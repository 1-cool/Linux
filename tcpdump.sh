#!/bin/bash
# 使用tcpdump抓包脚本,指定抓包会话持续时间或指定抓包文件大小

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PCAP_DIR="${SCRIPT_DIR}/pcap"

# 配置参数
INTERFACE="eth0"
TARGET_IP="192.168.0.50"
DURATION="600"  # 每个抓包会话持续时间（秒）
# file_size="20"  # 每个抓包文件大小（MB）
PID_FILE="${PCAP_DIR}/tcpdump_daemon.pid"
LOG_FILE="${PCAP_DIR}/tcpdump_daemon.log"
CURRENT_PID_FILE="${PCAP_DIR}/tcpdump_current.pid"

# 创建pcap目录
mkdir -p "$PCAP_DIR"

# 日志函数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# 检查是否已经有实例在运行
check_running() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "错误: 脚本已经在运行 (PID: $pid)"
            exit 1
        else
            rm -f "$PID_FILE"
        fi
    fi
}

# 启动抓包进程
start_capture() {
    output_file="${PCAP_DIR}/capture_%Y%m%d_%H%M%S.pcap"
    
    log "启动抓包进程 - 接口: $INTERFACE, 目标IP: $TARGET_IP"
    
    # 使用相对路径启动tcpdump，按时间周期分割，移除了-W参数不限制文件总数
    tcpdump -i "$INTERFACE" -w "$output_file" -G "$DURATION" host "$TARGET_IP" &
    # 按文件大小分割,文件名固定不能设置格式，暂时弃用
    # tcpdump -i "$INTERFACE" -w "$output_file" -C "$file_size" host "$TARGET_IP" -Z root &
    
    tcpdump_pid=$!
    echo "$tcpdump_pid" > "$CURRENT_PID_FILE"
    
    log "抓包进程已启动 (PID: $tcpdump_pid), 输出文件: $output_file"
    
    # 等待抓包进程结束
    wait "$tcpdump_pid"
    exit_code=$?
    
    # 压缩抓包文件
    if [ -f "$output_file" ]; then
        gzip "$output_file"
        log "抓包文件已压缩: ${output_file}.gz"
    fi
    
    # 清理PID文件
    rm -f "$CURRENT_PID_FILE"
    
    log "抓包会话结束, 退出码: $exit_code"
    return $exit_code
}

# 停止当前抓包进程
stop_capture() {
    if [ -f "$CURRENT_PID_FILE" ]; then
        pid=$(cat "$CURRENT_PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            log "停止当前抓包进程 (PID: $pid)"
            kill "$pid"
            sleep 2
            if kill -0 "$pid" 2>/dev/null; then
                log "强制停止抓包进程"
                kill -9 "$pid"
            fi
        fi
        rm -f "$CURRENT_PID_FILE"
    fi
}

# 停止守护进程
stop_daemon() {
    log "停止守护进程"
    stop_capture
    if [ -f "$PID_FILE" ]; then
        rm -f "$PID_FILE"
    fi
    exit 0
}

# 处理信号
trap stop_daemon SIGTERM SIGINT

# 主函数
main() {
    log "TCPDUMP守护进程启动"
    echo $$ > "$PID_FILE"
    
    # 主循环
    while true; do
        log "开始新的抓包周期"
        if ! start_capture; then
            log "抓包进程异常退出，等待10秒后重启"
            sleep 10
        fi
        
        # 检查是否需要退出
        if [ ! -f "$PID_FILE" ]; then
            log "检测到停止信号，退出主循环"
            break
        fi
        
        # 短暂的延迟
        sleep 5
    done
    
    log "TCPDUMP守护进程停止"
}

# 显示状态
show_status() {
    if [ -f "$PID_FILE" ]; then
        daemon_pid=$(cat "$PID_FILE")
        if kill -0 "$daemon_pid" 2>/dev/null; then
            echo "守护进程运行中 (PID: $daemon_pid)"
            echo "脚本目录: $SCRIPT_DIR"
            echo "抓包目录: $PCAP_DIR"
        else
            echo "守护进程PID文件存在但进程未运行"
            rm -f "$PID_FILE"
        fi
    else
        echo "守护进程未运行"
    fi
    
    if [ -f "$CURRENT_PID_FILE" ]; then
        capture_pid=$(cat "$CURRENT_PID_FILE")
        if kill -0 "$capture_pid" 2>/dev/null; then
            echo "抓包进程运行中 (PID: $capture_pid)"
        else
            echo "抓包进程PID文件存在但进程未运行"
            rm -f "$CURRENT_PID_FILE"
        fi
    else
        echo "当前没有活跃的抓包进程"
    fi
    
    # 显示抓包文件信息
    echo ""
    echo "抓包文件列表:"
    if ls "${PCAP_DIR}"/*.pcap* 1>/dev/null 2>&1; then
        ls -lt "${PCAP_DIR}"/*.pcap* | head -10
    else
        echo "暂无抓包文件"
    fi
}

# 清理旧文件
cleanup_old_files() {
    retention_days=${1:-7}
    log "清理${retention_days}天前的抓包文件"
    find "$PCAP_DIR" -name "*.pcap*" -mtime "+$retention_days" -delete
    log "清理完成"
}

# 命令行参数处理
case "$1" in
    start)
        check_running
        log "=== 启动TCPDUMP守护进程 ==="
        # 后台运行
        nohup "$0" daemon >> "$LOG_FILE" 2>&1 &
        echo "守护进程已启动"
        echo "脚本目录: $SCRIPT_DIR"
        echo "抓包目录: $PCAP_DIR"
        echo "日志文件: $LOG_FILE"
        ;;
    stop)
        if [ -f "$PID_FILE" ]; then
            pid=$(cat "$PID_FILE")
            kill "$pid" 2>/dev/null
            echo "已发送停止信号给守护进程 (PID: $pid)"
            # 等待进程结束
            sleep 2
            if kill -0 "$pid" 2>/dev/null; then
                echo "进程未正常结束，发送强制终止信号"
                kill -9 "$pid" 2>/dev/null
            fi
            rm -f "$PID_FILE"
        else
            echo "守护进程未运行"
        fi
        ;;
    restart)
        "$0" stop
        sleep 2
        "$0" start
        ;;
    status)
        show_status
        ;;
    daemon)
        main
        ;;
    cleanup)
        cleanup_old_files "$2"
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status|cleanup [days]}"
        echo ""
        echo "命令说明:"
        echo "  start          启动守护进程"
        echo "  stop           停止守护进程"
        echo "  restart        重启守护进程"
        echo "  status         查看运行状态"
        echo "  cleanup [days] 清理指定天数前的文件（默认7天）"
        echo ""
        echo "文件位置:"
        echo "  脚本目录: $SCRIPT_DIR"
        echo "  抓包目录: $PCAP_DIR"
        exit 1
        ;;
esac