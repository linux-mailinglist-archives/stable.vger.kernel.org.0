Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34812414787
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 13:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhIVLQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 07:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235592AbhIVLOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 07:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE877611C9;
        Wed, 22 Sep 2021 11:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632309202;
        bh=1HLTMKTiMbcHZgNesiZhFKnrcnEgAdAR/rxSh87+cyU=;
        h=From:To:Cc:Subject:Date:From;
        b=Jf6JVZdzZR9uIQZFAtqt8j7UEK5ZIb3ORc3hB9yUoyLWMn2F0QA+51tfOqQMltnBP
         vRktcwGef7wkTC/sYR/nCoeVgC/d3bNAzAgEJ0oTWjTEGRb5YyHFs33+yi1QiBCZ46
         Ftpp/LwoToJPvihTwDVjBFPIFV6GUKg9TKtxe8to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.148
Date:   Wed, 22 Sep 2021 13:13:05 +0200
Message-Id: <1632309186117148@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.148 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/devices.txt                      |    6 
 Documentation/devicetree/bindings/arm/tegra.yaml           |    2 
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt        |    2 
 Makefile                                                   |    2 
 arch/arc/mm/cache.c                                        |    2 
 arch/arm/boot/compressed/Makefile                          |    2 
 arch/arm/boot/dts/imx53-ppd.dts                            |   23 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                        |    6 
 arch/arm/boot/dts/tegra20-tamonten.dtsi                    |   14 -
 arch/arm64/boot/dts/freescale/fsl-ls1046a-frwy.dts         |    8 
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts          |    7 
 arch/arm64/boot/dts/nvidia/tegra132.dtsi                   |    4 
 arch/arm64/boot/dts/nvidia/tegra194.dtsi                   |    6 
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts                  |    2 
 arch/arm64/include/asm/kernel-pgtable.h                    |    4 
 arch/arm64/kernel/fpsimd.c                                 |    2 
 arch/arm64/kernel/head.S                                   |   11 -
 arch/m68k/Kconfig.bus                                      |    2 
 arch/mips/mti-malta/malta-dtshim.c                         |    2 
 arch/openrisc/kernel/entry.S                               |    2 
 arch/parisc/kernel/signal.c                                |    6 
 arch/powerpc/configs/mpc885_ads_defconfig                  |    1 
 arch/powerpc/include/asm/pmc.h                             |    7 
 arch/powerpc/kernel/stacktrace.c                           |    1 
 arch/powerpc/kvm/book3s_64_vio_hv.c                        |    9 -
 arch/powerpc/kvm/book3s_hv.c                               |   20 ++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S                    |   36 ++++
 arch/powerpc/perf/hv-gpci.c                                |    2 
 arch/s390/include/asm/setup.h                              |    2 
 arch/s390/kernel/early.c                                   |    4 
 arch/s390/kernel/jump_label.c                              |    2 
 arch/s390/mm/init.c                                        |    2 
 arch/s390/net/bpf_jit_comp.c                               |   67 ++++----
 arch/s390/pci/pci.c                                        |    5 
 arch/x86/mm/init_64.c                                      |    6 
 arch/x86/xen/enlighten_pv.c                                |    7 
 arch/x86/xen/p2m.c                                         |    4 
 arch/xtensa/platforms/iss/console.c                        |   17 +-
 block/bfq-iosched.c                                        |   18 +-
 block/blk-zoned.c                                          |    6 
 block/bsg.c                                                |    5 
 drivers/ata/libata-core.c                                  |    4 
 drivers/ata/sata_dwc_460ex.c                               |   12 -
 drivers/base/power/trace.c                                 |   10 +
 drivers/clk/at91/clk-generated.c                           |   32 ++-
 drivers/clk/at91/dt-compat.c                               |    8 
 drivers/clk/at91/pmc.h                                     |    4 
 drivers/clk/at91/sam9x60.c                                 |   10 -
 drivers/clk/at91/sama5d2.c                                 |   31 +--
 drivers/cpufreq/powernv-cpufreq.c                          |   16 +
 drivers/crypto/mxs-dcp.c                                   |   36 +---
 drivers/dma/imx-sdma.c                                     |   13 -
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                        |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c                    |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c                 |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c             |    2 
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c               |   84 +++++++---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.h               |    1 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   16 -
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   11 -
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c      |    2 
 drivers/gpu/drm/drm_debugfs.c                              |    3 
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c                   |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                      |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c               |    3 
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                      |   43 +++--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                      |    1 
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c                    |    4 
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c                 |    8 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                      |    1 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                      |    4 
 drivers/gpu/drm/exynos/exynos_drm_dma.c                    |    2 
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c                   |   17 --
 drivers/gpu/drm/panfrost/panfrost_mmu.c                    |   31 +--
 drivers/gpu/drm/panfrost/panfrost_regs.h                   |    2 
 drivers/hid/hid-input.c                                    |    2 
 drivers/hid/i2c-hid/i2c-hid-core.c                         |    5 
 drivers/iio/dac/ad5624r_spi.c                              |   18 ++
 drivers/infiniband/core/iwcm.c                             |   19 +-
 drivers/infiniband/hw/efa/efa_verbs.c                      |    1 
 drivers/infiniband/hw/hfi1/init.c                          |    7 
 drivers/md/dm-crypt.c                                      |    7 
 drivers/media/dvb-frontends/dib8000.c                      |   58 ++++--
 drivers/media/i2c/imx258.c                                 |    4 
 drivers/media/i2c/tda1997x.c                               |    5 
 drivers/media/platform/tegra-cec/tegra_cec.c               |   10 -
 drivers/media/rc/rc-loopback.c                             |    2 
 drivers/media/usb/uvc/uvc_v4l2.c                           |   34 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c                  |    4 
 drivers/mfd/ab8500-core.c                                  |    2 
 drivers/mfd/axp20x.c                                       |    3 
 drivers/mfd/db8500-prcmu.c                                 |   14 -
 drivers/mfd/stmpe.c                                        |    4 
 drivers/mfd/tc3589x.c                                      |    2 
 drivers/mfd/tqmx86.c                                       |    2 
 drivers/mfd/wm8994-irq.c                                   |    2 
 drivers/misc/vmw_vmci/vmci_queue_pair.c                    |    6 
 drivers/mmc/core/block.c                                   |    3 
 drivers/mmc/host/rtsx_pci_sdmmc.c                          |   36 ++--
 drivers/mmc/host/sdhci-of-arasan.c                         |   18 +-
 drivers/mtd/nand/raw/cafe_nand.c                           |    4 
 drivers/net/bonding/bond_main.c                            |    3 
 drivers/net/dsa/b53/b53_common.c                           |    3 
 drivers/net/dsa/lantiq_gswip.c                             |    3 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c          |    2 
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                  |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c            |    8 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   19 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                         |    8 
 drivers/net/ethernet/intel/iavf/iavf_main.c                |   58 ++++++
 drivers/net/ethernet/intel/igc/igc_main.c                  |    9 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c              |    8 
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |    3 
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c          |    5 
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c |    1 
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                  |    6 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c           |    1 
 drivers/net/ethernet/rdc/r6040.c                           |    9 -
 drivers/net/ethernet/renesas/sh_eth.c                      |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c        |   18 --
 drivers/net/ethernet/wiznet/w5100.c                        |    2 
 drivers/net/phy/dp83640_reg.h                              |    2 
 drivers/net/usb/cdc_mbim.c                                 |    5 
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c             |    3 
 drivers/net/wireless/ath/ath9k/hw.c                        |   12 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c          |    4 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c          |    8 
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c               |   24 ++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c               |   30 ++-
 drivers/ntb/test/ntb_msi_test.c                            |    4 
 drivers/ntb/test/ntb_perf.c                                |    1 
 drivers/nvme/host/tcp.c                                    |   14 -
 drivers/of/kobj.c                                          |    2 
 drivers/opp/of.c                                           |   12 -
 drivers/parport/ieee1284_ops.c                             |    2 
 drivers/pci/controller/pci-aardvark.c                      |   73 +++++++-
 drivers/pci/controller/pcie-xilinx-nwl.c                   |   12 +
 drivers/pci/hotplug/TODO                                   |    3 
 drivers/pci/hotplug/ibmphp_ebda.c                          |    5 
 drivers/pci/msi.c                                          |    3 
 drivers/pci/pci.c                                          |    8 
 drivers/pci/pcie/portdrv_core.c                            |    9 -
 drivers/pci/quirks.c                                       |   59 ++++++-
 drivers/pci/syscall.c                                      |    4 
 drivers/pinctrl/pinctrl-ingenic.c                          |    6 
 drivers/pinctrl/pinctrl-single.c                           |    1 
 drivers/pinctrl/pinctrl-stmfx.c                            |    6 
 drivers/pinctrl/samsung/pinctrl-samsung.c                  |    2 
 drivers/platform/chrome/cros_ec_proto.c                    |    9 +
 drivers/platform/x86/dell-smbios-wmi.c                     |    1 
 drivers/power/supply/max17042_battery.c                    |    6 
 drivers/rtc/rtc-tps65910.c                                 |    2 
 drivers/s390/char/sclp_early.c                             |    3 
 drivers/scsi/BusLogic.c                                    |    4 
 drivers/scsi/pcmcia/fdomain_cs.c                           |    4 
 drivers/scsi/qedf/qedf_main.c                              |   10 -
 drivers/scsi/qedi/qedi_main.c                              |   14 -
 drivers/scsi/qla2xxx/qla_nvme.c                            |    5 
 drivers/scsi/qla2xxx/qla_os.c                              |    6 
 drivers/scsi/smartpqi/smartpqi_init.c                      |    1 
 drivers/soc/aspeed/aspeed-lpc-ctrl.c                       |    2 
 drivers/soc/aspeed/aspeed-p2a-ctrl.c                       |    2 
 drivers/soc/qcom/qcom_aoss.c                               |    8 
 drivers/staging/board/board.c                              |    7 
 drivers/staging/ks7010/ks7010_sdio.c                       |    2 
 drivers/staging/rts5208/rtsx_scsi.c                        |   10 -
 drivers/target/target_core_xcopy.c                         |   96 +++--------
 drivers/target/target_core_xcopy.h                         |    1 
 drivers/tty/hvc/hvsi.c                                     |   19 +-
 drivers/tty/serial/8250/8250_pci.c                         |    2 
 drivers/tty/serial/8250/8250_port.c                        |    3 
 drivers/tty/serial/jsm/jsm_neo.c                           |    2 
 drivers/tty/serial/jsm/jsm_tty.c                           |    3 
 drivers/tty/serial/sh-sci.c                                |    7 
 drivers/usb/chipidea/host.c                                |   14 +
 drivers/usb/gadget/composite.c                             |    8 
 drivers/usb/gadget/function/u_ether.c                      |    5 
 drivers/usb/host/ehci-mv.c                                 |   23 +-
 drivers/usb/host/fotg210-hcd.c                             |   41 ++--
 drivers/usb/host/fotg210.h                                 |    5 
 drivers/usb/host/xhci.c                                    |   24 +-
 drivers/usb/musb/musb_dsps.c                               |   13 -
 drivers/usb/usbip/vhci_hcd.c                               |   32 +++
 drivers/vfio/Kconfig                                       |    2 
 drivers/vhost/net.c                                        |   11 +
 drivers/video/fbdev/asiliantfb.c                           |    3 
 drivers/video/fbdev/kyro/fbdev.c                           |    8 
 drivers/video/fbdev/riva/fbdev.c                           |    3 
 fs/btrfs/disk-io.c                                         |   45 ++---
 fs/btrfs/inode.c                                           |   10 -
 fs/btrfs/tree-log.c                                        |    4 
 fs/btrfs/volumes.c                                         |    3 
 fs/cifs/sess.c                                             |    2 
 fs/f2fs/checkpoint.c                                       |    2 
 fs/f2fs/data.c                                             |   23 ++
 fs/f2fs/dir.c                                              |   15 +
 fs/f2fs/f2fs.h                                             |   24 +-
 fs/f2fs/file.c                                             |    6 
 fs/f2fs/gc.c                                               |    6 
 fs/f2fs/inode.c                                            |    2 
 fs/f2fs/node.c                                             |    2 
 fs/f2fs/segment.c                                          |    9 -
 fs/f2fs/super.c                                            |   84 +++++-----
 fs/fscache/cookie.c                                        |   14 -
 fs/fscache/internal.h                                      |    2 
 fs/fscache/main.c                                          |   39 ++++
 fs/fuse/dev.c                                              |    4 
 fs/gfs2/lock_dlm.c                                         |    5 
 fs/lockd/svclock.c                                         |   30 +--
 fs/overlayfs/dir.c                                         |    6 
 fs/userfaultfd.c                                           |   93 +++++------
 include/crypto/public_key.h                                |    4 
 include/linux/hugetlb.h                                    |    9 +
 include/linux/list.h                                       |   29 ++-
 include/linux/memory_hotplug.h                             |    4 
 include/linux/pci.h                                        |    5 
 include/linux/pci_ids.h                                    |    3 
 include/linux/skbuff.h                                     |    2 
 include/linux/sunrpc/xprt.h                                |    1 
 include/uapi/linux/pkt_sched.h                             |    2 
 include/uapi/linux/serial_reg.h                            |    1 
 kernel/dma/debug.c                                         |    7 
 kernel/events/core.c                                       |    2 
 kernel/fork.c                                              |    1 
 kernel/pid_namespace.c                                     |    3 
 kernel/trace/trace_kprobe.c                                |    6 
 kernel/trace/trace_probe.c                                 |   25 +++
 kernel/trace/trace_probe.h                                 |    1 
 kernel/trace/trace_uprobe.c                                |    6 
 kernel/workqueue.c                                         |   12 -
 lib/test_bpf.c                                             |   13 +
 lib/test_stackinit.c                                       |   20 --
 mm/memory_hotplug.c                                        |    4 
 mm/vmscan.c                                                |    2 
 net/9p/trans_xen.c                                         |    4 
 net/bluetooth/hci_event.c                                  |  108 +++++++++----
 net/bluetooth/sco.c                                        |   74 +++++---
 net/caif/chnl_net.c                                        |   19 --
 net/core/flow_dissector.c                                  |   12 -
 net/dccp/minisocks.c                                       |    2 
 net/dsa/slave.c                                            |   12 -
 net/ipv4/ip_gre.c                                          |    9 -
 net/ipv4/ip_output.c                                       |    5 
 net/ipv4/nexthop.c                                         |    2 
 net/ipv4/tcp_fastopen.c                                    |    3 
 net/ipv4/tcp_input.c                                       |    2 
 net/ipv6/netfilter/nf_socket_ipv6.c                        |    4 
 net/l2tp/l2tp_core.c                                       |    4 
 net/mac80211/iface.c                                       |   11 +
 net/netlabel/netlabel_cipso_v4.c                           |    4 
 net/netlink/af_netlink.c                                   |    4 
 net/sched/sch_fq_codel.c                                   |   12 +
 net/sched/sch_taprio.c                                     |    4 
 net/sunrpc/auth_gss/svcauth_gss.c                          |    2 
 net/sunrpc/xprt.c                                          |    6 
 net/tipc/socket.c                                          |   36 +++-
 net/unix/af_unix.c                                         |    2 
 samples/bpf/test_override_return.sh                        |    1 
 samples/bpf/tracex7_user.c                                 |    5 
 scripts/gen_ksymdeps.sh                                    |    8 
 security/smack/smack_access.c                              |   17 --
 sound/soc/atmel/Kconfig                                    |    1 
 sound/soc/intel/boards/bytcr_rt5640.c                      |    9 -
 sound/soc/intel/skylake/skl-messages.c                     |   11 +
 sound/soc/intel/skylake/skl-pcm.c                          |   25 +--
 sound/soc/rockchip/rockchip_i2s.c                          |   35 ++--
 tools/perf/Makefile.config                                 |    8 
 tools/perf/util/machine.c                                  |    1 
 tools/testing/selftests/bpf/progs/xdp_tx.c                 |    2 
 tools/testing/selftests/bpf/test_maps.c                    |    2 
 tools/testing/selftests/bpf/test_xdp_veth.sh               |    2 
 tools/thermal/tmon/Makefile                                |    2 
 virt/kvm/arm/arm.c                                         |    8 
 274 files changed, 1902 insertions(+), 1108 deletions(-)

Adrian Bunk (1):
      bnx2x: Fix enabling network interfaces without VFs

Alexander Egorenkov (1):
      s390/sclp: fix Secure-IPL facility detection

Alexey Kardashevskiy (1):
      KVM: PPC: Fix clearing never mapped TCEs in realmode

Alyssa Rosenzweig (3):
      drm/panfrost: Simplify lock_region calculation
      drm/panfrost: Use u64 for size in lock_region
      drm/panfrost: Clamp lock region to Bifrost minimum

Anand Jain (1):
      btrfs: fix upper limit for max_inline for page size 64K

Andreas Obergschwandtner (1):
      ARM: tegra: tamonten: Fix UART pad setting

Andrey Grodzovsky (1):
      drm/amdgpu: Fix BUG_ON assert

Andy Shevchenko (3):
      include/linux/list.h: add a macro to test if entry is pointing to the head
      ata: sata_dwc_460ex: No need to call phy_exit() befre phy_init()
      PCI: Sync __pci_register_driver() stub for CONFIG_PCI=n

Anirudh Rayabharam (1):
      usbip: give back URBs for unsent unlink requests during cleanup

Anson Jacob (1):
      drm/amd/amdgpu: Update debugfs link_settings output link_rate field in hex

Anthony Iliopoulos (1):
      dma-debug: fix debugfs initialization order

Arnd Bergmann (1):
      m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch

Arne Welzel (1):
      dm crypt: Avoid percpu_counter spinlock contention in crypt_page_alloc()

Baptiste Lepers (1):
      events: Reuse value read using READ_ONCE instead of re-reading it

Benjamin Hesmans (1):
      netfilter: socket: icmp6: fix use-after-scope

Bob Peterson (1):
      gfs2: Don't call dlm after protocol is unmounted

Cezary Rojewski (1):
      ASoC: Intel: Skylake: Fix module configuration for KPB and MIXER

Chao Yu (5):
      f2fs: quota: fix potential deadlock
      f2fs: show f2fs instance in printk_ratelimited
      f2fs: fix to account missing .skipped_gc_rwsem
      f2fs: fix unexpected ENOENT comes from f2fs_map_blocks()
      f2fs: fix to unmap pages from userspace process in punch_hole()

Christoph Hellwig (1):
      scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND

Christophe JAILLET (2):
      staging: ks7010: Fix the initialization of the 'sleep_status' structure
      mtd: rawnand: cafe: Fix a resource leak in the error handling path of 'cafe_nand_probe()'

Claudiu Beznea (1):
      clk: at91: clk-generated: pass the id of changeable parent at registration

Codrin Ciubotariu (2):
      clk: at91: sam9x60: Don't use audio PLL
      clk: at91: clk-generated: Limit the requested rate to our range

Colin Ian King (1):
      parport: remove non-zero check on count

Damien Le Moal (1):
      block: bfq: fix bfq_set_next_ioprio_data()

Dan Carpenter (4):
      scsi: smartpqi: Fix an error code in pqi_get_raid_map()
      scsi: qedi: Fix error codes in qedi_alloc_global_queues()
      scsi: qedf: Fix error codes in qedf_alloc_global_queues()
      PCI: Fix pci_dev_str_match_path() alloc while atomic bug

Daniele Palmas (1):
      net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920

David Disseldorp (1):
      scsi: target: avoid per-loop XCOPY buffer allocations

David Heidelberg (5):
      ARM: 9105/1: atags_to_fdt: don't warn about stack size
      ARM: dts: qcom: apq8064: correct clock names
      drm/msm: mdp4: drop vblank get/put from prepare/complete_commit
      drm/msi/mdp4: populate priv->kms in mdp4_kms_init
      dt-bindings: arm: Fix Toradex compatible typo

David Hildenbrand (1):
      mm/memory_hotplug: use "unsigned long" for PFN in zone_for_pfn_range()

David Howells (1):
      fscache: Fix cookie key hashing

Desmond Cheong Zhi Xi (5):
      btrfs: reset replace target device to allocation state on close
      drm: avoid blocking in drm_clients_info's rcu section
      Bluetooth: skip invalid hci_sync_conn_complete_evt
      Bluetooth: schedule SCO timeouts with delayed_work
      Bluetooth: avoid circular locks in sco_sock_connect

Ding Hui (1):
      cifs: fix wrong release in sess_alloc_buffer() failed path

Dinghao Liu (1):
      qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom

Dmitry Osipenko (1):
      rtc: tps65910: Correct driver module alias

Dmitry Torokhov (1):
      HID: input: do not report stylus battery state as "full"

Eran Ben Elisha (1):
      net/mlx5: Fix variable type to match 64bit

Eric Dumazet (3):
      net-caif: avoid user-triggerable WARN_ON(1)
      net/af_unix: fix a data-race in unix_dgram_poll
      fq_codel: reject silly quantum parameters

Ernst Sjöstrand (1):
      drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10

Evan Quan (1):
      PCI: Add AMD GPU multi-function power dependencies

Evan Wang (1):
      PCI: aardvark: Fix checking for PIO status

Evgeny Novikov (2):
      USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()
      media: tegra-cec: Handle errors of clk_prepare_enable()

Florian Fainelli (1):
      r6040: Restore MDIO clock frequency after MAC reset

Geert Uytterhoeven (1):
      staging: board: Fix uninitialized spinlock when attaching genpd

George Cherian (1):
      PCI: Add ACS quirks for Cavium multi-function devices

Greg Kroah-Hartman (2):
      serial: 8250_pci: make setup_port() parameters explicitly unsigned
      Linux 5.4.148

Gustavo A. R. Silva (2):
      ipv4: ip_output.c: Fix out-of-bounds warning in ip_copy_addrs()
      flow_dissector: Fix out-of-bounds warnings

Gustaw Lewandowski (1):
      ASoC: Intel: Skylake: Fix passing loadable flag for module

Haimin Zhang (1):
      fix array-index-out-of-bounds in taprio_change

Halil Pasic (1):
      s390/pv: fix the forcing of the swiotlb

Hans Verkuil (1):
      media: v4l2-dv-timings.c: fix wrong condition in two for-loops

Hans de Goede (4):
      libata: add ATA_HORKAGE_NO_NCQ_TRIM for Samsung 860 and 870 SSDs
      platform/x86: dell-smbios-wmi: Add missing kfree in error-exit from run_smbios_call
      ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output
      mfd: axp20x: Update AXP288 volatile ranges

Harshvardhan Jha (1):
      9p/xen: Fix end of loop tests for list_for_each_entry

Heiko Carstens (1):
      s390/jump_label: print real address in a case of a jump label bug

Hoang Le (1):
      tipc: increase timeout in tipc_sk_enqueue()

Hyun Kwon (1):
      PCI: xilinx-nwl: Enable the clock through CCF

Ilya Leoshkevich (2):
      s390/bpf: Fix optimizing out zero-extensions
      s390/bpf: Fix 64-bit subtraction of the -0x80000000 constant

Iwona Winiarska (2):
      soc: aspeed: lpc-ctrl: Fix boundary check for mmap
      soc: aspeed: p2a-ctrl: Fix boundary check for mmap

J. Bruce Fields (2):
      rpc: fix gss_svc_init cleanup on failure
      lockd: lockd server-side shouldn't set fl_ops

Jack Pham (1):
      usb: gadget: composite: Allow bMaxPower=0 if self-powered

Jaehyoung Choi (1):
      pinctrl: samsung: Fix pinctrl bank pin count

Jan Hoffmann (1):
      net: dsa: lantiq_gswip: fix maximum frame length

Jason Gunthorpe (1):
      vfio: Use config not menuconfig for VFIO_NOIOMMU

Jiaran Zhang (1):
      net: hns3: fix the timing issue of VF clearing interrupt sources

Jim Broadus (1):
      HID: i2c-hid: Fix Elan touchpad regression

Jiri Slaby (2):
      xtensa: ISS: don't panic in rs_init
      hvsi: don't panic on tty_register_driver failure

Joel Stanley (1):
      powerpc/config: Renable MTD_PHYSMAP_OF

Johan Almbladh (3):
      bpf/tests: Fix copy-and-paste error in double word test
      bpf/tests: Do not PASS tests without actually testing the result
      mac80211: Fix monitor MTU limit so that A-MSDUs get through

Johannes Berg (2):
      iwlwifi: mvm: avoid static queue number aliasing
      iwlwifi: mvm: fix access to BSS elements

Jonathan Cameron (1):
      iio: dac: ad5624r: Fix incorrect handling of an optional regulator.

Josef Bacik (1):
      btrfs: wake up async_delalloc_pages waiters after submit

Juergen Gross (3):
      xen: fix setting of max_pfn in shared_info
      xen: reset legacy rtc flag for PV domU
      PM: base: power: don't try to use non-existing RTC for storing data

Juhee Kang (1):
      samples: bpf: Fix tracex7 error raised on the missing argument

Jussi Maki (1):
      selftests/bpf: Fix xdp_tx.c prog section name

Kajol Jain (1):
      powerpc/perf/hv-gpci: Fix counter value parsing

Kees Cook (2):
      staging: rts5208: Fix get_ms_information() heap buffer size
      lib/test_stackinit: Fix static initializer test

Kelly Devilliv (2):
      usb: host: fotg210: fix the endpoint's transactional opportunities calculation
      usb: host: fotg210: fix the actual_length of an iso packet

Krzysztof Hałasa (1):
      media: TDA1997x: fix tda1997x_query_dv_timings() return value

Krzysztof Kozlowski (1):
      power: supply: max17042: handle fails of reading status register

Krzysztof Wilczyński (1):
      PCI: Return ~0 data on pciconfig_read() CAP_SYS_ADMIN failure

Laurent Pinchart (1):
      media: imx258: Rectify mismatch of VTS value

Leon Romanovsky (3):
      RDMA/iwcm: Release resources if iw_cm module initialization fails
      docs: Fix infiniband uverbs minor number
      RDMA/efa: Remove double QP type assignment

Li Huafei (1):
      perf unwind: Do not overwrite FEATURE_CHECK_LDFLAGS-libunwind-{x86,aarch64}

Li Jun (1):
      usb: chipidea: host: fix port index underflow and UBSAN complains

Li Zhijian (1):
      selftests/bpf: Enlarge select() timeout for test_maps

Lin, Zhenpeng (1):
      dccp: don't duplicate ccid when cloning dccp sock

Linus Walleij (1):
      mfd: db8500-prcmu: Adjust map to reality

Liu Zixian (1):
      mm/hugetlb: initialize hugetlb_usage in mm_init

Luben Tuikov (1):
      drm/amdgpu: Fix amdgpu_ras_eeprom_init()

Lucas Stach (8):
      drm/etnaviv: return context from etnaviv_iommu_context_get
      drm/etnaviv: put submit prev MMU context when it exists
      drm/etnaviv: stop abusing mmu_context as FE running marker
      drm/etnaviv: keep MMU context across runtime suspend/resume
      drm/etnaviv: exec and MMU state is lost when resetting the GPU
      drm/etnaviv: fix MMU context leak on GPU reset
      drm/etnaviv: reference MMU context when setting up hardware state
      drm/etnaviv: add missing MMU context put when reaping MMU mapping

Luiz Augusto von Dentz (1):
      Bluetooth: Fix handling of LE Enhanced Connection Complete

Luke Hsiao (1):
      tcp: enable data-less, empty-cookie SYN with TFO_SERVER_COOKIE_NOT_REQD

Maciej W. Rozycki (2):
      serial: 8250: Define RX trigger levels for OxSemi 950 devices
      scsi: BusLogic: Fix missing pr_cont() use

Maciej Żenczykowski (1):
      usb: gadget: u_ether: fix a potential null pointer dereference

Manish Narani (1):
      mmc: sdhci-of-arasan: Check return value of non-void funtions

Manivannan Sadhasivam (1):
      soc: qcom: aoss: Fix the out of bound usage of cooling_devs

Maor Gottlieb (1):
      net/mlx5: Fix potential sleeping in atomic context

Marc Zyngier (3):
      pinctrl: stmfx: Fix hazardous u8[] to unsigned long cast
      of: Don't allow __of_attached_node_sysfs() without CONFIG_SYSFS
      mfd: Don't use irq_create_mapping() to resolve a mapping

Marcos Paulo de Souza (1):
      btrfs: tree-log: check btrfs_lookup_data_extent return value

Marek Behún (1):
      PCI: Restrict ASMedia ASM1062 SATA Max Payload Size Supported

Marek Marczykowski-Górecki (1):
      PCI/MSI: Skip masking MSI-X on Xen PV

Mark Brown (1):
      arm64/sve: Use correct size when reinitialising SVE state

Mark Rutland (1):
      arm64: head: avoid over-mapping in map_memory

Masahiro Yamada (1):
      kbuild: Fix 'no symbols' warning when CONFIG_TRIM_UNUSD_KSYMS=y

Masami Hiramatsu (1):
      tracing/probes: Reject events which have the same name of existing one

Mathias Nyman (1):
      Revert "USB: xhci: fix U1/U2 handling for hardware with XHCI_INTEL_HOST quirk set"

Matthias Schiffer (1):
      mfd: tqmx86: Clear GPIO IRQ resource when no IRQ is set

Mauro Carvalho Chehab (2):
      media: uvc: don't do DMA on stack
      media: dib8000: rewrite the init prbs logic

Miaoqing Pan (1):
      ath9k: fix sleeping in atomic context

Michael Petlan (1):
      perf machine: Initialize srcline string member in add_location struct

Michal Suchanek (1):
      powerpc/stacktrace: Include linux/delay.h

Mike Marciniszyn (1):
      IB/hfi1: Adjust pkey entry in index 0

Mike Rapoport (1):
      x86/mm: Fix kern_addr_valid() to cope with existing but not present entries

Miklos Szeredi (1):
      fuse: fix use after free in fuse_read_interrupt()

Mikulas Patocka (1):
      parisc: fix crash with signals and alloca

Miquel Raynal (1):
      dt-bindings: mtd: gpmc: Fix the ECC bytes vs. OOB bytes equation

Nadav Amit (1):
      userfaultfd: prevent concurrent API initialization

Nadezda Lutovinova (1):
      usb: musb: musb_dsps: request_irq() after initializing musb

Nathan Chancellor (2):
      net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()
      drm/exynos: Always initialize mapping in exynos_drm_register_dma()

Nicholas Piggin (2):
      KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live
      KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers

Niklas Cassel (2):
      blk-zoned: allow zone management send operations without CAP_SYS_ADMIN
      blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN

Niklas Schnelle (1):
      s390: make PCI mio support a machine flag

Nishad Kamdar (1):
      mmc: core: Return correct emmc response in case of ioctl error

Oleksij Rempel (1):
      MIPS: Malta: fix alignment of the devicetree buffer

Oliver Logush (1):
      drm/amd/display: Fix timer_per_pixel unit error

Oliver Upton (1):
      KVM: arm64: Handle PSCI resets before userspace touches vCPU state

Pali Rohár (2):
      PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response
      PCI: aardvark: Fix masking and unmasking legacy INTx interrupts

Paolo Abeni (1):
      vhost_net: fix OoB on sendmsg() failure.

Paolo Valente (1):
      block, bfq: honor already-setup queue merges

Patryk Duda (1):
      platform/chrome: cros_ec_proto: Send command again when timeout occurs

Paul Cercueil (1):
      pinctrl: ingenic: Fix incorrect pull up/down info

Pratik R. Sampat (1):
      cpufreq: powernv: Fix init_chip_info initialization in numa=off

Raag Jadav (1):
      arm64: dts: ls1046a: fix eeprom entries

Rafael J. Wysocki (1):
      PCI: Use pci_update_current_state() in pci_enable_device_flags()

Rafał Miłecki (1):
      net: dsa: b53: Fix calculating number of switch ports

Rajendra Nayak (1):
      opp: Don't print an error if required-opps is missing

Randy Dunlap (4):
      openrisc: don't printk() unconditionally
      ASoC: atmel: ATMEL drivers don't need HAS_DMA
      ptp: dp83640: don't define PAGE0
      ARC: export clear_user_page() for modules

Rik van Riel (1):
      mm,vmscan: fix divide by zero in get_scan_count

Robin Gong (2):
      Revert "dmaengine: imx-sdma: refine to load context only once"
      dmaengine: imx-sdma: remove duplicated sdma_load_context

Rolf Eike Beer (1):
      tools/thermal/tmon: Add cross compiling support

Ryoga Saito (1):
      Set fc_nlinfo in nh_create_ipv4, nh_create_ipv6

Saeed Mahameed (1):
      net/mlx5: FWTrace, cancel work on alloc pd error flow

Sagi Grimberg (1):
      nvme-tcp: don't check blk_mq_tag_to_rq when receiving pdu data

Sasha Neftin (1):
      igc: Check if num of q_vectors is smaller than max before array access

Saurav Kashyap (2):
      scsi: qla2xxx: Changes to support kdump kernel
      scsi: qla2xxx: Sync queue idx with queue_pair_map idx

Sean Anderson (1):
      crypto: mxs-dcp - Use sg_mapping_iter to copy data

Sean Keely (1):
      drm/amdkfd: Account for SH/SE count when setting up cu masks.

Sean Young (1):
      media: rc-loopback: return number of emitters rather than error

Sebastian Reichel (1):
      ARM: dts: imx53-ppd: Fix ACHC entry

Shai Malin (1):
      qed: Handle management FW error

Shuah Khan (1):
      usbip:vhci_hcd USB port can get stuck in the disabled state

Stefan Assmann (2):
      iavf: do not override the adapter state in the watchdog task
      iavf: fix locking of critical sections

Stuart Hayes (1):
      PCI/portdrv: Enable Bandwidth Notification only if port supports it

Sugar Zhang (1):
      ASoC: rockchip: i2s: Fix regmap_ops hang

Sukadev Bhattiprolu (1):
      ibmvnic: check failover_pending in login response

Thierry Reding (1):
      arm64: tegra: Fix compatible string for Tegra132 CPUs

Thomas Hebb (1):
      mmc: rtsx_pci: Fix long reads when clock is prescaled

Tianjia Zhang (1):
      Smack: Fix wrong semantics in smk_access_entry()

Trond Myklebust (1):
      SUNRPC: Fix potential memory corruption

Tuo Li (2):
      gpu: drm: amd: amdgpu: amdgpu_i2c: fix possible uninitialized-variable access in amdgpu_i2c_router_select_ddc_port()
      drm/display: fix possible null-pointer dereference in dcn10_set_clock()

Ulrich Hecht (1):
      serial: sh-sci: fix break handling for sysrq

Umang Jain (1):
      media: imx258: Limit the max analogue gain to 480

Vasily Averin (1):
      memcg: enable accounting for pids in nested pid namespaces

Vidya Sagar (1):
      arm64: tegra: Fix Tegra194 PCIe EP compatible string

Vinod Koul (1):
      arm64: dts: qcom: sdm660: use reg value for memory node

Vishal Aslot (1):
      PCI: ibmphp: Fix double unmap of io_mem

Vladimir Oltean (1):
      net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup

Wang Hai (1):
      VMCI: fix NULL pointer dereference when unmapping queue pair

Wasim Khan (1):
      PCI: Add ACS quirks for NXP LX2xx0 and LX2xx2 platforms

Wei Li (1):
      scsi: fdomain: Fix error return code in fdomain_probe()

Willem de Bruijn (1):
      ip_gre: validate csum_start only on pull

Xiaotan Luo (1):
      ASoC: rockchip: i2s: Fixup config for DAIFMT_DSP_A/B

Xin Long (2):
      tipc: keep the skb in rcv queue until the whole data is read
      tipc: fix an use-after-free issue in tipc_recvmsg

Xiyu Yang (1):
      net/l2tp: Fix reference count leak in l2tp_udp_recv_core

Yajun Deng (1):
      netlink: Deal with ESRCH error in nlmsg_notify()

Yang Li (3):
      ethtool: Fix an error code in cxgb2.c
      NTB: Fix an error code in ntb_msit_probe()
      NTB: perf: Fix an error code in perf_setup_inbuf()

Yang Yingliang (1):
      net: w5100: check return value after calling platform_get_resource()

Yangtao Li (1):
      f2fs: reduce the scope of setting fsck tag when de->name_len is zero

Yevgeny Kliteynik (1):
      net/mlx5: DR, Enable QP retransmission

Yoshihiro Shimoda (1):
      net: renesas: sh_eth: Fix freeing wrong tx descriptor

Yufeng Mo (4):
      bonding: 3ad: fix the concurrency between __bond_release_one() and bond_3ad_state_machine_handler()
      net: hns3: pad the short tunnel frame before sending to hardware
      net: hns3: change affinity_mask to numa node range
      net: hns3: disable mac in flr process

Zekun Shen (1):
      ath9k: fix OOB read ar9300_eeprom_restore_internal

Zhang Qilong (1):
      iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed

Zhen Lei (2):
      pinctrl: single: Fix error return code in pcs_parse_bits_in_pinctrl_entry()
      workqueue: Fix possible memory leaks in wq_numa_init()

Zheyu Ma (5):
      video: fbdev: kyro: fix a DoS bug by restricting user input
      tty: serial: jsm: hold port lock when reporting modem line changes
      video: fbdev: asiliantfb: Error out if 'pixclock' equals zero
      video: fbdev: kyro: Error out if 'pixclock' equals zero
      video: fbdev: riva: Error out if 'pixclock' equals zero

chenying (1):
      ovl: fix BUG_ON() in may_delete() when called from ovl_cleanup()

zhenggy (1):
      tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()

zhenwei pi (1):
      crypto: public_key: fix overflow during implicit conversion

王贇 (1):
      net: fix NULL pointer reference in cipso_v4_doi_free

