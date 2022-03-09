Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BBA4D3AFC
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbiCIUZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238187AbiCIUZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:25:12 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E86F68FD
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:23:59 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id p2so2342246ile.2
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 12:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HazTgyol23oSS4wKw5o0VHobK1cW6sAOIDRHpL8/+Yg=;
        b=IomXux5ehfdCB5zkURzAdBNgNIg+hD26UCANFL+xBIKWogcWN7CHt+Jqv59Ib/ffst
         w6WLxhJplhDKxifGbGD6WbYT7+1inBG048XTnx0gMv3XBGRg8G9n+yX2+lLYttEfmOHU
         4E3rQ66I83GbJy0p0Q9Rb1donNIl9oK7Gm5Ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HazTgyol23oSS4wKw5o0VHobK1cW6sAOIDRHpL8/+Yg=;
        b=tpO1+LhUe76WTyg7bMqscPNY0vkQ07tvpYfBRLetjvS+MKveKEJTJ5fEFfn41oVwYN
         yftI3z2NNt/d2pBCV56UtCDQygGfuEkzm8wLOPR3//dGXHFrztxKKajw+Ucz8g7EBDc3
         VU2fHniIMQt2odxQfum6DDzFcFxffEypXZGhtjcYcvQpKNBf4Tf1qOJSeT6/fDw4+i4H
         jvEGm0y3jEb2ANPEU9YsweZSu5TVbtmKvrMAp4CbMonuWNn3s4vX/BP7UJCd/HDRg9tm
         BCwoD4WJdHVn9hnxGNU4y9lODM1FOoh5jWFNVQq5iahZUEKcDaLO/zxZtf567fpAW5BM
         7G5Q==
X-Gm-Message-State: AOAM531rJ1dCYfzfp1UXMy7XKQfsmoQAI4hgfOJ2qVRWIM5KjRQGNCJN
        V3mIJDFBJ2T3+h1OvUhdMqgAlg==
X-Google-Smtp-Source: ABdhPJzbWsVyN8BeeVEcRW5FLAjajYX+IY17tQ2NJLi3Wz/cDGnge2RzQePVNjkLlPs33+L4C7WR1Q==
X-Received: by 2002:a05:6e02:1baf:b0:2c2:46eb:a074 with SMTP id n15-20020a056e021baf00b002c246eba074mr845367ili.263.1646857439088;
        Wed, 09 Mar 2022 12:23:59 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id l3-20020a056e020e4300b002c242b778a5sm1554828ilk.74.2022.03.09.12.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 12:23:58 -0800 (PST)
Subject: Re: [PATCH 5.15 00/43] 5.15.28-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <3e899e01-9975-9a0f-da6f-9c8334bec595@linuxfoundation.org>
Date:   Wed, 9 Mar 2022 13:23:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/22 8:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc1.gz
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
