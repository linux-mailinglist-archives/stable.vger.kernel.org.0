Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9AE696C6A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbjBNSIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbjBNSIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:08:04 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8072722;
        Tue, 14 Feb 2023 10:07:49 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id n25-20020a9d7119000000b0068bd8c1e836so4898091otj.3;
        Tue, 14 Feb 2023 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=h4OOqypcztMGdRZMWdYWIa8wO6PV1EB/xigL2lXgd6c=;
        b=TH83SksMB4qG/bSenItHJFZ5leEGwcp0TZYW/00oaEIdnzmacod2Q7ODIwP1T/PjuL
         84KTWNa7rjbqdg+1cMpCnwwueIqosK0qxjeO7/oeXcyh7gfLCkqpISllCXWPMw4C2hQN
         IhbeF2bdDvjtxi8rVuLOqyBPsr9S1VmF43kfHzE/SCLT1rS9Qk/IzDzSNaDR9ACMHefD
         RJoIf3Hd+suzqERiO4EqR07iIQOlks7cKk3lQcbjMubgSYgyQWwSBhVaDDAZJWH7989a
         VBV+FxjV271ytZLfA5kbhGA/zOGwBacjV8cB6Z/XHuqK7Yh+QnufazgnmscHSxXKbBmw
         D2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h4OOqypcztMGdRZMWdYWIa8wO6PV1EB/xigL2lXgd6c=;
        b=eGhSpdsWwVT+B1uksVCwj3mbwahX1GNryWTnZeSBq9nFW8Tu0604LRnMmHjhJwzJob
         nYe759vDChlOA/tM/ckd/8RzSDg1ss70z0AciIjw1UZscZTJAB6qXvITpuZC1oRyVIlz
         SAteD/EdLEJWR/R1Dj8pgdSPnhqYIzW++FJmYF8u+Zhzez6ubvDlnRsXmlzPFKDAclh7
         uxM7gC5slUn32+Rpe903P8ICFn9UadbttpZLAi2X+vsPjtppd23fID9DGdeM29Y4n5Z4
         yTArQKA0HoyEd6xpKpCZ7kAs2JahGH7QfiI3NXUsSq9Dhngye5tfTXzXDzenyjl9sQ38
         2CGA==
X-Gm-Message-State: AO0yUKUhJeN1utjt+EwPJveoI2dpm7FseiB9vRcNx0MrfO9XTVvH+8B2
        mHEwRJTlfdAnyOG9oPUQKmU=
X-Google-Smtp-Source: AK7set+EvvMCmu2Iz3by706vIrjihoJBYEIp3M/kj7rOLONkNS4XfgbyPMUg/wq8oznsjQECnnKZ4Q==
X-Received: by 2002:a9d:7e8d:0:b0:68d:3d9b:fb10 with SMTP id m13-20020a9d7e8d000000b0068d3d9bfb10mr1470704otp.11.1676398068482;
        Tue, 14 Feb 2023 10:07:48 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id dj6-20020a0568303a8600b0068d542f630fsm6553081otb.76.2023.02.14.10.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 10:07:47 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8c06157f-a482-a7f7-8218-863db3dfe268@roeck-us.net>
Date:   Tue, 14 Feb 2023 10:07:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230214172549.450713187@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/23 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
> 

Still observed for ppc:ppc32_allmodconfig:

In file included from arch/powerpc/net/bpf_jit_comp.c:16:
arch/powerpc/net/bpf_jit32.h:131:8: error: redefinition of 'struct codegen_context'
   131 | struct codegen_context {
       |        ^~~~~~~~~~~~~~~
In file included from arch/powerpc/net/bpf_jit32.h:13,
                  from arch/powerpc/net/bpf_jit_comp.c:16:
arch/powerpc/net/bpf_jit.h:124:8: note: originally defined here
   124 | struct codegen_context {
       |        ^~~~~~~~~~~~~~~
arch/powerpc/net/bpf_jit_comp.c:18:20: error: redefinition of 'bpf_flush_icache'
    18 | static inline void bpf_flush_icache(void *start, void *end)
       |                    ^~~~~~~~~~~~~~~~
In file included from arch/powerpc/net/bpf_jit32.h:13,
                  from arch/powerpc/net/bpf_jit_comp.c:16:
arch/powerpc/net/bpf_jit.h:139:20: note: previous definition of 'bpf_flush_icache' with type 'void(void *, void *)'
   139 | static inline void bpf_flush_icache(void *start, void *end)
       |                    ^~~~~~~~~~~~~~~~

Guenter

