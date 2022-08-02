Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09035588143
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 19:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiHBRp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 13:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiHBRpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 13:45:20 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFF812AD6;
        Tue,  2 Aug 2022 10:45:19 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j1so10403933wrw.1;
        Tue, 02 Aug 2022 10:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=VX8txl3/+0QeRvpYY1TNyCvH4SHLM0g5nHUtDTMXGvY=;
        b=qJ5Y252mVpZk6bZEOKd1Vhc2Ct914CsDaJXcYw5Oyj8BzaD/s2hB8rLqbfrZ0AcNE9
         4BCWJvh19iTX2kncXuHGrquMGgUo8A5eVAvlbf9SeJObzkfyUsNo8H+cLAjiQJY3Re3f
         BFZnmlDLYI0n6G0gwh5PUBhp5fW6/U8qGH1duHrRH2cDzJke6YxdXYhiFMFCm5iYEIe7
         2OWRs5YDWsLIkRBEw2U+gMrJ0h+qeQ4cyTslVNai+l5Fv/jM/u6Sk6du4BHWxTqPExJY
         TGMdqCG7qfrXUVf1NIHOIPizNsQLPQDeZWtnaAql0e0GyDnHzI5mpa7kdlWnfrcZgZu0
         imFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=VX8txl3/+0QeRvpYY1TNyCvH4SHLM0g5nHUtDTMXGvY=;
        b=C1fd/6Tywohu4L2zUWmVktuIBFCcyPb/vyj6fqNDd04lJKYjDE23diZQAj8qUZZAkC
         QsXUNqVXAI1p4bXCuOiL5docXYctMsde1RrZ3Hwy/0BbdVhrQ5NtT8A3gTgmWZ3fxkkc
         p77jf7s1jZzAjVHAu/z2GqXob1bqHNACszwr6To3FgEX8afE6+VQbgIlpxLhzHETsU89
         0hL+9nuP6ncr5lL+86+iX5IuSUjOXg1pSUyDbVvA8NtKgeZVpyOz8D7Q/axcbD0JQFvL
         OIHyIrWSEue9movOGUydWHs+yN0JsLc6XffjysQW1Uvae/2u8qPaO+uoPd/xS4UMUoGI
         V23A==
X-Gm-Message-State: ACgBeo2BjEaqoSw7TrwiYnyb3rzqtBAwogFF91/WEinFp4SUduYHJZa8
        w37lbcpQzYE8IDvOWJayAhc=
X-Google-Smtp-Source: AA6agR7Ts2Nwr3SHbgBmaAKKbNiGFJzWfrtWVYze7AQUt1UOeuyj/zVqLRQjXvwHLdSw2gnhAaIHzw==
X-Received: by 2002:adf:ea0a:0:b0:220:6222:ee48 with SMTP id q10-20020adfea0a000000b002206222ee48mr7124681wrm.243.1659462317490;
        Tue, 02 Aug 2022 10:45:17 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id az13-20020a05600c600d00b003a32490c95dsm24209807wmb.35.2022.08.02.10.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 10:45:17 -0700 (PDT)
Date:   Tue, 2 Aug 2022 18:45:06 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/69] 5.15.59-rc1 review
Message-ID: <YuliolY38GjgA7hm@debian>
References: <20220801114134.468284027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
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

On Mon, Aug 01, 2022 at 01:46:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.59 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220724):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1604
[2]. https://openqa.qa.codethink.co.uk/tests/1610
[3]. https://openqa.qa.codethink.co.uk/tests/1612

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
