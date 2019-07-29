Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4D79A60
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfG2Uy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:54:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45302 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfG2Uy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 16:54:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so63296312wre.12;
        Mon, 29 Jul 2019 13:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dGV+VgnJbJAnGDX/51DW9mvgG9yE3L7k/29WtRT7Q9E=;
        b=veizmoYv1cU+nDu6mCN/WCsFjQZ+mj85Gcb8ML4d/y+zQY1xhdTf5rEEolQzHYR5CY
         /DO4akfCOVk7d2MYUWvnyHCNnU9IzzDDtKZXwgl7H8ICD6PDzU4lrRZctPEfgZajzUQ/
         xdbRdg+/V9kauxEelwXmyj1ZGJme/NiRW31hhFy5qAZNzUbnzppuCoMan1PkqjHXTudT
         pglvphAujWgjtNxwzjD5vV9UloThHiuB65o3f7YE0YWRvtq2C891+/D/4BrEOUJ8e23B
         AMlW2Q2+bZbRbLQptXx9F7OID9RwB2Xi2FPxXz93a5Qs8/FG7YLVJ5FRHb+2su/aymk4
         XGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dGV+VgnJbJAnGDX/51DW9mvgG9yE3L7k/29WtRT7Q9E=;
        b=j2BBgaCHNjDscYudcJLQZDph5dgujbl1YCs/QAtDcfy/W655XNb1aRZtjYcsWbAhCE
         ypNJcR82CzfDtgyI/U2mLlTiBlCYt33tHu+aiKcGFPNVF3urYJF9ZEzqGielZbqlNPyM
         Rt00qNCOY+0A4F8LM+nh5fVBxy5VQxo8wHLCC/2Q6+Ac32xUB6SYSnWdovPHx9+56WsI
         oSSDD3Dney/yp6dVAXHj6SJ9a1AAekFhSB+BWvG5DCiNdTaa7BdN3qlcMq85L6rcK1J0
         tPjMYoFq5owE/aqurKoAnAL8/mQDrGnO4i8O++HRbdJuhIkNND0KARVTNJgd4bwqm/Te
         dsKg==
X-Gm-Message-State: APjAAAXJWk8MSw6L/8Q47gPXcGxwcPYsAhtF+Dnh0MQ5F5XC1dJ7qUvT
        L9YZBEkC48oiMOD4XyHvsHc=
X-Google-Smtp-Source: APXvYqw1rwm6Wsr1Pfo+JzROn4IRfK5FXYDymkOjazFc9LWtIkOIQiZYx9IOsn5azOllGbN4OF06Fw==
X-Received: by 2002:a5d:5644:: with SMTP id j4mr41129290wrw.144.1564433694694;
        Mon, 29 Jul 2019 13:54:54 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id v65sm69115514wme.31.2019.07.29.13.54.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 13:54:54 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:54:52 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>,
        andy.shevchenko@gmail.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        egranata@chromium.org, egranata@google.com,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-acpi@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] driver core: platform: return -ENXIO for missing GpioInt
Message-ID: <20190729205452.GA22785@archlinux-threadripper>
References: <20190729204954.25510-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729204954.25510-1-briannorris@chromium.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 01:49:54PM -0700, Brian Norris wrote:
> Commit daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in
> platform_get_irq()") broke the Embedded Controller driver on most LPC
> Chromebooks (i.e., most x86 Chromebooks), because cros_ec_lpc expects
> platform_get_irq() to return -ENXIO for non-existent IRQs.
> Unfortunately, acpi_dev_gpio_irq_get() doesn't follow this convention
> and returns -ENOENT instead. So we get this error from cros_ec_lpc:
> 
>    couldn't retrieve IRQ number (-2)
> 
> I see a variety of drivers that treat -ENXIO specially, so rather than
> fix all of them, let's fix up the API to restore its previous behavior.
> 
> I reported this on v2 of this patch:
> 
> https://lore.kernel.org/lkml/20190220180538.GA42642@google.com/
> 
> but apparently the patch had already been merged before v3 got sent out:
> 
> https://lore.kernel.org/lkml/20190221193429.161300-1-egranata@chromium.org/
> 
> and the result is that the bug landed and remains unfixed.
> 
> I differ from the v3 patch by:
>  * allowing for ret==0, even though acpi_dev_gpio_irq_get() specifically
>    documents (and enforces) that 0 is not a valid return value (noted on
>    the v3 review)
>  * adding a small comment
> 
> Reported-by: Brian Norris <briannorris@chromium.org>
> Reported-by: Salvatore Bellizzi <salvatore.bellizzi@linux.seppia.net>
> Cc: Enrico Granata <egranata@chromium.org>
> Cc: <stable@vger.kernel.org>
> Fixes: daaef255dc96 ("driver: platform: Support parsing GpioInt 0 in platform_get_irq()")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> Side note: it might have helped alleviate some of this pain if there
> were email notifications to the mailing list when a patch gets applied.
> I didn't realize (and I'm not sure if Enrico did) that v2 was already
> merged by the time I noted its mistakes. If I had known, I would have
> suggested a follow-up patch, not a v3.

I've found this to be fairly reliable for getting notified when
something gets applied if it is a tree that shows up in -next.

https://www.kernel.org/get-notifications-for-your-patches.html

Cheers,
Nathan
