Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F926B0E3D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjCHQKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjCHQKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:10:15 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1556D87360;
        Wed,  8 Mar 2023 08:09:46 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0C66820008;
        Wed,  8 Mar 2023 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678291785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zpTLB8XHi0AtrWUZ58ZmZi24Zue7n9YuQOFOVfBwfP4=;
        b=e335GaXqZ+WXb47i01TuLaXKA8Od66iG5sVvdiT49ZMd60zyxGHmBAAmvNj9Tl+1GiQdVm
        aAn1o9fLrWLHPmxcvvKWGaTLmEy3kLqy64vuXXV3isG9DEq4bJUpFcfzH51YAXJYjvHCUR
        /euKDtxjPGckSPVEHk0GMdOTesOmb1kEzowT4l9k038NGEJb1F/RGlg9RRD7EZBEV6P6Sc
        dRrzUIkQHMOr/HvFB1L1VB6vDD9vL1OsRsl9s3d6M0anPLaQLlwrfir1sPAEV+Re+9z1Uz
        zXB0g/sYFWyGAz2F9Y7FpR1ocyKxcNv8a1qr2o6w01wHnMLEA6lquQG8+osZsQ==
Date:   Wed, 8 Mar 2023 17:09:43 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, pali@kernel.org,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: Patch "mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW"
 has been added to the 5.4-stable tree
Message-ID: <20230308170943.13b6ee5e@xps-13>
In-Reply-To: <20230305035038.1777370-1-sashal@kernel.org>
References: <20230305035038.1777370-1-sashal@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

sashal@kernel.org wrote on Sat,  4 Mar 2023 22:50:38 -0500:

> This is a note to let you know that I've just added the patch titled
>=20
>     mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW
>=20
> to the 5.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
> The filename of the patch is:
>      mtd-rawnand-fsl_elbc-propagate-hw-ecc-settings-to-hw.patch
> and it can be found in the queue-5.4 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

+Marek

As reported by kernel test robot, this commit does not apply on 5.4
because many changes have happened in the core since the introduction
of the fixed patch. In practice the driver works in most cases,
but does not in few rare cases (IIUC) so I would be in favor of just
dropping this commit from the queue/5.4 branch. If someone feels like
this commit should be backported there, please send an updated fix.

Link: https://lore.kernel.org/oe-kbuild-all/202303060514.1ziBICF7-lkp@intel=
.com/

Thanks,
Miqu=C3=A8l

>=20
>=20
>=20
> commit 839c09472742b383f65eb7c1f7e576ebfb6a1f62
> Author: Pali Roh=C3=A1r <pali@kernel.org>
> Date:   Sat Jan 28 14:41:11 2023 +0100
>=20
>     mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW
>    =20
>     [ Upstream commit b56265257d38af5abf43bd5461ca166b401c35a5 ]
>    =20
>     It is possible that current chip->ecc.engine_type value does not matc=
h to
>     configured HW value (if HW ECC checking and generating is enabled or =
not).
>    =20
>     This can happen with old U-Boot bootloader version which either does =
not
>     initialize NAND (and let it in some default unusable state) or initia=
lize
>     NAND with different parameters than what is specified in kernel DTS f=
ile.
>    =20
>     So if kernel chose to use some chip->ecc.engine_type settings (e.g. f=
rom
>     DTS file) then do not depend on bootloader HW configuration and confi=
gures
>     HW ECC settings according to chip->ecc.engine_type value.
>    =20
>     BR_DECC must be set to BR_DECC_CHK_GEN when HW is doing ECC (both
>     generating and checking), or to BR_DECC_OFF when HW is not doing ECC.
>    =20
>     This change fixes usage of SW ECC support in case bootloader explicit=
ly
>     enabled HW ECC support and kernel DTS file has specified to use SW EC=
C.
>     (Of course this works only in case when NAND is not a boot device and=
 both
>     bootloader and kernel are loaded from different location, e.g. FLASH =
NOR.)
>    =20
>     Fixes: f6424c22aa36 ("mtd: rawnand: fsl_elbc: Make SW ECC work")
>     Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
>     Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>     Link: https://lore.kernel.org/linux-mtd/20230128134111.32559-1-pali@k=
ernel.org
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/drivers/mtd/nand/raw/fsl_elbc_nand.c b/drivers/mtd/nand/raw/=
fsl_elbc_nand.c
> index 634c550db13a7..e900c0eddc21d 100644
> --- a/drivers/mtd/nand/raw/fsl_elbc_nand.c
> +++ b/drivers/mtd/nand/raw/fsl_elbc_nand.c
> @@ -727,6 +727,7 @@ static int fsl_elbc_attach_chip(struct nand_chip *chi=
p)
>  	struct fsl_lbc_ctrl *ctrl =3D priv->ctrl;
>  	struct fsl_lbc_regs __iomem *lbc =3D ctrl->regs;
>  	unsigned int al;
> +	u32 br;
> =20
>  	switch (chip->ecc.mode) {
>  	/*
> @@ -762,6 +763,13 @@ static int fsl_elbc_attach_chip(struct nand_chip *ch=
ip)
>  		return -EINVAL;
>  	}
> =20
> +	/* enable/disable HW ECC checking and generating based on if HW ECC was=
 chosen */
> +	br =3D in_be32(&lbc->bank[priv->bank].br) & ~BR_DECC;
> +	if (chip->ecc.engine_type =3D=3D NAND_ECC_ENGINE_TYPE_ON_HOST)
> +		out_be32(&lbc->bank[priv->bank].br, br | BR_DECC_CHK_GEN);
> +	else
> +		out_be32(&lbc->bank[priv->bank].br, br | BR_DECC_OFF);
> +
>  	/* calculate FMR Address Length field */
>  	al =3D 0;
>  	if (chip->pagemask & 0xffff0000)

