Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3834E2FD9
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 19:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352072AbiCUSXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 14:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352075AbiCUSXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 14:23:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DDF515AE;
        Mon, 21 Mar 2022 11:22:24 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u17so16160214pfk.11;
        Mon, 21 Mar 2022 11:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=pWJlyjVMhLMtBNyH4yWhUe1GiisBsvfrkn0alOM5Z6k=;
        b=DtZf4g4zSZkYHCPibWYmiQNnIrq6GSsqfe2JgMSwhkBoAMgzRrIibAX3srmn9/xnLS
         UhI25930cJmKVUL/D1OES5CBiAUjo2pCejwy+3riFoVHHAHYeSjvKgS6QXkp3WkqTc+N
         1YvMK47ZP4LgdWT/6021b6ddv9IPhrNrK2Ezbb+rJcY1GH3q8U7C99d7T/XKZr03UFr0
         dYwecXrEFarBU8kHc07GNwyBggbEkyCmBGIOBpfb2yuCza03RAI145MN9Yn1/8VMtyeI
         nX/2LgBbNkXBSZJQzSKpVTE9nDMTQViAIUyy21G2A03iL4xdaOxSZJ2Az9xZPP8R2KAc
         FSiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=pWJlyjVMhLMtBNyH4yWhUe1GiisBsvfrkn0alOM5Z6k=;
        b=n4HOTC0WFjZ5y6aJNrCmJTQux8gezFXAELX3UKBV+yvMAdL+CamB8R3/Z+j1Ngt5tW
         ft+lBzEixJWHI63FqDiKx/JS4ybAHJXZN4SrLWhCKXEqNGzMSGVXlUscaPXsoxA3ELr6
         X0NwDlkUC1f3bJrtI5gqbsMHAKtremZWLZxMD+lGBezfigUYdCRlMfJdz26oboUfE3X9
         D+jzMhAWjr2rAFm8ltVmpSKEfN8HOzmdJT8bpSdTAT/3cRw+51JFexQ1xOsn76x9Xaim
         HnUeklcuDYinOPoRpQkAi92IwmTI3qlmW8x5J+fmdgbS/h0mFb26JZWOxzl5BNcLryBf
         z8og==
X-Gm-Message-State: AOAM531gXxEktL1T2UJ7gFTnJ+Pdc2kO/qNtSLWWbUyP+O7takYnsgrL
        uv+124eRUbMEAli9G0T5IFE=
X-Google-Smtp-Source: ABdhPJyDQ1xyB/GRGSR8FyAUqwkpef62eWQ6L2bCcA5AKUxIOYY8rbVPdFUmHAaeRcijIB3IV8oxzA==
X-Received: by 2002:a05:6a00:1350:b0:4f7:8c4f:cfca with SMTP id k16-20020a056a00135000b004f78c4fcfcamr24864702pfu.45.1647886943929;
        Mon, 21 Mar 2022 11:22:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y14-20020a056a001c8e00b004fa829db45csm3321871pfw.218.2022.03.21.11.22.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 11:22:23 -0700 (PDT)
Message-ID: <594b0eda-8c3c-1745-4bb4-c2dd9481fc14@gmail.com>
Date:   Mon, 21 Mar 2022 11:22:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220321133221.290173884@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/22 06:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
