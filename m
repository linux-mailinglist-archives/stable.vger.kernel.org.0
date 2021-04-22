Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D793679D2
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhDVGWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhDVGWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:22:24 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C8C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:21:49 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q123-20020a1c43810000b029012c7d852459so3626705wma.0
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3leBXUDdWOzENypO6OlQVoPNj0OhijjLkgseVZ8gBOQ=;
        b=uPEweRhyFv4bJsoSQz0SPQZTP3zYtMtlfrtUWYsnG1oki83PCuRKJqt3uCRZW7Gu2q
         i6juiBnm/q/APzhdeHZERFXJklKgaoRXIeVZZHstAW9dqOTAPDJkcaKQxaMuUGrAXvM/
         Dy99wHl6DPfK2Rd71zn65UXr1dgtwhuJK9HcniPtwEkEQfGEtj9bbc77A+WggxAOqcun
         BqewTMDcvpT3ahhEyfo1gIqcDtkYYbOqGpaoAwgaUw83usmkh7Ute6bqTIzqi9TH/bMs
         9jlXKAYsZJg/THyIf1ce0w5nqlA+FC831mQXth3t1tlVIF+SyfiIPmJgd0s5k0Mllx/X
         hf/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3leBXUDdWOzENypO6OlQVoPNj0OhijjLkgseVZ8gBOQ=;
        b=m3qvTtwxTeyoONFTuJU8nToBn1Mu970/4DuDxUNAhYfkiJuD7+TDxQ7LkXlnHKCjWJ
         KDgvrbw2gwsKOMdqGaJI72i+UISpZR3TlMaD+i0f43jCsgP+q/gv6AqgiZ4w8MEu7OlX
         QDpUkTAcRdflHQjt8jQHIf2J7ImmZcSjAe27gCz0C2REllyok6iwCSPLpcbrSbwah88A
         xrNQqfWqbAUh5nZpAohxJrS+G0qKA/UBz0ymMsabk5M72fDTskORNdt0jGlQnVJeoCDj
         i9jae1eW7LVK7KlyHaWLzMAhFKbPbZFU7UvxKkiImgVeuzzUxIMDWkN5/aQiru2ULW+8
         jvhg==
X-Gm-Message-State: AOAM530GT6LAvT3QjjZd0/PZ0Wv5JMeWfhn5ofUVlbo0ugTvsNrSVhUW
        Iec1yh7RLUHfJyGNzO6hfF6wtHRzLbdNVw==
X-Google-Smtp-Source: ABdhPJzQ/jBG1YQxx6hrTge4GdylBdQGhu6IhG95+zM3Kn1F9nE1kCGl0zCHe9j3siAJEquC4lDenQ==
X-Received: by 2002:a05:600c:48a6:: with SMTP id j38mr1947105wmp.99.1619072507769;
        Wed, 21 Apr 2021 23:21:47 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id l4sm1858824wrx.24.2021.04.21.23.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:21:46 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:21:44 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v4.14.y
Message-ID: <YIEV+DLk9ShVj6El@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Ukhr4BwvfVs0ZLKZ"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ukhr4BwvfVs0ZLKZ
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

--Ukhr4BwvfVs0ZLKZ
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v4.14.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 4480ec834a64841ee4176e4e98a2076359334ffd Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:34:45 +0100=0ASubject: [PATCH 01/73] Revert "media: sti: Fix referenc=
e count leaks"=0A=0AThis reverts commit 67aff25b8dbef75dcdaa7bd2d8838bf04f9=
3f235.=0A=0ACommits from @umn.edu addresses have been found to be submitted=
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
e <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/sti/hva/hva-=
hw.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/med=
ia/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c=0Ain=
dex 1185f6b6721e..56925d3850c3 100644=0A--- a/drivers/media/platform/sti/hv=
a/hva-hw.c=0A+++ b/drivers/media/platform/sti/hva/hva-hw.c=0A@@ -272,7 +272=
,6 @@ static unsigned long int hva_hw_get_ip_version(struct hva_dev *hva)=
=0A =0A 	if (pm_runtime_get_sync(dev) < 0) {=0A 		dev_err(dev, "%s     fail=
ed to get pm_runtime\n", HVA_PREFIX);=0A-		pm_runtime_put_noidle(dev);=0A 	=
	mutex_unlock(&hva->protect_mutex);=0A 		return -EFAULT;=0A 	}=0A@@ -558,7 =
+557,6 @@ void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *s)=0A=
 =0A 	if (pm_runtime_get_sync(dev) < 0) {=0A 		seq_puts(s, "Cannot wake up =
IP\n");=0A-		pm_runtime_put_noidle(dev);=0A 		mutex_unlock(&hva->protect_mu=
tex);=0A 		return;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 3df039341da159cee99355=
2244e098cc821f9fe8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:46 +0100=0ASubject: =
[PATCH 02/73] Revert "drm/nouveau: fix multiple instances of=0A reference c=
ount leaks"=0A=0AThis reverts commit 42479de3daeae1728b3b2d2baef218f109e373=
61.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/nouveau_drm.=
c | 8 ++------=0A drivers/gpu/drm/nouveau/nouveau_gem.c | 4 +---=0A 2 files=
 changed, 3 insertions(+), 9 deletions(-)=0A=0Adiff --git a/drivers/gpu/drm=
/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c=0Aindex fb6b=
1d0f7fef..d00524a5d7f0 100644=0A--- a/drivers/gpu/drm/nouveau/nouveau_drm.c=
=0A+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c=0A@@ -840,10 +840,8 @@ nouve=
au_drm_open(struct drm_device *dev, struct drm_file *fpriv)=0A =0A 	/* need=
 to bring up power immediately if opening device */=0A 	ret =3D pm_runtime_=
get_sync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_=
put_autosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return=
 ret;=0A-	}=0A =0A 	get_task_comm(tmpname, current);=0A 	snprintf(name, siz=
eof(name), "%s[%d]", tmpname, pid_nr(fpriv->pid));=0A@@ -932,10 +930,8 @@ n=
ouveau_drm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)=0A=
 	long ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if (ret < 0 =
&& ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	if (r=
et < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	switch (_IOC_NR(=
cmd) - DRM_COMMAND_BASE) {=0A 	case DRM_NOUVEAU_NVIF:=0Adiff --git a/driver=
s/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c=0Ai=
ndex c6149b5be073..60ffb70bb908 100644=0A--- a/drivers/gpu/drm/nouveau/nouv=
eau_gem.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c=0A@@ -42,10 +42,8 @=
@ nouveau_gem_object_del(struct drm_gem_object *gem)=0A 	int ret;=0A =0A 	r=
et =3D pm_runtime_get_sync(dev);=0A-	if (WARN_ON(ret < 0 && ret !=3D -EACCE=
S)) {=0A-		pm_runtime_put_autosuspend(dev);=0A+	if (WARN_ON(ret < 0 && ret =
!=3D -EACCES))=0A 		return;=0A-	}=0A =0A 	if (gem->import_attach)=0A 		drm_=
prime_gem_destroy(gem, nvbo->bo.sg);=0A-- =0A2.30.2=0A=0A=0AFrom 9fb0fa4b81=
0571c8575ac3dac7496b161c26bc0f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:46 +0100=
=0ASubject: [PATCH 03/73] Revert "drm/nouveau/drm/noveau: fix reference cou=
nt=0A leak in nouveau_fbcon_open"=0A=0AThis reverts commit bcd0b71b6e8278b2=
791800d0548d4d6cf18ef37e.=0A=0ACommits from @umn.edu addresses have been fo=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/=
nouveau/nouveau_fbcon.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 delet=
ions(-)=0A=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers=
/gpu/drm/nouveau/nouveau_fbcon.c=0Aindex cae1beabcd05..9ffb09679cc4 100644=
=0A--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c=0A+++ b/drivers/gpu/drm/no=
uveau/nouveau_fbcon.c=0A@@ -184,10 +184,8 @@ nouveau_fbcon_open(struct fb_i=
nfo *info, int user)=0A 	struct nouveau_fbdev *fbcon =3D info->par;=0A 	str=
uct nouveau_drm *drm =3D nouveau_drm(fbcon->helper.dev);=0A 	int ret =3D pm=
_runtime_get_sync(drm->dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A=
-		pm_runtime_put(drm->dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 	=
	return ret;=0A-	}=0A 	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom df0f2=
1f1f57789032252fec1319c6c88baa8b038 Mon Sep 17 00:00:00 2001=0AFrom: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:46 +0=
100=0ASubject: [PATCH 04/73] Revert "PCI: Fix pci_create_slot() reference c=
ount=0A leak"=0A=0AThis reverts commit d3d12858d45c0f03c42e901540b9833cc706=
e045.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/pci/slot.c | 6 ++----=0A 1 f=
ile changed, 2 insertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/pci/=
slot.c b/drivers/pci/slot.c=0Aindex e5c3a27eaea2..bfdad5742c85 100644=0A---=
 a/drivers/pci/slot.c=0A+++ b/drivers/pci/slot.c=0A@@ -303,7 +303,6 @@ stru=
ct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,=0A 	slot_=
name =3D make_slot_name(name);=0A 	if (!slot_name) {=0A 		err =3D -ENOMEM;=
=0A-		kfree(slot);=0A 		goto err;=0A 	}=0A =0A@@ -312,10 +311,8 @@ struct p=
ci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,=0A =0A 	err =
=3D kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,=0A 				   "%s"=
, slot_name);=0A-	if (err) {=0A-		kobject_put(&slot->kobj);=0A+	if (err)=0A=
 		goto err;=0A-	}=0A =0A 	down_read(&pci_bus_sem);=0A 	list_for_each_entry=
(dev, &parent->devices, bus_list)=0A@@ -331,6 +328,7 @@ struct pci_slot *pc=
i_create_slot(struct pci_bus *parent, int slot_nr,=0A 	mutex_unlock(&pci_sl=
ot_mutex);=0A 	return slot;=0A err:=0A+	kfree(slot);=0A 	slot =3D ERR_PTR(e=
rr);=0A 	goto out;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 15bab5c8118f47b7405e4bd=
5718f322c0a94411f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:46 +0100=0ASubject: [PA=
TCH 05/73] Revert "omapfb: fix multiple reference count leaks due=0A to pm_=
runtime_get_sync"=0A=0AThis reverts commit f8e0dad8be89f1aa594e26fdba05312c=
b739418c.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/video/fbdev/omap2/omapfb=
/dss/dispc.c | 7 ++-----=0A drivers/video/fbdev/omap2/omapfb/dss/dsi.c   | =
7 ++-----=0A drivers/video/fbdev/omap2/omapfb/dss/dss.c   | 7 ++-----=0A dr=
ivers/video/fbdev/omap2/omapfb/dss/hdmi4.c | 5 ++---=0A drivers/video/fbdev=
/omap2/omapfb/dss/hdmi5.c | 5 ++---=0A drivers/video/fbdev/omap2/omapfb/dss=
/venc.c  | 7 ++-----=0A 6 files changed, 12 insertions(+), 26 deletions(-)=
=0A=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c b/drivers/v=
ideo/fbdev/omap2/omapfb/dss/dispc.c=0Aindex 00f5a54aaf9b..7a75dfda9845 1006=
44=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c=0A+++ b/drivers/vid=
eo/fbdev/omap2/omapfb/dss/dispc.c=0A@@ -531,11 +531,8 @@ int dispc_runtime_=
get(void)=0A 	DSSDBG("dispc_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_s=
ync(&dispc.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&=
dispc.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A=
+	return r < 0 ? r : 0;=0A }=0A EXPORT_SYMBOL(dispc_runtime_get);=0A =0Adif=
f --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/=
omap2/omapfb/dss/dsi.c=0Aindex 2bfd9063cdfc..30d49f3800b3 100644=0A--- a/dr=
ivers/video/fbdev/omap2/omapfb/dss/dsi.c=0A+++ b/drivers/video/fbdev/omap2/=
omapfb/dss/dsi.c=0A@@ -1148,11 +1148,8 @@ static int dsi_runtime_get(struct=
 platform_device *dsidev)=0A 	DSSDBG("dsi_runtime_get\n");=0A =0A 	r =3D pm=
_runtime_get_sync(&dsi->pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runti=
me_put_sync(&dsi->pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_O=
N(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A static void dsi_runtime_put=
(struct platform_device *dsidev)=0Adiff --git a/drivers/video/fbdev/omap2/o=
mapfb/dss/dss.c b/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0Aindex acecee=
5b1c10..4429ad37b64c 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/ds=
s.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0A@@ -778,11 +778,8 =
@@ int dss_runtime_get(void)=0A 	DSSDBG("dss_runtime_get\n");=0A =0A 	r =3D=
 pm_runtime_get_sync(&dss.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_run=
time_put_sync(&dss.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_=
ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A void dss_runtime_put(void)=
=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c b/drivers/vide=
o/fbdev/omap2/omapfb/dss/hdmi4.c=0Aindex e2d571ca8590..ec78d61bc551 100644=
=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c=0A+++ b/drivers/video=
/fbdev/omap2/omapfb/dss/hdmi4.c=0A@@ -50,10 +50,9 @@ static int hdmi_runtim=
e_get(void)=0A 	DSSDBG("hdmi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_=
sync(&hdmi.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&=
hdmi.pdev->dev);=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	}=0A=
 =0A 	return 0;=0A }=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/hd=
mi5.c b/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c=0Aindex 13f3a5ce5529..=
2e2fcc3d6d4f 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c=0A=
+++ b/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c=0A@@ -54,10 +54,9 @@ sta=
tic int hdmi_runtime_get(void)=0A 	DSSDBG("hdmi_runtime_get\n");=0A =0A 	r =
=3D pm_runtime_get_sync(&hdmi.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm=
_runtime_put_sync(&hdmi.pdev->dev);=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 	=
	return r;=0A-	}=0A =0A 	return 0;=0A }=0Adiff --git a/drivers/video/fbdev/=
omap2/omapfb/dss/venc.c b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0Aind=
ex 96714b4596d2..392464da12e4 100644=0A--- a/drivers/video/fbdev/omap2/omap=
fb/dss/venc.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0A@@ -402=
,11 +402,8 @@ static int venc_runtime_get(void)=0A 	DSSDBG("venc_runtime_ge=
t\n");=0A =0A 	r =3D pm_runtime_get_sync(&venc.pdev->dev);=0A-	if (WARN_ON(=
r < 0)) {=0A-		pm_runtime_put_sync(&venc.pdev->dev);=0A-		return r;=0A-	}=
=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A st=
atic void venc_runtime_put(void)=0A-- =0A2.30.2=0A=0A=0AFrom 27560c633ad091=
f50563fede051b70dbefeae6d0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:47 +0100=0ASub=
ject: [PATCH 06/73] Revert "media: exynos4-is: Fix several reference count=
=0A leaks due to pm_runtime_get_sync"=0A=0AThis reverts commit 9e701ac75c67=
700de7017da13d15db74431dc376.=0A=0ACommits from @umn.edu addresses have bee=
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
a/platform/exynos4-is/fimc-isp.c  | 4 +---=0A drivers/media/platform/exynos=
4-is/fimc-lite.c | 2 +-=0A 2 files changed, 2 insertions(+), 4 deletions(-)=
=0A=0Adiff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/m=
edia/platform/exynos4-is/fimc-isp.c=0Aindex 89989b296159..fd793d3ac072 1006=
44=0A--- a/drivers/media/platform/exynos4-is/fimc-isp.c=0A+++ b/drivers/med=
ia/platform/exynos4-is/fimc-isp.c=0A@@ -311,10 +311,8 @@ static int fimc_is=
p_subdev_s_power(struct v4l2_subdev *sd, int on)=0A =0A 	if (on) {=0A 		ret=
 =3D pm_runtime_get_sync(&is->pdev->dev);=0A-		if (ret < 0) {=0A-			pm_runt=
ime_put(&is->pdev->dev);=0A+		if (ret < 0)=0A 			return ret;=0A-		}=0A 		se=
t_bit(IS_ST_PWR_ON, &is->state);=0A =0A 		ret =3D fimc_is_start_firmware(is=
);=0Adiff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/m=
edia/platform/exynos4-is/fimc-lite.c=0Aindex 1cdca5ce4843..4a3c9948ca54 100=
644=0A--- a/drivers/media/platform/exynos4-is/fimc-lite.c=0A+++ b/drivers/m=
edia/platform/exynos4-is/fimc-lite.c=0A@@ -480,7 +480,7 @@ static int fimc_=
lite_open(struct file *file)=0A 	set_bit(ST_FLITE_IN_USE, &fimc->state);=0A=
 	ret =3D pm_runtime_get_sync(&fimc->pdev->dev);=0A 	if (ret < 0)=0A-		goto=
 err_pm;=0A+		goto unlock;=0A =0A 	ret =3D v4l2_fh_open(file);=0A 	if (ret =
< 0)=0A-- =0A2.30.2=0A=0A=0AFrom d8e836e168713c148014b5bb103280dbfcacd9fb M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:34:47 +0100=0ASubject: [PATCH 07/73] Revert "=
ASoC: rockchip: Fix a reference count leak."=0A=0AThis reverts commit 5ef8e=
112ddac71c11f9519067fb920a7595190f3.=0A=0ACommits from @umn.edu addresses h=
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
=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sou=
nd/soc/rockchip/rockchip_pdm.c | 4 +---=0A 1 file changed, 1 insertion(+), =
3 deletions(-)=0A=0Adiff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/=
soc/rockchip/rockchip_pdm.c=0Aindex ad16c8310dd3..8a2e3bbce3a1 100644=0A---=
 a/sound/soc/rockchip/rockchip_pdm.c=0A+++ b/sound/soc/rockchip/rockchip_pd=
m.c=0A@@ -478,10 +478,8 @@ static int rockchip_pdm_resume(struct device *de=
v)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) =
{=0A-		pm_runtime_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A =
	ret =3D regcache_sync(pdm->regmap);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 23d755=
3ca91d4761d02514fe4f0ecf7851288658 Mon Sep 17 00:00:00 2001=0AFrom: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:47 +01=
00=0ASubject: [PATCH 08/73] Revert "media: exynos4-is: Fix a reference coun=
t leak=0A due to pm_runtime_get_sync"=0A=0AThis reverts commit 1674941303d3=
41d53342c99992431de5ab6e4312.=0A=0ACommits from @umn.edu addresses have bee=
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
a/platform/exynos4-is/media-dev.c | 4 +---=0A 1 file changed, 1 insertion(+=
), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platform/exynos4-is/media=
-dev.c b/drivers/media/platform/exynos4-is/media-dev.c=0Aindex 24fb0f4b95e1=
=2E.d313f9078e71 100644=0A--- a/drivers/media/platform/exynos4-is/media-dev=
=2Ec=0A+++ b/drivers/media/platform/exynos4-is/media-dev.c=0A@@ -479,10 +47=
9,8 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)=0A =
		return -ENXIO;=0A =0A 	ret =3D pm_runtime_get_sync(fmd->pmf);=0A-	if (ret=
 < 0) {=0A-		pm_runtime_put(fmd->pmf);=0A+	if (ret < 0)=0A 		return ret;=0A=
-	}=0A =0A 	fmd->num_sensors =3D 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9b5f220=
7cae73769778a9ff2cf106c2e1c3ce448 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:47 +010=
0=0ASubject: [PATCH 09/73] Revert "media: exynos4-is: Fix a reference count=
 leak"=0A=0AThis reverts commit 7713c060f1c11b435a6f4e57ee39559645454c5c.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/exynos4-is/mi=
pi-csis.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Ad=
iff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/p=
latform/exynos4-is/mipi-csis.c=0Aindex 040d10df17c9..560aadabcb11 100644=0A=
--- a/drivers/media/platform/exynos4-is/mipi-csis.c=0A+++ b/drivers/media/p=
latform/exynos4-is/mipi-csis.c=0A@@ -513,10 +513,8 @@ static int s5pcsis_s_=
stream(struct v4l2_subdev *sd, int enable)=0A 	if (enable) {=0A 		s5pcsis_c=
lear_counters(state);=0A 		ret =3D pm_runtime_get_sync(&state->pdev->dev);=
=0A-		if (ret && ret !=3D 1) {=0A-			pm_runtime_put_noidle(&state->pdev->de=
v);=0A+		if (ret && ret !=3D 1)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	mute=
x_lock(&state->lock);=0A-- =0A2.30.2=0A=0A=0AFrom 34ae91c1a7f7397e7bc1d5c44=
70626084f7a34a9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:48 +0100=0ASubject: [PATC=
H 10/73] Revert "media: ti-vpe: Fix a missing check and=0A reference count =
leak"=0A=0AThis reverts commit 0cb5c9607f1642e0c29d1cff72fef6ed9a8efe9c.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/media/platform/ti-vpe/vpe.c | 2 --=
=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/media/platform=
/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c=0Aindex bbd8bb611915..2=
e8970c7e22d 100644=0A--- a/drivers/media/platform/ti-vpe/vpe.c=0A+++ b/driv=
ers/media/platform/ti-vpe/vpe.c=0A@@ -2470,8 +2470,6 @@ static int vpe_runt=
ime_get(struct platform_device *pdev)=0A =0A 	r =3D pm_runtime_get_sync(&pd=
ev->dev);=0A 	WARN_ON(r < 0);=0A-	if (r)=0A-		pm_runtime_put_noidle(&pdev->=
dev);=0A 	return r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9dc254=
d16c9f38344aa3fcc29e10f6316bde452a Mon Sep 17 00:00:00 2001=0AFrom: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:48 +01=
00=0ASubject: [PATCH 11/73] Revert "media: s5p-mfc: Fix a reference count l=
eak"=0A=0AThis reverts commit a4c597c385c474e07c672afa8b4406f10b595539.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=
 | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git=
 a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p=
-mfc/s5p_mfc_pm.c=0Aindex 95abf2bd7eba..5e080f32b0e8 100644=0A--- a/drivers=
/media/platform/s5p-mfc/s5p_mfc_pm.c=0A+++ b/drivers/media/platform/s5p-mfc=
/s5p_mfc_pm.c=0A@@ -83,10 +83,8 @@ int s5p_mfc_power_on(void)=0A 	int i, re=
t =3D 0;=0A =0A 	ret =3D pm_runtime_get_sync(pm->device);=0A-	if (ret < 0) =
{=0A-		pm_runtime_put_noidle(pm->device);=0A+	if (ret < 0)=0A 		return ret;=
=0A-	}=0A =0A 	/* clock control */=0A 	for (i =3D 0; i < pm->num_clocks; i+=
+) {=0A-- =0A2.30.2=0A=0A=0AFrom 9f9328a4a82c3debbea09b2c3831924012ece5e9 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:34:48 +0100=0ASubject: [PATCH 12/73] Revert "=
media: platform: fcp: Fix a reference count=0A leak."=0A=0AThis reverts com=
mit 47aa0f3cf46c5b0087461317f3870aca162cb137.=0A=0ACommits from @umn.edu ad=
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
--=0A drivers/media/platform/rcar-fcp.c | 4 +---=0A 1 file changed, 1 inser=
tion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platform/rcar-fcp.c=
 b/drivers/media/platform/rcar-fcp.c=0Aindex 19502a1860cf..0047d144c932 100=
644=0A--- a/drivers/media/platform/rcar-fcp.c=0A+++ b/drivers/media/platfor=
m/rcar-fcp.c=0A@@ -106,10 +106,8 @@ int rcar_fcp_enable(struct rcar_fcp_dev=
ice *fcp)=0A 		return 0;=0A =0A 	ret =3D pm_runtime_get_sync(fcp->dev);=0A-=
	if (ret < 0) {=0A-		pm_runtime_put_noidle(fcp->dev);=0A+	if (ret < 0)=0A 	=
	return ret;=0A-	}=0A =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 46ce7=
6f0bc993870938b3a8c946437f8aaa2e25d Mon Sep 17 00:00:00 2001=0AFrom: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:48 +0=
100=0ASubject: [PATCH 13/73] Revert "media: st-delta: Fix reference count l=
eak in=0A delta_run_work"=0A=0AThis reverts commit 36d682798e58d3b4b66e12c5=
ce48c53f15df7f97.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/s=
ti/delta/delta-v4l2.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletio=
ns(-)=0A=0Adiff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/dri=
vers/media/platform/sti/delta/delta-v4l2.c=0Aindex 7c925f309158..b2dc3d223a=
9c 100644=0A--- a/drivers/media/platform/sti/delta/delta-v4l2.c=0A+++ b/dri=
vers/media/platform/sti/delta/delta-v4l2.c=0A@@ -970,10 +970,8 @@ static vo=
id delta_run_work(struct work_struct *work)=0A 	/* enable the hardware */=
=0A 	if (!dec->pm) {=0A 		ret =3D delta_get_sync(ctx);=0A-		if (ret) {=0A-	=
		delta_put_autosuspend(ctx);=0A+		if (ret)=0A 			goto err;=0A-		}=0A 	}=0A=
 =0A 	/* decode this access unit */=0A-- =0A2.30.2=0A=0A=0AFrom 5ede638aaa6=
848043fb4ba8e491ea5afd6bde655 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:49 +0100=0A=
Subject: [PATCH 14/73] Revert "ASoC: tegra: Fix reference count leaks."=0A=
=0AThis reverts commit 63d5985db8888ba226511e95ebf03b813bcfa8ba.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A sound/soc/tegra/tegra30_ahub.c | 4 +---=0A sound/soc=
/tegra/tegra30_i2s.c  | 4 +---=0A 2 files changed, 2 insertions(+), 6 delet=
ions(-)=0A=0Adiff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/=
tegra30_ahub.c=0Aindex 88e838ac937d..43679aeeb12b 100644=0A--- a/sound/soc/=
tegra/tegra30_ahub.c=0A+++ b/sound/soc/tegra/tegra30_ahub.c=0A@@ -655,10 +6=
55,8 @@ static int tegra30_ahub_resume(struct device *dev)=0A 	int ret;=0A =
=0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_p=
ut(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A 	ret =3D regcache_sync(=
ahub->regmap_ahub);=0A 	ret |=3D regcache_sync(ahub->regmap_apbif);=0A 	pm_=
runtime_put(dev);=0Adiff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/=
tegra/tegra30_i2s.c=0Aindex bf155c5092f0..0b176ea24914 100644=0A--- a/sound=
/soc/tegra/tegra30_i2s.c=0A+++ b/sound/soc/tegra/tegra30_i2s.c=0A@@ -551,10=
 +551,8 @@ static int tegra30_i2s_resume(struct device *dev)=0A 	int ret;=
=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_runti=
me_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A 	ret =3D regcache_s=
ync(i2s->regmap);=0A 	pm_runtime_put(dev);=0A =0A-- =0A2.30.2=0A=0A=0AFrom =
c19a22fdb33fc4d8bc4f5cd96109b98156edd28c Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:=
49 +0100=0ASubject: [PATCH 15/73] Revert "iommu: Fix reference count leak i=
n=0A iommu_group_alloc."=0A=0AThis reverts commit 0716c40a5b5c1d60958411c67=
2f497eca31c85fd.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/iommu/iommu.c | 2=
 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/driv=
ers/iommu/iommu.c b/drivers/iommu/iommu.c=0Aindex e0a6ae6a5796..2c48a9d6d91=
e 100644=0A--- a/drivers/iommu/iommu.c=0A+++ b/drivers/iommu/iommu.c=0A@@ -=
359,7 +359,7 @@ struct iommu_group *iommu_group_alloc(void)=0A 				   NULL,=
 "%d", group->id);=0A 	if (ret) {=0A 		ida_simple_remove(&iommu_group_ida, =
group->id);=0A-		kobject_put(&group->kobj);=0A+		kfree(group);=0A 		return =
ERR_PTR(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom f54b9ac64ca7e7657af5136=
fda5263b83d0d3ced Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:49 +0100=0ASubject: [PA=
TCH 16/73] Revert "ACPI: CPPC: Fix reference count leak in=0A acpi_cppc_pro=
cessor_probe()"=0A=0AThis reverts commit bcb6e3ca64d27b61fe41e479a968eb9734=
325903.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/acpi/cppc_acpi.c | 1 -=
=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/drivers/acpi/cppc_acpi.=
c b/drivers/acpi/cppc_acpi.c=0Aindex 732549ee1fe3..7bf1948b1223 100644=0A--=
- a/drivers/acpi/cppc_acpi.c=0A+++ b/drivers/acpi/cppc_acpi.c=0A@@ -800,7 +=
800,6 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)=0A 			"ac=
pi_cppc");=0A 	if (ret) {=0A 		per_cpu(cpc_desc_ptr, pr->id) =3D NULL;=0A-	=
	kobject_put(&cpc_ptr->kobj);=0A 		goto out_free;=0A 	}=0A =0A-- =0A2.30.2=
=0A=0A=0AFrom 8221541e1777cd6a24ccb2bd230beff7c6a80546 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:34:49 +0100=0ASubject: [PATCH 17/73] Revert "ACPI: sysfs: Fix re=
ference count leak in=0A acpi_sysfs_add_hotplug_profile()"=0A=0AThis revert=
s commit 8641abcf0963ecb3b649e31e46cf2c6610c3493a.=0A=0ACommits from @umn.e=
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
=0A---=0A drivers/acpi/sysfs.c | 4 +---=0A 1 file changed, 1 insertion(+), =
3 deletions(-)=0A=0Adiff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.=
c=0Aindex 3b7e23866b42..ac2cf2c1bbcf 100644=0A--- a/drivers/acpi/sysfs.c=0A=
+++ b/drivers/acpi/sysfs.c=0A@@ -997,10 +997,8 @@ void acpi_sysfs_add_hotpl=
ug_profile(struct acpi_hotplug_profile *hotplug,=0A =0A 	error =3D kobject_=
init_and_add(&hotplug->kobj,=0A 		&acpi_hotplug_profile_ktype, hotplug_kobj=
, "%s", name);=0A-	if (error) {=0A-		kobject_put(&hotplug->kobj);=0A+	if (e=
rror)=0A 		goto err_out;=0A-	}=0A =0A 	kobject_uevent(&hotplug->kobj, KOBJ_=
ADD);=0A 	return;=0A-- =0A2.30.2=0A=0A=0AFrom d639a6a9a2892481ae9d785a8634a=
44be6666a3c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:50 +0100=0ASubject: [PATCH 18=
/73] Revert "qlcnic: fix missing release in=0A qlcnic_83xx_interrupt_test."=
=0A=0AThis reverts commit 4ebf0014e8200224cbcbdf502234230ca8099d5f.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw=
=2Ec | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff -=
-git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/et=
hernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0Aindex aae81226a0a4..1fc84d8f891b 10=
0644=0A--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A+++ b/dr=
ivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A@@ -3650,7 +3650,7 @@ i=
nt qlcnic_83xx_interrupt_test(struct net_device *netdev)=0A 	ahw->diag_cnt =
=3D 0;=0A 	ret =3D qlcnic_alloc_mbx_args(&cmd, adapter, QLCNIC_CMD_INTRPT_T=
EST);=0A 	if (ret)=0A-		goto fail_mbx_args;=0A+		goto fail_diag_irq;=0A =0A=
 	if (adapter->flags & QLCNIC_MSIX_ENABLED)=0A 		intrpt_id =3D ahw->intr_tb=
l[0].id;=0A@@ -3680,8 +3680,6 @@ int qlcnic_83xx_interrupt_test(struct net_=
device *netdev)=0A =0A done:=0A 	qlcnic_free_mbx_args(&cmd);=0A-=0A-fail_mb=
x_args:=0A 	qlcnic_83xx_diag_free_res(netdev, drv_sds_rings);=0A =0A fail_d=
iag_irq:=0A-- =0A2.30.2=0A=0A=0AFrom 11bdc88c777d7c12430373417ebc53a150555e=
4e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:34:50 +0100=0ASubject: [PATCH 19/73] Re=
vert "usb: gadget: fix potential double-free in=0A m66592_probe."=0A=0AThis=
 reverts commit 264175bd94374683d4b0f4944294b44878defe87.=0A=0ACommits from=
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
l.com>=0A---=0A drivers/usb/gadget/udc/m66592-udc.c | 2 +-=0A 1 file change=
d, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/usb/gadget/udc/m=
66592-udc.c b/drivers/usb/gadget/udc/m66592-udc.c=0Aindex 53abad98af6d..46c=
e7bc15f2b 100644=0A--- a/drivers/usb/gadget/udc/m66592-udc.c=0A+++ b/driver=
s/usb/gadget/udc/m66592-udc.c=0A@@ -1672,7 +1672,7 @@ static int m66592_pro=
be(struct platform_device *pdev)=0A =0A err_add_udc:=0A 	m66592_free_reques=
t(&m66592->ep[0].ep, m66592->ep0_req);=0A-	m66592->ep0_req =3D NULL;=0A+=0A=
 clean_up3:=0A 	if (m66592->pdata->on_chip) {=0A 		clk_disable(m66592->clk)=
;=0A-- =0A2.30.2=0A=0A=0AFrom 91e7456706c4a49fac3df51e8bbffc5290fee578 Mon =
Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:34:50 +0100=0ASubject: [PATCH 20/73] Revert "n=
et/mlx4_core: fix a memory leak bug."=0A=0AThis reverts commit 10b585a37112=
b64340d1bd365ed3fb899e337ce6.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/=
ethernet/mellanox/mlx4/fw.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 del=
etion(-)=0A=0Adiff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/driver=
s/net/ethernet/mellanox/mlx4/fw.c=0Aindex 3b13a5ef7e05..cd8854e52371 100644=
=0A--- a/drivers/net/ethernet/mellanox/mlx4/fw.c=0A+++ b/drivers/net/ethern=
et/mellanox/mlx4/fw.c=0A@@ -2715,7 +2715,7 @@ void mlx4_opreq_action(struct=
 work_struct *work)=0A 		if (err) {=0A 			mlx4_err(dev, "Failed to retrieve=
 required operation: %d\n",=0A 				 err);=0A-			goto out;=0A+			return;=0A =
		}=0A 		MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);=0A 		MLX4_=
GET(token, outbox, GET_OP_REQ_TOKEN_OFFSET);=0A-- =0A2.30.2=0A=0A=0AFrom c2=
14e824abe3ab2b86667f88c69c3d0e74034bde Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:50=
 +0100=0ASubject: [PATCH 21/73] Revert "agp/intel: Fix a memory leak on mod=
ule=0A initialisation failure"=0A=0AThis reverts commit b3ad6a3db008e4565d9=
7da15c00ef25ee4b5b59a.=0A=0ACommits from @umn.edu addresses have been found=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/char/agp=
/intel-gtt.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=
=0Adiff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c=
=0Aindex 34cc853772bc..7516ba981b63 100644=0A--- a/drivers/char/agp/intel-g=
tt.c=0A+++ b/drivers/char/agp/intel-gtt.c=0A@@ -304,10 +304,8 @@ static int=
 intel_gtt_setup_scratch_page(void)=0A 	if (intel_private.needs_dmar) {=0A =
		dma_addr =3D pci_map_page(intel_private.pcidev, page, 0,=0A 				    PAGE_=
SIZE, PCI_DMA_BIDIRECTIONAL);=0A-		if (pci_dma_mapping_error(intel_private.=
pcidev, dma_addr)) {=0A-			__free_page(page);=0A+		if (pci_dma_mapping_erro=
r(intel_private.pcidev, dma_addr))=0A 			return -EINVAL;=0A-		}=0A =0A 		in=
tel_private.scratch_page_dma =3D dma_addr;=0A 	} else=0A-- =0A2.30.2=0A=0A=
=0AFrom 90fac0a14a235aa7ae0f7d17c103cf024c6da9cb Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:34:51 +0100=0ASubject: [PATCH 22/73] Revert "ecryptfs: replace BUG_O=
N with error handling=0A code"=0A=0AThis reverts commit 591f3bc646edf4622f8=
6f9266e4e215bde32538b.=0A=0ACommits from @umn.edu addresses have been found=
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
f --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c=0Aindex eed38ae86c6c.=
=2Ebd25ab837011 100644=0A--- a/fs/ecryptfs/crypto.c=0A+++ b/fs/ecryptfs/cry=
pto.c=0A@@ -339,10 +339,8 @@ static int crypt_scatterlist(struct ecryptfs_c=
rypt_stat *crypt_stat,=0A 	struct extent_crypt_result ecr;=0A 	int rc =3D 0=
;=0A =0A-	if (!crypt_stat || !crypt_stat->tfm=0A-	       || !(crypt_stat->f=
lags & ECRYPTFS_STRUCT_INITIALIZED))=0A-		return -EINVAL;=0A-=0A+	BUG_ON(!c=
rypt_stat || !crypt_stat->tfm=0A+	       || !(crypt_stat->flags & ECRYPTFS_=
STRUCT_INITIALIZED));=0A 	if (unlikely(ecryptfs_verbosity > 0)) {=0A 		ecry=
ptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",=0A 				crypt_stat->key_si=
ze);=0A-- =0A2.30.2=0A=0A=0AFrom ab5a5da473ef69726b462fc4de849469a05fe36e M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:34:51 +0100=0ASubject: [PATCH 23/73] Revert "=
net: sun: fix missing release regions in=0A cas_init_one()."=0A=0AThis reve=
rts commit 207a210c6c66aa46f8275a5f13cbc3721e0e7907.=0A=0ACommits from @umn=
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
assini.c b/drivers/net/ethernet/sun/cassini.c=0Aindex 7e5c0f182770..382993c=
1561c 100644=0A--- a/drivers/net/ethernet/sun/cassini.c=0A+++ b/drivers/net=
/ethernet/sun/cassini.c=0A@@ -4983,7 +4983,7 @@ static int cas_init_one(str=
uct pci_dev *pdev, const struct pci_device_id *ent)=0A 					  cas_cacheline=
_size)) {=0A 			dev_err(&pdev->dev, "Could not set PCI cache "=0A 			      =
 "line size\n");=0A-			goto err_out_free_res;=0A+			goto err_write_cachelin=
e;=0A 		}=0A 	}=0A #endif=0A@@ -5158,6 +5158,7 @@ static int cas_init_one(s=
truct pci_dev *pdev, const struct pci_device_id *ent)=0A err_out_free_res:=
=0A 	pci_release_regions(pdev);=0A =0A+err_write_cacheline:=0A 	/* Try to r=
estore it in case the error occurred after we=0A 	 * set it.=0A 	 */=0A-- =
=0A2.30.2=0A=0A=0AFrom 4e7e8f90de2e6c56218fbe27ed80959a793cf493 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:34:51 +0100=0ASubject: [PATCH 24/73] Revert "efi/esrt: =
Fix reference count leak in=0A esre_create_sysfs_entry."=0A=0AThis reverts =
commit cebee7673e1f366259fa96b4e29b1fd23e3f3b41.=0A=0ACommits from @umn.edu=
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
mware/efi/esrt.c=0Aindex deb1d8f3bdc8..f3c28777b8c6 100644=0A--- a/drivers/=
firmware/efi/esrt.c=0A+++ b/drivers/firmware/efi/esrt.c=0A@@ -180,7 +180,7 =
@@ static int esre_create_sysfs_entry(void *esre, int entry_num)=0A 		rc =
=3D kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,=0A 					  "entry=
%d", entry_num);=0A 		if (rc) {=0A-			kobject_put(&entry->kobj);=0A+			kfre=
e(entry);=0A 			return rc;=0A 		}=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 094d516=
e7db0df1cb7492a5922975b7c0b70db15 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:51 +010=
0=0ASubject: [PATCH 25/73] Revert "scsi: iscsi: Fix reference count leak in=
=0A iscsi_boot_create_kobj"=0A=0AThis reverts commit 0bda10eb793c8de7d3ec78=
f9cf2a332a3981f387.=0A=0ACommits from @umn.edu addresses have been found to=
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
=3D data;=0A-- =0A2.30.2=0A=0A=0AFrom 00372185ad301db7c6d8df8c7bcb9c9ef46c2=
b6f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0ADate: Wed, 21 Apr 2021 20:34:52 +0100=0ASubject: [PATCH 26/73] Rev=
ert "vfio/mdev: Fix reference count leak in=0A add_mdev_supported_type"=0A=
=0AThis reverts commit fcc43e9661344ac99aef9fac18ff850fd9cc8894.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/vfio/mdev/mdev_sysfs.c | 2 +-=0A 1 file chan=
ged, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/vfio/mdev/mdev=
_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c=0Aindex 7e474e41c85e..802df210929=
b 100644=0A--- a/drivers/vfio/mdev/mdev_sysfs.c=0A+++ b/drivers/vfio/mdev/m=
dev_sysfs.c=0A@@ -113,7 +113,7 @@ struct mdev_type *add_mdev_supported_type=
(struct mdev_parent *parent,=0A 				   "%s-%s", dev_driver_string(parent->d=
ev),=0A 				   group->name);=0A 	if (ret) {=0A-		kobject_put(&type->kobj);=
=0A+		kfree(type);=0A 		return ERR_PTR(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom b1d62ef1554c078b57b848250ff22597a9547c9d Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:34:52 +0100=0ASubject: [PATCH 27/73] Revert "cpuidle: Fix three refe=
rence count leaks"=0A=0AThis reverts commit b98c3badfadec789bc86e42e58f8fb1=
61aadfdb8.=0A=0ACommits from @umn.edu addresses have been found to be submi=
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
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/cpuidle/sysfs.c | 6 +++=
---=0A 1 file changed, 3 insertions(+), 3 deletions(-)=0A=0Adiff --git a/dr=
ivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c=0Aindex 909bd2255978..ae948=
b1da93a 100644=0A--- a/drivers/cpuidle/sysfs.c=0A+++ b/drivers/cpuidle/sysf=
s.c=0A@@ -414,7 +414,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle=
_device *device)=0A 		ret =3D kobject_init_and_add(&kobj->kobj, &ktype_stat=
e_cpuidle,=0A 					   &kdev->kobj, "state%d", i);=0A 		if (ret) {=0A-			kob=
ject_put(&kobj->kobj);=0A+			kfree(kobj);=0A 			goto error_state;=0A 		}=0A=
 		kobject_uevent(&kobj->kobj, KOBJ_ADD);=0A@@ -544,7 +544,7 @@ static int =
cpuidle_add_driver_sysfs(struct cpuidle_device *dev)=0A 	ret =3D kobject_in=
it_and_add(&kdrv->kobj, &ktype_driver_cpuidle,=0A 				   &kdev->kobj, "driv=
er");=0A 	if (ret) {=0A-		kobject_put(&kdrv->kobj);=0A+		kfree(kdrv);=0A 		=
return ret;=0A 	}=0A =0A@@ -638,7 +638,7 @@ int cpuidle_add_sysfs(struct cp=
uidle_device *dev)=0A 	error =3D kobject_init_and_add(&kdev->kobj, &ktype_c=
puidle, &cpu_dev->kobj,=0A 				   "cpuidle");=0A 	if (error) {=0A-		kobject=
_put(&kdev->kobj);=0A+		kfree(kdev);=0A 		return error;=0A 	}=0A =0A-- =0A2=
=2E30.2=0A=0A=0AFrom 1f47d5f6bd0c41391de72ada427d2fd760c419b2 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:34:52 +0100=0ASubject: [PATCH 28/73] Revert "EDAC: Fix re=
ference count leaks"=0A=0AThis reverts commit 46f7ec5fe967f8cb8e5ce479fa23e=
5476bbee2c1.=0A=0ACommits from @umn.edu addresses have been found to be sub=
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
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/edac/edac_device_sy=
sfs.c | 1 -=0A drivers/edac/edac_pci_sysfs.c    | 2 +-=0A 2 files changed, =
1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/edac/edac_device_s=
ysfs.c b/drivers/edac/edac_device_sysfs.c=0Aindex 5e7593753799..0e7ea3591b7=
8 100644=0A--- a/drivers/edac/edac_device_sysfs.c=0A+++ b/drivers/edac/edac=
_device_sysfs.c=0A@@ -275,7 +275,6 @@ int edac_device_register_sysfs_main_k=
obj(struct edac_device_ctl_info *edac_dev)=0A =0A 	/* Error exit stack */=
=0A err_kobj_reg:=0A-	kobject_put(&edac_dev->kobj);=0A 	module_put(edac_dev=
->owner);=0A =0A err_out:=0Adiff --git a/drivers/edac/edac_pci_sysfs.c b/dr=
ivers/edac/edac_pci_sysfs.c=0Aindex 53042af7262e..72c9eb9fdffb 100644=0A---=
 a/drivers/edac/edac_pci_sysfs.c=0A+++ b/drivers/edac/edac_pci_sysfs.c=0A@@=
 -386,7 +386,7 @@ static int edac_pci_main_kobj_setup(void)=0A =0A 	/* Erro=
r unwind statck */=0A kobject_init_and_add_fail:=0A-	kobject_put(edac_pci_t=
op_main_kobj);=0A+	kfree(edac_pci_top_main_kobj);=0A =0A kzalloc_fail:=0A 	=
module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=0A=0AFrom d5e4c252fc8451d96132c2=
b90f0d8dc23c3d288d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:52 +0100=0ASubject: =
[PATCH 29/73] Revert "fore200e: Fix incorrect checks of NULL pointer=0A der=
eference"=0A=0AThis reverts commit 2730ea6d5c5242b0de0ec7599ce2aadb8d9e0a7a=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/atm/fore200e.c | 25 +++++++-=
-----------------=0A 1 file changed, 7 insertions(+), 18 deletions(-)=0A=0A=
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c=0Aindex 0a1ad1=
a1d34f..f8b7e86907cc 100644=0A--- a/drivers/atm/fore200e.c=0A+++ b/drivers/=
atm/fore200e.c=0A@@ -1496,14 +1496,12 @@ fore200e_open(struct atm_vcc *vcc)=
=0A static void=0A fore200e_close(struct atm_vcc* vcc)=0A {=0A+    struct f=
ore200e*        fore200e =3D FORE200E_DEV(vcc->dev);=0A     struct fore200e=
_vcc*    fore200e_vcc;=0A-    struct fore200e*        fore200e;=0A     stru=
ct fore200e_vc_map* vc_map;=0A     unsigned long           flags;=0A =0A   =
  ASSERT(vcc);=0A-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-=0A     ASSER=
T((vcc->vpi >=3D 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));=0A     ASSERT((v=
cc->vci >=3D 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));=0A =0A@@ -1548,10 +1=
546,10 @@ fore200e_close(struct atm_vcc* vcc)=0A static int=0A fore200e_sen=
d(struct atm_vcc *vcc, struct sk_buff *skb)=0A {=0A-    struct fore200e*   =
     fore200e;=0A-    struct fore200e_vcc*    fore200e_vcc;=0A+    struct f=
ore200e*        fore200e     =3D FORE200E_DEV(vcc->dev);=0A+    struct fore=
200e_vcc*    fore200e_vcc =3D FORE200E_VCC(vcc);=0A     struct fore200e_vc_=
map* vc_map;=0A-    struct host_txq*        txq;=0A+    struct host_txq*   =
     txq          =3D &fore200e->host_txq;=0A     struct host_txq_entry*  e=
ntry;=0A     struct tpd*             tpd;=0A     struct tpd_haddr        tp=
d_haddr;=0A@@ -1564,18 +1562,9 @@ fore200e_send(struct atm_vcc *vcc, struct=
 sk_buff *skb)=0A     unsigned char*          data;=0A     unsigned long   =
        flags;=0A =0A-    if (!vcc)=0A-        return -EINVAL;=0A-=0A-    f=
ore200e =3D FORE200E_DEV(vcc->dev);=0A-    fore200e_vcc =3D FORE200E_VCC(vc=
c);=0A-=0A-    if (!fore200e)=0A-        return -EINVAL;=0A-=0A-    txq =3D=
 &fore200e->host_txq;=0A-    if (!fore200e_vcc)=0A-        return -EINVAL;=
=0A+    ASSERT(vcc);=0A+    ASSERT(fore200e);=0A+    ASSERT(fore200e_vcc);=
=0A =0A     if (!test_bit(ATM_VF_READY, &vcc->flags)) {=0A 	DPRINTK(1, "VC =
%d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);=0A-- =0A2.30.2=
=0A=0A=0AFrom 232fbc1f4874f2c263ffd1bfa50cb89369b33878 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:34:53 +0100=0ASubject: [PATCH 30/73] Revert "rapidio: fix a NULL=
 pointer dereference when=0A create_workqueue() fails"=0A=0AThis reverts co=
mmit a36a8879a446f0bb49f5cb18ec8d392fb2198008.=0A=0ACommits from @umn.edu a=
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
-=0A drivers/rapidio/rio_cm.c | 8 --------=0A 1 file changed, 8 deletions(-=
)=0A=0Adiff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c=0Ai=
ndex b29fc258eeba..cf45829585cb 100644=0A--- a/drivers/rapidio/rio_cm.c=0A+=
++ b/drivers/rapidio/rio_cm.c=0A@@ -2147,14 +2147,6 @@ static int riocm_add=
_mport(struct device *dev,=0A 	mutex_init(&cm->rx_lock);=0A 	riocm_rx_fill(=
cm, RIOCM_RX_RING_SIZE);=0A 	cm->rx_wq =3D create_workqueue(DRV_NAME "/rxq"=
);=0A-	if (!cm->rx_wq) {=0A-		riocm_error("failed to allocate IBMBOX_%d on =
%s",=0A-			    cmbox, mport->name);=0A-		rio_release_outb_mbox(mport, cmbox=
);=0A-		kfree(cm);=0A-		return -ENOMEM;=0A-	}=0A-=0A 	INIT_WORK(&cm->rx_wor=
k, rio_ibmsg_handler);=0A =0A 	cm->tx_slot =3D 0;=0A-- =0A2.30.2=0A=0A=0AFr=
om d146c9b7c03912197627d3ddfa0e58bb60c15321 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
34:53 +0100=0ASubject: [PATCH 31/73] Revert "tracing: Fix a memory leak by =
early error exit=0A in trace_pid_write()"=0A=0AThis reverts commit 5cc7ae88=
0836c5943a773148e7a936728c750430.=0A=0ACommits from @umn.edu addresses have=
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
gned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A kernel/t=
race/trace.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=
=0Adiff --git a/kernel/trace/trace.c b/kernel/trace/trace.c=0Aindex ba966b9=
10378..db82d180490f 100644=0A--- a/kernel/trace/trace.c=0A+++ b/kernel/trac=
e/trace.c=0A@@ -494,10 +494,8 @@ int trace_pid_write(struct trace_pid_list =
*filtered_pids,=0A 	 * not modified.=0A 	 */=0A 	pid_list =3D kmalloc(sizeo=
f(*pid_list), GFP_KERNEL);=0A-	if (!pid_list) {=0A-		trace_parser_put(&pars=
er);=0A+	if (!pid_list)=0A 		return -ENOMEM;=0A-	}=0A =0A 	pid_list->pid_ma=
x =3D READ_ONCE(pid_max);=0A =0A@@ -507,7 +505,6 @@ int trace_pid_write(str=
uct trace_pid_list *filtered_pids,=0A =0A 	pid_list->pids =3D vzalloc((pid_=
list->pid_max + 7) >> 3);=0A 	if (!pid_list->pids) {=0A-		trace_parser_put(=
&parser);=0A 		kfree(pid_list);=0A 		return -ENOMEM;=0A 	}=0A-- =0A2.30.2=
=0A=0A=0AFrom 31286441e3c9a5301236c78d69158f0bb4b59005 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:34:53 +0100=0ASubject: [PATCH 32/73] Revert "net: cw1200: fix a =
NULL pointer dereference"=0A=0AThis reverts commit 325e207324bc2eb2e246f5e2=
986d9e0b3ee0ba91.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/st/=
cw1200/main.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a=
/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/mai=
n.c=0Aindex f4338bce78f4..30c0ff70c874 100644=0A--- a/drivers/net/wireless/=
st/cw1200/main.c=0A+++ b/drivers/net/wireless/st/cw1200/main.c=0A@@ -345,11=
 +345,6 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr=
,=0A 	mutex_init(&priv->wsm_cmd_mux);=0A 	mutex_init(&priv->conf_mutex);=0A=
 	priv->workqueue =3D create_singlethread_workqueue("cw1200_wq");=0A-	if (!=
priv->workqueue) {=0A-		ieee80211_free_hw(hw);=0A-		return NULL;=0A-	}=0A-=
=0A 	sema_init(&priv->scan.lock, 1);=0A 	INIT_WORK(&priv->scan.work, cw1200=
_scan_work);=0A 	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe_wor=
k);=0A-- =0A2.30.2=0A=0A=0AFrom 768e8fa29e47907477b7841691fcf5e4a55426f7 Mo=
n Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:34:54 +0100=0ASubject: [PATCH 33/73] Revert "x=
86/PCI: Fix PCI IRQ routing table memory leak"=0A=0AThis reverts commit 147=
ee2cc1044c5cc8663cd19c78e356b521574d7.=0A=0ACommits from @umn.edu addresses=
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
x c77f565a04f2..0452629148be 100644=0A--- a/arch/x86/pci/irq.c=0A+++ b/arch=
/x86/pci/irq.c=0A@@ -1118,8 +1118,6 @@ static const struct dmi_system_id pc=
iirq_dmi_table[] __initconst =3D {=0A =0A void __init pcibios_irq_init(void=
)=0A {=0A-	struct irq_routing_table *rtable =3D NULL;=0A-=0A 	DBG(KERN_DEBU=
G "PCI: IRQ init\n");=0A =0A 	if (raw_pci_ops =3D=3D NULL)=0A@@ -1130,10 +1=
128,8 @@ void __init pcibios_irq_init(void)=0A 	pirq_table =3D pirq_find_ro=
uting_table();=0A =0A #ifdef CONFIG_PCI_BIOS=0A-	if (!pirq_table && (pci_pr=
obe & PCI_BIOS_IRQ_SCAN)) {=0A+	if (!pirq_table && (pci_probe & PCI_BIOS_IR=
Q_SCAN))=0A 		pirq_table =3D pcibios_get_irq_routing_table();=0A-		rtable =
=3D pirq_table;=0A-	}=0A #endif=0A 	if (pirq_table) {=0A 		pirq_peer_trick(=
);=0A@@ -1148,10 +1144,8 @@ void __init pcibios_irq_init(void)=0A 		 * If w=
e're using the I/O APIC, avoid using the PCI IRQ=0A 		 * routing table=0A 	=
	 */=0A-		if (io_apic_assign_pci_irqs) {=0A-			kfree(rtable);=0A+		if (io_a=
pic_assign_pci_irqs)=0A 			pirq_table =3D NULL;=0A-		}=0A 	}=0A =0A 	x86_in=
it.pci.fixup_irqs();=0A-- =0A2.30.2=0A=0A=0AFrom 9b8b28ecded0e3a75cf7ca5273=
be7da195c45819 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:54 +0100=0ASubject: [PATCH=
 34/73] Revert "mmc_spi: add a status check for=0A spi_sync_locked"=0A=0ATh=
is reverts commit b5128b96309a4c7dd44f15b7ad74a5614f3c520b.=0A=0ACommits fr=
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
 =0A2.30.2=0A=0A=0AFrom d2aeafbad43fe507265b15fc04f804b28f286eaa Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 20:34:54 +0100=0ASubject: [PATCH 35/73] Revert "iio: hmc5=
843: fix potential NULL pointer=0A dereferences"=0A=0AThis reverts commit e=
76528d98e270c167b9b1dbf2867ae782e864556.=0A=0ACommits from @umn.edu address=
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
);=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 974197c19eb00a9584b7c0cd2400eeb3723=
27b18 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:34:55 +0100=0ASubject: [PATCH 36/73] R=
evert "rtlwifi: fix a potential NULL pointer=0A dereference"=0A=0AThis reve=
rts commit 4a63186e40e4c9bdd3afde281e57d162f39762d7.=0A=0ACommits from @umn=
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
lwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c=0Aindex 4a3c713a=
d324..ec82c1c3f12e 100644=0A--- a/drivers/net/wireless/realtek/rtlwifi/base=
=2Ec=0A+++ b/drivers/net/wireless/realtek/rtlwifi/base.c=0A@@ -468,11 +468,=
6 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)=0A 	/* <2=
> work queue */=0A 	rtlpriv->works.hw =3D hw;=0A 	rtlpriv->works.rtl_wq =3D=
 alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);=0A-	if (unlikely(!rtlpriv=
->works.rtl_wq)) {=0A-		pr_err("Failed to allocate work queue\n");=0A-		ret=
urn;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,=0A 			  (=
void *)rtl_watchdog_wq_callback);=0A 	INIT_DELAYED_WORK(&rtlpriv->works.ips=
_nic_off_wq,=0A-- =0A2.30.2=0A=0A=0AFrom 56fa2b546a9c2ccabf1975960cb97ccf48=
a516c0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 20:34:55 +0100=0ASubject: [PATCH 37/73] =
Revert "video: hgafb: fix potential NULL pointer=0A dereference"=0A=0AThis =
reverts commit 4eb9e877981af1f3cf1d4a04687567805b419c6c.=0A=0ACommits from =
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
1;=0A-- =0A2.30.2=0A=0A=0AFrom bb4a3a6bdcfdb577309d5be6ea05bf9d55785fed Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 20:34:55 +0100=0ASubject: [PATCH 38/73] Revert "v=
ideo: imsttfb: fix potential NULL pointer=0A dereferences"=0A=0AThis revert=
s commit 179e70d0260f71b19d4a06d726e7d716fc562875.=0A=0ACommits from @umn.e=
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
rom c9fd4240f347df8c18fcc14adc6d326052ffa937 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:34:55 +0100=0ASubject: [PATCH 39/73] Revert "rfkill: Fix incorrect check t=
o avoid NULL=0A pointer dereference"=0A=0AThis reverts commit c7a6c3d2c372a=
592c975cda98a479287ebd169d1.=0A=0ACommits from @umn.edu addresses have been=
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
ff --git a/net/rfkill/core.c b/net/rfkill/core.c=0Aindex e31b4288f32c..99a2=
e55b01cf 100644=0A--- a/net/rfkill/core.c=0A+++ b/net/rfkill/core.c=0A@@ -9=
98,13 +998,10 @@ static void rfkill_sync_work(struct work_struct *work)=0A =
int __must_check rfkill_register(struct rfkill *rfkill)=0A {=0A 	static uns=
igned long rfkill_no;=0A-	struct device *dev;=0A+	struct device *dev =3D &r=
fkill->dev;=0A 	int error;=0A =0A-	if (!rfkill)=0A-		return -EINVAL;=0A-=0A=
-	dev =3D &rfkill->dev;=0A+	BUG_ON(!rfkill);=0A =0A 	mutex_lock(&rfkill_glo=
bal_mutex);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9e85f09e6236d20298e2cf75c9b02fe=
aa7704c26 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:56 +0100=0ASubject: [PATCH 40/7=
3] Revert "PCI: xilinx: Check for __get_free_pages()=0A failure"=0A=0AThis =
reverts commit 6862830562317897df7e139aa92ac1a3c5a8a87e.=0A=0ACommits from =
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
st/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c=0Aindex a8a44afa81ec..29f=
024f0ed7f 100644=0A--- a/drivers/pci/host/pcie-xilinx.c=0A+++ b/drivers/pci=
/host/pcie-xilinx.c=0A@@ -338,19 +338,14 @@ static const struct irq_domain_=
ops msi_domain_ops =3D {=0A  * xilinx_pcie_enable_msi - Enable MSI support=
=0A  * @port: PCIe port information=0A  */=0A-static int xilinx_pcie_enable=
_msi(struct xilinx_pcie_port *port)=0A+static void xilinx_pcie_enable_msi(s=
truct xilinx_pcie_port *port)=0A {=0A 	phys_addr_t msg_addr;=0A =0A 	port->=
msi_pages =3D __get_free_pages(GFP_KERNEL, 0);=0A-	if (!port->msi_pages)=0A=
-		return -ENOMEM;=0A-=0A 	msg_addr =3D virt_to_phys((void *)port->msi_page=
s);=0A 	pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);=0A 	pcie_write(por=
t, msg_addr, XILINX_PCIE_REG_MSIBASE2);=0A-=0A-	return 0;=0A }=0A =0A /* IN=
Tx Functions */=0A@@ -505,7 +500,6 @@ static int xilinx_pcie_init_irq_domai=
n(struct xilinx_pcie_port *port)=0A 	struct device *dev =3D port->dev;=0A 	=
struct device_node *node =3D dev->of_node;=0A 	struct device_node *pcie_int=
c_node;=0A-	int ret;=0A =0A 	/* Setup INTx */=0A 	pcie_intc_node =3D of_get=
_next_child(node, NULL);=0A@@ -534,9 +528,7 @@ static int xilinx_pcie_init_=
irq_domain(struct xilinx_pcie_port *port)=0A 			return -ENODEV;=0A 		}=0A =
=0A-		ret =3D xilinx_pcie_enable_msi(port);=0A-		if (ret)=0A-			return ret;=
=0A+		xilinx_pcie_enable_msi(port);=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=
=0A=0A=0AFrom 6d2a4919483cf4ab5a936104b8ee99d97bd07359 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:34:56 +0100=0ASubject: [PATCH 41/73] Revert "media: video-mux: f=
ix null pointer=0A dereferences"=0A=0AThis reverts commit 9d561c9546f0add7b=
9e238fd23d68f3065ba24d6.=0A=0ACommits from @umn.edu addresses have been fou=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/pl=
atform/video-mux.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --=
git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux=
=2Ec=0Aindex eedc0b99a891..ee89ad76bee2 100644=0A--- a/drivers/media/platfo=
rm/video-mux.c=0A+++ b/drivers/media/platform/video-mux.c=0A@@ -242,14 +242=
,9 @@ static int video_mux_probe(struct platform_device *pdev)=0A 	vmux->ac=
tive =3D -1;=0A 	vmux->pads =3D devm_kcalloc(dev, num_pads, sizeof(*vmux->p=
ads),=0A 				  GFP_KERNEL);=0A-	if (!vmux->pads)=0A-		return -ENOMEM;=0A-=
=0A 	vmux->format_mbus =3D devm_kcalloc(dev, num_pads,=0A 					 sizeof(*vmu=
x->format_mbus),=0A 					 GFP_KERNEL);=0A-	if (!vmux->format_mbus)=0A-		ret=
urn -ENOMEM;=0A =0A 	for (i =3D 0; i < num_pads - 1; i++)=0A 		vmux->pads[i=
].flags =3D MEDIA_PAD_FL_SINK;=0A-- =0A2.30.2=0A=0A=0AFrom bc5a56676008d44a=
b6b2698a6bf96d7af26a4fd9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:56 +0100=0ASubje=
ct: [PATCH 42/73] Revert "media: rcar_drif: fix a memory disclosure"=0A=0AT=
his reverts commit 3feec89682118fad5139e745c3453a4cf8580ef0.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/media/platform/rcar_drif.c | 1 -=0A 1 file chang=
ed, 1 deletion(-)=0A=0Adiff --git a/drivers/media/platform/rcar_drif.c b/dr=
ivers/media/platform/rcar_drif.c=0Aindex 3871ed6a1fcb..522364ff0d5d 100644=
=0A--- a/drivers/media/platform/rcar_drif.c=0A+++ b/drivers/media/platform/=
rcar_drif.c=0A@@ -915,7 +915,6 @@ static int rcar_drif_g_fmt_sdr_cap(struct=
 file *file, void *priv,=0A {=0A 	struct rcar_drif_sdr *sdr =3D video_drvda=
ta(file);=0A =0A-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved=
));=0A 	f->fmt.sdr.pixelformat =3D sdr->fmt->pixelformat;=0A 	f->fmt.sdr.bu=
ffersize =3D sdr->fmt->buffersize;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9be4730e=
bc5caa9df1fc0b4c1463f4c4cbfbe1b4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:56 +0100=
=0ASubject: [PATCH 43/73] Revert "drm/gma500: fix memory disclosures due to=
=0A uninitialized bytes"=0A=0AThis reverts commit 4d4d3240a7a9defaac373ca5c=
599dcdea9c06279.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/oa=
ktrail_crtc.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/dr=
ivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oaktrail_crtc=
=2Ec=0Aindex 42785f3df60f..0fff269d3fe6 100644=0A--- a/drivers/gpu/drm/gma5=
00/oaktrail_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c=0A@@ -139=
,7 +139,6 @@ static bool mrst_sdvo_find_best_pll(const struct gma_limit_t *=
limit,=0A 	s32 freq_error, min_error =3D 100000;=0A =0A 	memset(best_clock,=
 0, sizeof(*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for=
 (clock.m =3D limit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		fo=
r (clock.n =3D limit->n.min; clock.n <=3D limit->n.max;=0A@@ -196,7 +195,6 =
@@ static bool mrst_lvds_find_best_pll(const struct gma_limit_t *limit,=0A =
	int err =3D target;=0A =0A 	memset(best_clock, 0, sizeof(*best_clock));=0A=
-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =3D limit->m.min; =
clock.m <=3D limit->m.max; clock.m++) {=0A 		for (clock.p1 =3D limit->p1.mi=
n; clock.p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=0AFrom 59970e341883cb4=
b333252ea5645ef3df2f218b0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:57 +0100=0ASubj=
ect: [PATCH 44/73] Revert "gma/gma500: fix a memory disclosure bug due to=
=0A uninitialized bytes"=0A=0AThis reverts commit 6032b6e31b7e40820f1122116=
6540d48f72e1324.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/cd=
v_intel_display.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git =
a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_i=
ntel_display.c=0Aindex 2e8479744ca4..17db4b4749d5 100644=0A--- a/drivers/gp=
u/drm/gma500/cdv_intel_display.c=0A+++ b/drivers/gpu/drm/gma500/cdv_intel_d=
isplay.c=0A@@ -415,8 +415,6 @@ static bool cdv_intel_find_dp_pll(const stru=
ct gma_limit_t *limit,=0A 	struct gma_crtc *gma_crtc =3D to_gma_crtc(crtc);=
=0A 	struct gma_clock_t clock;=0A =0A-	memset(&clock, 0, sizeof(clock));=0A=
-=0A 	switch (refclk) {=0A 	case 27000:=0A 		if (target < 200000) {=0A-- =
=0A2.30.2=0A=0A=0AFrom 510091219f2962698531afdae0bb33f1247d472d Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:34:57 +0100=0ASubject: [PATCH 45/73] Revert "spi : spi-=
topcliff-pch: Fix to handle empty DMA=0A buffers"=0A=0AThis reverts commit =
febdf321b762c4b47cddaace37c031eb71242ecd.=0A=0ACommits from @umn.edu addres=
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
=0A drivers/spi/spi-topcliff-pch.c | 15 ++-------------=0A 1 file changed, =
2 insertions(+), 13 deletions(-)=0A=0Adiff --git a/drivers/spi/spi-topcliff=
-pch.c b/drivers/spi/spi-topcliff-pch.c=0Aindex fa730a871d25..e7e8ea1edcce =
100644=0A--- a/drivers/spi/spi-topcliff-pch.c=0A+++ b/drivers/spi/spi-topcl=
iff-pch.c=0A@@ -1300,27 +1300,18 @@ static void pch_free_dma_buf(struct pch=
_spi_board_data *board_dat,=0A 				  dma->rx_buf_virt, dma->rx_buf_dma);=0A=
 }=0A =0A-static int pch_alloc_dma_buf(struct pch_spi_board_data *board_dat=
,=0A+static void pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,=0A=
 			      struct pch_spi_data *data)=0A {=0A 	struct pch_spi_dma_ctrl *dma;=
=0A-	int ret;=0A =0A 	dma =3D &data->dma;=0A-	ret =3D 0;=0A 	/* Get Consist=
ent memory for Tx DMA */=0A 	dma->tx_buf_virt =3D dma_alloc_coherent(&board=
_dat->pdev->dev,=0A 				PCH_BUF_SIZE, &dma->tx_buf_dma, GFP_KERNEL);=0A-	if=
 (!dma->tx_buf_virt)=0A-		ret =3D -ENOMEM;=0A-=0A 	/* Get Consistent memory=
 for Rx DMA */=0A 	dma->rx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev=
->dev,=0A 				PCH_BUF_SIZE, &dma->rx_buf_dma, GFP_KERNEL);=0A-	if (!dma->rx=
_buf_virt)=0A-		ret =3D -ENOMEM;=0A-=0A-	return ret;=0A }=0A =0A static int=
 pch_spi_pd_probe(struct platform_device *plat_dev)=0A@@ -1397,9 +1388,7 @@=
 static int pch_spi_pd_probe(struct platform_device *plat_dev)=0A =0A 	if (=
use_dma) {=0A 		dev_info(&plat_dev->dev, "Use DMA for data transfers\n");=
=0A-		ret =3D pch_alloc_dma_buf(board_dat, data);=0A-		if (ret)=0A-			goto =
err_spi_register_master;=0A+		pch_alloc_dma_buf(board_dat, data);=0A 	}=0A =
=0A 	ret =3D spi_register_master(master);=0A-- =0A2.30.2=0A=0A=0AFrom fd4b9=
15b76eb6f703e149ac4cc96b5e77c7e66ec Mon Sep 17 00:00:00 2001=0AFrom: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:57 +0=
100=0ASubject: [PATCH 46/73] Revert "ALSA: sb8: add a check for request_reg=
ion"=0A=0AThis reverts commit b042245be24b0e663bcf45f0ae77910bb3f11829.=0A=
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
m.mukherjee@gmail.com>=0A---=0A sound/isa/sb/sb8.c | 4 ----=0A 1 file chang=
ed, 4 deletions(-)=0A=0Adiff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.=
c=0Aindex 1eb8b61a185b..d77dcba276b5 100644=0A--- a/sound/isa/sb/sb8.c=0A++=
+ b/sound/isa/sb/sb8.c=0A@@ -111,10 +111,6 @@ static int snd_sb8_probe(stru=
ct device *pdev, unsigned int dev)=0A =0A 	/* block the 0x388 port to avoid=
 PnP conflicts */=0A 	acard->fm_res =3D request_region(0x388, 4, "SoundBlas=
ter FM");=0A-	if (!acard->fm_res) {=0A-		err =3D -EBUSY;=0A-		goto _err;=0A=
-	}=0A =0A 	if (port[dev] !=3D SNDRV_AUTO_PORT) {=0A 		if ((err =3D snd_sbd=
sp_create(card, port[dev], irq[dev],=0A-- =0A2.30.2=0A=0A=0AFrom 82f4b3f2f6=
e7b75f84ed0329bdac778fb70211e7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:58 +0100=
=0ASubject: [PATCH 47/73] Revert "md: Fix failed allocation of=0A md_regist=
er_thread"=0A=0AThis reverts commit d287b65e265d3879f34805e931f7a25b62dab81=
3.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/raid10.c | 2 --=0A driver=
s/md/raid5.c  | 2 --=0A 2 files changed, 4 deletions(-)=0A=0Adiff --git a/d=
rivers/md/raid10.c b/drivers/md/raid10.c=0Aindex 419ecdd914f4..7f219cb611f4=
 100644=0A--- a/drivers/md/raid10.c=0A+++ b/drivers/md/raid10.c=0A@@ -3822,=
8 +3822,6 @@ static int raid10_run(struct mddev *mddev)=0A 		set_bit(MD_REC=
OVERY_RUNNING, &mddev->recovery);=0A 		mddev->sync_thread =3D md_register_t=
hread(md_do_sync, mddev,=0A 							"reshape");=0A-		if (!mddev->sync_thread=
)=0A-			goto out_free_conf;=0A 	}=0A =0A 	return 0;=0Adiff --git a/drivers/=
md/raid5.c b/drivers/md/raid5.c=0Aindex ed55b02f9f89..512498996e3d 100644=
=0A--- a/drivers/md/raid5.c=0A+++ b/drivers/md/raid5.c=0A@@ -7383,8 +7383,6=
 @@ static int raid5_run(struct mddev *mddev)=0A 		set_bit(MD_RECOVERY_RUNN=
ING, &mddev->recovery);=0A 		mddev->sync_thread =3D md_register_thread(md_d=
o_sync, mddev,=0A 							"reshape");=0A-		if (!mddev->sync_thread)=0A-			go=
to abort;=0A 	}=0A =0A 	/* Ok, everything is just fine now */=0A-- =0A2.30.=
2=0A=0A=0AFrom 452ac140dbe63a94e06527d7ab8327a4c5460a9b Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 20:34:58 +0100=0ASubject: [PATCH 48/73] Revert "qlcnic: Avoid pote=
ntial NULL pointer=0A dereference"=0A=0AThis reverts commit 74a9e727ea1b294=
330f4cd65b290c79e43fbe46d.=0A=0ACommits from @umn.edu addresses have been f=
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
ernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 --=0A 1 file changed, 2 deletions(=
-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/=
drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0Aindex da042bc520d4..7=
f7deeaf1cf0 100644=0A--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtoo=
l.c=0A+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A@@ -1047,=
8 +1047,6 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)=
=0A =0A 	for (i =3D 0; i < QLCNIC_NUM_ILB_PKT; i++) {=0A 		skb =3D netdev_a=
lloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);=0A-		if (!skb)=0A-			break;=
=0A 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);=0A 		skb_p=
ut(skb, QLCNIC_ILB_PKT_SIZE);=0A 		adapter->ahw->diag_cnt =3D 0;=0A-- =0A2.=
30.2=0A=0A=0AFrom 0f2bdc97c4623fa749307dcb6914c21b3b56f1fe Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:34:58 +0100=0ASubject: [PATCH 49/73] Revert "tty: atmel_seri=
al: fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 4=
f49089456e7537c6c2c3596aaabd89d698dbe15.=0A=0ACommits from @umn.edu address=
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
=0A drivers/tty/serial/atmel_serial.c | 4 ----=0A 1 file changed, 4 deletio=
ns(-)=0A=0Adiff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/ser=
ial/atmel_serial.c=0Aindex a00227d312d3..dd494ca7a832 100644=0A--- a/driver=
s/tty/serial/atmel_serial.c=0A+++ b/drivers/tty/serial/atmel_serial.c=0A@@ =
-1175,10 +1175,6 @@ static int atmel_prepare_rx_dma(struct uart_port *port)=
=0A 					 sg_dma_len(&atmel_port->sg_rx)/2,=0A 					 DMA_DEV_TO_MEM,=0A 			=
		 DMA_PREP_INTERRUPT);=0A-	if (!desc) {=0A-		dev_err(port->dev, "Preparing=
 DMA cyclic failed\n");=0A-		goto chan_err;=0A-	}=0A 	desc->callback =3D at=
mel_complete_rx_dma;=0A 	desc->callback_param =3D port;=0A 	atmel_port->des=
c_rx =3D desc;=0A-- =0A2.30.2=0A=0A=0AFrom 7431b66926b05a68ff6a81562d70ed28=
00eacb0b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:59 +0100=0ASubject: [PATCH 50/73=
] Revert "scsi: qla4xxx: fix a potential NULL pointer=0A dereference"=0A=0A=
This reverts commit 5d429f762470c15b7bc2d5b3f3bb2e5bb41c22d6.=0A=0ACommits =
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
e@gmail.com>=0A---=0A drivers/scsi/qla4xxx/ql4_os.c | 2 --=0A 1 file change=
d, 2 deletions(-)=0A=0Adiff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers=
/scsi/qla4xxx/ql4_os.c=0Aindex 62022a66e9ee..d6ed94342b9e 100644=0A--- a/dr=
ivers/scsi/qla4xxx/ql4_os.c=0A+++ b/drivers/scsi/qla4xxx/ql4_os.c=0A@@ -320=
7,8 +3207,6 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_s=
ession,=0A 	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))=0A 		re=
turn -EINVAL;=0A 	ep =3D iscsi_lookup_endpoint(transport_fd);=0A-	if (!ep)=
=0A-		return -EINVAL;=0A 	conn =3D cls_conn->dd_data;=0A 	qla_conn =3D conn=
->dd_data;=0A 	qla_conn->qla_ep =3D ep->dd_data;=0A-- =0A2.30.2=0A=0A=0AFro=
m 5837ed8a98e480483f4af3b0f424c2ee6d15a027 Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:3=
4:59 +0100=0ASubject: [PATCH 51/73] Revert "libnvdimm/btt: Fix a kmemdup fa=
ilure check"=0A=0AThis reverts commit 32423424a8cf4ff4ec3fe59b0d53d026a0743=
17e.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/btt_devs.c | 18 +++++-=
------------=0A 1 file changed, 5 insertions(+), 13 deletions(-)=0A=0Adiff =
--git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c=0Aindex 76a74=
e292fd7..69ae2ad8d36c 100644=0A--- a/drivers/nvdimm/btt_devs.c=0A+++ b/driv=
ers/nvdimm/btt_devs.c=0A@@ -198,15 +198,14 @@ static struct device *__nd_bt=
t_create(struct nd_region *nd_region,=0A 		return NULL;=0A =0A 	nd_btt->id =
=3D ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNEL);=0A-	if (nd_btt->=
id < 0)=0A-		goto out_nd_btt;=0A+	if (nd_btt->id < 0) {=0A+		kfree(nd_btt);=
=0A+		return NULL;=0A+	}=0A =0A 	nd_btt->lbasize =3D lbasize;=0A-	if (uuid)=
 {=0A+	if (uuid)=0A 		uuid =3D kmemdup(uuid, 16, GFP_KERNEL);=0A-		if (!uui=
d)=0A-			goto out_put_id;=0A-	}=0A 	nd_btt->uuid =3D uuid;=0A 	dev =3D &nd_=
btt->dev;=0A 	dev_set_name(dev, "btt%d.%d", nd_region->id, nd_btt->id);=0A@=
@ -221,13 +220,6 @@ static struct device *__nd_btt_create(struct nd_region =
*nd_region,=0A 		return NULL;=0A 	}=0A 	return dev;=0A-=0A-out_put_id:=0A-	=
ida_simple_remove(&nd_region->btt_ida, nd_btt->id);=0A-=0A-out_nd_btt:=0A-	=
kfree(nd_btt);=0A-	return NULL;=0A }=0A =0A struct device *nd_btt_create(st=
ruct nd_region *nd_region)=0A-- =0A2.30.2=0A=0A=0AFrom 37f7eebf005077b097cb=
c994037a60d66b5828bf Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:59 +0100=0ASubject: =
[PATCH 52/73] Revert "x86/hpet: Prevent potential NULL pointer=0A dereferen=
ce"=0A=0AThis reverts commit c65812de901537e6dec45a66fd86f4f535925644.=0A=
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
m.mukherjee@gmail.com>=0A---=0A arch/x86/kernel/hpet.c | 2 --=0A 1 file cha=
nged, 2 deletions(-)=0A=0Adiff --git a/arch/x86/kernel/hpet.c b/arch/x86/ke=
rnel/hpet.c=0Aindex df767e6de8dd..afa1a204bc6d 100644=0A--- a/arch/x86/kern=
el/hpet.c=0A+++ b/arch/x86/kernel/hpet.c=0A@@ -909,8 +909,6 @@ int __init h=
pet_enable(void)=0A 		return 0;=0A =0A 	hpet_set_mapping();=0A-	if (!hpet_v=
irt_address)=0A-		return 0;=0A =0A 	/*=0A 	 * Read the period and check for=
 a sane value:=0A-- =0A2.30.2=0A=0A=0AFrom 7b32aa1390a33620046e461777706e03=
e3b58cd6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 20:34:59 +0100=0ASubject: [PATCH 53/73=
] Revert "staging: rtl8188eu: Fix potential NULL pointer=0A dereference of =
kcalloc"=0A=0AThis reverts commit 6849e040a935a09fdfee55c7f9fe12609921c489.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/rtl8188eu/core/rtw_x=
mit.c    |  9 ++-------=0A drivers/staging/rtl8188eu/include/rtw_xmit.h |  =
2 +-=0A drivers/staging/rtl8723bs/core/rtw_xmit.c    | 14 +++++++-------=0A=
 drivers/staging/rtl8723bs/include/rtw_xmit.h |  2 +-=0A 4 files changed, 1=
1 insertions(+), 16 deletions(-)=0A=0Adiff --git a/drivers/staging/rtl8188e=
u/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0Aindex 7c895=
af1ba31..f1699e8f3e89 100644=0A--- a/drivers/staging/rtl8188eu/core/rtw_xmi=
t.c=0A+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0A@@ -188,9 +188,7 @@=
 s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padap=
ter)=0A =0A 	pxmitpriv->free_xmit_extbuf_cnt =3D num_xmit_extbuf;=0A =0A-	r=
es =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _FAIL)=0A-		goto exi=
t;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(pxmitpriv->hwxmits=
, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; i++)=0A@@ -1575,7 =
+1573,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_fr=
ame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_alloc_hwxmits(struct a=
dapter *padapter)=0A+void rtw_alloc_hwxmits(struct adapter *padapter)=0A {=
=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmitpriv =3D &padapter=
->xmitpriv;=0A@@ -1584,8 +1582,6 @@ s32 rtw_alloc_hwxmits(struct adapter *p=
adapter)=0A =0A 	pxmitpriv->hwxmits =3D kcalloc(pxmitpriv->hwxmit_entry,=0A=
 				     sizeof(struct hw_xmit), GFP_KERNEL);=0A-	if (!pxmitpriv->hwxmits)=
=0A-		return _FAIL;=0A =0A 	hwxmits =3D pxmitpriv->hwxmits;=0A =0A@@ -1593,=
7 +1589,6 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A 	hwxmits[1]=
 .sta_queue =3D &pxmitpriv->vi_pending;=0A 	hwxmits[2] .sta_queue =3D &pxmi=
tpriv->be_pending;=0A 	hwxmits[3] .sta_queue =3D &pxmitpriv->bk_pending;=0A=
-	return _SUCCESS;=0A }=0A =0A void rtw_free_hwxmits(struct adapter *padapt=
er)=0Adiff --git a/drivers/staging/rtl8188eu/include/rtw_xmit.h b/drivers/s=
taging/rtl8188eu/include/rtw_xmit.h=0Aindex 1be4b478475a..dd6b7a9a8d4a 1006=
44=0A--- a/drivers/staging/rtl8188eu/include/rtw_xmit.h=0A+++ b/drivers/sta=
ging/rtl8188eu/include/rtw_xmit.h=0A@@ -342,7 +342,7 @@ s32 rtw_txframes_st=
a_ac_pending(struct adapter *padapter,=0A void rtw_init_hwxmits(struct hw_x=
mit *phwxmit, int entry);=0A s32 _rtw_init_xmit_priv(struct xmit_priv *pxmi=
tpriv, struct adapter *padapter);=0A void _rtw_free_xmit_priv(struct xmit_p=
riv *pxmitpriv);=0A-s32 rtw_alloc_hwxmits(struct adapter *padapter);=0A+voi=
d rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_free_hwxmits(str=
uct adapter *padapter);=0A s32 rtw_xmit(struct adapter *padapter, struct sk=
_buff **pkt);=0A =0Adiff --git a/drivers/staging/rtl8723bs/core/rtw_xmit.c =
b/drivers/staging/rtl8723bs/core/rtw_xmit.c=0Aindex 91dab7f8a739..022f65441=
9e4 100644=0A--- a/drivers/staging/rtl8723bs/core/rtw_xmit.c=0A+++ b/driver=
s/staging/rtl8723bs/core/rtw_xmit.c=0A@@ -271,9 +271,7 @@ s32	_rtw_init_xmi=
t_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)=0A 		}=0A 	}=
=0A =0A-	res =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _FAIL)=0A-=
		goto exit;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(pxmitpri=
v->hwxmits, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; i++) {=
=0A@@ -2159,7 +2157,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, =
struct xmit_frame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_alloc_hw=
xmits(struct adapter *padapter)=0A+void rtw_alloc_hwxmits(struct adapter *p=
adapter)=0A {=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmitpriv =
=3D &padapter->xmitpriv;=0A@@ -2170,8 +2168,10 @@ s32 rtw_alloc_hwxmits(str=
uct adapter *padapter)=0A =0A 	pxmitpriv->hwxmits =3D (struct hw_xmit *)rtw=
_zmalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry);=0A =0A-	if (!px=
mitpriv->hwxmits)=0A-		return _FAIL;=0A+	if (pxmitpriv->hwxmits =3D=3D NULL=
) {=0A+		DBG_871X("alloc hwxmits fail!...\n");=0A+		return;=0A+	}=0A =0A 	h=
wxmits =3D pxmitpriv->hwxmits;=0A =0A@@ -2217,7 +2217,7 @@ s32 rtw_alloc_hw=
xmits(struct adapter *padapter)=0A =0A 	}=0A =0A-	return _SUCCESS;=0A+=0A }=
=0A =0A void rtw_free_hwxmits(struct adapter *padapter)=0Adiff --git a/driv=
ers/staging/rtl8723bs/include/rtw_xmit.h b/drivers/staging/rtl8723bs/includ=
e/rtw_xmit.h=0Aindex 92236ca8a1ef..11571649cd2c 100644=0A--- a/drivers/stag=
ing/rtl8723bs/include/rtw_xmit.h=0A+++ b/drivers/staging/rtl8723bs/include/=
rtw_xmit.h=0A@@ -494,7 +494,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *=
pxmitpriv, struct adapter *padapter);=0A void _rtw_free_xmit_priv (struct x=
mit_priv *pxmitpriv);=0A =0A =0A-s32 rtw_alloc_hwxmits(struct adapter *pada=
pter);=0A+void rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_fre=
e_hwxmits(struct adapter *padapter);=0A =0A =0A-- =0A2.30.2=0A=0A=0AFrom f1=
10de44e040dd9fe2a902a6e05a8d6e6a736346 Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:00=
 +0100=0ASubject: [PATCH 54/73] Revert "leds: lp5523: fix a missing check o=
f return=0A value of lp55xx_read"=0A=0AThis reverts commit caa27a81df46e5a6=
97ca6731677deeb45100883b.=0A=0ACommits from @umn.edu addresses have been fo=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/leds/led=
s-lp5523.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c=0Ainde=
x 13838d72e297..924e50aefb00 100644=0A--- a/drivers/leds/leds-lp5523.c=0A++=
+ b/drivers/leds/leds-lp5523.c=0A@@ -318,9 +318,7 @@ static int lp5523_init=
_program_engine(struct lp55xx_chip *chip)=0A =0A 	/* Let the programs run f=
or couple of ms and check the engine status */=0A 	usleep_range(3000, 6000)=
;=0A-	ret =3D lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A-	if (ret)=
=0A-		return ret;=0A+	lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A 	st=
atus &=3D LP5523_ENG_STATUS_MASK;=0A =0A 	if (status !=3D LP5523_ENG_STATUS=
_MASK) {=0A-- =0A2.30.2=0A=0A=0AFrom 25c5142a6e5af2fd777c0cac847d5cea05111e=
9e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:35:00 +0100=0ASubject: [PATCH 55/73] Re=
vert "mfd: mc13xxx: Fix a missing check of a=0A register-read failure"=0A=
=0AThis reverts commit 1f1408d9088c3bb2ce9c4ca066f24b3e147ba14e.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/mfd/mc13xxx-core.c | 4 +---=0A 1 file change=
d, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/mfd/mc13xxx-cor=
e.c b/drivers/mfd/mc13xxx-core.c=0Aindex 75d52034f89d..7ea1d5c4f60b 100644=
=0A--- a/drivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/mc13xxx-core.c=0A@@=
 -274,9 +274,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, un=
signed int mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_ADC_WORKING;=0A =0A=
-	ret =3D mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A-	if (ret)=
=0A-		goto out;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A =
=0A 	adc0 =3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=0A 	       MC13XX=
X_ADC0_CHRGRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom 60b8565320f8369e5d20d7325c90=
6b3cf9e0ff09 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:00 +0100=0ASubject: [PATCH 5=
6/73] Revert "gdrom: fix a memory leak bug"=0A=0AThis reverts commit e5727e=
4feb221f40d70b8c91e116543c491c83c1.=0A=0ACommits from @umn.edu addresses ha=
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
s/cdrom/gdrom.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/dr=
ivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 72cd96a8eb19..ae3a7537c=
f0f 100644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/drivers/cdrom/gdrom.c=0A@@=
 -889,7 +889,6 @@ static void __exit exit_gdrom(void)=0A 	platform_device_u=
nregister(pd);=0A 	platform_driver_unregister(&gdrom_driver);=0A 	kfree(gd.=
toc);=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(init_gdrom);=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 523302f6f823dbb2e68d453c609e9a992bf4daf3 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:35:01 +0100=0ASubject: [PATCH 57/73] Revert "atl1e: check=
ing the status of=0A atl1e_write_phy_reg"=0A=0AThis reverts commit a4bc476b=
d09e09d8f854dd8b7dcb60cb0c4dfafe.=0A=0ACommits from @umn.edu addresses have=
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
net/ethernet/atheros/atl1e/atl1e_main.c | 4 +---=0A 1 file changed, 1 inser=
tion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/atheros/atl1=
e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0Aindex 0d=
08039981b5..4f7e195af0bc 100644=0A--- a/drivers/net/ethernet/atheros/atl1e/=
atl1e_main.c=0A+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0A@@ -=
472,9 +472,7 @@ static void atl1e_mdio_write(struct net_device *netdev, int=
 phy_id,=0A {=0A 	struct atl1e_adapter *adapter =3D netdev_priv(netdev);=0A=
 =0A-	if (atl1e_write_phy_reg(&adapter->hw,=0A-				reg_num & MDIO_REG_ADDR_=
MASK, val))=0A-		netdev_err(netdev, "write phy register failed\n");=0A+	atl=
1e_write_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, val);=0A }=0A =
=0A static int atl1e_mii_ioctl(struct net_device *netdev,=0A-- =0A2.30.2=0A=
=0A=0AFrom 50989d3aee1886e65d440a42ff65632acb215d3b Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:35:01 +0100=0ASubject: [PATCH 58/73] Revert "net: dsa: bcm_sf2: Pro=
pagate error value from=0A mdio_write"=0A=0AThis reverts commit 04e35269d5d=
34ad5e4e13105048c77b872438e02.=0A=0ACommits from @umn.edu addresses have be=
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
/dsa/bcm_sf2.c | 7 ++++---=0A 1 file changed, 4 insertions(+), 3 deletions(=
-)=0A=0Adiff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c=
=0Aindex 11a72c4cbb92..5694fddec381 100644=0A--- a/drivers/net/dsa/bcm_sf2.=
c=0A+++ b/drivers/net/dsa/bcm_sf2.c=0A@@ -438,10 +438,11 @@ static int bcm_=
sf2_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,=0A 	 * send th=
em to our master MDIO bus controller=0A 	 */=0A 	if (addr =3D=3D BRCM_PSEUD=
O_PHY_ADDR && priv->indir_phy_mask & BIT(addr))=0A-		return bcm_sf2_sw_indi=
r_rw(priv, 0, addr, regnum, val);=0A+		bcm_sf2_sw_indir_rw(priv, 0, addr, r=
egnum, val);=0A 	else=0A-		return mdiobus_write_nested(priv->master_mii_bus=
, addr,=0A-				regnum, val);=0A+		mdiobus_write_nested(priv->master_mii_bus=
, addr, regnum, val);=0A+=0A+	return 0;=0A }=0A =0A static irqreturn_t bcm_=
sf2_switch_0_isr(int irq, void *dev_id)=0A-- =0A2.30.2=0A=0A=0AFrom ed86b66=
ab777b04272ae73a95c0174badcbe5a3a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:01 +010=
0=0ASubject: [PATCH 59/73] Revert "net: stmicro: fix a missing check of=0A =
clk_prepare"=0A=0AThis reverts commit 2f2a742cea6d028c703f53fb57919c101e6ae=
f12.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/stmicro/stmmac/d=
wmac-sunxi.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=
=0Adiff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers=
/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0Aindex 57694eada995..c0824c6fe8=
6d 100644=0A--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A+++ b=
/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A@@ -59,9 +59,7 @@ stat=
ic int sun7i_gmac_init(struct platform_device *pdev, void *priv)=0A 		gmac-=
>clk_enabled =3D 1;=0A 	} else {=0A 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC=
_MII_RATE);=0A-		ret =3D clk_prepare(gmac->tx_clk);=0A-		if (ret)=0A-			ret=
urn ret;=0A+		clk_prepare(gmac->tx_clk);=0A 	}=0A =0A 	return 0;=0A-- =0A2.=
30.2=0A=0A=0AFrom e88511227f80111f95c79f5327f4b293c0e40a2d Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:35:01 +0100=0ASubject: [PATCH 60/73] Revert "net: (cpts) fix=
 a missing check of clk_prepare"=0A=0AThis reverts commit 3092e216b75397f09=
611a6d409476e5d7e8a75c2.=0A=0ACommits from @umn.edu addresses have been fou=
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
rnet/ti/cpts.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=
=0A=0Adiff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti=
/cpts.c=0Aindex 9e7e7e8a018d..f7f90f77644b 100644=0A--- a/drivers/net/ether=
net/ti/cpts.c=0A+++ b/drivers/net/ethernet/ti/cpts.c=0A@@ -566,9 +566,7 @@ =
struct cpts *cpts_create(struct device *dev, void __iomem *regs,=0A 		retur=
n ERR_PTR(PTR_ERR(cpts->refclk));=0A 	}=0A =0A-	ret =3D clk_prepare(cpts->r=
efclk);=0A-	if (ret)=0A-		return ERR_PTR(ret);=0A+	clk_prepare(cpts->refclk=
);=0A =0A 	cpts->cc.read =3D cpts_systim_read;=0A 	cpts->cc.mask =3D CLOCKS=
OURCE_MASK(32);=0A-- =0A2.30.2=0A=0A=0AFrom 60f96e0d9146cf5ec512558d87b2a67=
05d0e35d0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:02 +0100=0ASubject: [PATCH 61/7=
3] Revert "net/net_namespace: Check the return value of=0A register_pernet_=
subsys()"=0A=0AThis reverts commit 145422360a329f12f8c19ddad5edb178625966ee=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A net/core/net_namespace.c | 3 +--=0A =
1 file changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/net/core/n=
et_namespace.c b/net/core/net_namespace.c=0Aindex 1af25d53f63c..60b88718b1d=
4 100644=0A--- a/net/core/net_namespace.c=0A+++ b/net/core/net_namespace.c=
=0A@@ -854,8 +854,7 @@ static int __init net_ns_init(void)=0A =0A 	mutex_un=
lock(&net_mutex);=0A =0A-	if (register_pernet_subsys(&net_ns_ops))=0A-		pan=
ic("Could not register network namespace subsystems");=0A+	register_pernet_=
subsys(&net_ns_ops);=0A =0A 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_net=
_newid, NULL,=0A 		      RTNL_FLAG_DOIT_UNLOCKED);=0A-- =0A2.30.2=0A=0A=0AF=
rom eb3b2eed19505fe848208502adb34686fffd928a Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20=
:35:02 +0100=0ASubject: [PATCH 62/73] Revert "drivers/regulator: fix a miss=
ing check of=0A return value"=0A=0AThis reverts commit b63cd67875dda7d041f0=
febc2bb5453361b8b101.=0A=0ACommits from @umn.edu addresses have been found =
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
_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 7269ee3e40723b84aaf=
fba665b0a531304ff7c94 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:02 +0100=0ASubject:=
 [PATCH 63/73] Revert "yam: fix a missing-check bug"=0A=0AThis reverts comm=
it d0539c56391d449603f7ff2bcddf38995df49749.=0A=0ACommits from @umn.edu add=
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
=0A drivers/net/hamradio/yam.c | 4 ----=0A 1 file changed, 4 deletions(-)=
=0A=0Adiff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c=
=0Aindex b74c735a423d..de05fc817e93 100644=0A--- a/drivers/net/hamradio/yam=
=2Ec=0A+++ b/drivers/net/hamradio/yam.c=0A@@ -980,8 +980,6 @@ static int ya=
m_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)=0A 				 sizeof(=
struct yamdrv_ioctl_mcs));=0A 		if (IS_ERR(ym))=0A 			return PTR_ERR(ym);=
=0A-		if (ym->cmd !=3D SIOCYAMSMCS)=0A-			return -EINVAL;=0A 		if (ym->bitr=
ate > YAM_MAXBITRATE) {=0A 			kfree(ym);=0A 			return -EINVAL;=0A@@ -997,8 =
+995,6 @@ static int yam_ioctl(struct net_device *dev, struct ifreq *ifr, i=
nt cmd)=0A 		if (copy_from_user(&yi, ifr->ifr_data, sizeof(struct yamdrv_io=
ctl_cfg)))=0A 			 return -EFAULT;=0A =0A-		if (yi.cmd !=3D SIOCYAMSCFG)=0A-=
			return -EINVAL;=0A 		if ((yi.cfg.mask & YAM_IOBASE) && netif_running(dev=
))=0A 			return -EINVAL;		/* Cannot change this parameter when up */=0A 		i=
f ((yi.cfg.mask & YAM_IRQ) && netif_running(dev))=0A-- =0A2.30.2=0A=0A=0AFr=
om 6bb00b4fedbe88cc8a44948e6163fd74e704d4b2 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:=
35:03 +0100=0ASubject: [PATCH 64/73] Revert "hwmon: (lm80) fix a missing ch=
eck of bus read=0A in lm80 probe"=0A=0AThis reverts commit 1812be7e56c7c444=
7c2facdc52d81a872158a957.=0A=0ACommits from @umn.edu addresses have been fo=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/hwmon/lm=
80.c | 11 ++---------=0A 1 file changed, 2 insertions(+), 9 deletions(-)=0A=
=0Adiff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c=0Aindex f9b8e3e=
23a8e..dc2bd82b3202 100644=0A--- a/drivers/hwmon/lm80.c=0A+++ b/drivers/hwm=
on/lm80.c=0A@@ -630,7 +630,6 @@ static int lm80_probe(struct i2c_client *cl=
ient,=0A 	struct device *dev =3D &client->dev;=0A 	struct device *hwmon_dev=
;=0A 	struct lm80_data *data;=0A-	int rv;=0A =0A 	data =3D devm_kzalloc(dev=
, sizeof(struct lm80_data), GFP_KERNEL);=0A 	if (!data)=0A@@ -643,14 +642,8=
 @@ static int lm80_probe(struct i2c_client *client,=0A 	lm80_init_client(c=
lient);=0A =0A 	/* A few vars need to be filled upon startup */=0A-	rv =3D =
lm80_read_value(client, LM80_REG_FAN_MIN(1));=0A-	if (rv < 0)=0A-		return r=
v;=0A-	data->fan[f_min][0] =3D rv;=0A-	rv =3D lm80_read_value(client, LM80_=
REG_FAN_MIN(2));=0A-	if (rv < 0)=0A-		return rv;=0A-	data->fan[f_min][1] =
=3D rv;=0A+	data->fan[f_min][0] =3D lm80_read_value(client, LM80_REG_FAN_MI=
N(1));=0A+	data->fan[f_min][1] =3D lm80_read_value(client, LM80_REG_FAN_MIN=
(2));=0A =0A 	hwmon_dev =3D devm_hwmon_device_register_with_groups(dev, cli=
ent->name,=0A 							   data, lm80_groups);=0A-- =0A2.30.2=0A=0A=0AFrom fee=
33fab2171e5ea0fb752fa5495891eb8b1caca Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:03 =
+0100=0ASubject: [PATCH 65/73] Revert "net: cxgb3_main: fix a missing-check=
 bug"=0A=0AThis reverts commit ec4e9618d1fdc980b7018c698cccbc1bbcd6e3fc.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/chelsio/cxgb3/cxgb3_ma=
in.c | 17 -----------------=0A 1 file changed, 17 deletions(-)=0A=0Adiff --=
git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/etherne=
t/chelsio/cxgb3/cxgb3_main.c=0Aindex b8779afb8550..e9617e5e5ec3 100644=0A--=
- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A+++ b/drivers/net/eth=
ernet/chelsio/cxgb3/cxgb3_main.c=0A@@ -2159,8 +2159,6 @@ static int cxgb_ex=
tension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -=
EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAU=
LT;=0A-		if (t.cmd !=3D CHELSIO_SET_QSET_PARAMS)=0A-			return -EINVAL;=0A 	=
	if (t.qset_idx >=3D SGE_QSETS)=0A 			return -EINVAL;=0A 		if (!in_range(t.=
intr_lat, 0, M_NEWTIMER) ||=0A@@ -2260,9 +2258,6 @@ static int cxgb_extensi=
on_ioctl(struct net_device *dev, void __user *useraddr)=0A 		if (copy_from_=
user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A =0A-		if (t.cmd !=
=3D CHELSIO_GET_QSET_PARAMS)=0A-			return -EINVAL;=0A-=0A 		/* Display qset=
s for all ports when offload enabled */=0A 		if (test_bit(OFFLOAD_DEVMAP_BI=
T, &adapter->open_device_map)) {=0A 			q1 =3D 0;=0A@@ -2308,8 +2303,6 @@ st=
atic int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr=
)=0A 			return -EBUSY;=0A 		if (copy_from_user(&edata, useraddr, sizeof(eda=
ta)))=0A 			return -EFAULT;=0A-		if (edata.cmd !=3D CHELSIO_SET_QSET_NUM)=
=0A-			return -EINVAL;=0A 		if (edata.val < 1 ||=0A 			(edata.val > 1 && !(=
adapter->flags & USING_MSIX)))=0A 			return -EINVAL;=0A@@ -2350,8 +2343,6 @=
@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *user=
addr)=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(t))=
)=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_LOAD_FW)=0A-			return -=
EINVAL;=0A 		/* Check t.len sanity ? */=0A 		fw_data =3D memdup_user(userad=
dr + sizeof(t), t.len);=0A 		if (IS_ERR(fw_data))=0A@@ -2375,8 +2366,6 @@ s=
tatic int cxgb_extension_ioctl(struct net_device *dev, void __user *useradd=
r)=0A 			return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=
=0A 			return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SETMTUTAB)=0A-			return =
-EINVAL;=0A 		if (m.nmtus !=3D NMTUS)=0A 			return -EINVAL;=0A 		if (m.mtus=
[0] < 81)	/* accommodate SACK */=0A@@ -2418,8 +2407,6 @@ static int cxgb_ex=
tension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -=
EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			return -EFAU=
LT;=0A-		if (m.cmd !=3D CHELSIO_SET_PM)=0A-			return -EINVAL;=0A 		if (!is_=
power_of_2(m.rx_pg_sz) ||=0A 			!is_power_of_2(m.tx_pg_sz))=0A 			return -E=
INVAL;	/* not power of 2 */=0A@@ -2455,8 +2442,6 @@ static int cxgb_extensi=
on_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EIO;	=
/* need the memory controllers */=0A 		if (copy_from_user(&t, useraddr, siz=
eof(t)))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_GET_MEM)=0A-			r=
eturn -EINVAL;=0A 		if ((t.addr & 7) || (t.len & 7))=0A 			return -EINVAL;=
=0A 		if (t.mem_id =3D=3D MEM_CM)=0A@@ -2509,8 +2494,6 @@ static int cxgb_e=
xtension_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return =
-EAGAIN;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EF=
AULT;=0A-		if (t.cmd !=3D CHELSIO_SET_TRACE_FILTER)=0A-			return -EINVAL;=
=0A =0A 		tp =3D (const struct trace_params *)&t.sip;=0A 		if (t.config_tx)=
=0A-- =0A2.30.2=0A=0A=0AFrom 2967a488120bc20e588a24f92028d487984231ec Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:35:03 +0100=0ASubject: [PATCH 66/73] Revert "libn=
vdimm/namespace: Fix a potential NULL=0A pointer dereference"=0A=0AThis rev=
erts commit 3a786906c88a03a02d3cceecf6003dea01241317.=0A=0ACommits from @um=
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
m>=0A---=0A drivers/nvdimm/namespace_devs.c | 5 +----=0A 1 file changed, 1 =
insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/nvdimm/namespace_dev=
s.c b/drivers/nvdimm/namespace_devs.c=0Aindex 6ed3b4ed27dd..2d40d1692264 10=
0644=0A--- a/drivers/nvdimm/namespace_devs.c=0A+++ b/drivers/nvdimm/namespa=
ce_devs.c=0A@@ -2249,12 +2249,9 @@ struct device *create_namespace_blk(stru=
ct nd_region *nd_region,=0A 	if (!nsblk->uuid)=0A 		goto blk_err;=0A 	memcp=
y(name, nd_label->name, NSLABEL_NAME_LEN);=0A-	if (name[0]) {=0A+	if (name[=
0])=0A 		nsblk->alt_name =3D kmemdup(name, NSLABEL_NAME_LEN,=0A 				GFP_KER=
NEL);=0A-		if (!nsblk->alt_name)=0A-			goto blk_err;=0A-	}=0A 	res =3D nsbl=
k_add_resource(nd_region, ndd, nsblk,=0A 			__le64_to_cpu(nd_label->dpa));=
=0A 	if (!res)=0A-- =0A2.30.2=0A=0A=0AFrom af35e07add1f1f74f3d7f998c4f9855d=
dae03421 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:03 +0100=0ASubject: [PATCH 67/73=
] Revert "niu: fix missing checks of niu_pci_eeprom_read"=0A=0AThis reverts=
 commit ba87bdade1366d650e00ff7b1524dba8bd4d71f5.=0A=0ACommits from @umn.ed=
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
=0A---=0A drivers/net/ethernet/sun/niu.c | 10 ++--------=0A 1 file changed,=
 2 insertions(+), 8 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/sun=
/niu.c b/drivers/net/ethernet/sun/niu.c=0Aindex 32ab44d00790..c819d395b566 =
100644=0A--- a/drivers/net/ethernet/sun/niu.c=0A+++ b/drivers/net/ethernet/=
sun/niu.c=0A@@ -8117,8 +8117,6 @@ static int niu_pci_vpd_scan_props(struct =
niu *np, u32 start, u32 end)=0A 		start +=3D 3;=0A =0A 		prop_len =3D niu_p=
ci_eeprom_read(np, start + 4);=0A-		if (prop_len < 0)=0A-			return prop_len=
;=0A 		err =3D niu_pci_vpd_get_propname(np, start + 5, namebuf, 64);=0A 		i=
f (err < 0)=0A 			return err;=0A@@ -8163,12 +8161,8 @@ static int niu_pci_v=
pd_scan_props(struct niu *np, u32 start, u32 end)=0A 			netif_printk(np, pr=
obe, KERN_DEBUG, np->dev,=0A 				     "VPD_SCAN: Reading in property [%s] l=
en[%d]\n",=0A 				     namebuf, prop_len);=0A-			for (i =3D 0; i < prop_len=
; i++) {=0A-				err =3D niu_pci_eeprom_read(np, off + i);=0A-				if (err >=
=3D 0)=0A-					*prop_buf =3D err;=0A-				++prop_buf;=0A-			}=0A+			for (i =
=3D 0; i < prop_len; i++)=0A+				*prop_buf++ =3D niu_pci_eeprom_read(np, of=
f + i);=0A 		}=0A =0A 		start +=3D len;=0A-- =0A2.30.2=0A=0A=0AFrom 4841e18=
89148f296519f3b858d603a8676564536 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:04 +010=
0=0ASubject: [PATCH 68/73] Revert "net: socket: fix a missing-check bug"=0A=
=0AThis reverts commit 7d58456872c4a65926541e8aa983056bd91f8ed6.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A net/socket.c | 11 +++--------=0A 1 file changed, 3 i=
nsertions(+), 8 deletions(-)=0A=0Adiff --git a/net/socket.c b/net/socket.c=
=0Aindex c74cfe1ee169..6a6440d4ad21 100644=0A--- a/net/socket.c=0A+++ b/net=
/socket.c=0A@@ -2871,14 +2871,9 @@ static int ethtool_ioctl(struct net *net=
, struct compat_ifreq __user *ifr32)=0A 		    copy_in_user(&rxnfc->fs.ring_=
cookie,=0A 				 &compat_rxnfc->fs.ring_cookie,=0A 				 (void __user *)(&rxn=
fc->fs.location + 1) -=0A-				 (void __user *)&rxnfc->fs.ring_cookie))=0A-	=
		return -EFAULT;=0A-		if (ethcmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-			if (p=
ut_user(rule_cnt, &rxnfc->rule_cnt))=0A-				return -EFAULT;=0A-		} else if =
(copy_in_user(&rxnfc->rule_cnt,=0A-					&compat_rxnfc->rule_cnt,=0A-					si=
zeof(rxnfc->rule_cnt)))=0A+				 (void __user *)&rxnfc->fs.ring_cookie) ||=
=0A+		    copy_in_user(&rxnfc->rule_cnt, &compat_rxnfc->rule_cnt,=0A+				 s=
izeof(rxnfc->rule_cnt)))=0A 			return -EFAULT;=0A 	}=0A =0A-- =0A2.30.2=0A=
=0A=0AFrom 09614d6327fa2b68a34ce51fa569e5d7fdb7b67f Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:35:04 +0100=0ASubject: [PATCH 69/73] Revert "net: netxen: fix a mis=
sing check and an=0A uninitialized use"=0A=0AThis reverts commit 29b7def0ff=
b1c9acc043a5ca4b9fb212c2d0687d.=0A=0ACommits from @umn.edu addresses have b=
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
t/ethernet/qlogic/netxen/netxen_nic_init.c | 3 +--=0A 1 file changed, 1 ins=
ertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/net=
xen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.=
c=0Aindex 4b444351ab7d..3dd973475125 100644=0A--- a/drivers/net/ethernet/ql=
ogic/netxen/netxen_nic_init.c=0A+++ b/drivers/net/ethernet/qlogic/netxen/ne=
txen_nic_init.c=0A@@ -1125,8 +1125,7 @@ netxen_validate_firmware(struct net=
xen_adapter *adapter)=0A 		return -EINVAL;=0A 	}=0A 	val =3D nx_get_bios_ve=
rsion(adapter);=0A-	if (netxen_rom_fast_read(adapter, NX_BIOS_VERSION_OFFSE=
T, (int *)&bios))=0A-		return -EIO;=0A+	netxen_rom_fast_read(adapter, NX_BI=
OS_VERSION_OFFSET, (int *)&bios);=0A 	if ((__force u32)val !=3D bios) {=0A =
		dev_err(&pdev->dev, "%s: firmware bios is incompatible\n",=0A 				fw_name=
[fw_type]);=0A-- =0A2.30.2=0A=0A=0AFrom 7732f5c25adbb909d165bf09a778742851c=
5d654 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gm=
ail.com>=0ADate: Wed, 21 Apr 2021 20:35:04 +0100=0ASubject: [PATCH 70/73] R=
evert "media: isif: fix a NULL pointer dereference=0A bug"=0A=0AThis revert=
s commit 5e63d5649ae3d47b9a2185544fbe71ed66882be4.=0A=0ACommits from @umn.e=
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
=0A---=0A drivers/media/platform/davinci/isif.c | 3 +--=0A 1 file changed, =
1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/media/platform/dav=
inci/isif.c b/drivers/media/platform/davinci/isif.c=0Aindex 12065ad1ac45..c=
f282a679f1f 100644=0A--- a/drivers/media/platform/davinci/isif.c=0A+++ b/dr=
ivers/media/platform/davinci/isif.c=0A@@ -1093,8 +1093,7 @@ static int isif=
_probe(struct platform_device *pdev)=0A =0A 	while (i >=3D 0) {=0A 		res =
=3D platform_get_resource(pdev, IORESOURCE_MEM, i);=0A-		if (res)=0A-			rel=
ease_mem_region(res->start, resource_size(res));=0A+		release_mem_region(re=
s->start, resource_size(res));=0A 		i--;=0A 	}=0A 	vpfe_unregister_ccdc_dev=
ice(&isif_hw_dev);=0A-- =0A2.30.2=0A=0A=0AFrom 796e86e5070b7a3570628d85f711=
57285d6280a2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:05 +0100=0ASubject: [PATCH 7=
1/73] Revert "scsi: 3w-xxxx: fix a missing-check bug"=0A=0AThis reverts com=
mit ca588ff3e7d649690bb80a1cca4ed3dd591d9cd7.=0A=0ACommits from @umn.edu ad=
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
--=0A drivers/scsi/3w-xxxx.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=
=0Adiff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c=0Aindex 961=
ea6f7def8..8177cf7071b7 100644=0A--- a/drivers/scsi/3w-xxxx.c=0A+++ b/drive=
rs/scsi/3w-xxxx.c=0A@@ -1033,9 +1033,6 @@ static int tw_chrdev_open(struct =
inode *inode, struct file *file)=0A =0A 	dprintk(KERN_WARNING "3w-xxxx: tw_=
ioctl_open()\n");=0A =0A-	if (!capable(CAP_SYS_ADMIN))=0A-		return -EACCES;=
=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=3D tw_devic=
e_extension_count)=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom 848c127=
b05f640bd62c7204aaf38812b26a54b6b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:05 +010=
0=0ASubject: [PATCH 72/73] Revert "scsi: 3w-9xxx: fix a missing-check bug"=
=0A=0AThis reverts commit a0e86c016bb4e8c59e57a99bf53762ad313593c5.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/scsi/3w-9xxx.c | 5 -----=0A 1 file change=
d, 5 deletions(-)=0A=0Adiff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3=
w-9xxx.c=0Aindex dd342207095a..0a3571a589b3 100644=0A--- a/drivers/scsi/3w-=
9xxx.c=0A+++ b/drivers/scsi/3w-9xxx.c=0A@@ -886,11 +886,6 @@ static int twa=
_chrdev_open(struct inode *inode, struct file *file)=0A 	unsigned int minor=
_number;=0A 	int retval =3D TW_IOCTL_ERROR_OS_ENODEV;=0A =0A-	if (!capable(=
CAP_SYS_ADMIN)) {=0A-		retval =3D -EACCES;=0A-		goto out;=0A-	}=0A-=0A 	min=
or_number =3D iminor(inode);=0A 	if (minor_number >=3D twa_device_extension=
_count)=0A 		goto out;=0A-- =0A2.30.2=0A=0A=0AFrom 3b79ab8f12650be3bddbec74=
506ac692d6aebaa3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:35:05 +0100=0ASubject: [PAT=
CH 73/73] Revert "dm ioctl: harden copy_params()'s=0A copy_from_user() from=
 malicious users"=0A=0AThis reverts commit a0a4629065e4cc4a79b91d9942afb556=
5d86b462.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/md/dm-ioctl.c | 18 +++++=
+++++++------=0A 1 file changed, 12 insertions(+), 6 deletions(-)=0A=0Adiff=
 --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c=0Aindex 2f020401d5ba=
=2E.86d3f92bf6e2 100644=0A--- a/drivers/md/dm-ioctl.c=0A+++ b/drivers/md/dm=
-ioctl.c=0A@@ -1720,7 +1720,8 @@ static void free_params(struct dm_ioctl *p=
aram, size_t param_size, int param_fla=0A }=0A =0A static int copy_params(s=
truct dm_ioctl __user *user, struct dm_ioctl *param_kernel,=0A-		       int=
 ioctl_flags, struct dm_ioctl **param, int *param_flags)=0A+		       int io=
ctl_flags,=0A+		       struct dm_ioctl **param, int *param_flags)=0A {=0A 	=
struct dm_ioctl *dmi;=0A 	int secure_data;=0A@@ -1761,13 +1762,18 @@ static=
 int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern=
=0A =0A 	*param_flags |=3D DM_PARAMS_MALLOC;=0A =0A-	/* Copy from param_ker=
nel (which was already copied from user) */=0A-	memcpy(dmi, param_kernel, m=
inimum_data_size);=0A-=0A-	if (copy_from_user(&dmi->data, (char __user *)us=
er + minimum_data_size,=0A-			   param_kernel->data_size - minimum_data_siz=
e))=0A+	if (copy_from_user(dmi, user, param_kernel->data_size))=0A 		goto b=
ad;=0A+=0A data_copied:=0A+	/*=0A+	 * Abort if something changed the ioctl =
data while it was being copied.=0A+	 */=0A+	if (dmi->data_size !=3D param_k=
ernel->data_size) {=0A+		DMERR("rejecting ioctl: data size modified while p=
rocessing parameters");=0A+		goto bad;=0A+	}=0A+=0A 	/* Wipe the user buffe=
r so we do not return it to userspace */=0A 	if (secure_data && clear_user(=
user, param_kernel->data_size))=0A 		goto bad;=0A-- =0A2.30.2=0A=0A
--Ukhr4BwvfVs0ZLKZ--
