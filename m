Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E791D8F52
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 07:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgESFpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 01:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgESFpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 01:45:17 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B984FC05BD09
        for <stable@vger.kernel.org>; Mon, 18 May 2020 22:45:16 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x27so10000567lfg.9
        for <stable@vger.kernel.org>; Mon, 18 May 2020 22:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f76EOTr9ng0HQJqS68gOEOMao8wCn3C/r3Rj0POH9q8=;
        b=ZMZBd3C4Oqz8XC6fRUUSAI8r6H/HvXwKZ4VKzRdjB86o0RPVdXqE7FekRxhhIpxc57
         ysKgcMYfNh/MsQ25weGNYlqKTQfsozwcSw2csNnB8nCzwI6XllSAFUBTREd7fuGxUsaX
         AHdzwnF2XPr8jv6EJ33fAfnd2dmPM5N3X5ukG2ULEhZ7Epc7aJo8D2SmWVAn0USkTj7p
         pU9Gbbe6SoDbMZLOuj05pxPDGnwGR7/V/2Mk4fyRnnHn1dtaYewNeC/RXgR75MOPzxpY
         9yMjSIt2CUcqJjcdgy/dr4brp+tOosEH3E4Ru37UnZYNnLWHyOpUqbW5OcCebtjTyizU
         GTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f76EOTr9ng0HQJqS68gOEOMao8wCn3C/r3Rj0POH9q8=;
        b=Yke0GSuclFmROIfV4bOiFTfAEGpo6/W6isQxOVDdUH/cGVKjLlPV84QUmo67Un756S
         KHf88ErtgbzFAabCgjWLDAtpRo+D97pzKRgk9utVAsFNXqogNUGeWH3Dg1m27yaJkntb
         m84TWZT4ef7WSLVEx6ckqgchfo4SrmJp58osrVPR2PQ/DZpHZa03LIYc0IBsKzv5zE7p
         Hrs5oUtX92c4IQbJs43QfpMqE16vlKiw3cyGXe+D4Y2/kZiCnRLu6BhYA5CO2C121HDB
         FNHN3ngztGzS9TCRuVDGA661E1s8hWMk4Gb2nU4s5bIOnL9q7Wm8jR/WopX8pSFRzEoR
         UHrQ==
X-Gm-Message-State: AOAM533U36rl9rjJuFBklHLz8CVoXjZaOqK25RnxyzDJmz2U9/shC8O4
        7tBjqogWaVpQjTQ/ehIOOahctQ==
X-Google-Smtp-Source: ABdhPJzThNm5a6/nvPnTKurFxSLJKcfIIu9iNXbnWA/NOV0iHFCtMVkCkSI2rTos5e8exn/p52/OpQ==
X-Received: by 2002:a19:6914:: with SMTP id e20mr7618653lfc.27.1589867114782;
        Mon, 18 May 2020 22:45:14 -0700 (PDT)
Received: from buimax ([109.204.208.150])
        by smtp.gmail.com with ESMTPSA id m13sm8304025lfk.12.2020.05.18.22.45.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 18 May 2020 22:45:14 -0700 (PDT)
Date:   Tue, 19 May 2020 08:45:12 +0300
From:   Henri Rosten <henri.rosten@unikie.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, lukas.bulwahn@gmail.com
Subject: Re: [PATCH 4.4 17/86] phy: micrel: Disable auto negotiation on
 startup
Message-ID: <20200519054510.GA28178@buimax>
References: <20200518173450.254571947@linuxfoundation.org>
 <20200518173453.976038108@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518173453.976038108@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 07:35:48PM +0200, Greg Kroah-Hartman wrote:
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> [ Upstream commit 99f81afc139c6edd14d77a91ee91685a414a1c66 ]

I notice 99f81afc139c has been reverted in mainline with commit b43bd72835a5.  
The revert commit points out that:

"It was papering over the real problem, which is fixed by commit
f555f34fdc58 ("net: phy: fix auto-negotiation stall due to unavailable
interrupt")"
 
Therefore, consider backporting f555f34fdc58 instead of 99f81afc139c.

Notice if f555f34fdc58 is taken, then I believe 215d08a85b9a should also 
be backported.

Thanks,
-- Henri

> 
> Disable auto negotiation on init to properly detect an already plugged
> cable at boot.
> 
> At boot, when the phy is started, it is in the PHY_UP state.
> However, if a cable is plugged at boot, because auto negociation is already
> enabled at the time we get the first interrupt, the phy is already running.
> But the state machine then switches from PHY_UP to PHY_AN and calls
> phy_start_aneg(). phy_start_aneg() will not do anything because aneg is
> already enabled on the phy. It will then wait for a interrupt before going
> further. This interrupt will never happen unless the cable is unplugged and
> then replugged.
> 
> It was working properly before 321beec5047a (net: phy: Use interrupts when
> available in NOLINK state) because switching to NOLINK meant starting
> polling the phy, even if IRQ were enabled.
> 
 
