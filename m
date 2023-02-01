Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50821686594
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 12:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjBALwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 06:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBALwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 06:52:22 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D14962261
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 03:52:11 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id ay1so12319306pfb.7
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 03:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dU/uHlzuYh6DlyOYEHeSz7EN8bM5HNCvxx/jCSLwAzI=;
        b=NykfaNQuQot4xKgM447mTfYXt2jfzGpT+pJMkkoUQu1JKh2owELnmfD0nzbxTr+XFF
         PoXD1DdfSlpneYrBzpirw+guJHHxLjJ7HI4owiMwqwXKIxdaHqvBUmniTgK58Mlo54gp
         KdxlRqNEpE4d7xuQYOmSh9pL039//z6Biaze/+3CXtwgX+TDn+2ceofyhUwot2TIP+9x
         TozNYviHbdTG48TZewZh5ucI17Mg0cpNQJI7W5xEmcqJM6ECDQ8mwkC8Si9enXIlEVpM
         sz3OjBddfzlpPBAajz4q5YqT+8sBbjY1K+iKFvS0gkltJrNlSMOu57WfzBRoEU9uB/3G
         p7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dU/uHlzuYh6DlyOYEHeSz7EN8bM5HNCvxx/jCSLwAzI=;
        b=ZQYlEofBTteAK0bdhIVolPAs9oZvfW9nHfqVN97CAfsVT0h29SfJ2EESaqVmJ/P5+g
         bAs5pOTOPJhRGURlnx8LEz0cztwvIN0f2mTQbjuS91kpTdsLVAP/s8IXL+iH660jEFGF
         t/y0HxOOIxhvU/o8hNFQp+Uyy6ffU8Qyyx2jcI10FoP8RpR+d+/Sohjb6kazuFRoCnJc
         gQm8UN66Aa3tAEGdMU1ormqKikYnwcjjYJYUnj60dDWBxGZXcDGDkikCl9xkM2eyRVsY
         RdTh8VcRrUUl315EqalMfZrL1TvXNi46vlg2Lc/taqq/bdijMCjy7NjoP7e18e1TTe0d
         u7ow==
X-Gm-Message-State: AO0yUKWGpfB8VxPwXpU9L2cCKhKjbzzOGoeFNNUM5ZzBXPFpNk3yZnV0
        u1DXbLbobnoCo9XqPtrueBYcHxEpyEmFCTJg9D2vyg==
X-Google-Smtp-Source: AK7set+of0uPkatZdO3hHvcKcsYUUr4vB58x0n5Ie953o2ZTdc/fy9kVxSeT/JNI83dacdmU/hZ48Q==
X-Received: by 2002:a05:6a00:22d6:b0:593:bc80:2d2d with SMTP id f22-20020a056a0022d600b00593bc802d2dmr2720978pfj.17.1675252330440;
        Wed, 01 Feb 2023 03:52:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1-20020aa79f01000000b005815017d348sm11628596pfr.179.2023.02.01.03.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 03:52:10 -0800 (PST)
Message-ID: <63da526a.a70a0220.12436.4a8f@mx.google.com>
Date:   Wed, 01 Feb 2023 03:52:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.166
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 153 runs, 6 regressions (v5.10.166)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 153 runs, 6 regressions (v5.10.166)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
at91-sama5d4_xplained  | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

rk3328-rock64          | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.166/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.166
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8d823aaa220eebec88c9f307225d3e163252ea95 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
at91-sama5d4_xplained  | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63da2003967afc7f78915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-sama5d4_xplained.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-sama5d4_xplained.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63da2003967afc7f78915=
eba
        new failure (last pass: v5.10.165) =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63da1eb1f1d458ddcc915ed4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da1eb1f1d458ddcc915ed9
        failing since 13 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-02-01T08:11:13.065366  <8>[   10.955381] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3262693_1.5.2.4.1>
    2023-02-01T08:11:13.175708  / # #
    2023-02-01T08:11:13.279344  export SHELL=3D/bin/sh
    2023-02-01T08:11:13.280682  #
    2023-02-01T08:11:13.383229  / # export SHELL=3D/bin/sh. /lava-3262693/e=
nvironment
    2023-02-01T08:11:13.383585  =

    2023-02-01T08:11:13.484804  / # . /lava-3262693/environment/lava-326269=
3/bin/lava-test-runner /lava-3262693/1
    2023-02-01T08:11:13.485327  =

    2023-02-01T08:11:13.485461  / # <3>[   11.291048] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-02-01T08:11:13.490014  /lava-3262693/bin/lava-test-runner /lava-32=
62693/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
rk3328-rock64          | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63da2176ef08170c1d915f0c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-rk3328-rock64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da2176ef08170c1d915f11
        new failure (last pass: v5.10.146)

    2023-02-01T08:23:04.646159  [   15.936648] <LAVA_SIGNAL_ENDRUN 0_dmesg =
3262728_1.5.2.4.1>
    2023-02-01T08:23:04.751138  =

    2023-02-01T08:23:04.751583  / # #[   15.997459] rockchip-drm display-su=
bsystem: [drm] Cannot find any crtc or sizes
    2023-02-01T08:23:04.853659  export SHELL=3D/bin/sh
    2023-02-01T08:23:04.854103  =

    2023-02-01T08:23:04.955441  / # export SHELL=3D/bin/sh. /lava-3262728/e=
nvironment
    2023-02-01T08:23:04.955866  =

    2023-02-01T08:23:05.057253  / # . /lava-3262728/environment/lava-326272=
8/bin/lava-test-runner /lava-3262728/1
    2023-02-01T08:23:05.058325  =

    2023-02-01T08:23:05.061766  / # /lava-3262728/bin/lava-test-runner /lav=
a-3262728/1 =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
stm32mp157c-dk2        | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63da1deefa7862ae83915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da1deefa7862ae83915ebe
        new failure (last pass: v5.10.129)

    2023-02-01T08:08:08.084955  <8>[   12.669328] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3262701_1.5.2.4.1>
    2023-02-01T08:08:08.190869  / # #
    2023-02-01T08:08:08.293283  export SHELL=3D/bin/sh
    2023-02-01T08:08:08.293891  #
    2023-02-01T08:08:08.395583  / # export SHELL=3D/bin/sh. /lava-3262701/e=
nvironment
    2023-02-01T08:08:08.395975  =

    2023-02-01T08:08:08.497397  / # . /lava-3262701/environment/lava-326270=
1/bin/lava-test-runner /lava-3262701/1
    2023-02-01T08:08:08.498037  =

    2023-02-01T08:08:08.502048  / # /lava-3262701/bin/lava-test-runner /lav=
a-3262701/1
    2023-02-01T08:08:08.567922  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63da25690b6744129c915ed5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da25690b6744129c915eda
        new failure (last pass: v5.10.154)

    2023-02-01T08:39:47.642596  + set +x
    2023-02-01T08:39:47.646710  <8>[   17.039684] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3262718_1.5.2.4.1>
    2023-02-01T08:39:47.766847  / # #
    2023-02-01T08:39:47.872592  export SHELL=3D/bin/sh
    2023-02-01T08:39:47.874098  #
    2023-02-01T08:39:47.977541  / # export SHELL=3D/bin/sh. /lava-3262718/e=
nvironment
    2023-02-01T08:39:47.979119  =

    2023-02-01T08:39:48.082533  / # . /lava-3262718/environment/lava-326271=
8/bin/lava-test-runner /lava-3262718/1
    2023-02-01T08:39:48.085282  =

    2023-02-01T08:39:48.088553  / # /lava-3262718/bin/lava-test-runner /lav=
a-3262718/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63da222a116fff3bb7915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.166/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63da222a116fff3bb7915ec1
        new failure (last pass: v5.10.154)

    2023-02-01T08:26:05.512675  + set +x
    2023-02-01T08:26:05.516790  <8>[   17.109994] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 228290_1.5.2.4.1>
    2023-02-01T08:26:05.627469  / # #
    2023-02-01T08:26:05.729665  export SHELL=3D/bin/sh
    2023-02-01T08:26:05.730223  #
    2023-02-01T08:26:05.831547  / # export SHELL=3D/bin/sh. /lava-228290/en=
vironment
    2023-02-01T08:26:05.831851  =

    2023-02-01T08:26:05.933165  / # . /lava-228290/environment/lava-228290/=
bin/lava-test-runner /lava-228290/1
    2023-02-01T08:26:05.934108  =

    2023-02-01T08:26:05.938134  / # /lava-228290/bin/lava-test-runner /lava=
-228290/1 =

    ... (12 line(s) more)  =

 =20
