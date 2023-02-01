Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08A36860D7
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjBAHnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjBAHnv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:43:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A635355F;
        Tue, 31 Jan 2023 23:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8F2761630;
        Wed,  1 Feb 2023 07:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98105C433D2;
        Wed,  1 Feb 2023 07:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675237426;
        bh=OzS3sobgOnK+vJmyhAqWh/NzgYdZpfgfp102WnFfmsk=;
        h=From:To:Cc:Subject:Date:From;
        b=najNaWwzY/IS8BX7Tw1OP9NY95XDw7Vs8hmgrZ1slwEbJ/3g3yS/YJEEqF1PUi3AX
         sWi9fNB7DAMS6gJPllkzpjIFtvyWiUQIzVlicQ5Je7ukZbiEk8119Ziuv+4BtrPSCN
         l66vUMTJKPGQMNmUlMO7d2aa16F4iECVDer/2Zys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.91
Date:   Wed,  1 Feb 2023 08:43:34 +0100
Message-Id: <167523741424550@kroah.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.91 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-kernel-oops_count            |    6 
 Documentation/ABI/testing/sysfs-kernel-warn_count            |    6 
 Documentation/admin-guide/sysctl/kernel.rst                  |   19 
 Makefile                                                     |    5 
 arch/alpha/kernel/traps.c                                    |    6 
 arch/alpha/mm/fault.c                                        |    2 
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi                        |    1 
 arch/arm/boot/dts/imx6ul-pico-dwarf.dts                      |    2 
 arch/arm/boot/dts/imx7d-pico-dwarf.dts                       |    4 
 arch/arm/boot/dts/imx7d-pico-nymph.dts                       |    4 
 arch/arm/boot/dts/sam9x60.dtsi                               |    2 
 arch/arm/kernel/traps.c                                      |    2 
 arch/arm/mach-imx/cpu-imx25.c                                |    1 
 arch/arm/mach-imx/cpu-imx27.c                                |    1 
 arch/arm/mach-imx/cpu-imx31.c                                |    1 
 arch/arm/mach-imx/cpu-imx35.c                                |    1 
 arch/arm/mach-imx/cpu-imx5.c                                 |    1 
 arch/arm/mm/fault.c                                          |    2 
 arch/arm/mm/nommu.c                                          |    2 
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi   |    4 
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts       |    1 
 arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi        |   10 
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts            |   90 ++
 arch/arm64/boot/dts/qcom/msm8992.dtsi                        |    4 
 arch/arm64/kernel/traps.c                                    |    2 
 arch/arm64/kvm/vgic/vgic-v3.c                                |   25 
 arch/arm64/kvm/vgic/vgic-v4.c                                |    8 
 arch/arm64/kvm/vgic/vgic.h                                   |    1 
 arch/arm64/mm/fault.c                                        |    2 
 arch/csky/abiv1/alignment.c                                  |    2 
 arch/csky/kernel/traps.c                                     |    2 
 arch/csky/mm/fault.c                                         |    2 
 arch/h8300/kernel/traps.c                                    |    3 
 arch/h8300/mm/fault.c                                        |    2 
 arch/hexagon/kernel/traps.c                                  |    2 
 arch/ia64/Kconfig                                            |    2 
 arch/ia64/kernel/mca_drv.c                                   |    2 
 arch/ia64/kernel/traps.c                                     |    2 
 arch/ia64/mm/fault.c                                         |    2 
 arch/m68k/kernel/traps.c                                     |    2 
 arch/m68k/mm/fault.c                                         |    2 
 arch/microblaze/kernel/exceptions.c                          |    4 
 arch/mips/kernel/traps.c                                     |    2 
 arch/nds32/kernel/fpu.c                                      |    2 
 arch/nds32/kernel/traps.c                                    |    8 
 arch/nios2/kernel/traps.c                                    |    4 
 arch/openrisc/kernel/traps.c                                 |    2 
 arch/parisc/kernel/traps.c                                   |    2 
 arch/powerpc/kernel/traps.c                                  |    8 
 arch/riscv/kernel/probes/simulate-insn.c                     |    4 
 arch/riscv/kernel/traps.c                                    |    2 
 arch/riscv/mm/fault.c                                        |    2 
 arch/s390/include/asm/debug.h                                |    6 
 arch/s390/kernel/dumpstack.c                                 |    2 
 arch/s390/kernel/nmi.c                                       |    2 
 arch/s390/kernel/vmlinux.lds.S                               |    2 
 arch/s390/kvm/interrupt.c                                    |   12 
 arch/sh/kernel/traps.c                                       |    2 
 arch/sparc/kernel/traps_32.c                                 |    4 
 arch/sparc/kernel/traps_64.c                                 |    4 
 arch/x86/entry/entry_32.S                                    |    6 
 arch/x86/entry/entry_64.S                                    |    6 
 arch/x86/events/amd/core.c                                   |    2 
 arch/x86/events/intel/uncore.c                               |    1 
 arch/x86/events/msr.c                                        |    1 
 arch/x86/kernel/acpi/cstate.c                                |   15 
 arch/x86/kernel/dumpstack.c                                  |    4 
 arch/x86/kernel/i8259.c                                      |    1 
 arch/x86/kernel/irqinit.c                                    |    4 
 arch/x86/kvm/svm/svm.c                                       |   34 -
 arch/x86/kvm/svm/svm.h                                       |    1 
 arch/x86/kvm/vmx/vmx.c                                       |   21 
 arch/xtensa/kernel/traps.c                                   |    2 
 block/blk-core.c                                             |    8 
 drivers/base/property.c                                      |   18 
 drivers/base/test/test_async_driver_probe.c                  |    2 
 drivers/cpufreq/armada-37xx-cpufreq.c                        |    2 
 drivers/cpufreq/cpufreq-dt-platdev.c                         |    2 
 drivers/cpufreq/cpufreq_governor.c                           |   20 
 drivers/cpufreq/cpufreq_governor.h                           |    1 
 drivers/cpufreq/cpufreq_governor_attr_set.c                  |    5 
 drivers/dma/dmaengine.c                                      |    7 
 drivers/dma/ptdma/ptdma-dev.c                                |    7 
 drivers/dma/ptdma/ptdma.h                                    |    2 
 drivers/dma/ti/k3-udma.c                                     |    5 
 drivers/dma/xilinx/xilinx_dma.c                              |    4 
 drivers/edac/edac_device.c                                   |   15 
 drivers/edac/highbank_mc_edac.c                              |    7 
 drivers/edac/qcom_edac.c                                     |    5 
 drivers/firmware/arm_scmi/shmem.c                            |    9 
 drivers/firmware/google/coreboot_table.c                     |    9 
 drivers/firmware/google/coreboot_table.h                     |    1 
 drivers/gpio/gpio-amdpt.c                                    |   10 
 drivers/gpio/gpio-brcmstb.c                                  |   12 
 drivers/gpio/gpio-cadence.c                                  |   12 
 drivers/gpio/gpio-dwapb.c                                    |   36 -
 drivers/gpio/gpio-grgpio.c                                   |   30 
 drivers/gpio/gpio-hlwd.c                                     |   18 
 drivers/gpio/gpio-idt3243x.c                                 |   12 
 drivers/gpio/gpio-ixp4xx.c                                   |    4 
 drivers/gpio/gpio-loongson1.c                                |    8 
 drivers/gpio/gpio-menz127.c                                  |    8 
 drivers/gpio/gpio-mlxbf2.c                                   |    6 
 drivers/gpio/gpio-mmio.c                                     |   22 
 drivers/gpio/gpio-mxc.c                                      |   16 
 drivers/gpio/gpio-sifive.c                                   |   12 
 drivers/gpio/gpio-tb10x.c                                    |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c                      |   10 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c            |    4 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c  |    1 
 drivers/gpu/drm/drm_panel_orientation_quirks.c               |    6 
 drivers/gpu/drm/i915/i915_drv.c                              |    5 
 drivers/gpu/drm/i915/i915_switcheroo.c                       |    6 
 drivers/gpu/drm/i915/selftests/intel_scheduler_helpers.c     |    3 
 drivers/gpu/drm/panfrost/Kconfig                             |    3 
 drivers/hid/hid-betopff.c                                    |   17 
 drivers/hid/hid-bigbenff.c                                   |    5 
 drivers/hid/hid-core.c                                       |    4 
 drivers/hid/hid-ids.h                                        |    1 
 drivers/hid/hid-quirks.c                                     |    1 
 drivers/hid/intel-ish-hid/ishtp/dma-if.c                     |   10 
 drivers/i2c/busses/i2c-designware-common.c                   |    9 
 drivers/i2c/busses/i2c-mv64xxx.c                             |   61 +-
 drivers/infiniband/core/verbs.c                              |    7 
 drivers/infiniband/hw/hfi1/user_exp_rcv.c                    |  200 ++++--
 drivers/infiniband/hw/hfi1/user_exp_rcv.h                    |    3 
 drivers/input/mouse/synaptics.c                              |    1 
 drivers/memory/atmel-sdramc.c                                |    6 
 drivers/memory/mvebu-devbus.c                                |    3 
 drivers/memory/tegra/tegra186.c                              |   36 -
 drivers/net/dsa/microchip/ksz9477.c                          |    4 
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                     |   23 
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                    |   24 
 drivers/net/ethernet/amd/xgbe/xgbe.h                         |    2 
 drivers/net/ethernet/broadcom/tg3.c                          |    8 
 drivers/net/ethernet/cadence/macb_main.c                     |    9 
 drivers/net/ethernet/freescale/enetc/enetc.c                 |    4 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c     |   11 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h     |    2 
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c            |   18 
 drivers/net/ethernet/mellanox/mlx5/core/main.c               |    8 
 drivers/net/ethernet/microsoft/mana/gdma.h                   |    3 
 drivers/net/ethernet/microsoft/mana/gdma_main.c              |    9 
 drivers/net/ethernet/renesas/ravb.h                          |    4 
 drivers/net/ethernet/renesas/ravb_main.c                     |   36 -
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c                 |   14 
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c         |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c            |    5 
 drivers/net/ipa/ipa_interrupt.c                              |   10 
 drivers/net/ipa/ipa_interrupt.h                              |   16 
 drivers/net/ipa/ipa_power.c                                  |   17 
 drivers/net/mdio/mdio-mux-meson-g12a.c                       |   23 
 drivers/net/phy/mdio_bus.c                                   |    7 
 drivers/net/usb/cdc_ether.c                                  |    6 
 drivers/net/usb/r8152.c                                      |    1 
 drivers/net/usb/sr9700.c                                     |    2 
 drivers/net/virtio_net.c                                     |    6 
 drivers/net/wan/fsl_ucc_hdlc.c                               |    6 
 drivers/net/wireless/rndis_wlan.c                            |   19 
 drivers/nvme/host/core.c                                     |    2 
 drivers/nvme/host/pci.c                                      |    2 
 drivers/phy/phy-can-transceiver.c                            |    5 
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c                |    4 
 drivers/phy/ti/Kconfig                                       |    4 
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c                    |    8 
 drivers/pinctrl/pinctrl-rockchip.c                           |  315 +++++-----
 drivers/pinctrl/pinctrl-rockchip.h                           |    4 
 drivers/platform/x86/asus-nb-wmi.c                           |    1 
 drivers/platform/x86/touchscreen_dmi.c                       |   25 
 drivers/reset/reset-uniphier-glue.c                          |   37 -
 drivers/scsi/hisi_sas/hisi_sas_main.c                        |    2 
 drivers/scsi/hpsa.c                                          |    2 
 drivers/scsi/scsi_transport_iscsi.c                          |   50 +
 drivers/scsi/ufs/ufshcd.c                                    |   26 
 drivers/scsi/ufs/ufshcd.h                                    |    2 
 drivers/soc/imx/soc-imx8m.c                                  |    4 
 drivers/soc/qcom/cpr.c                                       |    6 
 drivers/spi/spidev.c                                         |    2 
 drivers/thermal/gov_fair_share.c                             |   10 
 drivers/thermal/gov_power_allocator.c                        |    4 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c |   28 
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h |    1 
 drivers/thermal/tegra/tegra30-tsensor.c                      |    2 
 drivers/thermal/thermal_core.c                               |   53 -
 drivers/thermal/thermal_helpers.c                            |    4 
 drivers/thermal/thermal_netlink.c                            |    2 
 drivers/thermal/thermal_sysfs.c                              |   33 -
 drivers/usb/gadget/function/f_fs.c                           |    7 
 drivers/w1/w1.c                                              |    6 
 drivers/w1/w1_int.c                                          |    5 
 fs/affs/file.c                                               |    2 
 fs/cifs/dfs_cache.c                                          |   42 -
 fs/cifs/smbdirect.c                                          |    1 
 fs/ksmbd/connection.c                                        |   17 
 fs/ksmbd/ksmbd_netlink.h                                     |    4 
 fs/ksmbd/ndr.c                                               |    8 
 fs/ksmbd/server.h                                            |    1 
 fs/ksmbd/smb2pdu.c                                           |    2 
 fs/ksmbd/smb2pdu.h                                           |    5 
 fs/ksmbd/transport_ipc.c                                     |    6 
 fs/ksmbd/transport_rdma.c                                    |    8 
 fs/ksmbd/transport_rdma.h                                    |    6 
 fs/ksmbd/transport_tcp.c                                     |   17 
 fs/nfsd/nfs4proc.c                                           |    1 
 fs/overlayfs/copy_up.c                                       |    4 
 fs/proc/proc_sysctl.c                                        |   33 +
 fs/reiserfs/super.c                                          |    6 
 include/linux/cpufreq.h                                      |    5 
 include/linux/gpio/driver.h                                  |    2 
 include/linux/panic.h                                        |    7 
 include/linux/sched/task.h                                   |    1 
 include/linux/sysctl.h                                       |    3 
 include/linux/thermal.h                                      |    5 
 include/net/sch_generic.h                                    |    7 
 include/net/sock.h                                           |    2 
 include/scsi/scsi_transport_iscsi.h                          |    9 
 include/uapi/linux/netfilter/nf_conntrack_sctp.h             |    2 
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h           |    2 
 kernel/bpf/verifier.c                                        |    4 
 kernel/exit.c                                                |   72 ++
 kernel/kcsan/kcsan_test.c                                    |    7 
 kernel/kcsan/report.c                                        |    3 
 kernel/module.c                                              |   26 
 kernel/panic.c                                               |   90 ++
 kernel/sched/core.c                                          |    3 
 kernel/sysctl.c                                              |   11 
 kernel/trace/trace.c                                         |    2 
 kernel/trace/trace.h                                         |    1 
 kernel/trace/trace_events_hist.c                             |    2 
 kernel/trace/trace_output.c                                  |    3 
 lib/lockref.c                                                |    1 
 lib/nlattr.c                                                 |    3 
 lib/ubsan.c                                                  |   11 
 mm/kasan/report.c                                            |   12 
 mm/kfence/report.c                                           |    3 
 net/bluetooth/hci_core.c                                     |    1 
 net/bluetooth/rfcomm/sock.c                                  |    7 
 net/core/net_namespace.c                                     |    2 
 net/ipv4/fib_semantics.c                                     |    2 
 net/ipv4/inet_hashtables.c                                   |   17 
 net/ipv4/inet_timewait_sock.c                                |    8 
 net/ipv4/metrics.c                                           |    2 
 net/ipv4/tcp.c                                               |    2 
 net/ipv6/ip6_output.c                                        |   15 
 net/l2tp/l2tp_core.c                                         |  116 ++-
 net/mctp/af_mctp.c                                           |    1 
 net/mctp/route.c                                             |    6 
 net/netfilter/nf_conntrack_proto_sctp.c                      |  118 +--
 net/netfilter/nf_conntrack_standalone.c                      |    8 
 net/netfilter/nft_set_rbtree.c                               |  332 ++++++-----
 net/netlink/af_netlink.c                                     |   38 -
 net/netrom/nr_timer.c                                        |    1 
 net/nfc/llcp_core.c                                          |    1 
 net/sched/sch_htb.c                                          |   27 
 net/sched/sch_taprio.c                                       |    2 
 net/sctp/bind_addr.c                                         |    6 
 scripts/Makefile                                             |    4 
 scripts/dtc/Makefile                                         |    6 
 scripts/kconfig/gconf-cfg.sh                                 |   12 
 scripts/kconfig/mconf-cfg.sh                                 |   16 
 scripts/kconfig/nconf-cfg.sh                                 |   16 
 scripts/kconfig/qconf-cfg.sh                                 |   14 
 scripts/tracing/ftrace-bisect.sh                             |   34 -
 security/tomoyo/Makefile                                     |    2 
 sound/soc/fsl/fsl-asoc-card.c                                |    8 
 sound/soc/fsl/fsl_micfil.c                                   |   16 
 sound/soc/fsl/fsl_ssi.c                                      |    4 
 tools/gpio/gpio-event-mon.c                                  |    1 
 tools/objtool/Makefile                                       |    4 
 tools/objtool/check.c                                        |    3 
 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c  |    9 
 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c  |   42 -
 tools/testing/selftests/net/toeplitz.c                       |   12 
 273 files changed, 2172 insertions(+), 1319 deletions(-)

Adam Ford (1):
      arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux

Alexander Gordeev (1):
      s390: expicitly align _edata and _end symbols on page boundary

Alexander Potapenko (1):
      affs: initialize fsdata in affs_truncate()

Alexey V. Vissarionov (1):
      scsi: hpsa: Fix allocation size for scsi_host_alloc()

Andre Przywara (1):
      r8152: add vendor/device ID pair for Microsoft Devkit

Andrew Halaney (1):
      net: stmmac: enable all safety features by default

Andy Shevchenko (1):
      pinctrl/rockchip: Use temporary variable for struct device

Archie Pusaka (1):
      Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Arnd Bergmann (2):
      drm/panfrost: fix GENERIC_ATOMIC64 dependency
      drm/i915/selftest: fix intel_selftest_modify_policy argument types

Ashish Mhetre (1):
      memory: tegra: Remove clients SID override programming

Bartosz Golaszewski (1):
      spi: spidev: remove debug messages that access spidev->spi without locking

Biju Das (1):
      ravb: Rename "no_ptp_cfg_active" and "ptp_cfg_active" variables

Caleb Connolly (1):
      net: ipa: disable ipa interrupt during suspend

Chancel Liu (1):
      ASoC: fsl_micfil: Correct the number of steps on SX controls

Chen Zhongjin (1):
      driver core: Fix test_async_probe_init saves device in wrong array

Chris Morgan (2):
      i2c: mv64xxx: Remove shutdown method from driver
      i2c: mv64xxx: Add atomic_xfer method to driver

Christoph Hellwig (1):
      block: fix and cleanup bio_check_ro

Christophe JAILLET (1):
      PM: AVS: qcom-cpr: Fix an error handling path in cpr_probe()

Chun-Tse Shao (1):
      kbuild: Allow kernel installation packaging to override pkg-config

Claudiu Beznea (1):
      ARM: dts: at91: sam9x60: fix the ddr clock for sam9x60

Colin Ian King (1):
      perf/x86/amd: fix potential integer overflow on shift of a int

Cong Wang (2):
      l2tp: convert l2tp_tunnel_list to idr
      l2tp: close all race conditions in l2tp_tunnel_register()

Cristian Marussi (2):
      firmware: arm_scmi: Harden shared memory access in fetch_response
      firmware: arm_scmi: Harden shared memory access in fetch_notification

Dan Carpenter (2):
      thermal/core: fix error code in __thermal_cooling_device_register()
      gpio: mxc: Unlock on error path in mxc_flip_edge()

Daniel Lezcano (2):
      thermal/core: Remove duplicate information when an error occurs
      thermal/core: Rename 'trips' to 'num_trips'

Dario Binacchi (1):
      ARM: imx: add missing of_node_put()

David Christensen (1):
      net/tg3: resolve deadlock in tg3_reset_task() during EEH

David Howells (1):
      cifs: Fix oops due to uncleared server->smbd_conn in reconnect

David Morley (1):
      tcp: fix rate_app_limited to default to 1

Dean Luick (5):
      IB/hfi1: Reject a zero-length user expected buffer
      IB/hfi1: Reserve user expected TIDs
      IB/hfi1: Fix expected receive setup error exit issues
      IB/hfi1: Immediately remove invalid memory from hardware
      IB/hfi1: Remove user expected buffer invalidate race

Deepak Sharma (1):
      x86: ACPI: cstate: Optimize C3 entry on AMD CPUs

Dmitry Torokhov (1):
      Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"

Dongliang Mu (1):
      fs: reiserfs: remove useless new_opts in reiserfs_remount

Eric Dumazet (9):
      net/sched: sch_taprio: fix possible use-after-free
      l2tp: prevent lockdep issue in l2tp_tunnel_register()
      netlink: prevent potential spectre v1 gadgets
      netlink: annotate data races around nlk->portid
      netlink: annotate data races around dst_portid and dst_group
      netlink: annotate data races around sk_state
      ipv4: prevent potential spectre v1 gadget in ip_metrics_convert()
      ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
      net/sched: sch_taprio: do not schedule in taprio_reset()

Eric Pilmore (1):
      ptdma: pt_core_execute_cmd() should use spinlock

Eric W. Biederman (2):
      exit: Add and use make_task_dead.
      objtool: Add a missing comma to avoid string concatenation

Esina Ekaterina (1):
      net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs

Fabio Estevam (4):
      arm64: dts: imx8mp-phycore-som: Remove invalid PMIC property
      ARM: dts: imx6ul-pico-dwarf: Use 'clock-frequency'
      ARM: dts: imx7d-pico: Use 'clock-frequency'
      ARM: dts: imx6qdl-gw560x: Remove incorrect 'uart-has-rtscts'

Gaosheng Cui (2):
      memory: atmel-sdramc: Fix missing clk_disable_unprepare in atmel_ramc_probe()
      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()

Geert Uytterhoeven (1):
      phy: phy-can-transceiver: Skip warning if no "max-bitrate"

Geetha sowjanya (1):
      octeontx2-pf: Avoid use of GFP_KERNEL in atomic context

Gergely Risko (1):
      ipv6: fix reachability confirmation with proxy_ndp

Giulio Benetti (1):
      ARM: 9280/1: mm: fix warning on phys_addr_t to void pointer assignment

Greg Kroah-Hartman (1):
      Linux 5.15.91

Haiyang Zhang (1):
      net: mana: Fix IRQ name - add PCI and queue number

Hamza Mahfooz (1):
      drm/amd/display: fix issues with driver unload

Hans de Goede (1):
      platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK

Harsh Jain (1):
      drm/amdgpu: complete gfxoff allow signal during suspend without delay

Heiko Carstens (1):
      KVM: s390: interrupt: use READ_ONCE() before cmpxchg()

Heiner Kallweit (2):
      net: mdio: validate parameter addr in mdiobus_get_phy()
      net: stmmac: fix invalid call to mdiobus_get_phy()

Hendrik Borghorst (1):
      KVM: x86/vmx: Do not skip segment attributes if unusable bit is set

Hui Tang (1):
      reset: uniphier-glue: Fix possible null-ptr-deref

Hui Wang (1):
      net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem

Ivo Borisov Shopov (1):
      tools: gpio: fix -c option of gpio-event-mon

Jakub Sitnicki (2):
      l2tp: Serialize access to sk_user_data with sk_callback_lock
      l2tp: Don't sleep and disable BH under writer-side sk_callback_lock

Jann Horn (1):
      exit: Put an upper limit on how often we can oops

Jason Wang (1):
      virtio-net: correctly enable callback during start_xmit

Jason Xing (1):
      tcp: avoid the lookup process failing to get sk in ehash table

Jayesh Choudhary (1):
      dmaengine: ti: k3-udma: Do conditional decrement of UDMA_CHAN_RT_PEER_BCNT_REG

Jeremy Kerr (1):
      net: mctp: mark socks as dead on unhash, prevent re-add

Jerome Brunet (1):
      net: mdio-mux-meson-g12a: force internal PHY off on mux switch

Jiasheng Jiang (1):
      HID: intel_ish-hid: Add check for ishtp_dma_tx_map

Jiri Kosina (1):
      HID: revert CHERRY_MOUSE_000C quirk

Jisoo Jang (1):
      net: nfc: Fix use-after-free in local_cleanup()

Johan Hovold (1):
      scsi: ufs: core: Fix devfreq deadlocks

Jonas Karlman (2):
      pinctrl: rockchip: fix reading pull type on rk3568
      pinctrl: rockchip: fix mux route data for rk3568

Kan Liang (2):
      perf/x86/msr: Add Emerald Rapids
      perf/x86/intel/uncore: Add Emerald Rapids

Kees Cook (9):
      firmware: coreboot: Check size of table entry and use flex-array
      panic: Separate sysctl logic from CONFIG_SMP
      exit: Expose "oops_count" to sysfs
      exit: Allow oops_limit to be disabled
      panic: Consolidate open-coded panic_on_warn checks
      panic: Introduce warn_limit
      panic: Expose "warn_count" to sysfs
      docs: Fix path paste-o for /sys/kernel/warn_count
      exit: Use READ_ONCE() for all oops/warn limit reads

Keith Busch (2):
      nvme-pci: fix timeout request state check
      nvme: fix passthrough csi check

Kevin Hao (3):
      octeontx2-pf: Fix the use of GFP_KERNEL in atomic context on rt
      cpufreq: Move to_gov_attr_set() to cpufreq.h
      cpufreq: governor: Use kobject release() method to free dbs_data

Koba Ko (1):
      dmaengine: Fix double increment of client_count in dma_chan_get()

Konrad Dybcio (4):
      arm64: dts: qcom: msm8992: Don't use sfpb mutex
      arm64: dts: qcom: msm8992-libra: Add CPU regulators
      arm64: dts: qcom: msm8992-libra: Fix the memory map
      cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist

Kuniyuki Iwashima (1):
      netrom: Fix use-after-free of a listening socket.

Kurt Kanzenbach (1):
      net: stmmac: Fix queue statistics reading

Lareine Khawaly (1):
      i2c: designware: use casting of u64 in clock multiplication to avoid overflow

Liao Chang (1):
      riscv/kprobe: Fix instruction simulation of JALR

Linus Torvalds (1):
      treewide: fix up files incorrectly marked executable

Liu Shixin (1):
      dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()

Luis Gerhorst (1):
      bpf: Fix pointer-leak due to insufficient speculative store bypass mitigation

Manivannan Sadhasivam (2):
      EDAC/device: Respect any driver-supplied workqueue polling value
      EDAC/qcom: Do not pass llcc_driv_data as edac_device_ctl_info's pvt_info

Maor Dickman (1):
      net/mlx5: E-switch, Fix setting of reserved fields on MODIFY_SCHEDULING_ELEMENT

Marc Zyngier (1):
      KVM: arm64: GICv4.1: Fix race with doorbell on VPE activation/deactivation

Marcelo Ricardo Leitner (1):
      sctp: fail if no bound addresses can be used for a given scope

Marek Vasut (2):
      gpio: mxc: Protect GPIO irqchip RMW with bgpio spinlock
      gpio: mxc: Always set GPIOs used as interrupt source to INPUT mode

Marios Makassikis (1):
      ksmbd: do not sign response to session request for guest login

Mark Brown (2):
      ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC
      ASoC: fsl-asoc-card: Fix naming of AC'97 CODEC widgets

Masahiro Yamada (1):
      tomoyo: fix broken dependency on *.conf.default

Mateusz Guzik (1):
      lockref: stop doing cpu_relax in the cmpxchg loop

Max Filippov (1):
      kcsan: test: don't put the expect array on the stack

Maxim Levitsky (1):
      KVM: SVM: fix tsc scaling cache logic

Miaoqian Lin (2):
      soc: imx8m: Fix incorrect check for of_clk_get_by_name()
      EDAC/highbank: Fix memory leak in highbank_mc_probe()

Michael Klein (1):
      platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD

Miklos Szeredi (1):
      ovl: fail on invalid uid/gid mapping at copy up

Miles Chen (1):
      cpufreq: armada-37xx: stop using 0 as NULL pointer

Namjae Jeon (4):
      ksmbd: add smbd max io size parameter
      ksmbd: add max connections parameter
      ksmbd: downgrade ndr version error message to debug
      ksmbd: limit pdu length size according to connection status

Natalia Petrova (1):
      trace_events_hist: add check for return value of 'create_hist_field'

Nathan Chancellor (3):
      hexagon: Fix function name in die()
      h8300: Fix build errors from do_exit() to make_task_dead() transition
      csky: Fix function name in csky_alignment() and die()

Niklas Schnelle (1):
      s390/debug: add _ASM_S390_ prefix to header guard

Nirmoy Das (1):
      drm/i915: Remove unused variable

Pablo Neira Ayuso (2):
      netfilter: nft_set_rbtree: Switch to node list walk for overlap detection
      netfilter: nft_set_rbtree: skip elements in transaction from garbage collection

Paolo Abeni (1):
      net: fix UaF in netns ops registration error path

Patrick Thompson (1):
      drm: Add orientation quirk for Lenovo ideapad D330-10IGL

Paulo Alcantara (1):
      cifs: fix potential deadlock in cache_refresh_path()

Petr Pavlu (1):
      module: Don't wait for GOING modules

Philipp Zabel (1):
      reset: uniphier-glue: Use reset_control_bulk API

Pietro Borrello (3):
      HID: check empty report_list in hid_validate_values()
      HID: check empty report_list in bigben_probe()
      HID: betop: check shape of output reports

Rafael J. Wysocki (1):
      thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()

Rahul Rameshbabu (1):
      sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb

Raju Rangoju (2):
      amd-xgbe: TX Flow Ctrl Registers are h/w ver dependent
      amd-xgbe: Delay AN timeout during KR training

Rakesh Sankaranarayanan (1):
      net: dsa: microchip: ksz9477: port map correction in ALU table entry register

Randy Dunlap (3):
      phy: ti: fix Kconfig warning and operator precedence
      net: mlx5: eliminate anonymous module_init & module_exit
      ia64: make IA64_MCA_RECOVERY bool instead of tristate

Robert Hancock (1):
      net: macb: fix PTP TX timestamp failure due to packet padding

Sasha Levin (1):
      Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"

Schspa Shi (1):
      gpio: use raw spinlock for gpio chip shadowed data

Sebastian Reichel (1):
      pinctrl/rockchip: add error handling for pull/drive register getters

Shang XiaoJing (1):
      phy: rockchip-inno-usb2: Fix missing clk_disable_unprepare() in rockchip_usb2phy_power_on()

Srinivas Pandruvada (1):
      thermal: intel: int340x: Protect trip temperature from concurrent updates

Sriram Yagnaraman (2):
      netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
      netfilter: conntrack: unify established states for SCTP paths

Steven Rostedt (Google) (2):
      tracing: Make sure trace_printk() can output as soon as it can be used
      ftrace/scripts: Update the instructions for ftrace-bisect.sh

Sumit Gupta (1):
      cpufreq: Add Tegra234 to cpufreq-dt-platdev blocklist

Szymon Heidrich (2):
      wifi: rndis_wlan: Prevent buffer overflow in rndis_query_oid
      net: usb: sr9700: Handle negative len

Thomas Gleixner (1):
      x86/i8259: Mark legacy PIC interrupts with IRQ_LEVEL

Thomas Zimmermann (1):
      drm/i915: Allow switching away via vga-switcheroo if uninitialized

Tiezhu Yang (3):
      panic: unset panic_on_warn inside panic()
      ubsan: no need to unset panic_on_warn in ubsan_epilogue()
      kasan: no need to unset panic_on_warn in end_report()

Tim Harvey (1):
      arm64: dts: imx8mm-venice-gw7901: fix USB2 controller OC polarity

Udipto Goswami (2):
      usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait
      usb: gadget: f_fs: Ensure ep0req is dequeued before free_request

Viresh Kumar (2):
      thermal: Validate new state in cur_state_store()
      thermal: core: call put_device() only after device_register() fails

Vladimir Oltean (1):
      net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()

Wenchao Hao (1):
      scsi: iscsi: Fix multiple iSCSI session unbind events sent to userspace

Willem de Bruijn (1):
      selftests/net: toeplitz: fix race on tpacket_v3 block close

Xiaoming Ni (1):
      sysctl: add a new register_sysctl_init() interface

Xingyuan Mo (1):
      NFSD: fix use-after-free in nfsd4_ssc_setup_dul()

Yang Yingliang (3):
      device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()
      w1: fix deadloop in __w1_remove_master_device()
      w1: fix WARNING after calling w1_process()

Yihang Li (1):
      scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id

Ying Hsu (1):
      Bluetooth: Fix possible deadlock in rfcomm_sk_state_change

Yonatan Nachum (1):
      RDMA/core: Fix ib block iterator counter overflow

Yoshihiro Shimoda (2):
      net: ravb: Fix lack of register setting after system resumed for Gen3
      net: ravb: Fix possible hang if RIS2_QFF1 happen

tangmeng (1):
      kernel/panic: move panic sysctls to its own file

