Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45CE1A6F2
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 08:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfEKGtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 02:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfEKGtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 02:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABD262173B;
        Sat, 11 May 2019 06:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557557391;
        bh=ep7D9y1i3cc/1qmPa54dCXs2eV3dCiBQJhMJwd4+RxQ=;
        h=Date:From:To:Cc:Subject:From;
        b=eFCe5FCShbhMBvbDdD2lyaz8473SpbZfGVmhvLZ1Uz8/AXevwX3Rp9W7BCkycjpww
         CJ3oM/EsXyVvlljkVXy8ChRE6SH7SB1jcCjYM18AUdBj3hzA7JQ8e/IPFCIcBgUhdW
         8VaMYDZnD/hlxvl/nu/BD4TOHpzYeO8Hvz/9mPf8=
Date:   Sat, 11 May 2019 08:49:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.42
Message-ID: <20190511064948.GA27450@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.42 kernel.

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

 Makefile                                            |    2=20
 arch/arm64/include/asm/futex.h                      |   55 +-
 arch/mips/kernel/kgdb.c                             |    3=20
 arch/x86/events/intel/core.c                        |    8=20
 drivers/block/virtio_blk.c                          |    2=20
 drivers/clk/meson/gxbb.c                            |    2=20
 drivers/cpufreq/armada-37xx-cpufreq.c               |   22=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   |    1=20
 drivers/gpu/drm/mediatek/mtk_hdmi.c                 |    2=20
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c             |   26 -
 drivers/gpu/drm/sun4i/sun8i_tcon_top.c              |    5=20
 drivers/hv/hv.c                                     |    1=20
 drivers/hwtracing/intel_th/pci.c                    |    5=20
 drivers/infiniband/hw/hfi1/chip.c                   |   26 -
 drivers/infiniband/hw/hfi1/rc.c                     |    4=20
 drivers/infiniband/hw/hns/hns_roce_hem.c            |    6=20
 drivers/infiniband/hw/hns/hns_roce_mr.c             |    4=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c      |    2=20
 drivers/iommu/amd_iommu_init.c                      |    2=20
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c     |    2=20
 drivers/nvme/host/fc.c                              |   20=20
 drivers/platform/x86/pmc_atom.c                     |    2=20
 drivers/scsi/csiostor/csio_scsi.c                   |    5=20
 drivers/scsi/libsas/sas_expander.c                  |    9=20
 drivers/scsi/lpfc/lpfc_attr.c                       |  180 ++++---
 drivers/scsi/lpfc/lpfc_ct.c                         |   12=20
 drivers/scsi/lpfc/lpfc_debugfs.c                    |  453 ++++++++++-----=
-----
 drivers/scsi/lpfc/lpfc_debugfs.h                    |    6=20
 drivers/scsi/qla2xxx/qla_attr.c                     |    4=20
 drivers/scsi/qla2xxx/qla_target.c                   |    4=20
 drivers/soc/sunxi/Kconfig                           |    1=20
 drivers/staging/greybus/power_supply.c              |    2=20
 drivers/staging/most/cdev/cdev.c                    |    2=20
 drivers/usb/class/cdc-acm.c                         |   32 +
 drivers/usb/dwc3/core.c                             |    2=20
 drivers/usb/musb/Kconfig                            |    2=20
 drivers/usb/serial/f81232.c                         |   39 +
 drivers/usb/storage/scsiglue.c                      |   26 -
 drivers/usb/storage/uas.c                           |   35 -
 drivers/virtio/virtio_pci_common.c                  |    8=20
 include/linux/kernel.h                              |    4=20
 include/net/bluetooth/hci_core.h                    |    3=20
 kernel/events/core.c                                |   52 +-
 kernel/events/ring_buffer.c                         |    4=20
 kernel/futex.c                                      |  188 +++++---
 kernel/irq/manage.c                                 |    4=20
 lib/ubsan.c                                         |   49 +-
 mm/slab.c                                           |    3=20
 net/bluetooth/hci_conn.c                            |    8=20
 net/bluetooth/hidp/sock.c                           |    1=20
 sound/soc/codecs/cs35l35.c                          |   11=20
 sound/soc/codecs/cs4270.c                           |    1=20
 sound/soc/codecs/hdmi-codec.c                       |  118 ++---
 sound/soc/codecs/nau8810.c                          |    4=20
 sound/soc/codecs/nau8824.c                          |   46 +-
 sound/soc/codecs/rt5682.c                           |   14=20
 sound/soc/codecs/tlv320aic32x4.c                    |    2=20
 sound/soc/codecs/tlv320aic3x.c                      |    5=20
 sound/soc/codecs/wm_adsp.c                          |   11=20
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c |    2=20
 sound/soc/intel/common/sst-firmware.c               |    8=20
 sound/soc/intel/skylake/skl-pcm.c                   |   19=20
 sound/soc/rockchip/rockchip_pdm.c                   |    2=20
 sound/soc/samsung/odroid.c                          |    4=20
 sound/soc/soc-dapm.c                                |    4=20
 sound/soc/soc-pcm.c                                 |    7=20
 sound/soc/stm/stm32_adfsdm.c                        |   38 +
 sound/soc/stm/stm32_sai_sub.c                       |   15=20
 tools/objtool/check.c                               |    1=20
 69 files changed, 1006 insertions(+), 646 deletions(-)

Alan Stern (1):
      usb-storage: Set virt_boundary_mask to avoid SG overflows

Alexander Shishkin (1):
      intel_th: pci: Add Comet Lake support

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Andrey Ryabinin (1):
      ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Annaliese McDermond (1):
      ASoC: tlv320aic32x4: Fix Common Pins

Charles Keepax (2):
      ASoC: wm_adsp: Add locking to wm_adsp2_bus_error
      ASoC: cs35l35: Disable regulators on driver removal

Chong Qiao (1):
      MIPS: KGDB: fix kgdb support for SMP platforms.

Dan Carpenter (1):
      drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()

Daniel Mack (1):
      ASoC: cs4270: Set auto-increment bit for register writes

Dexuan Cui (1):
      Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cl=
eanup()

Dongli Zhang (1):
      virtio-blk: limit number of hw queues by nr_cpu_ids

Greg Kroah-Hartman (1):
      Linux 4.19.42

Gregory CLEMENT (1):
      cpufreq: armada-37xx: fix frequency calculation for opp

James Smart (1):
      nvme-fc: correct csn initialization and increments on error

Jann Horn (1):
      linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()

Jason Yan (1):
      scsi: libsas: fix a race condition when smp task timeout

Ji-Ze Hong (Peter Hong) (1):
      USB: serial: f81232: fix interrupt worker not stop

Joerg Roedel (1):
      iommu/amd: Set exclusion range correctly

Johan Hovold (2):
      staging: greybus: power_supply: fix prop-descriptor request size
      USB: cdc-acm: fix unthrottle races

John Hsu (2):
      ASoC: nau8824: fix the issue of the widget with prefix name
      ASoC: nau8810: fix the issue of widget with prefixed name

Josh Poimboeuf (1):
      objtool: Add rewind_stack_do_exit() to the noreturn list

Kaike Wan (2):
      IB/hfi1: Eliminate opcode tests on mr deref
      IB/hfi1: Fix the allocation of RSM table

Kamal Heib (1):
      RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove

Lijun Ou (1):
      RDMA/hns: Fix bug that caused srq creation to fail

Longpeng (1):
      virtio_pci: fix a NULL pointer reference in vp_del_vqs

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions

Maxime Jourdan (1):
      clk: meson-gxbb: round the vdec dividers to closest

Oliver Neukum (1):
      UAS: fix alignment of scatter/gather segments

Olivier Moysan (4):
      ASoC: stm32: sai: fix iec958 controls indexation
      ASoC: stm32: sai: fix exposed capabilities in spdif mode
      ASoC: stm32: dfsdm: manage multiple prepare
      ASoC: stm32: dfsdm: fix debugfs warnings on entry creation

Ondrej Jirman (1):
      drm/sun4i: tcon top: Fix NULL/invalid pointer dereference in sun8i_tc=
on_top_un/bind

Pankaj Bharadiya (1):
      ASoC: dapm: Fix NULL pointer dereference in snd_soc_dapm_free_kcontrol

Peter Zijlstra (2):
      perf/x86/intel: Initialize TFA MSR
      perf/core: Fix perf_event_disable_inatomic() race

Philipp Puschmann (1):
      ASoC: tlv320aic3x: fix reset gpio reference counting

Prasad Sodagudi (1):
      genirq: Prevent use-after-free and work list corruption

Qian Cai (1):
      slab: fix a crash by reading /proc/slab_allocators

Quinn Tran (1):
      scsi: qla2xxx: Fix device staying in blocked state

Rander Wang (2):
      ASoC:soc-pcm:fix a codec fixup issue in TDM case
      ASoC:intel:skl:fix a simultaneous playback & capture issue on hda pla=
tform

Ross Zwisler (1):
      ASoC: Intel: avoid Oops if DMA setup fails

Russell King (1):
      ASoC: hdmi-codec: fix S/PDIF DAI

Samuel Holland (1):
      soc: sunxi: Fix missing dependency on REGMAP_MMIO

Shuming Fan (1):
      ASoC: rt5682: recording has no sound after booting

Silvio Cesare (1):
      scsi: lpfc: change snprintf to scnprintf for possible overflow

Stephane Eranian (1):
      perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS

Stephen Boyd (1):
      platform/x86: pmc_atom: Drop __initconst on dmi table

Sugar Zhang (1):
      ASoC: rockchip: pdm: fix regmap_ops hang issue

Suresh Udipi (1):
      staging: most: cdev: fix chrdev_region leak in mod_exit

Sylwester Nawrocki (1):
      ASoC: samsung: odroid: Fix clock configuration for 44100 sample rate

Thinh Nguyen (1):
      usb: dwc3: Fix default lpm_nyet_threshold value

Tony Lindgren (1):
      drm/omap: hdmi4_cec: Fix CEC clock handling for PM

Tzung-Bi Shih (1):
      ASoC: Intel: kbl: fix wrong number of channels

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Wen Yang (1):
      drm/mediatek: fix possible object reference leak

Will Deacon (2):
      locking/futex: Allow low-level atomic operations to return -EAGAIN
      arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow

YueHaibing (1):
      net: stmmac: Use bfsize1 in ndesc_init_rx_desc

tiancyin (1):
      drm/amd/display: fix cursor black issue


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzWcIwACgkQONu9yGCS
aT70oA/+Kkyx3ZW05OiBY9r947itZIixQInILTZFz9e2C189g4S0Q8x0UP6GpI/A
p/kiZy0yXIvBv8vLIA2cHF9UqdWuBvx7RAe1/3iK0VZ3efmuLPfNDWa2cMTXnTPu
9hh6mby0iJV7A6tztSLkH4vl538TEZSPTPVJUfsRjnKsMEnkI5e2Drx5oRutfhKI
8S0rHGu74l+gPC3GfTHnJS7jWnlAhKpGnshF40NiatCoE5c4d4E5bzF1KPXKtZK/
sRWKLnONtragrGLXsA69riscZ4fRFhp51RJnrbWX0ETS3mvq9NvpRXiLRMsywbzl
vXKlA3x4ZXTQHOoB26jifBvP30+9Fc1RxY4ZMghH9Sz4830pg7xDJAvJbLjoqKLB
xVQBheoqD/7bEzk0Pdh6tAd2uBR+XkGFA3NalZz351+sQzJ8OBY1r4LNBf8DPO7Q
jcOIrww8AO5muG94gF5L5txdXt2+7SRzdZLx6dgFecJU0dNFA85B3fq7fyrepUU0
BVH1nJsEBJsP+NKJyGfDM3Sd48tkx3xWuDVipMJAkBGX9o+9pk3+C9zuTTzx8sib
xvtD2P62KAqSWbMx2iKzFHDbvvbQPUXqc6zKbuiBfAikCDFF0ezxgLr1sZyfj1Vx
nwzfnPnSkSaoIMFfJsqO2JZEm/gxm5BQ6nyyxWbrl/prorvE+Tc=
=xOL2
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
