Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0127306AAB
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 02:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhA1Bre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 20:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhA1Br3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 20:47:29 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F0CC061573;
        Wed, 27 Jan 2021 17:46:49 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id e70so3725359ote.11;
        Wed, 27 Jan 2021 17:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9zxL+Xh/GiGjMNr2zojIuA/hQyF+jMwVwqRuljPa8dM=;
        b=lo6xLwQxrdLBwy6lIEtyBjY/DScnLt6mbDkOr9/g5JJhP2A1vg5ByJcf3SljZ//gLz
         OR8m4QQpc7QxnngXF8BcgBV/J2ALo8xD09THnBPRu4XneBRakSMJGrcGEVyCSgnwg2kG
         SsPKYdb6tTFDJA94o3T3Pv6vbGtS8IRRrTdGMPevhhMHJvdee+z/rYeMuNnr16va2wk/
         mgGPEemkCOnLJssIJFhKsngOCsJd63ulnyb26VfNNUlrLTsrjc3b92S7V6hpAfmdbREY
         yVaUrAssGNLP2avvy+DpfXfu+n1rcbEE+HqF5RBX+jQlp1codlXeryha3pSKCMdR2/AM
         SIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9zxL+Xh/GiGjMNr2zojIuA/hQyF+jMwVwqRuljPa8dM=;
        b=cL45FM4FQrB3x0jqBcfo9xf+kQXfx4Df8Q9SiBQE53hBZ7jSQhm68BOejgAb75nbuG
         eqLWJYshhtaxA7ojE4vs48ywb8Bh1u1dm1dVlJeqO8kGa0vOGm+8fWZlVtH+jVgiYN93
         Qizgp33X+kt0m6dPQnOY7vTLh3o/dVJI124qSN7AW2hQ/DUN9j+Bd8+kRj7ZfPZ7KVF7
         IjlZ5ybEwH/BUNphAEbNPIZfTkUpuPmy89Z7jI3a9a3x3kjDqFZy+PDJmSQ82iT66bwa
         EI40Y4UGrh+Ejbia0a6ATxS422SxRB/4BVIAGAPNEzb1Rtg6Gk/I6I6zDVT04LC4Lfae
         1wAw==
X-Gm-Message-State: AOAM532Z+c+5hbFRgPS/nThjdek6DIr7+mIb6H3P6FB4BdhTQzquJtJh
        WrrD7Km8h0DLAKoxf5P0WcFYoPLYWzw=
X-Google-Smtp-Source: ABdhPJx+aKPSWRepxZxGjP1Z08LORw+WxUgDydXJAIpHYyfa6l51f+qRfW4Oj0OoI/ne1FF/SY2icA==
X-Received: by 2002:a9d:2c48:: with SMTP id f66mr9639858otb.239.1611798408225;
        Wed, 27 Jan 2021 17:46:48 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s123sm810889oos.3.2021.01.27.17.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:46:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali> <20210125201938.GB78651@roeck-us.net>
 <20210125202130.afwhcuznietmqo5s@pali> <20210127230001.7zeeczkfj33zj5sw@pali>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <aef96a2a-9e27-32a2-62a5-92b8d87b9136@roeck-us.net>
Date:   Wed, 27 Jan 2021 17:46:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210127230001.7zeeczkfj33zj5sw@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/21 3:00 PM, Pali Rohár wrote:
> On Monday 25 January 2021 21:21:30 Pali Rohár wrote:
>> On Monday 25 January 2021 12:19:38 Guenter Roeck wrote:
>>> On Mon, Jan 25, 2021 at 11:05:40AM +0100, Pali Rohár wrote:
>>>> On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
>>>>> It has been reported[0] that the Dell XPS 15 L502X exhibits similar
>>>>> freezing behavior to the other systems[1] on this blacklist. The issue
>>>>> was exposed by a prior change of mine to automatically load
>>>>> dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
>>>>> this model to the blacklist.
>>>>>
>>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
>>>>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
>>>>>
>>>>> Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
>>>>> Cc: stable@vger.kernel.org
>>>>> Reported-by: Bob Hepple <bob.hepple@gmail.com>
>>>>> Tested-by: Bob Hepple <bob.hepple@gmail.com>
>>>>> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
>>>>> ---
>>>>>
>>>>>  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
>>>>>  1 file changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
>>>>> index ec448f5f2dc3..73b9db9e3aab 100644
>>>>> --- a/drivers/hwmon/dell-smm-hwmon.c
>>>>> +++ b/drivers/hwmon/dell-smm-hwmon.c
>>>>> @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
>>>>>  			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
>>>>>  		},
>>>>>  	},
>>>>> +	{
>>>>> +		.ident = "Dell XPS 15 L502X",
>>>>> +		.matches = {
>>>>> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>>>>> +			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
>>>>
>>>> Hello! Are you sure that it is required to completely disable fan
>>>> support? And not only access to fan type label for which is different
>>>> blaclist i8k_blacklist_fan_type_dmi_table?
>>>>
>>>
>>> I'll drop this patch from my branch. Please send a Reviewed-by: or Acked-by: tag
>>> if/when I should apply it.
>>
>> Of course! We will just wait for Bob test results.
> 
> Guenter, now we have all needed information, fix is really needed in
> this form. So you can add my:
> 
> Reviewed-by: Pali Rohár <pali@kernel.org>
> 

Applied (again)

Thanks,
Guenter
