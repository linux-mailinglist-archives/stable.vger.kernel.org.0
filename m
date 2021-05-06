Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF96374D98
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 04:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhEFCgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 22:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhEFCgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 22:36:18 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A11C061574;
        Wed,  5 May 2021 19:35:19 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id e25so4191001oii.2;
        Wed, 05 May 2021 19:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qCaXhu5ADXpDYhRWpbWGou+MLQ2EsYw3ebfI+tHGv6k=;
        b=u3yo6lWRue35V0yoA4W8HDStiPbWY2jdAsrraBUmCr7u16cH9Rv974PLMgL8dH3Koz
         VH735L3sQ5te6rkZdJs6sIexu0HyMlhNj19MnW1QNHkMDcrBlBT806AGcSHWl8YdFNh2
         laBEDRHyU2d0/OlypNQ1tozarijD8B07PDOX7xveNNToJCodBUGXn/y36y7VWanEzKWb
         vjID8REisU1yFWW3UsiUBRVCTVSsW26SKOnQvsnF9IB2rfVQBR/bNgBb7Xkf5yJOSrvy
         3BfVbrrz6TKlIYa3Wkd1a7BKl8tCkPWoR2SNUK0o5foMdNdpnJACRYFnP+H1XLvQ+xTd
         Tv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qCaXhu5ADXpDYhRWpbWGou+MLQ2EsYw3ebfI+tHGv6k=;
        b=tMmRul+5eJJK+FUhGL9Lz39SmWikOrBOGeMW65FfvJv/PZERGKWepTLRCvTXL4DfPz
         6I1jY2zS0pP2wQgbPyS52d9bUQlmBiv0BPkroF2c9+UoM5iO2/mCwTRlm87fxmSCYOu2
         aUISRhH21A+EP4uNqLgdG6IwLE7LJg7ScgFZvWuxtewslXyw4I67GZHo73Bi0CWt7S3y
         +xdLuO24sctdMZn/owuzxgheKdmJ/M5oyEQochP3kCG+xvyPO864aeIjdGr80ZmTgD4h
         1htp+aTbv8LrpxkdtTbedDOcOXqBuv1CiA4JbBN68Rky7uoN09nv2VGXHNhjcccRyDAe
         VY0w==
X-Gm-Message-State: AOAM531LzFA+Y7gpz7A+sn8IltS/G+v4VOqNK+WW2k1pfAdbv+8nInN4
        LbvAJJg4j2F4dkczp3HFdKRuhOOUHNo=
X-Google-Smtp-Source: ABdhPJxvQbihO16Op5aqZzdn4HaaQUQsFnSKzS6TXgQVlX4+HRqvKnTdRBm0PM53a+TVQiKkcZln4A==
X-Received: by 2002:aca:2319:: with SMTP id e25mr3382739oie.38.1620268518072;
        Wed, 05 May 2021 19:35:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24sm269404ooh.28.2021.05.05.19.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 19:35:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        linux- stable <stable@vger.kernel.org>
References: <20210505112324.729798712@linuxfoundation.org>
 <20210505214938.GA817073@roeck-us.net>
 <CAEUSe79HYzZpUWRBz6uPyiWN6smxdUEm02_H4_YL5XyT4x9MGw@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.4 00/21] 5.4.117-rc1 review
Message-ID: <5bac42a7-71b0-e149-97c7-3cf3cd881464@roeck-us.net>
Date:   Wed, 5 May 2021 19:35:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAEUSe79HYzZpUWRBz6uPyiWN6smxdUEm02_H4_YL5XyT4x9MGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/5/21 7:15 PM, Daniel Díaz wrote:
> Hello!
> 
> On Wed, 5 May 2021 at 16:49, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Wed, May 05, 2021 at 02:04:14PM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.4.117 release.
>>> There are 21 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.117-rc1.gz
>>> or in the git tree and branch at:
>>>       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>> Pseudo-Shortlog of commits:
>>>
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>     Linux 5.4.117-rc1
>>>
>>> Ondrej Mosnacek <omosnace@redhat.com>
>>>     perf/core: Fix unconditional security_locked_down() call
>>>
>>> Miklos Szeredi <mszeredi@redhat.com>
>>>     ovl: allow upperdir inside lowerdir
>>>
>>> Dan Carpenter <dan.carpenter@oracle.com>
>>>     scsi: ufs: Unlock on a couple error paths
>>>
>>> Mark Pearson <markpearson@lenovo.com>
>>>     platform/x86: thinkpad_acpi: Correct thermal sensor allocation
>>>
>>> Shengjiu Wang <shengjiu.wang@nxp.com>
>>>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
>>>
>>> Shengjiu Wang <shengjiu.wang@nxp.com>
>>>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
>>
>> Twice ? Why ?
> 
> But different, right? One for 4458 and the other for 5558:
> 
> sound/soc/codecs/ak4458.c:
> +MODULE_DEVICE_TABLE(of, ak4458_of_match);
> 
> sound/soc/codecs/ak5558.c:
> +MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);
> 

Yes, I realized that later. The real problem is that the commits
are already in the tree, so both files end up with two sets of
MODULE_DEVICE_TABLE().

$ git grep MODULE_DEVICE_TABLE sound/soc/codecs/ak4458.c
sound/soc/codecs/ak4458.c:MODULE_DEVICE_TABLE(of, ak4458_of_match);
sound/soc/codecs/ak4458.c:MODULE_DEVICE_TABLE(of, ak4458_of_match);
$ git grep MODULE_DEVICE_TABLE sound/soc/codecs/ak5558.c
sound/soc/codecs/ak5558.c:MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);
sound/soc/codecs/ak5558.c:MODULE_DEVICE_TABLE(of, ak5558_i2c_dt_ids);

That applies to all branches.

> FWIW, our builds passed with that pair of commits.

My test builds pass as well. I think this is because Chrome OS
images build with -Werror.

Guenter

> 
> Greetings!
> 
> Daniel Díaz
> daniel.diaz@linaro.org
> 
> 
> 
>> This gives me a compile error (the second time it is added at the wrong
>> place).
>>
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/sound/soc/codecs/ak4458.c:722:1: error: redefinition of '__mod_of__ak4458_of_match_device_table'
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: MODULE_DEVICE_TABLE(of, ak4458_of_match);
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##__##name##_device_table               \
>> chromeos-kernel-5_4-5.4.117_rc1-r2159:                     ^
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: <scratch space>:119:1: note: expanded from here
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: __mod_of__ak4458_of_match_device_table
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/sound/soc/codecs/ak4458.c:711:1: note: previous definition is here
>> chromeos-kernel-5_4-5.4.117_rc1- r2159: MODULE_DEVICE_TABLE(of, ak4458_of_match);
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: ^
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: /build/arm-generic/tmp/portage/sys-kernel/chromeos-kernel-5_4-5.4.117_rc1-r2159/work/chromeos-kernel-5_4-5.4.117_rc1/include/linux/module.h:227:21: note: expanded from macro 'MODULE_DEVICE_TABLE'
>> chromeos-kernel-5_4-5.4.117_rc1-r2159: extern typeof(name) __mod_##type##__##name##_device_table               \
>>
>> Oddly enough, I only see the error when I try to merge the
>> code into ChromeOS, not in my test builds. I guess that has
>> to do with "-Werror".
>>
>> Guenter

