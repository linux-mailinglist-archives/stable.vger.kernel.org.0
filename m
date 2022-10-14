Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0138E5FF3D4
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiJNSwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJNSwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 14:52:03 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B692E070C;
        Fri, 14 Oct 2022 11:52:02 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id s17so1884271qkj.12;
        Fri, 14 Oct 2022 11:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PRbi6bybb59k8/mPXenhyQUDXO1pk1pSFKbVkK14AyQ=;
        b=h+kvh67BNEDRAC3gv+5FFpCROHRrkaE2Zk3eG55MkaHyBfWCYs0Awpq1bLMoVDkryR
         OdnxQVCy5tmY3vWPWgF1pK7HLKc6vXZOdRCnLaseDoXMWwFko46re6hXheKsRuCCJkJh
         rJJCo6aklVknbORUTBTBH28gyTbDuVprzL7K1rre/juEwpFkZHmyRaBr5X5QiIS9jjI1
         RorTZbVCF4567I3Yo6rbli6OP21oio1+C6ENEVkRH+AE/mMwjS+K7G+bI1MiFeNysQGd
         Tf1m5ghebL9eIgzXtd+TWCC1gfEamwUAuNUMo3/RoehzZbYlpQR4G0RrZC6jIMhwk3bW
         akJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PRbi6bybb59k8/mPXenhyQUDXO1pk1pSFKbVkK14AyQ=;
        b=f3xIkHfQCcz4NceURWgmimOgNtUxt6UmS8zyVp5H+CNtIT5z2iwYQLL9tkItTU/xL4
         8j+vD+uKu1rT6VaslmP8GFV7DMjAyBTYe/dcN8es6p2gn6NZsOZyKMa5xpV6fscSU9Es
         whxaTEq0MO6WNr5kIbWezmI6SUckvF8jxB2d0f8I+TTaRKtYWUlUetcgtoALkKC9wfLB
         HjW1m/YKZejhd1C24DW1j8wBKqyAoqHjVpR+LyQtQm4YBIlPS44154QlwABm3rYrOFGm
         FgZmO9RFKrQS0/XgB4dlZuXGcoK1Y9I8uE0sSZtmwvsKN1iMZ0HAXriOQaM3v4+u6cPm
         ttdQ==
X-Gm-Message-State: ACrzQf0SC/sQbKAF06fhCTX+NcaNXqI2IiMtJjU+QMblV9qlmxxvRUIX
        rZjyOimXqnBZ9MBkPEO1ZsgmqI4XgwU=
X-Google-Smtp-Source: AMsMyM4X5bAnAzSUB0gAFCWNWrAKLw0SbN13xQ/TTuhlD3itCA0kS5h1WVb7IGqpmVHGjjhOtDHcqA==
X-Received: by 2002:a37:bc01:0:b0:6ed:b53b:21c1 with SMTP id m1-20020a37bc01000000b006edb53b21c1mr4692002qkf.576.1665773521160;
        Fri, 14 Oct 2022 11:52:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g3-20020a05620a40c300b006eed14045f4sm1383608qko.48.2022.10.14.11.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 11:52:00 -0700 (PDT)
Message-ID: <144f3b1f-1fb2-119f-2511-bb648e34cecc@gmail.com>
Date:   Fri, 14 Oct 2022 11:51:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221014082515.704103805@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/14/22 01:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.74-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
