Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67D9470A9
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFOPJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOPJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 11:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E738720866;
        Sat, 15 Jun 2019 15:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560611357;
        bh=jJspYyioBX0I0E5S3kVURJgOCwlUEYq1y7D2nQTZDq8=;
        h=Date:From:To:Cc:Subject:From;
        b=1DMRi45mGU2UIDyI3tNauaSNB4CrEE/2NbhmuXWXwEZ6+g7booaSk5YpPA9+bZLGv
         Q9qdLIfsVeu2+pvI6927lSNMgFAvICAvsBXj76jECg0aa3uGQ5bpQrC71dy4XRuFhG
         +GnXL3rf1QCfKwVswD9LmP+EtbRVeJoANvReuNF8=
Date:   Sat, 15 Jun 2019 17:09:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.10
Message-ID: <20190615150914.GA2174@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.10 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/input/touchscreen/goodix.txt |    1=20
 Makefile                                                       |    2=20
 arch/arm/boot/dts/exynos5420-arndale-octa.dts                  |    2=20
 arch/arm/boot/dts/imx50.dtsi                                   |    2=20
 arch/arm/boot/dts/imx51.dtsi                                   |    2=20
 arch/arm/boot/dts/imx53.dtsi                                   |    2=20
 arch/arm/boot/dts/imx6qdl.dtsi                                 |    2=20
 arch/arm/boot/dts/imx6sl.dtsi                                  |    2=20
 arch/arm/boot/dts/imx6sll.dtsi                                 |    2=20
 arch/arm/boot/dts/imx6sx.dtsi                                  |    2=20
 arch/arm/boot/dts/imx6ul.dtsi                                  |    2=20
 arch/arm/boot/dts/imx7s.dtsi                                   |    4=20
 arch/arm/include/asm/hardirq.h                                 |    1=20
 arch/arm/kernel/smp.c                                          |    6=20
 arch/arm/mach-exynos/suspend.c                                 |   19 +
 arch/arm/mach-omap2/pm33xx-core.c                              |    8=20
 arch/arm/mach-shmobile/regulator-quirk-rcar-gen2.c             |    6=20
 arch/arm64/boot/dts/freescale/imx8mq.dtsi                      |    2=20
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi                       |   28 +-
 arch/arm64/configs/defconfig                                   |    6=20
 arch/mips/kernel/prom.c                                        |   14 +
 arch/powerpc/include/asm/drmem.h                               |   21 +
 arch/powerpc/mm/drmem.c                                        |    6=20
 arch/powerpc/platforms/pseries/hotplug-memory.c                |   17 -
 arch/um/kernel/time.c                                          |    2=20
 arch/x86/events/intel/core.c                                   |    2=20
 arch/x86/pci/irq.c                                             |   10=20
 block/bfq-iosched.c                                            |    2=20
 block/blk-core.c                                               |    1=20
 block/blk-mq.c                                                 |    2=20
 drivers/clk/rockchip/clk-rk3288.c                              |   11=20
 drivers/dma/idma64.c                                           |    6=20
 drivers/dma/idma64.h                                           |    2=20
 drivers/edac/Kconfig                                           |    4=20
 drivers/gpio/gpio-omap.c                                       |   53 ++--
 drivers/gpio/gpio-vf610.c                                      |   26 --
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                  |    9=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c               |    6=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c      |    2=20
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c                   |    6=20
 drivers/gpu/drm/drm_ioctl.c                                    |   20 -
 drivers/gpu/drm/msm/msm_gem.c                                  |    3=20
 drivers/gpu/drm/nouveau/Kconfig                                |   13 -
 drivers/gpu/drm/nouveau/dispnv50/disp.h                        |    1=20
 drivers/gpu/drm/nouveau/dispnv50/head.c                        |    3=20
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c                    |    1=20
 drivers/gpu/drm/nouveau/dispnv50/wndw.c                        |    2=20
 drivers/gpu/drm/nouveau/nouveau_drm.c                          |    7=20
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c                  |   11=20
 drivers/gpu/drm/pl111/pl111_display.c                          |    5=20
 drivers/input/touchscreen/goodix.c                             |    2=20
 drivers/iommu/arm-smmu-v3.c                                    |   10=20
 drivers/iommu/intel-iommu.c                                    |   19 +
 drivers/mailbox/stm32-ipcc.c                                   |   13 -
 drivers/media/platform/atmel/atmel-isc.c                       |    8=20
 drivers/media/v4l2-core/v4l2-ctrls.c                           |   18 -
 drivers/media/v4l2-core/v4l2-fwnode.c                          |    6=20
 drivers/mfd/intel-lpss.c                                       |    3=20
 drivers/mfd/tps65912-spi.c                                     |    1=20
 drivers/mfd/twl6040.c                                          |   13 -
 drivers/misc/pci_endpoint_test.c                               |    1=20
 drivers/mmc/host/mmci.c                                        |    5=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c        |    7=20
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |    3=20
 drivers/net/ethernet/intel/ice/ice_main.c                      |    3=20
 drivers/net/ethernet/intel/ice/ice_switch.c                    |   36 ++
 drivers/net/thunderbolt.c                                      |    3=20
 drivers/nvme/host/pci.c                                        |   10=20
 drivers/nvmem/core.c                                           |   15 -
 drivers/nvmem/sunxi_sid.c                                      |    2=20
 drivers/pci/controller/dwc/pci-keystone.c                      |    8=20
 drivers/pci/controller/dwc/pcie-designware-ep.c                |    7=20
 drivers/pci/controller/dwc/pcie-designware-host.c              |   45 ++-
 drivers/pci/controller/dwc/pcie-designware.h                   |    1=20
 drivers/pci/controller/pcie-rcar.c                             |   10=20
 drivers/pci/controller/pcie-xilinx.c                           |   12=20
 drivers/pci/hotplug/rpadlpar_core.c                            |    4=20
 drivers/pci/switch/switchtec.c                                 |    3=20
 drivers/pinctrl/intel/pinctrl-intel.c                          |    8=20
 drivers/pinctrl/intel/pinctrl-intel.h                          |   11=20
 drivers/platform/chrome/cros_ec_proto.c                        |   11=20
 drivers/platform/x86/intel_pmc_ipc.c                           |    6=20
 drivers/power/supply/cpcap-battery.c                           |   11=20
 drivers/power/supply/max14656_charger_detector.c               |   14 -
 drivers/pwm/core.c                                             |   10=20
 drivers/pwm/pwm-meson.c                                        |   25 +
 drivers/pwm/pwm-tiehrpwm.c                                     |    2=20
 drivers/pwm/sysfs.c                                            |   14 -
 drivers/rapidio/rio_cm.c                                       |    8=20
 drivers/scsi/qla2xxx/qla_gs.c                                  |    3=20
 drivers/soc/mediatek/mtk-pmic-wrap.c                           |    2=20
 drivers/soc/renesas/renesas-soc.c                              |    3=20
 drivers/soc/rockchip/grf.c                                     |    2=20
 drivers/soc/tegra/pmc.c                                        |    5=20
 drivers/spi/spi-pxa2xx.c                                       |    7=20
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c          |   10=20
 drivers/thermal/qcom/tsens.c                                   |    3=20
 drivers/thermal/rcar_gen3_thermal.c                            |    3=20
 drivers/tty/serial/8250/8250_dw.c                              |    4=20
 drivers/usb/host/ohci-da8xx.c                                  |   22 +
 drivers/usb/typec/tcpm/fusb302.c                               |    2=20
 drivers/vfio/pci/vfio_pci_nvlink2.c                            |    2=20
 drivers/vfio/vfio.c                                            |   30 --
 drivers/video/fbdev/core/fbcon.c                               |    2=20
 drivers/video/fbdev/hgafb.c                                    |    2=20
 drivers/video/fbdev/imsttfb.c                                  |    5=20
 drivers/watchdog/Kconfig                                       |    1=20
 drivers/watchdog/imx2_wdt.c                                    |    4=20
 fs/configfs/dir.c                                              |   17 -
 fs/dax.c                                                       |    2=20
 fs/f2fs/checkpoint.c                                           |    6=20
 fs/f2fs/data.c                                                 |    3=20
 fs/f2fs/f2fs.h                                                 |   30 +-
 fs/f2fs/gc.c                                                   |    1=20
 fs/f2fs/inline.c                                               |   17 +
 fs/f2fs/inode.c                                                |    5=20
 fs/f2fs/node.c                                                 |   20 +
 fs/f2fs/recovery.c                                             |   25 +
 fs/f2fs/segment.c                                              |    9=20
 fs/f2fs/segment.h                                              |    3=20
 fs/fat/file.c                                                  |   11=20
 fs/fuse/dev.c                                                  |    2=20
 fs/io_uring.c                                                  |    5=20
 fs/nfsd/nfs4xdr.c                                              |    4=20
 fs/nfsd/vfs.h                                                  |    5=20
 fs/overlayfs/file.c                                            |  130 ++++=
++++--
 include/linux/pwm.h                                            |    5=20
 include/media/v4l2-ctrls.h                                     |    2=20
 include/net/bluetooth/hci_core.h                               |    3=20
 init/initramfs.c                                               |   14 -
 ipc/mqueue.c                                                   |   10=20
 ipc/msgutil.c                                                  |    6=20
 kernel/bpf/verifier.c                                          |    2=20
 kernel/sys.c                                                   |    2=20
 kernel/sysctl.c                                                |    6=20
 kernel/time/ntp.c                                              |    2=20
 mm/Kconfig                                                     |    2=20
 mm/cma.c                                                       |   23 +
 mm/cma_debug.c                                                 |    2=20
 mm/compaction.c                                                |    4=20
 mm/hugetlb.c                                                   |   21 +
 mm/memory_hotplug.c                                            |   37 +-
 mm/mprotect.c                                                  |    5=20
 mm/page_alloc.c                                                |    6=20
 mm/percpu.c                                                    |    9=20
 mm/rmap.c                                                      |    2=20
 mm/slab.c                                                      |    6=20
 net/batman-adv/distributed-arp-table.c                         |   24 +
 net/bluetooth/hci_conn.c                                       |    8=20
 net/netfilter/nf_conntrack_h323_asn1.c                         |    2=20
 net/netfilter/nf_flow_table_core.c                             |   25 +
 net/netfilter/nf_flow_table_ip.c                               |    6=20
 net/netfilter/nf_tables_api.c                                  |    9=20
 net/netfilter/nft_flow_offload.c                               |    1=20
 sound/core/seq/seq_ports.c                                     |    2=20
 sound/pci/hda/hda_intel.c                                      |    6=20
 tools/objtool/check.c                                          |    8=20
 157 files changed, 963 insertions(+), 461 deletions(-)

Adam Ludkiewicz (1):
      i40e: Queues are reserved despite "Invalid argument" error

Amir Goldstein (2):
      ovl: do not generate duplicate fsnotify events for "fake" path
      ovl: support stacked SEEK_HOLE/SEEK_DATA

Amit Kucheria (1):
      drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER

Andreas Schwab (1):
      fbcon: Don't reset logo_shown when logo is currently shown

Andrey Smirnov (11):
      arm64: dts: imx8mq: Mark iomuxc_gpr as i.MX6Q compatible
      ARM: dts: imx51: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx50: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx53: Specify IMX5_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ahb" clock to SDMA
      ARM: dts: imx6sll: Specify IMX6SLL_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx7d: Specify IMX7D_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6ul: Specify IMX6UL_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6sx: Specify IMX6SX_CLK_IPG as "ipg" clock to SDMA
      ARM: dts: imx6qdl: Specify IMX6QDL_CLK_IPG as "ipg" clock to SDMA
      gpio: vf610: Do not share irq_chip

Andy Shevchenko (1):
      dmaengine: idma64: Use actual device for DMA transfers

Aneesh Kumar K.V (1):
      mm: page_mkclean vs MADV_DONTNEED race

Anthony Koo (1):
      drm/amd/display: disable link before changing link settings

Arnd Bergmann (2):
      ARM: prevent tracing IPI_CPU_BACKTRACE
      nfsd: avoid uninitialized variable warning

Baoquan He (1):
      mm/memory_hotplug.c: fix the wrong usage of N_HIGH_MEMORY

Bartosz Golaszewski (1):
      usb: ohci-da8xx: disable the regulator if the overcurrent irq fired

Ben Skeggs (3):
      drm/nouveau/disp/dp: respect sink limits when selecting failsafe link=
 configuration
      drm/nouveau/kms/gf119-gp10x: push HeadSetControlOutputResource() mthd=
 when encoders change
      drm/nouveau/kms/gv100-: fix spurious window immediate interlocks

Binbin Wu (2):
      mfd: intel-lpss: Set the device in reset state when init
      pinctrl: pinctrl-intel: move gpio suspend/resume to noirq phase

Bjorn Andersson (1):
      arm64: dts: qcom: qcs404: Fix regulator supply names

Brett Creeley (1):
      ice: Add missing case in print_link_msg for printing flow control

Brian Masney (1):
      drm/msm: correct attempted NULL pointer dereference in debugfs

Chao Yu (14):
      f2fs: fix to avoid panic in do_recover_data()
      f2fs: fix to avoid panic in f2fs_inplace_write_data()
      f2fs: fix error path of recovery
      f2fs: fix to avoid panic in f2fs_remove_inode_page()
      f2fs: fix to do sanity check on free nid
      f2fs: fix to clear dirty inode in error path of f2fs_iget()
      f2fs: fix to avoid panic in dec_valid_block_count()
      f2fs: fix to use inline space only if inline_xattr is enable
      f2fs: fix to avoid panic in dec_valid_node_count()
      f2fs: fix to do sanity check on valid block count of segment
      f2fs: fix to avoid deadloop in foreground GC
      f2fs: fix to retrieve inline xattr space
      f2fs: fix to do checksum even if inode page is uptodate
      f2fs: fix potential recursive call when enabling data_flush

Chen-Yu Tsai (1):
      nvmem: sunxi_sid: Support SID on A83T and H5

Christian Brauner (1):
      sysctl: return -EINVAL if val violates minmax

Christoph Hellwig (1):
      initramfs: free initrd memory if opening /initrd.image fails

Christoph Vogtl=C3=A4nder (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs

Christopher N Bednarz (1):
      ice: Do not set LB_EN for prune switch rules

Cyrill Gorcunov (1):
      kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Dafna Hirschfeld (1):
      media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon fai=
lure

Daniel Gomez (1):
      mfd: tps65912-spi: Add missing of table registration

Dave Airlie (1):
      Revert "drm: allow render capable master with DRM_AUTH ioctls"

David Hildenbrand (1):
      mm/memory_hotplug: release memory resource after arch_remove_memory()

Dennis Zhou (1):
      percpu: do not search past bitmap when allocating an area

Douglas Anderson (2):
      clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288
      soc: rockchip: Set the proper PWM for rk3288

Enrico Granata (1):
      platform/chrome: cros_ec_proto: check for NULL transfer function

Eugen Hristev (1):
      media: atmel: atmel-isc: fix asd memory allocation

Fabien Dessenne (1):
      mailbox: stm32-ipcc: check invalid irq

Farhan Ali (1):
      vfio: Fix WARNING "do not call blocking ops when !TASK_RUNNING"

Florian Westphal (1):
      netfilter: nf_tables: fix base chain stat rcu_dereference usage

Georg Hofmann (1):
      watchdog: imx2_wdt: Fix set_timeout for big timeout values

Giridhar Malavali (1):
      scsi: qla2xxx: Reset the FCF_ASYNC_{SENT|ACTIVE} flags

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Align minimum encryption key size for LE and BR/ED=
R connections"
      Revert "drm/nouveau: add kconfig option to turn off nouveau legacy co=
ntexts. (v3)"
      Linux 5.1.10

Greg Kurz (1):
      vfio-pci/nvlink2: Fix potential VMA leak

Guenter Roeck (1):
      drm/pl111: Initialize clock spinlock early

Hans de Goede (1):
      usb: typec: fusb302: Check vconn is off when we start toggling

Hou Tao (1):
      fs/fat/file.c: issue flush after the writeback of FAT

J. Bruce Fields (1):
      nfsd: allow fh_want_write to be called twice

Jagan Teki (1):
      Input: goodix - add GT5663 CTP support

Jakub Jankowski (1):
      netfilter: nf_conntrack_h323: restore boundary check correctness

Jens Axboe (1):
      io_uring: fix failure to verify SQ_AFF cpu

Jiada Wang (1):
      thermal: rcar_gen3_thermal: disable interrupt in .remove

Jisheng Zhang (2):
      PCI: dwc: Free MSI in dw_pcie_host_init() error path
      PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()

Jiufei Xue (1):
      ovl: check the capability before cred overridden

John Sperbeck (1):
      percpu: remove spurious lock dependency between percpu and sched

Jon Hunter (1):
      soc/tegra: pmc: Remove reset sysfs entries on error

Jonas Karlman (2):
      media: rockchip/vpu: Fix/re-order probe-error/remove path
      media: rockchip/vpu: Add missing dont_use_autosuspend() calls

Jorge Ramirez-Ortiz (1):
      nvmem: core: fix read buffer in place

Josh Poimboeuf (1):
      objtool: Don't use ignore flag for fake jumps

Junxiao Chang (1):
      platform/x86: intel_pmc_ipc: adding error handling

J=C3=A9r=C3=B4me Glisse (1):
      mm/hmm: select mmu notifier when selecting HMM

Kabir Sahane (1):
      ARM: OMAP2+: pm33xx-core: Do not Turn OFF CEFUSE as PPA may be using =
it

Kangjie Lu (5):
      rapidio: fix a NULL pointer dereference when create_workqueue() fails
      PCI: rcar: Fix a potential NULL pointer dereference
      video: hgafb: fix potential NULL pointer dereference
      video: imsttfb: fix potential NULL pointer dereferences
      PCI: xilinx: Check for __get_free_pages() failure

Keith Busch (2):
      nvme-pci: unquiesce admin queue on shutdown
      nvme-pci: shutdown on timeout during deletion

Kirill Smelkov (1):
      fuse: retrieve: cap requested size to negotiated max_write

Kishon Vijay Abraham I (5):
      misc: pci_endpoint_test: Fix test_reg_bar to be updated in pci_endpoi=
nt_test
      PCI: designware-ep: Use aligned ATU window for raising MSI interrupts
      PCI: keystone: Invoke phy_reset() API before enabling PHY
      PCI: keystone: Prevent ARM32 specific code to be compiled for ARM64
      PCI: dwc: Remove default MSI initialization for platform specific MSI=
 chips

Krzesimir Nowak (1):
      bpf: fix undefined behavior in narrow load handling

Krzysztof Kozlowski (1):
      ARM: dts: exynos: Always enable necessary APIO_1V8 and ABB_1V8 regula=
tors on Arndale Octa

Li Rongqing (1):
      ipc: prevent lockup on alloc_msg and free_msg

Linxu Fang (1):
      mem-hotplug: fix node spanned pages when we have a node with only ZON=
E_MOVABLE

Lu Baolu (3):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly
      iommu/vt-d: Don't request page request irq under dmar_global_lock
      iommu/vt-d: Flush IOTLB for untrusted device in time

Ludovic Barre (1):
      mmc: mmci: Prevent polling for busy detection in IRQ context

Maciej =C5=BBenczykowski (1):
      uml: fix a boot splat wrt use of cpu_all_mask

Marek Szyprowski (1):
      ARM: exynos: Fix undefined instruction during Exynos5422 resume

Marek Vasut (2):
      PCI: rcar: Fix 64bit MSI message address handling
      ARM: shmobile: porter: enable R-Car Gen2 regulator quirk

Martin Blumenstingl (1):
      pwm: meson: Use the spin-lock only to protect register modifications

Matt Redfearn (1):
      drm/bridge: adv7511: Fix low refresh rate selection

Michael Ellerman (1):
      EDAC/mpc85xx: Prevent building as a module

Mika Westerberg (1):
      net: thunderbolt: Unregister ThunderboltIP protocol handler when susp=
ending

Mike Kravetz (1):
      hugetlbfs: on restore reserve error path retain subpool reservation

Mike Rapoport (1):
      mm/mprotect.c: fix compilation warning because of unused 'mm' variable

Ming Lei (1):
      blk-mq: move cancel of requeue_work into blk_mq_release

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero

Nathan Chancellor (1):
      soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Nathan Fontenot (1):
      powerpc/pseries: Track LMB nid instead of using device tree

Nicholas Kazlauskas (1):
      drm/amd/display: Use plane->color_space for dpp if specified

Paolo Valente (1):
      block, bfq: increase idling for weight-raised queues

Peng Li (1):
      net: hns3: return 0 and print warning when hit duplicate MAC

Peteris Rudzusiks (1):
      drm/nouveau: fix duplication of nv50_head_atom struct

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device

Qian Cai (2):
      mm/compaction.c: fix an undefined behaviour
      mm/slab.c: fix an infinite loop in leaks_show()

Sakari Ailus (1):
      media: v4l2-fwnode: Defaults may not override endpoint configuration =
in firmware

Serge Semin (1):
      mips: Make sure dt memory regions are valid

Stephane Eranian (1):
      perf/x86/intel: Allow PEBS multi-entry in watermark mode

Sven Eckelmann (1):
      batman-adv: Adjust name for batadv_dat_send_data

Sven Van Asbroeck (1):
      power: supply: max14656: fix potential use-before-alloc

Taehee Yoo (3):
      netfilter: nf_flow_table: fix missing error check for rhashtable_inse=
rt_fast
      netfilter: nf_flow_table: check ttl value in flow offload data path
      netfilter: nf_flow_table: fix netdev refcnt leak

Takashi Iwai (2):
      ALSA: hda - Register irq handler after the chip initialization
      ALSA: seq: Cover unsubscribe_port() in list_mutex

Takeshi Kihara (1):
      soc: renesas: Identify R-Car M3-W ES1.3

Tony Lindgren (4):
      mfd: twl6040: Fix device init errors for ACCCTL register
      power: supply: cpcap-battery: Fix signed counter sample register
      gpio: gpio-omap: add check for off wake capable gpios
      gpio: gpio-omap: limit errata 1.101 handling to wkup domain gpios only

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Valentin Schneider (1):
      arm64: defconfig: Update UFSHCD for Hi3660 soc

Vladimir Zapolskiy (1):
      watchdog: fix compile time error of pretimeout governors

Wenwen Wang (1):
      x86/PCI: Fix PCI IRQ routing table memory leak

Wesley Sheng (1):
      switchtec: Fix unintended mask of MRPC event

Will Deacon (1):
      iommu/arm-smmu-v3: Don't disable SMMU in kdump kernel

Yashaswini Raghuram Prathivadi Bhayankaram (1):
      ice: Enable LAN_EN for the right recipes

Yue Hu (3):
      mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
      mm/cma.c: fix the bitmap status to show failed allocation reason
      mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

YueHaibing (1):
      configfs: fix possible use-after-free in configfs_register_group


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0FChoACgkQONu9yGCS
aT7nXhAAkxa4YLvW6ML6lJG14AB4/9VTZx1gKMlddd9DRIGphZINJIbuA56OTRvc
75mD9dQZGEwNYxnU0OEKw4C0UrqB/VRevxqKgAP3ZFm7a+z2piCzaI554zWa8fyz
Q3fDlQQH4f9k9UkLRvt7pxv/ndfGjssrnyWEGVVIevFR6e+fVPVxgBCGSBC+1urC
hlTo25V0oEDMPR42AnKXQYy9kvUdZoU2EsJnKn65VKMQHDbnebiJ0w/vTEmG8YGX
eaTLj1Q/U7RFt40xFFDS68mcKR1jQhInP/LqgVjEoTWoZUcWWIGCpTFl4hBOMYdp
etSGEZVgjKQCM9UeFDDS+xo6ThERCbdSXSe6DlJp36QOkdvbMdZX6WdvK3q8doPA
yWTLXG0XMlNoW6yxAcW3vla7Jh1lh2BB0LWCuVoSEmHO0H1mp18VoZjW8HMBRz9x
Dw4MQDQRl0ju9qw4LjhAI/fbb01C2KK3wA0Jv1C4XpNrxCWrRiVIkolzJ8NeTWsR
vywMLGO6rmdc8NrbvWTL5Ps1SGzw77OTiSpT+09LnEK+/ZIU6oCxksfFIHDpCL5+
8bHHZ3Qkfivfhyus79h1eQxgJGT+t9rIk1H6IwcytNpJQFYkJf3xJ76BjFo7pKmv
DhbDz4mwaVf2k8IiLSx0Xhq8Qr5Uy2VAYb3mo4VslALLcLdYRB0=
=Bm7v
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
