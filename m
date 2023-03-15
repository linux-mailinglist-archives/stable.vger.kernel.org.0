Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257686BC1C8
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 00:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjCOXxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 19:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbjCOXxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 19:53:23 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB95021A28
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:53:21 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id g6so52451iov.13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vd84AnaoqgffLltxoJ8OX+oSLpNPg+Q/OHum9kFhYu4=;
        b=gOyCS30SFVW6sTveg5ZHcXeE6gWMPyuqbyjPATNISsBAnROJmjwGRjCYyKcWGRqXkn
         Q69c70ipIwyUxTE/geusAYoXPHFEQR2S6JuHCLRceUSGDQ8XLsp9j0ZviAXzxID0Ii+O
         g/jvY/0C5+MaALCLLPkWVtYtfzaW2SGQrerMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vd84AnaoqgffLltxoJ8OX+oSLpNPg+Q/OHum9kFhYu4=;
        b=YvxG6V8V/mwk7x9q7rlV0Elpt1Qnnl/HYmNhRndu7qnrY8gx8HfyiL7HiTc3Uv5p3o
         3O44Je97TPgZUNi6ZvwT1fhnZGspQeNYwyRjI4Chx7DkVDzXo0lGpZelXh2NhuGzGp3/
         75RhLexC4jNAst958L/pqGCvCyb4xuxwcDr7ygLEPUW7wFCiehB3/6TPkhTF0xc6lNor
         khSCghkRjzuu3v+Wizm3ShPLGVQjYPTBYuCDec/hhgV+cvJ02mDMXo69iBZOZY2CH5QD
         Ga9X17PAbxSrubgy4HeenK3R/dKVv01fNxzCTj3Sdlao1Yigov5ZNdBB8Jou7J1ieSWd
         c5Gg==
X-Gm-Message-State: AO0yUKWl2PvlMHbWrRUfy5yGzznxB0upkUIPlgy5kPq6Vmmc6c22tvI0
        oETmAgwt92hZhef4EeX/PLDs0A==
X-Google-Smtp-Source: AK7set+9r02RFtx+5x1+uLhD5DXcNqJleEdP7NFpP2nqpfoRY8f0irMrHrwt+9+fddL4+SBIzfZdLQ==
X-Received: by 2002:a6b:dd0c:0:b0:74c:99e8:7f44 with SMTP id f12-20020a6bdd0c000000b0074c99e87f44mr556896ioc.2.1678924401244;
        Wed, 15 Mar 2023 16:53:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k11-20020a02a70b000000b003c4f7dd7554sm2126614jam.5.2023.03.15.16.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:53:20 -0700 (PDT)
Message-ID: <9985fb4c-4e10-e1c2-110b-8003fea0ff30@linuxfoundation.org>
Date:   Wed, 15 Mar 2023 17:53:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
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
References: <20230315115739.932786806@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
