Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF69844577B
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 17:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhKDQtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 12:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhKDQta (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 12:49:30 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2621C061714;
        Thu,  4 Nov 2021 09:46:52 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id t21-20020a9d7295000000b0055bf1807972so981727otj.8;
        Thu, 04 Nov 2021 09:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ber1qlGVd008H185TP4+K3fHV/Oq9soyax8B6EZJHNA=;
        b=kLqLKPWJwOJmaAV0iceRXCMVGxpqLI0YmUCs8HPHaA2kqA47oAFiTGPyQgtl6Trkjm
         K41b/SOgd21OwdWbFDbzl9Sv9tOtmGzesDyOlVVOGQVYlcxAMBNU56uq+OYfHkeQSh8U
         Jg3dvXO1fDBMs9pui+nammWmn19Nnon28aRw19Qnl2UkdWkwHjvtrskFx09JSvnNbqBP
         RL2FfrqYsiDLN53Bw5sDdFf2aN6fokKmZohqxKkoVKlRzAOj8TWQo3X4vOQOu6fdDV3D
         8PY5HHNZYMMQPWPo42JVnPYEnWQH6ljavceryGpTS3QvddqVXY0+1oj57nT/FCLiikiN
         EDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ber1qlGVd008H185TP4+K3fHV/Oq9soyax8B6EZJHNA=;
        b=7KLU8qZEJYHsTV4K4xCN16FDbZoBknxdlGZQXmCTWiAOtfsTAptfcQZx5+deA1CZB2
         d1EjILn7jyX2T53IbaK1d4awIHjXscXYDy3zd8GmCexFcwFvBk3gKiQ6eMyXraXo5rH9
         vVG61I2DWTyOAts2qZ5N0kAVL/FDf+kBz0TGx5AOtn5PDfj5NHeaRAHZKjH5b5JNTC5t
         4ugYEb3OLsYN9L/snfqm4FoDUaDsP97qemKLJOKmV2XqcAUqT31NoBMDEpwZNIWcD2nt
         7A498k2Ujq1q0FJ24OiRC4M9NRI7qDrHT7/gYBh14JvXY3jOLwAhi+aSkl9JyC7sExwa
         iXDw==
X-Gm-Message-State: AOAM5330hdp2nTiMCqMEd+lD4L+TcEII8WeaHg/4MEW4IR3iHzP65F4D
        BLPrZ/5eOCzdCtJs+RV1CbA=
X-Google-Smtp-Source: ABdhPJxZ6/ISeuRXTS0rkJKnH2vz4fbtsA500jEePP5hed6zb8uaGi3Nj6xDD9M5ZNw178y7xd8a2g==
X-Received: by 2002:a9d:2aca:: with SMTP id e68mr39507329otb.216.1636044412059;
        Thu, 04 Nov 2021 09:46:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z20sm1102887oto.14.2021.11.04.09.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 09:46:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 00/16] 5.10.78-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
References: <20211104141159.561284732@linuxfoundation.org>
 <3971a9b4-ebb6-a789-2143-31cf257d0d38@linaro.org>
 <YYQIUhHkv3kUY+UC@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <acabc414-164b-cd65-6a1a-cf912d8621d7@roeck-us.net>
Date:   Thu, 4 Nov 2021 09:46:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYQIUhHkv3kUY+UC@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/21 9:20 AM, Greg Kroah-Hartman wrote:
> On Thu, Nov 04, 2021 at 09:53:57AM -0600, Daniel Díaz wrote:
>> Hello!
>>
>> On 11/4/21 8:12 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.78 release.
>>> There are 16 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.78-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Regressions detected.
>>
>> Build failures on all architectures and all toolchains (GCC 8, 9, 10, 11; Clang 10, 11, 12, 13, nightly):
>> - arc
>> - arm (32-bits)
>> - arm (64-bits)
>> - i386
>> - mips
>> - parisc
>> - ppc
>> - riscv
>> - s390
>> - sh
>> - sparc
>> - x86
>>
>> Failures look like this:
>>
>>    In file included from /builds/linux/include/linux/kernel.h:11,
>>                     from /builds/linux/include/linux/list.h:9,
>>                     from /builds/linux/include/linux/smp.h:12,
>>                     from /builds/linux/include/linux/kernel_stat.h:5,
>>                     from /builds/linux/mm/memory.c:42:
>>    /builds/linux/mm/memory.c: In function 'finish_fault':
>>    /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned'; did you mean 'PageHWPoison'? [-Werror=implicit-function-declaration]
>>     3929 |  if (unlikely(PageHasHWPoisoned(page)))
>>          |               ^~~~~~~~~~~~~~~~~
>>    /builds/linux/include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>>       78 | # define unlikely(x) __builtin_expect(!!(x), 0)
>>          |                                          ^
>>    cc1: some warnings being treated as errors
>>
>> and this:
>>
>>    /builds/linux/mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
>>            if (unlikely(PageHasHWPoisoned(page)))
>>                         ^
>>
>>    /builds/linux/mm/page_alloc.c:1237:4: error: implicit declaration of function 'ClearPageHasHWPoisoned' [-Werror,-Wimplicit-function-declaration]
>>                            ClearPageHasHWPoisoned(page);
>>                            ^
>>    /builds/linux/mm/page_alloc.c:1237:4: note: did you mean 'ClearPageHWPoison'?
>>
> 
> What configuration?  This builds for me on x86 here on allmodconfig.
> 

defconfig, and anything with CONFIG_MEMORY_FAILURE=n or CONFIG_TRANSPARENT_HUGEPAGE=n.
Fix needs upstream commit e66435936756d (presumably, I did not check).

Guenter
