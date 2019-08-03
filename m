Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045F08059B
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbfHCJ63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 05:58:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46487 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388201AbfHCJ63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Aug 2019 05:58:29 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id C122B80371; Sat,  3 Aug 2019 11:58:13 +0200 (CEST)
Date:   Sat, 3 Aug 2019 11:58:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.64-stable review
Message-ID: <20190803095825.GA28812@amd>
References: <20190802092101.913646560@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2019-08-02 11:39:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.64 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.64=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.

The git tree does not seem to correspond to the patches posted. git has:

commit 63a8dab46af2b65ecdb5a83662d94a3a26be973e
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Aug 2 13:30:55 2019 +0200

    Linux 4.19.64-rc1

commit 1b35ed42aeacc21a9d21646165333566dd8e181a
Author: Xin Long <lucien.xin@gmail.com>
Date:   Mon Jun 17 21:34:13 2019 +0800

    ip_tunnel: allow not to count pkts on tstats by setting skb's dev
    to NULL
   =20
But 1b35ed42aeacc ip_tunnel patch is not mentioned here nor is
included in the series on the list AFAICT. (I don't find anything
wrong with 1b35ed42aeacc).

Best regards,
								Pavel


> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.64-rc1
>=20
> Bart Van Assche <bvanassche@acm.org>
>     scsi: core: Avoid that a kernel warning appears during system resume
>=20
> Bart Van Assche <bvanassche@acm.org>
>     block, scsi: Change the preempt-only flag into a counter
>=20
> Yan, Zheng <zyan@redhat.com>
>     ceph: hold i_ceph_lock when removing caps for freeing inode
>=20
> Yoshinori Sato <ysato@users.sourceforge.jp>
>     Fix allyesconfig output.
>=20
> Miroslav Lichvar <mlichvar@redhat.com>
>     drivers/pps/pps.c: clear offset flags in PPS_SETPARAMS ioctl
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     /proc/<pid>/cmdline: add back the setproctitle() special case
>=20
> Linus Torvalds <torvalds@linux-foundation.org>
>     /proc/<pid>/cmdline: remove all the special cases
>=20
> Jann Horn <jannh@google.com>
>     sched/fair: Use RCU accessors consistently for ->numa_group
>=20
> Jann Horn <jannh@google.com>
>     sched/fair: Don't free p->numa_faults with concurrent readers
>=20
> Jason Wang <jasowang@redhat.com>
>     vhost: scsi: add weight support
>=20
> Jason Wang <jasowang@redhat.com>
>     vhost: vsock: add weight support
>=20
> Jason Wang <jasowang@redhat.com>
>     vhost_net: fix possible infinite loop
>=20
> Jason Wang <jasowang@redhat.com>
>     vhost: introduce vhost_exceeds_weight()
>=20
> Vladis Dronov <vdronov@redhat.com>
>     Bluetooth: hci_uart: check for missing tty operations
>=20
> Joerg Roedel <jroedel@suse.de>
>     iommu/iova: Fix compilation error with !CONFIG_IOMMU_IOVA
>=20
> Dmitry Safonov <dima@arista.com>
>     iommu/vt-d: Don't queue_iova() if there is no flush queue
>=20
> Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
>     media: radio-raremono: change devm_k*alloc to k*alloc
>=20
> Benjamin Coddington <bcodding@redhat.com>
>     NFS: Cleanup if nfs_match_client is interrupted
>=20
> Andrey Konovalov <andreyknvl@google.com>
>     media: pvrusb2: use a different format for warnings
>=20
> Oliver Neukum <oneukum@suse.com>
>     media: cpia2_usb: first wake up, then free in disconnect
>=20
> Fabio Estevam <festevam@gmail.com>
>     ath10k: Change the warning message string
>=20
> Sean Young <sean@mess.org>
>     media: au0828: fix null dereference in error path
>=20
> Phong Tran <tranmanphong@gmail.com>
>     ISDN: hfcsusb: checking idx of ep configuration
>=20
> Todd Kjos <tkjos@android.com>
>     binder: fix possible UAF when freeing buffer
>=20
> Will Deacon <will.deacon@arm.com>
>     arm64: compat: Provide definition for COMPAT_SIGMINSTKSZ
>=20
> Minas Harutyunyan <minas.harutyunyan@synopsys.com>
>     usb: dwc2: Fix disable all EP's on disconnect
>=20
> Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
>     usb: dwc2: Disable all EP's on disconnect
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFSv4: Fix lookup revalidate of regular files
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Refactor nfs_lookup_revalidate()
>=20
> Trond Myklebust <trond.myklebust@hammerspace.com>
>     NFS: Fix dentry revalidation on NFSv4 lookup
>=20
> Sunil Muthuswamy <sunilmut@microsoft.com>
>     vsock: correct removal of socket from the list
>=20
> Sunil Muthuswamy <sunilmut@microsoft.com>
>     hv_sock: Add support for delayed close

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1FWsEACgkQMOfwapXb+vLRbACgr9cC5+lyiQKrgATUjIOooFQ8
9v4AoK26Wk3lyYWxHHiXOIApyKCOtdy+
=csRt
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
