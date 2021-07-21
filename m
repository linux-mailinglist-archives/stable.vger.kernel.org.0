Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FFD3D06CF
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhGUCE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 22:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhGUCE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 22:04:57 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6099C061574
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 19:45:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a127so1108083pfa.10
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 19:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UBwkbTo8l35LU/tbwpSY4nnDdBfl64rYSW8RWqMNU0o=;
        b=p1HK04nbt+7818VJf8EodGC9m41flBsXV9t0rDPQxVEEsIUAJR86u6yj37VPWGII2o
         gjVTIzzkI9QRfwa/Yi3GKqQMs4mFZpao3hJeueA3+4IQ7wUgE+RBPDpqZ9BfNSS1Jjua
         +vT7FJXRBI2SuLYACX8okGDu7iwcjCRzHlCNg4TSltq6W/m6W+DzzRfc/TPiUHkhZKJy
         VanCOBhmVwQEvHN7aGyiabd3wuVQIKUeAB4BI///b/WYk0kwX7P/qgcw7SYUSNwkTwbV
         Tzn9awunZmOxwjFyRj/6S7afB0X2nQvHgHicoq1lN4SiKXHHScD89Xgm1wqaboEAxW9A
         +wVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UBwkbTo8l35LU/tbwpSY4nnDdBfl64rYSW8RWqMNU0o=;
        b=cF48pc5j/lf0bPTxrgTBpMQO0VUGkq5FMfXf159P72BDLLrtf3NwR+vN3TlYnML56/
         jhc43pG+cwGmYIQ4SuVxCPCKzWSb7AoZscIDtCVwVx/qKyfpct+9oKFv6Ttp7z9neULA
         Yjqh8T0m3NykUqvB6aYppkHM6Z9YHIR3Dk+/XTwic7hCveSYYNW1SGO7Pzyqo2r19Gc6
         jLxwoaWeAo5b6uDKlX5oamEqSQBtlPhwCfhvUOZcH9SgE2+ScUg3UzOFHr4NQYKv2y1G
         C2Zn5TN2Iak5EOhBZUS2vQ9/RKDX9Jy/0nlPsyFTKX5HrR7rnil5385XXPPJt6wwUsdN
         JO5A==
X-Gm-Message-State: AOAM532oGmBTYzkQno9+3onRdtNyw2NeBh/+t5nbXOScBcfd6pwrdGWY
        aIcmG1Rn11dp+jGDay7xkrhGR1TAO0HaNTPa
X-Google-Smtp-Source: ABdhPJwN+1o4kQdMulaYyinspMeObmif1aiATXXkFkN4FmrQLmmcSxL+TMFhokQp3Jfr509bncXMcQ==
X-Received: by 2002:aa7:80d3:0:b029:347:820c:fbf with SMTP id a19-20020aa780d30000b0290347820c0fbfmr14508118pfn.73.1626835534188;
        Tue, 20 Jul 2021 19:45:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9sm16223912pgm.89.2021.07.20.19.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 19:45:33 -0700 (PDT)
Message-ID: <60f78a4d.1c69fb81.4bb63.05cc@mx.google.com>
Date:   Tue, 20 Jul 2021 19:45:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.133-148-gcd65dea59bf4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 194 runs,
 6 regressions (v5.4.133-148-gcd65dea59bf4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 194 runs, 6 regressions (v5.4.133-148-gcd65de=
a59bf4)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
              | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g             | 1          =

rk3288-veyron-jaq     | arm    | lab-collabora | gcc-8    | multi_v7_defcon=
fig           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.133-148-gcd65dea59bf4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.133-148-gcd65dea59bf4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd65dea59bf4f8835eaae2e9cc30fa735b4e6e63 =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/60f74f75d1c253b75385c292

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f74f75d1c253b75385c=
293
        failing since 264 days (last pass: v5.4.72-409-gbbe9df5e07cf, first=
 fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f74f2cbe9bf88e1785c271

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f74f2cbe9bf88e1785c=
272
        failing since 9 days (last pass: v5.4.130-4-g2151dbfa7bb2, first fa=
il: v5.4.131-344-g7da707277666) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f75288cc0934b22c85c2b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f75288cc0934b22c85c=
2b1
        failing since 9 days (last pass: v5.4.130-4-g2151dbfa7bb2, first fa=
il: v5.4.131-344-g7da707277666) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
rk3288-veyron-jaq     | arm    | lab-collabora | gcc-8    | multi_v7_defcon=
fig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60f74f870f84adda2685c256

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-1=
48-gcd65dea59bf4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f74f870f84adda2685c267
        failing since 35 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-20T22:34:30.185509  /lava-4221225/1/../bin/lava-test-case<8>[  =
 15.110117] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-20T22:34:30.185850  =

    2021-07-20T22:34:30.186045  /lava-4221225/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f74f870f84adda2685c27f
        failing since 35 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-20T22:34:28.744176  /lava-4221225/1/../bin/lava-test-case
    2021-07-20T22:34:28.761294  <8>[   13.685524] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-20T22:34:28.761523  /lava-4221225/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f74f870f84adda2685c281
        failing since 35 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-20T22:34:27.728808  /lava-4221225/1/../bin/lava-test-case<8>[  =
 12.665023] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-20T22:34:27.729138     =

 =20
