Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B883679BC
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhDVGSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhDVGSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:18:42 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABC2C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:18:07 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x7so43496039wrw.10
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1cA10aqbcWImfWmU6Nv3qcriao6ST/U8PsGb1ij1Aw4=;
        b=bCbf2B8t1OeD+tRJThrm3jfpMisKx1BWA5PG1vjHkxQDTkkV7utzorWO/6sVy08Cdd
         F6NATc4mDVUPdmJO1Z2KhZkygY9/neWIZI1PArAGOdjBDmQcrAat4mWdNFnQm1Q1yjxI
         AizpT7s1zBOJuA/DJ7yXabhecs4nCEfp3/VUPNM/V0AI6wlENcKxR5nFRZuO9NH6GIes
         +L7cPe5vBkPo6TDb+FPTv1dWV6VvV78rd31onzh/JFG0Pc4V754B8vOunHuabSDn/2Ze
         IADaE8z5HjWbbD6A6tYhwbJEu09VAifphRxIpFFKUnbJrkBpfonqwiKluVOXg8b36xRI
         B23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1cA10aqbcWImfWmU6Nv3qcriao6ST/U8PsGb1ij1Aw4=;
        b=rReA6g4GoSkQcYQVaS74XcUkRG2LIBmwgO+Ys98jdVSYxvooji8wt354re0oz+WyTi
         nCkgrK99TP62VYYDnuORMeJFkQqFRPuRcntYFZMBNNg9ulGqAvgCXv3SZUhpYgg6BaNp
         Og/3+jDybAQJ52syueSZjZnzDEm6cknDr/dpH97sy6zOv7OcicbaLBRzMmQoozVTtH25
         7IXVfteqZQ4KGvey8I7fYAuEdRyLiBm1OH7Y6DzCtEayeCAkCT0ybI11Mh8bSUwCP275
         3igKVHvbkWIlTd4DbN+PBukYUpAkr+WnFBKgzl7W2hijr70fdHZYifpahp7Ld/9FdRW8
         AGkA==
X-Gm-Message-State: AOAM533fxTM2+cU2zsyS86RLLYNvG10AIMBqvkNoiY4FijSQ9Yh8Nb9G
        qdcd8OEopMTlhjxFIp5rTbcOfpuhBIiwfw==
X-Google-Smtp-Source: ABdhPJwSC9MMqkMRZT+iFwzYjsVbkiVrq2K06aCotVxWcr5FCMvn1qIPhUCuWDzjYjjtLRsGBnbpyg==
X-Received: by 2002:adf:fc01:: with SMTP id i1mr1934743wrr.374.1619072285525;
        Wed, 21 Apr 2021 23:18:05 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id 61sm2011271wrm.52.2021.04.21.23.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:18:03 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:18:01 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v5.11.y
Message-ID: <YIEVGXEoeizx6O1p@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aryy8RvuTcrxwVZG"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aryy8RvuTcrxwVZG
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

--aryy8RvuTcrxwVZG
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v5.11.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom fdddc0d9f3231babd5596bfbe7dde18e2c5da12e Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 19:41:46 +0100=0ASubject: [PATCH 001/165] Revert "media: sti: Fix refere=
nce count leaks"=0A=0AThis reverts commit 6f4432bae9f2d12fc1815b5e26cc07e69=
bcad0df.=0A=0ACommits from @umn.edu addresses have been found to be submitt=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/sti/hva/h=
va-hw.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/=
media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c=
=0Aindex 43f279e2a6a3..8533d3bc6d5c 100644=0A--- a/drivers/media/platform/s=
ti/hva/hva-hw.c=0A+++ b/drivers/media/platform/sti/hva/hva-hw.c=0A@@ -272,7=
 +272,6 @@ static unsigned long int hva_hw_get_ip_version(struct hva_dev *h=
va)=0A =0A 	if (pm_runtime_get_sync(dev) < 0) {=0A 		dev_err(dev, "%s     f=
ailed to get pm_runtime\n", HVA_PREFIX);=0A-		pm_runtime_put_noidle(dev);=
=0A 		mutex_unlock(&hva->protect_mutex);=0A 		return -EFAULT;=0A 	}=0A@@ -5=
54,7 +553,6 @@ void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *=
s)=0A =0A 	if (pm_runtime_get_sync(dev) < 0) {=0A 		seq_puts(s, "Cannot wak=
e up IP\n");=0A-		pm_runtime_put_noidle(dev);=0A 		mutex_unlock(&hva->prote=
ct_mutex);=0A 		return;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 48afa7d142fe71298=
2fd00f584c9f759179c5cff Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:46 +0100=0ASubjec=
t: [PATCH 002/165] Revert "media: rockchip/rga: Fix a reference count=0A le=
ak."=0A=0AThis reverts commit 884d638e0853c4b5f01eb6d048fc3b6239012404.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/media/platform/rockchip/rga/rga-buf=
=2Ec | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/drivers/media=
/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-=
buf.c=0Aindex bf9a75b75083..36b821ccc1db 100644=0A--- a/drivers/media/platf=
orm/rockchip/rga/rga-buf.c=0A+++ b/drivers/media/platform/rockchip/rga/rga-=
buf.c=0A@@ -81,7 +81,6 @@ static int rga_buf_start_streaming(struct vb2_que=
ue *q, unsigned int count)=0A =0A 	ret =3D pm_runtime_get_sync(rga->dev);=
=0A 	if (ret < 0) {=0A-		pm_runtime_put_noidle(rga->dev);=0A 		rga_buf_retu=
rn_buffers(q, VB2_BUF_STATE_QUEUED);=0A 		return ret;=0A 	}=0A-- =0A2.30.2=
=0A=0A=0AFrom 27c98d18dd5d5aaf433771b9c6d1eef122c8a4ff Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:41:47 +0100=0ASubject: [PATCH 003/165] Revert "media: rcar-vin: =
Fix a reference count leak."=0A=0AThis reverts commit 410822037cc909c4bef84=
5a71e9cac92b75591d2.=0A=0ACommits from @umn.edu addresses have been found t=
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
m/rcar-vin/rcar-v4l2.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deleti=
ons(-)=0A=0Adiff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/driv=
ers/media/platform/rcar-vin/rcar-v4l2.c=0Aindex e6ea2b7991b8..82b42a3f61a8 =
100644=0A--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c=0A+++ b/drivers/=
media/platform/rcar-vin/rcar-v4l2.c=0A@@ -871,10 +871,8 @@ static int rvin_=
open(struct file *file)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(vi=
n->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(vin->dev);=0A+	if (r=
et < 0)=0A 		return ret;=0A-	}=0A =0A 	ret =3D mutex_lock_interruptible(&vi=
n->lock);=0A 	if (ret)=0A-- =0A2.30.2=0A=0A=0AFrom e54420232d73b715992ad13f=
45b9b15090134134 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:47 +0100=0ASubject: [PAT=
CH 004/165] Revert "media: rcar-vin: Fix a reference count leak."=0A=0AThis=
 reverts commit aaffa0126a111d65f4028c503c76192d4cc93277.=0A=0ACommits from=
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
l.com>=0A---=0A drivers/media/platform/rcar-vin/rcar-dma.c | 4 +---=0A 1 fi=
le changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/=
platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c=
=0Aindex 48280ddb15b9..94034e5daf96 100644=0A--- a/drivers/media/platform/r=
car-vin/rcar-dma.c=0A+++ b/drivers/media/platform/rcar-vin/rcar-dma.c=0A@@ =
-1454,10 +1454,8 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 c=
hsel)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(vin->dev);=0A-	if (r=
et < 0) {=0A-		pm_runtime_put_noidle(vin->dev);=0A+	if (ret < 0)=0A 		retur=
n ret;=0A-	}=0A =0A 	/* Make register writes take effect immediately. */=0A=
 	vnmc =3D rvin_read(vin, VNMC_REG);=0A-- =0A2.30.2=0A=0A=0AFrom 226e75b14e=
3595227a6eeb98e4c120f9fec3299a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:47 +0100=
=0ASubject: [PATCH 005/165] Revert "firmware: Fix a reference count leak."=
=0A=0AThis reverts commit fe3c60684377d5ad9b0569b87ed3e26e12c8173b.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/firmware/qemu_fw_cfg.c | 7 +++----=0A 1 f=
ile changed, 3 insertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/firm=
ware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c=0Aindex 0078260fbabe..8=
fa660dde0f6 100644=0A--- a/drivers/firmware/qemu_fw_cfg.c=0A+++ b/drivers/f=
irmware/qemu_fw_cfg.c=0A@@ -608,10 +608,8 @@ static int fw_cfg_register_fil=
e(const struct fw_cfg_file *f)=0A 	/* register entry under "/sys/firmware/q=
emu_fw_cfg/by_key/" */=0A 	err =3D kobject_init_and_add(&entry->kobj, &fw_c=
fg_sysfs_entry_ktype,=0A 				   fw_cfg_sel_ko, "%d", entry->select);=0A-	if=
 (err) {=0A-		kobject_put(&entry->kobj);=0A-		return err;=0A-	}=0A+	if (err=
)=0A+		goto err_register;=0A =0A 	/* add raw binary content access */=0A 	e=
rr =3D sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);=0A@@ -6=
27,6 +625,7 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)=
=0A =0A err_add_raw:=0A 	kobject_del(&entry->kobj);=0A+err_register:=0A 	kf=
ree(entry);=0A 	return err;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom a01d462f1feaf4=
60e821384b64eecd04f4d3dfa2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:48 +0100=0ASub=
ject: [PATCH 006/165] Revert "drm/nouveau: fix reference count leak in=0A n=
ouveau_debugfs_strap_peek"=0A=0AThis reverts commit 8f29432417b11039ef960ab=
18987c7d61b2b5396.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau=
/nouveau_debugfs.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(=
-)=0A=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gp=
u/drm/nouveau/nouveau_debugfs.c=0Aindex c2bc05eb2e54..c8da70e06006 100644=
=0A--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c=0A+++ b/drivers/gpu/drm/=
nouveau/nouveau_debugfs.c=0A@@ -54,10 +54,8 @@ nouveau_debugfs_strap_peek(s=
truct seq_file *m, void *data)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_=
sync(drm->dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime=
_put_autosuspend(drm->dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		=
return ret;=0A-	}=0A =0A 	seq_printf(m, "0x%08x\n",=0A 		   nvif_rd32(&drm-=
>client.device.object, 0x101000));=0A-- =0A2.30.2=0A=0A=0AFrom 5510445d6564=
99c9a139c4d67cdc470e0aa3e911 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:48 +0100=0AS=
ubject: [PATCH 007/165] Revert "drm/nouveau: fix reference count leak in=0A=
 nv50_disp_atomic_commit"=0A=0AThis reverts commit a2cdf39536b0d21fb06113f5=
e16692513d7bcb9c.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/=
dispnv50/disp.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=
=0A=0Adiff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/dr=
m/nouveau/dispnv50/disp.c=0Aindex f601e91241ac..da5b4c2b6c26 100644=0A--- a=
/drivers/gpu/drm/nouveau/dispnv50/disp.c=0A+++ b/drivers/gpu/drm/nouveau/di=
spnv50/disp.c=0A@@ -2290,10 +2290,8 @@ nv50_disp_atomic_commit(struct drm_d=
evice *dev,=0A 	int ret, i;=0A =0A 	ret =3D pm_runtime_get_sync(dev->dev);=
=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev=
->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A =
	ret =3D drm_atomic_helper_setup_commit(state, nonblock);=0A 	if (ret)=0A--=
 =0A2.30.2=0A=0A=0AFrom 82ac64b6d4af7effcb8955d709e0407397ec3c77 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:41:49 +0100=0ASubject: [PATCH 008/165] Revert "drm/nou=
veau: fix multiple instances of=0A reference count leaks"=0A=0AThis reverts=
 commit 659fb5f154c3434c90a34586f3b7aa1c39cf6062.=0A=0ACommits from @umn.ed=
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
=0A---=0A drivers/gpu/drm/nouveau/nouveau_drm.c | 8 ++------=0A drivers/gpu=
/drm/nouveau/nouveau_gem.c | 4 +---=0A 2 files changed, 3 insertions(+), 9 =
deletions(-)=0A=0Adiff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/driv=
ers/gpu/drm/nouveau/nouveau_drm.c=0Aindex d141a5f004af..ed5959b57bba 100644=
=0A--- a/drivers/gpu/drm/nouveau/nouveau_drm.c=0A+++ b/drivers/gpu/drm/nouv=
eau/nouveau_drm.c=0A@@ -1068,10 +1068,8 @@ nouveau_drm_open(struct drm_devi=
ce *dev, struct drm_file *fpriv)=0A =0A 	/* need to bring up power immediat=
ely if opening device */=0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if =
(ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=
=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	get_ta=
sk_comm(tmpname, current);=0A 	snprintf(name, sizeof(name), "%s[%d]", tmpna=
me, pid_nr(fpriv->pid));=0A@@ -1153,10 +1151,8 @@ nouveau_drm_ioctl(struct =
file *file, unsigned int cmd, unsigned long arg)=0A 	long ret;=0A =0A 	ret =
=3D pm_runtime_get_sync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=
=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EA=
CCES)=0A 		return ret;=0A-	}=0A =0A 	switch (_IOC_NR(cmd) - DRM_COMMAND_BAS=
E) {=0A 	case DRM_NOUVEAU_NVIF:=0Adiff --git a/drivers/gpu/drm/nouveau/nouv=
eau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c=0Aindex c88cbb85f101..195=
b570ee8f2 100644=0A--- a/drivers/gpu/drm/nouveau/nouveau_gem.c=0A+++ b/driv=
ers/gpu/drm/nouveau/nouveau_gem.c=0A@@ -48,10 +48,8 @@ nouveau_gem_object_d=
el(struct drm_gem_object *gem)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_=
sync(dev);=0A-	if (WARN_ON(ret < 0 && ret !=3D -EACCES)) {=0A-		pm_runtime_=
put_autosuspend(dev);=0A+	if (WARN_ON(ret < 0 && ret !=3D -EACCES))=0A 		re=
turn;=0A-	}=0A =0A 	if (gem->import_attach)=0A 		drm_prime_gem_destroy(gem,=
 nvbo->bo.sg);=0A-- =0A2.30.2=0A=0A=0AFrom 9392c0d0adcc202a3859aa1e6625bf5a=
5fa9254c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:49 +0100=0ASubject: [PATCH 009/1=
65] Revert "drm/nouveau/drm/noveau: fix reference count=0A leak in nouveau_=
fbcon_open"=0A=0AThis reverts commit bfad51c7633325b5d4b32444efe04329d53297=
b2.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/nouveau/nouveau_fbco=
n.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --=
git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nou=
veau_fbcon.c=0Aindex 24ec5339efb4..737f78927656 100644=0A--- a/drivers/gpu/=
drm/nouveau/nouveau_fbcon.c=0A+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c=
=0A@@ -189,10 +189,8 @@ nouveau_fbcon_open(struct fb_info *info, int user)=
=0A 	struct nouveau_fbdev *fbcon =3D info->par;=0A 	struct nouveau_drm *drm=
 =3D nouveau_drm(fbcon->helper.dev);=0A 	int ret =3D pm_runtime_get_sync(dr=
m->dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put(dr=
m->dev->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=
=0A 	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 70ce88a21e27a097d475a50=
1ff7539cea9c73cac Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:50 +0100=0ASubject: [PA=
TCH 010/165] Revert "PCI: Fix pci_create_slot() reference count=0A leak"=0A=
=0AThis reverts commit 8a94644b440eef5a7b9c104ac8aa7a7f413e35e5.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/pci/slot.c | 6 ++----=0A 1 file changed, 2 i=
nsertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/pci/slot.c b/drivers=
/pci/slot.c=0Aindex d627dd9179b4..c190e09af356 100644=0A--- a/drivers/pci/s=
lot.c=0A+++ b/drivers/pci/slot.c=0A@@ -268,7 +268,6 @@ struct pci_slot *pci=
_create_slot(struct pci_bus *parent, int slot_nr,=0A 	slot_name =3D make_sl=
ot_name(name);=0A 	if (!slot_name) {=0A 		err =3D -ENOMEM;=0A-		kfree(slot)=
;=0A 		goto err;=0A 	}=0A =0A@@ -277,10 +276,8 @@ struct pci_slot *pci_crea=
te_slot(struct pci_bus *parent, int slot_nr,=0A =0A 	err =3D kobject_init_a=
nd_add(&slot->kobj, &pci_slot_ktype, NULL,=0A 				   "%s", slot_name);=0A-	=
if (err) {=0A-		kobject_put(&slot->kobj);=0A+	if (err)=0A 		goto err;=0A-	}=
=0A =0A 	down_read(&pci_bus_sem);=0A 	list_for_each_entry(dev, &parent->dev=
ices, bus_list)=0A@@ -296,6 +293,7 @@ struct pci_slot *pci_create_slot(stru=
ct pci_bus *parent, int slot_nr,=0A 	mutex_unlock(&pci_slot_mutex);=0A 	ret=
urn slot;=0A err:=0A+	kfree(slot);=0A 	slot =3D ERR_PTR(err);=0A 	goto out;=
=0A }=0A-- =0A2.30.2=0A=0A=0AFrom c6d41956263e6f33f82405ad6d60a250b56309c2 =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 19:41:50 +0100=0ASubject: [PATCH 011/165] Rever=
t "omapfb: fix multiple reference count leaks=0A due to pm_runtime_get_sync=
"=0A=0AThis reverts commit 78c2ce9bde70be5be7e3615a2ae7024ed8173087.=0A=0AC=
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
herjee@gmail.com>=0A---=0A drivers/video/fbdev/omap2/omapfb/dss/dispc.c | 7=
 ++-----=0A drivers/video/fbdev/omap2/omapfb/dss/dsi.c   | 7 ++-----=0A dri=
vers/video/fbdev/omap2/omapfb/dss/dss.c   | 7 ++-----=0A drivers/video/fbde=
v/omap2/omapfb/dss/hdmi4.c | 5 ++---=0A drivers/video/fbdev/omap2/omapfb/ds=
s/hdmi5.c | 5 ++---=0A drivers/video/fbdev/omap2/omapfb/dss/venc.c  | 7 ++-=
----=0A 6 files changed, 12 insertions(+), 26 deletions(-)=0A=0Adiff --git =
a/drivers/video/fbdev/omap2/omapfb/dss/dispc.c b/drivers/video/fbdev/omap2/=
omapfb/dss/dispc.c=0Aindex b2d6e6df2161..285d33ce1e11 100644=0A--- a/driver=
s/video/fbdev/omap2/omapfb/dss/dispc.c=0A+++ b/drivers/video/fbdev/omap2/om=
apfb/dss/dispc.c=0A@@ -520,11 +520,8 @@ int dispc_runtime_get(void)=0A 	DSS=
DBG("dispc_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&dispc.pdev->=
dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dispc.pdev->dev);=
=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? =
r : 0;=0A }=0A EXPORT_SYMBOL(dispc_runtime_get);=0A =0Adiff --git a/drivers=
/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/=
dsi.c=0Aindex 6f9c25fec994..d620376216e1 100644=0A--- a/drivers/video/fbdev=
/omap2/omapfb/dss/dsi.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c=
=0A@@ -1137,11 +1137,8 @@ static int dsi_runtime_get(struct platform_device=
 *dsidev)=0A 	DSSDBG("dsi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_syn=
c(&dsi->pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&dsi=
->pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	re=
turn r < 0 ? r : 0;=0A }=0A =0A static void dsi_runtime_put(struct platform=
_device *dsidev)=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/dss.c =
b/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0Aindex a6b1c1598040..bfc5c4c5=
a26a 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/dss.c=0A+++ b/driv=
ers/video/fbdev/omap2/omapfb/dss/dss.c=0A@@ -768,11 +768,8 @@ int dss_runti=
me_get(void)=0A 	DSSDBG("dss_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_=
sync(&dss.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&d=
ss.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=0A+	WARN_ON(r < 0);=0A+	r=
eturn r < 0 ? r : 0;=0A }=0A =0A void dss_runtime_put(void)=0Adiff --git a/=
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c b/drivers/video/fbdev/omap2/om=
apfb/dss/hdmi4.c=0Aindex 496b43bdad21..32d658a2474f 100644=0A--- a/drivers/=
video/fbdev/omap2/omapfb/dss/hdmi4.c=0A+++ b/drivers/video/fbdev/omap2/omap=
fb/dss/hdmi4.c=0A@@ -39,10 +39,9 @@ static int hdmi_runtime_get(void)=0A 	D=
SSDBG("hdmi_runtime_get\n");=0A =0A 	r =3D pm_runtime_get_sync(&hdmi.pdev->=
dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sync(&hdmi.pdev->dev);=
=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	}=0A =0A 	return 0;=
=0A }=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c b/drivers=
/video/fbdev/omap2/omapfb/dss/hdmi5.c=0Aindex e3d441ade241..d14d339f7fdf 10=
0644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c=0A+++ b/drivers/v=
ideo/fbdev/omap2/omapfb/dss/hdmi5.c=0A@@ -43,10 +43,9 @@ static int hdmi_ru=
ntime_get(void)=0A 	DSSDBG("hdmi_runtime_get\n");=0A =0A 	r =3D pm_runtime_=
get_sync(&hdmi.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-		pm_runtime_put_sy=
nc(&hdmi.pdev->dev);=0A+	WARN_ON(r < 0);=0A+	if (r < 0)=0A 		return r;=0A-	=
}=0A =0A 	return 0;=0A }=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/ds=
s/venc.c b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0Aindex 905d642ff9ed=
=2E.b9e722542afb 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/venc.c=
=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0A@@ -348,11 +348,8 @@=
 static int venc_runtime_get(void)=0A 	DSSDBG("venc_runtime_get\n");=0A =0A=
 	r =3D pm_runtime_get_sync(&venc.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-=
		pm_runtime_put_sync(&venc.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=
=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A static void venc=
_runtime_put(void)=0A-- =0A2.30.2=0A=0A=0AFrom 16510819d9f47ac8155e0b1724e4=
495d773725a8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:51 +0100=0ASubject: [PATCH 0=
12/165] Revert "media: exynos4-is: Fix several reference=0A count leaks due=
 to pm_runtime_get_sync"=0A=0AThis reverts commit 7ef64ceea0008c17e94a8a2c6=
0c5d6d46f481996.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/ex=
ynos4-is/fimc-isp.c  | 4 +---=0A drivers/media/platform/exynos4-is/fimc-lit=
e.c | 2 +-=0A 2 files changed, 2 insertions(+), 4 deletions(-)=0A=0Adiff --=
git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform=
/exynos4-is/fimc-isp.c=0Aindex a77c49b18511..cde0d254ec1c 100644=0A--- a/dr=
ivers/media/platform/exynos4-is/fimc-isp.c=0A+++ b/drivers/media/platform/e=
xynos4-is/fimc-isp.c=0A@@ -305,10 +305,8 @@ static int fimc_isp_subdev_s_po=
wer(struct v4l2_subdev *sd, int on)=0A =0A 	if (on) {=0A 		ret =3D pm_runti=
me_get_sync(&is->pdev->dev);=0A-		if (ret < 0) {=0A-			pm_runtime_put(&is->=
pdev->dev);=0A+		if (ret < 0)=0A 			return ret;=0A-		}=0A 		set_bit(IS_ST_P=
WR_ON, &is->state);=0A =0A 		ret =3D fimc_is_start_firmware(is);=0Adiff --g=
it a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform=
/exynos4-is/fimc-lite.c=0Aindex fe20af3a7178..1576f273761b 100644=0A--- a/d=
rivers/media/platform/exynos4-is/fimc-lite.c=0A+++ b/drivers/media/platform=
/exynos4-is/fimc-lite.c=0A@@ -471,7 +471,7 @@ static int fimc_lite_open(str=
uct file *file)=0A 	set_bit(ST_FLITE_IN_USE, &fimc->state);=0A 	ret =3D pm_=
runtime_get_sync(&fimc->pdev->dev);=0A 	if (ret < 0)=0A-		goto err_pm;=0A+	=
	goto unlock;=0A =0A 	ret =3D v4l2_fh_open(file);=0A 	if (ret < 0)=0A-- =0A=
2.30.2=0A=0A=0AFrom 6f25051e91ba9e1f25e014bd82e7f8626496c21f Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 19:41:51 +0100=0ASubject: [PATCH 013/165] Revert "platform/ch=
rome: cros_ec_ishtp: Fix a=0A double-unlock issue"=0A=0AThis reverts commit=
 aaa3cbbac326c95308e315f1ab964a3369c4d07d.=0A=0ACommits from @umn.edu addre=
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
=0A drivers/platform/chrome/cros_ec_ishtp.c | 4 +---=0A 1 file changed, 1 i=
nsertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/platform/chrome/cros_=
ec_ishtp.c b/drivers/platform/chrome/cros_ec_ishtp.c=0Aindex 81364029af36..=
ed794a7ddba9 100644=0A--- a/drivers/platform/chrome/cros_ec_ishtp.c=0A+++ b=
/drivers/platform/chrome/cros_ec_ishtp.c=0A@@ -681,10 +681,8 @@ static int =
cros_ec_ishtp_probe(struct ishtp_cl_device *cl_device)=0A =0A 	/* Register =
croc_ec_dev mfd */=0A 	rv =3D cros_ec_dev_init(client_data);=0A-	if (rv) {=
=0A-		down_write(&init_lock);=0A+	if (rv)=0A 		goto end_cros_ec_dev_init_er=
ror;=0A-	}=0A =0A 	return 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 8a1d8b98b2a18f=
d8b03b26e2e395af7afb1d102a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:52 +0100=0ASub=
ject: [PATCH 014/165] Revert "usb: dwc3: pci: Fix reference count leak in=
=0A dwc3_pci_resume_work"=0A=0AThis reverts commit 2655971ad4b34e97dd921df1=
6bb0b08db9449df7.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/usb/dwc3/dwc3-pc=
i.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --=
git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c=0Aindex 598=
daed8086f..50e7b877c969 100644=0A--- a/drivers/usb/dwc3/dwc3-pci.c=0A+++ b/=
drivers/usb/dwc3/dwc3-pci.c=0A@@ -212,10 +212,8 @@ static void dwc3_pci_res=
ume_work(struct work_struct *work)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_=
get_sync(&dwc3->dev);=0A-	if (ret) {=0A-		pm_runtime_put_sync_autosuspend(&=
dwc3->dev);=0A+	if (ret)=0A 		return;=0A-	}=0A =0A 	pm_runtime_mark_last_bu=
sy(&dwc3->dev);=0A 	pm_runtime_put_sync_autosuspend(&dwc3->dev);=0A-- =0A2.=
30.2=0A=0A=0AFrom a62255a2398bd356fffec415069ec4be762e015a Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:41:52 +0100=0ASubject: [PATCH 015/165] Revert "ASoC: rockchi=
p: Fix a reference count leak."=0A=0AThis reverts commit f141a422159a199f4c=
8dedb7e0df55b3b2cf16cd.=0A=0ACommits from @umn.edu addresses have been foun=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/soc/rockch=
ip/rockchip_pdm.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-=
)=0A=0Adiff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/=
rockchip_pdm.c=0Aindex e5f732747f71..b7d0f442d235 100644=0A--- a/sound/soc/=
rockchip/rockchip_pdm.c=0A+++ b/sound/soc/rockchip/rockchip_pdm.c=0A@@ -590=
,10 +590,8 @@ static int rockchip_pdm_resume(struct device *dev)=0A 	int re=
t;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_run=
time_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	ret =3D regc=
ache_sync(pdm->regmap);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 354979efb8f5bfd6c3e=
f820e36e8e15a999c1385 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:53 +0100=0ASubject:=
 [PATCH 016/165] Revert "media: exynos4-is: Fix a reference count leak=0A d=
ue to pm_runtime_get_sync"=0A=0AThis reverts commit c47f7c779ef0458a58583f0=
0c9ed71b7f5a4d0a2.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/=
exynos4-is/media-dev.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deleti=
ons(-)=0A=0Adiff --git a/drivers/media/platform/exynos4-is/media-dev.c b/dr=
ivers/media/platform/exynos4-is/media-dev.c=0Aindex e636c33e847b..7d92793a8=
e74 100644=0A--- a/drivers/media/platform/exynos4-is/media-dev.c=0A+++ b/dr=
ivers/media/platform/exynos4-is/media-dev.c=0A@@ -509,10 +509,8 @@ static i=
nt fimc_md_register_sensor_entities(struct fimc_md *fmd)=0A 		return -ENXIO=
;=0A =0A 	ret =3D pm_runtime_get_sync(fmd->pmf);=0A-	if (ret < 0) {=0A-		pm=
_runtime_put(fmd->pmf);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	fmd=
->num_sensors =3D 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom ba58d2ab3d1b5b1d9efaad=
8d0501b79cce4d1e80 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:53 +0100=0ASubject: =
[PATCH 017/165] Revert "media: exynos4-is: Fix a reference count=0A leak"=
=0A=0AThis reverts commit 64157b2cb1940449e7df2670e85781c690266588.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/media/platform/exynos4-is/mipi-csis.c | 4=
 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/d=
rivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exyno=
s4-is/mipi-csis.c=0Aindex 1aac167abb17..540151bbf58f 100644=0A--- a/drivers=
/media/platform/exynos4-is/mipi-csis.c=0A+++ b/drivers/media/platform/exyno=
s4-is/mipi-csis.c=0A@@ -510,10 +510,8 @@ static int s5pcsis_s_stream(struct=
 v4l2_subdev *sd, int enable)=0A 	if (enable) {=0A 		s5pcsis_clear_counters=
(state);=0A 		ret =3D pm_runtime_get_sync(&state->pdev->dev);=0A-		if (ret =
&& ret !=3D 1) {=0A-			pm_runtime_put_noidle(&state->pdev->dev);=0A+		if (r=
et && ret !=3D 1)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	mutex_lock(&state-=
>lock);=0A-- =0A2.30.2=0A=0A=0AFrom 0f74bd9e04fb13a30d0e7d0a08aa8dde93948e9=
2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 19:41:54 +0100=0ASubject: [PATCH 018/165] Rev=
ert "media: ti-vpe: Fix a missing check and=0A reference count leak"=0A=0AT=
his reverts commit 7dae2aaaf432767ca7aa11fa84643a7c2600dbdd.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/media/platform/ti-vpe/vpe.c | 2 --=0A 1 file cha=
nged, 2 deletions(-)=0A=0Adiff --git a/drivers/media/platform/ti-vpe/vpe.c =
b/drivers/media/platform/ti-vpe/vpe.c=0Aindex 779dd74b82d0..346f8212791c 10=
0644=0A--- a/drivers/media/platform/ti-vpe/vpe.c=0A+++ b/drivers/media/plat=
form/ti-vpe/vpe.c=0A@@ -2475,8 +2475,6 @@ static int vpe_runtime_get(struct=
 platform_device *pdev)=0A =0A 	r =3D pm_runtime_get_sync(&pdev->dev);=0A 	=
WARN_ON(r < 0);=0A-	if (r)=0A-		pm_runtime_put_noidle(&pdev->dev);=0A 	retu=
rn r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 7fed00c6c7e8664bfd03=
279aefa31a0140ec887f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:54 +0100=0ASubject: =
[PATCH 019/165] Revert "media: stm32-dcmi: Fix a reference count=0A leak"=
=0A=0AThis reverts commit 88f50a05f907d96a27a9ce3cc9e8cbb91a6f0f22.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/media/platform/stm32/stm32-dcmi.c | 4 +++=
-=0A 1 file changed, 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/drive=
rs/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-d=
cmi.c=0Aindex b745f1342c2e..c46825fbffda 100644=0A--- a/drivers/media/platf=
orm/stm32/stm32-dcmi.c=0A+++ b/drivers/media/platform/stm32/stm32-dcmi.c=0A=
@@ -734,7 +734,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, u=
nsigned int count)=0A 	if (ret < 0) {=0A 		dev_err(dcmi->dev, "%s: Failed t=
o start streaming, cannot get sync (%d)\n",=0A 			__func__, ret);=0A-		goto=
 err_pm_put;=0A+		goto err_release_buffers;=0A 	}=0A =0A 	ret =3D media_pip=
eline_start(&dcmi->vdev->entity, &dcmi->pipeline);=0A@@ -855,6 +855,8 @@ st=
atic int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)=0A =
=0A err_pm_put:=0A 	pm_runtime_put(dcmi->dev);=0A+=0A+err_release_buffers:=
=0A 	spin_lock_irq(&dcmi->irqlock);=0A 	/*=0A 	 * Return all buffers to vb2=
 in QUEUED state.=0A-- =0A2.30.2=0A=0A=0AFrom 2166a300ff9f55925d680c404c32a=
71dddec7fca Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:55 +0100=0ASubject: [PATCH 02=
0/165] Revert "media: s5p-mfc: Fix a reference count leak"=0A=0AThis revert=
s commit 78741ce98c2e36188e2343434406b0e0bc50b0e7.=0A=0ACommits from @umn.e=
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
=0A---=0A drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 4 +---=0A 1 file ch=
anged, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/media/platf=
orm/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=0Ain=
dex 62d2320a7218..7d52431c2c83 100644=0A--- a/drivers/media/platform/s5p-mf=
c/s5p_mfc_pm.c=0A+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c=0A@@ -79=
,10 +79,8 @@ int s5p_mfc_power_on(void)=0A 	int i, ret =3D 0;=0A =0A 	ret =
=3D pm_runtime_get_sync(pm->device);=0A-	if (ret < 0) {=0A-		pm_runtime_put=
_noidle(pm->device);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	/* clo=
ck control */=0A 	for (i =3D 0; i < pm->num_clocks; i++) {=0A-- =0A2.30.2=
=0A=0A=0AFrom 2702d1bc3628805a48c8e191666c75540a3eab6e Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:41:55 +0100=0ASubject: [PATCH 021/165] Revert "media: platform: =
fcp: Fix a reference count=0A leak."=0A=0AThis reverts commit 63e36a381d92a=
9cded97e90d481ee22566557dd1.=0A=0ACommits from @umn.edu addresses have been=
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
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media=
/platform/rcar-fcp.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletion=
s(-)=0A=0Adiff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/pl=
atform/rcar-fcp.c=0Aindex 5c03318ae07b..13a84c7e3586 100644=0A--- a/drivers=
/media/platform/rcar-fcp.c=0A+++ b/drivers/media/platform/rcar-fcp.c=0A@@ -=
102,10 +102,8 @@ int rcar_fcp_enable(struct rcar_fcp_device *fcp)=0A 		retu=
rn 0;=0A =0A 	ret =3D pm_runtime_get_sync(fcp->dev);=0A-	if (ret < 0) {=0A-=
		pm_runtime_put_noidle(fcp->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=
=0A =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 670a37398bcc71516c963fc=
3c218b8c5cb7c320e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:55 +0100=0ASubject: [PA=
TCH 022/165] Revert "media: st-delta: Fix reference count leak in=0A delta_=
run_work"=0A=0AThis reverts commit 57cc666d36adc7b45e37ba4cd7bc4e44ec4c43d7=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/sti/delta/del=
ta-v4l2.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Ad=
iff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/p=
latform/sti/delta/delta-v4l2.c=0Aindex c691b3d81549..2503224eeee5 100644=0A=
--- a/drivers/media/platform/sti/delta/delta-v4l2.c=0A+++ b/drivers/media/p=
latform/sti/delta/delta-v4l2.c=0A@@ -954,10 +954,8 @@ static void delta_run=
_work(struct work_struct *work)=0A 	/* enable the hardware */=0A 	if (!dec-=
>pm) {=0A 		ret =3D delta_get_sync(ctx);=0A-		if (ret) {=0A-			delta_put_au=
tosuspend(ctx);=0A+		if (ret)=0A 			goto err;=0A-		}=0A 	}=0A =0A 	/* decod=
e this access unit */=0A-- =0A2.30.2=0A=0A=0AFrom c0f4d0e5ea43b06f1492f66a6=
6ad5958760d9503 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:56 +0100=0ASubject: [PATC=
H 023/165] Revert "ASoC: tegra: Fix reference count leaks."=0A=0AThis rever=
ts commit deca195383a6085be62cb453079e03e04d618d6e.=0A=0ACommits from @umn.=
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
m>=0A---=0A sound/soc/tegra/tegra30_ahub.c | 4 +---=0A sound/soc/tegra/tegr=
a30_i2s.c  | 4 +---=0A 2 files changed, 2 insertions(+), 6 deletions(-)=0A=
=0Adiff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ah=
ub.c=0Aindex 156e3b9d613c..635eacbd28d4 100644=0A--- a/sound/soc/tegra/tegr=
a30_ahub.c=0A+++ b/sound/soc/tegra/tegra30_ahub.c=0A@@ -643,10 +643,8 @@ st=
atic int tegra30_ahub_resume(struct device *dev)=0A 	int ret;=0A =0A 	ret =
=3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev);=
=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A 	ret =3D regcache_sync(ahub->re=
gmap_ahub);=0A 	ret |=3D regcache_sync(ahub->regmap_apbif);=0A 	pm_runtime_=
put(dev);=0Adiff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/te=
gra30_i2s.c=0Aindex db5a8587bfa4..d59882ec48f1 100644=0A--- a/sound/soc/teg=
ra/tegra30_i2s.c=0A+++ b/sound/soc/tegra/tegra30_i2s.c=0A@@ -567,10 +567,8 =
@@ static int tegra30_i2s_resume(struct device *dev)=0A 	int ret;=0A =0A 	r=
et =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put(dev=
);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A 	ret =3D regcache_sync(i2s->r=
egmap);=0A 	pm_runtime_put(dev);=0A =0A-- =0A2.30.2=0A=0A=0AFrom d92e1014ff=
5f2165d88d54864cd8bc36d7b7adc2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:56 +0100=
=0ASubject: [PATCH 024/165] Revert "iommu: Fix reference count leak in=0A i=
ommu_group_alloc."=0A=0AThis reverts commit 7cc31613734c4870ae32f5265d576ef=
296621343.=0A=0ACommits from @umn.edu addresses have been found to be submi=
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
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/iommu/iommu.c | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/io=
mmu/iommu.c b/drivers/iommu/iommu.c=0Aindex fd5f59373fc6..a15f8d956ce2 1006=
44=0A--- a/drivers/iommu/iommu.c=0A+++ b/drivers/iommu/iommu.c=0A@@ -596,7 =
+596,7 @@ struct iommu_group *iommu_group_alloc(void)=0A 				   NULL, "%d",=
 group->id);=0A 	if (ret) {=0A 		ida_simple_remove(&iommu_group_ida, group-=
>id);=0A-		kobject_put(&group->kobj);=0A+		kfree(group);=0A 		return ERR_PT=
R(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 00062c919cec536f2b98f52d9f1bb=
45d43090925 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:57 +0100=0ASubject: [PATCH 02=
5/165] Revert "ACPI: CPPC: Fix reference count leak in=0A acpi_cppc_process=
or_probe()"=0A=0AThis reverts commit 4d8be4bc94f74bb7d096e1c2e44457b530d5a1=
70.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/acpi/cppc_acpi.c | 1 -=0A 1 =
file changed, 1 deletion(-)=0A=0Adiff --git a/drivers/acpi/cppc_acpi.c b/dr=
ivers/acpi/cppc_acpi.c=0Aindex 75aaf94ae0a9..7397484c778f 100644=0A--- a/dr=
ivers/acpi/cppc_acpi.c=0A+++ b/drivers/acpi/cppc_acpi.c=0A@@ -830,7 +830,6 =
@@ int acpi_cppc_processor_probe(struct acpi_processor *pr)=0A 			"acpi_cpp=
c");=0A 	if (ret) {=0A 		per_cpu(cpc_desc_ptr, pr->id) =3D NULL;=0A-		kobje=
ct_put(&cpc_ptr->kobj);=0A 		goto out_free;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom ba8edf2bb69fc8079049311891d6a3e222860023 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:41:58 +0100=0ASubject: [PATCH 026/165] Revert "ACPI: sysfs: Fix refe=
rence count leak in=0A acpi_sysfs_add_hotplug_profile()"=0A=0AThis reverts =
commit 6e6c25283dff866308c87b49434c7dbad4774cc0.=0A=0ACommits from @umn.edu=
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
---=0A drivers/acpi/sysfs.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 d=
eletions(-)=0A=0Adiff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c=
=0Aindex a5cc4f3bb1e3..727c4c7c17ea 100644=0A--- a/drivers/acpi/sysfs.c=0A+=
++ b/drivers/acpi/sysfs.c=0A@@ -993,10 +993,8 @@ void acpi_sysfs_add_hotplu=
g_profile(struct acpi_hotplug_profile *hotplug,=0A =0A 	error =3D kobject_i=
nit_and_add(&hotplug->kobj,=0A 		&acpi_hotplug_profile_ktype, hotplug_kobj,=
 "%s", name);=0A-	if (error) {=0A-		kobject_put(&hotplug->kobj);=0A+	if (er=
ror)=0A 		goto err_out;=0A-	}=0A =0A 	kobject_uevent(&hotplug->kobj, KOBJ_A=
DD);=0A 	return;=0A-- =0A2.30.2=0A=0A=0AFrom bdf8677f71e96b2ef5f84c2032f9fc=
4b1b388a9f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:41:58 +0100=0ASubject: [PATCH 027=
/165] Revert "ASoC: fix incomplete error-handling in=0A img_i2s_in_probe."=
=0A=0AThis reverts commit 25bf943e4e7b47282bd86ae7d39e039217ebb007.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A sound/soc/img/img-i2s-in.c | 1 -=0A 1 file change=
d, 1 deletion(-)=0A=0Adiff --git a/sound/soc/img/img-i2s-in.c b/sound/soc/i=
mg/img-i2s-in.c=0Aindex 0843235d73c9..3de95da52583 100644=0A--- a/sound/soc=
/img/img-i2s-in.c=0A+++ b/sound/soc/img/img-i2s-in.c=0A@@ -484,7 +484,6 @@ =
static int img_i2s_in_probe(struct platform_device *pdev)=0A 	if (IS_ERR(rs=
t)) {=0A 		if (PTR_ERR(rst) =3D=3D -EPROBE_DEFER) {=0A 			ret =3D -EPROBE_D=
EFER;=0A-			pm_runtime_put(&pdev->dev);=0A 			goto err_suspend;=0A 		}=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 443a72b5603adab0a51ad1bf2233bb52786aea08 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:41:59 +0100=0ASubject: [PATCH 028/165] Revert "ql=
cnic: fix missing release in=0A qlcnic_83xx_interrupt_test."=0A=0AThis reve=
rts commit 15c973858903009e995b2037683de29dfe968621.=0A=0ACommits from @umn=
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
om>=0A---=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 +---=
=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/driver=
s/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic=
/qlcnic/qlcnic_83xx_hw.c=0Aindex d8882d0b6b49..edefeeff60f4 100644=0A--- a/=
drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A+++ b/drivers/net/eth=
ernet/qlogic/qlcnic/qlcnic_83xx_hw.c=0A@@ -3649,7 +3649,7 @@ int qlcnic_83x=
x_interrupt_test(struct net_device *netdev)=0A 	ahw->diag_cnt =3D 0;=0A 	re=
t =3D qlcnic_alloc_mbx_args(&cmd, adapter, QLCNIC_CMD_INTRPT_TEST);=0A 	if =
(ret)=0A-		goto fail_mbx_args;=0A+		goto fail_diag_irq;=0A =0A 	if (adapter=
->flags & QLCNIC_MSIX_ENABLED)=0A 		intrpt_id =3D ahw->intr_tbl[0].id;=0A@@=
 -3679,8 +3679,6 @@ int qlcnic_83xx_interrupt_test(struct net_device *netde=
v)=0A =0A done:=0A 	qlcnic_free_mbx_args(&cmd);=0A-=0A-fail_mbx_args:=0A 	q=
lcnic_83xx_diag_free_res(netdev, drv_sds_rings);=0A =0A fail_diag_irq:=0A--=
 =0A2.30.2=0A=0A=0AFrom 6ec727087ae98a716037f0f2972f7922d29110f8 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:41:59 +0100=0ASubject: [PATCH 029/165] Revert "usb: ga=
dget: fix potential double-free in=0A m66592_probe."=0A=0AThis reverts comm=
it 44734a594196bf1d474212f38fe3a0d37a73278b.=0A=0ACommits from @umn.edu add=
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
=0A drivers/usb/gadget/udc/m66592-udc.c | 2 +-=0A 1 file changed, 1 inserti=
on(+), 1 deletion(-)=0A=0Adiff --git a/drivers/usb/gadget/udc/m66592-udc.c =
b/drivers/usb/gadget/udc/m66592-udc.c=0Aindex 931e6362a13d..75d16a8902e6 10=
0644=0A--- a/drivers/usb/gadget/udc/m66592-udc.c=0A+++ b/drivers/usb/gadget=
/udc/m66592-udc.c=0A@@ -1667,7 +1667,7 @@ static int m66592_probe(struct pl=
atform_device *pdev)=0A =0A err_add_udc:=0A 	m66592_free_request(&m66592->e=
p[0].ep, m66592->ep0_req);=0A-	m66592->ep0_req =3D NULL;=0A+=0A clean_up3:=
=0A 	if (m66592->pdata->on_chip) {=0A 		clk_disable(m66592->clk);=0A-- =0A2=
=2E30.2=0A=0A=0AFrom af9e47804895fdc419e01698b6bdce15bbfe0ea2 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 19:42:00 +0100=0ASubject: [PATCH 030/165] Revert "net/mlx4_c=
ore: fix a memory leak bug."=0A=0AThis reverts commit febfd9d3c7f74063e8e63=
0b15413ca91b567f963.=0A=0ACommits from @umn.edu addresses have been found t=
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
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/=
mellanox/mlx4/fw.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=
=0A=0Adiff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/et=
hernet/mellanox/mlx4/fw.c=0Aindex f6cfec81ccc3..380e027ba5df 100644=0A--- a=
/drivers/net/ethernet/mellanox/mlx4/fw.c=0A+++ b/drivers/net/ethernet/mella=
nox/mlx4/fw.c=0A@@ -2734,7 +2734,7 @@ void mlx4_opreq_action(struct work_st=
ruct *work)=0A 		if (err) {=0A 			mlx4_err(dev, "Failed to retrieve require=
d operation: %d\n",=0A 				 err);=0A-			goto out;=0A+			return;=0A 		}=0A 	=
	MLX4_GET(modifier, outbox, GET_OP_REQ_MODIFIER_OFFSET);=0A 		MLX4_GET(toke=
n, outbox, GET_OP_REQ_TOKEN_OFFSET);=0A-- =0A2.30.2=0A=0A=0AFrom b303486562=
b466b78a451568b17c1e538a8840ee Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:00 +0100=
=0ASubject: [PATCH 031/165] Revert "test_objagg: Fix potential memory leak =
in=0A error handling"=0A=0AThis reverts commit a6379f0ad6375a707e915518ecd5=
c2270afcd395.=0A=0ACommits from @umn.edu addresses have been found to be su=
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
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A lib/test_objagg.c | 4 ++--=
=0A 1 file changed, 2 insertions(+), 2 deletions(-)=0A=0Adiff --git a/lib/t=
est_objagg.c b/lib/test_objagg.c=0Aindex da137939a410..72c1abfa154d 100644=
=0A--- a/lib/test_objagg.c=0A+++ b/lib/test_objagg.c=0A@@ -979,10 +979,10 @=
@ static int test_hints_case(const struct hints_case *hints_case)=0A err_wo=
rld2_obj_get:=0A 	for (i--; i >=3D 0; i--)=0A 		world_obj_put(&world2, obja=
gg, hints_case->key_ids[i]);=0A-	i =3D hints_case->key_ids_count;=0A+	objag=
g_hints_put(hints);=0A 	objagg_destroy(objagg2);=0A+	i =3D hints_case->key_=
ids_count;=0A err_check_expect_hints_stats:=0A-	objagg_hints_put(hints);=0A=
 err_hints_get:=0A err_check_expect_stats:=0A err_world_obj_get:=0A-- =0A2.=
30.2=0A=0A=0AFrom 1e8f595bb483b02ebef155d9975e15aec61b3581 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:42:01 +0100=0ASubject: [PATCH 032/165] Revert "agp/intel: Fi=
x a memory leak on module=0A initialisation failure"=0A=0AThis reverts comm=
it b975abbd382fe442713a4c233549abb90e57c22b.=0A=0ACommits from @umn.edu add=
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
=0A drivers/char/agp/intel-gtt.c | 4 +---=0A 1 file changed, 1 insertion(+)=
, 3 deletions(-)=0A=0Adiff --git a/drivers/char/agp/intel-gtt.c b/drivers/c=
har/agp/intel-gtt.c=0Aindex 5bfdf222d5f9..4b34a5195c65 100644=0A--- a/drive=
rs/char/agp/intel-gtt.c=0A+++ b/drivers/char/agp/intel-gtt.c=0A@@ -304,10 +=
304,8 @@ static int intel_gtt_setup_scratch_page(void)=0A 	if (intel_privat=
e.needs_dmar) {=0A 		dma_addr =3D pci_map_page(intel_private.pcidev, page, =
0,=0A 				    PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);=0A-		if (pci_dma_mapping_e=
rror(intel_private.pcidev, dma_addr)) {=0A-			__free_page(page);=0A+		if (p=
ci_dma_mapping_error(intel_private.pcidev, dma_addr))=0A 			return -EINVAL;=
=0A-		}=0A =0A 		intel_private.scratch_page_dma =3D dma_addr;=0A 	} else=0A=
-- =0A2.30.2=0A=0A=0AFrom 737e1ab0fc4ddcf51f496d8b77bbc731ae0c8024 Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 19:42:01 +0100=0ASubject: [PATCH 033/165] Revert "clk: =
samsung: Remove redundant check in=0A samsung_cmu_register_one"=0A=0AThis r=
everts commit 8d7a577d04e8ce24b1b81ee44ec8cd1dda2a9cd9.=0A=0ACommits from @=
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
l.com>=0A---=0A drivers/clk/samsung/clk.c | 4 ++++=0A 1 file changed, 4 ins=
ertions(+)=0A=0Adiff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsun=
g/clk.c=0Aindex 1949ae7851b2..dad31308c071 100644=0A--- a/drivers/clk/samsu=
ng/clk.c=0A+++ b/drivers/clk/samsung/clk.c=0A@@ -356,6 +356,10 @@ struct sa=
msung_clk_provider * __init samsung_cmu_register_one(=0A 	}=0A =0A 	ctx =3D=
 samsung_clk_init(np, reg_base, cmu->nr_clk_ids);=0A+	if (!ctx) {=0A+		pani=
c("%s: unable to allocate ctx\n", __func__);=0A+		return ctx;=0A+	}=0A =0A =
	if (cmu->pll_clks)=0A 		samsung_clk_register_pll(ctx, cmu->pll_clks, cmu->=
nr_pll_clks,=0A-- =0A2.30.2=0A=0A=0AFrom 3b962ac1dd7a575df7ac1da00fda586a0d=
4eea04 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 19:42:02 +0100=0ASubject: [PATCH 034/165=
] Revert "ecryptfs: replace BUG_ON with error handling=0A code"=0A=0AThis r=
everts commit 2c2a7552dd6465e8fde6bc9cccf8d66ed1c1eb72.=0A=0ACommits from @=
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
l.com>=0A---=0A fs/ecryptfs/crypto.c | 6 ++----=0A 1 file changed, 2 insert=
ions(+), 4 deletions(-)=0A=0Adiff --git a/fs/ecryptfs/crypto.c b/fs/ecryptf=
s/crypto.c=0Aindex 0681540c48d9..adf0707263a1 100644=0A--- a/fs/ecryptfs/cr=
ypto.c=0A+++ b/fs/ecryptfs/crypto.c=0A@@ -296,10 +296,8 @@ static int crypt=
_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,=0A 	struct extent_cryp=
t_result ecr;=0A 	int rc =3D 0;=0A =0A-	if (!crypt_stat || !crypt_stat->tfm=
=0A-	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))=0A-		ret=
urn -EINVAL;=0A-=0A+	BUG_ON(!crypt_stat || !crypt_stat->tfm=0A+	       || !=
(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED));=0A 	if (unlikely(ecrypt=
fs_verbosity > 0)) {=0A 		ecryptfs_printk(KERN_DEBUG, "Key size [%zd]; key:=
\n",=0A 				crypt_stat->key_size);=0A-- =0A2.30.2=0A=0A=0AFrom 00a95bfec184=
ef901da05fa32ab02c5759ba9963 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:02 +0100=0AS=
ubject: [PATCH 035/165] Revert "net: sun: fix missing release regions in=0A=
 cas_init_one()."=0A=0AThis reverts commit 5a730153984dd13f82ffae93d7170d76=
eba204e9.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/sun/cassini=
=2Ec | 3 ++-=0A 1 file changed, 2 insertions(+), 1 deletion(-)=0A=0Adiff --=
git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini=
=2Ec=0Aindex 9ff894ba8d3e..d9cdf51c5a33 100644=0A--- a/drivers/net/ethernet=
/sun/cassini.c=0A+++ b/drivers/net/ethernet/sun/cassini.c=0A@@ -4956,7 +495=
6,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_devic=
e_id *ent)=0A 					  cas_cacheline_size)) {=0A 			dev_err(&pdev->dev, "Coul=
d not set PCI cache "=0A 			       "line size\n");=0A-			goto err_out_free_=
res;=0A+			goto err_write_cacheline;=0A 		}=0A 	}=0A #endif=0A@@ -5128,6 +5=
128,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_dev=
ice_id *ent)=0A err_out_free_res:=0A 	pci_release_regions(pdev);=0A =0A+err=
_write_cacheline:=0A 	/* Try to restore it in case the error occurred after=
 we=0A 	 * set it.=0A 	 */=0A-- =0A2.30.2=0A=0A=0AFrom 756ca3c4c46f8af48f31=
9d7655ba7ef5df1d63b1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:03 +0100=0ASubject: =
[PATCH 036/165] Revert "media: media/saa7146: fix incorrect assertion=0A in=
 saa7146_buffer_finish"=0A=0AThis reverts commit 639c0a5b0503fb57127fa89722=
08d43020a9bcf6.=0A=0ACommits from @umn.edu addresses have been found to be =
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
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/common/saa71=
46/saa7146_fops.c | 2 ++=0A 1 file changed, 2 insertions(+)=0A=0Adiff --git=
 a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa71=
46/saa7146_fops.c=0Aindex baf5772c52a9..c256146fd3b6 100644=0A--- a/drivers=
/media/common/saa7146/saa7146_fops.c=0A+++ b/drivers/media/common/saa7146/s=
aa7146_fops.c=0A@@ -95,6 +95,8 @@ void saa7146_buffer_finish(struct saa7146=
_dev *dev,=0A 	DEB_EE("dev:%p, dmaq:%p, state:%d\n", dev, q, state);=0A 	DE=
B_EE("q->curr:%p\n", q->curr);=0A =0A+	BUG_ON(!q->curr);=0A+=0A 	/* finish =
current buffer */=0A 	if (NULL =3D=3D q->curr) {=0A 		DEB_D("aiii. no curre=
nt buffer\n");=0A-- =0A2.30.2=0A=0A=0AFrom 219a5a65a53588e184f43d45651d9c3c=
8d9f8636 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:04 +0100=0ASubject: [PATCH 037/1=
65] Revert "fs: ocfs: remove unnecessary assertion in=0A dlm_migrate_lockre=
s"=0A=0AThis reverts commit 67e2d2eb542338145a2e0b2336c1cdabd2424fd3.=0A=0A=
Commits from @umn.edu addresses have been found to be submitted in "bad=0Af=
aith" to try to test the kernel community's ability to review "known=0Amali=
cious" changes.  The result of these submissions can be found in a=0Apaper =
published at the 42nd IEEE Symposium on Security and Privacy=0Aentitled, "O=
pen Source Insecurity: Stealthily Introducing=0AVulnerabilities via Hypocri=
te Commits" written by Qiushi Wu (University=0Aof Minnesota) and Kangjie Lu=
 (University of Minnesota).=0A=0ABecause of this, all submissions from this=
 group must be reverted from=0Athe kernel tree and will need to be re-revie=
wed again to determine if=0Athey actually are a valid fix.  Until that work=
 is complete, remove this=0Achange to ensure that no problems are being int=
roduced into the=0Acodebase.=0A=0ASigned-off-by: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0A---=0A fs/ocfs2/dlm/dlmmaster.c | 2 ++=0A 1 file chang=
ed, 2 insertions(+)=0A=0Adiff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/d=
lm/dlmmaster.c=0Aindex f105746063ed..f89dcf9b6217 100644=0A--- a/fs/ocfs2/d=
lm/dlmmaster.c=0A+++ b/fs/ocfs2/dlm/dlmmaster.c=0A@@ -2554,6 +2554,8 @@ sta=
tic int dlm_migrate_lockres(struct dlm_ctxt *dlm,=0A 	if (!dlm_grab(dlm))=
=0A 		return -EINVAL;=0A =0A+	BUG_ON(target =3D=3D O2NM_MAX_NODES);=0A+=0A =
	name =3D res->lockname.name;=0A 	namelen =3D res->lockname.len;=0A =0A-- =
=0A2.30.2=0A=0A=0AFrom 6d51577d652cd90c50662c22ac436c4b1b33e474 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:42:04 +0100=0ASubject: [PATCH 038/165] Revert "media: d=
avinci/vpfe_capture.c: Avoid BUG_ON=0A for register failure"=0A=0AThis reve=
rts commit b0e4cfae483fe1e3db71ab2d8509490df60e52c6.=0A=0ACommits from @umn=
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
om>=0A---=0A drivers/media/platform/davinci/vpfe_capture.c | 31 +++++++++--=
--------=0A 1 file changed, 15 insertions(+), 16 deletions(-)=0A=0Adiff --g=
it a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform=
/davinci/vpfe_capture.c=0Aindex f9f7dd17c57c..bcedaf4523e0 100644=0A--- a/d=
rivers/media/platform/davinci/vpfe_capture.c=0A+++ b/drivers/media/platform=
/davinci/vpfe_capture.c=0A@@ -168,22 +168,21 @@ int vpfe_register_ccdc_devi=
ce(const struct ccdc_hw_device *dev)=0A 	int ret =3D 0;=0A 	printk(KERN_NOT=
ICE "vpfe_register_ccdc_device: %s\n", dev->name);=0A =0A-	if (!dev->hw_ops=
=2Eopen ||=0A-	    !dev->hw_ops.enable ||=0A-	    !dev->hw_ops.set_hw_if_pa=
rams ||=0A-	    !dev->hw_ops.configure ||=0A-	    !dev->hw_ops.set_buftype =
||=0A-	    !dev->hw_ops.get_buftype ||=0A-	    !dev->hw_ops.enum_pix ||=0A-=
	    !dev->hw_ops.set_frame_format ||=0A-	    !dev->hw_ops.get_frame_format=
 ||=0A-	    !dev->hw_ops.get_pixel_format ||=0A-	    !dev->hw_ops.set_pixel=
_format ||=0A-	    !dev->hw_ops.set_image_window ||=0A-	    !dev->hw_ops.ge=
t_image_window ||=0A-	    !dev->hw_ops.get_line_length ||=0A-	    !dev->hw_=
ops.getfid)=0A-		return -EINVAL;=0A+	BUG_ON(!dev->hw_ops.open);=0A+	BUG_ON(=
!dev->hw_ops.enable);=0A+	BUG_ON(!dev->hw_ops.set_hw_if_params);=0A+	BUG_ON=
(!dev->hw_ops.configure);=0A+	BUG_ON(!dev->hw_ops.set_buftype);=0A+	BUG_ON(=
!dev->hw_ops.get_buftype);=0A+	BUG_ON(!dev->hw_ops.enum_pix);=0A+	BUG_ON(!d=
ev->hw_ops.set_frame_format);=0A+	BUG_ON(!dev->hw_ops.get_frame_format);=0A=
+	BUG_ON(!dev->hw_ops.get_pixel_format);=0A+	BUG_ON(!dev->hw_ops.set_pixel_=
format);=0A+	BUG_ON(!dev->hw_ops.set_image_window);=0A+	BUG_ON(!dev->hw_ops=
=2Eget_image_window);=0A+	BUG_ON(!dev->hw_ops.get_line_length);=0A+	BUG_ON(=
!dev->hw_ops.getfid);=0A =0A 	mutex_lock(&ccdc_lock);=0A 	if (!ccdc_cfg) {=
=0A-- =0A2.30.2=0A=0A=0AFrom 87be59a18b896da3f26fc10ab19204cc9c73be12 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:42:05 +0100=0ASubject: [PATCH 039/165] Revert "me=
dia: saa7146: Avoid using BUG_ON as an=0A assertion"=0A=0AThis reverts comm=
it 1ec4c6efe23154b4ab44c1a34dbc0eb121eb614a.=0A=0ACommits from @umn.edu add=
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
=0A drivers/media/common/saa7146/saa7146_video.c | 6 ++----=0A 1 file chang=
ed, 2 insertions(+), 4 deletions(-)=0A=0Adiff --git a/drivers/media/common/=
saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c=0Ain=
dex 7b8795eca589..d9d7d82ca451 100644=0A--- a/drivers/media/common/saa7146/=
saa7146_video.c=0A+++ b/drivers/media/common/saa7146/saa7146_video.c=0A@@ -=
345,8 +345,7 @@ static int video_begin(struct saa7146_fh *fh)=0A =0A 	fmt =
=3D saa7146_format_by_fourcc(dev, vv->video_fmt.pixelformat);=0A 	/* we nee=
d to have a valid format set here */=0A-	if (!fmt)=0A-		return -EINVAL;=0A+=
	BUG_ON(NULL =3D=3D fmt);=0A =0A 	if (0 !=3D (fmt->flags & FORMAT_IS_PLANAR=
)) {=0A 		resource =3D RESOURCE_DMA1_HPS|RESOURCE_DMA2_CLP|RESOURCE_DMA3_BR=
S;=0A@@ -399,8 +398,7 @@ static int video_end(struct saa7146_fh *fh, struct=
 file *file)=0A =0A 	fmt =3D saa7146_format_by_fourcc(dev, vv->video_fmt.pi=
xelformat);=0A 	/* we need to have a valid format set here */=0A-	if (!fmt)=
=0A-		return -EINVAL;=0A+	BUG_ON(NULL =3D=3D fmt);=0A =0A 	if (0 !=3D (fmt-=
>flags & FORMAT_IS_PLANAR)) {=0A 		resource =3D RESOURCE_DMA1_HPS|RESOURCE_=
DMA2_CLP|RESOURCE_DMA3_BRS;=0A-- =0A2.30.2=0A=0A=0AFrom 92bd656dd48ce6e6d33=
9837653cf9797f9a2d842 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:05 +0100=0ASubject:=
 [PATCH 040/165] Revert "media: cx231xx: replace BUG_ON with recovery=0A co=
de"=0A=0AThis reverts commit 93a24578de721006055b422c7772e0e417e1983c.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/media/usb/cx231xx/cx231xx-i2c.c | 3=
 +--=0A 1 file changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/dr=
ivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i=
2c.c=0Aindex c6659253c6fb..f33b6a077d57 100644=0A--- a/drivers/media/usb/cx=
231xx/cx231xx-i2c.c=0A+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c=0A@@ -5=
15,8 +515,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)=0A {=0A 	s=
truct cx231xx *dev =3D bus->dev;=0A =0A-	if (!dev->cx231xx_send_usb_command=
)=0A-		return -EINVAL;=0A+	BUG_ON(!dev->cx231xx_send_usb_command);=0A =0A 	=
bus->i2c_adap =3D cx231xx_adap_template;=0A 	bus->i2c_adap.dev.parent =3D d=
ev->dev;=0A-- =0A2.30.2=0A=0A=0AFrom df82b9d7e867ef38be47130a865de69e409c40=
2e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 19:42:06 +0100=0ASubject: [PATCH 041/165] =
Revert "ASoC: img-parallel-out: Fix a reference count=0A leak"=0A=0AThis re=
verts commit 6b9fbb073636906eee9fe4d4c05a4f445b9e2a23.=0A=0ACommits from @u=
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
om>=0A---=0A sound/soc/img/img-parallel-out.c | 4 +---=0A 1 file changed, 1=
 insertion(+), 3 deletions(-)=0A=0Adiff --git a/sound/soc/img/img-parallel-=
out.c b/sound/soc/img/img-parallel-out.c=0Aindex 4da49a42e854..5ddbe3a31c2e=
 100644=0A--- a/sound/soc/img/img-parallel-out.c=0A+++ b/sound/soc/img/img-=
parallel-out.c=0A@@ -163,10 +163,8 @@ static int img_prl_out_set_fmt(struct=
 snd_soc_dai *dai, unsigned int fmt)=0A 	}=0A =0A 	ret =3D pm_runtime_get_s=
ync(prl->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(prl->dev);=0A+=
	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	reg =3D img_prl_out_readl(prl,=
 IMG_PRL_OUT_CTL);=0A 	reg =3D (reg & ~IMG_PRL_OUT_CTL_EDGE_MASK) | control=
_set;=0A-- =0A2.30.2=0A=0A=0AFrom da2473266798d79f9d26a0824e2cedc92ed3c1fa =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 19:42:06 +0100=0ASubject: [PATCH 042/165] Rever=
t "staging: kpc2000: remove unnecessary=0A assertions in kpc_dma_transfer"=
=0A=0AThis reverts commit d7a336d67ab5443a0ef14b8335d139e855e8a682.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/staging/kpc2000/kpc_dma/fileops.c | 2 ++=
=0A 1 file changed, 2 insertions(+)=0A=0Adiff --git a/drivers/staging/kpc20=
00/kpc_dma/fileops.c b/drivers/staging/kpc2000/kpc_dma/fileops.c=0Aindex 10=
dcd6646b01..7fdad86044ca 100644=0A--- a/drivers/staging/kpc2000/kpc_dma/fil=
eops.c=0A+++ b/drivers/staging/kpc2000/kpc_dma/fileops.c=0A@@ -49,7 +49,9 @=
@ static int kpc_dma_transfer(struct dev_private_data *priv,=0A 	u64 dma_ad=
dr;=0A 	u64 user_ctl;=0A =0A+	BUG_ON(priv =3D=3D NULL);=0A 	ldev =3D priv->=
ldev;=0A+	BUG_ON(ldev =3D=3D NULL);=0A =0A 	acd =3D kzalloc(sizeof(*acd), G=
FP_KERNEL);=0A 	if (!acd) {=0A-- =0A2.30.2=0A=0A=0AFrom e251fd909e82cad00fb=
83ecdc3c01323c2148cd7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:07 +0100=0ASubject:=
 [PATCH 043/165] Revert "scsi: libfc: remove unnecessary assertion on=0A ep=
 variable"=0A=0AThis reverts commit 52b894393cecdc303990e834778d39b85d0553f=
c.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/target/tcm_fc/tfc_io.c | 1 +=
=0A 1 file changed, 1 insertion(+)=0A=0Adiff --git a/drivers/target/tcm_fc/=
tfc_io.c b/drivers/target/tcm_fc/tfc_io.c=0Aindex bbe2e29612fa..15d557a11f6=
3 100644=0A--- a/drivers/target/tcm_fc/tfc_io.c=0A+++ b/drivers/target/tcm_=
fc/tfc_io.c=0A@@ -220,6 +220,7 @@ void ft_recv_write_data(struct ft_cmd *cm=
d, struct fc_frame *fp)=0A 	ep =3D fc_seq_exch(seq);=0A 	lport =3D ep->lp;=
=0A 	if (cmd->was_ddp_setup) {=0A+		BUG_ON(!ep);=0A 		BUG_ON(!lport);=0A 		=
/*=0A 		 * Since DDP (Large Rx offload) was setup for this request,=0A-- =
=0A2.30.2=0A=0A=0AFrom f33e655a868ad1ae333ac204e5f7dc2a7f362441 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:42:08 +0100=0ASubject: [PATCH 044/165] Revert "hdlcdrv:=
 replace unnecessary assertion in=0A hdlcdrv_register"=0A=0AThis reverts co=
mmit a886ca6fcfffd337482352f383c1002c72786b17.=0A=0ACommits from @umn.edu a=
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
-=0A drivers/net/hamradio/hdlcdrv.c | 2 ++=0A 1 file changed, 2 insertions(=
+)=0A=0Adiff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/=
hdlcdrv.c=0Aindex 9e0058154ac3..d8df4e2b162e 100644=0A--- a/drivers/net/ham=
radio/hdlcdrv.c=0A+++ b/drivers/net/hamradio/hdlcdrv.c=0A@@ -687,6 +687,8 @=
@ struct net_device *hdlcdrv_register(const struct hdlcdrv_ops *ops,=0A 	st=
ruct hdlcdrv_state *s;=0A 	int err;=0A =0A+	BUG_ON(ops =3D=3D NULL);=0A+=0A=
 	if (privsize < sizeof(struct hdlcdrv_state))=0A 		privsize =3D sizeof(str=
uct hdlcdrv_state);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 8c886890493a65ff083788e=
0ed5b5592ef1b22d7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:08 +0100=0ASubject: [PA=
TCH 045/165] Revert "nfc: s3fwrn5: replace the assertion with a=0A WARN_ON"=
=0A=0AThis reverts commit 615f22f58029aa747b12768985e7f91cd053daa2.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/nfc/s3fwrn5/firmware.c | 5 +----=0A 1 fil=
e changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/nfc/s3f=
wrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c=0Aindex eb5d7a5beac7..f77f=
183c9bd0 100644=0A--- a/drivers/nfc/s3fwrn5/firmware.c=0A+++ b/drivers/nfc/=
s3fwrn5/firmware.c=0A@@ -492,10 +492,7 @@ int s3fwrn5_fw_recv_frame(struct =
nci_dev *ndev, struct sk_buff *skb)=0A 	struct s3fwrn5_info *info =3D nci_g=
et_drvdata(ndev);=0A 	struct s3fwrn5_fw_info *fw_info =3D &info->fw_info;=
=0A =0A-	if (WARN_ON(fw_info->rsp)) {=0A-		kfree_skb(skb);=0A-		return -EIN=
VAL;=0A-	}=0A+	BUG_ON(fw_info->rsp);=0A =0A 	fw_info->rsp =3D skb;=0A =0A--=
 =0A2.30.2=0A=0A=0AFrom 74718495ee38c49e201b56e3e296e15d262fb593 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:42:09 +0100=0ASubject: [PATCH 046/165] Revert "bpf: Re=
move unnecessary assertion on fp_old"=0A=0AThis reverts commit 5bf2fc1f9c88=
397b125d5ec5f65b1ed9300ba59d.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A kernel/bpf/c=
ore.c | 2 ++=0A 1 file changed, 2 insertions(+)=0A=0Adiff --git a/kernel/bp=
f/core.c b/kernel/bpf/core.c=0Aindex 1de87fcaeabd..978f7d996fab 100644=0A--=
- a/kernel/bpf/core.c=0A+++ b/kernel/bpf/core.c=0A@@ -223,6 +223,8 @@ struc=
t bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,=0A=
 	struct bpf_prog *fp;=0A 	u32 pages;=0A =0A+	BUG_ON(fp_old =3D=3D NULL);=
=0A+=0A 	size =3D round_up(size, PAGE_SIZE);=0A 	pages =3D size / PAGE_SIZE=
;=0A 	if (pages <=3D fp_old->pages)=0A-- =0A2.30.2=0A=0A=0AFrom 03e69471ebd=
9d499ac0cbd37ebe02950c0b8da3e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:09 +0100=0A=
Subject: [PATCH 047/165] Revert "efi/esrt: Fix reference count leak in=0A e=
sre_create_sysfs_entry."=0A=0AThis reverts commit 4ddf4739be6e375116c375f0a=
68bf3893ffcee21.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/firmware/efi/esrt=
=2Ec | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --gi=
t a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c=0Aindex d5915=
272141f..e3d692696583 100644=0A--- a/drivers/firmware/efi/esrt.c=0A+++ b/dr=
ivers/firmware/efi/esrt.c=0A@@ -181,7 +181,7 @@ static int esre_create_sysf=
s_entry(void *esre, int entry_num)=0A 		rc =3D kobject_init_and_add(&entry-=
>kobj, &esre1_ktype, NULL,=0A 					  "entry%d", entry_num);=0A 		if (rc) {=
=0A-			kobject_put(&entry->kobj);=0A+			kfree(entry);=0A 			return rc;=0A 	=
	}=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 3237838d25f054724cbff8b2f160d7a8fe4a14=
11 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 19:42:10 +0100=0ASubject: [PATCH 048/165] =
Revert "ASoC: img: Fix a reference count leak in=0A img_i2s_in_set_fmt"=0A=
=0AThis reverts commit c4c59b95b7f7d4cef5071b151be2dadb33f3287b.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A sound/soc/img/img-i2s-in.c | 4 +---=0A 1 file change=
d, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/sound/soc/img/img-i2s-i=
n.c b/sound/soc/img/img-i2s-in.c=0Aindex 3de95da52583..a495d1050d49 100644=
=0A--- a/sound/soc/img/img-i2s-in.c=0A+++ b/sound/soc/img/img-i2s-in.c=0A@@=
 -343,10 +343,8 @@ static int img_i2s_in_set_fmt(struct snd_soc_dai *dai, u=
nsigned int fmt)=0A 	chan_control_mask =3D IMG_I2S_IN_CH_CTL_CLK_TRANS_MASK=
;=0A =0A 	ret =3D pm_runtime_get_sync(i2s->dev);=0A-	if (ret < 0) {=0A-		pm=
_runtime_put_noidle(i2s->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =
=0A 	for (i =3D 0; i < i2s->active_channels; i++)=0A 		img_i2s_in_ch_disabl=
e(i2s, i);=0A-- =0A2.30.2=0A=0A=0AFrom 05332339e885eaecc653d267c1a7ca178202=
aabc Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 19:42:10 +0100=0ASubject: [PATCH 049/165] =
Revert "scsi: iscsi: Fix reference count leak in=0A iscsi_boot_create_kobj"=
=0A=0AThis reverts commit 0267ffce562c8bbf9b57ebe0e38445ad04972890.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/scsi/iscsi_boot_sysfs.c | 2 +-=0A 1 file =
changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/scsi/iscsi=
_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c=0Aindex a64abe38db2d..e4857=
b728033 100644=0A--- a/drivers/scsi/iscsi_boot_sysfs.c=0A+++ b/drivers/scsi=
/iscsi_boot_sysfs.c=0A@@ -352,7 +352,7 @@ iscsi_boot_create_kobj(struct isc=
si_boot_kset *boot_kset,=0A 	boot_kobj->kobj.kset =3D boot_kset->kset;=0A 	=
if (kobject_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,=0A 				 NULL,=
 name, index)) {=0A-		kobject_put(&boot_kobj->kobj);=0A+		kfree(boot_kobj);=
=0A 		return NULL;=0A 	}=0A 	boot_kobj->data =3D data;=0A-- =0A2.30.2=0A=0A=
=0AFrom b144f01792fa7b619dca2cc3c26dae66bc71429c Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:11 +0100=0ASubject: [PATCH 050/165] Revert "vfio/mdev: Fix refere=
nce count leak in=0A add_mdev_supported_type"=0A=0AThis reverts commit aa8b=
a13cae3134b8ef1c1b6879f66372531da738.=0A=0ACommits from @umn.edu addresses =
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
drivers/vfio/mdev/mdev_sysfs.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 =
deletion(-)=0A=0Adiff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio=
/mdev/mdev_sysfs.c=0Aindex 917fd84c1c6f..8ad14e5c02bf 100644=0A--- a/driver=
s/vfio/mdev/mdev_sysfs.c=0A+++ b/drivers/vfio/mdev/mdev_sysfs.c=0A@@ -110,7=
 +110,7 @@ static struct mdev_type *add_mdev_supported_type(struct mdev_par=
ent *parent,=0A 				   "%s-%s", dev_driver_string(parent->dev),=0A 				   g=
roup->name);=0A 	if (ret) {=0A-		kobject_put(&type->kobj);=0A+		kfree(type)=
;=0A 		return ERR_PTR(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 51be74f41=
0d6555af8346935b8a9502f7512729c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:11 +0100=
=0ASubject: [PATCH 051/165] Revert "RDMA/core: Fix several reference count=
=0A leaks."=0A=0AThis reverts commit 0b8e125e213204508e1b3c4bdfe69713280b7a=
bd.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/infiniband/core/sysfs.c | 10=
 +++++-----=0A 1 file changed, 5 insertions(+), 5 deletions(-)=0A=0Adiff --=
git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c=0Ai=
ndex b8abb30f80df..1ff580362a7c 100644=0A--- a/drivers/infiniband/core/sysf=
s.c=0A+++ b/drivers/infiniband/core/sysfs.c=0A@@ -1076,7 +1076,8 @@ static =
int add_port(struct ib_core_device *coredev, int port_num)=0A 				   corede=
v->ports_kobj,=0A 				   "%d", port_num);=0A 	if (ret) {=0A-		goto err_put;=
=0A+		kfree(p);=0A+		return ret;=0A 	}=0A =0A 	p->gid_attr_group =3D kzallo=
c(sizeof(*p->gid_attr_group), GFP_KERNEL);=0A@@ -1089,7 +1090,8 @@ static i=
nt add_port(struct ib_core_device *coredev, int port_num)=0A 	ret =3D kobje=
ct_init_and_add(&p->gid_attr_group->kobj, &gid_attr_type,=0A 				   &p->kob=
j, "gid_attrs");=0A 	if (ret) {=0A-		goto err_put_gid_attrs;=0A+		kfree(p->=
gid_attr_group);=0A+		goto err_put;=0A 	}=0A =0A 	if (device->ops.process_m=
ad && is_full_dev) {=0A@@ -1452,10 +1454,8 @@ int ib_port_register_module_s=
tat(struct ib_device *device, u8 port_num,=0A =0A 		ret =3D kobject_init_an=
d_add(kobj, ktype, &port->kobj, "%s",=0A 					   name);=0A-		if (ret) {=0A-=
			kobject_put(kobj);=0A+		if (ret)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	=
return 0;=0A-- =0A2.30.2=0A=0A=0AFrom 1b00454455019ea1c03f07cce5298b3c114b1=
261 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0ADate: Wed, 21 Apr 2021 19:42:12 +0100=0ASubject: [PATCH 052/165] R=
evert "cpuidle: Fix three reference count leaks"=0A=0AThis reverts commit c=
343bf1ba5efcbf2266a1fe3baefec9cc82f867f.=0A=0ACommits from @umn.edu address=
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
=0A drivers/cpuidle/sysfs.c | 6 +++---=0A 1 file changed, 3 insertions(+), =
3 deletions(-)=0A=0Adiff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/=
sysfs.c=0Aindex 53ec9585ccd4..23a219cedbdb 100644=0A--- a/drivers/cpuidle/s=
ysfs.c=0A+++ b/drivers/cpuidle/sysfs.c=0A@@ -487,7 +487,7 @@ static int cpu=
idle_add_state_sysfs(struct cpuidle_device *device)=0A 		ret =3D kobject_in=
it_and_add(&kobj->kobj, &ktype_state_cpuidle,=0A 					   &kdev->kobj, "stat=
e%d", i);=0A 		if (ret) {=0A-			kobject_put(&kobj->kobj);=0A+			kfree(kobj)=
;=0A 			goto error_state;=0A 		}=0A 		cpuidle_add_s2idle_attr_group(kobj);=
=0A@@ -618,7 +618,7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_d=
evice *dev)=0A 	ret =3D kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpu=
idle,=0A 				   &kdev->kobj, "driver");=0A 	if (ret) {=0A-		kobject_put(&kd=
rv->kobj);=0A+		kfree(kdrv);=0A 		return ret;=0A 	}=0A =0A@@ -712,7 +712,7 =
@@ int cpuidle_add_sysfs(struct cpuidle_device *dev)=0A 	error =3D kobject_=
init_and_add(&kdev->kobj, &ktype_cpuidle, &cpu_dev->kobj,=0A 				   "cpuidl=
e");=0A 	if (error) {=0A-		kobject_put(&kdev->kobj);=0A+		kfree(kdev);=0A 	=
	return error;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 277f21c52645734e9b3846=
2aae685dea26248ff6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:12 +0100=0ASubject: =
[PATCH 053/165] Revert "EDAC: Fix reference count leaks"=0A=0AThis reverts =
commit 17ed808ad243192fb923e4e653c1338d3ba06207.=0A=0ACommits from @umn.edu=
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
---=0A drivers/edac/edac_device_sysfs.c | 1 -=0A drivers/edac/edac_pci_sysf=
s.c    | 2 +-=0A 2 files changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff =
--git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c=
=0Aindex 5e7593753799..0e7ea3591b78 100644=0A--- a/drivers/edac/edac_device=
_sysfs.c=0A+++ b/drivers/edac/edac_device_sysfs.c=0A@@ -275,7 +275,6 @@ int=
 edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev=
)=0A =0A 	/* Error exit stack */=0A err_kobj_reg:=0A-	kobject_put(&edac_dev=
->kobj);=0A 	module_put(edac_dev->owner);=0A =0A err_out:=0Adiff --git a/dr=
ivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c=0Aindex 53042af=
7262e..72c9eb9fdffb 100644=0A--- a/drivers/edac/edac_pci_sysfs.c=0A+++ b/dr=
ivers/edac/edac_pci_sysfs.c=0A@@ -386,7 +386,7 @@ static int edac_pci_main_=
kobj_setup(void)=0A =0A 	/* Error unwind statck */=0A kobject_init_and_add_=
fail:=0A-	kobject_put(edac_pci_top_main_kobj);=0A+	kfree(edac_pci_top_main_=
kobj);=0A =0A kzalloc_fail:=0A 	module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=
=0A=0AFrom 31ec170f887c81fc0c4b57378653e5b53d911cf2 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:42:13 +0100=0ASubject: [PATCH 054/165] Revert "fore200e: Fix incorr=
ect checks of NULL=0A pointer dereference"=0A=0AThis reverts commit bbd20c9=
39c8aa3f27fa30e86691af250bf92973a.=0A=0ACommits from @umn.edu addresses hav=
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
/atm/fore200e.c | 25 +++++++------------------=0A 1 file changed, 7 inserti=
ons(+), 18 deletions(-)=0A=0Adiff --git a/drivers/atm/fore200e.c b/drivers/=
atm/fore200e.c=0Aindex 9a70bee84125..9498156808e4 100644=0A--- a/drivers/at=
m/fore200e.c=0A+++ b/drivers/atm/fore200e.c=0A@@ -1414,14 +1414,12 @@ fore2=
00e_open(struct atm_vcc *vcc)=0A static void=0A fore200e_close(struct atm_v=
cc* vcc)=0A {=0A+    struct fore200e*        fore200e =3D FORE200E_DEV(vcc-=
>dev);=0A     struct fore200e_vcc*    fore200e_vcc;=0A-    struct fore200e*=
        fore200e;=0A     struct fore200e_vc_map* vc_map;=0A     unsigned lo=
ng           flags;=0A =0A     ASSERT(vcc);=0A-    fore200e =3D FORE200E_DE=
V(vcc->dev);=0A-=0A     ASSERT((vcc->vpi >=3D 0) && (vcc->vpi < 1<<FORE200E=
_VPI_BITS));=0A     ASSERT((vcc->vci >=3D 0) && (vcc->vci < 1<<FORE200E_VCI=
_BITS));=0A =0A@@ -1466,10 +1464,10 @@ fore200e_close(struct atm_vcc* vcc)=
=0A static int=0A fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)=
=0A {=0A-    struct fore200e*        fore200e;=0A-    struct fore200e_vcc* =
   fore200e_vcc;=0A+    struct fore200e*        fore200e     =3D FORE200E_D=
EV(vcc->dev);=0A+    struct fore200e_vcc*    fore200e_vcc =3D FORE200E_VCC(=
vcc);=0A     struct fore200e_vc_map* vc_map;=0A-    struct host_txq*       =
 txq;=0A+    struct host_txq*        txq          =3D &fore200e->host_txq;=
=0A     struct host_txq_entry*  entry;=0A     struct tpd*             tpd;=
=0A     struct tpd_haddr        tpd_haddr;=0A@@ -1482,18 +1480,9 @@ fore200=
e_send(struct atm_vcc *vcc, struct sk_buff *skb)=0A     unsigned char*     =
     data;=0A     unsigned long           flags;=0A =0A-    if (!vcc)=0A-  =
      return -EINVAL;=0A-=0A-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-  =
  fore200e_vcc =3D FORE200E_VCC(vcc);=0A-=0A-    if (!fore200e)=0A-        =
return -EINVAL;=0A-=0A-    txq =3D &fore200e->host_txq;=0A-    if (!fore200=
e_vcc)=0A-        return -EINVAL;=0A+    ASSERT(vcc);=0A+    ASSERT(fore200=
e);=0A+    ASSERT(fore200e_vcc);=0A =0A     if (!test_bit(ATM_VF_READY, &vc=
c->flags)) {=0A 	DPRINTK(1, "VC %d.%d.%d not ready for tx\n", vcc->itf, vcc=
->vpi, vcc->vpi);=0A-- =0A2.30.2=0A=0A=0AFrom bb2d0b8836553c222413f4781aa60=
a0430d5b788 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:14 +0100=0ASubject: [PATCH 05=
5/165] Revert "rapidio: fix a NULL pointer dereference when=0A create_workq=
ueue() fails"=0A=0AThis reverts commit 23015b22e47c5409620b1726a677d69e5cd0=
32ba.=0A=0ACommits from @umn.edu addresses have been found to be submitted =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/rapidio/rio_cm.c | 8 -------=
-=0A 1 file changed, 8 deletions(-)=0A=0Adiff --git a/drivers/rapidio/rio_c=
m.c b/drivers/rapidio/rio_cm.c=0Aindex 50ec53d67a4c..e6c16f04f2b4 100644=0A=
--- a/drivers/rapidio/rio_cm.c=0A+++ b/drivers/rapidio/rio_cm.c=0A@@ -2138,=
14 +2138,6 @@ static int riocm_add_mport(struct device *dev,=0A 	mutex_init=
(&cm->rx_lock);=0A 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);=0A 	cm->rx_wq =
=3D create_workqueue(DRV_NAME "/rxq");=0A-	if (!cm->rx_wq) {=0A-		riocm_err=
or("failed to allocate IBMBOX_%d on %s",=0A-			    cmbox, mport->name);=0A-=
		rio_release_outb_mbox(mport, cmbox);=0A-		kfree(cm);=0A-		return -ENOMEM;=
=0A-	}=0A-=0A 	INIT_WORK(&cm->rx_work, rio_ibmsg_handler);=0A =0A 	cm->tx_s=
lot =3D 0;=0A-- =0A2.30.2=0A=0A=0AFrom 0f7543b525419b3177b20725bcb56966df2e=
cd63 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 19:42:14 +0100=0ASubject: [PATCH 056/165] =
Revert "ASoC: cs43130: fix a NULL pointer=0A dereference"=0A=0AThis reverts=
 commit a2be42f18d409213bb7e7a736e3ef6ba005115bb.=0A=0ACommits from @umn.ed=
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
=0A---=0A sound/soc/codecs/cs43130.c | 2 --=0A 1 file changed, 2 deletions(=
-)=0A=0Adiff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.=
c=0Aindex 7fb34422a2a4..bb46e993c353 100644=0A--- a/sound/soc/codecs/cs4313=
0.c=0A+++ b/sound/soc/codecs/cs43130.c=0A@@ -2319,8 +2319,6 @@ static int c=
s43130_probe(struct snd_soc_component *component)=0A 			return ret;=0A =0A =
		cs43130->wq =3D create_singlethread_workqueue("cs43130_hp");=0A-		if (!cs=
43130->wq)=0A-			return -ENOMEM;=0A 		INIT_WORK(&cs43130->work, cs43130_imp=
_meas);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 7e573a467736f03c9412b17af3b72=
48c2e7dcfce Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:15 +0100=0ASubject: [PATCH 05=
7/165] Revert "ASoC: rt5645: fix a NULL pointer dereference"=0A=0AThis reve=
rts commit 51dd97d1df5fb9ac58b9b358e63e67b530f6ae21.=0A=0ACommits from @umn=
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
om>=0A---=0A sound/soc/codecs/rt5645.c | 3 ---=0A 1 file changed, 3 deletio=
ns(-)=0A=0Adiff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645=
=2Ec=0Aindex 420003d062c7..ed4b59ba63f3 100644=0A--- a/sound/soc/codecs/rt5=
645.c=0A+++ b/sound/soc/codecs/rt5645.c=0A@@ -3419,9 +3419,6 @@ static int =
rt5645_probe(struct snd_soc_component *component)=0A 		RT5645_HWEQ_NUM, siz=
eof(struct rt5645_eq_param_s),=0A 		GFP_KERNEL);=0A =0A-	if (!rt5645->eq_pa=
ram)=0A-		return -ENOMEM;=0A-=0A 	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom 9ce7074aa45607282d3b1a6a6df1223ad9a0f82c Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:16 +0100=0ASubject: [PATCH 058/165] Revert "ALSA: usx2y: fix a do=
uble free bug"=0A=0AThis reverts commit cbb88db76a1536e02e93e5bd37ebbfbb6c4=
043a9.=0A=0ACommits from @umn.edu addresses have been found to be submitted=
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
e <sudipm.mukherjee@gmail.com>=0A---=0A sound/usb/usx2y/usbusx2y.c | 4 +++-=
=0A 1 file changed, 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/sound/=
usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c=0Aindex c54158146917..01b=
4de83bee8 100644=0A--- a/sound/usb/usx2y/usbusx2y.c=0A+++ b/sound/usb/usx2y=
/usbusx2y.c=0A@@ -280,8 +280,10 @@ int usX2Y_In04_init(struct usX2Ydev *usX=
2Y)=0A 	if (! (usX2Y->In04urb =3D usb_alloc_urb(0, GFP_KERNEL)))=0A 		retur=
n -ENOMEM;=0A =0A-	if (! (usX2Y->In04Buf =3D kmalloc(21, GFP_KERNEL)))=0A+	=
if (! (usX2Y->In04Buf =3D kmalloc(21, GFP_KERNEL))) {=0A+		usb_free_urb(usX=
2Y->In04urb);=0A 		return -ENOMEM;=0A+	}=0A 	 =0A 	init_waitqueue_head(&usX=
2Y->In04WaitQueue);=0A 	usb_fill_int_urb(usX2Y->In04urb, usX2Y->dev, usb_rc=
vintpipe(usX2Y->dev, 0x4),=0A-- =0A2.30.2=0A=0A=0AFrom f8b1edd5b6e4c7718a29=
08051c40890bbdcf81e3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:16 +0100=0ASubject: =
[PATCH 059/165] Revert "tracing: Fix a memory leak by early error=0A exit i=
n trace_pid_write()"=0A=0AThis reverts commit 91862cc7867bba4ee5c8fcf0ca2f1=
d30427b6129.=0A=0ACommits from @umn.edu addresses have been found to be sub=
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
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A kernel/trace/trace.c | 5 +-=
---=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/ker=
nel/trace/trace.c b/kernel/trace/trace.c=0Aindex c27b05aeb7d2..2f7d0c97a87c=
 100644=0A--- a/kernel/trace/trace.c=0A+++ b/kernel/trace/trace.c=0A@@ -688=
,10 +688,8 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,=0A =
	 * not modified.=0A 	 */=0A 	pid_list =3D kmalloc(sizeof(*pid_list), GFP_K=
ERNEL);=0A-	if (!pid_list) {=0A-		trace_parser_put(&parser);=0A+	if (!pid_l=
ist)=0A 		return -ENOMEM;=0A-	}=0A =0A 	pid_list->pid_max =3D READ_ONCE(pid=
_max);=0A =0A@@ -701,7 +699,6 @@ int trace_pid_write(struct trace_pid_list =
*filtered_pids,=0A =0A 	pid_list->pids =3D vzalloc((pid_list->pid_max + 7) =
>> 3);=0A 	if (!pid_list->pids) {=0A-		trace_parser_put(&parser);=0A 		kfre=
e(pid_list);=0A 		return -ENOMEM;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom ae37e00=
9a06b427db5402a38baac0dc96600079c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:17 +010=
0=0ASubject: [PATCH 060/165] Revert "rsi: Fix NULL pointer dereference in k=
malloc"=0A=0AThis reverts commit d5414c2355b20ea8201156d2e874265f1cb0d775.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/rsi/rsi_91x_mac=
80211.c | 30 +++++++++------------=0A 1 file changed, 12 insertions(+), 18 =
deletions(-)=0A=0Adiff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c =
b/drivers/net/wireless/rsi/rsi_91x_mac80211.c=0Aindex 16025300cddb..714d4d5=
3236c 100644=0A--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c=0A+++ b/dr=
ivers/net/wireless/rsi/rsi_91x_mac80211.c=0A@@ -188,27 +188,27 @@ bool rsi_=
is_cipher_wep(struct rsi_common *common)=0A  * @adapter: Pointer to the ada=
pter structure.=0A  * @band: Operating band to be set.=0A  *=0A- * Return: =
int - 0 on success, negative error on failure.=0A+ * Return: None.=0A  */=
=0A-static int rsi_register_rates_channels(struct rsi_hw *adapter, int band=
)=0A+static void rsi_register_rates_channels(struct rsi_hw *adapter, int ba=
nd)=0A {=0A 	struct ieee80211_supported_band *sbands =3D &adapter->sbands[b=
and];=0A 	void *channels =3D NULL;=0A =0A 	if (band =3D=3D NL80211_BAND_2GH=
Z) {=0A-		channels =3D kmemdup(rsi_2ghz_channels, sizeof(rsi_2ghz_channels)=
,=0A-				   GFP_KERNEL);=0A-		if (!channels)=0A-			return -ENOMEM;=0A+		cha=
nnels =3D kmalloc(sizeof(rsi_2ghz_channels), GFP_KERNEL);=0A+		memcpy(chann=
els,=0A+		       rsi_2ghz_channels,=0A+		       sizeof(rsi_2ghz_channels));=
=0A 		sbands->band =3D NL80211_BAND_2GHZ;=0A 		sbands->n_channels =3D ARRAY=
_SIZE(rsi_2ghz_channels);=0A 		sbands->bitrates =3D rsi_rates;=0A 		sbands-=
>n_bitrates =3D ARRAY_SIZE(rsi_rates);=0A 	} else {=0A-		channels =3D kmemd=
up(rsi_5ghz_channels, sizeof(rsi_5ghz_channels),=0A-				   GFP_KERNEL);=0A-=
		if (!channels)=0A-			return -ENOMEM;=0A+		channels =3D kmalloc(sizeof(rsi=
_5ghz_channels), GFP_KERNEL);=0A+		memcpy(channels,=0A+		       rsi_5ghz_ch=
annels,=0A+		       sizeof(rsi_5ghz_channels));=0A 		sbands->band =3D NL802=
11_BAND_5GHZ;=0A 		sbands->n_channels =3D ARRAY_SIZE(rsi_5ghz_channels);=0A=
 		sbands->bitrates =3D &rsi_rates[4];=0A@@ -227,7 +227,6 @@ static int rsi=
_register_rates_channels(struct rsi_hw *adapter, int band)=0A 	sbands->ht_c=
ap.mcs.rx_mask[0] =3D 0xff;=0A 	sbands->ht_cap.mcs.tx_params =3D IEEE80211_=
HT_MCS_TX_DEFINED;=0A 	/* sbands->ht_cap.mcs.rx_highest =3D 0x82; */=0A-	re=
turn 0;=0A }=0A =0A static int rsi_mac80211_hw_scan_start(struct ieee80211_=
hw *hw,=0A@@ -2067,16 +2066,11 @@ int rsi_mac80211_attach(struct rsi_common=
 *common)=0A 	wiphy->available_antennas_rx =3D 1;=0A 	wiphy->available_ante=
nnas_tx =3D 1;=0A =0A-	status =3D rsi_register_rates_channels(adapter, NL80=
211_BAND_2GHZ);=0A-	if (status)=0A-		return status;=0A+	rsi_register_rates_=
channels(adapter, NL80211_BAND_2GHZ);=0A 	wiphy->bands[NL80211_BAND_2GHZ] =
=3D=0A 		&adapter->sbands[NL80211_BAND_2GHZ];=0A 	if (common->num_supp_band=
s > 1) {=0A-		status =3D rsi_register_rates_channels(adapter,=0A-						    =
 NL80211_BAND_5GHZ);=0A-		if (status)=0A-			return status;=0A+		rsi_registe=
r_rates_channels(adapter, NL80211_BAND_5GHZ);=0A 		wiphy->bands[NL80211_BAN=
D_5GHZ] =3D=0A 			&adapter->sbands[NL80211_BAND_5GHZ];=0A 	}=0A-- =0A2.30.2=
=0A=0A=0AFrom 811a37dcbaf9529bc1bbcd3d75692d1b934763fa Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:18 +0100=0ASubject: [PATCH 061/165] Revert "net: cw1200: fix =
a NULL pointer dereference"=0A=0AThis reverts commit 0ed2a005347400500a39ea=
7c7318f1fea57fb3ca.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/s=
t/cw1200/main.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git=
 a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/m=
ain.c=0Aindex 326b1cc1d2bc..015dd202e758 100644=0A--- a/drivers/net/wireles=
s/st/cw1200/main.c=0A+++ b/drivers/net/wireless/st/cw1200/main.c=0A@@ -342,=
11 +342,6 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macad=
dr,=0A 	mutex_init(&priv->wsm_cmd_mux);=0A 	mutex_init(&priv->conf_mutex);=
=0A 	priv->workqueue =3D create_singlethread_workqueue("cw1200_wq");=0A-	if=
 (!priv->workqueue) {=0A-		ieee80211_free_hw(hw);=0A-		return NULL;=0A-	}=
=0A-=0A 	sema_init(&priv->scan.lock, 1);=0A 	INIT_WORK(&priv->scan.work, cw=
1200_scan_work);=0A 	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe=
_work);=0A-- =0A2.30.2=0A=0A=0AFrom 634fb0ff3b9d233d4f10e5ea404dbc263c15c53=
f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 19:42:18 +0100=0ASubject: [PATCH 062/165] Rev=
ert "net: ieee802154: fix missing checks for=0A regmap_update_bits"=0A=0ATh=
is reverts commit 22e8860cf8f777fbf6a83f2fb7127f682a8e9de4.=0A=0ACommits fr=
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
ail.com>=0A---=0A drivers/net/ieee802154/mcr20a.c | 6 ------=0A 1 file chan=
ged, 6 deletions(-)=0A=0Adiff --git a/drivers/net/ieee802154/mcr20a.c b/dri=
vers/net/ieee802154/mcr20a.c=0Aindex 8dc04e2590b1..2ce5b41983f8 100644=0A--=
- a/drivers/net/ieee802154/mcr20a.c=0A+++ b/drivers/net/ieee802154/mcr20a.c=
=0A@@ -524,8 +524,6 @@ mcr20a_start(struct ieee802154_hw *hw)=0A 	dev_dbg(p=
rintdev(lp), "no slotted operation\n");=0A 	ret =3D regmap_update_bits(lp->=
regmap_dar, DAR_PHY_CTRL1,=0A 				 DAR_PHY_CTRL1_SLOTTED, 0x0);=0A-	if (ret=
 < 0)=0A-		return ret;=0A =0A 	/* enable irq */=0A 	enable_irq(lp->spi->irq=
);=0A@@ -533,15 +531,11 @@ mcr20a_start(struct ieee802154_hw *hw)=0A 	/* Un=
mask SEQ interrupt */=0A 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PH=
Y_CTRL2,=0A 				 DAR_PHY_CTRL2_SEQMSK, 0x0);=0A-	if (ret < 0)=0A-		return r=
et;=0A =0A 	/* Start the RX sequence */=0A 	dev_dbg(printdev(lp), "start th=
e RX sequence\n");=0A 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PHY_C=
TRL1,=0A 				 DAR_PHY_CTRL1_XCVSEQ_MASK, MCR20A_XCVSEQ_RX);=0A-	if (ret < 0=
)=0A-		return ret;=0A =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 03b9f=
094582034d1c56972d35c8ebf837d81a2bf Mon Sep 17 00:00:00 2001=0AFrom: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:19 +0=
100=0ASubject: [PATCH 063/165] Revert "x86/PCI: Fix PCI IRQ routing table m=
emory=0A leak"=0A=0AThis reverts commit ea094d53580f40c2124cef3d072b73b2425=
e7bfd.=0A=0ACommits from @umn.edu addresses have been found to be submitted=
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
e <sudipm.mukherjee@gmail.com>=0A---=0A arch/x86/pci/irq.c | 10 ++--------=
=0A 1 file changed, 2 insertions(+), 8 deletions(-)=0A=0Adiff --git a/arch/=
x86/pci/irq.c b/arch/x86/pci/irq.c=0Aindex d3a73f9335e1..52e55108404e 10064=
4=0A--- a/arch/x86/pci/irq.c=0A+++ b/arch/x86/pci/irq.c=0A@@ -1119,8 +1119,=
6 @@ static const struct dmi_system_id pciirq_dmi_table[] __initconst =3D {=
=0A =0A void __init pcibios_irq_init(void)=0A {=0A-	struct irq_routing_tabl=
e *rtable =3D NULL;=0A-=0A 	DBG(KERN_DEBUG "PCI: IRQ init\n");=0A =0A 	if (=
raw_pci_ops =3D=3D NULL)=0A@@ -1131,10 +1129,8 @@ void __init pcibios_irq_i=
nit(void)=0A 	pirq_table =3D pirq_find_routing_table();=0A =0A #ifdef CONFI=
G_PCI_BIOS=0A-	if (!pirq_table && (pci_probe & PCI_BIOS_IRQ_SCAN)) {=0A+	if=
 (!pirq_table && (pci_probe & PCI_BIOS_IRQ_SCAN))=0A 		pirq_table =3D pcibi=
os_get_irq_routing_table();=0A-		rtable =3D pirq_table;=0A-	}=0A #endif=0A =
	if (pirq_table) {=0A 		pirq_peer_trick();=0A@@ -1149,10 +1145,8 @@ void __=
init pcibios_irq_init(void)=0A 		 * If we're using the I/O APIC, avoid usin=
g the PCI IRQ=0A 		 * routing table=0A 		 */=0A-		if (io_apic_assign_pci_ir=
qs) {=0A-			kfree(rtable);=0A+		if (io_apic_assign_pci_irqs)=0A 			pirq_tab=
le =3D NULL;=0A-		}=0A 	}=0A =0A 	x86_init.pci.fixup_irqs();=0A-- =0A2.30.2=
=0A=0A=0AFrom 5881bc3117d1f7f7f6c1e34e5763e9f6d03f113a Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:20 +0100=0ASubject: [PATCH 064/165] Revert "udf: fix an unini=
tialized read bug and remove=0A dead code"=0A=0AThis reverts commit 39416c5=
872db69859e867fa250b9cbb3f1e0d185.=0A=0ACommits from @umn.edu addresses hav=
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
igned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A fs/udf/=
namei.c | 15 +++++++++++++++=0A 1 file changed, 15 insertions(+)=0A=0Adiff =
--git a/fs/udf/namei.c b/fs/udf/namei.c=0Aindex e169d8fe35b5..4b14225683f6 =
100644=0A--- a/fs/udf/namei.c=0A+++ b/fs/udf/namei.c=0A@@ -304,6 +304,21 @@=
 static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,=
=0A 	if (dentry->d_name.len > UDF_NAME_LEN)=0A 		return ERR_PTR(-ENAMETOOLO=
NG);=0A =0A+#ifdef UDF_RECOVERY=0A+	/* temporary shorthand for specifying f=
iles by inode number */=0A+	if (!strncmp(dentry->d_name.name, ".B=3D", 3)) =
{=0A+		struct kernel_lb_addr lb =3D {=0A+			.logicalBlockNum =3D 0,=0A+			.=
partitionReferenceNum =3D=0A+				simple_strtoul(dentry->d_name.name + 3,=0A=
+						NULL, 0),=0A+		};=0A+		inode =3D udf_iget(dir->i_sb, lb);=0A+		if (I=
S_ERR(inode))=0A+			return inode;=0A+	} else=0A+#endif /* UDF_RECOVERY */=
=0A+=0A 	fi =3D udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);=0A 	if (=
IS_ERR(fi))=0A 		return ERR_CAST(fi);=0A-- =0A2.30.2=0A=0A=0AFrom ed464e06d=
87df6fb5e4d00052c79b57495239ba6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:20 +0100=
=0ASubject: [PATCH 065/165] Revert "mmc_spi: add a status check for=0A spi_=
sync_locked"=0A=0AThis reverts commit 611025983b7976df0183390a63a2166411d17=
7f1.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/mmc/host/mmc_spi.c | 4 ----=
=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/mmc/host/mmc_s=
pi.c b/drivers/mmc/host/mmc_spi.c=0Aindex 02f4fd26e76a..cc40b050e302 100644=
=0A--- a/drivers/mmc/host/mmc_spi.c=0A+++ b/drivers/mmc/host/mmc_spi.c=0A@@=
 -800,10 +800,6 @@ mmc_spi_readblock(struct mmc_spi_host *host, struct spi_=
transfer *t,=0A 	}=0A =0A 	status =3D spi_sync_locked(spi, &host->m);=0A-	i=
f (status < 0) {=0A-		dev_dbg(&spi->dev, "read error %d\n", status);=0A-		r=
eturn status;=0A-	}=0A =0A 	if (host->dma_dev) {=0A 		dma_sync_single_for_c=
pu(host->dma_dev,=0A-- =0A2.30.2=0A=0A=0AFrom 6c582e0c881cc173c01a8f6693c7f=
b06897f4085 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:21 +0100=0ASubject: [PATCH 06=
6/165] Revert "PCI: endpoint: Fix a potential NULL pointer=0A dereference"=
=0A=0AThis reverts commit 507b820009a457afa78202da337bcb56791fbb12.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/pci/endpoint/functions/pci-epf-test.c | 5=
 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/pci/endp=
oint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test=
=2Ec=0Aindex e4e51d884553..6d15e4c987f9 100644=0A--- a/drivers/pci/endpoint=
/functions/pci-epf-test.c=0A+++ b/drivers/pci/endpoint/functions/pci-epf-te=
st.c=0A@@ -910,11 +910,6 @@ static int __init pci_epf_test_init(void)=0A =
=0A 	kpcitest_workqueue =3D alloc_workqueue("kpcitest",=0A 					     WQ_MEM=
_RECLAIM | WQ_HIGHPRI, 0);=0A-	if (!kpcitest_workqueue) {=0A-		pr_err("Fail=
ed to allocate the kpcitest work queue\n");=0A-		return -ENOMEM;=0A-	}=0A-=
=0A 	ret =3D pci_epf_register_driver(&test_driver);=0A 	if (ret) {=0A 		pr_=
err("Failed to register pci epf test driver --> %d\n", ret);=0A-- =0A2.30.2=
=0A=0A=0AFrom 2e427c7a9b69c0f42f71fcaacc536c74524f6633 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:22 +0100=0ASubject: [PATCH 067/165] Revert "net/smc: fix a NU=
LL pointer dereference"=0A=0AThis reverts commit e183d4e414b64711baf7a04e21=
4b61969ca08dfa.=0A=0ACommits from @umn.edu addresses have been found to be =
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
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/smc/smc_ism.c | 5 ----=
-=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/net/smc/smc_ism.c b/n=
et/smc/smc_ism.c=0Aindex 9c6e95882553..6558cf7643a7 100644=0A--- a/net/smc/=
smc_ism.c=0A+++ b/net/smc/smc_ism.c=0A@@ -417,11 +417,6 @@ struct smcd_dev =
*smcd_alloc_dev(struct device *parent, const char *name,=0A 	init_waitqueue=
_head(&smcd->lgrs_deleted);=0A 	smcd->event_wq =3D alloc_ordered_workqueue(=
"ism_evt_wq-%s)",=0A 						 WQ_MEM_RECLAIM, name);=0A-	if (!smcd->event_wq)=
 {=0A-		kfree(smcd->conn);=0A-		kfree(smcd);=0A-		return NULL;=0A-	}=0A 	re=
turn smcd;=0A }=0A EXPORT_SYMBOL_GPL(smcd_alloc_dev);=0A-- =0A2.30.2=0A=0A=
=0AFrom 33bf9aad675b0b98514848e10b678f9a0985d8ce Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:22 +0100=0ASubject: [PATCH 068/165] Revert "pinctrl: axp209: Fix =
NULL pointer dereference=0A after allocation"=0A=0AThis reverts commit 1adc=
90c7395742827d754a5f02f446818a77c379.=0A=0ACommits from @umn.edu addresses =
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
drivers/pinctrl/pinctrl-axp209.c | 2 --=0A 1 file changed, 2 deletions(-)=
=0A=0Adiff --git a/drivers/pinctrl/pinctrl-axp209.c b/drivers/pinctrl/pinct=
rl-axp209.c=0Aindex 207cbae3a7bf..58f7149dd39b 100644=0A--- a/drivers/pinct=
rl/pinctrl-axp209.c=0A+++ b/drivers/pinctrl/pinctrl-axp209.c=0A@@ -365,8 +3=
65,6 @@ static int axp20x_build_funcs_groups(struct platform_device *pdev)=
=0A 		pctl->funcs[i].groups =3D devm_kcalloc(&pdev->dev,=0A 						     npin=
s, sizeof(char *),=0A 						     GFP_KERNEL);=0A-		if (!pctl->funcs[i].grou=
ps)=0A-			return -ENOMEM;=0A 		for (pin =3D 0; pin < npins; pin++)=0A 			pc=
tl->funcs[i].groups[pin] =3D pctl->desc->pins[pin].name;=0A 	}=0A-- =0A2.30=
=2E2=0A=0A=0AFrom d8780f590c55a1131b8729620168a101da65a06d Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:42:23 +0100=0ASubject: [PATCH 069/165] Revert "iio: hmc5843:=
 fix potential NULL pointer=0A dereferences"=0A=0AThis reverts commit 536cc=
27deade8f1ec3c1beefa60d5fbe0f6fcb28.=0A=0ACommits from @umn.edu addresses h=
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
vers/iio/magnetometer/hmc5843_i2c.c | 7 +------=0A drivers/iio/magnetometer=
/hmc5843_spi.c | 7 +------=0A 2 files changed, 2 insertions(+), 12 deletion=
s(-)=0A=0Adiff --git a/drivers/iio/magnetometer/hmc5843_i2c.c b/drivers/iio=
/magnetometer/hmc5843_i2c.c=0Aindex 67fe657fdb3e..9a4491233d08 100644=0A---=
 a/drivers/iio/magnetometer/hmc5843_i2c.c=0A+++ b/drivers/iio/magnetometer/=
hmc5843_i2c.c=0A@@ -55,13 +55,8 @@ static const struct regmap_config hmc584=
3_i2c_regmap_config =3D {=0A static int hmc5843_i2c_probe(struct i2c_client=
 *cli,=0A 			     const struct i2c_device_id *id)=0A {=0A-	struct regmap *r=
egmap =3D devm_regmap_init_i2c(cli,=0A-			&hmc5843_i2c_regmap_config);=0A-	=
if (IS_ERR(regmap))=0A-		return PTR_ERR(regmap);=0A-=0A 	return hmc5843_com=
mon_probe(&cli->dev,=0A-			regmap,=0A+			devm_regmap_init_i2c(cli, &hmc5843=
_i2c_regmap_config),=0A 			id->driver_data, id->name);=0A }=0A =0Adiff --gi=
t a/drivers/iio/magnetometer/hmc5843_spi.c b/drivers/iio/magnetometer/hmc58=
43_spi.c=0Aindex d827554c346e..58bdbc7257ec 100644=0A--- a/drivers/iio/magn=
etometer/hmc5843_spi.c=0A+++ b/drivers/iio/magnetometer/hmc5843_spi.c=0A@@ =
-55,7 +55,6 @@ static const struct regmap_config hmc5843_spi_regmap_config =
=3D {=0A static int hmc5843_spi_probe(struct spi_device *spi)=0A {=0A 	int =
ret;=0A-	struct regmap *regmap;=0A 	const struct spi_device_id *id =3D spi_=
get_device_id(spi);=0A =0A 	spi->mode =3D SPI_MODE_3;=0A@@ -65,12 +64,8 @@ =
static int hmc5843_spi_probe(struct spi_device *spi)=0A 	if (ret)=0A 		retu=
rn ret;=0A =0A-	regmap =3D devm_regmap_init_spi(spi, &hmc5843_spi_regmap_co=
nfig);=0A-	if (IS_ERR(regmap))=0A-		return PTR_ERR(regmap);=0A-=0A 	return =
hmc5843_common_probe(&spi->dev,=0A-			regmap,=0A+			devm_regmap_init_spi(sp=
i, &hmc5843_spi_regmap_config),=0A 			id->driver_data, id->name);=0A }=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 443852a8d2bd7772e216ad5f9783059ec20cf8d9 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:42:24 +0100=0ASubject: [PATCH 070/165] Revert "ii=
o: adc: fix a potential NULL pointer=0A dereference"=0A=0AThis reverts comm=
it 13814627c9658cf8382dd052bc251ee415670a55.=0A=0ACommits from @umn.edu add=
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
=0A drivers/iio/adc/mxs-lradc-adc.c | 2 --=0A 1 file changed, 2 deletions(-=
)=0A=0Adiff --git a/drivers/iio/adc/mxs-lradc-adc.c b/drivers/iio/adc/mxs-l=
radc-adc.c=0Aindex 30e29f44ebd2..7f327ae95739 100644=0A--- a/drivers/iio/ad=
c/mxs-lradc-adc.c=0A+++ b/drivers/iio/adc/mxs-lradc-adc.c=0A@@ -456,8 +456,=
6 @@ static int mxs_lradc_adc_trigger_init(struct iio_dev *iio)=0A =0A 	tri=
g =3D devm_iio_trigger_alloc(&iio->dev, "%s-dev%i", iio->name,=0A 				     =
 iio->id);=0A-	if (!trig)=0A-		return -ENOMEM;=0A =0A 	trig->dev.parent =3D=
 adc->dev;=0A 	iio_trigger_set_drvdata(trig, iio);=0A-- =0A2.30.2=0A=0A=0AF=
rom 1480123225a1b4256970a4891bb75f526004b0e2 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19=
:42:24 +0100=0ASubject: [PATCH 071/165] Revert "net: mwifiex: fix a NULL po=
inter dereference"=0A=0AThis reverts commit e5b9b206f3f6376b9a1406b67eafe4e=
7bb9f123c.=0A=0ACommits from @umn.edu addresses have been found to be submi=
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
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/marvell/mw=
ifiex/cmdevt.c | 6 ------=0A 1 file changed, 6 deletions(-)=0A=0Adiff --git=
 a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/mar=
vell/mwifiex/cmdevt.c=0Aindex 3a11342a6bde..bda8a236e386 100644=0A--- a/dri=
vers/net/wireless/marvell/mwifiex/cmdevt.c=0A+++ b/drivers/net/wireless/mar=
vell/mwifiex/cmdevt.c=0A@@ -339,12 +339,6 @@ static int mwifiex_dnld_sleep_=
confirm_cmd(struct mwifiex_adapter *adapter)=0A 		sleep_cfm_tmp =3D=0A 			d=
ev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)=0A 				      + MWIFIE=
X_TYPE_LEN);=0A-		if (!sleep_cfm_tmp) {=0A-			mwifiex_dbg(adapter, ERROR,=
=0A-				    "SLEEP_CFM: dev_alloc_skb failed\n");=0A-			return -ENOMEM;=0A-=
		}=0A-=0A 		skb_put(sleep_cfm_tmp, sizeof(struct mwifiex_opt_sleep_confirm=
)=0A 			+ MWIFIEX_TYPE_LEN);=0A 		put_unaligned_le32(MWIFIEX_USB_TYPE_CMD, =
sleep_cfm_tmp->data);=0A-- =0A2.30.2=0A=0A=0AFrom 07a5f1298cbc20d6e9a91435e=
a3c4562ebe3f5ee Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:25 +0100=0ASubject: [PATC=
H 072/165] Revert "rtlwifi: fix a potential NULL pointer=0A dereference"=0A=
=0AThis reverts commit 765976285a8c8db3f0eb7f033829a899d0c2786e.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/net/wireless/realtek/rtlwifi/base.c | 5 ----=
-=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/=
realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c=0Ainde=
x 6e8bd99e8911..1d067536889e 100644=0A--- a/drivers/net/wireless/realtek/rt=
lwifi/base.c=0A+++ b/drivers/net/wireless/realtek/rtlwifi/base.c=0A@@ -452,=
11 +452,6 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)=
=0A 	/* <2> work queue */=0A 	rtlpriv->works.hw =3D hw;=0A 	rtlpriv->works.=
rtl_wq =3D alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);=0A-	if (unlikel=
y(!rtlpriv->works.rtl_wq)) {=0A-		pr_err("Failed to allocate work queue\n")=
;=0A-		return;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,=
=0A 			  rtl_watchdog_wq_callback);=0A 	INIT_DELAYED_WORK(&rtlpriv->works.i=
ps_nic_off_wq,=0A-- =0A2.30.2=0A=0A=0AFrom dadb92ccda8c6cbd58c709556fe068b1=
e2f82b4a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:26 +0100=0ASubject: [PATCH 073/1=
65] Revert "video: hgafb: fix potential NULL pointer=0A dereference"=0A=0AT=
his reverts commit ec7f6aad57ad29e4e66cc2e18e1e1599ddb02542.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/video/fbdev/hgafb.c | 2 --=0A 1 file changed, 2 =
deletions(-)=0A=0Adiff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/=
fbdev/hgafb.c=0Aindex a45fcff1461f..4da5abf5bc8f 100644=0A--- a/drivers/vid=
eo/fbdev/hgafb.c=0A+++ b/drivers/video/fbdev/hgafb.c=0A@@ -285,8 +285,6 @@ =
static int hga_card_detect(void)=0A 	hga_vram_len  =3D 0x08000;=0A =0A 	hga=
_vram =3D ioremap(0xb0000, hga_vram_len);=0A-	if (!hga_vram)=0A-		goto erro=
r;=0A =0A 	if (request_region(0x3b0, 12, "hgafb"))=0A 		release_io_ports =
=3D 1;=0A-- =0A2.30.2=0A=0A=0AFrom 2bda82d6c849e02716ac859a4ca67ac53b4b1653=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 19:42:26 +0100=0ASubject: [PATCH 074/165] Reve=
rt "video: imsttfb: fix potential NULL pointer=0A dereferences"=0A=0AThis r=
everts commit 1d84353d205a953e2381044953b7fa31c8c9702d.=0A=0ACommits from @=
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
l.com>=0A---=0A drivers/video/fbdev/imsttfb.c | 5 -----=0A 1 file changed, =
5 deletions(-)=0A=0Adiff --git a/drivers/video/fbdev/imsttfb.c b/drivers/vi=
deo/fbdev/imsttfb.c=0Aindex 3ac053b88495..e04411701ec8 100644=0A--- a/drive=
rs/video/fbdev/imsttfb.c=0A+++ b/drivers/video/fbdev/imsttfb.c=0A@@ -1512,1=
1 +1512,6 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pc=
i_device_id *ent)=0A 	info->fix.smem_start =3D addr;=0A 	info->screen_base =
=3D (__u8 *)ioremap(addr, par->ramdac =3D=3D IBM ?=0A 					    0x400000 : 0=
x800000);=0A-	if (!info->screen_base) {=0A-		release_mem_region(addr, size)=
;=0A-		framebuffer_release(info);=0A-		return -ENOMEM;=0A-	}=0A 	info->fix.=
mmio_start =3D addr + 0x800000;=0A 	par->dc_regs =3D ioremap(addr + 0x80000=
0, 0x1000);=0A 	par->cmap_regs_phys =3D addr + 0x840000;=0A-- =0A2.30.2=0A=
=0A=0AFrom dce3d9adfbe5d84f0ea6b9d355761d82983e54f5 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:42:27 +0100=0ASubject: [PATCH 075/165] Revert "rfkill: Fix incorrec=
t check to avoid NULL=0A pointer dereference"=0A=0AThis reverts commit 6fc2=
32db9e8cd50b9b83534de9cd91ace711b2d7.=0A=0ACommits from @umn.edu addresses =
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
net/rfkill/core.c | 7 ++-----=0A 1 file changed, 2 insertions(+), 5 deletio=
ns(-)=0A=0Adiff --git a/net/rfkill/core.c b/net/rfkill/core.c=0Aindex ac15a=
944573f..8a27164d7f5f 100644=0A--- a/net/rfkill/core.c=0A+++ b/net/rfkill/c=
ore.c=0A@@ -1033,13 +1033,10 @@ static void rfkill_sync_work(struct work_st=
ruct *work)=0A int __must_check rfkill_register(struct rfkill *rfkill)=0A {=
=0A 	static unsigned long rfkill_no;=0A-	struct device *dev;=0A+	struct dev=
ice *dev =3D &rfkill->dev;=0A 	int error;=0A =0A-	if (!rfkill)=0A-		return =
-EINVAL;=0A-=0A-	dev =3D &rfkill->dev;=0A+	BUG_ON(!rfkill);=0A =0A 	mutex_l=
ock(&rfkill_global_mutex);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 936f3221da142c06=
27077c85eb24a04dce34d003 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:28 +0100=0ASubje=
ct: [PATCH 076/165] Revert "PCI: xilinx: Check for __get_free_pages()=0A fa=
ilure"=0A=0AThis reverts commit 699ca30162686bf305cdf94861be02eb0cf9bda2.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/pci/controller/pcie-xilinx.c=
 | 12 ++----------=0A 1 file changed, 2 insertions(+), 10 deletions(-)=0A=
=0Adiff --git a/drivers/pci/controller/pcie-xilinx.c b/drivers/pci/controll=
er/pcie-xilinx.c=0Aindex fa5baeb82653..942c25bf7980 100644=0A--- a/drivers/=
pci/controller/pcie-xilinx.c=0A+++ b/drivers/pci/controller/pcie-xilinx.c=
=0A@@ -326,19 +326,14 @@ static const struct irq_domain_ops msi_domain_ops =
=3D {=0A  * xilinx_pcie_enable_msi - Enable MSI support=0A  * @port: PCIe p=
ort information=0A  */=0A-static int xilinx_pcie_enable_msi(struct xilinx_p=
cie_port *port)=0A+static void xilinx_pcie_enable_msi(struct xilinx_pcie_po=
rt *port)=0A {=0A 	phys_addr_t msg_addr;=0A =0A 	port->msi_pages =3D __get_=
free_pages(GFP_KERNEL, 0);=0A-	if (!port->msi_pages)=0A-		return -ENOMEM;=
=0A-=0A 	msg_addr =3D virt_to_phys((void *)port->msi_pages);=0A 	pcie_write=
(port, 0x0, XILINX_PCIE_REG_MSIBASE1);=0A 	pcie_write(port, msg_addr, XILIN=
X_PCIE_REG_MSIBASE2);=0A-=0A-	return 0;=0A }=0A =0A /* INTx Functions */=0A=
@@ -493,7 +488,6 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pc=
ie_port *port)=0A 	struct device *dev =3D port->dev;=0A 	struct device_node=
 *node =3D dev->of_node;=0A 	struct device_node *pcie_intc_node;=0A-	int re=
t;=0A =0A 	/* Setup INTx */=0A 	pcie_intc_node =3D of_get_next_child(node, =
NULL);=0A@@ -522,9 +516,7 @@ static int xilinx_pcie_init_irq_domain(struct =
xilinx_pcie_port *port)=0A 			return -ENODEV;=0A 		}=0A =0A-		ret =3D xilin=
x_pcie_enable_msi(port);=0A-		if (ret)=0A-			return ret;=0A+		xilinx_pcie_e=
nable_msi(port);=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom 5caf4f=
bf17e6765998869da4526b6beb774018da Mon Sep 17 00:00:00 2001=0AFrom: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:28 +01=
00=0ASubject: [PATCH 077/165] Revert "staging: greybus: audio_manager: fix =
a=0A missing check of ida_simple_get"=0A=0AThis reverts commit b5af36e3e5aa=
074605a4d90a89dd8f714b30909b.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/stag=
ing/greybus/audio_manager.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0A=
diff --git a/drivers/staging/greybus/audio_manager.c b/drivers/staging/grey=
bus/audio_manager.c=0Aindex 9a3f7c034ab4..7c7ca671876d 100644=0A--- a/drive=
rs/staging/greybus/audio_manager.c=0A+++ b/drivers/staging/greybus/audio_ma=
nager.c=0A@@ -45,9 +45,6 @@ int gb_audio_manager_add(struct gb_audio_manage=
r_module_descriptor *desc)=0A 	int err;=0A =0A 	id =3D ida_simple_get(&modu=
le_id, 0, 0, GFP_KERNEL);=0A-	if (id < 0)=0A-		return id;=0A-=0A 	err =3D g=
b_audio_manager_module_create(&module, manager_kset,=0A 					     id, desc)=
;=0A 	if (err) {=0A-- =0A2.30.2=0A=0A=0AFrom e2bdd754d51c0c32d215ba9ca6e4f4=
2ed8438037 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:29 +0100=0ASubject: [PATCH 078=
/165] Revert "omapfb: Fix potential NULL pointer=0A dereference in kmalloc"=
=0A=0AThis reverts commit 31fa6e2ae65feed0de10823c5d1eea21a93086c9.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/video/fbdev/omap2/omapfb/dss/omapdss-boot=
-init.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/=
video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c b/drivers/video/fbdev/omap=
2/omapfb/dss/omapdss-boot-init.c=0Aindex 0ae0cab252d3..05d87dcbdd8b 100644=
=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c=0A+++ b/d=
rivers/video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c=0A@@ -100,8 +100,6 =
@@ static void __init omapdss_omapify_node(struct device_node *node)=0A =0A=
 	new_len =3D prop->length + strlen(prefix) * num_strs;=0A 	new_compat =3D =
kmalloc(new_len, GFP_KERNEL);=0A-	if (!new_compat)=0A-		return;=0A =0A 	oma=
pdss_prefix_strcpy(new_compat, new_len, prop->value, prop->length);=0A =0A-=
- =0A2.30.2=0A=0A=0AFrom e428f31bdbaf6975e518122aef90fca79707aa59 Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 19:42:30 +0100=0ASubject: [PATCH 079/165] Revert "media:=
 video-mux: fix null pointer=0A dereferences"=0A=0AThis reverts commit aeb0=
d0f581e2079868e64a2e5ee346d340376eae.=0A=0ACommits from @umn.edu addresses =
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
drivers/media/platform/video-mux.c | 5 -----=0A 1 file changed, 5 deletions=
(-)=0A=0Adiff --git a/drivers/media/platform/video-mux.c b/drivers/media/pl=
atform/video-mux.c=0Aindex 53570250a25d..d4abb25d4378 100644=0A--- a/driver=
s/media/platform/video-mux.c=0A+++ b/drivers/media/platform/video-mux.c=0A@=
@ -448,14 +448,9 @@ static int video_mux_probe(struct platform_device *pdev=
)=0A 	vmux->active =3D -1;=0A 	vmux->pads =3D devm_kcalloc(dev, num_pads, s=
izeof(*vmux->pads),=0A 				  GFP_KERNEL);=0A-	if (!vmux->pads)=0A-		return =
-ENOMEM;=0A-=0A 	vmux->format_mbus =3D devm_kcalloc(dev, num_pads,=0A 					=
 sizeof(*vmux->format_mbus),=0A 					 GFP_KERNEL);=0A-	if (!vmux->format_mb=
us)=0A-		return -ENOMEM;=0A =0A 	for (i =3D 0; i < num_pads; i++) {=0A 		vm=
ux->pads[i].flags =3D (i < num_pads - 1) ? MEDIA_PAD_FL_SINK=0A-- =0A2.30.2=
=0A=0A=0AFrom 3f775a84e74784c134081e151234e347adcf3f0e Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:30 +0100=0ASubject: [PATCH 080/165] Revert "thunderbolt: prop=
erty: Fix a missing check of=0A kzalloc"=0A=0AThis reverts commit 6183d5a51=
866f3acdeeb66b75e87d44025b01a55.=0A=0ACommits from @umn.edu addresses have =
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
ned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/t=
hunderbolt/property.c | 7 +------=0A 1 file changed, 1 insertion(+), 6 dele=
tions(-)=0A=0Adiff --git a/drivers/thunderbolt/property.c b/drivers/thunder=
bolt/property.c=0Aindex d5b0cdb8f0b1..841314deb446 100644=0A--- a/drivers/t=
hunderbolt/property.c=0A+++ b/drivers/thunderbolt/property.c=0A@@ -587,12 +=
587,7 @@ int tb_property_add_text(struct tb_property_dir *parent, const cha=
r *key,=0A 		return -ENOMEM;=0A =0A 	property->length =3D size / 4;=0A-	pro=
perty->value.text =3D kzalloc(size, GFP_KERNEL);=0A-	if (!property->value.t=
ext) {=0A-		kfree(property);=0A-		return -ENOMEM;=0A-	}=0A-=0A+	property->v=
alue.data =3D kzalloc(size, GFP_KERNEL);=0A 	strcpy(property->value.text, t=
ext);=0A =0A 	list_add_tail(&property->list, &parent->properties);=0A-- =0A=
2.30.2=0A=0A=0AFrom 3003d89c98e91dd458f2c87d35b3b78bdce02c50 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 19:42:31 +0100=0ASubject: [PATCH 081/165] Revert "char: hpet:=
 fix a missing check of ioremap"=0A=0AThis reverts commit 13bd14a41ce3105d5=
b1f3cd8b4d1e249d17b6d9b.=0A=0ACommits from @umn.edu addresses have been fou=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/char/hpe=
t.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/char=
/hpet.c b/drivers/char/hpet.c=0Aindex ed3b7dab678d..6f13def6c172 100644=0A-=
-- a/drivers/char/hpet.c=0A+++ b/drivers/char/hpet.c=0A@@ -969,8 +969,6 @@ =
static acpi_status hpet_resources(struct acpi_resource *res, void *data)=0A=
 	if (ACPI_SUCCESS(status)) {=0A 		hdp->hd_phys_address =3D addr.address.mi=
nimum;=0A 		hdp->hd_address =3D ioremap(addr.address.minimum, addr.address.=
address_length);=0A-		if (!hdp->hd_address)=0A-			return AE_ERROR;=0A =0A 	=
	if (hpet_is_known(hdp)) {=0A 			iounmap(hdp->hd_address);=0A-- =0A2.30.2=
=0A=0A=0AFrom 84690fde3d713b7ea3490da7f6674a2066573eea Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:32 +0100=0ASubject: [PATCH 082/165] Revert "media: rcar_drif:=
 fix a memory disclosure"=0A=0AThis reverts commit d39083234c60519724c6ed59=
509a2129fd2aed41.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/r=
car_drif.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/drivers=
/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c=0Aindex f3=
18cd4b8086..083dba95beaa 100644=0A--- a/drivers/media/platform/rcar_drif.c=
=0A+++ b/drivers/media/platform/rcar_drif.c=0A@@ -915,7 +915,6 @@ static in=
t rcar_drif_g_fmt_sdr_cap(struct file *file, void *priv,=0A {=0A 	struct rc=
ar_drif_sdr *sdr =3D video_drvdata(file);=0A =0A-	memset(f->fmt.sdr.reserve=
d, 0, sizeof(f->fmt.sdr.reserved));=0A 	f->fmt.sdr.pixelformat =3D sdr->fmt=
->pixelformat;=0A 	f->fmt.sdr.buffersize =3D sdr->fmt->buffersize;=0A =0A--=
 =0A2.30.2=0A=0A=0AFrom 199480002f614b44033f67d82869a6ca97def477 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:42:32 +0100=0ASubject: [PATCH 083/165] Revert "net: ca=
if: replace BUG_ON with recovery code"=0A=0AThis reverts commit c5dea815834=
c7d2e9fc633785455bc428b7a1956.=0A=0ACommits from @umn.edu addresses have be=
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
/caif/caif_serial.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions=
(-)=0A=0Adiff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/cai=
f_serial.c=0Aindex bcc14c5875bf..4cc0d91d9c87 100644=0A--- a/drivers/net/ca=
if/caif_serial.c=0A+++ b/drivers/net/caif/caif_serial.c=0A@@ -270,9 +270,7 =
@@ static netdev_tx_t caif_xmit(struct sk_buff *skb, struct net_device *dev=
)=0A {=0A 	struct ser_device *ser;=0A =0A-	if (WARN_ON(!dev))=0A-		return -=
EINVAL;=0A-=0A+	BUG_ON(dev =3D=3D NULL);=0A 	ser =3D netdev_priv(dev);=0A =
=0A 	/* Send flow off once, on high water mark */=0A-- =0A2.30.2=0A=0A=0AFr=
om 88071e067c6bc9a3a83bd92e47fa628883b558fa Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:=
42:33 +0100=0ASubject: [PATCH 084/165] Revert "drm/gma500: fix memory discl=
osures due to=0A uninitialized bytes"=0A=0AThis reverts commit ec3b7b6eb8c9=
0b52f61adff11b6db7a8db34de19.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/=
drm/gma500/oaktrail_crtc.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adi=
ff --git a/drivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/=
oaktrail_crtc.c=0Aindex 900e5499249d..167c10767dd4 100644=0A--- a/drivers/g=
pu/drm/gma500/oaktrail_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.=
c=0A@@ -129,7 +129,6 @@ static bool mrst_sdvo_find_best_pll(const struct gm=
a_limit_t *limit,=0A 	s32 freq_error, min_error =3D 100000;=0A =0A 	memset(=
best_clock, 0, sizeof(*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=
=0A =0A 	for (clock.m =3D limit->m.min; clock.m <=3D limit->m.max; clock.m+=
+) {=0A 		for (clock.n =3D limit->n.min; clock.n <=3D limit->n.max;=0A@@ -1=
86,7 +185,6 @@ static bool mrst_lvds_find_best_pll(const struct gma_limit_t=
 *limit,=0A 	int err =3D target;=0A =0A 	memset(best_clock, 0, sizeof(*best=
_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =3D li=
mit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		for (clock.p1 =3D =
limit->p1.min; clock.p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=0AFrom 6de=
48672a4204677e9eff94580f8574ccc8f9ec9 Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:33 =
+0100=0ASubject: [PATCH 085/165] Revert "gma/gma500: fix a memory disclosur=
e bug due=0A to uninitialized bytes"=0A=0AThis reverts commit 57a25a5f754ce=
27da2cfa6f413cfd366f878db76.=0A=0ACommits from @umn.edu addresses have been=
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
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/d=
rm/gma500/cdv_intel_display.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=
=0Adiff --git a/drivers/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/dr=
m/gma500/cdv_intel_display.c=0Aindex 686385a66167..492ca9404bbe 100644=0A--=
- a/drivers/gpu/drm/gma500/cdv_intel_display.c=0A+++ b/drivers/gpu/drm/gma5=
00/cdv_intel_display.c=0A@@ -405,8 +405,6 @@ static bool cdv_intel_find_dp_=
pll(const struct gma_limit_t *limit,=0A 	struct gma_crtc *gma_crtc =3D to_g=
ma_crtc(crtc);=0A 	struct gma_clock_t clock;=0A =0A-	memset(&clock, 0, size=
of(clock));=0A-=0A 	switch (refclk) {=0A 	case 27000:=0A 		if (target < 200=
000) {=0A-- =0A2.30.2=0A=0A=0AFrom c133341f93a204db0a03a16149594579fb412c58=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 19:42:34 +0100=0ASubject: [PATCH 086/165] Reve=
rt "thunderbolt: Fix a missing check of kmemdup"=0A=0AThis reverts commit e=
4dfdd5804cce1255f99c5dd033526a18135a616.=0A=0ACommits from @umn.edu address=
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
=0A drivers/thunderbolt/property.c | 4 ----=0A 1 file changed, 4 deletions(=
-)=0A=0Adiff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/p=
roperty.c=0Aindex 841314deb446..ee76449524a3 100644=0A--- a/drivers/thunder=
bolt/property.c=0A+++ b/drivers/thunderbolt/property.c=0A@@ -176,10 +176,6 =
@@ static struct tb_property_dir *__tb_property_parse_dir(const u32 *block,=
=0A 	} else {=0A 		dir->uuid =3D kmemdup(&block[dir_offset], sizeof(*dir->u=
uid),=0A 				    GFP_KERNEL);=0A-		if (!dir->uuid) {=0A-			tb_property_free=
_dir(dir);=0A-			return NULL;=0A-		}=0A 		content_offset =3D dir_offset + 4=
;=0A 		content_len =3D dir_len - 4; /* Length includes UUID */=0A 	}=0A-- =
=0A2.30.2=0A=0A=0AFrom f1b3a4cd6318546fc296505a0f307ca0d2e9df36 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:42:35 +0100=0ASubject: [PATCH 087/165] Revert "spi : sp=
i-topcliff-pch: Fix to handle empty=0A DMA buffers"=0A=0AThis reverts commi=
t f37d8e67f39e6d3eaf4cc5471e8a3d21209843c6.=0A=0ACommits from @umn.edu addr=
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
--=0A drivers/spi/spi-topcliff-pch.c | 15 ++-------------=0A 1 file changed=
, 2 insertions(+), 13 deletions(-)=0A=0Adiff --git a/drivers/spi/spi-topcli=
ff-pch.c b/drivers/spi/spi-topcliff-pch.c=0Aindex b459e369079f..12d749e9436=
b 100644=0A--- a/drivers/spi/spi-topcliff-pch.c=0A+++ b/drivers/spi/spi-top=
cliff-pch.c=0A@@ -1290,27 +1290,18 @@ static void pch_free_dma_buf(struct p=
ch_spi_board_data *board_dat,=0A 				  dma->rx_buf_virt, dma->rx_buf_dma);=
=0A }=0A =0A-static int pch_alloc_dma_buf(struct pch_spi_board_data *board_=
dat,=0A+static void pch_alloc_dma_buf(struct pch_spi_board_data *board_dat,=
=0A 			      struct pch_spi_data *data)=0A {=0A 	struct pch_spi_dma_ctrl *d=
ma;=0A-	int ret;=0A =0A 	dma =3D &data->dma;=0A-	ret =3D 0;=0A 	/* Get Cons=
istent memory for Tx DMA */=0A 	dma->tx_buf_virt =3D dma_alloc_coherent(&bo=
ard_dat->pdev->dev,=0A 				PCH_BUF_SIZE, &dma->tx_buf_dma, GFP_KERNEL);=0A-=
	if (!dma->tx_buf_virt)=0A-		ret =3D -ENOMEM;=0A-=0A 	/* Get Consistent mem=
ory for Rx DMA */=0A 	dma->rx_buf_virt =3D dma_alloc_coherent(&board_dat->p=
dev->dev,=0A 				PCH_BUF_SIZE, &dma->rx_buf_dma, GFP_KERNEL);=0A-	if (!dma-=
>rx_buf_virt)=0A-		ret =3D -ENOMEM;=0A-=0A-	return ret;=0A }=0A =0A static =
int pch_spi_pd_probe(struct platform_device *plat_dev)=0A@@ -1387,9 +1378,7=
 @@ static int pch_spi_pd_probe(struct platform_device *plat_dev)=0A =0A 	i=
f (use_dma) {=0A 		dev_info(&plat_dev->dev, "Use DMA for data transfers\n")=
;=0A-		ret =3D pch_alloc_dma_buf(board_dat, data);=0A-		if (ret)=0A-			goto=
 err_spi_register_master;=0A+		pch_alloc_dma_buf(board_dat, data);=0A 	}=0A=
 =0A 	ret =3D spi_register_master(master);=0A-- =0A2.30.2=0A=0A=0AFrom 3532=
fdf48719a7cdde852fa9cc57081557a8a5a3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:35 +=
0100=0ASubject: [PATCH 088/165] Revert "scsi: ufs: fix a missing check of=
=0A devm_reset_control_get"=0A=0AThis reverts commit 63a06181d7ce169d098436=
45c50fea1901bc9f0a.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/ufs/ufs-h=
isi.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/=
scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c=0Aindex 0aa58131e791..7d1=
e07a9d9dd 100644=0A--- a/drivers/scsi/ufs/ufs-hisi.c=0A+++ b/drivers/scsi/u=
fs/ufs-hisi.c=0A@@ -468,10 +468,6 @@ static int ufs_hisi_init_common(struct=
 ufs_hba *hba)=0A 	ufshcd_set_variant(hba, host);=0A =0A 	host->rst  =3D de=
vm_reset_control_get(dev, "rst");=0A-	if (IS_ERR(host->rst)) {=0A-		dev_err=
(dev, "%s: failed to get reset control\n", __func__);=0A-		return PTR_ERR(h=
ost->rst);=0A-	}=0A =0A 	ufs_hisi_set_pm_lvl(hba);=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom d4ca725bf949cdabe5f4df5b663f821cc43470ed Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:36 +0100=0ASubject: [PATCH 089/165] Revert "netfilter: ip6t_srh: =
fix NULL pointer=0A dereferences"=0A=0AThis reverts commit 6d65561f3d5ec933=
151939c543d006b79044e7a6.=0A=0ACommits from @umn.edu addresses have been fo=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/ipv6/netfilt=
er/ip6t_srh.c | 6 ------=0A 1 file changed, 6 deletions(-)=0A=0Adiff --git =
a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c=0Aindex db0=
fd64d8986..f172702257a7 100644=0A--- a/net/ipv6/netfilter/ip6t_srh.c=0A+++ =
b/net/ipv6/netfilter/ip6t_srh.c=0A@@ -206,8 +206,6 @@ static bool srh1_mt6(=
const struct sk_buff *skb, struct xt_action_param *par)=0A 		psidoff =3D sr=
hoff + sizeof(struct ipv6_sr_hdr) +=0A 			  ((srh->segments_left + 1) * siz=
eof(struct in6_addr));=0A 		psid =3D skb_header_pointer(skb, psidoff, sizeo=
f(_psid), &_psid);=0A-		if (!psid)=0A-			return false;=0A 		if (NF_SRH_INVF=
(srhinfo, IP6T_SRH_INV_PSID,=0A 				ipv6_masked_addr_cmp(psid, &srhinfo->ps=
id_msk,=0A 						     &srhinfo->psid_addr)))=0A@@ -221,8 +219,6 @@ static b=
ool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)=0A 		n=
sidoff =3D srhoff + sizeof(struct ipv6_sr_hdr) +=0A 			  ((srh->segments_le=
ft - 1) * sizeof(struct in6_addr));=0A 		nsid =3D skb_header_pointer(skb, n=
sidoff, sizeof(_nsid), &_nsid);=0A-		if (!nsid)=0A-			return false;=0A 		if=
 (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,=0A 				ipv6_masked_addr_cmp(nsid,=
 &srhinfo->nsid_msk,=0A 						     &srhinfo->nsid_addr)))=0A@@ -233,8 +229,=
6 @@ static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param=
 *par)=0A 	if (srhinfo->mt_flags & IP6T_SRH_LSID) {=0A 		lsidoff =3D srhoff=
 + sizeof(struct ipv6_sr_hdr);=0A 		lsid =3D skb_header_pointer(skb, lsidof=
f, sizeof(_lsid), &_lsid);=0A-		if (!lsid)=0A-			return false;=0A 		if (NF_=
SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,=0A 				ipv6_masked_addr_cmp(lsid, &srh=
info->lsid_msk,=0A 						     &srhinfo->lsid_addr)))=0A-- =0A2.30.2=0A=0A=
=0AFrom d753d882658178e0717af300dec260fbce06bd17 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:37 +0100=0ASubject: [PATCH 090/165] Revert "net: openvswitch: fix=
 a NULL pointer=0A dereference"=0A=0AThis reverts commit 6f19893b644a9454d8=
5e593b5e90914e7a72b7dd.=0A=0ACommits from @umn.edu addresses have been foun=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/openvswitch/=
datapath.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/net=
/openvswitch/datapath.c b/net/openvswitch/datapath.c=0Aindex 9d6ef6cb9b26..=
99e63f4bbcaf 100644=0A--- a/net/openvswitch/datapath.c=0A+++ b/net/openvswi=
tch/datapath.c=0A@@ -443,10 +443,6 @@ static int queue_userspace_packet(str=
uct datapath *dp, struct sk_buff *skb,=0A =0A 	upcall =3D genlmsg_put(user_=
skb, 0, 0, &dp_packet_genl_family,=0A 			     0, upcall_info->cmd);=0A-	if =
(!upcall) {=0A-		err =3D -EINVAL;=0A-		goto out;=0A-	}=0A 	upcall->dp_ifind=
ex =3D dp_ifindex;=0A =0A 	err =3D ovs_nla_put_key(key, key, OVS_PACKET_ATT=
R_KEY, false, user_skb);=0A-- =0A2.30.2=0A=0A=0AFrom fe00fb4f5a13c3b6958db4=
51a0e5bcb09e8923a3 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:37 +0100=0ASubject: =
[PATCH 091/165] Revert "net: tipc: fix a missing check of=0A nla_nest_start=
"=0A=0AThis reverts commit 4589e28db46ee4961edfd794c5bb43887d38c8e5.=0A=0AC=
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
herjee@gmail.com>=0A---=0A net/tipc/group.c | 3 ---=0A 1 file changed, 3 de=
letions(-)=0A=0Adiff --git a/net/tipc/group.c b/net/tipc/group.c=0Aindex 3e=
137d8c9d2f..d18d497af4de 100644=0A--- a/net/tipc/group.c=0A+++ b/net/tipc/g=
roup.c=0A@@ -927,9 +927,6 @@ int tipc_group_fill_sock_diag(struct tipc_grou=
p *grp, struct sk_buff *skb)=0A {=0A 	struct nlattr *group =3D nla_nest_sta=
rt_noflag(skb, TIPC_NLA_SOCK_GROUP);=0A =0A-	if (!group)=0A-		return -EMSGS=
IZE;=0A-=0A 	if (nla_put_u32(skb, TIPC_NLA_SOCK_GROUP_ID,=0A 			grp->type) =
||=0A 	    nla_put_u32(skb, TIPC_NLA_SOCK_GROUP_INSTANCE,=0A-- =0A2.30.2=0A=
=0A=0AFrom 6d411c1593988cc56626bda2b13873255671f82c Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:42:38 +0100=0ASubject: [PATCH 092/165] Revert "net: strparser: fix =
a missing check for=0A create_singlethread_workqueue"=0A=0AThis reverts com=
mit 228cd2dba27cee9956c1af97e6445be056881e41.=0A=0ACommits from @umn.edu ad=
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
--=0A net/strparser/strparser.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=
=0Adiff --git a/net/strparser/strparser.c b/net/strparser/strparser.c=0Aind=
ex b3815c1e8f2e..efce4ddaa320 100644=0A--- a/net/strparser/strparser.c=0A++=
+ b/net/strparser/strparser.c=0A@@ -542,8 +542,6 @@ EXPORT_SYMBOL_GPL(strp_=
check_rcv);=0A static int __init strp_dev_init(void)=0A {=0A 	strp_wq =3D c=
reate_singlethread_workqueue("kstrp");=0A-	if (unlikely(!strp_wq))=0A-		ret=
urn -ENOMEM;=0A =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 3a66c01fcdd=
4e6dba25e5d60c1c146d5984f711d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:39 +0100=0A=
Subject: [PATCH 093/165] Revert "media: si2165: fix a missing check of retu=
rn=0A value"=0A=0AThis reverts commit 0ab34a08812a3334350dbaf69a018ee0ab3d2=
ddd.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-frontends/si2165.c =
| 8 +++-----=0A 1 file changed, 3 insertions(+), 5 deletions(-)=0A=0Adiff -=
-git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/s=
i2165.c=0Aindex ebee230afb7b..dc39543e0db1 100644=0A--- a/drivers/media/dvb=
-frontends/si2165.c=0A+++ b/drivers/media/dvb-frontends/si2165.c=0A@@ -266,=
20 +266,18 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)=0A =
=0A static int si2165_wait_init_done(struct si2165_state *state)=0A {=0A-	i=
nt ret;=0A+	int ret =3D -EINVAL;=0A 	u8 val =3D 0;=0A 	int i;=0A =0A 	for (=
i =3D 0; i < 3; ++i) {=0A-		ret =3D si2165_readreg8(state, REG_INIT_DONE, &=
val);=0A-		if (ret < 0)=0A-			return ret;=0A+		si2165_readreg8(state, REG_I=
NIT_DONE, &val);=0A 		if (val =3D=3D 0x01)=0A 			return 0;=0A 		usleep_rang=
e(1000, 50000);=0A 	}=0A 	dev_err(&state->client->dev, "init_done was not s=
et\n");=0A-	return -EINVAL;=0A+	return ret;=0A }=0A =0A static int si2165_u=
pload_firmware_block(struct si2165_state *state,=0A-- =0A2.30.2=0A=0A=0AFro=
m b4a4300b957028637f4dfe67265a2ed738339645 Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:4=
2:39 +0100=0ASubject: [PATCH 094/165] Revert "net: 8390: fix potential NULL=
 pointer=0A dereferences"=0A=0AThis reverts commit c7cbc3e937b885c9394bf9d0=
ca21ceb75c2ac262.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/839=
0/pcnet_cs.c | 10 ----------=0A 1 file changed, 10 deletions(-)=0A=0Adiff -=
-git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcn=
et_cs.c=0Aindex 9d3b1e0e425c..0a408fa2b7a4 100644=0A--- a/drivers/net/ether=
net/8390/pcnet_cs.c=0A+++ b/drivers/net/ethernet/8390/pcnet_cs.c=0A@@ -289,=
11 +289,6 @@ static struct hw_info *get_hwinfo(struct pcmcia_device *link)=
=0A =0A     virt =3D ioremap(link->resource[2]->start,=0A 	    resource_siz=
e(link->resource[2]));=0A-    if (unlikely(!virt)) {=0A-	    pcmcia_release=
_window(link, link->resource[2]);=0A-	    return NULL;=0A-    }=0A-=0A     =
for (i =3D 0; i < NR_INFO; i++) {=0A 	pcmcia_map_mem_page(link, link->resou=
rce[2],=0A 		hw_info[i].offset & ~(resource_size(link->resource[2])-1));=0A=
@@ -1430,11 +1425,6 @@ static int setup_shmem_window(struct pcmcia_device *=
link, int start_pg,=0A     /* Try scribbling on the buffer */=0A     info->=
base =3D ioremap(link->resource[3]->start,=0A 			resource_size(link->resour=
ce[3]));=0A-    if (unlikely(!info->base)) {=0A-	    ret =3D -ENOMEM;=0A-	 =
   goto failed;=0A-    }=0A-=0A     for (i =3D 0; i < (TX_PAGES<<8); i +=3D=
 2)=0A 	__raw_writew((i>>1), info->base+offset+i);=0A     udelay(100);=0A--=
 =0A2.30.2=0A=0A=0AFrom 7dfc3d65a7b5dff41c41ecc8cc7a0d2c86be230a Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:42:40 +0100=0ASubject: [PATCH 095/165] Revert "ALSA: s=
b8: add a check for request_region"=0A=0AThis reverts commit dcd0feac9bab90=
1d5739de51b3f69840851f8919.=0A=0ACommits from @umn.edu addresses have been =
found to be submitted in "bad=0Afaith" to try to test the kernel community'=
s ability to review "known=0Amalicious" changes.  The result of these submi=
ssions can be found in a=0Apaper published at the 42nd IEEE Symposium on Se=
curity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introduc=
ing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Universi=
ty=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause o=
f this, all submissions from this group must be reverted from=0Athe kernel =
tree and will need to be re-reviewed again to determine if=0Athey actually =
are a valid fix.  Until that work is complete, remove this=0Achange to ensu=
re that no problems are being introduced into the=0Acodebase.=0A=0ASigned-o=
ff-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/sb/s=
b8.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/sound/isa=
/sb/sb8.c b/sound/isa/sb/sb8.c=0Aindex 438109f167d6..ae93191ffdc9 100644=0A=
--- a/sound/isa/sb/sb8.c=0A+++ b/sound/isa/sb/sb8.c=0A@@ -96,10 +96,6 @@ st=
atic int snd_sb8_probe(struct device *pdev, unsigned int dev)=0A =0A 	/* bl=
ock the 0x388 port to avoid PnP conflicts */=0A 	acard->fm_res =3D request_=
region(0x388, 4, "SoundBlaster FM");=0A-	if (!acard->fm_res) {=0A-		err =3D=
 -EBUSY;=0A-		goto _err;=0A-	}=0A =0A 	if (port[dev] !=3D SNDRV_AUTO_PORT) =
{=0A 		if ((err =3D snd_sbdsp_create(card, port[dev], irq[dev],=0A-- =0A2.3=
0.2=0A=0A=0AFrom 6b0cda7e013b86b7a0845775e021b3a5dd340ea9 Mon Sep 17 00:00:=
00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 2=
1 Apr 2021 19:42:41 +0100=0ASubject: [PATCH 096/165] Revert "net: fujitsu: =
fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 9f4d6=
358e11bbc7b839f9419636188e4151fb6e4.=0A=0ACommits from @umn.edu addresses h=
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
vers/net/ethernet/fujitsu/fmvj18x_cs.c | 5 -----=0A 1 file changed, 5 delet=
ions(-)=0A=0Adiff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drive=
rs/net/ethernet/fujitsu/fmvj18x_cs.c=0Aindex a7b7a4aace79..dc90c61fc827 100=
644=0A--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c=0A+++ b/drivers/net/e=
thernet/fujitsu/fmvj18x_cs.c=0A@@ -547,11 +547,6 @@ static int fmvj18x_get_=
hwinfo(struct pcmcia_device *link, u_char *node_id)=0A 	return -1;=0A =0A  =
   base =3D ioremap(link->resource[2]->start, resource_size(link->resource[=
2]));=0A-    if (!base) {=0A-	    pcmcia_release_window(link, link->resourc=
e[2]);=0A-	    return -ENOMEM;=0A-    }=0A-=0A     pcmcia_map_mem_page(link=
, link->resource[2], 0);=0A =0A     /*=0A-- =0A2.30.2=0A=0A=0AFrom a47bce67=
07502f367a763de2e21d3a3381d576e8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:41 +0100=
=0ASubject: [PATCH 097/165] Revert "net: qlogic: fix a potential NULL point=
er=0A dereference"=0A=0AThis reverts commit eb32cfcdef2305dc0e44a65d4280131=
5669bb27e.=0A=0ACommits from @umn.edu addresses have been found to be submi=
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
erjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/qla=
3xxx.c | 6 ------=0A 1 file changed, 6 deletions(-)=0A=0Adiff --git a/drive=
rs/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c=0A=
index 27740c027681..7ceaa89cc571 100644=0A--- a/drivers/net/ethernet/qlogic=
/qla3xxx.c=0A+++ b/drivers/net/ethernet/qlogic/qla3xxx.c=0A@@ -3885,12 +388=
5,6 @@ static int ql3xxx_probe(struct pci_dev *pdev,=0A 	netif_stop_queue(n=
dev);=0A =0A 	qdev->workqueue =3D create_singlethread_workqueue(ndev->name)=
;=0A-	if (!qdev->workqueue) {=0A-		unregister_netdev(ndev);=0A-		err =3D -E=
NOMEM;=0A-		goto err_out_iounmap;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&qdev->re=
set_work, ql_reset_work);=0A 	INIT_DELAYED_WORK(&qdev->tx_timeout_work, ql_=
tx_timeout_work);=0A 	INIT_DELAYED_WORK(&qdev->link_state_work, ql_link_sta=
te_machine_work);=0A-- =0A2.30.2=0A=0A=0AFrom c2b8640044382dd8f2ce5f8f9b8f8=
4517630d0c4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:42 +0100=0ASubject: [PATCH 09=
8/165] Revert "md: Fix failed allocation of=0A md_register_thread"=0A=0AThi=
s reverts commit e406f12dde1a8375d77ea02d91f313fb1a9c6aec.=0A=0ACommits fro=
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
il.com>=0A---=0A drivers/md/raid10.c | 2 --=0A drivers/md/raid5.c  | 2 --=
=0A 2 files changed, 4 deletions(-)=0A=0Adiff --git a/drivers/md/raid10.c b=
/drivers/md/raid10.c=0Aindex c5d88ef6a45c..ccc2dfe106bf 100644=0A--- a/driv=
ers/md/raid10.c=0A+++ b/drivers/md/raid10.c=0A@@ -3896,8 +3896,6 @@ static =
int raid10_run(struct mddev *mddev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mdde=
v->recovery);=0A 		mddev->sync_thread =3D md_register_thread(md_do_sync, md=
dev,=0A 							"reshape");=0A-		if (!mddev->sync_thread)=0A-			goto out_fre=
e_conf;=0A 	}=0A =0A 	return 0;=0Adiff --git a/drivers/md/raid5.c b/drivers=
/md/raid5.c=0Aindex 3a90cc0e43ca..53172e8b73b6 100644=0A--- a/drivers/md/ra=
id5.c=0A+++ b/drivers/md/raid5.c=0A@@ -7695,8 +7695,6 @@ static int raid5_r=
un(struct mddev *mddev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery)=
;=0A 		mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,=0A 				=
			"reshape");=0A-		if (!mddev->sync_thread)=0A-			goto abort;=0A 	}=0A =0A=
 	/* Ok, everything is just fine now */=0A-- =0A2.30.2=0A=0A=0AFrom d180b94=
fd955a16af9ebbd737eaf5583f80059d0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:43 +010=
0=0ASubject: [PATCH 099/165] Revert "usb: u132-hcd: fix potential NULL poin=
ter=0A dereference"=0A=0AThis reverts commit 3de3dbe7c13210171ba8411e36b409=
a2c29c7415.=0A=0ACommits from @umn.edu addresses have been found to be subm=
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
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/usb/host/u132-hcd.c | =
2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/usb/host/u=
132-hcd.c b/drivers/usb/host/u132-hcd.c=0Aindex eb96e1e15b71..2b7bcbe2df4b =
100644=0A--- a/drivers/usb/host/u132-hcd.c=0A+++ b/drivers/usb/host/u132-hc=
d.c=0A@@ -3195,8 +3195,6 @@ static int __init u132_hcd_init(void)=0A 		retu=
rn -ENODEV;=0A 	printk(KERN_INFO "driver %s\n", hcd_name);=0A 	workqueue =
=3D create_singlethread_workqueue("u132");=0A-	if (!workqueue)=0A-		return =
-ENOMEM;=0A 	retval =3D platform_driver_register(&u132_platform_driver);=0A=
 	if (retval)=0A 		destroy_workqueue(workqueue);=0A-- =0A2.30.2=0A=0A=0AFro=
m 625c7bee9593e91640009e7798aff4ea17f5f6c5 Mon Sep 17 00:00:00 2001=0AFrom:=
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:4=
2:43 +0100=0ASubject: [PATCH 100/165] Revert "net: rocker: fix a potential =
NULL pointer=0A dereference"=0A=0AThis reverts commit 5c149314d91876f743ee4=
3efd75b6287ec55480e.=0A=0ACommits from @umn.edu addresses have been found t=
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
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/=
rocker/rocker_main.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff =
--git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/ro=
cker/rocker_main.c=0Aindex dd0bc7f0aaee..81cc3f8988f3 100644=0A--- a/driver=
s/net/ethernet/rocker/rocker_main.c=0A+++ b/drivers/net/ethernet/rocker/roc=
ker_main.c=0A@@ -2819,11 +2819,6 @@ static int rocker_switchdev_event(struc=
t notifier_block *unused,=0A 		memcpy(&switchdev_work->fdb_info, ptr,=0A 		=
       sizeof(switchdev_work->fdb_info));=0A 		switchdev_work->fdb_info.add=
r =3D kzalloc(ETH_ALEN, GFP_ATOMIC);=0A-		if (unlikely(!switchdev_work->fdb=
_info.addr)) {=0A-			kfree(switchdev_work);=0A-			return NOTIFY_BAD;=0A-		}=
=0A-=0A 		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,=0A 				fdb_i=
nfo->addr);=0A 		/* Take a reference on the rocker device */=0A-- =0A2.30.2=
=0A=0A=0AFrom e12f9bc69f524953a65906b068636d9697c6bc72 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:44 +0100=0ASubject: [PATCH 101/165] Revert "net: lio_core: fi=
x two NULL pointer=0A dereferences"=0A=0AThis reverts commit 41af8b3a097c6f=
d17a4867efa25966927094f57c.=0A=0ACommits from @umn.edu addresses have been =
found to be submitted in "bad=0Afaith" to try to test the kernel community'=
s ability to review "known=0Amalicious" changes.  The result of these submi=
ssions can be found in a=0Apaper published at the 42nd IEEE Symposium on Se=
curity and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introduc=
ing=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (Universi=
ty=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause o=
f this, all submissions from this group must be reverted from=0Athe kernel =
tree and will need to be re-reviewed again to determine if=0Athey actually =
are a valid fix.  Until that work is complete, remove this=0Achange to ensu=
re that no problems are being introduced into the=0Acodebase.=0A=0ASigned-o=
ff-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/et=
hernet/cavium/liquidio/lio_core.c | 10 ----------=0A 1 file changed, 10 del=
etions(-)=0A=0Adiff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c=
 b/drivers/net/ethernet/cavium/liquidio/lio_core.c=0Aindex 37d064193f0f..f1=
ad34102489 100644=0A--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c=
=0A+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c=0A@@ -1211,11 +121=
1,6 @@ int liquidio_change_mtu(struct net_device *netdev, int new_mtu)=0A =
=0A 	sc =3D (struct octeon_soft_command *)=0A 		octeon_alloc_soft_command(o=
ct, OCTNET_CMD_SIZE, 16, 0);=0A-	if (!sc) {=0A-		netif_info(lio, rx_err, li=
o->netdev,=0A-			   "Failed to allocate soft command\n");=0A-		return -ENOM=
EM;=0A-	}=0A =0A 	ncmd =3D (union octnet_cmd *)sc->virtdptr;=0A =0A@@ -1689=
,11 +1684,6 @@ int liquidio_set_fec(struct lio *lio, int on_off)=0A =0A 	sc=
 =3D octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,=0A 				       sizeof(s=
truct oct_nic_seapi_resp), 0);=0A-	if (!sc) {=0A-		dev_err(&oct->pci_dev->d=
ev,=0A-			"Failed to allocate soft command\n");=0A-		return -ENOMEM;=0A-	}=
=0A =0A 	ncmd =3D sc->virtdptr;=0A 	resp =3D sc->virtrptr;=0A-- =0A2.30.2=
=0A=0A=0AFrom 0b122baca8b75371c78ec559ebfde6d41ba01bef Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:42:45 +0100=0ASubject: [PATCH 102/165] Revert "pppoe: remove red=
undant BUG_ON() check in=0A pppoe_pernet"=0A=0AThis reverts commit 02a896ca=
84874bbfcedc006303f2951dda89b298.=0A=0ACommits from @umn.edu addresses have=
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
net/ppp/pppoe.c | 2 ++=0A 1 file changed, 2 insertions(+)=0A=0Adiff --git a=
/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c=0Aindex d7f50b835050..80=
3a4fe1ca18 100644=0A--- a/drivers/net/ppp/pppoe.c=0A+++ b/drivers/net/ppp/p=
ppoe.c=0A@@ -119,6 +119,8 @@ static inline bool stage_session(__be16 sid)=
=0A =0A static inline struct pppoe_net *pppoe_pernet(struct net *net)=0A {=
=0A+	BUG_ON(!net);=0A+=0A 	return net_generic(net, pppoe_net_id);=0A }=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 6cd46821c7eec02891ab6b6452910948ea8c9503 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:42:45 +0100=0ASubject: [PATCH 103/165] Revert "ne=
t: atm: Reduce the severity of logging in=0A unlink_clip_vcc"=0A=0AThis rev=
erts commit 60f5c4aaae452ae9252128ef7f9ae222aa70c569.=0A=0ACommits from @um=
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
m>=0A---=0A net/atm/clip.c | 6 +++---=0A 1 file changed, 3 insertions(+), 3=
 deletions(-)=0A=0Adiff --git a/net/atm/clip.c b/net/atm/clip.c=0Aindex 294=
cb9efe3d3..a7972da7235d 100644=0A--- a/net/atm/clip.c=0A+++ b/net/atm/clip.=
c=0A@@ -89,7 +89,7 @@ static void unlink_clip_vcc(struct clip_vcc *clip_vcc=
)=0A 	struct clip_vcc **walk;=0A =0A 	if (!entry) {=0A-		pr_err("!clip_vcc-=
>entry (clip_vcc %p)\n", clip_vcc);=0A+		pr_crit("!clip_vcc->entry (clip_vc=
c %p)\n", clip_vcc);=0A 		return;=0A 	}=0A 	netif_tx_lock_bh(entry->neigh->=
dev);	/* block clip_start_xmit() */=0A@@ -109,10 +109,10 @@ static void unl=
ink_clip_vcc(struct clip_vcc *clip_vcc)=0A 			error =3D neigh_update(entry-=
>neigh, NULL, NUD_NONE,=0A 					     NEIGH_UPDATE_F_ADMIN, 0);=0A 			if (er=
ror)=0A-				pr_err("neigh_update failed with %d\n", error);=0A+				pr_crit(=
"neigh_update failed with %d\n", error);=0A 			goto out;=0A 		}=0A-	pr_err(=
"ATMARP: failed (entry %p, vcc 0x%p)\n", entry, clip_vcc);=0A+	pr_crit("ATM=
ARP: failed (entry %p, vcc 0x%p)\n", entry, clip_vcc);=0A out:=0A 	netif_tx=
_unlock_bh(entry->neigh->dev);=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 16985896f70=
427e243277fd5c533a566aee226b5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:46 +0100=0A=
Subject: [PATCH 104/165] Revert "net: ixgbevf: fix a missing check of=0A ix=
gbevf_write_msg_read_ack"=0A=0AThis reverts commit 20d437ee8f4899573e6ea76c=
06ef0206e98bccb6.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/int=
el/ixgbevf/vf.c | 5 +++--=0A 1 file changed, 3 insertions(+), 2 deletions(-=
)=0A=0Adiff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/e=
thernet/intel/ixgbevf/vf.c=0Aindex bfe6dfcec4ab..501823f2d1c0 100644=0A--- =
a/drivers/net/ethernet/intel/ixgbevf/vf.c=0A+++ b/drivers/net/ethernet/inte=
l/ixgbevf/vf.c=0A@@ -508,8 +508,9 @@ static s32 ixgbevf_update_mc_addr_list=
_vf(struct ixgbe_hw *hw,=0A 		vector_list[i++] =3D ixgbevf_mta_vector(hw, h=
a->addr);=0A 	}=0A =0A-	return ixgbevf_write_msg_read_ack(hw, msgbuf, msgbu=
f,=0A-			IXGBE_VFMAILBOX_SIZE);=0A+	ixgbevf_write_msg_read_ack(hw, msgbuf, =
msgbuf, IXGBE_VFMAILBOX_SIZE);=0A+=0A+	return 0;=0A }=0A =0A /**=0A-- =0A2.=
30.2=0A=0A=0AFrom e70ac123c75a5e058889a042426faae38ce3cfb1 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:42:47 +0100=0ASubject: [PATCH 105/165] Revert "thunderbolt: =
property: Fix a NULL pointer=0A dereference"=0A=0AThis reverts commit 10620=
4b56f60abf1bead7dceb88f2be3e34433da.=0A=0ACommits from @umn.edu addresses h=
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
vers/thunderbolt/property.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=
=0Adiff --git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/proper=
ty.c=0Aindex ee76449524a3..b2f0d6386cee 100644=0A--- a/drivers/thunderbolt/=
property.c=0A+++ b/drivers/thunderbolt/property.c=0A@@ -548,11 +548,6 @@ in=
t tb_property_add_data(struct tb_property_dir *parent, const char *key,=0A =
=0A 	property->length =3D size / 4;=0A 	property->value.data =3D kzalloc(si=
ze, GFP_KERNEL);=0A-	if (!property->value.data) {=0A-		kfree(property);=0A-=
		return -ENOMEM;=0A-	}=0A-=0A 	memcpy(property->value.data, buf, buflen);=
=0A =0A 	list_add_tail(&property->list, &parent->properties);=0A-- =0A2.30.=
2=0A=0A=0AFrom 2c5bb170fdf8dc2497e8bdfcc2a64d9c28a8f9ef Mon Sep 17 00:00:00=
 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 =
Apr 2021 19:42:47 +0100=0ASubject: [PATCH 106/165] Revert "tty: mxs-auart: =
fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 67343=
30654dac550f12e932996b868c6d0dcb421.=0A=0ACommits from @umn.edu addresses h=
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
vers/tty/serial/mxs-auart.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=
=0Adiff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-aua=
rt.c=0Aindex 8ecf622602cb..6855fd7b3157 100644=0A--- a/drivers/tty/serial/m=
xs-auart.c=0A+++ b/drivers/tty/serial/mxs-auart.c=0A@@ -1667,10 +1667,6 @@ =
static int mxs_auart_probe(struct platform_device *pdev)=0A =0A 	s->port.ma=
pbase =3D r->start;=0A 	s->port.membase =3D ioremap(r->start, resource_size=
(r));=0A-	if (!s->port.membase) {=0A-		ret =3D -ENOMEM;=0A-		goto out_disab=
le_clks;=0A-	}=0A 	s->port.ops =3D &mxs_auart_ops;=0A 	s->port.iotype =3D U=
PIO_MEM;=0A 	s->port.fifosize =3D MXS_AUART_FIFO_SIZE;=0A-- =0A2.30.2=0A=0A=
=0AFrom 219cc1653d7c788c79e546eb8caaa74abeb2d065 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:48 +0100=0ASubject: [PATCH 107/165] Revert "serial: mvebu-uart: F=
ix to avoid a potential=0A NULL pointer dereference"=0A=0AThis reverts comm=
it 32f47179833b63de72427131169809065db6745e.=0A=0ACommits from @umn.edu add=
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
=0A drivers/tty/serial/mvebu-uart.c | 3 ---=0A 1 file changed, 3 deletions(=
-)=0A=0Adiff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/m=
vebu-uart.c=0Aindex e0c00a1b0763..51b0ecabf2ec 100644=0A--- a/drivers/tty/s=
erial/mvebu-uart.c=0A+++ b/drivers/tty/serial/mvebu-uart.c=0A@@ -818,9 +818=
,6 @@ static int mvebu_uart_probe(struct platform_device *pdev)=0A 		return=
 -EINVAL;=0A 	}=0A =0A-	if (!match)=0A-		return -ENODEV;=0A-=0A 	/* Assume =
that all UART ports have a DT alias or none has */=0A 	id =3D of_alias_get_=
id(pdev->dev.of_node, "serial");=0A 	if (!pdev->dev.of_node || id < 0)=0A--=
 =0A2.30.2=0A=0A=0AFrom d9694b2084190abe992a6c2120120868fcfac3e9 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:42:49 +0100=0ASubject: [PATCH 108/165] Revert "ALSA: u=
sx2y: Fix potential NULL pointer=0A dereference"=0A=0AThis reverts commit a=
2c6433ee5a35a8de6d563f6512a26f87835ea0f.=0A=0ACommits from @umn.edu address=
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
=0A sound/usb/usx2y/usb_stream.c | 5 -----=0A 1 file changed, 5 deletions(-=
)=0A=0Adiff --git a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stre=
am.c=0Aindex 091c071b270a..6bba17bf689a 100644=0A--- a/sound/usb/usx2y/usb_=
stream.c=0A+++ b/sound/usb/usx2y/usb_stream.c=0A@@ -91,12 +91,7 @@ static i=
nt init_urbs(struct usb_stream_kernel *sk, unsigned use_packsize,=0A =0A 	f=
or (u =3D 0; u < USB_STREAM_NURBS; ++u) {=0A 		sk->inurb[u] =3D usb_alloc_u=
rb(sk->n_o_ps, GFP_KERNEL);=0A-		if (!sk->inurb[u])=0A-			return -ENOMEM;=
=0A-=0A 		sk->outurb[u] =3D usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);=0A-		if =
(!sk->outurb[u])=0A-			return -ENOMEM;=0A 	}=0A =0A 	if (init_pipe_urbs(sk,=
 use_packsize, sk->inurb, indata, dev, in_pipe) ||=0A-- =0A2.30.2=0A=0A=0AF=
rom 0fd988be067b7ced2e9f39ceae717cdae9dcbd94 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19=
:42:49 +0100=0ASubject: [PATCH 109/165] Revert "qlcnic: Avoid potential NUL=
L pointer=0A dereference"=0A=0AThis reverts commit 5bf7295fe34a5251b1d241b9=
736af4697b590670.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlo=
gic/qlcnic/qlcnic_ethtool.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Ad=
iff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/n=
et/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0Aindex d8a3ecaed3fc..985cf8cb2e=
c0 100644=0A--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A+++=
 b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A@@ -1047,8 +1047,6=
 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)=0A =0A 	=
for (i =3D 0; i < QLCNIC_NUM_ILB_PKT; i++) {=0A 		skb =3D netdev_alloc_skb(=
adapter->netdev, QLCNIC_ILB_PKT_SIZE);=0A-		if (!skb)=0A-			break;=0A 		qlc=
nic_create_loopback_buff(skb->data, adapter->mac_addr);=0A 		skb_put(skb, Q=
LCNIC_ILB_PKT_SIZE);=0A 		adapter->ahw->diag_cnt =3D 0;=0A-- =0A2.30.2=0A=
=0A=0AFrom 2879916d122fb1f5a016644e7703c7eeecb05543 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:42:50 +0100=0ASubject: [PATCH 110/165] Revert "tty: atmel_serial: f=
ix a potential NULL=0A pointer dereference"=0A=0AThis reverts commit c85be0=
41065c0be8bc48eda4c45e0319caf1d0e5.=0A=0ACommits from @umn.edu addresses ha=
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
s/tty/serial/atmel_serial.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=
=0Adiff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atme=
l_serial.c=0Aindex a24e5c2b30bc..9786d8e5f04f 100644=0A--- a/drivers/tty/se=
rial/atmel_serial.c=0A+++ b/drivers/tty/serial/atmel_serial.c=0A@@ -1256,10=
 +1256,6 @@ static int atmel_prepare_rx_dma(struct uart_port *port)=0A 				=
	 sg_dma_len(&atmel_port->sg_rx)/2,=0A 					 DMA_DEV_TO_MEM,=0A 					 DMA_P=
REP_INTERRUPT);=0A-	if (!desc) {=0A-		dev_err(port->dev, "Preparing DMA cyc=
lic failed\n");=0A-		goto chan_err;=0A-	}=0A 	desc->callback =3D atmel_comp=
lete_rx_dma;=0A 	desc->callback_param =3D port;=0A 	atmel_port->desc_rx =3D=
 desc;=0A-- =0A2.30.2=0A=0A=0AFrom 5a779ed1a3074e13c3149505aeb6f587eb55ef7d=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 19:42:51 +0100=0ASubject: [PATCH 111/165] Reve=
rt "libertas: add checks for the return value of=0A sysfs_create_group"=0A=
=0AThis reverts commit 434256833d8eb988cb7f3b8a41699e2fe48d9332.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/net/wireless/marvell/libertas/mesh.c | 5 ---=
--=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless=
/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c=0Ai=
ndex f5b78257d551..c611e6668b21 100644=0A--- a/drivers/net/wireless/marvell=
/libertas/mesh.c=0A+++ b/drivers/net/wireless/marvell/libertas/mesh.c=0A@@ =
-805,12 +805,7 @@ static void lbs_persist_config_init(struct net_device *de=
v)=0A {=0A 	int ret;=0A 	ret =3D sysfs_create_group(&(dev->dev.kobj), &boot=
_opts_group);=0A-	if (ret)=0A-		pr_err("failed to create boot_opts_group.\n=
");=0A-=0A 	ret =3D sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);=
=0A-	if (ret)=0A-		pr_err("failed to create mesh_ie_group.\n");=0A }=0A =0A=
 static void lbs_persist_config_remove(struct net_device *dev)=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 8bb7ff1326f36d7ee7fe3dad0537635f0a5065f1 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:42:51 +0100=0ASubject: [PATCH 112/165] Revert "usb: sierra: =
fix a missing check of=0A device_create_file"=0A=0AThis reverts commit 1a13=
7b47ce6bd4f4b14662d2f5ace913ea7ffbf8.=0A=0ACommits from @umn.edu addresses =
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
drivers/usb/storage/sierra_ms.c | 4 +++-=0A 1 file changed, 3 insertions(+)=
, 1 deletion(-)=0A=0Adiff --git a/drivers/usb/storage/sierra_ms.c b/drivers=
/usb/storage/sierra_ms.c=0Aindex b9f78ef3edc3..0f5c9cd8535f 100644=0A--- a/=
drivers/usb/storage/sierra_ms.c=0A+++ b/drivers/usb/storage/sierra_ms.c=0A@=
@ -190,6 +190,8 @@ int sierra_ms_init(struct us_data *us)=0A 		kfree(swocIn=
fo);=0A 	}=0A complete:=0A-	return device_create_file(&us->pusb_intf->dev, =
&dev_attr_truinst);=0A+	result =3D device_create_file(&us->pusb_intf->dev, =
&dev_attr_truinst);=0A+=0A+	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom =
650f6adb74c0430ee3b53e889503a0e7f6240d73 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:=
52 +0100=0ASubject: [PATCH 113/165] Revert "scsi: qla4xxx: fix a potential =
NULL pointer=0A dereference"=0A=0AThis reverts commit fba1bdd2a9a93f3e2181e=
c1936a3c2f6b37e7ed6.=0A=0ACommits from @umn.edu addresses have been found t=
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
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/qla4xxx/=
ql4_os.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers=
/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c=0Aindex a4b014e1cd8c=
=2E.3ce02f0a11f7 100644=0A--- a/drivers/scsi/qla4xxx/ql4_os.c=0A+++ b/drive=
rs/scsi/qla4xxx/ql4_os.c=0A@@ -3229,8 +3229,6 @@ static int qla4xxx_conn_bi=
nd(struct iscsi_cls_session *cls_session,=0A 	if (iscsi_conn_bind(cls_sessi=
on, cls_conn, is_leading))=0A 		return -EINVAL;=0A 	ep =3D iscsi_lookup_end=
point(transport_fd);=0A-	if (!ep)=0A-		return -EINVAL;=0A 	conn =3D cls_con=
n->dd_data;=0A 	qla_conn =3D conn->dd_data;=0A 	qla_conn->qla_ep =3D ep->dd=
_data;=0A-- =0A2.30.2=0A=0A=0AFrom f581cb45762e16e1c62db359eb2b1f8cef3bb818=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 19:42:53 +0100=0ASubject: [PATCH 114/165] Reve=
rt "libnvdimm/btt: Fix a kmemdup failure check"=0A=0AThis reverts commit 48=
6fa92df4707b5df58d6508728bdb9321a59766.=0A=0ACommits from @umn.edu addresse=
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
drivers/nvdimm/btt_devs.c | 18 +++++-------------=0A 1 file changed, 5 inse=
rtions(+), 13 deletions(-)=0A=0Adiff --git a/drivers/nvdimm/btt_devs.c b/dr=
ivers/nvdimm/btt_devs.c=0Aindex 05feb97e11ce..995573905dfb 100644=0A--- a/d=
rivers/nvdimm/btt_devs.c=0A+++ b/drivers/nvdimm/btt_devs.c=0A@@ -191,15 +19=
1,14 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,=
=0A 		return NULL;=0A =0A 	nd_btt->id =3D ida_simple_get(&nd_region->btt_id=
a, 0, 0, GFP_KERNEL);=0A-	if (nd_btt->id < 0)=0A-		goto out_nd_btt;=0A+	if =
(nd_btt->id < 0) {=0A+		kfree(nd_btt);=0A+		return NULL;=0A+	}=0A =0A 	nd_b=
tt->lbasize =3D lbasize;=0A-	if (uuid) {=0A+	if (uuid)=0A 		uuid =3D kmemdu=
p(uuid, 16, GFP_KERNEL);=0A-		if (!uuid)=0A-			goto out_put_id;=0A-	}=0A 	n=
d_btt->uuid =3D uuid;=0A 	dev =3D &nd_btt->dev;=0A 	dev_set_name(dev, "btt%=
d.%d", nd_region->id, nd_btt->id);=0A@@ -213,13 +212,6 @@ static struct dev=
ice *__nd_btt_create(struct nd_region *nd_region,=0A 		return NULL;=0A 	}=
=0A 	return dev;=0A-=0A-out_put_id:=0A-	ida_simple_remove(&nd_region->btt_i=
da, nd_btt->id);=0A-=0A-out_nd_btt:=0A-	kfree(nd_btt);=0A-	return NULL;=0A =
}=0A =0A struct device *nd_btt_create(struct nd_region *nd_region)=0A-- =0A=
2.30.2=0A=0A=0AFrom c322ff8da1f187e09420e0d31012451756cb2944 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 19:42:53 +0100=0ASubject: [PATCH 115/165] Revert "x86/hpet: P=
revent potential NULL pointer=0A dereference"=0A=0AThis reverts commit 2e84=
f116afca3719c9d0a1a78b47b48f75fd5724.=0A=0ACommits from @umn.edu addresses =
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
arch/x86/kernel/hpet.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff -=
-git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c=0Aindex 08651a4e6aa0=
=2E.0515a97bf6f5 100644=0A--- a/arch/x86/kernel/hpet.c=0A+++ b/arch/x86/ker=
nel/hpet.c=0A@@ -930,8 +930,6 @@ int __init hpet_enable(void)=0A 		return 0=
;=0A =0A 	hpet_set_mapping();=0A-	if (!hpet_virt_address)=0A-		return 0;=0A=
 =0A 	/* Validate that the config register is working */=0A 	if (!hpet_cfg_=
working())=0A-- =0A2.30.2=0A=0A=0AFrom 053f788cdd762e41c1e93889e4c98609968f=
4aba Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gma=
il.com>=0ADate: Wed, 21 Apr 2021 19:42:54 +0100=0ASubject: [PATCH 116/165] =
Revert "staging: rtl8188eu: Fix potential NULL=0A pointer dereference of kc=
alloc"=0A=0AThis reverts commit 7671ce0d92933762f469266daf43bd34d422d58c.=
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
u/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0Aindex 31735=
5f830cb..580a3678acc6 100644=0A--- a/drivers/staging/rtl8188eu/core/rtw_xmi=
t.c=0A+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c=0A@@ -174,9 +174,7 @@=
 s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padap=
ter)=0A =0A 	pxmitpriv->free_xmit_extbuf_cnt =3D num_xmit_extbuf;=0A =0A-	r=
es =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _FAIL)=0A-		goto exi=
t;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(pxmitpriv->hwxmits=
, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; i++)=0A@@ -1505,7 =
+1503,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_fr=
ame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_alloc_hwxmits(struct a=
dapter *padapter)=0A+void rtw_alloc_hwxmits(struct adapter *padapter)=0A {=
=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmitpriv =3D &padapter=
->xmitpriv;=0A@@ -1514,8 +1512,6 @@ s32 rtw_alloc_hwxmits(struct adapter *p=
adapter)=0A =0A 	pxmitpriv->hwxmits =3D kcalloc(pxmitpriv->hwxmit_entry,=0A=
 				     sizeof(struct hw_xmit), GFP_KERNEL);=0A-	if (!pxmitpriv->hwxmits)=
=0A-		return _FAIL;=0A =0A 	hwxmits =3D pxmitpriv->hwxmits;=0A =0A@@ -1523,=
7 +1519,6 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A 	hwxmits[1]=
 .sta_queue =3D &pxmitpriv->vi_pending;=0A 	hwxmits[2] .sta_queue =3D &pxmi=
tpriv->be_pending;=0A 	hwxmits[3] .sta_queue =3D &pxmitpriv->bk_pending;=0A=
-	return _SUCCESS;=0A }=0A =0A void rtw_free_hwxmits(struct adapter *padapt=
er)=0Adiff --git a/drivers/staging/rtl8188eu/include/rtw_xmit.h b/drivers/s=
taging/rtl8188eu/include/rtw_xmit.h=0Aindex 456fd52717f3..59490a447382 1006=
44=0A--- a/drivers/staging/rtl8188eu/include/rtw_xmit.h=0A+++ b/drivers/sta=
ging/rtl8188eu/include/rtw_xmit.h=0A@@ -330,7 +330,7 @@ s32 rtw_txframes_st=
a_ac_pending(struct adapter *padapter,=0A void rtw_init_hwxmits(struct hw_x=
mit *phwxmit, int entry);=0A s32 _rtw_init_xmit_priv(struct xmit_priv *pxmi=
tpriv, struct adapter *padapter);=0A void _rtw_free_xmit_priv(struct xmit_p=
riv *pxmitpriv);=0A-s32 rtw_alloc_hwxmits(struct adapter *padapter);=0A+voi=
d rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_free_hwxmits(str=
uct adapter *padapter);=0A s32 rtw_xmit(struct adapter *padapter, struct sk=
_buff **pkt);=0A =0Adiff --git a/drivers/staging/rtl8723bs/core/rtw_xmit.c =
b/drivers/staging/rtl8723bs/core/rtw_xmit.c=0Aindex 41632fa0b3c8..9b1b8add3=
4e1 100644=0A--- a/drivers/staging/rtl8723bs/core/rtw_xmit.c=0A+++ b/driver=
s/staging/rtl8723bs/core/rtw_xmit.c=0A@@ -248,9 +248,7 @@ s32 _rtw_init_xmi=
t_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)=0A 		}=0A 	}=
=0A =0A-	res =3D rtw_alloc_hwxmits(padapter);=0A-	if (res =3D=3D _FAIL)=0A-=
		goto exit;=0A+	rtw_alloc_hwxmits(padapter);=0A 	rtw_init_hwxmits(pxmitpri=
v->hwxmits, pxmitpriv->hwxmit_entry);=0A =0A 	for (i =3D 0; i < 4; i++)=0A@=
@ -1990,7 +1988,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, stru=
ct xmit_frame *pxmitframe)=0A 	return res;=0A }=0A =0A-s32 rtw_alloc_hwxmit=
s(struct adapter *padapter)=0A+void rtw_alloc_hwxmits(struct adapter *padap=
ter)=0A {=0A 	struct hw_xmit *hwxmits;=0A 	struct xmit_priv *pxmitpriv =3D =
&padapter->xmitpriv;=0A@@ -2001,8 +1999,10 @@ s32 rtw_alloc_hwxmits(struct =
adapter *padapter)=0A =0A 	pxmitpriv->hwxmits =3D rtw_zmalloc(sizeof(struct=
 hw_xmit) * pxmitpriv->hwxmit_entry);=0A =0A-	if (!pxmitpriv->hwxmits)=0A-	=
	return _FAIL;=0A+	if (pxmitpriv->hwxmits =3D=3D NULL) {=0A+		DBG_871X("all=
oc hwxmits fail!...\n");=0A+		return;=0A+	}=0A =0A 	hwxmits =3D pxmitpriv->=
hwxmits;=0A =0A@@ -2027,7 +2027,7 @@ s32 rtw_alloc_hwxmits(struct adapter *=
padapter)=0A 	} else {=0A 	}=0A =0A-	return _SUCCESS;=0A+=0A }=0A =0A void =
rtw_free_hwxmits(struct adapter *padapter)=0Adiff --git a/drivers/staging/r=
tl8723bs/include/rtw_xmit.h b/drivers/staging/rtl8723bs/include/rtw_xmit.h=
=0Aindex c04318573f8f..9f25ff77aa2c 100644=0A--- a/drivers/staging/rtl8723b=
s/include/rtw_xmit.h=0A+++ b/drivers/staging/rtl8723bs/include/rtw_xmit.h=
=0A@@ -483,7 +483,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv,=
 struct adapter *padapter);=0A void _rtw_free_xmit_priv(struct xmit_priv *p=
xmitpriv);=0A =0A =0A-s32 rtw_alloc_hwxmits(struct adapter *padapter);=0A+v=
oid rtw_alloc_hwxmits(struct adapter *padapter);=0A void rtw_free_hwxmits(s=
truct adapter *padapter);=0A =0A =0A-- =0A2.30.2=0A=0A=0AFrom 80122db7eeeb1=
f56ecf2a4f16b9448c9e102421e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:55 +0100=0ASu=
bject: [PATCH 117/165] Revert "misc/ics932s401: Add a missing check to=0A i=
2c_smbus_read_word_data"=0A=0AThis reverts commit b05ae01fdb8966afff5b153e7=
a7ee24684745e2d.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/misc/ics932s401.c=
 | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/misc/ic=
s932s401.c b/drivers/misc/ics932s401.c=0Aindex 2bdf560ee681..733e5c2b57ce 1=
00644=0A--- a/drivers/misc/ics932s401.c=0A+++ b/drivers/misc/ics932s401.c=
=0A@@ -133,8 +133,6 @@ static struct ics932s401_data *ics932s401_update_dev=
ice(struct device *dev)=0A 	 */=0A 	for (i =3D 0; i < NUM_MIRRORED_REGS; i+=
+) {=0A 		temp =3D i2c_smbus_read_word_data(client, regs_to_copy[i]);=0A-		=
if (temp < 0)=0A-			data->regs[regs_to_copy[i]] =3D 0;=0A 		data->regs[regs=
_to_copy[i]] =3D temp >> 8;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 8b3e0a135=
936cb944aa1898330d4128dcd47db72 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukh=
erjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:55 +0100=
=0ASubject: [PATCH 118/165] Revert "media: usb: gspca: add a missed return-=
value=0A check for do_command"=0A=0AThis reverts commit 5ceaf5452c1b2a452da=
daf377f9f07af7bda9cc3.=0A=0ACommits from @umn.edu addresses have been found=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/us=
b/gspca/cpia1.c | 8 ++------=0A 1 file changed, 2 insertions(+), 6 deletion=
s(-)=0A=0Adiff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/=
gspca/cpia1.c=0Aindex a4f7431486f3..5ee749e05267 100644=0A--- a/drivers/med=
ia/usb/gspca/cpia1.c=0A+++ b/drivers/media/usb/gspca/cpia1.c=0A@@ -537,14 +=
537,10 @@ static int do_command(struct gspca_dev *gspca_dev, u16 command,=
=0A 		}=0A 		if (sd->params.qx3.button) {=0A 			/* button pressed - unlock =
the latch */=0A-			ret =3D do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,=
=0A+			do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,=0A 				   3, 0xdf, 0=
xdf, 0);=0A-			if (ret)=0A-				return ret;=0A-			ret =3D do_command(gspca_d=
ev, CPIA_COMMAND_WriteMCPort,=0A+			do_command(gspca_dev, CPIA_COMMAND_Writ=
eMCPort,=0A 				   3, 0xff, 0xff, 0);=0A-			if (ret)=0A-				return ret;=0A =
		}=0A =0A 		/* test whether microscope is cradled */=0A-- =0A2.30.2=0A=0A=
=0AFrom 3c14499e3fac65a5561dae40f1e26dc0889d9459 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:42:56 +0100=0ASubject: [PATCH 119/165] Revert "ath6kl: return error =
code in=0A ath6kl_wmi_set_roam_lrssi_cmd()"=0A=0AThis reverts commit fc6a65=
21556c8250e356ddc6a3f2391aa62dc976.=0A=0ACommits from @umn.edu addresses ha=
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
s/net/wireless/ath/ath6kl/wmi.c | 4 +++-=0A 1 file changed, 3 insertions(+)=
, 1 deletion(-)=0A=0Adiff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/d=
rivers/net/wireless/ath/ath6kl/wmi.c=0Aindex b137e7f34397..aca9732ec1ee 100=
644=0A--- a/drivers/net/wireless/ath/ath6kl/wmi.c=0A+++ b/drivers/net/wirel=
ess/ath/ath6kl/wmi.c=0A@@ -776,8 +776,10 @@ int ath6kl_wmi_set_roam_lrssi_c=
md(struct wmi *wmi, u8 lrssi)=0A 	cmd->info.params.roam_rssi_floor =3D DEF_=
LRSSI_ROAM_FLOOR;=0A 	cmd->roam_ctrl =3D WMI_SET_LRSSI_SCAN_PARAMS;=0A =0A-=
	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,=0A+	ath6k=
l_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,=0A 			    NO_SYNC_WMIF=
LAG);=0A+=0A+	return 0;=0A }=0A =0A int ath6kl_wmi_force_roam_cmd(struct wm=
i *wmi, const u8 *bssid)=0A-- =0A2.30.2=0A=0A=0AFrom 8dff0fadaa0869e9de6853=
3747fac978d1c0e1eb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:57 +0100=0ASubject: =
[PATCH 120/165] Revert "Input: ad7879 - add check for read errors in=0A int=
errupt"=0A=0AThis reverts commit e85bb0beb6498c0dffe18a2f1f16d575bc175c32.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/input/touchscreen/ad7879.c |=
 11 ++++-------=0A 1 file changed, 4 insertions(+), 7 deletions(-)=0A=0Adif=
f --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad=
7879.c=0Aindex e850853328f1..8c4f3c193550 100644=0A--- a/drivers/input/touc=
hscreen/ad7879.c=0A+++ b/drivers/input/touchscreen/ad7879.c=0A@@ -245,14 +2=
45,11 @@ static void ad7879_timer(struct timer_list *t)=0A static irqreturn=
_t ad7879_irq(int irq, void *handle)=0A {=0A 	struct ad7879 *ts =3D handle;=
=0A-	int error;=0A =0A-	error =3D regmap_bulk_read(ts->regmap, AD7879_REG_X=
PLUS,=0A-				 ts->conversion_data, AD7879_NR_SENSE);=0A-	if (error)=0A-		de=
v_err_ratelimited(ts->dev, "failed to read %#02x: %d\n",=0A-				    AD7879_=
REG_XPLUS, error);=0A-	else if (!ad7879_report(ts))=0A+	regmap_bulk_read(ts=
->regmap, AD7879_REG_XPLUS,=0A+			 ts->conversion_data, AD7879_NR_SENSE);=
=0A+=0A+	if (!ad7879_report(ts))=0A 		mod_timer(&ts->timer, jiffies + TS_PE=
N_UP_TIMEOUT);=0A =0A 	return IRQ_HANDLED;=0A-- =0A2.30.2=0A=0A=0AFrom b747=
5ab9cc42803161382575b3b98fe607e8502b Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:57 +=
0100=0ASubject: [PATCH 121/165] Revert "serial: max310x: pass return value =
of=0A spi_register_driver"=0A=0AThis reverts commit 51f689cc11333944c7a457f=
25ec75fcb41e99410.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/tty/serial/max3=
10x.c | 4 ++--=0A 1 file changed, 2 insertions(+), 2 deletions(-)=0A=0Adiff=
 --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c=0Ainde=
x 1b61d26bb7af..93f69b66b896 100644=0A--- a/drivers/tty/serial/max310x.c=0A=
+++ b/drivers/tty/serial/max310x.c=0A@@ -1518,10 +1518,10 @@ static int __i=
nit max310x_uart_init(void)=0A 		return ret;=0A =0A #ifdef CONFIG_SPI_MASTE=
R=0A-	ret =3D spi_register_driver(&max310x_spi_driver);=0A+	spi_register_dr=
iver(&max310x_spi_driver);=0A #endif=0A =0A-	return ret;=0A+	return 0;=0A }=
=0A module_init(max310x_uart_init);=0A =0A-- =0A2.30.2=0A=0A=0AFrom b07f1fe=
04069b88a484c19b15b34145091da4dce Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:58 +010=
0=0ASubject: [PATCH 122/165] Revert "ALSA: gus: add a check of the status o=
f=0A snd_ctl_add"=0A=0AThis reverts commit 0f25e000cb4398081748e54f62a90209=
8aa79ec1.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/gus/gus_main.c | 13 ++=
-----------=0A 1 file changed, 2 insertions(+), 11 deletions(-)=0A=0Adiff -=
-git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c=0Aindex afc088f0=
377c..b7518122a10d 100644=0A--- a/sound/isa/gus/gus_main.c=0A+++ b/sound/is=
a/gus/gus_main.c=0A@@ -77,17 +77,8 @@ static const struct snd_kcontrol_new =
snd_gus_joystick_control =3D {=0A =0A static void snd_gus_init_control(stru=
ct snd_gus_card *gus)=0A {=0A-	int ret;=0A-=0A-	if (!gus->ace_flag) {=0A-		=
ret =3D=0A-			snd_ctl_add(gus->card,=0A-					snd_ctl_new1(&snd_gus_joystick=
_control,=0A-						gus));=0A-		if (ret)=0A-			snd_printk(KERN_ERR "gus: snd=
_ctl_add failed: %d\n",=0A-					ret);=0A-	}=0A+	if (!gus->ace_flag)=0A+		sn=
d_ctl_add(gus->card, snd_ctl_new1(&snd_gus_joystick_control, gus));=0A }=0A=
 =0A /*=0A-- =0A2.30.2=0A=0A=0AFrom 0de75c8a7bfba1cd01b98db56dda42d3969f330=
d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 19:42:59 +0100=0ASubject: [PATCH 123/165] Rev=
ert "Staging: rts5208: Fix error handling on=0A rtsx_send_cmd"=0A=0AThis re=
verts commit c8c2702409430a6a2fd928e857f15773aaafcc99.=0A=0ACommits from @u=
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
om>=0A---=0A drivers/staging/rts5208/sd.c | 7 +------=0A 1 file changed, 1 =
insertion(+), 6 deletions(-)=0A=0Adiff --git a/drivers/staging/rts5208/sd.c=
 b/drivers/staging/rts5208/sd.c=0Aindex 25c31496757e..63f5465a6eeb 100644=
=0A--- a/drivers/staging/rts5208/sd.c=0A+++ b/drivers/staging/rts5208/sd.c=
=0A@@ -4424,12 +4424,7 @@ int sd_execute_write_data(struct scsi_cmnd *srb, =
struct rtsx_chip *chip)=0A 		rtsx_init_cmd(chip);=0A 		rtsx_add_cmd(chip, C=
HECK_REG_CMD, 0xFD30, 0x02, 0x02);=0A =0A-		retval =3D rtsx_send_cmd(chip, =
SD_CARD, 250);=0A-		if (retval < 0) {=0A-			write_err =3D true;=0A-			rtsx_=
clear_sd_error(chip);=0A-			goto sd_execute_write_cmd_failed;=0A-		}=0A+		r=
tsx_send_cmd(chip, SD_CARD, 250);=0A =0A 		retval =3D sd_update_lock_status=
(chip);=0A 		if (retval !=3D STATUS_SUCCESS) {=0A-- =0A2.30.2=0A=0A=0AFrom =
a7198d36d2fd2a7d7d32b77ed62334be5e700bf3 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:42:=
59 +0100=0ASubject: [PATCH 124/165] Revert "staging: rts5208: Add a check f=
or=0A ms_read_extra_data"=0A=0AThis reverts commit 73b69c01cc925d9c48e5b4f7=
8e3d8b88c4e5b924.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/rts5208/=
ms.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff =
--git a/drivers/staging/rts5208/ms.c b/drivers/staging/rts5208/ms.c=0Aindex=
 9001570a8c94..37b60ba1bdfe 100644=0A--- a/drivers/staging/rts5208/ms.c=0A+=
++ b/drivers/staging/rts5208/ms.c=0A@@ -1665,10 +1665,7 @@ static int ms_co=
py_page(struct rtsx_chip *chip, u16 old_blk, u16 new_blk,=0A 			return STAT=
US_FAIL;=0A 		}=0A =0A-		retval =3D ms_read_extra_data(chip, old_blk, i, ex=
tra,=0A-					    MS_EXTRA_SIZE);=0A-		if (retval !=3D STATUS_SUCCESS)=0A-		=
	return STATUS_FAIL;=0A+		ms_read_extra_data(chip, old_blk, i, extra, MS_EX=
TRA_SIZE);=0A =0A 		retval =3D ms_set_rw_reg_addr(chip, OVERWRITE_FLAG,=0A =
					    MS_EXTRA_SIZE, SYSTEM_PARAM, 6);=0A-- =0A2.30.2=0A=0A=0AFrom ea04d=
906f3b2e03a3f036f48dbe2b1ee02ad1aa4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:00 +0=
100=0ASubject: [PATCH 125/165] Revert "dmaengine: qcom_hidma: Check for dri=
ver=0A register failure"=0A=0AThis reverts commit a474b3f0428d6b02a538aa10b=
3c3b722751cb382.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/dma/qcom/hidma_mg=
mt.c | 3 ++-=0A 1 file changed, 2 insertions(+), 1 deletion(-)=0A=0Adiff --=
git a/drivers/dma/qcom/hidma_mgmt.c b/drivers/dma/qcom/hidma_mgmt.c=0Aindex=
 806ca02c52d7..fe87b01f7a4e 100644=0A--- a/drivers/dma/qcom/hidma_mgmt.c=0A=
+++ b/drivers/dma/qcom/hidma_mgmt.c=0A@@ -418,8 +418,9 @@ static int __init=
 hidma_mgmt_init(void)=0A 		hidma_mgmt_of_populate_channels(child);=0A 	}=
=0A #endif=0A-	return platform_driver_register(&hidma_mgmt_driver);=0A+	pla=
tform_driver_register(&hidma_mgmt_driver);=0A =0A+	return 0;=0A }=0A module=
_init(hidma_mgmt_init);=0A MODULE_LICENSE("GPL v2");=0A-- =0A2.30.2=0A=0A=
=0AFrom 15212fd0cc5624e44f74f6d03c48b1df82ea050d Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:43:01 +0100=0ASubject: [PATCH 126/165] Revert "leds: lp5523: fix a m=
issing check of return=0A value of lp55xx_read"=0A=0AThis reverts commit 24=
8b57015f35c94d4eae2fdd8c6febf5cd703900.=0A=0ACommits from @umn.edu addresse=
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
drivers/leds/leds-lp5523.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 de=
letions(-)=0A=0Adiff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds=
-lp5523.c=0Aindex fc433e63b1dc..5036d7d5f3d4 100644=0A--- a/drivers/leds/le=
ds-lp5523.c=0A+++ b/drivers/leds/leds-lp5523.c=0A@@ -305,9 +305,7 @@ static=
 int lp5523_init_program_engine(struct lp55xx_chip *chip)=0A =0A 	/* Let th=
e programs run for couple of ms and check the engine status */=0A 	usleep_r=
ange(3000, 6000);=0A-	ret =3D lp55xx_read(chip, LP5523_REG_STATUS, &status)=
;=0A-	if (ret)=0A-		return ret;=0A+	lp55xx_read(chip, LP5523_REG_STATUS, &s=
tatus);=0A 	status &=3D LP5523_ENG_STATUS_MASK;=0A =0A 	if (status !=3D LP5=
523_ENG_STATUS_MASK) {=0A-- =0A2.30.2=0A=0A=0AFrom 559f849fb63231086840ef0c=
0f9cbc358784cc01 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:01 +0100=0ASubject: [PAT=
CH 127/165] Revert "iio: ad9523: fix a missing check of return=0A value"=0A=
=0AThis reverts commit ae0b3773721f08526c850e2d8dec85bdb870cd12.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/iio/frequency/ad9523.c | 7 ++-----=0A 1 file=
 changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/iio/fre=
quency/ad9523.c b/drivers/iio/frequency/ad9523.c=0Aindex bdb0bc3b12dd..91eb=
47e27db0 100644=0A--- a/drivers/iio/frequency/ad9523.c=0A+++ b/drivers/iio/=
frequency/ad9523.c=0A@@ -944,14 +944,11 @@ static int ad9523_setup(struct i=
io_dev *indio_dev)=0A 		}=0A 	}=0A =0A-	for_each_clear_bit(i, &active_mask,=
 AD9523_NUM_CHAN) {=0A-		ret =3D ad9523_write(indio_dev,=0A+	for_each_clear=
_bit(i, &active_mask, AD9523_NUM_CHAN)=0A+		ad9523_write(indio_dev,=0A 			 =
    AD9523_CHANNEL_CLOCK_DIST(i),=0A 			     AD9523_CLK_DIST_DRIVER_MODE(TR=
ISTATE) |=0A 			     AD9523_CLK_DIST_PWR_DOWN_EN);=0A-		if (ret < 0)=0A-			=
return ret;=0A-	}=0A =0A 	ret =3D ad9523_write(indio_dev, AD9523_POWER_DOWN=
_CTRL, 0);=0A 	if (ret < 0)=0A-- =0A2.30.2=0A=0A=0AFrom 4d928c1f9ea059f02be=
aa88764c916330f539698 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:02 +0100=0ASubject:=
 [PATCH 128/165] Revert "mfd: mc13xxx: Fix a missing check of a=0A register=
-read failure"=0A=0AThis reverts commit 9e28989d41c0eab57ec0bb156617a875740=
6ff8a.=0A=0ACommits from @umn.edu addresses have been found to be submitted=
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
e <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mfd/mc13xxx-core.c | 4 +---=
=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/driver=
s/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c=0Aindex 1abe7432aad8..b2b=
eb7c39cc5 100644=0A--- a/drivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/mc1=
3xxx-core.c=0A@@ -271,9 +271,7 @@ int mc13xxx_adc_do_conversion(struct mc13=
xxx *mc13xxx, unsigned int mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_ADC=
_WORKING;=0A =0A-	ret =3D mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0=
);=0A-	if (ret)=0A-		goto out;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, =
&old_adc0);=0A =0A 	adc0 =3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=0A=
 	       MC13XXX_ADC0_CHRGRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom 5c4ea25a2e217=
3b796e259ef942e694217265fcb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:03 +0100=0ASu=
bject: [PATCH 129/165] Revert "gdrom: fix a memory leak bug"=0A=0AThis reve=
rts commit 093c48213ee37c3c3ff1cf5ac1aa2a9d8bc66017.=0A=0ACommits from @umn=
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
om>=0A---=0A drivers/cdrom/gdrom.c | 1 -=0A 1 file changed, 1 deletion(-)=
=0A=0Adiff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 98=
74fc1c815b..466fc3eee8bb 100644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/drive=
rs/cdrom/gdrom.c=0A@@ -863,7 +863,6 @@ static void __exit exit_gdrom(void)=
=0A 	platform_device_unregister(pd);=0A 	platform_driver_unregister(&gdrom_=
driver);=0A 	kfree(gd.toc);=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(=
init_gdrom);=0A-- =0A2.30.2=0A=0A=0AFrom d20c48a1a0dc3afffe1d9edf65b7d23280=
35f380 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 19:43:03 +0100=0ASubject: [PATCH 130/165=
] Revert "net: marvell: fix a missing check of=0A acpi_match_device"=0A=0AT=
his reverts commit 92ee77d148bf06d8c52664be4d1b862583fd5c0e.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 --=
=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/m=
arvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=
=0Aindex e6f9b5345b70..83bc9ad1cac9 100644=0A--- a/drivers/net/ethernet/mar=
vell/mvpp2/mvpp2_main.c=0A+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_ma=
in.c=0A@@ -6872,8 +6872,6 @@ static int mvpp2_probe(struct platform_device =
*pdev)=0A 	if (has_acpi_companion(&pdev->dev)) {=0A 		acpi_id =3D acpi_matc=
h_device(pdev->dev.driver->acpi_match_table,=0A 					    &pdev->dev);=0A-		=
if (!acpi_id)=0A-			return -EINVAL;=0A 		priv->hw_version =3D (unsigned lon=
g)acpi_id->driver_data;=0A 	} else {=0A 		priv->hw_version =3D=0A-- =0A2.30=
=2E2=0A=0A=0AFrom da68ce566b24290f7a7675a110ee5c07224e61d5 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:43:04 +0100=0ASubject: [PATCH 131/165] Revert "atl1e: checki=
ng the status of=0A atl1e_write_phy_reg"=0A=0AThis reverts commit ff07d48d7=
bc0974d4f96a85a4df14564fb09f1ef.=0A=0ACommits from @umn.edu addresses have =
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
ned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/n=
et/ethernet/atheros/atl1e/atl1e_main.c | 4 +---=0A 1 file changed, 1 insert=
ion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/atheros/atl1e=
/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0Aindex ff9=
f96de74b8..85f9cb769e30 100644=0A--- a/drivers/net/ethernet/atheros/atl1e/a=
tl1e_main.c=0A+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0A@@ -4=
55,9 +455,7 @@ static void atl1e_mdio_write(struct net_device *netdev, int =
phy_id,=0A {=0A 	struct atl1e_adapter *adapter =3D netdev_priv(netdev);=0A =
=0A-	if (atl1e_write_phy_reg(&adapter->hw,=0A-				reg_num & MDIO_REG_ADDR_M=
ASK, val))=0A-		netdev_err(netdev, "write phy register failed\n");=0A+	atl1=
e_write_phy_reg(&adapter->hw, reg_num & MDIO_REG_ADDR_MASK, val);=0A }=0A =
=0A static int atl1e_mii_ioctl(struct net_device *netdev,=0A-- =0A2.30.2=0A=
=0A=0AFrom 2e9424fa4a1ed1012724da785da652ff7c8a77df Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:43:05 +0100=0ASubject: [PATCH 132/165] Revert "net: dsa: bcm_sf2: P=
ropagate error value from=0A mdio_write"=0A=0AThis reverts commit e49505f72=
55be8ced695919c08a29bf2c3d79616.=0A=0ACommits from @umn.edu addresses have =
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
ned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/n=
et/dsa/bcm_sf2.c | 7 ++++---=0A 1 file changed, 4 insertions(+), 3 deletion=
s(-)=0A=0Adiff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.=
c=0Aindex 510324916e91..c8991304f035 100644=0A--- a/drivers/net/dsa/bcm_sf2=
=2Ec=0A+++ b/drivers/net/dsa/bcm_sf2.c=0A@@ -357,10 +357,11 @@ static int b=
cm_sf2_sw_mdio_write(struct mii_bus *bus, int addr, int regnum,=0A 	 * send=
 them to our master MDIO bus controller=0A 	 */=0A 	if (addr =3D=3D BRCM_PS=
EUDO_PHY_ADDR && priv->indir_phy_mask & BIT(addr))=0A-		return bcm_sf2_sw_i=
ndir_rw(priv, 0, addr, regnum, val);=0A+		bcm_sf2_sw_indir_rw(priv, 0, addr=
, regnum, val);=0A 	else=0A-		return mdiobus_write_nested(priv->master_mii_=
bus, addr,=0A-				regnum, val);=0A+		mdiobus_write_nested(priv->master_mii_=
bus, addr, regnum, val);=0A+=0A+	return 0;=0A }=0A =0A static irqreturn_t b=
cm_sf2_switch_0_isr(int irq, void *dev_id)=0A-- =0A2.30.2=0A=0A=0AFrom af92=
6cfb9d1c884a2af5aee03530a785ff0b4ff6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:06 +=
0100=0ASubject: [PATCH 133/165] Revert "net: stmicro: fix a missing check o=
f=0A clk_prepare"=0A=0AThis reverts commit f86a3b83833e7cfe558ca4d70b64ebc4=
8903efec.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/stmicro/stm=
mac/dwmac-sunxi.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-=
)=0A=0Adiff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/dri=
vers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0Aindex 0e1ca2cba3c7..0e8655=
3fc06f 100644=0A--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A+=
++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A@@ -50,9 +50,7 @@ =
static int sun7i_gmac_init(struct platform_device *pdev, void *priv)=0A 		g=
mac->clk_enabled =3D 1;=0A 	} else {=0A 		clk_set_rate(gmac->tx_clk, SUN7I_=
GMAC_MII_RATE);=0A-		ret =3D clk_prepare(gmac->tx_clk);=0A-		if (ret)=0A-		=
	return ret;=0A+		clk_prepare(gmac->tx_clk);=0A 	}=0A =0A 	return 0;=0A-- =
=0A2.30.2=0A=0A=0AFrom d8cbc9e34d88c574e2f6a20ba10f97cb957e0419 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:43:06 +0100=0ASubject: [PATCH 134/165] Revert "media: d=
vb: Add check on sp8870_readreg"=0A=0AThis reverts commit 467a37fba93f2b4fe=
3ab597ff6a517b22b566882.=0A=0ACommits from @umn.edu addresses have been fou=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dv=
b-frontends/sp8870.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletion=
s(-)=0A=0Adiff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media=
/dvb-frontends/sp8870.c=0Aindex 655db8272268..ee893a2f2261 100644=0A--- a/d=
rivers/media/dvb-frontends/sp8870.c=0A+++ b/drivers/media/dvb-frontends/sp8=
870.c=0A@@ -280,9 +280,7 @@ static int sp8870_set_frontend_parameters(struc=
t dvb_frontend *fe)=0A 	sp8870_writereg(state, 0xc05, reg0xc05);=0A =0A 	//=
 read status reg in order to clear pending irqs=0A-	err =3D sp8870_readreg(=
state, 0x200);=0A-	if (err)=0A-		return err;=0A+	sp8870_readreg(state, 0x20=
0);=0A =0A 	// system controller start=0A 	sp8870_microcontroller_start(sta=
te);=0A-- =0A2.30.2=0A=0A=0AFrom 353e27c810414aa4d5f296af7f1d2e69bc228576 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 19:43:07 +0100=0ASubject: [PATCH 135/165] Revert=
 "net: chelsio: Add a missing check on=0A cudg_get_buffer"=0A=0AThis revert=
s commit ca19fcb6285bfce1601c073bf4b9d2942e2df8d9.=0A=0ACommits from @umn.e=
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
=0A---=0A drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c | 4 ----=0A 1 file=
 changed, 4 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/chelsio/cxg=
b4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0Aindex c5b=
0e725b238..543da2f8a3e5 100644=0A--- a/drivers/net/ethernet/chelsio/cxgb4/c=
udbg_lib.c=0A+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0A@@ -163=
8,10 +1638,6 @@ int cudbg_collect_hw_sched(struct cudbg_init *pdbg_init,=0A=
 =0A 	rc =3D cudbg_get_buff(pdbg_init, dbg_buff, sizeof(struct cudbg_hw_sch=
ed),=0A 			    &temp_buff);=0A-=0A-	if (rc)=0A-		return rc;=0A-=0A 	hw_sche=
d_buff =3D (struct cudbg_hw_sched *)temp_buff.data;=0A 	hw_sched_buff->map =
=3D t4_read_reg(padap, TP_TX_MOD_QUEUE_REQ_MAP_A);=0A 	hw_sched_buff->mode =
=3D TIMERMODE_G(t4_read_reg(padap, TP_MOD_CONFIG_A));=0A-- =0A2.30.2=0A=0A=
=0AFrom e69518852ee5417dcf4b2ff39433d4d5eadb0079 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:43:08 +0100=0ASubject: [PATCH 136/165] Revert "net: (cpts) fix a mis=
sing check of=0A clk_prepare"=0A=0AThis reverts commit 2d822f2dbab7f4c820f7=
2eb8570aacf3f35855bd.=0A=0ACommits from @umn.edu addresses have been found =
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
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet=
/ti/cpts.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.=
c=0Aindex 43222a34cba0..60fde1bb9665 100644=0A--- a/drivers/net/ethernet/ti=
/cpts.c=0A+++ b/drivers/net/ethernet/ti/cpts.c=0A@@ -778,9 +778,7 @@ struct=
 cpts *cpts_create(struct device *dev, void __iomem *regs,=0A 		return ERR_=
CAST(cpts->refclk);=0A 	}=0A =0A-	ret =3D clk_prepare(cpts->refclk);=0A-	if=
 (ret)=0A-		return ERR_PTR(ret);=0A+	clk_prepare(cpts->refclk);=0A =0A 	cpt=
s->cc.read =3D cpts_systim_read;=0A 	cpts->cc.mask =3D CLOCKSOURCE_MASK(32)=
;=0A-- =0A2.30.2=0A=0A=0AFrom 380e5c1013e52ef20b366ed20c90141b04c144ca Mon =
Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 19:43:08 +0100=0ASubject: [PATCH 137/165] Revert =
"net/net_namespace: Check the return value of=0A register_pernet_subsys()"=
=0A=0AThis reverts commit 0eb987c874dc93f9c9d85a6465dbde20fdd3884c.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A net/core/net_namespace.c | 3 +--=0A 1 file change=
d, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/net/core/net_namespace.=
c b/net/core/net_namespace.c=0Aindex 2ef3b4557f40..3eb25ba2874c 100644=0A--=
- a/net/core/net_namespace.c=0A+++ b/net/core/net_namespace.c=0A@@ -1114,8 =
+1114,7 @@ static int __init net_ns_init(void)=0A 	init_net_initialized =3D=
 true;=0A 	up_write(&pernet_ops_rwsem);=0A =0A-	if (register_pernet_subsys(=
&net_ns_ops))=0A-		panic("Could not register network namespace subsystems")=
;=0A+	register_pernet_subsys(&net_ns_ops);=0A =0A 	rtnl_register(PF_UNSPEC,=
 RTM_NEWNSID, rtnl_net_newid, NULL,=0A 		      RTNL_FLAG_DOIT_UNLOCKED);=0A=
-- =0A2.30.2=0A=0A=0AFrom 7a3352d3195b7da0e0e00894bbf4d3cf32e9a22f Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 19:43:09 +0100=0ASubject: [PATCH 138/165] Revert "drive=
rs/regulator: fix a missing check of=0A return value"=0A=0AThis reverts com=
mit 966e927bf8cc6a44f8b72582a1d6d3ffc73b12ad.=0A=0ACommits from @umn.edu ad=
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
--=0A drivers/regulator/palmas-regulator.c | 5 +----=0A 1 file changed, 1 i=
nsertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/regulator/palmas-regu=
lator.c b/drivers/regulator/palmas-regulator.c=0Aindex 337dd614695e..f27ad8=
254291 100644=0A--- a/drivers/regulator/palmas-regulator.c=0A+++ b/drivers/=
regulator/palmas-regulator.c=0A@@ -438,16 +438,13 @@ static int palmas_ldo_=
write(struct palmas *palmas, unsigned int reg,=0A static int palmas_set_mod=
e_smps(struct regulator_dev *dev, unsigned int mode)=0A {=0A 	int id =3D rd=
ev_get_id(dev);=0A-	int ret;=0A 	struct palmas_pmic *pmic =3D rdev_get_drvd=
ata(dev);=0A 	struct palmas_pmic_driver_data *ddata =3D pmic->palmas->pmic_=
ddata;=0A 	struct palmas_regs_info *rinfo =3D &ddata->palmas_regs_info[id];=
=0A 	unsigned int reg;=0A 	bool rail_enable =3D true;=0A =0A-	ret =3D palma=
s_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A-	if (ret)=0A-		return=
 ret;=0A+	palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A =0A 	r=
eg &=3D ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.2=0A=0A=0AFr=
om 29db956eaed948ef7d5f4809d5e744028f16bfd0 Mon Sep 17 00:00:00 2001=0AFrom=
: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:=
43:10 +0100=0ASubject: [PATCH 139/165] Revert "media: mt312: fix a missing =
check of mt312=0A reset"=0A=0AThis reverts commit 9502cdf0807058a1002948805=
2b064cecceb7fc9.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-fronten=
ds/mt312.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0A=
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-fronte=
nds/mt312.c=0Aindex d43a67045dbe..1dc6adefb8fe 100644=0A--- a/drivers/media=
/dvb-frontends/mt312.c=0A+++ b/drivers/media/dvb-frontends/mt312.c=0A@@ -62=
7,9 +627,7 @@ static int mt312_set_frontend(struct dvb_frontend *fe)=0A 	if=
 (ret < 0)=0A 		return ret;=0A =0A-	ret =3D mt312_reset(state, 0);=0A-	if (=
ret < 0)=0A-		return ret;=0A+	mt312_reset(state, 0);=0A =0A 	return 0;=0A }=
=0A-- =0A2.30.2=0A=0A=0AFrom ba08a2f50687e1008691a8cbd83c849246ed99cf Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:43:10 +0100=0ASubject: [PATCH 140/165] Revert "ya=
m: fix a missing-check bug"=0A=0AThis reverts commit 0781168e23a2fc8dceb989=
f11fc5b39b3ccacc35.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/hamradio/y=
am.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/n=
et/hamradio/yam.c b/drivers/net/hamradio/yam.c=0Aindex 5ab53e9942f3..616db3=
a0d2f4 100644=0A--- a/drivers/net/hamradio/yam.c=0A+++ b/drivers/net/hamrad=
io/yam.c=0A@@ -951,8 +951,6 @@ static int yam_ioctl(struct net_device *dev,=
 struct ifreq *ifr, int cmd)=0A 				 sizeof(struct yamdrv_ioctl_mcs));=0A 	=
	if (IS_ERR(ym))=0A 			return PTR_ERR(ym);=0A-		if (ym->cmd !=3D SIOCYAMSMC=
S)=0A-			return -EINVAL;=0A 		if (ym->bitrate > YAM_MAXBITRATE) {=0A 			kfr=
ee(ym);=0A 			return -EINVAL;=0A@@ -968,8 +966,6 @@ static int yam_ioctl(st=
ruct net_device *dev, struct ifreq *ifr, int cmd)=0A 		if (copy_from_user(&=
yi, ifr->ifr_data, sizeof(struct yamdrv_ioctl_cfg)))=0A 			 return -EFAULT;=
=0A =0A-		if (yi.cmd !=3D SIOCYAMSCFG)=0A-			return -EINVAL;=0A 		if ((yi.c=
fg.mask & YAM_IOBASE) && netif_running(dev))=0A 			return -EINVAL;		/* Cann=
ot change this parameter when up */=0A 		if ((yi.cfg.mask & YAM_IRQ) && net=
if_running(dev))=0A-- =0A2.30.2=0A=0A=0AFrom 3cdba877955997f47c169739b497b2=
a374e4fa4c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:11 +0100=0ASubject: [PATCH 141=
/165] Revert "media: gspca: Check the return value of=0A write_bridge for t=
imeout"=0A=0AThis reverts commit a21a0eb56b4e8fe4a330243af8030f890cde2283.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/usb/gspca/m5602/m5602_=
po1030.c | 8 ++------=0A 1 file changed, 2 insertions(+), 6 deletions(-)=0A=
=0Adiff --git a/drivers/media/usb/gspca/m5602/m5602_po1030.c b/drivers/medi=
a/usb/gspca/m5602/m5602_po1030.c=0Aindex d680b777f097..7bdbb8065146 100644=
=0A--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c=0A+++ b/drivers/media=
/usb/gspca/m5602/m5602_po1030.c=0A@@ -154,7 +154,6 @@ static const struct v=
4l2_ctrl_config po1030_greenbal_cfg =3D {=0A =0A int po1030_probe(struct sd=
 *sd)=0A {=0A-	int rc =3D 0;=0A 	u8 dev_id_h =3D 0, i;=0A 	struct gspca_dev=
 *gspca_dev =3D (struct gspca_dev *)sd;=0A =0A@@ -174,14 +173,11 @@ int po1=
030_probe(struct sd *sd)=0A 	for (i =3D 0; i < ARRAY_SIZE(preinit_po1030); =
i++) {=0A 		u8 data =3D preinit_po1030[i][2];=0A 		if (preinit_po1030[i][0]=
 =3D=3D SENSOR)=0A-			rc |=3D m5602_write_sensor(sd,=0A+			m5602_write_sens=
or(sd,=0A 				preinit_po1030[i][1], &data, 1);=0A 		else=0A-			rc |=3D m560=
2_write_bridge(sd, preinit_po1030[i][1],=0A-						data);=0A+			m5602_write_=
bridge(sd, preinit_po1030[i][1], data);=0A 	}=0A-	if (rc < 0)=0A-		return r=
c;=0A =0A 	if (m5602_read_sensor(sd, PO1030_DEVID_H, &dev_id_h, 1))=0A 		re=
turn -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom 40b6dd45ab336330f7cd02faad76cd509=
e2f4ff0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:12 +0100=0ASubject: [PATCH 142/16=
5] Revert "media: lgdt3306a: fix a missing check of=0A return value"=0A=0AT=
his reverts commit c9b7d8f252a5a6f8ca6e948151367cbc7bc4b776.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/media/dvb-frontends/lgdt3306a.c | 5 +----=0A 1 f=
ile changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/media=
/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c=0Ainde=
x 722576f1732a..f34263a33ede 100644=0A--- a/drivers/media/dvb-frontends/lgd=
t3306a.c=0A+++ b/drivers/media/dvb-frontends/lgdt3306a.c=0A@@ -1690,10 +169=
0,7 @@ static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,=
=0A 	case QAM_256:=0A 	case QAM_AUTO:=0A 		/* need to know actual modulatio=
n to set proper SNR baseline */=0A-		ret =3D lgdt3306a_read_reg(state, 0x00=
a6, &val);=0A-		if (lg_chkerr(ret))=0A-			goto fail;=0A-=0A+		lgdt3306a_rea=
d_reg(state, 0x00a6, &val);=0A 		if(val & 0x04)=0A 			ref_snr =3D 2800; /* =
QAM-256 28dB */=0A 		else=0A-- =0A2.30.2=0A=0A=0AFrom 423b2ec562f4890323158=
5ad40d72539877ecea8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:12 +0100=0ASubject: [=
PATCH 143/165] Revert "media: usb: gspca: add a missed check for=0A goto_lo=
w_power"=0A=0AThis reverts commit 5b711870bec4dc9a6d705d41e127e73944fa3650.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/usb/gspca/cpia1.c | 6 =
+-----=0A 1 file changed, 1 insertion(+), 5 deletions(-)=0A=0Adiff --git a/=
drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c=0Aindex 5=
ee749e05267..99e594559a0c 100644=0A--- a/drivers/media/usb/gspca/cpia1.c=0A=
+++ b/drivers/media/usb/gspca/cpia1.c=0A@@ -1420,7 +1420,6 @@ static int sd=
_config(struct gspca_dev *gspca_dev,=0A {=0A 	struct sd *sd =3D (struct sd =
*) gspca_dev;=0A 	struct cam *cam;=0A-	int ret;=0A =0A 	sd->mainsFreq =3D F=
REQ_DEF =3D=3D V4L2_CID_POWER_LINE_FREQUENCY_60HZ;=0A 	reset_camera_params(=
gspca_dev);=0A@@ -1432,10 +1431,7 @@ static int sd_config(struct gspca_dev =
*gspca_dev,=0A 	cam->cam_mode =3D mode;=0A 	cam->nmodes =3D ARRAY_SIZE(mode=
);=0A =0A-	ret =3D goto_low_power(gspca_dev);=0A-	if (ret)=0A-		gspca_err(g=
spca_dev, "Cannot go to low power mode: %d\n",=0A-			  ret);=0A+	goto_low_p=
ower(gspca_dev);=0A 	/* Check the firmware version. */=0A 	sd->params.versi=
on.firmwareVersion =3D 0;=0A 	get_version_information(gspca_dev);=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 5810a2882f84135e0b76c127ed9df5fa6f726b37 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 19:43:13 +0100=0ASubject: [PATCH 144/165] Revert "net: thund=
er: fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 0=
b31d98d90f09868dce71319615e19cd1f146fb6.=0A=0ACommits from @umn.edu address=
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
=0A drivers/net/ethernet/cavium/thunder/nicvf_main.c | 6 ------=0A 1 file c=
hanged, 6 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/cavium/thunde=
r/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c=0Aindex f=
3b7b443f964..94515d84bfbc 100644=0A--- a/drivers/net/ethernet/cavium/thunde=
r/nicvf_main.c=0A+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c=0A@=
@ -2246,12 +2246,6 @@ static int nicvf_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *ent)=0A 	nic->nicvf_rx_mode_wq =3D alloc_ordered_workqu=
eue("nicvf_rx_mode_wq_VF%d",=0A 							WQ_MEM_RECLAIM,=0A 							nic->vf_id=
);=0A-	if (!nic->nicvf_rx_mode_wq) {=0A-		err =3D -ENOMEM;=0A-		dev_err(dev=
, "Failed to allocate work queue\n");=0A-		goto err_unregister_interrupts;=
=0A-	}=0A-=0A 	INIT_WORK(&nic->rx_mode_work.work, nicvf_set_rx_mode_task);=
=0A 	spin_lock_init(&nic->rx_mode_wq_lock);=0A =0A-- =0A2.30.2=0A=0A=0AFrom=
 4358b91cda560cca7e1eefac10942606a67f8a82 Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43=
:14 +0100=0ASubject: [PATCH 145/165] Revert "media: dvb: add return value c=
heck on=0A Write16"=0A=0AThis reverts commit 0f787c12ee7b2b41a74594ed158a01=
12736f4e4e.=0A=0ACommits from @umn.edu addresses have been found to be subm=
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
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-frontends/dr=
xd_hard.c | 30 +++++++++----------------=0A 1 file changed, 11 insertions(+=
), 19 deletions(-)=0A=0Adiff --git a/drivers/media/dvb-frontends/drxd_hard.=
c b/drivers/media/dvb-frontends/drxd_hard.c=0Aindex a7eb81df88c2..3e3de6bad=
c86 100644=0A--- a/drivers/media/dvb-frontends/drxd_hard.c=0A+++ b/drivers/=
media/dvb-frontends/drxd_hard.c=0A@@ -1132,8 +1132,6 @@ static int EnableAn=
dResetMB(struct drxd_state *state)=0A =0A static int InitCC(struct drxd_sta=
te *state)=0A {=0A-	int status =3D 0;=0A-=0A 	if (state->osc_clock_freq =3D=
=3D 0 ||=0A 	    state->osc_clock_freq > 20000 ||=0A 	    (state->osc_clock=
_freq % 4000) !=3D 0) {=0A@@ -1141,17 +1139,14 @@ static int InitCC(struct =
drxd_state *state)=0A 		return -1;=0A 	}=0A =0A-	status |=3D Write16(state,=
 CC_REG_OSC_MODE__A, CC_REG_OSC_MODE_M20, 0);=0A-	status |=3D Write16(state=
, CC_REG_PLL_MODE__A,=0A-				CC_REG_PLL_MODE_BYPASS_PLL |=0A-				CC_REG_PLL=
_MODE_PUMP_CUR_12, 0);=0A-	status |=3D Write16(state, CC_REG_REF_DIVIDE__A,=
=0A-				state->osc_clock_freq / 4000, 0);=0A-	status |=3D Write16(state, CC=
_REG_PWD_MODE__A, CC_REG_PWD_MODE_DOWN_PLL,=0A-				0);=0A-	status |=3D Writ=
e16(state, CC_REG_UPDATE__A, CC_REG_UPDATE_KEY, 0);=0A+	Write16(state, CC_R=
EG_OSC_MODE__A, CC_REG_OSC_MODE_M20, 0);=0A+	Write16(state, CC_REG_PLL_MODE=
__A, CC_REG_PLL_MODE_BYPASS_PLL |=0A+		CC_REG_PLL_MODE_PUMP_CUR_12, 0);=0A+=
	Write16(state, CC_REG_REF_DIVIDE__A, state->osc_clock_freq / 4000, 0);=0A+=
	Write16(state, CC_REG_PWD_MODE__A, CC_REG_PWD_MODE_DOWN_PLL, 0);=0A+	Write=
16(state, CC_REG_UPDATE__A, CC_REG_UPDATE_KEY, 0);=0A =0A-	return status;=
=0A+	return 0;=0A }=0A =0A static int ResetECOD(struct drxd_state *state)=
=0A@@ -1305,10 +1300,7 @@ static int SC_SendCommand(struct drxd_state *stat=
e, u16 cmd)=0A 	int status =3D 0, ret;=0A 	u16 errCode;=0A =0A-	status =3D =
Write16(state, SC_RA_RAM_CMD__A, cmd, 0);=0A-	if (status < 0)=0A-		return s=
tatus;=0A-=0A+	Write16(state, SC_RA_RAM_CMD__A, cmd, 0);=0A 	SC_WaitForRead=
y(state);=0A =0A 	ret =3D Read16(state, SC_RA_RAM_CMD_ADDR__A, &errCode, 0)=
;=0A@@ -1335,9 +1327,9 @@ static int SC_ProcStartCommand(struct drxd_state =
*state,=0A 			break;=0A 		}=0A 		SC_WaitForReady(state);=0A-		status |=3D W=
rite16(state, SC_RA_RAM_CMD_ADDR__A, subCmd, 0);=0A-		status |=3D Write16(s=
tate, SC_RA_RAM_PARAM1__A, param1, 0);=0A-		status |=3D Write16(state, SC_R=
A_RAM_PARAM0__A, param0, 0);=0A+		Write16(state, SC_RA_RAM_CMD_ADDR__A, sub=
Cmd, 0);=0A+		Write16(state, SC_RA_RAM_PARAM1__A, param1, 0);=0A+		Write16(=
state, SC_RA_RAM_PARAM0__A, param0, 0);=0A =0A 		SC_SendCommand(state, SC_R=
A_RAM_CMD_PROC_START);=0A 	} while (0);=0A-- =0A2.30.2=0A=0A=0AFrom 7fc1293=
e52806f6c6247a0f4cdf6210eafca7825 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:14 +010=
0=0ASubject: [PATCH 146/165] Revert "hwmon: (lm80) fix a missing check of b=
us read=0A in lm80 probe"=0A=0AThis reverts commit 9aa3aa15f4c2f74f47afd6c5=
db4b420fadf3f315.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/hwmon/lm80.c | 1=
1 ++---------=0A 1 file changed, 2 insertions(+), 9 deletions(-)=0A=0Adiff =
--git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c=0Aindex ac4adb44b224..9=
7ab491d2922 100644=0A--- a/drivers/hwmon/lm80.c=0A+++ b/drivers/hwmon/lm80.=
c=0A@@ -596,7 +596,6 @@ static int lm80_probe(struct i2c_client *client)=0A=
 	struct device *dev =3D &client->dev;=0A 	struct device *hwmon_dev;=0A 	st=
ruct lm80_data *data;=0A-	int rv;=0A =0A 	data =3D devm_kzalloc(dev, sizeof=
(struct lm80_data), GFP_KERNEL);=0A 	if (!data)=0A@@ -609,14 +608,8 @@ stat=
ic int lm80_probe(struct i2c_client *client)=0A 	lm80_init_client(client);=
=0A =0A 	/* A few vars need to be filled upon startup */=0A-	rv =3D lm80_re=
ad_value(client, LM80_REG_FAN_MIN(1));=0A-	if (rv < 0)=0A-		return rv;=0A-	=
data->fan[f_min][0] =3D rv;=0A-	rv =3D lm80_read_value(client, LM80_REG_FAN=
_MIN(2));=0A-	if (rv < 0)=0A-		return rv;=0A-	data->fan[f_min][1] =3D rv;=
=0A+	data->fan[f_min][0] =3D lm80_read_value(client, LM80_REG_FAN_MIN(1));=
=0A+	data->fan[f_min][1] =3D lm80_read_value(client, LM80_REG_FAN_MIN(2));=
=0A =0A 	hwmon_dev =3D devm_hwmon_device_register_with_groups(dev, client->=
name,=0A 							   data, lm80_groups);=0A-- =0A2.30.2=0A=0A=0AFrom 01bf8142=
244de8c6150494a2c5cd14ca5516260d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:15 +0100=
=0ASubject: [PATCH 147/165] Revert "net: liquidio: fix a NULL pointer=0A de=
reference"=0A=0AThis reverts commit fe543b2f174f34a7a751aa08b334fe6b105c456=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/cavium/liquidio=
/lio_main.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/d=
rivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/caviu=
m/liquidio/lio_main.c=0Aindex 7d00d3a8ded4..e4c220f30040 100644=0A--- a/dri=
vers/net/ethernet/cavium/liquidio/lio_main.c=0A+++ b/drivers/net/ethernet/c=
avium/liquidio/lio_main.c=0A@@ -1166,11 +1166,6 @@ static void send_rx_ctrl=
_cmd(struct lio *lio, int start_stop)=0A 	sc =3D (struct octeon_soft_comman=
d *)=0A 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,=0A 					  16, 0);=
=0A-	if (!sc) {=0A-		netif_info(lio, rx_err, lio->netdev,=0A-			   "Failed =
to allocate octeon_soft_command\n");=0A-		return;=0A-	}=0A =0A 	ncmd =3D (u=
nion octnet_cmd *)sc->virtdptr;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 60d985f5339=
32c53148657fa829c0da31152fd17 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:16 +0100=0A=
Subject: [PATCH 148/165] Revert "net: cxgb3_main: fix a missing-check bug"=
=0A=0AThis reverts commit 2c05d88818ab6571816b93edce4d53703870d7ae.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |=
 17 -----------------=0A 1 file changed, 17 deletions(-)=0A=0Adiff --git a/=
drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chel=
sio/cxgb3/cxgb3_main.c=0Aindex 84ad7261e243..cc6314aa0154 100644=0A--- a/dr=
ivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c=0A+++ b/drivers/net/ethernet/=
chelsio/cxgb3/cxgb3_main.c=0A@@ -2157,8 +2157,6 @@ static int cxgb_extensio=
n_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EPERM;=
=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A=
-		if (t.cmd !=3D CHELSIO_SET_QSET_PARAMS)=0A-			return -EINVAL;=0A 		if (t=
=2Eqset_idx >=3D SGE_QSETS)=0A 			return -EINVAL;=0A 		if (!in_range(t.intr=
_lat, 0, M_NEWTIMER) ||=0A@@ -2258,9 +2256,6 @@ static int cxgb_extension_i=
octl(struct net_device *dev, void __user *useraddr)=0A 		if (copy_from_user=
(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=0A =0A-		if (t.cmd !=3D CH=
ELSIO_GET_QSET_PARAMS)=0A-			return -EINVAL;=0A-=0A 		/* Display qsets for =
all ports when offload enabled */=0A 		if (test_bit(OFFLOAD_DEVMAP_BIT, &ad=
apter->open_device_map)) {=0A 			q1 =3D 0;=0A@@ -2306,8 +2301,6 @@ static i=
nt cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A 	=
		return -EBUSY;=0A 		if (copy_from_user(&edata, useraddr, sizeof(edata)))=
=0A 			return -EFAULT;=0A-		if (edata.cmd !=3D CHELSIO_SET_QSET_NUM)=0A-			=
return -EINVAL;=0A 		if (edata.val < 1 ||=0A 			(edata.val > 1 && !(adapter=
->flags & USING_MSIX)))=0A 			return -EINVAL;=0A@@ -2348,8 +2341,6 @@ stati=
c int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=
=0A 			return -EPERM;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A =
			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_LOAD_FW)=0A-			return -EINVA=
L;=0A 		/* Check t.len sanity ? */=0A 		fw_data =3D memdup_user(useraddr + =
sizeof(t), t.len);=0A 		if (IS_ERR(fw_data))=0A@@ -2373,8 +2364,6 @@ static=
 int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)=0A=
 			return -EBUSY;=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			=
return -EFAULT;=0A-		if (m.cmd !=3D CHELSIO_SETMTUTAB)=0A-			return -EINVAL=
;=0A 		if (m.nmtus !=3D NMTUS)=0A 			return -EINVAL;=0A 		if (m.mtus[0] < 8=
1)	/* accommodate SACK */=0A@@ -2416,8 +2405,6 @@ static int cxgb_extension=
_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EBUSY;=
=0A 		if (copy_from_user(&m, useraddr, sizeof(m)))=0A 			return -EFAULT;=0A=
-		if (m.cmd !=3D CHELSIO_SET_PM)=0A-			return -EINVAL;=0A 		if (!is_power_=
of_2(m.rx_pg_sz) ||=0A 			!is_power_of_2(m.tx_pg_sz))=0A 			return -EINVAL;=
	/* not power of 2 */=0A@@ -2453,8 +2440,6 @@ static int cxgb_extension_ioc=
tl(struct net_device *dev, void __user *useraddr)=0A 			return -EIO;	/* nee=
d the memory controllers */=0A 		if (copy_from_user(&t, useraddr, sizeof(t)=
))=0A 			return -EFAULT;=0A-		if (t.cmd !=3D CHELSIO_GET_MEM)=0A-			return =
-EINVAL;=0A 		if ((t.addr & 7) || (t.len & 7))=0A 			return -EINVAL;=0A 		i=
f (t.mem_id =3D=3D MEM_CM)=0A@@ -2507,8 +2492,6 @@ static int cxgb_extensio=
n_ioctl(struct net_device *dev, void __user *useraddr)=0A 			return -EAGAIN=
;=0A 		if (copy_from_user(&t, useraddr, sizeof(t)))=0A 			return -EFAULT;=
=0A-		if (t.cmd !=3D CHELSIO_SET_TRACE_FILTER)=0A-			return -EINVAL;=0A =0A=
 		tp =3D (const struct trace_params *)&t.sip;=0A 		if (t.config_tx)=0A-- =
=0A2.30.2=0A=0A=0AFrom b41ee40aa1623699477c7eec3f9fa8eb864777a1 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:43:16 +0100=0ASubject: [PATCH 149/165] Revert "isdn: mI=
SDNinfineon: fix potential NULL=0A pointer dereference"=0A=0AThis reverts c=
ommit d721fe99f6ada070ae8fc0ec3e01ce5a42def0d9.=0A=0ACommits from @umn.edu =
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
--=0A drivers/isdn/hardware/mISDN/mISDNinfineon.c | 5 +----=0A 1 file chang=
ed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/isdn/hardware/=
mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c=0Aindex=
 a16c7a2a7f3d..fa9c491f9c38 100644=0A--- a/drivers/isdn/hardware/mISDN/mISD=
Ninfineon.c=0A+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c=0A@@ -697,1=
1 +697,8 @@ setup_io(struct inf_hw *hw)=0A 				(ulong)hw->addr.start, (ulon=
g)hw->addr.size);=0A 			return err;=0A 		}=0A-		if (hw->ci->addr_mode =3D=
=3D AM_MEMIO) {=0A+		if (hw->ci->addr_mode =3D=3D AM_MEMIO)=0A 			hw->addr.=
p =3D ioremap(hw->addr.start, hw->addr.size);=0A-			if (unlikely(!hw->addr.=
p))=0A-				return -ENOMEM;=0A-		}=0A 		hw->addr.mode =3D hw->ci->addr_mode;=
=0A 		if (debug & DEBUG_HW)=0A 			pr_notice("%s: IO addr %lx (%lu bytes) mo=
de%d\n",=0A-- =0A2.30.2=0A=0A=0AFrom 1af6ad2bb4d89d5139cd29fce018a4ac6c1f78=
a8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 19:43:17 +0100=0ASubject: [PATCH 150/165] =
Revert "isdn: mISDN: Fix potential NULL pointer=0A dereference of kzalloc"=
=0A=0AThis reverts commit 38d22659803a033b1b66cd2624c33570c0dde77d.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/isdn/hardware/mISDN/hfcsusb.c | 3 ---=0A =
1 file changed, 3 deletions(-)=0A=0Adiff --git a/drivers/isdn/hardware/mISD=
N/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c=0Aindex 70061991915a..4=
bb470d3963d 100644=0A--- a/drivers/isdn/hardware/mISDN/hfcsusb.c=0A+++ b/dr=
ivers/isdn/hardware/mISDN/hfcsusb.c=0A@@ -249,9 +249,6 @@ hfcsusb_ph_info(s=
truct hfcsusb *hw)=0A 	int i;=0A =0A 	phi =3D kzalloc(struct_size(phi, bch,=
 dch->dev.nrbchan), GFP_ATOMIC);=0A-	if (!phi)=0A-		return;=0A-=0A 	phi->dc=
h.ch.protocol =3D hw->protocol;=0A 	phi->dch.ch.Flags =3D dch->Flags;=0A 	p=
hi->dch.state =3D dch->state;=0A-- =0A2.30.2=0A=0A=0AFrom 9ab649d42515452ae=
e90dd1a00794e361bfefb50 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:18 +0100=0ASubjec=
t: [PATCH 151/165] Revert "libnvdimm/namespace: Fix a potential NULL=0A poi=
nter dereference"=0A=0AThis reverts commit 55c1fc0af29a6c1b92f217b7eb7581a8=
82e0c07c.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/namespace_devs.c =
| 5 +----=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git=
 a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c=0Ainde=
x 2403b71b601e..04f7cb7a23b7 100644=0A--- a/drivers/nvdimm/namespace_devs.c=
=0A+++ b/drivers/nvdimm/namespace_devs.c=0A@@ -2297,12 +2297,9 @@ static st=
ruct device *create_namespace_blk(struct nd_region *nd_region,=0A 	if (!nsb=
lk->uuid)=0A 		goto blk_err;=0A 	memcpy(name, nd_label->name, NSLABEL_NAME_=
LEN);=0A-	if (name[0]) {=0A+	if (name[0])=0A 		nsblk->alt_name =3D kmemdup(=
name, NSLABEL_NAME_LEN,=0A 				GFP_KERNEL);=0A-		if (!nsblk->alt_name)=0A-	=
		goto blk_err;=0A-	}=0A 	res =3D nsblk_add_resource(nd_region, ndd, nsblk,=
=0A 			__le64_to_cpu(nd_label->dpa));=0A 	if (!res)=0A-- =0A2.30.2=0A=0A=0A=
=46rom efd795bcf9c62dc1c03c87873cd3ca8a2d82ba54 Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 19:43:18 +0100=0ASubject: [PATCH 152/165] Revert "ALSA: sb: fix a missin=
g check of snd_ctl_add"=0A=0AThis reverts commit beae77170c60aa786f3e4599c1=
8ead2854d8694d.=0A=0ACommits from @umn.edu addresses have been found to be =
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
 Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/isa/sb/sb16_main.c |=
 10 +++-------=0A 1 file changed, 3 insertions(+), 7 deletions(-)=0A=0Adiff=
 --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c=0Aindex 38dc1f=
de25f3..aa4870531023 100644=0A--- a/sound/isa/sb/sb16_main.c=0A+++ b/sound/=
isa/sb/sb16_main.c=0A@@ -846,14 +846,10 @@ int snd_sb16dsp_pcm(struct snd_s=
b *chip, int device)=0A 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_PLAYBACK, &s=
nd_sb16_playback_ops);=0A 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &=
snd_sb16_capture_ops);=0A =0A-	if (chip->dma16 >=3D 0 && chip->dma8 !=3D ch=
ip->dma16) {=0A-		err =3D snd_ctl_add(card, snd_ctl_new1(=0A-					&snd_sb16=
_dma_control, chip));=0A-		if (err)=0A-			return err;=0A-	} else {=0A+	if (=
chip->dma16 >=3D 0 && chip->dma8 !=3D chip->dma16)=0A+		snd_ctl_add(card, s=
nd_ctl_new1(&snd_sb16_dma_control, chip));=0A+	else=0A 		pcm->info_flags =
=3D SNDRV_PCM_INFO_HALF_DUPLEX;=0A-	}=0A =0A 	snd_pcm_set_managed_buffer_al=
l(pcm, SNDRV_DMA_TYPE_DEV,=0A 				       card->dev, 64*1024, 128*1024);=0A-=
- =0A2.30.2=0A=0A=0AFrom d984a18403e0478f3d37436311d8af542d8fb648 Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 19:43:19 +0100=0ASubject: [PATCH 153/165] Revert "brcmfm=
ac: add a check for the status of=0A usb_register"=0A=0AThis reverts commit=
 42daad3343be4a4e1ee03e30a5f5cc731dadfef5.=0A=0ACommits from @umn.edu addre=
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
=0A drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 6 +-----=0A 1 =
file changed, 1 insertion(+), 5 deletions(-)=0A=0Adiff --git a/drivers/net/=
wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/=
brcm80211/brcmfmac/usb.c=0Aindex 586f4dfc638b..d2a803fc8ac6 100644=0A--- a/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c=0A+++ b/drivers/net/=
wireless/broadcom/brcm80211/brcmfmac/usb.c=0A@@ -1586,10 +1586,6 @@ void br=
cmf_usb_exit(void)=0A =0A void brcmf_usb_register(void)=0A {=0A-	int ret;=
=0A-=0A 	brcmf_dbg(USB, "Enter\n");=0A-	ret =3D usb_register(&brcmf_usbdrvr=
);=0A-	if (ret)=0A-		brcmf_err("usb_register failed %d\n", ret);=0A+	usb_re=
gister(&brcmf_usbdrvr);=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 33f777ffe57c299484=
528ac5080f8df5134e2fc0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <su=
dipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:20 +0100=0ASubject=
: [PATCH 154/165] Revert "dmaengine: mv_xor: Fix a missing check in=0A mv_x=
or_channel_add"=0A=0AThis reverts commit 7c97381e7a9a5ec359007c0d491a143e3d=
9f787c.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/dma/mv_xor.c | 5 +----=
=0A 1 file changed, 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/driver=
s/dma/mv_xor.c b/drivers/dma/mv_xor.c=0Aindex 23b232b57518..78bd52565571 10=
0644=0A--- a/drivers/dma/mv_xor.c=0A+++ b/drivers/dma/mv_xor.c=0A@@ -1144,1=
0 +1144,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,=0A 		 dma_has=
_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",=0A 		 dma_has_cap(DMA_IN=
TERRUPT, dma_dev->cap_mask) ? "intr " : "");=0A =0A-	ret =3D dma_async_devi=
ce_register(dma_dev);=0A-	if (ret)=0A-		goto err_free_irq;=0A-=0A+	dma_asyn=
c_device_register(dma_dev);=0A 	return mv_chan;=0A =0A err_free_irq:=0A-- =
=0A2.30.2=0A=0A=0AFrom b84e9fc7ea4fea6b36451995fbc75255935cb76d Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:43:20 +0100=0ASubject: [PATCH 155/165] Revert "niu: fix=
 missing checks of=0A niu_pci_eeprom_read"=0A=0AThis reverts commit 26fd962=
bde0b15e54234fe762d86bc0349df1de4.=0A=0ACommits from @umn.edu addresses hav=
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
/net/ethernet/sun/niu.c | 10 ++--------=0A 1 file changed, 2 insertions(+),=
 8 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/sun/niu.c b/drivers/=
net/ethernet/sun/niu.c=0Aindex 707ccdd03b19..d70cdea756d1 100644=0A--- a/dr=
ivers/net/ethernet/sun/niu.c=0A+++ b/drivers/net/ethernet/sun/niu.c=0A@@ -8=
097,8 +8097,6 @@ static int niu_pci_vpd_scan_props(struct niu *np, u32 star=
t, u32 end)=0A 		start +=3D 3;=0A =0A 		prop_len =3D niu_pci_eeprom_read(np=
, start + 4);=0A-		if (prop_len < 0)=0A-			return prop_len;=0A 		err =3D ni=
u_pci_vpd_get_propname(np, start + 5, namebuf, 64);=0A 		if (err < 0)=0A 		=
	return err;=0A@@ -8143,12 +8141,8 @@ static int niu_pci_vpd_scan_props(str=
uct niu *np, u32 start, u32 end)=0A 			netif_printk(np, probe, KERN_DEBUG, =
np->dev,=0A 				     "VPD_SCAN: Reading in property [%s] len[%d]\n",=0A 			=
	     namebuf, prop_len);=0A-			for (i =3D 0; i < prop_len; i++) {=0A-				e=
rr =3D niu_pci_eeprom_read(np, off + i);=0A-				if (err >=3D 0)=0A-					*pr=
op_buf =3D err;=0A-				++prop_buf;=0A-			}=0A+			for (i =3D 0; i < prop_len=
; i++)=0A+				*prop_buf++ =3D niu_pci_eeprom_read(np, off + i);=0A 		}=0A =
=0A 		start +=3D len;=0A-- =0A2.30.2=0A=0A=0AFrom 40b882cb33f7f781434184547=
6795a550daa2fcf Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:21 +0100=0ASubject: [PATC=
H 156/165] Revert "ipv6/route: Add a missing check on=0A proc_dointvec"=0A=
=0AThis reverts commit f0fb9b288d0a7e9cc324ae362e2dfd2cc2217ded.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A net/ipv6/route.c | 6 +-----=0A 1 file changed, 1 ins=
ertion(+), 5 deletions(-)=0A=0Adiff --git a/net/ipv6/route.c b/net/ipv6/rou=
te.c=0Aindex 4bba6d21ffa0..b1c3f2c6470d 100644=0A--- a/net/ipv6/route.c=0A+=
++ b/net/ipv6/route.c=0A@@ -6109,16 +6109,12 @@ static int ipv6_sysctl_rtca=
che_flush(struct ctl_table *ctl, int write,=0A {=0A 	struct net *net;=0A 	i=
nt delay;=0A-	int ret;=0A 	if (!write)=0A 		return -EINVAL;=0A =0A 	net =3D=
 (struct net *)ctl->extra1;=0A 	delay =3D net->ipv6.sysctl.flush_delay;=0A-=
	ret =3D proc_dointvec(ctl, write, buffer, lenp, ppos);=0A-	if (ret)=0A-		r=
eturn ret;=0A-=0A+	proc_dointvec(ctl, write, buffer, lenp, ppos);=0A 	fib6_=
run_gc(delay <=3D 0 ? 0 : (unsigned long)delay, net, delay > 0);=0A 	return=
 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom fef324c12087d23e7203c13203009287a28991=
ec Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 19:43:22 +0100=0ASubject: [PATCH 157/165] =
Revert "net: socket: fix a missing-check bug"=0A=0AThis reverts commit b616=
8562c8ce2bd5a30e213021650422e08764dc.=0A=0ACommits from @umn.edu addresses =
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
net/socket.c | 11 +++--------=0A 1 file changed, 3 insertions(+), 8 deletio=
ns(-)=0A=0Adiff --git a/net/socket.c b/net/socket.c=0Aindex 33e8b6c4e1d3..5=
7a322ef4b31 100644=0A--- a/net/socket.c=0A+++ b/net/socket.c=0A@@ -3187,14 =
+3187,9 @@ static int ethtool_ioctl(struct net *net, struct compat_ifreq __=
user *ifr32)=0A 		    copy_in_user(&rxnfc->fs.ring_cookie,=0A 				 &compat_=
rxnfc->fs.ring_cookie,=0A 				 (void __user *)(&rxnfc->fs.location + 1) -=
=0A-				 (void __user *)&rxnfc->fs.ring_cookie))=0A-			return -EFAULT;=0A-	=
	if (ethcmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-			if (put_user(rule_cnt, &rxn=
fc->rule_cnt))=0A-				return -EFAULT;=0A-		} else if (copy_in_user(&rxnfc->=
rule_cnt,=0A-					&compat_rxnfc->rule_cnt,=0A-					sizeof(rxnfc->rule_cnt))=
)=0A+				 (void __user *)&rxnfc->fs.ring_cookie) ||=0A+		    copy_in_user(&=
rxnfc->rule_cnt, &compat_rxnfc->rule_cnt,=0A+				 sizeof(rxnfc->rule_cnt)))=
=0A 			return -EFAULT;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 66318b6d616e2e=
6272c62239e2774e31c8420351 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:23 +0100=0ASub=
ject: [PATCH 158/165] Revert "net: netxen: fix a missing check and an=0A un=
initialized use"=0A=0AThis reverts commit d134e486e831defd26130770181f01dfc=
6195f7d.=0A=0ACommits from @umn.edu addresses have been found to be submitt=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/netx=
en/netxen_nic_init.c | 3 +--=0A 1 file changed, 1 insertion(+), 2 deletions=
(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c =
b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c=0Aindex 94546ed5f867=
=2E.74335bdff701 100644=0A--- a/drivers/net/ethernet/qlogic/netxen/netxen_n=
ic_init.c=0A+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c=0A@@=
 -1109,8 +1109,7 @@ netxen_validate_firmware(struct netxen_adapter *adapter=
)=0A 		return -EINVAL;=0A 	}=0A 	val =3D nx_get_bios_version(adapter);=0A-	=
if (netxen_rom_fast_read(adapter, NX_BIOS_VERSION_OFFSET, (int *)&bios))=0A=
-		return -EIO;=0A+	netxen_rom_fast_read(adapter, NX_BIOS_VERSION_OFFSET, (=
int *)&bios);=0A 	if ((__force u32)val !=3D bios) {=0A 		dev_err(&pdev->dev=
, "%s: firmware bios is incompatible\n",=0A 				fw_name[fw_type]);=0A-- =0A=
2.30.2=0A=0A=0AFrom bd071ed0ab97d8c9d53606de9d8ba789b18d540d Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 19:43:23 +0100=0ASubject: [PATCH 159/165] Revert "media: gspc=
a: mt9m111: Check write_bridge for=0A timeout"=0A=0AThis reverts commit 656=
025850074f5c1ba2e05be37bda57ba2b8d491.=0A=0ACommits from @umn.edu addresses=
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
drivers/media/usb/gspca/m5602/m5602_mt9m111.c | 8 +++-----=0A 1 file change=
d, 3 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/media/usb/gspc=
a/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c=0Ai=
ndex bfa3b381d8a2..50481dc928d0 100644=0A--- a/drivers/media/usb/gspca/m560=
2/m5602_mt9m111.c=0A+++ b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c=0A@=
@ -195,7 +195,7 @@ static const struct v4l2_ctrl_config mt9m111_greenbal_cf=
g =3D {=0A int mt9m111_probe(struct sd *sd)=0A {=0A 	u8 data[2] =3D {0x00, =
0x00};=0A-	int i, rc =3D 0;=0A+	int i;=0A 	struct gspca_dev *gspca_dev =3D =
(struct gspca_dev *)sd;=0A =0A 	if (force_sensor) {=0A@@ -213,18 +213,16 @@=
 int mt9m111_probe(struct sd *sd)=0A 	/* Do the preinit */=0A 	for (i =3D 0=
; i < ARRAY_SIZE(preinit_mt9m111); i++) {=0A 		if (preinit_mt9m111[i][0] =
=3D=3D BRIDGE) {=0A-			rc |=3D m5602_write_bridge(sd,=0A+			m5602_write_bri=
dge(sd,=0A 				preinit_mt9m111[i][1],=0A 				preinit_mt9m111[i][2]);=0A 		}=
 else {=0A 			data[0] =3D preinit_mt9m111[i][2];=0A 			data[1] =3D preinit_=
mt9m111[i][3];=0A-			rc |=3D m5602_write_sensor(sd,=0A+			m5602_write_senso=
r(sd,=0A 				preinit_mt9m111[i][1], data, 2);=0A 		}=0A 	}=0A-	if (rc < 0)=
=0A-		return rc;=0A =0A 	if (m5602_read_sensor(sd, MT9M111_SC_CHIPVER, data=
, 2))=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom c3d8e08f98fb5342dc0f=
7a12af1a50b4ffabe2d4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:25 +0100=0ASubject: =
[PATCH 160/165] Revert "media: isif: fix a NULL pointer dereference=0A bug"=
=0A=0AThis reverts commit a26ac6c1bed951b2066cc4b2257facd919e35c0b.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/media/platform/davinci/isif.c | 3 +--=0A =
1 file changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/me=
dia/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c=0Aindex=
 c53cecd072b1..5355a14c090b 100644=0A--- a/drivers/media/platform/davinci/i=
sif.c=0A+++ b/drivers/media/platform/davinci/isif.c=0A@@ -1086,8 +1086,7 @@=
 static int isif_probe(struct platform_device *pdev)=0A =0A 	while (i >=3D =
0) {=0A 		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);=0A-		if (=
res)=0A-			release_mem_region(res->start, resource_size(res));=0A+		release=
_mem_region(res->start, resource_size(res));=0A 		i--;=0A 	}=0A 	vpfe_unreg=
ister_ccdc_device(&isif_hw_dev);=0A-- =0A2.30.2=0A=0A=0AFrom fba23644cc4ae0=
3939cfce5c4926968bfcf8555c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:25 +0100=0ASub=
ject: [PATCH 161/165] Revert "scsi: 3w-xxxx: fix a missing-check bug"=0A=0A=
This reverts commit 9899e4d3523faaef17c67141aa80ff2088f17871.=0A=0ACommits =
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
e@gmail.com>=0A---=0A drivers/scsi/3w-xxxx.c | 3 ---=0A 1 file changed, 3 d=
eletions(-)=0A=0Adiff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx=
=2Ec=0Aindex fb6444d0409c..63dce4ad0801 100644=0A--- a/drivers/scsi/3w-xxxx=
=2Ec=0A+++ b/drivers/scsi/3w-xxxx.c=0A@@ -1035,9 +1035,6 @@ static int tw_c=
hrdev_open(struct inode *inode, struct file *file)=0A =0A 	dprintk(KERN_WAR=
NING "3w-xxxx: tw_ioctl_open()\n");=0A =0A-	if (!capable(CAP_SYS_ADMIN))=0A=
-		return -EACCES;=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_nu=
mber >=3D tw_device_extension_count)=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=
=0A=0AFrom 45a1f42b7fb9dab8b3bb88a8f88643e3e89f34b8 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:43:26 +0100=0ASubject: [PATCH 162/165] Revert "scsi: 3w-9xxx: fix a=
 missing-check bug"=0A=0AThis reverts commit c9318a3e0218bc9dacc25be46b9eec=
363259536f.=0A=0ACommits from @umn.edu addresses have been found to be subm=
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
herjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/scsi/3w-9xxx.c | 5 ---=
--=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/scsi/3w-9xxx=
=2Ec b/drivers/scsi/3w-9xxx.c=0Aindex b4718a1b2bd6..9dc08d4a4a42 100644=0A-=
-- a/drivers/scsi/3w-9xxx.c=0A+++ b/drivers/scsi/3w-9xxx.c=0A@@ -886,11 +88=
6,6 @@ static int twa_chrdev_open(struct inode *inode, struct file *file)=
=0A 	unsigned int minor_number;=0A 	int retval =3D TW_IOCTL_ERROR_OS_ENODEV=
;=0A =0A-	if (!capable(CAP_SYS_ADMIN)) {=0A-		retval =3D -EACCES;=0A-		goto=
 out;=0A-	}=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=
=3D twa_device_extension_count)=0A 		goto out;=0A-- =0A2.30.2=0A=0A=0AFrom =
3b1fb014dc6c5902c6c7f8ce107f27f662a5f874 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:43:=
28 +0100=0ASubject: [PATCH 163/165] Revert "dm ioctl: harden copy_params()'=
s=0A copy_from_user() from malicious users"=0A=0AThis reverts commit 800a73=
40ab7dd667edf95e74d8e4f23a17e87076.=0A=0ACommits from @umn.edu addresses ha=
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
s/md/dm-ioctl.c | 18 ++++++++++++------=0A 1 file changed, 12 insertions(+)=
, 6 deletions(-)=0A=0Adiff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-io=
ctl.c=0Aindex 1ca65b434f1f..820342de92cd 100644=0A--- a/drivers/md/dm-ioctl=
=2Ec=0A+++ b/drivers/md/dm-ioctl.c=0A@@ -1747,7 +1747,8 @@ static void free=
_params(struct dm_ioctl *param, size_t param_size, int param_fla=0A }=0A =
=0A static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *p=
aram_kernel,=0A-		       int ioctl_flags, struct dm_ioctl **param, int *par=
am_flags)=0A+		       int ioctl_flags,=0A+		       struct dm_ioctl **param,=
 int *param_flags)=0A {=0A 	struct dm_ioctl *dmi;=0A 	int secure_data;=0A@@=
 -1788,13 +1789,18 @@ static int copy_params(struct dm_ioctl __user *user, =
struct dm_ioctl *param_kern=0A =0A 	*param_flags |=3D DM_PARAMS_MALLOC;=0A =
=0A-	/* Copy from param_kernel (which was already copied from user) */=0A-	=
memcpy(dmi, param_kernel, minimum_data_size);=0A-=0A-	if (copy_from_user(&d=
mi->data, (char __user *)user + minimum_data_size,=0A-			   param_kernel->d=
ata_size - minimum_data_size))=0A+	if (copy_from_user(dmi, user, param_kern=
el->data_size))=0A 		goto bad;=0A+=0A data_copied:=0A+	/*=0A+	 * Abort if s=
omething changed the ioctl data while it was being copied.=0A+	 */=0A+	if (=
dmi->data_size !=3D param_kernel->data_size) {=0A+		DMERR("rejecting ioctl:=
 data size modified while processing parameters");=0A+		goto bad;=0A+	}=0A+=
=0A 	/* Wipe the user buffer so we do not return it to userspace */=0A 	if =
(secure_data && clear_user(user, param_kernel->data_size))=0A 		goto bad;=
=0A-- =0A2.30.2=0A=0A=0AFrom 35568f858bbe7e7b0ef52968184ee33f825d5427 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:46:36 +0100=0ASubject: [PATCH 164/165] Revert "et=
htool: fix a missing-check bug"=0A=0AThis reverts commit 2bb3207dbbd4d30e96=
dd0e1c8e013104193bd59c.=0A=0ACommits from @umn.edu addresses have been foun=
d to be submitted in "bad=0Afaith" to try to test the kernel community's ab=
ility to review "known=0Amalicious" changes.  The result of these submissio=
ns can be found in a=0Apaper published at the 42nd IEEE Symposium on Securi=
ty and Privacy=0Aentitled, "Open Source Insecurity: Stealthily Introducing=
=0AVulnerabilities via Hypocrite Commits" written by Qiushi Wu (University=
=0Aof Minnesota) and Kangjie Lu (University of Minnesota).=0A=0ABecause of =
this, all submissions from this group must be reverted from=0Athe kernel tr=
ee and will need to be re-reviewed again to determine if=0Athey actually ar=
e a valid fix.  Until that work is complete, remove this=0Achange to ensure=
 that no problems are being introduced into the=0Acodebase.=0A=0A[sudip: re=
vert in new path]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0A---=0A net/ethtool/ioctl.c | 3 ---=0A 1 file changed, 3 deletions(-)=
=0A=0Adiff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c=0Aindex 771688=
e1b0da..807bc9465add 100644=0A--- a/net/ethtool/ioctl.c=0A+++ b/net/ethtool=
/ioctl.c=0A@@ -876,9 +876,6 @@ static noinline_for_stack int ethtool_get_rx=
nfc(struct net_device *dev,=0A 			return -EINVAL;=0A 	}=0A =0A-	if (info.cm=
d !=3D cmd)=0A-		return -EINVAL;=0A-=0A 	if (info.cmd =3D=3D ETHTOOL_GRXCLS=
RLALL) {=0A 		if (info.rule_cnt > 0) {=0A 			if (info.rule_cnt <=3D KMALLOC=
_MAX_SIZE / sizeof(u32))=0A-- =0A2.30.2=0A=0A=0AFrom 928658582269424def0937=
69184fec78ae1cbb6e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:49:52 +0100=0ASubject: =
[PATCH 165/165] Revert "ethtool: fix a potential missing-check bug"=0A=0ATh=
is reverts commit d656fe49e33df48ee6bc19e871f5862f49895c9e.=0A=0ACommits fr=
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
to the=0Acodebase.=0A=0A[sudip: revert in new path]=0ASigned-off-by: Sudip =
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/ethtool/ioctl.c | 5 ---=
--=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/net/ethtool/ioctl.c =
b/net/ethtool/ioctl.c=0Aindex 807bc9465add..542f2428014c 100644=0A--- a/net=
/ethtool/ioctl.c=0A+++ b/net/ethtool/ioctl.c=0A@@ -869,11 +869,6 @@ static =
noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,=0A 		info_=
size =3D sizeof(info);=0A 		if (copy_from_user(&info, useraddr, info_size))=
=0A 			return -EFAULT;=0A-		/* Since malicious users may modify the origina=
l data,=0A-		 * we need to check whether FLOW_RSS is still requested.=0A-		=
 */=0A-		if (!(info.flow_type & FLOW_RSS))=0A-			return -EINVAL;=0A 	}=0A =
=0A 	if (info.cmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-- =0A2.30.2=0A=0A
--aryy8RvuTcrxwVZG--
