Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D72628A60
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 21:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiKNUUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 15:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiKNUUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 15:20:49 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7EF25EC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:20:48 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id r81so9124589iod.2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0nQMvLB5INQNmj5E/HGsA2eiB52DexTVVJe3m04ZfpA=;
        b=A22VrwqESF/t5YHz3RtHI5c8nxBisEmNDqZ+aI+eW1Yq1Ic21fd3d+8Q5WPpMWSqQM
         sP726UE30fXy8u7zepEOIhmDVY/JVB0G/mwcOobUw5uwU+uEnrKGbw5K16VnVR/GvK20
         4GRiEHFrRjhHsTxNVZkNqT92MR9W5KgBPu/10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nQMvLB5INQNmj5E/HGsA2eiB52DexTVVJe3m04ZfpA=;
        b=DaS4BNLUYwEUN0Y7kGYTtkvRKkouNcvWSgzwkedz1FDpE1odFdb47/wpkZB7OmqlZR
         xM5+DfaFEz0qYRyMf6PVrNma3XhQhb95xOeVAiYaPFtD1uGl+sLu38Q1jFCFm+DQS6/f
         R9rmfdCleAf6hzKNGyxIYO9MzX3+znFoYERMPvpnhtDM7BgmpmJQkjS+EOxC5jFyV2uu
         SKgr9nz8yf5wCIhPgPu6ncndcORPxmgYrNSqVKnfgXbv7Vm5WiTLTCZwHB6naRzgzoIH
         i4p5iToCpsQYArwJsI1w2omSVDJ2AfT6rL7W2kcBAfdttqEPCuAQODlklpJled2zlfQc
         mc/A==
X-Gm-Message-State: ANoB5pm+PdV40d4Ll83I9RCLngk3NGl9w5QAUW3Gr06LWHfpiSVmDmpm
        gln2veaG2pCgFfsgQAC+bbxzEw==
X-Google-Smtp-Source: AA0mqf45a4K8rpJsFCtIvLY6IJ/KooyuKaDOP6YHXNNeADL9vwk+q3ct9iaZw5xCdlHBiG7SnheWiA==
X-Received: by 2002:a02:a002:0:b0:376:e17:5eaf with SMTP id a2-20020a02a002000000b003760e175eafmr3080930jah.56.1668457247869;
        Mon, 14 Nov 2022 12:20:47 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e22-20020a0566380cd600b00363dfbb145asm3685533jak.30.2022.11.14.12.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 12:20:47 -0800 (PST)
Message-ID: <0af677b8-a796-8fc8-c892-c588704732f6@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 13:20:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
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
References: <20221114124442.530286937@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/14/22 05:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.155-rc1.gz
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
