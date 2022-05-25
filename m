Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E40533E32
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbiEYNss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 09:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiEYNsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 09:48:47 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B552C67B
        for <stable@vger.kernel.org>; Wed, 25 May 2022 06:48:45 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7E89D5C021B;
        Wed, 25 May 2022 09:48:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 25 May 2022 09:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1653486523; x=1653572923; bh=bH5KXtGdsx
        pAEAGgyI9RejtyaNnshQ2tnEUSxdWyuVM=; b=nLYHK5Ud5teUwFetlU6eHeYHZw
        nYHfMPdYAHc0S/tN5vu2tneoTwfnCzgALN3RiLBGaK8gll/QaN+XEPiGCpkqF6F7
        jwE2Po5S9xpQ3LyVeqlDfLOC+78FY6wVgB4LfrZOUX5TtuXPeLZ0zN+Z9u57grl5
        MW0M3eVdiE8Ef+JKgPTMfNVwrFcXhMu0uARI07c5vlpWfnXEJU79KKjT3y8/DLVZ
        2MMInKgj9dp6bbxHtlFarc3wkeAAVEJN7zT6qsOJTnLb+RQ7dv/GsoeWQ7yH19/K
        gVJxaX+trygWvFJUalGKjBDA8dPMpHnEP3ucg/OrnSGZvGR3nvqrYHxuuk2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653486523; x=1653572923; bh=bH5KXtGdsxpAEAGgyI9RejtyaNns
        hQ2tnEUSxdWyuVM=; b=cGMa0Pm/fS7lJmGJJY1VfBFFj3lLa0iDUkgIuQR0wSYB
        fE9SU/8XSKaNHP9n62dAt61zzpPDE8Pde9finpp8FFG6TtOzLcIMUTRgwOeM8R5L
        LdCIW5V1D0xesPzGaj/gFj+3MUedexU965iCkoEm43Eb1fJ/JDddzlgbfqAcZ2dS
        p6AvFCTKmI+CPQt4wU7IW5TsabHCiu7LG0yXZS1VNVQqCVSTotb8Gff56k2I6YrT
        mmaqYg+FJ8uZRPZiBFGENeeRPXQMF+Z34L8g1+NbQnI+bcmODlqe0qBFnmqTYr7o
        hstwO/vfCPteJMrCGpxkNSohPvNaYibmIJuNkhYvtA==
X-ME-Sender: <xms:uzOOYgIeDy9dyquLTx0KGwCPcBWHRGr2v_Xwurd9wMnRLnSvJ1zCSw>
    <xme:uzOOYgKvM0w3Jyng8RAZkqXu10gk64dQCPNGHMmZYhySx-FTAN57IDZA5Vtu461ry
    IERh2gA8-f37A>
X-ME-Received: <xmr:uzOOYguoderBMpv629qg-u59KkQWYFlaUu7s7ZpJRN5aHLooGZ9ZGt9Grg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeehgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:uzOOYtbaGUKOa93KRsbSDI5CbyRmbxQqsDcJKzK1WoslhHOD4Gx7dw>
    <xmx:uzOOYnY1Ku3BRcgwLnCQmOdnfEw_dGV9ksixH7qUYbVhISjrjC6gdw>
    <xmx:uzOOYpBjrwQbiOrUwrcLOLZcqB5mHKCOdw0zPnbDi_EY_t1QcGlZlg>
    <xmx:uzOOYmk7foqGOGc8BTNfwuG-mlLoKXVcpUEgXOfDljLOHQU7e12G2A>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 May 2022 09:48:42 -0400 (EDT)
Date:   Wed, 25 May 2022 15:48:41 +0200
From:   Greg KH <greg@kroah.com>
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.10] lockdown: also lock down previous kgdb use
Message-ID: <Yo4zuaTypRCMInfV@kroah.com>
References: <20220525124918.114232-1-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525124918.114232-1-daniel.thompson@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 25, 2022 at 01:49:18PM +0100, Daniel Thompson wrote:
> commit eadb2f47a3ced5c64b23b90fd2a3463f63726066 upstream.
> 
> KGDB and KDB allow read and write access to kernel memory, and thus
> should be restricted during lockdown.  An attacker with access to a
> serial port (for example, via a hypervisor console, which some cloud
> vendors provide over the network) could trigger the debugger so it is
> important that the debugger respect the lockdown mode when/if it is
> triggered.
> 
> Fix this by integrating lockdown into kdb's existing permissions
> mechanism.  Unfortunately kgdb does not have any permissions mechanism
> (although it certainly could be added later) so, for now, kgdb is simply
> and brutally disabled by immediately exiting the gdb stub without taking
> any action.
> 
> For lockdowns established early in the boot (e.g. the normal case) then
> this should be fine but on systems where kgdb has set breakpoints before
> the lockdown is enacted than "bad things" will happen.
> 
> CVE: CVE-2022-21499
> Co-developed-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> 
> Notes:
>     Original patch did not backport cleanly. This backport is fixed up,
>     compile tested (on arm64) and side-by-side compared against the
>     original.

Now queued up, thanks.

greg k-h
