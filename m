Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5C76C3650
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 16:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCUP4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 11:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjCUP4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 11:56:42 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22953B666
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 08:56:40 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id h15so2585289vsh.0
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 08:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679414200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHA0cbdS1dEyb0KuPSwVES+1ODSyv2r98Cp2t9mhxB8=;
        b=yar+ksCzoZkluxr+vs0ZiQVsF7HNpXYgn8MTm4RndKU9Fo9SxqinqibYQ+b6EAe3TG
         NCy/89MkYu56pqRngTI6LdM54Mi0lEBqmjZNeNNZkVjj7q7r5FH9fvsFoFGmPpuXwa4a
         VDLyqm+gxBA2N7ihubkc6XwAdfFPAC/ceNVjOqC7+hS0wQSlFASt80Dm1YKeWXceTQTn
         JDEqvP8HmcOHjPEwk1gJd7eHpojkdGh5uM4cvf9RNDJHKwsENKO+iMy0ais+/VGpX173
         ACGyR4G02X8UUrNCCD9BDNdqqudS69NqtZYdyhCH0zGpK6CDBH+vj0/tbzOPo4kE/ynt
         YecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHA0cbdS1dEyb0KuPSwVES+1ODSyv2r98Cp2t9mhxB8=;
        b=SXFfPqPCHDyMP2MXwnuNqusOhIrWr8GmwuT4wQ9BEnHC0J9BwiBu3TTQxbWcF4lqWw
         ykRH1wFj3Oejquh5kMlRzTaSTcrQq7Mw/1E3VtGf5G7D/jvHl4ItrmWcSGFxRFYjA7gQ
         F2uJqW+/nc+Fv8hMUG0b70xwqKTP/KeHUYJWlcujTzRJsw1JRd1hL2KZ6Zys297Pj2Yp
         jy3j+PpJsMb7z7PBKyTlBwG5CzdTw9IjsU+ZEpCN+ofq603fHkKJ6rd1I6IKH6y+oTan
         dyMe+crH1dpEpjgHb15uFCAqukyq/ORf76IXX+0iL678LiDN6bnJtbVxeoh+Yy+iy4/L
         jDJw==
X-Gm-Message-State: AO0yUKWyLVq/KRje7O1Q8GcSv6EsPW/XZ4rV1D3XwNq2ngbYkcAvHBCY
        8dyqq29CxGDFkysKP8A1/tBNiUrMs7jJ2JBc8PlbLw==
X-Google-Smtp-Source: AK7set/6uZ4VQJHCSPEmC6Kx2n6cqlS8YV4W7n02P4n11z6JEfRsyN55Trd6Z4oD/280pdj9aUGBapt6Wv6iGdPSt7w=
X-Received: by 2002:a67:e00b:0:b0:425:d255:dd38 with SMTP id
 c11-20020a67e00b000000b00425d255dd38mr1765286vsl.1.1679414199753; Tue, 21 Mar
 2023 08:56:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230321080604.493429263@linuxfoundation.org>
In-Reply-To: <20230321080604.493429263@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Mar 2023 21:26:28 +0530
Message-ID: <CA+G9fYtC86ZEBq=qT7ZymtGVKfUurebVGXtTo3JbKYRS_4+B=Q@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/213] 6.2.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        llvm@lists.linux.dev,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 Mar 2023 at 14:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:05:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Powerpc builds need more commits,
RC1 to RC2 the
  - Build  clang-16 tqm8xx_defconfig got passed.

But still following build failures noticed on RC2 with
  - Build clang-16 ppc64e_defconfig failed

---
error: unknown target CPU 'e500mc64'
note: valid target CPU values are: generic, 440, 450, 601, 602, 603,
603e, 603ev, 604, 604e, 620, 630, g3, 7400, g4, 7450, g4+, 750, 8548,
970, g5, a2, e500, e500mc, e5500, power3, pwr3, power4, pwr4, power5,
pwr5, power5x, pwr5x, power6, pwr6, power6x, pwr6x, power7, pwr7,
power8, pwr8, power9, pwr9, power10, pwr10, powerpc, ppc, ppc32,
powerpc64, ppc64, powerpc64le, ppc64le, future
error: unknown target CPU 'e500mc64'

---

> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG

> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/64: Set default CPU in Kconfig

following commit also missing fixes:
--
From 77e82fa1f9781a958a6ea4aed7aec41239a5a22f Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Mon, 19 Dec 2022 19:45:58 +0100
Subject: powerpc/64: Replace -mcpu=3De500mc64 by -mcpu=3De5500

E500MC64 is a processor pre-dating E5500 that has never been
commercialised. Use -mcpu=3De5500 for E5500 core.

More details at https://gcc.gnu.org/PR108149

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Pali Roh=C3=A1r <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/fa71ed20d22c156225436374f0ab847daac893bc.16=
71475543.git.christophe.leroy@csgroup.eu


--
Linaro LKFT
https://lkft.linaro.org
