Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FA946CEF5
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244848AbhLHIck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244925AbhLHIcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:32:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173E5C061D5E;
        Wed,  8 Dec 2021 00:28:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B47B1B81FF9;
        Wed,  8 Dec 2021 08:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9923C341C3;
        Wed,  8 Dec 2021 08:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638952116;
        bh=lRYZPJl5zToDKs85tltQvt4Gm//qVOeZGkjB4dp7U8k=;
        h=From:To:Cc:Subject:Date:From;
        b=jLBD2wbzqIFGyb7V1QvVgDzXu6aNUWAPbhoeMfevjEiJYqIXqCG0uPPrFAyNNeVKx
         IVezAswz0HE58+mmuTuNJLgvb8hRQIt+4rW5K58f3gFqyCZCM7V0uSbZLnJzASSDAl
         0qzI3ydU1eeyMUW7wLlTfp2P8kxSRXaAjywgQrDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.84
Date:   Wed,  8 Dec 2021 09:28:15 +0100
Message-Id: <163895209514690@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.84 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                          |    2 
 arch/arm64/include/asm/kvm_arm.h                                  |    4 
 arch/arm64/kernel/entry-ftrace.S                                  |    6 
 arch/parisc/Makefile                                              |    5 
 arch/parisc/install.sh                                            |    1 
 arch/parisc/kernel/time.c                                         |   24 
 arch/powerpc/platforms/pseries/iommu.c                            |    9 
 arch/s390/include/asm/pci_io.h                                    |    7 
 arch/s390/kernel/setup.c                                          |    3 
 arch/x86/entry/entry_64.S                                         |   45 -
 arch/x86/include/asm/irqflags.h                                   |   20 
 arch/x86/include/asm/paravirt.h                                   |   20 
 arch/x86/include/asm/paravirt_types.h                             |    2 
 arch/x86/kernel/asm-offsets_64.c                                  |    1 
 arch/x86/kernel/paravirt.c                                        |    1 
 arch/x86/kernel/paravirt_patch.c                                  |    3 
 arch/x86/kernel/sev-es.c                                          |   57 +
 arch/x86/kernel/tsc.c                                             |   28 
 arch/x86/kernel/tsc_sync.c                                        |   41 +
 arch/x86/kvm/mmu/mmu.c                                            |    2 
 arch/x86/kvm/svm/pmu.c                                            |    2 
 arch/x86/kvm/vmx/nested.c                                         |    4 
 arch/x86/kvm/vmx/posted_intr.c                                    |   20 
 arch/x86/kvm/vmx/vmx.c                                            |   23 
 arch/x86/realmode/init.c                                          |   12 
 arch/x86/xen/enlighten_pv.c                                       |    3 
 arch/x86/xen/xen-asm.S                                            |   20 
 drivers/ata/ahci.c                                                |    1 
 drivers/ata/sata_fsl.c                                            |   20 
 drivers/char/ipmi/ipmi_msghandler.c                               |   13 
 drivers/cpufreq/cpufreq.c                                         |    9 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                          |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c             |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c       |   20 
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c                       |    4 
 drivers/gpu/drm/msm/msm_debugfs.c                                 |    1 
 drivers/gpu/drm/sun4i/Kconfig                                     |    1 
 drivers/i2c/busses/i2c-cbus-gpio.c                                |    5 
 drivers/i2c/busses/i2c-stm32f7.c                                  |   31 -
 drivers/net/ethernet/aquantia/atlantic/aq_common.h                |   27 
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h                    |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                   |   10 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c              |    7 
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c                   |    3 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c      |   25 
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c |    3 
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c          |   22 
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h          |    2 
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.h    |   38 +
 drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c |  110 ++-
 drivers/net/ethernet/dec/tulip/de4x5.c                            |   34 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                  |    2 
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c                |    4 
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c                   |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                    |    9 
 drivers/net/ethernet/natsemi/xtsonic.c                            |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c               |   10 
 drivers/net/usb/lan78xx.c                                         |    2 
 drivers/net/vrf.c                                                 |    2 
 drivers/net/wireguard/allowedips.c                                |    2 
 drivers/net/wireguard/device.c                                    |   39 -
 drivers/net/wireguard/device.h                                    |    9 
 drivers/net/wireguard/queueing.c                                  |    6 
 drivers/net/wireguard/queueing.h                                  |    2 
 drivers/net/wireguard/ratelimiter.c                               |    4 
 drivers/net/wireguard/receive.c                                   |   39 -
 drivers/net/wireguard/socket.c                                    |    2 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                      |   22 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h                      |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                 |   24 
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                      |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                      |    3 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                   |    4 
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c                    |    3 
 drivers/platform/x86/thinkpad_acpi.c                              |   13 
 drivers/scsi/scsi_transport_iscsi.c                               |    6 
 drivers/thermal/thermal_core.c                                    |    2 
 drivers/tty/serial/8250/8250_pci.c                                |   39 -
 drivers/tty/serial/8250/8250_port.c                               |    7 
 drivers/tty/serial/amba-pl011.c                                   |    1 
 drivers/tty/serial/msm_serial.c                                   |    3 
 drivers/tty/serial/serial-tegra.c                                 |    4 
 drivers/tty/serial/serial_core.c                                  |   18 
 drivers/usb/core/quirks.c                                         |    3 
 drivers/usb/host/xhci-ring.c                                      |   21 
 drivers/usb/typec/tcpm/tcpm.c                                     |    4 
 drivers/video/console/vgacon.c                                    |   14 
 fs/btrfs/disk-io.c                                                |   14 
 fs/file.c                                                         |    4 
 fs/gfs2/bmap.c                                                    |    2 
 fs/gfs2/super.c                                                   |   14 
 fs/nfs/nfs42proc.c                                                |    5 
 fs/overlayfs/file.c                                               |   59 +
 include/linux/acpi.h                                              |    9 
 include/linux/kprobes.h                                           |    2 
 include/linux/netdevice.h                                         |   19 
 include/linux/siphash.h                                           |   14 
 include/net/dst_cache.h                                           |   11 
 include/net/fib_rules.h                                           |    4 
 include/net/ip_fib.h                                              |    2 
 include/net/netns/ipv4.h                                          |    2 
 include/net/sock.h                                                |   13 
 kernel/kprobes.c                                                  |    3 
 kernel/sched/core.c                                               |    2 
 kernel/trace/trace_events_hist.c                                  |    2 
 lib/siphash.c                                                     |   12 
 net/can/j1939/transport.c                                         |    6 
 net/core/dev.c                                                    |    5 
 net/core/dst_cache.c                                              |   19 
 net/core/fib_rules.c                                              |    2 
 net/ipv4/devinet.c                                                |    2 
 net/ipv4/fib_frontend.c                                           |    2 
 net/ipv4/fib_rules.c                                              |    5 
 net/ipv4/fib_semantics.c                                          |    4 
 net/ipv6/esp6.c                                                   |    6 
 net/ipv6/fib6_rules.c                                             |    4 
 net/mac80211/rx.c                                                 |    3 
 net/mpls/af_mpls.c                                                |   68 +-
 net/rds/tcp.c                                                     |    2 
 net/rxrpc/conn_client.c                                           |   14 
 net/rxrpc/peer_object.c                                           |   14 
 net/smc/af_smc.c                                                  |   14 
 net/smc/smc_close.c                                               |    8 
 net/smc/smc_core.c                                                |    7 
 net/tls/tls_sw.c                                                  |    4 
 sound/hda/intel-dsp-config.c                                      |   10 
 sound/soc/tegra/tegra186_dspk.c                                   |  181 ++++--
 sound/soc/tegra/tegra210_admaif.c                                 |  140 +++-
 sound/soc/tegra/tegra210_ahub.c                                   |   11 
 sound/soc/tegra/tegra210_dmic.c                                   |  184 +++++-
 sound/soc/tegra/tegra210_i2s.c                                    |  296 +++++++---
 tools/perf/builtin-report.c                                       |   15 
 tools/perf/ui/hist.c                                              |   28 
 tools/perf/util/arm-spe.c                                         |   15 
 tools/perf/util/hist.h                                            |    1 
 tools/perf/util/util.c                                            |   14 
 tools/perf/util/util.h                                            |    2 
 tools/testing/selftests/net/fcnal-test.sh                         |    4 
 tools/testing/selftests/wireguard/netns.sh                        |   30 -
 tools/testing/selftests/wireguard/qemu/debug.config               |    2 
 tools/testing/selftests/wireguard/qemu/kernel.config              |    1 
 virt/kvm/kvm_main.c                                               |    3 
 142 files changed, 1728 insertions(+), 683 deletions(-)

Aaro Koskinen (1):
      i2c: cbus-gpio: set atomic transfer callback

Alain Volmat (3):
      i2c: stm32f7: flush TX FIFO upon transfer errors
      i2c: stm32f7: recover the bus on access timeout
      i2c: stm32f7: stop dma transfer in case of NACK

Alexey Kardashevskiy (1):
      powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"

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

Bernard Zhao (1):
      drm/amd/amdgpu: fix potential memleak

Bob Peterson (1):
      gfs2: release iopen glock early in evict

Catalin Marinas (1):
      KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1

Christophe JAILLET (1):
      net: marvell: mvpp2: Fix the computation of shared CPUs

Dan Carpenter (1):
      KVM: VMX: Set failure code in prepare_vmcs02()

Dmitry Bogdanov (2):
      atlantic: Increase delay for fw transactions
      atlantic: Fix statistics logic for production hardware

Dongliang Mu (1):
      dpaa2-eth: destroy workqueue at the end of remove function

Douglas Anderson (1):
      drm/msm/a6xx: Allocate enough space for GMU registers

Dust Li (1):
      net/smc: fix wrong list_del in smc_lgr_cleanup_early

Eiichi Tsukata (2):
      rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
      rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eric Dumazet (2):
      net: annotate data-races on txq->xmit_lock_owner
      ipv4: convert fib_num_tclassid_users to atomic_t

Feng Tang (2):
      x86/tsc: Add a timer to make sure TSC_adjust is always checked
      x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

German Gomez (1):
      perf inject: Fix ARM SPE handling

Greg Kroah-Hartman (1):
      Linux 5.10.84

Gustavo A. R. Silva (1):
      wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()

Helge Deller (3):
      parisc: Fix KBUILD_IMAGE for self-extracting kernel
      parisc: Fix "make install" on newer debian releases
      parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Ian Rogers (2):
      perf hist: Fix memory leak of a perf_hpp_fmt
      perf report: Fix memory leaks around perf_tip()

Ioanna Alifieraki (1):
      ipmi: Move remove_work to dedicated workqueue

Jason A. Donenfeld (6):
      wireguard: selftests: increase default dmesg log size
      wireguard: allowedips: add missing __rcu annotation to satisfy sparse
      wireguard: selftests: actually test for routing loops
      wireguard: device: reset peer src endpoint when netns exits
      wireguard: receive: use ring buffer for incoming handshakes
      wireguard: receive: drop handshakes if queue lock is contended

Jay Dolan (2):
      serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array
      serial: 8250_pci: rewrite pericom_do_set_divisor()

Jimmy Wang (1):
      platform/x86: thinkpad_acpi: Add support for dual fan control

Joerg Roedel (1):
      x86/64/mm: Map all kernel memory into trampoline_pgd

Johan Hovold (1):
      serial: core: fix transmit-buffer reset and memleak

Jordy Zomer (1):
      ipv6: check return value of ipv6_skip_exthdr

Juergen Gross (1):
      x86/pv: Switch SWAPGS to ALTERNATIVE

Julian Braha (1):
      drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY

Lai Jiangshan (4):
      KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()
      x86/entry: Use the correct fence macro after swapgs in kernel CR3
      x86/xen: Add xenpv_restore_regs_and_return_to_usermode()
      x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()

Li Zhijian (2):
      wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST
      selftests: net: Correct case name

Like Xu (1):
      KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

Linus Torvalds (1):
      fget: check that the fd still exists after getting a ref to it

Lorenzo Bianconi (1):
      mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode

Lukas Wunner (1):
      serial: 8250: Fix RTS modem control while in rs485 mode

Maciej W. Rozycki (1):
      vgacon: Propagate console boot parameters before calling `vc_resize'

Manaf Meethalavalappu Pallikunhi (1):
      thermal: core: Reset previous low and high trip during thermal zone init

Mario Limonciello (2):
      ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile
      ACPI: Add stubs for wakeup handler functions

Mark Rutland (1):
      arm64: ftrace: add missing BTIs

Masami Hiramatsu (1):
      kprobes: Limit max data_size of the kretprobe instances

Mathias Nyman (1):
      xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Michael Sterritt (1):
      x86/sev: Fix SEV-ES INS/OUTS instructions for word, dword, and qword

Mike Christie (1):
      scsi: iscsi: Unblock session then wake up error handler

Miklos Szeredi (2):
      ovl: simplify file splice
      ovl: fix deadlock in splice write

Mordechay Goodstein (1):
      iwlwifi: mvm: retry init flow if failed

Nicholas Kazlauskas (1):
      drm/amd/display: Allow DSC on supported MST branch devices

Nikita Danilov (2):
      atlatnic: enable Nbase-t speeds with base-t
      atlantic: Add missing DIDs and fix 115c.

Niklas Schnelle (1):
      s390/pci: move pseudo-MMIO to prevent MIO overlap

Ole Ernst (1):
      USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Paolo Abeni (1):
      tcp: fix page frag corruption on page fault

Paolo Bonzini (1):
      KVM: x86: Use a stable condition around all VT-d PI paths

Patrik John (1):
      serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30

Pierre Gondois (1):
      serial: pl011: Add ACPI SBSA UART match id

Pierre-Louis Bossart (1):
      ALSA: intel-dsp-config: add quirk for CML devices based on ES8336 codec

Qais Yousef (1):
      sched/uclamp: Fix rq->uclamp_max not set on first enqueue

Randy Dunlap (1):
      natsemi: xtensa: fix section mismatch warnings

Rob Clark (1):
      drm/msm: Do hw_init() before capturing GPU state

Sameer Pujar (9):
      ASoC: tegra: Fix wrong value type in ADMAIF
      ASoC: tegra: Fix wrong value type in I2S
      ASoC: tegra: Fix wrong value type in DMIC
      ASoC: tegra: Fix wrong value type in DSPK
      ASoC: tegra: Fix kcontrol put callback in ADMAIF
      ASoC: tegra: Fix kcontrol put callback in I2S
      ASoC: tegra: Fix kcontrol put callback in DMIC
      ASoC: tegra: Fix kcontrol put callback in DSPK
      ASoC: tegra: Fix kcontrol put callback in AHUB

Sameer Saurabh (3):
      atlantic: Fix to display FW bundle version instead of FW mac version.
      Remove Half duplex mode speed capabilities.
      atlantic: Remove warn trace message.

Sean Christopherson (2):
      KVM: Disallow user memslot with size that exceeds "unsigned long"
      KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST

Slark Xiao (1):
      platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Stanislaw Gruszka (1):
      rt2x00: do not mark device gone on EPROTO errors during start

Stephen Suryaputra (1):
      vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Steven Rostedt (VMware) (1):
      tracing/histograms: String compares should not care about signed values

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

shaoyunl (1):
      drm/amd/amdkfd: Fix kernel panic when reset failed and been triggered again

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

