Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C801689E86
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjBCPvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 10:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjBCPvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 10:51:23 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97E75B5A6;
        Fri,  3 Feb 2023 07:51:21 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-169b190e1fdso7109412fac.4;
        Fri, 03 Feb 2023 07:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IK6isyKHVl+ukxzyYdmFd+ltn6OU3spgEFoTeGzWtKY=;
        b=RzRYmChixrro+XXjPnRj22WOQGgXV1aSazeKDi5It479Nnz5GC1ZI+4u40rt3M4MCQ
         NHKfvBdm/WNHw0Nmjr5ik2mgrTpEDdznGueoIZ6l+5OwzL++sDwVmP5X2mrqUz1iJ5rJ
         o/MsjSEv9rUM12DnQtsmqMJsMrM3ibE52YxV0t+xSSY9VlQP0z1lWLSM8mKFhMiff/la
         83T/kV/2J9K1erdO4mtdO3A1YNthVPO8r2veQMGH6cdxJ+c88NEaWOm9eVsoZ2HkIjiP
         g6smtqabWwzrQ9cogtupDqkKd9eYPXr5jSDAZ9oY2tn03Vel9dMY6lfZJeGDaKQLR/fJ
         tZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IK6isyKHVl+ukxzyYdmFd+ltn6OU3spgEFoTeGzWtKY=;
        b=zy8R4Kn57+39FRcKHcbuQLtvleWS1THh9bUIffA1oPwAanS2olWhHxVV1U7omi4EpD
         /uGC+hg+iI1lHnpIgTfHULd3JQLffnXRRGFrL6mK4wOyAoWmUgKrJPDYBzPjippn9Fd3
         KHqGEsRkCz/t/UQ6ClZiyz+5o3bBR3eDOwX4Z16s1sVUlqKaYjZOfblQmr1h24UhtoMH
         DB5KNjorfvsynzQsapLwGJB4Az6vn3hfUcylDa0a0N3V8TJRerLkRdBJnQFHsFaTSh51
         oio8p7/JdSMHoUbtU70b1Whro/rZdME4zqY1DDtJJZKEVyIblhjm5pQiVMG/NcSRvDPt
         H6cg==
X-Gm-Message-State: AO0yUKUadbwU1QN1hHq7x+cKCHkBLPL9e/fn9b6l2MEBVAmx9Z5AU+01
        Yuw2CEkr4QohT3ti9a94dP0=
X-Google-Smtp-Source: AK7set+VlhBh9rvzj1I7nWfKRfrwsnMZOBDegZcQS4Gyf+gDfh/RGhnk9JMeGaRyssOYlc6ALtFI3w==
X-Received: by 2002:a05:6870:414b:b0:163:a45a:9e34 with SMTP id r11-20020a056870414b00b00163a45a9e34mr5960269oad.31.1675439481097;
        Fri, 03 Feb 2023 07:51:21 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w1-20020a4a2741000000b004f269f9b8f3sm540579oow.25.2023.02.03.07.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 07:51:19 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4e5a447b-1796-513c-135a-f9e9c870d88a@roeck-us.net>
Date:   Fri, 3 Feb 2023 07:51:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
 <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
In-Reply-To: <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 04:28, Krzysztof Kozlowski wrote:
> On 03/02/2023 12:04, Naresh Kamboju wrote:
>> On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 4.19.272 release.
>>> There are 80 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Following patch caused build error on arm,
>>
>>> Gaosheng Cui <cuigaosheng1@huawei.com>
>>>      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
>>
>> drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
>> drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
>> function 'devm_clk_get_enabled'
>> [-Werror=implicit-function-declaration]
>>    297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
>>        |        ^~~~~~~~~~~~~~~~~~~~
> 
> Already reported:
> https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/
> 

I don't usually check if release candidate reports have been reported already.
If I know about it, I may add a reference to the report, but typically I still
report it.

Personally I find it discouraging to get those "already reported" e-mails.
To me it sounds like "hey, you didn't do your job properly". It should not matter
if a problem was already reported or not, and I find it valuable if it is
reported multiple times because it gives an indication of the level of test
coverage. I would find it better if people would use something like "Also
reported:" instead. But then maybe I am just oversensitive, who knows.

Anyway, yes, I noticed this problem as well (and probably overlooked it
in my previous report to Greg - sorry for that).

Thanks,
Guenter

