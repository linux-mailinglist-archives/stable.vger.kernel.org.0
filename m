Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252E7149659
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 16:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAYPqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 10:46:51 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34368 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYPqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 10:46:51 -0500
Received: by mail-yb1-f193.google.com with SMTP id w17so2627030ybm.1;
        Sat, 25 Jan 2020 07:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0HpMnKuQ13CXcvq8WRFBP0W35enuEY45QliPMV8nJdA=;
        b=D9SqrNVf907tFfv22pxqSkkCNnDMUeARyYHgrR2XN3/gAxRPxXrCwagiQgqmaWx/Eh
         LDGuHzr2V0x3XJLjzbD+sqaYOHRztly28rKinQC4w8qH28xczTpP+DI+k0CQh9M6xIU7
         dglD+CT/l6Y6kKKpG48eUzDjkLGdBObbT2oJUpdlJOT1L+qa7yuqeMN9SpOnMCpnjfqP
         sbDRtboU2/fr07dZ/wKxHBUBtUHRfmZRK46b82Bdkfci7MUCxoICTQL789wPdjMKIIuT
         6uCbTVGy1XLzjDOlyGVzT1HuC9iHmwgMLcknVnlf5kNLzgKx73xk9jPeWP31w3DJz/TV
         tNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0HpMnKuQ13CXcvq8WRFBP0W35enuEY45QliPMV8nJdA=;
        b=jLbrzvZL9wNDZ4qV8oypPFv6/i7048mqPZsV5TfKuFIyu6fvX89vx+bQsHgeC6yY87
         XlUBaPqsVgLe1IwCmiJx7ZW8ST+27mSDE6t0CMfO+7Xpu/kYVzZl7CbK0iFSrb2Mz2e9
         oMkqAX9MWnmXk1eNlgxKDBwKgXXUqUu3wSd/QqFwaW2/rrn5j5HSnenI6r0nflgUmcjv
         fOwRybUnXc/zK1eDU/0619kwhbw/jikVV6pdeDq1uxv8fFS9PrRwVBlz8IjsQif1sQRV
         DPtUogJvOIq5MbscggIn/jYbV9AtWolq4eGRTzKpgPRcm2872c1oG6vy62KTNGRPNFKM
         KITA==
X-Gm-Message-State: APjAAAUV7Fj0Jbw+0bo9adDQL7dWKkVlj14WuHiYIqK7/7JgzfaD2HyE
        uTH5SoG29Rh1oqlZ1YVeyJqoJkUh
X-Google-Smtp-Source: APXvYqyHjAB5Ui3Om0EFYjY+B9Wiklfo/+/sC02dHKHo7e5HKtSsofsdKPBYJefwq972gJBxLZDeAw==
X-Received: by 2002:a25:d413:: with SMTP id m19mr6432911ybf.51.1579967210148;
        Sat, 25 Jan 2020 07:46:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c21sm926829ywb.71.2020.01.25.07.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 07:46:49 -0800 (PST)
Subject: Re: [PATCH 4.19 000/639] 4.19.99-stable review
To:     Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200124093047.008739095@linuxfoundation.org>
 <23f2a904-3351-4a75-aaaf-2623dc55d114@nvidia.com>
 <20200124173659.GD3166016@kroah.com>
 <8a782263-aca3-3846-12a0-4eb21f015894@nvidia.com>
 <87fcb1f0-b1b8-a6e2-b8f6-b95a07f67919@nvidia.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <eadee1dd-fb6d-855d-935a-4bf93a9ad505@roeck-us.net>
Date:   Sat, 25 Jan 2020 07:46:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <87fcb1f0-b1b8-a6e2-b8f6-b95a07f67919@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/20 3:32 AM, Jon Hunter wrote:
> 
> On 24/01/2020 18:07, Jon Hunter wrote:
>>
>> On 24/01/2020 17:36, Greg Kroah-Hartman wrote:
>>> On Fri, Jan 24, 2020 at 02:50:05PM +0000, Jon Hunter wrote:
>>>> Hi Greg,
>>>>
>>>> On 24/01/2020 09:22, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 4.19.99 release.
>>>>> There are 639 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sun, 26 Jan 2020 09:26:29 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.99-rc1.gz
>>>>> or in the git tree and branch at:
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>> -------------
>>>>> Pseudo-Shortlog of commits:
>>>>
>>>> ...
>>>>
>>>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>>>      PCI: PM: Skip devices in D0 for suspend-to-idle
>>>>
>>>> The above commit is causing a suspend regression on Tegra124 Jetson-TK1.
>>>> Reverting this on top of v4.19.99-rc1 fixes the issue.
>>>
>>> This is also in the 4.14 queue, so should I drop it there too?
>>
>> I did not see any failures with the same board on that branch, so I
>> would say no, but odd that it only fails here. It was failing for me
>> 100% so I would have expected to see if there too if it was a problem.
> 
> Hmmm, rc2 still not working for me ...
> 
> Test results for stable-v4.19:
>      11 builds:	11 pass, 0 fail
>      22 boots:	22 pass, 0 fail
>      32 tests:	30 pass, 2 fail
> 
> Linux version:	4.19.99-rc2-g24832ad2c623
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra30-cardhu-a04
> 
> I still see the following commit in rc2 ...
> 
> commit bb52152abe85f971278a7a4f033b29483f64bfdb
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Jun 13 23:59:45 2019 +0200
> 
>      PCI: PM: Skip devices in D0 for suspend-to-idle
> 
> BTW, I checked the 4.14. queue and I do not see the above change in
> there, however, there is similar change ...
> 
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>      PCI: PM: Avoid possible suspend-to-idle issue
> 
bb52152abe85 fixes this one, which in turn fixes 33e4f80ee69b.
The above in 4.14 but not its fixes is spelling a bit of trouble.

Maybe commit 471a739a47aa7 ("PCI: PM: Avoid skipping bus-level
PM on platforms without ACPI") was added to -rc2, since it is
supposed to fix bb52152abe85.

Guenter
