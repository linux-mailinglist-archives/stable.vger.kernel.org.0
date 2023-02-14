Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AA6695975
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 07:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjBNGvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 01:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbjBNGvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 01:51:08 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0C69ECD;
        Mon, 13 Feb 2023 22:51:07 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id c29-20020a4ad21d000000b00517a55a78d4so1430962oos.12;
        Mon, 13 Feb 2023 22:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=yvq9znrsaeT0s6kLPSd/jHF4Qd9ENE08EIFLbXY0LXk=;
        b=q0LuA5Y9nEDyM3ZoLAmcnc7hVijUd25jjosSs5PlJWHVK6yaxfLxEpSBXGJ/OPdrs6
         EvfwID2A5cdqDUOoA2qfkAqYTj2crcY8x6mFi03YJW5jT0delO+tUrTRZNLhgMn9YZtk
         axH7+pOU6i2rydTav6Wagg6XoY4zrZ3M034ydptUdh6hSy4jGYTP7vMrEjbMNGk1+U7y
         IbWy5qHrHXKe14zZN6mjXhF07wkhA6Ank1Wfl2tDSMjPYqf5DLOXOORMiebqS1s1+pk2
         XUlQnWVIOgdMqu8meDGb0W95ILDU5Ly0PpHoq7WJ0idbRLVV+xzExYQZTDigwdS7p79L
         ex1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvq9znrsaeT0s6kLPSd/jHF4Qd9ENE08EIFLbXY0LXk=;
        b=AmlXeQA2uYPbC8zGVUZUhX+EsN+BtLaSJQH9x8J/5QsmAAHWE7Pu4xg0Z7xxBpVH43
         6my9aCVecWc5DrD+V4d7C5iCp/+yLdQnI6xutF/g1AVVnhNoxgNK4GGN9XlxO77GntmG
         u0xSUa/h/b0u6fjca15c3uvLlk/VngQVwkWSGDzaqgH5JLlazbBE10aVsrVGj2LhS/zn
         7IjlMdthIAA8nStKQhLKiHu7jVeHLKAd8YRAKnDpdFLa9r+DR/ngpvCWoOA994z8bEza
         3rvCX2x4sjRloeysZMQmWUa2q2ZcRUIA+PTqIiioln2RgxhwtqKgoGiF0XoULRWhI89K
         lb/w==
X-Gm-Message-State: AO0yUKUpnHGNnlOg4+BjTf/wathlkRBQVOow9xsgARR11wJTIY8k8IqK
        8caLIKl/Fk/lB2WYiL3yzCBPz70MW8E=
X-Google-Smtp-Source: AK7set8ijbZaBZDPDYwn2kwd/smm4clfzk1Wq2sRMvzi0qoWqKKXci2PLJnZketilEqvVD277ahJIg==
X-Received: by 2002:a4a:c407:0:b0:51a:7af8:457b with SMTP id y7-20020a4ac407000000b0051a7af8457bmr616119oop.1.1676357466424;
        Mon, 13 Feb 2023 22:51:06 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b19-20020a4ae213000000b0051a2a5c8ac6sm5608166oot.36.2023.02.13.22.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 22:51:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8e573eb4-d6bd-ec44-153e-3ee143b3d6b2@roeck-us.net>
Date:   Mon, 13 Feb 2023 22:51:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
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

On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 

Building powerpc:ppc32_allmodconfig ... failed
--------------
Error log:
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
make[3]: *** [scripts/Makefile.build:286: arch/powerpc/net/bpf_jit_comp.o] Error 1

Guenter

