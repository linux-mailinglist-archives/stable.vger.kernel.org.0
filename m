Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70CD113FBB
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 11:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfLEKxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 05:53:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24945 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729099AbfLEKxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 05:53:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575543212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9MiSBkYrxLRkaMO4KvAeXN7MtJgEoseaGFx+AejKDY=;
        b=ID0m9ekLsxzmFpzzqQKUYSIuA+1jfenqFRuhurVHJTxXPJfNqOuaw1n5or1v/s6OkRO8k9
        mhIanhArMrgwECkdoT301wrI/0ANVFUdc44XseyPONwotNxVyJHGxbWIDrrpE1j8PxCnTU
        ad59fhJGb35PxA28dgkklqfaKL+Gr50=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-Ur_x81lKOTeAXAEqoibweA-1; Thu, 05 Dec 2019 05:53:31 -0500
Received: by mail-wm1-f71.google.com with SMTP id p5so726400wmc.4
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 02:53:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N9MiSBkYrxLRkaMO4KvAeXN7MtJgEoseaGFx+AejKDY=;
        b=KHnIVJFv/AnlcfD0IJdTMZAC452P07zH3A7TUp6P6L+pk6no7xt5KeDYPUb9e8qngG
         fRCR++wQNSNc1Ws5+sbVd0FDJa16itfEI+iP0ViFp2Tzz/Ref+5IpkcRziJl4TRBxeCs
         612NUAddJ0bx3IJo34WDar9SbeCNbCdimEXGBtuFjYFD4KQOD5a3LpgPHFpucnSviOtr
         ppijTyQlMJGL/+ZxLtwsftWAdLiI5jGZFoPwLjxrx+RrE+P3V4o50wYghB21WVYi05oN
         Oz+c0yX/A6CSkNOrcgdJBhtYqJh/4/vBg6ZIMwWdKNLOGf+7m7FSY37wzj/zhxwo1ye5
         ovBg==
X-Gm-Message-State: APjAAAVW7tqah5v2CZViUCXMT2PG3VhPuQpSC6ugsODF5x5wl06XEDJo
        MAtuo18VqdYcfX6n+FE4nnf82YM2o48+XvIfMjyHY/LWRYI63WR6jfyatvtTdtIXTlw4oxf9PQa
        f99fYsK0ZHY6pDMLV
X-Received: by 2002:a05:600c:305:: with SMTP id q5mr4663226wmd.167.1575543210703;
        Thu, 05 Dec 2019 02:53:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8Siikx+RenjGmb9/JgaiAJarJ4WUklGanKOUVM3RJ8HVeGo3sn10PEYhU/9toFV3BE5uKLQ==
X-Received: by 2002:a05:600c:305:: with SMTP id q5mr4663212wmd.167.1575543210518;
        Thu, 05 Dec 2019 02:53:30 -0800 (PST)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id x132sm1419084wmg.0.2019.12.05.02.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 02:53:29 -0800 (PST)
Subject: Re: [PATCH 4.19 082/321] ACPI / LPSS: Ignore
 acpi_device_fix_up_power() return value
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223431.423864271@linuxfoundation.org> <20191204212735.GC7678@amd>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <ffcc90cc-3b75-af81-832b-1387fcca7e06@redhat.com>
Date:   Thu, 5 Dec 2019 11:53:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191204212735.GC7678@amd>
Content-Language: en-US
X-MC-Unique: Ur_x81lKOTeAXAEqoibweA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 04-12-2019 22:27, Pavel Machek wrote:
> Hi!
> 
>> From: Hans de Goede <hdegoede@redhat.com>
>>
>> [ Upstream commit 1a2fa02f7489dc4d746f2a15fb77b3ce1affade8 ]
>>
>> Ignore acpi_device_fix_up_power() return value. If we return an error
>> we end up with acpi_default_enumeration() still creating a platform-
>> device for the device and we end up with the device still being used
>> but without the special LPSS related handling which is not useful.
>>
>> Specicifically ignoring the error fixes the touchscreen no longer
>> working after a suspend/resume on a Prowise PT301 tablet.
> 
> I'm pretty sure it does, but:
> 
> a) do you believe this is right patch for -stable? Should it get lot
> more testing in mainline as it.... may change things in a wrong way
> for someone else?

This has already been answered by Rafael.

> b) if we are ignoring errors now, should we at least printk() to let
> the user know that something is wrong with the ACPI tables?

acpi_device_fix_up_power() fails when the ACPI _PS0 method fails and
when there are errors while executing an ACPI method the ACPI subsystem
already is pretty verbose about this.

Regards,

Hans


> 
> Best regards,
> 									Pavel
> 
>> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
>> index b21c241aaab9f..30ccd94f87d24 100644
>> --- a/drivers/acpi/acpi_lpss.c
>> +++ b/drivers/acpi/acpi_lpss.c
>> @@ -665,12 +665,7 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>>   	 * have _PS0 and _PS3 without _PSC (and no power resources), so
>>   	 * acpi_bus_init_power() will assume that the BIOS has put them into D0.
>>   	 */
>> -	ret = acpi_device_fix_up_power(adev);
>> -	if (ret) {
>> -		/* Skip the device, but continue the namespace scan. */
>> -		ret = 0;
>> -		goto err_out;
>> -	}
>> +	acpi_device_fix_up_power(adev);
> 
> 
> 
>>   	adev->driver_data = pdata;
>>   	pdev = acpi_create_platform_device(adev, dev_desc->properties);
> 

