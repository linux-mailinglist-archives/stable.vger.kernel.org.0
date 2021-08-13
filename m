Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFD73EBEA8
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 01:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhHMXX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 19:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHMXX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 19:23:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A77FC061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:22:59 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b7so13979442plh.7
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 16:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2EEHOnMKHBbKer8tuezR2pTU3hmteqkUUvZiF2PWIaQ=;
        b=fMB8NGcpg9+9aFDGmkGlsUMHCZNMEXmj22GxntWSxsmUOQShQCdf33/jrucySjzdRe
         pZgQKWydIOYlFStIm4Ptvk2Yu33kNUpLk2KnEGn9vdKGGfBIOdh80dwWWaCZOsvGQxjQ
         D9re897jszKJ6s+oE+vzoMucsrM1ncFVPITX1TruV1FfEAX0SUbFLbae8a2gGSulpcJH
         Cx4KAcFMVdVNC41UvUn3l9qvTlbYCbRoXf6qI7rIoWze/pHIWlQEceTl9tMyjx7zVHMP
         SudVy5MaLKt/m2l3j/WJcDV5gy6B+z4jlSr8WA9q9pr/3wXa/a1e+fL836x26VcYWOEJ
         VlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2EEHOnMKHBbKer8tuezR2pTU3hmteqkUUvZiF2PWIaQ=;
        b=Y+pvZWN8VcwKoYp5CE/vgvAXnukKjy/kb/hD9Er0/y7tbZ6RswynpKVqSjZzpGReEk
         1LYshmZ85ZzVdYfGkB7ddPFRhyt0UNPFlpAvE0su+ZbNXw4JrVBLJsARtRIhhrVPdPf/
         AxlmThWqznBB29w6TnZnpCjJybT/QDGlBGOB5vpVjE+rnw1mLYS1CmNjOzrHZXX0Me32
         pJ+McWj+OtMwhcw9ebAhZNGVjXDoFpnrGoa22dv5goi7Pi6XRO6CtC7OWQwZQzXEZvhI
         X1v6VVEc3luV8HdP1sFCHlGCHeodLiXQb51suvPKu8S+3JIo3z6zAbTtJdcXxToPeCbc
         Na/g==
X-Gm-Message-State: AOAM532AqmZFnMeOQ6TWzRRWlffb7hKvn/NKEIkr7w+mFy09GG6oaY7S
        SdcvYn9O9PnvlUn2s4zyV4gaSfbnEblmJlZl
X-Google-Smtp-Source: ABdhPJyLsu4kLES6AKQjwCEHEliyOcsEm4cmodmjorjKqTlX182lolSaJ+2YcMvuSoR2Zfk7fya9Iw==
X-Received: by 2002:a17:902:a9c3:b029:12c:31c7:9b81 with SMTP id b3-20020a170902a9c3b029012c31c79b81mr3905504plr.30.1628896978555;
        Fri, 13 Aug 2021 16:22:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm3335170pfn.136.2021.08.13.16.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:22:58 -0700 (PDT)
Message-ID: <6116fed2.1c69fb81.1bd82.8c66@mx.google.com>
Date:   Fri, 13 Aug 2021 16:22:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-154-g5f0bac13c2e0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 158 runs,
 7 regressions (v5.10.57-154-g5f0bac13c2e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 158 runs, 7 regressions (v5.10.57-154-g5f0ba=
c13c2e0)

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

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.57-154-g5f0bac13c2e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-154-g5f0bac13c2e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f0bac13c2e03b1eacdd4db9289e187ce9311d1d =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6116c927cdb02a9b4cb13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116c927cdb02a9b4cb13=
688
        failing since 43 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6116c9a15ecd9205c6b1366d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6116c9a15ecd920=
5c6b13671
        new failure (last pass: v5.10.57-139-g906cd6fc30f8)
        4 lines

    2021-08-13T19:35:33.825766  kern  :alert : 8<--- cut here ---
    2021-08-13T19:35:33.856774  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-08-13T19:35:33.857073  kern  :alert : pgd =3D (ptrval)
    2021-08-13T19:35:33.858229  kern  :alert : [<8>[   39.405099] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-08-13T19:35:33.858578  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6116c9a15ecd920=
5c6b13672
        new failure (last pass: v5.10.57-139-g906cd6fc30f8)
        26 lines

    2021-08-13T19:35:33.909302  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-08-13T19:35:33.909607  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x(ptrval))
    2021-08-13T19:35:33.910156  kern  :emerg : Stack: (0xc2405eb0 to<8>[   =
39.452264] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-08-13T19:35:33.910433   0xc2406000)
    2021-08-13T19:35:33.910685  kern  :emerg : 5ea0<8>[   39.463658] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 688446_1.5.2.4.1>
    2021-08-13T19:35:33.910931  :                                     c2404=
000 ef78fdc0 c189c974 cec60217   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6116ca60a6f580e903b13765

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6116ca60a6f580e903b13=
766
        failing since 3 days (last pass: v5.10.57-49-g039efb5682ed, first f=
ail: v5.10.57-125-gb8eec9975ba1) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6116ce31802eb3efe6b13667

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
154-g5f0bac13c2e0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6116ce31802eb3efe6b1367f
        failing since 59 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-13T19:55:14.228215  /lava-4359998/1/../bin/lava-test-case
    2021-08-13T19:55:14.245358  <8>[   13.425586] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-13T19:55:14.245609  /lava-4359998/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6116ce31802eb3efe6b13697
        failing since 59 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-13T19:55:12.800393  /lava-4359998/1/../bin/lava-test-case
    2021-08-13T19:55:12.817099  <8>[   11.997700] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-13T19:55:12.817325  /lava-4359998/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6116ce31802eb3efe6b13698
        failing since 59 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-13T19:55:11.780155  /lava-4359998/1/../bin/lava-test-case
    2021-08-13T19:55:11.785396  <8>[   10.977834] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
