Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A945684FE
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiGFKPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiGFKPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:15:43 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CE3B1FE;
        Wed,  6 Jul 2022 03:15:42 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so8697516wmb.3;
        Wed, 06 Jul 2022 03:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8iSPnCQlsn+unzEqQcxOovCWHEse64Sct+b/T3iSIHY=;
        b=aj0FxjuXf5+sYxguaPR56ZprS55VHe5p8rrpzjIRCgOqycEJExWkGLaeRK3bPBodEJ
         Gfg9DK1JRt2nsD/jT3t+r5R4BzX9VYkUj+62J3DYIKHyNHnGGqMsRvmvfV3YwHP/NiGj
         q8kqKp0caReF+UEGk7/Qe/2J3lBVLMTwAONjOsuz1HvtgF+Bsg1twpdOUr/kVYxu8TPS
         ZLhsaEK3atv4PCC+o8S0tUw7fma2qXrFc4jq3R58hS3/fPCZva/3808NI7u/atFvHxU3
         O/v8IOQDlpGCzudIpAW6jMZ3QnELL7udgODcy4IRqEKr+afWPOBEZjjSY2GAQkCeHdWs
         C7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8iSPnCQlsn+unzEqQcxOovCWHEse64Sct+b/T3iSIHY=;
        b=WbWk62TTg5Lo7KjzoL67vnXGFWaCnExSSr0ypF6v/2C/t830YIAYFiVIBETVf7LOVl
         kN+eOTPa004UiXUX9M3IUu56+a1tghBARcSgQ3CtKHEw/gl2kRByvvgjTYe2g8zpS1RX
         yB6ba0Feqth/yDudjQvCuc8T7jwrJa8xWcMXDzWphDp52BCRdh1QrWiJUYh7dRmrlB11
         ayHYvkxHFUBdcSP9/BNUeUP9YKkPpPzqTB89CJFeH4DvRD50dmKid27iVM102as0WFw5
         dArTHOZ4Kgw3n8uWkQI95YtEHabS28Gr2YcRpwwFGjFj+1WWvSwjOoMuPPCnEAUchDYx
         DoFQ==
X-Gm-Message-State: AJIora+LOh3Ou7ObhtKyTcbsvFRPYDwGdVbNWkywKc7LUGkTlW7R0B/w
        KkdefzzqU0Nzzgc3Wtql5mo=
X-Google-Smtp-Source: AGRyM1trurU8mdAXWWae97aHNRdGMRp2KksttXISCTNRtIBYP+sMAcFFNPp2a9M21Jsx8Lfhhyqd/w==
X-Received: by 2002:a7b:c8d2:0:b0:3a0:2fd0:177 with SMTP id f18-20020a7bc8d2000000b003a02fd00177mr42782003wml.23.1657102541471;
        Wed, 06 Jul 2022 03:15:41 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id q11-20020adfea0b000000b0020fff0ea0a3sm34783485wrm.116.2022.07.06.03.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:15:41 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:15:39 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
Message-ID: <YsVgy1TGlldNqADK@debian>
References: <20220705115617.568350164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1458
[2]. https://openqa.qa.codethink.co.uk/tests/1461
[3]. https://openqa.qa.codethink.co.uk/tests/1464

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
