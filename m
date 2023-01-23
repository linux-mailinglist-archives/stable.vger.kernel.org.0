Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEA1678700
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 21:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjAWUB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 15:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbjAWUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 15:01:56 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F068828854;
        Mon, 23 Jan 2023 12:01:53 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id z13so12549638plg.6;
        Mon, 23 Jan 2023 12:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSZUXEn2pln3/CCnZqJdWGRNu0XQyJw+TD8CxoELWNU=;
        b=GbAaHgmFXhyWDDxIOz0+D+RfOqP2Ok85UUj7wE9eA2EPsUBamv0VgHw/rw5q7SprBJ
         oPSjzl7bH1MSaVRZXWn/8PrphqaMcRXK2xgs28Q6V1JCky7Vqj0sFL46zQqRYDMCZMcq
         83FJkrpIExgrxq/DiGwuNHGgYuT/3EfcK0cCrAvg4BHPzBUo7MtsgKu7IFqft4EWlE//
         98F94YSNCH5fDowYwhe+M3VHyodK9RadX9mngaJQOYIEniOwhqURZ7x5yClVDBQYjkdM
         kywncC34+EBvStsHTzcArMM0qqFk4UM/L74+76z+21RwIQCwXIHS5NaLbUj+zPfOez5X
         P4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSZUXEn2pln3/CCnZqJdWGRNu0XQyJw+TD8CxoELWNU=;
        b=uo9K8/wQETmmN23EhUfm7P6xNbvLGdCKeG6qeD3lGGL5ikjyB5p2clvmHetuHicgly
         AqEbg2ViqU8oYBwrWTu5JQ3EgXnvo5NCZiIEb32q8yrH57ZplS5skITOOULJOJtT/txy
         FVBPG7uS4KcsJhsictlQQeBHSSh+bW7k/QaDTNpTPnwnUaroj/c0KYk3TMm63p11PQDK
         lCUi24O9Kg7CyTJgWHZX7BTgd3f7CLY/4JCESifff9BHVC90IMWt4JI4WONzYOlPXW8U
         xPa6gmX146rNqTbnxY5fV6gSWDytdJnAfbYSym8bPGMb8yuzTtW1rroIO4L7LhX0kO/n
         AMOg==
X-Gm-Message-State: AFqh2kqFfCsHF6cMghIJ6fK06f8kVsmVmxHKnE6M2gKqTrtSB8kkKRvX
        Nav9ZE3DQr3OeyLXp6jndV0=
X-Google-Smtp-Source: AMrXdXtACcnlSumNzaxRxxHrSlnC/jTpG0PPQ4zhXVuDvzF/k8kTZwQB8KZZTBszN2O1sQB+xyYpWg==
X-Received: by 2002:a17:902:9343:b0:194:4a2b:d7e4 with SMTP id g3-20020a170902934300b001944a2bd7e4mr26601026plp.17.1674504113363;
        Mon, 23 Jan 2023 12:01:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id be2-20020a170902aa0200b001948809087dsm66804plb.281.2023.01.23.12.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:01:52 -0800 (PST)
Message-ID: <775529e0-1b21-82ba-acb1-1fee200eab12@gmail.com>
Date:   Mon, 23 Jan 2023 12:01:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094918.977276664@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

