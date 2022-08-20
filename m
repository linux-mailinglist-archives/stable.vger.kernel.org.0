Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745C759AD46
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345255AbiHTKmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345238AbiHTKmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:42:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F22A721D;
        Sat, 20 Aug 2022 03:42:05 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id d16so2470864wrr.3;
        Sat, 20 Aug 2022 03:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=wpUCvamh+ye0l2iuSNES+TALSlLBsIRaMdVzc71uTOU=;
        b=A3okTWC/Z/nQKnmI97eQ4g7Tn6OQTP8bZ4/mWy36NNE8TLIoKp7H/UOrIFRiGxHRr0
         z3lw/5309GJfkUSvbRa928iUVdMhLKAI6OJu+kKIc33bFnvrOhewr7dLyZmE8OMa1Bcy
         3JVoB3xsQOlvUixL3lNqZrjlxhvitC2WtoJDdwxxaEnwztRmBgrsZtivH+HBDOFOb5rZ
         CpMdVZoznJ74FkoF8l2rapPd/uMPFlx1HYZeE16b5Ws6fIW5I5APwP5zyWVezAHcZhRR
         2rNxAZjrv0dua/1GFZ/YHf3GHhiPp8D9HmA2YEiF/p1OW1Lb5yEnZ0Zj/YOjlm44rAwf
         o/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wpUCvamh+ye0l2iuSNES+TALSlLBsIRaMdVzc71uTOU=;
        b=fIreBqFewn1tNwELcHpRUJVpzTVV9BjC37qreFxYXng/FVWn9U+zSpuT4hTQD1d9du
         pLu1VIWriFk2E9ZuhxlR4FFKcWxMwQyzkeG4zMMKkuCRJK8kqhTAgeg/67c3vizHeJQi
         xtu53M88aLprI7S64x0DI3Jl6FIVATqnWbiUix8cecXQvbRHCO4PGVyb9ZdrzeaYjbA4
         1BJC/EjMFiQa3Aptm0zmJPQ8spQMaUM5joIo0usqmeClfb0sPB/WKOx0qmSTPuH3sCfZ
         dPHb0LLdOFQ6SqVG1lAvQ8B1R9IQiwcid5IDnD8aQNVIVGM0t53iUZLlHa88/59kEZVg
         bpzA==
X-Gm-Message-State: ACgBeo3lDhFXWUEA/EWrNJvtfOdmpd+v5jHS9OyLmOchzMXafGprfurG
        uH9o512+RoInS+sBPm5Bzu1jaM6pIzM=
X-Google-Smtp-Source: AA6agR6mKBIJfUDlN4adZIWylsxOcCr0KrYZv2JMh5JBUqp/T2U4T63SyVcW0HlTfHtxGjVZ3XyvDA==
X-Received: by 2002:adf:f001:0:b0:225:3a99:3938 with SMTP id j1-20020adff001000000b002253a993938mr3473277wro.111.1660992124185;
        Sat, 20 Aug 2022 03:42:04 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id c16-20020adfef50000000b002205f0890eesm6386403wrp.77.2022.08.20.03.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:42:03 -0700 (PDT)
Date:   Sat, 20 Aug 2022 11:42:01 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/14] 5.15.62-rc1 review
Message-ID: <YwC6eQjx8xC9y3LD@debian>
References: <20220819153711.658766010@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 19, 2022 at 05:40:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> fails
xtensa allmodconfig -> no failure

Note:

s390 allmodconfig fails with:

arch/s390/kernel/machine_kexec_file.c:336:5: error: redefinition of 'arch_kexec_kernel_image_probe'
  336 | int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/s390/kernel/machine_kexec_file.c:12:
./include/linux/kexec.h:190:1: note: previous definition of 'arch_kexec_kernel_image_probe' with type 'int(struct kimage *, void *, long unsigned int)'
  190 | arch_kexec_kernel_image_probe(struct kimage *image, void *buf, unsigned long buf_len)
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by: 4dc6d49023a0 ("kexec_file: drop weak attribute from functions")


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1659
[2]. https://openqa.qa.codethink.co.uk/tests/1666

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
