Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A189357ECD0
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 10:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiGWIxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 04:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiGWIxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 04:53:23 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9993F32B;
        Sat, 23 Jul 2022 01:53:21 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id id17so4000170wmb.1;
        Sat, 23 Jul 2022 01:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DMRcCy5cqY9wAM7Cv48akASTjSBA/1pr8hYEGaJXPKA=;
        b=I0lHpEuHJ8cixdrL1iDnSX/ccMQ/KwBNcPOgqBo8JIHrsNTm8iI63aw/2m1FphDZ6k
         xh171HZWGPyTPznb8kY1ZHzvva51rgOUniABttry68dKzfzV9Jk4PwvrypTp5Ww1+P1B
         0a9et0ElpOsSSYhqb7lywuORw6N9E6WKvGJSIb82VTaxbPFB/+yu8izk52m3IQz82Ckh
         zcBEjUNrLuEWhOczsu4qmilOak9btaMbEG0F4h9bnqfNi99chEvUsxr8vMH1YbsXMMtV
         ryUZk4p4JVErE3FUR0TcosZt2uu+AdW9Hi8fKMGYbMCus4eeauNkCbEhvJcDl67SupA1
         07mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DMRcCy5cqY9wAM7Cv48akASTjSBA/1pr8hYEGaJXPKA=;
        b=33WFXu6UlvuM1FyqlmsmVtrGVLKeme3MY0qVFkJenHhyyGVUvgfror9zn0SY7R722A
         VLPE8RATvG0z28C53QK78TFJtyMVQY5ZBJvllnvNLDNqNNjhbQM7dL3ty4Ymm/7RWDob
         BOZgU1JpHH3rqU5rncLPvZgwglQbrCchnS1/mDHmSmh/35b9gFE9X9l89JEVYuurOKGC
         NcEh084XFUGzqlZt+41TQPHWvmcE2s82W6SmvzkKMhBSpSwK38WIMKRrtPjd9wKeFqJT
         gzOaCQ4qtyunFgQzBHXrLDn7wpgIKwnETxi3N0L6/uLmLXidj7hXVD8wtZ7+157c6TvW
         /lEA==
X-Gm-Message-State: AJIora+TMaQhZ9Oum34+lshc2NqdfRTRAVY6WZaNrb8rlmMKXtLWf0ot
        kdkK06suKIjXgpJBBMbKCLw=
X-Google-Smtp-Source: AGRyM1up1JrufDiBihteBMRZrO1z3laFYGRfCzwybrGLzLVWDZ9QI00df3SwiZA1KMxdAQOeA2keKA==
X-Received: by 2002:a7b:c7d2:0:b0:3a3:209d:cdc6 with SMTP id z18-20020a7bc7d2000000b003a3209dcdc6mr15386029wmk.55.1658566400287;
        Sat, 23 Jul 2022 01:53:20 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id r5-20020a1c2b05000000b003a03be171b1sm7514753wmr.43.2022.07.23.01.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 01:53:19 -0700 (PDT)
Date:   Sat, 23 Jul 2022 09:53:17 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/70] 5.18.14-rc1 review
Message-ID: <Ytu2/b7zK0UwCpdu@debian>
References: <20220722090650.665513668@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Jul 22, 2022 at 11:06:55AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.14 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:06:00 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220706):
mips: 59 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1546
[2]. https://openqa.qa.codethink.co.uk/tests/1549
[3]. https://openqa.qa.codethink.co.uk/tests/1552

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
