Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686A480A65
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 12:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfHDKOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 06:14:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfHDKOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 06:14:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E2A2075C;
        Sun,  4 Aug 2019 10:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564913658;
        bh=dYTvBEdwHV3/APelTi6x0s7XURdj9OvxWY4qwzZotX0=;
        h=Date:From:To:Cc:Subject:From;
        b=wnF+OdqcXafhi0eQNDCpgErKt0wrhaYG5d9Lko9p0AbEQigkYD1inQ5gUIB3/+DnT
         5FXqlzDYo5DqngF9sQYU3iWyMFYU4A4H+Wa34ygUsUqyVN4rYXj0nfrKVHXzse9GtY
         wuup+Et9P0t8ICe4xeMGFqTM3VfxmpSWSR6WkbGU=
Date:   Sun, 4 Aug 2019 12:14:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.6
Message-ID: <20190804101415.GA27152@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.6 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/sh/boards/Kconfig                       |   14 --
 drivers/bluetooth/hci_ath.c                  |    3=20
 drivers/bluetooth/hci_bcm.c                  |    3=20
 drivers/bluetooth/hci_intel.c                |    3=20
 drivers/bluetooth/hci_ldisc.c                |   13 ++
 drivers/bluetooth/hci_mrvl.c                 |    3=20
 drivers/bluetooth/hci_qca.c                  |    3=20
 drivers/bluetooth/hci_uart.h                 |    1=20
 drivers/isdn/hardware/mISDN/hfcsusb.c        |    3=20
 drivers/media/radio/radio-raremono.c         |   30 ++++-
 drivers/media/usb/au0828/au0828-core.c       |   12 +-
 drivers/media/usb/cpia2/cpia2_usb.c          |    3=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c      |    4=20
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c |    6 -
 drivers/media/usb/pvrusb2/pvrusb2-std.c      |    2=20
 drivers/net/wireless/ath/ath10k/usb.c        |    2=20
 drivers/nvme/host/multipath.c                |    8 -
 drivers/nvme/host/nvme.h                     |    6 -
 drivers/pps/pps.c                            |    8 +
 fs/ceph/caps.c                               |   10 +
 fs/ceph/inode.c                              |    2=20
 fs/ceph/super.h                              |    2=20
 fs/exec.c                                    |    2=20
 fs/nfs/client.c                              |    4=20
 fs/proc/base.c                               |  132 ++++++++++++++--------=
--
 include/linux/sched.h                        |   10 +
 include/linux/sched/numa_balancing.h         |    4=20
 kernel/bpf/btf.c                             |   12 +-
 kernel/fork.c                                |    2=20
 kernel/sched/fair.c                          |  144 ++++++++++++++++++----=
-----
 net/vmw_vsock/af_vsock.c                     |   38 +------
 net/xfrm/xfrm_policy.c                       |   12 +-
 tools/testing/selftests/net/xfrm_policy.sh   |   27 ++++-
 34 files changed, 334 insertions(+), 196 deletions(-)

Andrey Konovalov (1):
      media: pvrusb2: use a different format for warnings

Benjamin Coddington (1):
      NFS: Cleanup if nfs_match_client is interrupted

Fabio Estevam (1):
      ath10k: Change the warning message string

Florian Westphal (1):
      xfrm: policy: fix bydst hlist corruption on hash rebuild

Greg Kroah-Hartman (1):
      Linux 5.2.6

Jann Horn (2):
      sched/fair: Don't free p->numa_faults with concurrent readers
      sched/fair: Use RCU accessors consistently for ->numa_group

Linus Torvalds (2):
      /proc/<pid>/cmdline: remove all the special cases
      /proc/<pid>/cmdline: add back the setproctitle() special case

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc

Marta Rybczynska (1):
      nvme: fix multipath crash when ANA is deactivated

Miroslav Lichvar (1):
      drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Oliver Neukum (1):
      media: cpia2_usb: first wake up, then free in disconnect

Phong Tran (1):
      ISDN: hfcsusb: checking idx of ep configuration

Sean Young (1):
      media: au0828: fix null dereference in error path

Stanislav Fomichev (1):
      bpf: fix NULL deref in btf_type_is_resolve_source_only

Sunil Muthuswamy (1):
      vsock: correct removal of socket from the list

Vladis Dronov (1):
      Bluetooth: hci_uart: check for missing tty operations

Yan, Zheng (1):
      ceph: hold i_ceph_lock when removing caps for freeing inode

Yoshinori Sato (1):
      Fix allyesconfig output.


--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1Gr/cACgkQONu9yGCS
aT55/BAAzn29/1L+chYnLjleWzOBwQasZe3XaOW60eghUPVQN1jTvM3xAm/Ka4Si
zJM7d4vFSB22A9OKPKcnk6IwTM2V/lx/yXvWb5TW4HLiwlhXduMRt1i6tgOL6Zy1
GrkicqRwmHFCXgJEbHhFkUN7orxo6CtUAsLPUIoj303MQBNDjrf/F2sEOsjHwG96
cAHtEUJm6zWpi6FbJsANTDDdJFvqisXnctG8AD4VRRnhMr1Ct0y5bxYjARsrTouA
fvZCbJykbOE1sxptLuek10L6xd4NabsqKswmJhFcDLKU2AV3fnwErriNQUodBobw
M25OpsNhD+WrSG3xI7fVZliuDSKsxnnkO+p0KmxpX1xTdUBMtMyOuSD0jmg6/PcE
11cUDfCHIwQ4cnzKXYJknlGn7ur87JqEoTD3EkdQuW1M8rW77UPuktzOaYxEIfdV
swRoZqnkdWejSPosc0B9zUk/RyVkV5Zh+zWZvHw4h5pQMZ5rD5Wl9jlXf8BL5x0i
F+FD9SJuXwrG2Mk+MR2b9Yfom3fopTVAuPvHRmQHwQjUnKrcl9uph3T3j8qEOEhE
H+6fJ05f/CmQuX6qT4ovh9BjM3kDk9EvAHaFPLTuDzyRA+gmmtUDMEZ7wVd5s1iQ
pBBl7plQkODZMFc0M1Sv4eLlSVQOC8+KU8b5HSmRnZmDRk4/t6U=
=5jT6
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
