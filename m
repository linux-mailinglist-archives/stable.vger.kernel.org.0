Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70B169E2C2
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 15:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjBUOzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 09:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBUOzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 09:55:53 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7482229E1E;
        Tue, 21 Feb 2023 06:55:50 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o4-20020a05600c4fc400b003e1f5f2a29cso3834125wmq.4;
        Tue, 21 Feb 2023 06:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8vYRFHb5gDoOeQ2hkB+dfrhYaR6Ydea8qkg1cZhOWzc=;
        b=lvxEljblJo9Jo181FYE8il3d92+hS0T8dT8u9x0DYyJStvlwt2pKXD6zPrqJUACQ3F
         tSBwjvhf6nFjb3FVoSPs3yP1CmG5vr5yOLUx8X+C3hVu0ZZFTQeKbORg9ERmPomKvKxE
         g6aTjUN5lcPsFXdRCOC34vXqAfeix3awzqB3rwYZArkSVIJGQbcl7+f3Oo9n8he0E98p
         ewcfFdI8swRlRNuCYP+6KuTUu92zTP/naZk+rvUyM9Dr2cd9eHmvzSpALbGahrw+wcyD
         P/moPXt7+3Zv2PCC2O1iGd7OGRNf/KWjaDNNE+Y7O7fPHk0uTAN2TOB3yWTB/NhxSskm
         XZig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vYRFHb5gDoOeQ2hkB+dfrhYaR6Ydea8qkg1cZhOWzc=;
        b=zlGIRTnFk5Npri8Dm83/BZ94xiS+2HwdpLpOdObsOAPIMf++hYyMvldn5pX88Ggk0q
         GYmoMixh22HGA83ZTgB6nkvyjbo/80pNAQ/3eZjv/3aGvhcgZWi1PcJZqFRO7mGbp8hN
         POCHXx/IL+R2cxRV23MhtGJLH1edsNHh5M3EDafUR7hkK3fFIaPkuXTybazU+i30eLmH
         O2b61UE/htp1mhL2TQDk1V/KIhTQ/YIAjCBikGtKL6gxPdNkTVjqOgBc49TMCulvrfFq
         URcu2RUieOO2pEnxjb0u5QS/krwW6vxJybwdiFSKYdU1Nzo6Z8vdDvpiDgrygJwkooSW
         dO+w==
X-Gm-Message-State: AO0yUKWvjzQts8gjG7JONOrntnPMgJ5VBY6Mtb1shGJMzs7eXErUDOAP
        TME0LP0oEzjD1MRWxom65wI=
X-Google-Smtp-Source: AK7set/MZNh28mUW9Q1w3BRd3cchiTogA9C/ej/PjXNZC4RJo8QJtcCwQ3D1mrJLg9RW6seDVj6hyQ==
X-Received: by 2002:a05:600c:1616:b0:3e0:1a9:b1d7 with SMTP id m22-20020a05600c161600b003e001a9b1d7mr3017853wmn.19.1676991348802;
        Tue, 21 Feb 2023 06:55:48 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b003e1f2e43a1csm4670984wms.48.2023.02.21.06.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 06:55:48 -0800 (PST)
Date:   Tue, 21 Feb 2023 14:55:46 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Message-ID: <Y/Tbcr5YIocnnFQB@debian>
References: <20230220133600.368809650@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2908
[2]. https://openqa.qa.codethink.co.uk/tests/2911
[3]. https://openqa.qa.codethink.co.uk/tests/2913

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
