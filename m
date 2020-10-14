Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615CA28DFC5
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 13:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbgJNLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 07:24:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730677AbgJNLYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 07:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602674640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3H6mGsRZewK80OZHFyPkl46RKkyXB0PbUSdyfxyv/nQ=;
        b=HyQv8i/wihW30LtwkNZJtEMWb+T2k30mpmJA/FVZxsGHKDhlwwLMWXBGslf4AdVILGnenF
        HLRJLe0uPskFpXlWqCCylz7KV5782SRj+fFQbcw5Dr1yqsa6+jm91BEsiySwYN/8+SUC3y
        ShWM/wQtEnJGiUdyF1FbPCmjaA/vtkw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-R6AeEOE4PFeMk5IQ3yHcOA-1; Wed, 14 Oct 2020 07:23:57 -0400
X-MC-Unique: R6AeEOE4PFeMk5IQ3yHcOA-1
Received: by mail-ed1-f71.google.com with SMTP id dc23so1055489edb.13
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 04:23:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3H6mGsRZewK80OZHFyPkl46RKkyXB0PbUSdyfxyv/nQ=;
        b=D7twLSLf4d7Xq41jw41viMyYnczfg5riua1S5Ovh21eVtQX6J1WxkgON73VdM1JHC8
         W0+nMcu47i7vpK/kQJBcdilR6l3uQpCrCj5Cr4sR4TX/m/FICeia0gJ9vXhqEAD0K+KN
         DBKIT6nJYQcBBexCkPinKoBMCSZtjHMSZXOYMAeuas5ccGcHDyjq3dMzYP54qUsp+33i
         yyt+vaFGBJ3lrR3HgigsrhqFh1oaRt4A80THZTY2WVzLXdVDxWTYQkcORQ+q33lushwl
         /rBGMI7ZFsT5l+PACxGWXvsR11nGyAlpuZQKk47NW51JfRjEA76YSczquMZZ6o49tnXf
         RqYQ==
X-Gm-Message-State: AOAM531sjHWBppp4SkO3Kb2xeyIVZ0VPzieY4q2W9D6e+XiazHOrWV+b
        oztn2m4xeMIXiLqzwvfIeUhkIgDESwcmDlEkHugGxw4DBtLESv6Rny7mE3Tuu7+Del2dAYhfqsH
        1WQn1fxXEIkIcZwte
X-Received: by 2002:a17:906:5052:: with SMTP id e18mr4562640ejk.530.1602674635893;
        Wed, 14 Oct 2020 04:23:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKr1m32t14FkDc/W8AweDP9IBnI3ylZgpuTkWQR5km+xGPX1lrPGf71ctcfLHQF7DtS46eAg==
X-Received: by 2002:a17:906:5052:: with SMTP id e18mr4562615ejk.530.1602674635646;
        Wed, 14 Oct 2020 04:23:55 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id rn10sm1584899ejb.8.2020.10.14.04.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 04:23:55 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.8 17/20] i2c: core: Call
 i2c_acpi_install_space_handler() before i2c_acpi_register_devices()
To:     kieran.bingham@ideasonboard.com, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-17-sashal@kernel.org>
 <1977b57b-fae6-d9d4-e6bf-3d4013619537@ideasonboard.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <bbeb7cae-d856-bb25-4602-8dd3bae62773@redhat.com>
Date:   Wed, 14 Oct 2020 13:23:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1977b57b-fae6-d9d4-e6bf-3d4013619537@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/14/20 1:09 PM, Kieran Bingham wrote:
> Hi Hans, Sasha,
> 
> As mentioned on https://github.com/linux-surface/kernel/issues/63, I'm
> afraid I've bisected a boot time issue on the Microsoft Surface Go 2 to
> this commit on the stable 5.8 tree.
> 
> The effect as reported there is that the boot process stalls just after
> loading the usbhid module.
> 
> Typing, or interacting with the Keyboard (Type Cover) at that point
> appears to cause usb bus resets, but I don't know if that's a related
> symptom or just an effect of some underlying root cause.
> 
> I have been running a linux-media kernel on this device without issue.
> 
> Is this commit in 5.9? I'll build a vanilla v5.9 kernel and see if it
> occurs there too.

Yes the commit is in 5.9 too. Still would be interesting to see if 5.9 hits
this issue too. I guess it will, but as I mentioned in:

https://github.com/linux-surface/kernel/issues/63

I do not understand why this commit is causing this issue.

So I just checked and the whole acpidump is not using I2C
opregion stuff at all:

[hans@x1 microsoft-surface-go2]$ ack GenericSerialBus *.dsl
[hans@x1 microsoft-surface-go2]$

And there is only 1 _REG handler which is for the
embedded-controller.

So this patch should not make a difference at all on the GO2,
other then maybe a subtle timing difference somewhere ... ?

Regards,

Hans


> On 21/09/2020 15:40, Sasha Levin wrote:
>> From: Hans de Goede <hdegoede@redhat.com>
>>
>> [ Upstream commit 21653a4181ff292480599dad996a2b759ccf050f ]
>>
>> Some ACPI i2c-devices _STA method (which is used to detect if the device
>> is present) use autodetection code which probes which device is present
>> over i2c. This requires the I2C ACPI OpRegion handler to be registered
>> before we enumerate i2c-clients under the i2c-adapter.
>>
>> This fixes the i2c touchpad on the Lenovo ThinkBook 14-IIL and
>> ThinkBook 15 IIL not getting an i2c-client instantiated and thus not
>> working.
>>
>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1842039
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Wolfram Sang <wsa@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/i2c/i2c-core-base.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
>> index 4f09d4c318287..7031393c74806 100644
>> --- a/drivers/i2c/i2c-core-base.c
>> +++ b/drivers/i2c/i2c-core-base.c
>> @@ -1336,8 +1336,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>>   
>>   	/* create pre-declared device nodes */
>>   	of_i2c_register_devices(adap);
>> -	i2c_acpi_register_devices(adap);
>>   	i2c_acpi_install_space_handler(adap);
>> +	i2c_acpi_register_devices(adap);
>>   
>>   	if (adap->nr < __i2c_first_dynamic_bus_num)
>>   		i2c_scan_static_board_info(adap);
>>
> 
> 

