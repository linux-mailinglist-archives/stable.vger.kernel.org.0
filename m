Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AD35880CC
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiHBRK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 13:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiHBRKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 13:10:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3986BB851;
        Tue,  2 Aug 2022 10:10:17 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z16so18609601wrh.12;
        Tue, 02 Aug 2022 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=czLWa8cP/unPIagRRBnhnz+Pt7dNkxuC1wA+KZkcpew=;
        b=RdXXWKNtAKCEaWRexR2u8UOhLyMpWgVdJ8HTtIoHtIxpVlWKT92p5ANyXXhCow6nmX
         D92z3bPCbubbijuFLnvXUDvBe7aoMfdppKqEL19J0tus4HOLwOjGDQO1Q/8luSsmgqhv
         MGdeVmxCkrLKssfqn2tk1QJbG/go4a4egxaXsLjAq0pN5euDciHY3LptFYt+stoue09V
         jk6JiOEPox355T9+60H6Q+isdWY/H0YAbYaj30x9uMr/p6aHzIl6RwLsBv2kWACwFBqX
         fFRBOIycQaXGJWaOAq//ax5Ee1mYJNJKGd9cmX6Nzd4w8bntvv4VwzxPJ9vxb1B5/HRm
         bgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=czLWa8cP/unPIagRRBnhnz+Pt7dNkxuC1wA+KZkcpew=;
        b=wlMBcknbXC+6J4/7oKUa4HA4jJd1G4l/kZsHfxdhJYwHb1Pa2Q6b0kDeJ/U06UnfnB
         oFjsePFbfVyBHtx/PFswhpmNs9QM4vTPQ3dL2LPaDyWed1XPAy7XdflsjMDoakBHr/s8
         6RbjCVEmXjcyAoebpEtsWEQ6Byr3cy2xFKvoL98OVGTpOt0uALq4qy4EbX6IwtqODqv3
         X4xrV8ZwdMiQQNhLFSA1lc8Tib4hLANa2Djj+TPKIZkoYkBF6Vh+qSMue6xG51HdMZ41
         U+tb4LxXEcbDnSDLVScz222CaDtzTjCJI2WtQo/yutNxDPwvHHAT4u7qWDPPUQH+YYIq
         V/qQ==
X-Gm-Message-State: ACgBeo2xo8wGuigTg+txTmM+PeHrEByC8xAwGBEGO7v0t32bs9ul+izp
        Xry557BNIRxdC2gAQ9lPc6Y=
X-Google-Smtp-Source: AA6agR4dycwR7OVTAaVEpSKazlUMkVOEgFRbB7mdDKY2GqScUaVcxj7nqgVq1JO6kmqj4R78FYxGOw==
X-Received: by 2002:a05:6000:184c:b0:21d:beaf:c2d2 with SMTP id c12-20020a056000184c00b0021dbeafc2d2mr13671151wri.562.1659460215693;
        Tue, 02 Aug 2022 10:10:15 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id y14-20020a5d620e000000b0021db7b0162esm16136645wru.105.2022.08.02.10.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 10:10:14 -0700 (PDT)
Date:   Tue, 2 Aug 2022 18:10:04 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/34] 5.4.209-rc1 review
Message-ID: <YulabDDJ9gu7nl7n@debian>
References: <20220801114128.025615151@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
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

On Mon, Aug 01, 2022 at 01:46:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.209 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1602


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
