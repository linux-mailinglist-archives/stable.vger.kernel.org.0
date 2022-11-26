Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7E6395B4
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 12:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiKZLTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 06:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKZLTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 06:19:02 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAF9B03;
        Sat, 26 Nov 2022 03:19:01 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d1so10073968wrs.12;
        Sat, 26 Nov 2022 03:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+0puK+taLmh7q2XEEEVa6EShVz+GcTC6xdX07f/2xM=;
        b=FFe6lGtTQ9b3SgofHOyHLZWWyjkQEAD92acdEpUJ6UTIdyXTc0s3D2fKX0QOF+cFh/
         yE1KeKSMd68VvB/qANzoywqd5a+KepPfMP7YguUCa+TFVYm2we0JGqx+lW6Cb287WOCZ
         4aUYtR80D2DVGnFchZ38hP8H8LA3cFdyS3JcTXwUemM0H6bSGRYnJrebK0tB41zrqFRB
         hZA5O5tE3YkXhnJMg9h6I4spE0/UMbOHjfdruBvg0k7Z5nJF8hIxPhuxwYwsyClZN+nt
         HZZSY5U8LJxwdrcDo04l0l9DKGoY/YIjsl4oCDKANHhoe2ebMw1B+yUuXEvijtK0oeXh
         H7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+0puK+taLmh7q2XEEEVa6EShVz+GcTC6xdX07f/2xM=;
        b=Tcy2dBVWdzMrZuc9vKkl00UTkNcvde88QodC3aZnfiUihULbJOtXVObs0AI4vBsU/p
         RQixFEHyoypiCphvdPcc873BWqY+Hl10ZBiztJkoncnTK9aI8ndVGIQcB34CmBZybZQl
         wpC5b22F7EEfrlPbdD1/5JwwLJcGQsFfupAV4L/i+7UsnBODQM1NO3BSwZd6oy/FVGmH
         Y165msJC7Jr5yvutq/Q3nTmgDw9gnayfeUnIITOjVkZCy7dfEHjc+rC5GCk5QD6zPySt
         sjyC8kaUkfUzzVUSn/Et7zofk2oDnUmoo5YJoYpwUuEak7mQRdMeqQ6mShs/AUEvi0e9
         fXGQ==
X-Gm-Message-State: ANoB5pnTHDnbs87keDi5nEFFKX/dWg6H1bu6UNqAj8GKGHYiCLMXQ+Ve
        WFV76QbYIGnjjwDEVN5tCNo=
X-Google-Smtp-Source: AA0mqf5y9gWYmf+pcFz1umxzIPTKdlkS519VScjMl9s1exM8Iy1fPy4+9fRp1crTBhWfIGCdLQnFrA==
X-Received: by 2002:a05:6000:1d92:b0:241:6e0a:bfe6 with SMTP id bk18-20020a0560001d9200b002416e0abfe6mr17967047wrb.34.1669461539782;
        Sat, 26 Nov 2022 03:18:59 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p1-20020a1c5441000000b003b4cba4ef71sm12001305wmi.41.2022.11.26.03.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 03:18:59 -0800 (PST)
Date:   Sat, 26 Nov 2022 11:18:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Message-ID: <Y4H2Iea9GqSXTkYx@debian>
References: <20221125075750.019489581@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>
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

On Fri, Nov 25, 2022 at 08:58:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:16 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2225
[2]. https://openqa.qa.codethink.co.uk/tests/2227
[3]. https://openqa.qa.codethink.co.uk/tests/2230

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
