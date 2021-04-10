Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6864C35AEAB
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhDJPBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbhDJPBU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:01:20 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B27DC06138A;
        Sat, 10 Apr 2021 08:01:05 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id s16-20020a0568301490b02901b83efc84a0so8507913otq.10;
        Sat, 10 Apr 2021 08:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2d9CJC9G8D6lXXh+RLIvavNbaFq9uE2kqs3YQu46vS4=;
        b=M1OFr2rmqPYYpTZ/DhBD4+FlyWihK/CQiWJ1BrwxfRserkF39euLm/lk7sjVUEDYNn
         qiW6l0G2MuPmDeAntqJBZeT6uA210lMsJwisU5lheVF9+VZZ9kTQ0t9lc7jgdOwmAgsi
         cKvw7+2hB0BzbV8U/XwLvHNbgoIkGP0+rkEE1dA9XLMHmX5IAbrHVORnDWcyfpNOO1wS
         nIZL81DDWqFxcFna2Qtsm5VAoXJDSIZ/4alKpiqib8WVpYGklsOXqNckPeCHDiIBLvgu
         Hm3lIJAVO6orl61y4Ph1Z4kP8wO8Dlw1cN0tdVaSGtCz2UOCsT/FM4z2+EtdkvrkBZCv
         p5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2d9CJC9G8D6lXXh+RLIvavNbaFq9uE2kqs3YQu46vS4=;
        b=Ikd0Pnp6lUoRe3kKXXJqVL/w6zkYscbSDySSuL7hlR97oRQzdaqvrXIUDGCPIr049Q
         1D4XujEiXwIO5hU3Ko1w/lQ/bE5RcZbYQct0rOgxm/mI7wiVyv8NKyWohX/GV1UDdTLM
         w2evyFa0ijRixFEAxP7Ynek8i2oCUe7QLTEDK3I8qdTlEAnQ78ueIoSkA3nkAfPHdjXu
         2o/Bn7F1MmU8Af+OM7nt2SD6fHIC8hGYzzcbO1kPMyNCpKLelFMp5TI1ByTWmcqzx2T6
         qvjpNznHQA6AeuE/TX585miAN1Wnn7JnVazbxVhN90ckYXP4ll8ORyLM0j9D3VxJ/Sgs
         pLTQ==
X-Gm-Message-State: AOAM531qtNZv+gylvD1k9tTs0qL9fhaxCLYwU5scHTwackKOSGhN82wM
        gWCqkm1WCMJ45EOfditwHUfzSIycvhk=
X-Google-Smtp-Source: ABdhPJyZ5i5AQIV4rDQNjbtwXlJI0urc3DBjYCnVqQcswhKj5OYplFW7H/DEnPpF3MDESx+xMzKTgQ==
X-Received: by 2002:a9d:6e11:: with SMTP id e17mr16434493otr.222.1618066864692;
        Sat, 10 Apr 2021 08:01:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t192sm1166676oif.52.2021.04.10.08.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 08:01:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.14 00/14] 4.14.230-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210409095300.391558233@linuxfoundation.org>
 <20210409201306.GC227412@roeck-us.net> <YHGlDRbuyyGL1Jqk@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <6272fcd6-21d1-680e-16e7-5f973e9f8a9f@roeck-us.net>
Date:   Sat, 10 Apr 2021 08:01:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YHGlDRbuyyGL1Jqk@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 4/10/21 6:15 AM, Greg Kroah-Hartman wrote:
> On Fri, Apr 09, 2021 at 01:13:06PM -0700, Guenter Roeck wrote:
>> On Fri, Apr 09, 2021 at 11:53:25AM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.14.230 release.
>>> There are 14 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 168 pass: 168 fail: 0
>> Qemu test results:
>> 	total: 408 pass: 408 fail: 0
>>
>> Tested-by: Guenter Roeck <linux@roeck-us.net>
>>
>> Having said this, I did see a spurious crash, and I see an unusual warning.
>> I have seen the crash only once, but the warning happens with every boot.
>> These are likely not new but exposed because I added network interface
>> tests. This is all v4.14.y specific; I did not see it in other branches.
>> See below for the tracebacks. Maybe someone has seen it before.
> 
> Thanks for testing all of these, I'll go queue up your reported fixes
> here for the next release.
> 

You'll need one more patch to avoid yet another warning:

b0949618826c net/ncsi: Avoid GFP_KERNEL in response handler

Thanks,
Guenter
