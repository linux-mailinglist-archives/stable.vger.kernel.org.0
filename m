Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD686355DC8
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 23:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbhDFVUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 17:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242931AbhDFVUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 17:20:45 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50863C06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 14:20:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b9so7782525wrs.1
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 14:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=QAPmkAmKkwiZ2OsNvRAsyZWU9KBlqaRHiY1ReNJhsUc=;
        b=fyNsZaH1L/I8bN2UnKg2WxK55QV50Qo3r4mGxyg1idzFBPsy0s/4X/J27Xgg8YMD8c
         E/5rGEpXolmDdiTuw0HFEGWwZTF32jfgC6hPf/M5SuoKVkGuY5GW+g6O+hZVfvnDKgbH
         EsU+G3cY6pT+MjyuspDDpHQDQV97yxF8XxHrDQrwS9zrg8qB3NHUM+bfT/xvupbv8dNS
         XKVFwokroMKS8lTuxoUS8qBw936uC+8nXjd+IIdh7VYN4C7GVgPHdP0UitqArfFToWKO
         J7FrTyZQ+9QrI/0Yk7pclVk3epnicESIfBUfbzLHNMyQoYQlrqMWFz4/j0zUpMAgrubP
         AK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=QAPmkAmKkwiZ2OsNvRAsyZWU9KBlqaRHiY1ReNJhsUc=;
        b=lMWTp/JRtY6v/O/W1DZ63I2Jabpjs2IAYBYFHsOt0EMM2W1MZkUFaaKGgl1WxDUOKQ
         0e+h2Pp1p0HpLH6q/BAGVMowPeY9O3pERxb9nePj5DUJ3mxWbpJJfmhwmLcFjkN3HHXI
         9MNpUhWlQUp9/XfGDy1dyYhbRR/8JoGPzQ/p78pKXr8OF3jCdszYfAMa5Ft016dG3PHu
         lYB5/55HQkwpkZC74dSDca2aS/slsFDnob5WCPHqWvYyVvdwOJ81X9b9YEI2kkgbvexa
         xOB2U2HW9Ldgh/i2a6BgmAUjztNzWfmzIggtf61UGSx0oszMD2mxh+PYhmxEy4OY1G8v
         DxEQ==
X-Gm-Message-State: AOAM532fLkNCxQQ2vwhYavwQf3tD6YmoBLLXLJdEkmLsiqUIRNnxARxn
        r1RfARjZUz/dm98KDRA792A=
X-Google-Smtp-Source: ABdhPJyXQaetXRsMlj7IUeU9R/1Ydw/k5GYCLZA+HpCRkvzyxX1JtT73v01q5dxYaMNqe8Y22gDmxQ==
X-Received: by 2002:adf:d211:: with SMTP id j17mr222284wrh.311.1617744034912;
        Tue, 06 Apr 2021 14:20:34 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id o15sm35445063wra.93.2021.04.06.14.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 14:20:34 -0700 (PDT)
Date:   Tue, 6 Apr 2021 22:20:32 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org
Subject: missing commits for 4.4-stable
Message-ID: <YGzQoA2GfkKiNUYG@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ln5X9tCt2M87h00o"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ln5X9tCt2M87h00o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

These were missing in 4.4-stable. One of them is needed in 4.9-stable too.
Please apply to your queues.


--
Regards
Sudip

--ln5X9tCt2M87h00o
Content-Type: application/mbox
Content-Disposition: attachment; filename="backport_4.4-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 5f97a863b130672a70aefd25495f5844cfa198dc Mon Sep 17 00:00:00 2001=0A=
=46rom: "Shih-Yuan Lee (FourDollars)" <sylee@canonical.com>=0ADate: Mon, 14=
 Aug 2017 18:00:47 +0800=0ASubject: [PATCH 1/9] ALSA: hda/realtek - Fix pin=
cfg for Dell XPS 13 9370=0A=0Acommit 8df4b0031067758d8b0a3bfde7d35e980d0376=
d5 upstream=0A=0AThe initial pin configs for Dell headset mode of ALC3271 h=
as changed.=0A=0A/sys/class/sound/hwC0D0/init_pin_configs: (BIOS 0.1.4)=0A0=
x12 0xb7a60130=0A0x13 0xb8a61140=0A0x14 0x40000000=0A0x16 0x411111f0=0A0x17=
 0x90170110=0A0x18 0x411111f0=0A0x19 0x411111f0=0A0x1a 0x411111f0=0A0x1b 0x=
411111f0=0A0x1d 0x4087992d=0A0x1e 0x411111f0=0A0x21 0x04211020=0A=0Ahas cha=
nged to ...=0A=0A/sys/class/sound/hwC0D0/init_pin_configs: (BIOS 0.2.0)=0A0=
x12 0xb7a60130=0A0x13 0x40000000=0A0x14 0x411111f0=0A0x16 0x411111f0=0A0x17=
 0x90170110=0A0x18 0x411111f0=0A0x19 0x411111f0=0A0x1a 0x411111f0=0A0x1b 0x=
411111f0=0A0x1d 0x4067992d=0A0x1e 0x411111f0=0A0x21 0x04211020=0A=0AFixes: =
b4576de87243 ("ALSA: hda/realtek - Fix typo of pincfg for Dell quirk")=0ASi=
gned-off-by: Shih-Yuan Lee (FourDollars) <sylee@canonical.com>=0ACc: <stabl=
e@vger.kernel.org>=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned-o=
ff-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/pci/hda/=
patch_realtek.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/so=
und/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c=0Aindex 4bfe066=
50277..51163309c875 100644=0A--- a/sound/pci/hda/patch_realtek.c=0A+++ b/so=
und/pci/hda/patch_realtek.c=0A@@ -6212,7 +6212,6 @@ static const struct snd=
_hda_pin_quirk alc269_pin_fixup_tbl[] =3D {=0A 	SND_HDA_PIN_QUIRK(0x10ec029=
9, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A 		ALC225_STANDARD=
_PINS,=0A 		{0x12, 0xb7a60130},=0A-		{0x13, 0xb8a61140},=0A 		{0x17, 0x9017=
0110}),=0A 	{}=0A };=0A-- =0A2.30.2=0A=0A=0AFrom e4a2e5f1628bc13f1d14380691=
a9cbfdd98a6fc3 Mon Sep 17 00:00:00 2001=0AFrom: Miquel Raynal <miquel.rayna=
l@bootlin.com>=0ADate: Tue, 19 May 2020 15:00:29 +0200=0ASubject: [PATCH 2/=
9] mtd: rawnand: tmio: Fix the probe error path=0A=0Acommit 75e9a330a9bd48f=
97a55a08000236084fe3dae56 upstream=0A=0Anand_release() is supposed be calle=
d after MTD device registration.=0AHere, only nand_scan() happened, so use =
nand_cleanup() instead.=0A=0AThere is no real Fixes tag applying here as th=
e use of nand_release()=0Ain this driver predates by far the introduction o=
f nand_cleanup() in=0Acommit d44154f969a4 ("mtd: nand: Provide nand_cleanup=
() function to free NAND related resources")=0Awhich makes this change poss=
ible. However, pointing this commit as the=0Aculprit for backporting purpos=
es makes sense even if this commit is not=0Aintroducing any bug.=0A=0AFixes=
: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND re=
lated resources")=0ASigned-off-by: Miquel Raynal <miquel.raynal@bootlin.com=
>=0ACc: stable@vger.kernel.org=0ALink: https://lore.kernel.org/linux-mtd/20=
200519130035.1883-57-miquel.raynal@bootlin.com=0A[sudip: manual backport to=
 old file]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A=
---=0A drivers/mtd/nand/tmio_nand.c | 2 +-=0A 1 file changed, 1 insertion(+=
), 1 deletion(-)=0A=0Adiff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/m=
td/nand/tmio_nand.c=0Aindex befddf0776e4..d8c6c09917ad 100644=0A--- a/drive=
rs/mtd/nand/tmio_nand.c=0A+++ b/drivers/mtd/nand/tmio_nand.c=0A@@ -445,7 +4=
45,7 @@ static int tmio_probe(struct platform_device *dev)=0A 	if (!retval)=
=0A 		return retval;=0A =0A-	nand_release(mtd);=0A+	nand_cleanup(nand_chip)=
;=0A =0A err_irq:=0A 	tmio_hw_stop(dev, tmio);=0A-- =0A2.30.2=0A=0A=0AFrom =
7875191ece5d7838a9584355b5eaa2333135353b Mon Sep 17 00:00:00 2001=0AFrom: M=
iquel Raynal <miquel.raynal@bootlin.com>=0ADate: Tue, 19 May 2020 15:00:23 =
+0200=0ASubject: [PATCH 3/9] mtd: rawnand: socrates: Fix the probe error pa=
th=0A=0Acommit 9c6c2e5cc77119ce0dacb4f9feedb73ce0354421 upstream=0A=0Anand_=
release() is supposed be called after MTD device registration.=0AHere, only=
 nand_scan() happened, so use nand_cleanup() instead.=0A=0AThere is no real=
 Fixes tag applying here as the use of nand_release()=0Ain this driver pred=
ates by far the introduction of nand_cleanup() in=0Acommit d44154f969a4 ("m=
td: nand: Provide nand_cleanup() function to free NAND related resources")=
=0Awhich makes this change possible. However, pointing this commit as the=
=0Aculprit for backporting purposes makes sense even if this commit is not=
=0Aintroducing any bug.=0A=0AFixes: d44154f969a4 ("mtd: nand: Provide nand_=
cleanup() function to free NAND related resources")=0ASigned-off-by: Miquel=
 Raynal <miquel.raynal@bootlin.com>=0ACc: stable@vger.kernel.org=0ALink: ht=
tps://lore.kernel.org/linux-mtd/20200519130035.1883-51-miquel.raynal@bootli=
n.com=0A[sudip: manual backport to old file]=0ASigned-off-by: Sudip Mukherj=
ee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mtd/nand/socrates_nand.c |=
 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/dr=
ivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c=0Aindex b=
94f53427f0f..8775111837f4 100644=0A--- a/drivers/mtd/nand/socrates_nand.c=
=0A+++ b/drivers/mtd/nand/socrates_nand.c=0A@@ -204,7 +204,7 @@ static int =
socrates_nand_probe(struct platform_device *ofdev)=0A 	if (!res)=0A 		retur=
n res;=0A =0A-	nand_release(mtd);=0A+	nand_cleanup(nand_chip);=0A =0A out:=
=0A 	iounmap(host->io_base);=0A-- =0A2.30.2=0A=0A=0AFrom da574d77342ef4362d=
0a9b73b74b70381e10e948 Mon Sep 17 00:00:00 2001=0AFrom: Miquel Raynal <miqu=
el.raynal@bootlin.com>=0ADate: Tue, 19 May 2020 15:00:21 +0200=0ASubject: [=
PATCH 4/9] mtd: rawnand: sharpsl: Fix the probe error path=0A=0Acommit 0f44=
b3275b3798ccb97a2f51ac85871c30d6fbbc upstream=0A=0Anand_release() is suppos=
ed be called after MTD device registration.=0AHere, only nand_scan() happen=
ed, so use nand_cleanup() instead.=0A=0AThere is no Fixes tag applying here=
 as the use of nand_release()=0Ain this driver predates by far the introduc=
tion of nand_cleanup() in=0Acommit d44154f969a4 ("mtd: nand: Provide nand_c=
leanup() function to free NAND related resources")=0Awhich makes this chang=
e possible. However, pointing this commit as the=0Aculprit for backporting =
purposes makes sense.=0A=0AFixes: d44154f969a4 ("mtd: nand: Provide nand_cl=
eanup() function to free NAND related resources")=0ASigned-off-by: Miquel R=
aynal <miquel.raynal@bootlin.com>=0ACc: stable@vger.kernel.org=0ALink: http=
s://lore.kernel.org/linux-mtd/20200519130035.1883-49-miquel.raynal@bootlin.=
com=0A[sudip: manual backport to old file]=0ASigned-off-by: Sudip Mukherjee=
 <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mtd/nand/sharpsl.c | 2 +-=0A=
 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/mt=
d/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c=0Aindex 082b6009736d..42b2a8d=
90d33 100644=0A--- a/drivers/mtd/nand/sharpsl.c=0A+++ b/drivers/mtd/nand/sh=
arpsl.c=0A@@ -189,7 +189,7 @@ static int sharpsl_nand_probe(struct platform=
_device *pdev)=0A 	return 0;=0A =0A err_add:=0A-	nand_release(&sharpsl->mtd=
);=0A+	nand_cleanup(this);=0A =0A err_scan:=0A 	iounmap(sharpsl->io);=0A-- =
=0A2.30.2=0A=0A=0AFrom a9889f203a85e5ace738b320a480d3a135c1ba50 Mon Sep 17 =
00:00:00 2001=0AFrom: Miquel Raynal <miquel.raynal@bootlin.com>=0ADate: Tue=
, 19 May 2020 15:00:15 +0200=0ASubject: [PATCH 5/9] mtd: rawnand: plat_nand=
: Fix the probe error path=0A=0Acommit 5284024b4dac5e94f7f374ca905c7580dbc4=
55e9 upstream=0A=0Anand_release() is supposed be called after MTD device re=
gistration.=0AHere, only nand_scan() happened, so use nand_cleanup() instea=
d.=0A=0AThere is no real Fixes tag applying here as the use of nand_release=
()=0Ain this driver predates by far the introduction of nand_cleanup() in=
=0Acommit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free=
 NAND related resources")=0Awhich makes this change possible, hence pointin=
g it as the commit to=0Afix for backporting purposes, even if this commit i=
s not introducing=0Aany bug.=0A=0AFixes: d44154f969a4 ("mtd: nand: Provide =
nand_cleanup() function to free NAND related resources")=0ASigned-off-by: M=
iquel Raynal <miquel.raynal@bootlin.com>=0ACc: stable@vger.kernel.org=0ALin=
k: https://lore.kernel.org/linux-mtd/20200519130035.1883-43-miquel.raynal@b=
ootlin.com=0A[sudip: manual backport to old file]=0ASigned-off-by: Sudip Mu=
kherjee <sudipm.mukherjee@gmail.com>=0A---=0A drivers/mtd/nand/plat_nand.c =
| 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/d=
rivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c=0Aindex 65b9dbbe=
6d6a..89c4a19b1740 100644=0A--- a/drivers/mtd/nand/plat_nand.c=0A+++ b/driv=
ers/mtd/nand/plat_nand.c=0A@@ -102,7 +102,7 @@ static int plat_nand_probe(s=
truct platform_device *pdev)=0A 	if (!err)=0A 		return err;=0A =0A-	nand_re=
lease(&data->mtd);=0A+	nand_cleanup(&data->chip);=0A out:=0A 	if (pdata->ct=
rl.remove)=0A 		pdata->ctrl.remove(pdev);=0A-- =0A2.30.2=0A=0A=0AFrom 05bb4=
00edefb629bf365e985560ac96403e86a79 Mon Sep 17 00:00:00 2001=0AFrom: Miquel=
 Raynal <miquel.raynal@bootlin.com>=0ADate: Tue, 19 May 2020 15:00:13 +0200=
=0ASubject: [PATCH 6/9] mtd: rawnand: pasemi: Fix the probe error path=0A=
=0Acommit f51466901c07e6930435d30b02a21f0841174f61 upstream=0A=0Anand_clean=
up() is supposed to be called on error after a successful=0Acall to nand_sc=
an() to free all NAND resources.=0A=0AThere is no real Fixes tag applying h=
ere as the use of nand_release()=0Ain this driver predates by far the intro=
duction of nand_cleanup() in=0Acommit d44154f969a4 ("mtd: nand: Provide nan=
d_cleanup() function to free NAND related resources")=0Awhich makes this ch=
ange possible, hence pointing it as the commit to=0Afix for backporting pur=
poses, even if this commit is not introducing=0Aany bug.=0A=0AFixes: d44154=
f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related re=
sources")=0ASigned-off-by: Miquel Raynal <miquel.raynal@bootlin.com>=0ACc: =
stable@vger.kernel.org=0ALink: https://lore.kernel.org/linux-mtd/2020051913=
0035.1883-41-miquel.raynal@bootlin.com=0A[sudip: manual backport to old fil=
e]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A d=
rivers/mtd/nand/pasemi_nand.c | 4 +++-=0A 1 file changed, 3 insertions(+), =
1 deletion(-)=0A=0Adiff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mt=
d/nand/pasemi_nand.c=0Aindex 83cf021b9651..8d289a882ca7 100644=0A--- a/driv=
ers/mtd/nand/pasemi_nand.c=0A+++ b/drivers/mtd/nand/pasemi_nand.c=0A@@ -167=
,7 +167,7 @@ static int pasemi_nand_probe(struct platform_device *ofdev)=0A=
 	if (mtd_device_register(pasemi_nand_mtd, NULL, 0)) {=0A 		printk(KERN_ERR=
 "pasemi_nand: Unable to register MTD device\n");=0A 		err =3D -ENODEV;=0A-=
		goto out_lpc;=0A+		goto out_cleanup_nand;=0A 	}=0A =0A 	printk(KERN_INFO =
"PA Semi NAND flash at %08llx, control at I/O %x\n",=0A@@ -175,6 +175,8 @@ =
static int pasemi_nand_probe(struct platform_device *ofdev)=0A =0A 	return =
0;=0A =0A+ out_cleanup_nand:=0A+	nand_cleanup(chip);=0A  out_lpc:=0A 	relea=
se_region(lpcctl, 4);=0A  out_ior:=0A-- =0A2.30.2=0A=0A=0AFrom 6d78f445c521=
85c8aeb4bd55c648d5afb05ad8df Mon Sep 17 00:00:00 2001=0AFrom: Miquel Raynal=
 <miquel.raynal@bootlin.com>=0ADate: Tue, 19 May 2020 15:00:06 +0200=0ASubj=
ect: [PATCH 7/9] mtd: rawnand: orion: Fix the probe error path=0A=0Acommit =
be238fbf78e4c7c586dac235ab967d3e565a4d1a upstream=0A=0Anand_release() is su=
pposed be called after MTD device registration.=0AHere, only nand_scan() ha=
ppened, so use nand_cleanup() instead.=0A=0AThere is no real Fixes tag appl=
ying here as the use of nand_release()=0Ain this driver predates by far the=
 introduction of nand_cleanup() in=0Acommit d44154f969a4 ("mtd: nand: Provi=
de nand_cleanup() function to free NAND related resources")=0Awhich makes t=
his change possible. However, pointing this commit as the=0Aculprit for bac=
kporting purposes makes sense even if this commit is not=0Aintroducing any =
bug.=0A=0AFixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function =
to free NAND related resources")=0ASigned-off-by: Miquel Raynal <miquel.ray=
nal@bootlin.com>=0ACc: stable@vger.kernel.org=0ALink: https://lore.kernel.o=
rg/linux-mtd/20200519130035.1883-34-miquel.raynal@bootlin.com=0A[sudip: man=
ual backport to old file]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukherje=
e@gmail.com>=0A---=0A drivers/mtd/nand/orion_nand.c | 2 +-=0A 1 file change=
d, 1 insertion(+), 1 deletion(-)=0A=0Adiff --git a/drivers/mtd/nand/orion_n=
and.c b/drivers/mtd/nand/orion_nand.c=0Aindex ee83749fb1d3..7b4278d50b45 10=
0644=0A--- a/drivers/mtd/nand/orion_nand.c=0A+++ b/drivers/mtd/nand/orion_n=
and.c=0A@@ -165,7 +165,7 @@ static int __init orion_nand_probe(struct platf=
orm_device *pdev)=0A 	ret =3D mtd_device_parse_register(mtd, NULL, &ppdata,=
=0A 			board->parts, board->nr_parts);=0A 	if (ret) {=0A-		nand_release(mtd=
);=0A+		nand_cleanup(nc);=0A 		goto no_dev;=0A 	}=0A =0A-- =0A2.30.2=0A=0A=
=0AFrom 2414abeecf6fba1a4a69cbd247160095802c6daf Mon Sep 17 00:00:00 2001=
=0AFrom: Miquel Raynal <miquel.raynal@bootlin.com>=0ADate: Tue, 19 May 2020=
 14:59:45 +0200=0ASubject: [PATCH 8/9] mtd: rawnand: diskonchip: Fix the pr=
obe error path=0A=0Acommit c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 upstrea=
m=0A=0ANot sure nand_cleanup() is the right function to call here but in an=
y=0Acase it is not nand_release(). Indeed, even a comment says that=0Acalli=
ng nand_release() is a bit of a hack as there is no MTD device to=0Aunregis=
ter. So switch to nand_cleanup() for now and drop this=0Acomment.=0A=0ATher=
e is no Fixes tag applying here as the use of nand_release()=0Ain this driv=
er predates by far the introduction of nand_cleanup() in=0Acommit d44154f96=
9a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resou=
rces")=0Awhich makes this change possible. However, pointing this commit as=
 the=0Aculprit for backporting purposes makes sense even if it did not intr=
uce=0Aany bug.=0A=0AFixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup()=
 function to free NAND related resources")=0ASigned-off-by: Miquel Raynal <=
miquel.raynal@bootlin.com>=0ACc: stable@vger.kernel.org=0ALink: https://lor=
e.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com=0A[=
sudip: manual backport to old file]=0ASigned-off-by: Sudip Mukherjee <sudip=
m.mukherjee@gmail.com>=0A---=0A drivers/mtd/nand/diskonchip.c | 7 ++-----=
=0A 1 file changed, 2 insertions(+), 5 deletions(-)=0A=0Adiff --git a/drive=
rs/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c=0Aindex 0802158a3f=
75..557fcf1c21fe 100644=0A--- a/drivers/mtd/nand/diskonchip.c=0A+++ b/drive=
rs/mtd/nand/diskonchip.c=0A@@ -1608,13 +1608,10 @@ static int __init doc_pr=
obe(unsigned long physadr)=0A 		numchips =3D doc2001_init(mtd);=0A =0A 	if =
((ret =3D nand_scan(mtd, numchips)) || (ret =3D doc->late_init(mtd))) {=0A-=
		/* DBB note: i believe nand_release is necessary here, as=0A+		/* DBB not=
e: i believe nand_cleanup is necessary here, as=0A 		   buffers may have be=
en allocated in nand_base.  Check with=0A 		   Thomas. FIX ME! */=0A-		/* n=
and_release will call mtd_device_unregister, but we=0A-		   haven't yet add=
ed it.  This is handled without incident by=0A-		   mtd_device_unregister, =
as far as I can tell. */=0A-		nand_release(mtd);=0A+		nand_cleanup(nand);=
=0A 		kfree(mtd);=0A 		goto fail;=0A 	}=0A-- =0A2.30.2=0A=0A=0AFrom 561fd8a=
4093b3f85529c6effbb902fa2858fecd1 Mon Sep 17 00:00:00 2001=0AFrom: "Steven =
Rostedt (VMware)" <rostedt@goodmis.org>=0ADate: Wed, 6 May 2020 10:36:18 -0=
400=0ASubject: [PATCH 9/9] tracing: Add a vmalloc_sync_mappings() for safe =
measure=0A=0Acommit 11f5efc3ab66284f7aaacc926e9351d658e2577b upstream=0A=0A=
x86_64 lazily maps in the vmalloc pages, and the way this works with per_cp=
u=0Aareas can be complex, to say the least. Mappings may happen at boot up,=
 and=0Aif nothing synchronizes the page tables, those page mappings may not=
 be=0Asynced till they are used. This causes issues for anything that might=
 touch=0Aone of those mappings in the path of the page fault handler. When =
one of=0Athose unmapped mappings is touched in the page fault handler, it w=
ill cause=0Aanother page fault, which in turn will cause a page fault, and =
leave us in=0Aa loop of page faults.=0A=0ACommit 763802b53a42 ("x86/mm: spl=
it vmalloc_sync_all()") split=0Avmalloc_sync_all() into vmalloc_sync_unmapp=
ings() and=0Avmalloc_sync_mappings(), as on system exit, it did not need to=
 do a full=0Async on x86_64 (although it still needed to be done on x86_32)=
=2E By chance,=0Athe vmalloc_sync_all() would synchronize the page mappings=
 done at boot up=0Aand prevent the per cpu area from being a problem for tr=
acing in the page=0Afault handler. But when that synchronization in the exi=
t of a task became a=0Anop, it caused the problem to appear.=0A=0ALink: htt=
ps://lore.kernel.org/r/20200429054857.66e8e333@oasis.local.home=0A=0ACc: st=
able@vger.kernel.org=0AFixes: 737223fbca3b1 ("tracing: Consolidate buffer a=
llocation code")=0AReported-by: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@=
gmail.com>=0ASuggested-by: Joerg Roedel <jroedel@suse.de>=0ASigned-off-by: =
Steven Rostedt (VMware) <rostedt@goodmis.org>=0A[sudip: add header]=0ASigne=
d-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A kernel/trac=
e/trace.c | 14 ++++++++++++++=0A 1 file changed, 14 insertions(+)=0A=0Adiff=
 --git a/kernel/trace/trace.c b/kernel/trace/trace.c=0Aindex ca8c8bdc1143..=
8822ae65a506 100644=0A--- a/kernel/trace/trace.c=0A+++ b/kernel/trace/trace=
=2Ec=0A@@ -26,6 +26,7 @@=0A #include <linux/linkage.h>=0A #include <linux/u=
access.h>=0A #include <linux/kprobes.h>=0A+#include <linux/vmalloc.h>=0A #i=
nclude <linux/ftrace.h>=0A #include <linux/module.h>=0A #include <linux/per=
cpu.h>=0A@@ -6626,6 +6627,19 @@ static int allocate_trace_buffers(struct tr=
ace_array *tr, int size)=0A 	 */=0A 	allocate_snapshot =3D false;=0A #endif=
=0A+=0A+	/*=0A+	 * Because of some magic with the way alloc_percpu() works =
on=0A+	 * x86_64, we need to synchronize the pgd of all the tables,=0A+	 * =
otherwise the trace events that happen in x86_64 page fault=0A+	 * handlers=
 can't cope with accessing the chance that a=0A+	 * alloc_percpu()'d memory=
 might be touched in the page fault trace=0A+	 * event. Oh, and we need to =
audit all other alloc_percpu() and vmalloc()=0A+	 * calls in tracing, becau=
se something might get triggered within a=0A+	 * page fault trace event!=0A=
+	 */=0A+	vmalloc_sync_mappings();=0A+=0A 	return 0;=0A }=0A =0A-- =0A2.30.=
2=0A=0A
--ln5X9tCt2M87h00o
Content-Type: application/mbox
Content-Disposition: attachment; filename="backport_4.9-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom cbc384daf0011a0812b36d1f2b00568bd55c39a6 Mon Sep 17 00:00:00 2001=0A=
=46rom: "Shih-Yuan Lee (FourDollars)" <sylee@canonical.com>=0ADate: Mon, 14=
 Aug 2017 18:00:47 +0800=0ASubject: [PATCH] ALSA: hda/realtek - Fix pincfg =
for Dell XPS 13 9370=0A=0Acommit 8df4b0031067758d8b0a3bfde7d35e980d0376d5 u=
pstream=0A=0AThe initial pin configs for Dell headset mode of ALC3271 has c=
hanged.=0A=0A/sys/class/sound/hwC0D0/init_pin_configs: (BIOS 0.1.4)=0A0x12 =
0xb7a60130=0A0x13 0xb8a61140=0A0x14 0x40000000=0A0x16 0x411111f0=0A0x17 0x9=
0170110=0A0x18 0x411111f0=0A0x19 0x411111f0=0A0x1a 0x411111f0=0A0x1b 0x4111=
11f0=0A0x1d 0x4087992d=0A0x1e 0x411111f0=0A0x21 0x04211020=0A=0Ahas changed=
 to ...=0A=0A/sys/class/sound/hwC0D0/init_pin_configs: (BIOS 0.2.0)=0A0x12 =
0xb7a60130=0A0x13 0x40000000=0A0x14 0x411111f0=0A0x16 0x411111f0=0A0x17 0x9=
0170110=0A0x18 0x411111f0=0A0x19 0x411111f0=0A0x1a 0x411111f0=0A0x1b 0x4111=
11f0=0A0x1d 0x4067992d=0A0x1e 0x411111f0=0A0x21 0x04211020=0A=0AFixes: b457=
6de87243 ("ALSA: hda/realtek - Fix typo of pincfg for Dell quirk")=0ASigned=
-off-by: Shih-Yuan Lee (FourDollars) <sylee@canonical.com>=0ACc: <stable@vg=
er.kernel.org>=0ASigned-off-by: Takashi Iwai <tiwai@suse.de>=0ASigned-off-b=
y: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A sound/pci/hda/patc=
h_realtek.c | 1 -=0A 1 file changed, 1 deletion(-)=0A=0Adiff --git a/sound/=
pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c=0Aindex 79c45046edc=
6..7b94170aa5ec 100644=0A--- a/sound/pci/hda/patch_realtek.c=0A+++ b/sound/=
pci/hda/patch_realtek.c=0A@@ -6285,7 +6285,6 @@ static const struct snd_hda=
_pin_quirk alc269_pin_fixup_tbl[] =3D {=0A 	SND_HDA_PIN_QUIRK(0x10ec0299, 0=
x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,=0A 		ALC225_STANDARD_PIN=
S,=0A 		{0x12, 0xb7a60130},=0A-		{0x13, 0xb8a61140},=0A 		{0x17, 0x90170110=
}),=0A 	{}=0A };=0A-- =0A2.30.2=0A=0A
--ln5X9tCt2M87h00o--
