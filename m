Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3481C6E68B3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 17:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbjDRPxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 11:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjDRPxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 11:53:16 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D5513F89
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 08:52:52 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 68B9D5C00B2;
        Tue, 18 Apr 2023 11:52:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 18 Apr 2023 11:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1681833159; x=1681919559; bh=KF
        2ERwP7Tm82pKzDySVRVtX4bVxGmo8SnshzoJpupWE=; b=pSPcsI4kExXMY/c7yg
        FjRbUtOcNALsNXJSPi79KyRbw0gqDNO9yLWeWUubH1O4gNgHrxY4HzX4OBiu7Zw0
        O6rxbhREqFNoe63wVmpqMl0qJH9WM6MCq502fS/5KcYdGlqgT3lgDWuafPiuw4W2
        4KL/sjmDqO9/Ns4Pkvy5Sdj9z1O44X6c8T/J8FJz4mwD5uBBNX6BYnPzhNabS3lD
        KIwWNWqQpWu3bztoRQpNyLAA/osi4gntrhLuo1CdCVLrPoI04lfVUD9WdtnEoicR
        W3+p500RLUsdIL1WrLpzOrcicj6mzL/VKf+spQfYydSM0WKzYV4MyZtYh004xU+l
        WnXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1681833159; x=1681919559; bh=KF2ERwP7Tm82p
        KzDySVRVtX4bVxGmo8SnshzoJpupWE=; b=iLbB8GaoSnRB6EQ8KortwFDS+rdEy
        ZbKqElQryGaEAV+pRx4jvRG5wt6w1zpHJ5nWXtNXE8V331QuWWiek48jLoKeQlx0
        acamGa/Zvh4VsV1Q/dBZtxWFTjnKla3OXquGShAxylnT6s95KYvWvfZFojYDa+Ti
        3n0q2cVsekVlpmI4vOXRadpKjXM9qGPsC1/zM+slswBb9mZVI7/lEnW3hKbveVvf
        zcutzpZ3wLVgGOlmxx64dMh1xddZUfaw0Yzm78Hd4dFVZWUnHQFpmvAh8Hy3w+Vr
        bBcvFMdwG/q4/8xaITBENTyOR60WcTWT3G5q6YxWf79QnzPSKw+Ng7Vdw==
X-ME-Sender: <xms:x7w-ZC8A3aWV5D2oTZ4JZl6KNyNXOf0MBrOw5ljZ8lM2uR0LUfWt7A>
    <xme:x7w-ZCtqjWKPwLgSLagi16FGle0hPIhY_GjmLFwca_nsMm6JRdr3PtGAs3bRjui83
    _bTqzDO3B4_HXkeyw>
X-ME-Received: <xmr:x7w-ZIAunSTU2CZy_s3yoXDlUb021YiPtx8KdD5KrN0JByRt39IUhvAe3rlROYhCwvBj9c9heXtcmHNnLO0Crak3cYzXwQS3IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdelkedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtvdenucfhrhhomheptehlhihs
    shgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepvd
    egieefffekjefhvdfhtdffleetheejleeuhefhvdduieeuueegueejgfdttedvnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihsh
    hsrgdrihhs
X-ME-Proxy: <xmx:x7w-ZKc4l_GoG6-ZvzqiuqCxILPAu03MEYhynIQWydqs9vot_vbd0g>
    <xmx:x7w-ZHPtgAKHsHByPf9LVUMma9qhcpLOyU8sJPtj62TMDpO8YvGREg>
    <xmx:x7w-ZEkIJQdetq4hc1PHCjVOHWv3xgSTHPaT2xOjOc2oUu6UAomK1Q>
    <xmx:x7w-ZC35GALpDBG3Mceh-1YTdw90JVU5rM5Qi8Sz8mVWoNfOzk-rnw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Apr 2023 11:52:38 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 7D089323F; Tue, 18 Apr 2023 15:52:37 +0000 (UTC)
Date:   Tue, 18 Apr 2023 15:52:37 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 127/134] purgatory: fix disabling debug info
Message-ID: <20230418155237.2ubcusqc52nufmow@x220>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.600787422@linuxfoundation.org>
 <20230418-wrist-glory-14a2aa00b2cb@wendy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mmswatlmbk4gxn5w"
Content-Disposition: inline
In-Reply-To: <20230418-wrist-glory-14a2aa00b2cb@wendy>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mmswatlmbk4gxn5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 18, 2023 at 02:38:38PM +0100, Conor Dooley wrote:
> Hey folks,
>
> On Tue, Apr 18, 2023 at 02:23:03PM +0200, Greg Kroah-Hartman wrote:
> > From: Alyssa Ross <hi@alyssa.is>
> >
> > [ Upstream commit d83806c4c0cccc0d6d3c3581a11983a9c186a138 ]
> >
> > Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> > Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> > -Wa versions of both of those if building with Clang and GNU as.  As a
> > result, debug info was being generated for the purgatory objects, even
> > though the intention was that it not be.
> >
> > Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > Cc: stable@vger.kernel.org
> > Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/riscv/purgatory/Makefile | 7 +------
> >  arch/x86/purgatory/Makefile   | 3 +--
> >  2 files changed, 2 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
> > index d16bf715a586b..5730797a6b402 100644
> > --- a/arch/riscv/purgatory/Makefile
> > +++ b/arch/riscv/purgatory/Makefile
> > @@ -84,12 +84,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
> >  CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
> >  CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
> >
> > -AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
> > -AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
> > -AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
>
> > -AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
> > -AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
> > -AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
>
> How about just deleting these 3 lines, rather than pulling back commit
> 56e0790c7f9e ("RISC-V: add infrastructure to allow different str*
> implementations") <20230418120317.572094889@linuxfoundation.org>
> as that is just going to be a bunch of dead code?

Hmm, in the port to 6.1 I submitted <20230417153147.1915266-1-hi@alyssa.is>,
I did just drop those lines.  Did I get it wrong somehow to have it not
picked up?

--mmswatlmbk4gxn5w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmQ+vMMACgkQ+dvtSFmy
ccBRfw/9EPRV8eRiJw/xb8WfuICq1jW504XXyTG9ZruorMV5Cw0UuZYBwOUYNXoC
GKoh3waMgpqNXYV0oJSlEQRC+MWaxPPuv0b/mf+SjFhpO0/MjFahlj5x895yNcon
8WsctUln+67/8TjDNnLtPNIb5drZNDaPqJjA5MsQQxnJI2aOf+vmo6Zf85pGWVpm
U+jc2bk5QYX+B0gC9zErGLurURyzLku87B3E+SGXcrO/Tkb+nVLud1axYwFtjVde
SAawlIRvoVEIU5I7HnDT5ADgQUPl8KAHVySHqP3c4jrHc5+1sFmoBUMbD4BoDDcK
b4KxNMiU23WGcUhoL/MbPMYl7DBRuQ2C5Pf7vSmq2dCKE/O8rGCyRJAdqqPVhkBd
Yp1TnP8UplxKeFCmoBdL0yD5fYTZjrcU49jWQVDir87MrgJaPTNFvsz4PDGo07aj
cyeIydHGvb2RmSkvQ30LzkYaRRsFJWGsiz6wK8UZng/0iL8NleLBZ/SyLVILxuir
OzmPFDRZoUaaq8/nGZawlPuVP7rk2c/8rzDWYqP66590LzUK7QbeT+A3Rjv0FJta
tN93GOBO9wX/grYD359VbHq6S9yl8HBjtPcOKsC31FcaOZaBSjaE2m0SQRb5f3Nb
/TkF9AWj8sv07Uc3GLz3uu9QQxsXv1JryEUhixlVcb6l9o4hxu0=
=QIu3
-----END PGP SIGNATURE-----

--mmswatlmbk4gxn5w--
