Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E30677596
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjAWH2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjAWH2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:28:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB411716A;
        Sun, 22 Jan 2023 23:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 098CDB80BFB;
        Mon, 23 Jan 2023 07:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767CC433B3;
        Mon, 23 Jan 2023 07:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674458912;
        bh=tDZSyDGWUdOFrSfldiEN29lT3lN2KENZc5nb4MvHF78=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IsP0wjxDEnFHvne1OyWxEIrR+cVRvkUSvZAuvBG8Y5Lmf1q12/B3Yuyvtu3Hmv8G7
         fZ9mRPHO7EjkX+faagLXYDpQENaQNOPKLEObyPSWVKHL/GA++/Iinh967Ae9l13reA
         fQtMljmoylteB+aIC8v4oeuegX4gffeyea/7w/f0tgEAQIN4+zYhQNAPLUVZCWBCVd
         E+83tMYuk7ZlzxR428SXUTG2znRE9vT98AlcRqnleOSiWxW/mJy2C5kKLDxhozm7fj
         VZQokaquQNmMu4P+oFRNiwXVG5Qha9pYullUApeVyDfBSbsxpxRo7yqizZutKeyVZb
         RJbbaaIP9gUNw==
Received: by mail-lf1-f50.google.com with SMTP id o20so16837727lfk.5;
        Sun, 22 Jan 2023 23:28:32 -0800 (PST)
X-Gm-Message-State: AFqh2kq86YMNjTToSF/WXruVGLWYnleRzgO+xFSoYslkkoZcBh9vzm1G
        F5hClmvsxWRGLy4oh3Ms7phJRfiFcQYLDOXVU4k=
X-Google-Smtp-Source: AMrXdXuwSrrvsm09tpsZA2C2PMEHa2dTiiOyrGKO8XhtVl4LMbWCyJAWnz611NXzHAoNEMS28NhTboUYuypfamEuWXA=
X-Received: by 2002:a05:6512:118a:b0:4cc:9d69:4703 with SMTP id
 g10-20020a056512118a00b004cc9d694703mr2418365lfr.110.1674458910440; Sun, 22
 Jan 2023 23:28:30 -0800 (PST)
MIME-Version: 1.0
References: <20230122150232.736358800@linuxfoundation.org> <CA+G9fYsEvpCj_vSFLxkKA6tzdNOhimqZYF+WCLKYAiNLtrMvsA@mail.gmail.com>
 <Y842R2KIhUL9XMUi@kroah.com>
In-Reply-To: <Y842R2KIhUL9XMUi@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 23 Jan 2023 08:28:18 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF02H87N4NsPWCdjdkGz-D_EQVMxbN3=btgzr5F=P0eRQ@mail.gmail.com>
Message-ID: <CAMj1kXF02H87N4NsPWCdjdkGz-D_EQVMxbN3=btgzr5F=P0eRQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 Jan 2023 at 08:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 23, 2023 at 12:39:55PM +0530, Naresh Kamboju wrote:
> > On Sun, 22 Jan 2023 at 20:46, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.90 release.
> > > There are 117 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.15.90-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build regressions found on sh:
> >    - build/gcc-8-dreamcast_defconfig
> >    - build/gcc-8-microdev_defconfig
> >
> >
> > Build error logs:
> >
> > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> > defined in discarded section `.exit.text' of crypto/algboss.o
> > `.exit.text' referenced in section `__bug_table' of
> > drivers/char/hw_random/core.o: defined in discarded section
> > `.exit.text' of drivers/char/hw_random/core.o
> > make[1]: *** [/builds/linux/Makefile:1218: vmlinux] Error 1
> >
> > Bisection points to this commit,
> >     arch: fix broken BuildID for arm64 and riscv
> >     commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> >
> > Ref:
> > upstream discussion thread,
> > https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
>
> Argh, what a mess.  Ok, let me rip out that commit (and the "fixes up
> that commit") series from the trees and push out a -rc2 in a few hours
> after I wake up.  I was worried about that one, and I should have
> trusted my first instinct...
>

The patch in question has

    Fixes: 994b7ac1697b ("arm64: remove special treatment for the link
order of head.o")
    Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link
order of head.o")

both of which were introduced in the current v6.2 cycle.

Neither of those are marked for stable, are obviously non-stable
material, and were not queued up themselves.

So how did we end up queuing these in the first place?
