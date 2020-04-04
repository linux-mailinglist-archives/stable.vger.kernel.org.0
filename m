Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D67119E4C1
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 13:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDDLwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Apr 2020 07:52:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41194 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726039AbgDDLwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Apr 2020 07:52:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586001173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f64FR+wQwG4Rf+1Nwf9deQLAxinVjgUZ9huOaCrREcU=;
        b=Z3OHSHnWPWsWIyIGN/wtzxXfwRCbOzgoDMqprZpfeMmNuoRNLuu0mV4ryC6WHKcV5lU+jk
        NaQnC7XcMk0xBeaXYyczpDqj2fgxvPSleYPHilcUqJL/8IUDe4y6w1l6QzBQzva/yi1ZcQ
        lsjoUPEKUW7H0aOPQI8uyqsEzod3qkQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-sqE6yblOOPKXSTGKVhfaEA-1; Sat, 04 Apr 2020 07:52:51 -0400
X-MC-Unique: sqE6yblOOPKXSTGKVhfaEA-1
Received: by mail-wm1-f69.google.com with SMTP id p12so1761016wmi.0
        for <stable@vger.kernel.org>; Sat, 04 Apr 2020 04:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f64FR+wQwG4Rf+1Nwf9deQLAxinVjgUZ9huOaCrREcU=;
        b=gL6zN+OTpG8Ig1mjoJdxFwjgU131Opy5DxlNf+MAH2S93Vi6TX1EfVot/UG/dKeKl3
         ot6NTiFprJ0oPlriyetdyf24VbSHnRD2f85dJtbUBB32vDZFs9/u2UIwRhY5WnxTO9oN
         AVGMlw1W+It5sxUFUVVcHz88cbwBEbWui/uSGc+B+npHL0Ucewc37XUKkc7lAHLNberA
         ZFW5hfD/GTiWgsqPGP3IDxfXtCLBq/JHx+l1NdGPh3Ri5PEC6lweNLr88mzsqoCbFRcr
         eiRd33ifrS0f822fLTmXapGCHUcVNMbum7/8ykqFiou9jXwXFBzb15KZWkBv7t+he6Oh
         CaMg==
X-Gm-Message-State: AGi0PuYTF+yK1Ym1YLc8XjobGZQdBUWtn4QCC3CzItVFyMmQzuU+rm+6
        OGYItBkBlH8pWzY+//azT+gNVB/2mlj8s3YoPdf8RCJJBy9LZGsVxdwfFKPDvQ00awvsDgune4r
        xLRR7Ebn0y2hvlKEH
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr13986479wmj.13.1586001170108;
        Sat, 04 Apr 2020 04:52:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypK0AZLIM+VFnAkYrCUNC87FZEsHxgjBLzBFl6igf0XOnAGiRT//XV5W7FDIbXfi3Leu5nrGlA==
X-Received: by 2002:a7b:cb59:: with SMTP id v25mr13986456wmj.13.1586001169826;
        Sat, 04 Apr 2020 04:52:49 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id z16sm346059wrg.66.2020.04.04.04.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2020 04:52:49 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] platform/x86: intel_int0002_vgpio: Use
 acpi_register_wakeup_handler()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Len Brown <lenb@kernel.org>, Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "5 . 4+" <stable@vger.kernel.org>
References: <20200403154834.303105-1-hdegoede@redhat.com>
 <20200403154834.303105-2-hdegoede@redhat.com> <3798902.sSGyZ91sKY@kreacher>
 <CAHp75VfThW1CrkneP5kEm_7KejQgS2dhDi0YyDrL4y3=uY9ZbA@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <f054f195-d5e7-8041-4995-8a52d2bd7674@redhat.com>
Date:   Sat, 4 Apr 2020 13:52:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VfThW1CrkneP5kEm_7KejQgS2dhDi0YyDrL4y3=uY9ZbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 4/3/20 6:23 PM, Andy Shevchenko wrote:
> On Fri, Apr 3, 2020 at 7:08 PM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>
>> On Friday, April 3, 2020 5:48:34 PM CEST Hans de Goede wrote:
>>> The Power Management Events (PMEs) the INT0002 driver listens for get
>>> signalled by the Power Management Controller (PMC) using the same IRQ
>>> as used for the ACPI SCI.
>>>
>>> Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
>>> waking up the system") the SCI triggering, without there being a wakeup
>>> cause recognized by the ACPI sleep code, will no longer wakeup the system.
>>>
>>> This breaks PMEs / wakeups signalled to the INT0002 driver, the system
>>> never leaves the s2idle_loop() now.
>>>
>>> Use acpi_register_wakeup_handler() to register a function which checks
>>> the GPE0a_STS register for a PME and trigger a wakeup when a PME has
>>> been signalled.
>>>
>>> Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
>>> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Andy, any objections?
> 
> No,
> Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> 
> Hans, just today when testing some other stuff noticed this
> 
> [   49.279001] irq 9: nobody cared (try booting with the "irqpoll" option)
> [   49.289176] CPU: 0 PID: 168 Comm: irq/123-ATML100 Not tainted
> 5.6.0-next-20200403+ #212
> [   49.300915] Hardware name: Intel Corporation CHERRYVIEW D0
> PLATFORM/Braswell CRB, BIOS BRAS.X64.B082.R00.150727 0557 07/27/2015
> [   49.316520] Call Trace:
> [   49.322093]  <IRQ>
> [   49.327193]  dump_stack+0x50/0x70
> [   49.333744]  __report_bad_irq+0x30/0xa2
> [   49.340858]  note_interrupt.cold+0xb/0x62
> ...
> [   49.685087] handlers:
> [   49.690307] [<000000000ab3cf88>] acpi_irq
> [   49.697463] [<00000000e5d78029>] int0002_irq [intel_int0002_vgpio]
> [   49.707063] Disabling IRQ #9
> 
> Is this what your series fixes?

I don't think that my series fixes this.

My series fixes CHT devices no longer waking up from s2idle
when woken by pressing a key on the USB attached keyboard dock
of various 2-in-1s. Before we were relying on the ACPI code
also waking up on IRQs which from the ACPI SCI handler pov where
spurious. Rafael fixed the ACPI SCI handling during s2idle
also waking the system on spurious events. My patch hooks
the INT0002 driver into the ACPI SCI handling / wakeup checks
during s2idle.

I guess Rafael may have made some related changes elsewhere
though where the SCI no longer returns IRQ_HANDLED in some cases?

Rafael?

Regards,

Hans




> 
>>
>>> ---
>>> Changes in v3:
>>> - Keep the pm_wakeup_hard_event() call
>>>
>>> Changes in v2:
>>> - Adjust for the wakeup-handler registration function being renamed to
>>>    acpi_register_wakeup_handler()
>>> ---
>>>   drivers/platform/x86/intel_int0002_vgpio.c | 10 ++++++++++
>>>   1 file changed, 10 insertions(+)
>>>
>>> diff --git a/drivers/platform/x86/intel_int0002_vgpio.c b/drivers/platform/x86/intel_int0002_vgpio.c
>>> index f14e2c5f9da5..55f088f535e2 100644
>>> --- a/drivers/platform/x86/intel_int0002_vgpio.c
>>> +++ b/drivers/platform/x86/intel_int0002_vgpio.c
>>> @@ -127,6 +127,14 @@ static irqreturn_t int0002_irq(int irq, void *data)
>>>        return IRQ_HANDLED;
>>>   }
>>>
>>> +static bool int0002_check_wake(void *data)
>>> +{
>>> +     u32 gpe_sts_reg;
>>> +
>>> +     gpe_sts_reg = inl(GPE0A_STS_PORT);
>>> +     return (gpe_sts_reg & GPE0A_PME_B0_STS_BIT);
>>> +}
>>> +
>>>   static struct irq_chip int0002_byt_irqchip = {
>>>        .name                   = DRV_NAME,
>>>        .irq_ack                = int0002_irq_ack,
>>> @@ -220,6 +228,7 @@ static int int0002_probe(struct platform_device *pdev)
>>>                return ret;
>>>        }
>>>
>>> +     acpi_register_wakeup_handler(irq, int0002_check_wake, NULL);
>>>        device_init_wakeup(dev, true);
>>>        return 0;
>>>   }
>>> @@ -227,6 +236,7 @@ static int int0002_probe(struct platform_device *pdev)
>>>   static int int0002_remove(struct platform_device *pdev)
>>>   {
>>>        device_init_wakeup(&pdev->dev, false);
>>> +     acpi_unregister_wakeup_handler(int0002_check_wake, NULL);
>>>        return 0;
>>>   }
>>>
>>>
>>
>>
>>
>>
> 
> 

