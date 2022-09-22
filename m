Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2AD5E5E65
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiIVJWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 05:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIVJWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 05:22:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E900017075
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:22:14 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x21so5580501edd.11
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 02:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=zu/La+x+mpg9RbS6KzOiMcR3Pzz+/DF7NsH0TJMll3E=;
        b=4GmtMp8FS4kvV0sC8dJyAlSDdoTr1eiE/h4eGi4dV/y09UuLkhNz/89eshTv3e7P/k
         2V1+eOSeMA0zSuM2uyK7YJtLi/rzzSEIayVF4gsIsl5q4yl1Dz2ixLhLksmkZ08FI1Lv
         LxnAnQl0jcwEee3LMsL0+nwnZdsuaG+n9AisksQwaxxOIGXWmjANoQTY3jDB33RBx+q9
         bbVE44ETrWCPfv/WqnTWb+47gmrBYbi6TlUimKfetw5MncPt3TTckIObv2xxTPhumvZd
         LSj/dmKL8n4glxLubXrrCb1WAujcZcFcOxZB+uT1JdyFbHNqJKK1qxg+gnj3848dG4LT
         GpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=zu/La+x+mpg9RbS6KzOiMcR3Pzz+/DF7NsH0TJMll3E=;
        b=UbNCbdyZ/WdC+E0Pf6TxAQ9c7DwSV8MRIaGMHWC1NYnz5Y9dJPYpMBSm9ngsScnK+W
         KBwOBmzIjrHOsIWwfOcxOiODiXpJor9BOZVc69Kq7+Wvm0sKmn/W4JjHDwA1B/5a/tvX
         G11fAm5ontCiMC2eyCK+vBkkXJqrUkZisjeJgokqGEgDY2HEM1sbH27DKVZvmMEIozUi
         HIGbxy0IP38Gd8nfg1IkE1kavhqPdHT8v84qeGRwOoltpR+WGGLm2lV4oLw1HtGIfKqy
         WmnRdT8yk6oXHKBwyfx/uFC6xZIjZl3mqvArTvVW85MIDqveoh2qBcD13D/jZVNTKK13
         CGqg==
X-Gm-Message-State: ACrzQf2+AKBGHxp/7Ohj0FDS2UddR8+svoyV25JVhv/yQVF/zSY13rRQ
        45iM1nRTUqdoG364xCa4k1s59gSrwmgwbEOX+E0ggw==
X-Google-Smtp-Source: AMsMyM6t0dzsEN8zI2x07k/UlGz3qtD6DQMIpEajWDiAzlPr9fzEqxhzzQWYxEuyJ6uMgW/USf5taysjv/4DflS4r0I=
X-Received: by 2002:aa7:dd02:0:b0:44e:f7af:b996 with SMTP id
 i2-20020aa7dd02000000b0044ef7afb996mr2311635edv.422.1663838533258; Thu, 22
 Sep 2022 02:22:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220921155436.235371-1-sashal@kernel.org> <20220921155436.235371-2-sashal@kernel.org>
 <fec2e2e2e74d680d5f9de6d68fb5fe18@kernel.org> <CAMRc=MexqLhu3ZWt1AbzBestswqmHNpct1LQiif0JGECTjHz4Q@mail.gmail.com>
 <87illfkbtk.wl-maz@kernel.org>
In-Reply-To: <87illfkbtk.wl-maz@kernel.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Thu, 22 Sep 2022 11:22:02 +0200
Message-ID: <CAMRc=Md9JKdW8wmbun_0_1y2RQbck7q=vzOkdw6n+FBgpf0h8w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 2/5] gpio: ixp4xx: Make irqchip immutable
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linusw@kernel.org, kaloz@openwrt.org, khalasa@piap.pl,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 11:17 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Bartosz,
>
> On Wed, 21 Sep 2022 21:04:27 +0100,
> Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> >
> > On Wed, Sep 21, 2022 at 6:57 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On 2022-09-21 16:54, Sasha Levin wrote:
> > > > From: Linus Walleij <linus.walleij@linaro.org>
> > > >
> > > > [ Upstream commit 94e9bc73d85aa6ecfe249e985ff57abe0ab35f34 ]
> > > >
> > > > This turns the IXP4xx GPIO irqchip into an immutable
> > > > irqchip, a bit different from the standard template due
> > > > to being hierarchical.
> > > >
> > > > Tested on the IXP4xx which uses drivers/ata/pata_ixp4xx_cf.c
> > > > for a rootfs on compact flash with IRQs from this GPIO
> > > > block to the CF ATA controller.
> > > >
> > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > > > Acked-by: Marc Zyngier <maz@kernel.org>
> > > > Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > >
> > > Why? The required dependencies are only in 5,19, and are
> > > definitely NOT a stable candidate...
> > >
> > > This isn't a fix by any stretch of the imagination.
> > >
> >
> > Hi Marc,
> >
> > While I didn't mark it for stable (and it shouldn't go into any branch
> > earlier than 5.19.x), I did send the patches making the irqchips
> > immutable to Linus Torvalds as fixes as they technically do *fix* the
> > warning emitted by gpiolib and make the implementation correct.
> >
> > I think these patches should still be part of the v5.19.x stable branch.
>
> 5.19, sure. All the dependencies are there, and tightening the driver
> implementations is a valuable goal.
>
> However, targeting all the other stable releases (5.4, 5.10, 5.15)
> makes little sense. It won't even compile! Do the dependencies need to
> be backported? I don't think it is worthwhile, as this is a long
> series containing multiple related changes spread all over the tree.
> This would defeat the very purpose of a stable tree.
>

That's what I'm saying. All the conversions to immutable irqchips
should go to v5.19 but nowhere else.

I thought that by saying "This isn't a fix by any stretch of the
imagination." you meant it should go like regular feature patches into
the next merge window only.

Sasha: can you drop this from all branches earlier than v5.19?

Thanks,
Bartosz
