Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105BF421924
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 23:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhJDVV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbhJDVV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 17:21:58 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F898C061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 14:20:09 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so17751175pgu.13
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 14:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fnnEb6T0kE7D37g/jI4LuG0iFCWYDvxDQQC935vfBFE=;
        b=qUufuwF/2UgiLfh6Ifc4+ctzGGu890aOeXD1JdG+927HNr+Lw4ZSHuw7cYe2rI5uZc
         WbAOHuHdZSVKEVkF9/eaiVW6/PdjgAwIxYyjFIjaG+ZofD3yXfqhmmuql5SR7L42NF0t
         OsMETZDTsnWz4gSyf6YlwXAHvHheqXlux8xPPhnRS7gzP6dt0DyXFkMWse9E+YfywomZ
         cS3lIhoNex4zuiq9kkG4acFOkPLEsAHEYZh0XUczjDDYdR9wM7v+FsIRLtUL8WQjaKDu
         aOFE3VmQ0QIXYgBnrPdQfrgH/5HEDHE8/gkBa8h9r53r9Sp4ZjezCiB8Ns7W/CB+5v9j
         IvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fnnEb6T0kE7D37g/jI4LuG0iFCWYDvxDQQC935vfBFE=;
        b=zk4qaMEpKXjY+nesdTmHdYz7CQ/U0N32MvPY4FgoOJyzoPUZLdu35nV1GPdFRtDy47
         ccKgWVIwffJA14pAUuBe0Zz/Z44t7dMe9uFj+KBlbISx72ijjl+7u1C+KAWzxhzQfkQN
         o3DIocTkdTpxAkikxmsptcZHgunkKD2n2yc59kuexwHeOLfDl2kBLzN7V0BtBYTSgl1N
         uKjxFw+QolYOL1++Mn4zMPcsD9jZgcHP+y9ShI1vYG3EBG50tDx271hXiUIixfPLtLfy
         l9zBLOx+47u0lkHn9zwL1A28pc7IJ4/Aiu1Y0GY5y2w2Vn5WwemSokgbuAHu8n4/5gKe
         4+Xg==
X-Gm-Message-State: AOAM533/jdsROrwbYXkjsPcS1DJ/sYK4D7Z3zNUvxR0hFMhq8SjUv/nV
        cJRo9QZYt+cOU0qRunSpgFITM0BzqP3M1veT
X-Google-Smtp-Source: ABdhPJyilgVfd7WqeYm72eO+qXOdh3bcZWUsBPy3oZIvzfaM17He88BJZdDym+Orv3hj5/nyHr4pkQ==
X-Received: by 2002:a63:9546:: with SMTP id t6mr12714399pgn.260.1633382408604;
        Mon, 04 Oct 2021 14:20:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5sm1591236pfo.154.2021.10.04.14.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 14:20:08 -0700 (PDT)
Message-ID: <615b7008.1c69fb81.770a5.479b@mx.google.com>
Date:   Mon, 04 Oct 2021 14:20:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.150-57-gfcbebeaa9950
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 145 runs,
 7 regressions (v5.4.150-57-gfcbebeaa9950)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 145 runs, 7 regressions (v5.4.150-57-gfcbeb=
eaa9950)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.150-57-gfcbebeaa9950/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.150-57-gfcbebeaa9950
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcbebeaa9950b7b59ce6b2baf97e2bcb1eb07224 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/615b38b73601bb373499a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b38b83601bb373499a=
2f2
        failing since 318 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3608dd0391291699a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3608dd0391291699a=
302
        failing since 324 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3e9a8554e7d89899a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3e9a8554e7d89899a=
2e3
        failing since 324 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3cdcd28f6a9c1199a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3cdcd28f6a9c1199a=
2dc
        failing since 324 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/615b5dfb7b8b27639c99a2e9

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.150=
-57-gfcbebeaa9950/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615b5dfb7b8b27639c99a2fd
        failing since 111 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-04T20:02:45.247782  /lava-4642883/1/../bin/lava-test-case
    2021-10-04T20:02:45.264581  <8>[   14.840790] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615b5dfb7b8b27639c99a315
        failing since 111 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-04T20:02:43.822969  /lava-4642883/1/../bin/lava-test-case
    2021-10-04T20:02:43.840178  <8>[   13.415121] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-04T20:02:43.840513  /lava-4642883/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615b5dfb7b8b27639c99a316
        failing since 111 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-04T20:02:42.802741  /lava-4642883/1/../bin/lava-test-case
    2021-10-04T20:02:42.809513  <8>[   12.395389] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
