Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4346CEEB
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbhLHIcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244830AbhLHIcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:32:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB8EC061746;
        Wed,  8 Dec 2021 00:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E6E9B81FDE;
        Wed,  8 Dec 2021 08:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57265C341C3;
        Wed,  8 Dec 2021 08:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638952108;
        bh=BM18Cgn/YlFyKyIBQO0m2qeJ8Vk/xDvACV4DLirJWCg=;
        h=From:To:Cc:Subject:Date:From;
        b=I7RYuVWe3L1hR/4QM6TtXFiuT2fXsEwzamUHO1IiPSXJ1Fnn7TZ+uIEp++l8K5Hvq
         42bIMOpLAtCWL0UHnf/yZd2ZqEKIjpiYN8/WyeYhwtcSfxb4nrlqgdDMCkFm8hVxjm
         xXEjvmywIfBGbXZaO041VXCo7Y2exHCeXwVyhH+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.164
Date:   Wed,  8 Dec 2021 09:28:10 +0100
Message-Id: <163895209053105@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.164 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi           |    3 
 arch/parisc/Makefile                                         |    5 
 arch/parisc/install.sh                                       |    1 
 arch/parisc/kernel/time.c                                    |   24 ---
 arch/s390/include/asm/pci_io.h                               |    7 -
 arch/s390/kernel/setup.c                                     |    3 
 arch/x86/kernel/tsc.c                                        |   28 +++-
 arch/x86/kernel/tsc_sync.c                                   |   41 ++++++
 arch/x86/kvm/pmu_amd.c                                       |    2 
 arch/x86/realmode/init.c                                     |   12 +
 drivers/ata/ahci.c                                           |    1 
 drivers/ata/sata_fsl.c                                       |   20 ++-
 drivers/char/ipmi/ipmi_msghandler.c                          |   13 +-
 drivers/cpufreq/cpufreq.c                                    |    9 -
 drivers/gpu/drm/msm/msm_debugfs.c                            |    1 
 drivers/gpu/drm/sun4i/Kconfig                                |    1 
 drivers/i2c/busses/i2c-cbus-gpio.c                           |    5 
 drivers/i2c/busses/i2c-stm32f7.c                             |   31 ++++-
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c |   10 +
 drivers/net/ethernet/dec/tulip/de4x5.c                       |   34 +++--
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c           |    4 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c              |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c               |    9 +
 drivers/net/ethernet/natsemi/xtsonic.c                       |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c          |   10 +
 drivers/net/usb/lan78xx.c                                    |    2 
 drivers/net/vrf.c                                            |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                 |   22 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h                 |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c            |   24 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                 |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                 |    3 
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c               |    3 
 drivers/platform/x86/thinkpad_acpi.c                         |   12 -
 drivers/scsi/scsi_transport_iscsi.c                          |    6 
 drivers/thermal/thermal_core.c                               |    2 
 drivers/tty/serial/8250/8250_pci.c                           |   39 ++++--
 drivers/tty/serial/amba-pl011.c                              |    1 
 drivers/tty/serial/msm_serial.c                              |    3 
 drivers/tty/serial/serial_core.c                             |   13 +-
 drivers/usb/core/quirks.c                                    |    3 
 drivers/usb/host/xhci-ring.c                                 |   21 ++-
 drivers/usb/typec/tcpm/tcpm.c                                |    4 
 drivers/video/console/vgacon.c                               |   14 +-
 fs/btrfs/disk-io.c                                           |   14 ++
 fs/file.c                                                    |    4 
 fs/gfs2/bmap.c                                               |    2 
 fs/nfs/nfs42proc.c                                           |    5 
 include/linux/kprobes.h                                      |    2 
 include/linux/netdevice.h                                    |   19 ++-
 include/linux/of_clk.h                                       |    3 
 include/linux/siphash.h                                      |   14 --
 include/net/fib_rules.h                                      |    2 
 include/net/ip_fib.h                                         |    2 
 include/net/netns/ipv4.h                                     |    2 
 kernel/kprobes.c                                             |    3 
 kernel/sched/core.c                                          |    2 
 lib/siphash.c                                                |   12 -
 net/can/j1939/transport.c                                    |    6 
 net/core/dev.c                                               |    5 
 net/core/fib_rules.c                                         |    2 
 net/ipv4/devinet.c                                           |    2 
 net/ipv4/fib_frontend.c                                      |    2 
 net/ipv4/fib_rules.c                                         |    6 
 net/ipv4/fib_semantics.c                                     |    4 
 net/ipv6/fib6_rules.c                                        |    5 
 net/mac80211/rx.c                                            |    3 
 net/mpls/af_mpls.c                                           |   68 ++++++++---
 net/rds/tcp.c                                                |    2 
 net/rxrpc/peer_object.c                                      |   14 +-
 net/smc/af_smc.c                                             |   14 ++
 net/smc/smc_close.c                                          |    8 -
 net/tls/tls_sw.c                                             |    4 
 tools/perf/builtin-report.c                                  |   15 +-
 tools/perf/ui/hist.c                                         |   28 ++--
 tools/perf/util/hist.h                                       |    1 
 tools/perf/util/util.c                                       |   14 +-
 tools/perf/util/util.h                                       |    2 
 tools/testing/selftests/net/fcnal-test.sh                    |    4 
 80 files changed, 531 insertions(+), 224 deletions(-)

Aaro Koskinen (1):
      i2c: cbus-gpio: set atomic transfer callback

Alain Volmat (3):
      i2c: stm32f7: flush TX FIFO upon transfer errors
      i2c: stm32f7: recover the bus on access timeout
      i2c: stm32f7: stop dma transfer in case of NACK

Andreas Gruenbacher (1):
      gfs2: Fix length of holes reported at end-of-file

Arnd Bergmann (1):
      siphash: use _unaligned version by default

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Baokun Li (2):
      sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl
      sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Benjamin Coddington (1):
      NFSv42: Fix pagecache invalidation after COPY/CLONE

Benjamin Poirier (1):
      net: mpls: Fix notifications when deleting a device

Christophe JAILLET (1):
      net: marvell: mvpp2: Fix the computation of shared CPUs

Eiichi Tsukata (1):
      rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eric Dumazet (2):
      net: annotate data-races on txq->xmit_lock_owner
      ipv4: convert fib_num_tclassid_users to atomic_t

Feng Tang (2):
      x86/tsc: Add a timer to make sure TSC_adjust is always checked
      x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

Geert Uytterhoeven (1):
      of: clk: Make <linux/of_clk.h> self-contained

Greg Kroah-Hartman (1):
      Linux 5.4.164

Helge Deller (3):
      parisc: Fix KBUILD_IMAGE for self-extracting kernel
      parisc: Fix "make install" on newer debian releases
      parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Ian Rogers (2):
      perf hist: Fix memory leak of a perf_hpp_fmt
      perf report: Fix memory leaks around perf_tip()

Ioanna Alifieraki (1):
      ipmi: Move remove_work to dedicated workqueue

Jay Dolan (2):
      serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array
      serial: 8250_pci: rewrite pericom_do_set_divisor()

Joerg Roedel (1):
      x86/64/mm: Map all kernel memory into trampoline_pgd

Johan Hovold (1):
      serial: core: fix transmit-buffer reset and memleak

Julian Braha (1):
      drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY

Li Zhijian (1):
      selftests: net: Correct case name

Like Xu (1):
      KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

Linus Torvalds (1):
      fget: check that the fd still exists after getting a ref to it

Maciej W. Rozycki (1):
      vgacon: Propagate console boot parameters before calling `vc_resize'

Manaf Meethalavalappu Pallikunhi (1):
      thermal: core: Reset previous low and high trip during thermal zone init

Mario Limonciello (1):
      ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile

Masami Hiramatsu (1):
      kprobes: Limit max data_size of the kretprobe instances

Mathias Nyman (1):
      xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Mike Christie (1):
      scsi: iscsi: Unblock session then wake up error handler

Mordechay Goodstein (1):
      iwlwifi: mvm: retry init flow if failed

Niklas Schnelle (1):
      s390/pci: move pseudo-MMIO to prevent MIO overlap

Ole Ernst (1):
      USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Pierre Gondois (1):
      serial: pl011: Add ACPI SBSA UART match id

Qais Yousef (1):
      sched/uclamp: Fix rq->uclamp_max not set on first enqueue

Randy Dunlap (1):
      natsemi: xtensa: fix section mismatch warnings

Rob Clark (1):
      drm/msm: Do hw_init() before capturing GPU state

Russell King (1):
      arm64: dts: mcbin: support 2W SFP modules

Slark Xiao (1):
      platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Stanislaw Gruszka (1):
      rt2x00: do not mark device gone on EPROTO errors during start

Stephen Suryaputra (1):
      vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Sven Eckelmann (1):
      tty: serial: msm_serial: Deactivate RX DMA for polling support

Sven Schuchmann (1):
      net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Teng Qi (2):
      ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
      net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

Tianjia Zhang (1):
      net/tls: Fix authentication failure in CCM mode

Tony Lu (1):
      net/smc: Keep smc_close_final rc during active close

Vasily Gorbik (1):
      s390/setup: avoid using memblock_enforce_memory_limit

Wang Yugui (1):
      btrfs: check-integrity: fix a warning on write caching disabled disk

Wei Yongjun (1):
      ipmi: msghandler: Make symbol 'remove_work_wq' static

Wen Gu (2):
      net/smc: Transfer remaining wait queue entries during fallback
      net/smc: Avoid warning of possible recursive locking

William Kucharski (1):
      net/rds: correct socket tunable error in rds_tcp_tune()

Xing Song (1):
      mac80211: do not access the IV when it was stripped

Xiongfeng Wang (1):
      cpufreq: Fix get_cpu_device() failure in add_cpu_dev_symlink()

Zekun Shen (1):
      atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

Zhang Changzhong (1):
      can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

Zhou Qingyang (2):
      net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
      net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

liuguoqiang (1):
      net: return correct error code

msizanoen1 (1):
      ipv6: fix memory leak in fib6_rule_suppress

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

