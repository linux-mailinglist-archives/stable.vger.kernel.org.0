Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6977B68A768
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjBDBBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjBDBBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:01:50 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23A660C96
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 17:01:48 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id w24so2604504iow.13
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 17:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Unz/hG5qpcSSbqIkSS3L9D824uEz62egmtqDeyQEHU=;
        b=RUfQIoPVMxhRIHryrxTInN6p/hOCXLZioYHxIcIcuMh0NkHx/2F70rPiiWBydebK8A
         ESQ6GURtQYenSyox8XDUmHfb7KCvtE5Lnc6Jw2N5Rbk+45m/lEwDFB6iOrhViYUejPAr
         CRcXRlHNMJtCw48NRA6zT5wpM4ORq6uPPpKfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Unz/hG5qpcSSbqIkSS3L9D824uEz62egmtqDeyQEHU=;
        b=qUyYbrLo8sJK3Uw1vYnHmAmRNBf1HVBYmjzPtbkcVcBnKhHyAP6m+MIR2Qxnqna5rT
         Im3B42AYbvIHme3EeD/rWfjj2GHo5Em4GQqatUoTWxGhjuxp0uYHFeSQwDZrgqOjNxkT
         Ib2uhcXgmpcX6bYqfvur/EiES2t3eCM5W19AiyFrmtn8WA+WDCuS0y8GCw5sSnZPF2TN
         8x1gVTzM7S9d1HIEssfOJ6rqceqctUkhWTrMHePzGr5KOMtC2l7UDhrk3LlV9sT3s0V3
         f3m7plhe194rqnMAzUJWdvpnJTjUeqWNhnN5JtqNGY7PRQutDHqdEPVAWR6padv3JI25
         Wrpg==
X-Gm-Message-State: AO0yUKUyszE1JutotMe3Q4Uy9AKH2i/WRoY6LuKi1T5a5m0AWD3ZUbFN
        CeWvfkB9Tr/M4NBWSfrtiKb0rQ==
X-Google-Smtp-Source: AK7set8v3UKWKGyOPPYfH/GAscwCg9dIrW5FwRvuoG9gq36Mt9idw3RP6zBX/wREbmFMgB72uJzEIA==
X-Received: by 2002:a5d:954b:0:b0:70a:9fce:853c with SMTP id a11-20020a5d954b000000b0070a9fce853cmr6834281ios.2.1675472508197;
        Fri, 03 Feb 2023 17:01:48 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s22-20020a02c516000000b00389d02a032dsm1301499jam.172.2023.02.03.17.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 17:01:47 -0800 (PST)
Message-ID: <6e33743e-50c0-f6c0-42e8-e07cd7cfdd5f@linuxfoundation.org>
Date:   Fri, 3 Feb 2023 18:01:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
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
References: <20230203101023.832083974@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.231-rc1.gz
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

