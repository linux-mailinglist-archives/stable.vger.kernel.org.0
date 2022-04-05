Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC7E4F5436
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242034AbiDFEpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450027AbiDFBsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 21:48:47 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3380392D0A
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 16:24:54 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-d6ca46da48so1071315fac.12
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 16:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M4vjmuTVMZbiU5JaTjwYqkybLPm+olNJlkQxM2BEaQ4=;
        b=BCt0TQXHHcguzELQkTvAp7vF07JTLuIYJu14EOX3Qaypmy1a7fR85APJOG8FTztfsD
         EQXtS3OgtYxVup3AW67Goky09sKYtTm7asc73gs9FBGMokfF1EqhOZt/5riATtAmBfnZ
         KIEx7mlVoWmnrW4QiWDcjVqqavZSbmxeMBwcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M4vjmuTVMZbiU5JaTjwYqkybLPm+olNJlkQxM2BEaQ4=;
        b=CwjAY3W22CCI6PsbV7jkuwyjhbR78Fqpz0Nv7AMX++03qDtmI+T4an2IInwz3s7MYc
         czI5K2dKbLZxCcV3FEvRg1L2DUX3zT7L1/Tu5GzQYDqCWBRYo6LyybmyMM5uesn6AK3p
         RsyF03Npl9gX0s2kmhL8DifP7aJU05Pf3freCYods2roYFxiRKIPNPdJOUW4cuNhqEg6
         +ty0a1tP9Y/rldqfaK2XqgUSLse4R8ZBjS1C+LEk8Xjh7L35d/97SBd5assuWSDwYe1P
         xFWN8En9kjb80Zk1B3iGpk75j39OVb7kBYTtVddiWZmTwbe20nuEnhfRPLJ6L4WqYFmY
         6NdQ==
X-Gm-Message-State: AOAM533jBcSQjQsgr3sHkxshH25X8FxnYIV6u+9UsjCEKeR6YfguKGic
        PDPXiKJHXI6UBGn+5SqH6AEYYA==
X-Google-Smtp-Source: ABdhPJwCTsOtVIqO72PONxtuPaktUOnExZMU65w/Izv6H+WLDA5L2/4QseoHac1k987sArhvWq9RpA==
X-Received: by 2002:a05:6870:9121:b0:e2:1d27:bd1d with SMTP id o33-20020a056870912100b000e21d27bd1dmr2625674oae.293.1649201093087;
        Tue, 05 Apr 2022 16:24:53 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id f8-20020a4ace88000000b00321598cd45dsm5514709oos.33.2022.04.05.16.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 16:24:52 -0700 (PDT)
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4ea24e30-bed4-a513-5efb-f450df5b8ec6@linuxfoundation.org>
Date:   Tue, 5 Apr 2022 17:24:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/22 1:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
