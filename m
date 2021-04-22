Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF0B3679D9
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhDVGYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhDVGYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:24:03 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11C6C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:23:28 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so2454270wmf.3
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X60MYdR6l/kA1s8XN5aq3MuGnngg9jD+PQXUlxNyZpY=;
        b=cgoEw6XIwKYue0NyTS/Nyhprt/74ZnhiIs5QgoPZO5IICsEKKo6ma3jJDrTB1HUOIB
         9yX1/A/H+h+q1ajyky8ohGRfXPVEA5lBvrR95nQ7clgJpt2g62I+WAP+z7b8DB/68yK5
         XPVIb1/cw1JQA9aZyOhjdns88WxxmhSygSNsxcaOTkDNZQwY8V83usze1xfuj8TBzItC
         lYG+KMztN5GYGDtiztqXJGWd4r1i+Y0EmNqJE8XGfaJqRH7j/mUvdXFGDP2F2OIiFDtX
         dxgg2pvvlDgD6XEbGKC2YYc73ZJ4uYZjDq3MqDwcX6CiYrblp2NDmychn/T99gShgtcc
         fL0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X60MYdR6l/kA1s8XN5aq3MuGnngg9jD+PQXUlxNyZpY=;
        b=VInezBllzXCif/wdKl9b3g7zn2qODIXdblM4T4ZtBbTtvEXfAPSqQOG57/0InZ6AJB
         iP73+3Hlku61it06xdPVyz6prACoCXNEDP/Zqf1HJ7evnbSgsEHVtijQEuFTdps2LmHV
         gt+lPiQCywxAMzKxTH/w3/AMoYWe6PPB7yTuljgZ7RX0VxIuqfpwL9cG+LN6KnpbaOyh
         Op7qmJgLdahoG3TEtobbBIlCrc915C/DAztZ1kT961Mdw/6gOTRP6RLT7AhO2iIvl2ms
         J+5H+lZWsXJ1NczCWoRylKz1zMtn3MvZXAZwRJ6fn7i9ASOoHVuGNZcy0e95ZR6hGj55
         Uplg==
X-Gm-Message-State: AOAM533E4fJl7ktWINtQQOVIamOkOGAKCC7mwN1BbkBeK1m+4KQb9jvl
        ZPGM62hlS/MThMYSPcLQuWsa0rJgpG2BHA==
X-Google-Smtp-Source: ABdhPJwwPyGTKVtkpkAJaJyFDhuAAVtDGmTnqkk+7RCyQU3yKRNQ8CgpJ7fxpJ9MKtjtDrn2Khgihw==
X-Received: by 2002:a05:600c:4f56:: with SMTP id m22mr1918878wmq.19.1619072607461;
        Wed, 21 Apr 2021 23:23:27 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id s16sm4540773wmh.11.2021.04.21.23.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:23:26 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:23:24 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v4.4.y
Message-ID: <YIEWXDKoPlaLq5Z5@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ROH1Jd7SpI6hpcgh"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ROH1Jd7SpI6hpcgh
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

--ROH1Jd7SpI6hpcgh
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v4.4.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 6cd44455b96b6e587b8901a0d2f1bb100278ef16 Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:42:29 +0100=0ASubject: [PATCH 01/54] Revert "drm/nouveau: fix multipl=
e instances of=0A reference count leaks"=0A=0AThis reverts commit 0739a93a0=
a9b9d2af1bdc904fd2a485ec71926a1.=0A=0ACommits from @umn.edu addresses have =
been found to be submitted in "bad=0Afaith" to try to test the kernel commu=
nity's ability to review "known=0Amalicious" changes.  The result of these =
submissions can be found in a=0Apaper published at the 42nd IEEE Symposium =
on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Int=
roducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Uni=
versity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABeca=
use of this, all submissions from this group must be reverted from=0Athe ke=
rnel tree and will need to be re-reviewed again to determine if=0Athey actu=
ally are a valid fix.  Until that work is complete, remove this=0Achange to=
 ensure that no problems are being introduced into the=0Acodebase.=0A=0ASig=
ned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/g=
pu/drm/nouveau/nouveau_drm.c | 8 ++------=0A drivers/gpu/drm/nouveau/nouvea=
u_gem.c | 4 +---=0A 2 files changed, 3 insertions(+), 9 deletions(-)=0A=0Ad=
iff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau=
/nouveau_drm.c=0Aindex a90840e39110..91a61d2cca88 100644=0A--- a/drivers/gp=
u/drm/nouveau/nouveau_drm.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c=
=0A@@ -805,10 +805,8 @@ nouveau_drm_open(struct drm_device *dev, struct drm=
_file *fpriv)=0A =0A 	/* need to bring up power immediately if opening devi=
ce */=0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if (ret < 0 && ret !=
=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	if (ret < 0 &=
& ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	get_task_comm(tmpname, c=
urrent);=0A 	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fpriv->=
pid));=0A@@ -896,10 +894,8 @@ nouveau_drm_ioctl(struct file *file, unsigned=
 int cmd, unsigned long arg)=0A 	long ret;=0A =0A 	ret =3D pm_runtime_get_s=
ync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_a=
utosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=
=0A-	}=0A =0A 	switch (_IOC_NR(cmd) - DRM_COMMAND_BASE) {=0A 	case DRM_NOUV=
EAU_NVIF:=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gp=
u/drm/nouveau/nouveau_gem.c=0Aindex e5db2a385cb6..ae560f5977fc 100644=0A---=
 a/drivers/gpu/drm/nouveau/nouveau_gem.c=0A+++ b/drivers/gpu/drm/nouveau/no=
uveau_gem.c=0A@@ -42,10 +42,8 @@ nouveau_gem_object_del(struct drm_gem_obje=
ct *gem)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (WAR=
N_ON(ret < 0 && ret !=3D -EACCES)) {=0A-		pm_runtime_put_autosuspend(dev);=
=0A+	if (WARN_ON(ret < 0 && ret !=3D -EACCES))=0A 		return;=0A-	}=0A =0A 	i=
f (gem->import_attach)=0A 		drm_prime_gem_destroy(gem, nvbo->bo.sg);=0A-- =
=0A2.30.2=0A=0A=0AFrom 26dad8e6e74187da2d5f1ebff04ca26373e4af92 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:42:29 +0100=0ASubject: [PATCH 02/54] Revert "drm/nouvea=
u/drm/noveau: fix reference count=0A leak in nouveau_fbcon_open"=0A=0AThis =
reverts commit 7592eb3b6cf80eaeb1e648a258a3031e95141f64.=0A=0ACommits from =
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
=2Ecom>=0A---=0A drivers/gpu/drm/nouveau/nouveau_fbcon.c | 4 +---=0A 1 file=
 changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/gpu/drm/=
nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0Aindex 1=
1183839f6fa..edb3a23ded5d 100644=0A--- a/drivers/gpu/drm/nouveau/nouveau_fb=
con.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0A@@ -184,10 +184,8 @=
@ nouveau_fbcon_open(struct fb_info *info, int user)=0A 	struct nouveau_fbd=
ev *fbcon =3D info->par;=0A 	struct nouveau_drm *drm =3D nouveau_drm(fbcon-=
>dev);=0A 	int ret =3D pm_runtime_get_sync(drm->dev->dev);=0A-	if (ret < 0 =
&& ret !=3D -EACCES) {=0A-		pm_runtime_put(drm->dev->dev);=0A+	if (ret < 0 =
&& ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A 	return 0;=0A }=0A =0A-- =0A=
2.30.2=0A=0A=0AFrom 3adb121864411685e24f749be29532bb9d44324e Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 20:42:29 +0100=0ASubject: [PATCH 03/54] Revert "PCI: Fix pci_=
create_slot() reference count=0A leak"=0A=0AThis reverts commit d22aec437d7=
71dc6b57b73ef14454a1aef44fa8c.=0A=0ACommits from @umn.edu addresses have be=
en found to be submitted in "bad=0Afaith" to try to test the kernel communi=
ty's ability to review "known=0Amalicious" changes.  The result of these su=
bmissions can be found in a=0Apaper published at the 42nd IEEE Symposium on=
 Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Intro=
ducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Unive=
rsity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecaus=
e of this, all submissions from this group must be reverted from=0Athe kern=
el tree and will need to be re-reviewed again to determine if=0Athey actual=
ly are a valid fix.  Until that work is complete, remove this=0Achange to e=
nsure that no problems are being introduced into the=0Acodebase.=0A=0ASigne=
d-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/pci=
/slot.c | 6 ++----=0A 1 file changed, 2 insertions(+), 4 deletions(-)=0A=0A=
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c=0Aindex 14d84d5a0f58..=
c29ad4bd4a3a 100644=0A--- a/drivers/pci/slot.c=0A+++ b/drivers/pci/slot.c=
=0A@@ -303,7 +303,6 @@ placeholder:=0A 	slot_name =3D make_slot_name(name);=
=0A 	if (!slot_name) {=0A 		err =3D -ENOMEM;=0A-		kfree(slot);=0A 		goto er=
r;=0A 	}=0A =0A@@ -312,10 +311,8 @@ placeholder:=0A =0A 	err =3D kobject_in=
it_and_add(&slot->kobj, &pci_slot_ktype, NULL,=0A 				   "%s", slot_name);=
=0A-	if (err) {=0A-		kobject_put(&slot->kobj);=0A+	if (err)=0A 		goto err;=
=0A-	}=0A =0A 	down_read(&pci_bus_sem);=0A 	list_for_each_entry(dev, &paren=
t->devices, bus_list)=0A@@ -331,6 +328,7 @@ out:=0A 	mutex_unlock(&pci_slot=
_mutex);=0A 	return slot;=0A err:=0A+	kfree(slot);=0A 	slot =3D ERR_PTR(err=
);=0A 	goto out;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 3413a65aeba3ff47bc0dec8b1=
6dc27ee3dffbdc9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:30 +0100=0ASubject: [PATC=
H 04/54] Revert "media: exynos4-is: Fix several reference count=0A leaks du=
e to pm_runtime_get_sync"=0A=0AThis reverts commit 2306e29e8813b3726a244aed=
91942487a3d1c0b8.=0A=0ACommits from @umn.edu addresses have been found to b=
e submitted in "bad=0Afaith" to try to test the kernel community's ability =
to review "known=0Amalicious" changes.  The result of these submissions can=
 be found in a=0Apaper published at the 42nd IEEE Symposium on Security and=
 Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVuln=
erabilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Mi=
nnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, al=
l submissions from this group must be reverted from=0Athe kernel tree and w=
ill need to be re-reviewed again to determine if=0Athey actually are a vali=
d fix.  Until that work is complete, remove this=0Achange to ensure that no=
 problems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/e=
xynos4-is/fimc-isp.c  | 4 +---=0A drivers/media/platform/exynos4-is/fimc-li=
te.c | 2 +-=0A 2 files changed, 2 insertions(+), 4 deletions(-)=0A=0Adiff -=
-git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platfor=
m/exynos4-is/fimc-isp.c=0Aindex ad280c5258b3..5d78f5716f3b 100644=0A--- a/d=
rivers/media/platform/exynos4-is/fimc-isp.c=0A+++ b/drivers/media/platform/=
exynos4-is/fimc-isp.c=0A@@ -311,10 +311,8 @@ static int fimc_isp_subdev_s_p=
ower(struct v4l2_subdev *sd, int on)=0A =0A 	if (on) {=0A 		ret =3D pm_runt=
ime_get_sync(&is->pdev->dev);=0A-		if (ret < 0) {=0A-			pm_runtime_put(&is-=
>pdev->dev);=0A+		if (ret < 0)=0A 			return ret;=0A-		}=0A 		set_bit(IS_ST_=
PWR_ON, &is->state);=0A =0A 		ret =3D fimc_is_start_firmware(is);=0Adiff --=
git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platfor=
m/exynos4-is/fimc-lite.c=0Aindex 65b33470a1b1..60660c3a5de0 100644=0A--- a/=
drivers/media/platform/exynos4-is/fimc-lite.c=0A+++ b/drivers/media/platfor=
m/exynos4-is/fimc-lite.c=0A@@ -487,7 +487,7 @@ static int fimc_lite_open(st=
ruct file *file)=0A 	set_bit(ST_FLITE_IN_USE, &fimc->state);=0A 	ret =3D pm=
_runtime_get_sync(&fimc->pdev->dev);=0A 	if (ret < 0)=0A-		goto err_pm;=0A+=
		goto unlock;=0A =0A 	ret =3D v4l2_fh_open(file);=0A 	if (ret < 0)=0A-- =
=0A2.30.2=0A=0A=0AFrom c3419ec563ed8ee557e38dead7760fc3d8a0e373 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:42:30 +0100=0ASubject: [PATCH 05/54] Revert "media: exy=
nos4-is: Fix a reference count leak=0A due to pm_runtime_get_sync"=0A=0AThi=
s reverts commit f3a48529951761916358d8ed924117bfb6fd223c.=0A=0ACommits fro=
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
il.com>=0A---=0A drivers/media/platform/exynos4-is/media-dev.c | 4 +---=0A =
1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/me=
dia/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/med=
ia-dev.c=0Aindex 76fadd3e3ada..6bc3c8a2e144 100644=0A--- a/drivers/media/pl=
atform/exynos4-is/media-dev.c=0A+++ b/drivers/media/platform/exynos4-is/med=
ia-dev.c=0A@@ -413,10 +413,8 @@ static int fimc_md_register_sensor_entities=
(struct fimc_md *fmd)=0A 		return -ENXIO;=0A =0A 	ret =3D pm_runtime_get_sy=
nc(fmd->pmf);=0A-	if (ret < 0) {=0A-		pm_runtime_put(fmd->pmf);=0A+	if (ret=
 < 0)=0A 		return ret;=0A-	}=0A =0A 	fmd->num_sensors =3D 0;=0A =0A-- =0A2.=
30.2=0A=0A=0AFrom 02bc6a635468e17ef67886d9d0ed8e4413dfa941 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:42:30 +0100=0ASubject: [PATCH 06/54] Revert "media: exynos4-=
is: Fix a reference count leak"=0A=0AThis reverts commit 144e4b3bc1a2f393ae=
21ce64b077171ef29d296c.=0A=0ACommits from @umn.edu addresses have been foun=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/pl=
atform/exynos4-is/mipi-csis.c | 4 +---=0A 1 file changed, 1 insertion(+), 3=
 deletions(-)=0A=0Adiff --git a/drivers/media/platform/exynos4-is/mipi-csis=
=2Ec b/drivers/media/platform/exynos4-is/mipi-csis.c=0Aindex 4f7a0f59f36c..=
4b85105dc159 100644=0A--- a/drivers/media/platform/exynos4-is/mipi-csis.c=
=0A+++ b/drivers/media/platform/exynos4-is/mipi-csis.c=0A@@ -513,10 +513,8 =
@@ static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)=0A 	if (=
enable) {=0A 		s5pcsis_clear_counters(state);=0A 		ret =3D pm_runtime_get_s=
ync(&state->pdev->dev);=0A-		if (ret && ret !=3D 1) {=0A-			pm_runtime_put_=
noidle(&state->pdev->dev);=0A+		if (ret && ret !=3D 1)=0A 			return ret;=0A=
-		}=0A 	}=0A =0A 	mutex_lock(&state->lock);=0A-- =0A2.30.2=0A=0A=0AFrom 36=
2df8d8d6b215fe954e88e906905b00b594981c Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:30=
 +0100=0ASubject: [PATCH 07/54] Revert "media: ti-vpe: Fix a missing check =
and=0A reference count leak"=0A=0AThis reverts commit 0d35b8ae3006001f4fc26=
0f87a1dcd81ce5f9c1c.=0A=0ACommits from @umn.edu addresses have been found t=
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
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platfor=
m/ti-vpe/vpe.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/d=
rivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c=0A=
index 8a3714bfb77e..b5f8c425cd2e 100644=0A--- a/drivers/media/platform/ti-v=
pe/vpe.c=0A+++ b/drivers/media/platform/ti-vpe/vpe.c=0A@@ -2135,8 +2135,6 @=
@ static int vpe_runtime_get(struct platform_device *pdev)=0A =0A 	r =3D pm=
_runtime_get_sync(&pdev->dev);=0A 	WARN_ON(r < 0);=0A-	if (r)=0A-		pm_runti=
me_put_noidle(&pdev->dev);=0A 	return r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.=
2=0A=0A=0AFrom 9410c5e81d140fb6b14dfea5b28b462f599104f5 Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:42:30 +0100=0ASubject: [PATCH 08/54] Revert "ASoC: tegra: Fix r=
eference count leaks."=0A=0AThis reverts commit ed36291b5c426b21210972dc8d2=
8f591e22294fc.=0A=0ACommits from @umn.edu addresses have been found to be s=
ubmitted in "bad=0Afaith" to try to test the kernel community's ability to =
review "known=0Amalicious" changes.  The result of these submissions can be=
 found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pr=
ivacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnera=
bilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minne=
sota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all s=
ubmissions from this group must be reverted from=0Athe kernel tree and will=
 need to be re-reviewed again to determine if=0Athey actually are a valid f=
ix.  Until that work is complete, remove this=0Achange to ensure that no pr=
oblems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/soc/tegra/tegra30_ahu=
b.c | 4 +---=0A sound/soc/tegra/tegra30_i2s.c  | 4 +---=0A 2 files changed,=
 2 insertions(+), 6 deletions(-)=0A=0Adiff --git a/sound/soc/tegra/tegra30_=
ahub.c b/sound/soc/tegra/tegra30_ahub.c=0Aindex e441e23a37e4..fef3b9a21a66 =
100644=0A--- a/sound/soc/tegra/tegra30_ahub.c=0A+++ b/sound/soc/tegra/tegra=
30_ahub.c=0A@@ -656,10 +656,8 @@ static int tegra30_ahub_resume(struct devi=
ce *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret=
 < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=
=0A 	ret =3D regcache_sync(ahub->regmap_ahub);=0A 	ret |=3D regcache_sync(a=
hub->regmap_apbif);=0A 	pm_runtime_put(dev);=0Adiff --git a/sound/soc/tegra=
/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c=0Aindex 516f37896092..8e5558=
3aa104 100644=0A--- a/sound/soc/tegra/tegra30_i2s.c=0A+++ b/sound/soc/tegra=
/tegra30_i2s.c=0A@@ -552,10 +552,8 @@ static int tegra30_i2s_resume(struct =
device *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if =
(ret < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-=
	}=0A 	ret =3D regcache_sync(i2s->regmap);=0A 	pm_runtime_put(dev);=0A =0A-=
- =0A2.30.2=0A=0A=0AFrom 2d76d1a55edfee81794539e5fda0525e14981da4 Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 20:42:31 +0100=0ASubject: [PATCH 09/54] Revert "iommu: F=
ix reference count leak in=0A iommu_group_alloc."=0A=0AThis reverts commit =
2996897d8b9bf1b42919300f392a891b4f925480.=0A=0ACommits from @umn.edu addres=
ses have been found to be submitted in "bad=0Afaith" to try to test the ker=
nel community's ability to review "known=0Amalicious" changes.  The result =
of these submissions can be found in a=0Apaper published at the 42nd IEEE S=
ymposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Steal=
thily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiush=
i Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A drivers/iommu/iommu.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 delet=
ion(-)=0A=0Adiff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c=0Ain=
dex a1e7a73930fa..589207176ffa 100644=0A--- a/drivers/iommu/iommu.c=0A+++ b=
/drivers/iommu/iommu.c=0A@@ -206,7 +206,7 @@ again:=0A 		mutex_lock(&iommu_=
group_mutex);=0A 		ida_remove(&iommu_group_ida, group->id);=0A 		mutex_unlo=
ck(&iommu_group_mutex);=0A-		kobject_put(&group->kobj);=0A+		kfree(group);=
=0A 		return ERR_PTR(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 0091878520=
9af1d9a42bd80392cfc8e1abf0e463 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:31 +0100=
=0ASubject: [PATCH 10/54] Revert "ACPI: sysfs: Fix reference count leak in=
=0A acpi_sysfs_add_hotplug_profile()"=0A=0AThis reverts commit 83df491ec01b=
226b690a84648f5757c4ee25089d.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/acpi=
/sysfs.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adi=
ff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c=0Aindex 13c308323e94=
=2E.00917731f4ed 100644=0A--- a/drivers/acpi/sysfs.c=0A+++ b/drivers/acpi/s=
ysfs.c=0A@@ -831,10 +831,8 @@ void acpi_sysfs_add_hotplug_profile(struct ac=
pi_hotplug_profile *hotplug,=0A =0A 	error =3D kobject_init_and_add(&hotplu=
g->kobj,=0A 		&acpi_hotplug_profile_ktype, hotplug_kobj, "%s", name);=0A-	i=
f (error) {=0A-		kobject_put(&hotplug->kobj);=0A+	if (error)=0A 		goto err_=
out;=0A-	}=0A =0A 	kobject_uevent(&hotplug->kobj, KOBJ_ADD);=0A 	return;=0A=
-- =0A2.30.2=0A=0A=0AFrom ed7b76149d6ce679595a6829904efad727dda717 Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 20:42:31 +0100=0ASubject: [PATCH 11/54] Revert "qlcnic:=
 fix missing release in=0A qlcnic_83xx_interrupt_test."=0A=0AThis reverts c=
ommit 1063d4e066a331fe435986bfedf4632ceb6878f9.=0A=0ACommits from @umn.edu =
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
--=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 +---=0A 1 fil=
e changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/eth=
ernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/q=
lcnic_83xx_hw.c=0Aindex 75ac5cc2fc23..7f7aea9758e7 100644=0A--- a/drivers/n=
et/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A+++ b/drivers/net/ethernet/qlo=
gic/qlcnic/qlcnic_83xx_hw.c=0A@@ -3609,7 +3609,7 @@ int qlcnic_83xx_interru=
pt_test(struct net_device *netdev)=0A 	ahw->diag_cnt =3D 0;=0A 	ret =3D qlc=
nic_alloc_mbx_args(&cmd, adapter, QLCNIC_CMD_INTRPT_TEST);=0A 	if (ret)=0A-=
		goto fail_mbx_args;=0A+		goto fail_diag_irq;=0A =0A 	if (adapter->flags &=
 QLCNIC_MSIX_ENABLED)=0A 		intrpt_id =3D ahw->intr_tbl[0].id;=0A@@ -3639,8 =
+3639,6 @@ int qlcnic_83xx_interrupt_test(struct net_device *netdev)=0A =0A=
 done:=0A 	qlcnic_free_mbx_args(&cmd);=0A-=0A-fail_mbx_args:=0A 	qlcnic_83x=
x_diag_free_res(netdev, drv_sds_rings);=0A =0A fail_diag_irq:=0A-- =0A2.30.=
2=0A=0A=0AFrom 38129bc72a7274f41396155f5c7763c43ce62e6f Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:42:31 +0100=0ASubject: [PATCH 12/54] Revert "usb: gadget: fix p=
otential double-free in=0A m66592_probe."=0A=0AThis reverts commit 4e26dd5e=
3f6746efbc681824360e680b02b76174.=0A=0ACommits from @umn.edu addresses have=
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
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/=
usb/gadget/udc/m66592-udc.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 del=
etion(-)=0A=0Adiff --git a/drivers/usb/gadget/udc/m66592-udc.c b/drivers/us=
b/gadget/udc/m66592-udc.c=0Aindex db95eab8b432..b1cfa96cc88f 100644=0A--- a=
/drivers/usb/gadget/udc/m66592-udc.c=0A+++ b/drivers/usb/gadget/udc/m66592-=
udc.c=0A@@ -1684,7 +1684,7 @@ static int m66592_probe(struct platform_devic=
e *pdev)=0A =0A err_add_udc:=0A 	m66592_free_request(&m66592->ep[0].ep, m66=
592->ep0_req);=0A-	m66592->ep0_req =3D NULL;=0A+=0A clean_up3:=0A 	if (m665=
92->pdata->on_chip) {=0A 		clk_disable(m66592->clk);=0A-- =0A2.30.2=0A=0A=
=0AFrom b3c80fb5e3d0ad4c2eeae58385fcc3e2a5621ae4 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:42:32 +0100=0ASubject: [PATCH 13/54] Revert "net/mlx4_core: fix a me=
mory leak bug."=0A=0AThis reverts commit 94926fb0d2fcd6426d4d59172a966422de=
91d9f0.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/mellanox/ml=
x4/fw.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff -=
-git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mella=
nox/mlx4/fw.c=0Aindex b6ae4b17555b..a106b1f214c3 100644=0A--- a/drivers/net=
/ethernet/mellanox/mlx4/fw.c=0A+++ b/drivers/net/ethernet/mellanox/mlx4/fw.=
c=0A@@ -2522,7 +2522,7 @@ void mlx4_opreq_action(struct work_struct *work)=
=0A 		if (err) {=0A 			mlx4_err(dev, "Failed to retrieve required operation=
: %d\n",=0A 				 err);=0A-			goto out;=0A+			return;=0A 		}=0A 		MLX4_GET(m=
odifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);=0A 		MLX4_GET(token, outbox, =
GET_OP_REQ_TOKEN_OFFSET);=0A-- =0A2.30.2=0A=0A=0AFrom 99da6eab5092579a61ab2=
de49d5cbbe6f444da82 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:32 +0100=0ASubject: [=
PATCH 14/54] Revert "agp/intel: Fix a memory leak on module=0A initialisati=
on failure"=0A=0AThis reverts commit ecef1cac30308a6975d0e6d41619839956a2d8=
57.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/char/agp/intel-gtt.c | 4 +--=
-=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drive=
rs/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c=0Aindex 3d11f5adb355=
=2E.76afc841232c 100644=0A--- a/drivers/char/agp/intel-gtt.c=0A+++ b/driver=
s/char/agp/intel-gtt.c=0A@@ -303,10 +303,8 @@ static int intel_gtt_setup_sc=
ratch_page(void)=0A 	if (intel_private.needs_dmar) {=0A 		dma_addr =3D pci_=
map_page(intel_private.pcidev, page, 0,=0A 				    PAGE_SIZE, PCI_DMA_BIDIR=
ECTIONAL);=0A-		if (pci_dma_mapping_error(intel_private.pcidev, dma_addr)) =
{=0A-			__free_page(page);=0A+		if (pci_dma_mapping_error(intel_private.pci=
dev, dma_addr))=0A 			return -EINVAL;=0A-		}=0A =0A 		intel_private.scratch=
_page_dma =3D dma_addr;=0A 	} else=0A-- =0A2.30.2=0A=0A=0AFrom a7e83d48a0b6=
31c1c37f893d1df4eb4d65f59979 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:32 +0100=0AS=
ubject: [PATCH 15/54] Revert "ecryptfs: replace BUG_ON with error handling=
=0A code"=0A=0AThis reverts commit bbd3d0f442864be4dae8e571c8865fbd35df9042=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A fs/ecryptfs/crypto.c | 6 ++----=0A 1=
 file changed, 2 insertions(+), 4 deletions(-)=0A=0Adiff --git a/fs/ecryptf=
s/crypto.c b/fs/ecryptfs/crypto.c=0Aindex 83e9f6272bfb..f246f1760ba2 100644=
=0A--- a/fs/ecryptfs/crypto.c=0A+++ b/fs/ecryptfs/crypto.c=0A@@ -346,10 +34=
6,8 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,=
=0A 	struct extent_crypt_result ecr;=0A 	int rc =3D 0;=0A =0A-	if (!crypt_s=
tat || !crypt_stat->tfm=0A-	       || !(crypt_stat->flags & ECRYPTFS_STRUCT=
_INITIALIZED))=0A-		return -EINVAL;=0A-=0A+	BUG_ON(!crypt_stat || !crypt_st=
at->tfm=0A+	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED));=
=0A 	if (unlikely(ecryptfs_verbosity > 0)) {=0A 		ecryptfs_printk(KERN_DEBU=
G, "Key size [%zd]; key:\n",=0A 				crypt_stat->key_size);=0A-- =0A2.30.2=
=0A=0A=0AFrom fd4d7bc85d8aeb35e60000130a00a9fcb9647d72 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:42:32 +0100=0ASubject: [PATCH 16/54] Revert "net: sun: fix missi=
ng release regions in=0A cas_init_one()."=0A=0AThis reverts commit 98770df2=
087a4466abf7008f5ab7c772f4ff7a92.=0A=0ACommits from @umn.edu addresses have=
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
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/=
net/ethernet/sun/cassini.c | 3 ++-=0A 1 file changed, 2 insertions(+), 1 de=
letion(-)=0A=0Adiff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/ne=
t/ethernet/sun/cassini.c=0Aindex bfe7b55f9714..062bce9acde6 100644=0A--- a/=
drivers/net/ethernet/sun/cassini.c=0A+++ b/drivers/net/ethernet/sun/cassini=
=2Ec=0A@@ -4980,7 +4980,7 @@ static int cas_init_one(struct pci_dev *pdev, =
const struct pci_device_id *ent)=0A 					  cas_cacheline_size)) {=0A 			dev=
_err(&pdev->dev, "Could not set PCI cache "=0A 			       "line size\n");=0A=
-			goto err_out_free_res;=0A+			goto err_write_cacheline;=0A 		}=0A 	}=0A =
#endif=0A@@ -5151,6 +5151,7 @@ err_out_iounmap:=0A err_out_free_res:=0A 	pc=
i_release_regions(pdev);=0A =0A+err_write_cacheline:=0A 	/* Try to restore =
it in case the error occurred after we=0A 	 * set it.=0A 	 */=0A-- =0A2.30.=
2=0A=0A=0AFrom a7423035e7887f9507f1e32af242e281139ed8b1 Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:42:32 +0100=0ASubject: [PATCH 17/54] Revert "efi/esrt: Fix refe=
rence count leak in=0A esre_create_sysfs_entry."=0A=0AThis reverts commit 8=
da5b2305f6244184f0debde4ff3029788f27228.=0A=0ACommits from @umn.edu address=
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
=0A drivers/firmware/efi/esrt.c | 2 +-=0A 1 file changed, 1 insertion(+), 1=
 deletion(-)=0A=0Adiff --git a/drivers/firmware/efi/esrt.c b/drivers/firmwa=
re/efi/esrt.c=0Aindex 4aaaccf95b36..341b8c686ec7 100644=0A--- a/drivers/fir=
mware/efi/esrt.c=0A+++ b/drivers/firmware/efi/esrt.c=0A@@ -182,7 +182,7 @@ =
static int esre_create_sysfs_entry(void *esre, int entry_num)=0A 		rc =3D k=
object_init_and_add(&entry->kobj, &esre1_ktype, NULL,=0A 					  "%s", name)=
;=0A 		if (rc) {=0A-			kobject_put(&entry->kobj);=0A+			kfree(entry);=0A 		=
	return rc;=0A 		}=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom b668a7d0b852f06c3b6b57=
2db8558fe63c947c00 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:33 +0100=0ASubject: =
[PATCH 18/54] Revert "scsi: iscsi: Fix reference count leak in=0A iscsi_boo=
t_create_kobj"=0A=0AThis reverts commit d9aa44efed5e656f543e6af54f215eadeb3=
3f054.=0A=0ACommits from @umn.edu addresses have been found to be submitted=
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
e <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/iscsi_boot_sysfs.c | 2=
 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/driv=
ers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c=0Aindex 476f4=
6aad54c..680bf6f0ce76 100644=0A--- a/drivers/scsi/iscsi_boot_sysfs.c=0A+++ =
b/drivers/scsi/iscsi_boot_sysfs.c=0A@@ -319,7 +319,7 @@ iscsi_boot_create_k=
obj(struct iscsi_boot_kset *boot_kset,=0A 	boot_kobj->kobj.kset =3D boot_ks=
et->kset;=0A 	if (kobject_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,=
=0A 				 NULL, name, index)) {=0A-		kobject_put(&boot_kobj->kobj);=0A+		kfr=
ee(boot_kobj);=0A 		return NULL;=0A 	}=0A 	boot_kobj->data =3D data;=0A-- =
=0A2.30.2=0A=0A=0AFrom 08d474cfa6e17a3d42ea36d0e2c72059929dee48 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:42:33 +0100=0ASubject: [PATCH 19/54] Revert "cpuidle: F=
ix three reference count leaks"=0A=0AThis reverts commit f79e5b53115c1753cc=
a7b8a0a6da16342f3689af.=0A=0ACommits from @umn.edu addresses have been foun=
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
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c=0Aindex e7e9=
2ed34f0c..9e98a5fbbc1d 100644=0A--- a/drivers/cpuidle/sysfs.c=0A+++ b/drive=
rs/cpuidle/sysfs.c=0A@@ -412,7 +412,7 @@ static int cpuidle_add_state_sysfs=
(struct cpuidle_device *device)=0A 		ret =3D kobject_init_and_add(&kobj->ko=
bj, &ktype_state_cpuidle,=0A 					   &kdev->kobj, "state%d", i);=0A 		if (r=
et) {=0A-			kobject_put(&kobj->kobj);=0A+			kfree(kobj);=0A 			goto error_s=
tate;=0A 		}=0A 		kobject_uevent(&kobj->kobj, KOBJ_ADD);=0A@@ -542,7 +542,7=
 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)=0A 	ret=
 =3D kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,=0A 				   &kd=
ev->kobj, "driver");=0A 	if (ret) {=0A-		kobject_put(&kdrv->kobj);=0A+		kfr=
ee(kdrv);=0A 		return ret;=0A 	}=0A =0A@@ -636,7 +636,7 @@ int cpuidle_add_=
sysfs(struct cpuidle_device *dev)=0A 	error =3D kobject_init_and_add(&kdev-=
>kobj, &ktype_cpuidle, &cpu_dev->kobj,=0A 				   "cpuidle");=0A 	if (error)=
 {=0A-		kobject_put(&kdev->kobj);=0A+		kfree(kdev);=0A 		return error;=0A 	=
}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 39f0ee55b2fd5c1ffebd5cef451d1a1b7e2a3f8e =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 20:42:33 +0100=0ASubject: [PATCH 20/54] Revert =
"EDAC: Fix reference count leaks"=0A=0AThis reverts commit e9646d449265da00=
f8cc96b57077302480126b92.=0A=0ACommits from @umn.edu addresses have been fo=
und to be submitted in "bad=0Afaith" to try to test the kernel community's =
ability to review "known=0Amalicious" changes.  The result of these submiss=
ions can be found in a=0Apaper published at the 42nd IEEE Symposium on Secu=
rity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducin=
g=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/edac/eda=
c_device_sysfs.c | 1 -=0A drivers/edac/edac_pci_sysfs.c    | 2 +-=0A 2 file=
s changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/edac/ed=
ac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c=0Aindex 18991cfec2af..=
fb68a06ad683 100644=0A--- a/drivers/edac/edac_device_sysfs.c=0A+++ b/driver=
s/edac/edac_device_sysfs.c=0A@@ -280,7 +280,6 @@ int edac_device_register_s=
ysfs_main_kobj(struct edac_device_ctl_info *edac_dev)=0A =0A 	/* Error exit=
 stack */=0A err_kobj_reg:=0A-	kobject_put(&edac_dev->kobj);=0A 	module_put=
(edac_dev->owner);=0A =0A err_mod_get:=0Adiff --git a/drivers/edac/edac_pci=
_sysfs.c b/drivers/edac/edac_pci_sysfs.c=0Aindex c56128402bc6..24d877f6e577=
 100644=0A--- a/drivers/edac/edac_pci_sysfs.c=0A+++ b/drivers/edac/edac_pci=
_sysfs.c=0A@@ -394,7 +394,7 @@ static int edac_pci_main_kobj_setup(void)=0A=
 =0A 	/* Error unwind statck */=0A kobject_init_and_add_fail:=0A-	kobject_p=
ut(edac_pci_top_main_kobj);=0A+	kfree(edac_pci_top_main_kobj);=0A =0A kzall=
oc_fail:=0A 	module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=0A=0AFrom b5e1c3bc6=
98016babca517f5550219d3f55f344b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:33 +0100=
=0ASubject: [PATCH 21/54] Revert "net: cw1200: fix a NULL pointer dereferen=
ce"=0A=0AThis reverts commit 50d25ca802f5a8827325750b05ac5f57cf75de91.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/cw1200/main.c | 5 ----=
-=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/=
cw1200/main.c b/drivers/net/wireless/cw1200/main.c=0Aindex 057725b06f64..85=
b533687964 100644=0A--- a/drivers/net/wireless/cw1200/main.c=0A+++ b/driver=
s/net/wireless/cw1200/main.c=0A@@ -345,11 +345,6 @@ static struct ieee80211=
_hw *cw1200_init_common(const u8 *macaddr,=0A 	mutex_init(&priv->wsm_cmd_mu=
x);=0A 	mutex_init(&priv->conf_mutex);=0A 	priv->workqueue =3D create_singl=
ethread_workqueue("cw1200_wq");=0A-	if (!priv->workqueue) {=0A-		ieee80211_=
free_hw(hw);=0A-		return NULL;=0A-	}=0A-=0A 	sema_init(&priv->scan.lock, 1)=
;=0A 	INIT_WORK(&priv->scan.work, cw1200_scan_work);=0A 	INIT_DELAYED_WORK(=
&priv->scan.probe_work, cw1200_probe_work);=0A-- =0A2.30.2=0A=0A=0AFrom 88c=
b6e6a45bdb76c299c15bc80ddce9169aee8f5 Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:33 =
+0100=0ASubject: [PATCH 22/54] Revert "x86/PCI: Fix PCI IRQ routing table m=
emory leak"=0A=0AThis reverts commit c7155e51cf85acc839822a9872d8bfbec53ef1=
32.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A arch/x86/pci/irq.c | 10 ++--------=
=0A 1 file changed, 2 insertions(+), 8 deletions(-)=0A=0Adiff --git a/arch/=
x86/pci/irq.c b/arch/x86/pci/irq.c=0Aindex 5f0e596b0519..9bd115484745 10064=
4=0A--- a/arch/x86/pci/irq.c=0A+++ b/arch/x86/pci/irq.c=0A@@ -1117,8 +1117,=
6 @@ static struct dmi_system_id __initdata pciirq_dmi_table[] =3D {=0A =0A=
 void __init pcibios_irq_init(void)=0A {=0A-	struct irq_routing_table *rtab=
le =3D NULL;=0A-=0A 	DBG(KERN_DEBUG "PCI: IRQ init\n");=0A =0A 	if (raw_pci=
_ops =3D=3D NULL)=0A@@ -1129,10 +1127,8 @@ void __init pcibios_irq_init(voi=
d)=0A 	pirq_table =3D pirq_find_routing_table();=0A =0A #ifdef CONFIG_PCI_B=
IOS=0A-	if (!pirq_table && (pci_probe & PCI_BIOS_IRQ_SCAN)) {=0A+	if (!pirq=
_table && (pci_probe & PCI_BIOS_IRQ_SCAN))=0A 		pirq_table =3D pcibios_get_=
irq_routing_table();=0A-		rtable =3D pirq_table;=0A-	}=0A #endif=0A 	if (pi=
rq_table) {=0A 		pirq_peer_trick();=0A@@ -1147,10 +1143,8 @@ void __init pc=
ibios_irq_init(void)=0A 		 * If we're using the I/O APIC, avoid using the P=
CI IRQ=0A 		 * routing table=0A 		 */=0A-		if (io_apic_assign_pci_irqs) {=
=0A-			kfree(rtable);=0A+		if (io_apic_assign_pci_irqs)=0A 			pirq_table =
=3D NULL;=0A-		}=0A 	}=0A =0A 	x86_init.pci.fixup_irqs();=0A-- =0A2.30.2=0A=
=0A=0AFrom 5a59237e8fac48b4d696e1947d0fcbcf45e4a595 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:42:34 +0100=0ASubject: [PATCH 23/54] Revert "mmc_spi: add a status =
check for=0A spi_sync_locked"=0A=0AThis reverts commit 8b0e6af16ae690e3f497=
a91def4d52cd72c66fc3.=0A=0ACommits from @umn.edu addresses have been found =
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
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mmc/host/mmc=
_spi.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers=
/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c=0Aindex b52489a67097..147f=
dd5c1891 100644=0A--- a/drivers/mmc/host/mmc_spi.c=0A+++ b/drivers/mmc/host=
/mmc_spi.c=0A@@ -819,10 +819,6 @@ mmc_spi_readblock(struct mmc_spi_host *ho=
st, struct spi_transfer *t,=0A 	}=0A =0A 	status =3D spi_sync_locked(spi, &=
host->m);=0A-	if (status < 0) {=0A-		dev_dbg(&spi->dev, "read error %d\n", =
status);=0A-		return status;=0A-	}=0A =0A 	if (host->dma_dev) {=0A 		dma_sy=
nc_single_for_cpu(host->dma_dev,=0A-- =0A2.30.2=0A=0A=0AFrom 92d08797d5c2b0=
04cab9ef893c6ff260a4480b29 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:34 +0100=0ASub=
ject: [PATCH 24/54] Revert "iio: hmc5843: fix potential NULL pointer=0A der=
eferences"=0A=0AThis reverts commit e98ef6767e41a4bf98356963e01cecda1a88c6f=
6.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/iio/magnetometer/hmc=
5843_i2c.c | 7 +------=0A drivers/staging/iio/magnetometer/hmc5843_spi.c | =
7 +------=0A 2 files changed, 2 insertions(+), 12 deletions(-)=0A=0Adiff --=
git a/drivers/staging/iio/magnetometer/hmc5843_i2c.c b/drivers/staging/iio/=
magnetometer/hmc5843_i2c.c=0Aindex 676a8e329eeb..3e06ceb32059 100644=0A--- =
a/drivers/staging/iio/magnetometer/hmc5843_i2c.c=0A+++ b/drivers/staging/ii=
o/magnetometer/hmc5843_i2c.c=0A@@ -59,13 +59,8 @@ static const struct regma=
p_config hmc5843_i2c_regmap_config =3D {=0A static int hmc5843_i2c_probe(st=
ruct i2c_client *cli,=0A 			     const struct i2c_device_id *id)=0A {=0A-	s=
truct regmap *regmap =3D devm_regmap_init_i2c(cli,=0A-			&hmc5843_i2c_regma=
p_config);=0A-	if (IS_ERR(regmap))=0A-		return PTR_ERR(regmap);=0A-=0A 	ret=
urn hmc5843_common_probe(&cli->dev,=0A-			regmap,=0A+			devm_regmap_init_i2=
c(cli, &hmc5843_i2c_regmap_config),=0A 			id->driver_data, id->name);=0A }=
=0A =0Adiff --git a/drivers/staging/iio/magnetometer/hmc5843_spi.c b/driver=
s/staging/iio/magnetometer/hmc5843_spi.c=0Aindex fded442a3c1d..8be198058ea2=
 100644=0A--- a/drivers/staging/iio/magnetometer/hmc5843_spi.c=0A+++ b/driv=
ers/staging/iio/magnetometer/hmc5843_spi.c=0A@@ -59,7 +59,6 @@ static const=
 struct regmap_config hmc5843_spi_regmap_config =3D {=0A static int hmc5843=
_spi_probe(struct spi_device *spi)=0A {=0A 	int ret;=0A-	struct regmap *reg=
map;=0A 	const struct spi_device_id *id =3D spi_get_device_id(spi);=0A =0A =
	spi->mode =3D SPI_MODE_3;=0A@@ -69,12 +68,8 @@ static int hmc5843_spi_prob=
e(struct spi_device *spi)=0A 	if (ret)=0A 		return ret;=0A =0A-	regmap =3D =
devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config);=0A-	if (IS_ERR(regma=
p))=0A-		return PTR_ERR(regmap);=0A-=0A 	return hmc5843_common_probe(&spi->=
dev,=0A-			regmap,=0A+			devm_regmap_init_spi(spi, &hmc5843_spi_regmap_conf=
ig),=0A 			id->driver_data, id->name);=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom=
 7a82b03046acc27d30a0f97ef02007c75896bb79 Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42=
:34 +0100=0ASubject: [PATCH 25/54] Revert "rtlwifi: fix a potential NULL po=
inter=0A dereference"=0A=0AThis reverts commit 1d3ee4d7fc6ab2effa809b7c4e4e=
f134a1e11465.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/realtek=
/rtlwifi/base.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git=
 a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realt=
ek/rtlwifi/base.c=0Aindex 5013d8c1d4a6..aab752328c26 100644=0A--- a/drivers=
/net/wireless/realtek/rtlwifi/base.c=0A+++ b/drivers/net/wireless/realtek/r=
tlwifi/base.c=0A@@ -466,11 +466,6 @@ static void _rtl_init_deferred_work(st=
ruct ieee80211_hw *hw)=0A 	/* <2> work queue */=0A 	rtlpriv->works.hw =3D h=
w;=0A 	rtlpriv->works.rtl_wq =3D alloc_workqueue("%s", 0, 0, rtlpriv->cfg->=
name);=0A-	if (unlikely(!rtlpriv->works.rtl_wq)) {=0A-		pr_err("Failed to a=
llocate work queue\n");=0A-		return;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&rtlpr=
iv->works.watchdog_wq,=0A 			  (void *)rtl_watchdog_wq_callback);=0A 	INIT_=
DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,=0A-- =0A2.30.2=0A=0A=0AFrom ee=
8f78a6a8b5167fe5fa1af6490d667f46adc06f Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:34=
 +0100=0ASubject: [PATCH 26/54] Revert "video: hgafb: fix potential NULL po=
inter=0A dereference"=0A=0AThis reverts commit 5c7fbc5f6a7d526054e0b11df805=
3e0841fb8a29.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/video/fbdev/hgafb.c =
| 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/video/fb=
dev/hgafb.c b/drivers/video/fbdev/hgafb.c=0Aindex 4a397c7c1b56..15d3ccff296=
5 100644=0A--- a/drivers/video/fbdev/hgafb.c=0A+++ b/drivers/video/fbdev/hg=
afb.c=0A@@ -285,8 +285,6 @@ static int hga_card_detect(void)=0A 	hga_vram_l=
en  =3D 0x08000;=0A =0A 	hga_vram =3D ioremap(0xb0000, hga_vram_len);=0A-	i=
f (!hga_vram)=0A-		goto error;=0A =0A 	if (request_region(0x3b0, 12, "hgafb=
"))=0A 		release_io_ports =3D 1;=0A-- =0A2.30.2=0A=0A=0AFrom 7968988c9db000=
3b06dcfc98540b52bf7ca8a0aa Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:35 +0100=0ASub=
ject: [PATCH 27/54] Revert "video: imsttfb: fix potential NULL pointer=0A d=
ereferences"=0A=0AThis reverts commit c869210e0ac6af93df8c2f68c80c1978be00d=
4f7.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/video/fbdev/imsttfb.c | 5 ---=
--=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/video/fbdev/=
imsttfb.c b/drivers/video/fbdev/imsttfb.c=0Aindex 4994a540f680..9b167f7ef6c=
6 100644=0A--- a/drivers/video/fbdev/imsttfb.c=0A+++ b/drivers/video/fbdev/=
imsttfb.c=0A@@ -1517,11 +1517,6 @@ static int imsttfb_probe(struct pci_dev =
*pdev, const struct pci_device_id *ent)=0A 	info->fix.smem_start =3D addr;=
=0A 	info->screen_base =3D (__u8 *)ioremap(addr, par->ramdac =3D=3D IBM ?=
=0A 					    0x400000 : 0x800000);=0A-	if (!info->screen_base) {=0A-		relea=
se_mem_region(addr, size);=0A-		framebuffer_release(info);=0A-		return -ENO=
MEM;=0A-	}=0A 	info->fix.mmio_start =3D addr + 0x800000;=0A 	par->dc_regs =
=3D ioremap(addr + 0x800000, 0x1000);=0A 	par->cmap_regs_phys =3D addr + 0x=
840000;=0A-- =0A2.30.2=0A=0A=0AFrom 0d8e461c5a545b6369936b3e251f5965afb8082=
2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 20:42:35 +0100=0ASubject: [PATCH 28/54] Rever=
t "rfkill: Fix incorrect check to avoid NULL=0A pointer dereference"=0A=0AT=
his reverts commit d72d75c9d1d0de0ef4b55311e3d178f3c1d7f79c.=0A=0ACommits f=
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
mail.com>=0A---=0A net/rfkill/core.c | 7 ++-----=0A 1 file changed, 2 inser=
tions(+), 5 deletions(-)=0A=0Adiff --git a/net/rfkill/core.c b/net/rfkill/c=
ore.c=0Aindex ad927a6ca2a1..cf5b69ab1829 100644=0A--- a/net/rfkill/core.c=
=0A+++ b/net/rfkill/core.c=0A@@ -941,13 +941,10 @@ static void rfkill_sync_=
work(struct work_struct *work)=0A int __must_check rfkill_register(struct r=
fkill *rfkill)=0A {=0A 	static unsigned long rfkill_no;=0A-	struct device *=
dev;=0A+	struct device *dev =3D &rfkill->dev;=0A 	int error;=0A =0A-	if (!r=
fkill)=0A-		return -EINVAL;=0A-=0A-	dev =3D &rfkill->dev;=0A+	BUG_ON(!rfkil=
l);=0A =0A 	mutex_lock(&rfkill_global_mutex);=0A =0A-- =0A2.30.2=0A=0A=0AFr=
om 62beb11362ff5100d9a5f312a7928874edbe2cff Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
42:35 +0100=0ASubject: [PATCH 29/54] Revert "PCI: xilinx: Check for __get_f=
ree_pages()=0A failure"=0A=0AThis reverts commit 3b4652ba9d7885782fa2ac594c=
d28d8975322479.=0A=0ACommits from @umn.edu addresses have been found to be =
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
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/pci/host/pcie-xili=
nx.c | 12 ++----------=0A 1 file changed, 2 insertions(+), 10 deletions(-)=
=0A=0Adiff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-x=
ilinx.c=0Aindex 6a2499f4d610..4cfa46360d12 100644=0A--- a/drivers/pci/host/=
pcie-xilinx.c=0A+++ b/drivers/pci/host/pcie-xilinx.c=0A@@ -349,19 +349,14 @=
@ static const struct irq_domain_ops msi_domain_ops =3D {=0A  * xilinx_pcie=
_enable_msi - Enable MSI support=0A  * @port: PCIe port information=0A  */=
=0A-static int xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A+sta=
tic void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A {=0A 	phy=
s_addr_t msg_addr;=0A =0A 	port->msi_pages =3D __get_free_pages(GFP_KERNEL,=
 0);=0A-	if (!port->msi_pages)=0A-		return -ENOMEM;=0A-=0A 	msg_addr =3D vi=
rt_to_phys((void *)port->msi_pages);=0A 	pcie_write(port, 0x0, XILINX_PCIE_=
REG_MSIBASE1);=0A 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE2);=0A=
-=0A-	return 0;=0A }=0A =0A /* INTx Functions */=0A@@ -560,7 +555,6 @@ stat=
ic int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)=0A 	struc=
t device *dev =3D port->dev;=0A 	struct device_node *node =3D dev->of_node;=
=0A 	struct device_node *pcie_intc_node;=0A-	int ret;=0A =0A 	/* Setup INTx=
 */=0A 	pcie_intc_node =3D of_get_next_child(node, NULL);=0A@@ -588,9 +582,=
7 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)=
=0A 			return PTR_ERR(port->irq_domain);=0A 		}=0A =0A-		ret =3D xilinx_pci=
e_enable_msi(port);=0A-		if (ret)=0A-			return ret;=0A+		xilinx_pcie_enable=
_msi(port);=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom f968d742c95=
560093c2df23e86e1c7bf2f95c63a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:35 +0100=0A=
Subject: [PATCH 30/54] Revert "drm/gma500: fix memory disclosures due to=0A=
 uninitialized bytes"=0A=0AThis reverts commit 8a0bb821889912b342b229aa26fe=
c1eb77660d7a.=0A=0ACommits from @umn.edu addresses have been found to be su=
bmitted in "bad=0Afaith" to try to test the kernel community's ability to r=
eview "known=0Amalicious" changes.  The result of these submissions can be =
found in a=0Apaper published at the 42nd IEEE Symposium on Security and Pri=
vacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerab=
ilities via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnes=
ota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all su=
bmissions from this group must be reverted from=0Athe kernel tree and will =
need to be re-reviewed again to determine if=0Athey actually are a valid fi=
x.  Until that work is complete, remove this=0Achange to ensure that no pro=
blems are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/oaktr=
ail_crtc.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drive=
rs/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oaktrail_crtc.c=
=0Aindex 31e0899035f9..1048f0c7c6ce 100644=0A--- a/drivers/gpu/drm/gma500/o=
aktrail_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c=0A@@ -139,7 +=
139,6 @@ static bool mrst_sdvo_find_best_pll(const struct gma_limit_t *limi=
t,=0A 	s32 freq_error, min_error =3D 100000;=0A =0A 	memset(best_clock, 0, =
sizeof(*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (cl=
ock.m =3D limit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		for (c=
lock.n =3D limit->n.min; clock.n <=3D limit->n.max;=0A@@ -196,7 +195,6 @@ s=
tatic bool mrst_lvds_find_best_pll(const struct gma_limit_t *limit,=0A 	int=
 err =3D target;=0A =0A 	memset(best_clock, 0, sizeof(*best_clock));=0A-	me=
mset(&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =3D limit->m.min; cloc=
k.m <=3D limit->m.max; clock.m++) {=0A 		for (clock.p1 =3D limit->p1.min; c=
lock.p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=0AFrom b389b2b6c0859ce3310=
46fcaec8890e3e0a47bed Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:35 +0100=0ASubject:=
 [PATCH 31/54] Revert "gma/gma500: fix a memory disclosure bug due to=0A un=
initialized bytes"=0A=0AThis reverts commit 526af772abc19bb9ae2406620eec015=
ba619bcda.=0A=0ACommits from @umn.edu addresses have been found to be submi=
tted in "bad=0Afaith" to try to test the kernel community's ability to revi=
ew "known=0Amalicious" changes.  The result of these submissions can be fou=
nd in a=0Apaper published at the 42nd IEEE Symposium on Security and Privac=
y=0Aentitled, "Open Source Insecurity: Stealthily Introducing=0AVulnerabili=
ties via Hypocrite Commits" written by Qiushi Wu (University=0Aof Minnesota=
) and Kangjie Lu (University of Minnesota).=0A=0ABecause of this, all submi=
ssions from this group must be reverted from=0Athe kernel tree and will nee=
d to be re-reviewed again to determine if=0Athey actually are a valid fix. =
 Until that work is complete, remove this=0Achange to ensure that no proble=
ms are being introduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/cdv_inte=
l_display.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/driv=
ers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_d=
isplay.c=0Aindex 54d554d72000..7d47b3d5cc0d 100644=0A--- a/drivers/gpu/drm/=
gma500/cdv_intel_display.c=0A+++ b/drivers/gpu/drm/gma500/cdv_intel_display=
=2Ec=0A@@ -415,8 +415,6 @@ static bool cdv_intel_find_dp_pll(const struct g=
ma_limit_t *limit,=0A 	struct gma_crtc *gma_crtc =3D to_gma_crtc(crtc);=0A =
	struct gma_clock_t clock;=0A =0A-	memset(&clock, 0, sizeof(clock));=0A-=0A=
 	switch (refclk) {=0A 	case 27000:=0A 		if (target < 200000) {=0A-- =0A2.3=
0.2=0A=0A=0AFrom 82d50bc397672d019964c74b9b0149a016f3b597 Mon Sep 17 00:00:=
00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 2=
1 Apr 2021 20:42:36 +0100=0ASubject: [PATCH 32/54] Revert "spi : spi-topcli=
ff-pch: Fix to handle empty DMA=0A buffers"=0A=0AThis reverts commit c92745=
1887c1abdb480ee77f17ba2b20c55285b6.=0A=0ACommits from @umn.edu addresses ha=
ve been found to be submitted in "bad=0Afaith" to try to test the kernel co=
mmunity's ability to review "known=0Amalicious" changes.  The result of the=
se submissions can be found in a=0Apaper published at the 42nd IEEE Symposi=
um on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily =
Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (=
University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0AB=
ecause of this, all submissions from this group must be reverted from=0Athe=
 kernel tree and will need to be re-reviewed again to determine if=0Athey a=
ctually are a valid fix.  Until that work is complete, remove this=0Achange=
 to ensure that no problems are being introduced into the=0Acodebase.=0A=0A=
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A driver=
s/spi/spi-topcliff-pch.c | 15 ++-------------=0A 1 file changed, 2 insertio=
ns(+), 13 deletions(-)=0A=0Adiff --git a/drivers/spi/spi-topcliff-pch.c b/d=
rivers/spi/spi-topcliff-pch.c=0Aindex 9f30a4ab2004..93dfcee0f987 100644=0A-=
-- a/drivers/spi/spi-topcliff-pch.c=0A+++ b/drivers/spi/spi-topcliff-pch.c=
=0A@@ -1326,27 +1326,18 @@ static void pch_free_dma_buf(struct pch_spi_boar=
d_data *board_dat,=0A 	return;=0A }=0A =0A-static int pch_alloc_dma_buf(str=
uct pch_spi_board_data *board_dat,=0A+static void pch_alloc_dma_buf(struct =
pch_spi_board_data *board_dat,=0A 			      struct pch_spi_data *data)=0A {=
=0A 	struct pch_spi_dma_ctrl *dma;=0A-	int ret;=0A =0A 	dma =3D &data->dma;=
=0A-	ret =3D 0;=0A 	/* Get Consistent memory for Tx DMA */=0A 	dma->tx_buf_=
virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 				PCH_BUF_SIZE, &dm=
a->tx_buf_dma, GFP_KERNEL);=0A-	if (!dma->tx_buf_virt)=0A-		ret =3D -ENOMEM=
;=0A-=0A 	/* Get Consistent memory for Rx DMA */=0A 	dma->rx_buf_virt =3D d=
ma_alloc_coherent(&board_dat->pdev->dev,=0A 				PCH_BUF_SIZE, &dma->rx_buf_=
dma, GFP_KERNEL);=0A-	if (!dma->rx_buf_virt)=0A-		ret =3D -ENOMEM;=0A-=0A-	=
return ret;=0A }=0A =0A static int pch_spi_pd_probe(struct platform_device =
*plat_dev)=0A@@ -1423,9 +1414,7 @@ static int pch_spi_pd_probe(struct platf=
orm_device *plat_dev)=0A =0A 	if (use_dma) {=0A 		dev_info(&plat_dev->dev, =
"Use DMA for data transfers\n");=0A-		ret =3D pch_alloc_dma_buf(board_dat, =
data);=0A-		if (ret)=0A-			goto err_spi_register_master;=0A+		pch_alloc_dma=
_buf(board_dat, data);=0A 	}=0A =0A 	ret =3D spi_register_master(master);=
=0A-- =0A2.30.2=0A=0A=0AFrom f17db997b28b29c8220e4d64f3400dfb9a954bcc Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:42:36 +0100=0ASubject: [PATCH 33/54] Revert "ALSA=
: sb8: add a check for request_region"=0A=0AThis reverts commit 0a2741cd526=
9d8d5cd34898086e543b75bb18002.=0A=0ACommits from @umn.edu addresses have be=
en found to be submitted in "bad=0Afaith" to try to test the kernel communi=
ty's ability to review "known=0Amalicious" changes.  The result of these su=
bmissions can be found in a=0Apaper published at the 42nd IEEE Symposium on=
 Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Intro=
ducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Unive=
rsity=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecaus=
e of this, all submissions from this group must be reverted from=0Athe kern=
el tree and will need to be re-reviewed again to determine if=0Athey actual=
ly are a valid fix.  Until that work is complete, remove this=0Achange to e=
nsure that no problems are being introduced into the=0Acodebase.=0A=0ASigne=
d-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/s=
b/sb8.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/sound/=
isa/sb/sb8.c b/sound/isa/sb/sb8.c=0Aindex 0c7fe1418447..b8e2391c33ff 100644=
=0A--- a/sound/isa/sb/sb8.c=0A+++ b/sound/isa/sb/sb8.c=0A@@ -111,10 +111,6 =
@@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)=0A =0A 	=
/* block the 0x388 port to avoid PnP conflicts */=0A 	acard->fm_res =3D req=
uest_region(0x388, 4, "SoundBlaster FM");=0A-	if (!acard->fm_res) {=0A-		er=
r =3D -EBUSY;=0A-		goto _err;=0A-	}=0A =0A 	if (port[dev] !=3D SNDRV_AUTO_P=
ORT) {=0A 		if ((err =3D snd_sbdsp_create(card, port[dev], irq[dev],=0A-- =
=0A2.30.2=0A=0A=0AFrom d8b82b82446c1f778e54b0bf67cd8e7a29aee6f8 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:42:36 +0100=0ASubject: [PATCH 34/54] Revert "md: Fix fa=
iled allocation of=0A md_register_thread"=0A=0AThis reverts commit 128f60fe=
3bb0b759cf52548fcb15683f91bd7d00.=0A=0ACommits from @umn.edu addresses have=
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
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/=
md/raid10.c | 2 --=0A drivers/md/raid5.c  | 2 --=0A 2 files changed, 4 dele=
tions(-)=0A=0Adiff --git a/drivers/md/raid10.c b/drivers/md/raid10.c=0Ainde=
x 69e9abf00c74..98da5f5d847d 100644=0A--- a/drivers/md/raid10.c=0A+++ b/dri=
vers/md/raid10.c=0A@@ -3755,8 +3755,6 @@ static int run(struct mddev *mddev=
)=0A 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);=0A 		mddev->sync_thr=
ead =3D md_register_thread(md_do_sync, mddev,=0A 							"reshape");=0A-		if=
 (!mddev->sync_thread)=0A-			goto out_free_conf;=0A 	}=0A =0A 	return 0;=0A=
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0Aindex 24708dcf0bb4..=
4f8900eee409 100644=0A--- a/drivers/md/raid5.c=0A+++ b/drivers/md/raid5.c=
=0A@@ -6984,8 +6984,6 @@ static int run(struct mddev *mddev)=0A 		set_bit(M=
D_RECOVERY_RUNNING, &mddev->recovery);=0A 		mddev->sync_thread =3D md_regis=
ter_thread(md_do_sync, mddev,=0A 							"reshape");=0A-		if (!mddev->sync_t=
hread)=0A-			goto abort;=0A 	}=0A =0A 	/* Ok, everything is just fine now *=
/=0A-- =0A2.30.2=0A=0A=0AFrom 4ae64e4ad995624bf78d1d20eb1c39696bf53bf4 Mon =
Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:42:36 +0100=0ASubject: [PATCH 35/54] Revert "q=
lcnic: Avoid potential NULL pointer=0A dereference"=0A=0AThis reverts commi=
t d311479911c760e0d5c915c2f187d2b46b960848.=0A=0ACommits from @umn.edu addr=
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
--=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 --=0A 1 file =
changed, 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/qlcni=
c/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A=
index 63ebc491057b..0a2318cad34d 100644=0A--- a/drivers/net/ethernet/qlogic=
/qlcnic/qlcnic_ethtool.c=0A+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_=
ethtool.c=0A@@ -1038,8 +1038,6 @@ int qlcnic_do_lb_test(struct qlcnic_adapt=
er *adapter, u8 mode)=0A =0A 	for (i =3D 0; i < QLCNIC_NUM_ILB_PKT; i++) {=
=0A 		skb =3D netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);=0A-		=
if (!skb)=0A-			break;=0A 		qlcnic_create_loopback_buff(skb->data, adapter-=
>mac_addr);=0A 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);=0A 		adapter->ahw->diag=
_cnt =3D 0;=0A-- =0A2.30.2=0A=0A=0AFrom 45347a5e555f948cf25d3cdcf70360dc192=
932ba Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:42:37 +0100=0ASubject: [PATCH 36/54] R=
evert "tty: atmel_serial: fix a potential NULL pointer=0A dereference"=0A=
=0AThis reverts commit 13f6808ec2bb43cffafd3a24b01692676bdfccfc.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/tty/serial/atmel_serial.c | 4 ----=0A 1 file=
 changed, 4 deletions(-)=0A=0Adiff --git a/drivers/tty/serial/atmel_serial.=
c b/drivers/tty/serial/atmel_serial.c=0Aindex 3bd19de7df71..340bc4f38f18 10=
0644=0A--- a/drivers/tty/serial/atmel_serial.c=0A+++ b/drivers/tty/serial/a=
tmel_serial.c=0A@@ -1178,10 +1178,6 @@ static int atmel_prepare_rx_dma(stru=
ct uart_port *port)=0A 					 sg_dma_len(&atmel_port->sg_rx)/2,=0A 					 DMA=
_DEV_TO_MEM,=0A 					 DMA_PREP_INTERRUPT);=0A-	if (!desc) {=0A-		dev_err(po=
rt->dev, "Preparing DMA cyclic failed\n");=0A-		goto chan_err;=0A-	}=0A 	de=
sc->callback =3D atmel_complete_rx_dma;=0A 	desc->callback_param =3D port;=
=0A 	atmel_port->desc_rx =3D desc;=0A-- =0A2.30.2=0A=0A=0AFrom 3f9f9f609073=
a75ade2e7dc888cd1204feaf8cb7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:37 +0100=0AS=
ubject: [PATCH 37/54] Revert "scsi: qla4xxx: fix a potential NULL pointer=
=0A dereference"=0A=0AThis reverts commit 783552a9865c667d492386994b6eb42d2=
ec365db.=0A=0ACommits from @umn.edu addresses have been found to be submitt=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/qla4xxx/ql4_os.c | =
2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/scsi/qla4x=
xx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c=0Aindex f10088a1d38c..521dd87f9=
4ce 100644=0A--- a/drivers/scsi/qla4xxx/ql4_os.c=0A+++ b/drivers/scsi/qla4x=
xx/ql4_os.c=0A@@ -3207,8 +3207,6 @@ static int qla4xxx_conn_bind(struct isc=
si_cls_session *cls_session,=0A 	if (iscsi_conn_bind(cls_session, cls_conn,=
 is_leading))=0A 		return -EINVAL;=0A 	ep =3D iscsi_lookup_endpoint(transpo=
rt_fd);=0A-	if (!ep)=0A-		return -EINVAL;=0A 	conn =3D cls_conn->dd_data;=
=0A 	qla_conn =3D conn->dd_data;=0A 	qla_conn->qla_ep =3D ep->dd_data;=0A--=
 =0A2.30.2=0A=0A=0AFrom f4fbe83502672ee735af00665e6c57aa8fe07259 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:42:37 +0100=0ASubject: [PATCH 38/54] Revert "libnvdimm=
/btt: Fix a kmemdup failure check"=0A=0AThis reverts commit 905b8964c9d973e=
64e3dd0c64e62c207c13df4db.=0A=0ACommits from @umn.edu addresses have been f=
ound to be submitted in "bad=0Afaith" to try to test the kernel community's=
 ability to review "known=0Amalicious" changes.  The result of these submis=
sions can be found in a=0Apaper published at the 42nd IEEE Symposium on Sec=
urity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introduci=
ng=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Universit=
y=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of=
 this, all submissions from this group must be reverted from=0Athe kernel t=
ree and will need to be re-reviewed again to determine if=0Athey actually a=
re a valid fix.  Until that work is complete, remove this=0Achange to ensur=
e that no problems are being introduced into the=0Acodebase.=0A=0ASigned-of=
f-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/=
btt_devs.c | 18 +++++-------------=0A 1 file changed, 5 insertions(+), 13 d=
eletions(-)=0A=0Adiff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/bt=
t_devs.c=0Aindex 4c129450495d..cb477518dd0e 100644=0A--- a/drivers/nvdimm/b=
tt_devs.c=0A+++ b/drivers/nvdimm/btt_devs.c=0A@@ -170,15 +170,14 @@ static =
struct device *__nd_btt_create(struct nd_region *nd_region,=0A 		return NUL=
L;=0A =0A 	nd_btt->id =3D ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KER=
NEL);=0A-	if (nd_btt->id < 0)=0A-		goto out_nd_btt;=0A+	if (nd_btt->id < 0)=
 {=0A+		kfree(nd_btt);=0A+		return NULL;=0A+	}=0A =0A 	nd_btt->lbasize =3D =
lbasize;=0A-	if (uuid) {=0A+	if (uuid)=0A 		uuid =3D kmemdup(uuid, 16, GFP_=
KERNEL);=0A-		if (!uuid)=0A-			goto out_put_id;=0A-	}=0A 	nd_btt->uuid =3D =
uuid;=0A 	dev =3D &nd_btt->dev;=0A 	dev_set_name(dev, "btt%d.%d", nd_region=
->id, nd_btt->id);=0A@@ -193,13 +192,6 @@ static struct device *__nd_btt_cr=
eate(struct nd_region *nd_region,=0A 		return NULL;=0A 	}=0A 	return dev;=
=0A-=0A-out_put_id:=0A-	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);=
=0A-=0A-out_nd_btt:=0A-	kfree(nd_btt);=0A-	return NULL;=0A }=0A =0A struct =
device *nd_btt_create(struct nd_region *nd_region)=0A-- =0A2.30.2=0A=0A=0AF=
rom e42fdf52311e689ba8df472e91509c022915ea3c Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:42:37 +0100=0ASubject: [PATCH 39/54] Revert "x86/hpet: Prevent potential N=
ULL pointer=0A dereference"=0A=0AThis reverts commit c2dc2fdc0cd17d308671fb=
2dcdfcb2d2b89cfcf9.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A arch/x86/kernel/hpet.c=
 | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/arch/x86/kernel=
/hpet.c b/arch/x86/kernel/hpet.c=0Aindex e8d20336f398..95c957d193f9 100644=
=0A--- a/arch/x86/kernel/hpet.c=0A+++ b/arch/x86/kernel/hpet.c=0A@@ -824,8 =
+824,6 @@ int __init hpet_enable(void)=0A 		return 0;=0A =0A 	hpet_set_mapp=
ing();=0A-	if (!hpet_virt_address)=0A-		return 0;=0A =0A 	/*=0A 	 * Read th=
e period and check for a sane value:=0A-- =0A2.30.2=0A=0A=0AFrom f22cc17114=
48ed5d36a3a0713ddccdaecdca437a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:38 +0100=
=0ASubject: [PATCH 40/54] Revert "leds: lp5523: fix a missing check of retu=
rn=0A value of lp55xx_read"=0A=0AThis reverts commit 65aac32fee8007170c5ce7=
38837046bde5f2b12d.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/leds/leds-lp55=
23.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff -=
-git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c=0Aindex d123=
70352ae3..1d0187f42941 100644=0A--- a/drivers/leds/leds-lp5523.c=0A+++ b/dr=
ivers/leds/leds-lp5523.c=0A@@ -318,9 +318,7 @@ static int lp5523_init_progr=
am_engine(struct lp55xx_chip *chip)=0A =0A 	/* Let the programs run for cou=
ple of ms and check the engine status */=0A 	usleep_range(3000, 6000);=0A-	=
ret =3D lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A-	if (ret)=0A-		re=
turn ret;=0A+	lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A 	status &=
=3D LP5523_ENG_STATUS_MASK;=0A =0A 	if (status !=3D LP5523_ENG_STATUS_MASK)=
 {=0A-- =0A2.30.2=0A=0A=0AFrom 0aef1c0bc1b5175c1c5d13e4dbafda3d3304121c Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:42:38 +0100=0ASubject: [PATCH 41/54] Revert "m=
fd: mc13xxx: Fix a missing check of a=0A register-read failure"=0A=0AThis r=
everts commit d8189ee86c3a63ba73eecab676f7a10b13d8ff65.=0A=0ACommits from @=
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
rivers/mfd/mc13xxx-core.c=0Aindex 1494e7cbd593..997906d82747 100644=0A--- a=
/drivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/mc13xxx-core.c=0A@@ -274,9 =
+274,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned i=
nt mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_ADC_WORKING;=0A =0A-	ret =
=3D mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A-	if (ret)=0A-		g=
oto out;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A =0A 	ad=
c0 =3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=0A 	       MC13XXX_ADC0_=
CHRGRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom b54f9d1f5fb0983a054631d3ce00ea7f783=
07330 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:42:38 +0100=0ASubject: [PATCH 42/54] R=
evert "gdrom: fix a memory leak bug"=0A=0AThis reverts commit 4c549499c4c96=
c876289c73dca2e7ed995d80de8.=0A=0ACommits from @umn.edu addresses have been=
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
drom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 1852d19d0d7b..e2808fefbb78 100=
644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/drivers/cdrom/gdrom.c=0A@@ -882,7=
 +882,6 @@ static void __exit exit_gdrom(void)=0A 	platform_device_unregist=
er(pd);=0A 	platform_driver_unregister(&gdrom_driver);=0A 	kfree(gd.toc);=
=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(init_gdrom);=0A-- =0A2.30.2=
=0A=0A=0AFrom 3eac4635c0709d97303f1f7d1824cc0f18187705 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:42:38 +0100=0ASubject: [PATCH 43/54] Revert "atl1e: checking the=
 status of=0A atl1e_write_phy_reg"=0A=0AThis reverts commit 0c97734b244ad96=
515df73ef4d95df8129fd6c0f.=0A=0ACommits from @umn.edu addresses have been f=
ound to be submitted in "bad=0Afaith" to try to test the kernel community's=
 ability to review "known=0Amalicious" changes.  The result of these submis=
sions can be found in a=0Apaper published at the 42nd IEEE Symposium on Sec=
urity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introduci=
ng=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Universit=
y=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of=
 this, all submissions from this group must be reverted from=0Athe kernel t=
ree and will need to be re-reviewed again to determine if=0Athey actually a=
re a valid fix.  Until that work is complete, remove this=0Achange to ensur=
e that no problems are being introduced into the=0Acodebase.=0A=0ASigned-of=
f-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/eth=
ernet/atheros/atl1e/atl1e_main.c | 4 +---=0A 1 file changed, 1 insertion(+)=
, 3 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/atheros/atl1e/atl1e=
_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0Aindex 4384b2b4d=
238..59a03a193e83 100644=0A--- a/drivers/net/ethernet/atheros/atl1e/atl1e_m=
ain.c=0A+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0A@@ -478,9 +=
478,7 @@ static void atl1e_mdio_write(struct net_device *netdev, int phy_id=
,=0A {=0A 	struct atl1e_adapter *adapter =3D netdev_priv(netdev);=0A =0A-	i=
f (atl1e_write_phy_reg(&adapter->hw,=0A-				reg_num & MDIO_REG_ADDR_MASK, v=
al))=0A-		netdev_err(netdev, "write phy register failed\n");=0A+	atl1e_writ=
e_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, val);=0A }=0A =0A sta=
tic int atl1e_mii_ioctl(struct net_device *netdev,=0A-- =0A2.30.2=0A=0A=0AF=
rom aefbf527173444487614eda74bd6a59354eb7c79 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:42:39 +0100=0ASubject: [PATCH 44/54] Revert "net: stmicro: fix a missing c=
heck of=0A clk_prepare"=0A=0AThis reverts commit b801a2820eda33e6ad76adf312=
aa2518d21d9e5d.=0A=0ACommits from @umn.edu addresses have been found to be =
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
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/stmic=
ro/stmmac/dwmac-sunxi.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 delet=
ions(-)=0A=0Adiff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=
 b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0Aindex 31ab5e749e66..=
92e9d8c74e02 100644=0A--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi=
=2Ec=0A+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A@@ -59,9 +=
59,7 @@ static int sun7i_gmac_init(struct platform_device *pdev, void *priv=
)=0A 		gmac->clk_enabled =3D 1;=0A 	} else {=0A 		clk_set_rate(gmac->tx_clk=
, SUN7I_GMAC_MII_RATE);=0A-		ret =3D clk_prepare(gmac->tx_clk);=0A-		if (re=
t)=0A-			return ret;=0A+		clk_prepare(gmac->tx_clk);=0A 	}=0A =0A 	return 0=
;=0A-- =0A2.30.2=0A=0A=0AFrom db98c01ee04a8e9987ad2c499d0583f1ee8544dd Mon =
Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:42:39 +0100=0ASubject: [PATCH 45/54] Revert "n=
et/net_namespace: Check the return value of=0A register_pernet_subsys()"=0A=
=0AThis reverts commit 88b903fedb6d43443a80a7033b17e0424f072ccc.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A net/core/net_namespace.c | 3 +--=0A 1 file changed, =
1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/net/core/net_namespace.c b=
/net/core/net_namespace.c=0Aindex 01bfe28b20a1..087ce1598b74 100644=0A--- a=
/net/core/net_namespace.c=0A+++ b/net/core/net_namespace.c=0A@@ -778,8 +778=
,7 @@ static int __init net_ns_init(void)=0A =0A 	mutex_unlock(&net_mutex);=
=0A =0A-	if (register_pernet_subsys(&net_ns_ops))=0A-		panic("Could not reg=
ister network namespace subsystems");=0A+	register_pernet_subsys(&net_ns_op=
s);=0A =0A 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net_newid, NULL, NUL=
L);=0A 	rtnl_register(PF_UNSPEC, RTM_GETNSID, rtnl_net_getid, rtnl_net_dump=
id,=0A-- =0A2.30.2=0A=0A=0AFrom 98c3351a60b912c3399578c641417c92e7b28a9a Mo=
n Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:42:39 +0100=0ASubject: [PATCH 46/54] Revert "d=
rivers/regulator: fix a missing check of=0A return value"=0A=0AThis reverts=
 commit f1f6e74a6ddf7e4341f64aa4c7f03cb5c711b699.=0A=0ACommits from @umn.ed=
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
=0A---=0A drivers/regulator/palmas-regulator.c | 5 +----=0A 1 file changed,=
 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/regulator/palmas-=
regulator.c b/drivers/regulator/palmas-regulator.c=0Aindex 4a4766c43e61..82=
17613807d3 100644=0A--- a/drivers/regulator/palmas-regulator.c=0A+++ b/driv=
ers/regulator/palmas-regulator.c=0A@@ -435,16 +435,13 @@ static int palmas_=
ldo_write(struct palmas *palmas, unsigned int reg,=0A static int palmas_set=
_mode_smps(struct regulator_dev *dev, unsigned int mode)=0A {=0A 	int id =
=3D rdev_get_id(dev);=0A-	int ret;=0A 	struct palmas_pmic *pmic =3D rdev_ge=
t_drvdata(dev);=0A 	struct palmas_pmic_driver_data *ddata =3D pmic->palmas-=
>pmic_ddata;=0A 	struct palmas_regs_info *rinfo =3D &ddata->palmas_regs_inf=
o[id];=0A 	unsigned int reg;=0A 	bool rail_enable =3D true;=0A =0A-	ret =3D=
 palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A-	if (ret)=0A-		=
return ret;=0A+	palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A =
=0A 	reg &=3D ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.2=0A=
=0A=0AFrom a7ef0251e1bd697c940381315a96a2800f216a2c Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:42:39 +0100=0ASubject: [PATCH 47/54] Revert "hwmon: (lm80) fix a mi=
ssing check of bus read=0A in lm80 probe"=0A=0AThis reverts commit 90beb6bb=
ed6719bf5ee73dadebe6fd99cb57cc98.=0A=0ACommits from @umn.edu addresses have=
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
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/=
hwmon/lm80.c | 11 ++---------=0A 1 file changed, 2 insertions(+), 9 deletio=
ns(-)=0A=0Adiff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c=0Aindex=
 be60bd5bab78..ee6d499edc1b 100644=0A--- a/drivers/hwmon/lm80.c=0A+++ b/dri=
vers/hwmon/lm80.c=0A@@ -630,7 +630,6 @@ static int lm80_probe(struct i2c_cl=
ient *client,=0A 	struct device *dev =3D &client->dev;=0A 	struct device *h=
wmon_dev;=0A 	struct lm80_data *data;=0A-	int rv;=0A =0A 	data =3D devm_kza=
lloc(dev, sizeof(struct lm80_data), GFP_KERNEL);=0A 	if (!data)=0A@@ -643,1=
4 +642,8 @@ static int lm80_probe(struct i2c_client *client,=0A 	lm80_init_=
client(client);=0A =0A 	/* A few vars need to be filled upon startup */=0A-=
	rv =3D lm80_read_value(client, LM80_REG_FAN_MIN(1));=0A-	if (rv < 0)=0A-		=
return rv;=0A-	data->fan[f_min][0] =3D rv;=0A-	rv =3D lm80_read_value(clien=
t, LM80_REG_FAN_MIN(2));=0A-	if (rv < 0)=0A-		return rv;=0A-	data->fan[f_mi=
n][1] =3D rv;=0A+	data->fan[f_min][0] =3D lm80_read_value(client, LM80_REG_=
FAN_MIN(1));=0A+	data->fan[f_min][1] =3D lm80_read_value(client, LM80_REG_F=
AN_MIN(2));=0A =0A 	hwmon_dev =3D devm_hwmon_device_register_with_groups(de=
v, client->name,=0A 							   data, lm80_groups);=0A-- =0A2.30.2=0A=0A=0AFr=
om 141d56cea037356012b82d6d04dddd14db2a0768 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
42:40 +0100=0ASubject: [PATCH 48/54] Revert "net: cxgb3_main: fix a missing=
-check bug"=0A=0AThis reverts commit 6596d0ab8c602b6bb9f4a8423ddd7fc3acb241=
8f.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/chelsio/cxgb3/c=
xgb3_main.c | 17 -----------------=0A 1 file changed, 17 deletions(-)=0A=0A=
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/=
ethernet/chelsio/cxgb3/cxgb3_main.c=0Aindex f40eefd1b378..4b8c5a4bd7b5 1006=
44=0A--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A+++ b/drivers/=
net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A@@ -2147,8 +2147,6 @@ static int =
cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			r=
eturn -EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			retur=
n -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_SET_QSET_PARAMS)=0A-			return -EINVA=
L;=0A 		if (t.qset_idx >=3D SGE_QSETS)=0A 			return -EINVAL;=0A 		if (!in_r=
ange(t.intr_lat, 0, M_NEWTIMER) ||=0A@@ -2248,9 +2246,6 @@ static int cxgb_=
extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 		if (cop=
y_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A =0A-		if (t.=
cmd !=3D CHELSIO_GET_QSET_PARAMS)=0A-			return -EINVAL;=0A-=0A 		/* Display=
 qsets for all ports when offload enabled */=0A 		if (test_bit(OFFLOAD_DEVM=
AP_BIT, &adapter->open_device_map)) {=0A 			q1 =3D 0;=0A@@ -2296,8 +2291,6 =
@@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *use=
raddr)=0A 			return -EBUSY;=0A 		if (copy_from_user(&edata, useraddr, sizeo=
f(edata)))=0A 			return -EFAULT;=0A-		if (edata.cmd !=3D CHELSIO_SET_QSET_N=
UM)=0A-			return -EINVAL;=0A 		if (edata.val < 1 ||=0A 			(edata.val > 1 &&=
 !(adapter->flags & USING_MSIX)))=0A 			return -EINVAL;=0A@@ -2338,8 +2331,=
6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *u=
seraddr)=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(=
t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_LOAD_FW)=0A-			retur=
n -EINVAL;=0A 		/* Check t.len sanity ? */=0A 		fw_data =3D memdup_user(use=
raddr + sizeof(t), t.len);=0A 		if (IS_ERR(fw_data))=0A@@ -2363,8 +2354,6 @=
@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *user=
addr)=0A 			return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m))=
)=0A 			return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SETMTUTAB)=0A-			return=
 -EINVAL;=0A 		if (m.nmtus !=3D NMTUS)=0A 			return -EINVAL;=0A 		if (m.mtu=
s[0] < 81)	/* accommodate SACK */=0A@@ -2406,8 +2395,6 @@ static int cxgb_e=
xtension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return =
-EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			return -EFA=
ULT;=0A-		if (m.cmd !=3D CHELSIO_SET_PM)=0A-			return -EINVAL;=0A 		if (!is=
_power_of_2(m.rx_pg_sz) ||=0A 			!is_power_of_2(m.tx_pg_sz))=0A 			return -=
EINVAL;	/* not power of 2 */=0A@@ -2443,8 +2430,6 @@ static int cxgb_extens=
ion_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EIO;=
	/* need the memory controllers */=0A 		if (copy_from_user(&t, useraddr, si=
zeof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_GET_MEM)=0A-			=
return -EINVAL;=0A 		if ((t.addr & 7) || (t.len & 7))=0A 			return -EINVAL;=
=0A 		if (t.mem_id =3D=3D MEM_CM)=0A@@ -2497,8 +2482,6 @@ static int cxgb_e=
xtension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return =
-EAGAIN;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EF=
AULT;=0A-		if (t.cmd !=3D CHELSIO_SET_TRACE_FILTER)=0A-			return -EINVAL;=
=0A =0A 		tp =3D (const struct trace_params *)&t.sip;=0A 		if (t.config_tx)=
=0A-- =0A2.30.2=0A=0A=0AFrom 7e672631a2780ac5750a6d2c4d564164df0c715a Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:42:40 +0100=0ASubject: [PATCH 49/54] Revert "niu:=
 fix missing checks of niu_pci_eeprom_read"=0A=0AThis reverts commit 1f8aea=
084cb3d962bdd1ceaadf0f6d54aa7862d5.=0A=0ACommits from @umn.edu addresses ha=
ve been found to be submitted in "bad=0Afaith" to try to test the kernel co=
mmunity's ability to review "known=0Amalicious" changes.  The result of the=
se submissions can be found in a=0Apaper published at the 42nd IEEE Symposi=
um on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealthily =
Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (=
University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0AB=
ecause of this, all submissions from this group must be reverted from=0Athe=
 kernel tree and will need to be re-reviewed again to determine if=0Athey a=
ctually are a valid fix.  Until that work is complete, remove this=0Achange=
 to ensure that no problems are being introduced into the=0Acodebase.=0A=0A=
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A driver=
s/net/ethernet/sun/niu.c | 10 ++--------=0A 1 file changed, 2 insertions(+)=
, 8 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/sun/niu.c b/drivers=
/net/ethernet/sun/niu.c=0Aindex cc3b025ab7a7..bd3c047c9fa7 100644=0A--- a/d=
rivers/net/ethernet/sun/niu.c=0A+++ b/drivers/net/ethernet/sun/niu.c=0A@@ -=
8119,8 +8119,6 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 sta=
rt, u32 end)=0A 		start +=3D 3;=0A =0A 		prop_len =3D niu_pci_eeprom_read(n=
p, start + 4);=0A-		if (prop_len < 0)=0A-			return prop_len;=0A 		err =3D n=
iu_pci_vpd_get_propname(np, start + 5, namebuf, 64);=0A 		if (err < 0)=0A 	=
		return err;=0A@@ -8165,12 +8163,8 @@ static int niu_pci_vpd_scan_props(st=
ruct niu *np, u32 start, u32 end)=0A 			netif_printk(np, probe, KERN_DEBUG,=
 np->dev,=0A 				     "VPD_SCAN: Reading in property [%s] len[%d]\n",=0A 		=
		     namebuf, prop_len);=0A-			for (i =3D 0; i < prop_len; i++) {=0A-				=
err =3D niu_pci_eeprom_read(np, off + i);=0A-				if (err >=3D 0)=0A-					*p=
rop_buf =3D err;=0A-				++prop_buf;=0A-			}=0A+			for (i =3D 0; i < prop_le=
n; i++)=0A+				*prop_buf++ =3D niu_pci_eeprom_read(np, off + i);=0A 		}=0A =
=0A 		start +=3D len;=0A-- =0A2.30.2=0A=0A=0AFrom 72457039e398cccba785350fd=
72615b700a0c369 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:40 +0100=0ASubject: [PATC=
H 50/54] Revert "net: socket: fix a missing-check bug"=0A=0AThis reverts co=
mmit 98528072a2a9f7936bb2cbda6bf0f34545a45adf.=0A=0ACommits from @umn.edu a=
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
-=0A net/socket.c | 11 +++--------=0A 1 file changed, 3 insertions(+), 8 de=
letions(-)=0A=0Adiff --git a/net/socket.c b/net/socket.c=0Aindex 1392461d39=
1a..52f9cdee4fd1 100644=0A--- a/net/socket.c=0A+++ b/net/socket.c=0A@@ -274=
8,14 +2748,9 @@ static int ethtool_ioctl(struct net *net, struct compat_ifr=
eq __user *ifr32)=0A 		    copy_in_user(&rxnfc->fs.ring_cookie,=0A 				 &co=
mpat_rxnfc->fs.ring_cookie,=0A 				 (void __user *)(&rxnfc->fs.location + 1=
) -=0A-				 (void __user *)&rxnfc->fs.ring_cookie))=0A-			return -EFAULT;=
=0A-		if (ethcmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-			if (put_user(rule_cnt,=
 &rxnfc->rule_cnt))=0A-				return -EFAULT;=0A-		} else if (copy_in_user(&rx=
nfc->rule_cnt,=0A-					&compat_rxnfc->rule_cnt,=0A-					sizeof(rxnfc->rule_=
cnt)))=0A+				 (void __user *)&rxnfc->fs.ring_cookie) ||=0A+		    copy_in_u=
ser(&rxnfc->rule_cnt, &compat_rxnfc->rule_cnt,=0A+				 sizeof(rxnfc->rule_c=
nt)))=0A 			return -EFAULT;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9fc42eded=
3c02c31eba22c739ef8f5a5f89d1087 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:40 +0100=
=0ASubject: [PATCH 51/54] Revert "media: isif: fix a NULL pointer dereferen=
ce=0A bug"=0A=0AThis reverts commit cc1c305ccaabf2b8ef7679cfe09fb3ca0b84dcd=
9.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/davinci/isif.=
c | 3 +--=0A 1 file changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git=
 a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/i=
sif.c=0Aindex b51b875c5a61..7b98e275054d 100644=0A--- a/drivers/media/platf=
orm/davinci/isif.c=0A+++ b/drivers/media/platform/davinci/isif.c=0A@@ -1097=
,8 +1097,7 @@ fail_nobase_res:=0A =0A 	while (i >=3D 0) {=0A 		res =3D plat=
form_get_resource(pdev, IORESOURCE_MEM, i);=0A-		if (res)=0A-			release_mem=
_region(res->start, resource_size(res));=0A+		release_mem_region(res->start=
, resource_size(res));=0A 		i--;=0A 	}=0A 	vpfe_unregister_ccdc_device(&isi=
f_hw_dev);=0A-- =0A2.30.2=0A=0A=0AFrom 4656a5187d55607f57341557a9c5ef806c98=
9004 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 20:42:40 +0100=0ASubject: [PATCH 52/54] Re=
vert "scsi: 3w-xxxx: fix a missing-check bug"=0A=0AThis reverts commit 2c29=
ed33045b82322518452b20b9b2ff9ebec2f7.=0A=0ACommits from @umn.edu addresses =
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
drivers/scsi/3w-xxxx.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff =
--git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c=0Aindex 308a4206b63=
6..f000669de0de 100644=0A--- a/drivers/scsi/3w-xxxx.c=0A+++ b/drivers/scsi/=
3w-xxxx.c=0A@@ -1034,9 +1034,6 @@ static int tw_chrdev_open(struct inode *i=
node, struct file *file)=0A =0A 	dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_op=
en()\n");=0A =0A-	if (!capable(CAP_SYS_ADMIN))=0A-		return -EACCES;=0A-=0A =
	minor_number =3D iminor(inode);=0A 	if (minor_number >=3D tw_device_extens=
ion_count)=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom 054e5de39a8587c=
6257cb67a7aa344c3d26049e3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:41 +0100=0ASubj=
ect: [PATCH 53/54] Revert "scsi: 3w-9xxx: fix a missing-check bug"=0A=0AThi=
s reverts commit 092b0288f150e17ed626079685a04318abbfbd81.=0A=0ACommits fro=
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
il.com>=0A---=0A drivers/scsi/3w-9xxx.c | 5 -----=0A 1 file changed, 5 dele=
tions(-)=0A=0Adiff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c=
=0Aindex b78a2f3745f2..67133d9e8ce0 100644=0A--- a/drivers/scsi/3w-9xxx.c=
=0A+++ b/drivers/scsi/3w-9xxx.c=0A@@ -889,11 +889,6 @@ static int twa_chrde=
v_open(struct inode *inode, struct file *file)=0A 	unsigned int minor_numbe=
r;=0A 	int retval =3D TW_IOCTL_ERROR_OS_ENODEV;=0A =0A-	if (!capable(CAP_SY=
S_ADMIN)) {=0A-		retval =3D -EACCES;=0A-		goto out;=0A-	}=0A-=0A 	minor_num=
ber =3D iminor(inode);=0A 	if (minor_number >=3D twa_device_extension_count=
)=0A 		goto out;=0A-- =0A2.30.2=0A=0A=0AFrom de990d12039711f28e8b967476d334=
f28c2a3a9f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:42:41 +0100=0ASubject: [PATCH 54/=
54] Revert "dm ioctl: harden copy_params()'s=0A copy_from_user() from malic=
ious users"=0A=0AThis reverts commit 4cc537f4a947e7f11ca84f3f94ad9867615589=
80.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/dm-ioctl.c | 18 +++++++++=
+++------=0A 1 file changed, 12 insertions(+), 6 deletions(-)=0A=0Adiff --g=
it a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c=0Aindex eab3f7325e31..14=
cdc2475a10 100644=0A--- a/drivers/md/dm-ioctl.c=0A+++ b/drivers/md/dm-ioctl=
=2Ec=0A@@ -1686,7 +1686,8 @@ static void free_params(struct dm_ioctl *param=
, size_t param_size, int param_fla=0A }=0A =0A static int copy_params(struc=
t dm_ioctl __user *user, struct dm_ioctl *param_kernel,=0A-		       int ioc=
tl_flags, struct dm_ioctl **param, int *param_flags)=0A+		       int ioctl_=
flags,=0A+		       struct dm_ioctl **param, int *param_flags)=0A {=0A 	stru=
ct dm_ioctl *dmi;=0A 	int secure_data;=0A@@ -1734,13 +1735,18 @@ static int=
 copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern=0A 	=
	return -ENOMEM;=0A 	}=0A =0A-	/* Copy from param_kernel (which was already=
 copied from user) */=0A-	memcpy(dmi, param_kernel, minimum_data_size);=0A-=
=0A-	if (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size=
,=0A-			   param_kernel->data_size - minimum_data_size))=0A+	if (copy_from_=
user(dmi, user, param_kernel->data_size))=0A 		goto bad;=0A+=0A data_copied=
:=0A+	/*=0A+	 * Abort if something changed the ioctl data while it was bein=
g copied.=0A+	 */=0A+	if (dmi->data_size !=3D param_kernel->data_size) {=0A=
+		DMERR("rejecting ioctl: data size modified while processing parameters")=
;=0A+		goto bad;=0A+	}=0A+=0A 	/* Wipe the user buffer so we do not return =
it to userspace */=0A 	if (secure_data && clear_user(user, param_kernel->da=
ta_size))=0A 		goto bad;=0A-- =0A2.30.2=0A=0A
--ROH1Jd7SpI6hpcgh--
