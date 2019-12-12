Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B1B11C25D
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 02:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfLLBki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 20:40:38 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33620 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfLLBkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 20:40:37 -0500
Received: by mail-pf1-f195.google.com with SMTP id y206so247719pfb.0;
        Wed, 11 Dec 2019 17:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dwmsUJYMt5xrrap+rvfe8cg+cZO6d3WRlJ1DUVNQLrA=;
        b=NDaEK2LvN7DRpEq/EzAJxx1bUoOsY72Sig4eLwIO2jiAOe8xMnz1uwP2DoApqOSc1G
         S5lmmqXRbprDAe16ci3b3jRVE1q7LsZOIB0AuPlBdfQ8lq72Rd+CXkGkt8s4iNqG1WL4
         +7KRlNImlczrjqIq3Xw1bEVipkgHKnN8+40d6QzA2u24faAaw1HrVUFhzMWG8fYXmued
         cSCKN7+ku0zzQ3P10y62Y2tK1BFkzbk02FtlaUGQvtHPHzzatMlboiRlNKofgGKcPTaK
         TdAAscL5oCymKMSpXGSvePUPeB1EEuVdkj0rm2bGth72Zg+8HSvf9CMJhcThzJKdPJfg
         udhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:subject:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dwmsUJYMt5xrrap+rvfe8cg+cZO6d3WRlJ1DUVNQLrA=;
        b=ZVjgDfI2bVKT9ruRw3wn/REAwZwsD1kEIK75FhrWff/ZMD8XbNCiKhYndWr79IreVS
         GKm/HUnqdSzqMpn8dhc2sIFRXVMXF9XD8gyeI04Y9olPcVLThoEkVO/YKliV5Sw3QeKi
         E36Dy8p9uOLdUI/EDBfYwBSbRPhy/68Tw36ZlD7yh1oSTOzGx8J4vDNGJM+ln8JPBuNb
         5PE34xUqiOuGxlVGSBHOFhfCfhnug/lMOm5PKjrqn4mOVrZFTG6I8RnXNs9O6vxlfEwF
         RmcA8WAIHwernzzRs+Xz0VX6izVId1Hv5q8sfDuzR9d1u+VasSNCN5PWm4APkScFQuwe
         oqxQ==
X-Gm-Message-State: APjAAAV1wdLEpnTvP0n8zNLSC+ZPFBDrZxLaoSMI3rHq75loOpdpxeBn
        F9gQEysT0sXvrVEHsh9bzh7mXKxW
X-Google-Smtp-Source: APXvYqzDjWjamdpFJ43MLw86QvYZg6zyr+221X4XxbjOUtxe47fIrUtZtPONGIm3NJWAfXS+h2UmbA==
X-Received: by 2002:aa7:9145:: with SMTP id 5mr7172058pfi.74.1576114836495;
        Wed, 11 Dec 2019 17:40:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16sm4449070pfo.12.2019.12.11.17.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 17:40:35 -0800 (PST)
From:   Guenter Roeck <linux@roeck-us.net>
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
Message-ID: <8de7c018-32c7-f46e-4c43-ea3a70378a14@roeck-us.net>
Date:   Wed, 11 Dec 2019 17:40:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
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

I dimly recall that this was a problem before. Ah yes ... commit 89a5e15bcba8
("gpio/mmc/of: Respect polarity in the device tree") fixes the above commit.
Can you give it a try ?

[ One may wonder though why this was back-ported in the first place. ]

Thanks,
Guenter
