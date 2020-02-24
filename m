Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2921F169F98
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 08:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgBXH7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 02:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:56318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgBXH7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 02:59:07 -0500
Received: from localhost (95-141-97-180.as16211.net [95.141.97.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 563B72051A;
        Mon, 24 Feb 2020 07:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582531145;
        bh=UwQRqyZ8AsybraLQh7zkNk1y4lI3NfqRNBiiOpv8GI0=;
        h=Date:From:To:Cc:Subject:From;
        b=fQS3XNCe15lQZJWcVZ0Sf6+GbGNc8o3LCsuCJKQ0VgHUZTiK+EfEHeYtsFw/xePg0
         lUAIJ791Hp57iOSvhVM9twzFWeiKtLnSYkBi5POkZeeWsU3Ui6hZkXIuqCJmdmNFeU
         AILgGjnRDxTveR50U/LF6L7NLRwm4QjsNkuJCM9U=
Date:   Mon, 24 Feb 2020 08:59:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.106
Message-ID: <20200224075902.GA680612@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.106 kernel.

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

 Makefile                                                |    2=20
 arch/arm/Kconfig                                        |    4=20
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi                 |    7=20
 arch/arm/boot/dts/r8a7779.dtsi                          |    8=20
 arch/arm/boot/dts/stm32f469-disco.dts                   |    8=20
 arch/arm/boot/dts/sun8i-h3.dtsi                         |   15=20
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi            |   10=20
 arch/arm64/boot/dts/qcom/msm8996.dtsi                   |    4=20
 arch/arm64/include/asm/alternative.h                    |   32=20
 arch/microblaze/kernel/cpu/cache.c                      |    3=20
 arch/mips/loongson64/loongson-3/platform.c              |    3=20
 arch/powerpc/kernel/eeh_driver.c                        |    6=20
 arch/powerpc/kernel/pci_dn.c                            |   15=20
 arch/powerpc/platforms/powernv/pci-ioda.c               |   48=20
 arch/powerpc/platforms/powernv/pci.c                    |   18=20
 arch/s390/Makefile                                      |    2=20
 arch/s390/kernel/mcount.S                               |   15=20
 arch/s390/kvm/interrupt.c                               |    6=20
 arch/s390/pci/pci_sysfs.c                               |   63=20
 arch/sh/include/cpu-sh2a/cpu/sh7269.h                   |   11=20
 arch/sparc/kernel/vmlinux.lds.S                         |    6=20
 arch/x86/entry/vdso/vdso32-setup.c                      |    1=20
 arch/x86/include/asm/nmi.h                              |    1=20
 arch/x86/kernel/nmi.c                                   |   20=20
 arch/x86/kernel/sysfb_simplefb.c                        |    2=20
 arch/x86/kvm/vmx.c                                      |    3=20
 arch/x86/kvm/vmx/vmx.c                                  | 8036 -----------=
-----
 arch/x86/lib/x86-opcode-map.txt                         |    2=20
 arch/x86/mm/pageattr.c                                  |    8=20
 arch/x86/platform/efi/efi.c                             |   41=20
 arch/x86/platform/efi/efi_64.c                          |    9=20
 drivers/acpi/acpica/dsfield.c                           |    2=20
 drivers/acpi/acpica/dswload.c                           |   21=20
 drivers/acpi/button.c                                   |   11=20
 drivers/atm/fore200e.c                                  |   25=20
 drivers/base/dd.c                                       |    5=20
 drivers/base/platform.c                                 |   12=20
 drivers/block/brd.c                                     |   22=20
 drivers/block/nbd.c                                     |   10=20
 drivers/block/rbd.c                                     |    2=20
 drivers/char/random.c                                   |    5=20
 drivers/clk/qcom/clk-rcg2.c                             |    3=20
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c                   |   28=20
 drivers/clk/uniphier/clk-uniphier-peri.c                |   13=20
 drivers/clocksource/bcm2835_timer.c                     |    5=20
 drivers/crypto/chelsio/chtls/chtls_cm.c                 |   27=20
 drivers/crypto/chelsio/chtls/chtls_cm.h                 |   21=20
 drivers/crypto/chelsio/chtls/chtls_hw.c                 |    3=20
 drivers/devfreq/Kconfig                                 |    3=20
 drivers/devfreq/event/Kconfig                           |    2=20
 drivers/dma/dmaengine.c                                 |    4=20
 drivers/dma/imx-sdma.c                                  |   19=20
 drivers/gpio/gpio-grgpio.c                              |   10=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c            |   19=20
 drivers/gpu/drm/amd/amdgpu/soc15_common.h               |    1=20
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.h    |   40=20
 drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c        |   34=20
 drivers/gpu/drm/amd/display/dc/core/dc_link.c           |    3=20
 drivers/gpu/drm/amd/display/dc/dml/dml_common_defs.c    |    2=20
 drivers/gpu/drm/amd/display/dc/dml/dml_inline_defs.h    |    2=20
 drivers/gpu/drm/amd/display/dc/inc/dcn_calc_math.h      |   40=20
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c       |   23=20
 drivers/gpu/drm/drm_debugfs_crc.c                       |    4=20
 drivers/gpu/drm/gma500/framebuffer.c                    |    8=20
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c                 |    8=20
 drivers/gpu/drm/nouveau/nouveau_fence.c                 |    2=20
 drivers/gpu/drm/nouveau/nouveau_ttm.c                   |    4=20
 drivers/gpu/drm/nouveau/nvkm/core/memory.c              |    2=20
 drivers/gpu/drm/nouveau/nvkm/engine/disp/channv50.c     |    2=20
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c          |   21=20
 drivers/gpu/drm/nouveau/nvkm/subdev/fault/base.c        |    1=20
 drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gm20b.c     |    5=20
 drivers/gpu/drm/radeon/radeon_display.c                 |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_cmdbuf_res.c              |    4=20
 drivers/ide/cmd64x.c                                    |    3=20
 drivers/ide/serverworks.c                               |    6=20
 drivers/infiniband/hw/hfi1/chip.c                       |   10=20
 drivers/infiniband/hw/hfi1/chip.h                       |    1=20
 drivers/infiniband/hw/hfi1/driver.c                     |    1=20
 drivers/infiniband/hw/hfi1/hfi.h                        |    2=20
 drivers/infiniband/sw/rxe/rxe_verbs.h                   |    2=20
 drivers/input/touchscreen/edt-ft5x06.c                  |    7=20
 drivers/iommu/arm-smmu-v3.c                             |    3=20
 drivers/iommu/dmar.c                                    |    1=20
 drivers/iommu/intel-svm.c                               |    2=20
 drivers/irqchip/irq-gic-v3-its.c                        |    2=20
 drivers/irqchip/irq-gic-v3.c                            |    9=20
 drivers/irqchip/irq-mbigen.c                            |    1=20
 drivers/leds/leds-pca963x.c                             |    8=20
 drivers/md/bcache/bset.h                                |    3=20
 drivers/md/bcache/super.c                               |    3=20
 drivers/media/i2c/mt9v032.c                             |   10=20
 drivers/media/pci/cx23885/cx23885-cards.c               |   24=20
 drivers/media/pci/cx23885/cx23885-video.c               |    3=20
 drivers/media/pci/cx23885/cx23885.h                     |    1=20
 drivers/media/platform/sti/bdisp/bdisp-hw.c             |    6=20
 drivers/net/ethernet/cisco/enic/enic_main.c             |    2=20
 drivers/net/ethernet/freescale/gianfar.c                |   10=20
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c      |    3=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c    |    3=20
 drivers/net/ethernet/realtek/r8169.c                    |    9=20
 drivers/net/wan/fsl_ucc_hdlc.c                          |    5=20
 drivers/net/wan/ixp4xx_hss.c                            |    4=20
 drivers/net/wireless/ath/ath10k/wmi.c                   |    2=20
 drivers/net/wireless/broadcom/b43legacy/main.c          |    5=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    1=20
 drivers/net/wireless/intel/ipw2x00/ipw2100.c            |    7=20
 drivers/net/wireless/intel/ipw2x00/ipw2200.c            |    5=20
 drivers/net/wireless/intel/iwlegacy/3945-mac.c          |    5=20
 drivers/net/wireless/intel/iwlegacy/4965-mac.c          |    5=20
 drivers/net/wireless/intel/iwlegacy/common.c            |    2=20
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c             |    4=20
 drivers/net/wireless/intersil/hostap/hostap_ap.c        |    2=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c     |    3=20
 drivers/net/wireless/realtek/rtlwifi/pci.c              |   10=20
 drivers/nfc/port100.c                                   |    2=20
 drivers/pci/controller/pcie-iproc.c                     |   24=20
 drivers/pci/quirks.c                                    |   61=20
 drivers/pinctrl/intel/pinctrl-baytrail.c                |    8=20
 drivers/pinctrl/sh-pfc/pfc-sh7264.c                     |    9=20
 drivers/pinctrl/sh-pfc/pfc-sh7269.c                     |   39=20
 drivers/pwm/pwm-omap-dmtimer.c                          |   35=20
 drivers/pwm/pwm-pca9685.c                               |    4=20
 drivers/regulator/rk808-regulator.c                     |    2=20
 drivers/remoteproc/remoteproc_core.c                    |    2=20
 drivers/reset/reset-uniphier.c                          |   13=20
 drivers/scsi/aic7xxx/aic7xxx_core.c                     |    2=20
 drivers/scsi/iscsi_tcp.c                                |    4=20
 drivers/scsi/scsi_transport_iscsi.c                     |   26=20
 drivers/scsi/ufs/ufshcd.c                               |   24=20
 drivers/scsi/ufs/ufshcd.h                               |    2=20
 drivers/soc/tegra/fuse/tegra-apbmisc.c                  |    2=20
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c          |    9=20
 drivers/tty/synclink_gt.c                               |   18=20
 drivers/tty/synclinkmp.c                                |   24=20
 drivers/uio/uio_dmem_genirq.c                           |    6=20
 drivers/usb/dwc2/gadget.c                               |    3=20
 drivers/usb/gadget/udc/gr_udc.c                         |   16=20
 drivers/usb/musb/omap2430.c                             |    2=20
 drivers/video/fbdev/pxa168fb.c                          |    6=20
 drivers/virtio/virtio_balloon.c                         |    2=20
 drivers/visorbus/visorchipset.c                         |   11=20
 drivers/vme/bridges/vme_fake.c                          |   30=20
 fs/btrfs/check-integrity.c                              |    3=20
 fs/btrfs/file-item.c                                    |    3=20
 fs/btrfs/volumes.c                                      |    2=20
 fs/ceph/mds_client.c                                    |    3=20
 fs/ceph/super.c                                         |    5=20
 fs/cifs/connect.c                                       |    6=20
 fs/cifs/smb2pdu.c                                       |    3=20
 fs/ext4/file.c                                          |   10=20
 fs/f2fs/namei.c                                         |   27=20
 fs/f2fs/sysfs.c                                         |   12=20
 fs/jbd2/checkpoint.c                                    |    2=20
 fs/jbd2/commit.c                                        |    4=20
 fs/jbd2/journal.c                                       |   24=20
 fs/nfs/nfs42proc.c                                      |    4=20
 fs/ocfs2/journal.h                                      |    8=20
 fs/orangefs/orangefs-debugfs.c                          |    1=20
 fs/reiserfs/stree.c                                     |    3=20
 fs/reiserfs/super.c                                     |    2=20
 fs/udf/super.c                                          |   22=20
 include/linux/dmaengine.h                               |    2=20
 include/linux/list_nulls.h                              |    8=20
 include/linux/rculist_nulls.h                           |    8=20
 include/media/v4l2-device.h                             |   12=20
 kernel/bpf/inode.c                                      |    3=20
 kernel/cpu.c                                            |   13=20
 kernel/module.c                                         |    9=20
 kernel/trace/ftrace.c                                   |    5=20
 kernel/trace/trace_events_trigger.c                     |    5=20
 kernel/trace/trace_stat.c                               |   31=20
 kernel/watchdog.c                                       |   10=20
 lib/scatterlist.c                                       |    2=20
 net/core/dev.c                                          |    4=20
 net/core/filter.c                                       |    2=20
 net/dsa/tag_qca.c                                       |    2=20
 net/netfilter/nft_tunnel.c                              |    3=20
 net/sched/cls_flower.c                                  |    1=20
 net/sched/cls_matchall.c                                |    1=20
 net/smc/smc_diag.c                                      |    5=20
 scripts/Kconfig.include                                 |    2=20
 scripts/kconfig/confdata.c                              |    2=20
 security/selinux/avc.c                                  |   77=20
 security/selinux/hooks.c                                |   11=20
 security/selinux/include/avc.h                          |    8=20
 sound/core/control.c                                    |    5=20
 sound/pci/hda/patch_conexant.c                          |    1=20
 sound/pci/hda/patch_hdmi.c                              |    7=20
 sound/sh/aica.c                                         |    4=20
 sound/sh/sh_dac_audio.c                                 |    3=20
 sound/soc/atmel/Kconfig                                 |    2=20
 sound/usb/usx2y/usX2Yhwdep.c                            |    2=20
 tools/lib/api/fs/fs.c                                   |    4=20
 tools/objtool/arch/x86/lib/x86-opcode-map.txt           |    2=20
 tools/testing/selftests/bpf/test_select_reuseport.c     |   16=20
 tools/testing/selftests/size/get_size.c                 |   24=20
 tools/usb/usbip/src/usbip_network.c                     |   40=20
 tools/usb/usbip/src/usbip_network.h                     |   12=20
 199 files changed, 1232 insertions(+), 8730 deletions(-)

Aditya Pakki (2):
      fore200e: Fix incorrect checks of NULL pointer dereference
      orinoco: avoid assertion in case of NULL pointer

Alex Deucher (3):
      drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_latency
      drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage
      drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (=
v2)

Anand Jain (1):
      btrfs: device stats, log when stats are zeroed

Andre Przywara (2):
      arm64: dts: allwinner: H6: Add PMU mode
      arm: dts: allwinner: H3: Add PMU node

Andrei Otcheretianski (1):
      iwlwifi: mvm: Fix thermal zone registration

Andrey Smirnov (2):
      ARM: dts: imx6: rdu2: Disable WP for USDHC2 and USDHC3
      ARM: dts: imx6: rdu2: Limit USBH1 to Full Speed

Andrey Zhizhikin (1):
      tools lib api fs: Fix gcc9 stringop-truncation compilation error

Ard Biesheuvel (3):
      efi/x86: Map the entire EFI vendor string before copying it
      efi/x86: Don't panic or BUG() on non-critical error conditions
      x86/mm: Fix NX bit clearing issue in kernel_map_pages_in_pgd

Arnd Bergmann (6):
      mlx5: work around high stack usage with gcc
      staging: rtl8188: avoid excessive stack usage
      wan: ixp4xx_hss: fix compile-testing on 64-bit
      visorbus: fix uninitialized variable access
      vme: bridges: reduce stack usage
      rbd: work around -Wuninitialized warning

Arvind Sankar (1):
      x86/sysfb: Fix check for bad VRAM size

Ben Skeggs (4):
      drm/nouveau/gr/gk20a,gm200-: add terminators to method lists read fro=
m fw
      drm/nouveau/fault/gv100-: fix memory leak on module unload
      drm/nouveau/mmu: fix comptag memory leak
      drm/nouveau/disp/nv50-: prevent oops when no channel method map provi=
ded

Benjamin Gaignard (1):
      ARM: dts: stm32: Add power-supply for DSI panel on stm32f469-disco

Bibby Hsieh (1):
      drm/mediatek: handle events when enabling/disabling crtc

Brandon Maier (1):
      remoteproc: Initialize rproc_class before use

Can Guo (1):
      scsi: ufs: Complete pending requests in host reset and restore path

Changbin Du (1):
      x86/nmi: Remove irq_work from the long duration NMI handler

Chanwoo Choi (1):
      PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC depende=
ncy

Chao Yu (1):
      f2fs: fix memleak of kobject

Chen Zhou (1):
      ASoC: atmel: fix build error with CONFIG_SND_ATMEL_SOC_DMA=3Dm

Christian Borntraeger (1):
      KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups

Christophe JAILLET (1):
      pxa168fb: Fix the function used to release some memory in an error ha=
ndling path

Colin Ian King (3):
      clocksource/drivers/bcm2835_timer: Fix memory leak of timer
      driver core: platform: fix u32 greater or equal to zero comparison
      iwlegacy: ensure loop counter addr does not wrap and cause an infinit=
e loop

Coly Li (1):
      bcache: explicity type cast in bset_bkey_last()

Dan Carpenter (4):
      brcmfmac: Fix use after free in brcmf_sdio_readframes()
      drm/nouveau/secboot/gm20b: initialize pointer in gm20b_secboot_new()
      cmd64x: potential buffer overflow in cmd64x_program_timings()
      ide: serverworks: potential overflow in svwks_set_pio_mode()

Daniel Drake (2):
      PCI: Add generic quirk for increasing D3hot delay
      PCI: Increase D3 delay for AMD Ryzen5/7 XHCI controllers

Daniel Vetter (1):
      radeon: insert 10ms sleep in dce5_crtc_load_lut

David S. Miller (1):
      sparc: Add .exit.data section.

David Sterba (1):
      btrfs: safely advance counter when looking up bio csums

Davide Caratti (2):
      net/sched: matchall: add missing validation of TCA_MATCHALL_FLAGS
      net/sched: flower: add missing validation of TCA_FLOWER_FLAGS

Dingchen Zhang (1):
      drm: remove the newline for CRC source name.

Dmitry Osipenko (1):
      soc/tegra: fuse: Correct straps' address for older Tegra124 device tr=
ees

Douglas Anderson (1):
      clk: qcom: rcg2: Don't crash if our parent can't be found; return an =
error

Eric Dumazet (1):
      net/smc: fix leak of kernel memory to user space

Erik Kaneda (1):
      ACPICA: Disassembler: create buffer fields in ACPI_PARSE_LOAD_PASS1

Eugen Hristev (1):
      media: i2c: mt9v032: fix enum mbus codes and frame sizes

Firo Yang (1):
      enic: prevent waking up stopped tx queues over watchdog reset

Forest Crossman (1):
      media: cx23885: Add support for AVerMedia CE310B

Geert Uytterhoeven (4):
      pinctrl: sh-pfc: sh7264: Fix CAN function GPIOs
      ARM: dts: r8a7779: Add device node for ARM global timer
      pinctrl: sh-pfc: sh7269: Fix CAN function GPIOs
      driver core: Print device when resources present in really_probe()

Greg Kroah-Hartman (1):
      Linux 4.19.106

Hans de Goede (1):
      pinctrl: baytrail: Do not clear IRQ flags on direct-irq enabled pins

Harry Wentland (1):
      drm/amd/display: Retrain dongles when SINK_COUNT becomes non-zero

Heiner Kallweit (1):
      r8169: check that Realtek PHY driver module is loaded

Icenowy Zheng (1):
      clk: sunxi-ng: add mux and pll notifiers for A64 CPU clock

Ido Schimmel (1):
      mlxsw: spectrum_dpipe: Add missing error path

Jacob Pan (1):
      iommu/vt-d: Fix off-by-one in PASID allocation

Jaegeuk Kim (2):
      f2fs: set I_LINKABLE early to avoid wrong access by vfs
      f2fs: free sysfs kobject

Jaihind Yadav (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_=
update()

Jan Kara (2):
      reiserfs: Fix spurious unlock in reiserfs_fill_super() error handling
      udf: Fix free space reporting for metadata and virtual partitions

Jason Ekstrand (1):
      ACPI: button: Add DMI quirk for Razer Blade Stealth 13 late 2019 lid =
switch

Jessica Yu (1):
      module: avoid setting info->name early in case we can fall back to in=
fo->mod->name

Jia-Ju Bai (4):
      gpio: gpio-grgpio: fix possible sleep-in-atomic-context bugs in grgpi=
o_irq_map/unmap()
      media: sti: bdisp: fix a possible sleep-in-atomic-context bug in bdis=
p_device_run()
      uio: fix a sleep-in-atomic-context bug in uio_dmem_genirq_irqcontrol()
      usb: gadget: udc: fix possible sleep-in-atomic-context bugs in gr_pro=
be()

Jiewei Ke (1):
      RDMA/rxe: Fix error type of mmap_offset

Johannes Thumshirn (1):
      btrfs: fix possible NULL-pointer dereference in integrity checks

John Garry (1):
      irqchip/mbigen: Set driver .suppress_bind_attrs to avoid remove probl=
ems

John Keeping (1):
      usb: dwc2: Fix IN FIFO allocation

Jun Lei (1):
      drm/amd/display: fixup DML dependencies

Kai Li (1):
      jbd2: clear JBD2_ABORT flag before journal_reset to update log tail i=
nfo when load journal

Kai Vehmanen (1):
      ALSA: hda/hdmi - add retry logic to parse_intel_hdmi()

Kunihiko Hayashi (2):
      reset: uniphier: Add SCSSI reset control for each channel
      clk: uniphier: Add SCSSI clock gate for each channel

Li RongQing (1):
      bpf: Return -EBADRQC for invalid map type in __bpf_tx_xdp_map

Liang Chen (1):
      bcache: cached_dev_free needs to put the sb page

Logan Gunthorpe (1):
      dmaengine: Store module owner in dma_device struct

Lorenz Bauer (1):
      selftests: bpf: Reset global state between reuseport test runs

Lu Baolu (1):
      iommu/vt-d: Remove unnecessary WARN_ON_ONCE()

Luis Henriques (1):
      tracing: Fix tracing_stat return values in error handling paths

Manu Gautam (1):
      arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core

Mao Wenan (1):
      NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_a=
dd_cpu().

Marc Zyngier (1):
      irqchip/gic-v3: Only provision redistributors that are enabled in ACPI

Masahiro Yamada (2):
      kconfig: fix broken dependency in randconfig-generated .config
      kbuild: use -S instead of -E for precise cc-option test in Kconfig

Masami Hiramatsu (1):
      x86/decoder: Add TEST opcode to Group3-2

Michael S. Tsirkin (1):
      virtio_balloon: prevent pfn array overflow

Mike Marciniszyn (1):
      IB/hfi1: Add software counter for ctxt0 seq drop

Miquel Raynal (1):
      regulator: rk808: Lower log level on optional GPIOs being not availab=
le

Nathan Chancellor (8):
      drm/amdgpu: Ensure ret is always initialized when using SOC15_WAIT_ON=
_RREG
      media: v4l2-device.h: Explicitly compare grp{id,mask} to zero in v4l2=
_device macros
      ALSA: usx2y: Adjust indentation in snd_usX2Y_hwdep_dsp_status
      scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
      tty: synclinkmp: Adjust indentation in several functions
      tty: synclink_gt: Adjust indentation in several functions
      hostap: Adjust indentation in prism2_hostapd_add_sta
      lib/scatterlist.c: adjust indentation in __sg_alloc_table

Navid Emamdoost (1):
      drm/vmwgfx: prevent memory leak in vmw_cmdbuf_res_add

Nick Black (1):
      scsi: iscsi: Don't destroy session if there are outstanding connectio=
ns

Niklas Schnelle (1):
      s390/pci: Fix possible deadlock in recover_store()

Oliver O'Halloran (3):
      powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid P=
E number
      powerpc/iov: Move VF pdev fixup into pcibios_fixup_iov()
      powerpc/sriov: Remove VF eeh_dev state when disabling SR-IOV

Paul E. McKenney (1):
      rcu: Use WRITE_ONCE() for assignments to ->pprev for hlist_nulls

Paul Kocialkowski (1):
      drm/gma500: Fixup fbdev stolen size usage evaluation

Paul Moore (1):
      selinux: ensure we cleanup the internal AVC counters on error in avc_=
insert()

Per Forlin (1):
      net: dsa: tag_qca: Make sure there is headroom for tag

Peter Gro=DFe (1):
      ALSA: hda - Add docking station support for Lenovo Thinkpad T420s

Peter Zijlstra (1):
      cpu/hotplug, stop_machine: Fix stop_machine vs hotplug order

Philipp Zabel (1):
      Input: edt-ft5x06 - work around first register access error

Phong Tran (4):
      b43legacy: Fix -Wcast-function-type
      ipw2x00: Fix -Wcast-function-type
      iwlegacy: Fix -Wcast-function-type
      rtlwifi: rtl_pci: Fix -Wcast-function-type

Rakesh Pillai (1):
      ath10k: Correct the DMA direction for management tx buffers

Rasmus Villemoes (1):
      net/wan/fsl_ucc_hdlc: reject muram offsets above 64K

Ritesh Harjani (1):
      ext4: fix ext4_dax_read/write inode locking sequence for IOCB_NOWAIT

Ronnie Sahlberg (1):
      cifs: fix NULL dereference in match_prepath

Sami Tolvanen (1):
      arm64: fix alternatives with LLVM's integrated assembler

Sascha Hauer (1):
      dmaengine: imx-sdma: Fix memory leak

Sasha Levin (2):
      Revert "KVM: nVMX: Use correct root level for nested EPT shadow page =
tables"
      Revert "KVM: VMX: Add non-canonical check on writes to RTIT address M=
SRs"

Sean Christopherson (1):
      KVM: nVMX: Use correct root level for nested EPT shadow page tables

Sergey Senozhatsky (1):
      char/random: silence a lockdep splat with printk()

Shuah Khan (1):
      usbip: Fix unsafe unaligned pointer usage

Shubhrajyoti Datta (1):
      microblaze: Prevent the overflow of the start

Siddhesh Poyarekar (1):
      kselftest: Minimise dependency of get_size on C library interfaces

Simon Schwartz (1):
      driver core: platform: Prevent resouce overflow from causing infinite=
 loops

Stephen Smalley (1):
      selinux: fall back to ref-walk if audit is required

Steve French (1):
      cifs: log warning message (once) if out of disk space

Steven Rostedt (VMware) (1):
      tracing: Fix very unlikely race of registering two stat tracers

Sun Ke (1):
      nbd: add a flush_workqueue in nbd_start_device

Takashi Iwai (2):
      ALSA: sh: Fix unused variable warnings
      ALSA: sh: Fix compile warning wrt const

Takashi Sakamoto (1):
      ALSA: ctl: allow TLV read operation for callback type of element in l=
ocked case

Thomas Gleixner (1):
      watchdog/softlockup: Enforce that timestamp is valid on boot

Tiezhu Yang (1):
      MIPS: Loongson: Fix potential NULL dereference in loongson3_platform_=
init()

Toke H=F8iland-J=F8rgensen (1):
      core: Don't skip generic XDP program execution for cloned SKBs

Tony Lindgren (1):
      usb: musb: omap2430: Get rid of musb .set_vbus for omap2430 glue

Uwe Kleine-K=F6nig (2):
      pwm: omap-dmtimer: Simplify error handling
      pwm: omap-dmtimer: Remove PWM chip in .remove before making it unfunc=
tional

Valdis Kletnieks (1):
      x86/vdso: Provide missing include file

Vasily Averin (4):
      bpf: map_seq_next should always increase position index
      ftrace: fpid_next() should increase position index
      trigger_next should increase position index
      help_next should increase position index

Vasily Gorbik (2):
      s390: adjust -mpacked-stack support check for clang 10
      s390/ftrace: generate traced function stack frame

Vinay Kumar Yadav (1):
      crypto: chtls - Fixed memory leak

Vincenzo Frascino (2):
      ARM: 8952/1: Disable kmemleak on XIP kernels
      ARM: 8951/1: Fix Kexec compilation issue.

Vladimir Oltean (1):
      gianfar: Fix TX timestamping with a stacked DSA driver

Wei Liu (1):
      PCI: iproc: Apply quirk_paxc_bridge() for module as well as built-in

Wenwen Wang (1):
      NFS: Fix memory leaks

Will Deacon (1):
      iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE

Xin Long (1):
      netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy

Xiubo Li (1):
      ceph: check availability of mds cluster on mount after wait timeout

YueHaibing (2):
      drm/nouveau: Fix copy-paste error in nouveau_fence_wait_uevent_handler
      drm/nouveau/drm/ttm: Remove set but not used variable 'mem'

Yunfeng Ye (1):
      reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()

Zahari Petkov (1):
      leds: pca963x: Fix open-drain initialization

Zenghui Yu (1):
      irqchip/gic-v3-its: Reference to its_invall_cmd descriptor when build=
ing INVALL

Zhiqiang Liu (1):
      brd: check and limit max_part par

wangyan (1):
      ocfs2: fix a NULL pointer dereference when call ocfs2_update_inode_fs=
ync_trans()

yu kuai (2):
      drm/amdgpu: remove 4 set but not used variable in amdgpu_atombios_get=
_connector_info_from_object_table
      pwm: Remove set but not set variable 'pwm'

zhangyi (F) (3):
      ext4, jbd2: ensure panic when aborting with zero errno
      jbd2: switch to use jbd2_journal_abort() when failed to submit the co=
mmit record
      jbd2: make sure ESHUTDOWN to be recorded in the journal superblock


--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5TgkQACgkQONu9yGCS
aT6biw/9EVDnWrxkD8xKCYl49juSKXEBBqXPJARdRSZDdx554K0Xu0AQ3oyKm2fQ
ahXjjlbcX2A2bQ2SyZmIpQz+7sJjRo4AMOQh/+po3fm8o2kRCMDZw8gzrHbSgZYZ
slZHIjMKhxSMmsvxdd1ZZkjcXPNJ3Aotpap88MKlu2Yb5DkcE4rT259EhmI/Og9t
QqJqJN2cJwngP3qeO7km7vz/l1XXOjtF+PlZA8VFRfsOD/ITBHfOPJwrz/pak5K6
70ido6xDEBRPmiNwmfqeN/BJJ6pYG5/SCgEj0U2hUnvfCzwtIz3jyBLWI+ejgqPa
ugOLXcJ3K0cUajoMqXugQEqrpHMZSlx4oIu6ZyciwC4Oq6bBfmYjF3CELGhreOjH
O2537LPVgVdMp0zYo3GWOFW8fQ2vEo3Cn1stYJmxk2G2qfo2jgGNOyt66DinvrRo
k9uTpv7PUJ+o1StMATcS3IrOuQtDYOaCt5t226Qz2JTUoKbO13u1R51IlFs+exic
prWyxxzMvqbSxRajdapdgZsNS3WYeghuwg2YKN0L9H9GIHXeuxAyIchdpBjozF4p
XDDuBhzpKkZcwUaSvNZNhtEoToOh5Naoz/aqg/ZtZHzhO56LEzflibJXHraV+Fog
iuOn5n6ATgI5r6sCZ9xFmRE1LyE8+rxm2eL/1PCdyMXuyt3O6kU=
=iwCA
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
