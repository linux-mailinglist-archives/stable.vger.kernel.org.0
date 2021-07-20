Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB23CF2A7
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 05:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbhGTCwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 22:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346735AbhGTCwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 22:52:10 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CA8C0613AC
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 20:31:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c15so10775346pls.13
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 20:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQBjU9I7PnfsxgjZVY2becjI4EvqvqLliwUO9ki6C9M=;
        b=afBxCO6CLATfmwCOC499VPu5BkV1L2PviGN2FDNcpEoV9ks82PdS3+LEDII1tz7KJQ
         SICZYgBFbTYOyw5R01EeaD1vmweMH1k78YiBlU7Dgx01fwn/NxGZFaay9dU+PL7USwtw
         I0Enh8JzfLVTweqMjIq8ZNPSEV8YPdUs2Lm6fQTjoQLKtAiWKCCYTept/Q3I/bM/9ocL
         7nuc6IPt1D5YItts7Z2vbXmwEEmgNPQqT3njv9lZQF98f5Smf+dmg2k4yNZcnPdwm76w
         6Ndxy8R0T7pxQZA9L8PXowqKthPQw7aFSnCWMUTJYYMGHLwd4f4IQuKfleFjxgG6wlDc
         KYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQBjU9I7PnfsxgjZVY2becjI4EvqvqLliwUO9ki6C9M=;
        b=oovLmqbFWtrj1DP9UX9DaJ261QD6ZJREs31pzg9gVGazbd2MQnoMB9QriT0W/hstHY
         RC2k7UxidC1n6hAB0UyG6jo/Ft99O3WOJfaiFfLcFlS/mEiMlb+//cfhICTr5HLW1M3j
         M+RJ0fJKssSDBLZXphqOF+anBPydN2iCybHNR1eFnbkY1Vpwd2h25VrwHC1aNKLvSMc+
         mKsVcbgxn0K23ojncSsln3q1/5WHJY/s8GJerzdFIUmTsW14w7aCf7VGofvhDleKEJRC
         IwuhPcelfqA43avg79zq5OWsIW91jACg54/tcRIOKELO353DcxCEwHYKVegYePmY/mHy
         2Ssg==
X-Gm-Message-State: AOAM532b7Re0hzK6rZarDKUlI5gJ/ROqV//2Ud7yDC3o21+BMxlJMMlW
        T+gIFNglbc8bCWCrWk+WPxoQZSW6uxqspA==
X-Google-Smtp-Source: ABdhPJzxdEMzUFAO7cWEvDbmb2yuZWlsboEDH6JGe3rB/nEtD7URhAtwSczD2HS6fXDcYf6P1p0K/Q==
X-Received: by 2002:a17:90a:c003:: with SMTP id p3mr27671653pjt.14.1626751878177;
        Mon, 19 Jul 2021 20:31:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y35sm13523321pfa.34.2021.07.19.20.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 20:31:17 -0700 (PDT)
Message-ID: <60f64385.1c69fb81.ad1a6.8a8b@mx.google.com>
Date:   Mon, 19 Jul 2021 20:31:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.239-315-gb65a6ff8a80a9
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 147 runs,
 7 regressions (v4.14.239-315-gb65a6ff8a80a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 7 regressions (v4.14.239-315-gb6=
5a6ff8a80a9)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-q200        | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.239-315-gb65a6ff8a80a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.239-315-gb65a6ff8a80a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b65a6ff8a80a903dcdbbd03ed035f9047517d296 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60f60cd16aa15884191160ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-=
sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-=
sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f60cd16aa1588419116=
0ad
        failing since 360 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60f60c92d5c015b49111609c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxb=
b-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxb=
b-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f60c92d5c015b491116=
09d
        failing since 475 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-q200        | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60f638241f45e360d21160b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm=
-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm=
-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f638241f45e360d2116=
0b7
        failing since 116 days (last pass: v4.14.226-44-gdbfdb55a0970, firs=
t fail: v4.14.227) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f608f4be517ed4691160a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f608f4be517ed469116=
0a8
        failing since 247 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f608ecf5aabce43f116109

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f608ecf5aabce43f116=
10a
        failing since 247 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f60902adad979f5e1160e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f60902adad979f5e116=
0e9
        failing since 247 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6121e1922de73f71160b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
39-315-gb65a6ff8a80a9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6121e1922de73f7116=
0b9
        failing since 247 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
