Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2855BA97E
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 11:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiIPJfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 05:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIPJfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 05:35:45 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14377C1D7
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 02:35:44 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 75E925C0247;
        Fri, 16 Sep 2022 05:35:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 16 Sep 2022 05:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1663320941; x=1663407341; bh=eIA78Vn0TI
        PSZ6qqVPlztU7LPMRoZ5pntH6TgjQ+JIY=; b=gzNDR4hTlFTASdP2ImFBzKqxEM
        OYAcEsCBU+qaqwMD8HZlzTGos+DuA4sQ7slbfccjyuMAn2UzEmHryyJ+Xb6qOvyB
        8yVzRXlCmQXDr1iaDGIxSVlkntIZ5NzGpRpgr3RbcdSQSNblQpdbluVUvAyyNhAG
        75tn+v7QotsbKkW5jplkjl0tUbhheHsZMVRpwDRVJYQIPw4OIwV9h0EjchQIyYqF
        vKAQ5LRb2lP7bVg9Rrx+YicZXp4yc3GI71rtSqIaqlgomHEmWVP5lFRzOw0DKYAf
        85/oqMK1pHdtCbI+qPVMvVqpN+GO7aE7u49Erm4DIB+cK9KOGH6+TT4iQWSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663320941; x=1663407341; bh=eIA78Vn0TIPSZ6qqVPlztU7LPMRo
        Z5pntH6TgjQ+JIY=; b=mUA6lO45dEpG/a/ZzHkr0b1gtDe4oVLfXOhFH71fwU1r
        WowuQXWvILz3hkou5cQcKUBBT6yUGamkpBfuABcEbnKX2McdCnEK+YVK/s9Owcai
        QFPnvJg4j2o59N4ZqLsd/J37Xxr2oRf4x318lENqRkQ0gGx7vH856xxfxPqjARUn
        TF6YivOybaMtj7mIkohH6qOOCR17xAz2Rr6zTYFTjtPixbtcTrnBzDsA96tWrwhB
        rzY2sCUSQN/cZcAGINXSwCAg91quYxSdm3WPDpclWZdqbTdbHo5kV1YK1a1GCClm
        Tfi3BHVRbSBcYej4WrdBmspCOV3Q+40Jl5GmdgNleg==
X-ME-Sender: <xms:bUMkY82-RgC8E9QLM2I2YOA0aGqq2SjrMcYoR2ZQuu-ARWKfw75Cxw>
    <xme:bUMkY3GHfaDSKshSP12f0XwAIVE0FObNkWn1YHnUnTU6l24gUZfXicqY1touP8WCv
    QtxxdcXckltNA>
X-ME-Received: <xmr:bUMkY06Jru7nQRYQyDeqkRZVGLECXr8jl-OALQmCiojWHIxQ9dIpVx1RL9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvtddgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bUMkY132d-yeoPGLvvW-thjIHW9fMB7fl-PQQQoldeXkJkYoyTRjeg>
    <xmx:bUMkY_E3a3Zh8mqLddCvwBdV1Wd64po6DTfMS44ysKyOSFEinQgoIQ>
    <xmx:bUMkY-_z-9CRHfpI4t0iPJrkrwm2ULbmeN5ojbGt0Top79fFPgCgaw>
    <xmx:bUMkY05xxZ81RuGDm8uhb_FC9oJDZG_J9qA4sfhbJlH1I5jm0-zdyg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Sep 2022 05:35:40 -0400 (EDT)
Date:   Fri, 16 Sep 2022 11:36:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Mathew McBride <matt@traverse.com.au>
Cc:     stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.15] soc: fsl: select FSL_GUTS driver for DPIO
Message-ID: <YyRDhw3vcAsVonHb@kroah.com>
References: <20220914061957.11886-1-matt@traverse.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914061957.11886-1-matt@traverse.com.au>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 06:19:57AM +0000, Mathew McBride wrote:
> commit 9a472613f5bccf1b36837423495ae592a9c5182f upstream
> 
> The soc/fsl/dpio driver will perform a soc_device_match()
> to determine the optimal cache settings for a given CPU core.
> 
> If FSL_GUTS is not enabled, this search will fail and
> the driver will not configure cache stashing for the given
> DPIO, and a string of "unknown SoC" messages will appear:
> 
> fsl_mc_dpio dpio.7: unknown SoC version
> fsl_mc_dpio dpio.6: unknown SoC version
> fsl_mc_dpio dpio.5: unknown SoC version
> 
> Fixes: 51da14e96e9b ("soc: fsl: dpio: configure cache stashing destination")
> Signed-off-by: Mathew McBride <matt@traverse.com.au>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220901052149.23873-2-matt@traverse.com.au
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/soc/fsl/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Now queued up, thanks.

greg k-h
