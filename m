Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6D86A0EA5
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 18:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjBWRXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 12:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjBWRXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 12:23:22 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B9B1D924;
        Thu, 23 Feb 2023 09:23:20 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q11so14153312plx.5;
        Thu, 23 Feb 2023 09:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4X9XPUluho+I4U2YTl0MMSfrwa5zdjEgqCMtE8mvXv0=;
        b=gh+VZGdKAHENF5w1fy6caNEhvYRPbgD+mn/rC0Kyl8Regya2mBoyKQoD4ZQoPQK06Z
         jCtwhGwbsRibxW9U2oIbd5nnuY1oN76EnBddzfQLvP1vcZfXcwaEzKJoeF61+6rUTPz0
         k9CMne/R1oS4lkKKKJ9ZjYE/2IEPf0PydUhXU0hUWa5pnuo9obox8Ba1vsckhxqu8J44
         2T0q13SG3oegxDDZfn+feYdLaTPx4fXZYb9TC3RaaCR1SMqwzdq8flGQHQsCSLHVwTHx
         EPjUShnrWecq/MJcrqAY14q6xY3PIp/GjGjyM/yMZQiZxeMwoKEAiymQcB7pzNoCt2UM
         Urlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4X9XPUluho+I4U2YTl0MMSfrwa5zdjEgqCMtE8mvXv0=;
        b=Lz010fSArpZywP9HPBw6cDXNu6dsAa056laiDlGkD7ej052ss9ma812AN0tz1FJpn/
         5Fag6sqKVBFEXJ6cPVUbb0X41vZLbltAL+d4mJlMSj4Kc49tOhsJJ33DBVw2kaFri+49
         VY7wh4r6GMKCqCQZeLH1b8CympDcycURMUjFMB0FvrD7wiKhhJ2hTiD9nCaAqhZ9AH7j
         rlt7GPVqSUps3QD+Nu+Eq/o+X7ChhlNHMY1ntQQ6CT1DZ27qsOJH6iQ9c4UiwOei33Gx
         VMftoRc0S1VeuLkySgxKw5bkz4atU4YnSijC5UHBf2zyN/pMzpWwv6SjduY0YJ+quKTo
         CzAw==
X-Gm-Message-State: AO0yUKVnoxtixKQYE3vwdSnM5ZoTmk4pua6igNDfVB4a3H99LGvlftDz
        8aJfCFmkzgqlZDnb/OmUFKw=
X-Google-Smtp-Source: AK7set/K4BBwjvU55dIu+6lZsRHoNjZpmTcK22Pfl06vnIwEZdIRSLiFDIZGZcdH13Kd98nUMMz50g==
X-Received: by 2002:a17:902:e1cc:b0:19c:9420:6236 with SMTP id t12-20020a170902e1cc00b0019c94206236mr7798946pla.22.1677172999883;
        Thu, 23 Feb 2023 09:23:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x20-20020a170902ea9400b0019cbabf127dsm1941061plb.182.2023.02.23.09.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 09:23:19 -0800 (PST)
Message-ID: <6c19502d-4303-fb8f-f2b7-9061a04b9a15@gmail.com>
Date:   Thu, 23 Feb 2023 09:23:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141539.591151658@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
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

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.233-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

