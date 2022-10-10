Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527375FA2EA
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 19:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiJJRts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 13:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJJRtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 13:49:36 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF77644D;
        Mon, 10 Oct 2022 10:49:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l4so11016021plb.8;
        Mon, 10 Oct 2022 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WVa4kiMsJL7oEORpbzWjtM3OlO9r8o5QjkRtb8k39Z8=;
        b=ORFQV/44fTAqju9rNTuADHE9sbZ0iGjW4vQNJobL6oEB+ITyWcBMdQgKaFDmsjB72K
         yUXknIY+sl6c3/CsQTaFn++5ymhRrpvEYpwUEcG3eGgsHl7qswXBCGymlOM0fg3h1XnY
         /quZrq5tB+btZC0NgoJllza6y1e/UDSEh9r9ACctuP7q+A09rxxzNqWclS7vfvqQMWGm
         QF9OweHa4TZfi5S9+D0vP6ItL4CWqcr09iJt7XuCBc2OiZomu6A52TgMgQlhocJSN/ZU
         9yWckOeb3g7mMAwwzpCJIjnyVdcwm9UJSLa/9xe3gQ8Wjt5JPjMRRsurDmE5pw8TcxJf
         Ln4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVa4kiMsJL7oEORpbzWjtM3OlO9r8o5QjkRtb8k39Z8=;
        b=oQJgmBmbkRiHFlHAfZX6NI+7iiS6idf987iO8M8CrIdc9JPwDq+F8IWh2rAll95kDx
         nxUGJXLapIgygD2kXCwE6roZgQSp0IbDFPD4yIwlFUpUgWiByith4G2hQMg4uuNIwsc/
         +OeU/NngdZt4oKSplXhSykryA5JOCBGFqZZBs5zhaJCZZaq9vpeQnPTbdg0wBqVKh/6L
         VQZW6YT6dKWBE9yxiOHtyHIspHW3o6lfv56gjj6XmH32i3xHUAOMNBfyTfV4G+cpGq5I
         nYcICTMK4ClYtT5tm+O0AHBvStZRQQJWPiuy8sFvKw0ViD9FigoFrVvwddP5eqtVCtIT
         lmVA==
X-Gm-Message-State: ACrzQf3RjwJrQPCJwSHwS/T5I0yM86ogM3UPe3LWU97iGBxhdtD2K9Mt
        7ROIg8wLdt/uwvY9EdhmtdpF02cg8w+PfA==
X-Google-Smtp-Source: AMsMyM4Iouh6yM3lmxysFwKctzJoyuPGvKXfdNnFCYUz5OK/Ftej5/NVqIf+yj0rTjc5N7bSJjrXUA==
X-Received: by 2002:a17:90b:3a8a:b0:20a:7e68:91a with SMTP id om10-20020a17090b3a8a00b0020a7e68091amr22355044pjb.206.1665424155616;
        Mon, 10 Oct 2022 10:49:15 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902f68600b0017f92246e4dsm6974792plg.181.2022.10.10.10.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 10:49:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net>
Date:   Mon, 10 Oct 2022 10:49:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010070331.211113813@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 00/37] 5.15.73-rc1 review
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 00:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 

Building h8300:allnoconfig ... failed
--------------
Error log:
In file included from include/linux/fs.h:6,
                  from include/linux/huge_mm.h:8,
                  from include/linux/mm.h:727,
                  from include/linux/pid_namespace.h:7,
                  from include/linux/ptrace.h:10,
                  from arch/h8300/kernel/asm-offsets.c:15:
include/linux/wait_bit.h: In function 'wait_on_bit':
include/linux/wait_bit.h:74:14: error: implicit declaration of function 'test_bit_acquire'; did you mean 'test_bit_le'? [-Werror=implicit-function-declaration]
    74 |         if (!test_bit_acquire(bit, word))
       |              ^~~~~~~~~~~~~~~~
       |              test_bit_le

This affects h8300 builds in all branches all the way back to v4.9.y.
It also affects release candidates for various other architectures
in v4.9.y..v5.10.y. In v4.9.y.queue, for example, I see 56 build
failures out of 164 builds; most if not all of those can be attributed
to problems with test_bit_acquire() - either due to a missing or due
to a bad backport.

I can only hope that fix for the the problem that required the
test_bit_acquire() backport is worth the trouble it causes.

Guenter
