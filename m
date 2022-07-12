Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C231157156B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiGLJN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGLJNx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:13:53 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E7533354;
        Tue, 12 Jul 2022 02:13:52 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n18so11179508lfq.1;
        Tue, 12 Jul 2022 02:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XE4JnhtsX+9bRSJhafx+QlBOIlHNZ8nXGn9GMY6ZGvU=;
        b=fgzBI7tmy8Cb6oUEPpfkpvoea/PU5XC7pGYQSEbWgr04jQoGrZbCjCZax6kpCp75md
         ZaoBwmfWoCuCFOXaR4k/QHlsLstZm7qflsq+Ca9y+Jgb0vr/3R3utOpkquNp+D2Y3cBh
         rZB5SpBNJrXLGm/NYqcEOUyJGcFjbE45vYYkIEeI0AFRtsy4M6gTMHAmyYVdEGWAhW6M
         4NccffhC7JgEq7l99JCVoU9LOcOOaeqlXF0KDR6jOOKv++79o1bKCM8LQHHouAD3ELRp
         rqfeU0oiICFHyG2tiVP0UnUPo8FMmL1Oe7g1JRsHxWrL0aaVEv2wqM+KmgQ3PWm/tbHK
         OtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XE4JnhtsX+9bRSJhafx+QlBOIlHNZ8nXGn9GMY6ZGvU=;
        b=ast8euF8uy/aYclWKyZV3/jR8JVuepN6WX9UsF+gbzQjawP7FfnfsOgum/wVzKkhrT
         f4t+g9BTfUIYGk7tRFt6BUgMNga12jYI2ka0/TukcI/IyAowmehjDpJgalUw2WEf/OUO
         cO9HZHxJxoJG9fxI2lrGcGl+dT4gkFTffBrTII5JSyHNerixNhT2eSpmBvRJZallvzVw
         h3kHsoLlHYE9IJnPp2jowZ8GmahFOtDXmbL8HPaOimO2QG8smdVdMUfey/+vmK4bajZ/
         e7nBQMyWbpNCbDtoXQQswmd/+bCKyFplliGdcNXz1Ej1l5+yrlaATCFsl08mwAdCmEzC
         iuMg==
X-Gm-Message-State: AJIora9+UMBXFKK/pc9vXJtsIF4nPlDG+fTS9zS7savyg2lqwukxDv3a
        ckFO0OoMpqpouAvvCVynLc3MuAcxdHFDN6pM2pE=
X-Google-Smtp-Source: AGRyM1ujIrpTXlHRVeL1sEk9M68DIgjXlavfWyRNERd8qdnleE1cNRbRkOgVk8bBzRogNd0Knv27++LNA8MziaZ1FU8=
X-Received: by 2002:a05:6512:3183:b0:47f:79f3:af9a with SMTP id
 i3-20020a056512318300b0047f79f3af9amr13953057lfe.182.1657617230889; Tue, 12
 Jul 2022 02:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220711173418.91709-1-brgl@bgdev.pl> <20220712023714.GA9406@sol>
In-Reply-To: <20220712023714.GA9406@sol>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jul 2022 11:13:14 +0200
Message-ID: <CAHp75VcPaDq-3iL+3NpnYrOoLEX06HKX+tAhbP=P35jZ5NUuGQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: sim: fix the chip_name configfs item
To:     Kent Gibson <warthog618@gmail.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
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

On Tue, Jul 12, 2022 at 4:40 AM Kent Gibson <warthog618@gmail.com> wrote:
> On Mon, Jul 11, 2022 at 07:34:18PM +0200, Bartosz Golaszewski wrote:

...

> Not totally convinced by Andy's suggestion to rename swnode to fwnode.
> Variables should be named for what they represent, not their type, and
> you use swnode extensively elsewhere in the module, so either change it
> everywhere or not at all, and such a sweeping change is beyond the scope
> this patch.

Ah, I agree that consistency has higher priority here.

-- 
With Best Regards,
Andy Shevchenko
