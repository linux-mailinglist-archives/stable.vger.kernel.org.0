Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2B068A752
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 01:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjBDAtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 19:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjBDAtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 19:49:42 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55224A6C1A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 16:49:41 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id e204so2624727iof.1
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 16:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oo7mqL9y5RSbe5Z0lh99Nai0NSR3yfVP+UESegMK5U0=;
        b=XFBszp9P01vRlXL1pdAzILHmfjGJWxCUz1sNv4cpoyHqiHY6Gt40rhXfkw2dtuNesG
         KTZALxh+SuXK2UfrIEGMDUrgcdmQif3M1oBV2E5bhQqTaJUax0kEo+hM+XBAPGjP86KV
         q6jtbc6djuO/zPZqCLLlJylZI6i70lRwwG69o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oo7mqL9y5RSbe5Z0lh99Nai0NSR3yfVP+UESegMK5U0=;
        b=e+0WxHk0EIi9OXsSGqwyIf/QishHXsHLaeMGKKuEOv2SaxbnRB2rp4JDzETU3K95ed
         pLkJwzll36jOdmyrHa+QUJskjaWqzhLTb51qYUluROC1Y7gO/QnTg1n5a+T/OA3zudLt
         4eVJhBodAsEsxQBbk3fcuE31SEX6Tg7+fwze0IAdRVrWOKJYyCMwY3xOHmgJZsijJiHg
         GldWro0TMeAPHrGgcPAS87jRhyIwSr549HcVbxTxm7xTmzf2WEbAY/AinsZYjt5HUdw/
         He1fU4a8Tm++RV2ajhuME8Go075q/zoiKw7XxY0JqqQWM3CUeQHxxwdgyFL4K2sh6mYO
         WM8w==
X-Gm-Message-State: AO0yUKXeXZTtpYJS+wkskcr0IyFWamTsfRWmOmcYE0z3gcB0c3nYPQ1c
        /9LwvOfd4FgmvLiEqCxU/klOww==
X-Google-Smtp-Source: AK7set8pyFTXYndI7vTRUogyFr8J12Rz6W9PAOmi/TDMHIHlMSf3w31CyN0/et9dLawFd8OEYqMRTQ==
X-Received: by 2002:a6b:7808:0:b0:71d:63e5:7b5f with SMTP id j8-20020a6b7808000000b0071d63e57b5fmr7554082iom.2.1675471780598;
        Fri, 03 Feb 2023 16:49:40 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p32-20020a056638192000b003748d3552e1sm1283835jal.154.2023.02.03.16.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 16:49:39 -0800 (PST)
Message-ID: <6ce2b22c-c19c-6e88-3ceb-a05f4bd5ea99@linuxfoundation.org>
Date:   Fri, 3 Feb 2023 17:49:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 03:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
