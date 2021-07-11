Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96373C3E2C
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhGKRHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 13:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhGKRHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 13:07:55 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7023BC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 10:05:08 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 37so15624214pgq.0
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 10:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FdREcbioIM1iTiqKldPrAImVA7qzXs8N5jiuEvNL2og=;
        b=H2l34QtxeHHwUO9Zs6m4qkvZ6B2/6UEpNeS1O2//6saTFc5CXms31UH+6JLJf3zZTS
         jhP++T930aMtYGFzfHZIXXlvmNoU1lGSKkXEjAs8P8a1iLvvXFaMMuC5GXget8qvAnF8
         XNog5l7APzgARe0yFQWEf4d8sxXbCn00olE9bYAkZVyxXn4UzTpkRIBXH1TnqKT0VA87
         MJ/Jzm5V04AjPryr2Td0e1GA2KPpej6pnCmIFtJz6tD59VH+1bFYBrTWTCI2WzWMIraI
         ykr4tzuNazeQWI18cXVDk/12vqH+fVBADmIZchV8PqSrtTX8s8iO1fkDEFw8cIDPcqbv
         OQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FdREcbioIM1iTiqKldPrAImVA7qzXs8N5jiuEvNL2og=;
        b=MphLYyyn60G15nFcoiiatuOy5h9DdNd0tziBLmr9J2P3W6TnF3YYVp3Jtnrj2GEVc7
         r1eaylAaejAuroAQK67DMJGvTYM43AT0u6Bpl+aR1RaSVnm0M+o01Y3g4cuPV1lkUO5M
         hy61Va1EhvuFLIz3ptm0N7Pl3kFRLfO2/m1atkf0iPlssr8B95TJON0KcvW/JiEqENb/
         oNPh0Y4tSjTZmZW25Y2ZB22ey3ozNW4HvRKAj3gqcKzERN1k7cCkUSuaGCFyFiO9TiPW
         hDWx+6NMkGja0f9xR4H/woKAVdVIJcuLWxAdCcnK8zFypxaSczRSpQffqBQiBlk8Pj5/
         VM2w==
X-Gm-Message-State: AOAM530+ZIVUrJrw4c80Tu8Xownscu6vvKENgwxAIML92hKppyZberSa
        XyGvzpUKQXDE2Y4QzNMsJtQRu9+WsMD63rOV
X-Google-Smtp-Source: ABdhPJyEC10HdY54SlsW2DyfEW9Jw0McMMH97PKRJpVfR960/i57KfI65AXNz6JDisvRkdmRtAdyrg==
X-Received: by 2002:a05:6a00:1994:b029:327:2dc0:9dac with SMTP id d20-20020a056a001994b02903272dc09dacmr22504341pfl.79.1626023107630;
        Sun, 11 Jul 2021 10:05:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm11885992pgk.90.2021.07.11.10.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 10:05:07 -0700 (PDT)
Message-ID: <60eb24c3.1c69fb81.d96c5.3888@mx.google.com>
Date:   Sun, 11 Jul 2021 10:05:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 194 runs, 6 regressions (v5.10.49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 194 runs, 6 regressions (v5.10.49)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.49/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      904ad453baa0aae7189ebd07f0d43cb694fb2987 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60eaf3b5261bdda58911799b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.49/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.49/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eaf3b5261bdda589117=
99c
        failing since 3 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/60eaf3577858ef7a10117a80

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.49/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.49/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboard.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60eaf3577858ef7=
a10117a87
        new failure (last pass: v5.10.48)
        4 lines

    2021-07-11T13:33:54.485058  kern  :alert : 8<--- cut here ---
    2021-07-11T13:33:54.485322  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-07-11T13:33:54.485798  kern  :alert : pgd =3D (ptrval)
    2021-07-11T13:33:54.486476  kern  :alert : [<8>[   42.565099] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-07-11T13:33:54.486713  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60eaf3577858ef7=
a10117a88
        new failure (last pass: v5.10.48)
        26 lines

    2021-07-11T13:33:54.537024  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-07-11T13:33:54.537288  kern  :emerg : Process kworker/0:0 (pid: 5,=
 stack limit =3D 0x(ptrval))
    2021-07-11T13:33:54.537766  kern  :emerg : Stack: (0xc210feb0 to <8>[  =
 42.610994] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-07-11T13:33:54.538006  0xc2110000)
    2021-07-11T13:33:54.538232  kern  :emerg : fea0:<8>[   42.622548] <LAVA=
_SIGNAL_ENDRUN 0_dmesg 545362_1.5.2.4.1>
    2021-07-11T13:33:54.538447                                       c210e0=
00 ef78f540 c20f679c cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/60eaf45286cfc5f5ca1179ae

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.49/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.49/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eaf45286cfc5f5ca1179c2
        failing since 24 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-11T13:38:12.651278  /lava-4175292/1/../bin/lava-test-case<8>[  =
 13.914010] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T13:38:12.651891  =

    2021-07-11T13:38:12.652399  /lava-4175292/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eaf45286cfc5f5ca1179da
        failing since 24 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-11T13:38:11.209988  /lava-4175292/1/../bin/lava-test-case
    2021-07-11T13:38:11.227684  <8>[   12.489539] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eaf45286cfc5f5ca1179db
        failing since 24 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-07-11T13:38:10.191104  /lava-4175292/1/../bin/lava-test-case
    2021-07-11T13:38:10.196743  <8>[   11.470007] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
