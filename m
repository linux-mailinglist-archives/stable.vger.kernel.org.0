Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29DA68D532
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 12:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjBGLK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 06:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjBGLK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 06:10:57 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E68D366AC;
        Tue,  7 Feb 2023 03:10:55 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 87B9C5C0096;
        Tue,  7 Feb 2023 06:10:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 07 Feb 2023 06:10:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1675768253; x=1675854653; bh=Fs0iHWeNOc
        RqahxLvKQvRWTC6Io+cKtIudvuN67M2R4=; b=QBXXZ7jbKpdMuCFaIolHIXrOnp
        oRgVmnfiRIoIGZD3J3suzCuOYxOcyh12RMCHTNb65DOzFjGRv4uOYFMHyzfcjqBW
        v9aL/LFGyvzXYKcEngZn5R565AaB5hXtOkiTn7xZDpD2AoHK15uzHVevHWEBnWTV
        IZ16XHKCmtxrtzBk55yGOoPyV0tl1LeivAX8pkoKsfGOkOx1RrTR1ZpN09hGHQ98
        4ZXgM1I9yLzTgbXejhVAOg1cyXcJMAcxC1WbeW/fYCQIn1HCILKnKrThUB69EVc4
        vnI7QxKmTgcx4dq+ts5SMH6gdM1vZEHf4WFxUn0UdXEhZclCywN/B7Q8J5fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675768253; x=1675854653; bh=Fs0iHWeNOcRqahxLvKQvRWTC6Io+
        cKtIudvuN67M2R4=; b=YGjsuPGQomMsxlhGRrwEHTnEyWNn+kuIueFVVrdR9GsL
        QuWszjr+XyONhl//R8867a3+idNxpEjz9n30ROQXyVLzUaRjRuoFJFJBqUhG0RMs
        tVt1zobHKIq++kA86tzumIkk6LGwZ5qXk45cAuNAQTZr2YdPw/UYfL6fJJRP87rS
        87S0TcmBLmB2u4esKiqO6POw2GzxryS+/VgVl3OmTWR7AuhkCWauMSfrD10FgDJJ
        Kq6Jp/cFFsgQ/C50T2horWZr4isafy8+pJNNDDgUwHZfhGluYAn4O9WRURFq5znR
        yQhSVJyNDe/QB9eFZY+Fyh7WkySieT11DiNJ/Y32gw==
X-ME-Sender: <xms:vTHiY-ct7C2r1fMDfDikqbKOMTmeZCHH55nzSOBtiwjwpili154ceg>
    <xme:vTHiY4Mxt6mBj19eAWZhvPImjYWIb1K-sQMph2LqyXx6xnRMAdQWdsNoTV66TeS4x
    q6caMgOaIzAUg>
X-ME-Received: <xmr:vTHiY_geoA9Nh53dVEA3C9reAS93aYFVKJ30j9LL7AksQ_3AFFnRnSOAV095WdRmA0jWo_VYHPqPz60qXgkrjFiOjiU4hoLk6ampig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegkedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepteekie
    efleefvdevgeeiieetlefffeduueehhfegudegkedvieehtedttdehjeefnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghdptghhrhhomhgvohhsrdguvghvnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgt
    ohhm
X-ME-Proxy: <xmx:vTHiY79rg2SQ_WEDGfEHpafyKcZ5z8Qg3TZqwkH30G5lwHDXe_ackw>
    <xmx:vTHiY6s-GhF_R7-Ruql0AqPCxquLlkflDLIeHpMYmwYwoqKtHS6fiw>
    <xmx:vTHiYyHtBG2xf1vtJavqDzsiv2YZYoSdAhCnfNrEw3y-xNH4Aff_Mg>
    <xmx:vTHiY7H5Xox7iuu4Ii48g97jtMrqPI1_lFp-K7CPNNNbFaDB-ztN0Q>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Feb 2023 06:10:52 -0500 (EST)
Date:   Tue, 7 Feb 2023 12:10:41 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.15.y v3 0/5] phy: qcom-qmp-combo: Backport some stable
 fixes
Message-ID: <Y+IxsTJINcSCYSPl@kroah.com>
References: <20230203222616.2935268-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203222616.2935268-1-swboyd@chromium.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 02:26:11PM -0800, Stephen Boyd wrote:
> After the qmp phy driver was split it looks like 5.15.y stable kernels
> aren't getting fixes like commit 7a7d86d14d07 ("phy: qcom-qmp-combo: fix
> broken power on") which is tagged for stable 5.10. Trogdor boards use
> the qmp phy on 5.15.y kernels, so I backported the fixes I could find
> that looked like we may possibly trip over at some point.
> 
> USB and DP work on my Trogdor.Lazor board with this set.
> 
> Changes from v2 (https://lore.kernel.org/r/20230113204548.578798-1-swboyd@chromium.org):
>  * Keep conditional that can't be removed from last patch
>  * Rebase to latest 5.15.y stable tree
> 
> Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
>  * New patch for memleak on probe deferal to avoid compat issues
>  * Update "fix broken power on" patch for pcie/ufs phy
> 
> Johan Hovold (5):
>   phy: qcom-qmp-combo: disable runtime PM on unbind
>   phy: qcom-qmp-combo: fix memleak on probe deferral
>   phy: qcom-qmp-usb: fix memleak on probe deferral
>   phy: qcom-qmp-combo: fix broken power on
>   phy: qcom-qmp-combo: fix runtime suspend
> 
>  drivers/phy/qualcomm/phy-qcom-qmp.c | 89 ++++++++++++++++++++---------
>  1 file changed, 61 insertions(+), 28 deletions(-)
> 
> Cc: Johan Hovold <johan+linaro@kernel.org>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> 
> base-commit: 9cf4111cdf9420fa99792ae16c8de23242bb2e0b
> -- 
> https://chromeos.dev
> 

All now queued up, thanks.

greg k-h
