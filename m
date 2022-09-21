Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6535E5657
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 00:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiIUWsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 18:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiIUWsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 18:48:36 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72556A4B36;
        Wed, 21 Sep 2022 15:48:35 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id k12so5046331qkj.8;
        Wed, 21 Sep 2022 15:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6z99X4lRCTSIu2Q4XQ2h+oEaKO1StmXKFpMlcOU1xTc=;
        b=IDVwKGihc4JLCLvPIAzB8kj95wkmpQJmjuR6Y2UOgse+HTJkrmJ2OtNOvJL+vWAHX/
         Nholgq/gPTKEcOf5anaxliUy7vMToNmxRn1Rg8FpnIvkjwmVcqzNLipPtsd5Yaf0n7lL
         TDbNktU6CF2YUO/zUbHb+NE/1jIwroQobXXk3WNjvD8FwEsbT3ctihF8w1GTAm+28vp6
         +j8MjSpA42lQUGlS9I23ufo5uxQALjnOqm2lhPCrtfcaisJ1wnAdAme9aGinxN0v4VG1
         niNZpUPfaZ7Hp1yB2/Fteo4hsPdoi1NGaYonc1Mdq3WPDi48a82Mj85HPT8jU/pbhqOR
         Aumg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6z99X4lRCTSIu2Q4XQ2h+oEaKO1StmXKFpMlcOU1xTc=;
        b=Ey1jeJN1GvLwkZkxgWP03qgTYC531tNHF7CHc2CgpNQmTJEi9e/5HDxM5xt+o0qvL/
         GNChjH+wWS0NRZ5bosD19KEzWtW8sufNIlAOf56AuePjZEx81FYiplxVcU6WpNZvb5vj
         o0yc7cMSEIxDqggOhvd2GIQm39zKuNGQf6lfl8TZjeAdEGIoWbYSw0BARy2NJSdaXqsX
         erVMfwD54pSldlkysuDP4uO8UiVwN15mck2ON0Kq9pbelQnyO5dGIkzJqlUI7gjajkC4
         ryMqVNUbVEcJmR3ASEZGl7ZfH1VpkOc9U1bU3xqXGJuK7YGrIaNVvKE0jjh9LVomkHg/
         fsIA==
X-Gm-Message-State: ACrzQf0TNBue61dZTDkYLkFrc8ne0KikYbUufaYulYi/xJdBt4NyjBVn
        4SmYml4ub9oZS3U4Z+lmYPI=
X-Google-Smtp-Source: AMsMyM5tkkbKDyQcHn4eg09it2IFhd8BeqGbxdxmG/v6GVxYq/n8CY6t/nv9IiRsEqxpRkJ/SRgHJQ==
X-Received: by 2002:a05:620a:1aa4:b0:6ce:6105:dc3f with SMTP id bl36-20020a05620a1aa400b006ce6105dc3fmr280586qkb.632.1663800514551;
        Wed, 21 Sep 2022 15:48:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e24-20020ac84918000000b003445d06a622sm2309680qtq.86.2022.09.21.15.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 15:48:33 -0700 (PDT)
Message-ID: <eabe85aa-0e04-e691-cece-47d0bc5cc321@gmail.com>
Date:   Wed, 21 Sep 2022 15:48:30 -0700
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
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220921153645.663680057@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/21/22 08:46, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
