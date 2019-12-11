Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51DB11C0C2
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfLKXsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:48:47 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34197 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfLKXsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:48:47 -0500
Received: by mail-pj1-f65.google.com with SMTP id j11so227616pjs.1;
        Wed, 11 Dec 2019 15:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0gDghqppbyjz+43tzAq1YgtN2CX9ITE/3fXeQwGT4sE=;
        b=QPpFqlSrNdDgZnIvJjcgQD6ZBX/AKaRZFiwnCHu4a2a3lk4rLIOd85HL1M9FsmzN+2
         Yti58LZY1PdPnFFLbNCDa5Bf7mYfDoWbtafqfP008rvlkNnDOGl9Bk0TvMrby5u1gF7K
         xH4eXE7gkf1Aww/HgqX2rUaKpP1SiqHNVjCE0JfcwaQLhUyKUP5e7goJymvopAUsfDqG
         G/pabeXrT84lb1PKtuCz09oUUD2jUcrDw5MtV2mF9hPnNeyhlFPQDyLZrO1NiPTI7mim
         kbSGCF1CRyoWWAtNWIADiDGLRAmLajvQnXKr2iwZyseZLAuMem953GKRBM20U0vTP9m+
         rmoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0gDghqppbyjz+43tzAq1YgtN2CX9ITE/3fXeQwGT4sE=;
        b=SEB0VsNMgJh/7oQKMVa2PZuGaZ/mnK6mETjBwiL98mJkXc3VF9VcjvQHn6em/SQ8Jl
         cW68gUtuDraQxtfVNrhZEAbjFbdpYTwFFa2hxTZYtOeUVv17vJp0e+Jkf3/OV+HvHKr/
         B3OjmhXKlA8BEDElEiCm6U4Db8K3WulSDDsQdVGLy57KIOItTeWFaosS2QacZoElOsHn
         F9hS/+7V6g4uS9LwMnLYk5fDCPbkKm92CBFYbjs64jB8jFwgPd4k4aZIjfWZWEcqB/+P
         LQL9dgPS7PWxYbbkd5ktFnXNvhF0fT1eaCEGeP+gg9wAtgN5GQgjFNdjgKx/adEwsw7r
         JTcQ==
X-Gm-Message-State: APjAAAXMwcrx92vPx38RwzIppbwT6DKPXz4u7Yn4e+8mzrtw1KludPye
        kqDD6Qg4mkCbCN/hwekF7t+WEtgL
X-Google-Smtp-Source: APXvYqwIywNExRJeiqWLpl1Oj8ZqxEbFHFVUbm+N/8RWzhT2YSAMSK5ssXG42pHgfMXUmvpYEo2uBw==
X-Received: by 2002:a17:902:8bc5:: with SMTP id r5mr6428292plo.189.1576108126324;
        Wed, 11 Dec 2019 15:48:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a15sm4478138pfh.169.2019.12.11.15.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 15:48:45 -0800 (PST)
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
To:     Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191211150339.185439726@linuxfoundation.org>
 <7b43a504-160f-e793-99b2-bcb79d331b6a@nvidia.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1c0a27c1-1c98-347f-fcd4-9ec057e1e362@roeck-us.net>
Date:   Wed, 11 Dec 2019 15:48:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <7b43a504-160f-e793-99b2-bcb79d331b6a@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/19 1:36 PM, Jon Hunter wrote:
> 
> On 11/12/2019 15:02, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.89 release.
>> There are 243 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.89-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
> 
> ...
> 
>> Linus Walleij <linus.walleij@linaro.org>
>>      gpio: OF: Parse MMC-specific CD and WP properties
> 
> The above change is causing intermittent failures on Tegra30 eMMC.
> Reverting this change on top of the 4.19.89-rc1 fixes the problem.
> 

Thanks for tracking that down. I see boot failures for arm:vexpress-a9
when trying to boot from mmc.

I dimly recall that I have seen this before. Ah yes ... commit 89a5e15bcba8
("gpio/mmc/of: Respect polarity in the device tree") fixes the above commit.
Can you give it a try ?

One may wonder though why the parsing code was backported in the first place.
It doesn't look like a bug fix to me.

Thanks,
Guenter
