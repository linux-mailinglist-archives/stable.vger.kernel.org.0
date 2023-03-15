Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0399A6BC1EF
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 00:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCOX6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 19:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbjCOX6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 19:58:43 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8990065476
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:58:30 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id 4so101562ilz.6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=YQZ4ieHz2aKd57VRKTQ4sWESTfrAbmtJdoHpYHJ4jvtSCLizGwFyFHimUIrCdK/8/0
         FW52raga8m0fMotiasW7QR7mEzzWGNtttaNFs69zX3X6oecLaK3aBG0t4gy+sR75rAo6
         eGh1CyhhELLVhhf0Pzs8Kz9v4qC5OIzD0NAYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5n6N4Kf45DWAUdDU8gCqH2UU9H1ulFevAL57GqiUGY=;
        b=UCTCvSuxE1Bk9+eYnihOOO5qX/YvxUg+2kYln6a3C06gqasRr8QgvALBkjeh65ZuAJ
         n8eARzauTAH+rwjXmmt7iFA0A5uEWNBt3chOP4bupY5O17Y8IP8JVJNtRXuJ7EWqO1sY
         MwoxSO2GLKBgG/5C/vsK9yx7eKtmhaH1Cv8ifsEsWnW6/IVLYFCLYLQeboQzQiBkU+y5
         N2KKqgOki+ZkSbIF/WmQuTKvpwRObkXMNBmcf6Fj6+kM+1ECUwhLiQA4x8hk3e0Z0GlZ
         gh1raYKIIhM1iJR0WhAWBVoS/P8qCOVO0fChMKgNua76HNKjMrrX24otJQIXSKJpKqmI
         8Uvg==
X-Gm-Message-State: AO0yUKVyrXkOShh/EZPKF7CnvODYIH1GjCnQ/vlscopY5aSuSB7D+wLP
        rFsrxeH1q1xhjDOdcvylnjy70Q==
X-Google-Smtp-Source: AK7set8FwaNdZ8lL8DpYpHdbxVeHP78YybZ7hV6/c6EBv03k5UuiYpwi2muQLsae8M3A0FVnVs7Zxw==
X-Received: by 2002:a92:c547:0:b0:318:8674:be8 with SMTP id a7-20020a92c547000000b0031886740be8mr654138ilj.2.1678924708259;
        Wed, 15 Mar 2023 16:58:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o14-20020a056e02092e00b00313d32f8345sm1979717ilt.66.2023.03.15.16.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:58:28 -0700 (PDT)
Message-ID: <ceaf4aad-d6c2-a1c4-22a9-193a60f29fd6@linuxfoundation.org>
Date:   Wed, 15 Mar 2023 17:58:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 000/104] 5.10.175-rc1 review
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
References: <20230315115731.942692602@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
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

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.175 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.175-rc1.gz
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
