Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6885385B8
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 18:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbiE3QBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 12:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243122AbiE3QAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 12:00:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9959748E59;
        Mon, 30 May 2022 08:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DDFCB80E2E;
        Mon, 30 May 2022 15:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19569C36AE7;
        Mon, 30 May 2022 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653926182;
        bh=oY2To6Dq8E4ZlSNzE9OvSOJ4Ec6SlQMPkQKRYIbD1j4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LAYG1a7rWuqBm9UiZAAn/vKEnZDJg/f4xBpHZZKdElqCHN070n/QJ3w70BKDdGFdZ
         7szxQd3rnBJmIkjXnkTXxNchF3dQ1Nw+4Kyz2poAZrfu/OKNjCwqzNFU9xcie1Un57
         PVnF99w8tArh1pbxOxGwtr1pkrlwAZ/VZ04ZLoeAlHejvJrwPp1leTzDt5TsRVOw8T
         /uj8NtafELR0Sn/4EYy8GGZ6V9h+ahcR5JpRKeal1l1xLYXCahBr1wenBnx7Rx+nA1
         VuIaJqM03bUvtOMIR7hUcGf5NSpvPLsIwkpbmKj/rD/LvTGGZgVCbol6f/mOEJRo3V
         1IwW85crae4fw==
Received: by mail-oi1-f178.google.com with SMTP id y131so6972376oia.6;
        Mon, 30 May 2022 08:56:22 -0700 (PDT)
X-Gm-Message-State: AOAM530cJFhvS+f2WprL+8x3daK6PiB6sFZp4Q8o+J7AhrU/dzp4qJKf
        u8DiE7hoWUF5EPznEDjufxHMadPtwPR+HzLnwFo=
X-Google-Smtp-Source: ABdhPJx1z4xy7gzvzyGPxKXo7f7InAUbUfc1mL0H8QmD86R83QH82XT9ytmiExoj5XZx70/VX0uvCQ6dvxRVUKn4xkw=
X-Received: by 2002:a05:6808:f88:b0:32b:d10f:cc6b with SMTP id
 o8-20020a0568080f8800b0032bd10fcc6bmr8351264oiw.228.1653926181276; Mon, 30
 May 2022 08:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220530132425.1929512-1-sashal@kernel.org> <20220530132425.1929512-147-sashal@kernel.org>
 <CAMj1kXGAuKTqV0S4jxticZJp7ChtqqeXjn7SV1E83p5yVE1pkw@mail.gmail.com> <YpTh9dan5lJgH2aL@kroah.com>
In-Reply-To: <YpTh9dan5lJgH2aL@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 30 May 2022 17:56:09 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGO-1ccxaK_GnE+d2yc0XkF5y9ZawXXC3ypeGAanv9VtA@mail.gmail.com>
Message-ID: <CAMj1kXGO-1ccxaK_GnE+d2yc0XkF5y9ZawXXC3ypeGAanv9VtA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.18 147/159] ARM: 9201/1: spectre-bhb: rely on
 linker to emit cross-section literal loads
To:     Greg KH <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Keith Packard <keithpac@amazon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 30 May 2022 at 17:25, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 30, 2022 at 03:32:47PM +0200, Ard Biesheuvel wrote:
> > AUTONAK
> >
> > As discussed before, please disregard all patches authored by me when
> > running the bot.
>
> Ok, but why wasn't this spectre-bhb commit asked to be backported to
> stable in the first place?

Because it doesn't belong in -stable. Hence the lack of cc:stable or
fixes: tags.

> Do older kernels not need these types of
> fixes?
>

This commit was part of a series of six, two of which were bug fixes
and had fixes: tags. They do not have cc:stable tags because the
'fixed' patches had not been backported yet when they were sent out.

So those are clear candidates for -stable, and as far as I can tell,
they have already been backported.

This patch does not fix a bug. It makes the asm code more resilient to
potential bugs introduced inadvertently by future changes, which will
be harder to detect now that we have three different versions of the
exception vector table. (Any given system will only exercise one of
the three, depending on whether and which Spectre-BHB workaround it
requires)

I build and boot test my patches carefully, and so I consciously
decided that the regression risk of backporting this patch outweighs
the benefits. This is why I did not add a cc:stable or fixes: tag. If
a tag existed that said 'do not backport this unless explicitly
requested', I would have added it.

I would expect anyone that proposes this patch for -stable to be as
diligent in ensuring that the patch is safe for backporting, which
includes building the code with older GCC versions that those stable
kernels still support, and boot testing the result on actual hardware.

If this is part of the AUTOSEL workflow, then I stand corrected. But
even then, this does not mean that the patch *belongs* in -stable. As
you know, I enjoy throwing stable-kernel-rules.rst in your face, and I
am pretty sure that using a bot to find patches that apply cleanly and
happen not to cause build breakage is not covered by the criteria
defined by that document by any stretch of the imagination.

On top of that, I feel that 'saving' precious stable maintainer's time
by using a bot to offload this burden to the community uninvited is
really not ok. We work very hard to keep highly heterogeneous
architectures such as ARM working across all supported platforms, and
this is work enough as it is without all the bogus patches that
AUTOSEL digs up without *any* justification beyond 'hey, it applies!'
