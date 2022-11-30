Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787D163E235
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 21:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiK3Uf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 15:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3Ufz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 15:35:55 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7A1119;
        Wed, 30 Nov 2022 12:35:54 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso3156812pjt.0;
        Wed, 30 Nov 2022 12:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gSEjPF93GMI3z5E1hQkgEscxi559x8HTBtezk/0B3sM=;
        b=F0XixuXZEk2UTAsNqC7vceNho1K4AE+FJ0RvADRizDnWeTE9clf7X6O8B2gy6wUnZV
         JHGZ8sB0kSijDJfB9lOYv/za7yVGmeWvMgKrh5h9/ocxd6zpBh4iH8+Ac8kGiKA24S7S
         LDy4WxejU6DA3oRZvhxGdEddA+imoExbJvbnBQKAuAhJUy+zpTENRyQYUWu4tjcRjMOR
         EcYR8wPn8kAnMP2yWcbI0ZctL8KIHcCd5rjAw2M5jW7vjMvmutDMz62AmRmk57v7JLAg
         h7SWjFNNJst8+tNLfUklZAS0izR4pQikWoge3vmcJbQ5lqToZ9XnHHGuCupUs8ZvaEJ9
         POIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gSEjPF93GMI3z5E1hQkgEscxi559x8HTBtezk/0B3sM=;
        b=OF0hXfCoJcrjwNqf4vjOIq/EuH5it78YxMaEYbT+7Bx6iCrZUYRtPzM+Jg+CNr8I05
         Lhmpq14M+4H+dUbILatn6CF85CCdzerIXIegUK9NPtWZPE7mKH8eZNktLsvN0tNP7y4V
         KMy3XoBVBepVYcaxcce0ND1Dj1HO3zdLYnYRhwaQ38nvnzaqupr6RY4YQBiBARmRMoKD
         CI9rBz0Xak6nUzINRzMHUcM7wlJN1SfhJPNcudA0aIFBswJGgOSNM89ZQhIqLRxJ30aY
         iGmrwoyjFhGJuGpS3th1fnbwTNuSQXngUSkQUlMqpR0BSd38U+334d1vQjGAKjYP80KK
         XtsA==
X-Gm-Message-State: ANoB5pndtoYDbqbLGAQcQqQyo12FvT4HBXNjOvtsHBNwwMssWOzYeWx8
        zbAzCQP6tFo70Qg3ycCXkZc=
X-Google-Smtp-Source: AA0mqf5DhFdlnhKi8U10qOmeowf+5XiyAAeogl4c6RW380zZBR5Wev9gOPnGQJ36tCRMNA49oIvJvg==
X-Received: by 2002:a17:903:32ca:b0:189:9031:675c with SMTP id i10-20020a17090332ca00b001899031675cmr14548535plr.139.1669840554198;
        Wed, 30 Nov 2022 12:35:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c1-20020a63d501000000b004351358f056sm1333987pgg.85.2022.11.30.12.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 12:35:53 -0800 (PST)
Message-ID: <8a1564c1-3321-e180-7340-f70cdddd40fd@gmail.com>
Date:   Wed, 30 Nov 2022 12:35:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221130180544.105550592@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/30/22 10:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

