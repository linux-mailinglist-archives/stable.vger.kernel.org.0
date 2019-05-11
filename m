Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF501A6F8
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 08:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfEKGuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 May 2019 02:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbfEKGuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 May 2019 02:50:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B71382173B;
        Sat, 11 May 2019 06:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557557411;
        bh=4IhOj9QaAvgqWlLLTiHndZMxIERt5Bf8iGMtOcsq3Ak=;
        h=Date:From:To:Cc:Subject:From;
        b=b1URc2fbJTRE2Q/HJfo6y5binyw6/fxzYWMjVRCy1YKtIqfaJR+AGpQXiONO3F4MK
         V/YpWcPh7Bfj2OXRB5dKBZePwwXjoQEWDgSsrepFkGueVFtWr97h35ra7jLBzmNiwj
         34yXWsbVx3Qaj5Vb6mEVBg+tGY+qdaK7yOFbhUUw=
Date:   Sat, 11 May 2019 08:50:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.15
Message-ID: <20190511065009.GA27515@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.15 kernel.

All users of the 5.0 kernel series must upgrade.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
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
 arch/xtensa/include/asm/processor.h                 |   21=20
 block/blk-mq.c                                      |    7=20
 drivers/acpi/acpi_lpss.c                            |    4=20
 drivers/block/virtio_blk.c                          |    2=20
 drivers/bluetooth/hci_bcm.c                         |   20=20
 drivers/clk/meson/gxbb.c                            |    2=20
 drivers/cpufreq/armada-37xx-cpufreq.c               |   22=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c          |   13=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c              |    3=20
 drivers/gpu/drm/amd/amdkfd/kfd_device.c             |    1=20
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   |    1=20
 drivers/gpu/drm/mediatek/mtk_dpi.c                  |    8=20
 drivers/gpu/drm/mediatek/mtk_hdmi.c                 |    2=20
 drivers/gpu/drm/mediatek/mtk_hdmi_phy.c             |   35 -
 drivers/gpu/drm/mediatek/mtk_hdmi_phy.h             |    5=20
 drivers/gpu/drm/mediatek/mtk_mt2701_hdmi_phy.c      |   49 +-
 drivers/gpu/drm/mediatek/mtk_mt8173_hdmi_phy.c      |   23 +
 drivers/gpu/drm/omapdrm/dss/hdmi4_cec.c             |   26 -
 drivers/gpu/drm/sun4i/sun8i_tcon_top.c              |    5=20
 drivers/hv/hv.c                                     |    1=20
 drivers/hwtracing/intel_th/pci.c                    |    5=20
 drivers/i3c/master.c                                |    5=20
 drivers/iio/adc/qcom-spmi-adc5.c                    |    1=20
 drivers/infiniband/hw/hfi1/chip.c                   |   26 -
 drivers/infiniband/hw/hfi1/qp.c                     |    2=20
 drivers/infiniband/hw/hfi1/rc.c                     |    4=20
 drivers/infiniband/hw/hns/hns_roce_hem.c            |    6=20
 drivers/infiniband/hw/hns/hns_roce_mr.c             |    4=20
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c      |    2=20
 drivers/iommu/amd_iommu_init.c                      |    2=20
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c     |    2=20
 drivers/nvme/host/core.c                            |    2=20
 drivers/nvme/host/fc.c                              |   20=20
 drivers/nvme/target/admin-cmd.c                     |    5=20
 drivers/nvme/target/discovery.c                     |   68 +-
 drivers/nvme/target/nvmet.h                         |    1=20
 drivers/platform/x86/pmc_atom.c                     |    2=20
 drivers/scsi/csiostor/csio_scsi.c                   |    5=20
 drivers/scsi/lpfc/lpfc_attr.c                       |  192 ++++----
 drivers/scsi/lpfc/lpfc_ct.c                         |   12=20
 drivers/scsi/lpfc/lpfc_debugfs.c                    |  455 ++++++++++-----=
-----
 drivers/scsi/lpfc/lpfc_debugfs.h                    |    6=20
 drivers/scsi/qla2xxx/qla_attr.c                     |    4=20
 drivers/scsi/qla2xxx/qla_target.c                   |    4=20
 drivers/soc/sunxi/Kconfig                           |    1=20
 drivers/staging/greybus/power_supply.c              |    2=20
 drivers/staging/most/cdev/cdev.c                    |    2=20
 drivers/staging/most/sound/sound.c                  |    2=20
 drivers/staging/wilc1000/linux_wlan.c               |    2=20
 drivers/usb/class/cdc-acm.c                         |   32 +
 drivers/usb/dwc3/Kconfig                            |    6=20
 drivers/usb/dwc3/core.c                             |    2=20
 drivers/usb/musb/Kconfig                            |    2=20
 drivers/usb/serial/f81232.c                         |   39 +
 drivers/usb/storage/scsiglue.c                      |   26 -
 drivers/usb/storage/uas.c                           |   35 -
 drivers/virtio/virtio_pci_common.c                  |    8=20
 fs/nfs/nfs42proc.c                                  |    3=20
 fs/nfs/nfs4file.c                                   |    4=20
 include/keys/trusted.h                              |    2=20
 include/linux/blk-mq.h                              |    1=20
 include/linux/kernel.h                              |    4=20
 include/linux/nvme.h                                |    9=20
 include/net/bluetooth/hci_core.h                    |    3=20
 include/sound/soc.h                                 |    2=20
 kernel/events/core.c                                |   52 +-
 kernel/events/ring_buffer.c                         |    4=20
 kernel/futex.c                                      |  188 +++++---
 kernel/irq/manage.c                                 |    4=20
 lib/iov_iter.c                                      |    4=20
 lib/ubsan.c                                         |   49 +-
 mm/slab.c                                           |    3=20
 net/bluetooth/hci_conn.c                            |    8=20
 net/bluetooth/hidp/sock.c                           |    1=20
 net/bluetooth/l2cap_core.c                          |    9=20
 security/keys/trusted.c                             |    4=20
 sound/hda/ext/hdac_ext_bus.c                        |    1=20
 sound/hda/hdac_bus.c                                |    1=20
 sound/hda/hdac_component.c                          |    6=20
 sound/soc/codecs/cs35l35.c                          |   11=20
 sound/soc/codecs/cs4270.c                           |    1=20
 sound/soc/codecs/hdac_hda.c                         |   53 +-
 sound/soc/codecs/hdac_hda.h                         |    1=20
 sound/soc/codecs/hdmi-codec.c                       |  118 ++---
 sound/soc/codecs/nau8810.c                          |    4=20
 sound/soc/codecs/nau8824.c                          |   46 +-
 sound/soc/codecs/rt5682.c                           |   56 +-
 sound/soc/codecs/tlv320aic32x4.c                    |    2=20
 sound/soc/codecs/tlv320aic3x.c                      |    5=20
 sound/soc/codecs/wm_adsp.c                          |   11=20
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c |    2=20
 sound/soc/intel/common/sst-firmware.c               |    8=20
 sound/soc/intel/skylake/skl-pcm.c                   |   19=20
 sound/soc/rockchip/rockchip_pdm.c                   |    2=20
 sound/soc/samsung/odroid.c                          |    4=20
 sound/soc/soc-core.c                                |    1=20
 sound/soc/soc-dapm.c                                |    4=20
 sound/soc/soc-pcm.c                                 |   47 +-
 sound/soc/stm/stm32_adfsdm.c                        |   38 +
 sound/soc/stm/stm32_sai_sub.c                       |   92 +++-
 tools/objtool/check.c                               |    1=20
 105 files changed, 1381 insertions(+), 819 deletions(-)

Alan Stern (1):
      usb-storage: Set virt_boundary_mask to avoid SG overflows

Alex Deucher (1):
      drm/amdkfd: Add picasso pci id

Alexander Shishkin (1):
      intel_th: pci: Add Comet Lake support

Andrew Vasquez (1):
      scsi: qla2xxx: Fix incorrect region-size setting in optrom SYSFS rout=
ines

Andrey Ryabinin (1):
      ubsan: Fix nasty -Wbuiltin-declaration-mismatch GCC-9 warnings

Annaliese McDermond (1):
      ASoC: tlv320aic32x4: Fix Common Pins

Bjorn Andersson (1):
      iio: adc: qcom-spmi-adc5: Fix of-based module autoloading

Charles Keepax (2):
      ASoC: wm_adsp: Add locking to wm_adsp2_bus_error
      ASoC: cs35l35: Disable regulators on driver removal

Chen-Yu Tsai (1):
      Bluetooth: hci_bcm: Fix empty regulator supplies for Intel Macs

Chong Qiao (1):
      MIPS: KGDB: fix kgdb support for SMP platforms.

Christian Gromm (1):
      staging: most: sound: pass correct device when creating a sound card

Dan Carpenter (2):
      drm/mediatek: Fix an error code in mtk_hdmi_dt_parse_pdata()
      i3c: Fix a shift wrap bug in i3c_bus_set_addr_slot_status()

Daniel Mack (1):
      ASoC: cs4270: Set auto-increment bit for register writes

Dexuan Cui (1):
      Drivers: hv: vmbus: Remove the undesired put_cpu_ptr() in hv_synic_cl=
eanup()

Dongli Zhang (1):
      virtio-blk: limit number of hw queues by nr_cpu_ids

Greg Kroah-Hartman (1):
      Linux 5.0.15

Gregory CLEMENT (1):
      cpufreq: armada-37xx: fix frequency calculation for opp

Hans de Goede (1):
      ACPI / LPSS: Use acpi_lpss_* instead of acpi_subsys_* functions for h=
ibernate

James Smart (1):
      nvme-fc: correct csn initialization and increments on error

Jann Horn (1):
      linux/kernel.h: Use parentheses around argument in u64_to_user_ptr()

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

KaiChieh Chuang (1):
      ASoC: dpcm: prevent snd_soc_dpcm use after free

Kaike Wan (3):
      IB/hfi1: Clear the IOWAIT pending bits when QP is put into error state
      IB/hfi1: Eliminate opcode tests on mr deref
      IB/hfi1: Fix the allocation of RSM table

Kamal Heib (1):
      RDMA/vmw_pvrdma: Fix memory leak on pvrdma_pci_remove

Keith Busch (1):
      nvmet: fix discover log page when offsets are used

Lijun Ou (1):
      RDMA/hns: Fix bug that caused srq creation to fail

Longpeng (1):
      virtio_pci: fix a NULL pointer reference in vp_del_vqs

Luiz Augusto von Dentz (1):
      Bluetooth: Fix not initializing L2CAP tx_credits

Marc Gonzalez (1):
      usb: dwc3: Allow building USB_DWC3_QCOM without EXTCON

Marcel Holtmann (1):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions

Max Filippov (1):
      xtensa: fix initialization of pt_regs::syscall in start_thread

Maxime Jourdan (1):
      clk: meson-gxbb: round the vdec dividers to closest

Ming Lei (2):
      blk-mq: introduce blk_mq_complete_request_sync()
      nvme: cancel request synchronously

Olga Kornievskaia (1):
      NFSv4.1 fix incorrect return value in copy_file_range

Oliver Neukum (1):
      UAS: fix alignment of scatter/gather segments

Olivier Moysan (6):
      ASoC: stm32: sai: fix iec958 controls indexation
      ASoC: stm32: sai: fix exposed capabilities in spdif mode
      ASoC: stm32: sai: fix race condition in irq handler
      ASoC: stm32: dfsdm: manage multiple prepare
      ASoC: stm32: dfsdm: fix debugfs warnings on entry creation
      ASoC: stm32: sai: fix master clock management

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

Rander Wang (3):
      ASoC:soc-pcm:fix a codec fixup issue in TDM case
      ASoC:hdac_hda:use correct format to setup hda codec
      ASoC:intel:skl:fix a simultaneous playback & capture issue on hda pla=
tform

Ross Zwisler (1):
      ASoC: Intel: avoid Oops if DMA setup fails

Russell King (1):
      ASoC: hdmi-codec: fix S/PDIF DAI

Samuel Holland (1):
      soc: sunxi: Fix missing dependency on REGMAP_MMIO

Shuming Fan (3):
      ASoC: rt5682: Check JD status when system resume
      ASoC: rt5682: fix jack type detection issue
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

Takashi Iwai (1):
      ALSA: hda: Fix racy display power access

Tetsuo Handa (1):
      staging: wilc1000: Avoid GFP_KERNEL allocation from atomic context.

Thinh Nguyen (1):
      usb: dwc3: Fix default lpm_nyet_threshold value

Tony Lindgren (1):
      drm/omap: hdmi4_cec: Fix CEC clock handling for PM

Tzung-Bi Shih (1):
      ASoC: Intel: kbl: fix wrong number of channels

Varun Prakash (1):
      scsi: csiostor: fix missing data copy in csio_scsi_err_handler()

Wangyan Wang (5):
      drm/mediatek: fix the rate and divder of hdmi phy for MT2701
      drm/mediatek: make implementation of recalc_rate() for MT2701 hdmi phy
      drm/mediatek: remove flag CLK_SET_RATE_PARENT for MT2701 hdmi phy
      drm/mediatek: using new factor for tvdpll for MT2701 hdmi phy
      drm/mediatek: no change parent rate in round_rate() for MT2701 hdmi p=
hy

Wen Yang (1):
      drm/mediatek: fix possible object reference leak

Will Deacon (2):
      locking/futex: Allow low-level atomic operations to return -EAGAIN
      arm64: futex: Bound number of LDXR/STXR loops in FUTEX_WAKE_OP

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow

YueHaibing (2):
      net: stmmac: Use bfsize1 in ndesc_init_rx_desc
      iov_iter: Fix build error without CONFIG_CRYPTO

ndesaulniers@google.com (1):
      KEYS: trusted: fix -Wvarags warning

shaoyunl (1):
      drm/amdgpu: Adjust IB test timeout for XGMI configuration

tiancyin (1):
      drm/amd/display: fix cursor black issue

wentalou (1):
      drm/amdgpu: amdgpu_device_recover_vram always failed if only one node=
 in shadow_list


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzWcKAACgkQONu9yGCS
aT5qjg/+MnCI0Lo49YaQ/F/oE/y2pdj0w9jZm3kvxiiozdDYrgZO1i+BB5RA3JiP
THS5E5dfOYe2t1ZYbvHPLPeva0EJJOlJpsz0fkAgbTMNVFK7R3kFR/4JUjVjg19C
3RjzHPqiFD52RVpuEmphuBjWHYJjVS2/mMqiUrif8LQ5V5nFlYyTdWZGpQnE2dYP
uWRNLp3T1eKOfNQxkJyWlttcudmzuQ0aohBRXEyKIuefLBouch2I2eae4c8fd+uN
K+IhXBBBRZkSMOiH1NEaCLtYYh04LDjYXxNoxVrFjsN2HqcuefJfcuFzfp7smrnZ
jsiMBRci28dwK42QSqHcHMpL5d7D9ZsUxvTh3gd0QLVWAPBuYN+7HPwOcepVpJTu
RqzEJOVBFCWpotPDSFeWyiE4xt8JyZjZf3jTDDgOEM99/iMIqi345kn9kmj0TcHH
qel3SMmtLKLNphYvrrbg9HwBwQU9YKsWOoFbyK1olJ36Gry+pzvhjZLz8JbX5DQw
RHW6bR0Oo8K4aWeUFrVcpU4KdxbjDP78OowS/B9FCx6G8wADwmwi1npnXWIjQRWN
uxTb2IXQosUuhewQBZX+PlCg8cBwsfj3RXB/D1mLHRG2oWcMV1By4K6jlFaB7SrE
z7RyVizy2sarsfCPblb8zokcl1MNga6XnVtv45xmiN6dSUe8Ubc=
=CWJx
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
