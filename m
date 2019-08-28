Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0344A017E
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfH1MV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbfH1MV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 08:21:29 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 81D25C057F88
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 12:21:28 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id m30so1564357eda.11
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 05:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pFwT3MczVz0uzEr5z1eNeQGMrxBuPaHwi2jIUSF3DYw=;
        b=q97hiUDnAwDu6p1mtijWf5ckGJ8ckqqXEWmudMmHHMphKSNtXq7U2DMqU9iJbGqR9n
         t6UHks5dE0GRGRADR9Nr22RMqNeHP5lewhSHUOS7ThliInKIJHbtsLIMwMZnxNHK/dbj
         HDHNuaBP72zOrc5g8Ts0Dm96/7xyWC+7cv7MruxGNPW7mIpUYp9H9o+/1GLXuiqxK+xI
         IPZQYb9V7r0QT8Fp0/E+xKkhmvJu2j1HhPyuBT84oUCMAO9CoQqS0ALs31g/LW4etcDd
         LrqJnsgHLVQovYSa7lbz5yORzB1/SnYIHEfzxzem7VwXflRKod9qhk7m2IOL1ZMcMmkm
         rpmA==
X-Gm-Message-State: APjAAAXFVkjGpfdlv+fi42tbxWV1eGFBVAGQFxkG2iBkC7EHyVsDgDsI
        aMpPihFhBY0otxpCAYJSh3nGkdVxGV9BRNa9rgOgCv/vqrXFIEV03/4IECRu2Jd6e3OL3Pj+o75
        4/POd1wcH51Obzg6i
X-Received: by 2002:a50:b165:: with SMTP id l34mr3669768edd.179.1566994887261;
        Wed, 28 Aug 2019 05:21:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxluKTYQWj67XWD8VFMLEPjzWhXpX6fsNT/j5tTVmlbY2uAsI4n2i4ld3hTVQwF28OBuxOQtw==
X-Received: by 2002:a50:b165:: with SMTP id l34mr3669749edd.179.1566994887097;
        Wed, 28 Aug 2019 05:21:27 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id k15sm359958ejk.46.2019.08.28.05.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2019 05:21:26 -0700 (PDT)
Subject: Re: [PATCH v2] gpiolib: acpi: Add
 gpiolib_acpi_run_edge_events_on_boot option and blacklist
From:   Hans de Goede <hdegoede@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
References: <20190827202835.213456-1-hdegoede@redhat.com>
 <20190828113748.GK2680@smile.fi.intel.com>
 <005b954d-46ad-5e45-6a9c-0b1efe020b92@redhat.com>
Message-ID: <c07a8e2e-61a7-7ce7-4f73-48978be98d27@redhat.com>
Date:   Wed, 28 Aug 2019 14:21:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <005b954d-46ad-5e45-6a9c-0b1efe020b92@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 28-08-19 14:20, Hans de Goede wrote:
> Hi,
> 
> On 28-08-19 13:37, Andy Shevchenko wrote:
>> On Tue, Aug 27, 2019 at 10:28:35PM +0200, Hans de Goede wrote:
>>> Another day; another DSDT bug we need to workaround...
>>>
>>> Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
>>> at least once on boot") we call _AEI edge handlers at boot.
>>>
>>> In some rare cases this causes problems. One example of this is the Minix
>>> Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
>>> and pasted code for dealing with Micro USB-B connector host/device role
>>> switching, while the mini PC does not even have a micro-USB connector.
>>> This code, which should not be there, messes with the DDC data pin from
>>> the HDMI connector (switching it to GPIO mode) breaking HDMI support.
>>>
>>> To avoid problems like this, this commit adds a new
>>> gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
>>> allows disabling the running of _AEI edge event handlers at boot.
>>>
>>> The default value is -1/auto which uses a DMI based blacklist, the initial
>>> version of this blacklist contains the Neo Z83-4 fixing the HDMI breakage.
>>
>> Thank you!
>>
>> Assuming it works for Ian,
>> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Note I have access to a Minix Neo Z83-4 myself now and I did test that
> this fixes it and that passing gpiolib_acpi.run_edge_events_on_boot=0
> breaks HDMI again (so the option works).

Erm that should be gpiolib_acpi.run_edge_events_on_boot=1 (not 0) breaks
HDMI.

Regards,

Hans



>>> Cc: stable@vger.kernel.org
>>> Cc: Daniel Drake <drake@endlessm.com>
>>> Cc: Ian W MORRISON <ianwmorrison@gmail.com>
>>> Reported-by: Ian W MORRISON <ianwmorrison@gmail.com>
>>> Suggested-by: Ian W MORRISON <ianwmorrison@gmail.com>
>>> Fixes: ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>> Changes in v2:
>>> - Use a module_param instead of __setup
>>> - Do DMI check only once from a postcore_initcall
>>> ---
>>>   drivers/gpio/gpiolib-acpi.c | 42 +++++++++++++++++++++++++++++++++----
>>>   1 file changed, 38 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
>>> index 39f2f9035c11..bda28eb82c3f 100644
>>> --- a/drivers/gpio/gpiolib-acpi.c
>>> +++ b/drivers/gpio/gpiolib-acpi.c
>>> @@ -7,6 +7,7 @@
>>>    *          Mika Westerberg <mika.westerberg@linux.intel.com>
>>>    */
>>> +#include <linux/dmi.h>
>>>   #include <linux/errno.h>
>>>   #include <linux/gpio/consumer.h>
>>>   #include <linux/gpio/driver.h>
>>> @@ -19,6 +20,11 @@
>>>   #include "gpiolib.h"
>>> +static int run_edge_events_on_boot = -1;
>>> +module_param(run_edge_events_on_boot, int, 0444);
>>> +MODULE_PARM_DESC(run_edge_events_on_boot,
>>> +         "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
>>> +
>>>   /**
>>>    * struct acpi_gpio_event - ACPI GPIO event handler data
>>>    *
>>> @@ -170,10 +176,13 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
>>>       event->irq_requested = true;
>>>       /* Make sure we trigger the initial state of edge-triggered IRQs */
>>> -    value = gpiod_get_raw_value_cansleep(event->desc);
>>> -    if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
>>> -        ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
>>> -        event->handler(event->irq, event);
>>> +    if (run_edge_events_on_boot &&
>>> +        (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
>>> +        value = gpiod_get_raw_value_cansleep(event->desc);
>>> +        if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
>>> +            ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
>>> +            event->handler(event->irq, event);
>>> +    }
>>>   }
>>>   static void acpi_gpiochip_request_irqs(struct acpi_gpio_chip *acpi_gpio)
>>> @@ -1283,3 +1292,28 @@ static int acpi_gpio_handle_deferred_request_irqs(void)
>>>   }
>>>   /* We must use _sync so that this runs after the first deferred_probe run */
>>>   late_initcall_sync(acpi_gpio_handle_deferred_request_irqs);
>>> +
>>> +static const struct dmi_system_id run_edge_events_on_boot_blacklist[] = {
>>> +    {
>>> +        .matches = {
>>> +            DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
>>> +            DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
>>> +        }
>>> +    },
>>> +    {} /* Terminating entry */
>>> +};
>>> +
>>> +static int acpi_gpio_setup_params(void)
>>> +{
>>> +    if (run_edge_events_on_boot < 0) {
>>> +        if (dmi_check_system(run_edge_events_on_boot_blacklist))
>>> +            run_edge_events_on_boot = 0;
>>> +        else
>>> +            run_edge_events_on_boot = 1;
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +/* Directly after dmi_setup() which runs as core_initcall() */
>>> +postcore_initcall(acpi_gpio_setup_params);
>>> -- 
>>> 2.23.0
>>>
>>
