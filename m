Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38216A7434
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 20:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjCAT0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 14:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCAT0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 14:26:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ADC43463;
        Wed,  1 Mar 2023 11:26:51 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i10so15113055plr.9;
        Wed, 01 Mar 2023 11:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677698810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4v3P6EKA1Bt9y18IA1nEWhKb3MWpao+bby1BrXmk/PM=;
        b=SfybIzROFX55amZBZ8IIINi17zksuZE7349HRirXI6gRI/iXE3YRBlbqyHyHRkq26c
         i7X0G3/ZmxsXk35LVQY7m6nXxuo10fMBKtHC2+M7QoOpSuqOKuhnwofbKr2/HsXvIUSA
         5N6YQLVAJC3nv6P7YxYCO0tTLAxzRRhVSTwxC/slQt5kdlV72BE38UcDTz+yl7l0/lq7
         O1hS49AqjMacdLnlQD9UWEuF4W373NjALldfhsPM2pKom1A4B+eY1kMRWW1EUPwXF+jF
         gawiX9BhynuacMVh7DIDVnu+hejtThwI98I8T+eA/uCb6zF1eLVr/RRgeDaTIQt2FXFD
         fu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677698810;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4v3P6EKA1Bt9y18IA1nEWhKb3MWpao+bby1BrXmk/PM=;
        b=dBl5qN5VAN0mjobDcPQ2jNO4i2aEloo/0TOKVXGr9tYCxaasxjJuBK4owGzl5MxMAx
         q8JIhPHjFD6/wVQRkqHLxd0ihGKXV0x8E0QU7RnwY7oNDdL0mnc/8489vK/xnXLp3MiB
         fw7RP+VQGBT0plSrqoojlv0jnn7VP9b0B2mv+z6T28IAFfTkmf09cOwM4ma/ePB7QahQ
         hvOeXsEKo5DXWs8+ZMneUJibmBUNsk1oAB0K18VXu2/Qh78xrTfJdNJzLONLwkptIOGd
         dV97KmjdmwEGMUlDIVFjM0LR/77B26391ZuAb14kZXsyWis3Ca4x50EjF4DW5pvqenN0
         dFKg==
X-Gm-Message-State: AO0yUKV+wtKmEJSpAcFLS+fEcuSu7HJgMYM0pUyYBM6iI86aTN65+AwO
        AUeavhapwTmQPWwaf13KYe5Rl7wOK2I=
X-Google-Smtp-Source: AK7set8i4VxbG0TEU1qv/MkFU89itwbnK3NKOXhvhKtxlgLazIqMbZL2qTMt0S77ZK1HrLm+ykmoNA==
X-Received: by 2002:a05:6a20:244f:b0:cc:b8b4:d774 with SMTP id t15-20020a056a20244f00b000ccb8b4d774mr9772148pzc.7.1677698810513;
        Wed, 01 Mar 2023 11:26:50 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h20-20020a62b414000000b005d3fdf7515esm8153605pfn.81.2023.03.01.11.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 11:26:49 -0800 (PST)
Message-ID: <5e255f48-0878-8da6-8888-438315bb0cfd@gmail.com>
Date:   Wed, 1 Mar 2023 11:26:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180651.177668495@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/1/2023 10:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.234-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
