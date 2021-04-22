Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D18E3679D6
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhDVGXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhDVGXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:23:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D874C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:22:38 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x7so43505419wrw.10
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mCCvTczq/PLqr0HUZGXt3Yh4lhArDPXmzpRLylhBtuY=;
        b=jhbDyLC3ywwDPxzLQaHHePP5gT+70iBij7yYBmXqMoYLDNj3VqasRNHKyujQ3SQSit
         JugYmvxJSajIkcJyRvEiZKKlXsKL71aL1QaUOW2bH1fm373c+h1Y6VB2JmCAEewRwjuP
         hDtyNaaG2yfS2PDNhtArVAsZByLVHJPMvgOPbzIESpSXtE8ijpsyGq2o+iUmmOy9xaSi
         HOJ9U2Mvjg6gDdCtaAl6A8HiYty1rOHKewPBnzz/PL7U/eN9JeIMk55PIvW3UjPVxVJF
         TErxEefZ5xdIb3zFtekV0Uk6p7zHRxKD393siewmAzh/94D/Yl/bPyLfqdB/9lU43LGa
         8Ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mCCvTczq/PLqr0HUZGXt3Yh4lhArDPXmzpRLylhBtuY=;
        b=s9uEtHjU0FpgSX7vIWYUMJZyHIkfuhd6yzG+zLOsS0f79pLlOggL55pn+kRcros3p/
         a1pSccVS8StRaOfQ2wvjTrMtt3dyUv0Xe8OFLRawFsyZ2Veq2n9nOMRQqron5OTlBQxm
         mXT58SPHPIUiT34AN/jLJ3AC62496djRcv5xmXfxPw5hXAv7egHwAo4YeEH+618o5Jq6
         Mynnc4qYD7I3Sq0ghmEhKM8x+U7zqC2+pr2dbAjCLDuj+xTHZ9TOyPyix5pCYpH/0s9V
         HM7ZvM8Thk3xNaQHWC0z9Lwi08FhWLWstzd0Qlhb2+EhEWfmNC9y9vs+/L5H8eHF4CM4
         GAHQ==
X-Gm-Message-State: AOAM53130hIAcvxHYDURZlv16dfra3m07z7l4nWKboevSJeEL0kkvCQo
        KIT7M6STNY9TJSMjNMmpgcM=
X-Google-Smtp-Source: ABdhPJwNLRir3tmGAIUERtJynm+JvoSG2lF8152SSLtLozc84GAcDSPaIPxalhao2RdTtp59TD6tAw==
X-Received: by 2002:adf:e583:: with SMTP id l3mr2051198wrm.63.1619072556879;
        Wed, 21 Apr 2021 23:22:36 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id o17sm1908748wrg.80.2021.04.21.23.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:22:35 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:22:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v4.9.y
Message-ID: <YIEWKbugSMDonADm@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vvALna9kLWNMwAEB"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vvALna9kLWNMwAEB
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

--vvALna9kLWNMwAEB
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v4.9.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 1e4ffd0f95431818658a54ddaa9f095bdb444426 Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:37:59 +0100=0ASubject: [PATCH 01/62] Revert "drm/nouveau: fix multipl=
e instances of=0A reference count leaks"=0A=0AThis reverts commit a6ea07556=
d0bd8dedfb0e154d9f10a74ec45d721.=0A=0ACommits from @umn.edu addresses have =
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
/nouveau_drm.c=0Aindex 4e12d3d59651..42829a942e33 100644=0A--- a/drivers/gp=
u/drm/nouveau/nouveau_drm.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c=
=0A@@ -823,10 +823,8 @@ nouveau_drm_open(struct drm_device *dev, struct drm=
_file *fpriv)=0A =0A 	/* need to bring up power immediately if opening devi=
ce */=0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if (ret < 0 && ret !=
=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	if (ret < 0 &=
& ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	get_task_comm(tmpname, c=
urrent);=0A 	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fpriv->=
pid));=0A@@ -914,10 +912,8 @@ nouveau_drm_ioctl(struct file *file, unsigned=
 int cmd, unsigned long arg)=0A 	long ret;=0A =0A 	ret =3D pm_runtime_get_s=
ync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_a=
utosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=
=0A-	}=0A =0A 	switch (_IOC_NR(cmd) - DRM_COMMAND_BASE) {=0A 	case DRM_NOUV=
EAU_NVIF:=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gp=
u/drm/nouveau/nouveau_gem.c=0Aindex be6672da33a6..505dca48b9f8 100644=0A---=
 a/drivers/gpu/drm/nouveau/nouveau_gem.c=0A+++ b/drivers/gpu/drm/nouveau/no=
uveau_gem.c=0A@@ -42,10 +42,8 @@ nouveau_gem_object_del(struct drm_gem_obje=
ct *gem)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (WAR=
N_ON(ret < 0 && ret !=3D -EACCES)) {=0A-		pm_runtime_put_autosuspend(dev);=
=0A+	if (WARN_ON(ret < 0 && ret !=3D -EACCES))=0A 		return;=0A-	}=0A =0A 	i=
f (gem->import_attach)=0A 		drm_prime_gem_destroy(gem, nvbo->bo.sg);=0A-- =
=0A2.30.2=0A=0A=0AFrom 00290ee5a33324039059348520881fe8016903eb Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:37:59 +0100=0ASubject: [PATCH 02/62] Revert "drm/nouvea=
u/drm/noveau: fix reference count=0A leak in nouveau_fbcon_open"=0A=0AThis =
reverts commit f4605dc3581fc71a5f065e1c0bb6e007fb439ac7.=0A=0ACommits from =
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
nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0Aindex 4=
0da9143f722..275abc424ce2 100644=0A--- a/drivers/gpu/drm/nouveau/nouveau_fb=
con.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0A@@ -183,10 +183,8 @=
@ nouveau_fbcon_open(struct fb_info *info, int user)=0A 	struct nouveau_fbd=
ev *fbcon =3D info->par;=0A 	struct nouveau_drm *drm =3D nouveau_drm(fbcon-=
>dev);=0A 	int ret =3D pm_runtime_get_sync(drm->dev->dev);=0A-	if (ret < 0 =
&& ret !=3D -EACCES) {=0A-		pm_runtime_put(drm->dev->dev);=0A+	if (ret < 0 =
&& ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A 	return 0;=0A }=0A =0A-- =0A=
2.30.2=0A=0A=0AFrom 7572e155d026743ca9036d77d39fc6769c453879 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 20:38:00 +0100=0ASubject: [PATCH 03/62] Revert "PCI: Fix pci_=
create_slot() reference count=0A leak"=0A=0AThis reverts commit e840d01d940=
e7192877a062f5176276795b4c51d.=0A=0ACommits from @umn.edu addresses have be=
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
=0A@@ -303,7 +303,6 @@ struct pci_slot *pci_create_slot(struct pci_bus *par=
ent, int slot_nr,=0A 	slot_name =3D make_slot_name(name);=0A 	if (!slot_nam=
e) {=0A 		err =3D -ENOMEM;=0A-		kfree(slot);=0A 		goto err;=0A 	}=0A =0A@@ =
-312,10 +311,8 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, =
int slot_nr,=0A =0A 	err =3D kobject_init_and_add(&slot->kobj, &pci_slot_kt=
ype, NULL,=0A 				   "%s", slot_name);=0A-	if (err) {=0A-		kobject_put(&slo=
t->kobj);=0A+	if (err)=0A 		goto err;=0A-	}=0A =0A 	down_read(&pci_bus_sem)=
;=0A 	list_for_each_entry(dev, &parent->devices, bus_list)=0A@@ -331,6 +328=
,7 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,=
=0A 	mutex_unlock(&pci_slot_mutex);=0A 	return slot;=0A err:=0A+	kfree(slot=
);=0A 	slot =3D ERR_PTR(err);=0A 	goto out;=0A }=0A-- =0A2.30.2=0A=0A=0AFro=
m 4109d19129112bcfe9d5335de657b695b5fb4d75 Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:3=
8:00 +0100=0ASubject: [PATCH 04/62] Revert "omapfb: fix multiple reference =
count leaks due=0A to pm_runtime_get_sync"=0A=0AThis reverts commit bb3a2d5=
75e1d46f91e841505c9b25646e5a50efc.=0A=0ACommits from @umn.edu addresses hav=
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
/video/fbdev/omap2/omapfb/dss/dispc.c | 7 ++-----=0A drivers/video/fbdev/om=
ap2/omapfb/dss/dsi.c   | 7 ++-----=0A drivers/video/fbdev/omap2/omapfb/dss/=
dss.c   | 7 ++-----=0A drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c | 5 ++-=
--=0A drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c | 5 ++---=0A drivers/vid=
eo/fbdev/omap2/omapfb/dss/venc.c  | 7 ++-----=0A 6 files changed, 12 insert=
ions(+), 26 deletions(-)=0A=0Adiff --git a/drivers/video/fbdev/omap2/omapfb=
/dss/dispc.c b/drivers/video/fbdev/omap2/omapfb/dss/dispc.c=0Aindex 00f5a54=
aaf9b..7a75dfda9845 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/dis=
pc.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/dispc.c=0A@@ -531,11 +531=
,8 @@ int dispc_runtime_get(void)=0A 	DSSDBG("dispc_runtime_get\n");=0A =0A=
 	r =3D pm_runtime_get_sync(&dispc.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A=
-		pm_runtime_put_sync(&dispc.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0=
;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A EXPORT_SYMBOL(dispc=
_runtime_get);=0A =0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.=
c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c=0Aindex 2bfd9063cdfc..30d49f=
3800b3 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c=0A+++ b/dr=
ivers/video/fbdev/omap2/omapfb/dss/dsi.c=0A@@ -1148,11 +1148,8 @@ static in=
t dsi_runtime_get(struct platform_device *dsidev)=0A 	DSSDBG("dsi_runtime_g=
et\n");=0A =0A 	r =3D pm_runtime_get_sync(&dsi->pdev->dev);=0A-	if (WARN_ON=
(r < 0)) {=0A-		pm_runtime_put_sync(&dsi->pdev->dev);=0A-		return r;=0A-	}=
=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A st=
atic void dsi_runtime_put(struct platform_device *dsidev)=0Adiff --git a/dr=
ivers/video/fbdev/omap2/omapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb=
/dss/dss.c=0Aindex acecee5b1c10..4429ad37b64c 100644=0A--- a/drivers/video/=
fbdev/omap2/omapfb/dss/dss.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/d=
ss.c=0A@@ -778,11 +778,8 @@ int dss_runtime_get(void)=0A 	DSSDBG("dss_runti=
me_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&dss.pdev->dev);=0A-	if (WARN=
_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dss.pdev->dev);=0A-		return r;=0A-	=
}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A v=
oid dss_runtime_put(void)=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/d=
ss/hdmi4.c b/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c=0Aindex ab64bf021=
5e8..156a254705ea 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi4=
=2Ec=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c=0A@@ -50,10 +50,9=
 @@ static int hdmi_runtime_get(void)=0A 	DSSDBG("hdmi_runtime_get\n");=0A =
=0A 	r =3D pm_runtime_get_sync(&hdmi.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=
=0A-		pm_runtime_put_sync(&hdmi.pdev->dev);=0A+	WARN_ON(r < 0);=0A+	if (r <=
 0)=0A 		return r;=0A-	}=0A =0A 	return 0;=0A }=0Adiff --git a/drivers/vide=
o/fbdev/omap2/omapfb/dss/hdmi5.c b/drivers/video/fbdev/omap2/omapfb/dss/hdm=
i5.c=0Aindex c6efaca3235a..4da36bcab977 100644=0A--- a/drivers/video/fbdev/=
omap2/omapfb/dss/hdmi5.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/hdmi5=
=2Ec=0A@@ -54,10 +54,9 @@ static int hdmi_runtime_get(void)=0A 	DSSDBG("hdm=
i_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&hdmi.pdev->dev);=0A-	=
if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&hdmi.pdev->dev);=0A+	WARN_O=
N(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	}=0A =0A 	return 0;=0A }=0Adiff=
 --git a/drivers/video/fbdev/omap2/omapfb/dss/venc.c b/drivers/video/fbdev/=
omap2/omapfb/dss/venc.c=0Aindex 96714b4596d2..392464da12e4 100644=0A--- a/d=
rivers/video/fbdev/omap2/omapfb/dss/venc.c=0A+++ b/drivers/video/fbdev/omap=
2/omapfb/dss/venc.c=0A@@ -402,11 +402,8 @@ static int venc_runtime_get(void=
)=0A 	DSSDBG("venc_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&venc=
=2Epdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&venc.pde=
v->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return =
r < 0 ? r : 0;=0A }=0A =0A static void venc_runtime_put(void)=0A-- =0A2.30.=
2=0A=0A=0AFrom 2503bc8fc0d97d4a639173b2af5d40aedb99dbcd Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:38:00 +0100=0ASubject: [PATCH 05/62] Revert "media: exynos4-is:=
 Fix several reference count=0A leaks due to pm_runtime_get_sync"=0A=0AThis=
 reverts commit 3450996789e5d8c09a3feecbaf265ba6d25a3ee0.=0A=0ACommits from=
 @umn.edu addresses have been found to be submitted in "bad=0Afaith" to try=
 to test the kernel community's ability to review "known=0Amalicious" chang=
es.  The result of these submissions can be found in a=0Apaper published at=
 the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "Open Source I=
nsecurity: Stealthily Introducing=0AVulnerabilities via Hypocrite Commits" =
written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu (University=
 of Minnesota).=0A=0ABecause of this, all submissions from this group must =
be reverted from=0Athe kernel tree and will need to be re-reviewed again to=
 determine if=0Athey actually are a valid fix.  Until that work is complete=
, remove this=0Achange to ensure that no problems are being introduced into=
 the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0A---=0A drivers/media/platform/exynos4-is/fimc-isp.c  | 4 +---=0A d=
rivers/media/platform/exynos4-is/fimc-lite.c | 2 +-=0A 2 files changed, 2 i=
nsertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/media/platform/exyno=
s4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c=0Aindex dbc=
4f57f34a5..8efe9160ab34 100644=0A--- a/drivers/media/platform/exynos4-is/fi=
mc-isp.c=0A+++ b/drivers/media/platform/exynos4-is/fimc-isp.c=0A@@ -311,10 =
+311,8 @@ static int fimc_isp_subdev_s_power(struct v4l2_subdev *sd, int on=
)=0A =0A 	if (on) {=0A 		ret =3D pm_runtime_get_sync(&is->pdev->dev);=0A-		=
if (ret < 0) {=0A-			pm_runtime_put(&is->pdev->dev);=0A+		if (ret < 0)=0A 	=
		return ret;=0A-		}=0A 		set_bit(IS_ST_PWR_ON, &is->state);=0A =0A 		ret =
=3D fimc_is_start_firmware(is);=0Adiff --git a/drivers/media/platform/exyno=
s4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c=0Aindex f=
1921e06ffe1..b91abf1c4d43 100644=0A--- a/drivers/media/platform/exynos4-is/=
fimc-lite.c=0A+++ b/drivers/media/platform/exynos4-is/fimc-lite.c=0A@@ -480=
,7 +480,7 @@ static int fimc_lite_open(struct file *file)=0A 	set_bit(ST_FL=
ITE_IN_USE, &fimc->state);=0A 	ret =3D pm_runtime_get_sync(&fimc->pdev->dev=
);=0A 	if (ret < 0)=0A-		goto err_pm;=0A+		goto unlock;=0A =0A 	ret =3D v4l=
2_fh_open(file);=0A 	if (ret < 0)=0A-- =0A2.30.2=0A=0A=0AFrom 98c29dff72fbc=
db47e31bdf495999f358c2089f2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:00 +0100=0ASu=
bject: [PATCH 06/62] Revert "media: exynos4-is: Fix a reference count leak=
=0A due to pm_runtime_get_sync"=0A=0AThis reverts commit 6e8429c2946fd179c2=
7a165aca9f2ab6aea2ae1d.=0A=0ACommits from @umn.edu addresses have been foun=
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
atform/exynos4-is/media-dev.c | 4 +---=0A 1 file changed, 1 insertion(+), 3=
 deletions(-)=0A=0Adiff --git a/drivers/media/platform/exynos4-is/media-dev=
=2Ec b/drivers/media/platform/exynos4-is/media-dev.c=0Aindex a1599659b88b..=
532b7cd361dc 100644=0A--- a/drivers/media/platform/exynos4-is/media-dev.c=
=0A+++ b/drivers/media/platform/exynos4-is/media-dev.c=0A@@ -477,10 +477,8 =
@@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)=0A 		re=
turn -ENXIO;=0A =0A 	ret =3D pm_runtime_get_sync(fmd->pmf);=0A-	if (ret < 0=
) {=0A-		pm_runtime_put(fmd->pmf);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=
=0A =0A 	fmd->num_sensors =3D 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom f70f7a24e9=
33602511bd7230ae5e20a446c7dc15 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:01 +0100=
=0ASubject: [PATCH 07/62] Revert "media: exynos4-is: Fix a reference count =
leak"=0A=0AThis reverts commit 5dde90751d407a74b08f2ceb4f876de65bd8f3d3.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/media/platform/exynos4-is/mipi-csis=
=2Ec | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff -=
-git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platfo=
rm/exynos4-is/mipi-csis.c=0Aindex dc87c9cfa52f..befd9fc0adc4 100644=0A--- a=
/drivers/media/platform/exynos4-is/mipi-csis.c=0A+++ b/drivers/media/platfo=
rm/exynos4-is/mipi-csis.c=0A@@ -513,10 +513,8 @@ static int s5pcsis_s_strea=
m(struct v4l2_subdev *sd, int enable)=0A 	if (enable) {=0A 		s5pcsis_clear_=
counters(state);=0A 		ret =3D pm_runtime_get_sync(&state->pdev->dev);=0A-		=
if (ret && ret !=3D 1) {=0A-			pm_runtime_put_noidle(&state->pdev->dev);=0A=
+		if (ret && ret !=3D 1)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	mutex_lock=
(&state->lock);=0A-- =0A2.30.2=0A=0A=0AFrom 0639d384fe2ed34ee8a50837c5fdc24=
b97e6aee4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:01 +0100=0ASubject: [PATCH 08/6=
2] Revert "media: ti-vpe: Fix a missing check and=0A reference count leak"=
=0A=0AThis reverts commit c772cb1c8c15bd5bfb294cf432f902dfd9e7a696.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/media/platform/ti-vpe/vpe.c | 2 --=0A 1 f=
ile changed, 2 deletions(-)=0A=0Adiff --git a/drivers/media/platform/ti-vpe=
/vpe.c b/drivers/media/platform/ti-vpe/vpe.c=0Aindex 360a2ad14ce4..dbb4829a=
cc43 100644=0A--- a/drivers/media/platform/ti-vpe/vpe.c=0A+++ b/drivers/med=
ia/platform/ti-vpe/vpe.c=0A@@ -2133,8 +2133,6 @@ static int vpe_runtime_get=
(struct platform_device *pdev)=0A =0A 	r =3D pm_runtime_get_sync(&pdev->dev=
);=0A 	WARN_ON(r < 0);=0A-	if (r)=0A-		pm_runtime_put_noidle(&pdev->dev);=
=0A 	return r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 09f95faf7ba=
f9fdc74e09b3f64d04faa79dfd251 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:01 +0100=0A=
Subject: [PATCH 09/62] Revert "media: platform: fcp: Fix a reference count=
=0A leak."=0A=0AThis reverts commit 3af18152d6802b9f95fc04cd7eec5dc13b6cfe2=
f.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/rcar-fcp.c | =
4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/=
drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c=0Aind=
ex 5b5722e65e9b..8e9c3bd36d03 100644=0A--- a/drivers/media/platform/rcar-fc=
p.c=0A+++ b/drivers/media/platform/rcar-fcp.c=0A@@ -107,10 +107,8 @@ int rc=
ar_fcp_enable(struct rcar_fcp_device *fcp)=0A 		return 0;=0A =0A 	ret =3D p=
m_runtime_get_sync(fcp->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle=
(fcp->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	return 0;=0A }=
=0A-- =0A2.30.2=0A=0A=0AFrom b258fa1a1d12d4f8912292978112e9279683218e Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:38:01 +0100=0ASubject: [PATCH 10/62] Revert "ASoC=
: tegra: Fix reference count leaks."=0A=0AThis reverts commit ed7edd4264c38=
5a833fe985f11ce21c14faef35e.=0A=0ACommits from @umn.edu addresses have been=
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
tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c=0Aindex e441e23a37e4.=
=2Efef3b9a21a66 100644=0A--- a/sound/soc/tegra/tegra30_ahub.c=0A+++ b/sound=
/soc/tegra/tegra30_ahub.c=0A@@ -656,10 +656,8 @@ static int tegra30_ahub_re=
sume(struct device *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(d=
ev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		ret=
urn ret;=0A-	}=0A 	ret =3D regcache_sync(ahub->regmap_ahub);=0A 	ret |=3D r=
egcache_sync(ahub->regmap_apbif);=0A 	pm_runtime_put(dev);=0Adiff --git a/s=
ound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c=0Aindex 516f37=
896092..8e55583aa104 100644=0A--- a/sound/soc/tegra/tegra30_i2s.c=0A+++ b/s=
ound/soc/tegra/tegra30_i2s.c=0A@@ -552,10 +552,8 @@ static int tegra30_i2s_=
resume(struct device *dev)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync=
(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		r=
eturn ret;=0A-	}=0A 	ret =3D regcache_sync(i2s->regmap);=0A 	pm_runtime_put=
(dev);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 3b8e79ff2d4da253f906520a44ef3150fdbc=
ebe9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 20:38:01 +0100=0ASubject: [PATCH 11/62] Re=
vert "iommu: Fix reference count leak in=0A iommu_group_alloc."=0A=0AThis r=
everts commit 44ac6becd5c68be7bfe95335f7f8788174c1e02f.=0A=0ACommits from @=
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
iommu.c=0Aindex d609e14bb904..dbcc13efaf3c 100644=0A--- a/drivers/iommu/iom=
mu.c=0A+++ b/drivers/iommu/iommu.c=0A@@ -195,7 +195,7 @@ struct iommu_group=
 *iommu_group_alloc(void)=0A 				   NULL, "%d", group->id);=0A 	if (ret) {=
=0A 		ida_simple_remove(&iommu_group_ida, group->id);=0A-		kobject_put(&gro=
up->kobj);=0A+		kfree(group);=0A 		return ERR_PTR(ret);=0A 	}=0A =0A-- =0A2=
=2E30.2=0A=0A=0AFrom 9f4e23b63443aa35e404b68c79f2563f3a6c4b40 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:38:02 +0100=0ASubject: [PATCH 12/62] Revert "ACPI: CPPC: =
Fix reference count leak in=0A acpi_cppc_processor_probe()"=0A=0AThis rever=
ts commit 17cac70bdf319d85e6f4ba78f686c06ee55f86cf.=0A=0ACommits from @umn.=
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
m>=0A---=0A drivers/acpi/cppc_acpi.c | 4 +---=0A 1 file changed, 1 insertio=
n(+), 3 deletions(-)=0A=0Adiff --git a/drivers/acpi/cppc_acpi.c b/drivers/a=
cpi/cppc_acpi.c=0Aindex 318bdfb8703c..9ec4618df533 100644=0A--- a/drivers/a=
cpi/cppc_acpi.c=0A+++ b/drivers/acpi/cppc_acpi.c=0A@@ -793,10 +793,8 @@ int=
 acpi_cppc_processor_probe(struct acpi_processor *pr)=0A =0A 	ret =3D kobje=
ct_init_and_add(&cpc_ptr->kobj, &cppc_ktype, &cpu_dev->kobj,=0A 			"acpi_cp=
pc");=0A-	if (ret) {=0A-		kobject_put(&cpc_ptr->kobj);=0A+	if (ret)=0A 		go=
to out_free;=0A-	}=0A =0A 	kfree(output.pointer);=0A 	return 0;=0A-- =0A2.3=
0.2=0A=0A=0AFrom d4a1bf427747f2d742d74ec362f750d82bb4c572 Mon Sep 17 00:00:=
00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 2=
1 Apr 2021 20:38:02 +0100=0ASubject: [PATCH 13/62] Revert "ACPI: sysfs: Fix=
 reference count leak in=0A acpi_sysfs_add_hotplug_profile()"=0A=0AThis rev=
erts commit bdce493344432a5ce4afa45e6ec8d14edd8dd468.=0A=0ACommits from @um=
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
m>=0A---=0A drivers/acpi/sysfs.c | 4 +---=0A 1 file changed, 1 insertion(+)=
, 3 deletions(-)=0A=0Adiff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysf=
s.c=0Aindex 764786cfb0d9..f8d3be1a5e58 100644=0A--- a/drivers/acpi/sysfs.c=
=0A+++ b/drivers/acpi/sysfs.c=0A@@ -898,10 +898,8 @@ void acpi_sysfs_add_ho=
tplug_profile(struct acpi_hotplug_profile *hotplug,=0A =0A 	error =3D kobje=
ct_init_and_add(&hotplug->kobj,=0A 		&acpi_hotplug_profile_ktype, hotplug_k=
obj, "%s", name);=0A-	if (error) {=0A-		kobject_put(&hotplug->kobj);=0A+	if=
 (error)=0A 		goto err_out;=0A-	}=0A =0A 	kobject_uevent(&hotplug->kobj, KO=
BJ_ADD);=0A 	return;=0A-- =0A2.30.2=0A=0A=0AFrom 41bf52342799b3868964cdccd4=
72bb334652681f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:02 +0100=0ASubject: [PATCH=
 14/62] Revert "qlcnic: fix missing release in=0A qlcnic_83xx_interrupt_tes=
t."=0A=0AThis reverts commit 0dee5beb6c802c16bb2cfc94976c1e215a681427.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_8=
3xx_hw.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adi=
ff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/ne=
t/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0Aindex 5d2de48b77a0..35c5ac41c0a=
1 100644=0A--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A+++ =
b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A@@ -3610,7 +3610,7 =
@@ int qlcnic_83xx_interrupt_test(struct net_device *netdev)=0A 	ahw->diag_=
cnt =3D 0;=0A 	ret =3D qlcnic_alloc_mbx_args(&cmd, adapter, QLCNIC_CMD_INTR=
PT_TEST);=0A 	if (ret)=0A-		goto fail_mbx_args;=0A+		goto fail_diag_irq;=0A=
 =0A 	if (adapter->flags & QLCNIC_MSIX_ENABLED)=0A 		intrpt_id =3D ahw->int=
r_tbl[0].id;=0A@@ -3640,8 +3640,6 @@ int qlcnic_83xx_interrupt_test(struct =
net_device *netdev)=0A =0A done:=0A 	qlcnic_free_mbx_args(&cmd);=0A-=0A-fai=
l_mbx_args:=0A 	qlcnic_83xx_diag_free_res(netdev, drv_sds_rings);=0A =0A fa=
il_diag_irq:=0A-- =0A2.30.2=0A=0A=0AFrom da41cd0a193f526cb76739971fa55445a4=
234654 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:38:02 +0100=0ASubject: [PATCH 15/62] =
Revert "usb: gadget: fix potential double-free in=0A m66592_probe."=0A=0ATh=
is reverts commit 03eeb914f9ef479a8ceff1f25d14bd4075bdc3a9.=0A=0ACommits fr=
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
ail.com>=0A---=0A drivers/usb/gadget/udc/m66592-udc.c | 2 +-=0A 1 file chan=
ged, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/usb/gadget/udc=
/m66592-udc.c b/drivers/usb/gadget/udc/m66592-udc.c=0Aindex 1be409644a48..6=
e977dc22570 100644=0A--- a/drivers/usb/gadget/udc/m66592-udc.c=0A+++ b/driv=
ers/usb/gadget/udc/m66592-udc.c=0A@@ -1672,7 +1672,7 @@ static int m66592_p=
robe(struct platform_device *pdev)=0A =0A err_add_udc:=0A 	m66592_free_requ=
est(&m66592->ep[0].ep, m66592->ep0_req);=0A-	m66592->ep0_req =3D NULL;=0A+=
=0A clean_up3:=0A 	if (m66592->pdata->on_chip) {=0A 		clk_disable(m66592->c=
lk);=0A-- =0A2.30.2=0A=0A=0AFrom 44d1a174d5f37646ec8dfe0be4bb7843335b9d2c M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:38:03 +0100=0ASubject: [PATCH 16/62] Revert "=
net/mlx4_core: fix a memory leak bug."=0A=0AThis reverts commit 2256bf0ea08=
fe75111a8aa8085cbc2b3e7be09a5.=0A=0ACommits from @umn.edu addresses have be=
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
d-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net=
/ethernet/mellanox/mlx4/fw.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 de=
letion(-)=0A=0Adiff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drive=
rs/net/ethernet/mellanox/mlx4/fw.c=0Aindex 7c3e505cf255..8542aea4d905 10064=
4=0A--- a/drivers/net/ethernet/mellanox/mlx4/fw.c=0A+++ b/drivers/net/ether=
net/mellanox/mlx4/fw.c=0A@@ -2704,7 +2704,7 @@ void mlx4_opreq_action(struc=
t work_struct *work)=0A 		if (err) {=0A 			mlx4_err(dev, "Failed to retriev=
e required operation: %d\n",=0A 				 err);=0A-			goto out;=0A+			return;=0A=
 		}=0A 		MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);=0A 		MLX4=
_GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);=0A-- =0A2.30.2=0A=0A=0AFrom 9=
ff9451bc450a153cd2d99d82ae37e62090a1c08 Mon Sep 17 00:00:00 2001=0AFrom: Su=
dip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:0=
3 +0100=0ASubject: [PATCH 17/62] Revert "agp/intel: Fix a memory leak on mo=
dule=0A initialisation failure"=0A=0AThis reverts commit 7d755eab2bcfc84bc7=
c9b55ccf907fe3c6831563.=0A=0ACommits from @umn.edu addresses have been foun=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/char/agp=
/intel-gtt.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=
=0Adiff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c=
=0Aindex 667882e996ec..871e7f4994e8 100644=0A--- a/drivers/char/agp/intel-g=
tt.c=0A+++ b/drivers/char/agp/intel-gtt.c=0A@@ -303,10 +303,8 @@ static int=
 intel_gtt_setup_scratch_page(void)=0A 	if (intel_private.needs_dmar) {=0A =
		dma_addr =3D pci_map_page(intel_private.pcidev, page, 0,=0A 				    PAGE_=
SIZE, PCI_DMA_BIDIRECTIONAL);=0A-		if (pci_dma_mapping_error(intel_private.=
pcidev, dma_addr)) {=0A-			__free_page(page);=0A+		if (pci_dma_mapping_erro=
r(intel_private.pcidev, dma_addr))=0A 			return -EINVAL;=0A-		}=0A =0A 		in=
tel_private.scratch_page_dma =3D dma_addr;=0A 	} else=0A-- =0A2.30.2=0A=0A=
=0AFrom 76c19682031378331bf8e0a6fde39f320472a56a Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:38:03 +0100=0ASubject: [PATCH 18/62] Revert "ecryptfs: replace BUG_O=
N with error handling=0A code"=0A=0AThis reverts commit 61faa537979103e4a55=
714a4c0e17153485e9d39.=0A=0ACommits from @umn.edu addresses have been found=
 to be submitted in "bad=0Afaith" to try to test the kernel community's abi=
lity to review "known=0Amalicious" changes.  The result of these submission=
s can be found in a=0Apaper published at the 42nd IEEE Symposium on Securit=
y and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A fs/ecryptfs/cryp=
to.c | 6 ++----=0A 1 file changed, 2 insertions(+), 4 deletions(-)=0A=0Adif=
f --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c=0Aindex ff6cf23be8a2.=
=2Ecb77e7ee2c9f 100644=0A--- a/fs/ecryptfs/crypto.c=0A+++ b/fs/ecryptfs/cry=
pto.c=0A@@ -339,10 +339,8 @@ static int crypt_scatterlist(struct ecryptfs_c=
rypt_stat *crypt_stat,=0A 	struct extent_crypt_result ecr;=0A 	int rc =3D 0=
;=0A =0A-	if (!crypt_stat || !crypt_stat->tfm=0A-	       || !(crypt_stat->f=
lags & ECRYPTFS_STRUCT_INITIALIZED))=0A-		return -EINVAL;=0A-=0A+	BUG_ON(!c=
rypt_stat || !crypt_stat->tfm=0A+	       || !(crypt_stat->flags & ECRYPTFS_=
STRUCT_INITIALIZED));=0A 	if (unlikely(ecryptfs_verbosity > 0)) {=0A 		ecry=
ptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",=0A 				crypt_stat->key_si=
ze);=0A-- =0A2.30.2=0A=0A=0AFrom ba29e42d4372937d2ad8e825b5d60221b66d30cf M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:38:03 +0100=0ASubject: [PATCH 19/62] Revert "=
net: sun: fix missing release regions in=0A cas_init_one()."=0A=0AThis reve=
rts commit 6a6237db07083785de882a3147f76bba78d372c0.=0A=0ACommits from @umn=
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
om>=0A---=0A drivers/net/ethernet/sun/cassini.c | 3 ++-=0A 1 file changed, =
2 insertions(+), 1 deletion(-)=0A=0Adiff --git a/drivers/net/ethernet/sun/c=
assini.c b/drivers/net/ethernet/sun/cassini.c=0Aindex bfe7b55f9714..062bce9=
acde6 100644=0A--- a/drivers/net/ethernet/sun/cassini.c=0A+++ b/drivers/net=
/ethernet/sun/cassini.c=0A@@ -4980,7 +4980,7 @@ static int cas_init_one(str=
uct pci_dev *pdev, const struct pci_device_id *ent)=0A 					  cas_cacheline=
_size)) {=0A 			dev_err(&pdev->dev, "Could not set PCI cache "=0A 			      =
 "line size\n");=0A-			goto err_out_free_res;=0A+			goto err_write_cachelin=
e;=0A 		}=0A 	}=0A #endif=0A@@ -5151,6 +5151,7 @@ static int cas_init_one(s=
truct pci_dev *pdev, const struct pci_device_id *ent)=0A err_out_free_res:=
=0A 	pci_release_regions(pdev);=0A =0A+err_write_cacheline:=0A 	/* Try to r=
estore it in case the error occurred after we=0A 	 * set it.=0A 	 */=0A-- =
=0A2.30.2=0A=0A=0AFrom c00ce5b9a21412d005ddaa9ef92d15c7254ea9af Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:38:04 +0100=0ASubject: [PATCH 20/62] Revert "efi/esrt: =
Fix reference count leak in=0A esre_create_sysfs_entry."=0A=0AThis reverts =
commit 83fc0cb8db7adf36a75f6cf55820ee386721bd1b.=0A=0ACommits from @umn.edu=
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
---=0A drivers/firmware/efi/esrt.c | 2 +-=0A 1 file changed, 1 insertion(+)=
, 1 deletion(-)=0A=0Adiff --git a/drivers/firmware/efi/esrt.c b/drivers/fir=
mware/efi/esrt.c=0Aindex 481b2f0a190b..241dd7c63d2c 100644=0A--- a/drivers/=
firmware/efi/esrt.c=0A+++ b/drivers/firmware/efi/esrt.c=0A@@ -180,7 +180,7 =
@@ static int esre_create_sysfs_entry(void *esre, int entry_num)=0A 		rc =
=3D kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,=0A 					  "entry=
%d", entry_num);=0A 		if (rc) {=0A-			kobject_put(&entry->kobj);=0A+			kfre=
e(entry);=0A 			return rc;=0A 		}=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 21917be=
d9cd607c5425e3eb60a8f164d6bb99f40 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:04 +010=
0=0ASubject: [PATCH 21/62] Revert "scsi: iscsi: Fix reference count leak in=
=0A iscsi_boot_create_kobj"=0A=0AThis reverts commit fbffea5caf01cd8d55f0e4=
4b5644a4ac4f67b4da.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/iscsi_boo=
t_sysfs.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff=
 --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c=
=0Aindex 15d64f96e623..d453667612f8 100644=0A--- a/drivers/scsi/iscsi_boot_=
sysfs.c=0A+++ b/drivers/scsi/iscsi_boot_sysfs.c=0A@@ -360,7 +360,7 @@ iscsi=
_boot_create_kobj(struct iscsi_boot_kset *boot_kset,=0A 	boot_kobj->kobj.ks=
et =3D boot_kset->kset;=0A 	if (kobject_init_and_add(&boot_kobj->kobj, &isc=
si_boot_ktype,=0A 				 NULL, name, index)) {=0A-		kobject_put(&boot_kobj->k=
obj);=0A+		kfree(boot_kobj);=0A 		return NULL;=0A 	}=0A 	boot_kobj->data =
=3D data;=0A-- =0A2.30.2=0A=0A=0AFrom 684be36272f9f51b1579b34039c0c48864a71=
1eb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0ADate: Wed, 21 Apr 2021 20:38:04 +0100=0ASubject: [PATCH 22/62] Rev=
ert "cpuidle: Fix three reference count leaks"=0A=0AThis reverts commit 42b=
548b9e9248ffd2f378bd4cbcb31d692ef3280.=0A=0ACommits from @umn.edu addresses=
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
drivers/cpuidle/sysfs.c | 6 +++---=0A 1 file changed, 3 insertions(+), 3 de=
letions(-)=0A=0Adiff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysf=
s.c=0Aindex e7e92ed34f0c..9e98a5fbbc1d 100644=0A--- a/drivers/cpuidle/sysfs=
=2Ec=0A+++ b/drivers/cpuidle/sysfs.c=0A@@ -412,7 +412,7 @@ static int cpuid=
le_add_state_sysfs(struct cpuidle_device *device)=0A 		ret =3D kobject_init=
_and_add(&kobj->kobj, &ktype_state_cpuidle,=0A 					   &kdev->kobj, "state%=
d", i);=0A 		if (ret) {=0A-			kobject_put(&kobj->kobj);=0A+			kfree(kobj);=
=0A 			goto error_state;=0A 		}=0A 		kobject_uevent(&kobj->kobj, KOBJ_ADD);=
=0A@@ -542,7 +542,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_d=
evice *dev)=0A 	ret =3D kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpu=
idle,=0A 				   &kdev->kobj, "driver");=0A 	if (ret) {=0A-		kobject_put(&kd=
rv->kobj);=0A+		kfree(kdrv);=0A 		return ret;=0A 	}=0A =0A@@ -636,7 +636,7 =
@@ int cpuidle_add_sysfs(struct cpuidle_device *dev)=0A 	error =3D kobject_=
init_and_add(&kdev->kobj, &ktype_cpuidle, &cpu_dev->kobj,=0A 				   "cpuidl=
e");=0A 	if (error) {=0A-		kobject_put(&kdev->kobj);=0A+		kfree(kdev);=0A 	=
	return error;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 268dd3859d3ce307a3d2d3=
e96b6bcb84e0edd6ed Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:04 +0100=0ASubject: =
[PATCH 23/62] Revert "EDAC: Fix reference count leaks"=0A=0AThis reverts co=
mmit 91a1b253ed61172d87dd8c5408897c91a8ece426.=0A=0ACommits from @umn.edu a=
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
-=0A drivers/edac/edac_device_sysfs.c | 1 -=0A drivers/edac/edac_pci_sysfs.=
c    | 2 +-=0A 2 files changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --=
git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c=
=0Aindex 470b02fc2de9..93da1a45c716 100644=0A--- a/drivers/edac/edac_device=
_sysfs.c=0A+++ b/drivers/edac/edac_device_sysfs.c=0A@@ -275,7 +275,6 @@ int=
 edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev=
)=0A =0A 	/* Error exit stack */=0A err_kobj_reg:=0A-	kobject_put(&edac_dev=
->kobj);=0A 	module_put(edac_dev->owner);=0A =0A err_out:=0Adiff --git a/dr=
ivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c=0Aindex 622d117=
e2533..6e3428ba400f 100644=0A--- a/drivers/edac/edac_pci_sysfs.c=0A+++ b/dr=
ivers/edac/edac_pci_sysfs.c=0A@@ -386,7 +386,7 @@ static int edac_pci_main_=
kobj_setup(void)=0A =0A 	/* Error unwind statck */=0A kobject_init_and_add_=
fail:=0A-	kobject_put(edac_pci_top_main_kobj);=0A+	kfree(edac_pci_top_main_=
kobj);=0A =0A kzalloc_fail:=0A 	module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=
=0A=0AFrom 112e362cd0e26c7431ccc870236a6359e76686d6 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:38:05 +0100=0ASubject: [PATCH 24/62] Revert "rapidio: fix a NULL po=
inter dereference when=0A create_workqueue() fails"=0A=0AThis reverts commi=
t 506e0ced8dc3f2cccca5e72e9aeb572e0315c367.=0A=0ACommits from @umn.edu addr=
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
--=0A drivers/rapidio/rio_cm.c | 8 --------=0A 1 file changed, 8 deletions(=
-)=0A=0Adiff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c=0A=
index b29fc258eeba..cf45829585cb 100644=0A--- a/drivers/rapidio/rio_cm.c=0A=
+++ b/drivers/rapidio/rio_cm.c=0A@@ -2147,14 +2147,6 @@ static int riocm_ad=
d_mport(struct device *dev,=0A 	mutex_init(&cm->rx_lock);=0A 	riocm_rx_fill=
(cm, RIOCM_RX_RING_SIZE);=0A 	cm->rx_wq =3D create_workqueue(DRV_NAME "/rxq=
");=0A-	if (!cm->rx_wq) {=0A-		riocm_error("failed to allocate IBMBOX_%d on=
 %s",=0A-			    cmbox, mport->name);=0A-		rio_release_outb_mbox(mport, cmbo=
x);=0A-		kfree(cm);=0A-		return -ENOMEM;=0A-	}=0A-=0A 	INIT_WORK(&cm->rx_wo=
rk, rio_ibmsg_handler);=0A =0A 	cm->tx_slot =3D 0;=0A-- =0A2.30.2=0A=0A=0AF=
rom 5357ff10298f3b2c659c006b40152a34fedf87c7 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:38:05 +0100=0ASubject: [PATCH 25/62] Revert "tracing: Fix a memory leak by=
 early error exit=0A in trace_pid_write()"=0A=0AThis reverts commit 3ddc299=
357094265573482856191dec115c93cb2.=0A=0ACommits from @umn.edu addresses hav=
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
igned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A kernel/=
trace/trace.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=
=0A=0Adiff --git a/kernel/trace/trace.c b/kernel/trace/trace.c=0Aindex 8c6b=
682b83b8..f3d6bcc32716 100644=0A--- a/kernel/trace/trace.c=0A+++ b/kernel/t=
race/trace.c=0A@@ -500,10 +500,8 @@ int trace_pid_write(struct trace_pid_li=
st *filtered_pids,=0A 	 * not modified.=0A 	 */=0A 	pid_list =3D kmalloc(si=
zeof(*pid_list), GFP_KERNEL);=0A-	if (!pid_list) {=0A-		trace_parser_put(&p=
arser);=0A+	if (!pid_list)=0A 		return -ENOMEM;=0A-	}=0A =0A 	pid_list->pid=
_max =3D READ_ONCE(pid_max);=0A =0A@@ -513,7 +511,6 @@ int trace_pid_write(=
struct trace_pid_list *filtered_pids,=0A =0A 	pid_list->pids =3D vzalloc((p=
id_list->pid_max + 7) >> 3);=0A 	if (!pid_list->pids) {=0A-		trace_parser_p=
ut(&parser);=0A 		kfree(pid_list);=0A 		return -ENOMEM;=0A 	}=0A-- =0A2.30.=
2=0A=0A=0AFrom 092cf949cb1ebcbf9c489c2f1cca32f3f065b28a Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:38:05 +0100=0ASubject: [PATCH 26/62] Revert "net: cw1200: fix a=
 NULL pointer dereference"=0A=0AThis reverts commit 2f3201b23b69bbae2f9fec1=
8648b45df5cd93960.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/st=
/cw1200/main.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git =
a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/ma=
in.c=0Aindex f4338bce78f4..30c0ff70c874 100644=0A--- a/drivers/net/wireless=
/st/cw1200/main.c=0A+++ b/drivers/net/wireless/st/cw1200/main.c=0A@@ -345,1=
1 +345,6 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macadd=
r,=0A 	mutex_init(&priv->wsm_cmd_mux);=0A 	mutex_init(&priv->conf_mutex);=
=0A 	priv->workqueue =3D create_singlethread_workqueue("cw1200_wq");=0A-	if=
 (!priv->workqueue) {=0A-		ieee80211_free_hw(hw);=0A-		return NULL;=0A-	}=
=0A-=0A 	sema_init(&priv->scan.lock, 1);=0A 	INIT_WORK(&priv->scan.work, cw=
1200_scan_work);=0A 	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe=
_work);=0A-- =0A2.30.2=0A=0A=0AFrom 74064fbcb1d89455ca624dd0fce7f0ba4f300f3=
5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 20:38:05 +0100=0ASubject: [PATCH 27/62] Rever=
t "x86/PCI: Fix PCI IRQ routing table memory leak"=0A=0AThis reverts commit=
 f460e08e1c5ec5a355384107356d61c3cff328fd.=0A=0ACommits from @umn.edu addre=
sses have been found to be submitted in "bad=0Afaith" to try to test the ke=
rnel community's ability to review "known=0Amalicious" changes.  The result=
 of these submissions can be found in a=0Apaper published at the 42nd IEEE =
Symposium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stea=
lthily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qius=
hi Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=
=0A=0ABecause of this, all submissions from this group must be reverted fro=
m=0Athe kernel tree and will need to be re-reviewed again to determine if=
=0Athey actually are a valid fix.  Until that work is complete, remove this=
=0Achange to ensure that no problems are being introduced into the=0Acodeba=
se.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=
=0A arch/x86/pci/irq.c | 10 ++--------=0A 1 file changed, 2 insertions(+), =
8 deletions(-)=0A=0Adiff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c=0A=
index 5f0e596b0519..9bd115484745 100644=0A--- a/arch/x86/pci/irq.c=0A+++ b/=
arch/x86/pci/irq.c=0A@@ -1117,8 +1117,6 @@ static struct dmi_system_id __in=
itdata pciirq_dmi_table[] =3D {=0A =0A void __init pcibios_irq_init(void)=
=0A {=0A-	struct irq_routing_table *rtable =3D NULL;=0A-=0A 	DBG(KERN_DEBUG=
 "PCI: IRQ init\n");=0A =0A 	if (raw_pci_ops =3D=3D NULL)=0A@@ -1129,10 +11=
27,8 @@ void __init pcibios_irq_init(void)=0A 	pirq_table =3D pirq_find_rou=
ting_table();=0A =0A #ifdef CONFIG_PCI_BIOS=0A-	if (!pirq_table && (pci_pro=
be & PCI_BIOS_IRQ_SCAN)) {=0A+	if (!pirq_table && (pci_probe & PCI_BIOS_IRQ=
_SCAN))=0A 		pirq_table =3D pcibios_get_irq_routing_table();=0A-		rtable =
=3D pirq_table;=0A-	}=0A #endif=0A 	if (pirq_table) {=0A 		pirq_peer_trick(=
);=0A@@ -1147,10 +1143,8 @@ void __init pcibios_irq_init(void)=0A 		 * If w=
e're using the I/O APIC, avoid using the PCI IRQ=0A 		 * routing table=0A 	=
	 */=0A-		if (io_apic_assign_pci_irqs) {=0A-			kfree(rtable);=0A+		if (io_a=
pic_assign_pci_irqs)=0A 			pirq_table =3D NULL;=0A-		}=0A 	}=0A =0A 	x86_in=
it.pci.fixup_irqs();=0A-- =0A2.30.2=0A=0A=0AFrom f6c1ccd15b87c8e860bb0c7d4f=
ea1e33a5b98d55 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:06 +0100=0ASubject: [PATCH=
 28/62] Revert "mmc_spi: add a status check for=0A spi_sync_locked"=0A=0ATh=
is reverts commit cb1962ff432a5d14810013c6afe27c89ca752ad0.=0A=0ACommits fr=
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
t/mmc_spi.c=0Aindex 279d5da6e54b..23d5ea62242a 100644=0A--- a/drivers/mmc/h=
ost/mmc_spi.c=0A+++ b/drivers/mmc/host/mmc_spi.c=0A@@ -819,10 +819,6 @@ mmc=
_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,=0A 	}=0A =
=0A 	status =3D spi_sync_locked(spi, &host->m);=0A-	if (status < 0) {=0A-		=
dev_dbg(&spi->dev, "read error %d\n", status);=0A-		return status;=0A-	}=0A=
 =0A 	if (host->dma_dev) {=0A 		dma_sync_single_for_cpu(host->dma_dev,=0A--=
 =0A2.30.2=0A=0A=0AFrom e03432b7cf5814d3636b2452d1b34fa770ec2d27 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:38:06 +0100=0ASubject: [PATCH 29/62] Revert "iio: hmc5=
843: fix potential NULL pointer=0A dereferences"=0A=0AThis reverts commit 2=
fd9d6a0fd6944360ad05c8646ed11c87671d6bf.=0A=0ACommits from @umn.edu address=
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
);=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 2c88242bbc0aebb61233749525e3f6cf0f5=
bf146 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:38:06 +0100=0ASubject: [PATCH 30/62] R=
evert "rtlwifi: fix a potential NULL pointer=0A dereference"=0A=0AThis reve=
rts commit 088c9aa3ce6a6cddb38f3c7b561e5aadd4ca2f09.=0A=0ACommits from @umn=
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
lwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c=0Aindex 7de18ed1=
0db8..4ac928bf1f8e 100644=0A--- a/drivers/net/wireless/realtek/rtlwifi/base=
=2Ec=0A+++ b/drivers/net/wireless/realtek/rtlwifi/base.c=0A@@ -466,11 +466,=
6 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)=0A 	/* <2=
> work queue */=0A 	rtlpriv->works.hw =3D hw;=0A 	rtlpriv->works.rtl_wq =3D=
 alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);=0A-	if (unlikely(!rtlpriv=
->works.rtl_wq)) {=0A-		pr_err("Failed to allocate work queue\n");=0A-		ret=
urn;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,=0A 			  (=
void *)rtl_watchdog_wq_callback);=0A 	INIT_DELAYED_WORK(&rtlpriv->works.ips=
_nic_off_wq,=0A-- =0A2.30.2=0A=0A=0AFrom 3bc37b9724098a32049d1cc4aeec691e4f=
3c158c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:38:06 +0100=0ASubject: [PATCH 31/62] =
Revert "video: hgafb: fix potential NULL pointer=0A dereference"=0A=0AThis =
reverts commit b509b1c0ece2b166fb2400bd331068b9cbe4c2fe.=0A=0ACommits from =
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
1;=0A-- =0A2.30.2=0A=0A=0AFrom 4fee604c47e878274a9c4f7dedb7f78c18d8f785 Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:38:07 +0100=0ASubject: [PATCH 32/62] Revert "v=
ideo: imsttfb: fix potential NULL pointer=0A dereferences"=0A=0AThis revert=
s commit 9cc334c336c839e1a22ecfbd4e0a9463a5cb0f83.=0A=0ACommits from @umn.e=
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
dev/imsttfb.c=0Aindex 4ef9dc94e813..4363c64d74e8 100644=0A--- a/drivers/vid=
eo/fbdev/imsttfb.c=0A+++ b/drivers/video/fbdev/imsttfb.c=0A@@ -1516,11 +151=
6,6 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_devi=
ce_id *ent)=0A 	info->fix.smem_start =3D addr;=0A 	info->screen_base =3D (_=
_u8 *)ioremap(addr, par->ramdac =3D=3D IBM ?=0A 					    0x400000 : 0x80000=
0);=0A-	if (!info->screen_base) {=0A-		release_mem_region(addr, size);=0A-	=
	framebuffer_release(info);=0A-		return -ENOMEM;=0A-	}=0A 	info->fix.mmio_s=
tart =3D addr + 0x800000;=0A 	par->dc_regs =3D ioremap(addr + 0x800000, 0x1=
000);=0A 	par->cmap_regs_phys =3D addr + 0x840000;=0A-- =0A2.30.2=0A=0A=0AF=
rom 773a50a2b59869317c414db02349870bb1469733 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:38:07 +0100=0ASubject: [PATCH 33/62] Revert "rfkill: Fix incorrect check t=
o avoid NULL=0A pointer dereference"=0A=0AThis reverts commit 1e1672c5c6307=
d90fd86de3c4b039b3fad235b39.=0A=0ACommits from @umn.edu addresses have been=
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
ff --git a/net/rfkill/core.c b/net/rfkill/core.c=0Aindex 87c35844d7d9..8840=
27f62783 100644=0A--- a/net/rfkill/core.c=0A+++ b/net/rfkill/core.c=0A@@ -9=
40,13 +940,10 @@ static void rfkill_sync_work(struct work_struct *work)=0A =
int __must_check rfkill_register(struct rfkill *rfkill)=0A {=0A 	static uns=
igned long rfkill_no;=0A-	struct device *dev;=0A+	struct device *dev =3D &r=
fkill->dev;=0A 	int error;=0A =0A-	if (!rfkill)=0A-		return -EINVAL;=0A-=0A=
-	dev =3D &rfkill->dev;=0A+	BUG_ON(!rfkill);=0A =0A 	mutex_lock(&rfkill_glo=
bal_mutex);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 8afc3b92f3517765d658a8ee93d5d82=
a94f433c7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:07 +0100=0ASubject: [PATCH 34/6=
2] Revert "PCI: xilinx: Check for __get_free_pages()=0A failure"=0A=0AThis =
reverts commit d73c419cc5c528df713f91a802c8ead538563e1b.=0A=0ACommits from =
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
=2Ecom>=0A---=0A drivers/pci/host/pcie-xilinx.c | 12 ++----------=0A 1 file=
 changed, 2 insertions(+), 10 deletions(-)=0A=0Adiff --git a/drivers/pci/ho=
st/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c=0Aindex c3964fca57b0..613=
32f4d51c3 100644=0A--- a/drivers/pci/host/pcie-xilinx.c=0A+++ b/drivers/pci=
/host/pcie-xilinx.c=0A@@ -337,19 +337,14 @@ static const struct irq_domain_=
ops msi_domain_ops =3D {=0A  * xilinx_pcie_enable_msi - Enable MSI support=
=0A  * @port: PCIe port information=0A  */=0A-static int xilinx_pcie_enable=
_msi(struct xilinx_pcie_port *port)=0A+static void xilinx_pcie_enable_msi(s=
truct xilinx_pcie_port *port)=0A {=0A 	phys_addr_t msg_addr;=0A =0A 	port->=
msi_pages =3D __get_free_pages(GFP_KERNEL, 0);=0A-	if (!port->msi_pages)=0A=
-		return -ENOMEM;=0A-=0A 	msg_addr =3D virt_to_phys((void *)port->msi_page=
s);=0A 	pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);=0A 	pcie_write(por=
t, msg_addr, XILINX_PCIE_REG_MSIBASE2);=0A-=0A-	return 0;=0A }=0A =0A /* IN=
Tx Functions */=0A@@ -521,7 +516,6 @@ static int xilinx_pcie_init_irq_domai=
n(struct xilinx_pcie_port *port)=0A 	struct device *dev =3D port->dev;=0A 	=
struct device_node *node =3D dev->of_node;=0A 	struct device_node *pcie_int=
c_node;=0A-	int ret;=0A =0A 	/* Setup INTx */=0A 	pcie_intc_node =3D of_get=
_next_child(node, NULL);=0A@@ -550,9 +544,7 @@ static int xilinx_pcie_init_=
irq_domain(struct xilinx_pcie_port *port)=0A 			return -ENODEV;=0A 		}=0A =
=0A-		ret =3D xilinx_pcie_enable_msi(port);=0A-		if (ret)=0A-			return ret;=
=0A+		xilinx_pcie_enable_msi(port);=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=
=0A=0A=0AFrom 3a659d3ea8d2ce8e9f4cb6888b87e1bf0e53c8f5 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:38:07 +0100=0ASubject: [PATCH 35/62] Revert "drm/gma500: fix mem=
ory disclosures due to=0A uninitialized bytes"=0A=0AThis reverts commit c39=
118738793ecdde9207bec584769ed68677b4f.=0A=0ACommits from @umn.edu addresses=
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
drivers/gpu/drm/gma500/oaktrail_crtc.c | 2 --=0A 1 file changed, 2 deletion=
s(-)=0A=0Adiff --git a/drivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu=
/drm/gma500/oaktrail_crtc.c=0Aindex caa6da02206a..da9fd34b9550 100644=0A---=
 a/drivers/gpu/drm/gma500/oaktrail_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oa=
ktrail_crtc.c=0A@@ -139,7 +139,6 @@ static bool mrst_sdvo_find_best_pll(con=
st struct gma_limit_t *limit,=0A 	s32 freq_error, min_error =3D 100000;=0A =
=0A 	memset(best_clock, 0, sizeof(*best_clock));=0A-	memset(&clock, 0, size=
of(clock));=0A =0A 	for (clock.m =3D limit->m.min; clock.m <=3D limit->m.ma=
x; clock.m++) {=0A 		for (clock.n =3D limit->n.min; clock.n <=3D limit->n.m=
ax;=0A@@ -196,7 +195,6 @@ static bool mrst_lvds_find_best_pll(const struct =
gma_limit_t *limit,=0A 	int err =3D target;=0A =0A 	memset(best_clock, 0, s=
izeof(*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (clo=
ck.m =3D limit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		for (cl=
ock.p1 =3D limit->p1.min; clock.p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=
=0AFrom 25d7af14cb0c764bfb5b580ab761a45eae160238 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:38:08 +0100=0ASubject: [PATCH 36/62] Revert "gma/gma500: fix a memor=
y disclosure bug due to=0A uninitialized bytes"=0A=0AThis reverts commit 88=
aed7fb5d6d3e63ef1b618a6824a3e45595d92f.=0A=0ACommits from @umn.edu addresse=
s have been found to be submitted in "bad=0Afaith" to try to test the kerne=
l community's ability to review "known=0Amalicious" changes.  The result of=
 these submissions can be found in a=0Apaper published at the 42nd IEEE Sym=
posium on Security and Privacy=0Aentitled, "Open Source Insecurity: Stealth=
ily Introducing=0AVulnerabilities via Hypocrite Commits" written by Qiushi =
Wu (University=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=
=0ABecause of this, all submissions from this group must be reverted from=
=0Athe kernel tree and will need to be re-reviewed again to determine if=0A=
they actually are a valid fix.  Until that work is complete, remove this=0A=
change to ensure that no problems are being introduced into the=0Acodebase.=
=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A =
drivers/gpu/drm/gma500/cdv_intel_display.c | 2 --=0A 1 file changed, 2 dele=
tions(-)=0A=0Adiff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/dri=
vers/gpu/drm/gma500/cdv_intel_display.c=0Aindex 2e8479744ca4..17db4b4749d5 =
100644=0A--- a/drivers/gpu/drm/gma500/cdv_intel_display.c=0A+++ b/drivers/g=
pu/drm/gma500/cdv_intel_display.c=0A@@ -415,8 +415,6 @@ static bool cdv_int=
el_find_dp_pll(const struct gma_limit_t *limit,=0A 	struct gma_crtc *gma_cr=
tc =3D to_gma_crtc(crtc);=0A 	struct gma_clock_t clock;=0A =0A-	memset(&clo=
ck, 0, sizeof(clock));=0A-=0A 	switch (refclk) {=0A 	case 27000:=0A 		if (t=
arget < 200000) {=0A-- =0A2.30.2=0A=0A=0AFrom 80147322d4a4ea0e9eba4350e91b8=
d6e2f95994b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:08 +0100=0ASubject: [PATCH 37=
/62] Revert "spi : spi-topcliff-pch: Fix to handle empty DMA=0A buffers"=0A=
=0AThis reverts commit b764a801663a9cb6594bc1a4070b57e760f26780.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/spi/spi-topcliff-pch.c | 15 ++-------------=
=0A 1 file changed, 2 insertions(+), 13 deletions(-)=0A=0Adiff --git a/driv=
ers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c=0Aindex fe70744=
0f8c3..c54ee6674471 100644=0A--- a/drivers/spi/spi-topcliff-pch.c=0A+++ b/d=
rivers/spi/spi-topcliff-pch.c=0A@@ -1306,27 +1306,18 @@ static void pch_fre=
e_dma_buf(struct pch_spi_board_data *board_dat,=0A 	return;=0A }=0A =0A-sta=
tic int pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,=0A+static v=
oid pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,=0A 			      str=
uct pch_spi_data *data)=0A {=0A 	struct pch_spi_dma_ctrl *dma;=0A-	int ret;=
=0A =0A 	dma =3D &data->dma;=0A-	ret =3D 0;=0A 	/* Get Consistent memory fo=
r Tx DMA */=0A 	dma->tx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->d=
ev,=0A 				PCH_BUF_SIZE, &dma->tx_buf_dma, GFP_KERNEL);=0A-	if (!dma->tx_bu=
f_virt)=0A-		ret =3D -ENOMEM;=0A-=0A 	/* Get Consistent memory for Rx DMA *=
/=0A 	dma->rx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 			=
	PCH_BUF_SIZE, &dma->rx_buf_dma, GFP_KERNEL);=0A-	if (!dma->rx_buf_virt)=0A=
-		ret =3D -ENOMEM;=0A-=0A-	return ret;=0A }=0A =0A static int pch_spi_pd_p=
robe(struct platform_device *plat_dev)=0A@@ -1403,9 +1394,7 @@ static int p=
ch_spi_pd_probe(struct platform_device *plat_dev)=0A =0A 	if (use_dma) {=0A=
 		dev_info(&plat_dev->dev, "Use DMA for data transfers\n");=0A-		ret =3D p=
ch_alloc_dma_buf(board_dat, data);=0A-		if (ret)=0A-			goto err_spi_registe=
r_master;=0A+		pch_alloc_dma_buf(board_dat, data);=0A 	}=0A =0A 	ret =3D sp=
i_register_master(master);=0A-- =0A2.30.2=0A=0A=0AFrom e5fa249394385ba44dc1=
eb455e5c1f8328ead1c1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:08 +0100=0ASubject: =
[PATCH 38/62] Revert "ALSA: sb8: add a check for request_region"=0A=0AThis =
reverts commit 5e6e33fd757714e76d7abeddac125547bb2cf20d.=0A=0ACommits from =
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
=2Ecom>=0A---=0A sound/isa/sb/sb8.c | 4 ----=0A 1 file changed, 4 deletions=
(-)=0A=0Adiff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c=0Aindex e75bf=
c511e3e..ad42d2364199 100644=0A--- a/sound/isa/sb/sb8.c=0A+++ b/sound/isa/s=
b/sb8.c=0A@@ -111,10 +111,6 @@ static int snd_sb8_probe(struct device *pdev=
, unsigned int dev)=0A =0A 	/* block the 0x388 port to avoid PnP conflicts =
*/=0A 	acard->fm_res =3D request_region(0x388, 4, "SoundBlaster FM");=0A-	i=
f (!acard->fm_res) {=0A-		err =3D -EBUSY;=0A-		goto _err;=0A-	}=0A =0A 	if =
(port[dev] !=3D SNDRV_AUTO_PORT) {=0A 		if ((err =3D snd_sbdsp_create(card,=
 port[dev], irq[dev],=0A-- =0A2.30.2=0A=0A=0AFrom 9014036248f5a9398dfe6e340=
508e2696199c9f3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:08 +0100=0ASubject: [PATC=
H 39/62] Revert "md: Fix failed allocation of=0A md_register_thread"=0A=0AT=
his reverts commit f61b68e1c7745d142afa4c7cbab71731ddf7a982.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/md/raid10.c | 2 --=0A drivers/md/raid5.c  | 2 --=
=0A 2 files changed, 4 deletions(-)=0A=0Adiff --git a/drivers/md/raid10.c b=
/drivers/md/raid10.c=0Aindex 717787d09e0f..67414616eb35 100644=0A--- a/driv=
ers/md/raid10.c=0A+++ b/drivers/md/raid10.c=0A@@ -3798,8 +3798,6 @@ static =
int raid10_run(struct mddev *mddev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mdde=
v->recovery);=0A 		mddev->sync_thread =3D md_register_thread(md_do_sync, md=
dev,=0A 							"reshape");=0A-		if (!mddev->sync_thread)=0A-			goto out_fre=
e_conf;=0A 	}=0A =0A 	return 0;=0Adiff --git a/drivers/md/raid5.c b/drivers=
/md/raid5.c=0Aindex 1e9321410bbb..b2e7900150cc 100644=0A--- a/drivers/md/ra=
id5.c=0A+++ b/drivers/md/raid5.c=0A@@ -6988,8 +6988,6 @@ static int raid5_r=
un(struct mddev *mddev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery)=
;=0A 		mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,=0A 				=
			"reshape");=0A-		if (!mddev->sync_thread)=0A-			goto abort;=0A 	}=0A =0A=
 	/* Ok, everything is just fine now */=0A-- =0A2.30.2=0A=0A=0AFrom 80693c4=
ce6e235ec0c0c762e7bf3e8fe89d4e1cd Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:09 +010=
0=0ASubject: [PATCH 40/62] Revert "qlcnic: Avoid potential NULL pointer=0A =
dereference"=0A=0AThis reverts commit aba0a087a00096c3831b6524852a972df5f5f=
3d9.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/qlcnic/ql=
cnic_ethtool.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/d=
rivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/q=
logic/qlcnic/qlcnic_ethtool.c=0Aindex 63ebc491057b..0a2318cad34d 100644=0A-=
-- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A+++ b/drivers/ne=
t/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A@@ -1038,8 +1038,6 @@ int qlcni=
c_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)=0A =0A 	for (i =3D 0;=
 i < QLCNIC_NUM_ILB_PKT; i++) {=0A 		skb =3D netdev_alloc_skb(adapter->netd=
ev, QLCNIC_ILB_PKT_SIZE);=0A-		if (!skb)=0A-			break;=0A 		qlcnic_create_lo=
opback_buff(skb->data, adapter->mac_addr);=0A 		skb_put(skb, QLCNIC_ILB_PKT=
_SIZE);=0A 		adapter->ahw->diag_cnt =3D 0;=0A-- =0A2.30.2=0A=0A=0AFrom 04f0=
55a33b99b2bdf83c6fc626624f6d1a4f3f01 Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:09 +=
0100=0ASubject: [PATCH 41/62] Revert "tty: atmel_serial: fix a potential NU=
LL pointer=0A dereference"=0A=0AThis reverts commit fe186fdd1a45b5e33dd85f7=
bf63e70049f99b230.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/tty/serial/atme=
l_serial.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/dri=
vers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c=0Aindex =
4a7eb85f7c85..78c4f2b9e06f 100644=0A--- a/drivers/tty/serial/atmel_serial.c=
=0A+++ b/drivers/tty/serial/atmel_serial.c=0A@@ -1178,10 +1178,6 @@ static =
int atmel_prepare_rx_dma(struct uart_port *port)=0A 					 sg_dma_len(&atmel=
_port->sg_rx)/2,=0A 					 DMA_DEV_TO_MEM,=0A 					 DMA_PREP_INTERRUPT);=0A-=
	if (!desc) {=0A-		dev_err(port->dev, "Preparing DMA cyclic failed\n");=0A-=
		goto chan_err;=0A-	}=0A 	desc->callback =3D atmel_complete_rx_dma;=0A 	de=
sc->callback_param =3D port;=0A 	atmel_port->desc_rx =3D desc;=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 56541823dbd88a849f6f9207c1b452ee40f5fefe Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:38:09 +0100=0ASubject: [PATCH 42/62] Revert "scsi: qla4xxx: =
fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit a3d1c=
9bc1416500bc6d7105de3d28a91f2f99fee.=0A=0ACommits from @umn.edu addresses h=
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
vers/scsi/qla4xxx/ql4_os.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adi=
ff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c=0A=
index f10088a1d38c..521dd87f94ce 100644=0A--- a/drivers/scsi/qla4xxx/ql4_os=
=2Ec=0A+++ b/drivers/scsi/qla4xxx/ql4_os.c=0A@@ -3207,8 +3207,6 @@ static i=
nt qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,=0A 	if (iscsi_c=
onn_bind(cls_session, cls_conn, is_leading))=0A 		return -EINVAL;=0A 	ep =
=3D iscsi_lookup_endpoint(transport_fd);=0A-	if (!ep)=0A-		return -EINVAL;=
=0A 	conn =3D cls_conn->dd_data;=0A 	qla_conn =3D conn->dd_data;=0A 	qla_co=
nn->qla_ep =3D ep->dd_data;=0A-- =0A2.30.2=0A=0A=0AFrom 3af05b93a0ed293719b=
a060f09b4adeeb8c93664 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:10 +0100=0ASubject:=
 [PATCH 43/62] Revert "libnvdimm/btt: Fix a kmemdup failure check"=0A=0AThi=
s reverts commit 4d8fc7d8d7ed3e7405a8315a84c07b006151f634.=0A=0ACommits fro=
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
il.com>=0A---=0A drivers/nvdimm/btt_devs.c | 18 +++++-------------=0A 1 fil=
e changed, 5 insertions(+), 13 deletions(-)=0A=0Adiff --git a/drivers/nvdim=
m/btt_devs.c b/drivers/nvdimm/btt_devs.c=0Aindex 5d2c76682848..97dd2925ed6e=
 100644=0A--- a/drivers/nvdimm/btt_devs.c=0A+++ b/drivers/nvdimm/btt_devs.c=
=0A@@ -190,15 +190,14 @@ static struct device *__nd_btt_create(struct nd_re=
gion *nd_region,=0A 		return NULL;=0A =0A 	nd_btt->id =3D ida_simple_get(&n=
d_region->btt_ida, 0, 0, GFP_KERNEL);=0A-	if (nd_btt->id < 0)=0A-		goto out=
_nd_btt;=0A+	if (nd_btt->id < 0) {=0A+		kfree(nd_btt);=0A+		return NULL;=0A=
+	}=0A =0A 	nd_btt->lbasize =3D lbasize;=0A-	if (uuid) {=0A+	if (uuid)=0A 	=
	uuid =3D kmemdup(uuid, 16, GFP_KERNEL);=0A-		if (!uuid)=0A-			goto out_put=
_id;=0A-	}=0A 	nd_btt->uuid =3D uuid;=0A 	dev =3D &nd_btt->dev;=0A 	dev_set=
_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);=0A@@ -213,13 +212,6 @@ s=
tatic struct device *__nd_btt_create(struct nd_region *nd_region,=0A 		retu=
rn NULL;=0A 	}=0A 	return dev;=0A-=0A-out_put_id:=0A-	ida_simple_remove(&nd=
_region->btt_ida, nd_btt->id);=0A-=0A-out_nd_btt:=0A-	kfree(nd_btt);=0A-	re=
turn NULL;=0A }=0A =0A struct device *nd_btt_create(struct nd_region *nd_re=
gion)=0A-- =0A2.30.2=0A=0A=0AFrom aacc95a8c1016c52a6516a9b14a2be5c226be043 =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 20:38:10 +0100=0ASubject: [PATCH 44/62] Revert =
"x86/hpet: Prevent potential NULL pointer=0A dereference"=0A=0AThis reverts=
 commit ec1fdc02cc255f5021f52e3bf90044099d9eba67.=0A=0ACommits from @umn.ed=
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
=0A---=0A arch/x86/kernel/hpet.c | 2 --=0A 1 file changed, 2 deletions(-)=
=0A=0Adiff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c=0Aindex =
775c23d4021a..756634f14df6 100644=0A--- a/arch/x86/kernel/hpet.c=0A+++ b/ar=
ch/x86/kernel/hpet.c=0A@@ -914,8 +914,6 @@ int __init hpet_enable(void)=0A =
		return 0;=0A =0A 	hpet_set_mapping();=0A-	if (!hpet_virt_address)=0A-		re=
turn 0;=0A =0A 	/*=0A 	 * Read the period and check for a sane value:=0A-- =
=0A2.30.2=0A=0A=0AFrom cd5bd522ce397a07d94148f4ab7286cbbfb4a48d Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:38:10 +0100=0ASubject: [PATCH 45/62] Revert "leds: lp55=
23: fix a missing check of return=0A value of lp55xx_read"=0A=0AThis revert=
s commit 38ad9f0362b2f79786c65c26c92e09f788512864.=0A=0ACommits from @umn.e=
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
=0A---=0A drivers/leds/leds-lp5523.c | 4 +---=0A 1 file changed, 1 insertio=
n(+), 3 deletions(-)=0A=0Adiff --git a/drivers/leds/leds-lp5523.c b/drivers=
/leds/leds-lp5523.c=0Aindex 44ceed7ac3c5..c5b30f06218a 100644=0A--- a/drive=
rs/leds/leds-lp5523.c=0A+++ b/drivers/leds/leds-lp5523.c=0A@@ -318,9 +318,7=
 @@ static int lp5523_init_program_engine(struct lp55xx_chip *chip)=0A =0A =
	/* Let the programs run for couple of ms and check the engine status */=0A=
 	usleep_range(3000, 6000);=0A-	ret =3D lp55xx_read(chip, LP5523_REG_STATUS=
, &status);=0A-	if (ret)=0A-		return ret;=0A+	lp55xx_read(chip, LP5523_REG_=
STATUS, &status);=0A 	status &=3D LP5523_ENG_STATUS_MASK;=0A =0A 	if (statu=
s !=3D LP5523_ENG_STATUS_MASK) {=0A-- =0A2.30.2=0A=0A=0AFrom cf4feb3035506f=
2ce237dbb6e01d2284a4e96e28 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:10 +0100=0ASub=
ject: [PATCH 46/62] Revert "mfd: mc13xxx: Fix a missing check of a=0A regis=
ter-read failure"=0A=0AThis reverts commit f98bcfadc81aaa38711b119f920dce34=
48b5782c.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mfd/mc13xxx-core.c | 4 +=
---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/dri=
vers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c=0Aindex 75d52034f89d..=
7ea1d5c4f60b 100644=0A--- a/drivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/=
mc13xxx-core.c=0A@@ -274,9 +274,7 @@ int mc13xxx_adc_do_conversion(struct m=
c13xxx *mc13xxx, unsigned int mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_=
ADC_WORKING;=0A =0A-	ret =3D mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_a=
dc0);=0A-	if (ret)=0A-		goto out;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC=
0, &old_adc0);=0A =0A 	adc0 =3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=
=0A 	       MC13XXX_ADC0_CHRGRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom 2a30b8b7ec=
feac952cc2e33917f2f42b1492ccbd Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:11 +0100=
=0ASubject: [PATCH 47/62] Revert "gdrom: fix a memory leak bug"=0A=0AThis r=
everts commit 69a1580320bf505ce51e06763e36b0596872d3d0.=0A=0ACommits from @=
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
l.com>=0A---=0A drivers/cdrom/gdrom.c | 1 -=0A 1 file changed, 1 deletion(-=
)=0A=0Adiff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 1=
852d19d0d7b..e2808fefbb78 100644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/driv=
ers/cdrom/gdrom.c=0A@@ -882,7 +882,6 @@ static void __exit exit_gdrom(void)=
=0A 	platform_device_unregister(pd);=0A 	platform_driver_unregister(&gdrom_=
driver);=0A 	kfree(gd.toc);=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(=
init_gdrom);=0A-- =0A2.30.2=0A=0A=0AFrom b8201752140797b7973f7007e160d00201=
f4341b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:38:11 +0100=0ASubject: [PATCH 48/62] =
Revert "atl1e: checking the status of=0A atl1e_write_phy_reg"=0A=0AThis rev=
erts commit 57b2d68786a843a70bb410a9f38f6671c485d38b.=0A=0ACommits from @um=
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
m>=0A---=0A drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 4 +---=0A 1 f=
ile changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/e=
thernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl=
1e_main.c=0Aindex 5e1f03590aaf..974713b19ab6 100644=0A--- a/drivers/net/eth=
ernet/atheros/atl1e/atl1e_main.c=0A+++ b/drivers/net/ethernet/atheros/atl1e=
/atl1e_main.c=0A@@ -478,9 +478,7 @@ static void atl1e_mdio_write(struct net=
_device *netdev, int phy_id,=0A {=0A 	struct atl1e_adapter *adapter =3D net=
dev_priv(netdev);=0A =0A-	if (atl1e_write_phy_reg(&adapter->hw,=0A-				reg_=
num & MDIO_REG_ADDR_MASK, val))=0A-		netdev_err(netdev, "write phy register=
 failed\n");=0A+	atl1e_write_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_=
MASK, val);=0A }=0A =0A static int atl1e_mii_ioctl(struct net_device *netde=
v,=0A-- =0A2.30.2=0A=0A=0AFrom 5504c1c17bb276ce8bae6f23e8072c4b33e591fb Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:38:11 +0100=0ASubject: [PATCH 49/62] Revert "n=
et: dsa: bcm_sf2: Propagate error value from=0A mdio_write"=0A=0AThis rever=
ts commit 27c9e12a43fe2abd086116252a4981d899178c09.=0A=0ACommits from @umn.=
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
m>=0A---=0A drivers/net/dsa/bcm_sf2.c | 7 ++++---=0A 1 file changed, 4 inse=
rtions(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/dsa/bcm_sf2.c b/dri=
vers/net/dsa/bcm_sf2.c=0Aindex 40b3adf7ad99..5e62c3e454c2 100644=0A--- a/dr=
ivers/net/dsa/bcm_sf2.c=0A+++ b/drivers/net/dsa/bcm_sf2.c=0A@@ -410,10 +410=
,11 @@ static int bcm_sf2_sw_mdio_write(struct mii_bus *bus, int addr, int =
regnum,=0A 	 * send them to our master MDIO bus controller=0A 	 */=0A 	if (=
addr =3D=3D BRCM_PSEUDO_PHY_ADDR && priv->indir_phy_mask & BIT(addr))=0A-		=
return bcm_sf2_sw_indir_rw(priv, 0, addr, regnum, val);=0A+		bcm_sf2_sw_ind=
ir_rw(priv, 0, addr, regnum, val);=0A 	else=0A-		return mdiobus_write_neste=
d(priv->master_mii_bus, addr,=0A-				regnum, val);=0A+		mdiobus_write_neste=
d(priv->master_mii_bus, addr, regnum, val);=0A+=0A+	return 0;=0A }=0A =0A s=
tatic irqreturn_t bcm_sf2_switch_0_isr(int irq, void *dev_id)=0A-- =0A2.30.=
2=0A=0A=0AFrom 12a086bcb516958bca41e25311a33257020bd204 Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:38:11 +0100=0ASubject: [PATCH 50/62] Revert "net: stmicro: fix =
a missing check of=0A clk_prepare"=0A=0AThis reverts commit 712545ec9e81824=
fdaeb60b0ad121eba5512fafe.=0A=0ACommits from @umn.edu addresses have been f=
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
ernet/stmicro/stmmac/dwmac-sunxi.c | 4 +---=0A 1 file changed, 1 insertion(=
+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/stmicro/stmmac/dw=
mac-sunxi.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0Aindex fc1=
fa0f9f338..ee5c0c626351 100644=0A--- a/drivers/net/ethernet/stmicro/stmmac/=
dwmac-sunxi.c=0A+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A@=
@ -59,9 +59,7 @@ static int sun7i_gmac_init(struct platform_device *pdev, v=
oid *priv)=0A 		gmac->clk_enabled =3D 1;=0A 	} else {=0A 		clk_set_rate(gma=
c->tx_clk, SUN7I_GMAC_MII_RATE);=0A-		ret =3D clk_prepare(gmac->tx_clk);=0A=
-		if (ret)=0A-			return ret;=0A+		clk_prepare(gmac->tx_clk);=0A 	}=0A =0A =
	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom f06b05e0af2489358cbdb255573b711e964d=
c94f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 20:38:12 +0100=0ASubject: [PATCH 51/62] Re=
vert "net/net_namespace: Check the return value of=0A register_pernet_subsy=
s()"=0A=0AThis reverts commit 9b852f0a5416c3d2f812413d44fc0166a4c8c419.=0A=
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
m.mukherjee@gmail.com>=0A---=0A net/core/net_namespace.c | 3 +--=0A 1 file =
changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/net/core/net_name=
space.c b/net/core/net_namespace.c=0Aindex 7630fa80db92..4509dec7bd1c 10064=
4=0A--- a/net/core/net_namespace.c=0A+++ b/net/core/net_namespace.c=0A@@ -8=
02,8 +802,7 @@ static int __init net_ns_init(void)=0A =0A 	mutex_unlock(&ne=
t_mutex);=0A =0A-	if (register_pernet_subsys(&net_ns_ops))=0A-		panic("Coul=
d not register network namespace subsystems");=0A+	register_pernet_subsys(&=
net_ns_ops);=0A =0A 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net_newid, =
NULL, NULL);=0A 	rtnl_register(PF_UNSPEC, RTM_GETNSID, rtnl_net_getid, rtnl=
_net_dumpid,=0A-- =0A2.30.2=0A=0A=0AFrom 5d08254541e2240630331e179a61472756=
355d07 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:38:12 +0100=0ASubject: [PATCH 52/62] =
Revert "drivers/regulator: fix a missing check of=0A return value"=0A=0AThi=
s reverts commit 608024a3a186c9bf958fe01dac244e187b1b04af.=0A=0ACommits fro=
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
il.com>=0A---=0A drivers/regulator/palmas-regulator.c | 5 +----=0A 1 file c=
hanged, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/regulator/=
palmas-regulator.c b/drivers/regulator/palmas-regulator.c=0Aindex 1eb605b6f=
049..f11d41dad9c1 100644=0A--- a/drivers/regulator/palmas-regulator.c=0A+++=
 b/drivers/regulator/palmas-regulator.c=0A@@ -435,16 +435,13 @@ static int =
palmas_ldo_write(struct palmas *palmas, unsigned int reg,=0A static int pal=
mas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)=0A {=0A 	in=
t id =3D rdev_get_id(dev);=0A-	int ret;=0A 	struct palmas_pmic *pmic =3D rd=
ev_get_drvdata(dev);=0A 	struct palmas_pmic_driver_data *ddata =3D pmic->pa=
lmas->pmic_ddata;=0A 	struct palmas_regs_info *rinfo =3D &ddata->palmas_reg=
s_info[id];=0A 	unsigned int reg;=0A 	bool rail_enable =3D true;=0A =0A-	re=
t =3D palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A-	if (ret)=
=0A-		return ret;=0A+	palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg=
);=0A =0A 	reg &=3D ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.=
2=0A=0A=0AFrom c4a805347887e89f9c46dc748fde899eb4e4e019 Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:38:12 +0100=0ASubject: [PATCH 53/62] Revert "hwmon: (lm80) fix =
a missing check of bus read=0A in lm80 probe"=0A=0AThis reverts commit ecbf=
70b1586786ad84eead30246ecc2ef87de417.=0A=0ACommits from @umn.edu addresses =
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
drivers/hwmon/lm80.c | 11 ++---------=0A 1 file changed, 2 insertions(+), 9=
 deletions(-)=0A=0Adiff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c=
=0Aindex be60bd5bab78..ee6d499edc1b 100644=0A--- a/drivers/hwmon/lm80.c=0A+=
++ b/drivers/hwmon/lm80.c=0A@@ -630,7 +630,6 @@ static int lm80_probe(struc=
t i2c_client *client,=0A 	struct device *dev =3D &client->dev;=0A 	struct d=
evice *hwmon_dev;=0A 	struct lm80_data *data;=0A-	int rv;=0A =0A 	data =3D =
devm_kzalloc(dev, sizeof(struct lm80_data), GFP_KERNEL);=0A 	if (!data)=0A@=
@ -643,14 +642,8 @@ static int lm80_probe(struct i2c_client *client,=0A 	lm=
80_init_client(client);=0A =0A 	/* A few vars need to be filled upon startu=
p */=0A-	rv =3D lm80_read_value(client, LM80_REG_FAN_MIN(1));=0A-	if (rv < =
0)=0A-		return rv;=0A-	data->fan[f_min][0] =3D rv;=0A-	rv =3D lm80_read_val=
ue(client, LM80_REG_FAN_MIN(2));=0A-	if (rv < 0)=0A-		return rv;=0A-	data->=
fan[f_min][1] =3D rv;=0A+	data->fan[f_min][0] =3D lm80_read_value(client, L=
M80_REG_FAN_MIN(1));=0A+	data->fan[f_min][1] =3D lm80_read_value(client, LM=
80_REG_FAN_MIN(2));=0A =0A 	hwmon_dev =3D devm_hwmon_device_register_with_g=
roups(dev, client->name,=0A 							   data, lm80_groups);=0A-- =0A2.30.2=0A=
=0A=0AFrom c96d30a1d158fd35f3e0f9b02e954d2c6d41711b Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:38:12 +0100=0ASubject: [PATCH 54/62] Revert "net: cxgb3_main: fix a=
 missing-check bug"=0A=0AThis reverts commit 063cc21634ce9755b999aaa2755947=
96d30f2c47.=0A=0ACommits from @umn.edu addresses have been found to be subm=
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
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/chelsio/c=
xgb3/cxgb3_main.c | 17 -----------------=0A 1 file changed, 17 deletions(-)=
=0A=0Adiff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/driver=
s/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0Aindex 9627ed0b2f1c..5ebece47735=
4 100644=0A--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A+++ b/dr=
ivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A@@ -2150,8 +2150,6 @@ stati=
c int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=
=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A =
			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_SET_QSET_PARAMS)=0A-			retur=
n -EINVAL;=0A 		if (t.qset_idx >=3D SGE_QSETS)=0A 			return -EINVAL;=0A 		i=
f (!in_range(t.intr_lat, 0, M_NEWTIMER) ||=0A@@ -2251,9 +2249,6 @@ static i=
nt cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 	=
	if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A =0A-=
		if (t.cmd !=3D CHELSIO_GET_QSET_PARAMS)=0A-			return -EINVAL;=0A-=0A 		/*=
 Display qsets for all ports when offload enabled */=0A 		if (test_bit(OFFL=
OAD_DEVMAP_BIT, &adapter->open_device_map)) {=0A 			q1 =3D 0;=0A@@ -2299,8 =
+2294,6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __u=
ser *useraddr)=0A 			return -EBUSY;=0A 		if (copy_from_user(&edata, useradd=
r, sizeof(edata)))=0A 			return -EFAULT;=0A-		if (edata.cmd !=3D CHELSIO_SE=
T_QSET_NUM)=0A-			return -EINVAL;=0A 		if (edata.val < 1 ||=0A 			(edata.va=
l > 1 && !(adapter->flags & USING_MSIX)))=0A 			return -EINVAL;=0A@@ -2341,=
8 +2334,6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void _=
_user *useraddr)=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr,=
 sizeof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_LOAD_FW)=0A-=
			return -EINVAL;=0A 		/* Check t.len sanity ? */=0A 		fw_data =3D memdup_=
user(useraddr + sizeof(t), t.len);=0A 		if (IS_ERR(fw_data))=0A@@ -2366,8 +=
2357,6 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __us=
er *useraddr)=0A 			return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, si=
zeof(m)))=0A 			return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SETMTUTAB)=0A-	=
		return -EINVAL;=0A 		if (m.nmtus !=3D NMTUS)=0A 			return -EINVAL;=0A 		i=
f (m.mtus[0] < 81)	/* accommodate SACK */=0A@@ -2409,8 +2398,6 @@ static in=
t cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 		=
	return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			ret=
urn -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SET_PM)=0A-			return -EINVAL;=0A 	=
	if (!is_power_of_2(m.rx_pg_sz) ||=0A 			!is_power_of_2(m.tx_pg_sz))=0A 			=
return -EINVAL;	/* not power of 2 */=0A@@ -2446,8 +2433,6 @@ static int cxg=
b_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			retu=
rn -EIO;	/* need the memory controllers */=0A 		if (copy_from_user(&t, user=
addr, sizeof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_GET_MEM=
)=0A-			return -EINVAL;=0A 		if ((t.addr & 7) || (t.len & 7))=0A 			return =
-EINVAL;=0A 		if (t.mem_id =3D=3D MEM_CM)=0A@@ -2500,8 +2485,6 @@ static in=
t cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 		=
	return -EAGAIN;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			re=
turn -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_SET_TRACE_FILTER)=0A-			return -E=
INVAL;=0A =0A 		tp =3D (const struct trace_params *)&t.sip;=0A 		if (t.conf=
ig_tx)=0A-- =0A2.30.2=0A=0A=0AFrom 4b89f425e38944d5e3dfcc1e5e02e821da279d83=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 20:38:13 +0100=0ASubject: [PATCH 55/62] Revert=
 "libnvdimm/namespace: Fix a potential NULL=0A pointer dereference"=0A=0ATh=
is reverts commit 93cc83319f9aca32b0d4cd5156086d908287b376.=0A=0ACommits fr=
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
ail.com>=0A---=0A drivers/nvdimm/namespace_devs.c | 5 +----=0A 1 file chang=
ed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/nvdimm/namespa=
ce_devs.c b/drivers/nvdimm/namespace_devs.c=0Aindex e83453e1b308..6a7e4a17a=
1d2 100644=0A--- a/drivers/nvdimm/namespace_devs.c=0A+++ b/drivers/nvdimm/n=
amespace_devs.c=0A@@ -2043,12 +2043,9 @@ struct device *create_namespace_bl=
k(struct nd_region *nd_region,=0A 	if (!nsblk->uuid)=0A 		goto blk_err;=0A =
	memcpy(name, nd_label->name, NSLABEL_NAME_LEN);=0A-	if (name[0]) {=0A+	if =
(name[0])=0A 		nsblk->alt_name =3D kmemdup(name, NSLABEL_NAME_LEN,=0A 				G=
FP_KERNEL);=0A-		if (!nsblk->alt_name)=0A-			goto blk_err;=0A-	}=0A 	res =
=3D nsblk_add_resource(nd_region, ndd, nsblk,=0A 			__le64_to_cpu(nd_label-=
>dpa));=0A 	if (!res)=0A-- =0A2.30.2=0A=0A=0AFrom 0e12c7e8715994219cfb82e31=
746fe8a0f5c2c11 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:13 +0100=0ASubject: [PATC=
H 56/62] Revert "niu: fix missing checks of niu_pci_eeprom_read"=0A=0AThis =
reverts commit 63e311153b66fb36eb448e65b8bca5c1dbf1c28e.=0A=0ACommits from =
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
=2Ecom>=0A---=0A drivers/net/ethernet/sun/niu.c | 10 ++--------=0A 1 file c=
hanged, 2 insertions(+), 8 deletions(-)=0A=0Adiff --git a/drivers/net/ether=
net/sun/niu.c b/drivers/net/ethernet/sun/niu.c=0Aindex 5bf47279f9c1..6137e4=
13e09d 100644=0A--- a/drivers/net/ethernet/sun/niu.c=0A+++ b/drivers/net/et=
hernet/sun/niu.c=0A@@ -8119,8 +8119,6 @@ static int niu_pci_vpd_scan_props(=
struct niu *np, u32 start, u32 end)=0A 		start +=3D 3;=0A =0A 		prop_len =
=3D niu_pci_eeprom_read(np, start + 4);=0A-		if (prop_len < 0)=0A-			return=
 prop_len;=0A 		err =3D niu_pci_vpd_get_propname(np, start + 5, namebuf, 64=
);=0A 		if (err < 0)=0A 			return err;=0A@@ -8165,12 +8163,8 @@ static int =
niu_pci_vpd_scan_props(struct niu *np, u32 start, u32 end)=0A 			netif_prin=
tk(np, probe, KERN_DEBUG, np->dev,=0A 				     "VPD_SCAN: Reading in proper=
ty [%s] len[%d]\n",=0A 				     namebuf, prop_len);=0A-			for (i =3D 0; i <=
 prop_len; i++) {=0A-				err =3D niu_pci_eeprom_read(np, off + i);=0A-				i=
f (err >=3D 0)=0A-					*prop_buf =3D err;=0A-				++prop_buf;=0A-			}=0A+			=
for (i =3D 0; i < prop_len; i++)=0A+				*prop_buf++ =3D niu_pci_eeprom_read=
(np, off + i);=0A 		}=0A =0A 		start +=3D len;=0A-- =0A2.30.2=0A=0A=0AFrom =
7f720b8f852cbdc92ac826c1e82a90d3f5047978 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:=
13 +0100=0ASubject: [PATCH 57/62] Revert "net: socket: fix a missing-check =
bug"=0A=0AThis reverts commit f57ef24f811ccca74df04cc39b30e023654d9e99.=0A=
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
m.mukherjee@gmail.com>=0A---=0A net/socket.c | 11 +++--------=0A 1 file cha=
nged, 3 insertions(+), 8 deletions(-)=0A=0Adiff --git a/net/socket.c b/net/=
socket.c=0Aindex ab64ae80ca2c..23e2b4b64ec6 100644=0A--- a/net/socket.c=0A+=
++ b/net/socket.c=0A@@ -2765,14 +2765,9 @@ static int ethtool_ioctl(struct =
net *net, struct compat_ifreq __user *ifr32)=0A 		    copy_in_user(&rxnfc->=
fs.ring_cookie,=0A 				 &compat_rxnfc->fs.ring_cookie,=0A 				 (void __user=
 *)(&rxnfc->fs.location + 1) -=0A-				 (void __user *)&rxnfc->fs.ring_cooki=
e))=0A-			return -EFAULT;=0A-		if (ethcmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-=
			if (put_user(rule_cnt, &rxnfc->rule_cnt))=0A-				return -EFAULT;=0A-		} =
else if (copy_in_user(&rxnfc->rule_cnt,=0A-					&compat_rxnfc->rule_cnt,=0A=
-					sizeof(rxnfc->rule_cnt)))=0A+				 (void __user *)&rxnfc->fs.ring_cook=
ie) ||=0A+		    copy_in_user(&rxnfc->rule_cnt, &compat_rxnfc->rule_cnt,=0A+=
				 sizeof(rxnfc->rule_cnt)))=0A 			return -EFAULT;=0A 	}=0A =0A-- =0A2.30=
=2E2=0A=0A=0AFrom 5e490afb4c0ad4ce9b85014438d4b0eba3671a43 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:38:14 +0100=0ASubject: [PATCH 58/62] Revert "net: netxen: fi=
x a missing check and an=0A uninitialized use"=0A=0AThis reverts commit 154=
b7716f9aaf55a8307e464069d25cf5830f6e3.=0A=0ACommits from @umn.edu addresses=
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
drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 3 +--=0A 1 file chan=
ged, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/=
qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen=
_nic_init.c=0Aindex 5cf551914767..7b43a3b4abdc 100644=0A--- a/drivers/net/e=
thernet/qlogic/netxen/netxen_nic_init.c=0A+++ b/drivers/net/ethernet/qlogic=
/netxen/netxen_nic_init.c=0A@@ -1125,8 +1125,7 @@ netxen_validate_firmware(=
struct netxen_adapter *adapter)=0A 		return -EINVAL;=0A 	}=0A 	val =3D nx_g=
et_bios_version(adapter);=0A-	if (netxen_rom_fast_read(adapter, NX_BIOS_VER=
SION_OFFSET, (int *)&bios))=0A-		return -EIO;=0A+	netxen_rom_fast_read(adap=
ter, NX_BIOS_VERSION_OFFSET, (int *)&bios);=0A 	if ((__force u32)val !=3D b=
ios) {=0A 		dev_err(&pdev->dev, "%s: firmware bios is incompatible\n",=0A 	=
			fw_name[fw_type]);=0A-- =0A2.30.2=0A=0A=0AFrom 96e3e5b9b6d885273cbf61354=
a7be2325df34bdb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:14 +0100=0ASubject: [PATC=
H 59/62] Revert "media: isif: fix a NULL pointer dereference=0A bug"=0A=0AT=
his reverts commit 0419fe5b7fed909853c53a81bb401fe268a362d4.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/media/platform/davinci/isif.c | 3 +--=0A 1 file =
changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/media/pla=
tform/davinci/isif.c b/drivers/media/platform/davinci/isif.c=0Aindex b51b87=
5c5a61..7b98e275054d 100644=0A--- a/drivers/media/platform/davinci/isif.c=
=0A+++ b/drivers/media/platform/davinci/isif.c=0A@@ -1097,8 +1097,7 @@ stat=
ic int isif_probe(struct platform_device *pdev)=0A =0A 	while (i >=3D 0) {=
=0A 		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);=0A-		if (res)=
=0A-			release_mem_region(res->start, resource_size(res));=0A+		release_mem=
_region(res->start, resource_size(res));=0A 		i--;=0A 	}=0A 	vpfe_unregiste=
r_ccdc_device(&isif_hw_dev);=0A-- =0A2.30.2=0A=0A=0AFrom 5f281793de1ee69e27=
4a49aa92a73284d0c990ba Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <su=
dipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:14 +0100=0ASubject=
: [PATCH 60/62] Revert "scsi: 3w-xxxx: fix a missing-check bug"=0A=0AThis r=
everts commit 5a644f682267dff1614e5aaf23cdcffeefe91213.=0A=0ACommits from @=
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
l.com>=0A---=0A drivers/scsi/3w-xxxx.c | 3 ---=0A 1 file changed, 3 deletio=
ns(-)=0A=0Adiff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c=0Ai=
ndex 0ee0835d2647..57c71a6b44bd 100644=0A--- a/drivers/scsi/3w-xxxx.c=0A+++=
 b/drivers/scsi/3w-xxxx.c=0A@@ -1034,9 +1034,6 @@ static int tw_chrdev_open=
(struct inode *inode, struct file *file)=0A =0A 	dprintk(KERN_WARNING "3w-x=
xxx: tw_ioctl_open()\n");=0A =0A-	if (!capable(CAP_SYS_ADMIN))=0A-		return =
-EACCES;=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=3D =
tw_device_extension_count)=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom=
 cddee08b37f71511b97d4d7555496ca2219955ec Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38=
:14 +0100=0ASubject: [PATCH 61/62] Revert "scsi: 3w-9xxx: fix a missing-che=
ck bug"=0A=0AThis reverts commit 80e75bdc0e1be707edfd3730a2b46595648cf5b8.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/3w-9xxx.c | 5 -----=0A =
1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/scsi/3w-9xxx.c b/d=
rivers/scsi/3w-9xxx.c=0Aindex b78a2f3745f2..67133d9e8ce0 100644=0A--- a/dri=
vers/scsi/3w-9xxx.c=0A+++ b/drivers/scsi/3w-9xxx.c=0A@@ -889,11 +889,6 @@ s=
tatic int twa_chrdev_open(struct inode *inode, struct file *file)=0A 	unsig=
ned int minor_number;=0A 	int retval =3D TW_IOCTL_ERROR_OS_ENODEV;=0A =0A-	=
if (!capable(CAP_SYS_ADMIN)) {=0A-		retval =3D -EACCES;=0A-		goto out;=0A-	=
}=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=3D twa_dev=
ice_extension_count)=0A 		goto out;=0A-- =0A2.30.2=0A=0A=0AFrom 47a108a4264=
dfcf1d553e93b16960a3e06962451 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:38:15 +0100=0A=
Subject: [PATCH 62/62] Revert "dm ioctl: harden copy_params()'s=0A copy_fro=
m_user() from malicious users"=0A=0AThis reverts commit 6c446ad3622a67af92e=
6342c5678b06710c3777f.=0A=0ACommits from @umn.edu addresses have been found=
 to be submitted in "bad=0Afaith" to try to test the kernel community's abi=
lity to review "known=0Amalicious" changes.  The result of these submission=
s can be found in a=0Apaper published at the 42nd IEEE Symposium on Securit=
y and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0ASigned-off=
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/dm-io=
ctl.c | 18 ++++++++++++------=0A 1 file changed, 12 insertions(+), 6 deleti=
ons(-)=0A=0Adiff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c=0Ain=
dex 836a2808c0c7..df03ab15b241 100644=0A--- a/drivers/md/dm-ioctl.c=0A+++ b=
/drivers/md/dm-ioctl.c=0A@@ -1693,7 +1693,8 @@ static void free_params(stru=
ct dm_ioctl *param, size_t param_size, int param_fla=0A }=0A =0A static int=
 copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,=
=0A-		       int ioctl_flags, struct dm_ioctl **param, int *param_flags)=0A=
+		       int ioctl_flags,=0A+		       struct dm_ioctl **param, int *param_=
flags)=0A {=0A 	struct dm_ioctl *dmi;=0A 	int secure_data;=0A@@ -1738,13 +1=
739,18 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_io=
ctl *param_kern=0A =0A 	*param_flags |=3D DM_PARAMS_MALLOC;=0A =0A-	/* Copy=
 from param_kernel (which was already copied from user) */=0A-	memcpy(dmi, =
param_kernel, minimum_data_size);=0A-=0A-	if (copy_from_user(&dmi->data, (c=
har __user *)user + minimum_data_size,=0A-			   param_kernel->data_size - m=
inimum_data_size))=0A+	if (copy_from_user(dmi, user, param_kernel->data_siz=
e))=0A 		goto bad;=0A+=0A data_copied:=0A+	/*=0A+	 * Abort if something cha=
nged the ioctl data while it was being copied.=0A+	 */=0A+	if (dmi->data_si=
ze !=3D param_kernel->data_size) {=0A+		DMERR("rejecting ioctl: data size m=
odified while processing parameters");=0A+		goto bad;=0A+	}=0A+=0A 	/* Wipe=
 the user buffer so we do not return it to userspace */=0A 	if (secure_data=
 && clear_user(user, param_kernel->data_size))=0A 		goto bad;=0A-- =0A2.30.=
2=0A=0A
--vvALna9kLWNMwAEB--
