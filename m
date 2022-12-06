Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E7C644E6B
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 23:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiLFWOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 17:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLFWOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 17:14:34 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA4A31EDD;
        Tue,  6 Dec 2022 14:14:33 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id j26so8707451qki.10;
        Tue, 06 Dec 2022 14:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K2zu23twNKS54cXNdL78RlekF8d1xuGtuL1+G3LtJiY=;
        b=U6yX3xI9s2oaC0HxMDnJcLgU0zKMCKXHyXtw/lRJaog4VmLf/HKrketdBslIoMVEdU
         6I4oPOhPmChSRL8n52y05OvyL0EovhKCbJqwVtIlI7ui+3GV3GnOdKcLJN+uNa7WvjHl
         5XCA/6Pj/KJpXTW8RFgKCeHKqbq3DSrjtLeC7CmgjmWba2GbV5ImqTOqPnjURf2O94jk
         Do/H2Vyj7erufXPy7IfJykTQ1BB8nz7+CjJDbzmFOCbkTDN7ERCBs008vBEXQg0IwcnV
         NuIqd/aPOWi3vLrtLKcbRspouDiK4DVNow+nqQXCdafVigzcL/qjfpsnrbf0Y2iP4lT1
         ly7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K2zu23twNKS54cXNdL78RlekF8d1xuGtuL1+G3LtJiY=;
        b=fmY0JHMtLPkP7fouECOsS2ogCICja45pXeWmJjrGVPI8g2k6dd/e5+3TS6PXtVoRok
         73bKMWmodGAXfdJzuZTGZ5hX/pkfNWOMHchDFidgZgZiTnf5bwL7EWpoDdDUb6Mz7xrC
         WhcJZ/n5Rvaisb+PiFrSoMciEbsMwDGMN6vh4RaeDKcRfW08abECi/92RL9A8SD+PJSn
         K7Nva+7AWToAG1Jnx5QUsHCJd0nzG+VjaesNfW4jaFJ4u4/J1ai6YC/zKEkS5vEfQPH3
         1SIUOWMGcikyx5ppuKdXHChC7tzZ8j8uVheMfQHKxO36LtwO1jywoRaKYu9NoTDPeats
         IFMg==
X-Gm-Message-State: ANoB5pl+6js053EhwYwBf8tuJd6tAgiw8SWOYdanhDISaebD5eQYaWKp
        xnXKhFe6y/ZtJex97Ci7a0m04TOE5RPyPQ==
X-Google-Smtp-Source: AA0mqf4prugQ/SUV8HMwy28gpVRMbEQ3kHOT98e/LtOYHRIQYKwLjisCad+0hsMXRFB95KVhwkmapg==
X-Received: by 2002:a05:620a:3720:b0:6fa:faad:2008 with SMTP id de32-20020a05620a372000b006fafaad2008mr62815393qkb.668.1670364872274;
        Tue, 06 Dec 2022 14:14:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bm1-20020a05620a198100b006fa2b1c3c1esm15931304qkb.58.2022.12.06.14.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:14:31 -0800 (PST)
Message-ID: <df796897-fe12-4470-8fe7-63d11eebf5ce@gmail.com>
Date:   Tue, 6 Dec 2022 14:14:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206163439.841627689@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/6/2022 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc3.gz
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

