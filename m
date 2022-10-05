Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD305F5918
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 19:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJERZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 13:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJERZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 13:25:11 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2D240A2
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 10:25:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c24so15963462plo.3
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 10:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=qZzRxgqV+jik0nPRPRPUMDqJcHSrcC5sL437KN9VfBY=;
        b=5rrBBb6hpDtRxT0NuqFUkYUe57rXGvV7F2TbCNCsVMgQoVio1MauSCC0GEgFrAiE65
         DQVtK/c1ucXyVN0An5HPk/mJQT+yOueCGTCA1u6l2mRyjEYUAzcpaH/Lx+QGzg1GL6oQ
         XqrXET5F6XzuNRqBZNULg+GgmwUUfR5JI4VDjdQ0iQ9ErCRkByeHDaPMUi+9/yHZLkeU
         TQNxkAsqNIkB6/tJw4oT5N55LFHOEsyH9+kv9x6l3daT/+1ACdfYK9krV4nlwBy+iHWZ
         1hQw+mWwaH2uoiAAhv+8iFJkN48TnwsXPnqI3fhkleYdHwT1HCGP9vR6j0SULwV7VUkX
         3x2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=qZzRxgqV+jik0nPRPRPUMDqJcHSrcC5sL437KN9VfBY=;
        b=6tATUFevFw6modt/KE78vk7pp1LmrKtaMM9j/DOKu6DOkRL9n4OZzoFBYQXdMmsm/P
         q596d4tDC8N4FyfgAY45sSdF+Sc0JCyv4KFqn0WEUND6Lwegpz72/uZQvyvyR/LFKVdD
         PrqSb3/gVKrLs5TN0VF/Hdq4zd18Swkz6A+s8R9RvlP1HdxSTxL/CPtVForM2859/wPE
         yivRhm66UXPr7AZKrtAOpmJEAC0Fi7ZwiOa/mKNIUzfIdp06Qge469vI7e33VA2qev5F
         Bq74IPKU52Wxiy2U/ehSBSyavi8tHqE5O2GeUzj5xM7uVffqw3V87JXag+r3ajLpe66F
         RcIg==
X-Gm-Message-State: ACrzQf0AE+xJORKJT4zF8+JhnojvF4z5VIjTMRWKnqt1plbjW4SCQI8G
        BYCLd/PrC7KuIfcdZ3h+WUBiAa9O10VbLFSjp70=
X-Google-Smtp-Source: AMsMyM7BE/DcmkEaghYBqDgQXwiPmRgUhaSIF8J0zAW8jtKjicjxYDzP/H6SCvR36EvOGBMb5gizWg==
X-Received: by 2002:a17:903:2342:b0:17c:ae18:1c86 with SMTP id c2-20020a170903234200b0017cae181c86mr414002plh.5.1664990709401;
        Wed, 05 Oct 2022 10:25:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a634947000000b004547fd85ec3sm3382522pgk.77.2022.10.05.10.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 10:25:09 -0700 (PDT)
Message-ID: <633dbdf5.630a0220.62292.6c86@mx.google.com>
Date:   Wed, 05 Oct 2022 10:25:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.71-71-gc68173b2012b8
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 140 runs,
 5 regressions (v5.15.71-71-gc68173b2012b8)
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

stable-rc/linux-5.15.y baseline: 140 runs, 5 regressions (v5.15.71-71-gc681=
73b2012b8)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =

imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.71-71-gc68173b2012b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.71-71-gc68173b2012b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c68173b2012b8eba332cf9832f0ad23427d795b5 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8ec0bae87eb77acab5f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8ec0bae87eb77acab=
5f4
        failing since 8 days (last pass: v5.15.70, first fail: v5.15.70-144=
-g0b09b5df445f9) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
imx7ulp-evk      | arm   | lab-nxp       | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/633d8d435d5a12152bcab61f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d8d435d5a12152bcab=
620
        failing since 8 days (last pass: v5.15.70, first fail: v5.15.70-144=
-g0b09b5df445f9) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/633d9a8e5e78077e05cab616

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d9a8e5e78077e05cab=
617
        failing since 50 days (last pass: v5.15.59, first fail: v5.15.60-78=
0-ge0aee0aca52e6) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/633d96ce320e169138cab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633d96ce320e169138cab=
5f0
        failing since 42 days (last pass: v5.15.60-779-g8c2db2eab58f3, firs=
t fail: v5.15.62-245-g1450c8b12181) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633db5de0be38fbafecab66a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
1-71-gc68173b2012b8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/633db5de0be38fbafecab68c
        failing since 211 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-10-05T16:50:31.021219  <8>[   59.844510] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-10-05T16:50:32.048501  /lava-7512431/1/../bin/lava-test-case   =

 =20
