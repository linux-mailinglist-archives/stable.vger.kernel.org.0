Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE51361AE
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 21:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgAIUZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 15:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgAIUZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 15:25:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F085206ED;
        Thu,  9 Jan 2020 20:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578601549;
        bh=KmmxjW/n0f5QkKq5zao0NaYxyvoPiSgtJ6eizMno8HM=;
        h=Date:From:To:Cc:Subject:From;
        b=O5TpSAa81ndCn5jCvuvLEMSiYB11hv2KwD7kofubtFIECgcleXXA5s/UNE5Db45KF
         Hf2Ao83gIMGKcTPeUvNkBv1N/MbmnaAEIdPjoVUHUXLRuusTEeBkCbnaLbXy++AAjj
         hCzcmFxqo5chDH1hAPlo4SOsdY/+rBaovnj5drH0=
Date:   Thu, 9 Jan 2020 21:25:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.163
Message-ID: <20200109202547.GA7640@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.163 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/clock/renesas,rcar-usb2-clock-sel.txt | =
   2=20
 Makefile                                                                | =
   2=20
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts                     | =
   4=20
 arch/arm64/include/asm/pgtable-prot.h                                   | =
   5=20
 arch/arm64/include/asm/pgtable.h                                        | =
  10=20
 arch/arm64/mm/fault.c                                                   | =
   2=20
 arch/mips/include/asm/thread_info.h                                     | =
  20 +
 arch/powerpc/platforms/pseries/hvconsole.c                              | =
   2=20
 arch/s390/kernel/perf_cpum_sf.c                                         | =
  22 +
 arch/s390/kernel/smp.c                                                  | =
  80 ++++---
 arch/x86/events/intel/bts.c                                             | =
  16 -
 block/compat_ioctl.c                                                    | =
  11=20
 drivers/ata/ahci_brcm.c                                                 | =
 112 +++++++---
 drivers/ata/libahci_platform.c                                          | =
   6=20
 drivers/block/xen-blkback/blkback.c                                     | =
   2=20
 drivers/block/xen-blkback/xenbus.c                                      | =
  10=20
 drivers/bluetooth/btusb.c                                               | =
   3=20
 drivers/devfreq/devfreq.c                                               | =
   8=20
 drivers/firewire/net.c                                                  | =
   6=20
 drivers/gpio/gpiolib.c                                                  | =
   8=20
 drivers/gpu/drm/drm_dp_mst_topology.c                                   | =
   6=20
 drivers/gpu/drm/drm_property.c                                          | =
   2=20
 drivers/gpu/drm/nouveau/nouveau_connector.h                             | =
 110 ++++-----
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                                  | =
   2=20
 drivers/iio/adc/max9611.c                                               | =
  16 -
 drivers/infiniband/core/cma.c                                           | =
   1=20
 drivers/infiniband/hw/mlx4/main.c                                       | =
   9=20
 drivers/infiniband/sw/rxe/rxe_recv.c                                    | =
   2=20
 drivers/infiniband/sw/rxe/rxe_req.c                                     | =
   6=20
 drivers/infiniband/sw/rxe/rxe_resp.c                                    | =
   7=20
 drivers/md/raid1.c                                                      | =
   2=20
 drivers/media/cec/cec-adap.c                                            | =
  20 +
 drivers/media/usb/b2c2/flexcop-usb.c                                    | =
   2=20
 drivers/media/usb/dvb-usb/af9005.c                                      | =
   5=20
 drivers/media/usb/pulse8-cec/pulse8-cec.c                               | =
  17 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                           | =
  23 +-
 drivers/nvme/host/fc.c                                                  | =
  14 +
 drivers/nvme/target/fcloop.c                                            | =
   1=20
 drivers/platform/x86/pmc_atom.c                                         | =
   8=20
 drivers/regulator/ab8500.c                                              | =
  17 -
 drivers/scsi/libsas/sas_discover.c                                      | =
  11=20
 drivers/scsi/lpfc/lpfc_bsg.c                                            | =
  15 -
 drivers/scsi/lpfc/lpfc_nvme.c                                           | =
   2=20
 drivers/scsi/qedf/qedf_els.c                                            | =
  16 -
 drivers/scsi/qla2xxx/qla_isr.c                                          | =
   4=20
 drivers/scsi/qla2xxx/qla_nvme.c                                         | =
   1=20
 drivers/scsi/qla2xxx/qla_target.c                                       | =
   1=20
 drivers/scsi/qla4xxx/ql4_os.c                                           | =
   1=20
 drivers/tty/hvc/hvc_vio.c                                               | =
  16 +
 drivers/tty/serial/msm_serial.c                                         | =
  13 -
 drivers/usb/gadget/function/f_ecm.c                                     | =
   6=20
 drivers/usb/gadget/function/f_rndis.c                                   | =
   1=20
 drivers/xen/balloon.c                                                   | =
   3=20
 fs/compat_ioctl.c                                                       | =
   3=20
 fs/locks.c                                                              | =
   2=20
 fs/nfsd/nfs4state.c                                                     | =
  15 -
 fs/pstore/ram.c                                                         | =
  11=20
 fs/xfs/libxfs/xfs_bmap.c                                                | =
   2=20
 fs/xfs/xfs_log.c                                                        | =
   2=20
 include/linux/ahci_platform.h                                           | =
   2=20
 include/linux/dmaengine.h                                               | =
   5=20
 include/linux/nvme-fc-driver.h                                          | =
   4=20
 include/linux/regulator/ab8500.h                                        | =
   1=20
 include/net/neighbour.h                                                 | =
   2=20
 kernel/cred.c                                                           | =
   6=20
 kernel/exit.c                                                           | =
  12 -
 kernel/power/snapshot.c                                                 | =
   9=20
 kernel/taskstats.c                                                      | =
  30 +-
 kernel/trace/ftrace.c                                                   | =
   6=20
 kernel/trace/trace.c                                                    | =
   8=20
 kernel/trace/trace_events.c                                             | =
   8=20
 kernel/trace/tracing_map.c                                              | =
   4=20
 mm/mmap.c                                                               | =
   6=20
 mm/zsmalloc.c                                                           | =
   5=20
 net/bluetooth/hci_conn.c                                                | =
   4=20
 net/bluetooth/l2cap_core.c                                              | =
   4=20
 net/core/neighbour.c                                                    | =
   4=20
 net/ethernet/eth.c                                                      | =
   7=20
 net/rxrpc/peer_event.c                                                  | =
   3=20
 net/socket.c                                                            | =
   4=20
 sound/firewire/motu/motu-proc.c                                         | =
   2=20
 sound/isa/cs423x/cs4236.c                                               | =
   3=20
 sound/pci/ice1712/ice1724.c                                             | =
   9=20
 tools/testing/selftests/net/rtnetlink.sh                                | =
  21 +
 84 files changed, 607 insertions(+), 288 deletions(-)

Al Viro (1):
      fix compat handling of FICLONERANGE, FIDEDUPERANGE and FS_IOC_FIEMAP

Aleksandr Yashkin (1):
      pstore/ram: Write new dumps to start of recycled zones

Alexander Shishkin (1):
      perf/x86/intel/bts: Fix the use of page_private()

Amir Goldstein (1):
      locks: print unsigned ino in /proc/locks

Anand Moon (1):
      arm64: dts: meson: odroid-c2: Disable usb_otg bus to avoid power fail=
ed warning

Andy Whitcroft (1):
      PM / hibernate: memory_bm_find_bit(): Tighten node optimisation

Arnd Bergmann (2):
      compat_ioctl: block: handle Persistent Reservations
      compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE

Bo Wu (1):
      scsi: lpfc: Fix memory leak on lpfc_bsg_write_ebuf_set func

Brian Foster (1):
      xfs: fix mount failure crash on invalid iclog memory access

Catalin Marinas (1):
      arm64: Revert support for execute-only user mappings

Chad Dupuis (1):
      scsi: qedf: Do not retry ELS request if qedf_alloc_cmd fails

Chanho Min (1):
      mm/zsmalloc.c: fix the migrated zspage statistics.

Christian Brauner (1):
      taskstats: fix data-race

Chuhong Yuan (1):
      RDMA/cma: add missed unregister_pernet_subsys in init failure

Colin Ian King (2):
      ALSA: cs4236: fix error return comparison of an unsigned integer
      media: flexcop-usb: ensure -EIO is returned on error condition

Dan Carpenter (2):
      scsi: iscsi: qla4xxx: fix double free in probe
      Bluetooth: delete a stray unlock

Daniel Axtens (1):
      powerpc/pseries/hvconsole: Fix stack overread via udbg

Daniel Vetter (1):
      drm: limit to INT_MAX in create_blob ioctl

David Howells (1):
      rxrpc: Fix possible NULL pointer access in ICMP handling

EJ Hsu (1):
      usb: gadget: fix wrong endpoint desc

Eric Dumazet (1):
      net: add annotations on hh->hh_len lockless accesses

Florian Fainelli (3):
      ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
      ata: ahci_brcm: Allow optional reset controller to be used
      ata: ahci_brcm: Fix AHCI resources management

Florian Westphal (1):
      selftests: rtnetlink: add addresses with fixed life time

Geert Uytterhoeven (2):
      iio: adc: max9611: Fix too short conversion time delay
      dt-bindings: clock: renesas: rcar-usb2-clock-sel: Fix typo in example

Greg Kroah-Hartman (1):
      Linux 4.14.163

Hans Verkuil (3):
      media: pulse8-cec: fix lost cec_transmit_attempt_done() call
      media: cec: CEC 2.0-only bcast messages were ignored
      media: cec: avoid decrementing transmit_queue_sz if it is 0

Hans de Goede (1):
      drm/nouveau: Move the declaration of struct nouveau_conn_atom up a bit

Heiko Carstens (1):
      s390/smp: fix physical to logical CPU map for SMT

Imre Deak (1):
      drm/mst: Fix MST sideband up-reply failure handling

James Smart (1):
      nvme_fc: add module to ops template to allow module references

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected

Jens Axboe (1):
      net: make socket read/write_iter() honor IOCB_NOWAIT

Juergen Gross (1):
      xen/balloon: fix ballooned page accounting without hotplug enabled

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops

Leonard Crestez (2):
      PM / devfreq: Don't fail devfreq_dev_release if not in list
      PM / devfreq: Check NULL governor in available_governors_show

Lukas Wunner (1):
      dmaengine: Fix access to uninitialized dma_slave_caps

Masashi Honma (2):
      ath9k_htc: Modify byte order for an error message
      ath9k_htc: Discard undersized packets

Michael Haener (1):
      platform/x86: pmc_atom: Add Siemens CONNECT X300 to critclk_systems D=
MI table

Navid Emamdoost (2):
      Bluetooth: Fix memory leak in hci_connect_le_scan
      media: usb: fix memory leak in af9005_identify_state

Oliver Neukum (1):
      Bluetooth: btusb: fix PM leak in error case of setup

Omar Sandoval (1):
      xfs: don't check for AG deadlock for realtime files in bunmapi

Parav Pandit (1):
      IB/mlx4: Follow mirror sequence of device add during device removal

Paul Burton (1):
      MIPS: Avoid VDSO ABI breakage due to global register variable

Paul Durrant (1):
      xen-blkback: prevent premature module unload

Prateek Sood (1):
      tracing: Fix lock inversion in trace_event_enable_tgid_record()

Roman Bolshakov (2):
      scsi: qla2xxx: Don't call qlt_async_event twice
      scsi: qla2xxx: Drop superfluous INIT_WORK of del_work

Russell King (1):
      gpiolib: fix up emulated open drain outputs

Scott Mayhew (1):
      nfsd4: fix up replay_matches_cache()

SeongJae Park (1):
      xen/blkback: Avoid unmapping unmapped grant pages

Shakeel Butt (1):
      memcg: account security cred as well to kmemcg

Stefan Mavrodiev (1):
      drm/sun4i: hdmi: Remove duplicate cleanup calls

Stephan Gerhold (1):
      regulator: ab8500: Remove AB8505 USB regulator

Steve Wise (1):
      rxe: correctly calculate iCRC for unaligned payloads

Steven Rostedt (VMware) (1):
      tracing: Have the histogram compare functions convert to u64 first

Takashi Iwai (2):
      ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
      ALSA: firewire-motu: Correct a typo in the clock proc string

Thomas Richter (2):
      s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits
      s390/cpum_sf: Avoid SBD overflow condition in irq handler

Wen Yang (1):
      ftrace: Avoid potential division by zero in function profiler

Zhiqiang Liu (1):
      md: raid1: check rdev before reference in raid1_sync_request func

chenqiwu (1):
      exit: panic before exit_mm() on global init exit


--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4XjEkACgkQONu9yGCS
aT7VXA//c20DkFWf2tJPtR3Muv7AfupmPnzdwN6yeJKhJt+Uvewtom+66TrQARb1
XyL7nmm2I8ex7A8xSceC+1bFaou6VJv4o6yg+h52UnvINnc13pmStro103YFUPkQ
eTAM4U9GXgNX7FvoC8f84fflU4BEnoGBUuepV5BcW8HnvI9j/EC3KKjUjTMH15ES
xyxzjGeLz5XNg4vxixcY9fS/KNRyAaisYBVIFH8vq9vpTa/bwKuKnEAH31VgyVds
lmxip9Gn9bSwYHOzEPqwC8YQ4DuC3T77fuESQUJOsRpPjpEQVxTAz2Ne1nwE0TBp
zQSKSCIM06u8zWYGyzS7VEPiynn4+Cfq7DIJzyrfKlPQ7f1u7vYCZLRVXLYog8Pa
j+MKq6s2Gn2CDqs+Zs8gZ9f85Ov2pCcVlpFZkiYwA1h7TZbJKl88w5OI1VwYFXbk
5k/mkFb4ZuMFFfketqvOMBHIlCFMqLI4m9VyeUFL0r/JM410OEddk5Pn3/z7Nf2x
PuTWNFKzAcybwFIBDeLKCiHD4I6eu94397eMU7Og9T+xP9OgsSrJr5N9absaj3DW
MB8jHzuD0lf2oMKlKpc/kUGUW3WXEhCmfiB6foTlQsFrcEK+DWW1co+rmu4akjD9
9o0z0Im1P8ww4oSC/eZXDJp6qZGSwoQ1X0CbyOT5p/IbZJ7m5E0=
=yAnj
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
