Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF81F3EBEF0
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 02:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbhHNATg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 20:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbhHNATg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 20:19:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DF7C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 17:19:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a5so14097844plh.5
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 17:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bbV9GFNJfndGOr2V+P6jjI3cwFViFX1wwPDtGPpuS7U=;
        b=lRTIdeeNxlYuq0zWl6Jbc6Y/DFaK94o8jlLg2NIzrRuTtC++JygbHTFYhm5kZP5ROa
         Xzd8b3UNw9AAV++34LnPjG9133xWA74dCW4+ivRxUpX5ZiQMRWigVSm9YG12oDOsTYyW
         izVt/uxU2mhrM632bQvLuODT6pQlfGfDXpMbRvocQuWLWnLPUIDVXHmF0XlmU6tuSTNK
         ro9YZTKBdV2r6D7euFv+1ZMsIQ1vcjOOBZhsr0nDEjT1EKYZzJHBBcB5C9hSTa527283
         7hYKP/IE4X7wFaO1jCDZMnt68xixtKjuUv6Iq1IF4LcmOuz4urga5nVrSDx4BYz8tG+Q
         91uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bbV9GFNJfndGOr2V+P6jjI3cwFViFX1wwPDtGPpuS7U=;
        b=R+JJtFMhhXjbtZ8zEFOIwUte9WTnPafCoqOHJNGeFbM8DIvAAII40csgVaE7/hK7bv
         jh53h6Mr25P5OB1OF2yrsQ7yDWmqGFtp4SsR+hJOQnhg2GtNh/sZotv6lIYYeD75/94G
         IUTU0HPh0vVIr3ygFHVnJdc36mcYXig9okF6tcWialBDLjBAvtKIi+FVCsC0J99A9rO2
         9B5FWeTL2x6wBDwD+2Rm5Z9CgURUxMVpc2BMxpZ6GkRppqUMpQFtO2sQn9HlMhHHWKnw
         pFStTTuYH9vZiAu7Z3c6B8Q4hExjJLxdgVc1rAtF0Z16uRRdSebu4kh9kkUm9RKTugTC
         P2Dg==
X-Gm-Message-State: AOAM531Wz4enjxndJKZxeNCkT4/coAFU+j105fdDNKtBl9EvoM569KVS
        yiliQorR4yOL3RoboQraq7rZptjiiVoXNIm7
X-Google-Smtp-Source: ABdhPJxcv9VNsiBhPTqlOs7SUTTeqU7bAoE8yzWYHo5qqnXKogDyV3/9uz3qxUgEIEdxQ05zISEbAQ==
X-Received: by 2002:a05:6a00:1904:b029:3b9:e4ea:1f22 with SMTP id y4-20020a056a001904b02903b9e4ea1f22mr4909416pfi.79.1628900348400;
        Fri, 13 Aug 2021 17:19:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y64sm4033025pgy.32.2021.08.13.17.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 17:19:08 -0700 (PDT)
Message-ID: <61170bfc.1c69fb81.e7113.b125@mx.google.com>
Date:   Fri, 13 Aug 2021 17:19:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-183-g0c8c94131509
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 159 runs,
 4 regressions (v5.13.9-183-g0c8c94131509)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 159 runs, 4 regressions (v5.13.9-183-g0c8c94=
131509)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx6sx-sdb           | arm   | lab-nxp      | gcc-8    | multi_v7_defconfig=
 | 1          =

imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig         =
 | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-8    | defconfig         =
 | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.9-183-g0c8c94131509/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.9-183-g0c8c94131509
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c8c94131509e58f376d0f0b566621346b3c8c1e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx6sx-sdb           | arm   | lab-nxp      | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6116d86e81803d61bdb136da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
83-g0c8c94131509/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
83-g0c8c94131509/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116d86e81803d61bdb13=
6db
        new failure (last pass: v5.13.9-176-gc85d412c71cc) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6116d94f663c2d636db13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
83-g0c8c94131509/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
83-g0c8c94131509/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116d94f663c2d636db13=
667
        failing since 7 days (last pass: v5.13.8-33-gd8a5aa498511, first fa=
il: v5.13.8-35-ge21c26fae3e0) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-8    | defconfig         =
 | 2          =


  Details:     https://kernelci.org/test/plan/id/6116d7d0ab58b28adeb136c2

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
83-g0c8c94131509/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
83-g0c8c94131509/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-odr=
oid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6116d7d0ab58b28=
adeb136c6
        new failure (last pass: v5.13.9-176-gc85d412c71cc)
        8 lines

    2021-08-13T20:36:07.638388  kern  :alert : Mem<8>[   15.694626] <LAVA_S=
IGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D8>
    2021-08-13T20:36:07.638675   abort info:
    2021-08-13T20:36:07.638863  kern  :alert :   ESR =3D 0x8600000e
    2021-08-13T20:36:07.639029  kern  :alert :   EC =3D 0x21: IABT (current=
 EL), IL =3D 32 bits
    2021-08-13T20:36:07.639190  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-08-13T20:36:07.639345  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-08-13T20:36:07.639497  kern  :alert : <8>[   15.720036] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
2>
    2021-08-13T20:36:07.639650  swapper pg<8>[   15.729364] <LAVA_SIGNAL_EN=
DRUN 0_dmesg 688520_1.5.2.4.1>
    2021-08-13T20:36:07.639804  table: 4k pages, 48-bit VAs, pgdp=3D0000000=
0026ab000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6116d7d0ab58b28=
adeb136c7
        new failure (last pass: v5.13.9-176-gc85d412c71cc)
        2 lines =

 =20
