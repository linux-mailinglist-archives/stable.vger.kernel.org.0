Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F733FF67
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 07:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhCRGJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 02:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhCRGJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Mar 2021 02:09:36 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B927BC06174A;
        Wed, 17 Mar 2021 23:09:36 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w65so1049630oie.7;
        Wed, 17 Mar 2021 23:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AJTdx8gCeb21rUmpujzPLZEeMT7bjnWijPWwGxEavtE=;
        b=aMz+LI9db/0O30hLpPmuOC+WXIc7bnBx9NX2n0NrPmUlmTr+3jXyqGY1J/87aO/AQl
         PXbaI3crpJAs70tQBm3Pw35hS1DnhduWLP5Y4iUPEkmcSdhngouo7DN+2E4/9G77O1ig
         73VQtaJKQdHhWprerzDdxYWtREMqA/dM/O4VMYdShSEvRCRD9Sd1pkk3JErwAmfuQKqa
         c0ptJawfcxWNKiNBeSrp6uIEdL+3uqH4PVVHnI2RPsncIIEdgta7y7/cUGOBxgjS9N3T
         1QnzcX34MkP2NHEmmdiVRH08iDdG0ZjjfNQYst9x2gr4jzwcTHpPg8YL5hP2bJfG83I1
         Tj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AJTdx8gCeb21rUmpujzPLZEeMT7bjnWijPWwGxEavtE=;
        b=CumlOFg6oo7AkBNxhGjggO3DNdquNB9zPoSMFtV3QsOo9u+AIaB4TSUGDOdqTRJVu2
         F4LI/nqxtpX6MRzbwYdEG0Xlh9Hf5PGAmPEpEANlj6KrNKT59hKz/ElirO0LcZ6PBA5L
         J7LYToVqsTSVJsyyMzmH4JK6U8uvPVO7rAfktyBRUqm6o2Cnu11jggMYQIip4AEU15l2
         NFvwb7Js2wGXWC6SZGhIpdyeUaudBtD/+ibK9HCL7KIpKJNz1gNCTYy/BgWY+Z3n2pJZ
         nxI7UsNS0HKnrq9FgNwHMLc5cU5SnBSsSJNdxuHylTUsZqkTFPiRM99BaNnSsNWMCtmf
         EfBA==
X-Gm-Message-State: AOAM532L6iMxPi0822hLwnYGMFXDyA9i/xYiteisT0LW3ch2td1w4ZOE
        ywPhm3Omknxa1+SBZVMMOwulkjHwVpA=
X-Google-Smtp-Source: ABdhPJxmpUWvOVhD1YEhOph/e7BPpjwBm1EZFq976j/23qxWuzFIRaGbZDh8ptMjXVUpTeFe/T0Xgw==
X-Received: by 2002:aca:c4cb:: with SMTP id u194mr1960139oif.74.1616047775907;
        Wed, 17 Mar 2021 23:09:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m19sm337242oop.6.2021.03.17.23.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 23:09:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.14 00/95] 4.14.226-rc1 review
To:     Samuel Zou <zou_wei@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210315135740.245494252@linuxfoundation.org>
 <c0902934-ea11-ba1e-fa2d-b05897aab4b3@huawei.com>
 <YFIh6ZyWb2JtCu6H@kroah.com>
 <f2328179-00d9-41e0-6bd8-7bd39b025563@huawei.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <f41e7c89-74b4-5a3c-b569-793ee8c3f486@roeck-us.net>
Date:   Wed, 17 Mar 2021 23:09:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f2328179-00d9-41e0-6bd8-7bd39b025563@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/21 10:54 PM, Samuel Zou wrote:
> 
> 
> On 2021/3/17 23:36, Greg KH wrote:
>> On Tue, Mar 16, 2021 at 02:35:36PM +0800, Samuel Zou wrote:
>>>
>>>
>>> On 2021/3/15 21:56, gregkh@linuxfoundation.org wrote:
>>>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>
>>>> This is the start of the stable review cycle for the 4.14.226 release.
>>>> There are 95 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 17 Mar 2021 13:57:24 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.226-rc1.gz
>>>> or in the git tree and branch at:
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> Tested on x86 for 4.14.226-rc1,
>>>
>>> Kernel repo:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>> Branch: linux-4.14.y
>>> Version: 4.14.226-rc1
>>> Commit: 57cc62fb2d2b8e81c02cb9197e303c7782dee4cd
>>> Compiler: gcc version 7.3.0 (GCC)
>>>
>>> x86 (No kernel failures)
>>> --------------------------------------------------------------------
>>> Testcase Result Summary:
>>> total_num: 4728
>>> succeed_num: 4727
>>> failed_num: 1
>>
>> What does this "failed_num" mean?
>>
>> thanks,
>>
>> greg k-h
> 
> total_num: The number of total testcases
> succeed_num: The number of succeed testcases
> failed_num: The number of failed testcases
> 
> Maybe I can revise the description in the next email.

I think the interesting information would be what exactly failed,
and if the failure indicates a regression.

Thanks,
Guenter
