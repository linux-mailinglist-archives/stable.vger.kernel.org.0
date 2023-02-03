Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C29689FDF
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 18:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbjBCRFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 12:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjBCRFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 12:05:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10119D06F;
        Fri,  3 Feb 2023 09:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29894B82B64;
        Fri,  3 Feb 2023 17:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D238C433D2;
        Fri,  3 Feb 2023 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675443896;
        bh=/H/OL9wlQinpF2jjnnOMOGLbNzzXn/TvM4w1w4/8YBc=;
        h=From:To:Cc:Subject:Date:From;
        b=nsIGuHx4xQzdaAV/CMNyYfwA+qwaBkBSoEj/xz/zNX7MylsBloLPc61SGnOFPaK6/
         75xOX4a4wXd0t0ro9dnxJHg0x9szjnhY1hLKLloKH5b3MVmuYoFpMUxYfRhTkCaIEc
         2eb67kMkJrmV9RwUNPtUeO9Mt/ky/T6ygYO0Nwm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.19 00/79] 4.19.272-rc2 review
Date:   Fri,  3 Feb 2023 18:04:53 +0100
Message-Id: <20230203170324.096985239@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.272-rc2
X-KernelTest-Deadline: 2023-02-05T17:03+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.272 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Feb 2023 17:03:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.272-rc2

Peter Chen <peter.chen@nxp.com>
    usb: host: xhci-plat: add wakeup entry at sysfs

Eric Dumazet <edumazet@google.com>
    ipv6: ensure sane device mtu in tunnels

Kees Cook <keescook@chromium.org>
    exit: Use READ_ONCE() for all oops/warn limit reads

Kees Cook <keescook@chromium.org>
    docs: Fix path paste-o for /sys/kernel/warn_count

Kees Cook <keescook@chromium.org>
    panic: Expose "warn_count" to sysfs

Kees Cook <keescook@chromium.org>
    panic: Introduce warn_limit

Kees Cook <keescook@chromium.org>
    panic: Consolidate open-coded panic_on_warn checks

Kees Cook <keescook@chromium.org>
    exit: Allow oops_limit to be disabled

Kees Cook <keescook@chromium.org>
    exit: Expose "oops_count" to sysfs

Jann Horn <jannh@google.com>
    exit: Put an upper limit on how often we can oops

Randy Dunlap <rdunlap@infradead.org>
    ia64: make IA64_MCA_RECOVERY bool instead of tristate

Nathan Chancellor <nathan@kernel.org>
    h8300: Fix build errors from do_exit() to make_task_dead() transition

Nathan Chancellor <nathan@kernel.org>
    hexagon: Fix function name in die()

Eric W. Biederman <ebiederm@xmission.com>
    objtool: Add a missing comma to avoid string concatenation

Eric W. Biederman <ebiederm@xmission.com>
    exit: Add and use make_task_dead.

Tiezhu Yang <yangtiezhu@loongson.cn>
    panic: unset panic_on_warn inside panic()

Xiaoming Ni <nixiaoming@huawei.com>
    sysctl: add a new register_sysctl_init() interface

Hui Wang <hui.wang@canonical.com>
    dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: imx: Fix pca9547 i2c-mux node name

Jan Beulich <jbeulich@suse.com>
    x86/entry/64: Add instruction suffix to SYSRET

Mikulas Patocka <mpatocka@redhat.com>
    x86/asm: Fix an assembler warning with current binutils

Linus Torvalds <torvalds@linux-foundation.org>
    drm/i915/display: fix compiler warning about array overrun

Thomas Gleixner <tglx@linutronix.de>
    x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

David Christensen <drc@linux.vnet.ibm.com>
    net/tg3: resolve deadlock in tg3_reset_task() during EEH

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: ravb: Fix possible hang if RIS2_QFF1 happen

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fail if no bound addresses can be used for a given scope

Kuniyuki Iwashima <kuniyu@amazon.com>
    netrom: Fix use-after-free of a listening socket.

Sriram Yagnaraman <sriram.yagnaraman@est.tech>
    netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE

Eric Dumazet <edumazet@google.com>
    ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around sk_state

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around dst_portid and dst_group

Eric Dumazet <edumazet@google.com>
    netlink: annotate data races around nlk->portid

Li RongQing <lirongqing@baidu.com>
    netlink: remove hash::nelems check in netlink_insert

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

Paolo Abeni <pabeni@redhat.com>
    net: fix UaF in netns ops registration error path

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    EDAC/device: Respect any driver-supplied workqueue polling value

Giulio Benetti <giulio.benetti@benettiengineering.com>
    ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

David Howells <dhowells@redhat.com>
    cifs: Fix oops due to uncleared server->smbd_conn in reconnect

Long Li <longli@microsoft.com>
    smbd: Make upper layer decide when to destroy the transport

Natalia Petrova <n.petrova@fintech.ru>
    trace_events_hist: add check for return value of 'create_hist_field'

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Make sure trace_printk() can output as soon as it can be used

Petr Pavlu <petr.pavlu@suse.com>
    module: Don't wait for GOING modules

Alexey V. Vissarionov <gremlin@altlinux.org>
    scsi: hpsa: Fix allocation size for scsi_host_alloc()

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: reiserfs: remove useless new_opts in reiserfs_remount

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf env: Do not return pointers to local variables

Christoph Hellwig <hch@lst.de>
    block: fix and cleanup bio_check_ro

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

Yang Yingliang <yangyingliang@huawei.com>
    w1: fix WARNING after calling w1_process()

Yang Yingliang <yangyingliang@huawei.com>
    w1: fix deadloop in __w1_remove_master_device()

Jason Xing <kernelxing@tencent.com>
    tcp: avoid the lookup process failing to get sk in ehash table

Liu Shixin <liushixin2@huawei.com>
    dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Swati Agarwal <swati.agarwal@xilinx.com>
    dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: xilinx_dma: program hardware supported buffer length

Andrea Merello <andrea.merello@gmail.com>
    dmaengine: xilinx_dma: commonize DMA copy size calculation

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: betop: check shape of output reports

Robert Hancock <robert.hancock@calian.com>
    net: macb: fix PTP TX timestamp failure due to packet padding

Koba Ko <koba.ko@canonical.com>
    dmaengine: Fix double increment of client_count in dma_chan_get()

Randy Dunlap <rdunlap@infradead.org>
    net: mlx5: eliminate anonymous module_init & module_exit

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait

Pietro Borrello <borrello@diag.uniroma1.it>
    HID: check empty report_list in hid_validate_values()

Heiner Kallweit <hkallweit1@gmail.com>
    net: mdio: validate parameter addr in mdiobus_get_phy()

Szymon Heidrich <szymon.heidrich@gmail.com>
    net: usb: sr9700: Handle negative len

Szymon Heidrich <szymon.heidrich@gmail.com>
    wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    net: nfc: Fix use-after-free in local_cleanup()

Shang XiaoJing <shangxiaojing@huawei.com>
    phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Luis Gerhorst <gerhorst@cs.fau.de>
    bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: Delay AN timeout during KR training

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent

Alexander Potapenko <glider@google.com>
    affs: initialize fsdata in affs_truncate()

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Fix expected receive setup error exit issues

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Reserve user expected TIDs

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Reject a zero-length user expected buffer

Masahiro Yamada <masahiroy@kernel.org>
    tomoyo: fix broken dependency on *.conf.default

Miaoqian Lin <linmq006@gmail.com>
    EDAC/highbank: Fix memory leak in highbank_mc_probe()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-kernel-oops_count |   6 ++
 Documentation/ABI/testing/sysfs-kernel-warn_count |   6 ++
 Documentation/sysctl/kernel.txt                   |  20 ++++
 Makefile                                          |   4 +-
 arch/alpha/kernel/traps.c                         |   6 +-
 arch/alpha/mm/fault.c                             |   2 +-
 arch/arm/boot/dts/imx53-ppd.dts                   |   2 +-
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi             |   1 -
 arch/arm/kernel/traps.c                           |   2 +-
 arch/arm/mm/fault.c                               |   2 +-
 arch/arm/mm/nommu.c                               |   2 +-
 arch/arm64/kernel/traps.c                         |   2 +-
 arch/arm64/mm/fault.c                             |   2 +-
 arch/h8300/kernel/traps.c                         |   3 +-
 arch/h8300/mm/fault.c                             |   2 +-
 arch/hexagon/kernel/traps.c                       |   2 +-
 arch/ia64/Kconfig                                 |   2 +-
 arch/ia64/kernel/mca_drv.c                        |   2 +-
 arch/ia64/kernel/traps.c                          |   2 +-
 arch/ia64/mm/fault.c                              |   2 +-
 arch/m68k/kernel/traps.c                          |   2 +-
 arch/m68k/mm/fault.c                              |   2 +-
 arch/microblaze/kernel/exceptions.c               |   4 +-
 arch/mips/kernel/traps.c                          |   2 +-
 arch/nds32/kernel/traps.c                         |   8 +-
 arch/nios2/kernel/traps.c                         |   4 +-
 arch/openrisc/kernel/traps.c                      |   2 +-
 arch/parisc/kernel/traps.c                        |   2 +-
 arch/powerpc/kernel/traps.c                       |   2 +-
 arch/riscv/kernel/traps.c                         |   2 +-
 arch/riscv/mm/fault.c                             |   2 +-
 arch/s390/kernel/dumpstack.c                      |   2 +-
 arch/s390/kernel/nmi.c                            |   2 +-
 arch/sh/kernel/traps.c                            |   2 +-
 arch/sparc/kernel/traps_32.c                      |   4 +-
 arch/sparc/kernel/traps_64.c                      |   4 +-
 arch/x86/entry/entry_32.S                         |   6 +-
 arch/x86/entry/entry_64.S                         |   8 +-
 arch/x86/kernel/dumpstack.c                       |   4 +-
 arch/x86/kernel/i8259.c                           |   1 +
 arch/x86/kernel/irqinit.c                         |   4 +-
 arch/x86/lib/iomap_copy_64.S                      |   2 +-
 arch/xtensa/kernel/traps.c                        |   2 +-
 block/blk-core.c                                  |   5 +-
 drivers/dma/dmaengine.c                           |   7 +-
 drivers/dma/imx-sdma.c                            |   4 +-
 drivers/dma/xilinx/xilinx_dma.c                   |  78 +++++++++++----
 drivers/edac/edac_device.c                        |  15 ++-
 drivers/edac/highbank_mc_edac.c                   |   7 +-
 drivers/gpu/drm/i915/intel_dp.c                   |  13 ++-
 drivers/hid/hid-betopff.c                         |  17 ++--
 drivers/hid/hid-core.c                            |   4 +-
 drivers/hid/intel-ish-hid/ishtp/dma-if.c          |  10 ++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c         | 101 +++++++++++--------
 drivers/input/mouse/synaptics.c                   |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c          |  23 +++--
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c         |  24 +++++
 drivers/net/ethernet/amd/xgbe/xgbe.h              |   2 +
 drivers/net/ethernet/broadcom/tg3.c               |   8 +-
 drivers/net/ethernet/cadence/macb_main.c          |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   8 +-
 drivers/net/ethernet/renesas/ravb_main.c          |   4 +-
 drivers/net/phy/mdio_bus.c                        |   7 +-
 drivers/net/usb/sr9700.c                          |   2 +-
 drivers/net/wireless/rndis_wlan.c                 |  19 ++--
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c     |   4 +-
 drivers/scsi/hpsa.c                               |   2 +-
 drivers/usb/gadget/function/f_fs.c                |   7 ++
 drivers/usb/host/xhci-plat.c                      |   2 +-
 drivers/w1/w1.c                                   |   6 +-
 drivers/w1/w1_int.c                               |   5 +-
 fs/affs/file.c                                    |   2 +-
 fs/cifs/connect.c                                 |   9 +-
 fs/cifs/smbdirect.c                               | 115 ++++++++++++++++++----
 fs/cifs/smbdirect.h                               |   5 +-
 fs/proc/proc_sysctl.c                             |  33 +++++++
 fs/reiserfs/super.c                               |   6 --
 include/linux/kernel.h                            |   1 +
 include/linux/sched/task.h                        |   1 +
 include/linux/sysctl.h                            |   3 +
 kernel/bpf/verifier.c                             |   4 +-
 kernel/exit.c                                     |  72 ++++++++++++++
 kernel/module.c                                   |  26 ++++-
 kernel/panic.c                                    |  75 ++++++++++++--
 kernel/sched/core.c                               |   3 +-
 kernel/trace/trace.c                              |   2 +
 kernel/trace/trace.h                              |   1 +
 kernel/trace/trace_events_hist.c                  |   2 +
 kernel/trace/trace_output.c                       |   3 +-
 mm/kasan/report.c                                 |   3 +-
 net/bluetooth/hci_core.c                          |   1 +
 net/core/net_namespace.c                          |   2 +-
 net/ipv4/inet_hashtables.c                        |  17 +++-
 net/ipv4/inet_timewait_sock.c                     |   8 +-
 net/ipv4/metrics.c                                |   2 +
 net/ipv6/ip6_gre.c                                |  12 ++-
 net/ipv6/ip6_tunnel.c                             |  10 +-
 net/ipv6/sit.c                                    |   8 +-
 net/netfilter/nf_conntrack_proto_sctp.c           |  25 +++--
 net/netfilter/nf_conntrack_proto_tcp.c            |  10 ++
 net/netfilter/nft_set_rbtree.c                    |  16 ++-
 net/netlink/af_netlink.c                          |  41 ++++----
 net/netrom/nr_timer.c                             |   1 +
 net/nfc/llcp_core.c                               |   1 +
 net/sctp/bind_addr.c                              |   6 ++
 security/tomoyo/Makefile                          |   2 +-
 tools/objtool/check.c                             |   3 +-
 tools/perf/util/env.c                             |   4 +-
 108 files changed, 772 insertions(+), 302 deletions(-)


