Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F3F5A0D1A
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbiHYJuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240706AbiHYJsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:48:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A25EAB4F6;
        Thu, 25 Aug 2022 02:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D99AB827E9;
        Thu, 25 Aug 2022 09:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DBAC433C1;
        Thu, 25 Aug 2022 09:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420879;
        bh=/BMWFCsFRUvI/7sH1Wz9tL6i3PSMEtu1STACExdEVWw=;
        h=From:To:Cc:Subject:Date:From;
        b=02qNOBnD6He1maZKVx3KX84MBXYiNSZ7+TgBqmrrqJB0l+iuwyqh40Y4l+mypCsSz
         VutpDaZNCNcH2h8bF5RlL12H9NSS6HUvXjcbKw4kDmEtnPA1HBkGS0UM/X35ZfXxv0
         PiSWysBzxWRcb1Q23qQx4yNrILxyfFXT/K9Y06rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.63
Date:   Thu, 25 Aug 2022 11:47:40 +0200
Message-Id: <1661420860207244@kroah.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_ABUSE_SURBL,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.63 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/atomic_bitops.txt                                        |    2 
 Documentation/devicetree/bindings/arm/qcom.yaml                        |   18 
 Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml          |   16 
 Documentation/devicetree/bindings/gpio/gpio-zynq.yaml                  |    6 
 Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml |   11 
 Documentation/devicetree/bindings/spi/spi-cadence.yaml                 |    7 
 Documentation/devicetree/bindings/spi/spi-zynqmp-qspi.yaml             |    7 
 Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml           |    1 
 Documentation/firmware-guide/acpi/apei/einj.rst                        |    2 
 Makefile                                                               |    8 
 arch/arm64/include/asm/kvm_host.h                                      |    4 
 arch/arm64/kvm/arm.c                                                   |    3 
 arch/arm64/kvm/guest.c                                                 |    2 
 arch/arm64/kvm/sys_regs.c                                              |    4 
 arch/csky/kernel/probes/kprobes.c                                      |    4 
 arch/m68k/coldfire/device.c                                            |    6 
 arch/mips/cavium-octeon/octeon-platform.c                              |    3 
 arch/mips/mm/tlbex.c                                                   |    4 
 arch/nios2/include/asm/entry.h                                         |    3 
 arch/nios2/include/asm/ptrace.h                                        |    2 
 arch/nios2/kernel/entry.S                                              |   22 -
 arch/nios2/kernel/signal.c                                             |    3 
 arch/nios2/kernel/syscall_table.c                                      |    1 
 arch/openrisc/include/asm/io.h                                         |    2 
 arch/openrisc/mm/ioremap.c                                             |    2 
 arch/powerpc/Makefile                                                  |   26 -
 arch/powerpc/kernel/head_book3s_32.S                                   |    4 
 arch/powerpc/kernel/pci-common.c                                       |   16 
 arch/powerpc/kernel/prom.c                                             |    7 
 arch/powerpc/kvm/book3s_hv_p9_entry.c                                  |   13 
 arch/powerpc/mm/book3s32/mmu.c                                         |   10 
 arch/powerpc/platforms/Kconfig.cputype                                 |   21 -
 arch/powerpc/platforms/powernv/pci-ioda.c                              |    2 
 arch/riscv/boot/dts/canaan/k210.dtsi                                   |   12 
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi                             |   24 +
 arch/riscv/kernel/sys_riscv.c                                          |    5 
 arch/riscv/kernel/traps.c                                              |    4 
 arch/um/os-Linux/skas/process.c                                        |   17 
 arch/x86/kernel/kprobes/core.c                                         |    2 
 arch/x86/mm/init_64.c                                                  |    2 
 drivers/acpi/pci_mcfg.c                                                |    3 
 drivers/acpi/property.c                                                |    8 
 drivers/ata/libata-eh.c                                                |    1 
 drivers/atm/idt77252.c                                                 |    1 
 drivers/block/zram/zcomp.c                                             |   11 
 drivers/clk/qcom/clk-alpha-pll.c                                       |    2 
 drivers/clk/qcom/gcc-ipq8074.c                                         |    1 
 drivers/clk/ti/clk-44xx.c                                              |  210 +++++-----
 drivers/clk/ti/clk-54xx.c                                              |  160 +++----
 drivers/clk/ti/clkctrl.c                                               |    4 
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                         |   11 
 drivers/dma/sprd-dma.c                                                 |    5 
 drivers/gpu/drm/amd/display/dc/dcn303/dcn303_resource.c                |    2 
 drivers/gpu/drm/imx/dcss/dcss-kms.c                                    |    2 
 drivers/gpu/drm/meson/meson_drv.c                                      |    5 
 drivers/gpu/drm/meson/meson_viu.c                                      |   22 -
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c                      |   22 +
 drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c                                 |   10 
 drivers/gpu/drm/ttm/ttm_bo.c                                           |    2 
 drivers/hid/hid-multitouch.c                                           |   13 
 drivers/hwtracing/coresight/coresight-etm4x.h                          |    3 
 drivers/i2c/busses/i2c-imx.c                                           |   20 
 drivers/infiniband/sw/rxe/rxe_param.h                                  |    6 
 drivers/infiniband/sw/rxe/rxe_task.c                                   |   16 
 drivers/input/touchscreen/exc3000.c                                    |    7 
 drivers/iommu/io-pgtable-arm-v7s.c                                     |   75 ++-
 drivers/irqchip/irq-tegra.c                                            |   10 
 drivers/md/md.c                                                        |    1 
 drivers/md/raid5.c                                                     |    2 
 drivers/media/platform/qcom/venus/pm_helpers.c                         |   10 
 drivers/misc/cxl/irq.c                                                 |    1 
 drivers/misc/habanalabs/gaudi/gaudi.c                                  |   24 -
 drivers/misc/uacce/uacce.c                                             |  133 ++++--
 drivers/mmc/host/meson-gx-mmc.c                                        |    6 
 drivers/mmc/host/pxamci.c                                              |    4 
 drivers/mmc/host/renesas_sdhi_core.c                                   |   29 -
 drivers/mmc/host/tmio_mmc.c                                            |    2 
 drivers/mmc/host/tmio_mmc.h                                            |    6 
 drivers/mmc/host/tmio_mmc_core.c                                       |   28 +
 drivers/net/can/spi/mcp251x.c                                          |   18 
 drivers/net/can/usb/ems_usb.c                                          |    2 
 drivers/net/dsa/microchip/ksz9477.c                                    |    3 
 drivers/net/dsa/mv88e6060.c                                            |    3 
 drivers/net/dsa/ocelot/felix_vsc9959.c                                 |    3 
 drivers/net/dsa/sja1105/sja1105_devlink.c                              |    2 
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c                        |   21 -
 drivers/net/ethernet/broadcom/bgmac.c                                  |    2 
 drivers/net/ethernet/broadcom/genet/bcmmii.c                           |    3 
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c                       |    4 
 drivers/net/ethernet/freescale/fec_ptp.c                               |    6 
 drivers/net/ethernet/intel/i40e/i40e_main.c                            |    4 
 drivers/net/ethernet/intel/iavf/iavf_adminq.c                          |   15 
 drivers/net/ethernet/intel/iavf/iavf_main.c                            |    9 
 drivers/net/ethernet/intel/ice/ice_switch.c                            |    2 
 drivers/net/ethernet/intel/igb/igb.h                                   |    2 
 drivers/net/ethernet/intel/igb/igb_main.c                              |   12 
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c                        |    6 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c                    |   15 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c                 |    3 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c               |   19 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h               |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c                    |    4 
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c                         |    2 
 drivers/net/ethernet/moxa/moxart_ether.c                               |   20 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c                   |    2 
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c                      |    1 
 drivers/net/geneve.c                                                   |   15 
 drivers/net/phy/phy_device.c                                           |    6 
 drivers/net/plip/plip.c                                                |    2 
 drivers/net/virtio_net.c                                               |    5 
 drivers/ntb/test/ntb_tool.c                                            |    8 
 drivers/nvme/target/tcp.c                                              |    3 
 drivers/pci/controller/pci-aardvark.c                                  |   33 +
 drivers/pci/quirks.c                                                   |    3 
 drivers/phy/samsung/phy-exynos-pcie.c                                  |   25 -
 drivers/pinctrl/intel/pinctrl-intel.c                                  |   14 
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                              |    4 
 drivers/pinctrl/pinctrl-amd.c                                          |   11 
 drivers/pinctrl/qcom/pinctrl-msm8916.c                                 |    4 
 drivers/pinctrl/qcom/pinctrl-sm8250.c                                  |    2 
 drivers/pinctrl/sunxi/pinctrl-sun50i-h6-r.c                            |    1 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                                  |    7 
 drivers/platform/chrome/cros_ec_proto.c                                |    8 
 drivers/scsi/lpfc/lpfc_debugfs.c                                       |   20 
 drivers/scsi/lpfc/lpfc_sli.c                                           |    4 
 drivers/scsi/ufs/ufs-mediatek.c                                        |   60 ++
 drivers/spi/spi-meson-spicc.c                                          |  129 ++++--
 drivers/tty/serial/ucc_uart.c                                          |    2 
 drivers/usb/cdns3/cdns3-gadget.c                                       |    4 
 drivers/usb/dwc2/gadget.c                                              |    3 
 drivers/usb/gadget/function/uvc_queue.c                                |   17 
 drivers/usb/gadget/function/uvc_video.c                                |    2 
 drivers/usb/gadget/legacy/inode.c                                      |    1 
 drivers/usb/host/ohci-ppc-of.c                                         |    1 
 drivers/usb/renesas_usbhs/rza.c                                        |    4 
 drivers/vfio/vfio.c                                                    |    1 
 drivers/video/fbdev/i740fb.c                                           |    9 
 drivers/virt/vboxguest/vboxguest_linux.c                               |    9 
 drivers/xen/xenbus/xenbus_dev_frontend.c                               |    4 
 fs/btrfs/block-group.c                                                 |    4 
 fs/btrfs/relocation.c                                                  |    7 
 fs/btrfs/tree-log.c                                                    |    4 
 fs/ceph/caps.c                                                         |   27 -
 fs/ceph/mds_client.c                                                   |    7 
 fs/ceph/mds_client.h                                                   |    6 
 fs/cifs/misc.c                                                         |    6 
 fs/cifs/smb2ops.c                                                      |    5 
 fs/ext4/namei.c                                                        |    7 
 fs/ext4/resize.c                                                       |   10 
 fs/f2fs/node.c                                                         |    6 
 fs/f2fs/segment.c                                                      |   13 
 fs/nfs/nfs4idmap.c                                                     |   46 +-
 fs/nfs/nfs4proc.c                                                      |   20 
 fs/ntfs3/fslog.c                                                       |    2 
 fs/ntfs3/fsntfs.c                                                      |    7 
 fs/ntfs3/index.c                                                       |    2 
 fs/ntfs3/inode.c                                                       |    1 
 fs/ntfs3/super.c                                                       |    8 
 fs/ntfs3/xattr.c                                                       |   22 -
 fs/overlayfs/super.c                                                   |    7 
 fs/xfs/xfs_filestream.c                                                |    7 
 fs/xfs/xfs_fsops.c                                                     |   50 --
 fs/xfs/xfs_icache.c                                                    |   22 -
 fs/xfs/xfs_inode.c                                                     |   79 ++-
 fs/xfs/xfs_ioctl.c                                                     |    2 
 fs/xfs/xfs_trans.c                                                     |   86 ++++
 fs/xfs/xfs_trans.h                                                     |    3 
 fs/xfs/xfs_trans_dquot.c                                               |    1 
 include/asm-generic/bitops/atomic.h                                    |    6 
 include/linux/bpfptr.h                                                 |    8 
 include/linux/io-pgtable.h                                             |   15 
 include/linux/nmi.h                                                    |    2 
 include/linux/sunrpc/xdr.h                                             |    4 
 include/linux/uacce.h                                                  |    6 
 include/sound/control.h                                                |    2 
 include/sound/core.h                                                   |    8 
 kernel/bpf/arraymap.c                                                  |    6 
 kernel/bpf/hashtab.c                                                   |    8 
 kernel/trace/trace_eprobe.c                                            |   88 +++-
 kernel/trace/trace_event_perf.c                                        |    7 
 kernel/trace/trace_events.c                                            |    1 
 kernel/trace/trace_probe.c                                             |   29 -
 kernel/watchdog.c                                                      |   21 -
 lib/list_debug.c                                                       |   12 
 net/can/j1939/socket.c                                                 |    5 
 net/can/j1939/transport.c                                              |    8 
 net/core/bpf_sk_storage.c                                              |   12 
 net/core/devlink.c                                                     |    4 
 net/core/sock_map.c                                                    |   20 
 net/dsa/port.c                                                         |    7 
 net/ipv6/ip6_output.c                                                  |    3 
 net/ipv6/ndisc.c                                                       |    3 
 net/netfilter/nf_tables_api.c                                          |   70 ++-
 net/netlink/genetlink.c                                                |    6 
 net/netlink/policy.c                                                   |   14 
 net/qrtr/mhi.c                                                         |   12 
 net/rds/ib_recv.c                                                      |    1 
 net/sunrpc/auth.c                                                      |    2 
 net/sunrpc/backchannel_rqst.c                                          |   14 
 net/sunrpc/sysfs.c                                                     |    6 
 net/vmw_vsock/af_vsock.c                                               |   10 
 scripts/Makefile.gcc-plugins                                           |    2 
 scripts/dummy-tools/gcc                                                |    8 
 scripts/module.lds.S                                                   |    2 
 security/apparmor/apparmorfs.c                                         |    2 
 security/apparmor/audit.c                                              |    2 
 security/apparmor/domain.c                                             |    2 
 security/apparmor/include/lib.h                                        |    5 
 security/apparmor/include/policy.h                                     |    2 
 security/apparmor/label.c                                              |   13 
 security/apparmor/mount.c                                              |    8 
 security/apparmor/policy_unpack.c                                      |   12 
 sound/core/control.c                                                   |    7 
 sound/core/info.c                                                      |    6 
 sound/core/misc.c                                                      |   94 ++++
 sound/core/timer.c                                                     |   11 
 sound/pci/hda/patch_realtek.c                                          |    1 
 sound/soc/codecs/tas2770.c                                             |   98 ++--
 sound/soc/codecs/tas2770.h                                             |    5 
 sound/soc/codecs/tlv320aic32x4.c                                       |    9 
 sound/soc/sh/rcar/ssiu.c                                               |    2 
 sound/soc/sof/debug.c                                                  |    6 
 sound/soc/sof/intel/apl.c                                              |    1 
 sound/soc/sof/intel/cnl.c                                              |    2 
 sound/soc/sof/intel/hda-loader.c                                       |   14 
 sound/soc/sof/intel/hda.c                                              |   10 
 sound/soc/sof/intel/icl.c                                              |    1 
 sound/soc/sof/intel/shim.h                                             |    1 
 sound/soc/sof/intel/tgl.c                                              |    4 
 sound/usb/card.c                                                       |    8 
 sound/usb/mixer_maps.c                                                 |   34 +
 tools/build/feature/test-libcrypto.c                                   |   15 
 tools/perf/tests/switch-tracking.c                                     |   18 
 tools/perf/util/parse-events.c                                         |   14 
 tools/perf/util/probe-event.c                                          |    6 
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |    1 
 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh        |   24 -
 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh    |   24 -
 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh |   24 -
 tools/vm/slabinfo.c                                                    |   32 +
 virt/kvm/kvm_main.c                                                    |   14 
 241 files changed, 2159 insertions(+), 1063 deletions(-)

Aaron Lu (1):
      x86/mm: Use proper mask when setting PUD mapping

Adrian Hunter (2):
      perf parse-events: Fix segfault when event parser gets an error
      perf tests: Fix Track with sched_switch test for hybrid case

Al Viro (6):
      nios2: page fault et.al. are *not* restartable syscalls...
      nios2: don't leave NULLs in sys_call_table[]
      nios2: traced syscall does need to check the syscall number
      nios2: fix syscall restart checks
      nios2: restarts apply only to the first sigframe we build...
      nios2: add force_successful_syscall_return()

Alan Brady (1):
      i40e: Fix to stop tx_timeout recovery if GLOBR fails

Alexey Kardashevskiy (1):
      powerpc/ioda/iommu/debugfs: Generate unique debugfs entries

Amadeusz Sławiński (1):
      ALSA: info: Fix llseek return value when using callback

Amelie Delaunay (1):
      usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch

Amit Cohen (1):
      mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice

Andrew Donnellan (1):
      gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file

Andy Shevchenko (1):
      pinctrl: intel: Check against matching data instead of ACPI companion

Arun Ramadoss (1):
      net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry

Arunpravin Paneer Selvam (1):
      drm/ttm: Fix dummy res NULL ptr deref bug

Aurabindo Pillai (1):
      drm/amd/display: Check correct bounds for stream encoder instances for DCN303

Basavaraj Natikar (1):
      pinctrl: amd: Don't save/restore interrupt status and wake status bits

Ben Dooks (2):
      dmaengine: dw-axi-dmac: do not print NULL LLI during error
      dmaengine: dw-axi-dmac: ignore interrupt if no descriptor

Bob Pearson (1):
      RDMA/rxe: Limit the number of calls to each tasklet

Brian Foster (2):
      xfs: flush inodegc workqueue tasks before cancel
      xfs: fix soft lockup via spinning in filestream ag selection loop

Celeste Liu (1):
      riscv: mmap with PROT_WRITE but no PROT_READ is invalid

Chao Yu (2):
      f2fs: fix to avoid use f2fs_bug_on() in f2fs_new_node_page()
      f2fs: fix to do sanity check on segment type in build_sit_entries()

Chen Lin (1):
      dpaa2-eth: trace the allocated address instead of page struct

Chia-Lin Kao (AceLan) (1):
      net: atlantic: fix aq_vec index out of range error

Christoffer Sandberg (1):
      ALSA: hda/realtek: Add quirk for Clevo NS50PU, NS70PU

Christophe JAILLET (6):
      mmc: pxamci: Fix another error handling path in pxamci_probe()
      mmc: pxamci: Fix an error handling path in pxamci_probe()
      mmc: meson-gx: Fix an error handling path in meson_mmc_probe()
      perf probe: Fix an error handling path in 'parse_perf_probe_command()'
      stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()
      cxl: Fix a memory leak in an error handling path

Christophe Leroy (2):
      powerpc/32: Set an IBAT covering up to _einittext during init
      powerpc/32: Don't always pass -mcpu=powerpc to the compiler

Chuck Lever (1):
      SUNRPC: Fix xdr_encode_bool()

Conor Dooley (2):
      riscv: dts: sifive: Add fu740 topology information
      riscv: dts: canaan: Add k210 topology information

Csókás Bence (1):
      fec: Fix timer capture timing in `fec_ptp_enable_pps()`

Damien Le Moal (1):
      ata: libata-eh: Add missing command name

Dan Aloni (1):
      sunrpc: fix expiry of auth creds

Dan Carpenter (4):
      NTB: ntb_tool: uninitialized heap data in tool_fn_write()
      xen/xenbus: fix return type in xenbus_file_read()
      fs/ntfs3: Don't clear upper bits accidentally in log_replay()
      fs/ntfs3: uninitialized variable in ntfs_set_acl_ex()

Darrick J. Wong (6):
      xfs: reserve quota for dir expansion when linking/unlinking files
      xfs: reserve quota for target dir expansion when renaming files
      xfs: remove infinite loop when reserving free block pool
      xfs: always succeed at setting the reserve pool size
      xfs: fix overfilling of reserve pool
      xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*

Dmitry Baryshkov (1):
      dt-bindings: clock: qcom,gcc-msm8996: add more GCC clock sources

Duoming Zhou (1):
      atm: idt77252: fix use-after-free bugs caused by tst_timer

Eric Sandeen (1):
      xfs: revert "xfs: actually bump warning counts when we send warnings"

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings

Fedor Pchelkin (2):
      can: j1939: j1939_session_destroy(): fix memory leak of skbs
      can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()

Filipe Manana (1):
      btrfs: fix lost error handling when looking up extended ref on log replay

Florian Fainelli (2):
      net: phy: Warn about incorrect mdio_bus_phy_resume() state
      net: bcmgenet: Indicate MAC is in charge of PHY PM

Florian Westphal (1):
      plip: avoid rcu debug splat

Frank Li (2):
      usb: cdns3 fix use-after-free at workaround 2
      usb: cdns3: fix random warning message when driver load

Frieder Schrempf (1):
      regulator: pca9450: Remove restrictions for regulator-name

Greg Kroah-Hartman (1):
      Linux 5.15.63

Grzegorz Siwik (1):
      ice: Ignore EEXIST when setting promisc mode

Guenter Roeck (1):
      lib/list_debug.c: Detect uninitialized lists

Harman Kalra (1):
      octeontx2-af: suppress external profile loading warning

Hector Martin (1):
      locking/atomic: Make test_and_*_bit() ordered on failure

Helge Deller (1):
      modules: Ensure natural alignment for .altinstructions and __bug_table sections

Hou Tao (5):
      bpf: Acquire map uref in .init_seq_private for array map iterator
      bpf: Acquire map uref in .init_seq_private for hash map iterator
      bpf: Acquire map uref in .init_seq_private for sock local storage map iterator
      bpf: Acquire map uref in .init_seq_private for sock{map,hash} iterator
      bpf: Check the validity of max_rdwr_access for sock local storage map iterator

Huacai Chen (1):
      PCI/ACPI: Guard ARM64-specific mcfg_quirks

Ido Schimmel (2):
      devlink: Fix use-after-free after a failed reload
      selftests: forwarding: Fix failing tests with old libnet

Jakub Kicinski (1):
      net: genl: fix error path memory leak in policy dumping

James Smart (2):
      scsi: lpfc: Prevent buffer overflow crashes in debugfs with malformed user input
      scsi: lpfc: Fix possible memory leak when failing to issue CMF WQE

Jason A. Donenfeld (1):
      um: add "noreboot" command line option for PANIC_TIMEOUT=-1 setups

Jean-Philippe Brucker (1):
      uacce: Handle parent device removal or parent driver module rmmod

Jeff Layton (1):
      ceph: don't leak snap_rwsem in handle_cap_grant

Jianhua Lu (1):
      pinctrl: qcom: sm8250: Fix PDC map

Jinghao Jia (1):
      BPF: Fix potential bad pointer dereference in bpf_sys_bpf()

John Johansen (5):
      apparmor: fix quiet_denied for file rules
      apparmor: fix absroot causing audited secids to begin with =
      apparmor: Fix failed mount permission check error message
      apparmor: fix setting unconfined mode on a loaded profile
      apparmor: fix overlapping attachment computation

Josef Bacik (1):
      btrfs: reset RO counter on block group if we fail to relocate

Jozef Martiniak (1):
      gadgetfs: ep_io - wait until IRQ finishes

Karol Herbst (1):
      drm/nouveau: recognise GA103

Kiselev, Oleg (1):
      ext4: avoid resizing to a partial cluster size

Konstantin Komarov (3):
      fs/ntfs3: Fix double free on remount
      fs/ntfs3: Do not change mode if ntfs_set_ea failed
      fs/ntfs3: Fix missing i_op in ntfs_read_mft

Krzysztof Kozlowski (6):
      dt-bindings: arm: qcom: fix Alcatel OneTouch Idol 3 compatibles
      dt-bindings: arm: qcom: fix Longcheer L8150 compatibles
      dt-bindings: arm: qcom: fix MSM8916 MTP compatibles
      dt-bindings: arm: qcom: fix MSM8994 boards compatibles
      spi: dt-bindings: cadence: add missing 'required'
      spi: dt-bindings: zynqmp-qspi: add missing 'required'

Kumar Kartikeya Dwivedi (1):
      bpf: Don't reinit map value in prealloc_lru_pop

Kuninori Morimoto (1):
      ASoC: rsnd: care default case on rsnd_ssiu_busif_err_irq_ctrl()

Laurent Dufour (1):
      watchdog: export lockup_detector_reconfigure

Laurentiu Palcu (1):
      drm/imx/dcss: get rid of HPD warning message

Liang He (5):
      drm/meson: Fix refcount bugs in meson_vpu_has_available_connectors()
      usb: host: ohci-ppc-of: Fix refcount leak bug
      usb: renesas: Fix refcount leak bug
      tty: serial: Fix refcount leak bug in ucc_uart.c
      mips: cavium-octeon: Fix missing of_node_put() in octeon2_usb_clocks_start

Liao Chang (1):
      csky/kprobe: reclaim insn_slot on kprobe unregistration

Lin Ma (1):
      igb: Add lock to avoid data race

Logan Gunthorpe (1):
      md: Notify sysfs sync_completed in md_reap_sync_thread()

Luís Henriques (1):
      ceph: use correct index when encoding client supported features

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Marek Szyprowski (1):
      phy: samsung: phy-exynos-pcie: sanitize init/power_on callbacks

Martin Povišer (4):
      ASoC: tas2770: Set correct FSYNC polarity
      ASoC: tas2770: Allow mono streams
      ASoC: tas2770: Drop conflicting set_bias_level power setting
      ASoC: tas2770: Fix handling of mute/unmute

Masahiro Yamada (1):
      kbuild: fix the modules order between drivers and libs

Matthias May (4):
      geneve: do not use RT_TOS for IPv6 flowlabel
      mlx5: do not use RT_TOS for IPv6 flowlabel
      ipv6: do not use RT_TOS for IPv6 flowlabel
      geneve: fix TOS inheriting for ipv4

Maxim Kochetkov (1):
      net: qrtr: start MHI channel after endpoit creation

Miaoqian Lin (2):
      pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map
      Input: exc3000 - fix return value check of wait_for_completion_timeout

Michael Ellerman (1):
      powerpc/pci: Fix get_phb_number() locking

Michael Grzeschik (2):
      usb: gadget: uvc: calculate the number of request depending on framesize
      usb: gadget: uvc: call uvc uvcg_warn on completed status instead of uvcg_info

Michal Simek (1):
      dt-bindings: gpio: zynq: Add missing compatible strings

Miklos Szeredi (1):
      ovl: warn if trusted xattr creation fails

Mikulas Patocka (1):
      rds: add missing barrier to release_refill

Nadav Amit (1):
      x86/kprobes: Fix JNG/JNLE emulation

Nathan Chancellor (1):
      MIPS: tlbex: Explicitly compare _PAGE_NO_EXEC against 0

Naveen Mamindlapalli (1):
      octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration

Neil Armstrong (1):
      spi: meson-spicc: add local pow2 clock ops to preserve rate between messages

Nick Desaulniers (1):
      coresight: etm4x: avoid build failure with unrolled loops

Nikita Travkin (1):
      pinctrl: qcom: msm8916: Allow CAMSS GP clocks to be muxed

Nícolas F. R. A. Prado (1):
      dt-bindings: usb: mtk-xhci: Allow wakeup interrupt-names to be optional

Oded Gabbay (1):
      habanalabs/gaudi: mask constant value before cast

Ofir Bitton (1):
      habanalabs/gaudi: fix shift out of bounds

Oliver Upton (2):
      KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

Ondrej Mosnacek (1):
      kbuild: dummy-tools: avoid tmpdir leak in dummy gcc

Pablo Neira Ayuso (8):
      netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
      netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
      netfilter: nf_tables: possible module reference underflow in error path
      netfilter: nf_tables: really skip inactive sets when allocating name
      netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
      netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
      netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified

Pali Rohár (1):
      PCI: aardvark: Fix reporting Slot capabilities on emulated bridge

Pascal Terjan (1):
      vboxguest: Do not use devm for irq

Pavan Chebbi (1):
      PCI: Add ACS quirk for Broadcom BCM5750x NICs

Pavel Skripkin (1):
      fs/ntfs3: Fix NULL deref in ntfs_update_mftmirr

Peilin Ye (2):
      vsock: Fix memory leak in vsock_connect()
      vsock: Set socket state back to SS_UNCONNECTED in vsock_connect_timeout()

Philipp Zabel (1):
      ASoC: codec: tlv320aic32x4: fix mono playback via I2S

Po-Wen Kao (1):
      scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators

Przemyslaw Patynowski (2):
      iavf: Fix adminq error handling
      iavf: Fix reset error handling

Qifu Zhang (1):
      Documentation: ACPI: EINJ: Fix obsolete example

Randy Dunlap (1):
      m68k: coldfire/device.c: protect FLEXCAN blocks

Ranjani Sridharan (1):
      ASoC: SOF: Intel: hda: Define rom_status_reg in sof_intel_dsp_desc

Ren Zhijie (1):
      scsi: ufs: ufs-mediatek: Fix build error and type mismatch

Robert Marko (1):
      clk: qcom: ipq8074: dont disable gcc_sleep_clk_src

Roberto Sassu (1):
      tools build: Switch to new openssl API for test-libcrypto

Rustam Subkhankulov (1):
      net: dsa: sja1105: fix buffer overflow in sja1105_setup_devlink_regions()

Sagi Grimberg (1):
      nvmet-tcp: fix lockdep complaint on nvmet_tcp_wq flush during queue teardown

Sai Prakash Ranjan (2):
      irqchip/tegra: Fix overflow implicit truncation warnings
      drm/meson: Fix overflow implicit truncation warnings

Sakari Ailus (1):
      ACPI: property: Return type of acpi_add_nondev_subnodes() should be bool

Samuel Holland (2):
      pinctrl: sunxi: Add I/O bias setting for H6 R-PIO
      drm/sun4i: dsi: Prevent underflow when computing packet sizes

Sandor Bodo-Merle (1):
      net: bgmac: Fix a BUG triggered by wrong bytes_compl

Schspa Shi (1):
      vfio: Clear the caps->buf to NULL after free

Sean Christopherson (1):
      KVM: Unconditionally get a ref to /dev/kvm module when creating a VM

Sebastian Würl (1):
      can: mcp251x: Fix race condition on receive interrupt

Sergei Antonov (2):
      net: dsa: mv88e6060: prevent crash on an unused port
      net: moxa: pass pdev instead of ndev to DMA functions

Sergey Senozhatsky (1):
      zram: do not lookup algorithm in backends table

Stafford Horne (1):
      openrisc: io: Define iounmap argument as volatile

Stanimir Varbanov (1):
      venus: pm_helpers: Fix warning in OPP during probe

Stanislaw Kardach (1):
      octeontx2-af: Apply tx nibble fixup always

Steve French (1):
      smb3: check xattr value length earlier

Steven Rostedt (Google) (8):
      tracing/perf: Fix double put of trace event when init fails
      tracing/eprobes: Do not allow eprobes to use $stack, or % for regs
      tracing/eprobes: Do not hardcode $comm as a string
      tracing/eprobes: Have event probes be consistent with kprobes and uprobes
      tracing/probes: Have kprobes and uprobes use $COMM too
      tracing: Have filter accept "common_cpu" to be consistent
      tracing/eprobes: Fix reading of string fields
      selftests/kprobe: Do not test for GRP/ without event failures

Subbaraya Sundeep (2):
      octeontx2-af: Fix mcam entry resource leak
      octeontx2-af: Fix key checking for source mac

Takashi Iwai (6):
      ALSA: usb-audio: More comprehensive mixer map for ASUS ROG Zenith II
      ASoC: SOF: debug: Fix potential buffer overflow by snprintf()
      ASoC: SOF: Intel: hda: Fix potential buffer overflow by snprintf()
      ALSA: core: Add async signal helpers
      ALSA: timer: Use deferred fasync helper
      ALSA: control: Use deferred fasync helper

Tao Jin (1):
      HID: multitouch: new device class fix Lenovo X12 trackpad sticky

Tom Rix (1):
      apparmor: fix aa_label_asxprint return check

Tony Lindgren (1):
      clk: ti: Stop using legacy clkctrl names for omap4 and 5

Trond Myklebust (5):
      NFSv4.1: Don't decrease the value of seq_nr_highest_sent
      NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly
      NFSv4: Fix races in the legacy idmapper upcall
      NFSv4/pnfs: Fix a use-after-free bug in open
      SUNRPC: Reinitialise the backchannel request buffers before reuse

Tzung-Bi Shih (1):
      platform/chrome: cros_ec_proto: don't show MKBP version if unsupported

Uwe Kleine-König (2):
      i2c: imx: Make sure to unregister adapter on remove()
      dmaengine: sprd: Cleanup in .remove() after pm_runtime_get_sync() failed

Vladimir Oltean (2):
      net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
      net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it

Vladimir Zapolskiy (1):
      clk: qcom: clk-alpha-pll: fix clk_trion_pll_configure description

Wentao_Liang (1):
      drivers:md:fix a potential use-after-free bug

Wolfram Sang (1):
      mmc: tmio: avoid glitches when resetting

Xianting Tian (1):
      RISC-V: Add fast call path of crash_kexec()

Xin Xiong (3):
      apparmor: fix reference count leak in aa_pivotroot()
      net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()
      net: fix potential refcount leak in ndisc_router_discovery()

Xiu Jianfeng (1):
      apparmor: Fix memleak in aa_simple_write_to_buffer()

Xuan Zhuo (1):
      virtio_net: fix memory leak inside XPD_TX with mergeable

Yan Lei (1):
      fs/ntfs3: Fix using uninitialized value n when calling indx_read

Ye Bin (1):
      ext4: avoid remove directory when directory is corrupted

Yu Xiao (1):
      nfp: ethtool: fix the display error of `ethtool -m DEVNAME`

Yuanzheng Song (1):
      tools/vm/slabinfo: use alphabetic order when two values are equal

Yunfei Wang (1):
      iommu/io-pgtable-arm-v7s: Add a quirk to allow pgtable PA up to 35bit

Zhang Xianwei (1):
      NFSv4.1: RECLAIM_COMPLETE must handle EACCES

Zhang Xiaoxu (1):
      cifs: Fix memory leak on the deferred close

Zheyu Ma (1):
      video: fbdev: i740fb: Check the argument of i740_calc_vclk()

Zhouyi Zhou (1):
      powerpc/64: Init jump labels before parse_early_param()

Zixuan Fu (1):
      btrfs: unset reloc control if transaction commit fails in prepare_to_relocate()

