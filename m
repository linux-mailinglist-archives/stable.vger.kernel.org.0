Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E6226A76E
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgIOOpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbgIOOpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 10:45:02 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8E4C061788
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 07:44:46 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id q13so892702vkd.0
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 07:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zT4idoY3GXU6AKl9P1KDotBGRD6i9BlOD/Yn8HDxrN8=;
        b=cZcT/XO2v6Dw0s2Q7AzR/zkwbrn4Ls20hHCTCwjhdEm4E90JV0hcQRXDXeZO0/79hQ
         aF+uMGX1TJIcuD68ObaYkd9bA7Qdk0HFRWwA/rZBI/5tw6+sCym7qpOxSaA1MKQzKvA+
         PKT/I2wOPNx697M0Kt0AyARG4MwGHIMriU4Y05nxMvOVLHijn/kzh8bV9Lmyfx5IX6ls
         rO3tL24NeY+O0sTDx89AZcGI995Ai5XwqYKMrD8Arrvow+1WyE8b+lLmjZzvByom/hw5
         jE0q04luXWatzViaRyWafy86MVsVozNRTnWLmGTUMkBfAricswHoyVpHKVc9XAVxLIke
         RGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zT4idoY3GXU6AKl9P1KDotBGRD6i9BlOD/Yn8HDxrN8=;
        b=c/hE3SfiWFK4uHAtY7JUKtSBO46+yxIuBZwJS5h2Aw+Q6I7Wy35qXqvbO8t6emrgHb
         vomFKd75ZTv0f7oc2lEFL1EZ79jPFBtwmd3mGKkXDaHqTzMFx48YQ9wAQvtLxoT+XOlR
         LIrmqUn5D1Xy0ql1rXvkHNNIt+e6rnTfwr2FmM1L/aNLQjCnLFsy+v2Fjg8C3gWDI5bR
         jL43AC9ZgR4r3JnCA40wC7ybclE9luE6Zobfg+2fgTAkgp4Bl/jOVSWXG9zR2CccwiI3
         5q+BriRSSXAF+NlLqssMsv+DZRxpnR6dz+V1J4damgt2UM7amPGUAKcfYlE13pbiFggt
         GPAg==
X-Gm-Message-State: AOAM5317oV70hK3reSVdlAnX95tKG2nSZaomrbWbH1Sa37x4PQdaz/Qz
        TR2pkP5lbC21gSPmDu6YQA7HU8wUSpc+JsluTHlJJw==
X-Google-Smtp-Source: ABdhPJz9V+xdlRF8ie6wyANpoDEf4gTRpkJcbnRPg71Sjm27NaLv4OKg5H8hiYkDipcT92cxG4GzEtlmJZG5SuY43QQ=
X-Received: by 2002:a1f:7882:: with SMTP id t124mr1612757vkc.22.1600181085580;
 Tue, 15 Sep 2020 07:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200915140644.037604909@linuxfoundation.org>
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Sep 2020 20:14:34 +0530
Message-ID: <CA+G9fYv5hvOYNdfX6F40aZPP9Vr6aEsP_-22gX2P+Q95TrfF-A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/132] 5.4.66-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        freedreno <freedreno@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 15 Sep 2020 at 19:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.66 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.66-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

arm and arm64 build breaks on stable rc 5.4.

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm
CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dgcc CC=3D"sccache
arm-linux-gnueabihf-gcc" O=3Dbuild zImage
#
../kernel/kprobes.c: In function =E2=80=98kill_kprobe=E2=80=99:
../kernel/kprobes.c:1081:33: warning: statement with no effect [-Wunused-va=
lue]
 1081 | #define disarm_kprobe_ftrace(p) (-ENODEV)
      |                                 ^
../kernel/kprobes.c:2113:3: note: in expansion of macro =E2=80=98disarm_kpr=
obe_ftrace=E2=80=99
 2113 |   disarm_kprobe_ftrace(p);
      |   ^~~~~~~~~~~~~~~~~~~~
#
# make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm
CROSS_COMPILE=3Darm-linux-gnueabihf- HOSTCC=3Dgcc CC=3D"sccache
arm-linux-gnueabihf-gcc" O=3Dbuild modules
#
../drivers/gpu/drm/msm/adreno/a5xx_preempt.c: In function =E2=80=98preempt_=
init_ring=E2=80=99:
../drivers/gpu/drm/msm/adreno/a5xx_preempt.c:235:21: error:
=E2=80=98MSM_BO_MAP_PRIV=E2=80=99 undeclared (first use in this function)
  235 |   MSM_BO_UNCACHED | MSM_BO_MAP_PRIV, gpu->aspace, &bo, &iova);
      |                     ^~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a5xx_preempt.c:235:21: note: each
undeclared identifier is reported only once for each function it
appears in
make[5]: *** [../scripts/Makefile.build:266:
drivers/gpu/drm/msm/adreno/a5xx_preempt.o] Error 1
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c: In function =E2=80=98a6xx_hw_init=
=E2=80=99:
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:414:6: error: implicit
declaration of function =E2=80=98adreno_is_a640=E2=80=99; did you mean
=E2=80=98adreno_is_a540=E2=80=99? [-Werror=3Dimplicit-function-declaration]
  414 |  if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
      |      ^~~~~~~~~~~~~~
      |      adreno_is_a540
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:414:36: error: implicit
declaration of function =E2=80=98adreno_is_a650=E2=80=99; did you mean
=E2=80=98adreno_is_a540=E2=80=99? [-Werror=3Dimplicit-function-declaration]
  414 |  if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
      |                                    ^~~~~~~~~~~~~~
      |                                    adreno_is_a540
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:415:18: error:
=E2=80=98REG_A6XX_GBIF_QSB_SIDE0=E2=80=99 undeclared (first use in this fun=
ction)
  415 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE0, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:415:18: note: each undeclared
identifier is reported only once for each function it appears in
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:416:18: error:
=E2=80=98REG_A6XX_GBIF_QSB_SIDE1=E2=80=99 undeclared (first use in this fun=
ction)
  416 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE1, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:417:18: error:
=E2=80=98REG_A6XX_GBIF_QSB_SIDE2=E2=80=99 undeclared (first use in this fun=
ction)
  417 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE2, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:418:18: error:
=E2=80=98REG_A6XX_GBIF_QSB_SIDE3=E2=80=99 undeclared (first use in this fun=
ction)
  418 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE3, 0x00071620);
      |                  ^~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[5]: *** [../scripts/Makefile.build:265:
drivers/gpu/drm/msm/adreno/a6xx_gpu.o] Error 1
In file included from ../drivers/gpu/drm/msm/msm_gpu.c:7:
../drivers/gpu/drm/msm/msm_gpu.c: In function =E2=80=98msm_gpu_init=E2=80=
=99:
../drivers/gpu/drm/msm/msm_gpu.h:330:22: error: =E2=80=98MSM_BO_MAP_PRIV=E2=
=80=99
undeclared (first use in this function)
  330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
      |                      ^~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/msm_gpu.c:935:3: note: in expansion of macro
=E2=80=98check_apriv=E2=80=99
  935 |   check_apriv(gpu, MSM_BO_UNCACHED), gpu->aspace, &gpu->memptrs_bo,
      |   ^~~~~~~~~~~
../drivers/gpu/drm/msm/msm_gpu.h:330:22: note: each undeclared
identifier is reported only once for each function it appears in
  330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
      |                      ^~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/msm_gpu.c:935:3: note: in expansion of macro
=E2=80=98check_apriv=E2=80=99
  935 |   check_apriv(gpu, MSM_BO_UNCACHED), gpu->aspace, &gpu->memptrs_bo,
      |   ^~~~~~~~~~~
make[5]: *** [../scripts/Makefile.build:266:
drivers/gpu/drm/msm/msm_gpu.o] Error 1
In file included from ../drivers/gpu/drm/msm/msm_ringbuffer.c:8:
../drivers/gpu/drm/msm/msm_ringbuffer.c: In function =E2=80=98msm_ringbuffe=
r_new=E2=80=99:
../drivers/gpu/drm/msm/msm_gpu.h:330:22: error: =E2=80=98MSM_BO_MAP_PRIV=E2=
=80=99
undeclared (first use in this function)
  330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
      |                      ^~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/msm_ringbuffer.c:30:3: note: in expansion of
macro =E2=80=98check_apriv=E2=80=99
   30 |   check_apriv(gpu, MSM_BO_WC | MSM_BO_GPU_READONLY),
      |   ^~~~~~~~~~~
../drivers/gpu/drm/msm/msm_gpu.h:330:22: note: each undeclared
identifier is reported only once for each function it appears in
  330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
      |                      ^~~~~~~~~~~~~~~
../drivers/gpu/drm/msm/msm_ringbuffer.c:30:3: note: in expansion of
macro =E2=80=98check_apriv=E2=80=99
   30 |   check_apriv(gpu, MSM_BO_WC | MSM_BO_GPU_READONLY),
      |   ^~~~~~~~~~~
make[5]: *** [../scripts/Makefile.build:265:
drivers/gpu/drm/msm/msm_ringbuffer.o] Error 1
make[5]: Target '__build' not remade because of errors.
make[4]: *** [../scripts/Makefile.build:500: drivers/gpu/drm/msm] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [../scripts/Makefile.build:500: drivers/gpu/drm] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [../scripts/Makefile.build:500: drivers/gpu] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1729: drivers] Error 2
make[1]: Target 'modules' not remade because of errors.
make: *** [Makefile:179: sub-make] Error 2
make: Target 'modules' not remade because of errors.


--=20
Linaro LKFT
https://lkft.linaro.org
