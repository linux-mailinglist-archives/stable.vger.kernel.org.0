Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810CD2D6F82
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 06:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgLKFFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 00:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLKFFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 00:05:15 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20300C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 21:04:35 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id bo9so10596001ejb.13
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 21:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19AnTq45CSZ2lUNFTFAhbgUOISoXYUKH+oHoFm5bIgI=;
        b=k5YscS7vhEsmMUSSklcg+o6u/nbJHzc5M4YEK8l4cqZAHmw/x8i11872lVI7EfBz2B
         YYMGeZNfQOLTzdFqldicmGNo+Uv69u7I1N7TxdUzoeCxBrbkkawnOKg07JiiQI1rUZBf
         meWRbkftsAek9JIsFn6X3kAGNPf4xZdK+iG6R5tyLt9suwnHmUZKqf6jGFM4klHTAggM
         LGpR2gvDYh/4/NpCqubu0XZj+4TgEAhsNJkgOtszEbVX42atd6ZpkWY+28YRh18ykIqw
         9YsFApCR3GOyTpatAcTlunbWLEjzuzDckfa1GL9BGzC7D/gZ+rNiT7uovkPGy6pnW5wx
         GZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19AnTq45CSZ2lUNFTFAhbgUOISoXYUKH+oHoFm5bIgI=;
        b=jplaPFneK20NbbAv6J11nS3MArwmrUoSWk9lRieiiddng+CFsI3oHmZ/t68uEcPflv
         U53oPU+gxyNBlq6Z/XtPlvNijkDUvKoE57lcb5T+EAcR4VrHRkSQ4ji3svfbxlHibWgz
         q9gRDAZSQis8tsiKACkYyLIInYtUph2eaUmNdudeKpJ+L1eTzVQhg3iPqEWSei4WFFZS
         Hv0y9iYiXB/s4I2w77GL1N0QgV2MfkQibI4mTdHAa0wXl4QWRrzY30X7fEbIxgyvhC1A
         nGQH/CmmQ1Wsjn9oYkgLochVHrxcbexU2XN8lrdzCm+8STYGgkmw6qNfpDfEoBCvxosc
         qzBw==
X-Gm-Message-State: AOAM531PrAKOFGFj7jP0ja31mCy9/r9WTopQRNH3uTfb6QOcYpRz2Eti
        uHnNLG6AlYa3ExU5QXSY+gguN+BvnTpjWx+aD926gw==
X-Google-Smtp-Source: ABdhPJwRrBhd2WxdtU4DWaOjuU1+PmSEKb2t71vPWLqO0S7exyuqZG9p5trAIiQqM4rXaEMpw7G38XfTdXx3aVdspdw=
X-Received: by 2002:a17:906:17d0:: with SMTP id u16mr9277055eje.452.1607663073559;
 Thu, 10 Dec 2020 21:04:33 -0800 (PST)
MIME-Version: 1.0
References: <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com> <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <20201210154651.GV1551@shell.armlinux.org.uk> <CAPv3WKdWr0zfuTkK+x6u7C6FpFxkVtRFrEq1FvemVpLYw2+5ng@mail.gmail.com>
 <20201210175619.GW1551@shell.armlinux.org.uk> <CAPv3WKe+2UKedYXgFh++-OLrJwQAyCE1i53oRUgp28z6AbaXLg@mail.gmail.com>
 <20201210202650.GA2654274@lunn.ch>
In-Reply-To: <20201210202650.GA2654274@lunn.ch>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Fri, 11 Dec 2020 06:03:57 +0100
Message-ID: <CABdtJHuuRY-Oimx6DbEW4pLYdbBKKwV+1r3OpfS62skCJYWLkQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Andrew Elwell <andrew.elwell@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 9:27 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +1. As soon as the MDIO+ACPI lands, I plan to do the rework.
>
> Don't hold you breath. It has gone very quiet about ACPI in net
> devices.

NXP resources were re-allocated for their next internal BSP release.
I have been working with Calvin over the past week and a half and the new
patchset will be submitted early next week most likely.

-Jon

>
>         Andrew
