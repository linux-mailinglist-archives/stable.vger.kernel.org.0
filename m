Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACBE55DDA8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiF0WEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 18:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiF0WBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 18:01:53 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA2563D7
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:58:56 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id p9so6663762ilj.7
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9GT2nNkf49vF8e158U/wUxr794H1AaU7oOi4NpwptRo=;
        b=hI3vmhAhkEP9/+pbu0tlgrBl5K2kpR9NO/0KOOMQlkWERtpIiGxuMs6UYoVc0khr1B
         T2N/zjxyZ5U9LpQOGiqhXC46jisNQvSetx43pFRoxEn/5vcfNHzlu0/SbHmnKwALj9iq
         9jM1ZidZCct2NUfVieaRv5q5u1wMbm8FSEJXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9GT2nNkf49vF8e158U/wUxr794H1AaU7oOi4NpwptRo=;
        b=I57Q/YKqSR4lsly8Vx4H8iUe7N01Cgy5sQE1dHtKj7ctRMWjnfIlL9b/3cLoI0qM9/
         QSBGZfRgNfZc8F57avH13l+wSaVgDGVTJvSV0agDzpnU8NFP02s774ytJqbqLTTWwYpr
         wOrm9Nifj6tnb8dJB4SexO+CF4xUe1Cn4fd4jLdTRJRM3WS7fFyY1fsZck6viNUyM/dA
         F1PiYeKt8emvpa03IVQ3vBb8C3mLTFH8uTNFWXVGPv8LDVWTqZROtqQelkAIs4R8K46y
         OMpQFsvlY3o98hukM7BbbeMPmXfK6pq9OCh0vyOnZRh8CEhfKqynPiRwxNiSxC5Q1rIj
         Q5Ew==
X-Gm-Message-State: AJIora96xeATsUdsx10EDfvL6GOpvg1JYEyaHYQl1CK98/1SWHMq5m5O
        hT5ScAAUvMdWdkI9tOm3tmAW/A==
X-Google-Smtp-Source: AGRyM1uZ8G2wTmyTVBvBNcpvF0K/igCH/hzNr+NZzmvopzmHYb/uOzsaqR+LDhuX70NqRGsjSNzyvg==
X-Received: by 2002:a92:a041:0:b0:2d7:7935:effa with SMTP id b1-20020a92a041000000b002d77935effamr7843380ilm.222.1656367136275;
        Mon, 27 Jun 2022 14:58:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t3-20020a056e02060300b002d93c072c56sm4031214ils.40.2022.06.27.14.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 14:58:55 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/60] 5.4.202-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220627111927.641837068@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ff5f22d8-37b5-df9d-5873-4a9ce7c1b070@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 15:58:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/27/22 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.202 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
