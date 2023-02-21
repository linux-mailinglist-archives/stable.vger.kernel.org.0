Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D485E69E8FF
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 21:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBUU3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 15:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBUU3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 15:29:14 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF93D2D159;
        Tue, 21 Feb 2023 12:29:13 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id co23-20020a17090afe9700b002341fadc370so6241156pjb.1;
        Tue, 21 Feb 2023 12:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6ZBdxrcYvbI1Z3Ko4/Ygq22p0mSRneCJlicvJMQ62Kc=;
        b=Jvz+wJA5yDvMdWAHjRTB1t5IO+pWd8B5VE3kh5OvwMSNITqrdXX4S5AG4+8B0dCW6K
         4NlXKs2VU4tMme5Liv3qc2cFJLaWMSIuGw1aUC9eLMKi81zh/1Zar1Dp98/iIQo1nLZL
         CmmbcGMNQKNRcXdonKRydfoGI5gHnCIzrFmdaPu2BpqoSiJ0us/boaAhZVJLRqVAWLSA
         38F3y2ZnMxiZDuPDJqsJeYDndb75xIKeP7pR1Mmc4D6KVbzMHVqrSMa9qpD1LWQbeaDu
         D9nmQJMLmfR9Jg9Ri9cmZIYcW+YSaVlOKbRD8xza6YZXG5VJnqMOGIhx1KdiRV5Ub90E
         F50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZBdxrcYvbI1Z3Ko4/Ygq22p0mSRneCJlicvJMQ62Kc=;
        b=bRnJlSLweMgqGD/plDoSS5RfZTEf3YtT7I2BqWNbDqgdG3cgOHQCsp+zSli0ygI0yq
         nzm35nJ5WoEm2ca5Bq9zZXaGKZujiUpAYZV6G5uiMGYmd3wqJhqUi8PJGP4l2Cgk2pH1
         KWr7gJLwDXrdXT5KLfeSyHX3XULzAOEMEWaCpf8pG25fzUVPDAcFIDpFmF+JRkBNVce4
         EgZNvE8wYZj2Z74dqg233r7POjtfBoXeTG0FPzAgU+15MLB8yEbUEqNxRV8gUbuBvyuB
         ou1ERRYPyBxZCuG18A+03pf2r4aeK87ghaf3U81ZS8LnXfq43288Y1ft93YNtFMTRyQR
         jW2Q==
X-Gm-Message-State: AO0yUKUe3MnkqAKm59Noon01uz7NdrAo1zkyhR6r67y1pD7lB4ZNiwtJ
        fUiyK0aX8dyBfNzJkSqH2Fw=
X-Google-Smtp-Source: AK7set8QdnIlUvdnGKNBL6HaRExsMpy3ecuBzjOW4TJDCCArDXbTrWZiABHdVxzQA2XS7dp56qHB3A==
X-Received: by 2002:a17:902:ea07:b0:19a:887d:98ac with SMTP id s7-20020a170902ea0700b0019a887d98acmr8151056plg.46.1677011353003;
        Tue, 21 Feb 2023 12:29:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bf3-20020a170902b90300b0019adbef6a63sm10257324plb.235.2023.02.21.12.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 12:29:12 -0800 (PST)
Message-ID: <27de6440-c062-db02-7f46-78154de1dee9@gmail.com>
Date:   Tue, 21 Feb 2023 12:29:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230220133600.368809650@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
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

On 2/20/23 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

