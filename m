Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39F9014CC69
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 15:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgA2O1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 09:27:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29696 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgA2O1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 09:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580308063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhDFgYtMJxL7OolBXcCNCLniqXwNsHWKW7afV4j1kc8=;
        b=KkI+lLkjhTWLJxltG8SXYaRzSPu15cbKUPGBjtHYkEgEb1J1n350ICy5ryxBn4DNkTNbdx
        pmtUWaOLeHCdHZ9tnbJz0ngcAti0Sw7KYPij7d+0/jhikUcY/ZfQoIxAgfnXPebtEsZZJa
        EWJ/Ma7zcv9zg/saaUjbKIBrL2UOSzY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-48lfblFgOYSwH7RmtEjsGg-1; Wed, 29 Jan 2020 09:27:36 -0500
X-MC-Unique: 48lfblFgOYSwH7RmtEjsGg-1
Received: by mail-wm1-f70.google.com with SMTP id g26so2739215wmk.6
        for <stable@vger.kernel.org>; Wed, 29 Jan 2020 06:27:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EhDFgYtMJxL7OolBXcCNCLniqXwNsHWKW7afV4j1kc8=;
        b=gnSXG+cKmFz5+JhOKQnv3HMrdQm1E37n2jKwQn5zayxoL5oIJzuRYDLDxbdDme+8O8
         5Yo6V/klqAyQbUDfS61vV7CLf4ChdQ/FlpLAjD6uiBij1q8rwPTZcPVziCBEheZgHjWU
         JHgxck/3gvwmlB81BPtrZ47DxOctDs855rro2oPPhVmZcyzHTo6PNoy4+eS+gPMN7ouJ
         SGD0PJ6MqSJ2bIXDi+DLaaenoWBXSlTPEfSTPGG6vzVDmg75SPsyE9Btv4crDPhE6u6C
         ZuupwpfNkbIKRIQzM3WaMabENyOCNes5R4qsNJ1DQOJBqen6YaIAgKtRM6qudxg9eESi
         c1yA==
X-Gm-Message-State: APjAAAVlAi6ur/Vg22TDQkAhNeXLeytpFR9789k0oivuS9uCpHIFOdP9
        UQS36RUfyEzTehfXeT13aT8qm/9wsDbgagQzF0//b/jr9hcn3MtPzuJyxn4sgbMUIv+FtBBqzC3
        PKZS5Klytis/AD4h8
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr11756548wmj.1.1580308055448;
        Wed, 29 Jan 2020 06:27:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwFm2Tw+YWnfE559ABE3YpBlo6s1p5UfJOT/2DSYudzFGLeXIV9kwiEqHYWyYXHDq14AS9M3g==
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr11756514wmj.1.1580308055153;
        Wed, 29 Jan 2020 06:27:35 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id d204sm2480650wmd.30.2020.01.29.06.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 06:27:34 -0800 (PST)
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        vipul kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
References: <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
 <30d49be8-67ad-6f32-37a8-0cdd26f0852e@redhat.com>
 <87sgjz434v.fsf@nanos.tec.linutronix.de>
 <20200129130350.GD32742@smile.fi.intel.com>
 <0d361322-87aa-af48-492c-e8c4983bb35b@redhat.com>
 <20200129141444.GE32742@smile.fi.intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <91cdda7a-4194-ebe7-225d-854447b0436e@redhat.com>
Date:   Wed, 29 Jan 2020 15:27:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129141444.GE32742@smile.fi.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 29-01-2020 15:14, Andy Shevchenko wrote:
> On Wed, Jan 29, 2020 at 02:21:40PM +0100, Hans de Goede wrote:
>> On 29-01-2020 14:03, Andy Shevchenko wrote:
>>> On Tue, Jan 28, 2020 at 11:39:28PM +0100, Thomas Gleixner wrote:
>>>> Hans de Goede <hdegoede@redhat.com> writes:
> 
> ...
> 
>>>> Typical crystal frequencies are 19.2, 24 and 25Mhz.
>>>
>>> Hans, I think Cherrytrail may be affected by this as the others.
>>> CHT AFAIK uses 19.2MHz xtal.
>>
>> Are you sure?
> 
> I'm not. I may mixed this with PMC clock.

Ok, then I'm going to go with 25MHz for now.

>> The first 5 entries of the CHT MSR_FSB_FREQ documentation exactly
>> match those of the BYT documentation (which has only 5 entries),
>> which suggests to me that CHT is also using a 25 MHz crystal.
>>
>> I can also make the other CHT only frequencies when assuming a 25
>> MHz crystal, here is a bit from the patch I'm working on for this:
>>
>> /*
>>   * Cherry Trail SDM MSR_FSB_FREQ frequencies to PLL settings map:
>>   * 0000:   25 * 20 /  6  =  83.3333 MHz
>>   * 0001:   25 *  4 /  1  = 100.0000 MHz
>>   * 0010:   25 * 16 /  3  = 133.3333 MHz
>>   * 0011:   25 * 28 /  6  = 116.6667 MHz
>>   * 0100:   25 * 16 /  5  =  80.0000 MHz
>>   * 0101:   25 * 56 / 15  =  93.3333 MHz
>>   * 0110:   25 * 18 /  5  =  90.0000 MHz
>>   * 0111:   25 * 32 /  9  =  88.8889 MHz
>>   * 1000:   25 *  7 /  2  =  87.5000 MHz
>>   */
>>
>> The only one which is possibly suspicious here is this line:
>>
>>   * 0111:   25 * 32 /  9  =  88.8889 MHz
>>
>> The SDM says 88.9 MHz for this one.
> 
> Anyway it seems need to be fixed as well.
> 
> Btw, why we are mentioning 20 / 6 and 28 / 6 when arithmetically
> it's the same as 10 / 3 and 14 / 3?

I copied the BYT values from Thomas' email and I guess he did not
get around to simplifying them, I'll use the simplified versions
for my patch.

Regards,

Hans



