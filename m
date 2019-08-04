Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ECA80A61
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 12:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHDKN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 06:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfHDKN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 06:13:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76EB72075C;
        Sun,  4 Aug 2019 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564913638;
        bh=/yEAU16tLDBcIoF1KVro98UlF1UdrpulQ03PTk9CaCA=;
        h=Date:From:To:Cc:Subject:From;
        b=vVgsllrr9YcObVwEvDL53GnbSDGJFGyL52ei3IKQJZ2nAqn6AyVjFCf7+UQ0EsZ2g
         f9FQyvfbKpIcqxORIyp6ileyoMMxPvOJvQ3aEwJ6/PKycPhklgxFP4yad6mJuhyq0h
         Ob3S+xwLpwqfmWjSwdtFV9RcfmThjHD/wuhA8ajQ=
Date:   Sun, 4 Aug 2019 12:13:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.64
Message-ID: <20190804101355.GA25707@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.64 kernel.

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

 Makefile                                     |    2=20
 arch/arm64/include/asm/compat.h              |    1=20
 arch/sh/boards/Kconfig                       |   14 -
 block/blk-core.c                             |   35 +--
 block/blk-mq-debugfs.c                       |   10=20
 drivers/android/binder.c                     |   16 +
 drivers/bluetooth/hci_ath.c                  |    3=20
 drivers/bluetooth/hci_bcm.c                  |    3=20
 drivers/bluetooth/hci_intel.c                |    3=20
 drivers/bluetooth/hci_ldisc.c                |   13 +
 drivers/bluetooth/hci_mrvl.c                 |    3=20
 drivers/bluetooth/hci_qca.c                  |    3=20
 drivers/bluetooth/hci_uart.h                 |    1=20
 drivers/iommu/intel-iommu.c                  |    2=20
 drivers/iommu/iova.c                         |   18 +
 drivers/isdn/hardware/mISDN/hfcsusb.c        |    3=20
 drivers/media/radio/radio-raremono.c         |   30 ++
 drivers/media/usb/au0828/au0828-core.c       |   12 -
 drivers/media/usb/cpia2/cpia2_usb.c          |    3=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |    4=20
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    6=20
 drivers/media/usb/pvrusb2/pvrusb2-std.c      |    2=20
 drivers/net/wireless/ath/ath10k/usb.c        |    2=20
 drivers/pps/pps.c                            |    8=20
 drivers/scsi/scsi_lib.c                      |   15 -
 drivers/usb/dwc2/gadget.c                    |   41 ++-
 drivers/vhost/net.c                          |   41 +--
 drivers/vhost/scsi.c                         |   15 +
 drivers/vhost/vhost.c                        |   20 +
 drivers/vhost/vhost.h                        |    5=20
 drivers/vhost/vsock.c                        |   28 +-
 fs/ceph/caps.c                               |    7=20
 fs/exec.c                                    |    2=20
 fs/nfs/client.c                              |    4=20
 fs/nfs/dir.c                                 |  295 ++++++++++++++--------=
-----
 fs/nfs/nfs4proc.c                            |   15 +
 fs/proc/base.c                               |  132 ++++++------
 include/linux/blkdev.h                       |   14 -
 include/linux/iova.h                         |    6=20
 include/linux/sched.h                        |   10=20
 include/linux/sched/numa_balancing.h         |    4=20
 kernel/fork.c                                |    2=20
 kernel/sched/fair.c                          |  144 +++++++++----
 net/ipv4/ip_tunnel_core.c                    |    9=20
 net/vmw_vsock/af_vsock.c                     |   38 ---
 net/vmw_vsock/hyperv_transport.c             |  108 +++++++--
 46 files changed, 724 insertions(+), 428 deletions(-)

Andrey Konovalov (1):
      media: pvrusb2: use a different format for warnings

Bart Van Assche (2):
      block, scsi: Change the preempt-only flag into a counter
      scsi: core: Avoid that a kernel warning appears during system resume

Benjamin Coddington (1):
      NFS: Cleanup if nfs_match_client is interrupted

Dmitry Safonov (1):
      iommu/vt-d: Don't queue_iova() if there is no flush queue

Fabio Estevam (1):
      ath10k: Change the warning message string

Greg Kroah-Hartman (1):
      Linux 4.19.64

Jann Horn (2):
      sched/fair: Don't free p->numa_faults with concurrent readers
      sched/fair: Use RCU accessors consistently for ->numa_group

Jason Wang (4):
      vhost: introduce vhost_exceeds_weight()
      vhost_net: fix possible infinite loop
      vhost: vsock: add weight support
      vhost: scsi: add weight support

Joerg Roedel (1):
      iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA

Linus Torvalds (2):
      /proc/<pid>/cmdline: remove all the special cases
      /proc/<pid>/cmdline: add back the setproctitle() special case

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc

Minas Harutyunyan (2):
      usb: dwc2: Disable all EP's on disconnect
      usb: dwc2: Fix disable all EP's on disconnect

Miroslav Lichvar (1):
      drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Oliver Neukum (1):
      media: cpia2_usb: first wake up, then free in disconnect

Phong Tran (1):
      ISDN: hfcsusb: checking idx of ep configuration

Sean Young (1):
      media: au0828: fix null dereference in error path

Sunil Muthuswamy (2):
      hv_sock: Add support for delayed close
      vsock: correct removal of socket from the list

Todd Kjos (1):
      binder: fix possible UAF when freeing buffer

Trond Myklebust (3):
      NFS: Fix dentry revalidation on NFSv4 lookup
      NFS: Refactor nfs_lookup_revalidate()
      NFSv4: Fix lookup revalidate of regular files

Vladis Dronov (1):
      Bluetooth: hci_uart: check for missing tty operations

Will Deacon (1):
      arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ

Xin Long (1):
      ip_tunnel: allow not to count pkts on tstats by setting skb's dev to =
NULL

Yan, Zheng (1):
      ceph: hold i_ceph_lock when removing caps for freeing inode

Yoshinori Sato (1):
      Fix allyesconfig output.


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1Gr+MACgkQONu9yGCS
aT65Tg//buD38kny4XpBoVc/5I2Us2H8ZTAMknTGdqBx5aLdF56uZlw1O2Im/q5X
pT+aP8lwmObBl4ZKrUvLlIZsaO+NUf8jQLCyWBVeIn4ybsLh3/5NnloLyU3Ln9Pb
xhGtmi4rf2MWAG4Yo5qakzDNEmmwtOLW9lqhdwy/E5QWNyGuj7C+LBwaV5bpDS33
wa/JXwphNsjkS+wwgkrr8gDTCSqNrrmMWEoADPcawTD4PYStNryUOEdeI5GtP5ee
B74NnlDd/4QwrN2nK/lK07JulZLw9xkvEBOY0vDIfVH4jopOV6hY363+ZdOmyerZ
fklLMtB+gW9l/lGrNxttadroZnC2E01unIfIMQqYS9PM1ZYXqgnCMdzZ4gca+4T1
ez3pkt67bFldhYWhnt0DqMsEMhGVZHLnnFGitLFpUljp0t8u5Z+FjqVh3LgOcGp1
J3Y168yOZ5hu546oKuPZyD0vutyJXn7aZfIARzkjUNDhf+VkzgecLeilY8WxGwoe
EsRHjs6wDjs05f8fjSDvTow052FjLHh909ykBgSu2s71g1dVmgIwVX9Q7wKiuc27
INyTAd5IVhzTNrhWi9C4YE/dkPr73gnBi8ZBY1GxudZW3gsC1Zgzvx/n03Nwotzg
v2rsFvwzm94O0cTroVayR75PDbYKM2FyhZ9s9vT+Qthm+4jwp1Q=
=Pt26
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
