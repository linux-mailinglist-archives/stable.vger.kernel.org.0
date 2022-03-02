Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA304CA0A5
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 10:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbiCBJZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 04:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbiCBJZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 04:25:45 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86606A2510;
        Wed,  2 Mar 2022 01:24:57 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id kt27so2445237ejb.0;
        Wed, 02 Mar 2022 01:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sIH+XDr0bcmAnSp6r3s95jesa/YkHfKfM8EvZG2x2jo=;
        b=hsEF+EI2f/RYm/JUPs5oa2IZ2CZKuZpD4CJzPSyORMsbaDMnWp3DfRlMKqPj8JtZVi
         anq67h7VOcM4sIpbWPxDDScpzx/H60AyP2jz/xk1p1AWJ2b76Qle5lpRibmjhahNK8Qd
         Q7brsKclZaRyQPIYUF9v+Me/p5Aknf2rDEL+cC9etK5k8xNnJ1vks4LH3Of18ieYNGOR
         IaLxKYHcUxJQI8k0iC6gQO+0CxLha9AeOJ2e7wS3AyH6r05EwI1v2UMd3DS67bndzW50
         BKZXMwjw8JNnRxzYAJ8UfCJFwSrXpSH5KThqTGibnHCM4xpeGZHlOeIVlU0lJ/SCBMRM
         CMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sIH+XDr0bcmAnSp6r3s95jesa/YkHfKfM8EvZG2x2jo=;
        b=Iyya5hAMAT+36dKnMYu5Y/2cDEXA/7PYS1XYLzFVbcu5nwdRxU8LSyFA6P4LSgHT2p
         IRmxewsi8FgjiJUh14oxoOKShmj0RPTbRnPrIyqDk8ueuZ9kVv/kBYbw57TsHZQhQEbm
         gSZfS3o8RkdwBHVm8mSOKFTl3PPLBnHZ0zCXkQ/R9DlRbtvnGEDyPnDhrS8ShSYOdevJ
         CDn/un2qGzFQIYa9VdYpSscwmZUQXiRHZM6/1ntbaY0PokqAOf9KEa+/mQY1SSllIHFi
         8Kvtu9FLzuI2gIPYcQd2YE0sNaQ3eJF9dpzcd4rJ+ktPNm5cbu8oAMexAQ2pH84jptCj
         v7Jg==
X-Gm-Message-State: AOAM532Oa9GEgwsNAaEBPBCYtW9WapIgBFvi3RKYM4HZ/V3s7LZOEh0m
        B45kKM47jwa4hsK+vfNnzPU=
X-Google-Smtp-Source: ABdhPJyeQXm9LWD3RXtqVhCpGaC2+7E5F6tWlrf4CiE3RYx+9cku+hvfEypndrYXp0tlrBL6eAOGqA==
X-Received: by 2002:a17:906:d7aa:b0:6cf:1fb3:2986 with SMTP id pk10-20020a170906d7aa00b006cf1fb32986mr22427009ejb.594.1646213096003;
        Wed, 02 Mar 2022 01:24:56 -0800 (PST)
Received: from tom-desktop (net-188-217-57-126.cust.vodafonedsl.it. [188.217.57.126])
        by smtp.gmail.com with ESMTPSA id b6-20020a50e386000000b00410d64cb3e4sm8545376edm.75.2022.03.02.01.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 01:24:55 -0800 (PST)
Date:   Wed, 2 Mar 2022 10:24:53 +0100
From:   Tommaso Merciai <tomm.merciai@gmail.com>
To:     Richard Leitner <richard.leitner@linux.dev>
Cc:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        richard.leitner@skidata.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 04/23] usb: usb251xb: add boost-up property
 support
Message-ID: <20220302092453.GA4465@tom-desktop>
References: <20220215152957.581303-1-sashal@kernel.org>
 <20220215152957.581303-4-sashal@kernel.org>
 <20220220101256.GC7321@amd>
 <Yhy+pvprwSx4zdCG@ltleri2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yhy+pvprwSx4zdCG@ltleri2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 01:23:02PM +0100, Richard Leitner wrote:
> Hi,
> 
> On Sun, Feb 20, 2022 at 11:12:57AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Tommaso Merciai <tomm.merciai@gmail.com>
> > > 
> > > [ Upstream commit 5c2b9c61ae5d8ad0a196d33b66ce44543be22281 ]
> > > 
> > > Add support for boost-up register of usb251xb hub.
> > > boost-up property control USB electrical drive strength
> > > This register can be set:
> > > 
> > >  - Normal mode -> 0x00
> > >  - Low         -> 0x01
> > >  - Medium      -> 0x10
> > >  - High        -> 0x11
> > > 
> > > (Normal Default)
> > > 
> > > References:
> > >  - http://www.mouser.com/catalog/specsheets/2514.pdf p29
> > 
> > Should the boost-up property be documented somewhere in the kernel
> > tree? We normally do that for device tree properties. And we normally
> > have properties used somewhere in the device tree. What is going on here?
> 
> AFAIK this patch was dropped for all stable releases, so this specific
> AUTOSEL message/thread is obsolete.
> 
> Nonetheless the DT documentation is also missing on master. Therefore
> I guess it should be provided asap 😉
> 
> Tommaso, can you provide a patch?

Hi All,
Sorry for delay, but I'm quite busy in these days.
Yes I can provide a patch about documentation in the
next days.

Regards,
Tommaso

> 
> regards;rl
> 
> > 
> > Best regards,
> > 							Pavel
