Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E584400439
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 19:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350131AbhICRkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 13:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350378AbhICRkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 13:40:01 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6860C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 10:39:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n4so3708644plh.9
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 10:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZqpvINC+cOdWFlmE3WvqWzbL2sUcgyKzRHwEpND8n2Q=;
        b=2JPb+deNqsv4xY2HHG1nN6uFZvk3v/mZpuvgt1UEc6/BJNH9s74Dmeav9zhbsd7hB0
         B92tS9bMIZLvwkdN6zAekFDBsEpGKwMKkdcsrAPs1k+zVMs3Rnz25wODl3SqQ1YrJ4u6
         m7N9jqqpGTWGGpiYbp+IIddC4zU0LdKAMeKAtzbH8wFRY6pnubJvHKH68W6t9krJmI5O
         UvNQps0Spk7/ZPpVK9w8IxfMnumPluyiOVHSFlfqKVO0C/izftDr3KRqAJSU19kyATIS
         p+bS9GAR7YMLUdDxTHZeX0dNRP/eNQae4q1Mu/FnRzkn3ORgl99WRNMSr63A2yak6Fv0
         x7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZqpvINC+cOdWFlmE3WvqWzbL2sUcgyKzRHwEpND8n2Q=;
        b=X0LnvfnclYIS54O6p/ctvfSE7TFepJtKJcUHtNd7iDgGSb+2Y1eocPJRRLdyj1Xy7c
         F3i/JTgvv70/2Yb7U0E8fJAufTkqTLp7efY0jJY6TjXK6CPGTVOdu/EiwFwDTgjgGU/i
         QPBOJTkOnm4D/jVL/Mdt2cZYZrdvpnADOtSLn3mo9b6dWi3TH5B7kOAmWRmKjdJ13erQ
         3U45zOOQ0/k4p1r7nKsMEb+BtDxzj4Kuih8eAkvFsVv68Eg7CwnIjysYuYTTHH5tmgUy
         o6DqSdNQwggi/5tGFbZllxtlPRHJqL9JU1q+NhEhb+d4Iuld8SaX1bgMiqJ8wIL1V5sQ
         7qOA==
X-Gm-Message-State: AOAM531hZp7Fb6McWLnTHTewIU/n8wEivqHNy1VBb71fCN2wa3p4X2w4
        wKKNNsbOek6no/I0hb74klvPse09oePcsWon
X-Google-Smtp-Source: ABdhPJxiKGyNsPZU06Twv84eWonaYJW3opNCawf5dz2blX2KOK+8n+0Wqp5U0CWPUZc+XU8M6M8SQg==
X-Received: by 2002:a17:902:b7c8:b0:138:c28f:a775 with SMTP id v8-20020a170902b7c800b00138c28fa775mr4056361plz.11.1630690740739;
        Fri, 03 Sep 2021 10:39:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm46983pfn.49.2021.09.03.10.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 10:39:00 -0700 (PDT)
Message-ID: <61325db4.1c69fb81.10a2c.02e2@mx.google.com>
Date:   Fri, 03 Sep 2021 10:39:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.206
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 152 runs, 6 regressions (v4.19.206)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 152 runs, 6 regressions (v4.19.206)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.206/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.206
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b172b44fcb1771e083aad806fa96f3f60e2ddfac =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613229a22da6140d28d59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613229a22da6140d28d59=
678
        failing since 288 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613233a33b67f00d39d59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613233a43b67f00d39d59=
66a
        failing since 288 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613229a52da6140d28d5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613229a52da6140d28d59=
67e
        failing since 288 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61323163084c94fd3cd59693

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.206/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61323163084c94fd3cd596a7
        failing since 78 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-09-03T14:29:31.716433  /lava-4443657/1/../bin/lava-test-case
    2021-09-03T14:29:31.733086  <8>[   18.285226] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-03T14:29:31.733542  /lava-4443657/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61323163084c94fd3cd596bf
        failing since 78 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-09-03T14:29:29.291405  /lava-4443657/1/../bin/lava-test-case<8>[  =
 15.843340] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-03T14:29:29.292053  =

    2021-09-03T14:29:29.292448  /lava-4443657/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61323163084c94fd3cd596c0
        failing since 78 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-09-03T14:29:28.256119  /lava-4443657/1/../bin/lava-test-case
    2021-09-03T14:29:28.256535  <8>[   14.823926] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
