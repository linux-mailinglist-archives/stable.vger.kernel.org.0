Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD16469C3E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347915AbhLFPVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357749AbhLFPTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7E0C0613F8;
        Mon,  6 Dec 2021 07:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D33AA61321;
        Mon,  6 Dec 2021 15:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE0CC341C1;
        Mon,  6 Dec 2021 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803549;
        bh=DXZXi5pGGJCNQo84oG0qZuU9EWWI9IRkfnZZwCZfggY=;
        h=From:To:Cc:Subject:Date:From;
        b=rW3XW8xoCWo1DdDEcXu1CiwJ1qTMJc348n+QBhn4855LWA54a3Iknj5KMOBnYJuSm
         eOwiNnd+iic2rNf3gXhG7C1U2GRFymLhSwPD0AlPq3VIKpWn1UXvZsxewPkAVFY2lU
         CtKxb2bggGlqyuSC1i7nVARiYetCC7HkY1coUv/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/70] 5.4.164-rc1 review
Date:   Mon,  6 Dec 2021 15:56:04 +0100
Message-Id: <20211206145551.909846023@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.164-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.164-rc1
X-KernelTest-Deadline: 2021-12-08T14:55+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.164 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.164-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.164-rc1

Wei Yongjun <weiyongjun1@huawei.com>
    ipmi: msghandler: Make symbol 'remove_work_wq' static

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    net/tls: Fix authentication failure in CCM mode

Helge Deller <deller@gmx.de>
    parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: retry init flow if failed

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_pci: rewrite pericom_do_set_divisor()

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array

Johan Hovold <johan@kernel.org>
    serial: core: fix transmit-buffer reset and memleak

Pierre Gondois <Pierre.Gondois@arm.com>
    serial: pl011: Add ACPI SBSA UART match id

Sven Eckelmann <sven@narfation.org>
    tty: serial: msm_serial: Deactivate RX DMA for polling support

Joerg Roedel <jroedel@suse.de>
    x86/64/mm: Map all kernel memory into trampoline_pgd

Feng Tang <feng.tang@intel.com>
    x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

Feng Tang <feng.tang@intel.com>
    x86/tsc: Add a timer to make sure TSC_adjust is always checked

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Ole Ernst <olebowle@gmx.com>
    USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Propagate console boot parameters before calling `vc_resize'

Helge Deller <deller@gmx.de>
    parisc: Fix "make install" on newer debian releases

Helge Deller <deller@gmx.de>
    parisc: Fix KBUILD_IMAGE for self-extracting kernel

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix rq->uclamp_max not set on first enqueue

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

msizanoen1 <msizanoen@qtmlabs.xyz>
    ipv6: fix memory leak in fib6_rule_suppress

Rob Clark <robdclark@chromium.org>
    drm/msm: Do hw_init() before capturing GPU state

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Keep smc_close_final rc during active close

William Kucharski <william.kucharski@oracle.com>
    net/rds: correct socket tunable error in rds_tcp_tune()

Eric Dumazet <edumazet@google.com>
    ipv4: convert fib_num_tclassid_users to atomic_t

Eric Dumazet <edumazet@google.com>
    net: annotate data-races on txq->xmit_lock_owner

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: marvell: mvpp2: Fix the computation of shared CPUs

Sven Schuchmann <schuchmann@schleissheimer.de>
    net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests: net: Correct case name

Zhou Qingyang <zhou1615@umn.edu>
    net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

Arnd Bergmann <arnd@arndb.de>
    siphash: use _unaligned version by default

Benjamin Poirier <bpoirier@nvidia.com>
    net: mpls: Fix notifications when deleting a device

Zhou Qingyang <zhou1615@umn.edu>
    net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()

Randy Dunlap <rdunlap@infradead.org>
    natsemi: xtensa: fix section mismatch warnings

Aaro Koskinen <aaro.koskinen@iki.fi>
    i2c: cbus-gpio: set atomic transfer callback

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: stop dma transfer in case of NACK

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: recover the bus on access timeout

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: flush TX FIFO upon transfer errors

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl

Linus Torvalds <torvalds@linux-foundation.org>
    fget: check that the fd still exists after getting a ref to it

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: move pseudo-MMIO to prevent MIO overlap

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    cpufreq: Fix get_cpu_device() failure in add_cpu_dev_symlink()

Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
    ipmi: Move remove_work to dedicated workqueue

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: do not mark device gone on EPROTO errors during start

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Limit max data_size of the kretprobe instances

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Avoid warning of possible recursive locking

Ian Rogers <irogers@google.com>
    perf report: Fix memory leaks around perf_tip()

Ian Rogers <irogers@google.com>
    perf hist: Fix memory leak of a perf_hpp_fmt

Teng Qi <starmiku1207184332@gmail.com>
    net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

zhangyue <zhangyue1@kylinos.cn>
    net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Teng Qi <starmiku1207184332@gmail.com>
    ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()

Mario Limonciello <mario.limonciello@amd.com>
    ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Unblock session then wake up error handler

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal: core: Reset previous low and high trip during thermal zone init

Wang Yugui <wangyugui@e16-tech.com>
    btrfs: check-integrity: fix a warning on write caching disabled disk

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: avoid using memblock_enforce_memory_limit

Slark Xiao <slark_xiao@163.com>
    platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

liuguoqiang <liuguoqiang@uniontech.com>
    net: return correct error code

Zekun Shen <bruceshenzk@gmail.com>
    atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Transfer remaining wait queue entries during fallback

Xing Song <xing.song@mediatek.com>
    mac80211: do not access the IV when it was stripped

Julian Braha <julianbraha@gmail.com>
    drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix length of holes reported at end-of-file

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

Russell King <rmk+kernel@armlinux.org.uk>
    arm64: dts: mcbin: support 2W SFP modules

Geert Uytterhoeven <geert+renesas@glider.be>
    of: clk: Make <linux/of_clk.h> self-contained

Benjamin Coddington <bcodding@redhat.com>
    NFSv42: Fix pagecache invalidation after COPY/CLONE


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi |  3 +
 arch/parisc/Makefile                               |  5 ++
 arch/parisc/install.sh                             |  1 +
 arch/parisc/kernel/time.c                          | 24 ++------
 arch/s390/include/asm/pci_io.h                     |  7 ++-
 arch/s390/kernel/setup.c                           |  3 -
 arch/x86/kernel/tsc.c                              | 28 +++++++--
 arch/x86/kernel/tsc_sync.c                         | 41 +++++++++++++
 arch/x86/kvm/pmu_amd.c                             |  2 +-
 arch/x86/realmode/init.c                           | 12 +++-
 drivers/ata/ahci.c                                 |  1 +
 drivers/ata/sata_fsl.c                             | 20 ++++---
 drivers/char/ipmi/ipmi_msghandler.c                | 13 ++++-
 drivers/cpufreq/cpufreq.c                          |  9 ++-
 drivers/gpu/drm/msm/msm_debugfs.c                  |  1 +
 drivers/gpu/drm/sun4i/Kconfig                      |  1 +
 drivers/i2c/busses/i2c-cbus-gpio.c                 |  5 +-
 drivers/i2c/busses/i2c-stm32f7.c                   | 31 +++++++++-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        | 10 ++++
 drivers/net/ethernet/dec/tulip/de4x5.c             | 34 ++++++-----
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |  4 ++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  9 ++-
 drivers/net/ethernet/natsemi/xtsonic.c             |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    | 10 +++-
 drivers/net/usb/lan78xx.c                          |  2 +-
 drivers/net/vrf.c                                  |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 22 ++++---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 24 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  3 +
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |  3 +
 drivers/platform/x86/thinkpad_acpi.c               | 12 ----
 drivers/scsi/scsi_transport_iscsi.c                |  6 +-
 drivers/thermal/thermal_core.c                     |  2 +
 drivers/tty/serial/8250/8250_pci.c                 | 39 ++++++++-----
 drivers/tty/serial/amba-pl011.c                    |  1 +
 drivers/tty/serial/msm_serial.c                    |  3 +
 drivers/tty/serial/serial_core.c                   | 13 ++++-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/host/xhci-ring.c                       | 21 ++++---
 drivers/usb/typec/tcpm/tcpm.c                      |  4 --
 drivers/video/console/vgacon.c                     | 14 +++--
 fs/btrfs/disk-io.c                                 | 14 ++++-
 fs/file.c                                          |  4 ++
 fs/gfs2/bmap.c                                     |  2 +-
 fs/nfs/nfs42proc.c                                 |  5 +-
 include/linux/kprobes.h                            |  2 +
 include/linux/netdevice.h                          | 19 ++++--
 include/linux/of_clk.h                             |  3 +
 include/linux/siphash.h                            | 14 ++---
 include/net/fib_rules.h                            |  2 +-
 include/net/ip_fib.h                               |  2 +-
 include/net/netns/ipv4.h                           |  2 +-
 kernel/kprobes.c                                   |  3 +
 kernel/sched/core.c                                |  2 +-
 lib/siphash.c                                      | 12 ++--
 net/can/j1939/transport.c                          |  6 ++
 net/core/dev.c                                     |  5 +-
 net/core/fib_rules.c                               |  2 +-
 net/ipv4/devinet.c                                 |  2 +-
 net/ipv4/fib_frontend.c                            |  2 +-
 net/ipv4/fib_rules.c                               |  6 +-
 net/ipv4/fib_semantics.c                           |  4 +-
 net/ipv6/fib6_rules.c                              |  5 +-
 net/mac80211/rx.c                                  |  3 +-
 net/mpls/af_mpls.c                                 | 68 +++++++++++++++++-----
 net/rds/tcp.c                                      |  2 +-
 net/rxrpc/peer_object.c                            | 14 +++--
 net/smc/af_smc.c                                   | 14 +++++
 net/smc/smc_close.c                                |  8 ++-
 net/tls/tls_sw.c                                   |  4 +-
 tools/perf/builtin-report.c                        | 15 +++--
 tools/perf/ui/hist.c                               | 28 ++++-----
 tools/perf/util/hist.h                             |  1 -
 tools/perf/util/util.c                             | 14 ++---
 tools/perf/util/util.h                             |  2 +-
 tools/testing/selftests/net/fcnal-test.sh          |  4 +-
 80 files changed, 532 insertions(+), 225 deletions(-)


