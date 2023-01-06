Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C406660A6B
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 00:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjAFXxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 18:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjAFXxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 18:53:19 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE46C72D22;
        Fri,  6 Jan 2023 15:53:18 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B09D85C0071;
        Fri,  6 Jan 2023 18:53:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 06 Jan 2023 18:53:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tyhicks.com; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1673049194; x=1673135594; bh=7G4/beSUaF
        qqw1nEdaUkVcwlLhwLsSrWTndJbny1Uek=; b=hGJkAkQ5KCG0r0+DxIojSkT5BC
        IBN6kbZKQq7pLRwfGGaNKDfW+LGae89wtH1h2F8OPrqSZ7MWp1xANmLhMrq/7CqJ
        UNqfC8L2Dlzzoxk/fnYY8jVpJ+N+iQEIPkNYfO9/Kpth32Hfx3FfSlbZABAW3bL0
        e8oXoaSlZ0m8HF7C9agSc3jtdXjob4z63GM6FftCC2GZmPeLWefHKApzyc8XXbe1
        tmDr9pdDjkNQlu9xMya+nqSPue+SBmEGqmpCbDAbEbeRMGRUDezeYx/rB3dGCe7d
        CGYSC5I2zJfTUJaR4eYiizl3dvCBHKDNb8llrGznk30FAS0UfV0ckudA/XbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1673049194; x=1673135594; bh=7G4/beSUaFqqw1nEdaUkVcwlLhwL
        sSrWTndJbny1Uek=; b=mBm7DiKmDzFj3ZH0irV4Ph9MbVV6esIQVuP890YNs3Ms
        2J3Q9JMWOXIu2joi/yhJVzqCuH7q+kP2TOYHGSGRN0xJYhdAYcWmRnHqRbr0h3ii
        sIHPmp2KZoQVBcUUgUoI2ppwseRIKl6NOC1odHgJPaUOhE+ZZKBy2VhVff63nT8w
        ydtyxhgUHKR71tOO6medUr3Neq/JyZRIWsCX4TVnto4uuXA8xfnyjTVKXr2PVyou
        zTFbQdhDXelcxMqZbNLEkDWFWfwEo0deTwQi/Qf26grzK9x638wwn+hN6WOmhLpN
        4uyqXwZ0wWEYQ8pMnbzBfn548+EwqttdaRTrhflX5w==
X-ME-Sender: <xms:arS4Y3NrU9dkMAyPmyqkpUiyuXBI3RJ-_9macWGeKOZJAfScgmu2HA>
    <xme:arS4Yx8uCLH0kJRxSzsggWaaI8aDgylq-XDQbiVXlg_rWF-MQ5ohRPMvYNWJKbpoL
    WjxdvX_5vZAAKatE2I>
X-ME-Received: <xmr:arS4Y2TV3xcJX-7-o7eZXgEyTzdYP9y0elAnRlnIoyJe_TpBOT2o2UeFubk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrkedugdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefvhihlvghr
    ucfjihgtkhhsuceotghouggvsehthihhihgtkhhsrdgtohhmqeenucggtffrrghtthgvrh
    hnpeetveeffeehgefgieffudeulefgffegudehjeejueffvefhkedvhfelvdevffelhfen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhlvggvmhhhuhhishdrihhnfhhonecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghouggvseht
    hihhihgtkhhsrdgtohhm
X-ME-Proxy: <xmx:arS4Y7sfGfnq-b-6O7kkX09GUiLNVAndrlxOAX9EVU9G3zabJMCCxg>
    <xmx:arS4Y_dI3EhpUn-ByDqSEXM172wzx4vwNfXKXAsJymALFcQa2NIyuQ>
    <xmx:arS4Y32X8-XxdSMA65eCzow_upFALDYXBItRTvHgbwjk-6mkspwBSQ>
    <xmx:arS4Y631rLcbSN7M8lgby6MZ8r6zt4hEsd9Qgv25ecPAuUQ5KEtngg>
Feedback-ID: i78e14604:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Jan 2023 18:53:12 -0500 (EST)
Date:   Fri, 6 Jan 2023 17:53:10 -0600
From:   Tyler Hicks <code@tyhicks.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7i0ZukMa9CX+fzo@sequoia>
References: <20230104160511.905925875@linuxfoundation.org>
 <Y7cmMKUr//oYKWXb@duo.ucw.cz>
 <Y7fGpYyaJWym1BxW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7fGpYyaJWym1BxW@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-06 07:58:45, Greg Kroah-Hartman wrote:
> On Thu, Jan 05, 2023 at 08:34:08PM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 6.1.4 release.
> > > There are 207 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Thank you.
> > 
> > Is it known at this point if 6.1 will became next longterm release? It
> > is not listed as such on https://www.kernel.org/category/releases.html
> > . We might want to do some extra testing if it is.
> 
> A kernel can not become "long term" until it would have normally dropped
> off of support.  Right now there are known-regressions in 6.1 still that
> are not resolved.

Hey Greg - A couple questions...

1. Does that mean that you always wait until N+1 is released by Linus
   before declaring N to be an upstream LTS kernel?

   Looking back to last year, v5.16 was released on 2022-01-10 and you
   declared v5.15 as the LTS on 2022-01-16:

    https://git.kernel.org/pub/scm/docs/kernel/website.git/commit/?id=c335525958a3424ec0200dc9093d2bbf95032f83

   That one data point lines up but I want to confirm that's the normal
   procedure because I hadn't noticed that pattern until now and I don't
   see it mentioned on the kernel.org Releases page.

2. Do you (or anyone else) happen to have a list of the known
   regressions? I see one specific to linux-6.1.y in the regzbot list:

    https://linux-regtracking.leemhuis.info/regzbot/stable/

   Another reported here (with a potential fix identified):

    https://lore.kernel.org/netdev/CAK8fFZ7cYRkGjUJD2D86G6Jh9YRmP_L+7Ke6CLFSyFmRkoe-Hg@mail.gmail.com/T/#m1b118647969eb0d64de016858506fc2345a0b834

   A more complete list may help all of us currently evaluating v6.1.

> And "extra" testing is always good no matter what kernel branch it is
> happening for, why not always do it?

That's a very good point. I have to admit that we are a bit too
LTS-focused today when it comes to our testing. We have a goal to
improve in that area.

We have been working under the assumption that v6.1 is going to be the
next LTS but, as you point out, we should be iteratively testing each
release just the same. We are currently doing some additional/extra
testing of v6.1 with our Microsoft Linux kernel and will let you know
the results as they come in.

Tyler

> 
> thanks,
> 
> greg k-h
