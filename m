Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BE4571420
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 10:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiGLINz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 04:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiGLINs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 04:13:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01306268;
        Tue, 12 Jul 2022 01:13:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so7223552pjf.2;
        Tue, 12 Jul 2022 01:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=pXBe8Hh8WdyiB+tUUK4BylCr0KEPGZ7rap8vshGM0UU=;
        b=N/jP3gV7aehg8+mtP58wCyQqUqQWoSfow+twIE0QX//y/hUyKFY+TLuZh4d0mdes1U
         Ctyzhzu0sSHzBKV/OWt2LzYCbZuDyKTlEoIYVDb5bdbc5h3klYl3y/4LlA/I0DcdmqMM
         iESA0yZXID52/4VA45mFwc+K39GQ6muSnciDN1FtRH7cVPH0ALvzDa/bSA3Ff8NROsWQ
         wCX6VjrSHBsMbbszDDGzRx6zPaTJ6ZQyKYNg4e8jmg6bYqCDRO8EPRDNuP3lXgf6TX4A
         XRee8ephZRq44XK5rdWMuEXByyj9f5MwGkq1LdirH2vIA+KnnRrB7vO4hoDuC/okAQny
         0PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=pXBe8Hh8WdyiB+tUUK4BylCr0KEPGZ7rap8vshGM0UU=;
        b=JwqwTzq4ndPbqJlDhKQ50XnzbBSzAuT9g/7zKz9rnLPyzr9q+g04kZ5GX33HBfpgZG
         YF6+NihpEZuFsKcGKYGC0IF6rvOR6EFzRR3+vT6K8wFV0rJV92I7W1CoIDlraLUzV2OU
         3ryoc5KKH+z/zlRjoBtFDcoHdBI5ladBowBM0IHMvdqNFy2xC6P7LmV4hselHTHyPkPp
         FpwL2c5ss6IWlcPBf30+GnZK3Oj+Hw+Jfhksf6qylWOCrOD4sK44s15jF5p8edV6g4Bk
         CW7MPssq40xQTbq1ah/Jkk8iX/QZKeAORP2hf3CxXolWT1dnVugI9xOXqhlzZeFwU+mf
         jGCA==
X-Gm-Message-State: AJIora/vvZc7P0TnrnEbXRLJBMFLYoOER67DgbLA9nBq+BhOn1quY5d+
        jBtAppvd9Ry7PLY8h1CQETQ=
X-Google-Smtp-Source: AGRyM1tSess7jQH7z9UcAhKqJ8V9cZsFH2bYicUhT8Bvg7J7ZQqyVLxZFQdxc+ZUc06f0/A3fiEIJQ==
X-Received: by 2002:a17:903:245:b0:16b:9c49:6b1c with SMTP id j5-20020a170903024500b0016b9c496b1cmr21979432plh.153.1657613626209;
        Tue, 12 Jul 2022 01:13:46 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-76.three.co.id. [180.214.232.76])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902f35100b0016bf803341asm6079664ple.146.2022.07.12.01.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 01:13:45 -0700 (PDT)
Message-ID: <192fc80b-95f6-5bf4-263d-a6c1a9569dab@gmail.com>
Date:   Tue, 12 Jul 2022 15:13:40 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 000/230] 5.15.54-rc1 review
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220711090604.055883544@linuxfoundation.org>
 <Yszp7pzYU4v21j1K@debian.me>
In-Reply-To: <Yszp7pzYU4v21j1K@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/22 10:26, Bagas Sanjaya wrote:
> On Mon, Jul 11, 2022 at 11:04:16AM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.54 release.
>> There are 230 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
> 
> Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0).
> 
> On powerpc build (ps3_defconfig, GCC 12.1.0), I found errors on gettimeofday
> vdso:
> 
>   VDSOSYM include/generated/vdso32-offsets.h
>   LDS     arch/powerpc/kernel/vdso64/vdso64.lds
>   AS      arch/powerpc/kernel/vdso64/sigtramp.o
>   AS      arch/powerpc/kernel/vdso64/gettimeofday.o
>   AS      arch/powerpc/kernel/vdso64/datapage.o
> arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
> arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized opcode: `cvdso_call_time'
> make[1]: *** [scripts/Makefile.build:390: arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1
> 
> Thanks.
> 
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 

Oops, wrong -rc replied. I tested for -rc2 instead.

I will test -rc3 soon.

-- 
An old man doll... just what I always wanted! - Clara
