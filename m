Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC57B3D9AC6
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 03:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhG2BEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 21:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhG2BEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 21:04:46 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACDEC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 18:04:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so12896850pja.5
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 18:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=THie/EcxDbHI5YakBHXaIHtnsx+jNrGkesv6IDdklCI=;
        b=unSEQCaMqsPihUWqRIB7jGcSQX/BeIEwEaSimppMpuXF7/OqOgaqaseHW4F5abUPT6
         UEyx08rzQ/OX6DW9Q/HZ/bWU2lHWMhxHA0q4TJIaENqGDQ5ucFMX17GjSSxXavN2Lw5n
         t9FFc3x00ffQGPlkK/Mw3WWmSc3LcETO6/h/V/qWz1TzLVNuX528eYiVmwuaV8hBczc8
         tz4opA1w0J3OY3Kw+TPjWOZVp8ai1a6JhpmrX4hQai6W3AWdW70HYDBf1+9j54yryvkK
         lXp4XOcVhBsqfgIaWzlgIrzpF8CWzFyB7zJKoRsXPGZCWXCxxChr/STq0Ea+db/rTJGc
         mwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=THie/EcxDbHI5YakBHXaIHtnsx+jNrGkesv6IDdklCI=;
        b=nRzBOoyKMub9aBqaUs2JgMy6cughmvqXoEv0Rc5B3+GlAONHMq6kXAOI/CcgNuRjJl
         2Fc669o9rAJEgeuvnYokXyEVhyxtUGpWMgsT7Mcc8/Trcg65aWKTQdQQACIUezOiS3pw
         rdfyp3VHuFGrP8YDTpob/BbCplBrFvhk4FYEvtdzeufGMbM/cIUw/0mCRzhgHQWFK9lV
         WPuUE0ySgQlIJ5J3BIcMOE/OpnKBhed7AFXSN8+asiUEJqex1i1R89ges9Pb5xr2dj7M
         qv9W0wN7zJvC+YRhsvk+w+n1/Jpl9AAaBA8IumX2wzLV3RAgiBSjQye7GusAYJpv3KpW
         FTcA==
X-Gm-Message-State: AOAM5306mqwfzxIi8V5VR9Pf2SNFkuq8RHrAyRVx6qj9gdcDQmvZyDtj
        c8SbF5ciXo5w71poTmYGIehQnLPfpjpp7YTM
X-Google-Smtp-Source: ABdhPJyypAW2/y5r1CT7KA1OCLJw4jDP1g6+0YnWdaFkW8g6mt0mONyZO3yz7TuNN7Br5TgcnbEkfQ==
X-Received: by 2002:a63:4f50:: with SMTP id p16mr1017523pgl.378.1627520682561;
        Wed, 28 Jul 2021 18:04:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm1363612pfk.61.2021.07.28.18.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 18:04:42 -0700 (PDT)
Message-ID: <6101feaa.1c69fb81.5df89.586c@mx.google.com>
Date:   Wed, 28 Jul 2021 18:04:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.199-2-g6e7bdd8caac9
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 3 regressions (v4.19.199-2-g6e7bdd8caac9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 135 runs, 3 regressions (v4.19.199-2-g6e7bdd=
8caac9)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.199-2-g6e7bdd8caac9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.199-2-g6e7bdd8caac9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e7bdd8caac982ed68af7d58c6d5ffffb420f485 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101c46cf19c51ea875018c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-2-g6e7bdd8caac9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-2-g6e7bdd8caac9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101c46cf19c51ea87501=
8c8
        failing since 257 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101c477f01ca0bf645018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-2-g6e7bdd8caac9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-2-g6e7bdd8caac9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101c477f01ca0bf64501=
8c3
        failing since 257 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6101c459e7274505ac5018d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-2-g6e7bdd8caac9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-2-g6e7bdd8caac9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101c459e7274505ac501=
8d7
        failing since 257 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
