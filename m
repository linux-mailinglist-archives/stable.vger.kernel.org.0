Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B3537F368
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 09:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhEMHKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 03:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhEMHKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 03:10:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEABC061574;
        Thu, 13 May 2021 00:08:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m124so20444318pgm.13;
        Thu, 13 May 2021 00:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJ3oi7BPr8I9au64jvD9eucKXrMf5nsxv7LhNFTYzRw=;
        b=o/5pStFlSTEpqU4QxBwJY7EQPGmGNTqtlPfuxTf2XSFhJZWYjbFoYXxKz1uZuaw+4g
         8EViSwrQ7W0+vU6NFDeFsme4eYzbTqV973LevU6RHLvVlV0DGQHHtXcr8uMDyAQG4810
         oB3N/mkWwQuAf8oB5nW7xqwlPiY4zmDqFcfRhL/Mrj8L8Qgu07Sp4fde3zKNtvoxv9oi
         SSAku0kQUT6Cj1w0I2zL8ArjDsd9zGPvIovHb+RrrPqwb44TXl3ActaaY2A50ZHmjGZT
         u91JKQnK1c9LFsh0U/Sxe69GhAuLIIHXHO6ZTgocZ/cSPIPPqWxZKm7X9HsWYJVqxT/L
         HSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJ3oi7BPr8I9au64jvD9eucKXrMf5nsxv7LhNFTYzRw=;
        b=QDW0hv5J4GfdOmgDZB0SpKOvAIFndx+MUS3qqKDzRR02MJr9u85aBmS+Ymd7jFewPa
         wACI2sb9CQnSncH7IasqhZFu7p0ZK08nqmE3y8r0dGM0xE9fGKUCzGGJK4CvXT3Ww98w
         PazpbJic61SCsG7vkNlRg3980AGW01JyqKsYYPjMZg+CxRodjJltp0VQtGy146kFUjAz
         mBXcestw29flx4EyaRZ+CmqyJSIbMmqPOay8U8AD87BiRaO0r1zWokJj/UhpWa7VPm72
         lI1jxTVNbsp9NRNXYM7vWlOnv8Eo8SHnuGCkdZ6dGds3Gw+srnakam3cHlwjvh8wwZkq
         CjHA==
X-Gm-Message-State: AOAM532cJSIDTx2gNiSHnavJgTivYcxdVDUAg5hA9otiICB9jGQ3d0AW
        YI1BXcLP9/Vxj08O1deMPcA9XHhi8A8eyIkViEE=
X-Google-Smtp-Source: ABdhPJxbjjdNWoaWhrFZ17IYKr8uzwbg3haQSlAmm9anUhYKzzov7tvNp7bPzxzoc7B6WS7DCg59XBGoB2eeHlBmdmE=
X-Received: by 2002:aa7:8e85:0:b029:28f:2620:957e with SMTP id
 a5-20020aa78e850000b029028f2620957emr39936678pfr.40.1620889729317; Thu, 13
 May 2021 00:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210512210413.1982933-1-luzmaximilian@gmail.com>
In-Reply-To: <20210512210413.1982933-1-luzmaximilian@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 13 May 2021 10:08:33 +0300
Message-ID: <CAHp75VczB-+Qs9-7Ye3qXZBag8_Ho4E3oTywGu2eNY67s3K00w@mail.gmail.com>
Subject: Re: [PATCH] serial: 8250_dw: Add device HID for new AMD UART controller
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, stable@vger.kernel.org,
        Sachi King <nakato@nakato.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 1:20 AM Maximilian Luz <luzmaximilian@gmail.com> wrote:
>
> Add device HID AMDI0022 to the AMD UART controller driver match table
> and create a platform device for it. This controller can be found on
> Microsoft Surface Laptop 4 devices and seems similar enough that we can
> just copy the existing AMDI0020 entries.

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com> # for 8250_dw part

> Cc: <stable@vger.kernel.org> # 5.10+
> Tested-by: Sachi King <nakato@nakato.io>
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
> ---
>  drivers/acpi/acpi_apd.c           | 1 +
>  drivers/tty/serial/8250/8250_dw.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
> index 0ec5b3f69112..6e02448d15d9 100644
> --- a/drivers/acpi/acpi_apd.c
> +++ b/drivers/acpi/acpi_apd.c
> @@ -226,6 +226,7 @@ static const struct acpi_device_id acpi_apd_device_ids[] = {
>         { "AMDI0010", APD_ADDR(wt_i2c_desc) },
>         { "AMD0020", APD_ADDR(cz_uart_desc) },
>         { "AMDI0020", APD_ADDR(cz_uart_desc) },
> +       { "AMDI0022", APD_ADDR(cz_uart_desc) },
>         { "AMD0030", },
>         { "AMD0040", APD_ADDR(fch_misc_desc)},
>         { "HYGO0010", APD_ADDR(wt_i2c_desc) },
> diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
> index 9e204f9b799a..a3a0154da567 100644
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -714,6 +714,7 @@ static const struct acpi_device_id dw8250_acpi_match[] = {
>         { "APMC0D08", 0},
>         { "AMD0020", 0 },
>         { "AMDI0020", 0 },
> +       { "AMDI0022", 0 },
>         { "BRCM2032", 0 },
>         { "HISI0031", 0 },
>         { },
> --
> 2.31.1
>


-- 
With Best Regards,
Andy Shevchenko
