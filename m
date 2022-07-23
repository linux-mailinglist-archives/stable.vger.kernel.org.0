Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B2757ECD3
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 10:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbiGWI4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 04:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiGWI4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 04:56:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B31B15A01;
        Sat, 23 Jul 2022 01:56:00 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u14-20020a05600c00ce00b003a323062569so3631014wmm.4;
        Sat, 23 Jul 2022 01:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yOVVtSpj6jszOGo1/l+28fNnDHkQnXU+Fv9O/UtaZkw=;
        b=bDKft6jLzxXgad2x6+gT15WrV41O6H+Eunm++6WAHvPFR1ZUa8vV9Bm/dik/XIK1ve
         Tvh8L/XZTcJhxoSLYLZD+/yH5VmN1uNU5sre/jlqIVKeUp2mJYe6dqvX2K1F7QMyIexU
         oqRDfbppMn626axb/TocpWlcE93KzDSjbOIb+zlqkKBo3CY5SxWndxZNZoB/+xTy4Lh6
         KZVRT7wO+EjsO1jAb6qaBeWuQ9AuqsJPeHBe6Y94BW7/TdgW7K90zj0jCQQ7PW56SfLG
         nq6of2kqO7dHegHiWhGhLqlE7Zye/bIb0Iy+V0UlL0KcJJPCLC+lufPZ2ysOLAh2A4XI
         wjIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yOVVtSpj6jszOGo1/l+28fNnDHkQnXU+Fv9O/UtaZkw=;
        b=zqjxtC+N2vPMOLYLL8SgABQEMgwMggmw0v6DvxNegaate1eGBpOKchMxlKFJWhHB4q
         hDrPyu+9xo+j7xdwWp70uTXRgkvixhjmFGsTjqNg2I+ge7CLlm+VCzhqJrQeTQ7n3fRE
         0fKe0DXoZ4Di+hYinFiyrL/PoOnBeTXnLSt9R+FShLvl4StJzYbmsdFvxtnBNOUk+Wr5
         ORKKS/vve1GlG7CywcriZ5RqpUT0Rzb5RfQS5Zl5iLzLQQPE+Q8IdtxxhnBasfV7dTCL
         FxwVjDrMaCMfsJJyK0LLy3+55RQa7t/w4YxeE4KSklAfG6HYXhvBXtMu7rxlNqJjcf1h
         H0fQ==
X-Gm-Message-State: AJIora/dhRWvCIsjUKhZQpEa5cIO1MoYBAXi56YIQsm8SY43u4J2Zgfj
        2CCzS5opPnRnFdShlWARGLQ=
X-Google-Smtp-Source: AGRyM1td4S+f3tNI9nzcVKCVWvywb8/F/SNGOoElpD4DkUxvdA5bwNLp3WTKefXZ9sHfreQ6Mgy3UA==
X-Received: by 2002:a7b:c8da:0:b0:3a2:ffd2:8059 with SMTP id f26-20020a7bc8da000000b003a2ffd28059mr2314250wml.169.1658566558669;
        Sat, 23 Jul 2022 01:55:58 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id f18-20020a7bc8d2000000b003a327b98c0asm7231456wml.22.2022.07.23.01.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 01:55:58 -0700 (PDT)
Date:   Sat, 23 Jul 2022 09:55:56 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/89] 5.15.57-rc1 review
Message-ID: <Ytu3nMsv5AiRhYH9@debian>
References: <20220722091133.320803732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
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

On Fri, Jul 22, 2022 at 11:10:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.57 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jul 2022 09:10:51 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 62 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1545
[2]. https://openqa.qa.codethink.co.uk/tests/1548
[3]. https://openqa.qa.codethink.co.uk/tests/1551

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
