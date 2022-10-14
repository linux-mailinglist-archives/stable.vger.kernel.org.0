Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC45FEDE3
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 14:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiJNMPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 08:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJNMPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 08:15:08 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181FF4AD6E;
        Fri, 14 Oct 2022 05:15:07 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id f11so7254526wrm.6;
        Fri, 14 Oct 2022 05:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SMvaGsw3aJfVXTn2+0JJBsQsLQ3oGxiGRqYprDO+ECU=;
        b=LofS5n5C1coAeYTHoG4vAOM9mLxnIvZkWn+eUmgb1QzV9uuKWVcpFMDESH8a/y5rBJ
         BZzI8IDS2o06QoMsVVDPp3q8kZHmkjZS8XIh8BjhA7xUUYPFpQF2h4KNWm/mbAjQmk/a
         LnGrDdGgeiS5cLIOkpztxlpV/MwpB+QCBFsszuQqjUKIDW5v4TSmfjaISu8objlc92iY
         nOwqH673R0mqPq8p9FT1XIeN4eONDMFKmyjngtCjr6HKrFOHl7OU8XPMUAjdvSuuR0Mk
         kJEPKQjkPVMAeZJzqeHTv+Hk69nbufem78QGkeJVXBzHESp/zBe0EeWWQOTY473Al2OV
         8adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMvaGsw3aJfVXTn2+0JJBsQsLQ3oGxiGRqYprDO+ECU=;
        b=QVQetX6jaJOG1/lENEDq5RU4kyDm4J9I5o8Pz1kKv/wWd6NW6Q9NCo5YJL9wXbJCQx
         /xywmxau/8qQCkXkXyEJG/lM3XUElkEANerwFMf9ZxXK7lwAqctMNytdRTPQzAploGFC
         9ddSVFBXvkI4OisL/y5+vReEue5H28z619mIWK1DtOD0yYd4nfLIXuFZRcGW6Mp3Gwcc
         fLPP44tP678Lfo2wMQlsxxS+S79mztD47lm7wmDOtSaD4selysKSuf65A89+nwpmdXN0
         GARrPwci4d8uYexPyXeR1VzHxXcQ9DR7t5jYWhwO0jxVunLyCTORj2gf1kqSowdcvxcd
         J7SQ==
X-Gm-Message-State: ACrzQf37bMot8i9wl5BnCoZ8jEwTYbCguy0O6r2Jb2dkZxZSjBUR3TPB
        3g0SqtsOH5vr1jqChSmY4dI=
X-Google-Smtp-Source: AMsMyM4/6LN2iF5+9XTo9sukWG5rfutBYm/rj0G0Gpa1ZZX6cywOpoxMcgeZJz5+h9pqBwrWhY+yXw==
X-Received: by 2002:a05:6000:108a:b0:22e:5610:7987 with SMTP id y10-20020a056000108a00b0022e56107987mr3000355wrw.527.1665749705354;
        Fri, 14 Oct 2022 05:15:05 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id h5-20020adfe985000000b002322bff5b3bsm2235891wrm.54.2022.10.14.05.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 05:15:05 -0700 (PDT)
Date:   Fri, 14 Oct 2022 13:15:03 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Message-ID: <Y0lSx2WqkIvblBcE@debian>
References: <20221013175146.507746257@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
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

On Thu, Oct 13, 2022 at 07:52:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220925):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2001
[2]. https://openqa.qa.codethink.co.uk/tests/1997
[3]. https://openqa.qa.codethink.co.uk/tests/2000

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
