Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018C933C562
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 19:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhCOSTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 14:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhCOSTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 14:19:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B022C06174A;
        Mon, 15 Mar 2021 11:18:59 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id r16so5794279pfh.10;
        Mon, 15 Mar 2021 11:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8KjN7BvbJBB4Xq70O198nwg/n4ypQbS+m7yJFiOEWQ=;
        b=gwpZSgZX0Epe+8nbtIpyQ2tgzt6FMVjwLtRVQ74e2t6U7QF+lwd//gTzl5cgIiHfIL
         rF5ACZx9xruq9D4MzklX16Me8jHlpnP3fYD39y99CjwYfmzsliZCFya1HytK1nAgRxYk
         ktY/9oAiAXBMyMt584EosLI6CbcAl3xbfNFqpeVlZGWXvMEuLS4tSxxnI2fErj2Xa66i
         oQsD/bk2qGtzz/BGubwddmNmCrU4BoNQUVVGM827E7z9Hpg3OA1OWY+biHDLKX6T5AP7
         +1PGyMOC8CFTA8LV5865Br1SqM+2sGmQm+TpZhX4mhaTg4UUVFYrjSwsA4ZUgS0LUw1c
         IE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8KjN7BvbJBB4Xq70O198nwg/n4ypQbS+m7yJFiOEWQ=;
        b=S1lx7YA5AJcznHoLvagK/WgwrboA1HcuWUImoGAnOHuuOZqZ5z2yuItTjF8M6Lkakw
         cGubj+N4VDLpTZdkt/2dKbxlGqe0+PcfJfgLQGf2KIzRvHZQ1SgSLv1/cTHt3lC6RQWB
         MVck3WslJdnnCRDT9N3kCyCWDcRvtbs3PUMkUseF9yfsbzug+cKilg+zWiFB5HCerf1o
         ey4TqRo0/7F9S6qBCfb0e8fyrTulhQMHq1xGcMmqpmfDPoaJCbOjLHqRPSDaQe9ZoLQR
         AcVY95Sc1aUCs3LuRjWuA/OWdQ+FD3MmJmOQUyfTjJcPq1XIIWwNw+N8IBam3XWpRI16
         FPUg==
X-Gm-Message-State: AOAM530YoaryXeYx931pTHEBvQLLdZrIdqtRl4Tjsi7RIkR+tYOCZmKG
        xbYouQxbecxkAXz7VIPPCLd+FOEOWcXq/7+aKQ0=
X-Google-Smtp-Source: ABdhPJxr0Mw50JiZmPtASt1ryjlfNQ61J5A233fEgj8VzkAkx83REKYYG7B9JCIjmR0sRhVFdLUbvjBUZ4DxuyAx1cY=
X-Received: by 2002:a63:ce15:: with SMTP id y21mr384404pgf.4.1615832338992;
 Mon, 15 Mar 2021 11:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210315135541.921894249@linuxfoundation.org> <20210315135544.659848571@linuxfoundation.org>
 <6abd9dd3-e14b-f690-f967-15fb58dffae8@denx.de>
In-Reply-To: <6abd9dd3-e14b-f690-f967-15fb58dffae8@denx.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 15 Mar 2021 20:18:43 +0200
Message-ID: <CAHp75VePHxAXHVJ974dXv6PnCbZhTTksY+-_moEZUzUzkFKE=Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 081/290] gpiolib: Read "gpio-line-names" from a
 firmware node
To:     Marek Vasut <marex@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Roman Guskov <rguskov@dh-electronics.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 5:05 PM Marek Vasut <marex@denx.de> wrote:
>
> On 3/15/21 2:52 PM, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >
> > commit b41ba2ec54a70908067034f139aa23d0dd2985ce upstream.
> >
> > On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
> > see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
> > pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
> > and iterates over all of its DT subnodes when registering each GPIO
> > bank gpiochip. Each gpiochip has:
> >
> >    - gpio_chip.parent = dev,
> >      where dev is the device node of the pin controller
> >    - gpio_chip.of_node = np,
> >      which is the OF node of the GPIO bank
> >
> > Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
> > i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.
> >
> > The original code behaved correctly, as it extracted the "gpio-line-names"
> > from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.
> >
> > To achieve the same behaviour, read property from the firmware node.
>
> There seem to be some discussion going on around this patch, so please
> postpone backporting until that is settled. Same for v5.11 backport. I
> hope Andy/Bartosz agrees ?

No need to postpone. The fix will be somewhere else, though inside gpiolib.c.

-- 
With Best Regards,
Andy Shevchenko
