Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E101C36AE
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgEDKVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728125AbgEDKVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 06:21:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2501206E6;
        Mon,  4 May 2020 10:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588587677;
        bh=m2IHj3Ei2VeZ+gVks8hE+o+74Prkh722SyV62Wgbjvs=;
        h=Date:From:To:Cc:Subject:From;
        b=HC7qSoS4UPrtIG54+f7keO0hwdVh5pF+nWY0Am8o4yI3nzOpoWFlodJGFhV4fnKpn
         ScSX9/JZwkaVtdhNpuI+5VZ1YOLASjBlstuUWatyLTPFtaka0CjjkHoGdTpU44MEtJ
         z9q2+4+ACDLhIydu2Ja6weSt5zA9fgo4Kf0QdkKo=
Date:   Mon, 4 May 2020 12:21:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.221
Message-ID: <20200504102114.GA1439495@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.221 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/arm/mach-imx/Makefile                 |    2=20
 arch/x86/kvm/vmx.c                         |    2=20
 arch/x86/net/bpf_jit_comp.c                |   18 +++++++-
 drivers/char/tpm/tpm_tis_core.c            |    8 +++
 drivers/crypto/mxs-dcp.c                   |    4 -
 drivers/gpu/drm/msm/msm_gem.c              |    4 -
 drivers/hwmon/jc42.c                       |    2=20
 drivers/iio/adc/xilinx-xadc-core.c         |   17 ++++++--
 drivers/mtd/chips/cfi_cmdset_0002.c        |    6 ++
 drivers/net/dsa/b53/b53_regs.h             |    4 -
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |    2=20
 drivers/net/macsec.c                       |   12 +++--
 drivers/net/macvlan.c                      |    2=20
 drivers/net/team/team.c                    |    4 +
 drivers/pci/pcie/aspm.c                    |   18 +++++---
 drivers/pwm/pwm-bcm2835.c                  |    1=20
 drivers/pwm/pwm-rcar.c                     |   10 +++-
 drivers/pwm/pwm-renesas-tpu.c              |    9 +---
 drivers/remoteproc/remoteproc_core.c       |    2=20
 drivers/s390/cio/device.c                  |   13 ++++--
 drivers/scsi/lpfc/lpfc_sli.c               |    2=20
 drivers/scsi/scsi_transport_iscsi.c        |    4 +
 drivers/staging/comedi/comedi_fops.c       |    4 +
 drivers/staging/comedi/drivers/dt2815.c    |    3 +
 drivers/staging/vt6656/int.c               |    3 -
 drivers/staging/vt6656/main_usb.c          |    9 ++--
 drivers/target/target_core_fabric_lib.c    |    2=20
 drivers/tty/hvc/hvc_console.c              |   23 ++++++-----
 drivers/tty/rocket.c                       |   25 ++++++------
 drivers/usb/core/hub.c                     |   14 ++++++
 drivers/usb/core/message.c                 |    9 +++-
 drivers/usb/core/quirks.c                  |    4 +
 drivers/usb/gadget/function/f_fs.c         |    4 +
 drivers/usb/gadget/udc/bdc/bdc_ep.c        |    2=20
 drivers/usb/misc/sisusbvga/sisusb.c        |   20 ++++-----
 drivers/usb/misc/sisusbvga/sisusb_init.h   |   14 +++---
 drivers/usb/storage/uas.c                  |   46 +++++++++++++++++++++-
 drivers/usb/storage/unusual_devs.h         |    7 +++
 drivers/watchdog/watchdog_dev.c            |    1=20
 drivers/xen/xenbus/xenbus_client.c         |    9 +++-
 fs/ceph/caps.c                             |    8 ++-
 fs/ceph/export.c                           |    5 ++
 fs/ext4/block_validity.c                   |   54 ++++++++++++++++++++++++=
++
 fs/ext4/ext4.h                             |   15 ++++++-
 fs/ext4/extents.c                          |   59 +++++++++++++++++-------=
-----
 fs/ext4/ialloc.c                           |    2=20
 fs/ext4/inode.c                            |   48 +++++++++++++++++------
 fs/ext4/ioctl.c                            |    2=20
 fs/ext4/mballoc.c                          |    6 +-
 fs/ext4/namei.c                            |    4 -
 fs/ext4/resize.c                           |    5 +-
 fs/ext4/super.c                            |   22 +++-------
 fs/fuse/dev.c                              |   12 ++++-
 fs/namespace.c                             |    2=20
 fs/nfsd/nfs4state.c                        |    2=20
 fs/pnode.c                                 |    9 +---
 fs/proc/vmcore.c                           |    2=20
 fs/xfs/xfs_reflink.c                       |    1=20
 include/linux/kvm_host.h                   |    2=20
 include/linux/overflow.h                   |   31 +++++++++++++++
 include/linux/vmalloc.h                    |    2=20
 include/net/tcp.h                          |    2=20
 ipc/util.c                                 |    2=20
 kernel/audit.c                             |    3 +
 kernel/events/core.c                       |   13 ++++--
 kernel/gcov/fs.c                           |    2=20
 mm/vmalloc.c                               |   16 ++++++-
 net/ipv4/ip_vti.c                          |    4 -
 net/ipv4/raw.c                             |    4 +
 net/ipv4/route.c                           |    3 -
 net/ipv4/xfrm4_output.c                    |    2=20
 net/ipv6/ipv6_sockglue.c                   |   13 ++----
 net/ipv6/xfrm6_output.c                    |    2=20
 net/netrom/nr_route.c                      |    1=20
 net/x25/x25_dev.c                          |    4 +
 sound/pci/hda/hda_intel.c                  |    1=20
 sound/soc/intel/atom/sst-atom-controls.c   |    2=20
 sound/soc/soc-dapm.c                       |   20 ++++++++-
 sound/usb/format.c                         |   52 +++++++++++++++++++++++++
 sound/usb/mixer_quirks.c                   |   12 +++--
 sound/usb/usx2y/usbusx2yaudio.c            |    2=20
 tools/objtool/check.c                      |   17 +++++++-
 tools/objtool/orc_dump.c                   |   44 +++++++++++++--------
 84 files changed, 638 insertions(+), 223 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=3Dy

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock

Alan Stern (3):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary
      USB: hub: Fix handling of connect changes during sleep
      usb-storage: Add unusual_devs entry for JMicron JMS566

Alexander Tsoy (1):
      ALSA: usb-audio: Filter out unsupported sample rates on Focusrite dev=
ices

Andrew Melnychenko (1):
      tty: hvc: fix buffer overflow during hvc_alloc().

Arnd Bergmann (1):
      net: ipv4: avoid unused variable warning for sysctl

Bodo Stroesser (1):
      scsi: target: fix PR IN / READ FULL STATUS for FC

Changming Liu (1):
      USB: sisusbvga: Change port variable from signed to unsigned

Clement Leger (1):
      remoteproc: Fix wrong rvring index computation

Colin Ian King (1):
      ext4: unsigned int compared against zero

Cornelia Huck (1):
      s390/cio: avoid duplicated 'ADD' uevents

Darrick J. Wong (1):
      xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

David Ahern (1):
      xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish

Dmitry Monakhov (1):
      ext4: fix extent_status fragmentation for plain files

Eric Dumazet (1):
      tcp: cache line align MAX_TCP_HEADER

Florian Fainelli (2):
      pwm: bcm2835: Dynamically allocate base
      net: dsa: b53: Fix ARL register definitions

Geert Uytterhoeven (2):
      pwm: rcar: Fix late Runtime PM enablement
      pwm: renesas-tpu: Fix late Runtime PM enablement

Greg Kroah-Hartman (1):
      Linux 4.9.221

Gyeongtaek Lee (1):
      ASoC: dapm: fixup dapm kcontrol widget

Hans de Goede (1):
      ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_s=
lot_map()

Heiner Kallweit (1):
      PCI/ASPM: Allow re-enabling Clock PM

Ian Abbott (1):
      staging: comedi: dt2815: fix writing hi byte of analog output

Ian Rogers (1):
      perf/core: fix parent pid/tid in task exit events

James Smart (1):
      scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Jann Horn (1):
      vmalloc: fix remap_vmalloc_range() bounds checks

Jarkko Sakkinen (1):
      tpm/tpm_tis: Free IRQ if probing fails

Jason Gunthorpe (2):
      overflow.h: Add arithmetic shift helper
      net/cxgb4: Check the return from t4_query_params properly

Jeremy Sowden (1):
      vti4: removed duplicate log message.

Jiri Slaby (1):
      tty: rocket, avoid OOB access

John Haxby (1):
      ipv6: fix restrict IPV6_ADDRFORM operation

Jonathan Cox (1):
      USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsai=
r K70 RGB RAPIDFIRE

Josh Poimboeuf (2):
      objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings
      objtool: Support Clang non-section symbols in ORC dump

Juergen Gross (1):
      xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant stat=
us

Lars-Peter Clausen (3):
      iio: xilinx-xadc: Fix ADC-B powerdown
      iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
      iio: xilinx-xadc: Fix sequencer configuration for aux channels in sim=
ultaneous mode

Liu Jian (1):
      mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer

Luke Nelson (1):
      bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Malcolm Priestley (2):
      staging: vt6656: Fix drivers TBTT timing counter.
      staging: vt6656: Power save stop wake_up_count wrap around.

Miklos Szeredi (1):
      fuse: fix possibly missed wake-up after abort

Nathan Chancellor (1):
      usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_comp=
lete

Nicolai Stange (1):
      net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()

Oliver Neukum (2):
      UAS: no use logging any details in case of ENODEV
      UAS: fix deadlock in error handling and PM flushing work

Paul Moore (1):
      audit: check the length of userspace generated audit records

Piotr Krysiuk (1):
      fs/namespace.c: fix mountpoint reference counter race

Qiujun Huang (1):
      ceph: return ceph_mdsc_do_request() errors from __get_parent()

Ritesh Harjani (1):
      ext4: check for non-zero journal inum in ext4_calculate_overhead

Rob Clark (1):
      drm/msm: Use the correct dma_sync calls harder

Sascha Hauer (1):
      hwmon: (jc42) Fix name to have no illegal characters

Sean Christopherson (1):
      KVM: Check validity of resolved slot when searching memslots

Taehee Yoo (3):
      macsec: avoid to set wrong mtu
      macvlan: fix null dereference in macvlan_device_event()
      team: fix hang in team_mode_get()

Takashi Iwai (2):
      ALSA: hda: Remove ASUS ROG Zenith from the blacklist
      ALSA: usx2y: Fix potential NULL dereference

Tero Kristo (1):
      watchdog: reset last_hw_keepalive time at start

Theodore Ts'o (5):
      ext4: convert BUG_ON's to WARN_ON's in mballoc.c
      ext4: avoid declaring fs inconsistent due to invalid file handles
      ext4: protect journal inode's blocks using block_validity
      ext4: don't perform block validity checks on the journal inode
      ext4: fix block validity checks for journal inodes using indirect blo=
cks

Udipto Goswami (1):
      usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_re=
set()

Uros Bizjak (1):
      KVM: VMX: Enable machine check support for 32bit targets

Vasily Averin (3):
      kernel/gcov/fs.c: gcov_seq_next() should increase position index
      ipc/util.c: sysvipc_find_ipc() should increase position index
      nfsd: memory corruption in nfsd4_lock()

Wei Yongjun (1):
      crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash=
' static

Wu Bo (1):
      scsi: iscsi: Report unbind session event when the target has been rem=
oved

Xiyu Yang (4):
      net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
      net/x25: Fix x25_neigh refcnt leak when receiving frame
      ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif
      staging: comedi: Fix comedi_device refcnt leak in comedi_open

Yan, Zheng (1):
      ceph: don't skip updating wanted caps when cap is stale


--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6v7JMACgkQONu9yGCS
aT4aPBAApeSH675E1+VH+7WUchS1Kd96cc0tOc2mhbxWX806ae9ypqZd9hFxuyjV
+NqUJLhrtesPkxngzSnymkTOJdsfQC/E0wG9+DESlVfkn6tttnr4RhLEQSZVi4Vg
gTfrYn7/ciLL5bKk2xEWFw8U4a+c+Ke4zUPs17ubfKsJ/qtFEsFLPPn5pJf6G377
9hWY1hgEvV6Jed+drH60VVNdgXEwe+T+OjPGd6wDlKtk2f6qEE+oLY8Jj7HUOHih
Qg7XslDiFO3r8bjLATmFbBYIEUvno9Pt++Lf1fBhPSFhhmgwcbRLkQBE0J3TaODw
sEaMu0d/gvAil3ycvpTkx0vksMpCmnWxBvz7TVIutAhojbGJdaL3XVkjsQuDdMxN
UR8EvMZc3cU5deQcR+i5DOftrkQwcA7/WOds7ygamIu81DoiR8A+eJmJuiasKO3g
48CKYIE9c6dR1lLCxK7S3cisQoFnvB1HTq7TgKl47JBbUsovziu8ESVhsHhe9oor
syqlsoi5cBfFs7V1ciUJIm1fUWFkbCWfFSitqFEBQu818/hztUkqvWGzhRja88zb
Gqz/WoeMwQ9rwjnVsEQOfn7u5kN4WUqs1JsCuJq6DRLGU8rKzIGLQEQTyp3nRiDT
HH+dZcvdcOpQ7aCZQMh7jKiswbkOahKCaWLK3Lkkzd9dtAVMDYs=
=Bpfo
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
