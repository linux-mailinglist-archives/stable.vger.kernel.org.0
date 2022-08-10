Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFF958EE5D
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiHJOb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiHJObc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:31:32 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E17B248F5
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:31:31 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j20so8364260ila.6
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=ns6JDd8CewO25+DVvrCONnPh03MSrjykonj1NN4uWq0=;
        b=QqW8l22YCkzKw4GiMQhdY8fTQbzaxtcSs8JxhgwNoFi2zXeRFAD8VRsY9u+hCAH68W
         EJE4wzgtTikkQ0rwBV9xDTt8nWB8aUOJh/tLQLCkGcDF2m3eJG/Z1c0LoOgWbMLBWe4t
         TTNamrbhNtfLUiHA9wTFndmUXcWW0yTsRWnJ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=ns6JDd8CewO25+DVvrCONnPh03MSrjykonj1NN4uWq0=;
        b=u6WA3NdlrOZ8CFnf1msq3cWj0PMC96Sp4Z0AzduEC+5XAAxwEk0xEWZUNQBa4NLsv8
         N1gezTy8h2QCZOEgA27cx6gp08SAGtFLuB1mso2KQRmMBtAYeE6LvhaIxoy7kCkNBmO/
         vz/k3z0VOqD1qknPia578TsrI49fCmOSyAM1SzYsO3NzWCktPhqfAYEkeuRg10X9W5Ht
         ISSGnAyUmjyjqzzwJ0CcAejbkg5sikLyKuFiZdX/D6t28sjgzTaI3w53XakGbk4u55NW
         NMJ+qDZhRfcjXXluc0YV00axTjZVtCQUAVaZ0dcxzRenokraaU3PJni/uT/dd1qLBRTz
         2iqg==
X-Gm-Message-State: ACgBeo2vamLsC8X5kyMqMbaEMHnMHFMDXH2LQPiy+SUx9h9tgboA3m6U
        ZBMCyggRBrbvE7jidqQTTGrv9g==
X-Google-Smtp-Source: AA6agR4ghNnRaWdrhVSZW42u+mwllcSQXG502scOPUUZK9LyRQtgtVK6DJqVsuZDfH1hxpgGS/uj7A==
X-Received: by 2002:a05:6e02:1aa3:b0:2df:922d:8b3b with SMTP id l3-20020a056e021aa300b002df922d8b3bmr10785127ilv.166.1660141890910;
        Wed, 10 Aug 2022 07:31:30 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v4-20020a92ab04000000b002dd0ff02527sm2210488ilh.55.2022.08.10.07.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:31:30 -0700 (PDT)
Subject: Re: [PATCH 5.18 00/35] 5.18.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5c88a8d6-73b5-df3d-48cc-4a112779ff56@linuxfoundation.org>
Date:   Wed, 10 Aug 2022 08:31:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
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

On 8/9/22 12:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.17 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.17-rc1.gz
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
