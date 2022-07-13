Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50615572BCE
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 05:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiGMDRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 23:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiGMDRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 23:17:00 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1ECD7A7C
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:16:58 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id l24so9736891ion.13
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NOar6MnEqXDwtrvK2AQRJKKT3Ik/UOEZ7FiGAzg0z3I=;
        b=gWnkKtkYhbBlUSQWnVOU6Z4mkgThELPIxFQ6XfFxLao6p09xGmBlhs1vROXxR2pdhi
         yv57GMfJ36NdK9pu5AarTj+bQMdtTnwdr/ZVudUt6kfDV+e6FqEDm9mXXw8gfsDfJ4Xk
         qe4kJd2dmqc8y13graokDpOMsP8nQWiAnspMg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NOar6MnEqXDwtrvK2AQRJKKT3Ik/UOEZ7FiGAzg0z3I=;
        b=UFZbLPzSYSzQugXuNVFeylG0NbDRHUUniDA7O+9+IJhuttaw7e4lEA4Qr/gNJiUV2O
         t4fhbC0niRu/q5fvBa7VZ5b7sNnXfLFNiTvi/TOzQp8DcuuqzNcz87YXI0QUiyoGoLoS
         VQj8+/0lg4NsX+LPcKF5N8j7xhw4FgaqKB6c5itp8RqqTAQs8jz6EZdHS+JOeL+W9W6c
         V6oNmY5XDTnTbSEXRBAEWbYwoFU3kHlTv/nfq7H8/wQ5TR9lM2AJbGy1sVsHO1lzzK23
         qui3ByKo4Chcl8CX1VxT6mJeoHTUdxTgVDppi4GPSytwRr4LFhJEtzsTEf0ekSqoYKnb
         jQ/Q==
X-Gm-Message-State: AJIora9PstD8PPN87yldzyvMFJulUrwLwEW/Hd+pcLYnjTb/+ow58TN4
        XXRHrAdkNX+GSNU3Si+UOhU3TA==
X-Google-Smtp-Source: AGRyM1vmqZ30pQeW5eGceJziZlGF7mRuL7z7QxE4dc7LNV1ESwzK0EK9/Nldb9DQjAKsZE8ZvJYDVQ==
X-Received: by 2002:a05:6638:3722:b0:33f:4948:a91c with SMTP id k34-20020a056638372200b0033f4948a91cmr767877jav.283.1657682217851;
        Tue, 12 Jul 2022 20:16:57 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j63-20020a026342000000b0033f8312ee5bsm184798jac.41.2022.07.12.20.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 20:16:57 -0700 (PDT)
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <89cdeb96-6227-4f6e-5ca0-f78adf3c7e07@linuxfoundation.org>
Date:   Tue, 12 Jul 2022 21:16:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 12:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
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



