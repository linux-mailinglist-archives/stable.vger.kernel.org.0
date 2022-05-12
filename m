Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B11524532
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 07:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245671AbiELFzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 01:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiELFzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 01:55:09 -0400
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A543612B0;
        Wed, 11 May 2022 22:55:08 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id i27so8009271ejd.9;
        Wed, 11 May 2022 22:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qgyCuAw9lKPrflWuWL0pXVFKUm286YeJTWO3N/9SWMg=;
        b=gj2XUln6V3YvjnQVr9nsSudOa4SknYlEGKFR5yP5D3YWAxmyZY9hsffEK0PjAjhrlD
         2u67hrLvy0Uurz+YM8nxrLM8pLdDAxRQj/rRcpr9F1iukpuaHfwxd5Jaz4Ywvk8Ba/RK
         bahoLxs624M6wfFAGrKngBZNLvMvoxc4XIm4VTnPmGLJD7estBuOOjwF9u+KKe0MdqwU
         ptLM8UeEg7/bCpfErnLpQ2ZL5Bzm7SkiwNS3qgdJs3BPsf6PgKPMbWd/5+FRC3AhkIVG
         FI3XYeA8UpAQSbcqzZf+PVZmiEGnvEoj+dFeVax8XYyaQdKtxjE+YZTM+FH4qgNcWzGK
         HM7Q==
X-Gm-Message-State: AOAM533253XGmyFp4w5LiptMdCLMzv3JLG2FpI98lA/Mh3zGNtQwkB//
        1/hiwDVEXnyjJzQ1jSts7iE=
X-Google-Smtp-Source: ABdhPJwo3cwjeGHQ5xRGdA3EB/ZRgGK4/CGZrFamiC+y+cVjfMzrcPiZs/z7H9hN90W4H7KJOe0NkA==
X-Received: by 2002:a17:906:29c2:b0:6f3:da29:8304 with SMTP id y2-20020a17090629c200b006f3da298304mr29191280eje.569.1652334906641;
        Wed, 11 May 2022 22:55:06 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id rk6-20020a170907214600b006f3ef214dd9sm1711643ejb.63.2022.05.11.22.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 22:55:06 -0700 (PDT)
Message-ID: <6d7750e9-bfb9-9b2f-4152-8e0d693ba22e@kernel.org>
Date:   Thu, 12 May 2022 07:55:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 5.17 000/140] 5.17.7-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220510130741.600270947@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10. 05. 22, 15:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.7 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 May 2022 13:07:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.

openSUSE configs¹⁾ all green.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs
