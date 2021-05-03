Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40250371CDB
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhECQ5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:16 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50911 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234702AbhECQyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 12:54:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id B2F67580552;
        Mon,  3 May 2021 12:53:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 03 May 2021 12:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=M
        sqyRimXY3XqCOEklJF7m9X85ugMYqBbaG8HDHYoI44=; b=gBqu4QfUbh04ILRSn
        3yCeS87M1JDw2hIzK4kEHDRC8KtcVA0m1Se9c1mRHCbeIEcUx0xdGatUzInAw3h3
        XCtsqSOZ4CKGyc6VUZMTydPFITS/KjZbCgLCEaqArGhCBAw0KvmnU1V8igGtabV8
        t6x1uWW609qnbxCKcc5maXyJ0s1M5PeAvacRO9UEvydUXLB4kUCHZ4k/RBz4y1fe
        DpxPWVKyyADiERUd5VX1kX2798DdzZlm46KKzSMXxCHidWrUkFssWeYeiwprfyYF
        NXQDuT83IakUhcq/RtoZP7Pr86wZWMpldRljczQS1WyCrfapdcEIE9eBW1GtciHb
        KM/Kw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=MsqyRimXY3XqCOEklJF7m9X85ugMYqBbaG8HDHYoI
        44=; b=aiKqP5zwxStOyvmTf96V84t7QaEoyMP63zFgbFuoRY1u32LQVpoqkCvSJ
        sQb8oU/0JVL05lLi6Szx/0BN83Yen/AgdlQe9LjOFT77ZW4E0YSuVCqruHaVJoVu
        OpMy5YtS7mQLr3heRMa+l+h2GBr5TQ4nkSwOWChEl/vDD+FBdzoqcX2E6BfMmAcm
        OTh8op4cBxCb8bzOsWgo72dLSuR3PAJf731oNexmXzmE4RcQNWqN/64EyQ6UVoA0
        hNvIZTMuv21iWHOSQR5+Wb5OYjoGuPleiDWR5RuxUkIUSgau1siOWoNXxOdld2DO
        nL+nmerySJQ35QYDTCuX4Wl3TD0Og==
X-ME-Sender: <xms:mSqQYFfe53HHBwkwYiatYFvxVo3V4GsxE4SjulTfkGVx14OYv9tSAQ>
    <xme:mSqQYDPxpYMrsDQKz4Bs6Bdjn1YbRfihFR0DLJ0b_xG8JZSUj5LvXat4NUZLgReeC
    hbZIkuhj3l5Zg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvff
    fgueeiuefhheevheetgfehvdefgeekfeevueejfeeftdetudetiefhheffvdenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhho
    rghhrdgtohhm
X-ME-Proxy: <xmx:mSqQYOjcv7B7N5B6pp3hvzCsUJQPv0P79PhhLqbNUQh3J8aXqWw7aA>
    <xmx:mSqQYO_q7LxFV8Ii6XPuPr2Ck0KZ3k1q4yZPrq5zeONoTj1QryI2mw>
    <xmx:mSqQYBuGil4ogjAp1gTbCuz5SdQzLPSt_Asfz_xz3wCQHG3Uwjw48g>
    <xmx:miqQYHKlXgOmY--MMFOxU-8xt2xFkpaaSHwK9_C1T_ouvPtIxxl6ZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon,  3 May 2021 12:53:45 -0400 (EDT)
Date:   Mon, 3 May 2021 18:53:43 +0200
From:   Greg KH <greg@kroah.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     stable@vger.kernel.org,
        Mario =?iso-8859-1?Q?H=FCttel?= <mario.huettel@gmx.net>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        intel-gfx@lists.freedesktop.org
Subject: Re: drm/i915: v5.11 stable backport request
Message-ID: <YJAql6Vstj7wY5Wg@kroah.com>
References: <20210503164001.GE4190280@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210503164001.GE4190280@ideak-desk.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 03, 2021 at 07:40:01PM +0300, Imre Deak wrote:
> Stable team, please backport the upstream commits
> 
> 7962893ecb85 ("drm/i915: Disable runtime power management during shutdown")
> 
> to the v5.11 stable kernel, they fix a system shutdown failure.
> 
> References: https://lore.kernel.org/intel-gfx/042237f49ed1fd719126a3407d7c909e49addbea.camel@gmx.net
> Reported-and-tested-by: Mario Hüttel <mario.huettel@gmx.net>

You also need this in 5.12.y, right?

thanks,

greg k-h
