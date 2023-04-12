Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D846DFED7
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjDLTlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 15:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDLTlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 15:41:12 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2366269F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:41:06 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7606cf9c551so4189839f.0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 12:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681328466;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ql2TRAjGOflpr9Whb4W4uT3fSvI+kJA4AxiqWsIZIc8=;
        b=VmwIeNu0tX7WOntbiPN80zRIhYotWibYJiYtotMwWOG5llUAtyGBKFXwaSky9drvqg
         zOwgT23N42FAugD+T+sjlslOuXEIYcacASE0APNSl6m6AvC6xvNSHNaWY7BEf8s6qIp3
         AiUQbydMiKsgGVHtqk2sOEXQ909EZwKsV8Em8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328466;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ql2TRAjGOflpr9Whb4W4uT3fSvI+kJA4AxiqWsIZIc8=;
        b=QgUcsBXeyaoepyWywrFKjOsSIhYphyG786K+6OdGYUZfrAHBDt9kR0Dyk+K08P84YF
         9q6Ao+WoTKGLmxeYjhPU8NZ8kx9WjcU1rTTI0popCnEetu6jdUQQmlCij5tt17AQeQgG
         0HjPmixnyZb/DeWWQThHjambBx2zNRUHzZ5/olSmN+jQEd50hLpQ6iG5nKaDdJBLi9IA
         IndJg9J0/p1GdkiQ/aCWMdj6Yy0haQEf3FBp+KNYj/q+uUgoTaZAjUp0nLGeTA68Pd09
         2TkZLdwS61w0VD9gmo0VN4HwrfPYeuacG650eHRnJjLX5eQXOR18w1CkgU54f51USLTj
         RqtQ==
X-Gm-Message-State: AAQBX9ejwRbd291zZ+oTUz90SWSfOis0V+fhUSfOdkszaMplwuhFzblG
        aLk+qrtq9vdaTOQBCt+UPGvYeg==
X-Google-Smtp-Source: AKy350bFAJV00eVFNzyrbWV0rVV5BzfmhbZQv6Cav0Gy81MxDHlYipcSY/zwavuuKDckDpXWk31R4w==
X-Received: by 2002:a6b:14cc:0:b0:740:7d21:d96f with SMTP id 195-20020a6b14cc000000b007407d21d96fmr1700262iou.1.1681328466035;
        Wed, 12 Apr 2023 12:41:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c9-20020a5ea909000000b007594a835232sm4475016iod.13.2023.04.12.12.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 12:41:05 -0700 (PDT)
Message-ID: <b2e4201c-f1c0-a842-ce07-7befe668a698@linuxfoundation.org>
Date:   Wed, 12 Apr 2023 13:41:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
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
References: <20230412082823.045155996@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/23 02:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.107-rc1.gz
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
