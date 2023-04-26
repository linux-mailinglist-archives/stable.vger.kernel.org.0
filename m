Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E2B6EEB65
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 02:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbjDZAYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 20:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238411AbjDZAYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 20:24:11 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E718BA2
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 17:24:07 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-763970c9a9eso13261939f.1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 17:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682468646; x=1685060646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xEkXql0myiwlSwKFESLcNnwEuA0avJTRSJrSoXaJZYo=;
        b=Na2/3KFVLVVwJ5u/up4JIUCZtHMgs5azVk82HBr0KUfunMnOFf1FogCIIFbr3QetTv
         pmjfzan0dkSUFAZb9a8nluijP9k0kqH+0FuKLqKYj7HKQw9bDM/b2rR6lYSxW+YTSvlY
         Tf4Uny2BQvTXS2RGDdOHmjltvAquCTsIHJtwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682468646; x=1685060646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEkXql0myiwlSwKFESLcNnwEuA0avJTRSJrSoXaJZYo=;
        b=Ko7ZVbQbAcaEP7xHriNxpqNCmsd/fJfudNVQ4CbPPe2Mo/BCuygDD9tueswkHN10Sx
         pHsuV7u2xtygKqJZwcGnVsCsrF156cATtkmvOheyN1RiDGo4ABCSRdmGlnf4fx/mq+n8
         WS+KHKMj4o9F98C5PxLXW2/Ws00ruMniXRMnqwHPZxsF64c9Od4+lsX70XklFpnL4Tec
         NnXeN83srIaItFiXCiUUz2cRHRKhkYRMbCZBpWdMC1wJ8N0MXlVFxN12G84o3MYWIslX
         HTDgdZoaSSaIPgRS+w8nplyOpz26hTTZBtAOwVQG3ddp4G2dEAau10ERDgVsUYtTs/9c
         DZug==
X-Gm-Message-State: AAQBX9e3yARggqU40XKhKMJmyVFF+m3yi68rtDUJxDuKMul6OzQvSjun
        ydVRwiS9DniedtK57OyKZBc2UQ==
X-Google-Smtp-Source: AKy350Zz9fjE7yr8crVz8Do6VigsWw+sdnlMiEqHRz9MaXRVBr+gnwM3rgJr4LeEuBrEHNhSLAqVdg==
X-Received: by 2002:a05:6602:379a:b0:760:f7e4:7941 with SMTP id be26-20020a056602379a00b00760f7e47941mr10661654iob.0.1682468646567;
        Tue, 25 Apr 2023 17:24:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q31-20020a056638345f00b0040f91a65669sm4500839jav.21.2023.04.25.17.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 17:24:06 -0700 (PDT)
Message-ID: <02e6ac01-8ea4-320e-8d01-9019dd103d68@linuxfoundation.org>
Date:   Tue, 25 Apr 2023 18:24:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
