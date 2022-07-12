Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B05571570
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 11:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiGLJPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 05:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiGLJPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 05:15:01 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F03537F82;
        Tue, 12 Jul 2022 02:15:00 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t25so12894369lfg.7;
        Tue, 12 Jul 2022 02:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7dJBg9LfnofgHy6ilpqchRetbtEZkPv+AKVAP45NFCo=;
        b=EQlz5Lplp1HgN4bVm90otjod7REHApUJ/Bgf60gHtsysuTPq9ehNegy42naHnCJwGg
         OZi38SGg28hVF2EJTbz9umxAsENo/grt3QU8SQ5nSheMt/g+V6DSCe7fo8VJTv+u2LNs
         XWwZ5XihCKiuT4sV+GGGxOkbx4V3ppshvovK+0Xd1Wyw0RokFcT+B4J2W8yi+5YTQLPa
         e1GaGZKLCt4MDxlhEwA8aytF8c1mQEkG8rVw0E4gRoijZlJLAvpz3ENvEiMWA1Hjk3l6
         zSxqhjbJp3gEMKLi9megxBc9HTcu54+qLN+3g1wcIlxrl1H+PFG8IYaOvbYsYBCx4654
         1acg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7dJBg9LfnofgHy6ilpqchRetbtEZkPv+AKVAP45NFCo=;
        b=JlD3kmmQ0xZ/7c+pyPrGfeIKqsabWSNFoDUj64oJHnlZaDXxxaqRZpzpVMWPQR83oa
         mUWl6Ebz7apYmgfNzubfDLSHoI3BwV8+VpIpKmoEv2CWmjZOmL1PExoBVSAf/qHV0C/Y
         8i9KpGwFIvm+479vLbqya21YFqMsPIsMKlcFqWTcw3Qy2sw2+rURTJEjAH0uiXcsSY9S
         HQWbZrtUsH6ZIsygr51BxLaR2ERlBmY7Wvr6EmOCAgUPBc2vI+BJGFmNyQXcIavGaqsO
         DGHA3Kpck9GFA/juynLl5tAktuqQthilR1BprT13G0ec/ccAC9bsGZoXl8lTtma63Z6r
         /cRA==
X-Gm-Message-State: AJIora+zpvys2zkA5ThzN8kFBB9MLUZxuyiOxDjlAuDpA78NOfIEcT0Y
        ZqZJEwk9vvfKH0LUMvcCx2zmYBZdQUYqchfPH+NGhEpeA2ixsA==
X-Google-Smtp-Source: AGRyM1tLHDQVyhND/WjqFxauc7FSgxBOMlNB6TthUBvoulmqIDIORuUfU3yX4w4mI3mKkUXSuJRG0bzcoBuz8LHvpzE=
X-Received: by 2002:a05:6512:3ca4:b0:489:d112:569a with SMTP id
 h36-20020a0565123ca400b00489d112569amr8363512lfv.207.1657617298692; Tue, 12
 Jul 2022 02:14:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220712074055.10588-1-brgl@bgdev.pl>
In-Reply-To: <20220712074055.10588-1-brgl@bgdev.pl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 12 Jul 2022 11:14:22 +0200
Message-ID: <CAHp75VdAidZxorVKvUfsc8fnNK19k2TpoTTJUXJpBo+wnALAWw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: sim: fix the chip_name configfs item
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

On Tue, Jul 12, 2022 at 9:46 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>
> The chip_name configs attribute always displays the device name of the
> first GPIO bank because the logic of the relevant function is simply
> wrong.
>
> Fix it by correctly comparing the bank's swnode against the GPIO
> device's children.

Taking into account that name swnode is used in other places in the
code, I'm fine with this version,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: cb8c474e79be ("gpio: sim: new testing module")
> Cc: stable@vger.kernel.org
> Reported-by: Kent Gibson <warthog618@gmail.com>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> ---
> v1 -> v2:
> - use device_match_fwnode for shorter code
>
>  drivers/gpio/gpio-sim.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
> index 98109839102f..1020c2feb249 100644
> --- a/drivers/gpio/gpio-sim.c
> +++ b/drivers/gpio/gpio-sim.c
> @@ -991,28 +991,22 @@ static struct configfs_attribute *gpio_sim_device_config_attrs[] = {
>  };
>
>  struct gpio_sim_chip_name_ctx {
> -       struct gpio_sim_device *dev;
> +       struct fwnode_handle *swnode;
>         char *page;
>  };
>
>  static int gpio_sim_emit_chip_name(struct device *dev, void *data)
>  {
>         struct gpio_sim_chip_name_ctx *ctx = data;
> -       struct fwnode_handle *swnode;
> -       struct gpio_sim_bank *bank;
>
>         /* This would be the sysfs device exported in /sys/class/gpio. */
>         if (dev->class)
>                 return 0;
>
> -       swnode = dev_fwnode(dev);
> +       if (device_match_fwnode(dev, ctx->swnode))
> +               return sprintf(ctx->page, "%s\n", dev_name(dev));
>
> -       list_for_each_entry(bank, &ctx->dev->bank_list, siblings) {
> -               if (bank->swnode == swnode)
> -                       return sprintf(ctx->page, "%s\n", dev_name(dev));
> -       }
> -
> -       return -ENODATA;
> +       return 0;
>  }
>
>  static ssize_t gpio_sim_bank_config_chip_name_show(struct config_item *item,
> @@ -1020,7 +1014,7 @@ static ssize_t gpio_sim_bank_config_chip_name_show(struct config_item *item,
>  {
>         struct gpio_sim_bank *bank = to_gpio_sim_bank(item);
>         struct gpio_sim_device *dev = gpio_sim_bank_get_device(bank);
> -       struct gpio_sim_chip_name_ctx ctx = { dev, page };
> +       struct gpio_sim_chip_name_ctx ctx = { bank->swnode, page };
>         int ret;
>
>         mutex_lock(&dev->lock);
> --
> 2.34.1
>


-- 
With Best Regards,
Andy Shevchenko
