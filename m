Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CD4668487
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 21:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbjALUyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 15:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjALUxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 15:53:00 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01BE1C905;
        Thu, 12 Jan 2023 12:29:16 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c6so21378275pls.4;
        Thu, 12 Jan 2023 12:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zRcbw/Pw2fNIlbQKW1+g/Vut5WCBUnY0POcA20AoPuQ=;
        b=jUPKA7KVPWUNHo6S3bE6FvtfNIgSVOA8ZltkggrPdMop05kqp/IG5a2vlRzSIHKLWy
         bGB7B2sAv10jIQsoviJoxfMJJ8pyD7Mth0gWLZEcoBEPalAW3k+D7M0fTp2+Fr8Ak1Mh
         9pUX4CpbBC9AGLZfScr/KXApS+PKfWrjHET5MGilcxs1ZtF53lsOFP6r8QMUGj/htoqQ
         SAPTgNmX4DD6I3eh7TRCZCZ9GWN1HbQf15bKFk/NegmNTd+X7qPE1FJLmDb/n59AlOCy
         guR5UODExnhu3VtS2HoUGke9sM8d/qtZ4Fhooi+pdP0LuDAP9XhZL4d6vsnynrxA4ihQ
         GSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zRcbw/Pw2fNIlbQKW1+g/Vut5WCBUnY0POcA20AoPuQ=;
        b=rnfeiO1U29+TbJCayUJlmLyTFzbObwTssl29oMngWE8xZUeU6jDkVBJiKxb55bdujU
         n4bPw8gYiyMr/NKSJnUwdu7e/8/OFle6iUkfVCkuibyc05O3lgasnuXW+BRUcqQYpAPI
         h8BR/R9hHEA7rYAd+dQoRxIraZksr0TDeZA/G/SUqAa6QOrN/YqXSk3A5f68JrczQplQ
         IDg2WwEJxcAiPG3v1JvYEn7MomMWlos6Eug7zFUrotYLqUJMWj2jnlja8rpLwT7gUdcd
         S07Dt2owdvhs843ABFBTca6hmn4m+jR4A4XUhBjSvAeZ45ICeYUVEfH1nhc4Kc+TbCub
         nmNA==
X-Gm-Message-State: AFqh2kopotWjyrFvEt3BBPrRUN+uOXldgUeAAyVHdyI+aJtqBkIO+2uS
        cyZji4fI9x18cur/eC1m+2k=
X-Google-Smtp-Source: AMrXdXs4WY/WYj1lSGZEJultfm60MUw8zc6EgPXU3YyJYx+8m++U8M5nmDfkcBKRNHnCWKOozf3BWw==
X-Received: by 2002:a17:90b:51c5:b0:223:2aa6:7f0f with SMTP id sf5-20020a17090b51c500b002232aa67f0fmr84182185pjb.7.1673555356369;
        Thu, 12 Jan 2023 12:29:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oa11-20020a17090b1bcb00b00212cf2fe8c3sm9813448pjb.1.2023.01.12.12.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 12:29:15 -0800 (PST)
Message-ID: <b53ee5db-e490-1d88-cba4-d98764b58050@gmail.com>
Date:   Thu, 12 Jan 2023 12:29:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230112135524.143670746@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/12/23 05:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

