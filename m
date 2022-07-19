Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F238257A639
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbiGSSMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 14:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239948AbiGSSMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 14:12:03 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B67B5C9C5;
        Tue, 19 Jul 2022 11:11:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso2040857pjz.0;
        Tue, 19 Jul 2022 11:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZL20oedxmnviAUBaSn09RaT61qD24EJ96IDebQUMg7o=;
        b=koR2hgNK02+h8dwMhuV320QqlSM+AEHej7R8HdCtvK2ntQJvIgscNaNNYBxjF5pLWQ
         ex8NnMort4zNWxCIgAe6Qmam7JiBhTSa5T6tsgA/P8Ow1sd7ozlT3j0Lot7vrfRksgmW
         Ls2pk5IrLgQuyufpu2AzaCP3pkA23KWysu1BfFZIesbsfLcVu0LRwjj2y1JwLBQv6d7G
         8QbPTYO67g6kxpUS0BF8YcftazXm9jmAuBYQStNcoPdvwX5c0yBwHNXSxQ3ohxzX1n92
         R62jCBtyHhVFF2nJyDPfW4qaatd0vRI9UyO8Y8Au5098XxO9iWv/r5nvucY1h7zy6+3Q
         05Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZL20oedxmnviAUBaSn09RaT61qD24EJ96IDebQUMg7o=;
        b=54nEBJs4jezkKrqlt+tkquHhmeSxEcfWjlAguhqLNNDpFAYBoSNifzX0yFDLy45rVg
         w1wruv2ExgMIBvsO2gTorRUY5aUo4oJz0Bu4LE0L3BVmagPZtkHBDLYQNUERXcorZKTi
         JrZN3E27/wJcB1t1A5jk5YRVn68ocY/Zxv4AcVaYjSW6U/JfwqwLD0W2xFylwZmmNws7
         o1fUIVIcxTA4Mw0ckjxu2SPjHCSGDQVd4c3iWl5zav51RBVkygk5pIvfN4vlQaN6Sd53
         YreXl18Zj6q8YFVCManYgq43yqzDAnLfrZz2h62BvWyEV+B5hh4Eq4O0fCss2gAtlXAS
         0U5Q==
X-Gm-Message-State: AJIora8AgscakNPQ/bmOLvs0yEMfVgh9MosZVoxQCQOZo1o7HDfgE3CB
        PIUuohCDav7tnA/6Mw8VSdc=
X-Google-Smtp-Source: AGRyM1uqvqhcR6WESD+U85o78Rvej+05X9CxZkttsyBFYkchWQgiTrKSLe9DXGeXGDP2+Ktl6JQNTw==
X-Received: by 2002:a17:902:cf4c:b0:16d:1175:9ed0 with SMTP id e12-20020a170902cf4c00b0016d11759ed0mr3260447plg.66.1658254310598;
        Tue, 19 Jul 2022 11:11:50 -0700 (PDT)
Received: from [192.168.1.106] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g5-20020aa79f05000000b005283f9e9b19sm6964517pfr.180.2022.07.19.11.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:11:50 -0700 (PDT)
Message-ID: <ae1ef021-abfa-dbfb-91c1-2624ceb04d31@gmail.com>
Date:   Tue, 19 Jul 2022 11:11:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 5.4 00/71] 5.4.207-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220719114552.477018590@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
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



On 7/19/2022 4:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.207 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.207-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and built tested 
with BMIPS_GENERIC (bmips_stb_defconfig):

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
