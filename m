Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9356855E
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 12:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGFKWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 06:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiGFKVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 06:21:49 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E332715A;
        Wed,  6 Jul 2022 03:21:33 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v14so21379624wra.5;
        Wed, 06 Jul 2022 03:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uEHh4GEP9EGPyx2OPtnoe9ayGXgmmZLOmFwUk1Akya8=;
        b=Gbd5BjMdj/NZowumQ+VnsG0Y7aMPE4mv0fXyAewoMbgxf5bna1GgTD7fbMNzMct/LS
         X4DO7FDPaOp85/oV5GInGQhXrA+bPY9JqxvJK86jdJXYJ+k2oC+ut1tQ6CHhBW61EOVC
         y+eTl3iCcgKeXjBcMQBFiOHuLnu3AYtOgjSJcdcW7KdHVCEp0YywYt9t93dXu3/X/Atk
         +bxF99Q8zYfmJTiAsUAw6BtmFXt/1zmK2AW8dIV0UXAGx9TBd9NyjnoWabnICclG0355
         gOILpiogZ7KFe592jOTVN0oOaVQvLFZ2mVLz+nsSc7/PJA0o79HN2j2mSXwi37HQxbMV
         ep1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uEHh4GEP9EGPyx2OPtnoe9ayGXgmmZLOmFwUk1Akya8=;
        b=MfJFtpCkMH3msvsQegCMxkBmvAqP+UQ1oeyWX7fJGf7KgMCMtbgx6xV8wSP/+yTtSh
         geJfpJGBsa6QkEqBdKtivzuAhPwBvPyY5kb2Z0n1jZWt0Rw7dTp2vY0q/nUk76R31RIw
         7Af/UX3Q86GbMcw+y3VL0zE/1awGk1znqWKVEocz4Fq9hNVS2WLFF48SCyCfBchLAHUT
         4x5m+yX4s+hNSUI0T68WPaFEvYBlmrpIylt9A+0R8S8+iORETkquz5bjnJ06GdlXOepj
         dEBcsfTfTTIT5wHGJHMx+swNbIc8eYWwctD1zoltTB8sGLgNlSIDniV0MFMS5HxmKara
         9JLg==
X-Gm-Message-State: AJIora8oPkIRn1bNzVWrDgqCJafsAu+C+JL50YGzunNzIMkAOBgNwrrb
        bwmRQ/A4DTW67YqHgWGzF4M=
X-Google-Smtp-Source: AGRyM1skWE3Dv/8Q1wMYa1A89flq9kAodkHzWPqKswBbq9td3sdVT6+aUfBnz8oWuBc9sjU/2HpF9Q==
X-Received: by 2002:adf:d1eb:0:b0:21b:dbb5:fe05 with SMTP id g11-20020adfd1eb000000b0021bdbb5fe05mr36960896wrd.651.1657102892039;
        Wed, 06 Jul 2022 03:21:32 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id t5-20020a1c4605000000b0039db31f6372sm21875103wma.2.2022.07.06.03.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:21:31 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:21:29 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/33] 4.19.251-rc1 review
Message-ID: <YsViKbbTLcySS6ka@debian>
References: <20220705115606.709817198@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
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

On Tue, Jul 05, 2022 at 01:57:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1455


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
