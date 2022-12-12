Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E48064A35A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 15:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiLLOa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 09:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiLLOa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 09:30:27 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F6412AC5
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 06:30:25 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id 124so11374693vsv.4
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 06:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U2Sl70StxkgITjnsDcQQNOj7ZeEYzAvq2G6yC0OXO/g=;
        b=KS4QU9NDMlTulLnjorjkUu6IRNLKiQS7S2GFn5EQgkY+boWUdl09+sU7dZcgUSBZEd
         mc+vCpRIA4x0jSZj3Vz2MxMsz4r683HMzrNzWko1dUezsY8jkm0qQh+0Nm2v1Pyu1OQ9
         pH33z/SyDQeSruSaHO5KyNie4w2PNO+yb4JVKQN/31mZ/OoakXWnEP7kz5UpqkOSXrMP
         C2nLS8bomkdTW7o1AHC+KqJDfqDfnlsCr0h+R/xLMteZf3pgvBLhQk/L22vRjncGATue
         k025GveFgyVWEguxCgPzB0ULQPksBfJtJgXIQyU9fTEhwJNEUy6KQuAw9RP5TyqLwxBb
         izZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U2Sl70StxkgITjnsDcQQNOj7ZeEYzAvq2G6yC0OXO/g=;
        b=MKzL9i1kUDnBHnGXZLbi0HqeFtTr8yd23jYBNZzbUBn6+hB0Qmdlg9YMJBG5fdEGHY
         j+ADzfUoKhrQ5HaHB5PYdZSAzlvLWMC1oqWid1QPEKFfzzRVCdGRLBSAHrjNMhEO33iE
         +E8cC/vfoGhPTgDWRKjTM9vDy4LU2QgOz7+g7aFJNlYLgZiIxmS+E/xlGebkH+cBN5vB
         Gznx5mccIYychwJmEW4cj2h5w0ne0ZzMN6dHl5sjmiD9TERnyldtLQJJ8t9mfRSfdMku
         /Q2DQEY434kUtT7dZQDt4SQPvZtRGRSPnqmb7shl9nO9jSoNmApM73JAYKLXUsDxDM5e
         N/Ig==
X-Gm-Message-State: ANoB5pnaX+FuFSBJ5CiCkFDxvwABq2GjDZ624MnSIBwR1wtL8uXfNS6M
        8EfH2BQtP2nScmp/c/PkxF/pivXeTcu/kMu4k091lg==
X-Google-Smtp-Source: AA0mqf6bml2soIr4eInLtks4Y+ThRZR/Fs/TvFAlImbNfEgbln2P+WWKIUzMBrAPDlx68B33sUGUcoJApEwthzyEgbY=
X-Received: by 2002:a05:6102:722:b0:3b0:eec8:ce04 with SMTP id
 u2-20020a056102072200b003b0eec8ce04mr20162668vsg.16.1670855424910; Mon, 12
 Dec 2022 06:30:24 -0800 (PST)
MIME-Version: 1.0
References: <20221212130926.811961601@linuxfoundation.org> <20221212130929.453689464@linuxfoundation.org>
In-Reply-To: <20221212130929.453689464@linuxfoundation.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 12 Dec 2022 15:30:14 +0100
Message-ID: <CAMRc=Mc5e6_1vLh0V97npZMSt0KSTnoFFTSAs0TZyJsbT5fDfw@mail.gmail.com>
Subject: Re: [PATCH 5.15 060/123] gpiolib: improve coding style for local variables
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 2:31 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Bartosz Golaszewski <brgl@bgdev.pl>
>
> [ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]
>
> Drop unneeded whitespaces and put the variables of the same type
> together for consistency with the rest of the code.
>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpio/gpiolib.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 320baed949ee..a87c4cd94f7a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
>                                struct lock_class_key *request_key)
>  {
>         struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
> -       unsigned long   flags;
> -       int             ret = 0;
> -       unsigned        i;
> -       int             base = gc->base;
>         struct gpio_device *gdev;
> +       unsigned long flags;
> +       int base = gc->base;
> +       unsigned int i;
> +       int ret = 0;
>
>         /*
>          * First: allocate and populate the internal stat container, and
> --
> 2.35.1
>
>
>

This isn't a fix, please drop it from stable.

Bartosz
