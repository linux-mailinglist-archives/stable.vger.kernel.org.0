Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470134097E4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343594AbhIMPxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343617AbhIMPxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:53:12 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67EFC03D405
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:47:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id n30so6555847pfq.5
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9s1IOqkDiSU6zaJDBXYtlg+/4QUJhlCpM7vSc/UpCZo=;
        b=03Xd6vo5w730/mDMm15Ufap4t9wDWKMQmi7+cd8gJO6NcH60GBBO01lab3M4CS5C8L
         EoaIHsUrJ1BicBneeOFaG6VXcOz5ghl6dv6/6pFGiiVcveGriHaFrRGj8NnTfB+HUvxO
         kp5f7krjSbtzHP8AnlSu9SOnQmC6Gj2Fa9OR7U2X3ewXmgjzQQmSyRa0KV4rwShSkqE9
         UYgnMtbfL2t4S0aqxkGga69/WgqhIkPV9OpdJm3qwKC9MtlAaGnBZg+BVxmRen+9KBVD
         3FrGMYyMvVUJMdowSd1zyhNfOX+gDpe9FMFOnycklRcYlhAYyDa2+OMZySpDPxP9GMDn
         BUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9s1IOqkDiSU6zaJDBXYtlg+/4QUJhlCpM7vSc/UpCZo=;
        b=Y50wsMmjYa4XBLc6ILn9iV/GaZDwte0YTivZi3YWfc+YUkKNa3JjSdQysd05Dptwl6
         l+/fMaDjnrB6jWuO7wXTMsLPjZ+YfVgtIbqo3tOZWTHvTsD3uC60eH2EqJL7GJ3GYmsE
         pEr1BX+XwfMxXTj/pQfhbGKgMdTsiA04oeK6AtehSAgDAJO4R21Ii+G2DcLeqeXPH1mD
         7UylKzVyE2jajODorehVWdeG2yCyoIrlcDBUstWaPhPktsRj0OYXeVAqbBsFxtbE5vF5
         Fe8ASuQM1n5LPofLmAR3kaFErwregU2+YbDMa/Tmxc9l8AbFuU4M44TxKUnZiDTsgjzw
         yFyg==
X-Gm-Message-State: AOAM533M8SZCBOHijl99e/Rf514wy2P11aeGk6kKEsFCOGbZwHK05BdJ
        n55iYlOR17gzXbw/g0XfntDnBEQNRr964vPT
X-Google-Smtp-Source: ABdhPJyDaeBKMHQBdlfQHawll1rXU6l1bK0R9pQN1/3dtXLSzYc7b1A1ZvnRt8HEDp+8A8BF1X0q0Q==
X-Received: by 2002:a62:2f47:0:b0:43c:11:69ce with SMTP id v68-20020a622f47000000b0043c001169cemr224679pfv.24.1631548025032;
        Mon, 13 Sep 2021 08:47:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9sm7309039pjz.55.2021.09.13.08.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:47:04 -0700 (PDT)
Message-ID: <613f7278.1c69fb81.2a625.47bc@mx.google.com>
Date:   Mon, 13 Sep 2021 08:47:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246-92-g408bfc1b57fe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 136 runs,
 7 regressions (v4.14.246-92-g408bfc1b57fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 136 runs, 7 regressions (v4.14.246-92-g408=
bfc1b57fe)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.246-92-g408bfc1b57fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.246-92-g408bfc1b57fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      408bfc1b57fe540ddd618ad1ee6a238363dfd8e9 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/613f4270aa19ee058199a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f4270aa19ee058199a=
2f3
        failing since 531 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f3f952b2ffbcbd299a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3f952b2ffbcbd299a=
2dc
        failing since 302 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f409f50daa0533199a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f409f50daa0533199a=
304
        failing since 302 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f41c6dd6b62541f99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f41c6dd6b62541f99a=
2dc
        failing since 302 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/613f51bc654085bd0999a2e7

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
46-92-g408bfc1b57fe/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f51bc654085bd0999a2fb
        failing since 90 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-09-13T13:27:17.935414  [   16.959919] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-13T13:27:17.935589  /lava-4509153/1/../bin/lava-test-case
    2021-09-13T13:27:17.935756  [   16.976938] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-pm-domain-driver-present RESULT=3Dpass>
    2021-09-13T13:27:17.935950  /lava-4509153/1/../bin/lava-test-case[   16=
.994649] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-pm-domain-pmu-probed=
 RESULT=3Dpass>
    2021-09-13T13:27:17.936117  =

    2021-09-13T13:27:17.936284  /lava-4509153/1/../bin/lava-test-case
    2021-09-13T13:27:17.936450  [   17.011645] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-pwm-driver-present RESULT=3Dpass>
    2021-09-13T13:27:17.936629  /lava-4509153/1/../bin/lava-test-case
    2021-09-13T13:27:17.936792  [   17.028870] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-pwm0-probed RESULT=3Dpass>
    2021-09-13T13:27:17.936956  /lava-4509153/1/../bin/lava-test-case =

    ... (1 line(s) more)  =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f51bc654085bd0999a313
        failing since 90 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f51bc654085bd0999a314
        failing since 90 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-09-13T13:27:14.387451  /lava-4509153/1/../bin/lava-test-case
    2021-09-13T13:27:14.392936  [   13.509523] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
