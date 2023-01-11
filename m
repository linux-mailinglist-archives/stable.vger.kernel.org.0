Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9D665BBE
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 13:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjAKMw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 07:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjAKMw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 07:52:57 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB4818B16
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 04:52:56 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id k4so15558473vsc.4
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 04:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rLqRf9VgAmK96U2aRgTND14SHPmEKdSAmyPaFPSFzBE=;
        b=YsGSPW8RNCDctVWQ6PSdppj4BtIihq41e2b8fYoCbUQ0JTDYQTxjhnQNpQebZZIGyc
         T/s+OZgmmhoLP/qENU0DbODnagcuUyp/JaqVt7ERGrqF9LUXagvQIdGQ76MU5AH+ePZt
         dMWc/7BPeateozG+ykDN4SgOndaJVFzTJVdVBn6IKMQ8drCCUFO1d22h6NQrqKEHbBZx
         +4Li3a/DJfZpHhiR4r4kSrNEzSqJk47WpIprpuwFkIM6aH/5+vLYde9qJMTzACsGI/kM
         4Y29c7+G2BOw1nsbz+TW9stTCnIXLDiIdzgdiGDW+rvop53WIBmExwQay/95+bU08Q5p
         JT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLqRf9VgAmK96U2aRgTND14SHPmEKdSAmyPaFPSFzBE=;
        b=G8k1G47iv/j7pYCesqmco50TJxkjz1d+TI5L2OfatxWVJ0ZJoJryL1pF5U/KMl9I7g
         JB8Fglpj+kiE8GSJg5iaTGdyJEjTvMIU1kEoAebz47VqsxxQ8agyG1PMqW4Ra+SQMC0n
         YGYtM0hRvTVQ5jMZ0Y7TVHeWPWYsu4eAPop3BBZMB6hyT3KFdWdivD624Gt6fLvvVOkb
         jy9PXyVBhOpzMmRsQC3l0xiu0QQqLJ0ZAgGATvzPA5GY62kNVOmRDefB78nOwqEyqI+v
         0IreIDTTscsiQfgm1jFIqNDH1h6W+mLFU8rBfYDqUxXhkYAu8W/sxEZxWUjoeT7Q1J8E
         FBHw==
X-Gm-Message-State: AFqh2krGTeNTVlzZu2XeolWCNxOk+aeiBHsB0Akgba4FdHYhnGientpz
        7FJbupoOD/WThV2dvuraYrVxL3CazRfIb/Vxdyi3qg==
X-Google-Smtp-Source: AMrXdXv3jhAnLlQZspK/k3OVxEpxZdj7+RYjlT4MNoTfoXbrKcQt8G79bKWDfAGr034gTz3vKsMugiCiDXtxRlIhGHk=
X-Received: by 2002:a67:ec94:0:b0:3b5:32d0:edcc with SMTP id
 h20-20020a67ec94000000b003b532d0edccmr10096934vsp.24.1673441575070; Wed, 11
 Jan 2023 04:52:55 -0800 (PST)
MIME-Version: 1.0
References: <20230110180017.145591678@linuxfoundation.org> <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
 <bd62bccb-6970-4cdb-ae23-792b5867705d@app.fastmail.com> <CA+G9fYsChy=HzEwkBVydPW4gJhDjkB87dY9FA833H2tZLfSh-w@mail.gmail.com>
 <45e6c885-3035-4cd7-a4d0-69127814ef32@app.fastmail.com>
In-Reply-To: <45e6c885-3035-4cd7-a4d0-69127814ef32@app.fastmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 11 Jan 2023 18:22:43 +0530
Message-ID: <CA+G9fYvNsy=NVJw+79ecnhnKTtnEmOGLTAP_2mm6cUE4jaF8ZA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 11 Jan 2023 at 16:48, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Jan 11, 2023, at 10:31, Naresh Kamboju wrote:
> > On Wed, 11 Jan 2023 at 13:48, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Wed, Jan 11, 2023, at 07:16, Naresh Kamboju wrote:
> >> > On Tue, 10 Jan 2023 at 23:36, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > Yes, it ran successfully on 6.0.18.
> >
> > On the same kernel 6.0.19-rc1 built with gcc-12 did not find this panic.
> > The reported issue is specific to clang-15 build.

After retesting a couple of times it is confirmed that it is not reproducible.

> Ok, and was the 6.0.18 build using the exact same clang-15 toolchain,
> or could there have been an update to any of the tools?

it is same Clang version 15.0.6

> Have you seen results with older clang releases?

We are not testing with older clang versions.

>
> >> > [ 2893.044339] Insufficient stack space to handle exception!
> >> > [ 2893.044351] ESR: 0x0000000096000047 -- DABT (current EL)
> >> > [ 2893.044360] FAR: 0xffff8000128180d0
> >> > [ 2893.044364] Task stack:     [0xffff800012a18000..0xffff800012a1c000]
> >> > [ 2893.044370] IRQ stack:      [0xffff80000a798000..0xffff80000a79c000]
> >> > [ 2893.044375] Overflow stack: [0xffff0000f77c4310..0xffff0000f77c5310]
> >> ...
> >> > [ 2893.044413] pc : el1h_64_sync+0x0/0x68
> >> > [ 2893.044430] lr : wp_page_copy+0xf8/0x90c
> >> > [ 2893.044445] sp : ffff8000128180d0
> >> ...
> >> > [ 2893.044646]  panic+0x168/0x374
> >> > [ 2893.044658]  test_taint+0x0/0x38
> >> > [ 2893.044667]  panic_bad_stack+0x110/0x124
> >> > [ 2893.044675]  handle_bad_stack+0x34/0x48
> >> > [ 2893.044685]  __bad_stack+0x78/0x7c
> >> > [ 2893.044692]  el1h_64_sync+0x0/0x68
> >> > [ 2893.044700]  do_wp_page+0x4a0/0x5c8
> >> > [ 2893.044708]  handle_mm_fault+0x7fc/0x14dc
> >> > [ 2893.044718]  do_page_fault+0x29c/0x450
> >> > [ 2893.044727]  do_mem_abort+0x4c/0xf8
> >> > [ 2893.044741]  el0_da+0x48/0xa8
> >> > [ 2893.044750]  el0t_64_sync_handler+0xcc/0xf0
> >> > [ 2893.044759]  el0t_64_sync+0x18c/0x190
> >>
> >> It claims that the stack overflow happened in do_wp_page(),
> >> but that has a really short call chain. It would be good
> >> to have the source line for do_wp_page+0x4a0/0x5c8 and
> >> wp_page_copy+0xf8/0x90c to see where exactly it was.
> >>
> >> >   artifact-location:
> >> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBef3oR5JT
> >>
> >
> > Adding " / " at end works.
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2K9JDtix2mHMoYRjNkBef3oR5JT/
>
> Ok, I disassembled the image to see what happened.
>
> do_wp_page+0x4a0/0x5c8 is the call to wp_page_copy(), so I would
> guess the el1h_64_sync fault actually happened in that function.
>
> lr : wp_page_copy+0xf8/0x90c the return address from
> __mem_cgroup_charge(), but I suspect it's not where the fault
> happened either, just the last address that was in the
> link register.
>
> el1h_64_sync+0x0/0x68 is a "paciasp" pointer authentication
> instruction.
>
> __bad_stack is actually called from 'vectors', which has this
> code for calling el1h_64_sync, from kernel_ventry:
>
> ffff800008011200:       d10543ff        sub     sp, sp, #0x150
> ffff800008011204:       8b2063ff        add     sp, sp, x0
> ffff800008011208:       cb2063e0        sub     x0, sp, x0
> ffff80000801120c:       37700080        tbnz    w0, #14, ffff80000801121c <vectors+0x21c>
> ffff800008011210:       cb2063e0        sub     x0, sp, x0
> ffff800008011214:       cb2063ff        sub     sp, sp, x0
> ffff800008011218:       14000201        b       ffff800008011a1c <el1h_64_sync>
> ffff80000801121c:       d51bd040        msr     tpidr_el0, x0
> ffff800008011220:       cb2063e0        sub     x0, sp, x0
> ffff800008011224:       d51bd060        msr     tpidrro_el0, x0
> ffff800008011228:       f0010a80        adrp    x0, ffff80000a164000 <overflow_stack+0xcf0>
> ffff80000801122c:       910c401f        add     sp, x0, #0x310
> ffff800008011230:       d538d080        mrs     x0, tpidr_el1
> ffff800008011234:       8b2063ff        add     sp, sp, x0
> ffff800008011238:       d53bd040        mrs     x0, tpidr_el0
> ffff80000801123c:       cb2063e0        sub     x0, sp, x0
> ffff800008011240:       f274cc1f        tst     x0, #0xfffffffffffff000
> ffff800008011244:       54002de1        b.ne    ffff800008011800 <__bad_stack>  // b.any
> ffff800008011248:       cb2063ff        sub     sp, sp, x0
> ffff80000801124c:       d53bd060        mrs     x0, tpidrro_el0
> ffff800008011250:       140001f3        b       ffff800008011a1c <el1h_64_sync>
>
> and here I'm lost now.
>
>       Arnd
