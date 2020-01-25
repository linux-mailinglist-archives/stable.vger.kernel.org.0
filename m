Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC91149764
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 20:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgAYTPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 14:15:10 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:32850 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 14:15:10 -0500
Received: by mail-yw1-f67.google.com with SMTP id 192so2714280ywy.0;
        Sat, 25 Jan 2020 11:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gVIu3ANFBGqPHt5YpcXKFOsWWJSpzcjW04aSB17DZsQ=;
        b=Blv863uek7BG2QNlgQc6ZtWXNmtq191HBVgp9hw1q1o9lZpveHOgRilm2+30Ip6Ngs
         pycOdbY39oraoEwovy21aTkiuJMgEsDv4ZHgQ2Yb4KNrUsy3l+rQFhbWp6eTOHEo0s6+
         GOrN0S7g9iIiDjIB2B58Iclw2EK41s0MSH1f65V5zzXnDB7eJIVfLRBsSYJDNvZAV8Vc
         cDCx7JfJhhFHZHwz5El3yoh4nGIobXJa/M7xuhgEED0ZqVQK/qBtv7vBbnfRwkRutsZW
         FEpiStXP6CrOMuneNXTANXin4E1zBvHDRZLO4sF4CxHgiMI+DqnqyWDMhh904ulirfWe
         QJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVIu3ANFBGqPHt5YpcXKFOsWWJSpzcjW04aSB17DZsQ=;
        b=Af+/AgXByzSv32UWY6wuWUdlBhiAogvLD0FqTM9zmGNHXi13I+9MZRI8b1BYjzGoIU
         AyvDh+bEzO8tsxPrk9PbTOUAuJLXN1fdiIJxwaVFhJqQmilFHvBdQzvYYNP5rxdqtHfb
         Qs4XZVwxc3l5WwAWHP04Qanlr3TQX9/iyNAZgXxNDBc2agIlpkpvuw2FxRH+gHzkFtOg
         XlyMV3WbNqCtwQcIginNq1arQxbFnWkZTX2iHFNKGrw9QqPtV/o2+m2KWxTPB5BIlS6M
         PJ1RyZhZxIKTvFIqHSrNmWPAVku1DgYDTi/TWYDUf08AWG7sTGhpFMcfjVApGdsGJDne
         ihsg==
X-Gm-Message-State: APjAAAUOJkwm5WUjjgMFZQH4j2tmpKe6vGFuPrj3Pj8DhqRdgPUR8oPl
        l3ydwnwTogT5LlB6piayxIraz4p3
X-Google-Smtp-Source: APXvYqxdjmiFY/ZuMr/x5G3hemgvHZE+sCniybmoAyXj9JGrA0gIPXLA5UWBTCmWehIq+G/liC7Vsg==
X-Received: by 2002:a81:5ad4:: with SMTP id o203mr6260075ywb.262.1579979709001;
        Sat, 25 Jan 2020 11:15:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x84sm4158920ywg.47.2020.01.25.11.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 11:15:08 -0800 (PST)
Subject: Re: [PATCH 4.19 309/639] hwmon: (w83627hf) Use request_muxed_region
 for Super-IO accesses
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093125.642179022@linuxfoundation.org>
 <20200125185935.GF14064@duo.ucw.cz>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9639ba77-ece0-d825-a1b0-cbf8b45af3ab@roeck-us.net>
Date:   Sat, 25 Jan 2020 11:14:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200125185935.GF14064@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/20 10:59 AM, Pavel Machek wrote:
> Hi!
>> [ Upstream commit e95fd518d05bfc087da6fcdea4900a57cfb083bd ]
>>
>> Super-IO accesses may fail on a system with no or unmapped LPC bus.
>>
>> Also, other drivers may attempt to access the LPC bus at the same time,
>> resulting in undefined behavior.
>>
>> Use request_muxed_region() to ensure that IO access on the requested
>> address space is supported, and to ensure that access by multiple drivers
>> is synchronized.
>>
> 
>> @@ -1644,9 +1654,21 @@ static int w83627thf_read_gpio5(struct platform_device *pdev)
>>   	struct w83627hf_sio_data *sio_data = dev_get_platdata(&pdev->dev);
>>   	int res = 0xff, sel;
>>   
>> -	superio_enter(sio_data);
>> +	if (superio_enter(sio_data)) {
>> +		/*
>> +		 * Some other driver reserved the address space for itself.
>> +		 * We don't want to fail driver instantiation because of that,
>> +		 * so display a warning and keep going.
>> +		 */
>> +		dev_warn(&pdev->dev,
>> +			 "Can not read VID data: Failed to enable SuperIO access\n");
>> +		return res;
>> +	}
>> +
>>   	superio_select(sio_data, W83627HF_LD_GPIO5);
>>   
>> +	res = 0xff;
>> +
> 
> This is strange. res is not actually assigned in the code above, so we
> have res = 0xff twice. Can we remove one of the initializations and do
> 'return 0xff' directly to make code more clear?
> 
> 
>> @@ -1677,7 +1699,17 @@ static int w83687thf_read_vid(struct platform_device *pdev)
>>   	struct w83627hf_sio_data *sio_data = dev_get_platdata(&pdev->dev);
>>   	int res = 0xff;
>>   
>> -	superio_enter(sio_data);
>> +	if (superio_enter(sio_data)) {
>> +		/*
>> +		 * Some other driver reserved the address space for itself.
>> +		 * We don't want to fail driver instantiation because of that,
>> +		 * so display a warning and keep going.
>> +		 */
>> +		dev_warn(&pdev->dev,
>> +			 "Can not read VID data: Failed to enable SuperIO access\n");
>> +		return res;
>> +	}
> 
> Direct "return 0xff" would make more sense here, too.
> 

Please feel free to submit a patch to improve the upstream code.

Thanks,
Guenter

