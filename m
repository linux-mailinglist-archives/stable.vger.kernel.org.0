Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04966689FC1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjBCQ4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 11:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjBCQ4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 11:56:30 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6155171987
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 08:56:21 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j32-20020a05600c1c2000b003dc4fd6e61dso6433356wms.5
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 08:56:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RMq+cvkWvF/UyzkbPjmrpsXN3fJwSAqaVKuerACOW48=;
        b=VIHlZoavFky86n+pjOnc6s8Bq2hhYfhmtq3eD6KH8MPQ6QBjrQ9WctPpMcO4+DWXuh
         RUt3EFdfmp3xzbflCdH3Hb8tAmMAzZ1oXWSdDIjWQhFOHZW0HM+TXpbmO4ap2E0dUUbX
         suaOLOSpkONs36ga7weJJh0UlmRqCOS1HoUSwJOYa6OyX9MXTcTA9TYV7CO0Jbblm8DT
         9bOag6GDyxlDZi7SqgaEEHRNeoRi5aGImimcq5lHBty8khEMSf3IsWJycwJQMk5oCazx
         8k7WjokcpBLGk1rLatCrwN7BALRvP/gwAPaxFkwk2355PWRD0qcrbnLNT6cmmPyeObjm
         zM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMq+cvkWvF/UyzkbPjmrpsXN3fJwSAqaVKuerACOW48=;
        b=zY2XrXu61+kOyXGhFiBnejuxcG4CaR+azCdgIw2Pfaens4LYsfORrwaHSUsGF5ohOW
         F1zTwYPIap/Qsh2FpbFGeOCD7uc0UrIX7/fMD+/kK3+ffViVXHCfUwzsm4XfmkqjTBXD
         ijkMpl28XP14GqXOlvP7UqjV+6ShgO8t48zpnSadBqI4cnGUP2B2BmkypLkvHZ5++UIA
         PaofPIXX3ub7+H+DB3N3sQVeOVq4F/ltr2ToOJC7s2+Hzs+Jke/OPR87HC6pW/wdNtt0
         FXoKQsvTVv3C+C9SaV9jwINNaWeRpAzCV0UHPNFT+rLUNNupMWZPkrsHR7ckGfKP7D8s
         B29Q==
X-Gm-Message-State: AO0yUKUvmCzqaAkQ/xhk8imDUT3ftyDufdrYeWoKWKig/O1bf/T87Gvj
        Nj1Ok/DOFtZUaliZMYXu/m6Lzw==
X-Google-Smtp-Source: AK7set9NjJxn74aZueYcfentd77BomFUbSMlvUzVg0sncnweknpQHZlamRhQeOfZrjq9rSw+s3P+MQ==
X-Received: by 2002:a05:600c:491c:b0:3dd:1b02:23b7 with SMTP id f28-20020a05600c491c00b003dd1b0223b7mr9727024wmp.10.1675443379954;
        Fri, 03 Feb 2023 08:56:19 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id q10-20020a05600c330a00b003dc3f195abesm3125534wmp.39.2023.02.03.08.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 08:56:19 -0800 (PST)
Message-ID: <5e57cf49-6348-7878-0e01-51e5e1359fa8@linaro.org>
Date:   Fri, 3 Feb 2023 17:56:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
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
 <4e5a447b-1796-513c-135a-f9e9c870d88a@roeck-us.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <4e5a447b-1796-513c-135a-f9e9c870d88a@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/02/2023 16:51, Guenter Roeck wrote:
> On 2/3/23 04:28, Krzysztof Kozlowski wrote:
>> On 03/02/2023 12:04, Naresh Kamboju wrote:
>>> On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> This is the start of the stable review cycle for the 4.19.272 release.
>>>> There are 80 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
>>>> or in the git tree and branch at:
>>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> Following patch caused build error on arm,
>>>
>>>> Gaosheng Cui <cuigaosheng1@huawei.com>
>>>>      memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
>>>
>>> drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
>>> drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
>>> function 'devm_clk_get_enabled'
>>> [-Werror=implicit-function-declaration]
>>>    297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
>>>        |        ^~~~~~~~~~~~~~~~~~~~
>>
>> Already reported:
>> https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/
>>
> 
> I don't usually check if release candidate reports have been reported already.
> If I know about it, I may add a reference to the report, but typically I still
> report it.
> 
> Personally I find it discouraging to get those "already reported" e-mails.
> To me it sounds like "hey, you didn't do your job properly". It should not matter
> if a problem was already reported or not, and I find it valuable if it is
> reported multiple times because it gives an indication of the level of test
> coverage. I would find it better if people would use something like "Also
> reported:" instead. But then maybe I am just oversensitive, who knows.
> 
> Anyway, yes, I noticed this problem as well (and probably overlooked it
> in my previous report to Greg - sorry for that).
> 

Let me rephrase it then:

This topic is already discussed here:
https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/

I proposed to drop both broken backports - mvebu-devbus and
atmel-sdramc, because they require new features in common clock
framework API.

Best regards,
Krzysztof

