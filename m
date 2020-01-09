Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D521361B5
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 21:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgAIU0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 15:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729823AbgAIU0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jan 2020 15:26:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C53206ED;
        Thu,  9 Jan 2020 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578601570;
        bh=bE7NXXwVOfExOXF9uG+WLh5PGKPbiWMoNDn1MvbGNMM=;
        h=Date:From:To:Cc:Subject:From;
        b=TEehO03xEXBMF3Vu4Gc19fEib4BgLCr/qxev3S3DK5MdzJn/6XGne9QqohKJl0Tac
         pndr6Tx+2b1HlPUOYQPrX3RKwbB7ZJ2a78Z6Ycj1uqlZ7jI5acen5d1036GuwbPY+c
         cTECoQcsWrKyG8TzE7DvF92ajtSHdZu5k5vBqJ5Y=
Date:   Thu, 9 Jan 2020 21:26:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.94
Message-ID: <20200109202608.GA7756@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.94 kernel.

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

 Documentation/admin-guide/kernel-parameters.txt                         | =
   2=20
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
  20=20
 arch/powerpc/include/asm/kvm_ppc.h                                      | =
 100 +++
 arch/powerpc/kernel/dbell.c                                             | =
   6=20
 arch/powerpc/kvm/book3s_hv_rm_xics.c                                    | =
   2=20
 arch/powerpc/platforms/powernv/smp.c                                    | =
   2=20
 arch/powerpc/platforms/pseries/hvconsole.c                              | =
   2=20
 arch/powerpc/sysdev/xics/icp-native.c                                   | =
   6=20
 arch/powerpc/sysdev/xics/icp-opal.c                                     | =
   6=20
 arch/riscv/kernel/ftrace.c                                              | =
   2=20
 arch/s390/kernel/perf_cpum_sf.c                                         | =
  22=20
 arch/s390/kernel/smp.c                                                  | =
  80 +-
 arch/x86/events/intel/bts.c                                             | =
  16=20
 block/compat_ioctl.c                                                    | =
  11=20
 drivers/acpi/sysfs.c                                                    | =
   6=20
 drivers/ata/ahci_brcm.c                                                 | =
 140 +++--
 drivers/ata/libahci_platform.c                                          | =
   6=20
 drivers/ata/libata-core.c                                               | =
  24=20
 drivers/ata/sata_fsl.c                                                  | =
   2=20
 drivers/ata/sata_mv.c                                                   | =
   2=20
 drivers/ata/sata_nv.c                                                   | =
   2=20
 drivers/block/xen-blkback/blkback.c                                     | =
   2=20
 drivers/block/xen-blkback/xenbus.c                                      | =
  10=20
 drivers/bluetooth/btusb.c                                               | =
   3=20
 drivers/devfreq/devfreq.c                                               | =
  30 -
 drivers/firewire/net.c                                                  | =
   6=20
 drivers/gpio/gpiolib.c                                                  | =
   8=20
 drivers/gpu/drm/amd/amdgpu/df_v3_6.c                                    | =
  38 -
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c                                   | =
  22=20
 drivers/gpu/drm/amd/display/dc/core/dc_link.c                           | =
   2=20
 drivers/gpu/drm/drm_dp_mst_topology.c                                   | =
   6=20
 drivers/gpu/drm/drm_property.c                                          | =
   2=20
 drivers/gpu/drm/msm/msm_gpu.c                                           | =
   1=20
 drivers/gpu/drm/nouveau/nouveau_connector.h                             | =
 110 ++--
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c                                  | =
   2=20
 drivers/hid/i2c-hid/i2c-hid-core.c                                      | =
  12=20
 drivers/iio/adc/max9611.c                                               | =
  16=20
 drivers/infiniband/core/cma.c                                           | =
   1=20
 drivers/infiniband/hw/mlx4/main.c                                       | =
   9=20
 drivers/infiniband/hw/mlx5/main.c                                       | =
  13=20
 drivers/infiniband/sw/rxe/rxe_recv.c                                    | =
   2=20
 drivers/infiniband/sw/rxe/rxe_req.c                                     | =
   6=20
 drivers/infiniband/sw/rxe/rxe_resp.c                                    | =
   7=20
 drivers/md/raid1.c                                                      | =
   2=20
 drivers/media/cec/cec-adap.c                                            | =
  40 -
 drivers/media/usb/b2c2/flexcop-usb.c                                    | =
   2=20
 drivers/media/usb/dvb-usb/af9005.c                                      | =
   5=20
 drivers/media/usb/pulse8-cec/pulse8-cec.c                               | =
  17=20
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                           | =
  23=20
 drivers/nvme/host/fc.c                                                  | =
  32 -
 drivers/nvme/target/fcloop.c                                            | =
   1=20
 drivers/platform/x86/pmc_atom.c                                         | =
   8=20
 drivers/regulator/ab8500.c                                              | =
  17=20
 drivers/scsi/libsas/sas_discover.c                                      | =
  11=20
 drivers/scsi/lpfc/lpfc_bsg.c                                            | =
  15=20
 drivers/scsi/lpfc/lpfc_nvme.c                                           | =
   2=20
 drivers/scsi/qedf/qedf_els.c                                            | =
  16=20
 drivers/scsi/qla2xxx/qla_init.c                                         | =
  10=20
 drivers/scsi/qla2xxx/qla_iocb.c                                         | =
   6=20
 drivers/scsi/qla2xxx/qla_isr.c                                          | =
   4=20
 drivers/scsi/qla2xxx/qla_mbx.c                                          | =
   3=20
 drivers/scsi/qla2xxx/qla_nvme.c                                         | =
   1=20
 drivers/scsi/qla2xxx/qla_target.c                                       | =
   2=20
 drivers/scsi/qla4xxx/ql4_os.c                                           | =
   1=20
 drivers/tty/hvc/hvc_vio.c                                               | =
  16=20
 drivers/tty/serial/msm_serial.c                                         | =
  13=20
 drivers/usb/gadget/function/f_ecm.c                                     | =
   6=20
 drivers/usb/gadget/function/f_rndis.c                                   | =
   1=20
 drivers/xen/balloon.c                                                   | =
   3=20
 fs/afs/dynroot.c                                                        | =
   3=20
 fs/afs/server.c                                                         | =
  21=20
 fs/afs/super.c                                                          | =
   1=20
 fs/block_dev.c                                                          | =
  37 -
 fs/compat_ioctl.c                                                       | =
   3=20
 fs/locks.c                                                              | =
   2=20
 fs/nfsd/nfs4state.c                                                     | =
  15=20
 fs/pstore/ram.c                                                         | =
  11=20
 fs/ubifs/tnc_commit.c                                                   | =
  34 -
 fs/xfs/libxfs/xfs_bmap.c                                                | =
   2=20
 fs/xfs/scrub/common.h                                                   | =
   9=20
 fs/xfs/xfs_log.c                                                        | =
   2=20
 include/linux/ahci_platform.h                                           | =
   2=20
 include/linux/dmaengine.h                                               | =
   5=20
 include/linux/libata.h                                                  | =
   1=20
 include/linux/netdevice.h                                               | =
   4=20
 include/linux/nvme-fc-driver.h                                          | =
   4=20
 include/linux/regulator/ab8500.h                                        | =
   1=20
 include/net/neighbour.h                                                 | =
   2=20
 kernel/cred.c                                                           | =
   6=20
 kernel/exit.c                                                           | =
  12=20
 kernel/power/snapshot.c                                                 | =
   9=20
 kernel/taskstats.c                                                      | =
  30 -
 kernel/trace/ftrace.c                                                   | =
   6=20
 kernel/trace/trace.c                                                    | =
   8=20
 kernel/trace/trace_events.c                                             | =
   8=20
 kernel/trace/trace_events_filter.c                                      | =
   2=20
 kernel/trace/trace_events_hist.c                                        | =
  21=20
 kernel/trace/tracing_map.c                                              | =
   4=20
 mm/migrate.c                                                            | =
  23=20
 mm/mmap.c                                                               | =
   6=20
 mm/zsmalloc.c                                                           | =
   5=20
 net/bluetooth/hci_conn.c                                                | =
   4=20
 net/bluetooth/l2cap_core.c                                              | =
   4=20
 net/core/dev.c                                                          | =
 272 ++++++++--
 net/core/neighbour.c                                                    | =
   4=20
 net/ethernet/eth.c                                                      | =
   7=20
 net/ipv4/tcp.c                                                          | =
   4=20
 net/ipv4/tcp_diag.c                                                     | =
   2=20
 net/ipv4/tcp_input.c                                                    | =
   6=20
 net/ipv4/tcp_ipv4.c                                                     | =
   3=20
 net/ipv4/tcp_minisocks.c                                                | =
   7=20
 net/ipv6/tcp_ipv6.c                                                     | =
   3=20
 net/netfilter/nft_tproxy.c                                              | =
   4=20
 net/rxrpc/peer_event.c                                                  | =
   3=20
 net/socket.c                                                            | =
   4=20
 security/apparmor/apparmorfs.c                                          | =
   2=20
 security/apparmor/domain.c                                              | =
  82 +--
 security/apparmor/policy.c                                              | =
   4=20
 sound/firewire/motu/motu-proc.c                                         | =
   2=20
 sound/isa/cs423x/cs4236.c                                               | =
   3=20
 sound/pci/hda/patch_realtek.c                                           | =
  61 +-
 sound/pci/ice1712/ice1724.c                                             | =
   9=20
 sound/usb/card.h                                                        | =
   1=20
 sound/usb/pcm.c                                                         | =
  25=20
 sound/usb/quirks-table.h                                                | =
   3=20
 sound/usb/quirks.c                                                      | =
  11=20
 sound/usb/usbaudio.h                                                    | =
   3=20
 tools/testing/selftests/net/rtnetlink.sh                                | =
  21=20
 tools/testing/selftests/rseq/param_test.c                               | =
  18=20
 135 files changed, 1368 insertions(+), 552 deletions(-)

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

Arnd Bergmann (3):
      compat_ioctl: block: handle Persistent Reservations
      compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE
      drm/msm: include linux/sched/task.h

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

Chris Chiu (1):
      ALSA: hda/realtek - Enable the bass speaker of ASUS UX431FLC

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

Darrick J. Wong (1):
      xfs: periodically yield scrub threads to the scheduler

David Galiffi (1):
      drm/amd/display: Fixed kernel panic when booting with DP-to-HDMI dong=
le

David Howells (3):
      afs: Fix SELinux setting security label on /afs
      afs: Fix creation calls in the dynamic root to fail with EOPNOTSUPP
      rxrpc: Fix possible NULL pointer access in ICMP handling

EJ Hsu (1):
      usb: gadget: fix wrong endpoint desc

Eric Dumazet (2):
      tcp: annotate tp->rcv_nxt lockless reads
      net: add annotations on hh->hh_len lockless accesses

Florian Fainelli (5):
      ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
      ata: ahci_brcm: Fix AHCI resources management
      ata: ahci_brcm: Allow optional reset controller to be used
      ata: ahci_brcm: Add missing clock management during recovery
      ata: ahci_brcm: BCM7425 AHCI requires AHCI_HFLAG_DELAY_ENGINE

Florian Westphal (1):
      selftests: rtnetlink: add addresses with fixed life time

Geert Uytterhoeven (2):
      iio: adc: max9611: Fix too short conversion time delay
      dt-bindings: clock: renesas: rcar-usb2-clock-sel: Fix typo in example

Greg Kroah-Hartman (1):
      Linux 4.19.94

Guchun Chen (1):
      drm/amdgpu: add check before enabling/disabling broadcast mode

Hans Verkuil (4):
      media: pulse8-cec: fix lost cec_transmit_attempt_done() call
      media: cec: CEC 2.0-only bcast messages were ignored
      media: cec: avoid decrementing transmit_queue_sz if it is 0
      media: cec: check 'transmit_in_progress', not 'transmitting'

Hans de Goede (1):
      drm/nouveau: Move the declaration of struct nouveau_conn_atom up a bit

Heiko Carstens (1):
      s390/smp: fix physical to logical CPU map for SMT

Hui Wang (1):
      ALSA: usb-audio: set the interface format after resume on Dell WD19

Imre Deak (1):
      drm/mst: Fix MST sideband up-reply failure handling

James Smart (2):
      nvme_fc: add module to ops template to allow module references
      nvme-fc: fix double-free scenarios on hw queues

Jan Kara (2):
      bdev: Factor out bdev revalidation into a common helper
      bdev: Refresh bdev size for disks without partitioning

Jaroslav Kysela (1):
      ALSA: hda - fixup for the bass speaker on Lenovo Carbon X1 7th gen

Jason Yan (1):
      scsi: libsas: stop discovering if oob mode is disconnected

Jens Axboe (1):
      net: make socket read/write_iter() honor IOCB_NOWAIT

Johan Hovold (1):
      ALSA: usb-audio: fix set_format altsetting sanity check

John Johansen (1):
      apparmor: fix aa_xattrs_match() may sleep while holding a RCU lock

Juergen Gross (1):
      xen/balloon: fix ballooned page accounting without hotplug enabled

Kai-Heng Feng (1):
      HID: i2c-hid: Reset ALPS touchpads on resume

Kailang Yang (2):
      ALSA: hda/realtek - Add Bass Speaker and fixed dac for bass speaker
      ALSA: hda/realtek - Add headset Mic no shutup for ALC283

Keita Suzuki (1):
      tracing: Avoid memory leak in process_system_preds()

Leo Yan (1):
      tty: serial: msm_serial: Fix lockup for sysrq and oops

Leonard Crestez (4):
      PM / devfreq: Fix devfreq_notifier_call returning errno
      PM / devfreq: Set scaling_max_freq to max on OPP notifier error
      PM / devfreq: Don't fail devfreq_dev_release if not in list
      PM / devfreq: Check NULL governor in available_governors_show

Lukas Wunner (1):
      dmaengine: Fix access to uninitialized dma_slave_caps

Maor Gottlieb (1):
      IB/mlx5: Fix steering rule of drop and count

Marc Dionne (1):
      afs: Fix afs_find_server lookups for ipv4 peers

Masashi Honma (2):
      ath9k_htc: Modify byte order for an error message
      ath9k_htc: Discard undersized packets

Mathieu Desnoyers (1):
      rseq/selftests: Fix: Namespace gettid() for compatibility with glibc =
2.30

Michael Haener (1):
      platform/x86: pmc_atom: Add Siemens CONNECT X300 to critclk_systems D=
MI table

Michael Roth (1):
      KVM: PPC: Book3S HV: use smp_mb() when setting/clearing host_ipi flag

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

Phil Sutter (1):
      netfilter: nft_tproxy: Fix port selector on Big Endian

Pierre-Eric Pelloux-Prayer (1):
      drm/amdgpu: add cache flush workaround to gfx8 emit_fence

Prateek Sood (1):
      tracing: Fix lock inversion in trace_event_enable_tgid_record()

Roman Bolshakov (6):
      scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
      scsi: qla2xxx: Don't call qlt_async_event twice
      scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
      scsi: qla2xxx: Configure local loop for N2N target
      scsi: qla2xxx: Send Notify ACK after N2N PLOGI
      scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI

Russell King (1):
      gpiolib: fix up emulated open drain outputs

Sascha Hauer (1):
      libata: Fix retrieving of active qcs

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

Sven Schnelle (1):
      tracing: Fix endianness bug in histogram trigger

Taehee Yoo (1):
      net: core: limit nested device depth

Takashi Iwai (2):
      ALSA: ice1724: Fix sleep-in-atomic in Infrasonic Quartet support code
      ALSA: firewire-motu: Correct a typo in the clock proc string

Thomas Richter (2):
      s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits
      s390/cpum_sf: Avoid SBD overflow condition in irq handler

Wen Yang (1):
      ftrace: Avoid potential division by zero in function profiler

Yang Shi (1):
      mm: move_pages: return valid node id in status if the page is already=
 on the target node

Yunfeng Ye (1):
      ACPI: sysfs: Change ACPI_MASKABLE_GPE_MAX to 0x100

Zhihao Cheng (1):
      ubifs: ubifs_tnc_start_commit: Fix OOB in layout_in_gaps

Zhiqiang Liu (1):
      md: raid1: check rdev before reference in raid1_sync_request func

Zong Li (1):
      riscv: ftrace: correct the condition logic in function graph tracer

chenqiwu (1):
      exit: panic before exit_mm() on global init exit


--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl4XjF8ACgkQONu9yGCS
aT4UAQ/+JyOAvzSGoBp0W/dT87g0o+oh0XrpPHjwbWDgZkQtnloqSUNMyCN+GSCS
6TF5Q/SCqp4rJR1c+rrT6KjqFEzABOL0pcaKoJ8bDH98LLZa2XxlAW15cNzYHog7
BDlK2q7oZBTnxywTmHUM7JJlc9DaEuaLUoovmmIkWAB5BXJnqrDKOf7vzdZRpeMt
YiGWjV+NgElf4Usul5kUpt8D5JGdln6hIpDZcD24EpOTh9k7lDJTUxBp7uxysNfM
xADHRy+7b87SRZJGI0dXJY256S+M5pP70E2uQgDBzKRLa58Nk4pOSvYFMI+9NuYc
vsSWIQwDDIORrIz7bTQtr43q7WmVeKitYVbrnnniVG/dJwcgQoXMLdPrsFUsW72A
TT8MoR0MAJgwZEM7X8QY6xbOS9CwGSnjx2FALx8CTooUQJxWdcNbamhvbXuPMExb
xT5Hptn1LFH8GCG+hF84bJctDCbp+6RUs9vxyHURtepPY19wfMb6VmuKMjoQW+5C
PY82NHuSZ3iy1yaERM5yAIAxQxnMYBkTVWkL1LRjWzM8hgmO/10zfWZ9jeUcQTHb
5FeMHr0A150lGxJrpCZmn+5hzVPSMp1EpnaCnsshc+wsUDrxXgPCQmg2RDps919Q
0CI5Camn2JPcP8OeuOmHnZgNIeSCM1YEnun+4iNTxtp837rodO8=
=h4dC
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
