Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888BD6BE64E
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCQKMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCQKMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:12:48 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717451207E;
        Fri, 17 Mar 2023 03:12:47 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p16so2969037wmq.5;
        Fri, 17 Mar 2023 03:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679047966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DwS/vv31f4BuEfVrvdbvseaIFS29tE8KLLx+JthWfKo=;
        b=kqYUbUCx7rarPzu1sjKivk4CQ1upiEdKzDr5T0rYLb87bdZ8TDWTTirWGwI6M/WVZE
         T/ueZTlr/XJN+MhEGtYdA8+ZOSrZxkjlUAYtnX7h1edorVAFIkqNqY8A2VfbGHoJub84
         VXmOTpw5y59SU7iWFMvd4ycCtOa93f8WF10alm5TJeroKb3upInUcfFqeZXAEJ034/R1
         wu/hlSFEDBEz/haiMhZ3siTsqQ5G/Vkko4/iPNOQJs5miGzhzpiFdg3xaI1H+T9ujxWI
         e0rNUf2PGJmbK6C02KGOkdjLUj1Rakm9KHxGZrcgHKkbC3Cymmv9pKAOamPRYXVh7F5H
         hsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679047966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwS/vv31f4BuEfVrvdbvseaIFS29tE8KLLx+JthWfKo=;
        b=N9hnozdc1qEknueuHY1kniXxNaWYswZjScQ6mJ+q39r+uV7NfLI4IfZIoO8qjknrEy
         4zp/DghkML/on/eGSIXMJf+1BiJ1EDgwq/oR2l7ywES/ZY3b3kePSY+EPntSVRtoCIu9
         dLfq5Ju5F8dLcgYwdvJjMlAo7JLVMeF6ZaDtN13fsCq1szcuSKd9rUkP9wc4sNkClgo/
         y+PWK9615u7SNSdhrY/azkOImVNYWF8uobDNrkij0Vtrv2pFuvtSZPTAfBI2mkVJiVDg
         d7Xj9ZfZRvSJ9rEI4Jj30A4xPKzLGP6wk2zmn/FjU9jdp/ht94jneYkW+oaZkUWywN2w
         iGkg==
X-Gm-Message-State: AO0yUKX1UqsMa1a8uy4u0h8zPuitlk4jQb9o5U8rEfe6TDAFlGmEMMHF
        Ef/hGXO9HKiBo8WwHzV3ATo=
X-Google-Smtp-Source: AK7set9t0nI25zcAALJYDS8Ya6hHA1lT5YjlB5SYqg/ZM0iK/wFqLj2Hwa4T8WrJ5MfdoTj9qk7Kiw==
X-Received: by 2002:a05:600c:21c6:b0:3ed:775e:5257 with SMTP id x6-20020a05600c21c600b003ed775e5257mr1910770wmj.35.1679047965728;
        Fri, 17 Mar 2023 03:12:45 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id h20-20020a1ccc14000000b003dc522dd25esm1535687wmb.30.2023.03.17.03.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:12:45 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:12:43 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Message-ID: <ZBQ9Gzk4dGfeYUv6@debian>
References: <20230316083444.336870717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Mar 16, 2023 at 09:50:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230311):
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
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/3134
[2]. https://openqa.qa.codethink.co.uk/tests/3146

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
