Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E6C183C35
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 23:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCLWPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 18:15:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgCLWPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 18:15:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 984E9206CD;
        Thu, 12 Mar 2020 22:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584051307;
        bh=QIFKulfJlm2l22dkk+B2waDhyEUJ2ZRgodVYftRHlVY=;
        h=Date:From:To:Cc:Subject:From;
        b=mYnYrYfVqQS6btfdFJVXU2ybAabp5shebRXxGFoAg4NlC6b6nFqv1j94i4iS84Kzr
         AZhoYnH7ISypXIm4OUaw4FBp1vPNGWdCaVt+hVRCVGu2mGZWdJCJn6vvL1MKrUChnD
         C+Dg4wSJvhWZGSFCU2TnbO9ojMGrmivMbWyh/PKc=
Date:   Thu, 12 Mar 2020 23:15:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.9
Message-ID: <20200312221504.GA616949@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.9 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/arm/fsl.yaml                      |    2=
=20
 Documentation/devicetree/bindings/regulator/qcom,spmi-regulator.txt |    2=
=20
 Makefile                                                            |    2=
=20
 arch/arm/boot/dts/am437x-idk-evm.dts                                |    4=
=20
 arch/arm/boot/dts/dra76x.dtsi                                       |    5=
=20
 arch/arm/boot/dts/dra7xx-clocks.dtsi                                |   12=
 -
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi                   |    1=
=20
 arch/arm/boot/dts/imx7-colibri.dtsi                                 |    1=
=20
 arch/arm/boot/dts/imx7d.dtsi                                        |    6=
=20
 arch/arm/boot/dts/ls1021a.dtsi                                      |    4=
=20
 arch/arm/mach-imx/Makefile                                          |    2=
=20
 arch/arm/mach-imx/common.h                                          |    4=
=20
 arch/arm/mach-imx/resume-imx6.S                                     |   24=
 ++
 arch/arm/mach-imx/suspend-imx6.S                                    |   14=
 -
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts               |    2=
=20
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts                    |    1=
=20
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts                       |    5=
=20
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi                       |    6=
=20
 arch/csky/Kconfig                                                   |    3=
=20
 arch/csky/abiv1/inc/abi/entry.h                                     |   19=
 +
 arch/csky/abiv2/inc/abi/entry.h                                     |   11=
 +
 arch/csky/include/uapi/asm/unistd.h                                 |    3=
=20
 arch/csky/kernel/atomic.S                                           |    8=
=20
 arch/csky/kernel/process.c                                          |    7=
=20
 arch/csky/kernel/smp.c                                              |    2=
=20
 arch/csky/mm/Makefile                                               |    2=
=20
 arch/csky/mm/init.c                                                 |    1=
=20
 arch/powerpc/kernel/cputable.c                                      |    4=
=20
 arch/powerpc/mm/mem.c                                               |    2=
=20
 arch/s390/Makefile                                                  |    2=
=20
 arch/s390/boot/Makefile                                             |    2=
=20
 arch/s390/include/asm/pgtable.h                                     |    6=
=20
 arch/s390/include/asm/qdio.h                                        |    2=
=20
 arch/s390/pci/pci.c                                                 |    4=
=20
 arch/x86/boot/compressed/kaslr_64.c                                 |    3=
=20
 arch/x86/include/asm/io_bitmap.h                                    |    9=
=20
 arch/x86/include/asm/paravirt.h                                     |    7=
=20
 arch/x86/include/asm/paravirt_types.h                               |    4=
=20
 arch/x86/kernel/cpu/common.c                                        |    2=
=20
 arch/x86/kernel/paravirt.c                                          |    5=
=20
 arch/x86/kernel/process.c                                           |    2=
=20
 arch/x86/platform/efi/efi_64.c                                      |   70=
 ++++--
 arch/x86/xen/enlighten_pv.c                                         |   32=
 ++-
 block/bfq-cgroup.c                                                  |   14=
 +
 block/bfq-iosched.c                                                 |   10=
=20
 block/bfq-iosched.h                                                 |    2=
=20
 block/bfq-wf2q.c                                                    |   12=
 -
 drivers/android/binder.c                                            |    9=
=20
 drivers/android/binder_internal.h                                   |    2=
=20
 drivers/android/binderfs.c                                          |    7=
=20
 drivers/base/core.c                                                 |   23=
 +-
 drivers/bus/ti-sysc.c                                               |    4=
=20
 drivers/dma-buf/dma-buf.c                                           |    1=
=20
 drivers/dma/coh901318.c                                             |    4=
=20
 drivers/dma/imx-sdma.c                                              |    5=
=20
 drivers/dma/tegra20-apb-dma.c                                       |    6=
=20
 drivers/edac/synopsys_edac.c                                        |   22=
 --
 drivers/firmware/efi/efi.c                                          |    4=
=20
 drivers/firmware/imx/imx-scu.c                                      |   27=
 ++
 drivers/firmware/imx/misc.c                                         |    8=
=20
 drivers/firmware/imx/scu-pd.c                                       |    2=
=20
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                              |   97=
 ++++-----
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c                          |    2=
=20
 drivers/gpu/drm/amd/powerplay/smu_v12_0.c                           |    3=
=20
 drivers/gpu/drm/drm_client_modeset.c                                |    3=
=20
 drivers/gpu/drm/drm_gem_shmem_helper.c                              |   15=
 +
 drivers/gpu/drm/drm_modes.c                                         |    7=
=20
 drivers/gpu/drm/hisilicon/kirin/kirin_ade_reg.h                     |    1=
=20
 drivers/gpu/drm/hisilicon/kirin/kirin_drm_ade.c                     |   20=
 -
 drivers/gpu/drm/i915/display/intel_display_power.c                  |   16=
 +
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c                  |    2=
=20
 drivers/gpu/drm/i915/i915_perf.c                                    |   58=
 +++--
 drivers/gpu/drm/i915/i915_perf_types.h                              |    3=
=20
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c                         |    1=
=20
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c                           |    4=
=20
 drivers/gpu/drm/msm/dsi/dsi_manager.c                               |    7=
=20
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                               |    4=
=20
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c                          |    6=
=20
 drivers/gpu/drm/panfrost/panfrost_mmu.c                             |   44=
 +---
 drivers/gpu/drm/selftests/drm_cmdline_selftests.h                   |    1=
=20
 drivers/gpu/drm/selftests/test-drm_cmdline_parser.c                 |   15=
 +
 drivers/gpu/drm/sun4i/sun8i_mixer.c                                 |  104=
 ++++++++--
 drivers/gpu/drm/sun4i/sun8i_mixer.h                                 |   11=
 +
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c                              |   66=
 +++++-
 drivers/gpu/drm/ttm/ttm_bo_util.c                                   |    1=
=20
 drivers/gpu/drm/virtio/virtgpu_object.c                             |    5=
=20
 drivers/hwmon/adt7462.c                                             |    2=
=20
 drivers/infiniband/core/cm.c                                        |    1=
=20
 drivers/infiniband/core/cma.c                                       |   15=
 +
 drivers/infiniband/core/core_priv.h                                 |   15=
 +
 drivers/infiniband/core/iwcm.c                                      |    4=
=20
 drivers/infiniband/core/nldev.c                                     |    2=
=20
 drivers/infiniband/core/rw.c                                        |   31=
 +-
 drivers/infiniband/core/security.c                                  |   14=
 -
 drivers/infiniband/core/umem_odp.c                                  |   24=
 +-
 drivers/infiniband/core/uverbs_cmd.c                                |   10=
=20
 drivers/infiniband/core/verbs.c                                     |   10=
=20
 drivers/infiniband/hw/hfi1/verbs.c                                  |    4=
=20
 drivers/infiniband/hw/mlx5/mlx5_ib.h                                |    1=
=20
 drivers/infiniband/hw/mlx5/odp.c                                    |   17=
 -
 drivers/infiniband/hw/qib/qib_verbs.c                               |    2=
=20
 drivers/infiniband/sw/siw/siw_main.c                                |    6=
=20
 drivers/iommu/amd_iommu_init.c                                      |   13=
 +
 drivers/md/dm-cache-target.c                                        |    4=
=20
 drivers/md/dm-integrity.c                                           |   50=
 +++-
 drivers/md/dm-thin-metadata.c                                       |    2=
=20
 drivers/md/dm-writecache.c                                          |   14=
 +
 drivers/md/dm-zoned-target.c                                        |    8=
=20
 drivers/md/dm.c                                                     |   22=
 +-
 drivers/media/mc/mc-entity.c                                        |    4=
=20
 drivers/media/platform/vicodec/codec-v4l2-fwht.c                    |   34=
 ---
 drivers/media/v4l2-core/v4l2-mem2mem.c                              |    4=
=20
 drivers/misc/habanalabs/device.c                                    |    5=
=20
 drivers/misc/habanalabs/goya/goya.c                                 |   44=
 ++++
 drivers/net/dsa/bcm_sf2.c                                           |    3=
=20
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h                      |    2=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c           |    4=
=20
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c        |   19=
 +
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   12=
 +
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c                   |   62=
 +++++
 drivers/net/ethernet/cavium/thunder/thunder_bgx.h                   |    9=
=20
 drivers/net/ethernet/davicom/dm9000.c                               |    2=
=20
 drivers/net/ethernet/intel/ice/ice_ethtool.c                        |    7=
=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c           |    5=
=20
 drivers/net/ethernet/micrel/ks8851_mll.c                            |   53=
 -----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |   13=
 -
 drivers/nvme/host/core.c                                            |    2=
=20
 drivers/nvme/host/pci.c                                             |   15=
 +
 drivers/phy/allwinner/phy-sun50i-usb3.c                             |    2=
=20
 drivers/phy/motorola/phy-mapphone-mdm6600.c                         |   27=
 ++
 drivers/regulator/stm32-vrefbuf.c                                   |    3=
=20
 drivers/s390/cio/blacklist.c                                        |    5=
=20
 drivers/s390/cio/qdio_setup.c                                       |    3=
=20
 drivers/s390/net/qeth_core_main.c                                   |   23=
 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c                         |    5=
=20
 drivers/soc/imx/soc-imx-scu.c                                       |    2=
=20
 drivers/spi/atmel-quadspi.c                                         |   11=
 +
 drivers/spi/spi-bcm63xx-hsspi.c                                     |    1=
=20
 drivers/spi/spidev.c                                                |    5=
=20
 drivers/staging/media/hantro/hantro_drv.c                           |    4=
=20
 drivers/staging/speakup/selection.c                                 |    2=
=20
 drivers/tty/serdev/core.c                                           |   10=
=20
 drivers/tty/serial/8250/8250_exar.c                                 |   33=
 +++
 drivers/tty/serial/ar933x_uart.c                                    |    8=
=20
 drivers/tty/serial/fsl_lpuart.c                                     |   39=
 ++-
 drivers/tty/serial/mvebu-uart.c                                     |    2=
=20
 drivers/tty/vt/selection.c                                          |   26=
 ++
 drivers/tty/vt/vt.c                                                 |    2=
=20
 drivers/usb/cdns3/gadget.c                                          |   19=
 +
 drivers/usb/core/hub.c                                              |    8=
=20
 drivers/usb/core/port.c                                             |   10=
=20
 drivers/usb/core/quirks.c                                           |    3=
=20
 drivers/usb/dwc3/gadget.c                                           |    9=
=20
 drivers/usb/gadget/composite.c                                      |   24=
 +-
 drivers/usb/gadget/function/f_fs.c                                  |    5=
=20
 drivers/usb/gadget/function/u_serial.c                              |    4=
=20
 drivers/usb/misc/usb251xb.c                                         |   20=
 +
 drivers/usb/storage/unusual_devs.h                                  |    6=
=20
 drivers/video/console/vgacon.c                                      |    3=
=20
 drivers/watchdog/da9062_wdt.c                                       |    7=
=20
 fs/btrfs/inode.c                                                    |    4=
=20
 fs/cifs/cifsglob.h                                                  |    7=
=20
 fs/cifs/cifsproto.h                                                 |    5=
=20
 fs/cifs/cifssmb.c                                                   |    3=
=20
 fs/cifs/file.c                                                      |   19=
 +
 fs/cifs/inode.c                                                     |   12=
 -
 fs/cifs/smb1ops.c                                                   |    2=
=20
 fs/cifs/smb2inode.c                                                 |    4=
=20
 fs/cifs/smb2ops.c                                                   |    3=
=20
 fs/cifs/smb2pdu.c                                                   |    1=
=20
 fs/fat/inode.c                                                      |   19=
 -
 include/drm/drm_gem_shmem_helper.h                                  |    5=
=20
 include/linux/mm.h                                                  |    4=
=20
 kernel/sched/fair.c                                                 |    2=
=20
 kernel/trace/blktrace.c                                             |    5=
=20
 mm/huge_memory.c                                                    |    3=
=20
 mm/memory.c                                                         |   35=
 ++-
 mm/memory_hotplug.c                                                 |    8=
=20
 mm/mprotect.c                                                       |   38=
 +++
 net/netfilter/xt_hashlimit.c                                        |   36=
 ---
 security/integrity/platform_certs/load_uefi.c                       |   40=
 ++-
 sound/hda/ext/hdac_ext_controller.c                                 |    9=
=20
 sound/pci/hda/patch_realtek.c                                       |   31=
 ++
 sound/soc/codecs/pcm512x.c                                          |    8=
=20
 sound/soc/intel/boards/skl_hda_dsp_generic.c                        |    8=
=20
 sound/soc/intel/skylake/skl-debug.c                                 |   32=
 +--
 sound/soc/intel/skylake/skl-ssp-clk.c                               |    4=
=20
 sound/soc/soc-component.c                                           |    2=
=20
 sound/soc/soc-dapm.c                                                |    2=
=20
 sound/soc/soc-pcm.c                                                 |   16=
 -
 sound/soc/soc-topology.c                                            |   17=
 -
 sound/soc/sof/intel/hda.c                                           |    3=
=20
 sound/soc/sof/ipc.c                                                 |    2=
=20
 tools/perf/arch/arm/util/cs-etm.c                                   |    5=
=20
 tools/perf/arch/arm64/util/arm-spe.c                                |    5=
=20
 tools/perf/arch/x86/util/intel-bts.c                                |    5=
=20
 tools/perf/arch/x86/util/intel-pt.c                                 |    5=
=20
 tools/testing/selftests/lib.mk                                      |   23=
 +-
 tools/testing/selftests/net/forwarding/mirror_gre.sh                |   25=
 +-
 tools/testing/selftests/net/forwarding/vxlan_bridge_1d.sh           |    6=
=20
 tools/testing/selftests/pidfd/.gitignore                            |    1=
=20
 tools/testing/selftests/tpm2/test_smoke.sh                          |   13=
 +
 tools/testing/selftests/tpm2/test_space.sh                          |    9=
=20
 203 files changed, 1610 insertions(+), 744 deletions(-)

Aaro Koskinen (1):
      net: stmmac: fix notifier registration

Adrian Hunter (1):
      perf arm-spe: Fix endless record after being terminated

Ahmad Fatoum (1):
      ARM: imx: build v7_cpu_resume() unconditionally

Ahzo (1):
      drm/ttm: fix leaking fences via ttm_buffer_object_transfer

Amadeusz S=C5=82awi=C5=84ski (1):
      ASoC: Intel: Skylake: Fix available clock counter incrementation

Andy Shevchenko (1):
      nvme-pci: Use single IRQ vector for old Apple models

Ard Biesheuvel (2):
      efi/x86: Align GUIDs to their size in the mixed mode runtime wrapper
      efi/x86: Handle by-ref arguments covering multiple pages in mixed mode

Artemy Kovalyov (1):
      IB/mlx5: Fix implicit ODP race

Aurelien Aptel (1):
      cifs: fix rename() by ensuring source handle opened with DELETE bit

Bernard Metzler (2):
      RDMA/siw: Fix failure handling during device creation
      RDMA/iwcm: Fix iwcm work deallocation

Brian Masney (1):
      drm/msm/mdp5: rate limit pp done timeout warnings

Cengiz Can (1):
      blktrace: fix dereference after null check

Charles Keepax (1):
      ASoC: dapm: Correct DAPM handling of active widgets during shutdown

Chris Wilson (1):
      drm/i915/perf: Reintroduce wait on OA configuration completion

Christian Brauner (2):
      binder: prevent UAF for binderfs devices
      binder: prevent UAF for binderfs devices II

Christian Hewitt (1):
      arm64: dts: meson: fix gxm-khadas-vim2 wifi

Christian Lachner (1):
      ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master

Christophe JAILLET (1):
      spi: bcm63xx-hsspi: Really keep pll clk enabled

Christophe Leroy (1):
      selftests: pidfd: Add pidfd_fdinfo_test in .gitignore

Cong Wang (2):
      netfilter: xt_hashlimit: unregister proc file before releasing mutex
      dma-buf: free dmabuf->name in dma_buf_release()

Dan Carpenter (4):
      ASoC: SOF: Fix snd_sof_ipc_stream_posn()
      drm/i915/selftests: Fix return in assert_mmap_offset()
      hwmon: (adt7462) Fix an error return in ADT7462_REG_VOLT()
      dmaengine: coh901318: Fix a double lock bug in dma_tc_handle()

Dan Lazewatsky (1):
      usb: quirks: add NO_LPM quirk for Logitech Screen Share

Daniel Golle (1):
      serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE

Dennis Dalessandro (1):
      IB/hfi1, qib: Ensure RCU is locked when accessing list

Desnes A. Nunes do Rosario (1):
      powerpc: fix hardware PMU exception bug on PowerVM compatibility mode=
 systems

Dmitry Osipenko (2):
      dmaengine: tegra-apb: Fix use-after-free
      dmaengine: tegra-apb: Prevent race conditions of tasklet vs free list

Dragos Tarcatu (2):
      ASoC: topology: Fix memleak in soc_tplg_link_elems_load()
      ASoC: topology: Fix memleak in soc_tplg_manifest_load()

Egor Pomozov (1):
      net: atlantic: ptp gpio adjustments

Eugeniu Rosca (3):
      usb: core: hub: fix unhandled return by employing a void function
      usb: core: hub: do error out if usb_autopm_get_interface() fails
      usb: core: port: do error out if usb_autopm_get_interface() fails

Ezequiel Garcia (1):
      media: hantro: Fix broken media controller links

Fabio Estevam (1):
      arm64: dts: imx8qxp-mek: Remove unexisting Ethernet PHY

Fabrice Gasnier (1):
      regulator: stm32-vrefbuf: fix a possible overshoot when re-enabling

Faiz Abbas (1):
      arm: dts: dra76x: Fix mmc3 max-frequency

Florian Fainelli (1):
      net: dsa: bcm_sf2: Forcibly configure IMP port for 1Gb/sec

Florian Westphal (1):
      netfilter: hashlimit: do not use indirect calls during gc

Frieder Schrempf (1):
      dmaengine: imx-sdma: Fix the event id check to include RX event for U=
ART6

Gerald Schaefer (1):
      s390/mm: fix panic in gup_fast on large pud

Gerd Hoffmann (2):
      drm/virtio: fix mmap page attributes
      drm/shmem: add support for per object caching flags.

Greg Kroah-Hartman (1):
      Linux 5.5.9

Guillaume La Roque (1):
      arm64: dts: meson-sm1-sei610: add missing interrupt-names

Guo Ren (6):
      csky/mm: Fixup export invalid_pte_table symbol
      csky: Set regs->usp to kernel sp, when the exception is from kernel
      csky/smp: Fixup boot failed when CONFIG_SMP
      csky: Fixup ftrace modify panic
      csky: Fixup compile warning for three unimplemented syscalls
      csky: Implement copy_thread_tls

H.J. Lu (1):
      x86/boot/compressed: Don't declare __force_order in kaslr_64.c

Hamdan Igbaria (1):
      net/mlx5: DR, Fix matching on vport gvmi

Hangbin Liu (3):
      selftests: forwarding: use proto icmp for {gretap, ip6gretap}_mac tes=
ting
      selftests: forwarding: vxlan_bridge_1d: fix tos value
      selftests: forwarding: vxlan_bridge_1d: use more proper tos value

Hans Verkuil (3):
      media: mc-entity.c: use & to check pad flags, not =3D=3D
      media: vicodec: process all 4 components for RGB32 formats
      media: v4l2-mem2mem.c: fix broken links

Harigovindan P (2):
      drm/msm/dsi: save pll state before dsi host is powered off
      drm/msm/dsi/pll: call vco set rate explicitly

Hou Tao (1):
      dm: fix congested_fn for request-based device

Huang Ying (1):
      mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()

Hui Wang (1):
      ALSA: hda/realtek - Fix a regression for mute led on Lenovo Carbon X1

Igor Russkikh (1):
      net: atlantic: check rpc result and wait for rpc address

Jack Pham (1):
      usb: gadget: composite: Support more than 500mA MaxPower

Jaroslav Kysela (1):
      ASoC: intel/skl/hda - export number of digital microphones via contro=
l components

Jason A. Donenfeld (1):
      efi: READ_ONCE rng seed size before munmap

Jason Gunthorpe (2):
      RDMA/odp: Ensure the mm is still alive before creating an implicit ch=
ild
      RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()

Javier Martinez Canillas (1):
      efi: Only print errors about failing to get certs if EFI vars are fou=
nd

Jay Dolan (1):
      serial: 8250_exar: add support for ACCES cards

Jernej Skrabec (3):
      drm/sun4i: Add separate DE3 VI layer formats
      drm/sun4i: Fix DE2 VI layer format support
      drm/sun4i: de2/de3: Remove unsupported VI layer formats

Jian-Hong Pan (1):
      ALSA: hda/realtek - Enable the headset of ASUS B9450FA with ALC294

Jim Lin (1):
      usb: storage: Add quirk for Samsung Fit flash

Jiri Benc (1):
      selftests: fix too long argument

Jiri Slaby (3):
      vt: selection, close sel_buffer race
      vt: selection, push console lock down
      vt: selection, push sel_lock up

John Bates (1):
      drm/virtio: fix resource id creation race

John Stultz (2):
      drm: msm: Fix return type of dsi_mgr_connector_mode_valid for kCFI
      drm: kirin: Revert "Fix for hikey620 display offset problem"

Juergen Gross (1):
      x86/ioperm: Add new paravirt function update_io_bitmap()

Julian Wiedmann (1):
      s390/qdio: fill SL with absolute addresses

Kai Vehmanen (1):
      ALSA: hda: do not override bus codec_mask in link_get()

Kai-Heng Feng (1):
      iommu/amd: Disable IOMMU on Stoney Ridge systems

Kailang Yang (2):
      ALSA: hda/realtek - Add Headset Mic supported
      ALSA: hda/realtek - Add Headset Button supported for ThinkPad X1

Kees Cook (1):
      x86/xen: Distribute switch variables for initialization

Keith Busch (1):
      nvme: Fix uninitialized-variable warning

Kirill A. Shutemov (1):
      mm: avoid data corruption on CoW fault into PFN-mapped VMA

Kuninori Morimoto (1):
      ASoC: soc-component: tidyup snd_soc_pcm_component_sync_stop()

Lars-Peter Clausen (1):
      usb: gadget: ffs: ffs_aio_cancel(): Save/restore IRQ flags

Leonard Crestez (5):
      firmware: imx: scu: Ensure sequential TX
      firmware: imx: misc: Align imx sc msg structs to 4
      firmware: imx: scu-pd: Align imx sc msg structs to 4
      firmware: imx: Align imx_sc_msg_req_cpu_start to 4
      soc: imx-scu: Align imx sc msg structs to 4

Ley Foon Tan (1):
      arm64: dts: socfpga: agilex: Fix gmac compatible

Lukas Wunner (1):
      spi: spidev: Fix CS polarity if GPIO descriptors are used

Maor Gottlieb (2):
      RDMA/core: Fix pkey and port assignment in get_new_pps
      RDMA/core: Fix protection fault in ib_mr_pool_destroy

Marco Felsch (3):
      watchdog: da9062: do not ping the hw during stop()
      usb: usb251xb: fix regulator probe and error handling
      ARM: dts: imx6: phycore-som: fix emmc supply

Marek Vasut (3):
      net: ks8851-ml: Remove 8-bit bus accessors
      net: ks8851-ml: Fix 16-bit data access
      net: ks8851-ml: Fix 16-bit IO operation

Mark Zhang (1):
      RDMA/nldev: Fix crash when set a QP to a new counter but QPN is missi=
ng

Martin Fuzzey (1):
      dmaengine: imx-sdma: fix context cache

Masahiro Yamada (1):
      s390: make 'install' not depend on vmlinux

Matt Roper (1):
      drm/i915: Program MBUS with rmw during initialization

Matthias Reichl (1):
      ASoC: pcm512x: Fix unbalanced regulator enable call in probe error pa=
th

Max Gurtovoy (1):
      RDMA/rw: Fix error flow during RDMA context initialization

Mel Gorman (1):
      mm, numa: fix bad pmd by atomically check for pmd_trans_huge when mar=
king page tables prot_numa

Michael Ellerman (1):
      powerpc/mm: Fix missing KUAP disable in flush_coherent_icache()

Michael Walle (1):
      tty: serial: fsl_lpuart: free IDs allocated by IDA

Michal Swiatkowski (1):
      ice: Don't tell the OS that link is going down

Mikulas Patocka (6):
      dm integrity: fix recalculation when moving from journal mode to bitm=
ap mode
      dm integrity: fix a deadlock due to offloading to an incorrect workqu=
eue
      dm integrity: fix invalid table returned due to argument count mismat=
ch
      dm cache: fix a crash due to incorrect work item cancelling
      dm: report suspended device during destroy
      dm writecache: verify watermark during resume

Nathan Chancellor (1):
      RDMA/core: Fix use of logical OR in get_new_pps

Nikita Sobolev (1):
      Kernel selftests: tpm2: check for tpm support

Niklas Schnelle (1):
      s390/pci: Fix unexpected write combine on resource

OGAWA Hirofumi (1):
      fat: fix uninit-memory access for partial initialized inode

Oded Gabbay (2):
      habanalabs: halt the engines before hard-reset
      habanalabs: patched cb equals user cb in device memset

Oleksandr Suvorov (1):
      ARM: dts: imx7-colibri: Fix frequency for sd/mmc

Omar Sandoval (1):
      btrfs: fix RAID direct I/O reads with alternate csums

Omer Shpigelman (1):
      habanalabs: do not halt CoreSight during hard reset

Paolo Valente (4):
      block, bfq: get a ref to a group when adding it to a service tree
      block, bfq: get extra ref to prevent a queue from being freed during =
a group move
      block, bfq: do not insert oom queue into position tree
      block, bfq: remove ifdefs from around gets/puts of bfq groups

Parav Pandit (1):
      Revert "RDMA/cma: Simplify rdma_resolve_addr() error flow"

Paul Cercueil (1):
      net: ethernet: dm9000: Handle -EPROBE_DEFER in dm9000_parse_dt()

Peng Fan (1):
      ARM: dts: imx7d: fix opp-supported-hw

Peter Chen (2):
      usb: cdns3: gadget: link trb should point to next request
      usb: cdns3: gadget: toggle cycle bit before reset endpoint

Petr Vorel (1):
      regulator: qcom_spmi: Fix docs for PM8004

Phong LE (1):
      drm/mediatek: Handle component type MTK_DISP_OVL_2L correctly

Pratham Pratap (1):
      usb: dwc3: gadget: Update chain bit correctly when using sg list

Prike Liang (1):
      drm/amd/powerplay: fix pre-check condition for setting clock range

Randy Dunlap (1):
      arch/csky: fix some Kconfig typos

Rikard Falkeborn (1):
      phy: allwinner: Fix GENMASK misuse

Ronald Tschal=C3=A4r (1):
      serdev: Fix detection of UART devices on Apple machines.

Ronnie Sahlberg (1):
      cifs: don't leak -EAGAIN for stat() during reconnect

Saravana Kannan (1):
      driver core: Call sync_state() even if supplier has no consumers

Sean Christopherson (1):
      x86/pkeys: Manually set X86_FEATURE_OSPKE to preserve existing changes

Sergey Organov (1):
      usb: gadget: serial: fix Tx stall after buffer overflow

Sherry Sun (1):
      EDAC/synopsys: Do not print an error with back-to-back snprintf() cal=
ls

Shin'ichiro Kawasaki (1):
      dm zoned: Fix reference counter initial value of chunk works

Shyjumon N (1):
      nvme/pci: Add sleep quirk for Samsung and Toshiba drives

Stephan Gerhold (2):
      drm/modes: Make sure to parse valid rotation value from cmdline
      drm/modes: Allow DRM_MODE_ROTATE_0 when applying video mode parameters

Suman Anna (2):
      ARM: dts: am437x-idk-evm: Fix incorrect OPP node names
      ARM: dts: dra7xx-clocks: Fixup IPU1 mux clock parent source

S=C3=A9bastien Szymanski (1):
      dt-bindings: arm: fsl: fix APF6Dev compatible

Takashi Iwai (3):
      ASoC: intel: skl: Fix pin debug prints
      ASoC: intel: skl: Fix possible buffer overflow in debug outputs
      ASoC: pcm: Fix possible buffer overflow in dpcm state sysfs output

Theodore Ts'o (1):
      dm thin metadata: fix lockdep complaint

Tianci.Yin (1):
      drm/amdgpu: disable 3D pipe 1 on Navi1x

Tim Harvey (1):
      net: thunderx: workaround BGX TX Underflow issue

Tomas Henzl (1):
      scsi: megaraid_sas: silence a warning

Tomeu Vizoso (1):
      drm/panfrost: Don't try to map on error faults

Tony Lindgren (3):
      phy: mapphone-mdm6600: Fix timeouts by adding wake-up handling
      phy: mapphone-mdm6600: Fix write timeouts with shorter GPIO toggle in=
terval
      bus: ti-sysc: Fix 1-wire reset quirk

Tudor Ambarus (1):
      spi: atmel-quadspi: fix possible MMIO window size overrun

Vasily Averin (1):
      s390/cio: cio_ignore_proc_seq_next should increase position index

Vincent Guittot (1):
      sched/fair: Fix statistics for find_idlest_group()

Vladimir Oltean (1):
      ARM: dts: ls1021a: Restore MDIO compatible to gianfar

Vlastimil Babka (1):
      mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled but not en=
abled

Wei Li (3):
      perf intel-pt: Fix endless record after being terminated
      perf intel-bts: Fix endless record after being terminated
      perf cs-etm: Fix endless record after being terminated

Zhang Xiaoxu (1):
      vgacon: Fix a UAF in vgacon_invert_region

tangbin (1):
      tty:serial:mvebu-uart:fix a wrong return


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl5qtGgACgkQONu9yGCS
aT44tw/+JtrbV0oxwU0olBOCfQ9l3lFYSisl2yXPgXu3Oc419q5hqUHZVmfPFG7h
awIHvufai/9T1Z+DgGnrLYQmmR3zeCOLfO+vfrT6gF8BDb3XW5u7d9powrQG/N2j
0fCZ3/0/YaTob5B+TsS24V0gDttE84T4ICqvAxcVbrcjP9754Ea+i8jpSYXGZoPG
mf0kSHzHjYkBD+ujjlNQWi6TBA20YR4mOTMueXWNd44iG1kn4Lr+ZcTO9MN0CBXy
p+caO5FflOZXKfsO3TTHNMmJDuk6BQVE3OaLtM0ivvzQdnFqsNm/greg9YNKRZ55
wntdPsHqAoRH/V1K0u8MPEt185QgOSWN4BeVugrLAV3ypWkofik2p2zvmLDjdiEv
YFSXsFLFN/rbdi5KvlfV1aPvdWY8f+M7SRoUfXhi64FBFFfyJ/DYyhtKUQ4wvPwL
Gy+5EhAcSOt1e/9TaxdcSpvoy1UrzsyjK0uceLa7s4X6qbQtFwbWC8w+2tOQyXCj
Y3varcVlyN8Z8Xggrzzd3FTK9ocwWaUkv6gXdsWGOFFvtxCqAnOrqkAlDVSeN/4T
VkXygh9QYNG7TAOKpErLYTmoGmTPpVfIApYm/8KRIfNSzHyQA0ecw2ogg+bk8PWV
Nxbuyb/mMaJPPtVKggDGWhTq0AxP6zaS4cWQ+l1W5/ld9JJf6s4=
=o21h
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
