Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE4D4DC178
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 09:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiCQIkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 04:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCQIkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 04:40:09 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C66B126595;
        Thu, 17 Mar 2022 01:38:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ja24so3747063ejc.11;
        Thu, 17 Mar 2022 01:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HxRIhMtIGNyuquPw1lmiPJQSJaGq9K+fhRuZGp4hFSw=;
        b=ij5/WzoJfQisplvcvRzMcZbis0DL0CSs9Z2z8zmQXhHH03o0i7whAhVUcmSgaIIStE
         ct0EAwRbaSVhJLVKDmxAXxkuuz1Wh4YZemlEbncEe3wT3mQMWbNEJR7ycMiS8GNNbTqU
         i1QrKrRJnAHvbCsxkYo883M4xF9dSJjmlW4nrTn1/Nt4wczQ3TRvjnd+DCscDcIVmNlN
         7/mtlso0lfs1R4v5sHuegjpbIj+25Wf1QdF77lP/kkA0jmjzVOwYXUiuIyJ6G/FH5vMd
         Y1BH20uCcHYoycllNyAs1JB2y0ayf1wnGfuZAQqZZTMNg6eavsMz6xPeJlGCjX7TtqRj
         nHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HxRIhMtIGNyuquPw1lmiPJQSJaGq9K+fhRuZGp4hFSw=;
        b=JZZqxFB0x1Bt//FulWjEwRA9DrcSW5k2qa4b9OWxYN3j/BsoY5pMo9dq0TwbJcmgDY
         0wMiLUUaEwyuSF1uNFuyQib6horqIWvHSmn6itagY5CsK2kzCC9XoitaY+1Cle+4LMvO
         uj2u7usv6IdtOXzbMLe2yUk3PY2x2VxtZJ8AfmaJZ8vev1wcECdSG/xp0mZl2a1Pvd+M
         kK66G+3GL/Ckf12j0Z3MRUbS+R93NVHyyHiARQXMOLJesq9mZ4ZHa32GNBx+Ax9/We31
         I5RkC6RFiw7bki41qbi+z/iGAiDEqOXE2X4VY0N6qihftHOqoTl8PhDnxbWK4cnSNn07
         Jx9Q==
X-Gm-Message-State: AOAM530i7U9oQGkkdj6b4c7nGrrktkxUrdWBaFqVjjws6l325mceeZlM
        SWJynwCNTzUKlEtB0XHB482ux+SuiCcVkV7DRRU=
X-Google-Smtp-Source: ABdhPJzKY289Ymbui0103ayg4U18iS7VJLj7hCueAp3BfI5ctm34/W2tHc27SGZJA/vNwLVlKykI67UuFIdov9SsEBs=
X-Received: by 2002:a17:907:7289:b0:6df:9746:e7c4 with SMTP id
 dt9-20020a170907728900b006df9746e7c4mr1391329ejc.497.1647506330740; Thu, 17
 Mar 2022 01:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <20220314155509.552218-1-michael@walle.cc> <CAMRc=MfH00YJv07TaiZ5z1w4gzqP5_8z9bKFcNU1Z37AVih4hQ@mail.gmail.com>
 <fe1ba600b2b30b4cba702d6aebdfda50@walle.cc>
In-Reply-To: <fe1ba600b2b30b4cba702d6aebdfda50@walle.cc>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 17 Mar 2022 10:37:37 +0200
Message-ID: <CAHp75VeoFQHAh6SbVu7fsXfziW+2RoFTWKA6jFhFswBbazzGAA@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Michael Walle <michael@walle.cc>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Saravana Kannan <saravanak@google.com>,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Andrew Chant <achant@google.com>,
        Edmond Chung <edmondchung@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        regressions@lists.linux.dev,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        stable <stable@vger.kernel.org>,
        Sergio Tanzilli <tanzilli@acmesystems.it>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Will McVicker <willmcvicker@google.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 7:36 AM Michael Walle <michael@walle.cc> wrote:
> Am 2022-03-15 16:32, schrieb Bartosz Golaszewski:
> > On Mon, Mar 14, 2022 at 4:55 PM Michael Walle <michael@walle.cc> wrote:

...

> I started to try this out, but then I was wondering if there weren't
> other gpio/pinctrl drivers with the same problem. And judging by the
> reports [1], I'd say there are. Then I wasn't sure if this is actually
> the correct fix here - or if that old workaround [2] doesn't work
> anymore because it might have that empty ranges "feature".
>
> To answer your question: I don't know. But I don't know if that is
> actually the correct way of fixing this either.
>
> >> Also, I'm not sure if there are any other other driver which get
> >> broken by this. I.e. ones falling into the gpio_stub_drv category.

I know that OF is a mess, but I want to understand why in ACPI we
haven't experienced such an issue. Any pointers would be appreciated.

-- 
With Best Regards,
Andy Shevchenko
