Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5106C4FE50A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 17:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357246AbiDLPqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 11:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357177AbiDLPqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 11:46:32 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84E9B845
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:44:11 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id z33so33797554ybh.5
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 08:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tr9PBKtwF8uwxpVk+FAIjyu0P4+AAl4OjgCwV9dPuUk=;
        b=FBpU8iZrkesdxN5hege1QVCKw2GwQWoJeqo7hta2MSJUHT2hX/jY4/T2uTIN91Ci2f
         yJYPP5se3CJcfHE7rZndjKAD9xDCiCMveeeg1bmiRexKgxQ5aeEdPBqeTrXGIIOIApep
         1Gc2EQUyynrjTlEYC8DRlMwGfwSiq2mE82KBA9kJ0ShAVa58yxE2vcldInV28pJXQAyV
         DjyEVtey6YGKZBqiSjquLuWMm6sYergrT9hEkKmhf1AtCgt8AKIXrwlx3ep9pRIu/xFC
         DXVRc2eEE4A8PGgT+6VvpngUsKIKbdLkgRagzaLB9RYyJTJ80U40OtUjoCIS0yNiYrjJ
         Vk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tr9PBKtwF8uwxpVk+FAIjyu0P4+AAl4OjgCwV9dPuUk=;
        b=WfTnZ0kt7kGYVsMN4niDDAkuqvwHDuWEWIhLLODHI3UQATOlxCj4YoiSTJtkUV108c
         yA9BU4/z0syLLfO0IZmH3urBdEgHFmYe/jnZH3xknXtTTTm6W/NxGmhFdAmU/Jy7j8dr
         Aj7i2Zogy1ror8VZsPG+x/XWCcZ0zOFIXm7CsI/63vk5h4nM4xIignIHmpZuFGqU2U+z
         ke1TMMrlL0orlCfXG8F+g4FqEGt5E0alzqrGH3l+h9I8bnH0PnmhsMjqFMgQQ3yJ4Wno
         6JMtAAfEA+NadgKS3YMIevviy6wd90cfyoTrHwpkJYN1fwc1FWHryhcAclp0Pqug9Od/
         HfIA==
X-Gm-Message-State: AOAM530+n6v8lsIkwQF9jUAJcD9k+V6IGEvwlqinLOmOClP5ODzQ06ia
        yRCkIFZ2jlz8G5XFE1UZPgqO3Y/XZEqhcOa9ui6lFQ==
X-Google-Smtp-Source: ABdhPJwwQOZn8bktk+JMI7gRj6EbmLkfkWywdQIVdWcSjUAaN/fZLvVFnq2dQrWz2x1R4BWR7pO/68AY6/0C3pCpoH0=
X-Received: by 2002:a25:df53:0:b0:641:1f31:1d3d with SMTP id
 w80-20020a25df53000000b006411f311d3dmr12954621ybg.603.1649778250882; Tue, 12
 Apr 2022 08:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220412062942.022903016@linuxfoundation.org> <CA+G9fYseyeNoxQwEWtiiU8dLs_1coNa+sdV-1nqoif6tER_46Q@mail.gmail.com>
 <CANpmjNP4-jG=kW8FoQpmt4X64en5G=Gd-3zaBebPL7xDFFOHmA@mail.gmail.com>
In-Reply-To: <CANpmjNP4-jG=kW8FoQpmt4X64en5G=Gd-3zaBebPL7xDFFOHmA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Apr 2022 21:13:59 +0530
Message-ID: <CA+G9fYuJKsYMR2vW+7d=xjDj9zoBtTF5=pSmcQRaiQitAjXCcw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
To:     Marco Elver <elver@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marco

On Tue, 12 Apr 2022 at 20:32, Marco Elver <elver@google.com> wrote:
>
> On Tue, 12 Apr 2022 at 16:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 12 Apr 2022 at 12:11, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.34 release.
> > > There are 277 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > On linux stable-rc 5.15 x86 and i386 builds failed due to below error [1]
> > with config [2].
> >
> > The finding is when kunit config is enabled the builds pass.
> > CONFIG_KUNIT=y
> >
> > But with CONFIG_KUNIT not set the builds failed.
> >
> > x86_64-linux-gnu-ld: mm/kfence/core.o: in function `__kfence_alloc':
> > core.c:(.text+0x901): undefined reference to `filter_irq_stacks'
> > make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > I see these three commits, I will bisect and get back to you
> >
> > 2f222c87ceb4 kfence: limit currently covered allocations when pool nearly full
> > e25487912879 kfence: move saving stack trace of allocations into
> > __kfence_alloc()
> > d99355395380 kfence: count unexpectedly skipped allocations
>
> My guess is that this commit is missing:

This patch is missing Fixes: tag.

> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f39f21b3ddc7fc0f87eb6dc75ddc81b5bbfb7672

For your information, I have reverted the below commit and build pass.

kfence: limit currently covered allocations when pool nearly full

[ Upstream commit 08f6b10630f284755087f58aa393402e15b92977 ]

- Naresh

> Thanks,
> -- Marco
