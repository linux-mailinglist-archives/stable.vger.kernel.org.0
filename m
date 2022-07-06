Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86225684F8
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiGFKNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiGFKNF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:13:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FADAA467;
        Wed,  6 Jul 2022 03:13:04 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n185so8536128wmn.4;
        Wed, 06 Jul 2022 03:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SCfNRbut6kB1IOvc9/o9t70YyceD/IZE41mLfc8eKME=;
        b=iV/dWKhF98ZUcWq1xWjJYsUvfRObplPB+qwT7kTgvcm0FyAnuetiRz8hzYpTiw3PYl
         vKTpyhV/8K5Z4ntbVDvuqAWCt6hODSZ6RXDDd8uMdaE1ovS4p7e1/AGxVzMPLEqJWPUI
         SaUfKl9dMhjqRMuLPqPajmdpTMhJbqpK1e5H5clP3OSx2QIWU6vlDcSqmFGFxkvMp7g/
         xdNAsvw6CCXffXvzMFqutq87M+pugcoLEpbpLS6iZ/3KCSgRyekxyVrkdDqh4FvVbcV4
         8vxXqpko6k+OfgfjTY+A3lR43s0cSJh/lFN8zswz5Um5N5MYudXsilIEWG4eUXZ0xuO9
         3UUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SCfNRbut6kB1IOvc9/o9t70YyceD/IZE41mLfc8eKME=;
        b=kmsaIdVziMGAjGCbgsE2vCPo+bhiT+47VFdQ0Hyp3q68CFAk8k29w/cfR4+Ems4aCy
         wCz8XjBsqeJCqr8tBX/irYap9XltxexrcdvKI7JdQDIEiaD5CyCJ/pgb+HDOzsKcxxht
         rG/NwxflaPpZbvYEPtp23LO36pbKbWqabspk5EtQ1Y6vrtRMOo0h0pfGUxDQwbwVbtC4
         YdrwRqrFiFf7+pDqeBqj6nIRE88wGy3TFWrKSJHEPCJZ7FRA/cVxNJtCCehkTmhMQmNE
         esKxP/yHsEdwo8ljO1dfpmXEpQe4spRnQBYNnzAlKo84cB+7/vRKOapD2A6sACF16UK9
         33kQ==
X-Gm-Message-State: AJIora8ZDaQF6Fu+/EU8/B2z7tcHl7/Jwc2VAGXCMvL1fN3N63wHxCzi
        YfeqXPiwFe4bLy8lsG+s5iQ=
X-Google-Smtp-Source: AGRyM1vd0Uh/6rDKhfjcNvDrvIKzpft57FnSkSMlDqVVgmFYHU1fV+scfMJWBbXwAMq5Pb4JppAXVw==
X-Received: by 2002:a7b:ce04:0:b0:3a1:92e0:d889 with SMTP id m4-20020a7bce04000000b003a192e0d889mr24322788wmc.131.1657102382554;
        Wed, 06 Jul 2022 03:13:02 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id bg39-20020a05600c3ca700b003a18de85a64sm17607017wmb.24.2022.07.06.03.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:13:02 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:13:00 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
Message-ID: <YsVgLDuR8foNKT3v@debian>
References: <20220705115618.410217782@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.10 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1459
[2]. https://openqa.qa.codethink.co.uk/tests/1462
[3]. https://openqa.qa.codethink.co.uk/tests/1465

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
