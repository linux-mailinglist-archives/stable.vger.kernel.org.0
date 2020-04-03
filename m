Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA519D9A1
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403831AbgDCPAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 11:00:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47643 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403795AbgDCPAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 11:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585926016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G+WR1RIU3atyxLTePnTCnN9yfP39JOx2oAtD6wBYsRo=;
        b=aPqExCWWcMASQ7JMbQO0FOBLiBnc56LBeybypGIsyiEbfBY4mlUUg7ZMQBcfqgb/jAs3P/
        neycdY7xM6v6tfO+Wlfj5jMpKRogwnYVEuoEmURNuamhG/xz3P7e5FHgMSK1Jq738y3/Wh
        d7BnvLBo2ODsEgoGF5pt4qkBrPOmy3g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-8bxRm5DvPjGv_d9qSvzEfw-1; Fri, 03 Apr 2020 11:00:14 -0400
X-MC-Unique: 8bxRm5DvPjGv_d9qSvzEfw-1
Received: by mail-wm1-f70.google.com with SMTP id 2so2877282wmf.1
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 08:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G+WR1RIU3atyxLTePnTCnN9yfP39JOx2oAtD6wBYsRo=;
        b=NIx5Lq+YouSJMJJJimQ5XY60ORHIZsduFcG3BvKzIqhwz06wjtUWwM0gGM1Yc4E/JQ
         wP7lW45nOUeWymZPvX8EgpPVt5u2Vl4tSPhhnG4O20QZ35+XIsMn11uXpyQSeg+jk5Db
         oYqjSDu6AtiRpEENTxOyZA4uCiq4ab1EYvinUWZzx61/zoI+ZHLxp4iYaoFgOqnMyfBM
         I+kVnqV5DnZVxc1nUvWww0vW0QGeZb+fktIpyz6AukxCQKHDPKB57B3uDfK6hkHXS4Ld
         /wtkqXSaOfphhmIQIdU74q4H7EQYakdr0gifxUNYB2c3SKKFwK/jTfMTquqmuf+6PPGS
         fyGw==
X-Gm-Message-State: AGi0PuYOe1mHpTCny6gaoX83AZhmB2m/R4kMquLOg/K6dDGmWfqUEiP9
        bcZ19/dJ7j4+CGloZLJY2rjXLsXbWqttV9noOxZrNFQubxXykqYQcNe+8J7JaFDtwrsyD+Jv4mS
        AS7JAlHF6MN8ZavdP
X-Received: by 2002:adf:e48a:: with SMTP id i10mr10024627wrm.71.1585926013263;
        Fri, 03 Apr 2020 08:00:13 -0700 (PDT)
X-Google-Smtp-Source: APiQypLqnDom6UdWBr+033Gy+83GRYfkfXS0fhfrDBUfQhqFi5xzo63Mh7oAag+pjQKdqhnpcks9TA==
X-Received: by 2002:adf:e48a:: with SMTP id i10mr10024589wrm.71.1585926012927;
        Fri, 03 Apr 2020 08:00:12 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id w204sm12060632wma.1.2020.04.03.08.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 08:00:12 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] ACPI: PM: Add acpi_[un]register_wakeup_handler()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 4+" <stable@vger.kernel.org>
References: <20200403105235.105187-1-hdegoede@redhat.com>
 <CAHp75VfV2M+uRNqDg0MfMwr2-1EMQv-cZT4-WtufrzyYi9zQXw@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <acba586b-6924-a3d8-9830-4e42a3586cb0@redhat.com>
Date:   Fri, 3 Apr 2020 17:00:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VfV2M+uRNqDg0MfMwr2-1EMQv-cZT4-WtufrzyYi9zQXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/3/20 4:17 PM, Andy Shevchenko wrote:
> On Fri, Apr 3, 2020 at 1:52 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
>> waking up the system") the SCI triggering without there being a wakeup
>> cause recognized by the ACPI sleep code will no longer wakeup the system.
>>
>> This works as intended, but this is a problem for devices where the SCI
>> is shared with another device which is also a wakeup source.
>>
>> In the past these, from the pov of the ACPI sleep code, spurious SCIs
>> would still cause a wakeup so the wakeup from the device sharing the
>> interrupt would actually wakeup the system. This now no longer works.
>>
>> This is a problem on e.g. Bay Trail-T and Cherry Trail devices where
>> some peripherals (typically the XHCI controller) can signal a
>> Power Management Event (PME) to the Power Management Controller (PMC)
>> to wakeup the system, this uses the same interrupt as the SCI.
>> These wakeups are handled through a special INT0002 ACPI device which
>> checks for events in the GPE0a_STS for this and takes care of acking
>> the PME so that the shared interrupt stops triggering.
>>
>> The change to the ACPI sleep code to ignore the spurious SCI, causes
>> the system to no longer wakeup on these PME events. To make things
>> worse this means that the INT0002 device driver interrupt handler will
>> no longer run, causing the PME to not get cleared and resulting in the
>> system hanging. Trying to wakeup the system after such a PME through e.g.
>> the power button no longer works.
>>
>> Add an acpi_register_wakeup_handler() function which registers
>> a handler to be called from acpi_s2idle_wake() and when the handler
>> returns true, return true from acpi_s2idle_wake().
>>
>> The INT0002 driver will use this mechanism to check the GPE0a_STS
>> register from acpi_s2idle_wake() and to tell the system to wakeup
>> if a PME is signaled in the register.
>>
> 
> Something happened to your editor settings? Some lines looks like too short...
> 
>> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
>> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> - Move the new helpers to drivers/acpi/wakeup.c
>> - Rename the helpers to acpi_[un]register_wakeup_handler(), also give some
>>    types/variables better names
>> ---
>>   drivers/acpi/sleep.c  |  4 +++
>>   drivers/acpi/sleep.h  |  1 +
>>   drivers/acpi/wakeup.c | 82 +++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/acpi.h  |  5 +++
>>   4 files changed, 92 insertions(+)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index e5f95922bc21..dc8c71c47285 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -1025,6 +1025,10 @@ static bool acpi_s2idle_wake(void)
>>                  if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
>>                          return true;
>>
>> +               /* Check wakeups from drivers sharing the SCI. */
>> +               if (acpi_check_wakeup_handlers())
>> +                       return true;
>> +
>>                  /*
>>                   * Cancel the wakeup and process all pending events in case
>>                   * there are any wakeup ones in there.
>> diff --git a/drivers/acpi/sleep.h b/drivers/acpi/sleep.h
>> index 41675d24a9bc..3d90480ce1b1 100644
>> --- a/drivers/acpi/sleep.h
>> +++ b/drivers/acpi/sleep.h
>> @@ -2,6 +2,7 @@
>>
>>   extern void acpi_enable_wakeup_devices(u8 sleep_state);
>>   extern void acpi_disable_wakeup_devices(u8 sleep_state);
>> +extern bool acpi_check_wakeup_handlers(void);
>>
>>   extern struct list_head acpi_wakeup_device_list;
>>   extern struct mutex acpi_device_lock;
>> diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
>> index 9614126bf56e..de0f8e626c1c 100644
>> --- a/drivers/acpi/wakeup.c
>> +++ b/drivers/acpi/wakeup.c
>> @@ -12,6 +12,15 @@
>>   #include "internal.h"
>>   #include "sleep.h"
>>
>> +struct acpi_wakeup_handler {
>> +       struct list_head list_node;
>> +       bool (*wakeup)(void *context);
>> +       void *context;
>> +};
>> +
>> +static LIST_HEAD(acpi_wakeup_handler_head);
>> +static DEFINE_MUTEX(acpi_wakeup_handler_mutex);
>> +
>>   /*
>>    * We didn't lock acpi_device_lock in the file, because it invokes oops in
>>    * suspend/resume and isn't really required as this is called in S-state. At
>> @@ -96,3 +105,76 @@ int __init acpi_wakeup_device_init(void)
>>          mutex_unlock(&acpi_device_lock);
>>          return 0;
>>   }
>> +
>> +/**
>> + * acpi_register_wakeup_handler - Register wakeup handler
>> + * @wake_irq: The IRQ through which the device may receive wakeups
>> + * @wakeup:   Wakeup-handler to call when the SCI has triggered a wakeup
>> + * @context:  Context to pass to the handler when calling it
>> + *
>> + * Drivers which may share an IRQ with the SCI can use this to register
>> + * a handler which returns true when the device they are managing wants
>> + * to trigger a wakeup.
>> + */
> 
>> +int acpi_register_wakeup_handler(
> 
> ...this one...
> 
>> +       int wake_irq, bool (*wakeup)(void *context), void *context)

As the changelog states, so variables were renamed, which makes this
a bit shorter then before. Note it still does not fit in a single
line, but I can put the second parameter after the ( now, which does
look better. Will fix for v3.

>> +{
>> +       struct acpi_wakeup_handler *handler;
>> +
>> +       /*
>> +        * If the device is not sharing its IRQ with the SCI, there is no
>> +        * need to register the handler.
>> +        */
>> +       if (!acpi_sci_irq_valid() || wake_irq != acpi_sci_irq)
>> +               return 0;
>> +
>> +       handler = kmalloc(sizeof(*handler), GFP_KERNEL);
>> +       if (!handler)
>> +               return -ENOMEM;
>> +
>> +       handler->wakeup = wakeup;
>> +       handler->context = context;
>> +
>> +       mutex_lock(&acpi_wakeup_handler_mutex);
>> +       list_add(&handler->list_node, &acpi_wakeup_handler_head);
>> +       mutex_unlock(&acpi_wakeup_handler_mutex);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_register_wakeup_handler);
>> +
>> +/**
>> + * acpi_unregister_wakeup_handler - Unregister wakeup handler
>> + * @wakeup:   Wakeup-handler passed to acpi_register_wakeup_handler()
>> + * @context:  Context passed to acpi_register_wakeup_handler()
>> + */
> 
>> +void acpi_unregister_wakeup_handler(
>> +       bool (*wakeup)(void *context), void *context)
> 
> Not sure, but looks like short.

Same as above.

> 
>> +{
>> +       struct acpi_wakeup_handler *handler;
>> +
>> +       mutex_lock(&acpi_wakeup_handler_mutex);
>> +       list_for_each_entry(handler, &acpi_wakeup_handler_head, list_node) {
> 
>> +               if (handler->wakeup == wakeup &&
>> +                   handler->context == context) {
> 
> Ditto.

This one now actually fits on a single line (it is 79 chars then)
will also fix for v3.

Regards,

Hans

> 
>> +                       list_del(&handler->list_node);
>> +                       kfree(handler);
>> +                       break;
>> +               }
>> +       }
>> +       mutex_unlock(&acpi_wakeup_handler_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(acpi_unregister_wakeup_handler);
>> +
>> +bool acpi_check_wakeup_handlers(void)
>> +{
>> +       struct acpi_wakeup_handler *handler;
>> +
>> +       /* No need to lock, nothing else is running when we're called. */
>> +       list_for_each_entry(handler, &acpi_wakeup_handler_head, list_node) {
>> +               if (handler->wakeup(handler->context))
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 0f24d701fbdc..efac0f9c01a2 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -488,6 +488,11 @@ void __init acpi_nvs_nosave_s3(void);
>>   void __init acpi_sleep_no_blacklist(void);
>>   #endif /* CONFIG_PM_SLEEP */
>>
>> +int acpi_register_wakeup_handler(
>> +       int wake_irq, bool (*wakeup)(void *context), void *context);
>> +void acpi_unregister_wakeup_handler(
>> +       bool (*wakeup)(void *context), void *context);
>> +
>>   struct acpi_osc_context {
>>          char *uuid_str;                 /* UUID string */
>>          int rev;
>> --
>> 2.26.0
>>
> 
> 

