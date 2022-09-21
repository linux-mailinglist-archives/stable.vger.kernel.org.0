Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FEA5E5669
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 00:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIUW4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 18:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiIUW4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 18:56:15 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31DC90815
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:56:14 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g8so6401403iob.0
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=7EMIiUheVMRIewD0sfGh5r4F5pJwhLiH6aNZws/GdNU=;
        b=M05CFdrqCVwfTKa+KZT+7ZlWrqGFrMuzfOq/qanI/sqNlOjHhq4zi+5zwSUJu69c6b
         vaSJrpcqo6eOTgm1Qoe3UKpjGY2FiGxPQA8rN1KSNyBPOH0onkntxqfDic21xHU6RiJ1
         JipKH2n3P3Z7/wvQo3osMQacb9AIaEqDzvads=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=7EMIiUheVMRIewD0sfGh5r4F5pJwhLiH6aNZws/GdNU=;
        b=1oNMJMEyyGlBoWNf/LipxdQrgdkShMN4lOp9oQt1e28nBxGnyS+QglL3yAt4GVsO/w
         A85m6icUbSWVqysgXac+UhEZihfCiDHubsmaWpFC4aPuwVcJrLxcWkxDNOnfO3Y5n+Hw
         0YC9e7PYGcVdY3g4RzP2woi010xFydPSBaxFn8R+X/BVcTOG3olI8MQtCs168jt0U+A2
         oL7qanqOVOPPXNNYrcii/oduXHlvvSnbjOQAcoItz4eL+s/UrvBw1jTXwHocpjxilEUD
         jSTLmGerPFYkcklIPeZCgC6uGo9mXGxz18xoEVY8CF97I/P/+hOIPtmQnGiuFLNFtLFq
         8Ciw==
X-Gm-Message-State: ACrzQf15KRBcJqRmueN7Dw41BFvA+HjjdnCuMmZ0KgMz7yZcLukujZc7
        2jhWAQHUvq4C8T+m8Yuel9tuQQ==
X-Google-Smtp-Source: AMsMyM4m/gQUqbd+EAzo1GlhXiglvapdQgcc4fxEPcLuPDYY+7MXBdgu+PsXBx8Yr2LpCQtmE7F23g==
X-Received: by 2002:a05:6638:1683:b0:35a:4772:edc2 with SMTP id f3-20020a056638168300b0035a4772edc2mr339201jat.128.1663800974265;
        Wed, 21 Sep 2022 15:56:14 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id w28-20020a02cf9c000000b0035a648fd47csm1565018jar.61.2022.09.21.15.56.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 15:56:13 -0700 (PDT)
Message-ID: <45affad7-bbeb-ed6e-d664-c8f58f991671@linuxfoundation.org>
Date:   Wed, 21 Sep 2022 16:56:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/39] 5.10.145-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/22 09:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.145 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.145-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
