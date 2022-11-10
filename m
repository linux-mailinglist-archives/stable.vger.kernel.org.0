Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7014962393B
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 02:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiKJBxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 20:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiKJBxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 20:53:30 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5C028738
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 17:53:16 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id x16so369816ilm.5
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 17:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yC4dnHY7IX8JIC8XVQZbHumkUsZcQ/kWMRWgfr+JpBc=;
        b=cPu+0IEV9d0/djuPjK0FdyVGoNNNd5l0fDueRZ2ZuMZUktABBeyR+AM7VzWDbIN/os
         7htA7QbLFMA/m8eJr9eeYwvKnIZ3z2Cdah5aa/rAnCZ0WXgIdMgtTU1iGmrTS8nscfm9
         o3Q97lu1YnFe0o9Xs3kcxPq1vcbUA3hL5tIe8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yC4dnHY7IX8JIC8XVQZbHumkUsZcQ/kWMRWgfr+JpBc=;
        b=Q8Mg6kNgtB6VK54q1mTCRLJp7Stx/KTtiuqrQouuUkHNTBSX7uzsYFsHbgktm7tsxA
         yg0JOZ7G7qhTpGNQbVGhE7fADQ7t3g4+0yqfT94sGUUFrhAIHZ2n2yGcv+6WWUAO/oZl
         jND7DCpIRIxuQ1MWAeEmW1FUQ0yQ3qxT6bv9Hyo8TpbKv47W83MJTDT4/ojsLhssg5J8
         oXcjhzaYIdd8+tKJLUUeS8oIXPuyKrda6BIpdqGXF/7A5lz5xtvSIt/h3Cr2RNrTf0MP
         A40OUPaGtjAiUAeF0poutFsEGYaIpxBV4Uyb+GNJSZQD98dwztnUReBfCbeVncO4WznS
         zEHA==
X-Gm-Message-State: ACrzQf22WbeSvFZJQpKjOj5kuygc9AVjeB8S8W63nXeYpVk2BhyL91+Y
        t1UyykIrGNyECMJhr1ZRorVl8w==
X-Google-Smtp-Source: AMsMyM5tS49qktlapJt5vQ4mFB0UbdrVhfHSaPbzXiuGVqR+4AlIi2XLTYN6sOTOsNOqSqYisyJ4aA==
X-Received: by 2002:a92:8e0c:0:b0:2ff:c5c8:792f with SMTP id c12-20020a928e0c000000b002ffc5c8792fmr32280658ild.313.1668045189839;
        Wed, 09 Nov 2022 17:53:09 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ck22-20020a0566383f1600b003636c5dcf29sm5235167jab.176.2022.11.09.17.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:53:09 -0800 (PST)
Message-ID: <ef6bf02f-f0e6-fbc1-ea95-39a097974c2d@linuxfoundation.org>
Date:   Wed, 9 Nov 2022 18:53:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Shuah Khan <skhan@linuxfoundation.org>
References: <20221109082223.141145957@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
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

On 11/9/22 01:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
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
