Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831A050FF15
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 15:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350392AbiDZNg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 09:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350339AbiDZNg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 09:36:26 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5561F377F6
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:33:17 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2f16645872fso182052747b3.4
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 06:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xQJxtHgYo45TypCgF91EJUJX/kpEtMGt2+M/xOBJnMI=;
        b=SwIK1PdkH4n+khwbHWsA069VnDXEen+KnTWOPpaksm1zszI77d6fkxok+B1KfpsMIU
         Z8DGXH867i4dqJ+RjIAoUudDdGyaJv5rfW/bxSMufgtl+hF5p6E648Sogatr0G3L9wKd
         hQdoH1h8hg0jgYD4x90Fy9w1yXLMEk/DWd6RqrPz+tPkKQPrSyO5CXGGltSPkcCQl1gx
         F+gDmRZBk0Qh/TEUul/7QIJ23O9qnHpbaPw2t2m1mRFzELl3pRHnWyaCTwXUAYi5yVQi
         k51NW7rxmelAmQ5+PNoVD5SniZRWllE92VyWyfYXNAXpIHcL/L/8URDqvSK3xEjiKykR
         HMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xQJxtHgYo45TypCgF91EJUJX/kpEtMGt2+M/xOBJnMI=;
        b=p8qDzK3fHXh3rpLxYM2A4yHawo0rOqRHGvzGQrn6QfqAW71mt4AMPqcZlm/1WrpxA6
         XlDOWIuCnV16IC8Znhv1sG1YA1mIBk3MT+iiuJp6bpgBzkdzT3/lqUn3wHctR5b+xvUd
         2ga4l8/dooN5pd4VOPFmNvhveV6m9nGJueSHzicYl1d5k5/h71J9WtSOdsXertxGiobG
         WLkPqrO71QvlKHv9AufE+wrzbj2GiFG2vD9wspUbxIW/CASOZr/ass9DD7z9L+LD7Esv
         EiXCupLyesoja6oBnlMWNbWgPjAxmBOqyaAU5LugsfU0OVXRYkuJdWN0pHcbmuHqsRjn
         0t5A==
X-Gm-Message-State: AOAM5318YQLi6qagrz/EStISlBZqbDwnQvD2qDzzznPlUeylOvTfJGWV
        ebNhJZy7izOiKZtOLjlu91zmKLsyNZ7FhY3HZoH/GQ==
X-Google-Smtp-Source: ABdhPJyNT/CX/SXRXOQuOox6/jWyVG5uSS7VPA9wWYPVI6WZSfJ7419v0oaLcxGDmhwykXFIqSwFNqC/4GfbI9f/pa8=
X-Received: by 2002:a81:998e:0:b0:2f4:e2a0:f30f with SMTP id
 q136-20020a81998e000000b002f4e2a0f30fmr21317098ywg.376.1650979997177; Tue, 26
 Apr 2022 06:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220423221623.1074556-1-huobean@gmail.com> <20220423221623.1074556-3-huobean@gmail.com>
 <CACRpkdahf5QhUJ-vG6Qs7i0VYbSS02zBrQOtN8EVFu9SyHZA1Q@mail.gmail.com>
 <89845bec6c827d7012cda916ee50b16c8eb08755.camel@gmail.com> <CACRpkdbM_qhwmFhwJNx0J_r2jUHoSsE6B=bKhGwKG=dXtX7uEg@mail.gmail.com>
In-Reply-To: <CACRpkdbM_qhwmFhwJNx0J_r2jUHoSsE6B=bKhGwKG=dXtX7uEg@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 26 Apr 2022 15:32:40 +0200
Message-ID: <CAPDyKFpavPhxzvohj8nOLujVyqTekgQO_G71eVpcCtxB+rhCMQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: core: Allows to override the timeout value
 for ioctl() path
To:     Linus Walleij <linus.walleij@linaro.org>,
        Bean Huo <huobean@gmail.com>
Cc:     adrian.hunter@intel.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, beanhuo@micron.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Apr 2022 at 22:15, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Mon, Apr 25, 2022 at 10:02 PM Bean Huo <huobean@gmail.com> wrote:
>
> > I think the current solution is the most flexible way, if the customer
> > wants to override the kernel default timeout, they know how to initiate
> > the correct timeout value in ioctl() based on their specific
> > hardware/software system. I don't know how to convince every maintainer
> > and reviewer if we don't want to give this permission or want to
> > maintain a unified timeout value in the kernel driver. Given that we
> > already have eMMC ioctl() support, and we've opened the door to allow
> > users to specify specific cmd_timeout_ms in struct mmc_ioc_cmd{},
> > please consider my change.
>
> The patch is fine, I'm just saying we should put another patch on
> top that defines a RPMB default timeout and set it to something
> high, such as a minute.

I am also okay with $subject patch - and I agree with you Linus, that
it sounds reasonable to pick something specific for RPMB. I guess the
question is rather what value to pick, but I guess Bean can have some
ideas for that, at least for Micron eMMCs. BTW, we do something very
similar for mmc_sanitize() already.

Kind regards
Uffe
