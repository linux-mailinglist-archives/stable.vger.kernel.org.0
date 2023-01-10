Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A94664BFB
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbjAJTHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbjAJTHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:07:25 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAE152C67;
        Tue, 10 Jan 2023 11:05:59 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-4d13cb4bbffso46293487b3.3;
        Tue, 10 Jan 2023 11:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XCwyXZ8v69nxWVcxtEAn9KfGkzaGevR3ns9wimMR6ic=;
        b=eU4fQ0MJtrWbl3qlhQy2aBeVqq2XfAAjP/zu1rSqBDiC8+s9bNvLZHkQeGRIOSrvS7
         eovdtjLIjioi+z0bZKbBVXdWZF5i8ZUoJGEGpeeKtpaaEovFGzGtKx3U0ln5cqQRgwGT
         qLxxVjC/hoCabkqKbqUqYY4xP9TWhSTwspE7RNLJAN4Hi1SEhx0vyQQ9oWSRPYzW2dJ1
         SijK1NM2QcGcc0oxno1o4BHcEh4f9OamTG8ZF39yzOfOVKFES6A5uy7yA2tiSZugQm+E
         AXKKioAy9DfMCNBAyL1lQlPmQUEn40zIKvUZEKU6r4CDduc4hyLdi/F9Wul3WcU3WZ2l
         v8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCwyXZ8v69nxWVcxtEAn9KfGkzaGevR3ns9wimMR6ic=;
        b=BiwE1lnJcxKqYu6WKZqiXlBL6bsG/T4kYR848h+h2073BmMXhC0pduGz85132hiX3Q
         f1aTxCMqICRGKSidP4kgOp/KaNx5jvysTCbDhAX4d/Tkp5gHNN2xmErLKDRyNU5KqiCf
         k1bRHRtzEHYdrkJwpLzbGtY7B0twwrLsSBe2QRxgdUC9RQKieMeXxCeGENLZX/D2ZbW4
         4MV9f/00x6QOJ9Jprq2Qstw/PKd5St6DPlAAWxZMyIurRrRJoyOJbUNUgnkDa5VnzuIs
         avi9qkRz9+Wo0Wpm8+6uKZaIaNsTQj152pPUn83U29qvvzP6ATeT95zq93h4ItP0NNUz
         85bg==
X-Gm-Message-State: AFqh2kohSm1Cy2nzKwk7ds69PDp0wF7/D1qzMuQLQ4YazX2BPEIag8q/
        inHXGbpcIoW0LR3k7U1oTiY=
X-Google-Smtp-Source: AMrXdXvDZdRsHQJY+Vh2CB3gJuG+irHektVvnnEDMARBodrGh7SNo9Ps3Jh+DMszzf0T4+3orlPglw==
X-Received: by 2002:a05:7500:438c:b0:ef:9e99:331e with SMTP id fn12-20020a057500438c00b000ef9e99331emr3073619gab.55.1673377558193;
        Tue, 10 Jan 2023 11:05:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c4-20020a05620a268400b006fefa5f7fcesm2880802qkp.10.2023.01.10.11.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 11:05:57 -0800 (PST)
Message-ID: <227de28a-5f2f-a6f1-6e84-e0d0d5dc6bcc@gmail.com>
Date:   Tue, 10 Jan 2023 11:05:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230110180031.620810905@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
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

On 1/10/23 10:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

