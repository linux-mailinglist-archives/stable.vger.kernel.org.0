Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66D95F5A6B
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 21:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJETMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 15:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJETMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 15:12:50 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111D3659E3
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 12:12:49 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q10so18669854oib.5
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 12:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8yzJCOiuBQr6qPJK27nOxrQWc7RyIwKbFwaCPfSVX1g=;
        b=KpX99vHMNvv+2y97mPfDoAfU6EDzBYvnAxBjoIplto7XF/OlfLNztSeLbLNdzVhJHF
         bQy5kJMahbn6VT/HBPGu1SrtLdIwEsb7p8QajNAIXHCa0ELZ8fRL/CCLcgtRy5UdGTsp
         0sOLUCoeuExSKRSRvvDwJzauueWvwv7wQKickcLqYIVZhw/WDSUllMwi500muCZKT2ue
         kUwiPPJq1TKP22edBomrWYwbrJZdjRLLlV//+Bd6fxg1QGVT6QMMTqVsu5EVZYbkn8AA
         ek5nh3zgs6WH0psI/4xKoQSRHmvcyd8mEUKy2PjXHpvTOzPokOHHtyJ3gJ9jbrKPLTCw
         RREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8yzJCOiuBQr6qPJK27nOxrQWc7RyIwKbFwaCPfSVX1g=;
        b=xpKQ50yeJI7T+JpeGoWycfHsZDFpdjcOcmqaqrhxrlpHvTZxR8c8VharP5MDXii9Ig
         2+wZ0gcptWG9teGX08ADp/MND+Oe+b47hpGW+M6i/Zo8y1uKditjq/nD0RNE6Z0v4BFP
         52eT+35N0r01BJ4T9fX7G2866KlI/jNbLvojyKjAMLaLKx0cOHBqohW3oRUMQdY9L2Mm
         5qP1/VXzEjR2UsNNytBVz0MhDh60Ee5tyO451zGowFPKr8l4RuzcWwydSoOXEssT5QpM
         keh9ad+kcEuqLbYernGVHK1nGdDzkoZ0n2OoplN14gJrVzMpNfu5E+r62NGp9EY8Acku
         G0Iw==
X-Gm-Message-State: ACrzQf1e+KxgaphPFcP1G0SwHxcapZq7rA6L8OI+CD8CSNphg03NdXNe
        u227F12ED3iur93oWQy6jCGbvg==
X-Google-Smtp-Source: AMsMyM69oILYQ9vKjMyluRyh34qaFXApodSp7NFNsmH4j7tmbXRsL89YxOnzwMTgeF5OP7v7qKfMDg==
X-Received: by 2002:a05:6808:1189:b0:353:f1e2:9afa with SMTP id j9-20020a056808118900b00353f1e29afamr3104121oil.287.1664997168357;
        Wed, 05 Oct 2022 12:12:48 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id c36-20020a05687047a400b0011dca1bd2cdsm5698609oaq.0.2022.10.05.12.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 12:12:47 -0700 (PDT)
Message-ID: <68134b95-ea83-cb02-0ded-fd147b117820@linaro.org>
Date:   Wed, 5 Oct 2022 14:12:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 5.4 00/51] 5.4.217-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221005113210.255710920@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 05/10/22 06:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.217 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We are seeing a new warning on x86_64:

   /builds/linux/arch/x86/entry/entry_64.S: Assembler messages:
   /builds/linux/arch/x86/entry/entry_64.S:1756: Warning: no instruction mnemonic suffix given and no register operands; using default for `sysret'
   arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x151: unsupported intra-function call
   x86_64-linux-gnu-ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only section `.head.text'
   x86_64-linux-gnu-ld: warning: creating DT_TEXTREL in a PIE

This started happening after 984b78c4ecea49b0b4b5729a502b689a623fde27 ("x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n").

The following configurations are affected:

* x86_64, build
   - gcc-8-allnoconfig-warnings
   - gcc-8-tinyconfig-warnings
   - gcc-8-x86_64_defconfig-warnings
   - gcc-9-allnoconfig-warnings
   - gcc-9-tinyconfig-warnings
   - gcc-9-x86_64_defconfig-warnings
   - gcc-10-allnoconfig-warnings
   - gcc-10-defconfig-warnings
   - gcc-10-tinyconfig-warnings
   - gcc-11-allnoconfig-warnings
   - gcc-11-defconfig-warnings
   - gcc-11-lkftconfig-debug-kmemleak-warnings
   - gcc-11-lkftconfig-debug-warnings
   - gcc-11-lkftconfig-kasan-warnings
   - gcc-11-lkftconfig-kselftest-kernel-warnings
   - gcc-11-lkftconfig-kselftest-warnings
   - gcc-11-lkftconfig-kunit-warnings
   - gcc-11-lkftconfig-libgpiod-warnings
   - gcc-11-lkftconfig-perf-warnings
   - gcc-11-lkftconfig-rcutorture-warnings
   - gcc-11-lkftconfig-warnings
   - gcc-11-tinyconfig-warnings
   - gcc-12-allnoconfig-warnings
   - gcc-12-defconfig-warnings
   - gcc-12-tinyconfig-warnings
   - clang-11-allnoconfig-warnings
   - clang-11-tinyconfig-warnings
   - clang-11-x86_64_defconfig-warnings
   - clang-12-allnoconfig-warnings
   - clang-12-lkftconfig-warnings
   - clang-12-tinyconfig-warnings
   - clang-12-x86_64_defconfig-warnings
   - clang-13-allnoconfig-warnings
   - clang-13-lkftconfig-warnings
   - clang-13-tinyconfig-warnings
   - clang-13-x86_64_defconfig-warnings
   - clang-14-allnoconfig-warnings
   - clang-14-lkftconfig-kcsan-warnings
   - clang-14-lkftconfig-warnings
   - clang-14-tinyconfig-warnings
   - clang-14-x86_64_defconfig-warnings
   - clang-nightly-lkftconfig-warnings
   - clang-nightly-tinyconfig-warnings
   - clang-nightly-x86_64_defconfig-warnings


Greetings!

Daniel Díaz
daniel.diaz@linaro.org
