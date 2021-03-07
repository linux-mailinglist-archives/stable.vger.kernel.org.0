Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22633050B
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 23:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhCGWtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 17:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhCGWtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 17:49:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D216EC06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 14:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ffmktd8CHukbv8ZpJIsYVvsHswFJCJz64JooEdtWqMc=; b=LtDpfo3NQ87raaFFuh8LGwjLX
        jU7KOHZOSalzHGG1njNTG1dNHOmaWiLLjEQeojxEvlxfXzPAs5oXCVr1wEOx52yqkRBWlNV/Uaivd
        2n243gCDQEz+lBoEo/EhkJXAnC12yPywR1+oJb4LKSEqz0kpoVBU+o1AvT9FCkeTSUx8NF/ORJKM9
        dB6GIcsQv5tyPljcULuUtO+PCsEGzqxQzWevrB9+Pmzrag5mMAW1B4ulB5lINm2UW8J5F2Z+9vlwh
        otY5xTwHH5fmNauUZ+YsxvYv9CXXMrLukKqvmvTRtkoc1I4723sjMkKYB2MWYSyT5m62sqEmH8r0e
        vlPubQybA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49836)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lJ2Cl-0001gk-Lj; Sun, 07 Mar 2021 22:48:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lJ2Ck-0006Zs-Nf; Sun, 07 Mar 2021 22:48:54 +0000
Date:   Sun, 7 Mar 2021 22:48:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: stable: KASan for ARM
Message-ID: <20210307224854.GF1463@shell.armlinux.org.uk>
References: <20210307150040.GB28240@qmqm.qmqm.pl>
 <YETvOfBpfGrzewmt@kroah.com>
 <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXEDD0To+t40ymFTrWVpBJBdi5PXYfxzE3yi5-VjDPTKoA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 07, 2021 at 05:10:43PM +0100, Ard Biesheuvel wrote:
> (+ Russell)
> 
> On Sun, 7 Mar 2021 at 16:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Mar 07, 2021 at 04:00:40PM +0100, Michał Mirosław wrote:
> > > Dear Greg,
> > >
> > > Would you consider KASan for ARM patches for LTS (5.10) kernel? Those
> > > are 7a1be318f579..421015713b30 if I understand correctly. They are
> > > not normal stable material, but I think they will help tremendously in
> > > discovering kernel bugs on 32-bit ARMs.
> >
> > Looks like a new feature to me, right?
> >
> > How many patches, and have you tested them?  If so, submit them as a
> > patch series and we can review them, but if this is a new feature, it
> > does not meet the stable kernel rules.
> >
> > And why not just use 5.11 or newer for discovering kernel bugs?  Why
> > does 5.10 matter here?
> >
> 
> The KASan support was rather tricky to get right, so I don't think
> this is suitable for stable. The range 7a1be318f579..421015713b30 is
> definitely not complete (we'd need at least
> e9a2f8b599d0bc22a1b13e69527246ac39c697b4 and
> 10fce53c0ef8f6e79115c3d9e0d7ea1338c3fa37 as well), and the intrusive
> nature of those changes means they are definitely not appropriate as
> stable backports.

I agree - it took quite a while for KASan to settle down - and our last
issue with KASan causing a panic in the Kprobes codes was in February.
So, I think at the very least, requesting to backport this so soon is
premature. That fix is not included even in what you mention above.
Maybe that fix has already been picked up in stable, I don't know.

So, we know that there's probably more to getting kprobes working on
32-bit ARM than even you've mentioned above.

Is it worth backporting such a major feature to stable kernels? Or
would it be better to backport the fixes found by KASan from later
kernels? My feeling is the latter is the better all round approach.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
