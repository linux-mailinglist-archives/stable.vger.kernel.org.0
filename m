Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49290132E9C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgAGSl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:41:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44643 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728358AbgAGSl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 13:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578422484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knBeTJdr3SvBDPuzW2zcs7LXSnmpROU43VYWYEPvPPQ=;
        b=dAcugBANUXDA5LKc+giBqaePXKR5uQJDybU25Vx1uqytr+snTn7kvgf+j61epnyRh0g7Ba
        Kl8YBjTPuGIQJ1xgP8AtB3990240wf9BP3Exut8yHqQfTZNNBiDw7WMt4znOMxE+m6NyTq
        p46ZdwziSh4Gahr8UiGCKN8UYoBV8Pg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-jWSWWcK6PBiznHk1Gh5gcg-1; Tue, 07 Jan 2020 13:41:23 -0500
X-MC-Unique: jWSWWcK6PBiznHk1Gh5gcg-1
Received: by mail-wr1-f71.google.com with SMTP id r2so319549wrp.7
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 10:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knBeTJdr3SvBDPuzW2zcs7LXSnmpROU43VYWYEPvPPQ=;
        b=SPFRuEz9sua57lhqy3RP82uvXRa0ByWh8pXPKOGfrSx5sf2iC3Gxgnp75Ifcp+ndec
         XvAWRniZ2m6o6m21qrzzOg6zYe1cLuTanBroQMZJTIIqjF3tr7Lf8i9BfuQYcgWfTOtN
         DFBgWQqOCRavQDpcUbqf45c/kdozTtoj3kdqMz71lftliTHsuxtjo+4qt6IWrr/hLw1B
         yIfGKQ9jJ0XAkSW17AZq+A8sMpTvsN+ZgiGFaJuTWNVEXpbOtvS2os8GuyT3Fx3aKE74
         pftDxYS4OQQIhb6yapoceMeMtHmM0sCqctwKUML8zO/mcmOzDvYksvQW9dYN/Z0/TV6h
         cdPg==
X-Gm-Message-State: APjAAAU85MJpCbrouXSma7bv3tv2VPqKjk4uxSrXSaQeDjEHcrh/eer3
        09+2NCatddDqHKcX6zHkugwXIFTLWAekAbaPpP8uUZUzLKhHn5qcCvZ2ibu79DKAZaqou8n7Luf
        kb/fgScSXGv62EVFE
X-Received: by 2002:adf:90e1:: with SMTP id i88mr433555wri.95.1578422481518;
        Tue, 07 Jan 2020 10:41:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqwvrhw6gY9CY1qKjVtotCC9mZKXWExcALQZtc+XkU2ySqa6u42+f3wB/Xj0BYkkhIV7NgyDUg==
X-Received: by 2002:adf:90e1:: with SMTP id i88mr433539wri.95.1578422481350;
        Tue, 07 Jan 2020 10:41:21 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id c5sm641724wmb.9.2020.01.07.10.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:41:20 -0800 (PST)
Subject: Re: [PATCH resend v2 1/2] gpiolib: acpi: Turn dmi_system_id table
 into a generic quirk table
To:     Sasha Levin <sashal@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org
References: <20200105160357.97154-2-hdegoede@redhat.com>
 <20200107183314.875AE222D9@mail.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b876a7f7-bdf4-8389-559b-d27390b3f38d@redhat.com>
Date:   Tue, 7 Jan 2020 19:41:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107183314.875AE222D9@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 07-01-2020 19:33, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.4.8, v4.19.93, v4.14.162, v4.9.208, v4.4.208.
> 
> v5.4.8: Build OK!
> v4.19.93: Build OK!
> v4.14.162: Build OK!

Adding this to 4.14 and later, leaving the others behind should be fine.

Thanks,

Hans

> v4.9.208: Failed to apply! Possible dependencies:
>      25e3ef894eef ("gpio: acpi: Split out acpi_gpio_get_irq_resource() helper")
>      2727315df3f5 ("gpiolib: acpi: Add Terra Pad 1061 to the run_edge_events_on_boot_blacklist")
>      61f7f7c8f978 ("gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist")
>      78d3a92edbfb ("gpiolib-acpi: Register GpioInt ACPI event handlers from a late_initcall")
>      85c73d50e57e ("gpio: acpi: Add managed variant of acpi_dev_add_driver_gpios()")
>      8a146fbe1f14 ("gpio: acpi: Call enable_irq_wake for _IAE GpioInts with Wake set")
>      993b9bc5c47f ("gpiolib: acpi: Switch to cansleep version of GPIO library call")
>      ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
>      e59f5e08ece1 ("gpiolib-acpi: Only defer request_irq for GpioInt ACPI event handlers")
> 
> v4.4.208: Failed to apply! Possible dependencies:
>      10cf4899f8af ("gpiolib: tighten up ACPI legacy gpio lookups")
>      25e3ef894eef ("gpio: acpi: Split out acpi_gpio_get_irq_resource() helper")
>      58383c78425e ("gpio: change member .dev to .parent")
>      61f7f7c8f978 ("gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist")
>      78d3a92edbfb ("gpiolib-acpi: Register GpioInt ACPI event handlers from a late_initcall")
>      85c73d50e57e ("gpio: acpi: Add managed variant of acpi_dev_add_driver_gpios()")
>      8a146fbe1f14 ("gpio: acpi: Call enable_irq_wake for _IAE GpioInts with Wake set")
>      993b9bc5c47f ("gpiolib: acpi: Switch to cansleep version of GPIO library call")
>      ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
>      e59f5e08ece1 ("gpiolib-acpi: Only defer request_irq for GpioInt ACPI event handlers")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

