Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F3D5105EA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 19:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiDZRwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 13:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353664AbiDZRvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 13:51:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC67189282;
        Tue, 26 Apr 2022 10:48:27 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id bo5so18626966pfb.4;
        Tue, 26 Apr 2022 10:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pAvc3y0UYDlHUboNbl2zLpW+l6KvWqqww+/DUTCVzc0=;
        b=Y2zbwoR1QoUY9xWRHczVroM80SeEtBFbusgs2N82EieFDqOXoRtWYmOt7juQ8UwEnO
         /7cE1UtnxNmx4HL3NdHGcnhgnJF2S4tkdmD8hLLR2XfklrEyIKGx1o8hRafcVNwE5Pb9
         MNG/TPCBICwEsDmGmvarMPDYU5I22pIDpNaZ/YHYVejjEVDcobVj2WyEOq/q05XH8YlO
         +6zJI4KY+X4QOj5uBcQYkpouXCrFdZtZZNfO5HySF3h8KyJkliljQmoZODGeXSLY0PjY
         e8AxZ2yoinc3iyjse2Tfjt4XGwt94xWVbH0mYAiVc9uUDu3VuuZgt0FMfTOfd45Ghpff
         kBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pAvc3y0UYDlHUboNbl2zLpW+l6KvWqqww+/DUTCVzc0=;
        b=kKad78tOM72NOU/znZYwU6qkUu+5QBDk5ABJkDeXMzIE/4pyMcnETxtuzCLxvZdkuv
         tGMfl39BJAKyKhM6TS/2RaiNp591fqSXLqgverh48VuOwF/NfVTlByNz/gdTKtvPltpF
         wCNfdsbQxDROE/89kD4EVBPvLXaRWAQ/noF6gZqPYV34uOiytGV+a1h6GRR9bf2BeYGT
         XhchKhOMKeZJTedrkA1ROC2CBT4iuwUF3nTxNnbJ+9I9fEqfbiyRZIQcc/yR6gB1hc/v
         c+Tw8M071GLo+EFxpAJlfqWoqnwfbe8NfWGC9xPIO6qavWb14EvxJLkk+cHx3PT38+73
         BLQg==
X-Gm-Message-State: AOAM531RykEA548b5GEaPDLa8LHFgusKmWqjEDAL2/cBRmrnV+PQTYUQ
        hpYf115ZpRbFiExlsT3JJpo=
X-Google-Smtp-Source: ABdhPJzDhL7jAV5BBaJf1V6BN7Bb2Maj/MdyHlnfiP5v8OJxzjEbBI39YjcgmucUCj0W8b68u9N54Q==
X-Received: by 2002:a05:6a00:2284:b0:50a:40b8:28ff with SMTP id f4-20020a056a00228400b0050a40b828ffmr25755230pfe.17.1650995306815;
        Tue, 26 Apr 2022 10:48:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c7-20020a62f847000000b0050bb32e3b8dsm13274673pfm.179.2022.04.26.10.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 10:48:26 -0700 (PDT)
Message-ID: <5a1c5f94-cf4f-d0da-4732-0702a4b13693@gmail.com>
Date:   Tue, 26 Apr 2022 10:48:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220426081750.051179617@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 01:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
