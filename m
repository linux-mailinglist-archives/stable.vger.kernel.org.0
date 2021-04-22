Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3865D3679CE
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhDVGVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhDVGVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:21:42 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45D2C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:21:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c15so34588169wro.13
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bUpHcEcGKv8a7xkKp0l73wCfIbN9oAr6NX3aYaZ6tZU=;
        b=S/RZAUpmbMDdWjvwea1oXNFBQRJPievHG50qIIO5AiS3y8lEYSAO6vsYXSJLxHQX7T
         U8xBWSToXdq0VYasP5Bk5ZiPWF9S0GgefOgnzLUzc4Ot4DuLdmC19Q1DkMZPZDyV1MYb
         rYrh+YJ/CPfHVnS5E+OLCVzH6GgbX0BPzL4HG6kn7mCgcsfQUZZkEDAMB7kLrVGraFsa
         MHgfINbAhOtGzVIFU4RB8q+JgLgwB5i7h8SpzctfPTz92+ZBAEN1phDyGqcMMkqJJWz+
         kVtNUSrMwJBJyxlAkNfo4wFE65iroOJRrP8FriOZ4h8b238o5O85k3FRVaO/cFP//Pb1
         Q77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bUpHcEcGKv8a7xkKp0l73wCfIbN9oAr6NX3aYaZ6tZU=;
        b=IP2y2mYhShArAEc9FAt7Otd5NOV1QACEr7aiRK2d5+RMFcXUnng3IN3899WRVkH/ak
         CKUcAbYZVcUKYX9Veid7MuXBlZGgxN8tR/XrKxH8QpuyD+7bwshv2dPXUxF9S+Dqgd/9
         cXqy9hCRevcgPmQEfkQUekCtiv5KGLXg1YQ1Zb3w4IzA3dUWUqVDkvv+CMzcHKai5Vl5
         JvxkkmbAbLDXq34bkHxl6OQ3EWLvsygvS+12cysox9hskI8cYgZtSUaGcWD13x5HSGYw
         1UUZAKAObLilsnX1juNLFkvJI4jeOUJFtInVkodbDw4c3YfIsyaQ4R0UqNdKnj8hI2SD
         31iQ==
X-Gm-Message-State: AOAM530wzD56lDAtvgX34Wby8BD0u4XopR2kmDNjHPx8QfphfV6ugTQq
        1RPWCNQt+pToLSuE4z4ycTY=
X-Google-Smtp-Source: ABdhPJwf3OV618SlxDZj9u19o2oL5DbJbBsH2e53YQ3N/tb/X0SCfFianPNb/cKlZ9pH/aEoohbytQ==
X-Received: by 2002:a05:6000:190:: with SMTP id p16mr2011974wrx.334.1619072466525;
        Wed, 21 Apr 2021 23:21:06 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id h63sm1743627wmh.13.2021.04.21.23.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:21:04 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:21:03 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v4.19.y
Message-ID: <YIEVz5wz5oD93HvQ@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PXjQmd8Pn6vUPwpT"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PXjQmd8Pn6vUPwpT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

Resending with individual attachments as the previous mail with all the
attachments (sent last night) did not appear in https://lore.kernel.org/stable.

This is based on the 190 commits that you posted for mainline. Out of
that 24 patches had a reply mail asking not to revert (till last night).
So, the attached series for stable is based on the remaining 166 commits.
I have borrowed the commit message from your series.


--
Regards
Sudip

--PXjQmd8Pn6vUPwpT
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v4.19.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom c394f851dac2555d026abe730f66881b248ba357 Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:30:59 +0100=0ASubject: [PATCH 01/94] Revert "yam: fix a missing-check=
 bug"=0A=0AThis reverts commit 0781168e23a2fc8dceb989f11fc5b39b3ccacc35.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/net/hamradio/yam.c | 4 ----=0A 1 fi=
le changed, 4 deletions(-)=0A=0Adiff --git a/drivers/net/hamradio/yam.c b/d=
rivers/net/hamradio/yam.c=0Aindex fdab49872587..eb90d8780958 100644=0A--- a=
/drivers/net/hamradio/yam.c=0A+++ b/drivers/net/hamradio/yam.c=0A@@ -966,8 =
+966,6 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, i=
nt cmd)=0A 				 sizeof(struct yamdrv_ioctl_mcs));=0A 		if (IS_ERR(ym))=0A 	=
		return PTR_ERR(ym);=0A-		if (ym->cmd !=3D SIOCYAMSMCS)=0A-			return -EINV=
AL;=0A 		if (ym->bitrate > YAM_MAXBITRATE) {=0A 			kfree(ym);=0A 			return =
-EINVAL;=0A@@ -983,8 +981,6 @@ static int yam_ioctl(struct net_device *dev,=
 struct ifreq *ifr, int cmd)=0A 		if (copy_from_user(&yi, ifr->ifr_data, si=
zeof(struct yamdrv_ioctl_cfg)))=0A 			 return -EFAULT;=0A =0A-		if (yi.cmd =
!=3D SIOCYAMSCFG)=0A-			return -EINVAL;=0A 		if ((yi.cfg.mask & YAM_IOBASE)=
 && netif_running(dev))=0A 			return -EINVAL;		/* Cannot change this parame=
ter when up */=0A 		if ((yi.cfg.mask & YAM_IRQ) && netif_running(dev))=0A--=
 =0A2.30.2=0A=0A=0AFrom c804c4dbd09e24a21ac5a9ca9230eb5aedf59dee Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:30:59 +0100=0ASubject: [PATCH 02/94] Revert "net: cxgb=
3_main: fix a missing-check bug"=0A=0AThis reverts commit 2c05d88818ab65718=
16b93edce4d53703870d7ae.=0A=0ACommits from @umn.edu addresses have been fou=
nd to be submitted in "bad=0Afaith" to try to test the kernel community's a=
bility to review "known=0Amalicious" changes.  The result of these submissi=
ons can be found in a=0Apaper published at the 42nd IEEE Symposium on Secur=
ity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethe=
rnet/chelsio/cxgb3/cxgb3_main.c | 17 -----------------=0A 1 file changed, 1=
7 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_m=
ain.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0Aindex c82469ab7ab=
a..06a8c440741f 100644=0A--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_mai=
n.c=0A+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A@@ -2159,8 +2=
159,6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __use=
r *useraddr)=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr, siz=
eof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_SET_QSET_PARAMS)=
=0A-			return -EINVAL;=0A 		if (t.qset_idx >=3D SGE_QSETS)=0A 			return -EI=
NVAL;=0A 		if (!in_range(t.intr_lat, 0, M_NEWTIMER) ||=0A@@ -2260,9 +2258,6=
 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *us=
eraddr)=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFA=
ULT;=0A =0A-		if (t.cmd !=3D CHELSIO_GET_QSET_PARAMS)=0A-			return -EINVAL;=
=0A-=0A 		/* Display qsets for all ports when offload enabled */=0A 		if (t=
est_bit(OFFLOAD_DEVMAP_BIT, &adapter->open_device_map)) {=0A 			q1 =3D 0;=
=0A@@ -2308,8 +2303,6 @@ static int cxgb_extension_ioctl(struct net_device =
*dev, void __user *useraddr)=0A 			return -EBUSY;=0A 		if (copy_from_user(&=
edata, useraddr, sizeof(edata)))=0A 			return -EFAULT;=0A-		if (edata.cmd !=
=3D CHELSIO_SET_QSET_NUM)=0A-			return -EINVAL;=0A 		if (edata.val < 1 ||=
=0A 			(edata.val > 1 && !(adapter->flags & USING_MSIX)))=0A 			return -EIN=
VAL;=0A@@ -2350,8 +2343,6 @@ static int cxgb_extension_ioctl(struct net_dev=
ice *dev, void __user *useraddr)=0A 			return -EPERM;=0A 		if (copy_from_us=
er(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHEL=
SIO_LOAD_FW)=0A-			return -EINVAL;=0A 		/* Check t.len sanity ? */=0A 		fw_=
data =3D memdup_user(useraddr + sizeof(t), t.len);=0A 		if (IS_ERR(fw_data)=
)=0A@@ -2375,8 +2366,6 @@ static int cxgb_extension_ioctl(struct net_device=
 *dev, void __user *useraddr)=0A 			return -EBUSY;=0A 		if (copy_from_user(=
&m, useraddr, sizeof(m)))=0A 			return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO=
_SETMTUTAB)=0A-			return -EINVAL;=0A 		if (m.nmtus !=3D NMTUS)=0A 			return=
 -EINVAL;=0A 		if (m.mtus[0] < 81)	/* accommodate SACK */=0A@@ -2418,8 +240=
7,6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user =
*useraddr)=0A 			return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeo=
f(m)))=0A 			return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SET_PM)=0A-			retu=
rn -EINVAL;=0A 		if (!is_power_of_2(m.rx_pg_sz) ||=0A 			!is_power_of_2(m.t=
x_pg_sz))=0A 			return -EINVAL;	/* not power of 2 */=0A@@ -2455,8 +2442,6 @=
@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *user=
addr)=0A 			return -EIO;	/* need the memory controllers */=0A 		if (copy_fr=
om_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D=
 CHELSIO_GET_MEM)=0A-			return -EINVAL;=0A 		if ((t.addr & 7) || (t.len & 7=
))=0A 			return -EINVAL;=0A 		if (t.mem_id =3D=3D MEM_CM)=0A@@ -2509,8 +249=
4,6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user =
*useraddr)=0A 			return -EAGAIN;=0A 		if (copy_from_user(&t, useraddr, size=
of(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_SET_TRACE_FILTER)=
=0A-			return -EINVAL;=0A =0A 		tp =3D (const struct trace_params *)&t.sip;=
=0A 		if (t.config_tx)=0A-- =0A2.30.2=0A=0A=0AFrom 55a7539b099ee81bfa32962c=
264f95a4103fbcaf Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:00 +0100=0ASubject: [PAT=
CH 03/94] Revert "net: socket: fix a missing-check bug"=0A=0AThis reverts c=
ommit b6168562c8ce2bd5a30e213021650422e08764dc.=0A=0ACommits from @umn.edu =
addresses have been found to be submitted in "bad=0Afaith" to try to test t=
he kernel community's ability to review "known=0Amalicious" changes.  The r=
esult of these submissions can be found in a=0Apaper published at the 42nd =
IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity:=
 Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by=
 Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnes=
ota).=0A=0ABecause of this, all submissions from this group must be reverte=
d from=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A net/socket.c | 11 +++--------=0A 1 file changed, 3 insertions(+), 8 d=
eletions(-)=0A=0Adiff --git a/net/socket.c b/net/socket.c=0Aindex 29169045d=
cfe..7fcf548b599e 100644=0A--- a/net/socket.c=0A+++ b/net/socket.c=0A@@ -28=
72,14 +2872,9 @@ static int ethtool_ioctl(struct net *net, struct compat_if=
req __user *ifr32)=0A 		    copy_in_user(&rxnfc->fs.ring_cookie,=0A 				 &c=
ompat_rxnfc->fs.ring_cookie,=0A 				 (void __user *)(&rxnfc->fs.location + =
1) -=0A-				 (void __user *)&rxnfc->fs.ring_cookie))=0A-			return -EFAULT;=
=0A-		if (ethcmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-			if (put_user(rule_cnt,=
 &rxnfc->rule_cnt))=0A-				return -EFAULT;=0A-		} else if (copy_in_user(&rx=
nfc->rule_cnt,=0A-					&compat_rxnfc->rule_cnt,=0A-					sizeof(rxnfc->rule_=
cnt)))=0A+				 (void __user *)&rxnfc->fs.ring_cookie) ||=0A+		    copy_in_u=
ser(&rxnfc->rule_cnt, &compat_rxnfc->rule_cnt,=0A+				 sizeof(rxnfc->rule_c=
nt)))=0A 			return -EFAULT;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 733415b5c=
7c7fca096835270f347858798d76c65 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:00 +0100=
=0ASubject: [PATCH 04/94] Revert "ethtool: fix a missing-check bug"=0A=0ATh=
is reverts commit 2bb3207dbbd4d30e96dd0e1c8e013104193bd59c.=0A=0ACommits fr=
om @umn.edu addresses have been found to be submitted in "bad=0Afaith" to t=
ry to test the kernel community's ability to review "known=0Amalicious" cha=
nges.  The result of these submissions can be found in a=0Apaper published =
at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source=
 Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits=
" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universi=
ty of Minnesota).=0A=0ABecause of this, all submissions from this group mus=
t be reverted from=0Athe kernel tree and will need to be re-reviewed again =
to determine if=0Athey actually are a valid fix.  Until that work is comple=
te, remove this=0Achange to ensure that no problems are being introduced in=
to the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0A---=0A net/core/ethtool.c | 3 ---=0A 1 file changed, 3 deletions=
(-)=0A=0Adiff --git a/net/core/ethtool.c b/net/core/ethtool.c=0Aindex 10116=
25a0ca4..08deab16d82c 100644=0A--- a/net/core/ethtool.c=0A+++ b/net/core/et=
htool.c=0A@@ -1020,9 +1020,6 @@ static noinline_for_stack int ethtool_get_r=
xnfc(struct net_device *dev,=0A 			return -EINVAL;=0A 	}=0A =0A-	if (info.c=
md !=3D cmd)=0A-		return -EINVAL;=0A-=0A 	if (info.cmd =3D=3D ETHTOOL_GRXCL=
SRLALL) {=0A 		if (info.rule_cnt > 0) {=0A 			if (info.rule_cnt <=3D KMALLO=
C_MAX_SIZE / sizeof(u32))=0A-- =0A2.30.2=0A=0A=0AFrom d99bd6aadc0d354e7026b=
4ffbf01529bdf568102 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:00 +0100=0ASubject: [=
PATCH 05/94] Revert "scsi: 3w-xxxx: fix a missing-check bug"=0A=0AThis reve=
rts commit 9899e4d3523faaef17c67141aa80ff2088f17871.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/scsi/3w-xxxx.c | 3 ---=0A 1 file changed, 3 deletions(=
-)=0A=0Adiff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c=0Ainde=
x 471366945bd4..55658c43aba3 100644=0A--- a/drivers/scsi/3w-xxxx.c=0A+++ b/=
drivers/scsi/3w-xxxx.c=0A@@ -1033,9 +1033,6 @@ static int tw_chrdev_open(st=
ruct inode *inode, struct file *file)=0A =0A 	dprintk(KERN_WARNING "3w-xxxx=
: tw_ioctl_open()\n");=0A =0A-	if (!capable(CAP_SYS_ADMIN))=0A-		return -EA=
CCES;=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=3D tw_=
device_extension_count)=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom c7=
8cded522ed3b9209728ebf5d5d06c9bb750628 Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:01=
 +0100=0ASubject: [PATCH 06/94] Revert "scsi: 3w-9xxx: fix a missing-check =
bug"=0A=0AThis reverts commit c9318a3e0218bc9dacc25be46b9eec363259536f.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/scsi/3w-9xxx.c | 5 -----=0A 1 file =
changed, 5 deletions(-)=0A=0Adiff --git a/drivers/scsi/3w-9xxx.c b/drivers/=
scsi/3w-9xxx.c=0Aindex 27521fc3ef5a..0767fabc9aa4 100644=0A--- a/drivers/sc=
si/3w-9xxx.c=0A+++ b/drivers/scsi/3w-9xxx.c=0A@@ -882,11 +882,6 @@ static i=
nt twa_chrdev_open(struct inode *inode, struct file *file)=0A 	unsigned int=
 minor_number;=0A 	int retval =3D TW_IOCTL_ERROR_OS_ENODEV;=0A =0A-	if (!ca=
pable(CAP_SYS_ADMIN)) {=0A-		retval =3D -EACCES;=0A-		goto out;=0A-	}=0A-=
=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=3D twa_device_e=
xtension_count)=0A 		goto out;=0A-- =0A2.30.2=0A=0A=0AFrom da1a98c3ce94adf9=
3b703c72f89fd46e258122d6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:01 +0100=0ASubje=
ct: [PATCH 07/94] Revert "ethtool: fix a potential missing-check bug"=0A=0A=
This reverts commit d656fe49e33df48ee6bc19e871f5862f49895c9e.=0A=0ACommits =
=66rom @umn.edu addresses have been found to be submitted in "bad=0Afaith" =
to try to test the kernel community's ability to review "known=0Amalicious"=
 changes.  The result of these submissions can be found in a=0Apaper publis=
hed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open So=
urce Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Com=
mits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Univ=
ersity of Minnesota).=0A=0ABecause of this, all submissions from this group=
 must be reverted from=0Athe kernel tree and will need to be re-reviewed ag=
ain to determine if=0Athey actually are a valid fix.  Until that work is co=
mplete, remove this=0Achange to ensure that no problems are being introduce=
d into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0A---=0A net/core/ethtool.c | 5 -----=0A 1 file changed, 5 del=
etions(-)=0A=0Adiff --git a/net/core/ethtool.c b/net/core/ethtool.c=0Aindex=
 08deab16d82c..146c978cfcc7 100644=0A--- a/net/core/ethtool.c=0A+++ b/net/c=
ore/ethtool.c=0A@@ -1013,11 +1013,6 @@ static noinline_for_stack int ethtoo=
l_get_rxnfc(struct net_device *dev,=0A 		info_size =3D sizeof(info);=0A 		i=
f (copy_from_user(&info, useraddr, info_size))=0A 			return -EFAULT;=0A-		/=
* Since malicious users may modify the original data,=0A-		 * we need to ch=
eck whether FLOW_RSS is still requested.=0A-		 */=0A-		if (!(info.flow_type=
 & FLOW_RSS))=0A-			return -EINVAL;=0A 	}=0A =0A 	if (info.cmd =3D=3D ETHTO=
OL_GRXCLSRLALL) {=0A-- =0A2.30.2=0A=0A=0AFrom a49ab6ae2628d662905caf4f9f7b8=
f482e668b1c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:01 +0100=0ASubject: [PATCH 08=
/94] Revert "media: sti: Fix reference count leaks"=0A=0AThis reverts commi=
t bde69ac535ebacb40a610e2463872cfde24f1aad.=0A=0ACommits from @umn.edu addr=
esses have been found to be submitted in "bad=0Afaith" to try to test the k=
ernel community's ability to review "known=0Amalicious" changes.  The resul=
t of these submissions can be found in a=0Apaper published at the 42nd IEEE=
 Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Ste=
althily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiu=
shi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota)=
=2E=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/media/platform/sti/hva/hva-hw.c | 2 --=0A 1 file changed, 2 d=
eletions(-)=0A=0Adiff --git a/drivers/media/platform/sti/hva/hva-hw.c b/dri=
vers/media/platform/sti/hva/hva-hw.c=0Aindex d826c011c095..78132418073a 100=
644=0A--- a/drivers/media/platform/sti/hva/hva-hw.c=0A+++ b/drivers/media/p=
latform/sti/hva/hva-hw.c=0A@@ -272,7 +272,6 @@ static unsigned long int hva=
_hw_get_ip_version(struct hva_dev *hva)=0A =0A 	if (pm_runtime_get_sync(dev=
) < 0) {=0A 		dev_err(dev, "%s     failed to get pm_runtime\n", HVA_PREFIX)=
;=0A-		pm_runtime_put_noidle(dev);=0A 		mutex_unlock(&hva->protect_mutex);=
=0A 		return -EFAULT;=0A 	}=0A@@ -558,7 +557,6 @@ void hva_hw_dump_regs(str=
uct hva_dev *hva, struct seq_file *s)=0A =0A 	if (pm_runtime_get_sync(dev) =
< 0) {=0A 		seq_puts(s, "Cannot wake up IP\n");=0A-		pm_runtime_put_noidle(=
dev);=0A 		mutex_unlock(&hva->protect_mutex);=0A 		return;=0A 	}=0A-- =0A2.=
30.2=0A=0A=0AFrom bdcd1ce49f3857e73ddaca96e1154d9a9abb0a6e Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:31:02 +0100=0ASubject: [PATCH 09/94] Revert "media: rockchip=
/rga: Fix a reference count=0A leak."=0A=0AThis reverts commit 8ead18003409=
64bbe1a884c70ca09e98101b71fb.=0A=0ACommits from @umn.edu addresses have bee=
n found to be submitted in "bad=0Afaith" to try to test the kernel communit=
y's ability to review "known=0Amalicious" changes.  The result of these sub=
missions can be found in a=0Apaper published at the 42nd IEEE Symposium on =
Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introd=
ucing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univer=
sity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause=
 of this, all submissions from this group must be reverted from=0Athe kerne=
l tree and will need to be re-reviewed again to determine if=0Athey actuall=
y are a valid fix.  Until that work is complete, remove this=0Achange to en=
sure that no problems are being introduced into the=0Acodebase.=0A=0ASigned=
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/medi=
a/platform/rockchip/rga/rga-buf.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=
=0Adiff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/med=
ia/platform/rockchip/rga/rga-buf.c=0Aindex 0932f1445dea..356821c2dacf 10064=
4=0A--- a/drivers/media/platform/rockchip/rga/rga-buf.c=0A+++ b/drivers/med=
ia/platform/rockchip/rga/rga-buf.c=0A@@ -89,7 +89,6 @@ static int rga_buf_s=
tart_streaming(struct vb2_queue *q, unsigned int count)=0A =0A 	ret =3D pm_=
runtime_get_sync(rga->dev);=0A 	if (ret < 0) {=0A-		pm_runtime_put_noidle(r=
ga->dev);=0A 		rga_buf_return_buffers(q, VB2_BUF_STATE_QUEUED);=0A 		return=
 ret;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 4c8e240a523b55a3d4d88190d6035e36767=
285c9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:31:02 +0100=0ASubject: [PATCH 10/94] R=
evert "media: rcar-vin: Fix a reference count leak."=0A=0AThis reverts comm=
it 8dc9270d00140d7ac5bf4aabf5abfac6b95d4467.=0A=0ACommits from @umn.edu add=
resses have been found to be submitted in "bad=0Afaith" to try to test the =
kernel community's ability to review "known=0Amalicious" changes.  The resu=
lt of these submissions can be found in a=0Apaper published at the 42nd IEE=
E Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: St=
ealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qi=
ushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota=
).=0A=0ABecause of this, all submissions from this group must be reverted f=
rom=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/media/platform/rcar-vin/rcar-dma.c | 4 +---=0A 1 file changed, =
1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platform/rca=
r-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c=0Aindex 70a8c=
c433a03..92323310f735 100644=0A--- a/drivers/media/platform/rcar-vin/rcar-d=
ma.c=0A+++ b/drivers/media/platform/rcar-vin/rcar-dma.c=0A@@ -1323,10 +1323=
,8 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)=0A 	int =
ret;=0A =0A 	ret =3D pm_runtime_get_sync(vin->dev);=0A-	if (ret < 0) {=0A-	=
	pm_runtime_put_noidle(vin->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=
=0A =0A 	/* Make register writes take effect immediately. */=0A 	vnmc =3D r=
vin_read(vin, VNMC_REG);=0A-- =0A2.30.2=0A=0A=0AFrom 08ab9db9c92d3e01f737ab=
be96d771cb410b5638 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:02 +0100=0ASubject: =
[PATCH 11/94] Revert "firmware: Fix a reference count leak."=0A=0AThis reve=
rts commit 937dafe8682044e70821c886d9063869744b3057.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/firmware/qemu_fw_cfg.c | 7 +++----=0A 1 file changed, =
3 insertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/firmware/qemu_fw_=
cfg.c b/drivers/firmware/qemu_fw_cfg.c=0Aindex 6945c3c96637..039e0f91dba8 1=
00644=0A--- a/drivers/firmware/qemu_fw_cfg.c=0A+++ b/drivers/firmware/qemu_=
fw_cfg.c=0A@@ -605,10 +605,8 @@ static int fw_cfg_register_file(const struc=
t fw_cfg_file *f)=0A 	/* register entry under "/sys/firmware/qemu_fw_cfg/by=
_key/" */=0A 	err =3D kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entr=
y_ktype,=0A 				   fw_cfg_sel_ko, "%d", entry->select);=0A-	if (err) {=0A-	=
	kobject_put(&entry->kobj);=0A-		return err;=0A-	}=0A+	if (err)=0A+		goto e=
rr_register;=0A =0A 	/* add raw binary content access */=0A 	err =3D sysfs_=
create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);=0A@@ -624,6 +622,7 @=
@ static int fw_cfg_register_file(const struct fw_cfg_file *f)=0A =0A err_a=
dd_raw:=0A 	kobject_del(&entry->kobj);=0A+err_register:=0A 	kfree(entry);=
=0A 	return err;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 09f02d26bbe06fd21ff4a3f68=
e1d674698f2837b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:03 +0100=0ASubject: [PATC=
H 12/94] Revert "drm/nouveau: fix reference count leak in=0A nv50_disp_atom=
ic_commit"=0A=0AThis reverts commit e15bc26ff99cdcb459a59ba5f35ebe2549ed939=
0.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
"bad=0Afaith" to try to test the kernel community's ability to review "know=
n=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/dispnv50/dis=
p.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --=
git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dis=
pnv50/disp.c=0Aindex fbe156302ee8..0f1ba70df6b4 100644=0A--- a/drivers/gpu/=
drm/nouveau/dispnv50/disp.c=0A+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c=
=0A@@ -1922,10 +1922,8 @@ nv50_disp_atomic_commit(struct drm_device *dev,=
=0A 	int ret, i;=0A =0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if (ret=
 < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	=
if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	ret =3D drm=
_atomic_helper_setup_commit(state, nonblock);=0A 	if (ret)=0A-- =0A2.30.2=
=0A=0A=0AFrom 2442e6f2979f3762aa605cf1b1bb610390a15af7 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:31:03 +0100=0ASubject: [PATCH 13/94] Revert "drm/nouveau: fix mu=
ltiple instances of=0A reference count leaks"=0A=0AThis reverts commit afd8=
47bb56cbf87c5e5b384d7c89d4661b6c3755.=0A=0ACommits from @umn.edu addresses =
have been found to be submitted in "bad=0Afaith" to try to test the kernel =
community's ability to review "known=0Amalicious" changes.  The result of t=
hese submissions can be found in a=0Apaper published at the 42nd IEEE Sympo=
sium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthil=
y Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu=
 (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/gpu/drm/nouveau/nouveau_drm.c | 8 ++------=0A drivers/gpu/drm/nouve=
au/nouveau_gem.c | 4 +---=0A 2 files changed, 3 insertions(+), 9 deletions(=
-)=0A=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/dr=
m/nouveau/nouveau_drm.c=0Aindex 81999bed1e4a..2b7a54cc3c9e 100644=0A--- a/d=
rivers/gpu/drm/nouveau/nouveau_drm.c=0A+++ b/drivers/gpu/drm/nouveau/nouvea=
u_drm.c=0A@@ -899,10 +899,8 @@ nouveau_drm_open(struct drm_device *dev, str=
uct drm_file *fpriv)=0A =0A 	/* need to bring up power immediately if openi=
ng device */=0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if (ret < 0 && =
ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	if (ret =
< 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	get_task_comm(tmpna=
me, current);=0A 	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fp=
riv->pid));=0A@@ -982,10 +980,8 @@ nouveau_drm_ioctl(struct file *file, uns=
igned int cmd, unsigned long arg)=0A 	long ret;=0A =0A 	ret =3D pm_runtime_=
get_sync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_=
put_autosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return=
 ret;=0A-	}=0A =0A 	switch (_IOC_NR(cmd) - DRM_COMMAND_BASE) {=0A 	case DRM=
_NOUVEAU_NVIF:=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drive=
rs/gpu/drm/nouveau/nouveau_gem.c=0Aindex a98fccb0d32f..b41bf317a755 100644=
=0A--- a/drivers/gpu/drm/nouveau/nouveau_gem.c=0A+++ b/drivers/gpu/drm/nouv=
eau/nouveau_gem.c=0A@@ -46,10 +46,8 @@ nouveau_gem_object_del(struct drm_ge=
m_object *gem)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	i=
f (WARN_ON(ret < 0 && ret !=3D -EACCES)) {=0A-		pm_runtime_put_autosuspend(=
dev);=0A+	if (WARN_ON(ret < 0 && ret !=3D -EACCES))=0A 		return;=0A-	}=0A =
=0A 	if (gem->import_attach)=0A 		drm_prime_gem_destroy(gem, nvbo->bo.sg);=
=0A-- =0A2.30.2=0A=0A=0AFrom 8763c1b2f8ddd19c64347dcff0245600a3b0ff21 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:31:03 +0100=0ASubject: [PATCH 14/94] Revert "drm/=
nouveau/drm/noveau: fix reference count=0A leak in nouveau_fbcon_open"=0A=
=0AThis reverts commit 83443512a9493281dd9481681194ea45dbdfd5ee.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/nouveau_fbcon.c | 4 +---=0A =
1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/gp=
u/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0Ai=
ndex d4fe52ec4c96..406cb99af7f2 100644=0A--- a/drivers/gpu/drm/nouveau/nouv=
eau_fbcon.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0A@@ -189,10 +1=
89,8 @@ nouveau_fbcon_open(struct fb_info *info, int user)=0A 	struct nouve=
au_fbdev *fbcon =3D info->par;=0A 	struct nouveau_drm *drm =3D nouveau_drm(=
fbcon->helper.dev);=0A 	int ret =3D pm_runtime_get_sync(drm->dev->dev);=0A-=
	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put(drm->dev->dev);=0A+=
	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A 	return 0;=0A }=
=0A =0A-- =0A2.30.2=0A=0A=0AFrom d62a2e0a7c40705215713df9972c9ea1f98f2be4 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:31:03 +0100=0ASubject: [PATCH 15/94] Revert "=
PCI: Fix pci_create_slot() reference count=0A leak"=0A=0AThis reverts commi=
t 03f4e517e6ac202d6a6ca50f02a1319a4a70cdd6.=0A=0ACommits from @umn.edu addr=
esses have been found to be submitted in "bad=0Afaith" to try to test the k=
ernel community's ability to review "known=0Amalicious" changes.  The resul=
t of these submissions can be found in a=0Apaper published at the 42nd IEEE=
 Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Ste=
althily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiu=
shi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota)=
=2E=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/pci/slot.c | 6 ++----=0A 1 file changed, 2 insertions(+), 4 d=
eletions(-)=0A=0Adiff --git a/drivers/pci/slot.c b/drivers/pci/slot.c=0Aind=
ex dfbe9cbf292c..184195c2f389 100644=0A--- a/drivers/pci/slot.c=0A+++ b/dri=
vers/pci/slot.c=0A@@ -303,7 +303,6 @@ struct pci_slot *pci_create_slot(stru=
ct pci_bus *parent, int slot_nr,=0A 	slot_name =3D make_slot_name(name);=0A=
 	if (!slot_name) {=0A 		err =3D -ENOMEM;=0A-		kfree(slot);=0A 		goto err;=
=0A 	}=0A =0A@@ -312,10 +311,8 @@ struct pci_slot *pci_create_slot(struct p=
ci_bus *parent, int slot_nr,=0A =0A 	err =3D kobject_init_and_add(&slot->ko=
bj, &pci_slot_ktype, NULL,=0A 				   "%s", slot_name);=0A-	if (err) {=0A-		=
kobject_put(&slot->kobj);=0A+	if (err)=0A 		goto err;=0A-	}=0A =0A 	down_re=
ad(&pci_bus_sem);=0A 	list_for_each_entry(dev, &parent->devices, bus_list)=
=0A@@ -331,6 +328,7 @@ struct pci_slot *pci_create_slot(struct pci_bus *par=
ent, int slot_nr,=0A 	mutex_unlock(&pci_slot_mutex);=0A 	return slot;=0A er=
r:=0A+	kfree(slot);=0A 	slot =3D ERR_PTR(err);=0A 	goto out;=0A }=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 23290c3dfb4727b9a0aa663a5334b1d9e480baeb Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:31:04 +0100=0ASubject: [PATCH 16/94] Revert "omapfb: fix =
multiple reference count leaks due=0A to pm_runtime_get_sync"=0A=0AThis rev=
erts commit 1c33c23b931d0b0e38aa436a90c2c527414e2fc5.=0A=0ACommits from @um=
n.edu addresses have been found to be submitted in "bad=0Afaith" to try to =
test the kernel community's ability to review "known=0Amalicious" changes. =
 The result of these submissions can be found in a=0Apaper published at the=
 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insec=
urity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writ=
ten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of =
Minnesota).=0A=0ABecause of this, all submissions from this group must be r=
everted from=0Athe kernel tree and will need to be re-reviewed again to det=
ermine if=0Athey actually are a valid fix.  Until that work is complete, re=
move this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A drivers/video/fbdev/omap2/omapfb/dss/dispc.c | 7 ++-----=0A dri=
vers/video/fbdev/omap2/omapfb/dss/dsi.c   | 7 ++-----=0A drivers/video/fbde=
v/omap2/omapfb/dss/dss.c   | 7 ++-----=0A drivers/video/fbdev/omap2/omapfb/=
dss/hdmi4.c | 5 ++---=0A drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c | 5 +=
+---=0A drivers/video/fbdev/omap2/omapfb/dss/venc.c  | 7 ++-----=0A 6 files=
 changed, 12 insertions(+), 26 deletions(-)=0A=0Adiff --git a/drivers/video=
/fbdev/omap2/omapfb/dss/dispc.c b/drivers/video/fbdev/omap2/omapfb/dss/disp=
c.c=0Aindex 0bd582e845f3..a06d9c25765c 100644=0A--- a/drivers/video/fbdev/o=
map2/omapfb/dss/dispc.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/dispc.=
c=0A@@ -531,11 +531,8 @@ int dispc_runtime_get(void)=0A 	DSSDBG("dispc_runt=
ime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&dispc.pdev->dev);=0A-	if (W=
ARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dispc.pdev->dev);=0A-		return r;=
=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =
EXPORT_SYMBOL(dispc_runtime_get);=0A =0Adiff --git a/drivers/video/fbdev/om=
ap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c=0Aindex 5=
0792d31533b..8e1d60d48dbb 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/d=
ss/dsi.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c=0A@@ -1148,11 +=
1148,8 @@ static int dsi_runtime_get(struct platform_device *dsidev)=0A 	DS=
SDBG("dsi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&dsi->pdev->de=
v);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dsi->pdev->dev);=0A=
-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r :=
 0;=0A }=0A =0A static void dsi_runtime_put(struct platform_device *dsidev)=
=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/=
fbdev/omap2/omapfb/dss/dss.c=0Aindex faebf9a773ba..b6c6c24979dd 100644=0A--=
- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0A+++ b/drivers/video/fbdev/=
omap2/omapfb/dss/dss.c=0A@@ -779,11 +779,8 @@ int dss_runtime_get(void)=0A =
	DSSDBG("dss_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&dss.pdev->=
dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dss.pdev->dev);=
=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? =
r : 0;=0A }=0A =0A void dss_runtime_put(void)=0Adiff --git a/drivers/video/=
fbdev/omap2/omapfb/dss/hdmi4.c b/drivers/video/fbdev/omap2/omapfb/dss/hdmi4=
=2Ec=0Aindex 9fd9a02bb871..28de56e21c74 100644=0A--- a/drivers/video/fbdev/=
omap2/omapfb/dss/hdmi4.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/hdmi4=
=2Ec=0A@@ -50,10 +50,9 @@ static int hdmi_runtime_get(void)=0A 	DSSDBG("hdm=
i_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&hdmi.pdev->dev);=0A-	=
if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&hdmi.pdev->dev);=0A+	WARN_O=
N(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	}=0A =0A 	return 0;=0A }=0Adiff=
 --git a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c b/drivers/video/fbdev=
/omap2/omapfb/dss/hdmi5.c=0Aindex 13f3a5ce5529..2e2fcc3d6d4f 100644=0A--- a=
/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c=0A+++ b/drivers/video/fbdev/o=
map2/omapfb/dss/hdmi5.c=0A@@ -54,10 +54,9 @@ static int hdmi_runtime_get(vo=
id)=0A 	DSSDBG("hdmi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&hd=
mi.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&hdmi.pde=
v->dev);=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	}=0A =0A 	re=
turn 0;=0A }=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/venc.c b/d=
rivers/video/fbdev/omap2/omapfb/dss/venc.c=0Aindex 96714b4596d2..392464da12=
e4 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0A+++ b/drive=
rs/video/fbdev/omap2/omapfb/dss/venc.c=0A@@ -402,11 +402,8 @@ static int ve=
nc_runtime_get(void)=0A 	DSSDBG("venc_runtime_get\n");=0A =0A 	r =3D pm_run=
time_get_sync(&venc.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_p=
ut_sync(&venc.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r =
< 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A static void venc_runtime_put(vo=
id)=0A-- =0A2.30.2=0A=0A=0AFrom 4fb3a341905c243cd451409b31fec8ced79d568b Mo=
n Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:04 +0100=0ASubject: [PATCH 17/94] Revert "m=
edia: exynos4-is: Fix several reference count=0A leaks due to pm_runtime_ge=
t_sync"=0A=0AThis reverts commit 72818356f146e927b58e334d01e55610da584675.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/exynos4-is/fi=
mc-isp.c  | 4 +---=0A drivers/media/platform/exynos4-is/fimc-lite.c | 2 +-=
=0A 2 files changed, 2 insertions(+), 4 deletions(-)=0A=0Adiff --git a/driv=
ers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-i=
s/fimc-isp.c=0Aindex 1dbebdc1c2f8..9a48c0f69320 100644=0A--- a/drivers/medi=
a/platform/exynos4-is/fimc-isp.c=0A+++ b/drivers/media/platform/exynos4-is/=
fimc-isp.c=0A@@ -311,10 +311,8 @@ static int fimc_isp_subdev_s_power(struct=
 v4l2_subdev *sd, int on)=0A =0A 	if (on) {=0A 		ret =3D pm_runtime_get_syn=
c(&is->pdev->dev);=0A-		if (ret < 0) {=0A-			pm_runtime_put(&is->pdev->dev)=
;=0A+		if (ret < 0)=0A 			return ret;=0A-		}=0A 		set_bit(IS_ST_PWR_ON, &is=
->state);=0A =0A 		ret =3D fimc_is_start_firmware(is);=0Adiff --git a/drive=
rs/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-i=
s/fimc-lite.c=0Aindex 10fe7d2e8790..70d5f5586a5d 100644=0A--- a/drivers/med=
ia/platform/exynos4-is/fimc-lite.c=0A+++ b/drivers/media/platform/exynos4-i=
s/fimc-lite.c=0A@@ -480,7 +480,7 @@ static int fimc_lite_open(struct file *=
file)=0A 	set_bit(ST_FLITE_IN_USE, &fimc->state);=0A 	ret =3D pm_runtime_ge=
t_sync(&fimc->pdev->dev);=0A 	if (ret < 0)=0A-		goto err_pm;=0A+		goto unlo=
ck;=0A =0A 	ret =3D v4l2_fh_open(file);=0A 	if (ret < 0)=0A-- =0A2.30.2=0A=
=0A=0AFrom dae1979075508a9504cb45dd1af23bb114987ed4 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:31:04 +0100=0ASubject: [PATCH 18/94] Revert "usb: dwc3: pci: Fix re=
ference count leak in=0A dwc3_pci_resume_work"=0A=0AThis reverts commit cc1=
815b74b28f044075f724e09516c4169981958.=0A=0ACommits from @umn.edu addresses=
 have been found to be submitted in "bad=0Afaith" to try to test the kernel=
 community's ability to review "known=0Amalicious" changes.  The result of =
these submissions can be found in a=0Apaper published at the 42nd IEEE Symp=
osium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthi=
ly Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi W=
u (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/usb/dwc3/dwc3-pci.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 d=
eletions(-)=0A=0Adiff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc=
3/dwc3-pci.c=0Aindex 389ec4c689c4..b2fd505938a0 100644=0A--- a/drivers/usb/=
dwc3/dwc3-pci.c=0A+++ b/drivers/usb/dwc3/dwc3-pci.c=0A@@ -204,10 +204,8 @@ =
static void dwc3_pci_resume_work(struct work_struct *work)=0A 	int ret;=0A =
=0A 	ret =3D pm_runtime_get_sync(&dwc3->dev);=0A-	if (ret) {=0A-		pm_runtim=
e_put_sync_autosuspend(&dwc3->dev);=0A+	if (ret)=0A 		return;=0A-	}=0A =0A =
	pm_runtime_mark_last_busy(&dwc3->dev);=0A 	pm_runtime_put_sync_autosuspend=
(&dwc3->dev);=0A-- =0A2.30.2=0A=0A=0AFrom d7f5d5c068754e0be403c45de08f5bc50=
222279d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:04 +0100=0ASubject: [PATCH 19/94]=
 Revert "ASoC: rockchip: Fix a reference count leak."=0A=0AThis reverts com=
mit df5888912859c26b9d7cb825eb26920f5e0f9c67.=0A=0ACommits from @umn.edu ad=
dresses have been found to be submitted in "bad=0Afaith" to try to test the=
 kernel community's ability to review "known=0Amalicious" changes.  The res=
ult of these submissions can be found in a=0Apaper published at the 42nd IE=
EE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: S=
tealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Q=
iushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesot=
a).=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A sound/soc/rockchip/rockchip_pdm.c | 4 +---=0A 1 file changed, 1 inser=
tion(+), 3 deletions(-)=0A=0Adiff --git a/sound/soc/rockchip/rockchip_pdm.c=
 b/sound/soc/rockchip/rockchip_pdm.c=0Aindex ad16c8310dd3..8a2e3bbce3a1 100=
644=0A--- a/sound/soc/rockchip/rockchip_pdm.c=0A+++ b/sound/soc/rockchip/ro=
ckchip_pdm.c=0A@@ -478,10 +478,8 @@ static int rockchip_pdm_resume(struct d=
evice *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (=
ret < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	=
}=0A =0A 	ret =3D regcache_sync(pdm->regmap);=0A =0A-- =0A2.30.2=0A=0A=0AFr=
om a7017663775670bbf35f5a3243366d2b3896a1a1 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
31:05 +0100=0ASubject: [PATCH 20/94] Revert "media: exynos4-is: Fix a refer=
ence count leak=0A due to pm_runtime_get_sync"=0A=0AThis reverts commit 937=
05ea75c8551de6bdcf9fe7975292683e6c1ab.=0A=0ACommits from @umn.edu addresses=
 have been found to be submitted in "bad=0Afaith" to try to test the kernel=
 community's ability to review "known=0Amalicious" changes.  The result of =
these submissions can be found in a=0Apaper published at the 42nd IEEE Symp=
osium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthi=
ly Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi W=
u (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/media/platform/exynos4-is/media-dev.c | 4 +---=0A 1 file changed, 1=
 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platform/exyn=
os4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c=0Aindex =
3261dc72cc61..f5fca01f3248 100644=0A--- a/drivers/media/platform/exynos4-is=
/media-dev.c=0A+++ b/drivers/media/platform/exynos4-is/media-dev.c=0A@@ -48=
1,10 +481,8 @@ static int fimc_md_register_sensor_entities(struct fimc_md *=
fmd)=0A 		return -ENXIO;=0A =0A 	ret =3D pm_runtime_get_sync(fmd->pmf);=0A-=
	if (ret < 0) {=0A-		pm_runtime_put(fmd->pmf);=0A+	if (ret < 0)=0A 		return=
 ret;=0A-	}=0A =0A 	fmd->num_sensors =3D 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom=
 de26a2cdc1296e75582b36fee1f74f8b52d85449 Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31=
:05 +0100=0ASubject: [PATCH 21/94] Revert "media: exynos4-is: Fix a referen=
ce count leak"=0A=0AThis reverts commit 8e506a74112279c8fdea1fa6ed1955b82fc=
00497.=0A=0ACommits from @umn.edu addresses have been found to be submitted=
 in "bad=0Afaith" to try to test the kernel community's ability to review "=
known=0Amalicious" changes.  The result of these submissions can be found i=
n a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0A=
entitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities=
 via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) an=
d Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submissio=
ns from this group must be reverted from=0Athe kernel tree and will need to=
 be re-reviewed again to determine if=0Athey actually are a valid fix.  Unt=
il that work is complete, remove this=0Achange to ensure that no problems a=
re being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/exynos4-is/m=
ipi-csis.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/=
platform/exynos4-is/mipi-csis.c=0Aindex efab3ebc6756..b4e28a299e26 100644=
=0A--- a/drivers/media/platform/exynos4-is/mipi-csis.c=0A+++ b/drivers/medi=
a/platform/exynos4-is/mipi-csis.c=0A@@ -513,10 +513,8 @@ static int s5pcsis=
_s_stream(struct v4l2_subdev *sd, int enable)=0A 	if (enable) {=0A 		s5pcsi=
s_clear_counters(state);=0A 		ret =3D pm_runtime_get_sync(&state->pdev->dev=
);=0A-		if (ret && ret !=3D 1) {=0A-			pm_runtime_put_noidle(&state->pdev->=
dev);=0A+		if (ret && ret !=3D 1)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	mu=
tex_lock(&state->lock);=0A-- =0A2.30.2=0A=0A=0AFrom e738ac1f245adde3adde334=
2b5ef79461ca1fb19 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:05 +0100=0ASubject: [PA=
TCH 22/94] Revert "media: ti-vpe: Fix a missing check and=0A reference coun=
t leak"=0A=0AThis reverts commit 0284adc407d0c5b88f5feea1a3d1849e670acac6.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/ti-vpe/vpe.c =
| 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/media/pl=
atform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c=0Aindex 70a8371b7=
e9a..a285b9db7ee8 100644=0A--- a/drivers/media/platform/ti-vpe/vpe.c=0A+++ =
b/drivers/media/platform/ti-vpe/vpe.c=0A@@ -2451,8 +2451,6 @@ static int vp=
e_runtime_get(struct platform_device *pdev)=0A =0A 	r =3D pm_runtime_get_sy=
nc(&pdev->dev);=0A 	WARN_ON(r < 0);=0A-	if (r)=0A-		pm_runtime_put_noidle(&=
pdev->dev);=0A 	return r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom =
22402202c99cc62af5925acb161830eb5eb90815 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:=
05 +0100=0ASubject: [PATCH 23/94] Revert "media: stm32-dcmi: Fix a referenc=
e count leak"=0A=0AThis reverts commit 52efde52dfc47e263c8d7fce5129878efc87=
37bf.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
in "bad=0Afaith" to try to test the kernel community's ability to review "k=
nown=0Amalicious" changes.  The result of these submissions can be found in=
 a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Ae=
ntitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities =
via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and=
 Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submission=
s from this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/stm32/stm32-d=
cmi.c | 4 +++-=0A 1 file changed, 3 insertions(+), 1 deletion(-)=0A=0Adiff =
--git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/=
stm32/stm32-dcmi.c=0Aindex ee1a21179767..18d0b5641789 100644=0A--- a/driver=
s/media/platform/stm32/stm32-dcmi.c=0A+++ b/drivers/media/platform/stm32/st=
m32-dcmi.c=0A@@ -587,7 +587,7 @@ static int dcmi_start_streaming(struct vb2=
_queue *vq, unsigned int count)=0A 	if (ret < 0) {=0A 		dev_err(dcmi->dev, =
"%s: Failed to start streaming, cannot get sync (%d)\n",=0A 			__func__, re=
t);=0A-		goto err_pm_put;=0A+		goto err_release_buffers;=0A 	}=0A =0A 	/* E=
nable stream on the sub device */=0A@@ -682,6 +682,8 @@ static int dcmi_sta=
rt_streaming(struct vb2_queue *vq, unsigned int count)=0A =0A err_pm_put:=
=0A 	pm_runtime_put(dcmi->dev);=0A+=0A+err_release_buffers:=0A 	spin_lock_i=
rq(&dcmi->irqlock);=0A 	/*=0A 	 * Return all buffers to vb2 in QUEUED state=
=2E=0A-- =0A2.30.2=0A=0A=0AFrom 2ffafc59349eb2a90393ff621c0808b2a7584817 Mo=
n Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:06 +0100=0ASubject: [PATCH 24/94] Revert "m=
edia: s5p-mfc: Fix a reference count leak"=0A=0AThis reverts commit 815501d=
08cde0dd4e62fb15e007e847b1a57140b.=0A=0ACommits from @umn.edu addresses hav=
e been found to be submitted in "bad=0Afaith" to try to test the kernel com=
munity's ability to review "known=0Amalicious" changes.  The result of thes=
e submissions can be found in a=0Apaper published at the 42nd IEEE Symposiu=
m on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily I=
ntroducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (U=
niversity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABe=
cause of this, all submissions from this group must be reverted from=0Athe =
kernel tree and will need to be re-reviewed again to determine if=0Athey ac=
tually are a valid fix.  Until that work is complete, remove this=0Achange =
to ensure that no problems are being introduced into the=0Acodebase.=0A=0AS=
igned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers=
/media/platform/s5p-mfc/s5p_mfc_pm.c | 4 +---=0A 1 file changed, 1 insertio=
n(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platform/s5p-mfc/s5p_m=
fc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=0Aindex 95abf2bd7eba.=
=2E5e080f32b0e8 100644=0A--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=
=0A+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=0A@@ -83,10 +83,8 @@ i=
nt s5p_mfc_power_on(void)=0A 	int i, ret =3D 0;=0A =0A 	ret =3D pm_runtime_=
get_sync(pm->device);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(pm->dev=
ice);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	/* clock control */=
=0A 	for (i =3D 0; i < pm->num_clocks; i++) {=0A-- =0A2.30.2=0A=0A=0AFrom 9=
19a0ecafe2bb2cb74b0accc495cb5ae048d5bc8 Mon Sep 17 00:00:00 2001=0AFrom: Su=
dip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:0=
6 +0100=0ASubject: [PATCH 25/94] Revert "media: platform: fcp: Fix a refere=
nce count=0A leak."=0A=0AThis reverts commit 442bb53ffe8dff9f97289477510b61=
1a0117246c.=0A=0ACommits from @umn.edu addresses have been found to be subm=
itted in "bad=0Afaith" to try to test the kernel community's ability to rev=
iew "known=0Amalicious" changes.  The result of these submissions can be fo=
und in a=0Apaper published at the 42nd IEEE Symposium on Security and Priva=
cy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabil=
ities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesot=
a) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all subm=
issions from this group must be reverted from=0Athe kernel tree and will ne=
ed to be re-reviewed again to determine if=0Athey actually are a valid fix.=
  Until that work is complete, remove this=0Achange to ensure that no probl=
ems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/rcar-fc=
p.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --=
git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c=
=0Aindex 05c712e00a2a..5c6b00737fe7 100644=0A--- a/drivers/media/platform/r=
car-fcp.c=0A+++ b/drivers/media/platform/rcar-fcp.c=0A@@ -103,10 +103,8 @@ =
int rcar_fcp_enable(struct rcar_fcp_device *fcp)=0A 		return 0;=0A =0A 	ret=
 =3D pm_runtime_get_sync(fcp->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_=
noidle(fcp->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	return 0;=
=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 39614ea91e53b3f0861fecd1109781e0080728f8 =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 20:31:06 +0100=0ASubject: [PATCH 26/94] Revert =
"media: st-delta: Fix reference count leak in=0A delta_run_work"=0A=0AThis =
reverts commit 07e82f531e6ad1bac1f28591fa40fc558e1ac7ff.=0A=0ACommits from =
@umn.edu addresses have been found to be submitted in "bad=0Afaith" to try =
to test the kernel community's ability to review "known=0Amalicious" change=
s.  The result of these submissions can be found in a=0Apaper published at =
the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source In=
security: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" w=
ritten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University =
of Minnesota).=0A=0ABecause of this, all submissions from this group must b=
e reverted from=0Athe kernel tree and will need to be re-reviewed again to =
determine if=0Athey actually are a valid fix.  Until that work is complete,=
 remove this=0Achange to ensure that no problems are being introduced into =
the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0A---=0A drivers/media/platform/sti/delta/delta-v4l2.c | 4 +---=0A =
1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/me=
dia/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delt=
a-v4l2.c=0Aindex 53dc6da2b09e..0b42acd4e3a6 100644=0A--- a/drivers/media/pl=
atform/sti/delta/delta-v4l2.c=0A+++ b/drivers/media/platform/sti/delta/delt=
a-v4l2.c=0A@@ -954,10 +954,8 @@ static void delta_run_work(struct work_stru=
ct *work)=0A 	/* enable the hardware */=0A 	if (!dec->pm) {=0A 		ret =3D de=
lta_get_sync(ctx);=0A-		if (ret) {=0A-			delta_put_autosuspend(ctx);=0A+		i=
f (ret)=0A 			goto err;=0A-		}=0A 	}=0A =0A 	/* decode this access unit */=
=0A-- =0A2.30.2=0A=0A=0AFrom d22af2b899191438919f13dd53cf69400148811c Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:31:06 +0100=0ASubject: [PATCH 27/94] Revert "ASoC=
: tegra: Fix reference count leaks."=0A=0AThis reverts commit 3ff0d9154ef86=
b2f90ecf75149a30cd3d9253241.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/soc/teg=
ra/tegra30_ahub.c | 4 +---=0A sound/soc/tegra/tegra30_i2s.c  | 4 +---=0A 2 =
files changed, 2 insertions(+), 6 deletions(-)=0A=0Adiff --git a/sound/soc/=
tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c=0Aindex 88e838ac937d.=
=2E43679aeeb12b 100644=0A--- a/sound/soc/tegra/tegra30_ahub.c=0A+++ b/sound=
/soc/tegra/tegra30_ahub.c=0A@@ -655,10 +655,8 @@ static int tegra30_ahub_re=
sume(struct device *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(d=
ev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		ret=
urn ret;=0A-	}=0A 	ret =3D regcache_sync(ahub->regmap_ahub);=0A 	ret |=3D r=
egcache_sync(ahub->regmap_apbif);=0A 	pm_runtime_put(dev);=0Adiff --git a/s=
ound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c=0Aindex bf155c=
5092f0..0b176ea24914 100644=0A--- a/sound/soc/tegra/tegra30_i2s.c=0A+++ b/s=
ound/soc/tegra/tegra30_i2s.c=0A@@ -551,10 +551,8 @@ static int tegra30_i2s_=
resume(struct device *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync=
(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		r=
eturn ret;=0A-	}=0A 	ret =3D regcache_sync(i2s->regmap);=0A 	pm_runtime_put=
(dev);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 44ae1d8932de7c63e021f5959b8603ef2acb=
3021 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 20:31:07 +0100=0ASubject: [PATCH 28/94] Re=
vert "iommu: Fix reference count leak in=0A iommu_group_alloc."=0A=0AThis r=
everts commit 0dc3cd0981c78d0b1669104aa9d28e3c3ce5460c.=0A=0ACommits from @=
umn.edu addresses have been found to be submitted in "bad=0Afaith" to try t=
o test the kernel community's ability to review "known=0Amalicious" changes=
=2E  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/iommu/iommu.c | 2 +-=0A 1 file changed, 1 insertion=
(+), 1 deletion(-)=0A=0Adiff --git a/drivers/iommu/iommu.c b/drivers/iommu/=
iommu.c=0Aindex 85ef6c9bc898..00e1c908cd8e 100644=0A--- a/drivers/iommu/iom=
mu.c=0A+++ b/drivers/iommu/iommu.c=0A@@ -392,7 +392,7 @@ struct iommu_group=
 *iommu_group_alloc(void)=0A 				   NULL, "%d", group->id);=0A 	if (ret) {=
=0A 		ida_simple_remove(&iommu_group_ida, group->id);=0A-		kobject_put(&gro=
up->kobj);=0A+		kfree(group);=0A 		return ERR_PTR(ret);=0A 	}=0A =0A-- =0A2=
=2E30.2=0A=0A=0AFrom cd70afef99d39fe62589229b2599c5c010b16f31 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:31:07 +0100=0ASubject: [PATCH 29/94] Revert "ACPI: CPPC: =
Fix reference count leak in=0A acpi_cppc_processor_probe()"=0A=0AThis rever=
ts commit c1348a561d567bb1edcded41f720d6c8a178f96d.=0A=0ACommits from @umn.=
edu addresses have been found to be submitted in "bad=0Afaith" to try to te=
st the kernel community's ability to review "known=0Amalicious" changes.  T=
he result of these submissions can be found in a=0Apaper published at the 4=
2nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecur=
ity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" writte=
n by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Mi=
nnesota).=0A=0ABecause of this, all submissions from this group must be rev=
erted from=0Athe kernel tree and will need to be re-reviewed again to deter=
mine if=0Athey actually are a valid fix.  Until that work is complete, remo=
ve this=0Achange to ensure that no problems are being introduced into the=
=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0A---=0A drivers/acpi/cppc_acpi.c | 1 -=0A 1 file changed, 1 deletion(-)=
=0A=0Adiff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c=0Ain=
dex 5c6ecbb66608..41228e545e82 100644=0A--- a/drivers/acpi/cppc_acpi.c=0A++=
+ b/drivers/acpi/cppc_acpi.c=0A@@ -869,7 +869,6 @@ int acpi_cppc_processor_=
probe(struct acpi_processor *pr)=0A 			"acpi_cppc");=0A 	if (ret) {=0A 		pe=
r_cpu(cpc_desc_ptr, pr->id) =3D NULL;=0A-		kobject_put(&cpc_ptr->kobj);=0A =
		goto out_free;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 92b7ab6035bcec5b4da1=
f283d88c8b3a3a9cdc66 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:07 +0100=0ASubject: =
[PATCH 30/94] Revert "ACPI: sysfs: Fix reference count leak in=0A acpi_sysf=
s_add_hotplug_profile()"=0A=0AThis reverts commit efb4903f931a5955ee34fd1be=
89efa601b761961.=0A=0ACommits from @umn.edu addresses have been found to be=
 submitted in "bad=0Afaith" to try to test the kernel community's ability t=
o review "known=0Amalicious" changes.  The result of these submissions can =
be found in a=0Apaper published at the 42nd IEEE Symposium on Security and =
Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulne=
rabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Min=
nesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all=
 submissions from this group must be reverted from=0Athe kernel tree and wi=
ll need to be re-reviewed again to determine if=0Athey actually are a valid=
 fix.  Until that work is complete, remove this=0Achange to ensure that no =
problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/acpi/sysfs.c | 4 =
+---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/dr=
ivers/acpi/sysfs.c b/drivers/acpi/sysfs.c=0Aindex 39ee0ca636aa..b4f229da808=
5 100644=0A--- a/drivers/acpi/sysfs.c=0A+++ b/drivers/acpi/sysfs.c=0A@@ -99=
0,10 +990,8 @@ void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_prof=
ile *hotplug,=0A =0A 	error =3D kobject_init_and_add(&hotplug->kobj,=0A 		&=
acpi_hotplug_profile_ktype, hotplug_kobj, "%s", name);=0A-	if (error) {=0A-=
		kobject_put(&hotplug->kobj);=0A+	if (error)=0A 		goto err_out;=0A-	}=0A =
=0A 	kobject_uevent(&hotplug->kobj, KOBJ_ADD);=0A 	return;=0A-- =0A2.30.2=
=0A=0A=0AFrom adeb215e0bc17cf62ddb42ece0150e97f7c9cbf7 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:31:07 +0100=0ASubject: [PATCH 31/94] Revert "ASoC: fix incomplet=
e error-handling in=0A img_i2s_in_probe."=0A=0AThis reverts commit 04ed3038=
8c9f9aec4608c5bc5938d023597a5772.=0A=0ACommits from @umn.edu addresses have=
 been found to be submitted in "bad=0Afaith" to try to test the kernel comm=
unity's ability to review "known=0Amalicious" changes.  The result of these=
 submissions can be found in a=0Apaper published at the 42nd IEEE Symposium=
 on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily In=
troducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Un=
iversity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABec=
ause of this, all submissions from this group must be reverted from=0Athe k=
ernel tree and will need to be re-reviewed again to determine if=0Athey act=
ually are a valid fix.  Until that work is complete, remove this=0Achange t=
o ensure that no problems are being introduced into the=0Acodebase.=0A=0ASi=
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/so=
c/img/img-i2s-in.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a=
/sound/soc/img/img-i2s-in.c b/sound/soc/img/img-i2s-in.c=0Aindex 7e48c740bf=
55..b35f24e617bf 100644=0A--- a/sound/soc/img/img-i2s-in.c=0A+++ b/sound/so=
c/img/img-i2s-in.c=0A@@ -487,7 +487,6 @@ static int img_i2s_in_probe(struct=
 platform_device *pdev)=0A 	if (IS_ERR(rst)) {=0A 		if (PTR_ERR(rst) =3D=3D=
 -EPROBE_DEFER) {=0A 			ret =3D -EPROBE_DEFER;=0A-			pm_runtime_put(&pdev->=
dev);=0A 			goto err_suspend;=0A 		}=0A =0A-- =0A2.30.2=0A=0A=0AFrom be7abd=
78991844c8bd0b3746d46cd83fe3fab269 Mon Sep 17 00:00:00 2001=0AFrom: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:08 +01=
00=0ASubject: [PATCH 32/94] Revert "qlcnic: fix missing release in=0A qlcni=
c_83xx_interrupt_test."=0A=0AThis reverts commit 79ed4c838a850ac4154331656d=
0972331c37d761.=0A=0ACommits from @umn.edu addresses have been found to be =
submitted in "bad=0Afaith" to try to test the kernel community's ability to=
 review "known=0Amalicious" changes.  The result of these submissions can b=
e found in a=0Apaper published at the 42nd IEEE Symposium on Security and P=
rivacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulner=
abilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minn=
esota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all =
submissions from this group must be reverted from=0Athe kernel tree and wil=
l need to be re-reviewed again to determine if=0Athey actually are a valid =
fix.  Until that work is complete, remove this=0Achange to ensure that no p=
roblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogi=
c/qlcnic/qlcnic_83xx_hw.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 del=
etions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_=
hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0Aindex 6ed8294f=
7df8..a79d84f99102 100644=0A--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic=
_83xx_hw.c=0A+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A@@=
 -3651,7 +3651,7 @@ int qlcnic_83xx_interrupt_test(struct net_device *netde=
v)=0A 	ahw->diag_cnt =3D 0;=0A 	ret =3D qlcnic_alloc_mbx_args(&cmd, adapter=
, QLCNIC_CMD_INTRPT_TEST);=0A 	if (ret)=0A-		goto fail_mbx_args;=0A+		goto =
fail_diag_irq;=0A =0A 	if (adapter->flags & QLCNIC_MSIX_ENABLED)=0A 		intrp=
t_id =3D ahw->intr_tbl[0].id;=0A@@ -3681,8 +3681,6 @@ int qlcnic_83xx_inter=
rupt_test(struct net_device *netdev)=0A =0A done:=0A 	qlcnic_free_mbx_args(=
&cmd);=0A-=0A-fail_mbx_args:=0A 	qlcnic_83xx_diag_free_res(netdev, drv_sds_=
rings);=0A =0A fail_diag_irq:=0A-- =0A2.30.2=0A=0A=0AFrom adf94cc833d77b526=
7a7201db13df9b3ca844e73 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:08 +0100=0ASubjec=
t: [PATCH 33/94] Revert "usb: gadget: fix potential double-free in=0A m6659=
2_probe."=0A=0AThis reverts commit 1a17c51d910b6b89825f1d22083e48ebc2da26e4=
=2E=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
 "bad=0Afaith" to try to test the kernel community's ability to review "kno=
wn=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/usb/gadget/udc/m66592-udc.c =
| 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/d=
rivers/usb/gadget/udc/m66592-udc.c b/drivers/usb/gadget/udc/m66592-udc.c=0A=
index ea59b56e5402..a8288df6aadf 100644=0A--- a/drivers/usb/gadget/udc/m665=
92-udc.c=0A+++ b/drivers/usb/gadget/udc/m66592-udc.c=0A@@ -1667,7 +1667,7 @=
@ static int m66592_probe(struct platform_device *pdev)=0A =0A err_add_udc:=
=0A 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);=0A-	m66592->e=
p0_req =3D NULL;=0A+=0A clean_up3:=0A 	if (m66592->pdata->on_chip) {=0A 		c=
lk_disable(m66592->clk);=0A-- =0A2.30.2=0A=0A=0AFrom cd2eadad193a947aa8c936=
84ee12435e308864a2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:08 +0100=0ASubject: =
[PATCH 34/94] Revert "net/mlx4_core: fix a memory leak bug."=0A=0AThis reve=
rts commit ec3150fc2922ddc93aeb3301a1535fd2eebbfd72.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/net/ethernet/mellanox/mlx4/fw.c | 2 +-=0A 1 file chang=
ed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/net/ethernet/me=
llanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c=0Aindex 926407f0=
bbd9..3317af84602c 100644=0A--- a/drivers/net/ethernet/mellanox/mlx4/fw.c=
=0A+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c=0A@@ -2731,7 +2731,7 @@ vo=
id mlx4_opreq_action(struct work_struct *work)=0A 		if (err) {=0A 			mlx4_e=
rr(dev, "Failed to retrieve required operation: %d\n",=0A 				 err);=0A-			=
goto out;=0A+			return;=0A 		}=0A 		MLX4_GET(modifier, outbox, GET_OP_REQ_M=
ODIFIER_OFFSET);=0A 		MLX4_GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);=0A-=
- =0A2.30.2=0A=0A=0AFrom c3cdef318bd694cdfcce710d2491fd97347d34d6 Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 20:31:09 +0100=0ASubject: [PATCH 35/94] Revert "agp/inte=
l: Fix a memory leak on module=0A initialisation failure"=0A=0AThis reverts=
 commit ea01e491c3da0952f6b8bc84f62236a5e431e808.=0A=0ACommits from @umn.ed=
u addresses have been found to be submitted in "bad=0Afaith" to try to test=
 the kernel community's ability to review "known=0Amalicious" changes.  The=
 result of these submissions can be found in a=0Apaper published at the 42n=
d IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurit=
y: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written =
by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minn=
esota).=0A=0ABecause of this, all submissions from this group must be rever=
ted from=0Athe kernel tree and will need to be re-reviewed again to determi=
ne if=0Athey actually are a valid fix.  Until that work is complete, remove=
 this=0Achange to ensure that no problems are being introduced into the=0Ac=
odebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/char/agp/intel-gtt.c | 4 +---=0A 1 file changed, 1 insert=
ion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/char/agp/intel-gtt.c b/dri=
vers/char/agp/intel-gtt.c=0Aindex 0941d38b2d32..b161bdf60000 100644=0A--- a=
/drivers/char/agp/intel-gtt.c=0A+++ b/drivers/char/agp/intel-gtt.c=0A@@ -30=
4,10 +304,8 @@ static int intel_gtt_setup_scratch_page(void)=0A 	if (intel_=
private.needs_dmar) {=0A 		dma_addr =3D pci_map_page(intel_private.pcidev, =
page, 0,=0A 				    PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);=0A-		if (pci_dma_map=
ping_error(intel_private.pcidev, dma_addr)) {=0A-			__free_page(page);=0A+	=
	if (pci_dma_mapping_error(intel_private.pcidev, dma_addr))=0A 			return -E=
INVAL;=0A-		}=0A =0A 		intel_private.scratch_page_dma =3D dma_addr;=0A 	} e=
lse=0A-- =0A2.30.2=0A=0A=0AFrom ebb7214ba3db69d559a84267f9aefa9439a5f270 Mo=
n Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:09 +0100=0ASubject: [PATCH 36/94] Revert "e=
cryptfs: replace BUG_ON with error handling=0A code"=0A=0AThis reverts comm=
it c0965be4b28b8078202bd174d2cf2beb1b91fe46.=0A=0ACommits from @umn.edu add=
resses have been found to be submitted in "bad=0Afaith" to try to test the =
kernel community's ability to review "known=0Amalicious" changes.  The resu=
lt of these submissions can be found in a=0Apaper published at the 42nd IEE=
E Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: St=
ealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qi=
ushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota=
).=0A=0ABecause of this, all submissions from this group must be reverted f=
rom=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A fs/ecryptfs/crypto.c | 6 ++----=0A 1 file changed, 2 insertions(+), 4 d=
eletions(-)=0A=0Adiff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c=
=0Aindex 8e5353bd72cf..708f931c36f1 100644=0A--- a/fs/ecryptfs/crypto.c=0A+=
++ b/fs/ecryptfs/crypto.c=0A@@ -325,10 +325,8 @@ static int crypt_scatterli=
st(struct ecryptfs_crypt_stat *crypt_stat,=0A 	struct extent_crypt_result e=
cr;=0A 	int rc =3D 0;=0A =0A-	if (!crypt_stat || !crypt_stat->tfm=0A-	     =
  || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))=0A-		return -EINVA=
L;=0A-=0A+	BUG_ON(!crypt_stat || !crypt_stat->tfm=0A+	       || !(crypt_sta=
t->flags & ECRYPTFS_STRUCT_INITIALIZED));=0A 	if (unlikely(ecryptfs_verbosi=
ty > 0)) {=0A 		ecryptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",=0A 		=
		crypt_stat->key_size);=0A-- =0A2.30.2=0A=0A=0AFrom 6614c5bb7484917d38313e=
fb9abda1a48e3d534b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:09 +0100=0ASubject: =
[PATCH 37/94] Revert "net: sun: fix missing release regions in=0A cas_init_=
one()."=0A=0AThis reverts commit 1620da8387caf5b87f1d71b4242dc05a75ca0854.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/sun/cassini.c |=
 3 ++-=0A 1 file changed, 2 insertions(+), 1 deletion(-)=0A=0Adiff --git a/=
drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c=0Ai=
ndex d323dd9daccb..7ec4eb74fe21 100644=0A--- a/drivers/net/ethernet/sun/cas=
sini.c=0A+++ b/drivers/net/ethernet/sun/cassini.c=0A@@ -4971,7 +4971,7 @@ s=
tatic int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *en=
t)=0A 					  cas_cacheline_size)) {=0A 			dev_err(&pdev->dev, "Could not se=
t PCI cache "=0A 			       "line size\n");=0A-			goto err_out_free_res;=0A+=
			goto err_write_cacheline;=0A 		}=0A 	}=0A #endif=0A@@ -5144,6 +5144,7 @@=
 static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *=
ent)=0A err_out_free_res:=0A 	pci_release_regions(pdev);=0A =0A+err_write_c=
acheline:=0A 	/* Try to restore it in case the error occurred after we=0A 	=
 * set it.=0A 	 */=0A-- =0A2.30.2=0A=0A=0AFrom 04c72cfa9b39942a4eec8d046825=
7169d6e2624a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:09 +0100=0ASubject: [PATCH 3=
8/94] Revert "ASoC: img-parallel-out: Fix a reference count=0A leak"=0A=0AT=
his reverts commit 951fba03cf3ed5981d53c91e93ab3dd5f3d0ebbd.=0A=0ACommits f=
rom @umn.edu addresses have been found to be submitted in "bad=0Afaith" to =
try to test the kernel community's ability to review "known=0Amalicious" ch=
anges.  The result of these submissions can be found in a=0Apaper published=
 at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Sourc=
e Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commit=
s" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Univers=
ity of Minnesota).=0A=0ABecause of this, all submissions from this group mu=
st be reverted from=0Athe kernel tree and will need to be re-reviewed again=
 to determine if=0Athey actually are a valid fix.  Until that work is compl=
ete, remove this=0Achange to ensure that no problems are being introduced i=
nto the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0A---=0A sound/soc/img/img-parallel-out.c | 4 +---=0A 1 file chan=
ged, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/sound/soc/img/img-par=
allel-out.c b/sound/soc/img/img-parallel-out.c=0Aindex f56752662b19..acc005=
217be0 100644=0A--- a/sound/soc/img/img-parallel-out.c=0A+++ b/sound/soc/im=
g/img-parallel-out.c=0A@@ -166,10 +166,8 @@ static int img_prl_out_set_fmt(=
struct snd_soc_dai *dai, unsigned int fmt)=0A 	}=0A =0A 	ret =3D pm_runtime=
_get_sync(prl->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(prl->dev=
);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	reg =3D img_prl_out_read=
l(prl, IMG_PRL_OUT_CTL);=0A 	reg =3D (reg & ~IMG_PRL_OUT_CTL_EDGE_MASK) | c=
ontrol_set;=0A-- =0A2.30.2=0A=0A=0AFrom d3fcc948fcb79dc96e5a2a474d4133bf88f=
b20b5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:31:10 +0100=0ASubject: [PATCH 39/94] R=
evert "efi/esrt: Fix reference count leak in=0A esre_create_sysfs_entry."=
=0A=0AThis reverts commit a717bbd11e3962e8144ef3e34a0533231dd2c409.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/firmware/efi/esrt.c | 2 +-=0A 1 file chan=
ged, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/firmware/efi/e=
srt.c b/drivers/firmware/efi/esrt.c=0Aindex 2f6204b2fdd3..5d06bd247d07 1006=
44=0A--- a/drivers/firmware/efi/esrt.c=0A+++ b/drivers/firmware/efi/esrt.c=
=0A@@ -180,7 +180,7 @@ static int esre_create_sysfs_entry(void *esre, int e=
ntry_num)=0A 		rc =3D kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL=
,=0A 					  "entry%d", entry_num);=0A 		if (rc) {=0A-			kobject_put(&entry-=
>kobj);=0A+			kfree(entry);=0A 			return rc;=0A 		}=0A 	}=0A-- =0A2.30.2=0A=
=0A=0AFrom 43b96d943ac84ac83cc1fd796efc46f527af90e9 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:31:10 +0100=0ASubject: [PATCH 40/94] Revert "ASoC: img: Fix a refer=
ence count leak in=0A img_i2s_in_set_fmt"=0A=0AThis reverts commit 6978222e=
a037ca8dcefaa0b37fea2cc41320a7f4.=0A=0ACommits from @umn.edu addresses have=
 been found to be submitted in "bad=0Afaith" to try to test the kernel comm=
unity's ability to review "known=0Amalicious" changes.  The result of these=
 submissions can be found in a=0Apaper published at the 42nd IEEE Symposium=
 on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily In=
troducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Un=
iversity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABec=
ause of this, all submissions from this group must be reverted from=0Athe k=
ernel tree and will need to be re-reviewed again to determine if=0Athey act=
ually are a valid fix.  Until that work is complete, remove this=0Achange t=
o ensure that no problems are being introduced into the=0Acodebase.=0A=0ASi=
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/so=
c/img/img-i2s-in.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(=
-)=0A=0Adiff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/img/img-i2s-in.=
c=0Aindex b35f24e617bf..388cefd7340a 100644=0A--- a/sound/soc/img/img-i2s-i=
n.c=0A+++ b/sound/soc/img/img-i2s-in.c=0A@@ -346,10 +346,8 @@ static int im=
g_i2s_in_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)=0A 	chan_contro=
l_mask =3D IMG_I2S_IN_CH_CTL_CLK_TRANS_MASK;=0A =0A 	ret =3D pm_runtime_get=
_sync(i2s->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(i2s->dev);=
=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	for (i =3D 0; i < i2s->act=
ive_channels; i++)=0A 		img_i2s_in_ch_disable(i2s, i);=0A-- =0A2.30.2=0A=0A=
=0AFrom bfee7c9fc6530fb9729a2d3992eb85e0585d4ed7 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:31:10 +0100=0ASubject: [PATCH 41/94] Revert "scsi: iscsi: Fix refere=
nce count leak in=0A iscsi_boot_create_kobj"=0A=0AThis reverts commit e4614=
1f73e5f0dcebb09445a09a877ea4408d653.=0A=0ACommits from @umn.edu addresses h=
ave been found to be submitted in "bad=0Afaith" to try to test the kernel c=
ommunity's ability to review "known=0Amalicious" changes.  The result of th=
ese submissions can be found in a=0Apaper published at the 42nd IEEE Sympos=
ium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily=
 Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu =
(University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0A=
Because of this, all submissions from this group must be reverted from=0Ath=
e kernel tree and will need to be re-reviewed again to determine if=0Athey =
actually are a valid fix.  Until that work is complete, remove this=0Achang=
e to ensure that no problems are being introduced into the=0Acodebase.=0A=
=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A dri=
vers/scsi/iscsi_boot_sysfs.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 de=
letion(-)=0A=0Adiff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/=
iscsi_boot_sysfs.c=0Aindex 15d64f96e623..d453667612f8 100644=0A--- a/driver=
s/scsi/iscsi_boot_sysfs.c=0A+++ b/drivers/scsi/iscsi_boot_sysfs.c=0A@@ -360=
,7 +360,7 @@ iscsi_boot_create_kobj(struct iscsi_boot_kset *boot_kset,=0A 	=
boot_kobj->kobj.kset =3D boot_kset->kset;=0A 	if (kobject_init_and_add(&boo=
t_kobj->kobj, &iscsi_boot_ktype,=0A 				 NULL, name, index)) {=0A-		kobject=
_put(&boot_kobj->kobj);=0A+		kfree(boot_kobj);=0A 		return NULL;=0A 	}=0A 	=
boot_kobj->data =3D data;=0A-- =0A2.30.2=0A=0A=0AFrom 10156c635d25a985beb3d=
4827316635593bc0f7a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:10 +0100=0ASubject: [=
PATCH 42/94] Revert "vfio/mdev: Fix reference count leak in=0A add_mdev_sup=
ported_type"=0A=0AThis reverts commit 1a98e4ef324d4735b0a8240717b4e2d1bb9ad=
fd8.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
n "bad=0Afaith" to try to test the kernel community's ability to review "kn=
own=0Amalicious" changes.  The result of these submissions can be found in =
a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aen=
titled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities v=
ia Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and =
Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions=
 from this group must be reverted from=0Athe kernel tree and will need to b=
e re-reviewed again to determine if=0Athey actually are a valid fix.  Until=
 that work is complete, remove this=0Achange to ensure that no problems are=
 being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/vfio/mdev/mdev_sysfs.c | 2 +-=
=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers=
/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c=0Aindex 1692a0cc30=
36..e7770b511d03 100644=0A--- a/drivers/vfio/mdev/mdev_sysfs.c=0A+++ b/driv=
ers/vfio/mdev/mdev_sysfs.c=0A@@ -113,7 +113,7 @@ struct mdev_type *add_mdev=
_supported_type(struct mdev_parent *parent,=0A 				   "%s-%s", dev_driver_s=
tring(parent->dev),=0A 				   group->name);=0A 	if (ret) {=0A-		kobject_put=
(&type->kobj);=0A+		kfree(type);=0A 		return ERR_PTR(ret);=0A 	}=0A =0A-- =
=0A2.30.2=0A=0A=0AFrom 003d9e703b04ee783cea52dc3229f26252fc1d9e Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:31:11 +0100=0ASubject: [PATCH 43/94] Revert "cpuidle: F=
ix three reference count leaks"=0A=0AThis reverts commit fad0431b7e61b750ef=
798c1a739382dfae85e231.=0A=0ACommits from @umn.edu addresses have been foun=
d to be submitted in "bad=0Afaith" to try to test the kernel community's ab=
ility to review "known=0Amalicious" changes.  The result of these submissio=
ns can be found in a=0Apaper published at the 42nd IEEE Symposium on Securi=
ty and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/cpuidle/=
sysfs.c | 6 +++---=0A 1 file changed, 3 insertions(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c=0Aindex 6697=
9dc33680..e754c7aae7f7 100644=0A--- a/drivers/cpuidle/sysfs.c=0A+++ b/drive=
rs/cpuidle/sysfs.c=0A@@ -467,7 +467,7 @@ static int cpuidle_add_state_sysfs=
(struct cpuidle_device *device)=0A 		ret =3D kobject_init_and_add(&kobj->ko=
bj, &ktype_state_cpuidle,=0A 					   &kdev->kobj, "state%d", i);=0A 		if (r=
et) {=0A-			kobject_put(&kobj->kobj);=0A+			kfree(kobj);=0A 			goto error_s=
tate;=0A 		}=0A 		cpuidle_add_s2idle_attr_group(kobj);=0A@@ -598,7 +598,7 @=
@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)=0A 	ret =
=3D kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,=0A 				   &kde=
v->kobj, "driver");=0A 	if (ret) {=0A-		kobject_put(&kdrv->kobj);=0A+		kfre=
e(kdrv);=0A 		return ret;=0A 	}=0A =0A@@ -692,7 +692,7 @@ int cpuidle_add_s=
ysfs(struct cpuidle_device *dev)=0A 	error =3D kobject_init_and_add(&kdev->=
kobj, &ktype_cpuidle, &cpu_dev->kobj,=0A 				   "cpuidle");=0A 	if (error) =
{=0A-		kobject_put(&kdev->kobj);=0A+		kfree(kdev);=0A 		return error;=0A 	}=
=0A =0A-- =0A2.30.2=0A=0A=0AFrom a9ed1d92efd421d033eebed619d6145107bd632f M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:31:11 +0100=0ASubject: [PATCH 44/94] Revert "=
EDAC: Fix reference count leaks"=0A=0AThis reverts commit 0a9c84ce0c78d2700=
4ea46aca1e8a5752dffd924.=0A=0ACommits from @umn.edu addresses have been fou=
nd to be submitted in "bad=0Afaith" to try to test the kernel community's a=
bility to review "known=0Amalicious" changes.  The result of these submissi=
ons can be found in a=0Apaper published at the 42nd IEEE Symposium on Secur=
ity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/edac/eda=
c_device_sysfs.c | 1 -=0A drivers/edac/edac_pci_sysfs.c    | 2 +-=0A 2 file=
s changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/edac/ed=
ac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c=0Aindex 5e7593753799..=
0e7ea3591b78 100644=0A--- a/drivers/edac/edac_device_sysfs.c=0A+++ b/driver=
s/edac/edac_device_sysfs.c=0A@@ -275,7 +275,6 @@ int edac_device_register_s=
ysfs_main_kobj(struct edac_device_ctl_info *edac_dev)=0A =0A 	/* Error exit=
 stack */=0A err_kobj_reg:=0A-	kobject_put(&edac_dev->kobj);=0A 	module_put=
(edac_dev->owner);=0A =0A err_out:=0Adiff --git a/drivers/edac/edac_pci_sys=
fs.c b/drivers/edac/edac_pci_sysfs.c=0Aindex 53042af7262e..72c9eb9fdffb 100=
644=0A--- a/drivers/edac/edac_pci_sysfs.c=0A+++ b/drivers/edac/edac_pci_sys=
fs.c=0A@@ -386,7 +386,7 @@ static int edac_pci_main_kobj_setup(void)=0A =0A=
 	/* Error unwind statck */=0A kobject_init_and_add_fail:=0A-	kobject_put(e=
dac_pci_top_main_kobj);=0A+	kfree(edac_pci_top_main_kobj);=0A =0A kzalloc_f=
ail:=0A 	module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=0A=0AFrom 320c68f3b156c=
3b2cbd13e0f05ad1fafecd51099 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:11 +0100=0ASu=
bject: [PATCH 45/94] Revert "fore200e: Fix incorrect checks of NULL pointer=
=0A dereference"=0A=0AThis reverts commit 8a3bc6e31b2b40f5c8f20ba355c34203e=
a21abd0.=0A=0ACommits from @umn.edu addresses have been found to be submitt=
ed in "bad=0Afaith" to try to test the kernel community's ability to review=
 "known=0Amalicious" changes.  The result of these submissions can be found=
 in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/atm/fore200e.c | 25 ++++=
+++------------------=0A 1 file changed, 7 insertions(+), 18 deletions(-)=
=0A=0Adiff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c=0Aindex =
86aab14872fd..99a38115b0a8 100644=0A--- a/drivers/atm/fore200e.c=0A+++ b/dr=
ivers/atm/fore200e.c=0A@@ -1504,14 +1504,12 @@ fore200e_open(struct atm_vcc=
 *vcc)=0A static void=0A fore200e_close(struct atm_vcc* vcc)=0A {=0A+    st=
ruct fore200e*        fore200e =3D FORE200E_DEV(vcc->dev);=0A     struct fo=
re200e_vcc*    fore200e_vcc;=0A-    struct fore200e*        fore200e;=0A   =
  struct fore200e_vc_map* vc_map;=0A     unsigned long           flags;=0A =
=0A     ASSERT(vcc);=0A-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-=0A    =
 ASSERT((vcc->vpi >=3D 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));=0A     ASS=
ERT((vcc->vci >=3D 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));=0A =0A@@ -1556=
,10 +1554,10 @@ fore200e_close(struct atm_vcc* vcc)=0A static int=0A fore20=
0e_send(struct atm_vcc *vcc, struct sk_buff *skb)=0A {=0A-    struct fore20=
0e*        fore200e;=0A-    struct fore200e_vcc*    fore200e_vcc;=0A+    st=
ruct fore200e*        fore200e     =3D FORE200E_DEV(vcc->dev);=0A+    struc=
t fore200e_vcc*    fore200e_vcc =3D FORE200E_VCC(vcc);=0A     struct fore20=
0e_vc_map* vc_map;=0A-    struct host_txq*        txq;=0A+    struct host_t=
xq*        txq          =3D &fore200e->host_txq;=0A     struct host_txq_ent=
ry*  entry;=0A     struct tpd*             tpd;=0A     struct tpd_haddr    =
    tpd_haddr;=0A@@ -1572,18 +1570,9 @@ fore200e_send(struct atm_vcc *vcc, =
struct sk_buff *skb)=0A     unsigned char*          data;=0A     unsigned l=
ong           flags;=0A =0A-    if (!vcc)=0A-        return -EINVAL;=0A-=0A=
-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-    fore200e_vcc =3D FORE200E_=
VCC(vcc);=0A-=0A-    if (!fore200e)=0A-        return -EINVAL;=0A-=0A-    t=
xq =3D &fore200e->host_txq;=0A-    if (!fore200e_vcc)=0A-        return -EI=
NVAL;=0A+    ASSERT(vcc);=0A+    ASSERT(fore200e);=0A+    ASSERT(fore200e_v=
cc);=0A =0A     if (!test_bit(ATM_VF_READY, &vcc->flags)) {=0A 	DPRINTK(1, =
"VC %d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);=0A-- =0A2.=
30.2=0A=0A=0AFrom b04fd60e30dc25c30988b115c6b7baa402e7afcc Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:31:12 +0100=0ASubject: [PATCH 46/94] Revert "rapidio: fix a =
NULL pointer dereference when=0A create_workqueue() fails"=0A=0AThis revert=
s commit 2a89e4c5ee2ee5964bc8b974f120e1a8eded25e9.=0A=0ACommits from @umn.e=
du addresses have been found to be submitted in "bad=0Afaith" to try to tes=
t the kernel community's ability to review "known=0Amalicious" changes.  Th=
e result of these submissions can be found in a=0Apaper published at the 42=
nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecuri=
ty: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written=
 by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Min=
nesota).=0A=0ABecause of this, all submissions from this group must be reve=
rted from=0Athe kernel tree and will need to be re-reviewed again to determ=
ine if=0Athey actually are a valid fix.  Until that work is complete, remov=
e this=0Achange to ensure that no problems are being introduced into the=0A=
codebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/rapidio/rio_cm.c | 8 --------=0A 1 file changed, 8 deleti=
ons(-)=0A=0Adiff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.=
c=0Aindex b29fc258eeba..cf45829585cb 100644=0A--- a/drivers/rapidio/rio_cm.=
c=0A+++ b/drivers/rapidio/rio_cm.c=0A@@ -2147,14 +2147,6 @@ static int rioc=
m_add_mport(struct device *dev,=0A 	mutex_init(&cm->rx_lock);=0A 	riocm_rx_=
fill(cm, RIOCM_RX_RING_SIZE);=0A 	cm->rx_wq =3D create_workqueue(DRV_NAME "=
/rxq");=0A-	if (!cm->rx_wq) {=0A-		riocm_error("failed to allocate IBMBOX_%=
d on %s",=0A-			    cmbox, mport->name);=0A-		rio_release_outb_mbox(mport, =
cmbox);=0A-		kfree(cm);=0A-		return -ENOMEM;=0A-	}=0A-=0A 	INIT_WORK(&cm->r=
x_work, rio_ibmsg_handler);=0A =0A 	cm->tx_slot =3D 0;=0A-- =0A2.30.2=0A=0A=
=0AFrom 732b6ce5e64b7453ac587f021df9f82b07691428 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:31:12 +0100=0ASubject: [PATCH 47/94] Revert "tracing: Fix a memory l=
eak by early error exit=0A in trace_pid_write()"=0A=0AThis reverts commit 0=
e78e92da2d8925d3acdfbee57233a75e2f6e423.=0A=0ACommits from @umn.edu address=
es have been found to be submitted in "bad=0Afaith" to try to test the kern=
el community's ability to review "known=0Amalicious" changes.  The result o=
f these submissions can be found in a=0Apaper published at the 42nd IEEE Sy=
mposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealt=
hily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi=
 Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A kernel/trace/trace.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 del=
etions(-)=0A=0Adiff --git a/kernel/trace/trace.c b/kernel/trace/trace.c=0Ai=
ndex bca0b6df53ca..16784f3a3acf 100644=0A--- a/kernel/trace/trace.c=0A+++ b=
/kernel/trace/trace.c=0A@@ -496,10 +496,8 @@ int trace_pid_write(struct tra=
ce_pid_list *filtered_pids,=0A 	 * not modified.=0A 	 */=0A 	pid_list =3D k=
malloc(sizeof(*pid_list), GFP_KERNEL);=0A-	if (!pid_list) {=0A-		trace_pars=
er_put(&parser);=0A+	if (!pid_list)=0A 		return -ENOMEM;=0A-	}=0A =0A 	pid_=
list->pid_max =3D READ_ONCE(pid_max);=0A =0A@@ -509,7 +507,6 @@ int trace_p=
id_write(struct trace_pid_list *filtered_pids,=0A =0A 	pid_list->pids =3D v=
zalloc((pid_list->pid_max + 7) >> 3);=0A 	if (!pid_list->pids) {=0A-		trace=
_parser_put(&parser);=0A 		kfree(pid_list);=0A 		return -ENOMEM;=0A 	}=0A--=
 =0A2.30.2=0A=0A=0AFrom 29980666985ee339b0c8ff9fcf47e72981c76e76 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:31:12 +0100=0ASubject: [PATCH 48/94] Revert "rsi: Fix =
NULL pointer dereference in kmalloc"=0A=0AThis reverts commit eacec4367998f=
647f172383c5008e727967a06c7.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/w=
ireless/rsi/rsi_91x_mac80211.c | 30 +++++++++------------=0A 1 file changed=
, 12 insertions(+), 18 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/=
rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c=0Ainde=
x be59d66585d6..4e510cbe0a89 100644=0A--- a/drivers/net/wireless/rsi/rsi_91=
x_mac80211.c=0A+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c=0A@@ -188,=
27 +188,27 @@ bool rsi_is_cipher_wep(struct rsi_common *common)=0A  * @adap=
ter: Pointer to the adapter structure.=0A  * @band: Operating band to be se=
t.=0A  *=0A- * Return: int - 0 on success, negative error on failure.=0A+ *=
 Return: None.=0A  */=0A-static int rsi_register_rates_channels(struct rsi_=
hw *adapter, int band)=0A+static void rsi_register_rates_channels(struct rs=
i_hw *adapter, int band)=0A {=0A 	struct ieee80211_supported_band *sbands =
=3D &adapter->sbands[band];=0A 	void *channels =3D NULL;=0A =0A 	if (band =
=3D=3D NL80211_BAND_2GHZ) {=0A-		channels =3D kmemdup(rsi_2ghz_channels, si=
zeof(rsi_2ghz_channels),=0A-				   GFP_KERNEL);=0A-		if (!channels)=0A-			r=
eturn -ENOMEM;=0A+		channels =3D kmalloc(sizeof(rsi_2ghz_channels), GFP_KER=
NEL);=0A+		memcpy(channels,=0A+		       rsi_2ghz_channels,=0A+		       size=
of(rsi_2ghz_channels));=0A 		sbands->band =3D NL80211_BAND_2GHZ;=0A 		sband=
s->n_channels =3D ARRAY_SIZE(rsi_2ghz_channels);=0A 		sbands->bitrates =3D =
rsi_rates;=0A 		sbands->n_bitrates =3D ARRAY_SIZE(rsi_rates);=0A 	} else {=
=0A-		channels =3D kmemdup(rsi_5ghz_channels, sizeof(rsi_5ghz_channels),=0A=
-				   GFP_KERNEL);=0A-		if (!channels)=0A-			return -ENOMEM;=0A+		channel=
s =3D kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL);=0A+		memcpy(channels,=
=0A+		       rsi_5ghz_channels,=0A+		       sizeof(rsi_5ghz_channels));=0A =
		sbands->band =3D NL80211_BAND_5GHZ;=0A 		sbands->n_channels =3D ARRAY_SIZ=
E(rsi_5ghz_channels);=0A 		sbands->bitrates =3D &rsi_rates[4];=0A@@ -227,7 =
+227,6 @@ static int rsi_register_rates_channels(struct rsi_hw *adapter, in=
t band)=0A 	sbands->ht_cap.mcs.rx_mask[0] =3D 0xff;=0A 	sbands->ht_cap.mcs.=
tx_params =3D IEEE80211_HT_MCS_TX_DEFINED;=0A 	/* sbands->ht_cap.mcs.rx_hig=
hest =3D 0x82; */=0A-	return 0;=0A }=0A =0A /**=0A@@ -1986,16 +1985,11 @@ i=
nt rsi_mac80211_attach(struct rsi_common *common)=0A 	wiphy->available_ante=
nnas_rx =3D 1;=0A 	wiphy->available_antennas_tx =3D 1;=0A =0A-	status =3D r=
si_register_rates_channels(adapter, NL80211_BAND_2GHZ);=0A-	if (status)=0A-=
		return status;=0A+	rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ=
);=0A 	wiphy->bands[NL80211_BAND_2GHZ] =3D=0A 		&adapter->sbands[NL80211_BA=
ND_2GHZ];=0A 	if (common->num_supp_bands > 1) {=0A-		status =3D rsi_registe=
r_rates_channels(adapter,=0A-						     NL80211_BAND_5GHZ);=0A-		if (status=
)=0A-			return status;=0A+		rsi_register_rates_channels(adapter, NL80211_BA=
ND_5GHZ);=0A 		wiphy->bands[NL80211_BAND_5GHZ] =3D=0A 			&adapter->sbands[N=
L80211_BAND_5GHZ];=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom b5801f54ec25016f7e2a0c=
8800a406fe8dea06d0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:12 +0100=0ASubject: =
[PATCH 49/94] Revert "net: cw1200: fix a NULL pointer dereference"=0A=0AThi=
s reverts commit 31de7f1d07b5b241187d49cedb6284e4d70b4466.=0A=0ACommits fro=
m @umn.edu addresses have been found to be submitted in "bad=0Afaith" to tr=
y to test the kernel community's ability to review "known=0Amalicious" chan=
ges.  The result of these submissions can be found in a=0Apaper published a=
t the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source =
Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits"=
 written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universit=
y of Minnesota).=0A=0ABecause of this, all submissions from this group must=
 be reverted from=0Athe kernel tree and will need to be re-reviewed again t=
o determine if=0Athey actually are a valid fix.  Until that work is complet=
e, remove this=0Achange to ensure that no problems are being introduced int=
o the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0A---=0A drivers/net/wireless/st/cw1200/main.c | 5 -----=0A 1 file =
changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/st/cw1200/ma=
in.c b/drivers/net/wireless/st/cw1200/main.c=0Aindex 0c5a15e2b8f9..61d1c53f=
9922 100644=0A--- a/drivers/net/wireless/st/cw1200/main.c=0A+++ b/drivers/n=
et/wireless/st/cw1200/main.c=0A@@ -345,11 +345,6 @@ static struct ieee80211=
_hw *cw1200_init_common(const u8 *macaddr,=0A 	mutex_init(&priv->wsm_cmd_mu=
x);=0A 	mutex_init(&priv->conf_mutex);=0A 	priv->workqueue =3D create_singl=
ethread_workqueue("cw1200_wq");=0A-	if (!priv->workqueue) {=0A-		ieee80211_=
free_hw(hw);=0A-		return NULL;=0A-	}=0A-=0A 	sema_init(&priv->scan.lock, 1)=
;=0A 	INIT_WORK(&priv->scan.work, cw1200_scan_work);=0A 	INIT_DELAYED_WORK(=
&priv->scan.probe_work, cw1200_probe_work);=0A-- =0A2.30.2=0A=0A=0AFrom efc=
b9b5a1873467744bc9b3e780ea221e4823619 Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:13 =
+0100=0ASubject: [PATCH 50/94] Revert "net: ieee802154: fix missing checks =
for=0A regmap_update_bits"=0A=0AThis reverts commit 36ae546a0046ebf3d9f38ac=
eb70286ebf6127147.=0A=0ACommits from @umn.edu addresses have been found to =
be submitted in "bad=0Afaith" to try to test the kernel community's ability=
 to review "known=0Amalicious" changes.  The result of these submissions ca=
n be found in a=0Apaper published at the 42nd IEEE Symposium on Security an=
d Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVul=
nerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof M=
innesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, a=
ll submissions from this group must be reverted from=0Athe kernel tree and =
will need to be re-reviewed again to determine if=0Athey actually are a val=
id fix.  Until that work is complete, remove this=0Achange to ensure that n=
o problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Su=
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ieee802154/=
mcr20a.c | 6 ------=0A 1 file changed, 6 deletions(-)=0A=0Adiff --git a/dri=
vers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a.c=0Aindex fe40=
57fca83d..04891429a554 100644=0A--- a/drivers/net/ieee802154/mcr20a.c=0A+++=
 b/drivers/net/ieee802154/mcr20a.c=0A@@ -539,8 +539,6 @@ mcr20a_start(struc=
t ieee802154_hw *hw)=0A 	dev_dbg(printdev(lp), "no slotted operation\n");=
=0A 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL1,=0A 				 DAR_=
PHY_CTRL1_SLOTTED, 0x0);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	/* enabl=
e irq */=0A 	enable_irq(lp->spi->irq);=0A@@ -548,15 +546,11 @@ mcr20a_start=
(struct ieee802154_hw *hw)=0A 	/* Unmask SEQ interrupt */=0A 	ret =3D regma=
p_update_bits(lp->regmap_dar, DAR_PHY_CTRL2,=0A 				 DAR_PHY_CTRL2_SEQMSK, =
0x0);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	/* Start the RX sequence */=
=0A 	dev_dbg(printdev(lp), "start the RX sequence\n");=0A 	ret =3D regmap_u=
pdate_bits(lp->regmap_dar, DAR_PHY_CTRL1,=0A 				 DAR_PHY_CTRL1_XCVSEQ_MASK=
, MCR20A_XCVSEQ_RX);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	return 0;=0A=
 }=0A-- =0A2.30.2=0A=0A=0AFrom 739edfa27ffeeb42e935c58d53b6b9a6395c6851 Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:13 +0100=0ASubject: [PATCH 51/94] Revert "x=
86/PCI: Fix PCI IRQ routing table memory leak"=0A=0AThis reverts commit aeb=
743dbe9360aa8b37b725550df1b3811b21fa6.=0A=0ACommits from @umn.edu addresses=
 have been found to be submitted in "bad=0Afaith" to try to test the kernel=
 community's ability to review "known=0Amalicious" changes.  The result of =
these submissions can be found in a=0Apaper published at the 42nd IEEE Symp=
osium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthi=
ly Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi W=
u (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
arch/x86/pci/irq.c | 10 ++--------=0A 1 file changed, 2 insertions(+), 8 de=
letions(-)=0A=0Adiff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c=0Ainde=
x d3a73f9335e1..52e55108404e 100644=0A--- a/arch/x86/pci/irq.c=0A+++ b/arch=
/x86/pci/irq.c=0A@@ -1119,8 +1119,6 @@ static const struct dmi_system_id pc=
iirq_dmi_table[] __initconst =3D {=0A =0A void __init pcibios_irq_init(void=
)=0A {=0A-	struct irq_routing_table *rtable =3D NULL;=0A-=0A 	DBG(KERN_DEBU=
G "PCI: IRQ init\n");=0A =0A 	if (raw_pci_ops =3D=3D NULL)=0A@@ -1131,10 +1=
129,8 @@ void __init pcibios_irq_init(void)=0A 	pirq_table =3D pirq_find_ro=
uting_table();=0A =0A #ifdef CONFIG_PCI_BIOS=0A-	if (!pirq_table && (pci_pr=
obe & PCI_BIOS_IRQ_SCAN)) {=0A+	if (!pirq_table && (pci_probe & PCI_BIOS_IR=
Q_SCAN))=0A 		pirq_table =3D pcibios_get_irq_routing_table();=0A-		rtable =
=3D pirq_table;=0A-	}=0A #endif=0A 	if (pirq_table) {=0A 		pirq_peer_trick(=
);=0A@@ -1149,10 +1145,8 @@ void __init pcibios_irq_init(void)=0A 		 * If w=
e're using the I/O APIC, avoid using the PCI IRQ=0A 		 * routing table=0A 	=
	 */=0A-		if (io_apic_assign_pci_irqs) {=0A-			kfree(rtable);=0A+		if (io_a=
pic_assign_pci_irqs)=0A 			pirq_table =3D NULL;=0A-		}=0A 	}=0A =0A 	x86_in=
it.pci.fixup_irqs();=0A-- =0A2.30.2=0A=0A=0AFrom 37cf74c8bb6b198c0501ce94f5=
64c4e51a163ec8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:13 +0100=0ASubject: [PATCH=
 52/94] Revert "mmc_spi: add a status check for=0A spi_sync_locked"=0A=0ATh=
is reverts commit fa291e89997a27b0b34b9302ec8a8bf925dcecf2.=0A=0ACommits fr=
om @umn.edu addresses have been found to be submitted in "bad=0Afaith" to t=
ry to test the kernel community's ability to review "known=0Amalicious" cha=
nges.  The result of these submissions can be found in a=0Apaper published =
at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source=
 Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits=
" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Universi=
ty of Minnesota).=0A=0ABecause of this, all submissions from this group mus=
t be reverted from=0Athe kernel tree and will need to be re-reviewed again =
to determine if=0Athey actually are a valid fix.  Until that work is comple=
te, remove this=0Achange to ensure that no problems are being introduced in=
to the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0A---=0A drivers/mmc/host/mmc_spi.c | 4 ----=0A 1 file changed, 4 =
deletions(-)=0A=0Adiff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/hos=
t/mmc_spi.c=0Aindex 24795454d106..cba6972d2e1f 100644=0A--- a/drivers/mmc/h=
ost/mmc_spi.c=0A+++ b/drivers/mmc/host/mmc_spi.c=0A@@ -819,10 +819,6 @@ mmc=
_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,=0A 	}=0A =
=0A 	status =3D spi_sync_locked(spi, &host->m);=0A-	if (status < 0) {=0A-		=
dev_dbg(&spi->dev, "read error %d\n", status);=0A-		return status;=0A-	}=0A=
 =0A 	if (host->dma_dev) {=0A 		dma_sync_single_for_cpu(host->dma_dev,=0A--=
 =0A2.30.2=0A=0A=0AFrom 2227e5074113ac0a50523a55798043b9a16bf94d Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:31:14 +0100=0ASubject: [PATCH 53/94] Revert "iio: hmc5=
843: fix potential NULL pointer=0A dereferences"=0A=0AThis reverts commit d=
d106d198deee0cf682b97a65d6b171fb80cc4a3.=0A=0ACommits from @umn.edu address=
es have been found to be submitted in "bad=0Afaith" to try to test the kern=
el community's ability to review "known=0Amalicious" changes.  The result o=
f these submissions can be found in a=0Apaper published at the 42nd IEEE Sy=
mposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealt=
hily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi=
 Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/iio/magnetometer/hmc5843_i2c.c | 7 +------=0A drivers/iio/magne=
tometer/hmc5843_spi.c | 7 +------=0A 2 files changed, 2 insertions(+), 12 d=
eletions(-)=0A=0Adiff --git a/drivers/iio/magnetometer/hmc5843_i2c.c b/driv=
ers/iio/magnetometer/hmc5843_i2c.c=0Aindex 86abba5827a2..3de7f4426ac4 10064=
4=0A--- a/drivers/iio/magnetometer/hmc5843_i2c.c=0A+++ b/drivers/iio/magnet=
ometer/hmc5843_i2c.c=0A@@ -58,13 +58,8 @@ static const struct regmap_config=
 hmc5843_i2c_regmap_config =3D {=0A static int hmc5843_i2c_probe(struct i2c=
_client *cli,=0A 			     const struct i2c_device_id *id)=0A {=0A-	struct re=
gmap *regmap =3D devm_regmap_init_i2c(cli,=0A-			&hmc5843_i2c_regmap_config=
);=0A-	if (IS_ERR(regmap))=0A-		return PTR_ERR(regmap);=0A-=0A 	return hmc5=
843_common_probe(&cli->dev,=0A-			regmap,=0A+			devm_regmap_init_i2c(cli, &=
hmc5843_i2c_regmap_config),=0A 			id->driver_data, id->name);=0A }=0A =0Adi=
ff --git a/drivers/iio/magnetometer/hmc5843_spi.c b/drivers/iio/magnetomete=
r/hmc5843_spi.c=0Aindex 79b2b707f90e..535f03a70d63 100644=0A--- a/drivers/i=
io/magnetometer/hmc5843_spi.c=0A+++ b/drivers/iio/magnetometer/hmc5843_spi.=
c=0A@@ -58,7 +58,6 @@ static const struct regmap_config hmc5843_spi_regmap_=
config =3D {=0A static int hmc5843_spi_probe(struct spi_device *spi)=0A {=
=0A 	int ret;=0A-	struct regmap *regmap;=0A 	const struct spi_device_id *id=
 =3D spi_get_device_id(spi);=0A =0A 	spi->mode =3D SPI_MODE_3;=0A@@ -68,12 =
+67,8 @@ static int hmc5843_spi_probe(struct spi_device *spi)=0A 	if (ret)=
=0A 		return ret;=0A =0A-	regmap =3D devm_regmap_init_spi(spi, &hmc5843_spi=
_regmap_config);=0A-	if (IS_ERR(regmap))=0A-		return PTR_ERR(regmap);=0A-=
=0A 	return hmc5843_common_probe(&spi->dev,=0A-			regmap,=0A+			devm_regmap=
_init_spi(spi, &hmc5843_spi_regmap_config),=0A 			id->driver_data, id->name=
);=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 6af7399c73ed423d179ae24cb4f6c9ba887=
f0fc8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:31:14 +0100=0ASubject: [PATCH 54/94] R=
evert "rtlwifi: fix a potential NULL pointer=0A dereference"=0A=0AThis reve=
rts commit 7be8d4251bf71a7fad26344e37b3dd4e18cde4fa.=0A=0ACommits from @umn=
=2Eedu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/net/wireless/realtek/rtlwifi/base.c | 5 -----=0A 1 fil=
e changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/realtek/rt=
lwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c=0Aindex a3189294=
ecb8..ef9b502ce576 100644=0A--- a/drivers/net/wireless/realtek/rtlwifi/base=
=2Ec=0A+++ b/drivers/net/wireless/realtek/rtlwifi/base.c=0A@@ -469,11 +469,=
6 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)=0A 	/* <2=
> work queue */=0A 	rtlpriv->works.hw =3D hw;=0A 	rtlpriv->works.rtl_wq =3D=
 alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);=0A-	if (unlikely(!rtlpriv=
->works.rtl_wq)) {=0A-		pr_err("Failed to allocate work queue\n");=0A-		ret=
urn;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,=0A 			  (=
void *)rtl_watchdog_wq_callback);=0A 	INIT_DELAYED_WORK(&rtlpriv->works.ips=
_nic_off_wq,=0A-- =0A2.30.2=0A=0A=0AFrom 0ebb6b3a985243f7391ff7ce4bae21bedc=
7c9ad5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:31:14 +0100=0ASubject: [PATCH 55/94] =
Revert "video: hgafb: fix potential NULL pointer=0A dereference"=0A=0AThis =
reverts commit 1f2611af4581a556dff4e99c860e3d1c1c6c3024.=0A=0ACommits from =
@umn.edu addresses have been found to be submitted in "bad=0Afaith" to try =
to test the kernel community's ability to review "known=0Amalicious" change=
s.  The result of these submissions can be found in a=0Apaper published at =
the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source In=
security: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" w=
ritten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University =
of Minnesota).=0A=0ABecause of this, all submissions from this group must b=
e reverted from=0Athe kernel tree and will need to be re-reviewed again to =
determine if=0Athey actually are a valid fix.  Until that work is complete,=
 remove this=0Achange to ensure that no problems are being introduced into =
the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0A---=0A drivers/video/fbdev/hgafb.c | 2 --=0A 1 file changed, 2 de=
letions(-)=0A=0Adiff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fb=
dev/hgafb.c=0Aindex 59e1cae57948..463028543173 100644=0A--- a/drivers/video=
/fbdev/hgafb.c=0A+++ b/drivers/video/fbdev/hgafb.c=0A@@ -285,8 +285,6 @@ st=
atic int hga_card_detect(void)=0A 	hga_vram_len  =3D 0x08000;=0A =0A 	hga_v=
ram =3D ioremap(0xb0000, hga_vram_len);=0A-	if (!hga_vram)=0A-		goto error;=
=0A =0A 	if (request_region(0x3b0, 12, "hgafb"))=0A 		release_io_ports =3D =
1;=0A-- =0A2.30.2=0A=0A=0AFrom 9b6119b3e527c8724a8cc930bb2c4549f097beec Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:15 +0100=0ASubject: [PATCH 56/94] Revert "v=
ideo: imsttfb: fix potential NULL pointer=0A dereferences"=0A=0AThis revert=
s commit e06d7a92796c50673a07de4e840aac6e8fc6d9c0.=0A=0ACommits from @umn.e=
du addresses have been found to be submitted in "bad=0Afaith" to try to tes=
t the kernel community's ability to review "known=0Amalicious" changes.  Th=
e result of these submissions can be found in a=0Apaper published at the 42=
nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecuri=
ty: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written=
 by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Min=
nesota).=0A=0ABecause of this, all submissions from this group must be reve=
rted from=0Athe kernel tree and will need to be re-reviewed again to determ=
ine if=0Athey actually are a valid fix.  Until that work is complete, remov=
e this=0Achange to ensure that no problems are being introduced into the=0A=
codebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/video/fbdev/imsttfb.c | 5 -----=0A 1 file changed, 5 dele=
tions(-)=0A=0Adiff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fb=
dev/imsttfb.c=0Aindex ffcf553719a3..ecdcf358ad5e 100644=0A--- a/drivers/vid=
eo/fbdev/imsttfb.c=0A+++ b/drivers/video/fbdev/imsttfb.c=0A@@ -1516,11 +151=
6,6 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_devi=
ce_id *ent)=0A 	info->fix.smem_start =3D addr;=0A 	info->screen_base =3D (_=
_u8 *)ioremap(addr, par->ramdac =3D=3D IBM ?=0A 					    0x400000 : 0x80000=
0);=0A-	if (!info->screen_base) {=0A-		release_mem_region(addr, size);=0A-	=
	framebuffer_release(info);=0A-		return -ENOMEM;=0A-	}=0A 	info->fix.mmio_s=
tart =3D addr + 0x800000;=0A 	par->dc_regs =3D ioremap(addr + 0x800000, 0x1=
000);=0A 	par->cmap_regs_phys =3D addr + 0x840000;=0A-- =0A2.30.2=0A=0A=0AF=
rom e4532320351f22a50f91422890b725613fc81934 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:31:15 +0100=0ASubject: [PATCH 57/94] Revert "rfkill: Fix incorrect check t=
o avoid NULL=0A pointer dereference"=0A=0AThis reverts commit d8ec4cf103d6a=
afcabe8a63cfc53e2350c12b5f6.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/rfkill/co=
re.c | 7 ++-----=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adi=
ff --git a/net/rfkill/core.c b/net/rfkill/core.c=0Aindex d6467cbf5c4f..7fbc=
8314f626 100644=0A--- a/net/rfkill/core.c=0A+++ b/net/rfkill/core.c=0A@@ -1=
014,13 +1014,10 @@ static void rfkill_sync_work(struct work_struct *work)=
=0A int __must_check rfkill_register(struct rfkill *rfkill)=0A {=0A 	static=
 unsigned long rfkill_no;=0A-	struct device *dev;=0A+	struct device *dev =
=3D &rfkill->dev;=0A 	int error;=0A =0A-	if (!rfkill)=0A-		return -EINVAL;=
=0A-=0A-	dev =3D &rfkill->dev;=0A+	BUG_ON(!rfkill);=0A =0A 	mutex_lock(&rfk=
ill_global_mutex);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 2e546fce84b0894417e7cc92=
47d9ca33c2568d8e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:15 +0100=0ASubject: [PAT=
CH 58/94] Revert "PCI: xilinx: Check for __get_free_pages()=0A failure"=0A=
=0AThis reverts commit 47d281bbbff9c7167332bea79bcedc08f863b02f.=0A=0ACommi=
ts from @umn.edu addresses have been found to be submitted in "bad=0Afaith"=
 to try to test the kernel community's ability to review "known=0Amalicious=
" changes.  The result of these submissions can be found in a=0Apaper publi=
shed at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open S=
ource Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Co=
mmits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (Uni=
versity of Minnesota).=0A=0ABecause of this, all submissions from this grou=
p must be reverted from=0Athe kernel tree and will need to be re-reviewed a=
gain to determine if=0Athey actually are a valid fix.  Until that work is c=
omplete, remove this=0Achange to ensure that no problems are being introduc=
ed into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0A---=0A drivers/pci/controller/pcie-xilinx.c | 12 ++--------=
--=0A 1 file changed, 2 insertions(+), 10 deletions(-)=0A=0Adiff --git a/dr=
ivers/pci/controller/pcie-xilinx.c b/drivers/pci/controller/pcie-xilinx.c=
=0Aindex ea48cba5480b..7b1389d8e2a5 100644=0A--- a/drivers/pci/controller/p=
cie-xilinx.c=0A+++ b/drivers/pci/controller/pcie-xilinx.c=0A@@ -336,19 +336=
,14 @@ static const struct irq_domain_ops msi_domain_ops =3D {=0A  * xilinx=
_pcie_enable_msi - Enable MSI support=0A  * @port: PCIe port information=0A=
  */=0A-static int xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A=
+static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A {=0A =
	phys_addr_t msg_addr;=0A =0A 	port->msi_pages =3D __get_free_pages(GFP_KER=
NEL, 0);=0A-	if (!port->msi_pages)=0A-		return -ENOMEM;=0A-=0A 	msg_addr =
=3D virt_to_phys((void *)port->msi_pages);=0A 	pcie_write(port, 0x0, XILINX=
_PCIE_REG_MSIBASE1);=0A 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE=
2);=0A-=0A-	return 0;=0A }=0A =0A /* INTx Functions */=0A@@ -503,7 +498,6 @=
@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)=0A =
	struct device *dev =3D port->dev;=0A 	struct device_node *node =3D dev->of=
_node;=0A 	struct device_node *pcie_intc_node;=0A-	int ret;=0A =0A 	/* Setu=
p INTx */=0A 	pcie_intc_node =3D of_get_next_child(node, NULL);=0A@@ -532,9=
 +526,7 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *=
port)=0A 			return -ENODEV;=0A 		}=0A =0A-		ret =3D xilinx_pcie_enable_msi(=
port);=0A-		if (ret)=0A-			return ret;=0A+		xilinx_pcie_enable_msi(port);=
=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom c68e0c1744699e3ed2782d=
6c7d3d4c1d259f7021 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:15 +0100=0ASubject: =
[PATCH 59/94] Revert "media: video-mux: fix null pointer=0A dereferences"=
=0A=0AThis reverts commit 6b5693f20dd8a6a07aeaa84c722bfe0ca3cfe9b7.=0A=0ACo=
mmits from @umn.edu addresses have been found to be submitted in "bad=0Afai=
th" to try to test the kernel community's ability to review "known=0Amalici=
ous" changes.  The result of these submissions can be found in a=0Apaper pu=
blished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Ope=
n Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite=
 Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (=
University of Minnesota).=0A=0ABecause of this, all submissions from this g=
roup must be reverted from=0Athe kernel tree and will need to be re-reviewe=
d again to determine if=0Athey actually are a valid fix.  Until that work i=
s complete, remove this=0Achange to ensure that no problems are being intro=
duced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0A---=0A drivers/media/platform/video-mux.c | 5 -----=0A 1=
 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/media/platform/vide=
o-mux.c b/drivers/media/platform/video-mux.c=0Aindex c8ffe7bff77f..c01e1592=
ad0a 100644=0A--- a/drivers/media/platform/video-mux.c=0A+++ b/drivers/medi=
a/platform/video-mux.c=0A@@ -365,14 +365,9 @@ static int video_mux_probe(st=
ruct platform_device *pdev)=0A 	vmux->active =3D -1;=0A 	vmux->pads =3D dev=
m_kcalloc(dev, num_pads, sizeof(*vmux->pads),=0A 				  GFP_KERNEL);=0A-	if =
(!vmux->pads)=0A-		return -ENOMEM;=0A-=0A 	vmux->format_mbus =3D devm_kcall=
oc(dev, num_pads,=0A 					 sizeof(*vmux->format_mbus),=0A 					 GFP_KERNEL)=
;=0A-	if (!vmux->format_mbus)=0A-		return -ENOMEM;=0A =0A 	for (i =3D 0; i =
< num_pads; i++) {=0A 		vmux->pads[i].flags =3D (i < num_pads - 1) ? MEDIA_=
PAD_FL_SINK=0A-- =0A2.30.2=0A=0A=0AFrom fbbb295bbd5ef31f9e62c5c92c71d120546=
4d364 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:31:16 +0100=0ASubject: [PATCH 60/94] R=
evert "thunderbolt: property: Fix a missing check of=0A kzalloc"=0A=0AThis =
reverts commit c8eecd65822044bef7c2bf077bfea980b2de2302.=0A=0ACommits from =
@umn.edu addresses have been found to be submitted in "bad=0Afaith" to try =
to test the kernel community's ability to review "known=0Amalicious" change=
s.  The result of these submissions can be found in a=0Apaper published at =
the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source In=
security: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" w=
ritten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University =
of Minnesota).=0A=0ABecause of this, all submissions from this group must b=
e reverted from=0Athe kernel tree and will need to be re-reviewed again to =
determine if=0Athey actually are a valid fix.  Until that work is complete,=
 remove this=0Achange to ensure that no problems are being introduced into =
the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0A---=0A drivers/thunderbolt/property.c | 7 +------=0A 1 file chang=
ed, 1 insertion(+), 6 deletions(-)=0A=0Adiff --git a/drivers/thunderbolt/pr=
operty.c b/drivers/thunderbolt/property.c=0Aindex be3f8b592b05..32977243cb1=
2 100644=0A--- a/drivers/thunderbolt/property.c=0A+++ b/drivers/thunderbolt=
/property.c=0A@@ -586,12 +586,7 @@ int tb_property_add_text(struct tb_prope=
rty_dir *parent, const char *key,=0A 		return -ENOMEM;=0A =0A 	property->le=
ngth =3D size / 4;=0A-	property->value.text =3D kzalloc(size, GFP_KERNEL);=
=0A-	if (!property->value.text) {=0A-		kfree(property);=0A-		return -ENOMEM=
;=0A-	}=0A-=0A+	property->value.data =3D kzalloc(size, GFP_KERNEL);=0A 	str=
cpy(property->value.text, text);=0A =0A 	list_add_tail(&property->list, &pa=
rent->properties);=0A-- =0A2.30.2=0A=0A=0AFrom f166640572dd3e6c4e1d08a33b9f=
498a30196e3c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:16 +0100=0ASubject: [PATCH 6=
1/94] Revert "media: rcar_drif: fix a memory disclosure"=0A=0AThis reverts =
commit debdd16cbd99ffc767227685e2738e5b495b7c54.=0A=0ACommits from @umn.edu=
 addresses have been found to be submitted in "bad=0Afaith" to try to test =
the kernel community's ability to review "known=0Amalicious" changes.  The =
result of these submissions can be found in a=0Apaper published at the 42nd=
 IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity=
: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written b=
y Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minne=
sota).=0A=0ABecause of this, all submissions from this group must be revert=
ed from=0Athe kernel tree and will need to be re-reviewed again to determin=
e if=0Athey actually are a valid fix.  Until that work is complete, remove =
this=0Achange to ensure that no problems are being introduced into the=0Aco=
debase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
---=0A drivers/media/platform/rcar_drif.c | 1 -=0A 1 file changed, 1 deleti=
on(-)=0A=0Adiff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/=
platform/rcar_drif.c=0Aindex b677d014e7ba..81413ab52475 100644=0A--- a/driv=
ers/media/platform/rcar_drif.c=0A+++ b/drivers/media/platform/rcar_drif.c=
=0A@@ -912,7 +912,6 @@ static int rcar_drif_g_fmt_sdr_cap(struct file *file=
, void *priv,=0A {=0A 	struct rcar_drif_sdr *sdr =3D video_drvdata(file);=
=0A =0A-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));=0A 	f=
->fmt.sdr.pixelformat =3D sdr->fmt->pixelformat;=0A 	f->fmt.sdr.buffersize =
=3D sdr->fmt->buffersize;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 7015e6bdf3fd4b73b=
ca9cb71d626bbb95cb24685 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:16 +0100=0ASubjec=
t: [PATCH 62/94] Revert "drm/gma500: fix memory disclosures due to=0A unini=
tialized bytes"=0A=0AThis reverts commit 7a284055e4c4d2b45955532252f8e63cc4=
1aa2e0.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
d in "bad=0Afaith" to try to test the kernel community's ability to review =
"known=0Amalicious" changes.  The result of these submissions can be found =
in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/oaktrail_=
crtc.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/g=
pu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oaktrail_crtc.c=0Ain=
dex f73a02a2a5b3..1b7fd6a9d8a5 100644=0A--- a/drivers/gpu/drm/gma500/oaktra=
il_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c=0A@@ -139,7 +139,6=
 @@ static bool mrst_sdvo_find_best_pll(const struct gma_limit_t *limit,=0A=
 	s32 freq_error, min_error =3D 100000;=0A =0A 	memset(best_clock, 0, sizeo=
f(*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (clock.m=
 =3D limit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		for (clock.=
n =3D limit->n.min; clock.n <=3D limit->n.max;=0A@@ -196,7 +195,6 @@ static=
 bool mrst_lvds_find_best_pll(const struct gma_limit_t *limit,=0A 	int err =
=3D target;=0A =0A 	memset(best_clock, 0, sizeof(*best_clock));=0A-	memset(=
&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =3D limit->m.min; clock.m <=
=3D limit->m.max; clock.m++) {=0A 		for (clock.p1 =3D limit->p1.min; clock.=
p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=0AFrom 383184e1d608eb4971b3c084=
4109e112bb4adfb6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:17 +0100=0ASubject: [PAT=
CH 63/94] Revert "gma/gma500: fix a memory disclosure bug due to=0A uniniti=
alized bytes"=0A=0AThis reverts commit ef488886e34a65aac17385835572eb5d69c4=
5682.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
in "bad=0Afaith" to try to test the kernel community's ability to review "k=
nown=0Amalicious" changes.  The result of these submissions can be found in=
 a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Ae=
ntitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities =
via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and=
 Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submission=
s from this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/cdv_intel_dis=
play.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/g=
pu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_displa=
y.c=0Aindex 2e8479744ca4..17db4b4749d5 100644=0A--- a/drivers/gpu/drm/gma50=
0/cdv_intel_display.c=0A+++ b/drivers/gpu/drm/gma500/cdv_intel_display.c=0A=
@@ -415,8 +415,6 @@ static bool cdv_intel_find_dp_pll(const struct gma_limi=
t_t *limit,=0A 	struct gma_crtc *gma_crtc =3D to_gma_crtc(crtc);=0A 	struct=
 gma_clock_t clock;=0A =0A-	memset(&clock, 0, sizeof(clock));=0A-=0A 	switc=
h (refclk) {=0A 	case 27000:=0A 		if (target < 200000) {=0A-- =0A2.30.2=0A=
=0A=0AFrom 0f03557f115285078cd4f9a4eb89f017196b071e Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:31:17 +0100=0ASubject: [PATCH 64/94] Revert "spi : spi-topcliff-pch=
: Fix to handle empty DMA=0A buffers"=0A=0AThis reverts commit bdc095631d50=
f9b61ce4e933d118a6e6654c11c9.=0A=0ACommits from @umn.edu addresses have bee=
n found to be submitted in "bad=0Afaith" to try to test the kernel communit=
y's ability to review "known=0Amalicious" changes.  The result of these sub=
missions can be found in a=0Apaper published at the 42nd IEEE Symposium on =
Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introd=
ucing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univer=
sity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause=
 of this, all submissions from this group must be reverted from=0Athe kerne=
l tree and will need to be re-reviewed again to determine if=0Athey actuall=
y are a valid fix.  Until that work is complete, remove this=0Achange to en=
sure that no problems are being introduced into the=0Acodebase.=0A=0ASigned=
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/spi/=
spi-topcliff-pch.c | 15 ++-------------=0A 1 file changed, 2 insertions(+),=
 13 deletions(-)=0A=0Adiff --git a/drivers/spi/spi-topcliff-pch.c b/drivers=
/spi/spi-topcliff-pch.c=0Aindex 8a5966963834..fba3f180f233 100644=0A--- a/d=
rivers/spi/spi-topcliff-pch.c=0A+++ b/drivers/spi/spi-topcliff-pch.c=0A@@ -=
1299,27 +1299,18 @@ static void pch_free_dma_buf(struct pch_spi_board_data =
*board_dat,=0A 				  dma->rx_buf_virt, dma->rx_buf_dma);=0A }=0A =0A-static=
 int pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,=0A+static void=
 pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,=0A 			      struct=
 pch_spi_data *data)=0A {=0A 	struct pch_spi_dma_ctrl *dma;=0A-	int ret;=0A=
 =0A 	dma =3D &data->dma;=0A-	ret =3D 0;=0A 	/* Get Consistent memory for T=
x DMA */=0A 	dma->tx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=
=0A 				PCH_BUF_SIZE, &dma->tx_buf_dma, GFP_KERNEL);=0A-	if (!dma->tx_buf_v=
irt)=0A-		ret =3D -ENOMEM;=0A-=0A 	/* Get Consistent memory for Rx DMA */=
=0A 	dma->rx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 				=
PCH_BUF_SIZE, &dma->rx_buf_dma, GFP_KERNEL);=0A-	if (!dma->rx_buf_virt)=0A-=
		ret =3D -ENOMEM;=0A-=0A-	return ret;=0A }=0A =0A static int pch_spi_pd_pr=
obe(struct platform_device *plat_dev)=0A@@ -1396,9 +1387,7 @@ static int pc=
h_spi_pd_probe(struct platform_device *plat_dev)=0A =0A 	if (use_dma) {=0A =
		dev_info(&plat_dev->dev, "Use DMA for data transfers\n");=0A-		ret =3D pc=
h_alloc_dma_buf(board_dat, data);=0A-		if (ret)=0A-			goto err_spi_register=
_master;=0A+		pch_alloc_dma_buf(board_dat, data);=0A 	}=0A =0A 	ret =3D spi=
_register_master(master);=0A-- =0A2.30.2=0A=0A=0AFrom a2f61e157b06d8eef7a2a=
1639e3ceff842dc723c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:17 +0100=0ASubject: [=
PATCH 65/94] Revert "scsi: ufs: fix a missing check of=0A devm_reset_contro=
l_get"=0A=0AThis reverts commit aeea87865aa74eb3931ebe6f77c57ff484e95528.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/ufs/ufs-hisi.c | 4 ----=
=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/scsi/ufs/ufs-h=
isi.c b/drivers/scsi/ufs/ufs-hisi.c=0Aindex c2cee73a8560..452e19f8fb47 1006=
44=0A--- a/drivers/scsi/ufs/ufs-hisi.c=0A+++ b/drivers/scsi/ufs/ufs-hisi.c=
=0A@@ -544,10 +544,6 @@ static int ufs_hisi_init_common(struct ufs_hba *hba=
)=0A 	ufshcd_set_variant(hba, host);=0A =0A 	host->rst  =3D devm_reset_cont=
rol_get(dev, "rst");=0A-	if (IS_ERR(host->rst)) {=0A-		dev_err(dev, "%s: fa=
iled to get reset control\n", __func__);=0A-		return PTR_ERR(host->rst);=0A=
-	}=0A =0A 	ufs_hisi_set_pm_lvl(hba);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 92937=
6cd5ccce23f7857ded4613e26abcdacacdb Mon Sep 17 00:00:00 2001=0AFrom: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:17 +0=
100=0ASubject: [PATCH 66/94] Revert "netfilter: ip6t_srh: fix NULL pointer=
=0A dereferences"=0A=0AThis reverts commit e634fc48661fcfaee25df821ee6e8d7a=
ff6ae793.=0A=0ACommits from @umn.edu addresses have been found to be submit=
ted in "bad=0Afaith" to try to test the kernel community's ability to revie=
w "known=0Amalicious" changes.  The result of these submissions can be foun=
d in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A net/ipv6/netfilter/ip6t_srh.c | =
6 ------=0A 1 file changed, 6 deletions(-)=0A=0Adiff --git a/net/ipv6/netfi=
lter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c=0Aindex 4cb83fb69844..10598=
94a6f4c 100644=0A--- a/net/ipv6/netfilter/ip6t_srh.c=0A+++ b/net/ipv6/netfi=
lter/ip6t_srh.c=0A@@ -210,8 +210,6 @@ static bool srh1_mt6(const struct sk_=
buff *skb, struct xt_action_param *par)=0A 		psidoff =3D srhoff + sizeof(st=
ruct ipv6_sr_hdr) +=0A 			  ((srh->segments_left + 1) * sizeof(struct in6_a=
ddr));=0A 		psid =3D skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid=
);=0A-		if (!psid)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T_S=
RH_INV_PSID,=0A 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,=0A 					=
	     &srhinfo->psid_addr)))=0A@@ -225,8 +223,6 @@ static bool srh1_mt6(con=
st struct sk_buff *skb, struct xt_action_param *par)=0A 		nsidoff =3D srhof=
f + sizeof(struct ipv6_sr_hdr) +=0A 			  ((srh->segments_left - 1) * sizeof=
(struct in6_addr));=0A 		nsid =3D skb_header_pointer(skb, nsidoff, sizeof(_=
nsid), &_nsid);=0A-		if (!nsid)=0A-			return false;=0A 		if (NF_SRH_INVF(sr=
hinfo, IP6T_SRH_INV_NSID,=0A 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_=
msk,=0A 						     &srhinfo->nsid_addr)))=0A@@ -237,8 +233,6 @@ static bool=
 srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)=0A 	if (s=
rhinfo->mt_flags & IP6T_SRH_LSID) {=0A 		lsidoff =3D srhoff + sizeof(struct=
 ipv6_sr_hdr);=0A 		lsid =3D skb_header_pointer(skb, lsidoff, sizeof(_lsid)=
, &_lsid);=0A-		if (!lsid)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo=
, IP6T_SRH_INV_LSID,=0A 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,=
=0A 						     &srhinfo->lsid_addr)))=0A-- =0A2.30.2=0A=0A=0AFrom 543fec57d=
f3cd6afbdba5d5999448358578f9aa4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:18 +0100=
=0ASubject: [PATCH 67/94] Revert "media: si2165: fix a missing check of ret=
urn=0A value"=0A=0AThis reverts commit ab934f0ac1584c80b1f998bb2e9781d79ed8=
de24.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
in "bad=0Afaith" to try to test the kernel community's ability to review "k=
nown=0Amalicious" changes.  The result of these submissions can be found in=
 a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Ae=
ntitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities =
via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and=
 Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submission=
s from this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-frontends/si2165.c=
 | 8 +++-----=0A 1 file changed, 3 insertions(+), 5 deletions(-)=0A=0Adiff =
--git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/=
si2165.c=0Aindex d55d8f169dca..feacd8da421d 100644=0A--- a/drivers/media/dv=
b-frontends/si2165.c=0A+++ b/drivers/media/dvb-frontends/si2165.c=0A@@ -275=
,20 +275,18 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)=0A =
=0A static int si2165_wait_init_done(struct si2165_state *state)=0A {=0A-	i=
nt ret;=0A+	int ret =3D -EINVAL;=0A 	u8 val =3D 0;=0A 	int i;=0A =0A 	for (=
i =3D 0; i < 3; ++i) {=0A-		ret =3D si2165_readreg8(state, REG_INIT_DONE, &=
val);=0A-		if (ret < 0)=0A-			return ret;=0A+		si2165_readreg8(state, REG_I=
NIT_DONE, &val);=0A 		if (val =3D=3D 0x01)=0A 			return 0;=0A 		usleep_rang=
e(1000, 50000);=0A 	}=0A 	dev_err(&state->client->dev, "init_done was not s=
et\n");=0A-	return -EINVAL;=0A+	return ret;=0A }=0A =0A static int si2165_u=
pload_firmware_block(struct si2165_state *state,=0A-- =0A2.30.2=0A=0A=0AFro=
m fe6c93b4095be62934c47135eb7677441a785d5b Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:3=
1:18 +0100=0ASubject: [PATCH 68/94] Revert "ALSA: sb8: add a check for requ=
est_region"=0A=0AThis reverts commit 317e716a8ad99f367feaf11d388dd597f832b3=
b1.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
 "bad=0Afaith" to try to test the kernel community's ability to review "kno=
wn=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/sb/sb8.c | 4 ----=0A 1 fil=
e changed, 4 deletions(-)=0A=0Adiff --git a/sound/isa/sb/sb8.c b/sound/isa/=
sb/sb8.c=0Aindex 1eb8b61a185b..d77dcba276b5 100644=0A--- a/sound/isa/sb/sb8=
=2Ec=0A+++ b/sound/isa/sb/sb8.c=0A@@ -111,10 +111,6 @@ static int snd_sb8_p=
robe(struct device *pdev, unsigned int dev)=0A =0A 	/* block the 0x388 port=
 to avoid PnP conflicts */=0A 	acard->fm_res =3D request_region(0x388, 4, "=
SoundBlaster FM");=0A-	if (!acard->fm_res) {=0A-		err =3D -EBUSY;=0A-		goto=
 _err;=0A-	}=0A =0A 	if (port[dev] !=3D SNDRV_AUTO_PORT) {=0A 		if ((err =
=3D snd_sbdsp_create(card, port[dev], irq[dev],=0A-- =0A2.30.2=0A=0A=0AFrom=
 e8af4360ee6f6e212b59fec5ee17fc36b9c79ebb Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31=
:18 +0100=0ASubject: [PATCH 69/94] Revert "md: Fix failed allocation of=0A =
md_register_thread"=0A=0AThis reverts commit cc3b79d487e83481f15973d82edefc=
197dbf495e.=0A=0ACommits from @umn.edu addresses have been found to be subm=
itted in "bad=0Afaith" to try to test the kernel community's ability to rev=
iew "known=0Amalicious" changes.  The result of these submissions can be fo=
und in a=0Apaper published at the 42nd IEEE Symposium on Security and Priva=
cy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabil=
ities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesot=
a) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all subm=
issions from this group must be reverted from=0Athe kernel tree and will ne=
ed to be re-reviewed again to determine if=0Athey actually are a valid fix.=
  Until that work is complete, remove this=0Achange to ensure that no probl=
ems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/raid10.c | 2 --=0A =
drivers/md/raid5.c  | 2 --=0A 2 files changed, 4 deletions(-)=0A=0Adiff --g=
it a/drivers/md/raid10.c b/drivers/md/raid10.c=0Aindex 8e0f936b3e37..f1b7c7=
8a698a 100644=0A--- a/drivers/md/raid10.c=0A+++ b/drivers/md/raid10.c=0A@@ =
-3959,8 +3959,6 @@ static int raid10_run(struct mddev *mddev)=0A 		set_bit(=
MD_RECOVERY_RUNNING, &mddev->recovery);=0A 		mddev->sync_thread =3D md_regi=
ster_thread(md_do_sync, mddev,=0A 							"reshape");=0A-		if (!mddev->sync_=
thread)=0A-			goto out_free_conf;=0A 	}=0A =0A 	return 0;=0Adiff --git a/dr=
ivers/md/raid5.c b/drivers/md/raid5.c=0Aindex c7bda4b0bced..d94ae1cb2b12 10=
0644=0A--- a/drivers/md/raid5.c=0A+++ b/drivers/md/raid5.c=0A@@ -7403,8 +74=
03,6 @@ static int raid5_run(struct mddev *mddev)=0A 		set_bit(MD_RECOVERY_=
RUNNING, &mddev->recovery);=0A 		mddev->sync_thread =3D md_register_thread(=
md_do_sync, mddev,=0A 							"reshape");=0A-		if (!mddev->sync_thread)=0A-	=
		goto abort;=0A 	}=0A =0A 	/* Ok, everything is just fine now */=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 2ab9bbfc3140acda83bffef8be062b08c8e1a103 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:31:19 +0100=0ASubject: [PATCH 70/94] Revert "thunderbolt:=
 property: Fix a NULL pointer=0A dereference"=0A=0AThis reverts commit 495e=
34e62c3be4e1f4c53892db8aec62832fe6b5.=0A=0ACommits from @umn.edu addresses =
have been found to be submitted in "bad=0Afaith" to try to test the kernel =
community's ability to review "known=0Amalicious" changes.  The result of t=
hese submissions can be found in a=0Apaper published at the 42nd IEEE Sympo=
sium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthil=
y Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu=
 (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/thunderbolt/property.c | 5 -----=0A 1 file changed, 5 deletions(-)=
=0A=0Adiff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/pro=
perty.c=0Aindex 32977243cb12..8fe913a95b4a 100644=0A--- a/drivers/thunderbo=
lt/property.c=0A+++ b/drivers/thunderbolt/property.c=0A@@ -551,11 +551,6 @@=
 int tb_property_add_data(struct tb_property_dir *parent, const char *key,=
=0A =0A 	property->length =3D size / 4;=0A 	property->value.data =3D kzallo=
c(size, GFP_KERNEL);=0A-	if (!property->value.data) {=0A-		kfree(property);=
=0A-		return -ENOMEM;=0A-	}=0A-=0A 	memcpy(property->value.data, buf, bufle=
n);=0A =0A 	list_add_tail(&property->list, &parent->properties);=0A-- =0A2.=
30.2=0A=0A=0AFrom e1aa31c7fe69309922407c199078fbdd6b9e930c Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:31:19 +0100=0ASubject: [PATCH 71/94] Revert "tty: mxs-auart:=
 fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 124e=
42064c0dcbc0a260d0e18ed2410976422c54.=0A=0ACommits from @umn.edu addresses =
have been found to be submitted in "bad=0Afaith" to try to test the kernel =
community's ability to review "known=0Amalicious" changes.  The result of t=
hese submissions can be found in a=0Apaper published at the 42nd IEEE Sympo=
sium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthil=
y Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu=
 (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/tty/serial/mxs-auart.c | 4 ----=0A 1 file changed, 4 deletions(-)=
=0A=0Adiff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-=
auart.c=0Aindex 63810eefa44b..89d64bec34bc 100644=0A--- a/drivers/tty/seria=
l/mxs-auart.c=0A+++ b/drivers/tty/serial/mxs-auart.c=0A@@ -1686,10 +1686,6 =
@@ static int mxs_auart_probe(struct platform_device *pdev)=0A =0A 	s->port=
=2Emapbase =3D r->start;=0A 	s->port.membase =3D ioremap(r->start, resource=
_size(r));=0A-	if (!s->port.membase) {=0A-		ret =3D -ENOMEM;=0A-		goto out_=
disable_clks;=0A-	}=0A 	s->port.ops =3D &mxs_auart_ops;=0A 	s->port.iotype =
=3D UPIO_MEM;=0A 	s->port.fifosize =3D MXS_AUART_FIFO_SIZE;=0A-- =0A2.30.2=
=0A=0A=0AFrom 1c897984f92cf2ff735424a06d447ff39f4d088b Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:31:19 +0100=0ASubject: [PATCH 72/94] Revert "serial: mvebu-uart:=
 Fix to avoid a potential=0A NULL pointer dereference"=0A=0AThis reverts co=
mmit b1e660c6f8026d52a54ea64288be4a3726fc3394.=0A=0ACommits from @umn.edu a=
ddresses have been found to be submitted in "bad=0Afaith" to try to test th=
e kernel community's ability to review "known=0Amalicious" changes.  The re=
sult of these submissions can be found in a=0Apaper published at the 42nd I=
EEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: =
Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by =
Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minneso=
ta).=0A=0ABecause of this, all submissions from this group must be reverted=
 from=0Athe kernel tree and will need to be re-reviewed again to determine =
if=0Athey actually are a valid fix.  Until that work is complete, remove th=
is=0Achange to ensure that no problems are being introduced into the=0Acode=
base.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A--=
-=0A drivers/tty/serial/mvebu-uart.c | 3 ---=0A 1 file changed, 3 deletions=
(-)=0A=0Adiff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/=
mvebu-uart.c=0Aindex 330522be708f..0515b5e6326d 100644=0A--- a/drivers/tty/=
serial/mvebu-uart.c=0A+++ b/drivers/tty/serial/mvebu-uart.c=0A@@ -807,9 +80=
7,6 @@ static int mvebu_uart_probe(struct platform_device *pdev)=0A 		retur=
n -EINVAL;=0A 	}=0A =0A-	if (!match)=0A-		return -ENODEV;=0A-=0A 	/* Assume=
 that all UART ports have a DT alias or none has */=0A 	id =3D of_alias_get=
_id(pdev->dev.of_node, "serial");=0A 	if (!pdev->dev.of_node || id < 0)=0A-=
- =0A2.30.2=0A=0A=0AFrom fa76343c87870742eb0faa6e96efce4483312576 Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 20:31:20 +0100=0ASubject: [PATCH 73/94] Revert "qlcnic: =
Avoid potential NULL pointer=0A dereference"=0A=0AThis reverts commit fc055=
dffa5751859f5043f1c1e91bfafe2c6a6e9.=0A=0ACommits from @umn.edu addresses h=
ave been found to be submitted in "bad=0Afaith" to try to test the kernel c=
ommunity's ability to review "known=0Amalicious" changes.  The result of th=
ese submissions can be found in a=0Apaper published at the 42nd IEEE Sympos=
ium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily=
 Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu =
(University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0A=
Because of this, all submissions from this group must be reverted from=0Ath=
e kernel tree and will need to be re-reviewed again to determine if=0Athey =
actually are a valid fix.  Until that work is complete, remove this=0Achang=
e to ensure that no problems are being introduced into the=0Acodebase.=0A=
=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A dri=
vers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 --=0A 1 file changed, =
2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_=
ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0Aindex a4c=
d6f2cfb86..3b0adda7cc9c 100644=0A--- a/drivers/net/ethernet/qlogic/qlcnic/q=
lcnic_ethtool.c=0A+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=
=0A@@ -1048,8 +1048,6 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapt=
er, u8 mode)=0A =0A 	for (i =3D 0; i < QLCNIC_NUM_ILB_PKT; i++) {=0A 		skb =
=3D netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);=0A-		if (!skb)=
=0A-			break;=0A 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr=
);=0A 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);=0A 		adapter->ahw->diag_cnt =3D =
0;=0A-- =0A2.30.2=0A=0A=0AFrom 589a2050683fc88c3ee6d06bf85c2c0a96712b5c Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:20 +0100=0ASubject: [PATCH 74/94] Revert "t=
ty: atmel_serial: fix a potential NULL pointer=0A dereference"=0A=0AThis re=
verts commit b9bbd1edddf74701d51a50ca476fa7101655b693.=0A=0ACommits from @u=
mn.edu addresses have been found to be submitted in "bad=0Afaith" to try to=
 test the kernel community's ability to review "known=0Amalicious" changes.=
  The result of these submissions can be found in a=0Apaper published at th=
e 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Inse=
curity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" wri=
tten by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of=
 Minnesota).=0A=0ABecause of this, all submissions from this group must be =
reverted from=0Athe kernel tree and will need to be re-reviewed again to de=
termine if=0Athey actually are a valid fix.  Until that work is complete, r=
emove this=0Achange to ensure that no problems are being introduced into th=
e=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0A---=0A drivers/tty/serial/atmel_serial.c | 4 ----=0A 1 file changed, =
4 deletions(-)=0A=0Adiff --git a/drivers/tty/serial/atmel_serial.c b/driver=
s/tty/serial/atmel_serial.c=0Aindex 936d401f20b9..f565e191f63f 100644=0A---=
 a/drivers/tty/serial/atmel_serial.c=0A+++ b/drivers/tty/serial/atmel_seria=
l.c=0A@@ -1168,10 +1168,6 @@ static int atmel_prepare_rx_dma(struct uart_po=
rt *port)=0A 					 sg_dma_len(&atmel_port->sg_rx)/2,=0A 					 DMA_DEV_TO_ME=
M,=0A 					 DMA_PREP_INTERRUPT);=0A-	if (!desc) {=0A-		dev_err(port->dev, "=
Preparing DMA cyclic failed\n");=0A-		goto chan_err;=0A-	}=0A 	desc->callba=
ck =3D atmel_complete_rx_dma;=0A 	desc->callback_param =3D port;=0A 	atmel_=
port->desc_rx =3D desc;=0A-- =0A2.30.2=0A=0A=0AFrom 583cd75aaa4822ca5046d98=
2652582536d20a76b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:20 +0100=0ASubject: [PA=
TCH 75/94] Revert "scsi: qla4xxx: fix a potential NULL pointer=0A dereferen=
ce"=0A=0AThis reverts commit 4135e588274e7b8ddeea95683f9d70f19d019f2e.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/scsi/qla4xxx/ql4_os.c | 2 --=0A 1 f=
ile changed, 2 deletions(-)=0A=0Adiff --git a/drivers/scsi/qla4xxx/ql4_os.c=
 b/drivers/scsi/qla4xxx/ql4_os.c=0Aindex 4ba9f46fcf74..57f045ea786e 100644=
=0A--- a/drivers/scsi/qla4xxx/ql4_os.c=0A+++ b/drivers/scsi/qla4xxx/ql4_os.=
c=0A@@ -3204,8 +3204,6 @@ static int qla4xxx_conn_bind(struct iscsi_cls_ses=
sion *cls_session,=0A 	if (iscsi_conn_bind(cls_session, cls_conn, is_leadin=
g))=0A 		return -EINVAL;=0A 	ep =3D iscsi_lookup_endpoint(transport_fd);=0A=
-	if (!ep)=0A-		return -EINVAL;=0A 	conn =3D cls_conn->dd_data;=0A 	qla_con=
n =3D conn->dd_data;=0A 	qla_conn->qla_ep =3D ep->dd_data;=0A-- =0A2.30.2=
=0A=0A=0AFrom 603f9c12c4a5eee8b35925eda4ecdcb35358b8ce Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:31:20 +0100=0ASubject: [PATCH 76/94] Revert "libnvdimm/btt: Fix =
a kmemdup failure check"=0A=0AThis reverts commit af5b7a150ef8d8f7de063be78=
b591054d041e9cd.=0A=0ACommits from @umn.edu addresses have been found to be=
 submitted in "bad=0Afaith" to try to test the kernel community's ability t=
o review "known=0Amalicious" changes.  The result of these submissions can =
be found in a=0Apaper published at the 42nd IEEE Symposium on Security and =
Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulne=
rabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Min=
nesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all=
 submissions from this group must be reverted from=0Athe kernel tree and wi=
ll need to be re-reviewed again to determine if=0Athey actually are a valid=
 fix.  Until that work is complete, remove this=0Achange to ensure that no =
problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/btt_devs.c=
 | 18 +++++-------------=0A 1 file changed, 5 insertions(+), 13 deletions(-=
)=0A=0Adiff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c=
=0Aindex 9486acc08402..b72a303176c7 100644=0A--- a/drivers/nvdimm/btt_devs.=
c=0A+++ b/drivers/nvdimm/btt_devs.c=0A@@ -198,15 +198,14 @@ static struct d=
evice *__nd_btt_create(struct nd_region *nd_region,=0A 		return NULL;=0A =
=0A 	nd_btt->id =3D ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);=
=0A-	if (nd_btt->id < 0)=0A-		goto out_nd_btt;=0A+	if (nd_btt->id < 0) {=0A=
+		kfree(nd_btt);=0A+		return NULL;=0A+	}=0A =0A 	nd_btt->lbasize =3D lbasi=
ze;=0A-	if (uuid) {=0A+	if (uuid)=0A 		uuid =3D kmemdup(uuid, 16, GFP_KERNE=
L);=0A-		if (!uuid)=0A-			goto out_put_id;=0A-	}=0A 	nd_btt->uuid =3D uuid;=
=0A 	dev =3D &nd_btt->dev;=0A 	dev_set_name(dev, "btt%d.%d", nd_region->id,=
 nd_btt->id);=0A@@ -221,13 +220,6 @@ static struct device *__nd_btt_create(=
struct nd_region *nd_region,=0A 		return NULL;=0A 	}=0A 	return dev;=0A-=0A=
-out_put_id:=0A-	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);=0A-=0A=
-out_nd_btt:=0A-	kfree(nd_btt);=0A-	return NULL;=0A }=0A =0A struct device =
*nd_btt_create(struct nd_region *nd_region)=0A-- =0A2.30.2=0A=0A=0AFrom ad6=
ed817372b5d823b990c77cfbf8e7014153598 Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:21 =
+0100=0ASubject: [PATCH 77/94] Revert "x86/hpet: Prevent potential NULL poi=
nter=0A dereference"=0A=0AThis reverts commit 30d9b740e2015c8ec7fe4329ba539=
574abb52d9e.=0A=0ACommits from @umn.edu addresses have been found to be sub=
mitted in "bad=0Afaith" to try to test the kernel community's ability to re=
view "known=0Amalicious" changes.  The result of these submissions can be f=
ound in a=0Apaper published at the 42nd IEEE Symposium on Security and Priv=
acy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabi=
lities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minneso=
ta) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all sub=
missions from this group must be reverted from=0Athe kernel tree and will n=
eed to be re-reviewed again to determine if=0Athey actually are a valid fix=
=2E  Until that work is complete, remove this=0Achange to ensure that no pr=
oblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A arch/x86/kernel/hpet.c | 2 =
--=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/arch/x86/kernel/hpet=
=2Ec b/arch/x86/kernel/hpet.c=0Aindex 1e3f1f140ffb..b0acb22e5a46 100644=0A-=
-- a/arch/x86/kernel/hpet.c=0A+++ b/arch/x86/kernel/hpet.c=0A@@ -909,8 +909=
,6 @@ int __init hpet_enable(void)=0A 		return 0;=0A =0A 	hpet_set_mapping(=
);=0A-	if (!hpet_virt_address)=0A-		return 0;=0A =0A 	/*=0A 	 * Read the pe=
riod and check for a sane value:=0A-- =0A2.30.2=0A=0A=0AFrom 5b5ae0c0c970ff=
e26cd056b32a3998dc73800f5e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:21 +0100=0ASub=
ject: [PATCH 78/94] Revert "staging: rtl8188eu: Fix potential NULL pointer=
=0A dereference of kcalloc"=0A=0AThis reverts commit d55bfd0746aeb4be950cf8=
0c25296a0675ac9199.=0A=0ACommits from @umn.edu addresses have been found to=
 be submitted in "bad=0Afaith" to try to test the kernel community's abilit=
y to review "known=0Amalicious" changes.  The result of these submissions c=
an be found in a=0Apaper published at the 42nd IEEE Symposium on Security a=
nd Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVu=
lnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof =
Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, =
all submissions from this group must be reverted from=0Athe kernel tree and=
 will need to be re-reviewed again to determine if=0Athey actually are a va=
lid fix.  Until that work is complete, remove this=0Achange to ensure that =
no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/rtl818=
8eu/core/rtw_xmit.c    |  9 ++-------=0A drivers/staging/rtl8188eu/include/=
rtw_xmit.h |  2 +-=0A drivers/staging/rtl8723bs/core/rtw_xmit.c    | 14 +++=
++++-------=0A drivers/staging/rtl8723bs/include/rtw_xmit.h |  2 +-=0A 4 fi=
les changed, 11 insertions(+), 16 deletions(-)=0A=0Adiff --git a/drivers/st=
aging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c=
=0Aindex c6a5b62cb363..f25fd2f9f528 100644=0A--- a/drivers/staging/rtl8188e=
u/core/rtw_xmit.c=0A+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0A@@ -1=
78,9 +178,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct =
adapter *padapter)=0A =0A 	pxmitpriv->free_xmit_extbuf_cnt =3D num_xmit_ext=
buf;=0A =0A-	res =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _FAIL)=
=0A-		goto exit;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(pxmi=
tpriv->hwxmits, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; i++)=
=0A@@ -1504,7 +1502,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, =
struct xmit_frame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_alloc_hw=
xmits(struct adapter *padapter)=0A+void rtw_alloc_hwxmits(struct adapter *p=
adapter)=0A {=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmitpriv =
=3D &padapter->xmitpriv;=0A@@ -1513,8 +1511,6 @@ s32 rtw_alloc_hwxmits(stru=
ct adapter *padapter)=0A =0A 	pxmitpriv->hwxmits =3D kcalloc(pxmitpriv->hwx=
mit_entry,=0A 				     sizeof(struct hw_xmit), GFP_KERNEL);=0A-	if (!pxmitp=
riv->hwxmits)=0A-		return _FAIL;=0A =0A 	hwxmits =3D pxmitpriv->hwxmits;=0A=
 =0A@@ -1522,7 +1518,6 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=
=0A 	hwxmits[1] .sta_queue =3D &pxmitpriv->vi_pending;=0A 	hwxmits[2] .sta_=
queue =3D &pxmitpriv->be_pending;=0A 	hwxmits[3] .sta_queue =3D &pxmitpriv-=
>bk_pending;=0A-	return _SUCCESS;=0A }=0A =0A void rtw_free_hwxmits(struct =
adapter *padapter)=0Adiff --git a/drivers/staging/rtl8188eu/include/rtw_xmi=
t.h b/drivers/staging/rtl8188eu/include/rtw_xmit.h=0Aindex ba7e15fbde72..78=
8f59c74ea1 100644=0A--- a/drivers/staging/rtl8188eu/include/rtw_xmit.h=0A++=
+ b/drivers/staging/rtl8188eu/include/rtw_xmit.h=0A@@ -336,7 +336,7 @@ s32 =
rtw_txframes_sta_ac_pending(struct adapter *padapter,=0A void rtw_init_hwxm=
its(struct hw_xmit *phwxmit, int entry);=0A s32 _rtw_init_xmit_priv(struct =
xmit_priv *pxmitpriv, struct adapter *padapter);=0A void _rtw_free_xmit_pri=
v(struct xmit_priv *pxmitpriv);=0A-s32 rtw_alloc_hwxmits(struct adapter *pa=
dapter);=0A+void rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_f=
ree_hwxmits(struct adapter *padapter);=0A s32 rtw_xmit(struct adapter *pada=
pter, struct sk_buff **pkt);=0A =0Adiff --git a/drivers/staging/rtl8723bs/c=
ore/rtw_xmit.c b/drivers/staging/rtl8723bs/core/rtw_xmit.c=0Aindex 16291de5=
c0d9..edb678190b4b 100644=0A--- a/drivers/staging/rtl8723bs/core/rtw_xmit.c=
=0A+++ b/drivers/staging/rtl8723bs/core/rtw_xmit.c=0A@@ -260,9 +260,7 @@ s3=
2 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter=
)=0A 		}=0A 	}=0A =0A-	res =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=
=3D _FAIL)=0A-		goto exit;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hw=
xmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i=
 < 4; i++) {=0A@@ -2146,7 +2144,7 @@ s32 rtw_xmit_classifier(struct adapter=
 *padapter, struct xmit_frame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 =
rtw_alloc_hwxmits(struct adapter *padapter)=0A+void rtw_alloc_hwxmits(struc=
t adapter *padapter)=0A {=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv=
 *pxmitpriv =3D &padapter->xmitpriv;=0A@@ -2157,8 +2155,10 @@ s32 rtw_alloc=
_hwxmits(struct adapter *padapter)=0A =0A 	pxmitpriv->hwxmits =3D rtw_zmall=
oc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry);=0A =0A-	if (!pxmitpri=
v->hwxmits)=0A-		return _FAIL;=0A+	if (pxmitpriv->hwxmits =3D=3D NULL) {=0A=
+		DBG_871X("alloc hwxmits fail!...\n");=0A+		return;=0A+	}=0A =0A 	hwxmits=
 =3D pxmitpriv->hwxmits;=0A =0A@@ -2204,7 +2204,7 @@ s32 rtw_alloc_hwxmits(=
struct adapter *padapter)=0A =0A 	}=0A =0A-	return _SUCCESS;=0A+=0A }=0A =
=0A void rtw_free_hwxmits(struct adapter *padapter)=0Adiff --git a/drivers/=
staging/rtl8723bs/include/rtw_xmit.h b/drivers/staging/rtl8723bs/include/rt=
w_xmit.h=0Aindex 021c72361fbb..a75b668d09a6 100644=0A--- a/drivers/staging/=
rtl8723bs/include/rtw_xmit.h=0A+++ b/drivers/staging/rtl8723bs/include/rtw_=
xmit.h=0A@@ -486,7 +486,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmi=
tpriv, struct adapter *padapter);=0A void _rtw_free_xmit_priv (struct xmit_=
priv *pxmitpriv);=0A =0A =0A-s32 rtw_alloc_hwxmits(struct adapter *padapter=
);=0A+void rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_free_hw=
xmits(struct adapter *padapter);=0A =0A =0A-- =0A2.30.2=0A=0A=0AFrom 5f35d2=
fdc31503247b6e16deb49bfbdc57f43cb2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:21 +01=
00=0ASubject: [PATCH 79/94] Revert "leds: lp5523: fix a missing check of re=
turn=0A value of lp55xx_read"=0A=0AThis reverts commit 0761f58c62d70742a20d=
7a9ee0dfaf8a7eed1e9e.=0A=0ACommits from @umn.edu addresses have been found =
to be submitted in "bad=0Afaith" to try to test the kernel community's abil=
ity to review "known=0Amalicious" changes.  The result of these submissions=
 can be found in a=0Apaper published at the 42nd IEEE Symposium on Security=
 and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0A=
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Ao=
f Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this=
, all submissions from this group must be reverted from=0Athe kernel tree a=
nd will need to be re-reviewed again to determine if=0Athey actually are a =
valid fix.  Until that work is complete, remove this=0Achange to ensure tha=
t no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/leds/leds-lp=
5523.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff=
 --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c=0Aindex fd=
64df5a57a5..a2e74feee2b2 100644=0A--- a/drivers/leds/leds-lp5523.c=0A+++ b/=
drivers/leds/leds-lp5523.c=0A@@ -318,9 +318,7 @@ static int lp5523_init_pro=
gram_engine(struct lp55xx_chip *chip)=0A =0A 	/* Let the programs run for c=
ouple of ms and check the engine status */=0A 	usleep_range(3000, 6000);=0A=
-	ret =3D lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A-	if (ret)=0A-		=
return ret;=0A+	lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A 	status &=
=3D LP5523_ENG_STATUS_MASK;=0A =0A 	if (status !=3D LP5523_ENG_STATUS_MASK)=
 {=0A-- =0A2.30.2=0A=0A=0AFrom 4ab0aec7b810a2981dce6329c30b7cd7adacd95d Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:31:22 +0100=0ASubject: [PATCH 80/94] Revert "m=
fd: mc13xxx: Fix a missing check of a=0A register-read failure"=0A=0AThis r=
everts commit 7fc59021c1f5e3ae88d3edd44cfbbe407d6e8909.=0A=0ACommits from @=
umn.edu addresses have been found to be submitted in "bad=0Afaith" to try t=
o test the kernel community's ability to review "known=0Amalicious" changes=
=2E  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/mfd/mc13xxx-core.c | 4 +---=0A 1 file changed, 1 in=
sertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/mfd/mc13xxx-core.c b/d=
rivers/mfd/mc13xxx-core.c=0Aindex d0bf50e3568d..f475e848252f 100644=0A--- a=
/drivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/mc13xxx-core.c=0A@@ -274,9 =
+274,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned i=
nt mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_ADC_WORKING;=0A =0A-	ret =
=3D mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A-	if (ret)=0A-		g=
oto out;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A =0A 	ad=
c0 =3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=0A 	       MC13XXX_ADC0_=
CHRGRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom b87530cb333b0233539dba793405e6251e5=
79e62 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:31:22 +0100=0ASubject: [PATCH 81/94] R=
evert "gdrom: fix a memory leak bug"=0A=0AThis reverts commit 711b2e7fc02fa=
2636be8079339bec123b485d106.=0A=0ACommits from @umn.edu addresses have been=
 found to be submitted in "bad=0Afaith" to try to test the kernel community=
's ability to review "known=0Amalicious" changes.  The result of these subm=
issions can be found in a=0Apaper published at the 42nd IEEE Symposium on S=
ecurity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introdu=
cing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univers=
ity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause =
of this, all submissions from this group must be reverted from=0Athe kernel=
 tree and will need to be re-reviewed again to determine if=0Athey actually=
 are a valid fix.  Until that work is complete, remove this=0Achange to ens=
ure that no problems are being introduced into the=0Acodebase.=0A=0ASigned-=
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/cdrom=
/gdrom.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/drivers/c=
drom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 72cd96a8eb19..ae3a7537cf0f 100=
644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/drivers/cdrom/gdrom.c=0A@@ -889,7=
 +889,6 @@ static void __exit exit_gdrom(void)=0A 	platform_device_unregist=
er(pd);=0A 	platform_driver_unregister(&gdrom_driver);=0A 	kfree(gd.toc);=
=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(init_gdrom);=0A-- =0A2.30.2=
=0A=0A=0AFrom aeaf93eee6434c36d28e457704aa60d84a5a1cc8 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:31:22 +0100=0ASubject: [PATCH 82/94] Revert "net: marvell: fix a=
 missing check of=0A acpi_match_device"=0A=0AThis reverts commit e3a5ee1382=
96040393c7d230ede7d1ddf2a661dc.=0A=0ACommits from @umn.edu addresses have b=
een found to be submitted in "bad=0Afaith" to try to test the kernel commun=
ity's ability to review "known=0Amalicious" changes.  The result of these s=
ubmissions can be found in a=0Apaper published at the 42nd IEEE Symposium o=
n Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Intr=
oducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Univ=
ersity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecau=
se of this, all submissions from this group must be reverted from=0Athe ker=
nel tree and will need to be re-reviewed again to determine if=0Athey actua=
lly are a valid fix.  Until that work is complete, remove this=0Achange to =
ensure that no problems are being introduced into the=0Acodebase.=0A=0ASign=
ed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c | 2 --=0A 1 file changed, 2 deletions=
(-)=0A=0Adiff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/dri=
vers/net/ethernet/marvell/mvpp2/mvpp2_main.c=0Aindex bc5cfe062b10..36ddea8e=
5ccb 100644=0A--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=0A+++ b=
/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=0A@@ -5131,8 +5131,6 @@ st=
atic int mvpp2_probe(struct platform_device *pdev)=0A 	if (has_acpi_compani=
on(&pdev->dev)) {=0A 		acpi_id =3D acpi_match_device(pdev->dev.driver->acpi=
_match_table,=0A 					    &pdev->dev);=0A-		if (!acpi_id)=0A-			return -EIN=
VAL;=0A 		priv->hw_version =3D (unsigned long)acpi_id->driver_data;=0A 	} e=
lse {=0A 		priv->hw_version =3D=0A-- =0A2.30.2=0A=0A=0AFrom ddc1cab429e2418=
67c9f194198a9b6116bb40d89 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:23 +0100=0ASubj=
ect: [PATCH 83/94] Revert "atl1e: checking the status of=0A atl1e_write_phy=
_reg"=0A=0AThis reverts commit a3ab332b4e1e94dbfc3b3d556d7720b2eecfef49.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/atheros/atl1e/atl1e_ma=
in.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff -=
-git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethern=
et/atheros/atl1e/atl1e_main.c=0Aindex 3164aad29bcf..9dc6da039a6d 100644=0A-=
-- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0A+++ b/drivers/net/et=
hernet/atheros/atl1e/atl1e_main.c=0A@@ -473,9 +473,7 @@ static void atl1e_m=
dio_write(struct net_device *netdev, int phy_id,=0A {=0A 	struct atl1e_adap=
ter *adapter =3D netdev_priv(netdev);=0A =0A-	if (atl1e_write_phy_reg(&adap=
ter->hw,=0A-				reg_num & MDIO_REG_ADDR_MASK, val))=0A-		netdev_err(netdev,=
 "write phy register failed\n");=0A+	atl1e_write_phy_reg(&adapter->hw, reg_=
num & MDIO_REG_ADDR_MASK, val);=0A }=0A =0A static int atl1e_mii_ioctl(stru=
ct net_device *netdev,=0A-- =0A2.30.2=0A=0A=0AFrom 34a06ea3a71ad1c276ab1533=
e70f90fd9c863e2c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:23 +0100=0ASubject: [PAT=
CH 84/94] Revert "net: dsa: bcm_sf2: Propagate error value from=0A mdio_wri=
te"=0A=0AThis reverts commit 8688658355ba0d6f37b76d4be488fda7073e9645.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/net/dsa/bcm_sf2.c | 7 ++++---=0A 1 =
file changed, 4 insertions(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net=
/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c=0Aindex 3deda0321c00..89c87db071=
a2 100644=0A--- a/drivers/net/dsa/bcm_sf2.c=0A+++ b/drivers/net/dsa/bcm_sf2=
=2Ec=0A@@ -305,10 +305,11 @@ static int bcm_sf2_sw_mdio_write(struct mii_bu=
s *bus, int addr, int regnum,=0A 	 * send them to our master MDIO bus contr=
oller=0A 	 */=0A 	if (addr =3D=3D BRCM_PSEUDO_PHY_ADDR && priv->indir_phy_m=
ask & BIT(addr))=0A-		return bcm_sf2_sw_indir_rw(priv, 0, addr, regnum, val=
);=0A+		bcm_sf2_sw_indir_rw(priv, 0, addr, regnum, val);=0A 	else=0A-		retu=
rn mdiobus_write_nested(priv->master_mii_bus, addr,=0A-				regnum, val);=0A=
+		mdiobus_write_nested(priv->master_mii_bus, addr, regnum, val);=0A+=0A+	r=
eturn 0;=0A }=0A =0A static irqreturn_t bcm_sf2_switch_0_isr(int irq, void =
*dev_id)=0A-- =0A2.30.2=0A=0A=0AFrom f4a9a102f63e938db14fee608deec275480c8b=
e9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:31:23 +0100=0ASubject: [PATCH 85/94] Re=
vert "net: stmicro: fix a missing check of=0A clk_prepare"=0A=0AThis revert=
s commit d29d4ccc4ee8e22c0e8ba0c6a223799d6e060e3f.=0A=0ACommits from @umn.e=
du addresses have been found to be submitted in "bad=0Afaith" to try to tes=
t the kernel community's ability to review "known=0Amalicious" changes.  Th=
e result of these submissions can be found in a=0Apaper published at the 42=
nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source Insecuri=
ty: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" written=
 by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Min=
nesota).=0A=0ABecause of this, all submissions from this group must be reve=
rted from=0Athe kernel tree and will need to be re-reviewed again to determ=
ine if=0Athey actually are a valid fix.  Until that work is complete, remov=
e this=0Achange to ensure that no problems are being introduced into the=0A=
codebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0A---=0A drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c | 4 +---=0A 1 f=
ile changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/e=
thernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/=
dwmac-sunxi.c=0Aindex 57694eada995..c0824c6fe86d 100644=0A--- a/drivers/net=
/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A+++ b/drivers/net/ethernet/stmicro=
/stmmac/dwmac-sunxi.c=0A@@ -59,9 +59,7 @@ static int sun7i_gmac_init(struct=
 platform_device *pdev, void *priv)=0A 		gmac->clk_enabled =3D 1;=0A 	} els=
e {=0A 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_MII_RATE);=0A-		ret =3D clk_=
prepare(gmac->tx_clk);=0A-		if (ret)=0A-			return ret;=0A+		clk_prepare(gma=
c->tx_clk);=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom b3a45f67a63=
d6f559f6bf27c27350944cd844b98 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:23 +0100=0A=
Subject: [PATCH 86/94] Revert "net: (cpts) fix a missing check of clk_prepa=
re"=0A=0AThis reverts commit 7d7519148362f6aa00c26de4bdbf381d3ec45259.=0A=
=0ACommits from @umn.edu addresses have been found to be submitted in "bad=
=0Afaith" to try to test the kernel community's ability to review "known=0A=
malicious" changes.  The result of these submissions can be found in a=0Apa=
per published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled=
, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hyp=
ocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangji=
e Lu (University of Minnesota).=0A=0ABecause of this, all submissions from =
this group must be reverted from=0Athe kernel tree and will need to be re-r=
eviewed again to determine if=0Athey actually are a valid fix.  Until that =
work is complete, remove this=0Achange to ensure that no problems are being=
 introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/ti/cpts.c | 4 +---=0A =
1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/ne=
t/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c=0Aindex 10b301e79086.=
=2E8b455ce2b14f 100644=0A--- a/drivers/net/ethernet/ti/cpts.c=0A+++ b/drive=
rs/net/ethernet/ti/cpts.c=0A@@ -571,9 +571,7 @@ struct cpts *cpts_create(st=
ruct device *dev, void __iomem *regs,=0A 		return ERR_CAST(cpts->refclk);=
=0A 	}=0A =0A-	ret =3D clk_prepare(cpts->refclk);=0A-	if (ret)=0A-		return =
ERR_PTR(ret);=0A+	clk_prepare(cpts->refclk);=0A =0A 	cpts->cc.read =3D cpts=
_systim_read;=0A 	cpts->cc.mask =3D CLOCKSOURCE_MASK(32);=0A-- =0A2.30.2=0A=
=0A=0AFrom 853e90f74a2ccbc271a3009177be50af4e6d8f22 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:31:24 +0100=0ASubject: [PATCH 87/94] Revert "net/net_namespace: Che=
ck the return value of=0A register_pernet_subsys()"=0A=0AThis reverts commi=
t bb76fe3f703bf000dcbbb8757c3fbf5f4ee92f2b.=0A=0ACommits from @umn.edu addr=
esses have been found to be submitted in "bad=0Afaith" to try to test the k=
ernel community's ability to review "known=0Amalicious" changes.  The resul=
t of these submissions can be found in a=0Apaper published at the 42nd IEEE=
 Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Ste=
althily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiu=
shi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota)=
=2E=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A net/core/net_namespace.c | 3 +--=0A 1 file changed, 1 insertion(+), 2=
 deletions(-)=0A=0Adiff --git a/net/core/net_namespace.c b/net/core/net_nam=
espace.c=0Aindex c60123dff803..6dab186d4b8f 100644=0A--- a/net/core/net_nam=
espace.c=0A+++ b/net/core/net_namespace.c=0A@@ -913,8 +913,7 @@ static int =
__init net_ns_init(void)=0A 	init_net_initialized =3D true;=0A 	up_write(&p=
ernet_ops_rwsem);=0A =0A-	if (register_pernet_subsys(&net_ns_ops))=0A-		pan=
ic("Could not register network namespace subsystems");=0A+	register_pernet_=
subsys(&net_ns_ops);=0A =0A 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net=
_newid, NULL,=0A 		      RTNL_FLAG_DOIT_UNLOCKED);=0A-- =0A2.30.2=0A=0A=0AF=
rom c53d2f169fbc1183ebc1408dcc1761ed9a971011 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:31:24 +0100=0ASubject: [PATCH 88/94] Revert "drivers/regulator: fix a miss=
ing check of=0A return value"=0A=0AThis reverts commit 6e5176f52017ee5c3a7a=
1baca56367fcff3095b8.=0A=0ACommits from @umn.edu addresses have been found =
to be submitted in "bad=0Afaith" to try to test the kernel community's abil=
ity to review "known=0Amalicious" changes.  The result of these submissions=
 can be found in a=0Apaper published at the 42nd IEEE Symposium on Security=
 and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0A=
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Ao=
f Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this=
, all submissions from this group must be reverted from=0Athe kernel tree a=
nd will need to be re-reviewed again to determine if=0Athey actually are a =
valid fix.  Until that work is complete, remove this=0Achange to ensure tha=
t no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/regulator/pa=
lmas-regulator.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-=
)=0A=0Adiff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulato=
r/palmas-regulator.c=0Aindex c2cc392a27d4..bb5ab7d78895 100644=0A--- a/driv=
ers/regulator/palmas-regulator.c=0A+++ b/drivers/regulator/palmas-regulator=
=2Ec=0A@@ -443,16 +443,13 @@ static int palmas_ldo_write(struct palmas *pal=
mas, unsigned int reg,=0A static int palmas_set_mode_smps(struct regulator_=
dev *dev, unsigned int mode)=0A {=0A 	int id =3D rdev_get_id(dev);=0A-	int =
ret;=0A 	struct palmas_pmic *pmic =3D rdev_get_drvdata(dev);=0A 	struct pal=
mas_pmic_driver_data *ddata =3D pmic->palmas->pmic_ddata;=0A 	struct palmas=
_regs_info *rinfo =3D &ddata->palmas_regs_info[id];=0A 	unsigned int reg;=
=0A 	bool rail_enable =3D true;=0A =0A-	ret =3D palmas_smps_read(pmic->palm=
as, rinfo->ctrl_addr, &reg);=0A-	if (ret)=0A-		return ret;=0A+	palmas_smps_=
read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A =0A 	reg &=3D ~PALMAS_SMPS12=
_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.2=0A=0A=0AFrom c7fc5ed292c3983bd9c=
dd24c48acde3f04a98965 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:24 +0100=0ASubject:=
 [PATCH 89/94] Revert "hwmon: (lm80) fix a missing check of bus read=0A in =
lm80 probe"=0A=0AThis reverts commit 040f76976ec5cb332ccdcc734d1c485d87e803=
a4.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
 "bad=0Afaith" to try to test the kernel community's ability to review "kno=
wn=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/hwmon/lm80.c | 11 ++--------=
-=0A 1 file changed, 2 insertions(+), 9 deletions(-)=0A=0Adiff --git a/driv=
ers/hwmon/lm80.c b/drivers/hwmon/lm80.c=0Aindex f9b8e3e23a8e..dc2bd82b3202 =
100644=0A--- a/drivers/hwmon/lm80.c=0A+++ b/drivers/hwmon/lm80.c=0A@@ -630,=
7 +630,6 @@ static int lm80_probe(struct i2c_client *client,=0A 	struct dev=
ice *dev =3D &client->dev;=0A 	struct device *hwmon_dev;=0A 	struct lm80_da=
ta *data;=0A-	int rv;=0A =0A 	data =3D devm_kzalloc(dev, sizeof(struct lm80=
_data), GFP_KERNEL);=0A 	if (!data)=0A@@ -643,14 +642,8 @@ static int lm80_=
probe(struct i2c_client *client,=0A 	lm80_init_client(client);=0A =0A 	/* A=
 few vars need to be filled upon startup */=0A-	rv =3D lm80_read_value(clie=
nt, LM80_REG_FAN_MIN(1));=0A-	if (rv < 0)=0A-		return rv;=0A-	data->fan[f_m=
in][0] =3D rv;=0A-	rv =3D lm80_read_value(client, LM80_REG_FAN_MIN(2));=0A-=
	if (rv < 0)=0A-		return rv;=0A-	data->fan[f_min][1] =3D rv;=0A+	data->fan[=
f_min][0] =3D lm80_read_value(client, LM80_REG_FAN_MIN(1));=0A+	data->fan[f=
_min][1] =3D lm80_read_value(client, LM80_REG_FAN_MIN(2));=0A =0A 	hwmon_de=
v =3D devm_hwmon_device_register_with_groups(dev, client->name,=0A 							 =
  data, lm80_groups);=0A-- =0A2.30.2=0A=0A=0AFrom f1474bc8cd17926c4df418c2b=
77ff46cbfe0fda2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:25 +0100=0ASubject: [PATC=
H 90/94] Revert "libnvdimm/namespace: Fix a potential NULL=0A pointer deref=
erence"=0A=0AThis reverts commit e94f852e2034b6b64f1c4694cc72d3b5274d988d.=
=0A=0ACommits from @umn.edu addresses have been found to be submitted in "b=
ad=0Afaith" to try to test the kernel community's ability to review "known=
=0Amalicious" changes.  The result of these submissions can be found in a=
=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=0Aent=
itled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilities vi=
a Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota) and K=
angjie Lu (University of Minnesota).=0A=0ABecause of this, all submissions =
=66rom this group must be reverted from=0Athe kernel tree and will need to =
be re-reviewed again to determine if=0Athey actually are a valid fix.  Unti=
l that work is complete, remove this=0Achange to ensure that no problems ar=
e being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/namespace_devs.c | 5 =
+----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/d=
rivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c=0Aindex 63=
640c315d93..5bc6b522daee 100644=0A--- a/drivers/nvdimm/namespace_devs.c=0A+=
++ b/drivers/nvdimm/namespace_devs.c=0A@@ -2266,12 +2266,9 @@ static struct=
 device *create_namespace_blk(struct nd_region *nd_region,=0A 	if (!nsblk->=
uuid)=0A 		goto blk_err;=0A 	memcpy(name, nd_label->name, NSLABEL_NAME_LEN)=
;=0A-	if (name[0]) {=0A+	if (name[0])=0A 		nsblk->alt_name =3D kmemdup(name=
, NSLABEL_NAME_LEN,=0A 				GFP_KERNEL);=0A-		if (!nsblk->alt_name)=0A-			go=
to blk_err;=0A-	}=0A 	res =3D nsblk_add_resource(nd_region, ndd, nsblk,=0A =
			__le64_to_cpu(nd_label->dpa));=0A 	if (!res)=0A-- =0A2.30.2=0A=0A=0AFrom=
 2d8ef73f21bc12f2dd0032a800613a132d17181a Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31=
:25 +0100=0ASubject: [PATCH 91/94] Revert "niu: fix missing checks of niu_p=
ci_eeprom_read"=0A=0AThis reverts commit 4d6b5b08f19fe697f45f1d8962af3fc586=
7e421c.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
d in "bad=0Afaith" to try to test the kernel community's ability to review =
"known=0Amalicious" changes.  The result of these submissions can be found =
in a=0Apaper published at the 42nd IEEE Symposium on Security and Privacy=
=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabilit=
ies via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota)=
 and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submis=
sions from this group must be reverted from=0Athe kernel tree and will need=
 to be re-reviewed again to determine if=0Athey actually are a valid fix.  =
Until that work is complete, remove this=0Achange to ensure that no problem=
s are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/sun/niu.c |=
 10 ++--------=0A 1 file changed, 2 insertions(+), 8 deletions(-)=0A=0Adiff=
 --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c=0A=
index 602a2025717a..c225118dd599 100644=0A--- a/drivers/net/ethernet/sun/ni=
u.c=0A+++ b/drivers/net/ethernet/sun/niu.c=0A@@ -8098,8 +8098,6 @@ static i=
nt niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)=0A 		start +=
=3D 3;=0A =0A 		prop_len =3D niu_pci_eeprom_read(np, start + 4);=0A-		if (p=
rop_len < 0)=0A-			return prop_len;=0A 		err =3D niu_pci_vpd_get_propname(n=
p, start + 5, namebuf, 64);=0A 		if (err < 0)=0A 			return err;=0A@@ -8144,=
12 +8142,8 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 start, =
u32 end)=0A 			netif_printk(np, probe, KERN_DEBUG, np->dev,=0A 				     "VP=
D_SCAN: Reading in property [%s] len[%d]\n",=0A 				     namebuf, prop_len)=
;=0A-			for (i =3D 0; i < prop_len; i++) {=0A-				err =3D niu_pci_eeprom_re=
ad(np, off + i);=0A-				if (err >=3D 0)=0A-					*prop_buf =3D err;=0A-				+=
+prop_buf;=0A-			}=0A+			for (i =3D 0; i < prop_len; i++)=0A+				*prop_buf+=
+ =3D niu_pci_eeprom_read(np, off + i);=0A 		}=0A =0A 		start +=3D len;=0A-=
- =0A2.30.2=0A=0A=0AFrom c58c05a316e25dcfd8d175a56b6f6aeb811621ec Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 20:31:25 +0100=0ASubject: [PATCH 92/94] Revert "net: net=
xen: fix a missing check and an=0A uninitialized use"=0A=0AThis reverts com=
mit 2fb13e2004e81c7e03700726642c2dbb271c64e8.=0A=0ACommits from @umn.edu ad=
dresses have been found to be submitted in "bad=0Afaith" to try to test the=
 kernel community's ability to review "known=0Amalicious" changes.  The res=
ult of these submissions can be found in a=0Apaper published at the 42nd IE=
EE Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: S=
tealthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Q=
iushi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesot=
a).=0A=0ABecause of this, all submissions from this group must be reverted =
=66rom=0Athe kernel tree and will need to be re-reviewed again to determine=
 if=0Athey actually are a valid fix.  Until that work is complete, remove t=
his=0Achange to ensure that no problems are being introduced into the=0Acod=
ebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A-=
--=0A drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 3 +--=0A 1 fil=
e changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/net/eth=
ernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/=
netxen_nic_init.c=0Aindex 6547a9dd5935..0ea141ece19e 100644=0A--- a/drivers=
/net/ethernet/qlogic/netxen/netxen_nic_init.c=0A+++ b/drivers/net/ethernet/=
qlogic/netxen/netxen_nic_init.c=0A@@ -1125,8 +1125,7 @@ netxen_validate_fir=
mware(struct netxen_adapter *adapter)=0A 		return -EINVAL;=0A 	}=0A 	val =
=3D nx_get_bios_version(adapter);=0A-	if (netxen_rom_fast_read(adapter, NX_=
BIOS_VERSION_OFFSET, (int *)&bios))=0A-		return -EIO;=0A+	netxen_rom_fast_r=
ead(adapter, NX_BIOS_VERSION_OFFSET, (int *)&bios);=0A 	if ((__force u32)va=
l !=3D bios) {=0A 		dev_err(&pdev->dev, "%s: firmware bios is incompatible\=
n",=0A 				fw_name[fw_type]);=0A-- =0A2.30.2=0A=0A=0AFrom 8a7dc598598f8fbfd=
26c32a235c7e7b24b2074bc Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:26 +0100=0ASubjec=
t: [PATCH 93/94] Revert "media: isif: fix a NULL pointer dereference=0A bug=
"=0A=0AThis reverts commit 1adde6589b4af8a010eeef2170165856edbc6d9a.=0A=0AC=
ommits from @umn.edu addresses have been found to be submitted in "bad=0Afa=
ith" to try to test the kernel community's ability to review "known=0Amalic=
ious" changes.  The result of these submissions can be found in a=0Apaper p=
ublished at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Op=
en Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocrit=
e Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu =
(University of Minnesota).=0A=0ABecause of this, all submissions from this =
group must be reverted from=0Athe kernel tree and will need to be re-review=
ed again to determine if=0Athey actually are a valid fix.  Until that work =
is complete, remove this=0Achange to ensure that no problems are being intr=
oduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0A---=0A drivers/media/platform/davinci/isif.c | 3 +--=0A=
 1 file changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/m=
edia/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c=0Ainde=
x 80fa60a4c448..209338670ff9 100644=0A--- a/drivers/media/platform/davinci/=
isif.c=0A+++ b/drivers/media/platform/davinci/isif.c=0A@@ -1091,8 +1091,7 @=
@ static int isif_probe(struct platform_device *pdev)=0A =0A 	while (i >=3D=
 0) {=0A 		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);=0A-		if =
(res)=0A-			release_mem_region(res->start, resource_size(res));=0A+		releas=
e_mem_region(res->start, resource_size(res));=0A 		i--;=0A 	}=0A 	vpfe_unre=
gister_ccdc_device(&isif_hw_dev);=0A-- =0A2.30.2=0A=0A=0AFrom 7ba788c9e5a42=
3de301f3db0962b7b763d531b4a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:31:26 +0100=0ASu=
bject: [PATCH 94/94] Revert "dm ioctl: harden copy_params()'s=0A copy_from_=
user() from malicious users"=0A=0AThis reverts commit b42128078cfc1c84a5354=
7d31126fdb2e188b9cb.=0A=0ACommits from @umn.edu addresses have been found t=
o be submitted in "bad=0Afaith" to try to test the kernel community's abili=
ty to review "known=0Amalicious" changes.  The result of these submissions =
can be found in a=0Apaper published at the 42nd IEEE Symposium on Security =
and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AV=
ulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof=
 Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this,=
 all submissions from this group must be reverted from=0Athe kernel tree an=
d will need to be re-reviewed again to determine if=0Athey actually are a v=
alid fix.  Until that work is complete, remove this=0Achange to ensure that=
 no problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/dm-ioctl.c=
 | 18 ++++++++++++------=0A 1 file changed, 12 insertions(+), 6 deletions(-=
)=0A=0Adiff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c=0Aindex 1=
7cbad58834f..a892994e2114 100644=0A--- a/drivers/md/dm-ioctl.c=0A+++ b/driv=
ers/md/dm-ioctl.c=0A@@ -1721,7 +1721,8 @@ static void free_params(struct dm=
_ioctl *param, size_t param_size, int param_fla=0A }=0A =0A static int copy=
_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,=0A-		 =
      int ioctl_flags, struct dm_ioctl **param, int *param_flags)=0A+		    =
   int ioctl_flags,=0A+		       struct dm_ioctl **param, int *param_flags)=
=0A {=0A 	struct dm_ioctl *dmi;=0A 	int secure_data;=0A@@ -1762,13 +1763,18=
 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *p=
aram_kern=0A =0A 	*param_flags |=3D DM_PARAMS_MALLOC;=0A =0A-	/* Copy from =
param_kernel (which was already copied from user) */=0A-	memcpy(dmi, param_=
kernel, minimum_data_size);=0A-=0A-	if (copy_from_user(&dmi->data, (char __=
user *)user + minimum_data_size,=0A-			   param_kernel->data_size - minimum=
_data_size))=0A+	if (copy_from_user(dmi, user, param_kernel->data_size))=0A=
 		goto bad;=0A+=0A data_copied:=0A+	/*=0A+	 * Abort if something changed t=
he ioctl data while it was being copied.=0A+	 */=0A+	if (dmi->data_size !=
=3D param_kernel->data_size) {=0A+		DMERR("rejecting ioctl: data size modif=
ied while processing parameters");=0A+		goto bad;=0A+	}=0A+=0A 	/* Wipe the=
 user buffer so we do not return it to userspace */=0A 	if (secure_data && =
clear_user(user, param_kernel->data_size))=0A 		goto bad;=0A-- =0A2.30.2=0A=
=0A
--PXjQmd8Pn6vUPwpT--
