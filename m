Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB066B1070
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 18:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCHRvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 12:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjCHRvV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 12:51:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A476299BD2;
        Wed,  8 Mar 2023 09:51:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40128618C4;
        Wed,  8 Mar 2023 17:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EF9C433EF;
        Wed,  8 Mar 2023 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678297878;
        bh=UnAOTgAjfoIxFpsJ7TIVK+WkejfMbueOZO3/BCDg6i4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QFm0dvjc+qGrjLeHU3O4LVQQBBKViqdloyN4SL9551DgMpCdy/25bDF+FqFRH+IEj
         0eYG4/8BMgXqJgsS6Y7nFLRFnc6Xzusd5+WM7VhBKsnWFVQemzymwP4MWU/E8Ref42
         w/fQt0JmqyYDewGjz6DQ1ZUe7Iv8jQ0oSPxhEJwbM8UlD+3Mx97XvUUaRmbdLvzqrT
         f2WjP0pvU2if2tDVIxP7HmBCrcb9g2MAgZ+bn3/sln5pyTMIH0JX3vjjQWn6FlgJ2n
         ujXq7xXSzNo8MiYsrVnY9WkegzJfP6RHTG6YL6YzGqPUcfTU0RCFQrJnwJp5WT9HpK
         ln+y3oTexH+Bw==
Received: by pali.im (Postfix)
        id 826516AE; Wed,  8 Mar 2023 18:51:15 +0100 (CET)
Date:   Wed, 8 Mar 2023 18:51:15 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: Patch "mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW"
 has been added to the 5.4-stable tree
Message-ID: <20230308175115.6y3jitdkzqcnqqev@pali>
References: <20230305035038.1777370-1-sashal@kernel.org>
 <20230308170943.13b6ee5e@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230308170943.13b6ee5e@xps-13>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 08 March 2023 17:09:43 Miquel Raynal wrote:
> Hi Sasha,
> 
> sashal@kernel.org wrote on Sat,  4 Mar 2023 22:50:38 -0500:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW
> > 
> > to the 5.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      mtd-rawnand-fsl_elbc-propagate-hw-ecc-settings-to-hw.patch
> > and it can be found in the queue-5.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> +Marek
> 
> As reported by kernel test robot, this commit does not apply on 5.4
> because many changes have happened in the core since the introduction
> of the fixed patch. In practice the driver works in most cases,
> but does not in few rare cases (IIUC) so I would be in favor of just
> dropping this commit from the queue/5.4 branch. If someone feels like
> this commit should be backported there, please send an updated fix.
> 
> Link: https://lore.kernel.org/oe-kbuild-all/202303060514.1ziBICF7-lkp@intel.com/
> 
> Thanks,
> Miquèl
> 
> > 
> > 
> > 
> > commit 839c09472742b383f65eb7c1f7e576ebfb6a1f62
> > Author: Pali Rohár <pali@kernel.org>
> > Date:   Sat Jan 28 14:41:11 2023 +0100
> > 
> >     mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW
> >     
> >     [ Upstream commit b56265257d38af5abf43bd5461ca166b401c35a5 ]
> >     
> >     It is possible that current chip->ecc.engine_type value does not match to
> >     configured HW value (if HW ECC checking and generating is enabled or not).
> >     
> >     This can happen with old U-Boot bootloader version which either does not
> >     initialize NAND (and let it in some default unusable state) or initialize
> >     NAND with different parameters than what is specified in kernel DTS file.
> >     
> >     So if kernel chose to use some chip->ecc.engine_type settings (e.g. from
> >     DTS file) then do not depend on bootloader HW configuration and configures
> >     HW ECC settings according to chip->ecc.engine_type value.
> >     
> >     BR_DECC must be set to BR_DECC_CHK_GEN when HW is doing ECC (both
> >     generating and checking), or to BR_DECC_OFF when HW is not doing ECC.
> >     
> >     This change fixes usage of SW ECC support in case bootloader explicitly
> >     enabled HW ECC support and kernel DTS file has specified to use SW ECC.
> >     (Of course this works only in case when NAND is not a boot device and both
> >     bootloader and kernel are loaded from different location, e.g. FLASH NOR.)
> >     
> >     Fixes: f6424c22aa36 ("mtd: rawnand: fsl_elbc: Make SW ECC work")
> >     Signed-off-by: Pali Rohár <pali@kernel.org>
> >     Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> >     Link: https://lore.kernel.org/linux-mtd/20230128134111.32559-1-pali@kernel.org
> >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > diff --git a/drivers/mtd/nand/raw/fsl_elbc_nand.c b/drivers/mtd/nand/raw/fsl_elbc_nand.c
> > index 634c550db13a7..e900c0eddc21d 100644
> > --- a/drivers/mtd/nand/raw/fsl_elbc_nand.c
> > +++ b/drivers/mtd/nand/raw/fsl_elbc_nand.c
> > @@ -727,6 +727,7 @@ static int fsl_elbc_attach_chip(struct nand_chip *chip)
> >  	struct fsl_lbc_ctrl *ctrl = priv->ctrl;
> >  	struct fsl_lbc_regs __iomem *lbc = ctrl->regs;
> >  	unsigned int al;
> > +	u32 br;
> >  
> >  	switch (chip->ecc.mode) {
> >  	/*
> > @@ -762,6 +763,13 @@ static int fsl_elbc_attach_chip(struct nand_chip *chip)
> >  		return -EINVAL;
> >  	}
> >  
> > +	/* enable/disable HW ECC checking and generating based on if HW ECC was chosen */
> > +	br = in_be32(&lbc->bank[priv->bank].br) & ~BR_DECC;
> > +	if (chip->ecc.engine_type == NAND_ECC_ENGINE_TYPE_ON_HOST)
> > +		out_be32(&lbc->bank[priv->bank].br, br | BR_DECC_CHK_GEN);
> > +	else
> > +		out_be32(&lbc->bank[priv->bank].br, br | BR_DECC_OFF);
> > +
> >  	/* calculate FMR Address Length field */
> >  	al = 0;
> >  	if (chip->pagemask & 0xffff0000)
> 

This commit depends on another commit "mtd: rawnand: fsl_elbc: Fix none ECC mode":
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=049e43b9fd8fd2966940485da163d67e96ee3fea

So if dependency commit is not backported then this commit
"mtd: rawnand: fsl_elbc: Propagate HW ECC settings to HW" cannot be
backported too.
