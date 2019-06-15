Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58117470A5
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfFOPI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:08:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOPI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 11:08:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0845E20866;
        Sat, 15 Jun 2019 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560611336;
        bh=mEhe15S652NcdLDnfy0dsP1c5PxgeNFU7Ea3f/hz3wk=;
        h=Date:From:To:Cc:Subject:From;
        b=sEoojviWaQguyamu/dGDAynitVScnbTDq0ue4mHLOzWpcWYOmYOW/y64yXxcp59bv
         D7q6f8uuYMXZxd4pDPdEMjGL/ZXUrHCoMiqGUzITcjTWcNiTiTB1CMozzzKOCNUtg2
         rFtiSSK0B7dl8RCi81bx8WEyfOcLhfpRNl7mHtRk=
Date:   Sat, 15 Jun 2019 17:08:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.51
Message-ID: <20190615150854.GA2025@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.51 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 arch/arm/boot/dts/exynos5420-arndale-octa.dts             |    2=20
 arch/arm/boot/dts/imx50.dtsi                              |    2=20
 arch/arm/boot/dts/imx51.dtsi                              |    2=20
 arch/arm/boot/dts/imx53.dtsi                              |    2=20
 arch/arm/boot/dts/imx6qdl.dtsi                            |    2=20
 arch/arm/boot/dts/imx6sl.dtsi                             |    2=20
 arch/arm/boot/dts/imx6sll.dtsi                            |    2=20
 arch/arm/boot/dts/imx6sx.dtsi                             |    2=20
 arch/arm/boot/dts/imx6ul.dtsi                             |    2=20
 arch/arm/boot/dts/imx7s.dtsi                              |    4=20
 arch/arm/include/asm/hardirq.h                            |    1=20
 arch/arm/kernel/smp.c                                     |    6=20
 arch/arm/mach-exynos/suspend.c                            |   19 ++
 arch/arm/mach-omap2/pm33xx-core.c                         |    8=20
 arch/mips/kernel/prom.c                                   |   14 +
 arch/um/kernel/time.c                                     |    2=20
 arch/x86/events/intel/core.c                              |    2=20
 arch/x86/pci/irq.c                                        |   10 -
 block/bfq-iosched.c                                       |    2=20
 block/blk-core.c                                          |    1=20
 block/blk-mq.c                                            |    2=20
 drivers/clk/rockchip/clk-rk3288.c                         |   11 +
 drivers/dma/idma64.c                                      |    6=20
 drivers/dma/idma64.h                                      |    2=20
 drivers/edac/Kconfig                                      |    4=20
 drivers/gpio/gpio-omap.c                                  |   25 +-
 drivers/gpio/gpio-vf610.c                                 |   26 +-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp.c          |    6=20
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |    2=20
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c              |    6=20
 drivers/gpu/drm/nouveau/Kconfig                           |   13 -
 drivers/gpu/drm/nouveau/dispnv50/disp.h                   |    1=20
 drivers/gpu/drm/nouveau/dispnv50/head.c                   |    2=20
 drivers/gpu/drm/nouveau/dispnv50/wimmc37b.c               |    1=20
 drivers/gpu/drm/nouveau/dispnv50/wndw.c                   |    2=20
 drivers/gpu/drm/nouveau/nouveau_drm.c                     |    7=20
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c             |   11 -
 drivers/gpu/drm/pl111/pl111_display.c                     |    5=20
 drivers/gpu/drm/vc4/vc4_plane.c                           |    1=20
 drivers/iommu/arm-smmu-v3.c                               |   10 -
 drivers/iommu/intel-iommu.c                               |    7=20
 drivers/mailbox/stm32-ipcc.c                              |   13 -
 drivers/mfd/intel-lpss.c                                  |    3=20
 drivers/mfd/tps65912-spi.c                                |    1=20
 drivers/mfd/twl6040.c                                     |   13 +
 drivers/misc/pci_endpoint_test.c                          |    1=20
 drivers/mmc/host/mmci.c                                   |    5=20
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |    7=20
 drivers/net/ethernet/intel/i40e/i40e_main.c               |    3=20
 drivers/net/ethernet/intel/ice/ice_main.c                 |    3=20
 drivers/net/thunderbolt.c                                 |    3=20
 drivers/nvme/host/pci.c                                   |   10 -
 drivers/nvmem/core.c                                      |   15 +
 drivers/nvmem/sunxi_sid.c                                 |    2=20
 drivers/pci/controller/dwc/pci-keystone.c                 |    4=20
 drivers/pci/controller/dwc/pcie-designware-ep.c           |    7=20
 drivers/pci/controller/dwc/pcie-designware-host.c         |   21 +-
 drivers/pci/controller/dwc/pcie-designware.h              |    1=20
 drivers/pci/controller/pcie-rcar.c                        |   10 -
 drivers/pci/controller/pcie-xilinx.c                      |   12 +
 drivers/pci/hotplug/rpadlpar_core.c                       |    4=20
 drivers/pci/switch/switchtec.c                            |    3=20
 drivers/platform/chrome/cros_ec_proto.c                   |   11 +
 drivers/platform/x86/intel_pmc_ipc.c                      |    6=20
 drivers/power/supply/max14656_charger_detector.c          |   14 -
 drivers/pwm/core.c                                        |   10 -
 drivers/pwm/pwm-meson.c                                   |   25 +-
 drivers/pwm/pwm-tiehrpwm.c                                |    2=20
 drivers/pwm/sysfs.c                                       |   14 -
 drivers/rapidio/rio_cm.c                                  |    8=20
 drivers/scsi/qla2xxx/qla_gs.c                             |    3=20
 drivers/soc/mediatek/mtk-pmic-wrap.c                      |    2=20
 drivers/soc/renesas/renesas-soc.c                         |    3=20
 drivers/soc/rockchip/grf.c                                |    2=20
 drivers/spi/spi-pxa2xx.c                                  |    7=20
 drivers/thermal/qcom/tsens.c                              |    3=20
 drivers/thermal/rcar_gen3_thermal.c                       |    3=20
 drivers/tty/serial/8250/8250_dw.c                         |    4=20
 drivers/usb/typec/fusb302/fusb302.c                       |    2=20
 drivers/vfio/vfio.c                                       |   30 +--
 drivers/video/fbdev/hgafb.c                               |    2=20
 drivers/video/fbdev/imsttfb.c                             |    5=20
 drivers/watchdog/Kconfig                                  |    1=20
 drivers/watchdog/imx2_wdt.c                               |    4=20
 fs/configfs/dir.c                                         |   17 +
 fs/dax.c                                                  |    2=20
 fs/f2fs/f2fs.h                                            |   16 +
 fs/f2fs/inode.c                                           |    5=20
 fs/f2fs/node.c                                            |   20 +-
 fs/f2fs/recovery.c                                        |   10 -
 fs/f2fs/segment.c                                         |    9=20
 fs/f2fs/segment.h                                         |    3=20
 fs/fat/file.c                                             |   11 -
 fs/fuse/dev.c                                             |    2=20
 fs/nfsd/nfs4xdr.c                                         |    4=20
 fs/nfsd/vfs.h                                             |    5=20
 fs/overlayfs/file.c                                       |  130 +++++++++=
++---
 include/linux/pwm.h                                       |    5=20
 include/net/bluetooth/hci_core.h                          |    3=20
 init/initramfs.c                                          |   14 -
 ipc/mqueue.c                                              |   10 -
 ipc/msgutil.c                                             |    6=20
 kernel/bpf/verifier.c                                     |    2=20
 kernel/sys.c                                              |    2=20
 kernel/sysctl.c                                           |    6=20
 kernel/time/ntp.c                                         |    2=20
 mm/Kconfig                                                |    2=20
 mm/cma.c                                                  |   23 +-
 mm/cma_debug.c                                            |    2=20
 mm/hugetlb.c                                              |   21 +-
 mm/page_alloc.c                                           |    6=20
 mm/percpu.c                                               |    9=20
 mm/rmap.c                                                 |    2=20
 mm/slab.c                                                 |    6=20
 net/bluetooth/hci_conn.c                                  |    8=20
 net/netfilter/nf_conntrack_h323_asn1.c                    |    2=20
 net/netfilter/nf_flow_table_core.c                        |   25 +-
 net/netfilter/nf_flow_table_ip.c                          |    6=20
 net/netfilter/nf_tables_api.c                             |    9=20
 net/netfilter/nft_flow_offload.c                          |    1=20
 sound/core/seq/seq_ports.c                                |    2=20
 sound/pci/hda/hda_intel.c                                 |    6=20
 tools/objtool/check.c                                     |    8=20
 124 files changed, 661 insertions(+), 302 deletions(-)

Adam Ludkiewicz (1):
      i40e: Queues are reserved despite "Invalid argument" error

Amir Goldstein (2):
      ovl: do not generate duplicate fsnotify events for "fake" path
      ovl: support stacked SEEK_HOLE/SEEK_DATA

Amit Kucheria (1):
      drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER

Andrey Smirnov (10):
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

Arnd Bergmann (2):
      ARM: prevent tracing IPI_CPU_BACKTRACE
      nfsd: avoid uninitialized variable warning

Ben Skeggs (3):
      drm/nouveau/disp/dp: respect sink limits when selecting failsafe link=
 configuration
      drm/nouveau/kms/gf119-gp10x: push HeadSetControlOutputResource() mthd=
 when encoders change
      drm/nouveau/kms/gv100-: fix spurious window immediate interlocks

Binbin Wu (1):
      mfd: intel-lpss: Set the device in reset state when init

Brett Creeley (1):
      ice: Add missing case in print_link_msg for printing flow control

Chao Yu (9):
      f2fs: fix to avoid panic in do_recover_data()
      f2fs: fix to avoid panic in f2fs_inplace_write_data()
      f2fs: fix to avoid panic in f2fs_remove_inode_page()
      f2fs: fix to do sanity check on free nid
      f2fs: fix to clear dirty inode in error path of f2fs_iget()
      f2fs: fix to avoid panic in dec_valid_block_count()
      f2fs: fix to use inline space only if inline_xattr is enable
      f2fs: fix to do sanity check on valid block count of segment
      f2fs: fix to do checksum even if inode page is uptodate

Chen-Yu Tsai (1):
      nvmem: sunxi_sid: Support SID on A83T and H5

Christian Brauner (1):
      sysctl: return -EINVAL if val violates minmax

Christoph Hellwig (1):
      initramfs: free initrd memory if opening /initrd.image fails

Christoph Vogtl=C3=A4nder (1):
      pwm: tiehrpwm: Update shadow register for disabling PWMs

Cyrill Gorcunov (1):
      kernel/sys.c: prctl: fix false positive in validate_prctl_map()

Daniel Gomez (1):
      mfd: tps65912-spi: Add missing of table registration

Dennis Zhou (1):
      percpu: do not search past bitmap when allocating an area

Douglas Anderson (2):
      clk: rockchip: Turn on "aclk_dmac1" for suspend on rk3288
      soc: rockchip: Set the proper PWM for rk3288

Enrico Granata (1):
      platform/chrome: cros_ec_proto: check for NULL transfer function

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
      Linux 4.19.51

Guenter Roeck (1):
      drm/pl111: Initialize clock spinlock early

Hans de Goede (1):
      usb: typec: fusb302: Check vconn is off when we start toggling

Helen Koike (1):
      drm/vc4: fix fb references in async update

Hou Tao (1):
      fs/fat/file.c: issue flush after the writeback of FAT

J. Bruce Fields (1):
      nfsd: allow fh_want_write to be called twice

Jakub Jankowski (1):
      netfilter: nf_conntrack_h323: restore boundary check correctness

Jiada Wang (1):
      thermal: rcar_gen3_thermal: disable interrupt in .remove

Jisheng Zhang (2):
      PCI: dwc: Free MSI in dw_pcie_host_init() error path
      PCI: dwc: Free MSI IRQ page in dw_pcie_free_msi()

Jiufei Xue (1):
      ovl: check the capability before cred overridden

John Sperbeck (1):
      percpu: remove spurious lock dependency between percpu and sched

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

Kishon Vijay Abraham I (3):
      misc: pci_endpoint_test: Fix test_reg_bar to be updated in pci_endpoi=
nt_test
      PCI: designware-ep: Use aligned ATU window for raising MSI interrupts
      PCI: keystone: Prevent ARM32 specific code to be compiled for ARM64

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

Lu Baolu (1):
      iommu/vt-d: Set intel_iommu_gfx_mapped correctly

Ludovic Barre (1):
      mmc: mmci: Prevent polling for busy detection in IRQ context

Maciej =C5=BBenczykowski (1):
      uml: fix a boot splat wrt use of cpu_all_mask

Marek Szyprowski (1):
      ARM: exynos: Fix undefined instruction during Exynos5422 resume

Marek Vasut (1):
      PCI: rcar: Fix 64bit MSI message address handling

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

Ming Lei (1):
      blk-mq: move cancel of requeue_work into blk_mq_release

Miroslav Lichvar (1):
      ntp: Allow TAI-UTC offset to be set to zero

Nathan Chancellor (1):
      soc: mediatek: pwrap: Zero initialize rdata in pwrap_init_cipher

Nicholas Kazlauskas (1):
      drm/amd/display: Use plane->color_space for dpp if specified

Paolo Valente (1):
      block, bfq: increase idling for weight-raised queues

Peng Li (1):
      net: hns3: return 0 and print warning when hit duplicate MAC

Phong Hoang (1):
      pwm: Fix deadlock warning when removing PWM device

Qian Cai (1):
      mm/slab.c: fix an infinite loop in leaks_show()

Serge Semin (1):
      mips: Make sure dt memory regions are valid

Stephane Eranian (1):
      perf/x86/intel: Allow PEBS multi-entry in watermark mode

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

Tony Lindgren (2):
      mfd: twl6040: Fix device init errors for ACCCTL register
      gpio: gpio-omap: add check for off wake capable gpios

Tyrel Datwyler (1):
      PCI: rpadlpar: Fix leaked device_node references in add/remove paths

Vladimir Zapolskiy (1):
      watchdog: fix compile time error of pretimeout governors

Wenwen Wang (1):
      x86/PCI: Fix PCI IRQ routing table memory leak

Wesley Sheng (1):
      switchtec: Fix unintended mask of MRPC event

Will Deacon (1):
      iommu/arm-smmu-v3: Don't disable SMMU in kdump kernel

Yue Hu (3):
      mm/cma.c: fix crash on CMA allocation if bitmap allocation fails
      mm/cma.c: fix the bitmap status to show failed allocation reason
      mm/cma_debug.c: fix the break condition in cma_maxchunk_get()

YueHaibing (1):
      configfs: fix possible use-after-free in configfs_register_group


--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0FCgYACgkQONu9yGCS
aT6cHA//Sjp0TknVTNJeo1BHGRlJnzZ9/BaWIun7+hZf2szCBaWcKEHiAyzBt4gC
oDS5X9xOR/a5vft/0eju4QUQT8z1Ucvzym903f+eXeZ0//jQPXHJFY+uWGhaut18
NDwekFjI2NM/4KuJskPnxfw5y9ZkXtluOsNK4veSgipLKZd6F+D7gk1YelwK6yPI
nmSXfkXH4LsGzCSncsRntOAtj/U6zeghcUj/snllq2J3NmTuZO7EI61K6XBChuAy
AxBo4tCH1qSbWw/68SYmT/Nw+f9pBe1qlV8sjmx5RfpRQd5Us/6x/DPD4oWpHiKU
gx6uaTi+LccWeFn6VU8FrH/oF2XnYmOwQl5wDlA/fiXhR6zraW2MQ9pnJHiwT9pw
L/YG4wwV9SJExxEi4pIn5LaGCq0arvuL2y3gV8shnjK37+MCDTZf2m3tuEthe62A
7/nFDkHPB5X8fOchhkTTfB2lRWWwhj0jUMpc/Nj5tyTFH0mMcNvHrg1APcuUMU0C
pfcqsRZsXct95wISsioETPPdhwlL5wg9bYPir1E96/w68IsGa4ZusFm74WFiT6p2
QDAJre9hZfoRF2ikvfrp3I+fUd5bvpq3rm8ByBK/lKJcbMyd3m1Ik0Jjeyd4nVun
OSClszkVQ7qqIXTJnEaz3wqygLZhf7AG7eMYX1FjwL5O2adA3b0=
=dCj/
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
