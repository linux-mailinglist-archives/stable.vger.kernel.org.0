Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA876623963
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 02:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiKJB6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 20:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiKJB55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 20:57:57 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671492A247
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 17:57:55 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id p141so269976iod.6
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 17:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVy4dHcr+3ctZbV++kQ+x2sxq+u+6c8Ljhwdo5Gph+o=;
        b=V54ScCv6iT/vmqAnORNHusYQVooKtM0NdwmOWzMBLGp5BODUbRmFJ0IqP9fu6Rxf1M
         tGbQZ0/XN1fQuYj4crq4yK4m/dDlID5UDTy7Bqc6IySwjbBBu4NvirICBn4+5fHpqogy
         r2L+ewgLNAMUcy7raSJT+wg3u0matJ+Qj4lXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVy4dHcr+3ctZbV++kQ+x2sxq+u+6c8Ljhwdo5Gph+o=;
        b=lpce8LcLNhS4nq8ZVYDPGhGUxd1NiRqVUSVF0VzcT+wvfarSNXMVQWJGk0OeyLKH04
         w+lTPjJv0SpyD0v5ieiuDnnPw8k4PObBVgmUEsDkQRBr/BmMn23WwjCCcJP74s/YeupG
         b2KfC+6lSINCrB1dF4TdvQi8THEgCRQOC1DPPR/5ycjtAbf4wFUOcdG/gT/qI1V1H/Ts
         cteCKOoQFY1K9JJGEQbrNOWoQxucKhfTCDVCqM0VDflEEGNH53qrSQkj1NNWhBolBUwM
         3iEY+Egt2Plt0MEAVMHLscgiCK4uvllXqpRXbvyK0Gp9LfeLoRlszbqTLqVd8Gl7r741
         OlBg==
X-Gm-Message-State: ACrzQf2F/c86lbtImIBaAo+OUPRPIoN9iqZUmnKaZMxn4xcbQa8snqU3
        LrzdTVc5hnnBzgixJ4m4fPRsgg==
X-Google-Smtp-Source: AMsMyM5ilNKZN2ViiC8a5bHibrF/afIqpOauFHiW67ALGdURC06ZZ6O2PScynkQXeUUesfmRBqxXDg==
X-Received: by 2002:a02:6d61:0:b0:375:660c:2c78 with SMTP id e33-20020a026d61000000b00375660c2c78mr28137761jaf.193.1668045474756;
        Wed, 09 Nov 2022 17:57:54 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i5-20020a02cc45000000b003720db763bbsm5332873jaq.106.2022.11.09.17.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:57:54 -0800 (PST)
Message-ID: <a59aba7b-8602-84c5-2caf-1b1b7f600617@linuxfoundation.org>
Date:   Wed, 9 Nov 2022 18:57:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.19 00/48] 4.19.265-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/8/22 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.265 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
