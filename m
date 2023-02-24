Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB8E6A1B39
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 12:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBXLRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 06:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBXLRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 06:17:11 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289615AB6C;
        Fri, 24 Feb 2023 03:17:10 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id bt28so6879123wrb.8;
        Fri, 24 Feb 2023 03:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=npDbChGxVT4upG8iaPwlFeucpDW9PWHzn2e04HvErHg=;
        b=SXYrhGcd4tqmWcOnaTmKqN+sRnT/WFxWYU4Azd9/iijyM0RUUC9M4K5jXT00g5aZ2v
         OUKYkUwRUBZykOKKB4jAQW0UMlvo84Krd6+CUp5qCOqq43nfd28dXj5wHNKOx2rhVnMz
         VjNN9puvOdzvmaZpbyPe7sJJZub+P9WtcWFmom3Ai9c/YOKsXrntLjfRT2rmRkJbikWj
         SzKK5bqyp1+uzzAHl2Og/PMMrSudaKlKyfmT+XGm2/956Ubttmj5fOoOR0Mb9xdpRO4x
         xk8nLOsB/rlW6yxwX8jWFhi4t1iYFCZpyqeLDCBCOw2qeMRJCosqfL2PpQO+oeEQvhAa
         3NQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npDbChGxVT4upG8iaPwlFeucpDW9PWHzn2e04HvErHg=;
        b=2FVXP83azPe6vmz9VFJVu4o8+iWACuPW/IyW4SjEcDzIKO26C2aRkl9RK/XjfKXDcB
         FRyYjl9eo3JndvxLH4BH1nn3/nB0FGxkJtQVtuDWt4mBupKjGJO6yxGQHQcmVHDvLMVv
         ufvu/h9Qvqs4xEn9jsjrasWNFLtj6aAXXBcz/uFpQlST3CciMFd3e8SjIOoG8V366Q31
         1d6+bP96RQL3MB5LSxkgU3ut5RmhhtPFXNkfdSRGkiF7Pms52VRUePorfyyr5n26C6Jb
         nTuW7IztwE1HJN2O5VgpG0YbvrE6winTu3FCG0n+uTqfsnzq1sYbRSYbmmtT5TrVldCO
         EaFg==
X-Gm-Message-State: AO0yUKWXCcQ3mGrUoCtsB1T0UZMMwG3nF8ecdvjmjiFa1XQCcpZlZcTy
        aybDdqO7crnXk+mOxt80UNA=
X-Google-Smtp-Source: AK7set+UJzenSO3Gz/GaTaipnBhKn5GSfxZ5z86bym5kTMn8n+9cf8ur0PJk98JfC7yVX7pPnN9Ayg==
X-Received: by 2002:adf:d0c8:0:b0:2c7:1b3d:1fb9 with SMTP id z8-20020adfd0c8000000b002c71b3d1fb9mr1944209wrh.50.1677237428674;
        Fri, 24 Feb 2023 03:17:08 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d434d000000b002c55ec7f661sm11676426wrr.5.2023.02.24.03.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:17:08 -0800 (PST)
Date:   Fri, 24 Feb 2023 11:17:06 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Message-ID: <Y/icsrUPXoxqPCLj@debian>
References: <20230223141540.701637224@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
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

On Thu, Feb 23, 2023 at 03:16:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2930
[2]. https://openqa.qa.codethink.co.uk/tests/2933


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
