Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE504679A4
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 15:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381560AbhLCOtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 09:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381548AbhLCOtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 09:49:45 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6197C061751
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 06:46:20 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p18so2533150wmq.5
        for <stable@vger.kernel.org>; Fri, 03 Dec 2021 06:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=v4VOMillbCsUUfD1LU3KOFh8EAHKlb6MpbuMP36w6ao=;
        b=inODXxOYsLADIcXKLE2foYW49r3909nrLMuTPkHQN16A2nQy6zeLBh/WhPypLO5avJ
         RmeOJQ3z7jB0b1j9zzIhYBmMcFHvSppx0QIOIO/dVEh3h27BoESwCdouXZSdF4RnhUxv
         guYkjIx33yIIaVcApfIG4isd0xhugX3UsyOQDIBhxGkt74eKopjU4BxEztqUjohymV6H
         RvqxZu8kXgpawYu8OqG2Qe4rPXP39Xc32N5nRTKHZc7SDzIe1+ljOnEqKPHzum0G8uIP
         11UqHSiCZb5w8eH+HcsnLkgBwvR0I0DQp6RKBHX2QIYd/kgapJ0D6XWIzjxtzVk6OcKX
         +tDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=v4VOMillbCsUUfD1LU3KOFh8EAHKlb6MpbuMP36w6ao=;
        b=03cJxBXRMHuZbgFo9FSuQURmCfHRQKi5iQUZXhZ+uCDOCr+FLo/7AuK/VEx3QXUznE
         Cz8ImpxZIi40DsaDgCKZaBIAU6bd86i98FhZhhJu9vyz2/JzWUkI5wn18LHolXr+bhmP
         eTYyf8twR1kulpGYYIrMWtjEuxpVk4jHA2+zO8J758sf+YAHuvgb7h6GqWE6Rg7V4siK
         +3ttJjbHh3sAkUuKW5vbJfmPQcWG+8gDHblsx83WgUcYeJhJR+PExmyFTDF9lhxeTLFd
         70pomWofELEOQhJ23P0j1h8JV8PoaetKC5MYxPo0wVLCfA/pxtaY3SBiRhgjcdWV8nr+
         KT/A==
X-Gm-Message-State: AOAM530LolDax0IUM6/6cai6r6KiODA+YG2bCI0NTza+FVQjrSKdqNn7
        YwR8rXcjJsjz7sTYpeZeJMDHcg==
X-Google-Smtp-Source: ABdhPJzxHqETgoDEVRMGwS14ODKhQckKDbC14Nr5NTWkjBLZu5Oc7PUyGjbcnQSzmO06JsWn84ouUw==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr15217228wmi.173.1638542779194;
        Fri, 03 Dec 2021 06:46:19 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id r8sm3667803wrz.43.2021.12.03.06.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 06:46:18 -0800 (PST)
Date:   Fri, 3 Dec 2021 14:46:16 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Message-ID: <YaotuB5CkQhWHvpQ@google.com>
References: <20211202143437.1411410-1-lee.jones@linaro.org>
 <20211202175134.5b463e18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87o85yj81l.fsf@miraculix.mork.no>
 <Yan+nvfyS21z7ZUw@google.com>
 <87ilw5kfrm.fsf@miraculix.mork.no>
 <YaoeKfmJrDPhMXWp@google.com>
 <871r2tkb5k.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871r2tkb5k.fsf@miraculix.mork.no>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 03 Dec 2021, Bjørn Mork wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> > On Fri, 03 Dec 2021, Bjørn Mork wrote:
> 
> >> This I don't understand.  If we have for example
> >> 
> >>  new_tx = 0
> >>  max = 0
> >>  min = 1514(=datagram) + 8(=ndp) + 2(=1+1) * 4(=dpe) + 12(=nth) = 1542
> >> 
> >> then
> >> 
> >>  max = max(min, max) = 1542
> >>  val = clamp_t(u32, new_tx, min, max) = 1542
> >> 
> >> so we return 1542 and everything is fine.
> >
> > I don't believe so.
> >
> > #define clamp_t(type, val, lo, hi) \
> >               min_t(type, max_t(type, val, lo), hi)
> >
> > So:
> >               min_t(u32, max_t(u32, 0, 1542), 0)
> 
> 
> I don't think so.  If we have:
> 
>  new_tx = 0
>  max = 0
>  min = 1514(=datagram) + 8(=ndp) + 2(=1+1) * 4(=dpe) + 12(=nth) = 1542
>  max = max(min, max) = 1542
> 
> Then we have
> 
>   min_t(u32, max_t(u32, 0, 1542), 1542)
> 
> 
> If it wasn't clear - My proposal was to change this:
> 
>   - min = min(min, max);
>   + max = max(min, max);
> 
> in the original code.

Oh, I see.  Yes, I missed the reallocation of 'max'.

I thought we were using original values and just changing min() to max().

> But looking further I don't think that's a good idea either.  I searched
> through old email and found this commit:
> 
> commit a6fe67087d7cb916e41b4ad1b3a57c91150edb88
> Author: Bjørn Mork <bjorn@mork.no>
> Date:   Fri Nov 1 11:17:01 2013 +0100
> 
>     net: cdc_ncm: no not set tx_max higher than the device supports
>     
>     There are MBIM devices out there reporting
>     
>       dwNtbInMaxSize=2048 dwNtbOutMaxSize=2048
>     
>     and since the spec require a datagram max size of at least
>     2048, this means that a full sized datagram will never fit.
>     
>     Still, sending larger NTBs than the device supports is not
>     going to help.  We do not have any other options than either
>      a) refusing to bindi, or
>      b) respect the insanely low value.
>     
>     Alternative b will at least make these devices work, so go
>     for it.
>     
>     Cc: Alexey Orishko <alexey.orishko@gmail.com>
>     Signed-off-by: Bjørn Mork <bjorn@mork.no>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 4531f38fc0e5..11c703337577 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -159,8 +159,7 @@ static u8 cdc_ncm_setup(struct usbnet *dev)
>         }
>  
>         /* verify maximum size of transmitted NTB in bytes */
> -       if ((ctx->tx_max < (CDC_NCM_MIN_HDR_SIZE + ctx->max_datagram_size)) ||
> -           (ctx->tx_max > CDC_NCM_NTB_MAX_SIZE_TX)) {
> +       if (ctx->tx_max > CDC_NCM_NTB_MAX_SIZE_TX) {
>                 dev_dbg(&dev->intf->dev, "Using default maximum transmit length=%d\n",
>                         CDC_NCM_NTB_MAX_SIZE_TX);
>                 ctx->tx_max = CDC_NCM_NTB_MAX_SIZE_TX;
> 
> 
> 
> 
> 
> So there are real devices depending on a dwNtbOutMaxSize which is too
> low.  Our calculated minimum for MBIM will not fit.
> 
> So let's go back your original test for zero.  It's better than
> nothing.  I'll just ack that.

Sure, no problem.

Thanks for conversing with me.

> > Perhaps we should use max_t() here instead of clamp?
> 
> No.  That would allow userspace to set an unlimited buffer size.

Right, I see.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
