Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B406585E96
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 13:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiGaLNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 07:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiGaLNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 07:13:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB84DE9D
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 04:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06298B80B20
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 11:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8711C4347C
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659266006;
        bh=zyiuKQHS40qfCly0L6PnM1NVDd7eMxtPyT90sMlse2c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gWiRCavyx9NWArXx7Kmvxukggjc2+XH0ZqFIyk0aHJeG3tR/sv/qDdgpFF3JOWouj
         xdw8C2P+1+37z5ByxDVw3wiuu/4yUUIACu2asZ9CVZE4xRTbTRkrwO4Z6+89JAUlQq
         tWBmeOxn/7oEJ5MoiBEwZr6lRvW4KJekcqJnzxNxx2Vhli0wpSDefaV347KIMdYRtG
         4pPxO2JXh36kn8xO8RWkOsWKb7EQH2zvpheqlThLNVJo5ARxk9KijfnpT7D7nzzwbi
         1CO7bdx3mZ2unwx0k5OPYN8WyQA9qmb5Rh/A9NNDrHSZ/Zc6dOiPyroVynknJlcKJW
         bHxEknl87yCpQ==
Received: by mail-oo1-f43.google.com with SMTP id v5-20020a4aa505000000b00435b0bb4227so1553246ook.12
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 04:13:26 -0700 (PDT)
X-Gm-Message-State: AJIora9QuYklxnjPC0eiKU3tUCReLYrfhY/hKuR46aKxNsNZrojSWESo
        cAPiJNWur0KeiWQklLVdDlpp0etUwGaoAFHOWlU=
X-Google-Smtp-Source: AGRyM1uniCizgwfvPXcszFmmyCB6vbOUjxg6u2E3e6Vl5rYuJOYHRoi2DCa/ZvPxrEwydjmwuKw4YIRxnzyMM2a4gYg=
X-Received: by 2002:a4a:cb10:0:b0:435:9075:a86b with SMTP id
 r16-20020a4acb10000000b004359075a86bmr3888557ooq.98.1659266005854; Sun, 31
 Jul 2022 04:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220731100551.3679874-1-gregkh@linuxfoundation.org>
 <CAMj1kXHPV-EHVQDa5hmJJAQP-dDfTgVpD6+7g65+Q9-C6xdwhg@mail.gmail.com> <YuZb5BEORzZ94z0k@kroah.com>
In-Reply-To: <YuZb5BEORzZ94z0k@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 31 Jul 2022 13:13:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFODDitAF+_UjrPeyV-tdAYv2n=8+hpXcQM4606ygiw=w@mail.gmail.com>
Message-ID: <CAMj1kXFODDitAF+_UjrPeyV-tdAYv2n=8+hpXcQM4606ygiw=w@mail.gmail.com>
Subject: Re: [PATCH] ARM: crypto: comment out gcc warning that breaks clang builds
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 31 Jul 2022 at 12:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Jul 31, 2022 at 12:17:40PM +0200, Ard Biesheuvel wrote:
> > On Sun, 31 Jul 2022 at 12:05, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > The gcc build warning prevents all clang-built kernels from working
> > > properly, so comment it out to fix the build.
> > >
> > > This is a -stable kernel only patch for now, it will be resolved
> > > differently in mainline releases in the future.
> > >
> > > Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > > Cc: "Justin M. Forbes" <jforbes@fedoraproject.org>
> > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > Cc: Arnd Bergmann <arnd@kernel.org>
> > > Cc: Nicolas Pitre <nico@linaro.org>
> > > Cc: Nathan Chancellor <nathan@kernel.org>
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  arch/arm/lib/xor-neon.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
> > > index b99dd8e1c93f..7ba6cf826162 100644
> > > --- a/arch/arm/lib/xor-neon.c
> > > +++ b/arch/arm/lib/xor-neon.c
> > > @@ -26,8 +26,9 @@ MODULE_LICENSE("GPL");
> > >   * While older versions of GCC do not generate incorrect code, they fail to
> > >   * recognize the parallel nature of these functions, and emit plain ARM code,
> > >   * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
> > > + *
> > > + * #warning This code requires at least version 4.6 of GCC
> > >   */
> > > -#warning This code requires at least version 4.6 of GCC
> > >  #endif
> > >
> > >  #pragma GCC diagnostic ignored "-Wunused-variable"
> >
> > LGTM but doesn't Clang also complain about the GCC specific pragma?
>
> I don't know, all clang builds always failed at the first #warning line :)

Just tried it, and it appears to ignore the #pragma so we're all good.
