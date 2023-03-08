Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80F56B1211
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 20:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCHTd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 14:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCHTd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 14:33:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D067F580E2
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 11:33:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bw19so16418271wrb.13
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 11:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678304003;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FyYWQ4ZX0ATmBXh44KjlHwO341Yn1PRkuR10GW4tLaQ=;
        b=Yh654aJ7/wbmNPbxfUzRjaUmV+0Tc2w8TOSwZw2tGD3IpUeR8Yll4ftTVkrBHcd/eD
         73nr+70T3WFetwDxlkFTPfCZBuZzNGmnGez9fL8e0x8O7B5z13Ix7djDhpmtgPeO3LI9
         rOGjs2CFQo+ax/H8DWwwK7VoEBF71nscVaELy6nHu/U7wAfe9//I7L6o1UyPfhHmbP1F
         y78FV6HoCmIP+71GU+O9cTfZD68p8r5q89/fwthJQptP+20yfpXKnF3QGobKsrTevM5X
         bNfZwb1ywiSZbP+pskn5x2sf+beDE32gyy3psA1TNVx24JJ5tzN+9rkk10mSrj83YfO9
         Y7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678304003;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FyYWQ4ZX0ATmBXh44KjlHwO341Yn1PRkuR10GW4tLaQ=;
        b=fdTTMGN+xnQjJvlkSEXrrmKW52+DlDK2Y6w7HzqXmv9K79bq/HJg6lN+Vv85ad2YwJ
         alll6ZeN7mGk1qDos/UfSsukJqp0NPwLca25M1jfUgAyrucsyfrcn20g+YIIL9n2Gsst
         WiiQr6JGe8llNYvkrADrNF+w1Yz3IkbJtJrUmiS/GyoT1hHNKvkGwtxp2Cl/qEVWMWXx
         sA8+6oZ1jj17DOpomH+l0Bz5c5iuVWVGv+PUW+oaC88+Ig2e9gLgrZNkaj7OWY5mhoa3
         n/4Cq1faTJxxkbqVGD57I3ZCoauH6BtDl7xPpOCywR6SN5S9aH4b6AdyKug3hDz/I0/b
         /PkQ==
X-Gm-Message-State: AO0yUKX75FbpLrXJcAwBl6rnl9/DNP19KJ5zpHvFKVjBuffxFVYwBAHK
        djZJ9R2sd0TY+TZZzUvpXDc=
X-Google-Smtp-Source: AK7set/aQ643KqgwD9QZD/qBiTBy3yb9aPJ7A3Jtyno0gXWkN7ult2pQ0oi+92oM5AlP5dIcHqjKvQ==
X-Received: by 2002:a5d:4347:0:b0:2c9:1a3f:d5f8 with SMTP id u7-20020a5d4347000000b002c91a3fd5f8mr10780315wrr.41.1678304003096;
        Wed, 08 Mar 2023 11:33:23 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id j2-20020a5d6042000000b002c70d269b4esm15808125wrt.91.2023.03.08.11.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 11:33:22 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id A7AD6BE2DE0; Wed,  8 Mar 2023 20:33:21 +0100 (CET)
Date:   Wed, 8 Mar 2023 20:33:21 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Martin Wilck <mwilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
Message-ID: <ZAjjAcLZ/3HsqtzQ@eldamar.lan>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
 <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com>
 <ZAi4k/09acWV0wRZ@eldamar.lan>
 <8579fc77c0de08c17d6d34b4d5dcc9386d69ebba.camel@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/+i+J8MBiLX1Dj1b"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8579fc77c0de08c17d6d34b4d5dcc9386d69ebba.camel@suse.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/+i+J8MBiLX1Dj1b
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Martin,

On Wed, Mar 08, 2023 at 07:06:10PM +0100, Martin Wilck wrote:
> On Wed, 2023-03-08 at 17:32 +0100, Salvatore Bonaccorso wrote:
> > hi Martin, hi Sreekanth,
> > 
> > On Mon, Mar 06, 2023 at 08:16:35PM -0500, Martin K. Petersen wrote:
> > > 
> > > Hi Salvatore!
> > > 
> > > > Sreekanth and Martin is this still on your radar?
> > > 
> > > Broadcom will have to provide a suitable fix for the relevant older
> > > stable releases. It is the patch author's responsibility to provide
> > > backports.
> > > 
> > > > as 9df650963bf6 picking as well is not an option.
> > > 
> > > Why not?
> > 
> > Thanks to Martin Wilck from SUSE to get me understanding the picture.
> > The problem is that e0e0747de0ea ("scsi: mpt3sas:
> > Fix return value check of dma_get_required_mask()") was backported to
> > several series. In mainline though the mis-merge did undo that. So I
> > believe the right thing would be to revert first in the stable series
> > where it was applied (5.10.y, 5.15.y) the commit e0e0747de0ea ("scsi:
> > mpt3sas: Fix return value check of dma_get_required_mask()")  and
> > then
> > on top of this revert apply the patches:
> > 
> > 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
> > reallocating pools")
> > 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
> > 06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask()
> > API")
> > 
> > Attached mbox file implements this.
> > 
> > Does that looks now good for resolving the regression?
> > 
> 
> Yes, this makes sense and it's actually the same thing I did for our
> 5.14 series. Thanks for re-figuring it out, the matter is really
> confusing.

Thanks for confirming. 

I had a small typo in the commit message of the revert commit,
attached is an updated mbox with that fixed (afferomentioned ->
aforementioned).

Regards,
Salvatore

--/+i+J8MBiLX1Dj1b
Content-Type: application/mbox
Content-Disposition: attachment; filename="mpt3sas-xen-regression.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 6ac451d8d12b4309b523b600449bb2f4494ac5bb Mon Sep 17 00:00:00 2001=0A=
=46rom: Salvatore Bonaccorso <carnil@debian.org>=0ADate: Wed, 8 Mar 2023 17=
:14:56 +0100=0ASubject: [PATCH 1/4] Revert "scsi: mpt3sas: Fix return value=
 check of=0A dma_get_required_mask()"=0A=0AThis reverts commit e0e0747de0ea=
3dd87cdbb0393311e17471a9baf1.=0A=0AAs noted in 1a2dcbdde82e ("scsi: mpt3sas=
: re-do lost mpt3sas DMA mask=0Afix") in mainline there was a mis-merge in =
commit 62e6e5940c0c ("Merge=0Atag 'scsi-misc' of=0Agit://git.kernel.org/pub=
/scm/linux/kernel/git/jejb/scsi"). causing that=0Athe fix needed to be redo=
ne later on again. To make series of patches=0Aapply cleanly to the stable =
series where e0e0747de0ea ("scsi: mpt3sas:=0AFix return value check of dma_=
get_required_mask()") was backported,=0Arevert the aforementioned commit.=
=0A=0ANo upstream commit exists for this commit.=0A=0ALink: https://lore.ke=
rnel.org/regressions/yq1sfehmjnb.fsf@ca-mkp.ca.oracle.com/=0ASigned-off-by:=
 Salvatore Bonaccorso <carnil@debian.org>=0A---=0A drivers/scsi/mpt3sas/mpt=
3sas_base.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adi=
ff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3s=
as_base.c=0Aindex c1b76cda60db..18f85c963944 100644=0A--- a/drivers/scsi/mp=
t3sas/mpt3sas_base.c=0A+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c=0A@@ -2825=
,7 +2825,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, stru=
ct pci_dev *pdev)=0A =0A 	if (ioc->is_mcpu_endpoint ||=0A 	    sizeof(dma_a=
ddr_t) =3D=3D 4 || ioc->use_32bit_dma ||=0A-	    dma_get_required_mask(&pde=
v->dev) <=3D DMA_BIT_MASK(32))=0A+	    dma_get_required_mask(&pdev->dev) <=
=3D 32)=0A 		ioc->dma_mask =3D 32;=0A 	/* Set 63 bit DMA mask for all SAS3 =
and SAS35 controllers */=0A 	else if (ioc->hba_mpi_version_belonged > MPI2_=
VERSION)=0A-- =0A2.39.2=0A=0A=0AFrom 7e4f02c0747d8713735098ddb9744bd30f0903=
af Mon Sep 17 00:00:00 2001=0AFrom: Sreekanth Reddy <sreekanth.reddy@broadc=
om.com>=0ADate: Thu, 25 Aug 2022 13:24:54 +0530=0ASubject: [PATCH 2/4] scsi=
: mpt3sas: Don't change DMA mask while reallocating=0A pools=0A=0Acommit 9d=
f650963bf6d6c2c3fcd325d8c44ca2b99554fe upstream.=0A=0AWhen a pool crosses t=
he 4GB boundary region then before reallocating pools=0Achange the coherent=
 DMA mask to 32 bits and keep the normal DMA mask set to=0A63/64 bits.=0A=
=0ALink: https://lore.kernel.org/r/20220825075457.16422-2-sreekanth.reddy@b=
roadcom.com=0ASigned-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>=
=0ASigned-off-by: Martin K. Petersen <martin.petersen@oracle.com>=0ASigned-=
off-by: Salvatore Bonaccorso <carnil@debian.org>=0A---=0A drivers/scsi/mpt3=
sas/mpt3sas_base.c | 21 ++++++++++++++-------=0A 1 file changed, 14 inserti=
ons(+), 7 deletions(-)=0A=0Adiff --git a/drivers/scsi/mpt3sas/mpt3sas_base.=
c b/drivers/scsi/mpt3sas/mpt3sas_base.c=0Aindex 18f85c963944..faea8001adf5 =
100644=0A--- a/drivers/scsi/mpt3sas/mpt3sas_base.c=0A+++ b/drivers/scsi/mpt=
3sas/mpt3sas_base.c=0A@@ -2822,19 +2822,26 @@ static int=0A _base_config_dm=
a_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)=0A {=0A 	st=
ruct sysinfo s;=0A+	u64 coherent_dma_mask, dma_mask;=0A =0A-	if (ioc->is_mc=
pu_endpoint ||=0A-	    sizeof(dma_addr_t) =3D=3D 4 || ioc->use_32bit_dma ||=
=0A-	    dma_get_required_mask(&pdev->dev) <=3D 32)=0A+	if (ioc->is_mcpu_en=
dpoint || sizeof(dma_addr_t) =3D=3D 4 ||=0A+	    dma_get_required_mask(&pde=
v->dev) <=3D 32) {=0A 		ioc->dma_mask =3D 32;=0A+		coherent_dma_mask =3D dm=
a_mask =3D DMA_BIT_MASK(32);=0A 	/* Set 63 bit DMA mask for all SAS3 and SA=
S35 controllers */=0A-	else if (ioc->hba_mpi_version_belonged > MPI2_VERSIO=
N)=0A+	} else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {=0A 		ioc-=
>dma_mask =3D 63;=0A-	else=0A+		coherent_dma_mask =3D dma_mask =3D DMA_BIT_=
MASK(63);=0A+	} else {=0A 		ioc->dma_mask =3D 64;=0A+		coherent_dma_mask =
=3D dma_mask =3D DMA_BIT_MASK(64);=0A+	}=0A+=0A+	if (ioc->use_32bit_dma)=0A=
+		coherent_dma_mask =3D DMA_BIT_MASK(32);=0A =0A-	if (dma_set_mask(&pdev->=
dev, DMA_BIT_MASK(ioc->dma_mask)) ||=0A-	    dma_set_coherent_mask(&pdev->d=
ev, DMA_BIT_MASK(ioc->dma_mask)))=0A+	if (dma_set_mask(&pdev->dev, dma_mask=
) ||=0A+	    dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))=0A 		ret=
urn -ENODEV;=0A =0A 	if (ioc->dma_mask > 32) {=0A-- =0A2.39.2=0A=0A=0AFrom =
2de98253a5e5f612b4dd3991eaf12da2f87fd835 Mon Sep 17 00:00:00 2001=0AFrom: S=
reekanth Reddy <sreekanth.reddy@broadcom.com>=0ADate: Tue, 13 Sep 2022 17:3=
5:38 +0530=0ASubject: [PATCH 3/4] scsi: mpt3sas: re-do lost mpt3sas DMA mas=
k fix=0A=0Acommit 1a2dcbdde82e3a5f1db9b2f4c48aa1aeba534fb2 upstream.=0A=0AT=
his is a re-do of commit e0e0747de0ea ("scsi: mpt3sas: Fix return value=0Ac=
heck of dma_get_required_mask()"), which I ended up undoing in a=0Amis-merg=
e in commit 62e6e5940c0c ("Merge tag 'scsi-misc' of=0Agit://git.kernel.org/=
pub/scm/linux/kernel/git/jejb/scsi").=0A=0AThe original commit message was=
=0A=0A  scsi: mpt3sas: Fix return value check of dma_get_required_mask()=0A=
=0A  Fix the incorrect return value check of dma_get_required_mask().  Due =
to=0A  this incorrect check, the driver was always setting the DMA mask to =
63 bit.=0A=0A  Link: https://lore.kernel.org/r/20220913120538.18759-2-sreek=
anth.reddy@broadcom.com=0A  Fixes: ba27c5cf286d ("scsi: mpt3sas: Don't chan=
ge the DMA coherent mask after allocations")=0A  Signed-off-by: Sreekanth R=
eddy <sreekanth.reddy@broadcom.com>=0A  Signed-off-by: Martin K. Petersen <=
martin.petersen@oracle.com>=0A=0Aand this fix was lost when I mis-merged th=
e conflict with commit=0A9df650963bf6 ("scsi: mpt3sas: Don't change DMA mas=
k while reallocating=0Apools").=0A=0AReported-by: Juergen Gross <jgross@sus=
e.com>=0AFixes: 62e6e5940c0c ("Merge tag 'scsi-misc' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/jejb/scsi")=0ALink: https://lore.kernel.org/all/=
CAHk-=3DwjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com=0ASign=
ed-off-by: Linus Torvalds <torvalds@linux-foundation.org>=0ASigned-off-by: =
Salvatore Bonaccorso <carnil@debian.org>=0A---=0A drivers/scsi/mpt3sas/mpt3=
sas_base.c | 2 +-=0A 1 file changed, 1 insertion(+), 1 deletion(-)=0A=0Adif=
f --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sa=
s_base.c=0Aindex faea8001adf5..23bab6f1c0d3 100644=0A--- a/drivers/scsi/mpt=
3sas/mpt3sas_base.c=0A+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c=0A@@ -2825,=
7 +2825,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struc=
t pci_dev *pdev)=0A 	u64 coherent_dma_mask, dma_mask;=0A =0A 	if (ioc->is_m=
cpu_endpoint || sizeof(dma_addr_t) =3D=3D 4 ||=0A-	    dma_get_required_mas=
k(&pdev->dev) <=3D 32) {=0A+	    dma_get_required_mask(&pdev->dev) <=3D DMA=
_BIT_MASK(32)) {=0A 		ioc->dma_mask =3D 32;=0A 		coherent_dma_mask =3D dma_=
mask =3D DMA_BIT_MASK(32);=0A 	/* Set 63 bit DMA mask for all SAS3 and SAS3=
5 controllers */=0A-- =0A2.39.2=0A=0A=0AFrom 7f67a3498048f7e5be3dc5e8b32eeb=
da115d409f Mon Sep 17 00:00:00 2001=0AFrom: Sreekanth Reddy <sreekanth.redd=
y@broadcom.com>=0ADate: Fri, 28 Oct 2022 14:46:55 +0530=0ASubject: [PATCH 4=
/4] scsi: mpt3sas: Remove usage of dma_get_required_mask()=0A API=0A=0Acomm=
it 06e472acf964649a58b7de35fc9cdc3151acb970 upstream.=0A=0ARemove the usage=
 of dma_get_required_mask() API.  Directly set the DMA mask=0Ato 63/64 if t=
he system is a 64bit machine.=0A=0ASigned-off-by: Sreekanth Reddy <sreekant=
h.reddy@broadcom.com>=0ALink: https://lore.kernel.org/r/20221028091655.1774=
1-2-sreekanth.reddy@broadcom.com=0AReviewed-by: Christoph Hellwig <hch@lst.=
de>=0ASigned-off-by: Martin K. Petersen <martin.petersen@oracle.com>=0ASign=
ed-off-by: Salvatore Bonaccorso <carnil@debian.org>=0A---=0A drivers/scsi/m=
pt3sas/mpt3sas_base.c | 3 +--=0A 1 file changed, 1 insertion(+), 2 deletion=
s(-)=0A=0Adiff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/m=
pt3sas/mpt3sas_base.c=0Aindex 23bab6f1c0d3..9085af1eb113 100644=0A--- a/dri=
vers/scsi/mpt3sas/mpt3sas_base.c=0A+++ b/drivers/scsi/mpt3sas/mpt3sas_base.=
c=0A@@ -2824,8 +2824,7 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTE=
R *ioc, struct pci_dev *pdev)=0A 	struct sysinfo s;=0A 	u64 coherent_dma_ma=
sk, dma_mask;=0A =0A-	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) =3D=
=3D 4 ||=0A-	    dma_get_required_mask(&pdev->dev) <=3D DMA_BIT_MASK(32)) {=
=0A+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) =3D=3D 4) {=0A 		ioc->=
dma_mask =3D 32;=0A 		coherent_dma_mask =3D dma_mask =3D DMA_BIT_MASK(32);=
=0A 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */=0A-- =0A2=
=2E39.2=0A=0A
--/+i+J8MBiLX1Dj1b--
