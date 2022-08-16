Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9AB5959EF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbiHPLYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiHPLYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:24:07 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DD65A8BA
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:38:11 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f22so12893802edc.7
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=ufWvRN9ig8qXKLJ6sMdoAhRoS5NiZ0umrZmeYXNUY5s=;
        b=QuF2Lfk6MReyDHsaxgF/85u0jGVLqLsK8ayItl3rPam/yJAtUmrXJ6l7dNLdwknhPx
         bG0fT3PQHtz21qbt6AZcVAEx16zzSy6F3Lp+4uwJIOn3KRyvToVItcUg/e7+0Lq6j0/C
         xaC3diIpEWjI/aJFK060fn8NCe2k33wmMd1vdUNKJfvujoh09BzFt8GM6EwCyqksHI4+
         6sRMdDxNx5slwFiR2auEWqMkv1g/umNozk0pz2Vr5kw+tXcZ82qyX82wmfhao6iPNbNp
         j4OhEIyhdal7mdblVjID95D0NIR1Gz+xJBwqIIJacf77hJ2o3EPYZenls0qdtfmu2a6q
         eu6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=ufWvRN9ig8qXKLJ6sMdoAhRoS5NiZ0umrZmeYXNUY5s=;
        b=z/0xpm4IP3hZ3SpuvE+K9KVWjQwTPIXhWfcejdHcoKLcKxc9oAoJmORGZuBhDazW/b
         TY0MUvcL0N6FjsJqny5HZrbmO+09aE3362arX6WbS9C+ZES9MwSHxDfV8q4Zr+mulvjH
         sE6+x9IvhMk6cVR/c+N1kHg/XXhWZMMG0JPVNzM1IkznBqalS+9IgKq0RwHv3igzjfIJ
         mlsTDL12qg3LtOXJ2nC8w6OA0h7WPm0J3lzTOsHbgiOLQtspNgqja5J44ajp3dqdvlZ3
         sLUylPfXMAUSyKRlZgjDQGlhEFITo3j7xdLpL8ds7Covz8+f7QF/JTf+/RkEYbS0oCwt
         JW/A==
X-Gm-Message-State: ACgBeo2n8WU07IAIqSvqBRxUKADIGBBgSM6VVZxlVY95fOr1m1NehaDv
        K0ygrh47Halz4PQYJU5DrZgGHqV/FrxkLXe5XhJF0w==
X-Google-Smtp-Source: AA6agR7jrpvglEBPKJU86Ncb/LZLDpKhvskK8YPPsieEPva2vJg/OoTwz3v0IKbJTIFYRqmV38s7KXUHGji3dO26jz0=
X-Received: by 2002:a05:6402:447:b0:440:d482:495f with SMTP id
 p7-20020a056402044700b00440d482495fmr18656731edw.264.1660646289626; Tue, 16
 Aug 2022 03:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220815180439.416659447@linuxfoundation.org> <CA+G9fYtZP_rYnmRyLbMrxKPGtJuoOw4h412dJXBJnzab41CzUw@mail.gmail.com>
 <YvtNZuap/oCKVv9O@kroah.com>
In-Reply-To: <YvtNZuap/oCKVv9O@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Aug 2022 16:07:58 +0530
Message-ID: <CA+G9fYuqm1NzfhF2B8OXqcH8-c24ZA6UGv3Y94fYuyOKVgqaOQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Aug 2022 at 13:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 16, 2022 at 01:08:26PM +0530, Naresh Kamboju wrote:
> > On Tue, 16 Aug 2022 at 00:58, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.19.2 release.
> > > There are 1157 patches in this series, all will be posted as a respon=
se
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.19.2-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-5.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The arm64 clang-14 allmodconfig failed on stable-rc 5.19.
> > This build failure got fixed on the mainline tree two weeks ago.
> >
> > * arm64, build
> >   - clang-12-allmodconfig
> >   - clang-13-allmodconfig
> >   - clang-14-allmodconfig
> >   - clang-nightly-allmodconfig
> >
> >
> > make --silent --keep-going --jobs=3D8
> > O=3D/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=3D1 LLVM_IAS=3D1
> > ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- 'HOSTCC=3Dsccache clang=
'
> > 'CC=3Dsccache clang' allmodconfig
> > make --silent --keep-going --jobs=3D8
> > O=3D/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=3D1 LLVM_IAS=3D1
> > ARCH=3Darm64 CROSS_COMPILE=3Daarch64-linux-gnu- 'HOSTCC=3Dsccache clang=
'
> > 'CC=3Dsccache clang'
> > sound/soc/intel/avs/path.c:815:18: error: stack frame size (2192)
> > exceeds limit (2048) in 'avs_path_create'
> > [-Werror,-Wframe-larger-than]
> > struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
> >                  ^
> > 1 error generated.
> > make[5]: *** [/builds/linux/scripts/Makefile.build:249:
> > sound/soc/intel/avs/path.o] Error 1
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Steps to reproduce:
> > -------------------------
> > # See https://docs.tuxmake.org/ for complete documentation.
> > # Original tuxmake command with fragments listed below.
> > # tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
> > --kconfig allmodconfig LLVM=3D1 LLVM_IAS=3D1
> >
> > tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
> > --kconfig https://builds.tuxbuild.com/2DPEiUmdALSZq7DeNthZFYoPLaN/confi=
g
> > LLVM=3D1 LLVM_IAS=3D1
>
> What is the commit on mainline that resolved this issue?

commit 1e744351bcb9c4cee81300de5a6097100d835386
Author: Amadeusz S=C5=82awi=C5=84ski <amadeuszx.slawinski@linux.intel.com>
Date:   Fri Jul 22 13:19:59 2022 +0200

    ASoC: Intel: avs: Use lookup table to create modules

    As reported by Nathan, when building avs driver using clang with:
      CONFIG_COMPILE_TEST=3Dy
      CONFIG_FORTIFY_SOURCE=3Dy
      CONFIG_KASAN=3Dy
      CONFIG_PCI=3Dy
      CONFIG_SOUND=3Dy
      CONFIG_SND=3Dy
      CONFIG_SND_SOC=3Dy
      CONFIG_SND_SOC_INTEL_AVS=3Dy

    there are reports of too big stack use, like:
      sound/soc/intel/avs/path.c:815:18: error: stack frame size
(2176) exceeds limit (2048) in 'avs_path_create'
[-Werror,-Wframe-larger-than]
      struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
                       ^
      1 error generated.

    This is apparently caused by inlining many calls to guid_equal which
    inlines fortified memcpy, using 2 size_t variables.

    Instead of hardcoding many calls to guid_equal, use lookup table with
    one call, this improves stack usage.

    Link: https://lore.kernel.org/alsa-devel/YtlzY9aYdbS4Y3+l@dev-arch.thel=
io-3990X/T/
    Link: https://github.com/ClangBuiltLinux/linux/issues/1642
    Signed-off-by: Amadeusz S=C5=82awi=C5=84ski <amadeuszx.slawinski@linux.=
intel.com>
    Reported-by: Nathan Chancellor <nathan@kernel.org>
    Build-tested-by: Nathan Chancellor <nathan@kernel.org>
    Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
    Link: https://lore.kernel.org/r/20220722111959.2588597-1-amadeuszx.slaw=
inski@linux.intel.com
    Signed-off-by: Mark Brown <broonie@kernel.org>

- Naresh
