Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A31AE0BA
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 17:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgDQPLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 11:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgDQPLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 11:11:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F682223D;
        Fri, 17 Apr 2020 15:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587136268;
        bh=LdUj5Aoo1L7AKT07aJgGgG7HoGKKLkXHBcNjy04cmAQ=;
        h=Date:From:To:Cc:Subject:From;
        b=t4BiVcHvbtF/U7ukWvn+67ODQ84XLh5x/JvEZxdJbfgIqlG7UdWe4/OfbO0P4WtVI
         qPIGzS2kt0aTC9cHhaYVl295eJXO2B4JO7SCWTX1+8Wy1lAMo6P3mPhg26B7kmOquK
         xYspFL91w8uJi9MukazCxeqoCCTvb9fRBN393mpI=
Date:   Fri, 17 Apr 2020 17:11:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.5
Message-ID: <20200417151106.GA714462@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.6.5 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/sysctl/user.rst                 |    6=20
 Documentation/sound/hd-audio/index.rst                    |    1=20
 Documentation/sound/hd-audio/models.rst                   |    2=20
 Documentation/sound/hd-audio/realtek-pc-beep.rst          |  129 +++++++
 Makefile                                                  |    2=20
 arch/arm/boot/dts/exynos4210-universal_c210.dts           |    4=20
 arch/arm64/Makefile                                       |    4=20
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi              |    3=20
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi              |    3=20
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts        |    4=20
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi                  |    2=20
 arch/arm64/kernel/armv8_deprecated.c                      |    2=20
 arch/arm64/mm/ptdump_debugfs.c                            |    4=20
 arch/mips/cavium-octeon/octeon-irq.c                      |    3=20
 arch/mips/mm/tlbex.c                                      |    5=20
 arch/powerpc/include/asm/book3s/64/hash-4k.h              |    6=20
 arch/powerpc/include/asm/book3s/64/hash-64k.h             |    8=20
 arch/powerpc/include/asm/book3s/64/pgtable.h              |    4=20
 arch/powerpc/include/asm/book3s/64/radix.h                |    5=20
 arch/powerpc/include/asm/drmem.h                          |    4=20
 arch/powerpc/include/asm/setjmp.h                         |    6=20
 arch/powerpc/kernel/dt_cpu_ftrs.c                         |    1=20
 arch/powerpc/kernel/kprobes.c                             |    3=20
 arch/powerpc/kernel/paca.c                                |   14=20
 arch/powerpc/kernel/setup.h                               |    6=20
 arch/powerpc/kernel/setup_64.c                            |   32 +
 arch/powerpc/kernel/signal_64.c                           |    4=20
 arch/powerpc/kexec/Makefile                               |    3=20
 arch/powerpc/kvm/book3s_hv_uvmem.c                        |    3=20
 arch/powerpc/mm/kasan/kasan_init_32.c                     |    2=20
 arch/powerpc/mm/nohash/tlb_low.S                          |   12=20
 arch/powerpc/platforms/pseries/hotplug-memory.c           |    8=20
 arch/powerpc/sysdev/xive/common.c                         |   16=20
 arch/powerpc/sysdev/xive/native.c                         |    4=20
 arch/powerpc/sysdev/xive/spapr.c                          |    4=20
 arch/powerpc/sysdev/xive/xive-internal.h                  |    7=20
 arch/powerpc/xmon/Makefile                                |    3=20
 arch/s390/kernel/diag.c                                   |    2=20
 arch/s390/kvm/vsie.c                                      |    1=20
 arch/s390/mm/gmap.c                                       |    6=20
 arch/x86/boot/compressed/head_32.S                        |    2=20
 arch/x86/boot/compressed/head_64.S                        |    4=20
 arch/x86/entry/entry_32.S                                 |    1=20
 arch/x86/include/asm/kvm_host.h                           |    2=20
 arch/x86/include/asm/pgtable.h                            |    7=20
 arch/x86/include/asm/pgtable_types.h                      |    2=20
 arch/x86/kernel/acpi/boot.c                               |    2=20
 arch/x86/kernel/tsc_msr.c                                 |  128 ++++++-
 arch/x86/kvm/svm.c                                        |    4=20
 arch/x86/kvm/vmx/nested.c                                 |   18 -
 arch/x86/kvm/vmx/ops.h                                    |   28 +
 arch/x86/kvm/vmx/vmenter.S                                |   58 +++
 arch/x86/kvm/vmx/vmx.c                                    |   92 ++---
 arch/x86/kvm/x86.c                                        |   21 -
 arch/x86/platform/efi/efi.c                               |    2=20
 arch/x86/platform/efi/efi_64.c                            |    4=20
 block/bfq-cgroup.c                                        |   14=20
 block/bfq-iosched.c                                       |   16=20
 block/blk-ioc.c                                           |    7=20
 block/blk-mq.c                                            |    1=20
 block/blk-settings.c                                      |    3=20
 block/blk-zoned.c                                         |    2=20
 crypto/rng.c                                              |    8=20
 drivers/acpi/acpica/achware.h                             |    2=20
 drivers/acpi/acpica/evxfgpe.c                             |   17 -
 drivers/acpi/acpica/hwgpe.c                               |   47 ++
 drivers/acpi/ec.c                                         |   26 +
 drivers/acpi/internal.h                                   |    1=20
 drivers/acpi/sleep.c                                      |   19 -
 drivers/ata/libata-pmp.c                                  |    1=20
 drivers/ata/libata-scsi.c                                 |    9=20
 drivers/base/firmware_loader/fallback.c                   |    2=20
 drivers/base/power/domain.c                               |    2=20
 drivers/base/power/wakeup.c                               |    4=20
 drivers/block/null_blk_main.c                             |   12=20
 drivers/block/xen-blkfront.c                              |   17 -
 drivers/char/ipmi/ipmi_msghandler.c                       |    4=20
 drivers/char/tpm/eventlog/common.c                        |   12=20
 drivers/char/tpm/eventlog/tpm1.c                          |    2=20
 drivers/char/tpm/eventlog/tpm2.c                          |    2=20
 drivers/char/tpm/tpm-chip.c                               |    4=20
 drivers/char/tpm/tpm.h                                    |    2=20
 drivers/clk/ingenic/jz4770-cgu.c                          |    4=20
 drivers/clk/ingenic/tcu.c                                 |    2=20
 drivers/clocksource/timer-microchip-pit64b.c              |    1=20
 drivers/cpufreq/imx6q-cpufreq.c                           |   12=20
 drivers/cpufreq/powernv-cpufreq.c                         |    6=20
 drivers/crypto/caam/caamalg_desc.c                        |   30 +
 drivers/crypto/ccree/cc_buffer_mgr.c                      |   76 ++--
 drivers/crypto/ccree/cc_buffer_mgr.h                      |    1=20
 drivers/crypto/mxs-dcp.c                                  |   58 +--
 drivers/edac/edac_mc.c                                    |   21 -
 drivers/firmware/arm_sdei.c                               |   32 -
 drivers/firmware/efi/efi.c                                |    2=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                |    5=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                     |    2=20
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c |    2=20
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c                |   18 +
 drivers/gpu/drm/amd/powerplay/renoir_ppt.h                |    2=20
 drivers/gpu/drm/bridge/analogix/analogix-anx78xx.c        |    5=20
 drivers/gpu/drm/drm_dp_mst_topology.c                     |   20 -
 drivers/gpu/drm/drm_pci.c                                 |   23 -
 drivers/gpu/drm/drm_prime.c                               |   37 +-
 drivers/gpu/drm/etnaviv/etnaviv_perfmon.c                 |   59 +++
 drivers/gpu/drm/i915/Kconfig.profile                      |    4=20
 drivers/gpu/drm/i915/display/intel_ddi.c                  |    6=20
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c            |    8=20
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c                      |   26 +
 drivers/gpu/drm/i915/gt/intel_engine_cs.c                 |   13=20
 drivers/gpu/drm/i915/gt/intel_ggtt.c                      |   48 ++
 drivers/gpu/drm/i915/gt/intel_gtt.c                       |   24 -
 drivers/gpu/drm/i915/gt/intel_gtt.h                       |    4=20
 drivers/gpu/drm/i915/gt/intel_rps.c                       |   13=20
 drivers/gpu/drm/vboxvideo/vbox_drv.c                      |    4=20
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c              |    5=20
 drivers/input/serio/i8042-x86ia64io.h                     |   11=20
 drivers/irqchip/irq-gic-v3-its.c                          |   10=20
 drivers/irqchip/irq-versatile-fpga.c                      |   18 -
 drivers/md/dm-clone-metadata.c                            |   15=20
 drivers/md/dm-clone-metadata.h                            |    2=20
 drivers/md/dm-clone-target.c                              |   66 ++-
 drivers/md/dm-integrity.c                                 |    4=20
 drivers/md/dm-verity-fec.c                                |    1=20
 drivers/md/dm-writecache.c                                |    6=20
 drivers/md/dm-zoned-metadata.c                            |    1=20
 drivers/md/md.c                                           |    2=20
 drivers/media/i2c/ov5695.c                                |   49 +-
 drivers/media/i2c/video-i2c.c                             |    2=20
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c              |    9=20
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c           |    6=20
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c           |   12=20
 drivers/media/platform/mtk-vpu/mtk_vpu.c                  |   45 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.h                  |    2=20
 drivers/media/platform/qcom/venus/core.h                  |    1=20
 drivers/media/platform/qcom/venus/firmware.c              |   10=20
 drivers/media/platform/qcom/venus/helpers.c               |   20 -
 drivers/media/platform/qcom/venus/hfi_parser.c            |    1=20
 drivers/media/platform/ti-vpe/cal.c                       |   29 -
 drivers/media/platform/vimc/vimc-streamer.c               |    9=20
 drivers/media/rc/keymaps/Makefile                         |    1=20
 drivers/media/rc/keymaps/rc-videostrong-kii-pro.c         |   83 ++++
 drivers/mfd/dln2.c                                        |    9=20
 drivers/mmc/host/mmci_stm32_sdmmc.c                       |    4=20
 drivers/mtd/nand/raw/cadence-nand-controller.c            |   13=20
 drivers/mtd/nand/spi/core.c                               |   17 -
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c        |   31 +
 drivers/net/wireless/ath/ath9k/main.c                     |    3=20
 drivers/nvme/host/fc.c                                    |   14=20
 drivers/nvme/target/fcloop.c                              |    1=20
 drivers/nvme/target/tcp.c                                 |    2=20
 drivers/pci/controller/dwc/pcie-qcom.c                    |    8=20
 drivers/pci/endpoint/pci-epc-mem.c                        |   10=20
 drivers/pci/hotplug/pciehp_hpc.c                          |   14=20
 drivers/pci/pcie/aspm.c                                   |    4=20
 drivers/pci/quirks.c                                      |   80 ++++
 drivers/pci/switch/switchtec.c                            |    2=20
 drivers/platform/x86/asus-wmi.c                           |    5=20
 drivers/remoteproc/qcom_q6v5_mss.c                        |   54 ++-
 drivers/remoteproc/remoteproc_virtio.c                    |    7=20
 drivers/s390/scsi/zfcp_erp.c                              |    2=20
 drivers/scsi/lpfc/lpfc.h                                  |    1=20
 drivers/scsi/lpfc/lpfc_hbadisc.c                          |   59 ++-
 drivers/scsi/lpfc/lpfc_nvme.c                             |    2=20
 drivers/scsi/lpfc/lpfc_scsi.c                             |    4=20
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                      |    8=20
 drivers/scsi/qla2xxx/qla_nvme.c                           |    1=20
 drivers/scsi/sr.c                                         |   22 -
 drivers/scsi/sr.h                                         |    2=20
 drivers/scsi/ufs/ufshcd.c                                 |    3=20
 drivers/scsi/ufs/ufshcd.h                                 |    6=20
 drivers/spi/spi-fsl-dspi.c                                |   25 -
 drivers/staging/media/allegro-dvt/allegro-core.c          |    5=20
 drivers/staging/media/hantro/hantro_h1_jpeg_enc.c         |    9=20
 drivers/staging/media/hantro/hantro_v4l2.c                |    2=20
 drivers/staging/media/hantro/rk3399_vpu_hw_jpeg_enc.c     |    9=20
 drivers/staging/media/imx/imx7-media-csi.c                |    4=20
 drivers/staging/media/imx/imx7-mipi-csis.c                |    2=20
 drivers/staging/media/rkisp1/rkisp1-dev.c                 |    3=20
 drivers/staging/media/rkisp1/rkisp1-isp.c                 |    4=20
 drivers/staging/mt7621-pci/pci-mt7621.c                   |    3=20
 drivers/staging/wilc1000/wlan.c                           |    1=20
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c   |    2=20
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c   |    2=20
 drivers/usb/dwc3/core.c                                   |    5=20
 drivers/usb/dwc3/core.h                                   |    4=20
 drivers/usb/gadget/composite.c                            |    9=20
 drivers/usb/gadget/function/f_fs.c                        |    1=20
 drivers/usb/host/xhci.c                                   |    4=20
 drivers/usb/phy/phy-tegra-usb.c                           |    3=20
 drivers/usb/typec/ucsi/ucsi_ccg.c                         |    2=20
 drivers/vfio/platform/vfio_platform.c                     |    2=20
 fs/btrfs/async-thread.c                                   |    8=20
 fs/btrfs/async-thread.h                                   |    1=20
 fs/btrfs/delayed-inode.c                                  |   13=20
 fs/btrfs/disk-io.c                                        |   27 +
 fs/btrfs/extent_io.c                                      |   35 ++
 fs/btrfs/file.c                                           |   11=20
 fs/btrfs/qgroup.c                                         |   11=20
 fs/btrfs/relocation.c                                     |   62 +--
 fs/btrfs/space-info.c                                     |   43 ++
 fs/cifs/file.c                                            |    2=20
 fs/cifs/inode.c                                           |   23 -
 fs/cifs/smb2ops.c                                         |    4=20
 fs/debugfs/file.c                                         |   18 -
 fs/erofs/utils.c                                          |    2=20
 fs/exec.c                                                 |    2=20
 fs/ext4/inode.c                                           |    2=20
 fs/filesystems.c                                          |    4=20
 fs/gfs2/glock.c                                           |    3=20
 fs/gfs2/glops.c                                           |   27 +
 fs/gfs2/log.c                                             |    2=20
 fs/gfs2/log.h                                             |    1=20
 fs/hfsplus/attributes.c                                   |    4=20
 fs/io_uring.c                                             |   23 -
 fs/nfs/fs_context.c                                       |    5=20
 fs/nfs/namespace.c                                        |   12=20
 fs/nfs/pagelist.c                                         |   48 +-
 fs/nfs/write.c                                            |    1=20
 fs/nfsd/nfsctl.c                                          |    1=20
 fs/ocfs2/alloc.c                                          |    4=20
 fs/pstore/inode.c                                         |    5=20
 fs/pstore/platform.c                                      |    4=20
 include/acpi/acpixf.h                                     |    2=20
 include/linux/cpu.h                                       |   12=20
 include/linux/devfreq_cooling.h                           |    2=20
 include/linux/iocontext.h                                 |    1=20
 include/linux/nvme-fc-driver.h                            |    4=20
 include/linux/pci-epc.h                                   |    3=20
 include/linux/sched.h                                     |    4=20
 include/linux/xarray.h                                    |    6=20
 include/media/rc-map.h                                    |    1=20
 include/trace/events/rcu.h                                |    1=20
 kernel/bpf/verifier.c                                     |  108 ++++--
 kernel/cpu.c                                              |    4=20
 kernel/dma/mapping.c                                      |    2=20
 kernel/events/core.c                                      |  150 ++++-----
 kernel/irq/debugfs.c                                      |   11=20
 kernel/irq/irqdomain.c                                    |   10=20
 kernel/kmod.c                                             |    4=20
 kernel/locking/lockdep.c                                  |    4=20
 kernel/rcu/tree.c                                         |   36 +-
 kernel/sched/core.c                                       |    1=20
 kernel/sched/cputime.c                                    |   41 +-
 kernel/sched/fair.c                                       |   29 +
 kernel/sched/sched.h                                      |    8=20
 kernel/seccomp.c                                          |    1=20
 kernel/signal.c                                           |    2=20
 kernel/time/namespace.c                                   |    1=20
 kernel/time/sched_clock.c                                 |    9=20
 kernel/trace/trace_kprobe.c                               |    2=20
 kernel/ucount.c                                           |    1=20
 lib/test_xarray.c                                         |   37 ++
 lib/xarray.c                                              |    4=20
 mm/memcontrol.c                                           |    3=20
 security/keys/key.c                                       |    2=20
 security/keys/keyctl.c                                    |    4=20
 sound/core/oss/pcm_plugin.c                               |   32 +
 sound/pci/hda/hda_beep.c                                  |    6=20
 sound/pci/hda/hda_intel.c                                 |   16=20
 sound/pci/hda/patch_realtek.c                             |  233 +++++++--=
-----
 sound/pci/ice1712/prodigy_hifi.c                          |    4=20
 sound/soc/codecs/cs4270.c                                 |   40 ++
 sound/soc/soc-dapm.c                                      |    8=20
 sound/soc/soc-ops.c                                       |    4=20
 sound/soc/soc-pcm.c                                       |    6=20
 sound/soc/soc-topology.c                                  |    2=20
 sound/soc/stm/stm32_sai_sub.c                             |    4=20
 sound/usb/mixer_maps.c                                    |   28 +
 tools/gpio/Makefile                                       |    2=20
 tools/perf/Makefile.config                                |   11=20
 tools/testing/radix-tree/Makefile                         |    4=20
 tools/testing/radix-tree/iteration_check_2.c              |   87 +++++
 tools/testing/radix-tree/main.c                           |    1=20
 tools/testing/radix-tree/test.h                           |    1=20
 tools/testing/selftests/powerpc/mm/.gitignore             |    1=20
 tools/testing/selftests/powerpc/pmu/ebb/Makefile          |    1=20
 tools/testing/selftests/vm/map_hugetlb.c                  |   14=20
 tools/testing/selftests/vm/mlock2-tests.c                 |  233 ++-------=
-----
 tools/testing/selftests/x86/ptrace_syscall.c              |    8=20
 279 files changed, 2731 insertions(+), 1359 deletions(-)

Aaron Liu (1):
      drm/amdgpu: unify fw_write_wait for new gfx9 asics

Ahmed S. Darwish (1):
      time/sched_clock: Expire timer in hardirq context

Ajay Gupta (1):
      usb: ucsi: ccg: disable runtime pm during fw flashing

Ajay Singh (1):
      staging: wilc1000: avoid double unlocking of 'wilc->hif_cs' mutex

Alexander Sverdlin (1):
      genirq/irqdomain: Check pointer in irq_domain_alloc_irqs_hierarchy()

Alexey Dobriyan (2):
      null_blk: fix spurious IO errors after failed past-wp access
      block, zoned: fix integer overflow with BLKRESETZONE et al

Andrei Botila (1):
      crypto: caam - update xts sector size for large input length

Andrzej Pietrasiewicz (1):
      media: hantro: Read be32 words starting at every fourth byte

Andy Lutomirski (1):
      selftests/x86/ptrace_syscall_32: Fix no-vDSO segfault

Andy Shevchenko (1):
      mfd: dln2: Fix sanity checking for endpoints

Aneesh Kumar K.V (1):
      powerpc/hash64/devmap: Use H_PAGE_THP_HUGE when setting up huge devma=
p PTE entries

Anshuman Khandual (1):
      arm64/mm: Hold memory hotplug lock while walking for kernel page tabl=
e dump

Anssi Hannula (1):
      tools: gpio: Fix out-of-tree build regression

Ard Biesheuvel (1):
      efi/x86: Ignore the memory attributes table on i386

Arvind Sankar (1):
      x86/boot: Use unsigned comparison for addresses

Bart Van Assche (5):
      null_blk: Fix the null_add_dev() error path
      blk-mq: Fix a recently introduced regression in blk_mq_realloc_hw_ctx=
s()
      null_blk: Handle null_add_dev() failures properly
      null_blk: Suppress an UBSAN complaint triggered when setting 'memory_=
backed'
      scsi: sr: Fix sr_block_release()

Benoit Parrot (2):
      media: ti-vpe: cal: fix disable_irqs to only the intended target
      media: ti-vpe: cal: fix a kernel oops when unloading module

Bjorn Andersson (2):
      PCI: qcom: Fix the fixup of PCI_VENDOR_ID_QCOM
      remoteproc: qcom_q6v5_mss: Don't reassign mpss region on shutdown

Bob Liu (1):
      dm zoned: remove duplicate nr_rnd_zones increase in dmz_init_zone()

Bob Peterson (2):
      gfs2: Do log_flush in gfs2_ail_empty_gl even if ail list is empty
      gfs2: Don't demote a glock until its revokes are written

Boqun Feng (1):
      locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps=
()

Changwei Ge (1):
      ocfs2: no need try to truncate file beyond i_size

Chris Wilson (5):
      sched/vtime: Prevent unstable evaluation of WARN(vtime->state)
      drm/i915/gem: Flush all the reloc_gpu batch
      drm: Remove PageReserved manipulation from drm_pci_alloc
      drm/i915/gt: Treat idling as a RPS downclock event
      drm/i915/gt: Fill all the unused space in the GGTT

Christian Gmeiner (1):
      drm/etnaviv: rework perfmon query infrastructure

Christoph Niedermaier (1):
      cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL

Christophe Leroy (4):
      selftests/vm: fix map_hugetlb length used for testing read and write
      selftests/powerpc: Add tlbie_test in .gitignore
      powerpc/kprobes: Ignore traps that happened in real mode
      powerpc/kasan: Fix kasan_remap_early_shadow_ro()

Claudiu Beznea (1):
      clocksource/drivers/timer-microchip-pit64b: Fix rate for gck

Clement Courbet (1):
      powerpc: Make setjmp/longjmp signature standard

C=C3=A9dric Le Goater (2):
      powerpc/xive: Use XIVE_BAD_IRQ instead of zero to catch non configure=
d IPIs
      powerpc/xive: Fix xmon support on the PowerNV platform

Dafna Hirschfeld (1):
      media: vimc: streamer: fix memory leak in vimc subdevs if kthread_run=
 fails

Dan Carpenter (1):
      crypto: rng - Fix a refcounting bug in crypto_rng_reset()

Daniel Axtens (1):
      powerpc/64: Setup a paca before parsing device tree etc.

Daniele Ceraolo Spurio (1):
      drm/i915/ggtt: do not set bits 1-11 in gen12 ptes

Dave Gerlach (1):
      arm64: dts: ti: k3-am65: Add clocks to dwc3 nodes

David Hildenbrand (2):
      KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
      KVM: s390: vsie: Fix delivery of addressing exceptions

Dmitry Safonov (1):
      time/namespace: Add max_time_namespaces ucount

Dongchun Zhu (1):
      media: i2c: ov5695: Fix power on and off sequences

Eric Auger (1):
      vfio: platform: Switch to platform_get_irq_optional()

Eric Biggers (2):
      fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_onc=
e()
      kmod: make request_module() return an error when autoloading is disab=
led

Eric W. Biederman (1):
      signal: Extend exec_id to 64bits

Fabiano Rosas (1):
      KVM: PPC: Book3S HV: Skip kvmppc_uvmem_free if Ultravisor is not supp=
orted

Filipe Manana (2):
      Btrfs: fix crash during unmount due to race with delayed inode workers
      btrfs: fix missing file extent item for hole after ranged fsync

Fredrik Strupe (1):
      arm64: armv8_deprecated: Fix undef_hook mask for thumb setend

Frieder Schrempf (2):
      mtd: spinand: Stop using spinand->oobbuf for buffering bad block mark=
ers
      mtd: spinand: Do not erase the block before writing a bad block marker

Gao Xiang (1):
      erofs: correct the remaining shrink objects

Gary Lin (1):
      efi/x86: Fix the deletion of variables in mixed mode

Gayatri Kammela (1):
      thermal: int340x_thermal: fix: Update Tiger Lake ACPI device IDs

Gilad Ben-Yossef (3):
      crypto: ccree - protect against empty or NULL scatterlists
      crypto: ccree - only try to map auth tag if needed
      crypto: ccree - dec auth tag size from cryptlen map

Greg Kroah-Hartman (1):
      Linux 5.6.5

Guoqing Jiang (1):
      md: check arrays is suspended in mddev_detach before call quiesce ope=
rations

Gustavo A. R. Silva (1):
      MIPS: OCTEON: irq: Fix potential NULL pointer dereference

Hans de Goede (6):
      ALSA: hda/realtek - Add quirk for Lenovo Carbon X1 8th gen
      x86/tsc_msr: Use named struct initializers
      x86/tsc_msr: Fix MSR_FSB_FREQ mask for Cherry Trail devices
      x86/tsc_msr: Make MSR derived TSC frequency more accurate
      drm/vboxvideo: Add missing remove_conflicting_pci_framebuffers call, =
v2
      Input: i8042 - add Acer Aspire 5738z to nomux list

Helen Koike (2):
      media: staging: rkisp1: use consistent bus_info string for media_dev
      media: staging: rkisp1: isp: do not set invalid mbus code for pad

Horia Geant=C4=83 (1):
      crypto: caam/qi2 - fix chacha20 data size error

Hsin-Yi Wang (1):
      media: mtk-vpu: avoid unaligned access to DTCM buffer.

Huacai Chen (1):
      MIPS/tlbex: Fix LDDIR usage in setup_pw() for Loongson-3

Hui Wang (1):
      ALSA: hda/realtek - a fake key event is triggered by running shutup

Imre Deak (1):
      drm/i915/icl+: Don't enable DDI IO power on a TypeC port in TBT mode

J. Bruce Fields (1):
      nfsd: fsnotify on rmdir under nfsd/clients/

Jakub Kicinski (1):
      mm, memcg: do not high throttle allocators based on wraparound

James Morse (1):
      firmware: arm_sdei: fix double-lock on hibernate with shared events

James Smart (3):
      nvme-fc: Revert "add module to ops template to allow module reference=
s"
      scsi: lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 err=
or path
      scsi: lpfc: Fix broken Credit Recovery after driver load

Jan Engelhardt (1):
      acpi/x86: ignore unspecified bit positions in the ACPI global lock fi=
eld

Jann Horn (1):
      bpf: Fix tnum constraints for 32-bit comparisons

Jens Axboe (3):
      io_uring: ensure openat sets O_LARGEFILE if needed
      io_uring: remove bogus RLIMIT_NOFILE check in file registration
      io_uring: honor original task RLIMIT_FSIZE

John Garry (1):
      libata: Remove extra scsi_host_put() in ata_scsi_add_hosts()

Josef Bacik (9):
      btrfs: remove a BUG_ON() from merge_reloc_roots()
      btrfs: restart relocate_tree_blocks properly
      btrfs: track reloc roots based on their commit root bytenr
      btrfs: fix btrfs_calc_reclaim_metadata_size calculation
      btrfs: reloc: clean dirty subvols if we fail to start a transaction
      btrfs: set update the uuid generation as soon as possible
      btrfs: drop block from cache on error in relocation
      btrfs: unset reloc control if we fail to recover
      btrfs: use nofs allocations for running delayed items

Juergen Gross (1):
      xen/blkfront: fix memory allocation flags in blkfront_setup_indirect()

Julia Lawall (1):
      ASoC: stm32: sai: Add missing cleanup

Junyong Sun (1):
      firmware: fix a double abort case with fw_load_sysfs_fallback

Kai-Heng Feng (2):
      ALSA: hda/realtek: Enable mute LED on an HP system
      libata: Return correct status in sata_pmp_eh_recover_pm() when ATA_DF=
LAG_DETACH is set

Kishon Vijay Abraham I (1):
      PCI: endpoint: Fix for concurrent memory allocation in OB address reg=
ion

Konstantin Khlebnikov (1):
      block: keep bdi->io_pages in sync with max_sectors_kb for stacked dev=
ices

Kristian Klausen (1):
      platform/x86: asus-wmi: Support laptops where the first battery is na=
med BATT

Krzysztof Kozlowski (1):
      usb: phy: tegra: Include proper GPIO consumer header to fix compile t=
esting

Laurent Pinchart (2):
      media: imx: imx7_mipi_csis: Power off the source when stopping stream=
ing
      media: imx: imx7-media-csi: Fix video field handling

Laurentiu Tudor (1):
      powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

Libor Pechacek (1):
      powerpc/pseries: Avoid NULL pointer dereference when drmem is unavail=
able

Logan Gunthorpe (1):
      PCI/switchtec: Fix init_completion race condition with poll_wait()

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: check return value from st_lsm6dsx_sensor_set_e=
nable

Ludovic Barre (1):
      mmc: mmci_sdmmc: Fix clear busyd0end irq flag

Lukas Wunner (1):
      PCI: pciehp: Fix indefinite wait on sysfs requests

Lyude Paul (2):
      Revert "drm/dp_mst: Remove VCPI while disabling topology mgr"
      drm/dp_mst: Fix clearing payload state on topology disable

Marc Zyngier (2):
      irqchip/gic-v4.1: Skip absent CPUs while iterating over redistributors
      irqchip/gic-v4: Provide irq_retrigger to avoid circular locking depen=
dency

Marek Szyprowski (2):
      ARM: dts: exynos: Fix polarity of the LCD SPI bus on UniversalC210 bo=
ard
      drm/prime: fix extracting of the DMA addresses from a scatterlist

Mark Brown (1):
      arm64: Always force a branch protection mode when the compiler has one

Martin Blumenstingl (1):
      thermal: devfreq_cooling: inline all stubs for CONFIG_DEVFREQ_THERMAL=
=3Dn

Masami Hiramatsu (1):
      ftrace/kprobe: Show the maxactive number on kprobe_events

Mathias Nyman (1):
      xhci: bail out early if driver can't accress host in resume

Matt Ranostay (1):
      media: i2c: video-i2c: fix build errors due to 'imply hwmon'

Matthew Garrett (1):
      tpm: Don't make log failures fatal

Matthew Wilcox (Oracle) (2):
      XArray: Fix xas_pause for large multi-index entries
      xarray: Fix early termination of xas_for_each_marked

Maxime Ripard (2):
      arm64: dts: allwinner: h6: Fix PMU compatible
      arm64: dts: allwinner: h5: Fix PMU compatible

Merlijn Wajer (1):
      scsi: sr: get rid of sr global mutex

Michael Ellerman (3):
      selftests/powerpc: Fix try-run when source tree is not writable
      powerpc/64/tm: Don't let userspace set regs->trap via sigreturn
      powerpc/64: Prevent stack protection in early boot

Michael Kerrisk (man-pages) (1):
      time/namespace: Fix time_for_children symlink

Michael Mueller (1):
      s390/diag: fix display of diagnose call statistics

Michael Strauss (1):
      drm/amd/display: Check for null fclk voltage when parsing clock table

Michael Tretter (1):
      media: allegro: fix type of gop_length in channel_create message

Michael Wang (1):
      sched: Avoid scale real weight down to zero

Michal Hocko (1):
      selftests: vm: drop dependencies on page flags from mlock2 tests

Mike Willard (1):
      ASoC: cs4270: pull reset GPIO low then high

Mikulas Patocka (2):
      dm writecache: add cond_resched to avoid CPU hangs
      dm integrity: fix a crash with unusually large tag size

Mohammad Rasim (2):
      media: rc: add keymap for Videostrong KII Pro
      media: arm64: dts: amlogic: add rc-videostrong-kii-pro keymap

Murphy Zhou (1):
      CIFS: check new file size when extending file by fallocate

Neeraj Upadhyay (1):
      PM: sleep: wakeup: Skip wakeup_source_sysfs_remove() if device is not=
 there

Neil Armstrong (1):
      usb: dwc3: core: add support for disabling SS instances in park mode

Nikita Shubin (1):
      remoteproc: Fix NULL pointer dereference in rproc_virtio_notify

Nikos Tsironis (4):
      dm clone: Fix handling of partial region discards
      dm clone: Add overflow check for number of regions
      dm clone: Add missing casts to prevent overflows and data corruption
      dm clone metadata: Fix return type of dm_clone_nr_of_hydrated_regions=
()

Oliver O'Halloran (1):
      cpufreq: powernv: Fix use-after-free

Paolo Valente (1):
      block, bfq: move forward the getting of an extra ref in bfq_bfqq_move

Paul Cercueil (2):
      clk: ingenic/jz4770: Exit with error if CGU init failed
      clk: ingenic/TCU: Fix round_rate returning error

Paul E. McKenney (1):
      rcu: Make rcu_barrier() account for offline no-CBs CPUs

Pavel Begunkov (1):
      io_uring: fix ctx refcounting in io_submit_sqes()

Peng Fan (1):
      cpufreq: imx6q: fix error handling

Peter Zijlstra (3):
      perf/core: Unify {pinned,flexible}_sched_in()
      perf/core: Fix event cgroup tracking
      perf/core: Remove 'struct sched_in_data'

Philipp Zabel (1):
      media: hantro: fix extra MV/MC sync space calculation

Piotr Sroka (3):
      mtd: rawnand: cadence: fix the calculation of the avaialble OOB size
      mtd: rawnand: cadence: change bad block marker size
      mtd: rawnand: cadence: reinit completion before executing a new comma=
nd

Prike Liang (2):
      drm/amd/powerplay: implement the is_dpm_running()
      drm/amdgpu: fix gfx hang during suspend with video playback (v2)

Qian Cai (1):
      ext4: fix a data race at inode->i_blocks

Qu Wenruo (2):
      btrfs: qgroup: ensure qgroup_rescan_running is only set when the work=
er is at least queued
      btrfs: Don't submit any btree write bio if the fs has errors

Rafael J. Wysocki (4):
      ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()
      ACPI: EC: Avoid printing confusing messages in acpi_ec_setup()
      ACPICA: Allow acpi_any_gpe_status_set() to skip one GPE
      ACPI: PM: s2idle: Refine active GPEs check

Remi Pommarel (1):
      ath9k: Handle txpower changes even when TPC is disabled

Robbie Ko (1):
      btrfs: fix missing semaphore unlock in btrfs_sync_file

Robert Richter (1):
      EDAC/mc: Report "unknown memory" on too many DIMM labels found

Rosioru Dragos (1):
      crypto: mxs-dcp - fix scatterlist linearization for hash

Sagi Grimberg (1):
      nvmet-tcp: fix maxh2cdata icresp parameter

Sahitya Tummala (1):
      block: Fix use-after-free issue accessing struct io_cq

Sam Lunt (1):
      perf tools: Support Python 3.8+ in Makefile

Scott Mayhew (1):
      NFS: Fix a few constant_table array definitions

Scott Wood (1):
      sched/core: Remove duplicate assignment in sched_tick_remote()

Sean Christopherson (5):
      KVM: nVMX: Properly handle userspace interrupt window request
      KVM: x86: Allocate new rmap and large page tracking when moving memsl=
ot
      KVM: VMX: Always VMCLEAR in-use VMCSes during crash with kexec support
      KVM: x86: Gracefully handle __vmalloc() failure during VM allocation
      KVM: VMX: Add a trampoline to fix VMREAD error handling

Sean V Kelley (1):
      PCI: Add boot interrupt quirk mechanism for Xeon chipsets

Sergio Paracuellos (1):
      staging: mt7621-pci: avoid to poweroff the phy for slot one

Shetty, Harshini X (EXT-Sony Mobile) (1):
      dm verity fec: fix memory leak in verity_fec_dtr

Sibi Sankar (1):
      remoteproc: qcom_q6v5_mss: Reload the mba region on coredump

Simon Gander (1):
      hfsplus: fix crash and filesystem corruption when deleting files

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Sriharsha Allenki (1):
      usb: gadget: f_fs: Fix use after free issue as part of queue failure

Stanimir Varbanov (2):
      media: venus: cache vb payload to be used by clock scaling
      media: venus: firmware: Ignore secure call error on first resume

Stanley Chu (1):
      scsi: ufs: fix Auto-Hibern8 error detection

Steffen Maier (1):
      scsi: zfcp: fix missing erp_lock in port recovery trigger for point-t=
o-point

Stephan Gerhold (1):
      media: venus: hfi_parser: Ignore HEVC encoding for V1

Steve French (1):
      smb3: fix performance regression with setting mtime

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Allow configuration updates to existing devices

Sungbo Eo (2):
      irqchip/versatile-fpga: Handle chained IRQs properly
      irqchip/versatile-fpga: Apply clear-mask earlier

Sven Schnelle (1):
      seccomp: Add missing compat_ioctl for notify

Taehee Yoo (1):
      debugfs: Check module state before warning in {full/open}_proxy_open()

Takashi Iwai (6):
      ALSA: usb-audio: Add mixer workaround for TRX40 and co
      ALSA: hda: Add driver blacklist
      ALSA: hda: Fix potential access overflow in beep helper
      ALSA: ice1724: Fix invalid access for enumerated ctl items
      ALSA: pcm: oss: Fix regression by buffer overflow fix
      ALSA: hda/realtek - Add quirk for MSI GL63

Tao Zhou (1):
      sched/fair: Fix condition of avg_load calculation

Thinh Nguyen (1):
      usb: gadget: composite: Inform controller driver of self-powered

Thomas Gleixner (3):
      cpu/hotplug: Ignore pm_wakeup_pending() for disable_nonboot_cpus()
      genirq/debugfs: Add missing sanity checks to interrupt injection
      x86/entry/32: Add missing ASM_CLAC to general_protection entry

Thomas Hebb (3):
      ALSA: doc: Document PC Beep Hidden Register on Realtek ALC256
      ALSA: hda/realtek - Set principled PC Beep configuration for ALC256
      ALSA: hda/realtek - Remove now-unnecessary XPS 13 headphone noise fix=
ups

Thomas Hellstrom (2):
      x86: Don't let pgprot_modify() change the page encryption bit
      dma-mapping: Fix dma_pgprot() for unencrypted coherent pages

Tom Lendacky (1):
      efi/x86: Add TPM related EFI tables to unencrypted mapping checks

Torsten Duwe (1):
      drm/bridge: analogix-anx78xx: Fix drm_dp_link helper removal

Trond Myklebust (3):
      NFS: Fix use-after-free issues in nfs_pageio_add_request()
      NFS: Fix a page leak in nfs_destroy_unlinked_subrequests()
      NFS: finish_automount() requires us to hold 2 refs to the mount record

Tvrtko Ursulin (1):
      drm/i915/gen12: Disable preemption timeout

Ulf Hansson (1):
      PM / Domains: Allow no domain-idle-states DT property in genpd when p=
arsing

Vasily Averin (3):
      tpm: tpm1_bios_measurements_next should increase position index
      tpm: tpm2_bios_measurements_next should increase position index
      pstore: pstore_ftrace_seq_next should increase position index

Vincent Guittot (1):
      sched/fair: Fix enqueue_task_fair warning

Vitaly Kuznetsov (1):
      KVM: VMX: fix crash cleanup when KVM wasn't used

Vladimir Oltean (2):
      spi: spi-fsl-dspi: Avoid NULL pointer in dspi_slave_abort for non-DMA=
 mode
      spi: spi-fsl-dspi: Replace interruptible wait queue with a simple com=
pletion

Wen Yang (1):
      ipmi: fix hung processes in __get_guid()

Yang Xu (1):
      KEYS: reaching the keys quotas correctly

Yicong Yang (1):
      PCI/ASPM: Clear the correct bits when enabling L1 substates

Yilu Lin (1):
      CIFS: Fix bug which the return value by asynchronous read is error

Yuxian Dai (1):
      drm/amdgpu/powerplay: using the FCLK DPM table to set the MCLK

Zhiqiang Liu (1):
      block, bfq: fix use-after-free in bfq_idle_slice_timer_body

chenqiwu (1):
      pstore/platform: fix potential mem leak if pstore_init_fs failed

=EC=9D=B4=EA=B2=BD=ED=83=9D (4):
      ASoC: fix regwmask
      ASoC: dapm: connect virtual mux with default value
      ASoC: dpcm: allow start or stop during pause for backend
      ASoC: topology: use name_prefix for new kcontrol


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6ZxwoACgkQONu9yGCS
aT7dTRAAnc0TbfUdJuNq5Q1tUFbWPrPpcZx3i5vb7TZMYyU31OZCSqB/p8qtEqkF
DkDTW/Oauxe0gm8KVGf05X1aytaMDIzwT4ogu2oAHuq+DlmDsaT684i4oxB3z6ZJ
9sLhBg8gIwvM3toa8ad/Ukltr96fv5UFMGQweF2GRVmxXMvCBlN/14V8Cuy3kxao
lwN2+Kh/FrLXelYqCRQHPSeOYasX5mHQ4O+C8PR4/nVucz9Q9r5howYdwuSPgkFe
UnPKsA+G9L4a2zh9dS0M1X2WNFHwZbOeiF9VnGdo3oo3wMApOwIPlFzW3orZAwmx
2ll+v9xKWJXf1jZa4uHDwb2XtAp+OmrlPfzzd2FdUUNKrPvwzT+jvrcVbcx3zOD8
jMPh8xw2SHqT99fofvR34FdzuGvV18rRJXwmOjnf99nbT46YBdd0K3j12KXqtlGK
/pKdsoQA1iLZDVEpTu6mErHbhUZqN3YiKiGj21auCKRyHoKnSPDEUkcwaf+EeHGy
xM3gwrjX8kgumpWiA+aEhznQqyyRCvCtuwTahZnkE5xFrP7yWhlSDTPGHtLTy3PZ
JfFebLAKQEvrhYxrXM9Owvi4WC0KK1rml5BhFwcSexdg5ehjkyEGFuB+2LVIfrSI
v8PwvufFXY2eTDLXeyRozO9FMnckC2P/+rU14SHfbJuru3iojcQ=
=nVrl
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
