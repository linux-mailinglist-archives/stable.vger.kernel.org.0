Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15355132E9F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgAGSmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:42:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53182 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgAGSmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 13:42:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578422521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gENCu0UbMTJ8+c3QrLGBJl46CsGhh7kSNycoBVRfXbs=;
        b=fDTMXG0m0X6F8sasc3QpLLVfM0V+vtA0WBLE4sMBak3AweSn7XRKqCXz1G3IGx1n7RWONC
        kKTUfh33DPwsGP0yBvjvDRW75szCRbiztvhZlHneM17MKhPFHt1zDU8MxiWYvxgm5JUZ78
        NcgnA/feU7IQ1Pm7p1t2XGy4WyHeZHo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-xaoOpgzaNtOhWSYE-zCAaw-1; Tue, 07 Jan 2020 13:41:59 -0500
X-MC-Unique: xaoOpgzaNtOhWSYE-zCAaw-1
Received: by mail-wr1-f70.google.com with SMTP id j13so303402wrr.20
        for <stable@vger.kernel.org>; Tue, 07 Jan 2020 10:41:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gENCu0UbMTJ8+c3QrLGBJl46CsGhh7kSNycoBVRfXbs=;
        b=rf9UvPnkNZkDna1mTmzk6lXVyHlMXHh6Kph4PtIOyLaywKXnJnVOEIk73i+njgpISr
         od8PnMCRK7xWMEDvrPtBrwaIfYCwlhGjPccEgyR+WtBSNuy2F9E+7QurMcyNk5urmjcB
         7IU3CzMe08xsS2eA3OSp240FwbNtMJvKIALhC5iIVTX7H5qP2UACh2ShD9tZ7Yd0X8SL
         d8aBKGL8pWxn7KoIyNDm9lmH0cToq9S1wQ/iT+nRQGwbZK4THbxlKJcU87c0N8XJ4WTU
         3vow+kqDKNEIDLe5kUTMtcUML/lE7EpX+v356SXqR//fSpBSBSmtLtKW6vICtaDDkrdy
         1QRQ==
X-Gm-Message-State: APjAAAVaADTYGojmnn39xGiy1ZV+0Q9DDcfWUA7reisE+raeoUtaLGxc
        uc5CWz14dgByUEIEmrxVP3ld+9g/zXBw7vulArA56S3+ccQ3k/jwgiStnX1C06iGv3nSvWNtkgz
        22bRpEyTjsV660dSd
X-Received: by 2002:a05:600c:2551:: with SMTP id e17mr447633wma.26.1578422518435;
        Tue, 07 Jan 2020 10:41:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqzpGM1svwLVg3Rk7KZDWMai3FCEe3dERy6+6LCgueZ2/2OxpDGfP5WHRBvAZG7YqRaPms0/kA==
X-Received: by 2002:a05:600c:2551:: with SMTP id e17mr447618wma.26.1578422518223;
        Tue, 07 Jan 2020 10:41:58 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id n3sm838121wrs.8.2020.01.07.10.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:41:57 -0800 (PST)
Subject: Re: [PATCH resend v2 2/2] gpiolib: acpi: Add honor_wakeup
 module-option + quirk mechanism
To:     Sasha Levin <sashal@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, stable@vger.kernel.org
References: <20200105160357.97154-3-hdegoede@redhat.com>
 <20200107183315.A2CE320848@mail.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <45cfd73c-0372-9622-b8c3-345aece253a7@redhat.com>
Date:   Tue, 7 Jan 2020 19:41:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107183315.A2CE320848@mail.kernel.org>
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
> v5.4.8: Failed to apply! Possible dependencies:
>      a5242f4858be ("gpiolib: acpi: Turn dmi_system_id table into a generic quirk table")
> 
> v4.19.93: Failed to apply! Possible dependencies:
>      a5242f4858be ("gpiolib: acpi: Turn dmi_system_id table into a generic quirk table")
> 
> v4.14.162: Failed to apply! Possible dependencies:
>      a5242f4858be ("gpiolib: acpi: Turn dmi_system_id table into a generic quirk table")
> 

Like with the previous patch adding this to 4.14 and later (which should apply cleanly once
the previous patch is applied) , leaving the others behind should be fine.

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
>      a5242f4858be ("gpiolib: acpi: Turn dmi_system_id table into a generic quirk table")
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
>      a5242f4858be ("gpiolib: acpi: Turn dmi_system_id table into a generic quirk table")
>      ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
>      e59f5e08ece1 ("gpiolib-acpi: Only defer request_irq for GpioInt ACPI event handlers")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

