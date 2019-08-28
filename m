Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AF2A017B
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfH1MUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbfH1MUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 08:20:37 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2B155859E
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 12:20:36 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id m30so1562472eda.11
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 05:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdH1GkwHzd4V3Un7iWCji7Bvc2KPgsbgbEWrgbKOEAI=;
        b=D1/ZzXSfR0DuWNvjkBVJFZ40IJWAUY6QbQx1Vypn+aETUNAxVh7irEexEhhHyT99gc
         1Dp06rfFHxL+pmgex4/y7ylMwDqnzO0xkv6Hd2my1XgX8mo7gtakNPpcMj7fDuSQ6Ho3
         HpmzHnsv6b8f3pAYNMZK95SinbwcQCCwkzT1fRMprAPgBXqj305oLxzMSsHuTSIkpcUs
         ycgkKIhBGeLD8FQt5iLTkNkQK/BobtPv1qTK31pDFooz4EX3Q0Q/Lp5AMrXExdWOz37x
         yY1JyTsH7J1HH+yE1WfaCsw++kKBLbmCc/EkRlfZ7dUWKm0DAys9q0VupUpquUG6RxB/
         N42A==
X-Gm-Message-State: APjAAAWLTlqy9onrOxlezn8YywXf1f08pCB6v5qwgp72yUch8ZDgM4Ir
        oLCm1isEQbcwVOqFXcu0zR2gU0BbaUSmPwh/PwqoMgGXJopgRhegUGdDHFDOic6JzkIaEnL7YST
        Qwz7Tgw9+gFuQGipX
X-Received: by 2002:a50:9736:: with SMTP id c51mr3720176edb.160.1566994835381;
        Wed, 28 Aug 2019 05:20:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyWukKyNCUZbK7qPi7GwQzbR3867OkLKr3tvczz/FIb+NgO92UjwVMmzr/2PMX1gqD8Ev3xgg==
X-Received: by 2002:a50:9736:: with SMTP id c51mr3720159edb.160.1566994835220;
        Wed, 28 Aug 2019 05:20:35 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id g20sm419835edp.92.2019.08.28.05.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2019 05:20:34 -0700 (PDT)
Subject: Re: [PATCH v2] gpiolib: acpi: Add
 gpiolib_acpi_run_edge_events_on_boot option and blacklist
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
References: <20190827202835.213456-1-hdegoede@redhat.com>
 <20190828113748.GK2680@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <005b954d-46ad-5e45-6a9c-0b1efe020b92@redhat.com>
Date:   Wed, 28 Aug 2019 14:20:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828113748.GK2680@smile.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 28-08-19 13:37, Andy Shevchenko wrote:
> On Tue, Aug 27, 2019 at 10:28:35PM +0200, Hans de Goede wrote:
>> Another day; another DSDT bug we need to workaround...
>>
>> Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
>> at least once on boot") we call _AEI edge handlers at boot.
>>
>> In some rare cases this causes problems. One example of this is the Minix
>> Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
>> and pasted code for dealing with Micro USB-B connector host/device role
>> switching, while the mini PC does not even have a micro-USB connector.
>> This code, which should not be there, messes with the DDC data pin from
>> the HDMI connector (switching it to GPIO mode) breaking HDMI support.
>>
>> To avoid problems like this, this commit adds a new
>> gpiolib_acpi.run_edge_events_on_boot kernel commandline option, which
>> allows disabling the running of _AEI edge event handlers at boot.
>>
>> The default value is -1/auto which uses a DMI based blacklist, the initial
>> version of this blacklist contains the Neo Z83-4 fixing the HDMI breakage.
> 
> Thank you!
> 
> Assuming it works for Ian,
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Note I have access to a Minix Neo Z83-4 myself now and I did test that
this fixes it and that passing gpiolib_acpi.run_edge_events_on_boot=0
breaks HDMI again (so the option works).

Regards,

Hans


> 
>>
>> Cc: stable@vger.kernel.org
>> Cc: Daniel Drake <drake@endlessm.com>
>> Cc: Ian W MORRISON <ianwmorrison@gmail.com>
>> Reported-by: Ian W MORRISON <ianwmorrison@gmail.com>
>> Suggested-by: Ian W MORRISON <ianwmorrison@gmail.com>
>> Fixes: ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Use a module_param instead of __setup
>> - Do DMI check only once from a postcore_initcall
>> ---
>>   drivers/gpio/gpiolib-acpi.c | 42 +++++++++++++++++++++++++++++++++----
>>   1 file changed, 38 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
>> index 39f2f9035c11..bda28eb82c3f 100644
>> --- a/drivers/gpio/gpiolib-acpi.c
>> +++ b/drivers/gpio/gpiolib-acpi.c
>> @@ -7,6 +7,7 @@
>>    *          Mika Westerberg <mika.westerberg@linux.intel.com>
>>    */
>>   
>> +#include <linux/dmi.h>
>>   #include <linux/errno.h>
>>   #include <linux/gpio/consumer.h>
>>   #include <linux/gpio/driver.h>
>> @@ -19,6 +20,11 @@
>>   
>>   #include "gpiolib.h"
>>   
>> +static int run_edge_events_on_boot = -1;
>> +module_param(run_edge_events_on_boot, int, 0444);
>> +MODULE_PARM_DESC(run_edge_events_on_boot,
>> +		 "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
>> +
>>   /**
>>    * struct acpi_gpio_event - ACPI GPIO event handler data
>>    *
>> @@ -170,10 +176,13 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
>>   	event->irq_requested = true;
>>   
>>   	/* Make sure we trigger the initial state of edge-triggered IRQs */
>> -	value = gpiod_get_raw_value_cansleep(event->desc);
>> -	if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
>> -	    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
>> -		event->handler(event->irq, event);
>> +	if (run_edge_events_on_boot &&
>> +	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
>> +		value = gpiod_get_raw_value_cansleep(event->desc);
>> +		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
>> +		    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
>> +			event->handler(event->irq, event);
>> +	}
>>   }
>>   
>>   static void acpi_gpiochip_request_irqs(struct acpi_gpio_chip *acpi_gpio)
>> @@ -1283,3 +1292,28 @@ static int acpi_gpio_handle_deferred_request_irqs(void)
>>   }
>>   /* We must use _sync so that this runs after the first deferred_probe run */
>>   late_initcall_sync(acpi_gpio_handle_deferred_request_irqs);
>> +
>> +static const struct dmi_system_id run_edge_events_on_boot_blacklist[] = {
>> +	{
>> +		.matches = {
>> +			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
>> +			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
>> +		}
>> +	},
>> +	{} /* Terminating entry */
>> +};
>> +
>> +static int acpi_gpio_setup_params(void)
>> +{
>> +	if (run_edge_events_on_boot < 0) {
>> +		if (dmi_check_system(run_edge_events_on_boot_blacklist))
>> +			run_edge_events_on_boot = 0;
>> +		else
>> +			run_edge_events_on_boot = 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* Directly after dmi_setup() which runs as core_initcall() */
>> +postcore_initcall(acpi_gpio_setup_params);
>> -- 
>> 2.23.0
>>
> 
