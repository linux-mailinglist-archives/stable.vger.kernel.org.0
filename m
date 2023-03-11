Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C7A6B5B8B
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 13:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCKMVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 07:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCKMVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 07:21:25 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8819525B9B;
        Sat, 11 Mar 2023 04:21:23 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id g3so7396740wri.6;
        Sat, 11 Mar 2023 04:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5fXIVr7gqCwmEgskozko98oirCIU7XQEToUdjHVacKo=;
        b=FO97lzR4wBH1KOgj49mKW057+Q36xfPNbBJwqyTOxYOtHjlXqLPntTHkOJHPGT/YdR
         kCjObndO+oiNG8W2QA0hXGCPWg5VWvvZuqaOya8rXPF+d+wVcmL6JkgtRoC5NKoOOyAO
         T6dNMKO6I9hBFGTSLe7Al8Tk0n0WtCvcOvadxTo4s7E3AzFdJ0p7zA0XOh//+s+NXZng
         UZuiEuLeAVvoE2zYexz/Ed2uX0p1Cjhq2Htxe+rBxXzrrpj6gl7v+6RKf1m4o5GkWM9e
         E7zR0OnZJKqSqyNbTrwv+CGLyTPHs8TdbUw4GKH5VM+5Bv76nZGWgpuIzHEu+ass5N8A
         3Y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fXIVr7gqCwmEgskozko98oirCIU7XQEToUdjHVacKo=;
        b=XB5IdhK2z9p+P2LSGhAoJQhom6oRd6x6TR3Ths6RoZK9VMpgL3KhSvNu0q0dCVpmdR
         h1gMdhxMoZPeTkA0mmgFFU0pozZK6pS1u+U1PKLacBQQ8gP2dIOFpzUsCT/wGsHpLfKX
         wUIG8xtlFg9anV5VSLEVeg5RYTyuuEIVXxX/VpEdx0g8+VnsgaE2B9k1k07y/w3uFy4j
         OId+DAsozL2wb16tRxCZupdw6OxCPMwN5qQJ6dkKX2TP3kHKvs7lox/sfmaoJ280cRPd
         uKPpQP2oONTh1ozHzKOhFxayLCUvQ74V6LqGlcC1wfTo2pcIKSfWWFXJnIvX7laAiN7/
         nJog==
X-Gm-Message-State: AO0yUKVmMrzPySyY8k4jXPLwbH4i/IPH+sQrE1WI8OmkQ67Bq/Qo2nqX
        3qxbZj04jTgYKucXIr5G+0Q=
X-Google-Smtp-Source: AK7set/dquqEYqlbPkhNMYPAySOK+2Z24Ru36FgEdTd9R57dVQoFHunD+p7rKjC4XPkW2l4rwT4qOQ==
X-Received: by 2002:a5d:4c4b:0:b0:2c9:3955:3948 with SMTP id n11-20020a5d4c4b000000b002c939553948mr18149264wrt.70.1678537281830;
        Sat, 11 Mar 2023 04:21:21 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id l18-20020a5d4bd2000000b002c559def236sm2335289wrt.57.2023.03.11.04.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:21:21 -0800 (PST)
Date:   Sat, 11 Mar 2023 12:21:19 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/252] 4.19.276-rc1 review
Message-ID: <ZAxyP3SXvdnPh5ZK@debian>
References: <20230310133718.803482157@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
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

On Fri, Mar 10, 2023 at 02:36:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.276 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3072


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
