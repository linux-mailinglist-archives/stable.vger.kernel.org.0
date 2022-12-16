Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A393F64EBF5
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiLPNOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPNOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:14:02 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE6D4385F;
        Fri, 16 Dec 2022 05:14:01 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o15so1827044wmr.4;
        Fri, 16 Dec 2022 05:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m8td16btPgGE0p4CoNaWK079dTkpm7qVZ4qxtSECPDY=;
        b=K6PXalvePnYIFBv7rGrqI0KXfx4XfXgtBJ2gbom4ZxZ7ZjyhsTvhdLe/Wu8gy81yAt
         NRZS9bkM64cKmV4UganS1pwltS0Na+tAsnj9g65aFxg7kPDu9R8QQgGOwz9JRuSJwi2F
         eEnx42t0kytGp/PPQA4qG8GNkTl5ogKt3kYwP3tYze6FAR6RfUR3UHI2eaOTEE6D/lb5
         Sg4nmHpfnfD+jbJVnGIzWL5GsTwLKW6qS1SH8pbiGkcDt/bdwa0SC9oyHYnGkxeCFT6p
         EaPplEl4YMHROLVAAgBMDbTkk1oW7Rb1eoqqqIWEk8rjsQr6QxPHbNP5D15AVaZw/Bqa
         TRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8td16btPgGE0p4CoNaWK079dTkpm7qVZ4qxtSECPDY=;
        b=wF9tmJwEP/LQoXQshzPRu8jH3DLyJPW9q251vw6rB44mNAhqrQKM9yYlR/R1VYXOa+
         Nd7RVTE+mbwk4+wEyhB3zzJps18TkPQNTH6JcZ8gxJwIZkuJ1aULMwAY9LhES/I4OWLv
         gjvzPt9fPxwt/OUrqtljRIpo5QR86aEqSwKiKg/mKivPtASpE5zcfmtH+01kd9/1tnjg
         FqdraD/F1V3HlRGvenp9bRYoyw5d11ZKpcNrPslncaPUWUFVs/1xPgY6vkXv6d2Fkhv/
         1UKmmoufM93XZw9PZBBFkIQko1DoYabDx31cN0N+YSPEWqp8rajBumEd1Yocy0WF1Bfv
         xSSQ==
X-Gm-Message-State: ANoB5pkcLvWDT7SRINq7qWFbW3nESNuyN8C4mvAVJZbDdVU+0ytSDpSW
        REzEBQnW2PZdB0avaXzeWDMgF+xpvYk=
X-Google-Smtp-Source: AA0mqf7ttMl4WZ+BxbG1kuGPLsFd0seu2xr5S/A6FCrPk/BguowJtqlYyuOP90IYBxxwaCQg9TLd5g==
X-Received: by 2002:a05:600c:3544:b0:3d1:e04f:9bfa with SMTP id i4-20020a05600c354400b003d1e04f9bfamr25285912wmq.28.1671196439882;
        Fri, 16 Dec 2022 05:13:59 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id z22-20020a05600c0a1600b003cfd0bd8c0asm2507934wmp.30.2022.12.16.05.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:13:59 -0800 (PST)
Date:   Fri, 16 Dec 2022 13:13:57 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Message-ID: <Y5xvFdS9BWXmVg+3@debian>
References: <20221215172906.338769943@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
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

On Thu, Dec 15, 2022 at 07:10:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2363
[2]. https://openqa.qa.codethink.co.uk/tests/2369
[3]. https://openqa.qa.codethink.co.uk/tests/2365

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
