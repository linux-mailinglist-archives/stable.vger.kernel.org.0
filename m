Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6486570A24
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 20:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiGKSuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 14:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGKSuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 14:50:12 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA555925C;
        Mon, 11 Jul 2022 11:50:11 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 75so8925495ybf.4;
        Mon, 11 Jul 2022 11:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vdn+kWdlLc5kFjA8AyxY+9HV+a6I1ZLb2j4vBgodHP8=;
        b=nIgMnALMjfiydsKZpOyh42VUXRWOAA/5gVzOGa7gtA+X4nWqSPxmdtDpom+kUzCWrF
         O4fDJRhl6UeOvWYXY2pEPjirrKOBA164uZkjagVFqy6+Jp++N+xzmpaJMElIgLMFtXPz
         w558uImDA/tKjtwXQt1MwAFFub4t/mwUktfkNfWfI/r1pxh8EZFubxzgR7un1XuEOLQK
         TXC4OwXeLAF7ewc8NuAhyCWHk6/CHLPK2oIMk7YTvI+zaWNyK38UVC5FOmAx5RTm4ymh
         glCAIkcMQZg2z6Lm/NCARAa4q6EPVS5C0d7qUivmD+eu+c1by9KjkWM/B77rnxFC6XyX
         QHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vdn+kWdlLc5kFjA8AyxY+9HV+a6I1ZLb2j4vBgodHP8=;
        b=n6COzIheb3pK9/nYviTCjThvFkoL+zjAJVKR7GoACB8PuRadNyhe2OpMc9ssvqNIDL
         N86ofsfaHz3OAOzjUYSYNtEPGUQPn0vvG44TuOJ79H2QYBYMX1d/c416ip8Mhn5re1Rt
         i6zD3uCOirp1lRIVnPtCX5WboFF1o+GQWqXR29fUaxqkpHQ5Ux3e4YJlGBJUum6iinAz
         2EJVM2B44kG2sG71OcEMLLRdxYKJCnnAjhcHnFqKSSFRxzOmCGMVaRQ5BqxbfDBiBA/d
         t0MJqwmfGFWTEtQexunWe43aLHAaa9uK/L1Z7Xws1y1pB/ZFLEyGMwzQ/LOIhlVwJczv
         8A9w==
X-Gm-Message-State: AJIora8lnqQNoBWb9n7/rc7T5MF9ovGI0M6xeE1vOT5Sb4GeITDW2HN/
        KsqJ7QdyNQs3XCspCBQOf9aA1yq812WoZVFQX1Y=
X-Google-Smtp-Source: AGRyM1sBy72a4o+/lKFzYxMildRzLwg3ico+w5eERCzyniThfzFft8EK9iDR81O/wYjWDroQ60Sh1KHhDK+QzE3thmA=
X-Received: by 2002:a25:dd83:0:b0:66c:8d8d:4f5f with SMTP id
 u125-20020a25dd83000000b0066c8d8d4f5fmr19018621ybg.79.1657565410549; Mon, 11
 Jul 2022 11:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220711173418.91709-1-brgl@bgdev.pl>
In-Reply-To: <20220711173418.91709-1-brgl@bgdev.pl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 11 Jul 2022 20:49:34 +0200
Message-ID: <CAHp75VcHVJu2bX_qWKf84e2t=FrNRvsRLnEXirRKVPh=kZz=hQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: sim: fix the chip_name configfs item
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kent Gibson <warthog618@gmail.com>,
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

On Mon, Jul 11, 2022 at 7:35 PM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> The chip_name configs attribute always displays the device name of the
> first GPIO bank because the logic of the relevant function is simply
> wrong.
>
> Fix it by correctly comparing the bank's swnode against the GPIO
> device's children.
>
> Fixes: cb8c474e79be ("gpio: sim: new testing module")
> Cc: stable@vger.kernel.org
> Reported-by: Kent Gibson <warthog618@gmail.com>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>

...

>  struct gpio_sim_chip_name_ctx {
> -       struct gpio_sim_device *dev;
> +       struct fwnode_handle *swnode;

I would call it fwnode even if we know the backend provider.

>         char *page;
>  };

...

>         struct fwnode_handle *swnode;

Do you still need this? See below.

...

>         swnode = dev_fwnode(dev);
>
> +       if (swnode == ctx->swnode)
> +               return sprintf(ctx->page, "%s\n", dev_name(dev));

So, now it can be

if (device_match_fwnode(dev, ctx->fwnode))
  return sprintf(...);

-- 
With Best Regards,
Andy Shevchenko
