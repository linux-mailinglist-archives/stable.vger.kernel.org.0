Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EBE40060D
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 21:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348708AbhICTrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 15:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhICTrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 15:47:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9C5C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 12:46:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m26so327596pff.3
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 12:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GQmz1ZUQmumjYnFtjrRc7E1U1yp1wfPdpqwB8ipub2o=;
        b=I6z8nKh5Y0ZVry9kNRXJxdUKhSw1OJfifAQYF2etq8hCrc/pHTbuDFQEGI5U+NICNv
         spDcIDqf0y8kFZyyw0p16LzurkFA4X5IvgGRLk05+LntmFycQ9tu497ptzdA6ZxQUHCQ
         KlN5ryK9q8I9HE/umyHMjoPf6M4XM/gbjvFIwR/sYDKYLAid3OElDyW9l1pYzv8kPbTg
         bikEqnFgLVDHoa5oEm+5cw/In8YiFcs6Obdm2zcPFaK9Z6m27ig2rd/TennbFPz9DcsD
         yciTDKOj3PB/J/NvzdV/2JUCrAovSgwUZu35Si9eLpUIZ6M8Q5YroijxCpsnXUUdF6Fg
         zdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GQmz1ZUQmumjYnFtjrRc7E1U1yp1wfPdpqwB8ipub2o=;
        b=oOrPdLuGaC9AaYrxVkVNfsGuiSEgUik6lyM2nffVJD+Wk4x7TIY9BVxTO88Cd/Q+Mq
         pdcwacAGMFeHKU6orYyXShsITOIeUG7ryv00MDpuYpxTcOCNeZRQxZlSeQqRHx8hRw6M
         2pqV+tE1NhFcXz6OGd1XElKGAdRnYfaLGE6vjBzhevQDtU6C2ubpU/Zf67jgtsyC1J95
         msfWvBAwe012mfVEqt8qB7XhpTnEa6QTQgU2brd2HqHXu3qyHadKBdN5tSVkcQMDMSiI
         ytNEKUQCagFPHNFmaG5nRsREtx0hGEDrAH8gkH9IMXx6CWeWzekNppLUTM5gHzLNBYa1
         uXXA==
X-Gm-Message-State: AOAM531fqrOCjRR/ecBIgBJAeoXUD6IMd36/m8Br7rlM7r4CHSoDNDVo
        pr74CN0Udu0MK+D9XUm/BPrAlFsEOdaBRYmi
X-Google-Smtp-Source: ABdhPJwvAmHUyN8hIkwYJEqrMX3K6IEyJh26a5WZjTHvBEzU4Lz4pnXKx1gO+86Ti+/Ukbg3cDSBCg==
X-Received: by 2002:a63:5947:: with SMTP id j7mr581816pgm.193.1630698372088;
        Fri, 03 Sep 2021 12:46:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p30sm188645pfh.116.2021.09.03.12.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 12:46:11 -0700 (PDT)
Message-ID: <61327b83.1c69fb81.466c5.0ef3@mx.google.com>
Date:   Fri, 03 Sep 2021 12:46:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.206-1-g858883949531
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 152 runs,
 7 regressions (v4.19.206-1-g858883949531)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 152 runs, 7 regressions (v4.19.206-1-g858883=
949531)

Regressions Summary
-------------------

platform                     | arch | lab           | compiler | defconfig =
          | regressions
-----------------------------+------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb         | arm  | lab-baylibre  | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-broonie   | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-cip       | gcc-8    | versatile_=
defconfig | 1          =

rk3288-veyron-jaq            | arm  | lab-collabora | gcc-8    | multi_v7_d=
efconfig  | 3          =

sun8i-h2-plus...ch-all-h3-cc | arm  | lab-baylibre  | gcc-8    | multi_v7_d=
efconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-1-g858883949531/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-1-g858883949531
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8588839495312d3154f1d5b02f3ba5610d5bb881 =



Test Regressions
---------------- =



platform                     | arch | lab           | compiler | defconfig =
          | regressions
-----------------------------+------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb         | arm  | lab-baylibre  | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61324690bfeeaeb65fd59668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61324690bfeeaeb65fd59=
669
        failing since 293 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab           | compiler | defconfig =
          | regressions
-----------------------------+------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb         | arm  | lab-broonie   | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613247f7006d6d7cdad5969b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613247f7006d6d7cdad59=
69c
        failing since 293 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab           | compiler | defconfig =
          | regressions
-----------------------------+------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb         | arm  | lab-cip       | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613246ade66e07ca1fd5967c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613246ade66e07ca1fd59=
67d
        failing since 293 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab           | compiler | defconfig =
          | regressions
-----------------------------+------+---------------+----------+-----------=
----------+------------
rk3288-veyron-jaq            | arm  | lab-collabora | gcc-8    | multi_v7_d=
efconfig  | 3          =


  Details:     https://kernelci.org/test/plan/id/61325303c313d2d664d596b1

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61325303c313d2d664d596c5
        failing since 80 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-03T16:53:12.908431  /lava-4444539/1/../bin/lava-test-case
    2021-09-03T16:53:12.913489  <8>[   18.414491] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61325303c313d2d664d596de
        failing since 80 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-03T16:53:10.467491  /lava-4444539/1/../bin/lava-test-case
    2021-09-03T16:53:10.484355  <8>[   15.973187] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61325303c313d2d664d596df
        failing since 80 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-03T16:53:09.454015  /lava-4444539/1/../bin/lava-test-case<8>[  =
 14.953959] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-03T16:53:09.454499     =

 =



platform                     | arch | lab           | compiler | defconfig =
          | regressions
-----------------------------+------+---------------+----------+-----------=
----------+------------
sun8i-h2-plus...ch-all-h3-cc | arm  | lab-baylibre  | gcc-8    | multi_v7_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61324a23d86c92ea5bd59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-1-g858883949531/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h=
2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61324a23d86c92ea5bd59=
66a
        new failure (last pass: v4.19.205-33-g55b15808c010) =

 =20
