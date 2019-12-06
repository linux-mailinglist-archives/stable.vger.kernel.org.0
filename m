Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B01155E2
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 17:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfLFQ4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 11:56:19 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35861 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfLFQ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 11:56:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id x184so2182846pfb.3;
        Fri, 06 Dec 2019 08:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ux+f+Nau75JwdbE4emjx8UpFsrP8QXJmcDtvXXDzHeM=;
        b=dzy+6eljRSsfdHi2oS9Z4J/cuWgMm9HnNnD5VYem8eJkTo43i0mgotulazqOlzuFtg
         bIjKYAMt3yhMxLJWX7NIC4HYbTPkyxAbI62DlWy+hNQq79hP0I+64uybAM0CnAFcQW5P
         B8vMtYwLEhrwM3gYt+p5D7kX13InDXFfiH9ZkQvCbCR5AzHb0+1HX7JvImGtjryDYdlf
         MMGxF/XwKmAJuEbPkhFfmWyeSgrwNI5nM7TJvMk1GGXjRGg4QaYx7ky+bsJNxga8eP/B
         2cVVJZXUGJLvIZF70TbR3+fTslteOC8Nnqo6CRYcDKtPkzdvHzh/DikIa+ADY/jcLu8U
         BzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ux+f+Nau75JwdbE4emjx8UpFsrP8QXJmcDtvXXDzHeM=;
        b=BJlbFmEckyQsWV7MumKSc+8J4DXRRBPdfx6shu8qTjpUsUVsSqjxefT6NwM2Xyuu89
         00rmCuczfyoK/Pp+CrJ2PQTfuK3N8PnwdNrFBsfGxZSeDGQmjCFDIphP4Z0YAD7pmmje
         6I98Dw4vcCwgScQ2nDyDG+aMB4vWXyHbQjyBDzTlF8lagwqWJtidBM3WzQQ4z5AlrtCz
         57ht8uj4vxkRKRT/GPWMYavPufXayGCFjqcCpAmPCgq9eLlvgjBlrYBVzc1KCP7n6JND
         mR1I4uqWaFndyElGg7zUzqHGpcueXds7IMQVEPSGtQNDbbUVQqKgILkDhyaGed1NZi8c
         7uqg==
X-Gm-Message-State: APjAAAWVQc2mGSCT0SfJRX3ljMBVmF7QLBtwuQYGP0E0HLjfofbkLLd7
        aTzcnMnAXugEpqXeU9kZLVYjCQ8t
X-Google-Smtp-Source: APXvYqzoCRTTuo/ofjO2p1Pn+UY6q8rXJioZYu3Wed+FNmjVnKPt5EtVofUrhXYf8nE+8DTZG3TfUQ==
X-Received: by 2002:a62:383:: with SMTP id 125mr9746402pfd.248.1575651377596;
        Fri, 06 Dec 2019 08:56:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j28sm16075278pgb.36.2019.12.06.08.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 08:56:16 -0800 (PST)
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
To:     shuah <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191204175321.609072813@linuxfoundation.org>
 <1dac10cd-7183-9dfd-204c-05fae75bcd74@kernel.org>
 <20191206152823.GA75339@kroah.com>
 <785c9534-1eb2-ea9b-8c9b-6713fdefdd01@kernel.org>
 <e04a233b-0854-2dd4-060e-47e1013879ee@roeck-us.net>
 <f7e72654-42a6-864a-4b4c-41adcce74404@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <5e923897-6bc6-5756-1283-39e5ff1481b7@roeck-us.net>
Date:   Fri, 6 Dec 2019 08:56:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <f7e72654-42a6-864a-4b4c-41adcce74404@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/19 8:23 AM, shuah wrote:
> On 12/6/19 9:10 AM, Guenter Roeck wrote:
>> On 12/6/19 7:35 AM, shuah wrote:
>>> On 12/6/19 8:28 AM, Greg Kroah-Hartman wrote:
>>>> On Fri, Dec 06, 2019 at 08:24:36AM -0700, shuah wrote:
>>>>> On 12/4/19 10:53 AM, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 4.14.158 release.
>>>>>> There are 209 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>> The whole patch series can be found in one patch at:
>>>>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
>>>>>> or in the git tree and branch at:
>>>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
>>>>>> and the diffstat can be found below.
>>>>>>
>>>>>> thanks,
>>>>>>
>>>>>> greg k-h
>>>>>>
>>>>>
>>>>> Starting with Linux 4.14.157, 4.9.204, and 4.4.204 stables stopped
>>>>> booting on my system. It can't find the root disk. No config changes
>>>>> in between.
>>>>>
>>>>> I have been bisecting 4.14 and 4.9 with no luck so far. I updated
>>>>> to Ubuntu 19.10 in between.
>>>>>
>>>>> The only other thing I see is CONFIG_GCC_VERSION which is supported
>>>>> starting 4.18. I don't this boot failing issue on 4.19 + up. I am
>>>>> also chasing any links between this config and scripts and tools
>>>>> that generate the initramfs.
>>>>
>>>> Did you also upgrade your version of gcc?  I know I build those older
>>>> kernels with the latest version of gcc for build tests, but I do not
>>>> boot them.  I think everyone who still uses them uses older versions of
>>>> gcc.
>>>
>>> Yes. gcc version changed. That has been my strong suspect since I started poking around the CONFIG_GCC_VERSION.
>>>
>>
>> What version of gcc are you using ? I currently use gcc 8.3.0 for all
>> qemu boot tests (except for 3.16 which doesn't support it, or at least
>> it didn't when I last checked), and have not observed any problems.
>>
> 
> With the upgrade gcc version went from 8.3.0 to 9.2.1
> 
> Interestingly enough all the older 4.14, 4.9, and 4.4 kernel I have
> on the system boot just fine. It fails when build newer rcs with new
> gcc, boot fails.
> 
> I would really like to understand it just in case something in our
> kbuild scrips is the issue.
> 

v4.4.206 boots for me into qemu when compiled with gcc 9.2.0 (9.2.1 does not
appear to be an official release). So at least it isn't that simple. Let me
know if I can test anything else.

Thanks,
Guenter
