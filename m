Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241514EE156
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 21:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbiCaTHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 15:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiCaTHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 15:07:39 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49D9221BA9;
        Thu, 31 Mar 2022 12:05:47 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F26F5C0056;
        Thu, 31 Mar 2022 15:05:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 31 Mar 2022 15:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=I9YlzO5I0vEV6J/zDkVkNzj6DhVFaiBXvZQLOA
        8ljxE=; b=SzeuCMiAO0FYiH1pEH+Mw45iOXsYNvqdEfo5va8kF/J4HSEyRGLLMk
        vBgpz0qk3cAMxH4oXqjGMn7bZJUnmqR48zPCvCZvc7/s0RZnBshPMFAs1Mz9AIkT
        SA824B9VZzWyPqrRQvCplC15xAB3jgCAnOYO4rgANK2TMrKQGbZoh2TYqqtkreqo
        0cLdNDyz/RA2xqkBqZWymO3btR7aa2Ldzjz0VftmzkfaRF0qY+luv7TEADl/PGj1
        ASj0MrFgJmzAOBF9CgUDrznRH49zhtfYeHGuwZJDiloR4llAmpFcaspic+fFuunL
        cM0HgpHeH5cfY3dIkNOFWToaczK3halg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=I9YlzO5I0vEV6J/zD
        kVkNzj6DhVFaiBXvZQLOA8ljxE=; b=LpwG/sSOnGfc6s7Whya/7kbn9IH5zMggK
        GJkzU+gkmb6OK8xbVccO7DB/e33Ajn7D1AxlpjQJcifGhpxPJqNQQdIfXLZDvO1U
        Ly4C6E6XdOJhpl+G9AblOa+eJM1OYVku2HxJ5HLE5zFZDWS0DOPCK8hCFjtJATt5
        T1vOrNOXxJ4lErPKdMHryNrn+mMGrOt/1OWxPFmcRN1dOtVbA5gDIy4arzlTm1z+
        F4Y3xRcnRXBgs0h1OPtt+yQWtsQhbgbgiq5bbpO0YfNxAw9aRhJNyQ+vKiRatpRR
        mZZbtXMTs65hJkC2BC1bIhW1Udxlr8VKAiW5O3PQptiK4xL0rqWyg==
X-ME-Sender: <xms:iPtFYjC7vvxFQCN2kqjI6adTzBhabDH3lAkaJwV29JC9_XOWYNwpcw>
    <xme:iPtFYpjvmHF2KbAXWJqKRgpF_xf0wH8WuZw1R9H6gF_iHF2wlXh9KCDg_CjJHD4hP
    FvXumR-9OVKFw>
X-ME-Received: <xmr:iPtFYunr4GykkObCJBe9cFLk4mcyoTrcJfOb-poNfsRNyJd_Ve8BSYsylrslc_2ZqP2laB5sqf6TOXaa7G5eAeYhXU1dy1Da>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeigedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iftFYlw0Zz0EbUSwlLqyY6PjXYbdRBDORD4x-LokpO1c1OSzKECqMg>
    <xmx:iftFYoS3DydlKqKS16d8nBG6bg3bNnyLDt5OduQjUL2HoMT19K14uQ>
    <xmx:iftFYoZXKOet_mbjGz8qPpW2uuZ3tO3kV80CNItqHTbFynY-5jJ9ew>
    <xmx:iftFYnFMESf4WBE7X959pBcyxSCotqVeGuqDnZIYV_jxxc25KM7p_A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 31 Mar 2022 15:05:44 -0400 (EDT)
Date:   Thu, 31 Mar 2022 21:03:52 +0200
From:   Greg KH <greg@kroah.com>
To:     James Morse <james.morse@arm.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com
Subject: Re: [stable:PATCH v4.14.274 00/27] arm64: Mitigate spectre style
 branch history side channels
Message-ID: <YkX7GG5+inB9TkN4@kroah.com>
References: <20220331183400.73183-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331183400.73183-1-james.morse@arm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 07:33:33PM +0100, James Morse wrote:
> Hello!
> 
> This is the spectre-bhb backport for v4.14.
> This comes with an A76 timer workaround. v4.14 doesn't have a compat
> vdso, so doesn't need all the patches for that workaround.
> In particular, it doesn't need Marc's series:
> https://lore.kernel.org/linux-arm-kernel/20200715125614.3240269-1-maz@kernel.org/
> 
> I included the Kconfig change that restricts this to COMPAT, but not commit
> 0f80cad3124f ("arm64: Restrict ARM64_ERRATUM_1188873 mitigation to AArch32"),
> which is an invasive performance optimisation that wasn't marked as
> being for stable.

Thanks for these, all now queued up!

greg k-h
