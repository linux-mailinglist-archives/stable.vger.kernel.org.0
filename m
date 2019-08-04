Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB0B80A5D
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 12:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfHDKNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 06:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfHDKNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 06:13:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3042075C;
        Sun,  4 Aug 2019 10:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564913617;
        bh=VmJoXEKUYKB5zqmiyo9xLIT0MrEQD+m4cAcQh5L+TKM=;
        h=Date:From:To:Cc:Subject:From;
        b=PXwmXWmBN5M9gh1RSztUPyk6GLhw+dqIughvhDnpE0sVhCLU5590/2FyaYqeQw16m
         lBGq+dpZp8yQJCAPdqVgzY/vDLSuxmKQOuNffG8d5p+xiTnDlsM4EmGRP71IT7Ew2N
         0yxbD4/ewSlnfx2LsXEPH7p/U+Ckc4nAXGhMTpf0=
Date:   Sun, 4 Aug 2019 12:13:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.136
Message-ID: <20190804101334.GA23679@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.136 kernel.

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

 Documentation/devicetree/bindings/serial/mvebu-uart.txt |    2=20
 Makefile                                                |    2=20
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi            |    2=20
 arch/arm64/include/asm/compat.h                         |    1=20
 arch/sh/boards/Kconfig                                  |   14=20
 drivers/android/binder.c                                |   16=20
 drivers/bluetooth/hci_ath.c                             |    3=20
 drivers/bluetooth/hci_bcm.c                             |    3=20
 drivers/bluetooth/hci_intel.c                           |    3=20
 drivers/bluetooth/hci_ldisc.c                           |   13=20
 drivers/bluetooth/hci_mrvl.c                            |    3=20
 drivers/bluetooth/hci_uart.h                            |    1=20
 drivers/i2c/busses/i2c-qup.c                            |    2=20
 drivers/iommu/intel-iommu.c                             |    2=20
 drivers/iommu/iova.c                                    |   18=20
 drivers/isdn/hardware/mISDN/hfcsusb.c                   |    3=20
 drivers/media/radio/radio-raremono.c                    |   30 +
 drivers/media/usb/au0828/au0828-core.c                  |   12=20
 drivers/media/usb/cpia2/cpia2_usb.c                     |    3=20
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                 |    4=20
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c            |    6=20
 drivers/media/usb/pvrusb2/pvrusb2-std.c                 |    2=20
 drivers/net/wireless/ath/ath10k/usb.c                   |    2=20
 drivers/pps/pps.c                                       |    8=20
 fs/ceph/caps.c                                          |    7=20
 fs/exec.c                                               |    2=20
 fs/nfs/client.c                                         |    4=20
 fs/nfs/dir.c                                            |  295 ++++++++---=
-----
 fs/nfs/nfs4proc.c                                       |   15=20
 include/linux/iova.h                                    |    6=20
 include/linux/sched/numa_balancing.h                    |    4=20
 include/net/af_vsock.h                                  |    3=20
 kernel/fork.c                                           |    2=20
 kernel/sched/fair.c                                     |   24 +
 net/ipv4/ip_tunnel_core.c                               |    9=20
 net/vmw_vsock/af_vsock.c                                |   84 +---
 net/vmw_vsock/hyperv_transport.c                        |  118 ++++--
 net/vmw_vsock/virtio_transport.c                        |    2=20
 net/vmw_vsock/virtio_transport_common.c                 |   22 -
 net/vmw_vsock/vmci_transport.c                          |   34 -
 net/vmw_vsock/vmci_transport_notify.c                   |    2=20
 net/vmw_vsock/vmci_transport_notify_qstate.c            |    2=20
 42 files changed, 477 insertions(+), 313 deletions(-)

Abhishek Sahu (1):
      i2c: qup: fixed releasing dma without flush operation completion

Andrey Konovalov (1):
      media: pvrusb2: use a different format for warnings

Benjamin Coddington (1):
      NFS: Cleanup if nfs_match_client is interrupted

Dmitry Safonov (1):
      iommu/vt-d: Don't queue_iova() if there is no flush queue

Fabio Estevam (1):
      ath10k: Change the warning message string

Greg Kroah-Hartman (1):
      Linux 4.14.136

Jann Horn (1):
      sched/fair: Don't free p->numa_faults with concurrent readers

Joerg Roedel (1):
      iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA

Luke Nowakowski-Krijger (1):
      media: radio-raremono: change devm_k*alloc to k*alloc

Miroslav Lichvar (1):
      drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl

Oliver Neukum (1):
      media: cpia2_usb: first wake up, then free in disconnect

Phong Tran (1):
      ISDN: hfcsusb: checking idx of ep configuration

Sean Young (1):
      media: au0828: fix null dereference in error path

Stefan Hajnoczi (1):
      VSOCK: use TCP state constants for sk_state

Sunil Muthuswamy (2):
      vsock: correct removal of socket from the list
      hv_sock: Add support for delayed close

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

allen yan (1):
      arm64: dts: marvell: Fix A37xx UART0 register size


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1Gr84ACgkQONu9yGCS
aT7gixAAnnbxgRWEyQnZ+TDVSG0du3O2nvJA+KkobJNrxC7l8rC5Wj6iVRtVJnUc
LJ9T4Aw8PSjwa5xqAvAk1AXkeqrGiTNPMfW910lRHDf9ezjhnA8RoZhE3gyvxKgu
aHZaDmTd1jaHBfAHeJ/eRfGONxLQPyAwCeRcbSCjrWTAkxbJu4xJzEI656ZHLG3Q
4JWrHrp9GhDZ4/VItRrHObOO2DequCm/k+qbQPznhLDAqU0cWkAQGU2aFNgDkszI
dUJt+e77L0VWnc/r5EGFUJXw/Cx25TB8Ib573eLVzJIrvcI1uFMTkZbbFZwsOFmU
pMalSOUt0GamrmRcPqlgORRnkoAuldtw/vGVSNu/q/9oHIU0eUgxBkj53eZd8sqV
ByOCIO+pdEZKrwaurgn6EFTEQk14MLFH6End3qgOex4YolPBQwke6O+aR876JBrp
rtMs7s8+Pj/VqWucYbmXZR+rL6r1mYZlWvywL58haBT6CkpUR7B2wL7QZm0qdGFy
WxccUHFOONW2RRhmHxLD0zQGN1FULl0wtJBUZNoaHfTo4DWo+p8aZkR6xp5jYn95
MDNU2WXuXts9oX5DN91PClD/rimUcOGfbbBDlZWObbLIlaUsfQNQhNyxAk39G+H+
wdDgBOz0a5zSoioQ3IzrdMN9xrMG3BwVIWLE94IBic6cIgDafhI=
=fZLc
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
