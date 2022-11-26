Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADBB6395B0
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 12:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKZLRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 06:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKZLRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 06:17:24 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04121EED6;
        Sat, 26 Nov 2022 03:17:22 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5so5180914wmo.1;
        Sat, 26 Nov 2022 03:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EKBlOjDIo+FXnoo/ratYxLq6wevcO8d8/HghKFwYCx4=;
        b=PdSUeXcyA/vBYOIS46Dxg3XdcZj2UdydFPmSFt+ujsV631OvtyTWC+EF8i++boQIYj
         Dr//OLHcBDVXrimwn/E9SsbEVXLdNaKi/CQmAzgN5+xSTw9BOM0iU0hz+GEWtrbENPrt
         EfaUXsaG2CiINFreuUVOJ4jD1zrfSvJVDeRPfY5ehTvolF5JIAK1hwYdr/rQYUnH+pb9
         sUAJpXiSwrg10lLuemj5AXs3FzbRntfNcXakSYGXNR4HqwY/OuPA71XQtnURgHwO7Ksp
         sm51rNaKKMJQL4/9WeIb9NCVxrEqkNKq/Zb85DIBEXfEBxqLpwb+tew8QttZLTn/HN8B
         tHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKBlOjDIo+FXnoo/ratYxLq6wevcO8d8/HghKFwYCx4=;
        b=I5WwgyoIacPPGfdLs2EZnmFvCoXvrgQmiY6mIOXoLThmEdKDX0QvwMqjKv8lODqW8e
         3CjCeWMy/QMB8lbTSRfdTCaeYq23EoVCDvX2SL3UYXBHvxlaj8gL+WbCAvGG5rHARzi8
         foTdQ9m5eZcJUwkkVTWB2ho+e0Du181Pt/2IHAgKfQp6BI+g4S82USX2StufVIq1wG3u
         mVVBAB6W7VuVYP2iK1WMKhHfI88hdBiTJzTJViIQnAalYxSRG9/c0C+4+uFPbWeqxsBx
         +vx+GP6f7bnkacAC6Rdsudq8wWDQQzSXgK8dMbCdYuos3cV5WA880V0MMDU+MtCI3JYd
         DR/Q==
X-Gm-Message-State: ANoB5pmA2/cOwNjFc4qyJjqJBIWZr7rloTqB47G4PTNXokePgyZPbM7c
        mLOoKWj2/fEYm3ucCgVhBps=
X-Google-Smtp-Source: AA0mqf6ZSRviRwvrfCzcg5u5CU6ujh9mzD4e6f1QEbdq8uAcNdPU4CLP8AHAna4Sj3eSTBDoPPOiSA==
X-Received: by 2002:a1c:790a:0:b0:3cf:e137:b31d with SMTP id l10-20020a1c790a000000b003cfe137b31dmr21524246wme.205.1669461441065;
        Sat, 26 Nov 2022 03:17:21 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o20-20020a05600c4fd400b003c6c5a5a651sm9046745wmq.28.2022.11.26.03.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 03:17:20 -0800 (PST)
Date:   Sat, 26 Nov 2022 11:17:19 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <Y4H1vz8htC1+9rbB@debian>
References: <20221125075804.064161337@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>
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

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2226
[2]. https://openqa.qa.codethink.co.uk/tests/2229
[3]. https://openqa.qa.codethink.co.uk/tests/2231

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
