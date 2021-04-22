Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0C03679C5
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 08:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhDVGTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 02:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhDVGTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 02:19:49 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD69C06138B
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:19:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c15so34584247wro.13
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 23:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XY3wHC2YBja6XaICSfkmI98b5LSlnXzYogXbzFhRXoY=;
        b=q2NnuRXc1n1gmimGRUang/vYMGPhuF2PsgtPbWqUSSC3XVBX+bx16EVhzynktjxDUM
         0i1ibGUn7WY1YWE6CRIM22VzcYFD4tZUHYU+otVsk1vU8WIQTbZu42GZqogzR3KFd1qc
         lPIRpvjz+qIG0e5VWMHUtjQ7MGSyqsFHuZlP51N3vChWEmjWTo2xTUmqLySbJgWCk0eG
         jL4btSWNF8RlXQ2792LoUWe8VS9jYihJtnkaxjFerO+IdxgnCUmKLsjiDc6UfacSUkV0
         JDPZC1m2Bu3I2L9PnCW2+P3j/gK6gDufwcfyVr2qltOtRy93U4QNmiHKrvgcYHPtu6xU
         WeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XY3wHC2YBja6XaICSfkmI98b5LSlnXzYogXbzFhRXoY=;
        b=H3Q6qdIEARcU2fbEz4keA6PjkdFin3rhxDcMY0zye4zFee1aLjMzLGsfweQELzq6ci
         iQIwt6oV9CMISbMkkX78nCXTAwMLDCV32RyP677gcClFS7ep3Ox7lbz4o+NOq6GYYZmO
         Anq8RKAGNy+9+21zl/D2jWW5o18afg2gI5WWc7LC7aQnJAG68uFTUiYVuZGUMDbs/KWb
         6z12EAgEdiqVePuIX/mD/QnB39Qqsxf7ufilRL/rK+I2mP9N+dY4GsX+0ujwHFQK18A8
         QF1oVpXvOAE151TH1BkCmgx+Uc1PLY1RLwzl+Go2Rxq8/YF9Tbarl8emrzIlPbrx48W+
         zGzw==
X-Gm-Message-State: AOAM533dXjpgvG7eOX/oIC7AZaaQ0uzo9kHsT9ENga8nheOGNMCv33f9
        wgmNZFCn0c5k+gdE1okG61E=
X-Google-Smtp-Source: ABdhPJwo6UMOoZHjb4ovdM+LUdNyS6fk1GxlmLxa2JnzIAM2G4zPG8B7lTCGPTSU77How2lL68XAow==
X-Received: by 2002:a05:6000:1204:: with SMTP id e4mr1968342wrx.424.1619072353021;
        Wed, 21 Apr 2021 23:19:13 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id s83sm1707711wms.16.2021.04.21.23.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 23:19:10 -0700 (PDT)
Date:   Thu, 22 Apr 2021 07:19:09 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [resend] revert series of umn.edu commits for v5.10.y
Message-ID: <YIEVXcN3OTi3LD/P@debian>
References: <YICidTdSYPut4oVa@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zwiwRNhsK/nH5DcA"
Content-Disposition: inline
In-Reply-To: <YICidTdSYPut4oVa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zwiwRNhsK/nH5DcA
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

--zwiwRNhsK/nH5DcA
Content-Type: application/mbox
Content-Disposition: attachment; filename="revertseries_v5.10.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 342831ee7afcc21833c9b7c3ba72b6739bc2d4ad Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 19:58:56 +0100=0ASubject: [PATCH 001/165] Revert "media: sti: Fix refere=
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
ct_mutex);=0A 		return;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom e5fa2165b5d43e17f=
71896b3add48040a0ee770f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:58:56 +0100=0ASubjec=
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
=0A=0A=0AFrom 72ca4838ff52f8bbff61669425181a4467c5888a Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:58:57 +0100=0ASubject: [PATCH 003/165] Revert "media: rcar-vin: =
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
ers/media/platform/rcar-vin/rcar-v4l2.c=0Aindex 3e7a3ae2a6b9..4071d9bd554a =
100644=0A--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c=0A+++ b/drivers/=
media/platform/rcar-vin/rcar-v4l2.c=0A@@ -871,10 +871,8 @@ static int rvin_=
open(struct file *file)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(vi=
n->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put_noidle(vin->dev);=0A+	if (r=
et < 0)=0A 		return ret;=0A-	}=0A =0A 	ret =3D mutex_lock_interruptible(&vi=
n->lock);=0A 	if (ret)=0A-- =0A2.30.2=0A=0A=0AFrom 8d043f467f5d62c2edad3683=
31d1d8795561a9d8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:58:57 +0100=0ASubject: [PAT=
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
=0Aindex 692dea300b0d..533a42a0034d 100644=0A--- a/drivers/media/platform/r=
car-vin/rcar-dma.c=0A+++ b/drivers/media/platform/rcar-vin/rcar-dma.c=0A@@ =
-1446,10 +1446,8 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 c=
hsel)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_sync(vin->dev);=0A-	if (r=
et < 0) {=0A-		pm_runtime_put_noidle(vin->dev);=0A+	if (ret < 0)=0A 		retur=
n ret;=0A-	}=0A =0A 	/* Make register writes take effect immediately. */=0A=
 	vnmc =3D rvin_read(vin, VNMC_REG);=0A-- =0A2.30.2=0A=0A=0AFrom a306de756c=
b8f89bc0e74b37e0c7e69b2d561dd9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:58:58 +0100=
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
ree(entry);=0A 	return err;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom efb01f61f0e4e7=
ff4c217642b7cd2f78baf5a9b0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:58:58 +0100=0ASub=
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
>client.device.object, 0x101000));=0A-- =0A2.30.2=0A=0A=0AFrom 1dec5cc3f6c6=
a340267322e78f7da7cfd4ab40b8 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:58:59 +0100=0AS=
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
m/nouveau/dispnv50/disp.c=0Aindex 5b8cabb099eb..e2fff5b9b450 100644=0A--- a=
/drivers/gpu/drm/nouveau/dispnv50/disp.c=0A+++ b/drivers/gpu/drm/nouveau/di=
spnv50/disp.c=0A@@ -2287,10 +2287,8 @@ nv50_disp_atomic_commit(struct drm_d=
evice *dev,=0A 	int ret, i;=0A =0A 	ret =3D pm_runtime_get_sync(dev->dev);=
=0A-	if (ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev=
->dev);=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A =
	ret =3D drm_atomic_helper_setup_commit(state, nonblock);=0A 	if (ret)=0A--=
 =0A2.30.2=0A=0A=0AFrom ae431e75dc8ecf9473dbd6a5e3e993d699c4aadc Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:58:59 +0100=0ASubject: [PATCH 008/165] Revert "drm/nou=
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
ers/gpu/drm/nouveau/nouveau_drm.c=0Aindex 42fc5c813a9b..0316f7dcdf73 100644=
=0A--- a/drivers/gpu/drm/nouveau/nouveau_drm.c=0A+++ b/drivers/gpu/drm/nouv=
eau/nouveau_drm.c=0A@@ -1065,10 +1065,8 @@ nouveau_drm_open(struct drm_devi=
ce *dev, struct drm_file *fpriv)=0A =0A 	/* need to bring up power immediat=
ely if opening device */=0A 	ret =3D pm_runtime_get_sync(dev->dev);=0A-	if =
(ret < 0 && ret !=3D -EACCES) {=0A-		pm_runtime_put_autosuspend(dev->dev);=
=0A+	if (ret < 0 && ret !=3D -EACCES)=0A 		return ret;=0A-	}=0A =0A 	get_ta=
sk_comm(tmpname, current);=0A 	snprintf(name, sizeof(name), "%s[%d]", tmpna=
me, pid_nr(fpriv->pid));=0A@@ -1150,10 +1148,8 @@ nouveau_drm_ioctl(struct =
file *file, unsigned int cmd, unsigned long arg)=0A 	long ret;=0A =0A 	ret =
=3D pm_runtime_get_sync(dev->dev);=0A-	if (ret < 0 && ret !=3D -EACCES) {=
=0A-		pm_runtime_put_autosuspend(dev->dev);=0A+	if (ret < 0 && ret !=3D -EA=
CCES)=0A 		return ret;=0A-	}=0A =0A 	switch (_IOC_NR(cmd) - DRM_COMMAND_BAS=
E) {=0A 	case DRM_NOUVEAU_NVIF:=0Adiff --git a/drivers/gpu/drm/nouveau/nouv=
eau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c=0Aindex c2051380d18c..5a3=
2b311933e 100644=0A--- a/drivers/gpu/drm/nouveau/nouveau_gem.c=0A+++ b/driv=
ers/gpu/drm/nouveau/nouveau_gem.c=0A@@ -46,10 +46,8 @@ nouveau_gem_object_d=
el(struct drm_gem_object *gem)=0A 	int ret;=0A =0A 	ret =3D pm_runtime_get_=
sync(dev);=0A-	if (WARN_ON(ret < 0 && ret !=3D -EACCES)) {=0A-		pm_runtime_=
put_autosuspend(dev);=0A+	if (WARN_ON(ret < 0 && ret !=3D -EACCES))=0A 		re=
turn;=0A-	}=0A =0A 	if (gem->import_attach)=0A 		drm_prime_gem_destroy(gem,=
 nvbo->bo.sg);=0A-- =0A2.30.2=0A=0A=0AFrom d601ad5e301356cb6dc35da2f96503be=
53f8b3a7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:00 +0100=0ASubject: [PATCH 009/1=
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
=0A 	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom c7efe154f755d1e7a419a4b=
1c77d9c8e09667df5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:00 +0100=0ASubject: [PA=
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
/pci/slot.c=0Aindex ed2077e7470a..ded1957fc982 100644=0A--- a/drivers/pci/s=
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
=0A }=0A-- =0A2.30.2=0A=0A=0AFrom f8864fa3f61daae01c53923037f00734b609e74a =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 19:59:01 +0100=0ASubject: [PATCH 011/165] Rever=
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
s/venc.c b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0Aindex f560fa4d7786=
=2E.e7f18dd228e0 100644=0A--- a/drivers/video/fbdev/omap2/omapfb/dss/venc.c=
=0A+++ b/drivers/video/fbdev/omap2/omapfb/dss/venc.c=0A@@ -348,11 +348,8 @@=
 static int venc_runtime_get(void)=0A 	DSSDBG("venc_runtime_get\n");=0A =0A=
 	r =3D pm_runtime_get_sync(&venc.pdev->dev);=0A-	if (WARN_ON(r < 0)) {=0A-=
		pm_runtime_put_sync(&venc.pdev->dev);=0A-		return r;=0A-	}=0A-	return 0;=
=0A+	WARN_ON(r < 0);=0A+	return r < 0 ? r : 0;=0A }=0A =0A static void venc=
_runtime_put(void)=0A-- =0A2.30.2=0A=0A=0AFrom ddeeae0c21a5235e35162d8a1548=
6c4c4fe601d7 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:01 +0100=0ASubject: [PATCH 0=
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
/exynos4-is/fimc-lite.c=0Aindex fdd0d369b192..9c666f663ab4 100644=0A--- a/d=
rivers/media/platform/exynos4-is/fimc-lite.c=0A+++ b/drivers/media/platform=
/exynos4-is/fimc-lite.c=0A@@ -471,7 +471,7 @@ static int fimc_lite_open(str=
uct file *file)=0A 	set_bit(ST_FLITE_IN_USE, &fimc->state);=0A 	ret =3D pm_=
runtime_get_sync(&fimc->pdev->dev);=0A 	if (ret < 0)=0A-		goto err_pm;=0A+	=
	goto unlock;=0A =0A 	ret =3D v4l2_fh_open(file);=0A 	if (ret < 0)=0A-- =0A=
2.30.2=0A=0A=0AFrom 4d463fad98a2d24d768ea821c64965bad67830d8 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 19:59:01 +0100=0ASubject: [PATCH 013/165] Revert "platform/ch=
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
ror;=0A-	}=0A =0A 	return 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 62fce6842f840c=
9f09fcb26d2f8e7864c3466935 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:02 +0100=0ASub=
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
30.2=0A=0A=0AFrom 07238c2f294c33bc1bdd64c535e9013029cbcb6d Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:59:02 +0100=0ASubject: [PATCH 015/165] Revert "ASoC: rockchi=
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
rockchip_pdm.c=0Aindex 5adb293d0435..35983b1cb5fa 100644=0A--- a/sound/soc/=
rockchip/rockchip_pdm.c=0A+++ b/sound/soc/rockchip/rockchip_pdm.c=0A@@ -590=
,10 +590,8 @@ static int rockchip_pdm_resume(struct device *dev)=0A 	int re=
t;=0A =0A 	ret =3D pm_runtime_get_sync(dev);=0A-	if (ret < 0) {=0A-		pm_run=
time_put(dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	ret =3D regc=
ache_sync(pdm->regmap);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 6ba3898f4e6f148d09b=
3e6e201becc394c863e37 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:03 +0100=0ASubject:=
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
->num_sensors =3D 0;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 0caa1b189e67a5e9609f71=
8cbb5c0fe99a80b161 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
=2Emukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:03 +0100=0ASubject: =
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
>lock);=0A-- =0A2.30.2=0A=0A=0AFrom f1d7b6611fdf44c98b9f8cc0a8e8b8b8e3e27bb=
b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.=
com>=0ADate: Wed, 21 Apr 2021 19:59:04 +0100=0ASubject: [PATCH 018/165] Rev=
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
rn r < 0 ? r : 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom c76052b42e642ef3433d=
362198a8a8bb54ab8217 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:04 +0100=0ASubject: =
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
cmi.c=0Aindex fd1c41cba52f..b8931490b83b 100644=0A--- a/drivers/media/platf=
orm/stm32/stm32-dcmi.c=0A+++ b/drivers/media/platform/stm32/stm32-dcmi.c=0A=
@@ -733,7 +733,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, u=
nsigned int count)=0A 	if (ret < 0) {=0A 		dev_err(dcmi->dev, "%s: Failed t=
o start streaming, cannot get sync (%d)\n",=0A 			__func__, ret);=0A-		goto=
 err_pm_put;=0A+		goto err_release_buffers;=0A 	}=0A =0A 	ret =3D media_pip=
eline_start(&dcmi->vdev->entity, &dcmi->pipeline);=0A@@ -837,6 +837,8 @@ st=
atic int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)=0A =
=0A err_pm_put:=0A 	pm_runtime_put(dcmi->dev);=0A+=0A+err_release_buffers:=
=0A 	spin_lock_irq(&dcmi->irqlock);=0A 	/*=0A 	 * Return all buffers to vb2=
 in QUEUED state.=0A-- =0A2.30.2=0A=0A=0AFrom e40eee99ea8f4abb46999e078072e=
29c0c9aaa22 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:05 +0100=0ASubject: [PATCH 02=
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
=0A=0A=0AFrom 134509fbc24e2ebbdebca3120e078dcd8c6ec5ff Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:59:05 +0100=0ASubject: [PATCH 021/165] Revert "media: platform: =
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
=0A =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom d7fac859ded66f3abfba105=
6b0f9c4cf6f5e8439 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:05 +0100=0ASubject: [PA=
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
e this access unit */=0A-- =0A2.30.2=0A=0A=0AFrom 7fbf3de888925cf92af50a467=
b555a0f78509b4a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:06 +0100=0ASubject: [PATC=
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
egmap);=0A 	pm_runtime_put(dev);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 00f4c32a55=
5afd23ede7ff629f231bc2700004bc Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:06 +0100=
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
mmu/iommu.c b/drivers/iommu/iommu.c=0Aindex 0d9adce6d812..beecb86c68a9 1006=
44=0A--- a/drivers/iommu/iommu.c=0A+++ b/drivers/iommu/iommu.c=0A@@ -589,7 =
+589,7 @@ struct iommu_group *iommu_group_alloc(void)=0A 				   NULL, "%d",=
 group->id);=0A 	if (ret) {=0A 		ida_simple_remove(&iommu_group_ida, group-=
>id);=0A-		kobject_put(&group->kobj);=0A+		kfree(group);=0A 		return ERR_PT=
R(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9eead996ab82224df116ff51f40b5=
b4ed36078ab Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:07 +0100=0ASubject: [PATCH 02=
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
ivers/acpi/cppc_acpi.c=0Aindex 7a99b19bb893..f8184004294a 100644=0A--- a/dr=
ivers/acpi/cppc_acpi.c=0A+++ b/drivers/acpi/cppc_acpi.c=0A@@ -846,7 +846,6 =
@@ int acpi_cppc_processor_probe(struct acpi_processor *pr)=0A 			"acpi_cpp=
c");=0A 	if (ret) {=0A 		per_cpu(cpc_desc_ptr, pr->id) =3D NULL;=0A-		kobje=
ct_put(&cpc_ptr->kobj);=0A 		goto out_free;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom e05d7967dc2273e9dbf4120751f571c04253c923 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:59:08 +0100=0ASubject: [PATCH 026/165] Revert "ACPI: sysfs: Fix refe=
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
DD);=0A 	return;=0A-- =0A2.30.2=0A=0A=0AFrom fd762b50809ac8d4abe40b28da9cc5=
6a3ba2a012 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:08 +0100=0ASubject: [PATCH 027=
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
=0A-- =0A2.30.2=0A=0A=0AFrom 224575acd71b1a26ad9e786551c8fac91571a0ce Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:09 +0100=0ASubject: [PATCH 028/165] Revert "ql=
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
 =0A2.30.2=0A=0A=0AFrom a09c58cafb5afc39d30a778e7f6333a4064e6939 Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:59:09 +0100=0ASubject: [PATCH 029/165] Revert "usb: ga=
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
=2E30.2=0A=0A=0AFrom b7b7fb6f3b4c19ee393d04c01d378e52bab0a450 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 19:59:10 +0100=0ASubject: [PATCH 030/165] Revert "net/mlx4_c=
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
n, outbox, GET_OP_REQ_TOKEN_OFFSET);=0A-- =0A2.30.2=0A=0A=0AFrom ae39210ec6=
1db8448559d39b6910e840410cf05e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:10 +0100=
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
30.2=0A=0A=0AFrom 6690eb0d00d8291f356c944bcb6fc1fc4e2323e4 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:59:11 +0100=0ASubject: [PATCH 032/165] Revert "agp/intel: Fi=
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
-- =0A2.30.2=0A=0A=0AFrom 38ce97fb907b14e4eb4abd06da2839ca2a6ff7ba Mon Sep =
17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADat=
e: Wed, 21 Apr 2021 19:59:11 +0100=0ASubject: [PATCH 033/165] Revert "clk: =
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
nr_pll_clks,=0A-- =0A2.30.2=0A=0A=0AFrom 6887ef322831987a4b2b89718685d0d752=
1e84bc Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@g=
mail.com>=0ADate: Wed, 21 Apr 2021 19:59:12 +0100=0ASubject: [PATCH 034/165=
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
\n",=0A 				crypt_stat->key_size);=0A-- =0A2.30.2=0A=0A=0AFrom 12680c3018ef=
5c9070e5776a6d98edd20289aa13 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:12 +0100=0AS=
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
 we=0A 	 * set it.=0A 	 */=0A-- =0A2.30.2=0A=0A=0AFrom 11be4115cbf1892fd772=
4fbf5d89c365470520e9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:13 +0100=0ASubject: =
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
46/saa7146_fops.c=0Aindex d6531874faa6..5aedfdc2ac01 100644=0A--- a/drivers=
/media/common/saa7146/saa7146_fops.c=0A+++ b/drivers/media/common/saa7146/s=
aa7146_fops.c=0A@@ -97,6 +97,8 @@ void saa7146_buffer_finish(struct saa7146=
_dev *dev,=0A 	DEB_EE("dev:%p, dmaq:%p, state:%d\n", dev, q, state);=0A 	DE=
B_EE("q->curr:%p\n", q->curr);=0A =0A+	BUG_ON(!q->curr);=0A+=0A 	/* finish =
current buffer */=0A 	if (NULL =3D=3D q->curr) {=0A 		DEB_D("aiii. no curre=
nt buffer\n");=0A-- =0A2.30.2=0A=0A=0AFrom df67dc370e6bfe63aace900f49f1318f=
3d5c5165 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee=
@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:13 +0100=0ASubject: [PATCH 037/1=
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
=0A2.30.2=0A=0A=0AFrom bf923fe8ac327126059b80de10df03e58a157955 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:59:14 +0100=0ASubject: [PATCH 038/165] Revert "media: d=
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
=0A-- =0A2.30.2=0A=0A=0AFrom 9a51cd10d91dc0ebc2cbac0a0f9b8b6eadf2bc24 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:15 +0100=0ASubject: [PATCH 039/165] Revert "me=
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
dex ccd15b4d4920..d16122039b0c 100644=0A--- a/drivers/media/common/saa7146/=
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
DMA2_CLP|RESOURCE_DMA3_BRS;=0A-- =0A2.30.2=0A=0A=0AFrom cf55ba5d959fa519b6b=
6ef7a4e58bbeb649a250b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:15 +0100=0ASubject:=
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
ev->dev;=0A-- =0A2.30.2=0A=0A=0AFrom 32b6d02f58b0fc1651a5be24df50a8ff20aa34=
38 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 19:59:16 +0100=0ASubject: [PATCH 041/165] =
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
_set;=0A-- =0A2.30.2=0A=0A=0AFrom 5c489495efd0b478b242caf6b92e9f5c41944cd3 =
Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.co=
m>=0ADate: Wed, 21 Apr 2021 19:59:16 +0100=0ASubject: [PATCH 042/165] Rever=
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
00/kpc_dma/fileops.c b/drivers/staging/kpc2000/kpc_dma/fileops.c=0Aindex e1=
c7c04f16fe..fc6b535b2f64 100644=0A--- a/drivers/staging/kpc2000/kpc_dma/fil=
eops.c=0A+++ b/drivers/staging/kpc2000/kpc_dma/fileops.c=0A@@ -49,7 +49,9 @=
@ static int kpc_dma_transfer(struct dev_private_data *priv,=0A 	u64 dma_ad=
dr;=0A 	u64 user_ctl;=0A =0A+	BUG_ON(priv =3D=3D NULL);=0A 	ldev =3D priv->=
ldev;=0A+	BUG_ON(ldev =3D=3D NULL);=0A =0A 	acd =3D kzalloc(sizeof(*acd), G=
FP_KERNEL);=0A 	if (!acd) {=0A-- =0A2.30.2=0A=0A=0AFrom 305613d1f40da09c226=
80d096a60522276d4af7c Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:17 +0100=0ASubject:=
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
tfc_io.c b/drivers/target/tcm_fc/tfc_io.c=0Aindex 6a38ff936389..1354a157e9a=
f 100644=0A--- a/drivers/target/tcm_fc/tfc_io.c=0A+++ b/drivers/target/tcm_=
fc/tfc_io.c=0A@@ -221,6 +221,7 @@ void ft_recv_write_data(struct ft_cmd *cm=
d, struct fc_frame *fp)=0A 	ep =3D fc_seq_exch(seq);=0A 	lport =3D ep->lp;=
=0A 	if (cmd->was_ddp_setup) {=0A+		BUG_ON(!ep);=0A 		BUG_ON(!lport);=0A 		=
/*=0A 		 * Since DDP (Large Rx offload) was setup for this request,=0A-- =
=0A2.30.2=0A=0A=0AFrom a92289a18a096f830e0d9c245da983ab741053ac Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:59:17 +0100=0ASubject: [PATCH 044/165] Revert "hdlcdrv:=
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
hdlcdrv.c=0Aindex e7413a643929..df495b5595f5 100644=0A--- a/drivers/net/ham=
radio/hdlcdrv.c=0A+++ b/drivers/net/hamradio/hdlcdrv.c=0A@@ -687,6 +687,8 @=
@ struct net_device *hdlcdrv_register(const struct hdlcdrv_ops *ops,=0A 	st=
ruct hdlcdrv_state *s;=0A 	int err;=0A =0A+	BUG_ON(ops =3D=3D NULL);=0A+=0A=
 	if (privsize < sizeof(struct hdlcdrv_state))=0A 		privsize =3D sizeof(str=
uct hdlcdrv_state);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 0e30a868944653893065622=
85bc430d1dbe288ac Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:18 +0100=0ASubject: [PA=
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
wrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c=0Aindex 64df50827642..2089=
cf886b09 100644=0A--- a/drivers/nfc/s3fwrn5/firmware.c=0A+++ b/drivers/nfc/=
s3fwrn5/firmware.c=0A@@ -501,10 +501,7 @@ int s3fwrn5_fw_recv_frame(struct =
nci_dev *ndev, struct sk_buff *skb)=0A 	struct s3fwrn5_info *info =3D nci_g=
et_drvdata(ndev);=0A 	struct s3fwrn5_fw_info *fw_info =3D &info->fw_info;=
=0A =0A-	if (WARN_ON(fw_info->rsp)) {=0A-		kfree_skb(skb);=0A-		return -EIN=
VAL;=0A-	}=0A+	BUG_ON(fw_info->rsp);=0A =0A 	fw_info->rsp =3D skb;=0A =0A--=
 =0A2.30.2=0A=0A=0AFrom 0bb62150e83c6332ecf9e33f260a6c9a8c9b3feb Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:59:18 +0100=0ASubject: [PATCH 046/165] Revert "bpf: Re=
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
f/core.c b/kernel/bpf/core.c=0Aindex 182e162f8fd0..e95f002dce2a 100644=0A--=
- a/kernel/bpf/core.c=0A+++ b/kernel/bpf/core.c=0A@@ -224,6 +224,8 @@ struc=
t bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,=0A=
 	u32 pages, delta;=0A 	int ret;=0A =0A+	BUG_ON(fp_old =3D=3D NULL);=0A+=0A=
 	size =3D round_up(size, PAGE_SIZE);=0A 	pages =3D size / PAGE_SIZE;=0A 	i=
f (pages <=3D fp_old->pages)=0A-- =0A2.30.2=0A=0A=0AFrom b12f97c06a8e3056de=
0dd1db3eb9f2e6a55bd7cd Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <su=
dipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:19 +0100=0ASubject=
: [PATCH 047/165] Revert "efi/esrt: Fix reference count leak in=0A esre_cre=
ate_sysfs_entry."=0A=0AThis reverts commit 4ddf4739be6e375116c375f0a68bf389=
3ffcee21.=0A=0ACommits from @umn.edu addresses have been found to be submit=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/firmware/efi/esrt.c | 2 =
+-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drive=
rs/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c=0Aindex d5915272141f..=
e3d692696583 100644=0A--- a/drivers/firmware/efi/esrt.c=0A+++ b/drivers/fir=
mware/efi/esrt.c=0A@@ -181,7 +181,7 @@ static int esre_create_sysfs_entry(v=
oid *esre, int entry_num)=0A 		rc =3D kobject_init_and_add(&entry->kobj, &e=
sre1_ktype, NULL,=0A 					  "entry%d", entry_num);=0A 		if (rc) {=0A-			kob=
ject_put(&entry->kobj);=0A+			kfree(entry);=0A 			return rc;=0A 		}=0A 	}=
=0A-- =0A2.30.2=0A=0A=0AFrom f83daa29309fdd4f474d9f046040d7adc344fc39 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:19 +0100=0ASubject: [PATCH 048/165] Revert "AS=
oC: img: Fix a reference count leak in=0A img_i2s_in_set_fmt"=0A=0AThis rev=
erts commit c4c59b95b7f7d4cef5071b151be2dadb33f3287b.=0A=0ACommits from @um=
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
m>=0A---=0A sound/soc/img/img-i2s-in.c | 4 +---=0A 1 file changed, 1 insert=
ion(+), 3 deletions(-)=0A=0Adiff --git a/sound/soc/img/img-i2s-in.c b/sound=
/soc/img/img-i2s-in.c=0Aindex 3de95da52583..a495d1050d49 100644=0A--- a/sou=
nd/soc/img/img-i2s-in.c=0A+++ b/sound/soc/img/img-i2s-in.c=0A@@ -343,10 +34=
3,8 @@ static int img_i2s_in_set_fmt(struct snd_soc_dai *dai, unsigned int =
fmt)=0A 	chan_control_mask =3D IMG_I2S_IN_CH_CTL_CLK_TRANS_MASK;=0A =0A 	re=
t =3D pm_runtime_get_sync(i2s->dev);=0A-	if (ret < 0) {=0A-		pm_runtime_put=
_noidle(i2s->dev);=0A+	if (ret < 0)=0A 		return ret;=0A-	}=0A =0A 	for (i =
=3D 0; i < i2s->active_channels; i++)=0A 		img_i2s_in_ch_disable(i2s, i);=
=0A-- =0A2.30.2=0A=0A=0AFrom e169d03b9ff0b10af0575925943df3d1bb302a3d Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:20 +0100=0ASubject: [PATCH 049/165] Revert "sc=
si: iscsi: Fix reference count leak in=0A iscsi_boot_create_kobj"=0A=0AThis=
 reverts commit 0267ffce562c8bbf9b57ebe0e38445ad04972890.=0A=0ACommits from=
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
l.com>=0A---=0A drivers/scsi/iscsi_boot_sysfs.c | 2 +-=0A 1 file changed, 1=
 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/scsi/iscsi_boot_sysf=
s.c b/drivers/scsi/iscsi_boot_sysfs.c=0Aindex a64abe38db2d..e4857b728033 10=
0644=0A--- a/drivers/scsi/iscsi_boot_sysfs.c=0A+++ b/drivers/scsi/iscsi_boo=
t_sysfs.c=0A@@ -352,7 +352,7 @@ iscsi_boot_create_kobj(struct iscsi_boot_ks=
et *boot_kset,=0A 	boot_kobj->kobj.kset =3D boot_kset->kset;=0A 	if (kobjec=
t_init_and_add(&boot_kobj->kobj, &iscsi_boot_ktype,=0A 				 NULL, name, ind=
ex)) {=0A-		kobject_put(&boot_kobj->kobj);=0A+		kfree(boot_kobj);=0A 		retu=
rn NULL;=0A 	}=0A 	boot_kobj->data =3D data;=0A-- =0A2.30.2=0A=0A=0AFrom 7f=
019b5234656d70027c249f5cbfc8c2e8fe47d5 Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:20=
 +0100=0ASubject: [PATCH 050/165] Revert "vfio/mdev: Fix reference count le=
ak in=0A add_mdev_supported_type"=0A=0AThis reverts commit aa8ba13cae3134b8=
ef1c1b6879f66372531da738.=0A=0ACommits from @umn.edu addresses have been fo=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/vfio/mde=
v/mdev_sysfs.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=
=0Adiff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sys=
fs.c=0Aindex 917fd84c1c6f..8ad14e5c02bf 100644=0A--- a/drivers/vfio/mdev/md=
ev_sysfs.c=0A+++ b/drivers/vfio/mdev/mdev_sysfs.c=0A@@ -110,7 +110,7 @@ sta=
tic struct mdev_type *add_mdev_supported_type(struct mdev_parent *parent,=
=0A 				   "%s-%s", dev_driver_string(parent->dev),=0A 				   group->name);=
=0A 	if (ret) {=0A-		kobject_put(&type->kobj);=0A+		kfree(type);=0A 		retur=
n ERR_PTR(ret);=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 3284e9e0a4612ab2c1912=
4acbf401efb737055fe Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:21 +0100=0ASubject: [=
PATCH 051/165] Revert "RDMA/core: Fix several reference count=0A leaks."=0A=
=0AThis reverts commit 0b8e125e213204508e1b3c4bdfe69713280b7abd.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/infiniband/core/sysfs.c | 10 +++++-----=0A 1=
 file changed, 5 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/in=
finiband/core/sysfs.c b/drivers/infiniband/core/sysfs.c=0Aindex 914cddea525=
d..1783929bc1c0 100644=0A--- a/drivers/infiniband/core/sysfs.c=0A+++ b/driv=
ers/infiniband/core/sysfs.c=0A@@ -1064,7 +1064,8 @@ static int add_port(str=
uct ib_core_device *coredev, int port_num)=0A 				   coredev->ports_kobj,=
=0A 				   "%d", port_num);=0A 	if (ret) {=0A-		goto err_put;=0A+		kfree(p)=
;=0A+		return ret;=0A 	}=0A =0A 	p->gid_attr_group =3D kzalloc(sizeof(*p->g=
id_attr_group), GFP_KERNEL);=0A@@ -1077,7 +1078,8 @@ static int add_port(st=
ruct ib_core_device *coredev, int port_num)=0A 	ret =3D kobject_init_and_ad=
d(&p->gid_attr_group->kobj, &gid_attr_type,=0A 				   &p->kobj, "gid_attrs"=
);=0A 	if (ret) {=0A-		goto err_put_gid_attrs;=0A+		kfree(p->gid_attr_group=
);=0A+		goto err_put;=0A 	}=0A =0A 	if (device->ops.process_mad && is_full_=
dev) {=0A@@ -1424,10 +1426,8 @@ int ib_port_register_module_stat(struct ib_=
device *device, u8 port_num,=0A =0A 		ret =3D kobject_init_and_add(kobj, kt=
ype, &port->kobj, "%s",=0A 					   name);=0A-		if (ret) {=0A-			kobject_put=
(kobj);=0A+		if (ret)=0A 			return ret;=0A-		}=0A 	}=0A =0A 	return 0;=0A--=
 =0A2.30.2=0A=0A=0AFrom 14349feb833e5a66f5f5ada433a4c59ddc65063e Mon Sep 17=
 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate:=
 Wed, 21 Apr 2021 19:59:21 +0100=0ASubject: [PATCH 052/165] Revert "cpuidle=
: Fix three reference count leaks"=0A=0AThis reverts commit c343bf1ba5efcbf=
2266a1fe3baefec9cc82f867f.=0A=0ACommits from @umn.edu addresses have been f=
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
f-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/cpuidle=
/sysfs.c | 6 +++---=0A 1 file changed, 3 insertions(+), 3 deletions(-)=0A=
=0Adiff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c=0Aindex 5=
3ec9585ccd4..23a219cedbdb 100644=0A--- a/drivers/cpuidle/sysfs.c=0A+++ b/dr=
ivers/cpuidle/sysfs.c=0A@@ -487,7 +487,7 @@ static int cpuidle_add_state_sy=
sfs(struct cpuidle_device *device)=0A 		ret =3D kobject_init_and_add(&kobj-=
>kobj, &ktype_state_cpuidle,=0A 					   &kdev->kobj, "state%d", i);=0A 		if=
 (ret) {=0A-			kobject_put(&kobj->kobj);=0A+			kfree(kobj);=0A 			goto erro=
r_state;=0A 		}=0A 		cpuidle_add_s2idle_attr_group(kobj);=0A@@ -618,7 +618,=
7 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)=0A 	re=
t =3D kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,=0A 				   &k=
dev->kobj, "driver");=0A 	if (ret) {=0A-		kobject_put(&kdrv->kobj);=0A+		kf=
ree(kdrv);=0A 		return ret;=0A 	}=0A =0A@@ -712,7 +712,7 @@ int cpuidle_add=
_sysfs(struct cpuidle_device *dev)=0A 	error =3D kobject_init_and_add(&kdev=
->kobj, &ktype_cpuidle, &cpu_dev->kobj,=0A 				   "cpuidle");=0A 	if (error=
) {=0A-		kobject_put(&kdev->kobj);=0A+		kfree(kdev);=0A 		return error;=0A =
	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom b340028eba4926f445141a7dc95a548e0ce80e7e=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 19:59:22 +0100=0ASubject: [PATCH 053/165] Reve=
rt "EDAC: Fix reference count leaks"=0A=0AThis reverts commit 17ed808ad2431=
92fb923e4e653c1338d3ba06207.=0A=0ACommits from @umn.edu addresses have been=
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
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/edac/=
edac_device_sysfs.c | 1 -=0A drivers/edac/edac_pci_sysfs.c    | 2 +-=0A 2 f=
iles changed, 1 insertion(+), 2 deletions(-)=0A=0Adiff --git a/drivers/edac=
/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c=0Aindex 5e759375379=
9..0e7ea3591b78 100644=0A--- a/drivers/edac/edac_device_sysfs.c=0A+++ b/dri=
vers/edac/edac_device_sysfs.c=0A@@ -275,7 +275,6 @@ int edac_device_registe=
r_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)=0A =0A 	/* Error e=
xit stack */=0A err_kobj_reg:=0A-	kobject_put(&edac_dev->kobj);=0A 	module_=
put(edac_dev->owner);=0A =0A err_out:=0Adiff --git a/drivers/edac/edac_pci_=
sysfs.c b/drivers/edac/edac_pci_sysfs.c=0Aindex 53042af7262e..72c9eb9fdffb =
100644=0A--- a/drivers/edac/edac_pci_sysfs.c=0A+++ b/drivers/edac/edac_pci_=
sysfs.c=0A@@ -386,7 +386,7 @@ static int edac_pci_main_kobj_setup(void)=0A =
=0A 	/* Error unwind statck */=0A kobject_init_and_add_fail:=0A-	kobject_pu=
t(edac_pci_top_main_kobj);=0A+	kfree(edac_pci_top_main_kobj);=0A =0A kzallo=
c_fail:=0A 	module_put(THIS_MODULE);=0A-- =0A2.30.2=0A=0A=0AFrom 5dcb39953c=
d4865ee70d424e0def5a0f2842d8a1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:23 +0100=
=0ASubject: [PATCH 054/165] Revert "fore200e: Fix incorrect checks of NULL=
=0A pointer dereference"=0A=0AThis reverts commit bbd20c939c8aa3f27fa30e866=
91af250bf92973a.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/atm/fore200e.c | =
25 +++++++------------------=0A 1 file changed, 7 insertions(+), 18 deletio=
ns(-)=0A=0Adiff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c=0Ai=
ndex 9a70bee84125..9498156808e4 100644=0A--- a/drivers/atm/fore200e.c=0A+++=
 b/drivers/atm/fore200e.c=0A@@ -1414,14 +1414,12 @@ fore200e_open(struct at=
m_vcc *vcc)=0A static void=0A fore200e_close(struct atm_vcc* vcc)=0A {=0A+ =
   struct fore200e*        fore200e =3D FORE200E_DEV(vcc->dev);=0A     stru=
ct fore200e_vcc*    fore200e_vcc;=0A-    struct fore200e*        fore200e;=
=0A     struct fore200e_vc_map* vc_map;=0A     unsigned long           flag=
s;=0A =0A     ASSERT(vcc);=0A-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-=
=0A     ASSERT((vcc->vpi >=3D 0) && (vcc->vpi < 1<<FORE200E_VPI_BITS));=0A =
    ASSERT((vcc->vci >=3D 0) && (vcc->vci < 1<<FORE200E_VCI_BITS));=0A =0A@=
@ -1466,10 +1464,10 @@ fore200e_close(struct atm_vcc* vcc)=0A static int=0A=
 fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)=0A {=0A-    struct=
 fore200e*        fore200e;=0A-    struct fore200e_vcc*    fore200e_vcc;=0A=
+    struct fore200e*        fore200e     =3D FORE200E_DEV(vcc->dev);=0A+  =
  struct fore200e_vcc*    fore200e_vcc =3D FORE200E_VCC(vcc);=0A     struct=
 fore200e_vc_map* vc_map;=0A-    struct host_txq*        txq;=0A+    struct=
 host_txq*        txq          =3D &fore200e->host_txq;=0A     struct host_=
txq_entry*  entry;=0A     struct tpd*             tpd;=0A     struct tpd_ha=
ddr        tpd_haddr;=0A@@ -1482,18 +1480,9 @@ fore200e_send(struct atm_vcc=
 *vcc, struct sk_buff *skb)=0A     unsigned char*          data;=0A     uns=
igned long           flags;=0A =0A-    if (!vcc)=0A-        return -EINVAL;=
=0A-=0A-    fore200e =3D FORE200E_DEV(vcc->dev);=0A-    fore200e_vcc =3D FO=
RE200E_VCC(vcc);=0A-=0A-    if (!fore200e)=0A-        return -EINVAL;=0A-=
=0A-    txq =3D &fore200e->host_txq;=0A-    if (!fore200e_vcc)=0A-        r=
eturn -EINVAL;=0A+    ASSERT(vcc);=0A+    ASSERT(fore200e);=0A+    ASSERT(f=
ore200e_vcc);=0A =0A     if (!test_bit(ATM_VF_READY, &vcc->flags)) {=0A 	DP=
RINTK(1, "VC %d.%d.%d not ready for tx\n", vcc->itf, vcc->vpi, vcc->vpi);=
=0A-- =0A2.30.2=0A=0A=0AFrom 18dbcbd8f72db44d9e8eb861addba772aa21fb4c Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:23 +0100=0ASubject: [PATCH 055/165] Revert "ra=
pidio: fix a NULL pointer dereference when=0A create_workqueue() fails"=0A=
=0AThis reverts commit 23015b22e47c5409620b1726a677d69e5cd032ba.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/rapidio/rio_cm.c | 8 --------=0A 1 file chan=
ged, 8 deletions(-)=0A=0Adiff --git a/drivers/rapidio/rio_cm.c b/drivers/ra=
pidio/rio_cm.c=0Aindex 50ec53d67a4c..e6c16f04f2b4 100644=0A--- a/drivers/ra=
pidio/rio_cm.c=0A+++ b/drivers/rapidio/rio_cm.c=0A@@ -2138,14 +2138,6 @@ st=
atic int riocm_add_mport(struct device *dev,=0A 	mutex_init(&cm->rx_lock);=
=0A 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);=0A 	cm->rx_wq =3D create_workqu=
eue(DRV_NAME "/rxq");=0A-	if (!cm->rx_wq) {=0A-		riocm_error("failed to all=
ocate IBMBOX_%d on %s",=0A-			    cmbox, mport->name);=0A-		rio_release_out=
b_mbox(mport, cmbox);=0A-		kfree(cm);=0A-		return -ENOMEM;=0A-	}=0A-=0A 	IN=
IT_WORK(&cm->rx_work, rio_ibmsg_handler);=0A =0A 	cm->tx_slot =3D 0;=0A-- =
=0A2.30.2=0A=0A=0AFrom 6a2ec25501566fbaadf164df9ac9d1e28080faaf Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:59:24 +0100=0ASubject: [PATCH 056/165] Revert "ASoC: cs=
43130: fix a NULL pointer=0A dereference"=0A=0AThis reverts commit a2be42f1=
8d409213bb7e7a736e3ef6ba005115bb.=0A=0ACommits from @umn.edu addresses have=
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
c/codecs/cs43130.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git=
 a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c=0Aindex 7fb34422=
a2a4..bb46e993c353 100644=0A--- a/sound/soc/codecs/cs43130.c=0A+++ b/sound/=
soc/codecs/cs43130.c=0A@@ -2319,8 +2319,6 @@ static int cs43130_probe(struc=
t snd_soc_component *component)=0A 			return ret;=0A =0A 		cs43130->wq =3D =
create_singlethread_workqueue("cs43130_hp");=0A-		if (!cs43130->wq)=0A-			r=
eturn -ENOMEM;=0A 		INIT_WORK(&cs43130->work, cs43130_imp_meas);=0A 	}=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 766b73808044907b040e7f59620c6b72a8218d40 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:25 +0100=0ASubject: [PATCH 057/165] Revert "AS=
oC: rt5645: fix a NULL pointer dereference"=0A=0AThis reverts commit 51dd97=
d1df5fb9ac58b9b358e63e67b530f6ae21.=0A=0ACommits from @umn.edu addresses ha=
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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/=
soc/codecs/rt5645.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --g=
it a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c=0Aindex 420003d0=
62c7..ed4b59ba63f3 100644=0A--- a/sound/soc/codecs/rt5645.c=0A+++ b/sound/s=
oc/codecs/rt5645.c=0A@@ -3419,9 +3419,6 @@ static int rt5645_probe(struct s=
nd_soc_component *component)=0A 		RT5645_HWEQ_NUM, sizeof(struct rt5645_eq_=
param_s),=0A 		GFP_KERNEL);=0A =0A-	if (!rt5645->eq_param)=0A-		return -ENO=
MEM;=0A-=0A 	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom dba3f2c4e469934=
b6d76720474e358f21ad0004d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:25 +0100=0ASubj=
ect: [PATCH 058/165] Revert "ALSA: usx2y: fix a double free bug"=0A=0AThis =
reverts commit cbb88db76a1536e02e93e5bd37ebbfbb6c4043a9.=0A=0ACommits from =
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
=2Ecom>=0A---=0A sound/usb/usx2y/usbusx2y.c | 4 +++-=0A 1 file changed, 3 i=
nsertions(+), 1 deletion(-)=0A=0Adiff --git a/sound/usb/usx2y/usbusx2y.c b/=
sound/usb/usx2y/usbusx2y.c=0Aindex c54158146917..01b4de83bee8 100644=0A--- =
a/sound/usb/usx2y/usbusx2y.c=0A+++ b/sound/usb/usx2y/usbusx2y.c=0A@@ -280,8=
 +280,10 @@ int usX2Y_In04_init(struct usX2Ydev *usX2Y)=0A 	if (! (usX2Y->I=
n04urb =3D usb_alloc_urb(0, GFP_KERNEL)))=0A 		return -ENOMEM;=0A =0A-	if (=
! (usX2Y->In04Buf =3D kmalloc(21, GFP_KERNEL)))=0A+	if (! (usX2Y->In04Buf =
=3D kmalloc(21, GFP_KERNEL))) {=0A+		usb_free_urb(usX2Y->In04urb);=0A 		ret=
urn -ENOMEM;=0A+	}=0A 	 =0A 	init_waitqueue_head(&usX2Y->In04WaitQueue);=0A=
 	usb_fill_int_urb(usX2Y->In04urb, usX2Y->dev, usb_rcvintpipe(usX2Y->dev, 0=
x4),=0A-- =0A2.30.2=0A=0A=0AFrom 45d65564bf6734817774e8a20ba1e417833d9aa6 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 19:59:26 +0100=0ASubject: [PATCH 059/165] Revert=
 "tracing: Fix a memory leak by early error=0A exit in trace_pid_write()"=
=0A=0AThis reverts commit 91862cc7867bba4ee5c8fcf0ca2f1d30427b6129.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A kernel/trace/trace.c | 5 +----=0A 1 file changed,=
 1 insertion(+), 4 deletions(-)=0A=0Adiff --git a/kernel/trace/trace.c b/ke=
rnel/trace/trace.c=0Aindex 8bfa4e78d895..4ec99bd96fbe 100644=0A--- a/kernel=
/trace/trace.c=0A+++ b/kernel/trace/trace.c=0A@@ -688,10 +688,8 @@ int trac=
e_pid_write(struct trace_pid_list *filtered_pids,=0A 	 * not modified.=0A 	=
 */=0A 	pid_list =3D kmalloc(sizeof(*pid_list), GFP_KERNEL);=0A-	if (!pid_l=
ist) {=0A-		trace_parser_put(&parser);=0A+	if (!pid_list)=0A 		return -ENOM=
EM;=0A-	}=0A =0A 	pid_list->pid_max =3D READ_ONCE(pid_max);=0A =0A@@ -701,7=
 +699,6 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,=0A =0A=
 	pid_list->pids =3D vzalloc((pid_list->pid_max + 7) >> 3);=0A 	if (!pid_li=
st->pids) {=0A-		trace_parser_put(&parser);=0A 		kfree(pid_list);=0A 		retu=
rn -ENOMEM;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 25b90ce67dadc93eda5406261d73a=
65727af87fa Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:27 +0100=0ASubject: [PATCH 06=
0/165] Revert "rsi: Fix NULL pointer dereference in kmalloc"=0A=0AThis reve=
rts commit d5414c2355b20ea8201156d2e874265f1cb0d775.=0A=0ACommits from @umn=
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
om>=0A---=0A drivers/net/wireless/rsi/rsi_91x_mac80211.c | 30 +++++++++----=
--------=0A 1 file changed, 12 insertions(+), 18 deletions(-)=0A=0Adiff --g=
it a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi=
/rsi_91x_mac80211.c=0Aindex 16025300cddb..714d4d53236c 100644=0A--- a/drive=
rs/net/wireless/rsi/rsi_91x_mac80211.c=0A+++ b/drivers/net/wireless/rsi/rsi=
_91x_mac80211.c=0A@@ -188,27 +188,27 @@ bool rsi_is_cipher_wep(struct rsi_c=
ommon *common)=0A  * @adapter: Pointer to the adapter structure.=0A  * @ban=
d: Operating band to be set.=0A  *=0A- * Return: int - 0 on success, negati=
ve error on failure.=0A+ * Return: None.=0A  */=0A-static int rsi_register_=
rates_channels(struct rsi_hw *adapter, int band)=0A+static void rsi_registe=
r_rates_channels(struct rsi_hw *adapter, int band)=0A {=0A 	struct ieee8021=
1_supported_band *sbands =3D &adapter->sbands[band];=0A 	void *channels =3D=
 NULL;=0A =0A 	if (band =3D=3D NL80211_BAND_2GHZ) {=0A-		channels =3D kmemd=
up(rsi_2ghz_channels, sizeof(rsi_2ghz_channels),=0A-				   GFP_KERNEL);=0A-=
		if (!channels)=0A-			return -ENOMEM;=0A+		channels =3D kmalloc(sizeof(rsi=
_2ghz_channels), GFP_KERNEL);=0A+		memcpy(channels,=0A+		       rsi_2ghz_ch=
annels,=0A+		       sizeof(rsi_2ghz_channels));=0A 		sbands->band =3D NL802=
11_BAND_2GHZ;=0A 		sbands->n_channels =3D ARRAY_SIZE(rsi_2ghz_channels);=0A=
 		sbands->bitrates =3D rsi_rates;=0A 		sbands->n_bitrates =3D ARRAY_SIZE(r=
si_rates);=0A 	} else {=0A-		channels =3D kmemdup(rsi_5ghz_channels, sizeof=
(rsi_5ghz_channels),=0A-				   GFP_KERNEL);=0A-		if (!channels)=0A-			retur=
n -ENOMEM;=0A+		channels =3D kmalloc(sizeof(rsi_5ghz_channels), GFP_KERNEL)=
;=0A+		memcpy(channels,=0A+		       rsi_5ghz_channels,=0A+		       sizeof(r=
si_5ghz_channels));=0A 		sbands->band =3D NL80211_BAND_5GHZ;=0A 		sbands->n=
_channels =3D ARRAY_SIZE(rsi_5ghz_channels);=0A 		sbands->bitrates =3D &rsi=
_rates[4];=0A@@ -227,7 +227,6 @@ static int rsi_register_rates_channels(str=
uct rsi_hw *adapter, int band)=0A 	sbands->ht_cap.mcs.rx_mask[0] =3D 0xff;=
=0A 	sbands->ht_cap.mcs.tx_params =3D IEEE80211_HT_MCS_TX_DEFINED;=0A 	/* s=
bands->ht_cap.mcs.rx_highest =3D 0x82; */=0A-	return 0;=0A }=0A =0A static =
int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,=0A@@ -2067,16 +2066=
,11 @@ int rsi_mac80211_attach(struct rsi_common *common)=0A 	wiphy->availa=
ble_antennas_rx =3D 1;=0A 	wiphy->available_antennas_tx =3D 1;=0A =0A-	stat=
us =3D rsi_register_rates_channels(adapter, NL80211_BAND_2GHZ);=0A-	if (sta=
tus)=0A-		return status;=0A+	rsi_register_rates_channels(adapter, NL80211_B=
AND_2GHZ);=0A 	wiphy->bands[NL80211_BAND_2GHZ] =3D=0A 		&adapter->sbands[NL=
80211_BAND_2GHZ];=0A 	if (common->num_supp_bands > 1) {=0A-		status =3D rsi=
_register_rates_channels(adapter,=0A-						     NL80211_BAND_5GHZ);=0A-		if=
 (status)=0A-			return status;=0A+		rsi_register_rates_channels(adapter, NL=
80211_BAND_5GHZ);=0A 		wiphy->bands[NL80211_BAND_5GHZ] =3D=0A 			&adapter->=
sbands[NL80211_BAND_5GHZ];=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 4f187fd43c1398=
977f15fa4dde87233ad47d3963 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:27 +0100=0ASub=
ject: [PATCH 061/165] Revert "net: cw1200: fix a NULL pointer dereference"=
=0A=0AThis reverts commit 0ed2a005347400500a39ea7c7318f1fea57fb3ca.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/net/wireless/st/cw1200/main.c | 5 -----=
=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/s=
t/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c=0Aindex 326b1cc1d2b=
c..015dd202e758 100644=0A--- a/drivers/net/wireless/st/cw1200/main.c=0A+++ =
b/drivers/net/wireless/st/cw1200/main.c=0A@@ -342,11 +342,6 @@ static struc=
t ieee80211_hw *cw1200_init_common(const u8 *macaddr,=0A 	mutex_init(&priv-=
>wsm_cmd_mux);=0A 	mutex_init(&priv->conf_mutex);=0A 	priv->workqueue =3D c=
reate_singlethread_workqueue("cw1200_wq");=0A-	if (!priv->workqueue) {=0A-	=
	ieee80211_free_hw(hw);=0A-		return NULL;=0A-	}=0A-=0A 	sema_init(&priv->sc=
an.lock, 1);=0A 	INIT_WORK(&priv->scan.work, cw1200_scan_work);=0A 	INIT_DE=
LAYED_WORK(&priv->scan.probe_work, cw1200_probe_work);=0A-- =0A2.30.2=0A=0A=
=0AFrom 36e2413c5fa54f7b6f82cbc36a73d98a25c22a27 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 19:59:28 +0100=0ASubject: [PATCH 062/165] Revert "net: ieee802154: fix =
missing checks for=0A regmap_update_bits"=0A=0AThis reverts commit 22e8860c=
f8f777fbf6a83f2fb7127f682a8e9de4.=0A=0ACommits from @umn.edu addresses have=
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
net/ieee802154/mcr20a.c | 6 ------=0A 1 file changed, 6 deletions(-)=0A=0Ad=
iff --git a/drivers/net/ieee802154/mcr20a.c b/drivers/net/ieee802154/mcr20a=
=2Ec=0Aindex 8dc04e2590b1..2ce5b41983f8 100644=0A--- a/drivers/net/ieee8021=
54/mcr20a.c=0A+++ b/drivers/net/ieee802154/mcr20a.c=0A@@ -524,8 +524,6 @@ m=
cr20a_start(struct ieee802154_hw *hw)=0A 	dev_dbg(printdev(lp), "no slotted=
 operation\n");=0A 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL=
1,=0A 				 DAR_PHY_CTRL1_SLOTTED, 0x0);=0A-	if (ret < 0)=0A-		return ret;=
=0A =0A 	/* enable irq */=0A 	enable_irq(lp->spi->irq);=0A@@ -533,15 +531,1=
1 @@ mcr20a_start(struct ieee802154_hw *hw)=0A 	/* Unmask SEQ interrupt */=
=0A 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL2,=0A 				 DAR_=
PHY_CTRL2_SEQMSK, 0x0);=0A-	if (ret < 0)=0A-		return ret;=0A =0A 	/* Start =
the RX sequence */=0A 	dev_dbg(printdev(lp), "start the RX sequence\n");=0A=
 	ret =3D regmap_update_bits(lp->regmap_dar, DAR_PHY_CTRL1,=0A 				 DAR_PHY=
_CTRL1_XCVSEQ_MASK, MCR20A_XCVSEQ_RX);=0A-	if (ret < 0)=0A-		return ret;=0A=
 =0A 	return 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 3f42f1e59e0d0c5a48e97bef6f=
5de29f95ae3dcb Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:28 +0100=0ASubject: [PATCH=
 063/165] Revert "x86/PCI: Fix PCI IRQ routing table memory=0A leak"=0A=0AT=
his reverts commit ea094d53580f40c2124cef3d072b73b2425e7bfd.=0A=0ACommits f=
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
mail.com>=0A---=0A arch/x86/pci/irq.c | 10 ++--------=0A 1 file changed, 2 =
insertions(+), 8 deletions(-)=0A=0Adiff --git a/arch/x86/pci/irq.c b/arch/x=
86/pci/irq.c=0Aindex d3a73f9335e1..52e55108404e 100644=0A--- a/arch/x86/pci=
/irq.c=0A+++ b/arch/x86/pci/irq.c=0A@@ -1119,8 +1119,6 @@ static const stru=
ct dmi_system_id pciirq_dmi_table[] __initconst =3D {=0A =0A void __init pc=
ibios_irq_init(void)=0A {=0A-	struct irq_routing_table *rtable =3D NULL;=0A=
-=0A 	DBG(KERN_DEBUG "PCI: IRQ init\n");=0A =0A 	if (raw_pci_ops =3D=3D NUL=
L)=0A@@ -1131,10 +1129,8 @@ void __init pcibios_irq_init(void)=0A 	pirq_tab=
le =3D pirq_find_routing_table();=0A =0A #ifdef CONFIG_PCI_BIOS=0A-	if (!pi=
rq_table && (pci_probe & PCI_BIOS_IRQ_SCAN)) {=0A+	if (!pirq_table && (pci_=
probe & PCI_BIOS_IRQ_SCAN))=0A 		pirq_table =3D pcibios_get_irq_routing_tab=
le();=0A-		rtable =3D pirq_table;=0A-	}=0A #endif=0A 	if (pirq_table) {=0A =
		pirq_peer_trick();=0A@@ -1149,10 +1145,8 @@ void __init pcibios_irq_init(=
void)=0A 		 * If we're using the I/O APIC, avoid using the PCI IRQ=0A 		 * =
routing table=0A 		 */=0A-		if (io_apic_assign_pci_irqs) {=0A-			kfree(rtab=
le);=0A+		if (io_apic_assign_pci_irqs)=0A 			pirq_table =3D NULL;=0A-		}=0A=
 	}=0A =0A 	x86_init.pci.fixup_irqs();=0A-- =0A2.30.2=0A=0A=0AFrom 61b6a350=
cd07d26a554a3ce08c3d41736761dae5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:29 +0100=
=0ASubject: [PATCH 064/165] Revert "udf: fix an uninitialized read bug and =
remove=0A dead code"=0A=0AThis reverts commit 39416c5872db69859e867fa250b9c=
bb3f1e0d185.=0A=0ACommits from @umn.edu addresses have been found to be sub=
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
Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A fs/udf/namei.c | 15 +++++++=
++++++++=0A 1 file changed, 15 insertions(+)=0A=0Adiff --git a/fs/udf/namei=
=2Ec b/fs/udf/namei.c=0Aindex e169d8fe35b5..4b14225683f6 100644=0A--- a/fs/=
udf/namei.c=0A+++ b/fs/udf/namei.c=0A@@ -304,6 +304,21 @@ static struct den=
try *udf_lookup(struct inode *dir, struct dentry *dentry,=0A 	if (dentry->d=
_name.len > UDF_NAME_LEN)=0A 		return ERR_PTR(-ENAMETOOLONG);=0A =0A+#ifdef=
 UDF_RECOVERY=0A+	/* temporary shorthand for specifying files by inode numb=
er */=0A+	if (!strncmp(dentry->d_name.name, ".B=3D", 3)) {=0A+		struct kern=
el_lb_addr lb =3D {=0A+			.logicalBlockNum =3D 0,=0A+			.partitionReference=
Num =3D=0A+				simple_strtoul(dentry->d_name.name + 3,=0A+						NULL, 0),=
=0A+		};=0A+		inode =3D udf_iget(dir->i_sb, lb);=0A+		if (IS_ERR(inode))=0A=
+			return inode;=0A+	} else=0A+#endif /* UDF_RECOVERY */=0A+=0A 	fi =3D ud=
f_find_entry(dir, &dentry->d_name, &fibh, &cfi);=0A 	if (IS_ERR(fi))=0A 		r=
eturn ERR_CAST(fi);=0A-- =0A2.30.2=0A=0A=0AFrom d1815432a655c1f269edfee70bc=
2720c5a445641 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:30 +0100=0ASubject: [PATCH =
065/165] Revert "mmc_spi: add a status check for=0A spi_sync_locked"=0A=0AT=
his reverts commit 611025983b7976df0183390a63a2166411d177f1.=0A=0ACommits f=
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
mail.com>=0A---=0A drivers/mmc/host/mmc_spi.c | 4 ----=0A 1 file changed, 4=
 deletions(-)=0A=0Adiff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/ho=
st/mmc_spi.c=0Aindex 02f4fd26e76a..cc40b050e302 100644=0A--- a/drivers/mmc/=
host/mmc_spi.c=0A+++ b/drivers/mmc/host/mmc_spi.c=0A@@ -800,10 +800,6 @@ mm=
c_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,=0A 	}=0A=
 =0A 	status =3D spi_sync_locked(spi, &host->m);=0A-	if (status < 0) {=0A-	=
	dev_dbg(&spi->dev, "read error %d\n", status);=0A-		return status;=0A-	}=
=0A =0A 	if (host->dma_dev) {=0A 		dma_sync_single_for_cpu(host->dma_dev,=
=0A-- =0A2.30.2=0A=0A=0AFrom a165ff5d9803968c4b2469a43d7b28b9556b6411 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 19:59:30 +0100=0ASubject: [PATCH 066/165] Revert "PC=
I: endpoint: Fix a potential NULL pointer=0A dereference"=0A=0AThis reverts=
 commit 507b820009a457afa78202da337bcb56791fbb12.=0A=0ACommits from @umn.ed=
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
=0A---=0A drivers/pci/endpoint/functions/pci-epf-test.c | 5 -----=0A 1 file=
 changed, 5 deletions(-)=0A=0Adiff --git a/drivers/pci/endpoint/functions/p=
ci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c=0Aindex e4e51=
d884553..6d15e4c987f9 100644=0A--- a/drivers/pci/endpoint/functions/pci-epf=
-test.c=0A+++ b/drivers/pci/endpoint/functions/pci-epf-test.c=0A@@ -910,11 =
+910,6 @@ static int __init pci_epf_test_init(void)=0A =0A 	kpcitest_workqu=
eue =3D alloc_workqueue("kpcitest",=0A 					     WQ_MEM_RECLAIM | WQ_HIGHPR=
I, 0);=0A-	if (!kpcitest_workqueue) {=0A-		pr_err("Failed to allocate the k=
pcitest work queue\n");=0A-		return -ENOMEM;=0A-	}=0A-=0A 	ret =3D pci_epf_=
register_driver(&test_driver);=0A 	if (ret) {=0A 		pr_err("Failed to regist=
er pci epf test driver --> %d\n", ret);=0A-- =0A2.30.2=0A=0A=0AFrom 9210d0f=
9551950307ef1c8b35dcb2b6077a35517 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:31 +010=
0=0ASubject: [PATCH 067/165] Revert "net/smc: fix a NULL pointer dereferenc=
e"=0A=0AThis reverts commit e183d4e414b64711baf7a04e214b61969ca08dfa.=0A=0A=
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
kherjee@gmail.com>=0A---=0A net/smc/smc_ism.c | 5 -----=0A 1 file changed, =
5 deletions(-)=0A=0Adiff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c=0Ain=
dex 6abbdd09a580..b4a9fe452470 100644=0A--- a/net/smc/smc_ism.c=0A+++ b/net=
/smc/smc_ism.c=0A@@ -319,11 +319,6 @@ struct smcd_dev *smcd_alloc_dev(struc=
t device *parent, const char *name,=0A 	init_waitqueue_head(&smcd->lgrs_del=
eted);=0A 	smcd->event_wq =3D alloc_ordered_workqueue("ism_evt_wq-%s)",=0A =
						 WQ_MEM_RECLAIM, name);=0A-	if (!smcd->event_wq) {=0A-		kfree(smcd->c=
onn);=0A-		kfree(smcd);=0A-		return NULL;=0A-	}=0A 	return smcd;=0A }=0A EX=
PORT_SYMBOL_GPL(smcd_alloc_dev);=0A-- =0A2.30.2=0A=0A=0AFrom 8e85ddea65a0be=
81d72d3aa85250d4efc8f9448d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:32 +0100=0ASub=
ject: [PATCH 068/165] Revert "pinctrl: axp209: Fix NULL pointer dereference=
=0A after allocation"=0A=0AThis reverts commit 1adc90c7395742827d754a5f02f4=
46818a77c379.=0A=0ACommits from @umn.edu addresses have been found to be su=
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
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/pinctrl/pinctrl-axp2=
09.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/pin=
ctrl/pinctrl-axp209.c b/drivers/pinctrl/pinctrl-axp209.c=0Aindex 207cbae3a7=
bf..58f7149dd39b 100644=0A--- a/drivers/pinctrl/pinctrl-axp209.c=0A+++ b/dr=
ivers/pinctrl/pinctrl-axp209.c=0A@@ -365,8 +365,6 @@ static int axp20x_buil=
d_funcs_groups(struct platform_device *pdev)=0A 		pctl->funcs[i].groups =3D=
 devm_kcalloc(&pdev->dev,=0A 						     npins, sizeof(char *),=0A 						   =
  GFP_KERNEL);=0A-		if (!pctl->funcs[i].groups)=0A-			return -ENOMEM;=0A 		=
for (pin =3D 0; pin < npins; pin++)=0A 			pctl->funcs[i].groups[pin] =3D pc=
tl->desc->pins[pin].name;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 0bf428df114c6d4=
c803df81e06f79e57ffb68271 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:32 +0100=0ASubj=
ect: [PATCH 069/165] Revert "iio: hmc5843: fix potential NULL pointer=0A de=
references"=0A=0AThis reverts commit 536cc27deade8f1ec3c1beefa60d5fbe0f6fcb=
28.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/iio/magnetometer/hmc5843_i2c=
=2Ec | 7 +------=0A drivers/iio/magnetometer/hmc5843_spi.c | 7 +------=0A 2=
 files changed, 2 insertions(+), 12 deletions(-)=0A=0Adiff --git a/drivers/=
iio/magnetometer/hmc5843_i2c.c b/drivers/iio/magnetometer/hmc5843_i2c.c=0Ai=
ndex 67fe657fdb3e..9a4491233d08 100644=0A--- a/drivers/iio/magnetometer/hmc=
5843_i2c.c=0A+++ b/drivers/iio/magnetometer/hmc5843_i2c.c=0A@@ -55,13 +55,8=
 @@ static const struct regmap_config hmc5843_i2c_regmap_config =3D {=0A st=
atic int hmc5843_i2c_probe(struct i2c_client *cli,=0A 			     const struct =
i2c_device_id *id)=0A {=0A-	struct regmap *regmap =3D devm_regmap_init_i2c(=
cli,=0A-			&hmc5843_i2c_regmap_config);=0A-	if (IS_ERR(regmap))=0A-		return=
 PTR_ERR(regmap);=0A-=0A 	return hmc5843_common_probe(&cli->dev,=0A-			regm=
ap,=0A+			devm_regmap_init_i2c(cli, &hmc5843_i2c_regmap_config),=0A 			id->=
driver_data, id->name);=0A }=0A =0Adiff --git a/drivers/iio/magnetometer/hm=
c5843_spi.c b/drivers/iio/magnetometer/hmc5843_spi.c=0Aindex d827554c346e..=
58bdbc7257ec 100644=0A--- a/drivers/iio/magnetometer/hmc5843_spi.c=0A+++ b/=
drivers/iio/magnetometer/hmc5843_spi.c=0A@@ -55,7 +55,6 @@ static const str=
uct regmap_config hmc5843_spi_regmap_config =3D {=0A static int hmc5843_spi=
_probe(struct spi_device *spi)=0A {=0A 	int ret;=0A-	struct regmap *regmap;=
=0A 	const struct spi_device_id *id =3D spi_get_device_id(spi);=0A =0A 	spi=
->mode =3D SPI_MODE_3;=0A@@ -65,12 +64,8 @@ static int hmc5843_spi_probe(st=
ruct spi_device *spi)=0A 	if (ret)=0A 		return ret;=0A =0A-	regmap =3D devm=
_regmap_init_spi(spi, &hmc5843_spi_regmap_config);=0A-	if (IS_ERR(regmap))=
=0A-		return PTR_ERR(regmap);=0A-=0A 	return hmc5843_common_probe(&spi->dev=
,=0A-			regmap,=0A+			devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config)=
,=0A 			id->driver_data, id->name);=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom d0=
3047993bc574f7f5402f54b0bba1d4920789e6 Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:33=
 +0100=0ASubject: [PATCH 070/165] Revert "iio: adc: fix a potential NULL po=
inter=0A dereference"=0A=0AThis reverts commit 13814627c9658cf8382dd052bc25=
1ee415670a55.=0A=0ACommits from @umn.edu addresses have been found to be su=
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
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/iio/adc/mxs-lradc-ad=
c.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/iio/=
adc/mxs-lradc-adc.c b/drivers/iio/adc/mxs-lradc-adc.c=0Aindex 30e29f44ebd2.=
=2E7f327ae95739 100644=0A--- a/drivers/iio/adc/mxs-lradc-adc.c=0A+++ b/driv=
ers/iio/adc/mxs-lradc-adc.c=0A@@ -456,8 +456,6 @@ static int mxs_lradc_adc_=
trigger_init(struct iio_dev *iio)=0A =0A 	trig =3D devm_iio_trigger_alloc(&=
iio->dev, "%s-dev%i", iio->name,=0A 				      iio->id);=0A-	if (!trig)=0A-	=
	return -ENOMEM;=0A =0A 	trig->dev.parent =3D adc->dev;=0A 	iio_trigger_set=
_drvdata(trig, iio);=0A-- =0A2.30.2=0A=0A=0AFrom 4a67f50d48c4ed9484453ecafb=
931044b8d0ad01 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.muk=
herjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:34 +0100=0ASubject: [PATCH=
 071/165] Revert "net: mwifiex: fix a NULL pointer dereference"=0A=0AThis r=
everts commit e5b9b206f3f6376b9a1406b67eafe4e7bb9f123c.=0A=0ACommits from @=
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
l.com>=0A---=0A drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 ------=0A=
 1 file changed, 6 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/marv=
ell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c=0Ainde=
x 3a11342a6bde..bda8a236e386 100644=0A--- a/drivers/net/wireless/marvell/mw=
ifiex/cmdevt.c=0A+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c=0A@@ -=
339,12 +339,6 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_a=
dapter *adapter)=0A 		sleep_cfm_tmp =3D=0A 			dev_alloc_skb(sizeof(struct m=
wifiex_opt_sleep_confirm)=0A 				      + MWIFIEX_TYPE_LEN);=0A-		if (!sleep=
_cfm_tmp) {=0A-			mwifiex_dbg(adapter, ERROR,=0A-				    "SLEEP_CFM: dev_al=
loc_skb failed\n");=0A-			return -ENOMEM;=0A-		}=0A-=0A 		skb_put(sleep_cfm=
_tmp, sizeof(struct mwifiex_opt_sleep_confirm)=0A 			+ MWIFIEX_TYPE_LEN);=
=0A 		put_unaligned_le32(MWIFIEX_USB_TYPE_CMD, sleep_cfm_tmp->data);=0A-- =
=0A2.30.2=0A=0A=0AFrom 98832ea9d38503bb2193bb1ed959442343cde0eb Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:59:34 +0100=0ASubject: [PATCH 072/165] Revert "rtlwifi:=
 fix a potential NULL pointer=0A dereference"=0A=0AThis reverts commit 7659=
76285a8c8db3f0eb7f033829a899d0c2786e.=0A=0ACommits from @umn.edu addresses =
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
drivers/net/wireless/realtek/rtlwifi/base.c | 5 -----=0A 1 file changed, 5 =
deletions(-)=0A=0Adiff --git a/drivers/net/wireless/realtek/rtlwifi/base.c =
b/drivers/net/wireless/realtek/rtlwifi/base.c=0Aindex 6e8bd99e8911..1d06753=
6889e 100644=0A--- a/drivers/net/wireless/realtek/rtlwifi/base.c=0A+++ b/dr=
ivers/net/wireless/realtek/rtlwifi/base.c=0A@@ -452,11 +452,6 @@ static voi=
d _rtl_init_deferred_work(struct ieee80211_hw *hw)=0A 	/* <2> work queue */=
=0A 	rtlpriv->works.hw =3D hw;=0A 	rtlpriv->works.rtl_wq =3D alloc_workqueu=
e("%s", 0, 0, rtlpriv->cfg->name);=0A-	if (unlikely(!rtlpriv->works.rtl_wq)=
) {=0A-		pr_err("Failed to allocate work queue\n");=0A-		return;=0A-	}=0A-=
=0A 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,=0A 			  rtl_watchdog_wq=
_callback);=0A 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,=0A-- =0A2=
=2E30.2=0A=0A=0AFrom 0d55193ee9a3da7ab0b6738cdf8eb697d78abd54 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 19:59:35 +0100=0ASubject: [PATCH 073/165] Revert "video: hga=
fb: fix potential NULL pointer=0A dereference"=0A=0AThis reverts commit ec7=
f6aad57ad29e4e66cc2e18e1e1599ddb02542.=0A=0ACommits from @umn.edu addresses=
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
drivers/video/fbdev/hgafb.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Ad=
iff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c=0Aind=
ex a45fcff1461f..4da5abf5bc8f 100644=0A--- a/drivers/video/fbdev/hgafb.c=0A=
+++ b/drivers/video/fbdev/hgafb.c=0A@@ -285,8 +285,6 @@ static int hga_card=
_detect(void)=0A 	hga_vram_len  =3D 0x08000;=0A =0A 	hga_vram =3D ioremap(0=
xb0000, hga_vram_len);=0A-	if (!hga_vram)=0A-		goto error;=0A =0A 	if (requ=
est_region(0x3b0, 12, "hgafb"))=0A 		release_io_ports =3D 1;=0A-- =0A2.30.2=
=0A=0A=0AFrom 1c9e5abe15594a192f214a0c456fc161703a6816 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:59:36 +0100=0ASubject: [PATCH 074/165] Revert "video: imsttfb: f=
ix potential NULL pointer=0A dereferences"=0A=0AThis reverts commit 1d84353=
d205a953e2381044953b7fa31c8c9702d.=0A=0ACommits from @umn.edu addresses hav=
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
/video/fbdev/imsttfb.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adif=
f --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c=0Ai=
ndex 3ac053b88495..e04411701ec8 100644=0A--- a/drivers/video/fbdev/imsttfb.=
c=0A+++ b/drivers/video/fbdev/imsttfb.c=0A@@ -1512,11 +1512,6 @@ static int=
 imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)=0A 	i=
nfo->fix.smem_start =3D addr;=0A 	info->screen_base =3D (__u8 *)ioremap(add=
r, par->ramdac =3D=3D IBM ?=0A 					    0x400000 : 0x800000);=0A-	if (!info=
->screen_base) {=0A-		release_mem_region(addr, size);=0A-		framebuffer_rele=
ase(info);=0A-		return -ENOMEM;=0A-	}=0A 	info->fix.mmio_start =3D addr + 0=
x800000;=0A 	par->dc_regs =3D ioremap(addr + 0x800000, 0x1000);=0A 	par->cm=
ap_regs_phys =3D addr + 0x840000;=0A-- =0A2.30.2=0A=0A=0AFrom 4e4b217e4f3dc=
05701e818fb9dd9ae1e53857396 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:36 +0100=0ASu=
bject: [PATCH 075/165] Revert "rfkill: Fix incorrect check to avoid NULL=0A=
 pointer dereference"=0A=0AThis reverts commit 6fc232db9e8cd50b9b83534de9cd=
91ace711b2d7.=0A=0ACommits from @umn.edu addresses have been found to be su=
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
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/rfkill/core.c | 7 ++----=
-=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/net/=
rfkill/core.c b/net/rfkill/core.c=0Aindex 97101c55763d..bee506cf07ae 100644=
=0A--- a/net/rfkill/core.c=0A+++ b/net/rfkill/core.c=0A@@ -1005,13 +1005,10=
 @@ static void rfkill_sync_work(struct work_struct *work)=0A int __must_ch=
eck rfkill_register(struct rfkill *rfkill)=0A {=0A 	static unsigned long rf=
kill_no;=0A-	struct device *dev;=0A+	struct device *dev =3D &rfkill->dev;=
=0A 	int error;=0A =0A-	if (!rfkill)=0A-		return -EINVAL;=0A-=0A-	dev =3D &=
rfkill->dev;=0A+	BUG_ON(!rfkill);=0A =0A 	mutex_lock(&rfkill_global_mutex);=
=0A =0A-- =0A2.30.2=0A=0A=0AFrom 82ab85e49671e57357b1a90224382fbae27975c2 M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 19:59:37 +0100=0ASubject: [PATCH 076/165] Revert=
 "PCI: xilinx: Check for __get_free_pages()=0A failure"=0A=0AThis reverts c=
ommit 699ca30162686bf305cdf94861be02eb0cf9bda2.=0A=0ACommits from @umn.edu =
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
--=0A drivers/pci/controller/pcie-xilinx.c | 12 ++----------=0A 1 file chan=
ged, 2 insertions(+), 10 deletions(-)=0A=0Adiff --git a/drivers/pci/control=
ler/pcie-xilinx.c b/drivers/pci/controller/pcie-xilinx.c=0Aindex 8523be61bb=
a5..130d3a9ca099 100644=0A--- a/drivers/pci/controller/pcie-xilinx.c=0A+++ =
b/drivers/pci/controller/pcie-xilinx.c=0A@@ -333,19 +333,14 @@ static const=
 struct irq_domain_ops msi_domain_ops =3D {=0A  * xilinx_pcie_enable_msi - =
Enable MSI support=0A  * @port: PCIe port information=0A  */=0A-static int =
xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)=0A+static void xilinx=
_pcie_enable_msi(struct xilinx_pcie_port *port)=0A {=0A 	phys_addr_t msg_ad=
dr;=0A =0A 	port->msi_pages =3D __get_free_pages(GFP_KERNEL, 0);=0A-	if (!p=
ort->msi_pages)=0A-		return -ENOMEM;=0A-=0A 	msg_addr =3D virt_to_phys((voi=
d *)port->msi_pages);=0A 	pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);=
=0A 	pcie_write(port, msg_addr, XILINX_PCIE_REG_MSIBASE2);=0A-=0A-	return 0=
;=0A }=0A =0A /* INTx Functions */=0A@@ -500,7 +495,6 @@ static int xilinx_=
pcie_init_irq_domain(struct xilinx_pcie_port *port)=0A 	struct device *dev =
=3D port->dev;=0A 	struct device_node *node =3D dev->of_node;=0A 	struct de=
vice_node *pcie_intc_node;=0A-	int ret;=0A =0A 	/* Setup INTx */=0A 	pcie_i=
ntc_node =3D of_get_next_child(node, NULL);=0A@@ -529,9 +523,7 @@ static in=
t xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)=0A 			return -=
ENODEV;=0A 		}=0A =0A-		ret =3D xilinx_pcie_enable_msi(port);=0A-		if (ret)=
=0A-			return ret;=0A+		xilinx_pcie_enable_msi(port);=0A 	}=0A =0A 	return =
0;=0A-- =0A2.30.2=0A=0A=0AFrom 422a2c86ed80803c05fd57da2213c52d3e703d9a Mon=
 Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=
=0ADate: Wed, 21 Apr 2021 19:59:37 +0100=0ASubject: [PATCH 077/165] Revert =
"staging: greybus: audio_manager: fix a=0A missing check of ida_simple_get"=
=0A=0AThis reverts commit b5af36e3e5aa074605a4d90a89dd8f714b30909b.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/staging/greybus/audio_manager.c | 3 ---=
=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/drivers/staging/greybu=
s/audio_manager.c b/drivers/staging/greybus/audio_manager.c=0Aindex 9a3f7c0=
34ab4..7c7ca671876d 100644=0A--- a/drivers/staging/greybus/audio_manager.c=
=0A+++ b/drivers/staging/greybus/audio_manager.c=0A@@ -45,9 +45,6 @@ int gb=
_audio_manager_add(struct gb_audio_manager_module_descriptor *desc)=0A 	int=
 err;=0A =0A 	id =3D ida_simple_get(&module_id, 0, 0, GFP_KERNEL);=0A-	if (=
id < 0)=0A-		return id;=0A-=0A 	err =3D gb_audio_manager_module_create(&mod=
ule, manager_kset,=0A 					     id, desc);=0A 	if (err) {=0A-- =0A2.30.2=0A=
=0A=0AFrom a70336d665a8a240ac74df8efb90d18357026e30 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:59:38 +0100=0ASubject: [PATCH 078/165] Revert "omapfb: Fix potentia=
l NULL pointer=0A dereference in kmalloc"=0A=0AThis reverts commit 31fa6e2a=
e65feed0de10823c5d1eea21a93086c9.=0A=0ACommits from @umn.edu addresses have=
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
video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c | 2 --=0A 1 file changed, =
2 deletions(-)=0A=0Adiff --git a/drivers/video/fbdev/omap2/omapfb/dss/omapd=
ss-boot-init.c b/drivers/video/fbdev/omap2/omapfb/dss/omapdss-boot-init.c=
=0Aindex 0ae0cab252d3..05d87dcbdd8b 100644=0A--- a/drivers/video/fbdev/omap=
2/omapfb/dss/omapdss-boot-init.c=0A+++ b/drivers/video/fbdev/omap2/omapfb/d=
ss/omapdss-boot-init.c=0A@@ -100,8 +100,6 @@ static void __init omapdss_oma=
pify_node(struct device_node *node)=0A =0A 	new_len =3D prop->length + strl=
en(prefix) * num_strs;=0A 	new_compat =3D kmalloc(new_len, GFP_KERNEL);=0A-=
	if (!new_compat)=0A-		return;=0A =0A 	omapdss_prefix_strcpy(new_compat, ne=
w_len, prop->value, prop->length);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 05f3d671=
b36afec5b9c035fa2e475ee10884368f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:39 +0100=
=0ASubject: [PATCH 079/165] Revert "media: video-mux: fix null pointer=0A d=
ereferences"=0A=0AThis reverts commit aeb0d0f581e2079868e64a2e5ee346d340376=
eae.=0A=0ACommits from @umn.edu addresses have been found to be submitted i=
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
<sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/platform/video-mux.c | =
5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers/media/p=
latform/video-mux.c b/drivers/media/platform/video-mux.c=0Aindex 53570250a2=
5d..d4abb25d4378 100644=0A--- a/drivers/media/platform/video-mux.c=0A+++ b/=
drivers/media/platform/video-mux.c=0A@@ -448,14 +448,9 @@ static int video_=
mux_probe(struct platform_device *pdev)=0A 	vmux->active =3D -1;=0A 	vmux->=
pads =3D devm_kcalloc(dev, num_pads, sizeof(*vmux->pads),=0A 				  GFP_KERN=
EL);=0A-	if (!vmux->pads)=0A-		return -ENOMEM;=0A-=0A 	vmux->format_mbus =
=3D devm_kcalloc(dev, num_pads,=0A 					 sizeof(*vmux->format_mbus),=0A 			=
		 GFP_KERNEL);=0A-	if (!vmux->format_mbus)=0A-		return -ENOMEM;=0A =0A 	fo=
r (i =3D 0; i < num_pads; i++) {=0A 		vmux->pads[i].flags =3D (i < num_pads=
 - 1) ? MEDIA_PAD_FL_SINK=0A-- =0A2.30.2=0A=0A=0AFrom c0030cc587f5e427573bc=
41220927ca3e5937b2a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:39 +0100=0ASubject: [=
PATCH 080/165] Revert "thunderbolt: property: Fix a missing check of=0A kza=
lloc"=0A=0AThis reverts commit 6183d5a51866f3acdeeb66b75e87d44025b01a55.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/thunderbolt/property.c | 7 +------=
=0A 1 file changed, 1 insertion(+), 6 deletions(-)=0A=0Adiff --git a/driver=
s/thunderbolt/property.c b/drivers/thunderbolt/property.c=0Aindex d5b0cdb8f=
0b1..841314deb446 100644=0A--- a/drivers/thunderbolt/property.c=0A+++ b/dri=
vers/thunderbolt/property.c=0A@@ -587,12 +587,7 @@ int tb_property_add_text=
(struct tb_property_dir *parent, const char *key,=0A 		return -ENOMEM;=0A =
=0A 	property->length =3D size / 4;=0A-	property->value.text =3D kzalloc(si=
ze, GFP_KERNEL);=0A-	if (!property->value.text) {=0A-		kfree(property);=0A-=
		return -ENOMEM;=0A-	}=0A-=0A+	property->value.data =3D kzalloc(size, GFP_=
KERNEL);=0A 	strcpy(property->value.text, text);=0A =0A 	list_add_tail(&pro=
perty->list, &parent->properties);=0A-- =0A2.30.2=0A=0A=0AFrom fdf8ae846653=
89650e6b61ded951828770bf9574 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:40 +0100=0AS=
ubject: [PATCH 081/165] Revert "char: hpet: fix a missing check of ioremap"=
=0A=0AThis reverts commit 13bd14a41ce3105d5b1f3cd8b4d1e249d17b6d9b.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/char/hpet.c | 2 --=0A 1 file changed, 2 d=
eletions(-)=0A=0Adiff --git a/drivers/char/hpet.c b/drivers/char/hpet.c=0Ai=
ndex ed3b7dab678d..6f13def6c172 100644=0A--- a/drivers/char/hpet.c=0A+++ b/=
drivers/char/hpet.c=0A@@ -969,8 +969,6 @@ static acpi_status hpet_resources=
(struct acpi_resource *res, void *data)=0A 	if (ACPI_SUCCESS(status)) {=0A =
		hdp->hd_phys_address =3D addr.address.minimum;=0A 		hdp->hd_address =3D i=
oremap(addr.address.minimum, addr.address.address_length);=0A-		if (!hdp->h=
d_address)=0A-			return AE_ERROR;=0A =0A 		if (hpet_is_known(hdp)) {=0A 			=
iounmap(hdp->hd_address);=0A-- =0A2.30.2=0A=0A=0AFrom 2ab473d663982ce5bd109=
5f51d3de68a38e1e609 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:41 +0100=0ASubject: [=
PATCH 082/165] Revert "media: rcar_drif: fix a memory disclosure"=0A=0AThis=
 reverts commit d39083234c60519724c6ed59509a2129fd2aed41.=0A=0ACommits from=
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
l.com>=0A---=0A drivers/media/platform/rcar_drif.c | 1 -=0A 1 file changed,=
 1 deletion(-)=0A=0Adiff --git a/drivers/media/platform/rcar_drif.c b/drive=
rs/media/platform/rcar_drif.c=0Aindex f318cd4b8086..083dba95beaa 100644=0A-=
-- a/drivers/media/platform/rcar_drif.c=0A+++ b/drivers/media/platform/rcar=
_drif.c=0A@@ -915,7 +915,6 @@ static int rcar_drif_g_fmt_sdr_cap(struct fil=
e *file, void *priv,=0A {=0A 	struct rcar_drif_sdr *sdr =3D video_drvdata(f=
ile);=0A =0A-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));=
=0A 	f->fmt.sdr.pixelformat =3D sdr->fmt->pixelformat;=0A 	f->fmt.sdr.buffe=
rsize =3D sdr->fmt->buffersize;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 7f3cc4bce14=
26fa60be9d4803b8431c66370e8d5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:41 +0100=0A=
Subject: [PATCH 083/165] Revert "net: caif: replace BUG_ON with recovery co=
de"=0A=0AThis reverts commit c5dea815834c7d2e9fc633785455bc428b7a1956.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/net/caif/caif_serial.c | 4 +---=0A =
1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/ne=
t/caif/caif_serial.c b/drivers/net/caif/caif_serial.c=0Aindex bcc14c5875bf.=
=2E4cc0d91d9c87 100644=0A--- a/drivers/net/caif/caif_serial.c=0A+++ b/drive=
rs/net/caif/caif_serial.c=0A@@ -270,9 +270,7 @@ static netdev_tx_t caif_xmi=
t(struct sk_buff *skb, struct net_device *dev)=0A {=0A 	struct ser_device *=
ser;=0A =0A-	if (WARN_ON(!dev))=0A-		return -EINVAL;=0A-=0A+	BUG_ON(dev =3D=
=3D NULL);=0A 	ser =3D netdev_priv(dev);=0A =0A 	/* Send flow off once, on =
high water mark */=0A-- =0A2.30.2=0A=0A=0AFrom aec3d0ca86a4abeca8b4619a9217=
33ecde18d56a Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:42 +0100=0ASubject: [PATCH 0=
84/165] Revert "drm/gma500: fix memory disclosures due to=0A uninitialized =
bytes"=0A=0AThis reverts commit ec3b7b6eb8c90b52f61adff11b6db7a8db34de19.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/oaktrail_crtc=
=2Ec | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers/gpu=
/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oaktrail_crtc.c=0Ainde=
x 900e5499249d..167c10767dd4 100644=0A--- a/drivers/gpu/drm/gma500/oaktrail=
_crtc.c=0A+++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c=0A@@ -129,7 +129,6 @=
@ static bool mrst_sdvo_find_best_pll(const struct gma_limit_t *limit,=0A 	=
s32 freq_error, min_error =3D 100000;=0A =0A 	memset(best_clock, 0, sizeof(=
*best_clock));=0A-	memset(&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =
=3D limit->m.min; clock.m <=3D limit->m.max; clock.m++) {=0A 		for (clock.n=
 =3D limit->n.min; clock.n <=3D limit->n.max;=0A@@ -186,7 +185,6 @@ static =
bool mrst_lvds_find_best_pll(const struct gma_limit_t *limit,=0A 	int err =
=3D target;=0A =0A 	memset(best_clock, 0, sizeof(*best_clock));=0A-	memset(=
&clock, 0, sizeof(clock));=0A =0A 	for (clock.m =3D limit->m.min; clock.m <=
=3D limit->m.max; clock.m++) {=0A 		for (clock.p1 =3D limit->p1.min; clock.=
p1 <=3D limit->p1.max;=0A-- =0A2.30.2=0A=0A=0AFrom 8474e7fe003322ff21386a5c=
d2b32a55f46184af Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:42 +0100=0ASubject: [PAT=
CH 085/165] Revert "gma/gma500: fix a memory disclosure bug due=0A to unini=
tialized bytes"=0A=0AThis reverts commit 57a25a5f754ce27da2cfa6f413cfd366f8=
78db76.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/gpu/drm/gma500/cdv_intel=
_display.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drive=
rs/gpu/drm/gma500/cdv_intel_display.c b/drivers/gpu/drm/gma500/cdv_intel_di=
splay.c=0Aindex 686385a66167..492ca9404bbe 100644=0A--- a/drivers/gpu/drm/g=
ma500/cdv_intel_display.c=0A+++ b/drivers/gpu/drm/gma500/cdv_intel_display.=
c=0A@@ -405,8 +405,6 @@ static bool cdv_intel_find_dp_pll(const struct gma_=
limit_t *limit,=0A 	struct gma_crtc *gma_crtc =3D to_gma_crtc(crtc);=0A 	st=
ruct gma_clock_t clock;=0A =0A-	memset(&clock, 0, sizeof(clock));=0A-=0A 	s=
witch (refclk) {=0A 	case 27000:=0A 		if (target < 200000) {=0A-- =0A2.30.2=
=0A=0A=0AFrom 32bbca7e9334f0e1247c4499e5bd40ba14f35632 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 19:59:43 +0100=0ASubject: [PATCH 086/165] Revert "thunderbolt: Fix =
a missing check of kmemdup"=0A=0AThis reverts commit e4dfdd5804cce1255f99c5=
dd033526a18135a616.=0A=0ACommits from @umn.edu addresses have been found to=
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
udip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/thunderbolt/pr=
operty.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drive=
rs/thunderbolt/property.c b/drivers/thunderbolt/property.c=0Aindex 841314de=
b446..ee76449524a3 100644=0A--- a/drivers/thunderbolt/property.c=0A+++ b/dr=
ivers/thunderbolt/property.c=0A@@ -176,10 +176,6 @@ static struct tb_proper=
ty_dir *__tb_property_parse_dir(const u32 *block,=0A 	} else {=0A 		dir->uu=
id =3D kmemdup(&block[dir_offset], sizeof(*dir->uuid),=0A 				    GFP_KERNE=
L);=0A-		if (!dir->uuid) {=0A-			tb_property_free_dir(dir);=0A-			return NU=
LL;=0A-		}=0A 		content_offset =3D dir_offset + 4;=0A 		content_len =3D dir=
_len - 4; /* Length includes UUID */=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 3c24=
4a7a5e044ced538f0d627a93430b0332d729 Mon Sep 17 00:00:00 2001=0AFrom: Sudip=
 Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:44 +=
0100=0ASubject: [PATCH 087/165] Revert "spi : spi-topcliff-pch: Fix to hand=
le empty=0A DMA buffers"=0A=0AThis reverts commit f37d8e67f39e6d3eaf4cc5471=
e8a3d21209843c6.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/spi/spi-topcliff-=
pch.c | 15 ++-------------=0A 1 file changed, 2 insertions(+), 13 deletions=
(-)=0A=0Adiff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topc=
liff-pch.c=0Aindex b459e369079f..12d749e9436b 100644=0A--- a/drivers/spi/sp=
i-topcliff-pch.c=0A+++ b/drivers/spi/spi-topcliff-pch.c=0A@@ -1290,27 +1290=
,18 @@ static void pch_free_dma_buf(struct pch_spi_board_data *board_dat,=
=0A 				  dma->rx_buf_virt, dma->rx_buf_dma);=0A }=0A =0A-static int pch_al=
loc_dma_buf(struct pch_spi_board_data *board_dat,=0A+static void pch_alloc_=
dma_buf(struct pch_spi_board_data *board_dat,=0A 			      struct pch_spi_da=
ta *data)=0A {=0A 	struct pch_spi_dma_ctrl *dma;=0A-	int ret;=0A =0A 	dma =
=3D &data->dma;=0A-	ret =3D 0;=0A 	/* Get Consistent memory for Tx DMA */=
=0A 	dma->tx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 				=
PCH_BUF_SIZE, &dma->tx_buf_dma, GFP_KERNEL);=0A-	if (!dma->tx_buf_virt)=0A-=
		ret =3D -ENOMEM;=0A-=0A 	/* Get Consistent memory for Rx DMA */=0A 	dma->=
rx_buf_virt =3D dma_alloc_coherent(&board_dat->pdev->dev,=0A 				PCH_BUF_SI=
ZE, &dma->rx_buf_dma, GFP_KERNEL);=0A-	if (!dma->rx_buf_virt)=0A-		ret =3D =
-ENOMEM;=0A-=0A-	return ret;=0A }=0A =0A static int pch_spi_pd_probe(struct=
 platform_device *plat_dev)=0A@@ -1387,9 +1378,7 @@ static int pch_spi_pd_p=
robe(struct platform_device *plat_dev)=0A =0A 	if (use_dma) {=0A 		dev_info=
(&plat_dev->dev, "Use DMA for data transfers\n");=0A-		ret =3D pch_alloc_dm=
a_buf(board_dat, data);=0A-		if (ret)=0A-			goto err_spi_register_master;=
=0A+		pch_alloc_dma_buf(board_dat, data);=0A 	}=0A =0A 	ret =3D spi_registe=
r_master(master);=0A-- =0A2.30.2=0A=0A=0AFrom df8938fa2b07d67d7a02735c56ecb=
fabd7cbd578 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:44 +0100=0ASubject: [PATCH 08=
8/165] Revert "scsi: ufs: fix a missing check of=0A devm_reset_control_get"=
=0A=0AThis reverts commit 63a06181d7ce169d09843645c50fea1901bc9f0a.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/scsi/ufs/ufs-hisi.c | 4 ----=0A 1 file ch=
anged, 4 deletions(-)=0A=0Adiff --git a/drivers/scsi/ufs/ufs-hisi.c b/drive=
rs/scsi/ufs/ufs-hisi.c=0Aindex 074a6a055a4c..6362876e1e3f 100644=0A--- a/dr=
ivers/scsi/ufs/ufs-hisi.c=0A+++ b/drivers/scsi/ufs/ufs-hisi.c=0A@@ -479,10 =
+479,6 @@ static int ufs_hisi_init_common(struct ufs_hba *hba)=0A 	ufshcd_s=
et_variant(hba, host);=0A =0A 	host->rst  =3D devm_reset_control_get(dev, "=
rst");=0A-	if (IS_ERR(host->rst)) {=0A-		dev_err(dev, "%s: failed to get re=
set control\n", __func__);=0A-		return PTR_ERR(host->rst);=0A-	}=0A =0A 	uf=
s_hisi_set_pm_lvl(hba);=0A =0A-- =0A2.30.2=0A=0A=0AFrom 09c6f9894ca3b890570=
6e0b578b4c17fa8342bd4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sud=
ipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:45 +0100=0ASubject:=
 [PATCH 089/165] Revert "netfilter: ip6t_srh: fix NULL pointer=0A dereferen=
ces"=0A=0AThis reverts commit 6d65561f3d5ec933151939c543d006b79044e7a6.=0A=
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
m.mukherjee@gmail.com>=0A---=0A net/ipv6/netfilter/ip6t_srh.c | 6 ------=0A=
 1 file changed, 6 deletions(-)=0A=0Adiff --git a/net/ipv6/netfilter/ip6t_s=
rh.c b/net/ipv6/netfilter/ip6t_srh.c=0Aindex db0fd64d8986..f172702257a7 100=
644=0A--- a/net/ipv6/netfilter/ip6t_srh.c=0A+++ b/net/ipv6/netfilter/ip6t_s=
rh.c=0A@@ -206,8 +206,6 @@ static bool srh1_mt6(const struct sk_buff *skb, =
struct xt_action_param *par)=0A 		psidoff =3D srhoff + sizeof(struct ipv6_s=
r_hdr) +=0A 			  ((srh->segments_left + 1) * sizeof(struct in6_addr));=0A 	=
	psid =3D skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);=0A-		if =
(!psid)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID=
,=0A 				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,=0A 						     &srhi=
nfo->psid_addr)))=0A@@ -221,8 +219,6 @@ static bool srh1_mt6(const struct s=
k_buff *skb, struct xt_action_param *par)=0A 		nsidoff =3D srhoff + sizeof(=
struct ipv6_sr_hdr) +=0A 			  ((srh->segments_left - 1) * sizeof(struct in6=
_addr));=0A 		nsid =3D skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_ns=
id);=0A-		if (!nsid)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T=
_SRH_INV_NSID,=0A 				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,=0A 			=
			     &srhinfo->nsid_addr)))=0A@@ -233,8 +229,6 @@ static bool srh1_mt6(c=
onst struct sk_buff *skb, struct xt_action_param *par)=0A 	if (srhinfo->mt_=
flags & IP6T_SRH_LSID) {=0A 		lsidoff =3D srhoff + sizeof(struct ipv6_sr_hd=
r);=0A 		lsid =3D skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);=
=0A-		if (!lsid)=0A-			return false;=0A 		if (NF_SRH_INVF(srhinfo, IP6T_SRH=
_INV_LSID,=0A 				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,=0A 						 =
    &srhinfo->lsid_addr)))=0A-- =0A2.30.2=0A=0A=0AFrom ae10684bb3fc7ab5f864=
f6553c36dab74d955ffd Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:46 +0100=0ASubject: =
[PATCH 090/165] Revert "net: openvswitch: fix a NULL pointer=0A dereference=
"=0A=0AThis reverts commit 6f19893b644a9454d85e593b5e90914e7a72b7dd.=0A=0AC=
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
herjee@gmail.com>=0A---=0A net/openvswitch/datapath.c | 4 ----=0A 1 file ch=
anged, 4 deletions(-)=0A=0Adiff --git a/net/openvswitch/datapath.c b/net/op=
envswitch/datapath.c=0Aindex 9d6ef6cb9b26..99e63f4bbcaf 100644=0A--- a/net/=
openvswitch/datapath.c=0A+++ b/net/openvswitch/datapath.c=0A@@ -443,10 +443=
,6 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff=
 *skb,=0A =0A 	upcall =3D genlmsg_put(user_skb, 0, 0, &dp_packet_genl_famil=
y,=0A 			     0, upcall_info->cmd);=0A-	if (!upcall) {=0A-		err =3D -EINVAL=
;=0A-		goto out;=0A-	}=0A 	upcall->dp_ifindex =3D dp_ifindex;=0A =0A 	err =
=3D ovs_nla_put_key(key, key, OVS_PACKET_ATTR_KEY, false, user_skb);=0A-- =
=0A2.30.2=0A=0A=0AFrom 3a52d605e7e4824f1509ffe310ed6b75cba6b69e Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 19:59:46 +0100=0ASubject: [PATCH 091/165] Revert "net: tip=
c: fix a missing check of=0A nla_nest_start"=0A=0AThis reverts commit 4589e=
28db46ee4961edfd794c5bb43887d38c8e5.=0A=0ACommits from @umn.edu addresses h=
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
=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net=
/tipc/group.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --git a/n=
et/tipc/group.c b/net/tipc/group.c=0Aindex b1fcd2ad5ecf..380e9c0f07d8 10064=
4=0A--- a/net/tipc/group.c=0A+++ b/net/tipc/group.c=0A@@ -926,9 +926,6 @@ i=
nt tipc_group_fill_sock_diag(struct tipc_group *grp, struct sk_buff *skb)=
=0A {=0A 	struct nlattr *group =3D nla_nest_start_noflag(skb, TIPC_NLA_SOCK=
_GROUP);=0A =0A-	if (!group)=0A-		return -EMSGSIZE;=0A-=0A 	if (nla_put_u32=
(skb, TIPC_NLA_SOCK_GROUP_ID,=0A 			grp->type) ||=0A 	    nla_put_u32(skb, =
TIPC_NLA_SOCK_GROUP_INSTANCE,=0A-- =0A2.30.2=0A=0A=0AFrom be314b9bd8e376a62=
283235db74ffcfde9d43379 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:47 +0100=0ASubjec=
t: [PATCH 092/165] Revert "net: strparser: fix a missing check for=0A creat=
e_singlethread_workqueue"=0A=0AThis reverts commit 228cd2dba27cee9956c1af97=
e6445be056881e41.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/strparser/strparser.=
c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/net/strparser/=
strparser.c b/net/strparser/strparser.c=0Aindex b3815c1e8f2e..efce4ddaa320 =
100644=0A--- a/net/strparser/strparser.c=0A+++ b/net/strparser/strparser.c=
=0A@@ -542,8 +542,6 @@ EXPORT_SYMBOL_GPL(strp_check_rcv);=0A static int __i=
nit strp_dev_init(void)=0A {=0A 	strp_wq =3D create_singlethread_workqueue(=
"kstrp");=0A-	if (unlikely(!strp_wq))=0A-		return -ENOMEM;=0A =0A 	return 0=
;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 7addc7de26a328733a0ff0aa6fdea5dd37532b84=
 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.c=
om>=0ADate: Wed, 21 Apr 2021 19:59:48 +0100=0ASubject: [PATCH 093/165] Reve=
rt "media: si2165: fix a missing check of return=0A value"=0A=0AThis revert=
s commit 0ab34a08812a3334350dbaf69a018ee0ab3d2ddd.=0A=0ACommits from @umn.e=
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
=0A---=0A drivers/media/dvb-frontends/si2165.c | 8 +++-----=0A 1 file chang=
ed, 3 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drivers/media/dvb-fro=
ntends/si2165.c b/drivers/media/dvb-frontends/si2165.c=0Aindex 3fdaef1935ef=
=2E.fe5f04a5aa01 100644=0A--- a/drivers/media/dvb-frontends/si2165.c=0A+++ =
b/drivers/media/dvb-frontends/si2165.c=0A@@ -266,20 +266,18 @@ static u32 s=
i2165_get_fe_clk(struct si2165_state *state)=0A =0A static int si2165_wait_=
init_done(struct si2165_state *state)=0A {=0A-	int ret;=0A+	int ret =3D -EI=
NVAL;=0A 	u8 val =3D 0;=0A 	int i;=0A =0A 	for (i =3D 0; i < 3; ++i) {=0A-	=
	ret =3D si2165_readreg8(state, REG_INIT_DONE, &val);=0A-		if (ret < 0)=0A-=
			return ret;=0A+		si2165_readreg8(state, REG_INIT_DONE, &val);=0A 		if (v=
al =3D=3D 0x01)=0A 			return 0;=0A 		usleep_range(1000, 50000);=0A 	}=0A 	d=
ev_err(&state->client->dev, "init_done was not set\n");=0A-	return -EINVAL;=
=0A+	return ret;=0A }=0A =0A static int si2165_upload_firmware_block(struct=
 si2165_state *state,=0A-- =0A2.30.2=0A=0A=0AFrom d44bf20f9df59dd944fe32b5c=
9bc841e39535a29 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:48 +0100=0ASubject: [PATC=
H 094/165] Revert "net: 8390: fix potential NULL pointer=0A dereferences"=
=0A=0AThis reverts commit c7cbc3e937b885c9394bf9d0ca21ceb75c2ac262.=0A=0ACo=
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
erjee@gmail.com>=0A---=0A drivers/net/ethernet/8390/pcnet_cs.c | 10 -------=
---=0A 1 file changed, 10 deletions(-)=0A=0Adiff --git a/drivers/net/ethern=
et/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c=0Aindex 9d3b1e0e4=
25c..0a408fa2b7a4 100644=0A--- a/drivers/net/ethernet/8390/pcnet_cs.c=0A+++=
 b/drivers/net/ethernet/8390/pcnet_cs.c=0A@@ -289,11 +289,6 @@ static struc=
t hw_info *get_hwinfo(struct pcmcia_device *link)=0A =0A     virt =3D iorem=
ap(link->resource[2]->start,=0A 	    resource_size(link->resource[2]));=0A-=
    if (unlikely(!virt)) {=0A-	    pcmcia_release_window(link, link->resour=
ce[2]);=0A-	    return NULL;=0A-    }=0A-=0A     for (i =3D 0; i < NR_INFO;=
 i++) {=0A 	pcmcia_map_mem_page(link, link->resource[2],=0A 		hw_info[i].of=
fset & ~(resource_size(link->resource[2])-1));=0A@@ -1430,11 +1425,6 @@ sta=
tic int setup_shmem_window(struct pcmcia_device *link, int start_pg,=0A    =
 /* Try scribbling on the buffer */=0A     info->base =3D ioremap(link->res=
ource[3]->start,=0A 			resource_size(link->resource[3]));=0A-    if (unlike=
ly(!info->base)) {=0A-	    ret =3D -ENOMEM;=0A-	    goto failed;=0A-    }=
=0A-=0A     for (i =3D 0; i < (TX_PAGES<<8); i +=3D 2)=0A 	__raw_writew((i>=
>1), info->base+offset+i);=0A     udelay(100);=0A-- =0A2.30.2=0A=0A=0AFrom =
872bb5cb3f5502ffb9cfc479a165894bb4e94cd3 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:=
49 +0100=0ASubject: [PATCH 095/165] Revert "ALSA: sb8: add a check for requ=
est_region"=0A=0AThis reverts commit dcd0feac9bab901d5739de51b3f69840851f89=
19.=0A=0ACommits from @umn.edu addresses have been found to be submitted in=
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
sb/sb8.c=0Aindex 438109f167d6..ae93191ffdc9 100644=0A--- a/sound/isa/sb/sb8=
=2Ec=0A+++ b/sound/isa/sb/sb8.c=0A@@ -96,10 +96,6 @@ static int snd_sb8_pro=
be(struct device *pdev, unsigned int dev)=0A =0A 	/* block the 0x388 port t=
o avoid PnP conflicts */=0A 	acard->fm_res =3D request_region(0x388, 4, "So=
undBlaster FM");=0A-	if (!acard->fm_res) {=0A-		err =3D -EBUSY;=0A-		goto _=
err;=0A-	}=0A =0A 	if (port[dev] !=3D SNDRV_AUTO_PORT) {=0A 		if ((err =3D =
snd_sbdsp_create(card, port[dev], irq[dev],=0A-- =0A2.30.2=0A=0A=0AFrom 21b=
bf49906e4b476c392a19af886ed175c1a2fb3 Mon Sep 17 00:00:00 2001=0AFrom: Sudi=
p Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:50 =
+0100=0ASubject: [PATCH 096/165] Revert "net: fujitsu: fix a potential NULL=
 pointer=0A dereference"=0A=0AThis reverts commit 9f4d6358e11bbc7b839f94196=
36188e4151fb6e4.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/fuji=
tsu/fmvj18x_cs.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --gi=
t a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujits=
u/fmvj18x_cs.c=0Aindex a7b7a4aace79..dc90c61fc827 100644=0A--- a/drivers/ne=
t/ethernet/fujitsu/fmvj18x_cs.c=0A+++ b/drivers/net/ethernet/fujitsu/fmvj18=
x_cs.c=0A@@ -547,11 +547,6 @@ static int fmvj18x_get_hwinfo(struct pcmcia_d=
evice *link, u_char *node_id)=0A 	return -1;=0A =0A     base =3D ioremap(li=
nk->resource[2]->start, resource_size(link->resource[2]));=0A-    if (!base=
) {=0A-	    pcmcia_release_window(link, link->resource[2]);=0A-	    return =
-ENOMEM;=0A-    }=0A-=0A     pcmcia_map_mem_page(link, link->resource[2], 0=
);=0A =0A     /*=0A-- =0A2.30.2=0A=0A=0AFrom 35328710721e8764b25146a4d1d77a=
e6a10a141e Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:50 +0100=0ASubject: [PATCH 097=
/165] Revert "net: qlogic: fix a potential NULL pointer=0A dereference"=0A=
=0AThis reverts commit eb32cfcdef2305dc0e44a65d42801315669bb27e.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/qla3xxx.c | 6 ------=0A =
1 file changed, 6 deletions(-)=0A=0Adiff --git a/drivers/net/ethernet/qlogi=
c/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c=0Aindex 27740c027681..7=
ceaa89cc571 100644=0A--- a/drivers/net/ethernet/qlogic/qla3xxx.c=0A+++ b/dr=
ivers/net/ethernet/qlogic/qla3xxx.c=0A@@ -3885,12 +3885,6 @@ static int ql3=
xxx_probe(struct pci_dev *pdev,=0A 	netif_stop_queue(ndev);=0A =0A 	qdev->w=
orkqueue =3D create_singlethread_workqueue(ndev->name);=0A-	if (!qdev->work=
queue) {=0A-		unregister_netdev(ndev);=0A-		err =3D -ENOMEM;=0A-		goto err_=
out_iounmap;=0A-	}=0A-=0A 	INIT_DELAYED_WORK(&qdev->reset_work, ql_reset_wo=
rk);=0A 	INIT_DELAYED_WORK(&qdev->tx_timeout_work, ql_tx_timeout_work);=0A =
	INIT_DELAYED_WORK(&qdev->link_state_work, ql_link_state_machine_work);=0A-=
- =0A2.30.2=0A=0A=0AFrom 05c2acfbc38c8a9613497494a83bdc906677482f Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 19:59:51 +0100=0ASubject: [PATCH 098/165] Revert "md: Fi=
x failed allocation of=0A md_register_thread"=0A=0AThis reverts commit e406=
f12dde1a8375d77ea02d91f313fb1a9c6aec.=0A=0ACommits from @umn.edu addresses =
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
drivers/md/raid10.c | 2 --=0A drivers/md/raid5.c  | 2 --=0A 2 files changed=
, 4 deletions(-)=0A=0Adiff --git a/drivers/md/raid10.c b/drivers/md/raid10.=
c=0Aindex 9f9d8b67b5dd..f9e3e1209915 100644=0A--- a/drivers/md/raid10.c=0A+=
++ b/drivers/md/raid10.c=0A@@ -3898,8 +3898,6 @@ static int raid10_run(stru=
ct mddev *mddev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);=0A 		=
mddev->sync_thread =3D md_register_thread(md_do_sync, mddev,=0A 							"res=
hape");=0A-		if (!mddev->sync_thread)=0A-			goto out_free_conf;=0A 	}=0A =
=0A 	return 0;=0Adiff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0Aind=
ex 39343479ac2a..2f5a22ef476f 100644=0A--- a/drivers/md/raid5.c=0A+++ b/dri=
vers/md/raid5.c=0A@@ -7696,8 +7696,6 @@ static int raid5_run(struct mddev *=
mddev)=0A 		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);=0A 		mddev->syn=
c_thread =3D md_register_thread(md_do_sync, mddev,=0A 							"reshape");=0A=
-		if (!mddev->sync_thread)=0A-			goto abort;=0A 	}=0A =0A 	/* Ok, everythi=
ng is just fine now */=0A-- =0A2.30.2=0A=0A=0AFrom e8dc006f6d118063f3a9ebaa=
f34b1e8b693f99c1 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.m=
ukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:51 +0100=0ASubject: [PAT=
CH 099/165] Revert "usb: u132-hcd: fix potential NULL pointer=0A dereferenc=
e"=0A=0AThis reverts commit 3de3dbe7c13210171ba8411e36b409a2c29c7415.=0A=0A=
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
kherjee@gmail.com>=0A---=0A drivers/usb/host/u132-hcd.c | 2 --=0A 1 file ch=
anged, 2 deletions(-)=0A=0Adiff --git a/drivers/usb/host/u132-hcd.c b/drive=
rs/usb/host/u132-hcd.c=0Aindex 995bc52d2d22..2e3722468bc1 100644=0A--- a/dr=
ivers/usb/host/u132-hcd.c=0A+++ b/drivers/usb/host/u132-hcd.c=0A@@ -3195,8 =
+3195,6 @@ static int __init u132_hcd_init(void)=0A 		return -ENODEV;=0A 	p=
rintk(KERN_INFO "driver %s\n", hcd_name);=0A 	workqueue =3D create_singleth=
read_workqueue("u132");=0A-	if (!workqueue)=0A-		return -ENOMEM;=0A 	retval=
 =3D platform_driver_register(&u132_platform_driver);=0A 	if (retval)=0A 		=
destroy_workqueue(workqueue);=0A-- =0A2.30.2=0A=0A=0AFrom 8bf121d3747c96640=
04308c80c8ede0f6929ee74 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:52 +0100=0ASubjec=
t: [PATCH 100/165] Revert "net: rocker: fix a potential NULL pointer=0A der=
eference"=0A=0AThis reverts commit 5c149314d91876f743ee43efd75b6287ec55480e=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/rocker/rocker_m=
ain.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git a/drivers=
/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_mai=
n.c=0Aindex dd0bc7f0aaee..81cc3f8988f3 100644=0A--- a/drivers/net/ethernet/=
rocker/rocker_main.c=0A+++ b/drivers/net/ethernet/rocker/rocker_main.c=0A@@=
 -2819,11 +2819,6 @@ static int rocker_switchdev_event(struct notifier_bloc=
k *unused,=0A 		memcpy(&switchdev_work->fdb_info, ptr,=0A 		       sizeof(s=
witchdev_work->fdb_info));=0A 		switchdev_work->fdb_info.addr =3D kzalloc(E=
TH_ALEN, GFP_ATOMIC);=0A-		if (unlikely(!switchdev_work->fdb_info.addr)) {=
=0A-			kfree(switchdev_work);=0A-			return NOTIFY_BAD;=0A-		}=0A-=0A 		ethe=
r_addr_copy((u8 *)switchdev_work->fdb_info.addr,=0A 				fdb_info->addr);=0A=
 		/* Take a reference on the rocker device */=0A-- =0A2.30.2=0A=0A=0AFrom =
26d7191230b4df250e7abfa64a0bacc7e473d9c3 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:=
53 +0100=0ASubject: [PATCH 101/165] Revert "net: lio_core: fix two NULL poi=
nter=0A dereferences"=0A=0AThis reverts commit 41af8b3a097c6fd17a4867efa259=
66927094f57c.=0A=0ACommits from @umn.edu addresses have been found to be su=
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
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/cavium/=
liquidio/lio_core.c | 10 ----------=0A 1 file changed, 10 deletions(-)=0A=
=0Adiff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/n=
et/ethernet/cavium/liquidio/lio_core.c=0Aindex 9ef172976b35..6d751d38b726 1=
00644=0A--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c=0A+++ b/drive=
rs/net/ethernet/cavium/liquidio/lio_core.c=0A@@ -1216,11 +1216,6 @@ int liq=
uidio_change_mtu(struct net_device *netdev, int new_mtu)=0A =0A 	sc =3D (st=
ruct octeon_soft_command *)=0A 		octeon_alloc_soft_command(oct, OCTNET_CMD_=
SIZE, 16, 0);=0A-	if (!sc) {=0A-		netif_info(lio, rx_err, lio->netdev,=0A-	=
		   "Failed to allocate soft command\n");=0A-		return -ENOMEM;=0A-	}=0A =
=0A 	ncmd =3D (union octnet_cmd *)sc->virtdptr;=0A =0A@@ -1694,11 +1689,6 @=
@ int liquidio_set_fec(struct lio *lio, int on_off)=0A =0A 	sc =3D octeon_a=
lloc_soft_command(oct, OCTNET_CMD_SIZE,=0A 				       sizeof(struct oct_nic=
_seapi_resp), 0);=0A-	if (!sc) {=0A-		dev_err(&oct->pci_dev->dev,=0A-			"Fa=
iled to allocate soft command\n");=0A-		return -ENOMEM;=0A-	}=0A =0A 	ncmd =
=3D sc->virtdptr;=0A 	resp =3D sc->virtrptr;=0A-- =0A2.30.2=0A=0A=0AFrom 10=
db82a1a550962152e9bb91b8e5e89f3015c16f Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:53=
 +0100=0ASubject: [PATCH 102/165] Revert "pppoe: remove redundant BUG_ON() =
check in=0A pppoe_pernet"=0A=0AThis reverts commit 02a896ca84874bbfcedc0063=
03f2951dda89b298.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ppp/pppoe.c =
| 2 ++=0A 1 file changed, 2 insertions(+)=0A=0Adiff --git a/drivers/net/ppp=
/pppoe.c b/drivers/net/ppp/pppoe.c=0Aindex d7f50b835050..803a4fe1ca18 10064=
4=0A--- a/drivers/net/ppp/pppoe.c=0A+++ b/drivers/net/ppp/pppoe.c=0A@@ -119=
,6 +119,8 @@ static inline bool stage_session(__be16 sid)=0A =0A static inl=
ine struct pppoe_net *pppoe_pernet(struct net *net)=0A {=0A+	BUG_ON(!net);=
=0A+=0A 	return net_generic(net, pppoe_net_id);=0A }=0A =0A-- =0A2.30.2=0A=
=0A=0AFrom b06deaa43d016ed8206c40774a8f3c484fc7eeae Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:59:54 +0100=0ASubject: [PATCH 103/165] Revert "net: atm: Reduce the=
 severity of logging in=0A unlink_clip_vcc"=0A=0AThis reverts commit 60f5c4=
aaae452ae9252128ef7f9ae222aa70c569.=0A=0ACommits from @umn.edu addresses ha=
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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A net/at=
m/clip.c | 6 +++---=0A 1 file changed, 3 insertions(+), 3 deletions(-)=0A=
=0Adiff --git a/net/atm/clip.c b/net/atm/clip.c=0Aindex 294cb9efe3d3..a7972=
da7235d 100644=0A--- a/net/atm/clip.c=0A+++ b/net/atm/clip.c=0A@@ -89,7 +89=
,7 @@ static void unlink_clip_vcc(struct clip_vcc *clip_vcc)=0A 	struct cli=
p_vcc **walk;=0A =0A 	if (!entry) {=0A-		pr_err("!clip_vcc->entry (clip_vcc=
 %p)\n", clip_vcc);=0A+		pr_crit("!clip_vcc->entry (clip_vcc %p)\n", clip_v=
cc);=0A 		return;=0A 	}=0A 	netif_tx_lock_bh(entry->neigh->dev);	/* block c=
lip_start_xmit() */=0A@@ -109,10 +109,10 @@ static void unlink_clip_vcc(str=
uct clip_vcc *clip_vcc)=0A 			error =3D neigh_update(entry->neigh, NULL, NU=
D_NONE,=0A 					     NEIGH_UPDATE_F_ADMIN, 0);=0A 			if (error)=0A-				pr_e=
rr("neigh_update failed with %d\n", error);=0A+				pr_crit("neigh_update fa=
iled with %d\n", error);=0A 			goto out;=0A 		}=0A-	pr_err("ATMARP: failed =
(entry %p, vcc 0x%p)\n", entry, clip_vcc);=0A+	pr_crit("ATMARP: failed (ent=
ry %p, vcc 0x%p)\n", entry, clip_vcc);=0A out:=0A 	netif_tx_unlock_bh(entry=
->neigh->dev);=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 9340bec68ad580d7ef5c888dfcc=
a7bd50fac6a85 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:55 +0100=0ASubject: [PATCH =
104/165] Revert "net: ixgbevf: fix a missing check of=0A ixgbevf_write_msg_=
read_ack"=0A=0AThis reverts commit 20d437ee8f4899573e6ea76c06ef0206e98bccb6=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/intel/ixgbevf/v=
f.c | 5 +++--=0A 1 file changed, 3 insertions(+), 2 deletions(-)=0A=0Adiff =
--git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/inte=
l/ixgbevf/vf.c=0Aindex bfe6dfcec4ab..501823f2d1c0 100644=0A--- a/drivers/ne=
t/ethernet/intel/ixgbevf/vf.c=0A+++ b/drivers/net/ethernet/intel/ixgbevf/vf=
=2Ec=0A@@ -508,8 +508,9 @@ static s32 ixgbevf_update_mc_addr_list_vf(struct=
 ixgbe_hw *hw,=0A 		vector_list[i++] =3D ixgbevf_mta_vector(hw, ha->addr);=
=0A 	}=0A =0A-	return ixgbevf_write_msg_read_ack(hw, msgbuf, msgbuf,=0A-			=
IXGBE_VFMAILBOX_SIZE);=0A+	ixgbevf_write_msg_read_ack(hw, msgbuf, msgbuf, I=
XGBE_VFMAILBOX_SIZE);=0A+=0A+	return 0;=0A }=0A =0A /**=0A-- =0A2.30.2=0A=
=0A=0AFrom d5736677400ab511aa6a08ce3a7fd258d8098d9d Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:59:55 +0100=0ASubject: [PATCH 105/165] Revert "thunderbolt: propert=
y: Fix a NULL pointer=0A dereference"=0A=0AThis reverts commit 106204b56f60=
abf1bead7dceb88f2be3e34433da.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/thun=
derbolt/property.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --=
git a/drivers/thunderbolt/property.c b/drivers/thunderbolt/property.c=0Aind=
ex ee76449524a3..b2f0d6386cee 100644=0A--- a/drivers/thunderbolt/property.c=
=0A+++ b/drivers/thunderbolt/property.c=0A@@ -548,11 +548,6 @@ int tb_prope=
rty_add_data(struct tb_property_dir *parent, const char *key,=0A =0A 	prope=
rty->length =3D size / 4;=0A 	property->value.data =3D kzalloc(size, GFP_KE=
RNEL);=0A-	if (!property->value.data) {=0A-		kfree(property);=0A-		return -=
ENOMEM;=0A-	}=0A-=0A 	memcpy(property->value.data, buf, buflen);=0A =0A 	li=
st_add_tail(&property->list, &parent->properties);=0A-- =0A2.30.2=0A=0A=0AF=
rom 0721e8320119c4f309d5cb99ed47a73ab3ba1828 Mon Sep 17 00:00:00 2001=0AFro=
m: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19=
:59:56 +0100=0ASubject: [PATCH 106/165] Revert "tty: mxs-auart: fix a poten=
tial NULL pointer=0A dereference"=0A=0AThis reverts commit 6734330654dac550=
f12e932996b868c6d0dcb421.=0A=0ACommits from @umn.edu addresses have been fo=
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
-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/tty/seri=
al/mxs-auart.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a=
/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c=0Aindex b7=
84323a6a7b..ed1ad2a52019 100644=0A--- a/drivers/tty/serial/mxs-auart.c=0A++=
+ b/drivers/tty/serial/mxs-auart.c=0A@@ -1680,10 +1680,6 @@ static int mxs_=
auart_probe(struct platform_device *pdev)=0A =0A 	s->port.mapbase =3D r->st=
art;=0A 	s->port.membase =3D ioremap(r->start, resource_size(r));=0A-	if (!=
s->port.membase) {=0A-		ret =3D -ENOMEM;=0A-		goto out_disable_clks;=0A-	}=
=0A 	s->port.ops =3D &mxs_auart_ops;=0A 	s->port.iotype =3D UPIO_MEM;=0A 	s=
->port.fifosize =3D MXS_AUART_FIFO_SIZE;=0A-- =0A2.30.2=0A=0A=0AFrom b3466f=
01dc2d3729a233b98f48d865cc7a31e6b2 Mon Sep 17 00:00:00 2001=0AFrom: Sudip M=
ukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:57 +01=
00=0ASubject: [PATCH 107/165] Revert "serial: mvebu-uart: Fix to avoid a po=
tential=0A NULL pointer dereference"=0A=0AThis reverts commit 32f47179833b6=
3de72427131169809065db6745e.=0A=0ACommits from @umn.edu addresses have been=
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
off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/tty/s=
erial/mvebu-uart.c | 3 ---=0A 1 file changed, 3 deletions(-)=0A=0Adiff --gi=
t a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c=0Aind=
ex e0c00a1b0763..51b0ecabf2ec 100644=0A--- a/drivers/tty/serial/mvebu-uart.=
c=0A+++ b/drivers/tty/serial/mvebu-uart.c=0A@@ -818,9 +818,6 @@ static int =
mvebu_uart_probe(struct platform_device *pdev)=0A 		return -EINVAL;=0A 	}=
=0A =0A-	if (!match)=0A-		return -ENODEV;=0A-=0A 	/* Assume that all UART p=
orts have a DT alias or none has */=0A 	id =3D of_alias_get_id(pdev->dev.of=
_node, "serial");=0A 	if (!pdev->dev.of_node || id < 0)=0A-- =0A2.30.2=0A=
=0A=0AFrom c129bd820b5d245a9c171c615eb9b509f4034f3c Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 19:59:57 +0100=0ASubject: [PATCH 108/165] Revert "ALSA: usx2y: Fix pot=
ential NULL pointer=0A dereference"=0A=0AThis reverts commit a2c6433ee5a35a=
8de6d563f6512a26f87835ea0f.=0A=0ACommits from @umn.edu addresses have been =
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
ff-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/usb/usx2=
y/usb_stream.c | 5 -----=0A 1 file changed, 5 deletions(-)=0A=0Adiff --git =
a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stream.c=0Aindex 091c0=
71b270a..6bba17bf689a 100644=0A--- a/sound/usb/usx2y/usb_stream.c=0A+++ b/s=
ound/usb/usx2y/usb_stream.c=0A@@ -91,12 +91,7 @@ static int init_urbs(struc=
t usb_stream_kernel *sk, unsigned use_packsize,=0A =0A 	for (u =3D 0; u < U=
SB_STREAM_NURBS; ++u) {=0A 		sk->inurb[u] =3D usb_alloc_urb(sk->n_o_ps, GFP=
_KERNEL);=0A-		if (!sk->inurb[u])=0A-			return -ENOMEM;=0A-=0A 		sk->outurb=
[u] =3D usb_alloc_urb(sk->n_o_ps, GFP_KERNEL);=0A-		if (!sk->outurb[u])=0A-=
			return -ENOMEM;=0A 	}=0A =0A 	if (init_pipe_urbs(sk, use_packsize, sk->i=
nurb, indata, dev, in_pipe) ||=0A-- =0A2.30.2=0A=0A=0AFrom 98f094e65a4512a0=
365004eb27f1f7ade5796044 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <=
sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:58 +0100=0ASubje=
ct: [PATCH 109/165] Revert "qlcnic: Avoid potential NULL pointer=0A derefer=
ence"=0A=0AThis reverts commit 5bf7295fe34a5251b1d241b9736af4697b590670.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/qlogic/qlcnic/qlcnic_e=
thtool.c | 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/drivers=
/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/=
qlcnic/qlcnic_ethtool.c=0Aindex d8a3ecaed3fc..985cf8cb2ec0 100644=0A--- a/d=
rivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c=0A+++ b/drivers/net/ethe=
rnet/qlogic/qlcnic/qlcnic_ethtool.c=0A@@ -1047,8 +1047,6 @@ int qlcnic_do_l=
b_test(struct qlcnic_adapter *adapter, u8 mode)=0A =0A 	for (i =3D 0; i < Q=
LCNIC_NUM_ILB_PKT; i++) {=0A 		skb =3D netdev_alloc_skb(adapter->netdev, QL=
CNIC_ILB_PKT_SIZE);=0A-		if (!skb)=0A-			break;=0A 		qlcnic_create_loopback=
_buff(skb->data, adapter->mac_addr);=0A 		skb_put(skb, QLCNIC_ILB_PKT_SIZE)=
;=0A 		adapter->ahw->diag_cnt =3D 0;=0A-- =0A2.30.2=0A=0A=0AFrom 858e75b63e=
0e21e1efa721e53c76ea41f4d61421 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukhe=
rjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 19:59:59 +0100=
=0ASubject: [PATCH 110/165] Revert "tty: atmel_serial: fix a potential NULL=
=0A pointer dereference"=0A=0AThis reverts commit c85be041065c0be8bc48eda4c=
45e0319caf1d0e5.=0A=0ACommits from @umn.edu addresses have been found to be=
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
p Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/tty/serial/atmel_=
serial.c | 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drive=
rs/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c=0Aindex a2=
4e5c2b30bc..9786d8e5f04f 100644=0A--- a/drivers/tty/serial/atmel_serial.c=
=0A+++ b/drivers/tty/serial/atmel_serial.c=0A@@ -1256,10 +1256,6 @@ static =
int atmel_prepare_rx_dma(struct uart_port *port)=0A 					 sg_dma_len(&atmel=
_port->sg_rx)/2,=0A 					 DMA_DEV_TO_MEM,=0A 					 DMA_PREP_INTERRUPT);=0A-=
	if (!desc) {=0A-		dev_err(port->dev, "Preparing DMA cyclic failed\n");=0A-=
		goto chan_err;=0A-	}=0A 	desc->callback =3D atmel_complete_rx_dma;=0A 	de=
sc->callback_param =3D port;=0A 	atmel_port->desc_rx =3D desc;=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 9f1f9b0668d6547f26a508be42dbf33646b36931 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 19:59:59 +0100=0ASubject: [PATCH 111/165] Revert "libertas: add=
 checks for the return value of=0A sysfs_create_group"=0A=0AThis reverts co=
mmit 434256833d8eb988cb7f3b8a41699e2fe48d9332.=0A=0ACommits from @umn.edu a=
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
-=0A drivers/net/wireless/marvell/libertas/mesh.c | 5 -----=0A 1 file chang=
ed, 5 deletions(-)=0A=0Adiff --git a/drivers/net/wireless/marvell/libertas/=
mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c=0Aindex f5b78257d551.=
=2Ec611e6668b21 100644=0A--- a/drivers/net/wireless/marvell/libertas/mesh.c=
=0A+++ b/drivers/net/wireless/marvell/libertas/mesh.c=0A@@ -805,12 +805,7 @=
@ static void lbs_persist_config_init(struct net_device *dev)=0A {=0A 	int =
ret;=0A 	ret =3D sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);=0A=
-	if (ret)=0A-		pr_err("failed to create boot_opts_group.\n");=0A-=0A 	ret =
=3D sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);=0A-	if (ret)=0A-	=
	pr_err("failed to create mesh_ie_group.\n");=0A }=0A =0A static void lbs_p=
ersist_config_remove(struct net_device *dev)=0A-- =0A2.30.2=0A=0A=0AFrom 75=
f74958ca71e96f4679ac33d3c4a9d677fb0e58 Mon Sep 17 00:00:00 2001=0AFrom: Sud=
ip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:00=
 +0100=0ASubject: [PATCH 112/165] Revert "usb: sierra: fix a missing check =
of=0A device_create_file"=0A=0AThis reverts commit 1a137b47ce6bd4f4b14662d2=
f5ace913ea7ffbf8.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/usb/storage/sier=
ra_ms.c | 4 +++-=0A 1 file changed, 3 insertions(+), 1 deletion(-)=0A=0Adif=
f --git a/drivers/usb/storage/sierra_ms.c b/drivers/usb/storage/sierra_ms.c=
=0Aindex b9f78ef3edc3..0f5c9cd8535f 100644=0A--- a/drivers/usb/storage/sier=
ra_ms.c=0A+++ b/drivers/usb/storage/sierra_ms.c=0A@@ -190,6 +190,8 @@ int s=
ierra_ms_init(struct us_data *us)=0A 		kfree(swocInfo);=0A 	}=0A complete:=
=0A-	return device_create_file(&us->pusb_intf->dev, &dev_attr_truinst);=0A+=
	result =3D device_create_file(&us->pusb_intf->dev, &dev_attr_truinst);=0A+=
=0A+	return 0;=0A }=0A =0A-- =0A2.30.2=0A=0A=0AFrom 9c781f1b5b033eb0e19005d=
106f76800a5f1db44 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.=
mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:00 +0100=0ASubject: [PA=
TCH 113/165] Revert "scsi: qla4xxx: fix a potential NULL pointer=0A derefer=
ence"=0A=0AThis reverts commit fba1bdd2a9a93f3e2181ec1936a3c2f6b37e7ed6.=0A=
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
 b/drivers/scsi/qla4xxx/ql4_os.c=0Aindex 2c23b692e318..9837f0b7ec76 100644=
=0A--- a/drivers/scsi/qla4xxx/ql4_os.c=0A+++ b/drivers/scsi/qla4xxx/ql4_os.=
c=0A@@ -3232,8 +3232,6 @@ static int qla4xxx_conn_bind(struct iscsi_cls_ses=
sion *cls_session,=0A 	if (iscsi_conn_bind(cls_session, cls_conn, is_leadin=
g))=0A 		return -EINVAL;=0A 	ep =3D iscsi_lookup_endpoint(transport_fd);=0A=
-	if (!ep)=0A-		return -EINVAL;=0A 	conn =3D cls_conn->dd_data;=0A 	qla_con=
n =3D conn->dd_data;=0A 	qla_conn->qla_ep =3D ep->dd_data;=0A-- =0A2.30.2=
=0A=0A=0AFrom 10e91a50e298c182b8606ec5bcee973cc7286843 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:00:01 +0100=0ASubject: [PATCH 114/165] Revert "libnvdimm/btt: Fi=
x a kmemdup failure check"=0A=0AThis reverts commit 486fa92df4707b5df58d650=
8728bdb9321a59766.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/nvdimm/btt_devs=
=2Ec | 18 +++++-------------=0A 1 file changed, 5 insertions(+), 13 deletio=
ns(-)=0A=0Adiff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs=
=2Ec=0Aindex 05feb97e11ce..995573905dfb 100644=0A--- a/drivers/nvdimm/btt_d=
evs.c=0A+++ b/drivers/nvdimm/btt_devs.c=0A@@ -191,15 +191,14 @@ static stru=
ct device *__nd_btt_create(struct nd_region *nd_region,=0A 		return NULL;=
=0A =0A 	nd_btt->id =3D ida_simple_get(&nd_region->btt_ida, 0, 0, GFP_KERNE=
L);=0A-	if (nd_btt->id < 0)=0A-		goto out_nd_btt;=0A+	if (nd_btt->id < 0) {=
=0A+		kfree(nd_btt);=0A+		return NULL;=0A+	}=0A =0A 	nd_btt->lbasize =3D lb=
asize;=0A-	if (uuid) {=0A+	if (uuid)=0A 		uuid =3D kmemdup(uuid, 16, GFP_KE=
RNEL);=0A-		if (!uuid)=0A-			goto out_put_id;=0A-	}=0A 	nd_btt->uuid =3D uu=
id;=0A 	dev =3D &nd_btt->dev;=0A 	dev_set_name(dev, "btt%d.%d", nd_region->=
id, nd_btt->id);=0A@@ -213,13 +212,6 @@ static struct device *__nd_btt_crea=
te(struct nd_region *nd_region,=0A 		return NULL;=0A 	}=0A 	return dev;=0A-=
=0A-out_put_id:=0A-	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);=0A-=
=0A-out_nd_btt:=0A-	kfree(nd_btt);=0A-	return NULL;=0A }=0A =0A struct devi=
ce *nd_btt_create(struct nd_region *nd_region)=0A-- =0A2.30.2=0A=0A=0AFrom =
9e44f985722804010562045f7d9ab63e3223236d Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:=
02 +0100=0ASubject: [PATCH 115/165] Revert "x86/hpet: Prevent potential NUL=
L pointer=0A dereference"=0A=0AThis reverts commit 2e84f116afca3719c9d0a1a7=
8b47b48f75fd5724.=0A=0ACommits from @umn.edu addresses have been found to b=
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
ip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A arch/x86/kernel/hpet.c |=
 2 --=0A 1 file changed, 2 deletions(-)=0A=0Adiff --git a/arch/x86/kernel/h=
pet.c b/arch/x86/kernel/hpet.c=0Aindex 7a50f0b62a70..ab91752536e2 100644=0A=
--- a/arch/x86/kernel/hpet.c=0A+++ b/arch/x86/kernel/hpet.c=0A@@ -820,8 +82=
0,6 @@ int __init hpet_enable(void)=0A 		return 0;=0A =0A 	hpet_set_mapping=
();=0A-	if (!hpet_virt_address)=0A-		return 0;=0A =0A 	/* Validate that the=
 config register is working */=0A 	if (!hpet_cfg_working())=0A-- =0A2.30.2=
=0A=0A=0AFrom 2f995761d774a35ef01ee3f46f64871f8e8e037c Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:00:02 +0100=0ASubject: [PATCH 116/165] Revert "staging: rtl8188e=
u: Fix potential NULL=0A pointer dereference of kcalloc"=0A=0AThis reverts =
commit 7671ce0d92933762f469266daf43bd34d422d58c.=0A=0ACommits from @umn.edu=
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
---=0A drivers/staging/rtl8188eu/core/rtw_xmit.c    |  9 ++-------=0A drive=
rs/staging/rtl8188eu/include/rtw_xmit.h |  2 +-=0A drivers/staging/rtl8723b=
s/core/rtw_xmit.c    | 14 +++++++-------=0A drivers/staging/rtl8723bs/inclu=
de/rtw_xmit.h |  2 +-=0A 4 files changed, 11 insertions(+), 16 deletions(-)=
=0A=0Adiff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/stag=
ing/rtl8188eu/core/rtw_xmit.c=0Aindex 314790fea1ae..3264d0609b42 100644=0A-=
-- a/drivers/staging/rtl8188eu/core/rtw_xmit.c=0A+++ b/drivers/staging/rtl8=
188eu/core/rtw_xmit.c=0A@@ -174,9 +174,7 @@ s32 _rtw_init_xmit_priv(struct =
xmit_priv *pxmitpriv, struct adapter *padapter)=0A =0A 	pxmitpriv->free_xmi=
t_extbuf_cnt =3D num_xmit_extbuf;=0A =0A-	res =3D rtw_alloc_hwxmits(padapte=
r);=0A-	if (res =3D=3D _FAIL)=0A-		goto exit;=0A+	rtw_alloc_hwxmits(padapte=
r);=0A 	rtw_init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);=0A =
=0A 	for (i =3D 0; i < 4; i++)=0A@@ -1505,7 +1503,7 @@ s32 rtw_xmit_classif=
ier(struct adapter *padapter, struct xmit_frame *pxmitframe)=0A 	return res=
;=0A }=0A =0A-s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A+void rtw_a=
lloc_hwxmits(struct adapter *padapter)=0A {=0A 	struct hw_xmit *hwxmits;=0A=
 	struct xmit_priv *pxmitpriv =3D &padapter->xmitpriv;=0A@@ -1514,8 +1512,6=
 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A =0A 	pxmitpriv->hwxm=
its =3D kcalloc(pxmitpriv->hwxmit_entry,=0A 				     sizeof(struct hw_xmit)=
, GFP_KERNEL);=0A-	if (!pxmitpriv->hwxmits)=0A-		return _FAIL;=0A =0A 	hwxm=
its =3D pxmitpriv->hwxmits;=0A =0A@@ -1523,7 +1519,6 @@ s32 rtw_alloc_hwxmi=
ts(struct adapter *padapter)=0A 	hwxmits[1] .sta_queue =3D &pxmitpriv->vi_p=
ending;=0A 	hwxmits[2] .sta_queue =3D &pxmitpriv->be_pending;=0A 	hwxmits[3=
] .sta_queue =3D &pxmitpriv->bk_pending;=0A-	return _SUCCESS;=0A }=0A =0A v=
oid rtw_free_hwxmits(struct adapter *padapter)=0Adiff --git a/drivers/stagi=
ng/rtl8188eu/include/rtw_xmit.h b/drivers/staging/rtl8188eu/include/rtw_xmi=
t.h=0Aindex 456fd52717f3..59490a447382 100644=0A--- a/drivers/staging/rtl81=
88eu/include/rtw_xmit.h=0A+++ b/drivers/staging/rtl8188eu/include/rtw_xmit.=
h=0A@@ -330,7 +330,7 @@ s32 rtw_txframes_sta_ac_pending(struct adapter *pad=
apter,=0A void rtw_init_hwxmits(struct hw_xmit *phwxmit, int entry);=0A s32=
 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)=
;=0A void _rtw_free_xmit_priv(struct xmit_priv *pxmitpriv);=0A-s32 rtw_allo=
c_hwxmits(struct adapter *padapter);=0A+void rtw_alloc_hwxmits(struct adapt=
er *padapter);=0A void rtw_free_hwxmits(struct adapter *padapter);=0A s32 r=
tw_xmit(struct adapter *padapter, struct sk_buff **pkt);=0A =0Adiff --git a=
/drivers/staging/rtl8723bs/core/rtw_xmit.c b/drivers/staging/rtl8723bs/core=
/rtw_xmit.c=0Aindex 6ecaff9728fd..3b4429fdd216 100644=0A--- a/drivers/stagi=
ng/rtl8723bs/core/rtw_xmit.c=0A+++ b/drivers/staging/rtl8723bs/core/rtw_xmi=
t.c=0A@@ -248,9 +248,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpr=
iv, struct adapter *padapter)=0A 		}=0A 	}=0A =0A-	res =3D rtw_alloc_hwxmit=
s(padapter);=0A-	if (res =3D=3D _FAIL)=0A-		goto exit;=0A+	rtw_alloc_hwxmit=
s(padapter);=0A 	rtw_init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_ent=
ry);=0A =0A 	for (i =3D 0; i < 4; i++)=0A@@ -1986,7 +1984,7 @@ s32 rtw_xmit=
_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)=0A 	re=
turn res;=0A }=0A =0A-s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A+vo=
id rtw_alloc_hwxmits(struct adapter *padapter)=0A {=0A 	struct hw_xmit *hwx=
mits;=0A 	struct xmit_priv *pxmitpriv =3D &padapter->xmitpriv;=0A@@ -1997,8=
 +1995,10 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A =0A 	pxmitp=
riv->hwxmits =3D rtw_zmalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_ent=
ry);=0A =0A-	if (!pxmitpriv->hwxmits)=0A-		return _FAIL;=0A+	if (pxmitpriv-=
>hwxmits =3D=3D NULL) {=0A+		DBG_871X("alloc hwxmits fail!...\n");=0A+		ret=
urn;=0A+	}=0A =0A 	hwxmits =3D pxmitpriv->hwxmits;=0A =0A@@ -2023,7 +2023,7=
 @@ s32 rtw_alloc_hwxmits(struct adapter *padapter)=0A 	} else {=0A 	}=0A =
=0A-	return _SUCCESS;=0A+=0A }=0A =0A void rtw_free_hwxmits(struct adapter =
*padapter)=0Adiff --git a/drivers/staging/rtl8723bs/include/rtw_xmit.h b/dr=
ivers/staging/rtl8723bs/include/rtw_xmit.h=0Aindex 196e70865c00..d3e59e7ef5=
4e 100644=0A--- a/drivers/staging/rtl8723bs/include/rtw_xmit.h=0A+++ b/driv=
ers/staging/rtl8723bs/include/rtw_xmit.h=0A@@ -483,7 +483,7 @@ s32 _rtw_ini=
t_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter);=0A void=
 _rtw_free_xmit_priv(struct xmit_priv *pxmitpriv);=0A =0A =0A-s32 rtw_alloc=
_hwxmits(struct adapter *padapter);=0A+void rtw_alloc_hwxmits(struct adapte=
r *padapter);=0A void rtw_free_hwxmits(struct adapter *padapter);=0A =0A =
=0A-- =0A2.30.2=0A=0A=0AFrom 15f6342adfd5f0621fc7d4dae1f2acb3ae2175e3 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:00:03 +0100=0ASubject: [PATCH 117/165] Revert "mi=
sc/ics932s401: Add a missing check to=0A i2c_smbus_read_word_data"=0A=0AThi=
s reverts commit b05ae01fdb8966afff5b153e7a7ee24684745e2d.=0A=0ACommits fro=
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
il.com>=0A---=0A drivers/misc/ics932s401.c | 2 --=0A 1 file changed, 2 dele=
tions(-)=0A=0Adiff --git a/drivers/misc/ics932s401.c b/drivers/misc/ics932s=
401.c=0Aindex 2bdf560ee681..733e5c2b57ce 100644=0A--- a/drivers/misc/ics932=
s401.c=0A+++ b/drivers/misc/ics932s401.c=0A@@ -133,8 +133,6 @@ static struc=
t ics932s401_data *ics932s401_update_device(struct device *dev)=0A 	 */=0A =
	for (i =3D 0; i < NUM_MIRRORED_REGS; i++) {=0A 		temp =3D i2c_smbus_read_w=
ord_data(client, regs_to_copy[i]);=0A-		if (temp < 0)=0A-			data->regs[regs=
_to_copy[i]] =3D 0;=0A 		data->regs[regs_to_copy[i]] =3D temp >> 8;=0A 	}=
=0A =0A-- =0A2.30.2=0A=0A=0AFrom 24d320557ab9f51343de183719a80d5f9b62b4ae M=
on Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com=
>=0ADate: Wed, 21 Apr 2021 20:00:04 +0100=0ASubject: [PATCH 118/165] Revert=
 "media: usb: gspca: add a missed return-value=0A check for do_command"=0A=
=0AThis reverts commit 5ceaf5452c1b2a452dadaf377f9f07af7bda9cc3.=0A=0ACommi=
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
ee@gmail.com>=0A---=0A drivers/media/usb/gspca/cpia1.c | 8 ++------=0A 1 fi=
le changed, 2 insertions(+), 6 deletions(-)=0A=0Adiff --git a/drivers/media=
/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c=0Aindex a4f7431486f3..=
5ee749e05267 100644=0A--- a/drivers/media/usb/gspca/cpia1.c=0A+++ b/drivers=
/media/usb/gspca/cpia1.c=0A@@ -537,14 +537,10 @@ static int do_command(stru=
ct gspca_dev *gspca_dev, u16 command,=0A 		}=0A 		if (sd->params.qx3.button=
) {=0A 			/* button pressed - unlock the latch */=0A-			ret =3D do_command(=
gspca_dev, CPIA_COMMAND_WriteMCPort,=0A+			do_command(gspca_dev, CPIA_COMMA=
ND_WriteMCPort,=0A 				   3, 0xdf, 0xdf, 0);=0A-			if (ret)=0A-				return r=
et;=0A-			ret =3D do_command(gspca_dev, CPIA_COMMAND_WriteMCPort,=0A+			do_=
command(gspca_dev, CPIA_COMMAND_WriteMCPort,=0A 				   3, 0xff, 0xff, 0);=
=0A-			if (ret)=0A-				return ret;=0A 		}=0A =0A 		/* test whether microsco=
pe is cradled */=0A-- =0A2.30.2=0A=0A=0AFrom 55b7628d09561f3ae3b1806f6e5bb4=
4aa7ebbaf6 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:04 +0100=0ASubject: [PATCH 119=
/165] Revert "ath6kl: return error code in=0A ath6kl_wmi_set_roam_lrssi_cmd=
()"=0A=0AThis reverts commit fc6a6521556c8250e356ddc6a3f2391aa62dc976.=0A=
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
m.mukherjee@gmail.com>=0A---=0A drivers/net/wireless/ath/ath6kl/wmi.c | 4 +=
++-=0A 1 file changed, 3 insertions(+), 1 deletion(-)=0A=0Adiff --git a/dri=
vers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c=
=0Aindex dbc47702a268..99be0d20f9a5 100644=0A--- a/drivers/net/wireless/ath=
/ath6kl/wmi.c=0A+++ b/drivers/net/wireless/ath/ath6kl/wmi.c=0A@@ -776,8 +77=
6,10 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)=0A 	cm=
d->info.params.roam_rssi_floor =3D DEF_LRSSI_ROAM_FLOOR;=0A 	cmd->roam_ctrl=
 =3D WMI_SET_LRSSI_SCAN_PARAMS;=0A =0A-	return ath6kl_wmi_cmd_send(wmi, 0, =
skb, WMI_SET_ROAM_CTRL_CMDID,=0A+	ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_=
ROAM_CTRL_CMDID,=0A 			    NO_SYNC_WMIFLAG);=0A+=0A+	return 0;=0A }=0A =0A =
int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)=0A-- =0A2.3=
0.2=0A=0A=0AFrom 8b7a33817167340dcb58c56249d244c43866b43c Mon Sep 17 00:00:=
00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 2=
1 Apr 2021 20:00:05 +0100=0ASubject: [PATCH 120/165] Revert "Input: ad7879 =
- add check for read errors in=0A interrupt"=0A=0AThis reverts commit e85bb=
0beb6498c0dffe18a2f1f16d575bc175c32.=0A=0ACommits from @umn.edu addresses h=
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
vers/input/touchscreen/ad7879.c | 11 ++++-------=0A 1 file changed, 4 inser=
tions(+), 7 deletions(-)=0A=0Adiff --git a/drivers/input/touchscreen/ad7879=
=2Ec b/drivers/input/touchscreen/ad7879.c=0Aindex 556a2af46e18..297fac9c9f9=
8 100644=0A--- a/drivers/input/touchscreen/ad7879.c=0A+++ b/drivers/input/t=
ouchscreen/ad7879.c=0A@@ -245,14 +245,11 @@ static void ad7879_timer(struct=
 timer_list *t)=0A static irqreturn_t ad7879_irq(int irq, void *handle)=0A =
{=0A 	struct ad7879 *ts =3D handle;=0A-	int error;=0A =0A-	error =3D regmap=
_bulk_read(ts->regmap, AD7879_REG_XPLUS,=0A-				 ts->conversion_data, AD787=
9_NR_SENSE);=0A-	if (error)=0A-		dev_err_ratelimited(ts->dev, "failed to re=
ad %#02x: %d\n",=0A-				    AD7879_REG_XPLUS, error);=0A-	else if (!ad7879_=
report(ts))=0A+	regmap_bulk_read(ts->regmap, AD7879_REG_XPLUS,=0A+			 ts->c=
onversion_data, AD7879_NR_SENSE);=0A+=0A+	if (!ad7879_report(ts))=0A 		mod_=
timer(&ts->timer, jiffies + TS_PEN_UP_TIMEOUT);=0A =0A 	return IRQ_HANDLED;=
=0A-- =0A2.30.2=0A=0A=0AFrom f1f3bc8feb0afc48a4eba0277c58671bc4136932 Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:00:06 +0100=0ASubject: [PATCH 121/165] Revert "se=
rial: max310x: pass return value of=0A spi_register_driver"=0A=0AThis rever=
ts commit 51f689cc11333944c7a457f25ec75fcb41e99410.=0A=0ACommits from @umn.=
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
m>=0A---=0A drivers/tty/serial/max310x.c | 4 ++--=0A 1 file changed, 2 inse=
rtions(+), 2 deletions(-)=0A=0Adiff --git a/drivers/tty/serial/max310x.c b/=
drivers/tty/serial/max310x.c=0Aindex 8434bd5a8ec7..f60b7b86d099 100644=0A--=
- a/drivers/tty/serial/max310x.c=0A+++ b/drivers/tty/serial/max310x.c=0A@@ =
-1527,10 +1527,10 @@ static int __init max310x_uart_init(void)=0A 		return =
ret;=0A =0A #ifdef CONFIG_SPI_MASTER=0A-	ret =3D spi_register_driver(&max31=
0x_spi_driver);=0A+	spi_register_driver(&max310x_spi_driver);=0A #endif=0A =
=0A-	return ret;=0A+	return 0;=0A }=0A module_init(max310x_uart_init);=0A =
=0A-- =0A2.30.2=0A=0A=0AFrom e38dadda730ed53a25e3a70ce816fe7f75afd0ca Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:00:06 +0100=0ASubject: [PATCH 122/165] Revert "AL=
SA: gus: add a check of the status of=0A snd_ctl_add"=0A=0AThis reverts com=
mit 0f25e000cb4398081748e54f62a902098aa79ec1.=0A=0ACommits from @umn.edu ad=
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
--=0A sound/isa/gus/gus_main.c | 13 ++-----------=0A 1 file changed, 2 inse=
rtions(+), 11 deletions(-)=0A=0Adiff --git a/sound/isa/gus/gus_main.c b/sou=
nd/isa/gus/gus_main.c=0Aindex afc088f0377c..b7518122a10d 100644=0A--- a/sou=
nd/isa/gus/gus_main.c=0A+++ b/sound/isa/gus/gus_main.c=0A@@ -77,17 +77,8 @@=
 static const struct snd_kcontrol_new snd_gus_joystick_control =3D {=0A =0A=
 static void snd_gus_init_control(struct snd_gus_card *gus)=0A {=0A-	int re=
t;=0A-=0A-	if (!gus->ace_flag) {=0A-		ret =3D=0A-			snd_ctl_add(gus->card,=
=0A-					snd_ctl_new1(&snd_gus_joystick_control,=0A-						gus));=0A-		if (r=
et)=0A-			snd_printk(KERN_ERR "gus: snd_ctl_add failed: %d\n",=0A-					ret)=
;=0A-	}=0A+	if (!gus->ace_flag)=0A+		snd_ctl_add(gus->card, snd_ctl_new1(&s=
nd_gus_joystick_control, gus));=0A }=0A =0A /*=0A-- =0A2.30.2=0A=0A=0AFrom =
5313ebbf03177dc0838c1eb6b74481a3470c92c2 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:=
07 +0100=0ASubject: [PATCH 123/165] Revert "Staging: rts5208: Fix error han=
dling on=0A rtsx_send_cmd"=0A=0AThis reverts commit c8c2702409430a6a2fd928e=
857f15773aaafcc99.=0A=0ACommits from @umn.edu addresses have been found to =
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
dip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/staging/rts5208=
/sd.c | 7 +------=0A 1 file changed, 1 insertion(+), 6 deletions(-)=0A=0Adi=
ff --git a/drivers/staging/rts5208/sd.c b/drivers/staging/rts5208/sd.c=0Ain=
dex 25c31496757e..63f5465a6eeb 100644=0A--- a/drivers/staging/rts5208/sd.c=
=0A+++ b/drivers/staging/rts5208/sd.c=0A@@ -4424,12 +4424,7 @@ int sd_execu=
te_write_data(struct scsi_cmnd *srb, struct rtsx_chip *chip)=0A 		rtsx_init=
_cmd(chip);=0A 		rtsx_add_cmd(chip, CHECK_REG_CMD, 0xFD30, 0x02, 0x02);=0A =
=0A-		retval =3D rtsx_send_cmd(chip, SD_CARD, 250);=0A-		if (retval < 0) {=
=0A-			write_err =3D true;=0A-			rtsx_clear_sd_error(chip);=0A-			goto sd_e=
xecute_write_cmd_failed;=0A-		}=0A+		rtsx_send_cmd(chip, SD_CARD, 250);=0A =
=0A 		retval =3D sd_update_lock_status(chip);=0A 		if (retval !=3D STATUS_S=
UCCESS) {=0A-- =0A2.30.2=0A=0A=0AFrom b3259c05c293cfd3817eac639ffb4cf3c2b9f=
155 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0ADate: Wed, 21 Apr 2021 20:00:08 +0100=0ASubject: [PATCH 124/165] R=
evert "staging: rts5208: Add a check for=0A ms_read_extra_data"=0A=0AThis r=
everts commit 73b69c01cc925d9c48e5b4f78e3d8b88c4e5b924.=0A=0ACommits from @=
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
l.com>=0A---=0A drivers/staging/rts5208/ms.c | 5 +----=0A 1 file changed, 1=
 insertion(+), 4 deletions(-)=0A=0Adiff --git a/drivers/staging/rts5208/ms.=
c b/drivers/staging/rts5208/ms.c=0Aindex 9001570a8c94..37b60ba1bdfe 100644=
=0A--- a/drivers/staging/rts5208/ms.c=0A+++ b/drivers/staging/rts5208/ms.c=
=0A@@ -1665,10 +1665,7 @@ static int ms_copy_page(struct rtsx_chip *chip, u=
16 old_blk, u16 new_blk,=0A 			return STATUS_FAIL;=0A 		}=0A =0A-		retval =
=3D ms_read_extra_data(chip, old_blk, i, extra,=0A-					    MS_EXTRA_SIZE);=
=0A-		if (retval !=3D STATUS_SUCCESS)=0A-			return STATUS_FAIL;=0A+		ms_rea=
d_extra_data(chip, old_blk, i, extra, MS_EXTRA_SIZE);=0A =0A 		retval =3D m=
s_set_rw_reg_addr(chip, OVERWRITE_FLAG,=0A 					    MS_EXTRA_SIZE, SYSTEM_P=
ARAM, 6);=0A-- =0A2.30.2=0A=0A=0AFrom 404acf57c23f5e02675323542f148a3af462a=
0a9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmai=
l.com>=0ADate: Wed, 21 Apr 2021 20:00:08 +0100=0ASubject: [PATCH 125/165] R=
evert "dmaengine: qcom_hidma: Check for driver=0A register failure"=0A=0ATh=
is reverts commit a474b3f0428d6b02a538aa10b3c3b722751cb382.=0A=0ACommits fr=
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
ail.com>=0A---=0A drivers/dma/qcom/hidma_mgmt.c | 3 ++-=0A 1 file changed, =
2 insertions(+), 1 deletion(-)=0A=0Adiff --git a/drivers/dma/qcom/hidma_mgm=
t.c b/drivers/dma/qcom/hidma_mgmt.c=0Aindex 806ca02c52d7..fe87b01f7a4e 1006=
44=0A--- a/drivers/dma/qcom/hidma_mgmt.c=0A+++ b/drivers/dma/qcom/hidma_mgm=
t.c=0A@@ -418,8 +418,9 @@ static int __init hidma_mgmt_init(void)=0A 		hidm=
a_mgmt_of_populate_channels(child);=0A 	}=0A #endif=0A-	return platform_dri=
ver_register(&hidma_mgmt_driver);=0A+	platform_driver_register(&hidma_mgmt_=
driver);=0A =0A+	return 0;=0A }=0A module_init(hidma_mgmt_init);=0A MODULE_=
LICENSE("GPL v2");=0A-- =0A2.30.2=0A=0A=0AFrom c0b94cbc89d60e3001ad1ef99173=
a7c267948c28 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukhe=
rjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:09 +0100=0ASubject: [PATCH 1=
26/165] Revert "leds: lp5523: fix a missing check of return=0A value of lp5=
5xx_read"=0A=0AThis reverts commit 248b57015f35c94d4eae2fdd8c6febf5cd703900=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/leds/leds-lp5523.c | 4 +---=
=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/driver=
s/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c=0Aindex fc433e63b1dc..503=
6d7d5f3d4 100644=0A--- a/drivers/leds/leds-lp5523.c=0A+++ b/drivers/leds/le=
ds-lp5523.c=0A@@ -305,9 +305,7 @@ static int lp5523_init_program_engine(str=
uct lp55xx_chip *chip)=0A =0A 	/* Let the programs run for couple of ms and=
 check the engine status */=0A 	usleep_range(3000, 6000);=0A-	ret =3D lp55x=
x_read(chip, LP5523_REG_STATUS, &status);=0A-	if (ret)=0A-		return ret;=0A+=
	lp55xx_read(chip, LP5523_REG_STATUS, &status);=0A 	status &=3D LP5523_ENG_=
STATUS_MASK;=0A =0A 	if (status !=3D LP5523_ENG_STATUS_MASK) {=0A-- =0A2.30=
=2E2=0A=0A=0AFrom 635929ed40f119917f0458bcf85fdce46387f459 Mon Sep 17 00:00=
:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, =
21 Apr 2021 20:00:10 +0100=0ASubject: [PATCH 127/165] Revert "iio: ad9523: =
fix a missing check of return=0A value"=0A=0AThis reverts commit ae0b377372=
1f08526c850e2d8dec85bdb870cd12.=0A=0ACommits from @umn.edu addresses have b=
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
ed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/ii=
o/frequency/ad9523.c | 7 ++-----=0A 1 file changed, 2 insertions(+), 5 dele=
tions(-)=0A=0Adiff --git a/drivers/iio/frequency/ad9523.c b/drivers/iio/fre=
quency/ad9523.c=0Aindex bdb0bc3b12dd..91eb47e27db0 100644=0A--- a/drivers/i=
io/frequency/ad9523.c=0A+++ b/drivers/iio/frequency/ad9523.c=0A@@ -944,14 +=
944,11 @@ static int ad9523_setup(struct iio_dev *indio_dev)=0A 		}=0A 	}=
=0A =0A-	for_each_clear_bit(i, &active_mask, AD9523_NUM_CHAN) {=0A-		ret =
=3D ad9523_write(indio_dev,=0A+	for_each_clear_bit(i, &active_mask, AD9523_=
NUM_CHAN)=0A+		ad9523_write(indio_dev,=0A 			     AD9523_CHANNEL_CLOCK_DIST=
(i),=0A 			     AD9523_CLK_DIST_DRIVER_MODE(TRISTATE) |=0A 			     AD9523_C=
LK_DIST_PWR_DOWN_EN);=0A-		if (ret < 0)=0A-			return ret;=0A-	}=0A =0A 	ret=
 =3D ad9523_write(indio_dev, AD9523_POWER_DOWN_CTRL, 0);=0A 	if (ret < 0)=
=0A-- =0A2.30.2=0A=0A=0AFrom eb0e23328e19860910296f83490e112324e3230a Mon S=
ep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
Date: Wed, 21 Apr 2021 20:00:10 +0100=0ASubject: [PATCH 128/165] Revert "mf=
d: mc13xxx: Fix a missing check of a=0A register-read failure"=0A=0AThis re=
verts commit 9e28989d41c0eab57ec0bb156617a8757406ff8a.=0A=0ACommits from @u=
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
om>=0A---=0A drivers/mfd/mc13xxx-core.c | 4 +---=0A 1 file changed, 1 inser=
tion(+), 3 deletions(-)=0A=0Adiff --git a/drivers/mfd/mc13xxx-core.c b/driv=
ers/mfd/mc13xxx-core.c=0Aindex 1abe7432aad8..b2beb7c39cc5 100644=0A--- a/dr=
ivers/mfd/mc13xxx-core.c=0A+++ b/drivers/mfd/mc13xxx-core.c=0A@@ -271,9 +27=
1,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int =
mode,=0A =0A 	mc13xxx->adcflags |=3D MC13XXX_ADC_WORKING;=0A =0A-	ret =3D m=
c13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A-	if (ret)=0A-		goto o=
ut;=0A+	mc13xxx_reg_read(mc13xxx, MC13XXX_ADC0, &old_adc0);=0A =0A 	adc0 =
=3D MC13XXX_ADC0_ADINC1 | MC13XXX_ADC0_ADINC2 |=0A 	       MC13XXX_ADC0_CHR=
GRAWDIV;=0A-- =0A2.30.2=0A=0A=0AFrom f83e0b9de0c775dff732e3acf57c6c14d8af11=
a4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:00:11 +0100=0ASubject: [PATCH 129/165] =
Revert "gdrom: fix a memory leak bug"=0A=0AThis reverts commit 093c48213ee3=
7c3c3ff1cf5ac1aa2a9d8bc66017.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/cdro=
m/gdrom.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/drivers/=
cdrom/gdrom.c b/drivers/cdrom/gdrom.c=0Aindex 9874fc1c815b..466fc3eee8bb 10=
0644=0A--- a/drivers/cdrom/gdrom.c=0A+++ b/drivers/cdrom/gdrom.c=0A@@ -863,=
7 +863,6 @@ static void __exit exit_gdrom(void)=0A 	platform_device_unregis=
ter(pd);=0A 	platform_driver_unregister(&gdrom_driver);=0A 	kfree(gd.toc);=
=0A-	kfree(gd.cd_info);=0A }=0A =0A module_init(init_gdrom);=0A-- =0A2.30.2=
=0A=0A=0AFrom 1aaf281bac449a74c73b69e8ffd0d16ecd6ac5f5 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:00:12 +0100=0ASubject: [PATCH 130/165] Revert "net: marvell: fix=
 a missing check of=0A acpi_match_device"=0A=0AThis reverts commit 92ee77d1=
48bf06d8c52664be4d1b862583fd5c0e.=0A=0ACommits from @umn.edu addresses have=
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
net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 --=0A 1 file changed, 2 deletio=
ns(-)=0A=0Adiff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/d=
rivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=0Aindex f5333fc27e14..a20d88=
e716a9 100644=0A--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=0A+++=
 b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=0A@@ -6811,8 +6811,6 @@ =
static int mvpp2_probe(struct platform_device *pdev)=0A 	if (has_acpi_compa=
nion(&pdev->dev)) {=0A 		acpi_id =3D acpi_match_device(pdev->dev.driver->ac=
pi_match_table,=0A 					    &pdev->dev);=0A-		if (!acpi_id)=0A-			return -E=
INVAL;=0A 		priv->hw_version =3D (unsigned long)acpi_id->driver_data;=0A 	}=
 else {=0A 		priv->hw_version =3D=0A-- =0A2.30.2=0A=0A=0AFrom 9ce706b1cb6c1=
54116641875ca0cd1b7d1bd4721 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:12 +0100=0ASu=
bject: [PATCH 131/165] Revert "atl1e: checking the status of=0A atl1e_write=
_phy_reg"=0A=0AThis reverts commit ff07d48d7bc0974d4f96a85a4df14564fb09f1ef=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/atheros/atl1e/a=
tl1e_main.c | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=
=0Adiff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/n=
et/ethernet/atheros/atl1e/atl1e_main.c=0Aindex ff9f96de74b8..85f9cb769e30 1=
00644=0A--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c=0A+++ b/drive=
rs/net/ethernet/atheros/atl1e/atl1e_main.c=0A@@ -455,9 +455,7 @@ static voi=
d atl1e_mdio_write(struct net_device *netdev, int phy_id,=0A {=0A 	struct a=
tl1e_adapter *adapter =3D netdev_priv(netdev);=0A =0A-	if (atl1e_write_phy_=
reg(&adapter->hw,=0A-				reg_num & MDIO_REG_ADDR_MASK, val))=0A-		netdev_er=
r(netdev, "write phy register failed\n");=0A+	atl1e_write_phy_reg(&adapter-=
>hw, reg_num & MDIO_REG_ADDR_MASK, val);=0A }=0A =0A static int atl1e_mii_i=
octl(struct net_device *netdev,=0A-- =0A2.30.2=0A=0A=0AFrom f874a5fa8a950af=
076ac92a1484a199823d8d7c9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:13 +0100=0ASubj=
ect: [PATCH 132/165] Revert "net: dsa: bcm_sf2: Propagate error value from=
=0A mdio_write"=0A=0AThis reverts commit e49505f7255be8ced695919c08a29bf2c3=
d79616.=0A=0ACommits from @umn.edu addresses have been found to be submitte=
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
rjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/dsa/bcm_sf2.c | 7 ++=
++---=0A 1 file changed, 4 insertions(+), 3 deletions(-)=0A=0Adiff --git a/=
drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c=0Aindex 510324916e91.=
=2Ec8991304f035 100644=0A--- a/drivers/net/dsa/bcm_sf2.c=0A+++ b/drivers/ne=
t/dsa/bcm_sf2.c=0A@@ -357,10 +357,11 @@ static int bcm_sf2_sw_mdio_write(st=
ruct mii_bus *bus, int addr, int regnum,=0A 	 * send them to our master MDI=
O bus controller=0A 	 */=0A 	if (addr =3D=3D BRCM_PSEUDO_PHY_ADDR && priv->=
indir_phy_mask & BIT(addr))=0A-		return bcm_sf2_sw_indir_rw(priv, 0, addr, =
regnum, val);=0A+		bcm_sf2_sw_indir_rw(priv, 0, addr, regnum, val);=0A 	els=
e=0A-		return mdiobus_write_nested(priv->master_mii_bus, addr,=0A-				regnu=
m, val);=0A+		mdiobus_write_nested(priv->master_mii_bus, addr, regnum, val)=
;=0A+=0A+	return 0;=0A }=0A =0A static irqreturn_t bcm_sf2_switch_0_isr(int=
 irq, void *dev_id)=0A-- =0A2.30.2=0A=0A=0AFrom 0702b6e5f853b5617644018392b=
b738340c06c9f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukh=
erjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:14 +0100=0ASubject: [PATCH =
133/165] Revert "net: stmicro: fix a missing check of=0A clk_prepare"=0A=0A=
This reverts commit f86a3b83833e7cfe558ca4d70b64ebc48903efec.=0A=0ACommits =
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
e@gmail.com>=0A---=0A drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c | 4=
 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/d=
rivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c b/drivers/net/ethernet/stm=
icro/stmmac/dwmac-sunxi.c=0Aindex 0e1ca2cba3c7..0e86553fc06f 100644=0A--- a=
/drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c=0A+++ b/drivers/net/ethe=
rnet/stmicro/stmmac/dwmac-sunxi.c=0A@@ -50,9 +50,7 @@ static int sun7i_gmac=
_init(struct platform_device *pdev, void *priv)=0A 		gmac->clk_enabled =3D =
1;=0A 	} else {=0A 		clk_set_rate(gmac->tx_clk, SUN7I_GMAC_MII_RATE);=0A-		=
ret =3D clk_prepare(gmac->tx_clk);=0A-		if (ret)=0A-			return ret;=0A+		clk=
_prepare(gmac->tx_clk);=0A 	}=0A =0A 	return 0;=0A-- =0A2.30.2=0A=0A=0AFrom=
 74cd6e38eb0dfd44cd591a02c2508722cf71216c Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00=
:14 +0100=0ASubject: [PATCH 134/165] Revert "media: dvb: Add check on sp887=
0_readreg"=0A=0AThis reverts commit 467a37fba93f2b4fe3ab597ff6a517b22b56688=
2.=0A=0ACommits from @umn.edu addresses have been found to be submitted in =
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-frontends/sp8870.c=
 | 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git=
 a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp887=
0.c=0Aindex 655db8272268..ee893a2f2261 100644=0A--- a/drivers/media/dvb-fro=
ntends/sp8870.c=0A+++ b/drivers/media/dvb-frontends/sp8870.c=0A@@ -280,9 +2=
80,7 @@ static int sp8870_set_frontend_parameters(struct dvb_frontend *fe)=
=0A 	sp8870_writereg(state, 0xc05, reg0xc05);=0A =0A 	// read status reg in=
 order to clear pending irqs=0A-	err =3D sp8870_readreg(state, 0x200);=0A-	=
if (err)=0A-		return err;=0A+	sp8870_readreg(state, 0x200);=0A =0A 	// syst=
em controller start=0A 	sp8870_microcontroller_start(state);=0A-- =0A2.30.2=
=0A=0A=0AFrom 4d767049fc2fadfaf16910482c41219739786f8d Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:00:15 +0100=0ASubject: [PATCH 135/165] Revert "net: chelsio: Add=
 a missing check on=0A cudg_get_buffer"=0A=0AThis reverts commit ca19fcb628=
5bfce1601c073bf4b9d2942e2df8d9.=0A=0ACommits from @umn.edu addresses have b=
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
t/ethernet/chelsio/cxgb4/cudbg_lib.c | 4 ----=0A 1 file changed, 4 deletion=
s(-)=0A=0Adiff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/dri=
vers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0Aindex c5b0e725b238..543da2f8a=
3e5 100644=0A--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0A+++ b/d=
rivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c=0A@@ -1638,10 +1638,6 @@ int =
cudbg_collect_hw_sched(struct cudbg_init *pdbg_init,=0A =0A 	rc =3D cudbg_g=
et_buff(pdbg_init, dbg_buff, sizeof(struct cudbg_hw_sched),=0A 			    &temp=
_buff);=0A-=0A-	if (rc)=0A-		return rc;=0A-=0A 	hw_sched_buff =3D (struct c=
udbg_hw_sched *)temp_buff.data;=0A 	hw_sched_buff->map =3D t4_read_reg(pada=
p, TP_TX_MOD_QUEUE_REQ_MAP_A);=0A 	hw_sched_buff->mode =3D TIMERMODE_G(t4_r=
ead_reg(padap, TP_MOD_CONFIG_A));=0A-- =0A2.30.2=0A=0A=0AFrom 9254a84a41bde=
4a673b91b0ceb8a866b2c73f92d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherje=
e <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:16 +0100=0ASu=
bject: [PATCH 136/165] Revert "net: (cpts) fix a missing check of=0A clk_pr=
epare"=0A=0AThis reverts commit 2d822f2dbab7f4c820f72eb8570aacf3f35855bd.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/ethernet/ti/cpts.c | 4 +=
---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git a/dri=
vers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c=0Aindex 43222a=
34cba0..60fde1bb9665 100644=0A--- a/drivers/net/ethernet/ti/cpts.c=0A+++ b/=
drivers/net/ethernet/ti/cpts.c=0A@@ -778,9 +778,7 @@ struct cpts *cpts_crea=
te(struct device *dev, void __iomem *regs,=0A 		return ERR_CAST(cpts->refcl=
k);=0A 	}=0A =0A-	ret =3D clk_prepare(cpts->refclk);=0A-	if (ret)=0A-		retu=
rn ERR_PTR(ret);=0A+	clk_prepare(cpts->refclk);=0A =0A 	cpts->cc.read =3D c=
pts_systim_read;=0A 	cpts->cc.mask =3D CLOCKSOURCE_MASK(32);=0A-- =0A2.30.2=
=0A=0A=0AFrom 4c624c04aa199bc024b67915b1dd66ba53175e23 Mon Sep 17 00:00:00 =
2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 A=
pr 2021 20:00:16 +0100=0ASubject: [PATCH 137/165] Revert "net/net_namespace=
: Check the return value of=0A register_pernet_subsys()"=0A=0AThis reverts =
commit 0eb987c874dc93f9c9d85a6465dbde20fdd3884c.=0A=0ACommits from @umn.edu=
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
---=0A net/core/net_namespace.c | 3 +--=0A 1 file changed, 1 insertion(+), =
2 deletions(-)=0A=0Adiff --git a/net/core/net_namespace.c b/net/core/net_na=
mespace.c=0Aindex dbc66b896287..ce886f8adc0c 100644=0A--- a/net/core/net_na=
mespace.c=0A+++ b/net/core/net_namespace.c=0A@@ -1114,8 +1114,7 @@ static i=
nt __init net_ns_init(void)=0A 	init_net_initialized =3D true;=0A 	up_write=
(&pernet_ops_rwsem);=0A =0A-	if (register_pernet_subsys(&net_ns_ops))=0A-		=
panic("Could not register network namespace subsystems");=0A+	register_pern=
et_subsys(&net_ns_ops);=0A =0A 	rtnl_register(PF_UNSPEC, RTM_NEWNSID, rtnl_=
net_newid, NULL,=0A 		      RTNL_FLAG_DOIT_UNLOCKED);=0A-- =0A2.30.2=0A=0A=
=0AFrom 1d043a662b7605099755c5db0584120a7dc8c0c3 Mon Sep 17 00:00:00 2001=
=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2=
021 20:00:17 +0100=0ASubject: [PATCH 138/165] Revert "drivers/regulator: fi=
x a missing check of=0A return value"=0A=0AThis reverts commit 966e927bf8cc=
6a44f8b72582a1d6d3ffc73b12ad.=0A=0ACommits from @umn.edu addresses have bee=
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
-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/regu=
lator/palmas-regulator.c | 5 +----=0A 1 file changed, 1 insertion(+), 4 del=
etions(-)=0A=0Adiff --git a/drivers/regulator/palmas-regulator.c b/drivers/=
regulator/palmas-regulator.c=0Aindex 337dd614695e..f27ad8254291 100644=0A--=
- a/drivers/regulator/palmas-regulator.c=0A+++ b/drivers/regulator/palmas-r=
egulator.c=0A@@ -438,16 +438,13 @@ static int palmas_ldo_write(struct palma=
s *palmas, unsigned int reg,=0A static int palmas_set_mode_smps(struct regu=
lator_dev *dev, unsigned int mode)=0A {=0A 	int id =3D rdev_get_id(dev);=0A=
-	int ret;=0A 	struct palmas_pmic *pmic =3D rdev_get_drvdata(dev);=0A 	stru=
ct palmas_pmic_driver_data *ddata =3D pmic->palmas->pmic_ddata;=0A 	struct =
palmas_regs_info *rinfo =3D &ddata->palmas_regs_info[id];=0A 	unsigned int =
reg;=0A 	bool rail_enable =3D true;=0A =0A-	ret =3D palmas_smps_read(pmic->=
palmas, rinfo->ctrl_addr, &reg);=0A-	if (ret)=0A-		return ret;=0A+	palmas_s=
mps_read(pmic->palmas, rinfo->ctrl_addr, &reg);=0A =0A 	reg &=3D ~PALMAS_SM=
PS12_CTRL_MODE_ACTIVE_MASK;=0A =0A-- =0A2.30.2=0A=0A=0AFrom 4255452e6a82b2b=
fffdc70e6ba7eed75e583e7f9 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee =
<sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:18 +0100=0ASubj=
ect: [PATCH 139/165] Revert "media: mt312: fix a missing check of mt312=0A =
reset"=0A=0AThis reverts commit 9502cdf0807058a10029488052b064cecceb7fc9.=
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
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/media/dvb-frontends/mt312.c =
| 4 +---=0A 1 file changed, 1 insertion(+), 3 deletions(-)=0A=0Adiff --git =
a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c=
=0Aindex d43a67045dbe..1dc6adefb8fe 100644=0A--- a/drivers/media/dvb-fronte=
nds/mt312.c=0A+++ b/drivers/media/dvb-frontends/mt312.c=0A@@ -627,9 +627,7 =
@@ static int mt312_set_frontend(struct dvb_frontend *fe)=0A 	if (ret < 0)=
=0A 		return ret;=0A =0A-	ret =3D mt312_reset(state, 0);=0A-	if (ret < 0)=
=0A-		return ret;=0A+	mt312_reset(state, 0);=0A =0A 	return 0;=0A }=0A-- =
=0A2.30.2=0A=0A=0AFrom 286c5f107bc6f69bf846ab78c9f659c98a6450ab Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:00:18 +0100=0ASubject: [PATCH 140/165] Revert "yam: fix=
 a missing-check bug"=0A=0AThis reverts commit 0781168e23a2fc8dceb989f11fc5=
b39b3ccacc35.=0A=0ACommits from @umn.edu addresses have been found to be su=
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
ukherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/net/hamradio/yam.c |=
 4 ----=0A 1 file changed, 4 deletions(-)=0A=0Adiff --git a/drivers/net/ham=
radio/yam.c b/drivers/net/hamradio/yam.c=0Aindex 5ab53e9942f3..616db3a0d2f4=
 100644=0A--- a/drivers/net/hamradio/yam.c=0A+++ b/drivers/net/hamradio/yam=
=2Ec=0A@@ -951,8 +951,6 @@ static int yam_ioctl(struct net_device *dev, str=
uct ifreq *ifr, int cmd)=0A 				 sizeof(struct yamdrv_ioctl_mcs));=0A 		if =
(IS_ERR(ym))=0A 			return PTR_ERR(ym);=0A-		if (ym->cmd !=3D SIOCYAMSMCS)=
=0A-			return -EINVAL;=0A 		if (ym->bitrate > YAM_MAXBITRATE) {=0A 			kfree=
(ym);=0A 			return -EINVAL;=0A@@ -968,8 +966,6 @@ static int yam_ioctl(stru=
ct net_device *dev, struct ifreq *ifr, int cmd)=0A 		if (copy_from_user(&yi=
, ifr->ifr_data, sizeof(struct yamdrv_ioctl_cfg)))=0A 			 return -EFAULT;=
=0A =0A-		if (yi.cmd !=3D SIOCYAMSCFG)=0A-			return -EINVAL;=0A 		if ((yi.c=
fg.mask & YAM_IOBASE) && netif_running(dev))=0A 			return -EINVAL;		/* Cann=
ot change this parameter when up */=0A 		if ((yi.cfg.mask & YAM_IRQ) && net=
if_running(dev))=0A-- =0A2.30.2=0A=0A=0AFrom 7e18d6563f85000fe6c13182876824=
56bc10cc27 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherj=
ee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:19 +0100=0ASubject: [PATCH 141=
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
turn -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom 16abca3ff9c5e62e45a569765be2168ee=
429116f Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@=
gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:20 +0100=0ASubject: [PATCH 142/16=
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
QAM-256 28dB */=0A 		else=0A-- =0A2.30.2=0A=0A=0AFrom 629f5a29c1ebb2194a513=
c570b50e2b9849e6e76 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:20 +0100=0ASubject: [=
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
=2E30.2=0A=0A=0AFrom b5078ff4fb0fd3044a7a0b249891fd6ab14036d7 Mon Sep 17 00=
:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: We=
d, 21 Apr 2021 20:00:21 +0100=0ASubject: [PATCH 144/165] Revert "net: thund=
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
 f2801e3cef8baf0e540be412a19f4fc57bded578 Mon Sep 17 00:00:00 2001=0AFrom: =
Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00=
:22 +0100=0ASubject: [PATCH 145/165] Revert "media: dvb: add return value c=
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
c b/drivers/media/dvb-frontends/drxd_hard.c=0Aindex 45f982863904..c27a2f0bf=
981 100644=0A--- a/drivers/media/dvb-frontends/drxd_hard.c=0A+++ b/drivers/=
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
A_RAM_CMD_PROC_START);=0A 	} while (0);=0A-- =0A2.30.2=0A=0A=0AFrom c3e5b74=
56f08861a6c4c0aa6f8d5d6d5aebf644b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:22 +010=
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
name,=0A 							   data, lm80_groups);=0A-- =0A2.30.2=0A=0A=0AFrom ab5f3dcf=
f6a327f9c6b3cc6d470badf1fa7a1844 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Muk=
herjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:23 +0100=
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
nion octnet_cmd *)sc->virtdptr;=0A =0A-- =0A2.30.2=0A=0A=0AFrom a88c25f2090=
35596b1ba68b6a90d441d123547d5 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukher=
jee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:24 +0100=0A=
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
=0A2.30.2=0A=0A=0AFrom 0b0b37848dbfcec4b753f96bd3b303d1ab024bd5 Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:00:24 +0100=0ASubject: [PATCH 149/165] Revert "isdn: mI=
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
de%d\n",=0A-- =0A2.30.2=0A=0A=0AFrom 656ce1c0e97bc239c2fd5acfb1ef2c9f7711ac=
54 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:00:25 +0100=0ASubject: [PATCH 150/165] =
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
hi->dch.state =3D dch->state;=0A-- =0A2.30.2=0A=0A=0AFrom 291f2cd1ae551e177=
c9545053446d0f2a414ab27 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <s=
udipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:26 +0100=0ASubjec=
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
=46rom bbe797a7eec294f9ec021b4ce7150f44a4dd9891 Mon Sep 17 00:00:00 2001=0A=
=46rom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 20=
21 20:00:26 +0100=0ASubject: [PATCH 152/165] Revert "ALSA: sb: fix a missin=
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
- =0A2.30.2=0A=0A=0AFrom dc3e196e7298bc000e573d39f133109e95417b50 Mon Sep 1=
7 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate=
: Wed, 21 Apr 2021 20:00:27 +0100=0ASubject: [PATCH 153/165] Revert "brcmfm=
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
gister(&brcmf_usbdrvr);=0A }=0A-- =0A2.30.2=0A=0A=0AFrom bc9a311ed3024c9c0d=
73d7ea8c3ce7e631360cc4 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <su=
dipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:28 +0100=0ASubject=
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
s/dma/mv_xor.c b/drivers/dma/mv_xor.c=0Aindex 00cd1335eeba..2bd5fd475e97 10=
0644=0A--- a/drivers/dma/mv_xor.c=0A+++ b/drivers/dma/mv_xor.c=0A@@ -1144,1=
0 +1144,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,=0A 		 dma_has=
_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",=0A 		 dma_has_cap(DMA_IN=
TERRUPT, dma_dev->cap_mask) ? "intr " : "");=0A =0A-	ret =3D dma_async_devi=
ce_register(dma_dev);=0A-	if (ret)=0A-		goto err_free_irq;=0A-=0A+	dma_asyn=
c_device_register(dma_dev);=0A 	return mv_chan;=0A =0A err_free_irq:=0A-- =
=0A2.30.2=0A=0A=0AFrom d6ceac5ff35b702e1fd9eff3375f191c4c55d9de Mon Sep 17 =
00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: =
Wed, 21 Apr 2021 20:00:28 +0100=0ASubject: [PATCH 155/165] Revert "niu: fix=
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
=0A 		start +=3D len;=0A-- =0A2.30.2=0A=0A=0AFrom 4e79e39c896e676ba01d59d3d=
6f2ecf4b88f9ee0 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:29 +0100=0ASubject: [PATC=
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
te.c=0Aindex 71e578ed8699..a0cadbe47cd5 100644=0A--- a/net/ipv6/route.c=0A+=
++ b/net/ipv6/route.c=0A@@ -6110,16 +6110,12 @@ static int ipv6_sysctl_rtca=
che_flush(struct ctl_table *ctl, int write,=0A {=0A 	struct net *net;=0A 	i=
nt delay;=0A-	int ret;=0A 	if (!write)=0A 		return -EINVAL;=0A =0A 	net =3D=
 (struct net *)ctl->extra1;=0A 	delay =3D net->ipv6.sysctl.flush_delay;=0A-=
	ret =3D proc_dointvec(ctl, write, buffer, lenp, ppos);=0A-	if (ret)=0A-		r=
eturn ret;=0A-=0A+	proc_dointvec(ctl, write, buffer, lenp, ppos);=0A 	fib6_=
run_gc(delay <=3D 0 ? 0 : (unsigned long)delay, net, delay > 0);=0A 	return=
 0;=0A }=0A-- =0A2.30.2=0A=0A=0AFrom 26e9b78f64d0dbc2438dc5f05c59e236809984=
4d Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail=
=2Ecom>=0ADate: Wed, 21 Apr 2021 20:00:30 +0100=0ASubject: [PATCH 157/165] =
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
ns(-)=0A=0Adiff --git a/net/socket.c b/net/socket.c=0Aindex 6e6cccc2104f..2=
1945b0bf2fc 100644=0A--- a/net/socket.c=0A+++ b/net/socket.c=0A@@ -3195,14 =
+3195,9 @@ static int ethtool_ioctl(struct net *net, struct compat_ifreq __=
user *ifr32)=0A 		    copy_in_user(&rxnfc->fs.ring_cookie,=0A 				 &compat_=
rxnfc->fs.ring_cookie,=0A 				 (void __user *)(&rxnfc->fs.location + 1) -=
=0A-				 (void __user *)&rxnfc->fs.ring_cookie))=0A-			return -EFAULT;=0A-	=
	if (ethcmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-			if (put_user(rule_cnt, &rxn=
fc->rule_cnt))=0A-				return -EFAULT;=0A-		} else if (copy_in_user(&rxnfc->=
rule_cnt,=0A-					&compat_rxnfc->rule_cnt,=0A-					sizeof(rxnfc->rule_cnt))=
)=0A+				 (void __user *)&rxnfc->fs.ring_cookie) ||=0A+		    copy_in_user(&=
rxnfc->rule_cnt, &compat_rxnfc->rule_cnt,=0A+				 sizeof(rxnfc->rule_cnt)))=
=0A 			return -EFAULT;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=0AFrom 444b572eb77917=
1adb0d02d975341261cc3bb6ec Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:30 +0100=0ASub=
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
2.30.2=0A=0A=0AFrom e0400f901ecfbc57ac4385ff7c6537a5645a3e08 Mon Sep 17 00:=
00:00 2001=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed=
, 21 Apr 2021 20:00:31 +0100=0ASubject: [PATCH 159/165] Revert "media: gspc=
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
, 2))=0A 		return -ENODEV;=0A-- =0A2.30.2=0A=0A=0AFrom aa75d575e1451b6f4d79=
f3b35a24d7990d9a846b Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudi=
pm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:32 +0100=0ASubject: =
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
 c98edb67cfb2..5fa26a1c2b48 100644=0A--- a/drivers/media/platform/davinci/i=
sif.c=0A+++ b/drivers/media/platform/davinci/isif.c=0A@@ -1082,8 +1082,7 @@=
 static int isif_probe(struct platform_device *pdev)=0A =0A 	while (i >=3D =
0) {=0A 		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);=0A-		if (=
res)=0A-			release_mem_region(res->start, resource_size(res));=0A+		release=
_mem_region(res->start, resource_size(res));=0A 		i--;=0A 	}=0A 	vpfe_unreg=
ister_ccdc_device(&isif_hw_dev);=0A-- =0A2.30.2=0A=0A=0AFrom 6c7f5cc50b5ba9=
3ab76507d45a936c007df41812 Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:33 +0100=0ASub=
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
=0A=0AFrom e377a883777b549fb158a8b6b9f02374cfca80a7 Mon Sep 17 00:00:00 200=
1=0AFrom: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr =
2021 20:00:34 +0100=0ASubject: [PATCH 162/165] Revert "scsi: 3w-9xxx: fix a=
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
=2Ec b/drivers/scsi/3w-9xxx.c=0Aindex 3337b1e80412..005f968fea42 100644=0A-=
-- a/drivers/scsi/3w-9xxx.c=0A+++ b/drivers/scsi/3w-9xxx.c=0A@@ -886,11 +88=
6,6 @@ static int twa_chrdev_open(struct inode *inode, struct file *file)=
=0A 	unsigned int minor_number;=0A 	int retval =3D TW_IOCTL_ERROR_OS_ENODEV=
;=0A =0A-	if (!capable(CAP_SYS_ADMIN)) {=0A-		retval =3D -EACCES;=0A-		goto=
 out;=0A-	}=0A-=0A 	minor_number =3D iminor(inode);=0A 	if (minor_number >=
=3D twa_device_extension_count)=0A 		goto out;=0A-- =0A2.30.2=0A=0A=0AFrom =
fa72bcc1949eee5992e104a2a309c001a0b8ecc1 Mon Sep 17 00:00:00 2001=0AFrom: S=
udip Mukherjee <sudipm.mukherjee@gmail.com>=0ADate: Wed, 21 Apr 2021 20:00:=
35 +0100=0ASubject: [PATCH 163/165] Revert "dm ioctl: harden copy_params()'=
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
=0A-- =0A2.30.2=0A=0A=0AFrom b70cdd0a2cf055123942f03cbdd5967b2d97e5ec Mon S=
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
=0A=0Adiff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c=0Aindex ec2cd7=
aab5ad..57dcfa3a5e71 100644=0A--- a/net/ethtool/ioctl.c=0A+++ b/net/ethtool=
/ioctl.c=0A@@ -876,9 +876,6 @@ static noinline_for_stack int ethtool_get_rx=
nfc(struct net_device *dev,=0A 			return -EINVAL;=0A 	}=0A =0A-	if (info.cm=
d !=3D cmd)=0A-		return -EINVAL;=0A-=0A 	if (info.cmd =3D=3D ETHTOOL_GRXCLS=
RLALL) {=0A 		if (info.rule_cnt > 0) {=0A 			if (info.rule_cnt <=3D KMALLOC=
_MAX_SIZE / sizeof(u32))=0A-- =0A2.30.2=0A=0A=0AFrom dbf00033fd9edbb17da8aa=
26356f06b27a3898ed Mon Sep 17 00:00:00 2001=0AFrom: Sudip Mukherjee <sudipm=
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
b/net/ethtool/ioctl.c=0Aindex 57dcfa3a5e71..b9d160171dc3 100644=0A--- a/net=
/ethtool/ioctl.c=0A+++ b/net/ethtool/ioctl.c=0A@@ -869,11 +869,6 @@ static =
noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,=0A 		info_=
size =3D sizeof(info);=0A 		if (copy_from_user(&info, useraddr, info_size))=
=0A 			return -EFAULT;=0A-		/* Since malicious users may modify the origina=
l data,=0A-		 * we need to check whether FLOW_RSS is still requested.=0A-		=
 */=0A-		if (!(info.flow_type & FLOW_RSS))=0A-			return -EINVAL;=0A 	}=0A =
=0A 	if (info.cmd =3D=3D ETHTOOL_GRXCLSRLALL) {=0A-- =0A2.30.2=0A=0A
--zwiwRNhsK/nH5DcA--
