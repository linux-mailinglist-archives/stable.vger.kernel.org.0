Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4205718D654
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 18:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCTR6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 13:58:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38740 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgCTR6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Mar 2020 13:58:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id z5so3685770pfn.5;
        Fri, 20 Mar 2020 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4NvFUm9LJovvBIAOq/vqlViRCl9CGv4yM5u91WabY3I=;
        b=H9tQQaMyaRARyLuCBE9PyNvgN6D77VY016XqLf5ejDxSnKQks3mUdI2i0RQNo46D/+
         SjQzGACdX7Wld+vCqSvBNMwBTrr168/LgFADj4yr8fx34zm7TaajrnOUz3ADnBpHp3x6
         mhZswtcO1uPTLZumOYqt8GEEH7LKVGqzCDzxw/RUHTY2KJ1W7lruIuhR88si8cVxQI2k
         D9yomT9G5dtNN71rq1QsKROv7yxsuJ5MFlCHzwfTvXp5sLCbFH215WT3yzNLdRdvtDSp
         PpuQUgYEgoFW0cI7mXSiLD/AVwY/670sfIMCxyRxGsImH2H0LrelM9o0vTL5MYc+yxfN
         6XiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4NvFUm9LJovvBIAOq/vqlViRCl9CGv4yM5u91WabY3I=;
        b=V7e9ME1kYtadGAVgbJQuw4zHWCF6b2VSWQFnm4Y+Beh4L1iC5NdMMNR+IZa5wpdx6R
         LALoTBvMCe1EVgEGCeSXuETZwBXWttL0WXwixn+uXjl2Ugx3brigyUlFS2vNGemhEnSm
         AC8sEqFb0HxjzsGIENxozJUc8tRU3JC6mIuq8D6IRSW6UXDEgmmIozY/GnJYGp6qOh5b
         b6C+KIiXL43tkLQocI7kQlGaBYfgfNFqkhYzHPs/xgdjYU5vGVlgmusOsp11NrLANxT2
         HZq41wVdKtF/6lJmx6dRAl3YCIYrcHmoiWQFX4/iKQ1bwwyOyzhEynlLL4vF/kLj3t+X
         I/5A==
X-Gm-Message-State: ANhLgQ1WbgbdQfTwlQvVtUPQ2rJuVFyhB0dhYivHYEe69Z40MfKExdVj
        B+sSNBdMQxF3xco1Oouu9Hc=
X-Google-Smtp-Source: ADFU+vs5GgtCS7YhNRaVNIXMwNdA6YYSR2wxbtWDxIgnJkC3OyoxBL3EtOgRGBKIpBGAzGjYqQxhew==
X-Received: by 2002:aa7:9844:: with SMTP id n4mr10453210pfq.98.1584727126154;
        Fri, 20 Mar 2020 10:58:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l25sm5820007pgn.47.2020.03.20.10.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:58:45 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/48] 4.19.112-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Faiz Abbas <faiz_abbas@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
References: <20200319123902.941451241@linuxfoundation.org>
 <CA+G9fYsDw6JEznSHm2X=Wvq1dysGbGa4-VpXJyzKWZQxLMdagw@mail.gmail.com>
 <7a8c6a752793f0907662c3e9c197c284fc461550.camel@codethink.co.uk>
 <20200320080317.GA312074@kroah.com> <20200320081122.GA349027@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <04164e5e-8cec-54cd-c4bd-f72bba86b5da@roeck-us.net>
Date:   Fri, 20 Mar 2020 10:58:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200320081122.GA349027@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/20/20 1:11 AM, Greg Kroah-Hartman wrote:
> On Fri, Mar 20, 2020 at 09:03:17AM +0100, Greg Kroah-Hartman wrote:
>> On Thu, Mar 19, 2020 at 08:00:32PM +0000, Ben Hutchings wrote:
>>> On Fri, 2020-03-20 at 01:12 +0530, Naresh Kamboju wrote:
>>>> On Thu, 19 Mar 2020 at 18:50, Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>> This is the start of the stable review cycle for the 4.19.112 release.
>>>>> There are 48 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.112-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>> Faiz Abbas <faiz_abbas@ti.com>
>>>>>     mmc: sdhci-omap: Fix Tuning procedure for temperatures < -20C
>>>>>
>>>>> Faiz Abbas <faiz_abbas@ti.com>
>>>>>     mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning
>>>>
>>>> Results from Linaro’s test farm.
>>>> No regressions on arm64, arm, x86_64, and i386.
>>>>
>>>> NOTE:
>>>> The arm beagleboard x15 device running stable rc 4.19.112-rc1, 5.4.27-rc1
>>>> and 5.5.11-rc2 kernel pops up the following messages on console log,
>>>> Is this a problem ?
>>>>
>>>> [   15.737765] mmc1: unspecified timeout for CMD6 - use generic
>>>> [   16.754248] mmc1: unspecified timeout for CMD6 - use generic
>>>> [   16.842071] mmc1: unspecified timeout for CMD6 - use generic
>>>> ...
>>>> [  977.126652] mmc1: unspecified timeout for CMD6 - use generic
>>>> [  985.449798] mmc1: unspecified timeout for CMD6 - use generic
>>> [...]
>>>
>>> This warning was introduced by commit 533a6cfe08f9 "mmc: core: Default
>>> to generic_cmd6_time as timeout in __mmc_switch()".  That should not be
>>> applied to stable branches; it is not valid without (at least) these
>>> preparatory changes:
>>>
>>> 0c204979c691 mmc: core: Cleanup BKOPS support
>>> 24ed3bd01d6a mmc: core: Specify timeouts for BKOPS and CACHE_FLUSH for eMMC
>>> ad91619aa9d7 mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
>>
>> Ok, I've now dropped that patch, which also required me to drop
>> 1292e3efb149 ("mmc: core: Allow host controllers to require R1B for
>> CMD6").  I've done so for 5.5.y, 5.4.y, and 4.19.y.
> 
> Ugh, I forgot, that broke other things.  I'm going to go rip out a bunch
> of mmc patches now...
> 
For v4.19.111-44-gd078cac:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Guenter
