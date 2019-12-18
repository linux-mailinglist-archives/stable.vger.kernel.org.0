Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E9124589
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfLRLSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 06:18:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727024AbfLRLSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 06:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZGhAnGH0QyfnH31mPKQJTf9859i7lgXJ3SW1mv4Pr8=;
        b=IBGTHTeeSmkwwbU1e37FEQhxVjpxYJvYDC7OK/T8gQvKC5N7+etmHpBa4cE1y153WOhspk
        ppvRFhlkdEXBcdnSlUvck3Ei8wgaHBXsLgtgWwTkcGZ7ZvU6JQKmAZujPFtXY2cs5vnDbZ
        73eSIuayOj1k3kw12lfkRu/by0DG7BI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-RL_swoKNPzafssboXLQfVw-1; Wed, 18 Dec 2019 06:18:17 -0500
X-MC-Unique: RL_swoKNPzafssboXLQfVw-1
Received: by mail-wm1-f69.google.com with SMTP id g26so397412wmk.6
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 03:18:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dZGhAnGH0QyfnH31mPKQJTf9859i7lgXJ3SW1mv4Pr8=;
        b=U7fpPk0Vz1tLY5sh3saQ1nVN/ogA2g3rlKJXQniNXppEARVH6XGKxH/WPdOUnvw3uZ
         19GpOkaQ/Hbof+LR3EmZJtdnCFw1L/I1pp52NScOQOxCwqrTf2oDH8pfUTlNJ+KvZ69+
         t6+nr3GY4WR7K2oaJhUWnp/dQefYSUIPrh6ljCKdwk6g4WmHGUe7UBaCLNheH5oM30RI
         RUmfuk6+VT3HiG/kfZneZhLNpUCDEQIhTGNw74Q2XHxchaJKlv6ZbqrgooPILeiQAQ2u
         7IT5RWgWXtvbfCz2ZsXugFb9IUm9OJN7TLmbnYjcoPFXDiMqUmpJXDYrsaJ0hTPO8OVf
         xCHg==
X-Gm-Message-State: APjAAAXIiw8TpVM7bvW3akFfp2ZTVymMn3NjWBUi9+Bl4hwP6xrdTMCI
        bY/AmQkD8FFApFXB6MdpuP5Au0F4gP7tkR13BXztLCZ5Ntx1QB2woL7ubOKmtOkTcdHXmj0YOU9
        OxGL8CJwn7sssKrJ6
X-Received: by 2002:adf:c147:: with SMTP id w7mr2254247wre.389.1576667894758;
        Wed, 18 Dec 2019 03:18:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqxy8svWDScf6vz9rhpq+U1ipCWfybaC8xv/UzYFKKYrL6RfmzIcL81FArHty2w2DF4y6X0lVQ==
X-Received: by 2002:adf:c147:: with SMTP id w7mr2254231wre.389.1576667894560;
        Wed, 18 Dec 2019 03:18:14 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id y139sm2232359wmd.24.2019.12.18.03.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 03:18:13 -0800 (PST)
Subject: Re: [PATCH] platform/x86: hp-wmi: Make buffer for
 HPWMI_FEATURE2_QUERY 128 bytes
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
References: <20191217190604.638467-1-hdegoede@redhat.com>
 <CAHp75Vf8CDwW731uD4OMzB69P-D1AN3PzCMFBGGD4fvBFccpLg@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <92800c93-9d03-ab26-e71f-ce40df1ad3bc@redhat.com>
Date:   Wed, 18 Dec 2019 12:18:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAHp75Vf8CDwW731uD4OMzB69P-D1AN3PzCMFBGGD4fvBFccpLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 18-12-2019 11:17, Andy Shevchenko wrote:
> On Tue, Dec 17, 2019 at 9:06 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> At least on the HP Envy x360 15-cp0xxx model the WMI interface
>> for HPWMI_FEATURE2_QUERY requires an outsize of at least 128 bytes,
>> otherwise it fails with an error code 5 (HPWMI_RET_INVALID_PARAMETERS):
>>
>> Dec 06 00:59:38 kernel: hp_wmi: query 0xd returned error 0x5
>>
>> We do not care about the contents of the buffer, we just want to know
>> if the HPWMI_FEATURE2_QUERY command is supported.
>>
>> This commits bumps the buffer size, fixing the error.
>>
> 
> Fixes tag?

The HPWMI_FEATURE2_QUERY call was introduced in 8a1513b4932, so I guess
this should have a:

Fixes: 8a1513b4932 ("hp-wmi: limit hotkey enable")

Tag, shall I send a v2 with this, or can you add it while applying the patch?

Regards,

Hans




> 
>> Cc: stable@vger.kernel.org
>> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1520703
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/platform/x86/hp-wmi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
>> index 9579a706fc08..a881b709af25 100644
>> --- a/drivers/platform/x86/hp-wmi.c
>> +++ b/drivers/platform/x86/hp-wmi.c
>> @@ -300,7 +300,7 @@ static int __init hp_wmi_bios_2008_later(void)
>>
>>   static int __init hp_wmi_bios_2009_later(void)
>>   {
>> -       int state = 0;
>> +       u8 state[128];
>>          int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, HPWMI_READ, &state,
>>                                         sizeof(state), sizeof(state));
>>          if (!ret)
>> --
>> 2.23.0
>>
> 
> 

