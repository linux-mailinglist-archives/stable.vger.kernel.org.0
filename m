Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181FE46CEF4
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbhLHIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:32:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44756 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244823AbhLHIcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:32:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC147CE1C4D;
        Wed,  8 Dec 2021 08:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C93C341C6;
        Wed,  8 Dec 2021 08:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638952128;
        bh=SyVcqs065TdHq+R4rO+IHMMghGYSCJ36vzSJySvaFN8=;
        h=From:To:Cc:Subject:Date:From;
        b=XOwVvXdesgkFN56bZclomaCB/nphbLJmLMbTeaVWCpcQm2A8jGIHPJDXe8QBGi95q
         QEEnoLRbwwctPAEp1/d+2sMq61eqhXOrXg+OUFrigLTUPbkWwooNUx7ipu1mjINzRq
         zMhqe6f0ODZEAHRL6uvjrXk9qBX0v5uRMDwFg1fI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.7
Date:   Wed,  8 Dec 2021 09:28:22 +0100
Message-Id: <163895210231144@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.7 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
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
 arch/parisc/kernel/time.c                                         |   30 -
 arch/powerpc/platforms/pseries/iommu.c                            |   15 
 arch/s390/include/asm/pci_io.h                                    |    7 
 arch/s390/kernel/setup.c                                          |    3 
 arch/x86/entry/entry_64.S                                         |   35 -
 arch/x86/hyperv/hv_init.c                                         |    9 
 arch/x86/kernel/cpu/mshyperv.c                                    |   20 
 arch/x86/kernel/sev.c                                             |   57 +
 arch/x86/kernel/tsc.c                                             |   28 
 arch/x86/kernel/tsc_sync.c                                        |   41 +
 arch/x86/kvm/lapic.c                                              |    2 
 arch/x86/kvm/mmu/mmu.c                                            |   37 -
 arch/x86/kvm/mmu/tdp_mmu.c                                        |   36 -
 arch/x86/kvm/mmu/tdp_mmu.h                                        |    5 
 arch/x86/kvm/svm/avic.c                                           |   16 
 arch/x86/kvm/svm/pmu.c                                            |    2 
 arch/x86/kvm/svm/sev.c                                            |   31 -
 arch/x86/kvm/svm/svm.c                                            |    1 
 arch/x86/kvm/vmx/nested.c                                         |   49 -
 arch/x86/kvm/vmx/posted_intr.c                                    |   20 
 arch/x86/kvm/vmx/vmx.c                                            |   62 +-
 arch/x86/kvm/x86.c                                                |   46 +
 arch/x86/kvm/x86.h                                                |    7 
 arch/x86/realmode/init.c                                          |   12 
 arch/x86/xen/xen-asm.S                                            |   20 
 drivers/ata/ahci.c                                                |    1 
 drivers/ata/libahci.c                                             |   15 
 drivers/ata/sata_fsl.c                                            |   20 
 drivers/char/ipmi/ipmi_msghandler.c                               |   13 
 drivers/cpufreq/cpufreq.c                                         |    9 
 drivers/dma-buf/heaps/system_heap.c                               |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c                          |    1 
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c             |    5 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c       |   20 
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c                   |   13 
 drivers/gpu/drm/i915/display/intel_display_types.h                |    3 
 drivers/gpu/drm/i915/display/intel_dp.c                           |   11 
 drivers/gpu/drm/i915/display/intel_dp.h                           |    2 
 drivers/gpu/drm/i915/display/intel_dp_aux_backlight.c             |    5 
 drivers/gpu/drm/i915/gt/intel_workarounds.c                       |    7 
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c                       |    4 
 drivers/gpu/drm/msm/msm_debugfs.c                                 |    1 
 drivers/gpu/drm/msm/msm_drv.c                                     |   49 +
 drivers/gpu/drm/msm/msm_gem.c                                     |    3 
 drivers/gpu/drm/msm/msm_gem_submit.c                              |    1 
 drivers/gpu/drm/msm/msm_gpu.h                                     |    3 
 drivers/gpu/drm/msm/msm_gpu_devfreq.c                             |    5 
 drivers/gpu/drm/sun4i/Kconfig                                     |    1 
 drivers/gpu/drm/vc4/vc4_kms.c                                     |   40 -
 drivers/i2c/busses/i2c-cbus-gpio.c                                |    5 
 drivers/i2c/busses/i2c-stm32f7.c                                  |   31 -
 drivers/net/dsa/b53/b53_spi.c                                     |   14 
 drivers/net/dsa/mv88e6xxx/serdes.c                                |  252 +++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h                                |    4 
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
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c                   |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                    |    9 
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en.h                      |   14 
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c               |   21 
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h               |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c                  |   23 
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h                  |    7 
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.c               |   66 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rx_res.h               |   11 
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c                  |   16 
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h                  |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c        |   24 
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c              |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c           |    6 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                 |   46 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c                  |    9 
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c                 |    4 
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c        |    1 
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c             |    7 
 drivers/net/ethernet/natsemi/xtsonic.c                            |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c               |   10 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                 |   11 
 drivers/net/usb/lan78xx.c                                         |    2 
 drivers/net/usb/r8152.c                                           |    9 
 drivers/net/vrf.c                                                 |    2 
 drivers/net/wireguard/allowedips.c                                |    2 
 drivers/net/wireguard/device.c                                    |   39 -
 drivers/net/wireguard/device.h                                    |    9 
 drivers/net/wireguard/queueing.c                                  |    6 
 drivers/net/wireguard/queueing.h                                  |    2 
 drivers/net/wireguard/ratelimiter.c                               |    4 
 drivers/net/wireguard/receive.c                                   |   39 -
 drivers/net/wireguard/socket.c                                    |    2 
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c                      |    6 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                      |   22 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h                      |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                 |   24 
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                      |    3 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                      |    5 
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c                   |    4 
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c                    |    3 
 drivers/pinctrl/qcom/Kconfig                                      |    2 
 drivers/platform/x86/dell/Kconfig                                 |    2 
 drivers/platform/x86/thinkpad_acpi.c                              |   13 
 drivers/scsi/lpfc/lpfc_els.c                                      |    9 
 drivers/scsi/scsi_transport_iscsi.c                               |    6 
 drivers/scsi/ufs/ufshcd-pci.c                                     |   18 
 drivers/thermal/thermal_core.c                                    |    2 
 drivers/tty/serial/8250/8250_bcm7271.c                            |   13 
 drivers/tty/serial/8250/8250_pci.c                                |   39 -
 drivers/tty/serial/8250/8250_port.c                               |    7 
 drivers/tty/serial/amba-pl011.c                                   |    1 
 drivers/tty/serial/liteuart.c                                     |   20 
 drivers/tty/serial/msm_serial.c                                   |    3 
 drivers/tty/serial/serial-tegra.c                                 |    4 
 drivers/tty/serial/serial_core.c                                  |   18 
 drivers/usb/cdns3/cdns3-gadget.c                                  |   20 
 drivers/usb/cdns3/cdnsp-mem.c                                     |    3 
 drivers/usb/core/quirks.c                                         |    3 
 drivers/usb/host/xhci-ring.c                                      |   21 
 drivers/usb/typec/tcpm/tcpm.c                                     |    4 
 drivers/video/console/vgacon.c                                    |   14 
 fs/btrfs/disk-io.c                                                |   14 
 fs/btrfs/volumes.c                                                |   18 
 fs/file.c                                                         |    4 
 fs/gfs2/bmap.c                                                    |    2 
 fs/gfs2/super.c                                                   |   14 
 fs/io-wq.c                                                        |    7 
 include/linux/acpi.h                                              |    9 
 include/linux/kprobes.h                                           |    2 
 include/linux/mlx5/mlx5_ifc.h                                     |    8 
 include/linux/netdevice.h                                         |   19 
 include/linux/siphash.h                                           |   14 
 include/net/dst_cache.h                                           |   11 
 include/net/fib_rules.h                                           |    4 
 include/net/ip_fib.h                                              |    2 
 include/net/netns/ipv4.h                                          |    2 
 include/net/sock.h                                                |   13 
 kernel/kprobes.c                                                  |    3 
 kernel/sched/core.c                                               |    6 
 kernel/trace/trace.c                                              |   12 
 kernel/trace/trace_events_hist.c                                  |    2 
 lib/siphash.c                                                     |   12 
 net/core/dev.c                                                    |    5 
 net/core/dst_cache.c                                              |   19 
 net/core/fib_rules.c                                              |    2 
 net/ipv4/devinet.c                                                |    2 
 net/ipv4/fib_frontend.c                                           |    2 
 net/ipv4/fib_rules.c                                              |    5 
 net/ipv4/fib_semantics.c                                          |    4 
 net/ipv6/esp6.c                                                   |    6 
 net/ipv6/fib6_rules.c                                             |    4 
 net/mac80211/led.h                                                |    8 
 net/mac80211/rx.c                                                 |   10 
 net/mac80211/tx.c                                                 |   34 -
 net/mctp/route.c                                                  |    9 
 net/mpls/af_mpls.c                                                |   68 +-
 net/rds/tcp.c                                                     |    2 
 net/rxrpc/conn_client.c                                           |   14 
 net/rxrpc/peer_object.c                                           |   14 
 net/smc/af_smc.c                                                  |   14 
 net/smc/smc_close.c                                               |    8 
 net/smc/smc_core.c                                                |    7 
 net/tls/tls_sw.c                                                  |    4 
 sound/hda/intel-dsp-config.c                                      |   10 
 sound/pci/hda/hda_local.h                                         |    9 
 sound/pci/hda/patch_cs8409.c                                      |    5 
 sound/soc/codecs/rk817_codec.c                                    |    1 
 sound/soc/tegra/tegra186_dspk.c                                   |  181 ++++--
 sound/soc/tegra/tegra210_admaif.c                                 |  140 +++-
 sound/soc/tegra/tegra210_ahub.c                                   |   11 
 sound/soc/tegra/tegra210_dmic.c                                   |  184 +++++-
 sound/soc/tegra/tegra210_i2s.c                                    |  296 +++++++---
 sound/usb/card.h                                                  |   10 
 sound/usb/endpoint.c                                              |  223 +++++--
 sound/usb/endpoint.h                                              |   13 
 sound/usb/pcm.c                                                   |  165 ++++-
 tools/perf/builtin-report.c                                       |   15 
 tools/perf/ui/hist.c                                              |   28 
 tools/perf/util/arm-spe.c                                         |   15 
 tools/perf/util/hist.c                                            |   23 
 tools/perf/util/hist.h                                            |    1 
 tools/perf/util/sort.c                                            |   52 -
 tools/perf/util/sort.h                                            |    6 
 tools/perf/util/util.c                                            |   14 
 tools/perf/util/util.h                                            |    2 
 tools/testing/selftests/net/fcnal-test.sh                         |    4 
 tools/testing/selftests/wireguard/netns.sh                        |   30 -
 tools/testing/selftests/wireguard/qemu/debug.config               |    2 
 tools/testing/selftests/wireguard/qemu/kernel.config              |    1 
 virt/kvm/kvm_main.c                                               |   50 +
 207 files changed, 2853 insertions(+), 1214 deletions(-)

Aaro Koskinen (1):
      i2c: cbus-gpio: set atomic transfer callback

Aaron Ma (1):
      net: usb: r8152: Add MAC passthrough support for more Lenovo Docks

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Add support for Intel ADL

Al Cooper (1):
      serial: 8250_bcm7271: UART errors after resuming from S2

Alain Volmat (3):
      i2c: stm32f7: flush TX FIFO upon transfer errors
      i2c: stm32f7: recover the bus on access timeout
      i2c: stm32f7: stop dma transfer in case of NACK

Alexey Kardashevskiy (2):
      powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"
      powerpc/pseries/ddw: Do not try direct mapping with persistent memory and one window

Andreas Gruenbacher (1):
      gfs2: Fix length of holes reported at end-of-file

Andrew Halaney (1):
      preempt/dynamic: Fix setup_preempt_mode() return value

Arnd Bergmann (1):
      siphash: use _unaligned version by default

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Baokun Li (2):
      sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl
      sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Ben Ben-Ishay (1):
      net/mlx5e: Rename lro_timeout to packet_merge_timeout

Ben Gardon (1):
      KVM: x86/mmu: Fix TLB flush range when handling disconnected pt

Benjamin Poirier (1):
      net: mpls: Fix notifications when deleting a device

Bernard Zhao (1):
      drm/amd/amdgpu: fix potential memleak

Bob Peterson (1):
      gfs2: release iopen glock early in evict

Catalin Marinas (1):
      KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1

Christophe JAILLET (2):
      net: marvell: mvpp2: Fix the computation of shared CPUs
      iwlwifi: Fix memory leaks in error handling path

Dan Carpenter (1):
      KVM: VMX: Set failure code in prepare_vmcs02()

David Matlack (1):
      KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k

Dmitry Bogdanov (2):
      atlantic: Increase delay for fw transactions
      atlantic: Fix statistics logic for production hardware

Dmytro Linkin (2):
      net/mlx5: E-switch, Respect BW share of the new group
      net/mlx5: E-Switch, Check group pointer before reading bw_share value

Dongliang Mu (1):
      dpaa2-eth: destroy workqueue at the end of remove function

Douglas Anderson (2):
      drm/msm/a6xx: Allocate enough space for GMU registers
      drm/msm: Fix mmap to include VM_IO and VM_DONTDUMP

Dust Li (1):
      net/smc: fix wrong list_del in smc_lgr_cleanup_early

Eiichi Tsukata (2):
      rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
      rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eric Dumazet (2):
      net: annotate data-races on txq->xmit_lock_owner
      ipv4: convert fib_num_tclassid_users to atomic_t

Felix Fietkau (1):
      mac80211: fix throughput LED trigger

Feng Tang (2):
      x86/tsc: Add a timer to make sure TSC_adjust is always checked
      x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

Filipe Manana (1):
      btrfs: silence lockdep when reading chunk tree during mount

Florian Fainelli (1):
      net: dsa: b53: Add SPI ID table

Frank Li (1):
      usb: cdns3: gadget: fix new urb never complete if ep cancel previous requests

German Gomez (1):
      perf inject: Fix ARM SPE handling

Greg Kroah-Hartman (1):
      Linux 5.15.7

Guangming (1):
      dma-buf: system_heap: Use 'for_each_sgtable_sg' in pages free flow

Gustavo A. R. Silva (1):
      wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()

Helge Deller (3):
      parisc: Fix KBUILD_IMAGE for self-extracting kernel
      parisc: Fix "make install" on newer debian releases
      parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Hou Wenlong (2):
      KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()
      KVM: x86/mmu: Pass parameter flush as false in kvm_tdp_mmu_zap_collapsible_sptes()

Ian Rogers (2):
      perf hist: Fix memory leak of a perf_hpp_fmt
      perf report: Fix memory leaks around perf_tip()

Ilia Sergachev (1):
      serial: liteuart: Fix NULL pointer dereference in ->remove()

Ioanna Alifieraki (1):
      ipmi: Move remove_work to dedicated workqueue

James Smart (1):
      scsi: lpfc: Fix non-recovery of remote ports following an unsolicited LOGO

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

Jens Axboe (1):
      io-wq: don't retry task_work creation failure on fatal conditions

Jimmy Wang (1):
      platform/x86: thinkpad_acpi: Add support for dual fan control

Joerg Roedel (1):
      x86/64/mm: Map all kernel memory into trampoline_pgd

Johan Hovold (3):
      serial: core: fix transmit-buffer reset and memleak
      serial: liteuart: fix use-after-free and memleak on unbind
      serial: liteuart: fix minor-number leak on probe errors

Jordy Zomer (1):
      ipv6: check return value of ipv6_skip_exthdr

José Roberto de Souza (1):
      Revert "drm/i915: Implement Wa_1508744258"

Julian Braha (2):
      drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY
      pinctrl: qcom: fix unmet dependencies on GPIOLIB for GPIOLIB_IRQCHIP

Khalid Manaa (1):
      net/mlx5e: Rename TIR lro functions to TIR packet merge functions

Lai Jiangshan (5):
      KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()
      KVM: X86: Fix when shadow_root_level=5 && guest root_level<4
      x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()
      x86/entry: Use the correct fence macro after swapgs in kernel CR3
      x86/xen: Add xenpv_restore_regs_and_return_to_usermode()

Li Zhijian (2):
      wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST
      selftests: net: Correct case name

Lijo Lazar (1):
      drm/amd/pm: Remove artificial freq level on Navi1x

Like Xu (1):
      KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

Linus Torvalds (1):
      fget: check that the fd still exists after getting a ref to it

Lorenzo Bianconi (1):
      mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode

Lukas Wunner (1):
      serial: 8250: Fix RTS modem control while in rs485 mode

Lyude Paul (1):
      drm/i915/dp: Perform 30ms delay after source OUI write

Maciej W. Rozycki (1):
      vgacon: Propagate console boot parameters before calling `vc_resize'

Manaf Meethalavalappu Pallikunhi (1):
      thermal: core: Reset previous low and high trip during thermal zone init

Marek Behún (6):
      net: dsa: mv88e6xxx: Fix application of erratum 4.8 for 88E6393X
      net: dsa: mv88e6xxx: Drop unnecessary check in mv88e6393x_serdes_erratum_4_6()
      net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver
      net: dsa: mv88e6xxx: Add fix for erratum 5.2 of 88E6393X family
      net: dsa: mv88e6xxx: Fix inband AN for 2500base-x on 88E6393X family
      net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed

Mario Limonciello (3):
      ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile
      ata: libahci: Adjust behavior when StorageD3Enable _DSD is set
      ACPI: Add stubs for wakeup handler functions

Mark Bloch (1):
      net/mlx5: E-Switch, fix single FDB creation on BlueField

Mark Rutland (1):
      arm64: ftrace: add missing BTIs

Masami Hiramatsu (1):
      kprobes: Limit max data_size of the kretprobe instances

Mathias Nyman (1):
      xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Matt Johnston (1):
      mctp: Don't let RTM_DELROUTE delete local routes

Maxime Ripard (6):
      drm/vc4: kms: Wait for the commit before increasing our clock rate
      drm/vc4: kms: Fix return code check
      drm/vc4: kms: Add missing drm_crtc_commit_put
      drm/vc4: kms: Clear the HVS FIFO commit pointer once done
      drm/vc4: kms: Don't duplicate pending commit
      drm/vc4: kms: Fix previous HVS commit wait

Michael Sterritt (1):
      x86/sev: Fix SEV-ES INS/OUTS instructions for word, dword, and qword

Mike Christie (1):
      scsi: iscsi: Unblock session then wake up error handler

Mordechay Goodstein (1):
      iwlwifi: mvm: retry init flow if failed

Moshe Shemesh (1):
      net/mlx5: Move MODIFY_RQT command to ignore list in internal error state

Namhyung Kim (3):
      perf sort: Fix the 'weight' sort key behavior
      perf sort: Fix the 'ins_lat' sort key behavior
      perf sort: Fix the 'p_stage_cyc' sort key behavior

Nicholas Kazlauskas (1):
      drm/amd/display: Allow DSC on supported MST branch devices

Nicolas Frattaroli (1):
      ASoC: rk817: Add module alias for rk817-codec

Nikita Danilov (2):
      atlatnic: enable Nbase-t speeds with base-t
      atlantic: Add missing DIDs and fix 115c.

Nikita Yushchenko (1):
      tracing: Don't use out-of-sync va_list in event printing

Niklas Schnelle (1):
      s390/pci: move pseudo-MMIO to prevent MIO overlap

Ole Ernst (1):
      USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Paolo Abeni (1):
      tcp: fix page frag corruption on page fault

Paolo Bonzini (7):
      KVM: fix avic_set_running for preemptable kernels
      KVM: x86: ignore APICv if LAPIC is not enabled
      KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
      KVM: x86: Use a stable condition around all VT-d PI paths
      KVM: MMU: shadow nested paging does not have PKU
      KVM: x86: check PIR even for vCPUs with disabled APICv
      KVM: SEV: initialize regions_list of a mirror VM

Patrik John (1):
      serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30

Pierre Gondois (1):
      serial: pl011: Add ACPI SBSA UART match id

Pierre-Louis Bossart (1):
      ALSA: intel-dsp-config: add quirk for CML devices based on ES8336 codec

Qais Yousef (1):
      sched/uclamp: Fix rq->uclamp_max not set on first enqueue

Raed Salem (2):
      net/mlx5e: IPsec: Fix Software parser inner l3 type setting in case of encapsulation
      net/mlx5e: Fix missing IPsec statistics on uplink representor

Randy Dunlap (1):
      natsemi: xtensa: fix section mismatch warnings

Rob Clark (4):
      drm/msm: Do hw_init() before capturing GPU state
      drm/msm/devfreq: Fix OPP refcnt leak
      drm/msm: Fix wait_fence submitqueue leak
      drm/msm: Restore error return on invalid fence

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

Sean Christopherson (8):
      x86/hyperv: Move required MSRs check to initial platform probing
      KVM: Disallow user memslot with size that exceeds "unsigned long"
      KVM: Ensure local memslot copies operate on up-to-date arch-specific data
      KVM: nVMX: Emulate guest TLB flush on nested VM-Enter with new vpid12
      KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST
      KVM: nVMX: Abide to KVM_REQ_TLB_FLUSH_GUEST request on nested vmentry/vmexit
      KVM: SEV: Return appropriate error codes if SEV-ES scratch setup fails
      KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap collapsible path

Slark Xiao (1):
      platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Stanislaw Gruszka (1):
      rt2x00: do not mark device gone on EPROTO errors during start

Stefan Binding (1):
      ALSA: hda/cs8409: Set PMSG_ON earlier inside cs8409 driver

Stephen Suryaputra (1):
      vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Steven Rostedt (VMware) (1):
      tracing/histograms: String compares should not care about signed values

Sven Eckelmann (1):
      tty: serial: msm_serial: Deactivate RX DMA for polling support

Sven Schuchmann (1):
      net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Takashi Iwai (12):
      ALSA: usb-audio: Restrict rates for the shared clocks
      ALSA: usb-audio: Rename early_playback_start flag with lowlatency_playback
      ALSA: usb-audio: Disable low-latency playback for free-wheel mode
      ALSA: usb-audio: Disable low-latency mode for implicit feedback sync
      ALSA: usb-audio: Check available frames for the next packet size
      ALSA: usb-audio: Add spinlock to stop_urbs()
      ALSA: usb-audio: Improved lowlatency playback support
      ALSA: usb-audio: Avoid killing in-flight URBs during draining
      ALSA: usb-audio: Fix packet size calculation regression
      ALSA: usb-audio: Less restriction for low-latency playback mode
      ALSA: usb-audio: Switch back to non-latency mode at a later point
      ALSA: usb-audio: Don't start stream for capture at prepare

Tariq Toukan (1):
      net/mlx5e: Sync TIR params updates against concurrent create/modify

Teng Qi (2):
      ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
      net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

Thomas Weißschuh (1):
      platform/x86: dell-wmi-descriptor: disable by default

Tianjia Zhang (1):
      net/tls: Fix authentication failure in CCM mode

Tony Lu (1):
      net/smc: Keep smc_close_final rc during active close

Vasily Gorbik (1):
      s390/setup: avoid using memblock_enforce_memory_limit

Vincent Whitchurch (1):
      net: stmmac: Avoid DMA_CHAN_CONTROL write if no Split Header support

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

Zhou Qingyang (4):
      net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
      net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()
      octeontx2-af: Fix a memleak bug in rvu_mbox_init()
      usb: cdnsp: Fix a NULL pointer dereference in cdnsp_endpoint_init()

liuguoqiang (1):
      net: return correct error code

msizanoen1 (1):
      ipv6: fix memory leak in fib6_rule_suppress

shaoyunl (1):
      drm/amd/amdkfd: Fix kernel panic when reset failed and been triggered again

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Łukasz Bartosik (1):
      iwlwifi: fix warnings produced by kernel debug options

