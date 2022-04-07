Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE6B4F7BB6
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbiDGJeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243809AbiDGJeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:34:46 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CDA113D29;
        Thu,  7 Apr 2022 02:32:41 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id z8so5070632oix.3;
        Thu, 07 Apr 2022 02:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ki3aFUkfa/hYhXGKcxrSTgut7tX0oEYaBor2VxuoPfQ=;
        b=bxp6Gri8o+/lC4w71i2SH86SerM7v5q9sJ44t/ctydWnb3aZcF/PUjPrneW6hbfg5f
         CeDXFVs0YymkSP0C42Yj5S5Hs0/OpDrFMjty1i/DJ02SjQLO35ESODXZs7de0cYMolZ0
         3vu97B1sO4XZ67rORVN7eL0wNx7v4WN55QFQMasu/ujHfY9ok/av3Ynm6BLdhVR1+mDK
         tIUCr7q0n0CR0fgY3+9BzOZRyUvkCgC81+W9RXdk5tG0kUpApC17gCG7Wg8mrRE9YeQj
         LDa5FjvgbflnVRtUnGxuxvfVNiGevMSHDcKGh/BJxMUzEuvtv+6vbjomMAN0ChwxiK0r
         ssEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Ki3aFUkfa/hYhXGKcxrSTgut7tX0oEYaBor2VxuoPfQ=;
        b=ZP4vuceZqpvHKWwu34dEYCyzUoS/wql8wWKHhtOEJL5B6hO0AahF+aVHFGfFp9H1cY
         okCu4H2Ahlw70HvjZ1dF18xTOqLZJ/msO6MSpwKVceaRfqGvf8/qDtjHW+ZuFfpWl+mc
         9e0Zd850ARfQ00etAdy5Kw2feu7HtzpQ5yX9e6/cIUE9AIAdw2hytIdBEBeDpTq5XAhZ
         /lrDUDNct4vX5u09rsOvmfC/T8/o7ye+woaw4mEAVfPQLz4+vQskKqrFZohTty9XC1Is
         SYtuKEpE3XNflv68652HwYtZGMLxo5l/YR613pApUOnzgpC47y6u0Ho10jAs8u7l8Uvu
         kYXA==
X-Gm-Message-State: AOAM533W79n5RNSoQybsDmSZ+Mm95MuE1xPkKStu3M91R94zhVkAe62F
        1ALhGtksLCeHqzO3YiG651A=
X-Google-Smtp-Source: ABdhPJz3rOPAJ9zdDgpQ5CxxG3fQ0AEe+TLUq9Xu3mJv9MqWsjo29/yfJn31XR1whemmprWjOQ1lWw==
X-Received: by 2002:a05:6808:2023:b0:2da:5b6a:a526 with SMTP id q35-20020a056808202300b002da5b6aa526mr5511859oiw.264.1649323960499;
        Thu, 07 Apr 2022 02:32:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i21-20020a056830011500b005cdc3cdacb5sm7859527otp.57.2022.04.07.02.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 02:32:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 02:32:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/43] 4.9.310-rc1 review
Message-ID: <20220407093238.GA3041848@roeck-us.net>
References: <20220406182436.675069715@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 08:26:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.310 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 18:24:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 161 fail: 2
Failed builds:
	arm64:allnoconfig
	arm64:tinyconfig
Qemu test results:
	total: 397 pass: 397 fail: 0

arch/arm64/kernel/cpu_errata.c: In function 'is_spectrev2_safe':
arch/arm64/kernel/cpu_errata.c:829:39: error: 'arm64_bp_harden_smccc_cpus' undeclared 

arch/arm64/kernel/cpu_errata.c: In function 'spectre_bhb_enable_mitigation':
arch/arm64/kernel/cpu_errata.c:839:39: error: '__hardenbp_enab' undeclared

arch/arm64/kernel/cpu_errata.c:879:42: error: 'bp_hardening_data' undeclared

Guenter
