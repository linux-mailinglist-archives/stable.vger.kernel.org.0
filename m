Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF0E679759
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjAXMLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbjAXMLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:11:37 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C2842DFC
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 04:11:34 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id b81so7487131vkf.1
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 04:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dISAn78vCWS4e6xdAYVii8dXCJmdFpiXIP1pmSRbb/8=;
        b=ZLjWXwX3EYWpqYpHXvt912h/2ETFWRj0hqQqB9cwIGQR9I1ti6KmgBoCv5JV0E6NH+
         Ao2ZJYcXe2AOfsuXLtgZ9tSvuZztJ4nLvMRv0L+m7l5dtscd4wNcR8b+evAdvi6YSwBm
         J74A/HUMs3P+Q5V0OxK2IHgJ/pzRL9XZlIz6pcGiwjFElBvOmELb5dZ42o1ycTXMfB3j
         IcSsFeRx0f4jjxajJOXa2wb+ojQggPAr2lXXo/ZhkorUHf6Mrf2DfpAeaYTihBvQooDu
         FnIedSqwFO6bEEos2h+7Ra1xfBbLcZLVLI3OV68Gs/aDRTk9YZVUx46j3RGigz5EbpYJ
         361g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dISAn78vCWS4e6xdAYVii8dXCJmdFpiXIP1pmSRbb/8=;
        b=HWFfSkb3eBfRNDBDFrQq1sws+ZkNZh3qzy1cfeEMTkFAqKTYIC/RyrXt2bZ5AyC2s3
         /PWhbj1OmAV3ZO07FeBeR91iWTdbOVoGOzXrM2GhjH3DXVQtrL49W+Vb1hA9K8vMoStU
         WFrR63S/PXLZFSe+HDWUHlVDPGin362SNNUcAHJFTMISFYwWZk0NXCK/N3uS5S7LMGls
         YxAKbJ8JcKZPEUHRQRRwUYIw5FF1++6zJMjeXbw+jV7u8cvfEOCIi/gwbdPOhir83jMJ
         QXpJXNZzpC6ZU3FQY5hH8xiI85EOKWsjuuyFW9ZZ7gakWXJgjE71RGR+BLaQ0Uu0VQyx
         UwNA==
X-Gm-Message-State: AFqh2kpZzDYh25Wt08s0f4c6gk0PybwC3hD9D5IrZXv8kZFoCmukYnSc
        EvlvfDU2mWGY0/+X4Zdih44oID5Ccy7JwsiKUsCeDw==
X-Google-Smtp-Source: AMrXdXsEU8BFfIKrVdZYAVyNpNnFgFf89N+fSD9CVwbqX8GRUTMFkEfGPe87YRNQbrX7xxpbwpitSYIX8RT97AbGxdA=
X-Received: by 2002:a1f:45cb:0:b0:3e2:3d0:929c with SMTP id
 s194-20020a1f45cb000000b003e203d0929cmr1944766vka.30.1674562293562; Tue, 24
 Jan 2023 04:11:33 -0800 (PST)
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org> <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
 <20230123191128.ewfyc5cdbbdx5gtl@oracle.com> <20230123194218.47ssfzhrpnv3xfez@oracle.com>
In-Reply-To: <20230123194218.47ssfzhrpnv3xfez@oracle.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 24 Jan 2023 17:41:22 +0530
Message-ID: <CA+G9fYvLh=epzy_KEZObfFn1kVCugKvuVWF08X9eEiPe4ehe3g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Rich Felker <dalias@libc.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tom,

On Tue, 24 Jan 2023 at 01:12, Tom Saeger <tom.saeger@oracle.com> wrote:
>
> On Mon, Jan 23, 2023 at 01:11:32PM -0600, Tom Saeger wrote:
> > On Mon, Jan 23, 2023 at 01:39:11PM +0530, Naresh Kamboju wrote:
> > > On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
> > >
> > > Results from Linaro=E2=80=99s test farm.
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > * sh, build
> > >   - gcc-8-dreamcast_defconfig
> > >   - gcc-8-microdev_defconfig
> >
> > Naresh, any chance you could test again adding the following:
> >
> > diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.=
S
> > index 3161b9ccd2a5..b6276a3521d7 100644
> > --- a/arch/sh/kernel/vmlinux.lds.S
> > +++ b/arch/sh/kernel/vmlinux.lds.S
> > @@ -4,6 +4,7 @@
> >   * Written by Niibe Yutaka and Paul Mundt
> >   */
> >  OUTPUT_ARCH(sh)
> > +#define RUNTIME_DISCARD_EXIT
> >  #include <asm/thread_info.h>
> >  #include <asm/cache.h>
> >  #include <asm/vmlinux.lds.h>
> >
> >
> > My guess is build environment is using ld < 2.36??
> > and this is probably similar to:
> > a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with=
 GNU ld < 2.36")
> > 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
> >
> >
> > Regards,
> >
> > --Tom
> >
> > >
> > >
> > > Build error logs:
> > > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> > > defined in discarded section `.exit.text' of crypto/algboss.o
> > > `.exit.text' referenced in section `__bug_table' of
> > > drivers/char/hw_random/core.o: defined in discarded section
> > > `.exit.text' of drivers/char/hw_random/core.o
> > > make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux] Err=
or 1
>
>
> This is also occurring in latest upstream:

Right !
build/gcc-8-dreamcast_defconfig
build/gcc-8-microdev_defconfig

These build errors started from v6.2-rc2 on the mainline [1] & [2].

>
> =E2=9D=AF git describe HEAD
> v6.2-rc5-13-g2475bf0250de
>
> =E2=9D=AF tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --k=
config microdev_defconfig
>
> `.exit.text' referenced in section `__bug_table' of crypto/algboss.o: def=
ined in discarded section `.exit.text' of crypto/algboss.o
> `.exit.text' referenced in section `__bug_table' of drivers/char/hw_rando=
m/core.o: defined in discarded section `.exit.text' of drivers/char/hw_rand=
om/core.o
> make[2]: *** [/home2/tsaeger/linux/linux-upstream/scripts/Makefile.vmlinu=
x:35: vmlinux] Error 1
> make[2]: Target '__default' not remade because of errors.
> make[1]: *** [/home2/tsaeger/linux/linux-upstream/Makefile:1264: vmlinux]=
 Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:242: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
>
>
> FWIW, the above patch resolves this.
Yes. Tested and confirmed it fixes the reported problem.

> How many more architectures need something similar?
Now I see it on sh with gcc-8 only on the mainline.

OTOH,
It was noticed on earlier stable-rc 5.4 for x86, i386, powerpc, sh and s390=
.

git_describe : v5.4.228-679-g79cbaf4448f3
kernel_version: 5.4.230-rc1

Regressions found on sh: [1] & [2] mainline and below
    - build/gcc-8-dreamcast_defconfig
    - build/gcc-8-microdev_defconfig

Regressions found on i386: [3]
    - build/gcc-8-i386_defconfig

Regressions found on powerpc:  [4]
    - build/gcc-8-mpc83xx_defconfig
    - build/gcc-8-ppc64e_defconfig
    - build/gcc-8-maple_defconfig
    - build/gcc-8-ppc6xx_defconfig
    - build/gcc-8-defconfig
    - build/gcc-8-tqm8xx_defconfig
    - build/gcc-8-cell_defconfig

Regressions found on s390: [5]
    - build/gcc-8-defconfig-fe40093d

Regressions found on x86_64: [6]
    - build/gcc-8-x86_64_defconfig


[1] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.2-rc5=
-20-g7bf70dbb1882/testrun/14340424/suite/build/test/gcc-8-microdev_defconfi=
g/history/?page=3D3
[2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.2-rc5=
-20-g7bf70dbb1882/testrun/14340393/suite/build/test/gcc-8-dreamcast_defconf=
ig/history/?page=3D3

[3] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5=
.4.228-679-g79cbaf4448f3/testrun/14304065/suite/build/test/gcc-8-i386_defco=
nfig/history/
[4] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5=
.4.228-679-g79cbaf4448f3/testrun/14304362/suite/build/tests/
[5] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5=
.4.228-679-g79cbaf4448f3/testrun/14304530/suite/build/tests/
[6] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5=
.4.228-679-g79cbaf4448f3/testrun/14304610/suite/build/test/gcc-8-x86_64_def=
config/history/

stable-rc report on 5.4:
https://lore.kernel.org/stable/Y85tO%2FmJOxIaWH4c@debian/T/#m6b1fdc9bcfc159=
44e26e3cdd6b1310c878251999

Best regards
Naresh Kamboju
