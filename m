Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506D469E2CB
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 15:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjBUO5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 09:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjBUO5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 09:57:39 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70532916A;
        Tue, 21 Feb 2023 06:57:38 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j3so1516252wms.2;
        Tue, 21 Feb 2023 06:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4H9Mx/yKZ3Hus53qi2wHVToOwmIjYjSCkNX7dVFqCwo=;
        b=F2QVHq2MCLZT2G5xJA114eev7sGqCMrd7Io0D+KtpUjacTeZhDiQ9UixCwB1qbmptO
         dWnBgzBbqEDLMGlhxBVmRgj7IcKcxRD39kHShMHrEzeXoYAo6wN4RKpKig9W6tqtNUTt
         2UbDIjuwX5Tir3Q305RwQWwA5koLQAa4CMCpx3jKvGwFwHrPU6USlvVujdgJqP0DD4cK
         VGB9Wk3iQV0WEmmPfqzCXdRAturixbDMT+U6x/0iH5nMDlSt0utdeASuG3ox7jX1RS+Q
         WDqrHMWdipE2fhrI/Ku9CuzS8nE1ggzLRNisrzLwkqYWgoYo1w9KF8LfgwEjWY9O6+4x
         DP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4H9Mx/yKZ3Hus53qi2wHVToOwmIjYjSCkNX7dVFqCwo=;
        b=rOQ+xAE/koDaQHA48JCgv9iCvgFXyUebbt/wqXwh1WCCE/+NbVe65YxyORGtFviexU
         mzP7gTg72hmmnj0A5YAk+FIRtOVe6vIg2jZz2Xi6vN4UGPKJpuifXwM5y47xGgP5CLrW
         qJ2KS3MIs5lFC7IfqLzn8AXRAdzKYSEXgE/AhgiET5Ypnum3Ym5WWK5PWkdACefMCh/I
         CkTGpuE5U+Iejic+ockI+radKZQqF4fImFKSloDxBj0g0XpNYUnwvm15TNxnvemfK3oK
         2Zt1MsDX0o3iylhgzpQ1zPtsAwM2aOyHW/uTR+l3cKCHiqmCtwSmmBDBlidpLMxg3NyR
         whSg==
X-Gm-Message-State: AO0yUKWhfJrlAFwOi1StIT7vGhPEYiMqaZGA7IYAho4fYIxHkFtCr8Gm
        psc1McjxHm4HF4GhjPbiAkI=
X-Google-Smtp-Source: AK7set/tts7I2v794GNeEU0xjDE4f5TUNTMY6f68NtdjKBIJ0UWaYFSZ0sj6Q7mjoYHCqSjqfrEI4g==
X-Received: by 2002:a05:600c:3b11:b0:3e2:669:757 with SMTP id m17-20020a05600c3b1100b003e206690757mr3471234wms.10.1676991457308;
        Tue, 21 Feb 2023 06:57:37 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c459200b003dc433355aasm4595702wmo.18.2023.02.21.06.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 06:57:37 -0800 (PST)
Date:   Tue, 21 Feb 2023 14:57:35 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Message-ID: <Y/Tb36aAXPJzbCAG@debian>
References: <20230220133553.669025851@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:35:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2907
[2]. https://openqa.qa.codethink.co.uk/tests/2910
[3]. https://openqa.qa.codethink.co.uk/tests/2912

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
