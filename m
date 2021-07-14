Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F173C91D3
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhGNULc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 16:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243440AbhGNUKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 16:10:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9B7C0F26F7
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:55:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so2456103pjh.4
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 12:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W0lgouJE//UKb7ACTXe7P+p9fsBmDtQmyZ+Ehlz+sRk=;
        b=SoUd43p95JWGJuIvuHM8mZQXpdK7XN+88VqZUX/gFhjRACFehQuZSmuMY8f5wXKui2
         F6YrmMvlFHvVioU3iFY2+5Lcf3YdEx1VNYiJG/eGg4R0GTBnrNcCBiyIthFXVWkBORQu
         AqkGeb99KCtz2YOwvVj6h1OkF2SQ6wvPb7pgoa8o1JFYji9s91WjPtxcEeQOw6MzcWp8
         DlTZW6JLCEBFVThp08LJLt2hwgPA5lIYusy0jDsT1J04dEaHRznglpC4x+PJ5DQUGfOm
         ZVaY3kzSP5Wi7lmn1wjdxGH6YP3TflP44Hd5z6YGL9UZAdzHVKkx15Gp6txL9QI0svaI
         mAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W0lgouJE//UKb7ACTXe7P+p9fsBmDtQmyZ+Ehlz+sRk=;
        b=DHG7Irp4CQG1Q7ygapI7p6Vx9c6HtlSJDEVoOMGXTVqH9/hHhFbjtr6ZlhqnnZU2co
         onDFzrbTE0Tu0zwQHSnGRN5ScPt4RrtH80FL0Sp0ZGIPmFcNs20ikMOXYGhfbC6pOD3V
         SwGOchpOpxa9UpyC3QiKZj5IPcIXYQWpC8RNd92901p1Tuc+V+YqyNuyY7mQKuCwLHIh
         QLcddHlU5Ux8V4kpdywa/MFyAqcVVCprNL4EpVLyLFxgzIFLwPkPzwyER/hGLShs69eU
         7M8u4YwBFt+t7Xga5hxOUcU3PxDHJgY5p0zHj+7h/+BiDsvN8Xb+jloMSjYGbupQGV/e
         +5Vw==
X-Gm-Message-State: AOAM533DLyhhmkuZVbcOZNDG38ey8rnH/yxZIoypJwnP9ksmcEbOGM19
        bIn5/eIgX41VtQyo9Jsg6b73ni6ktFjXV4aC
X-Google-Smtp-Source: ABdhPJwBj2FbnbGUG/m5DJoRBG8FrK7Ugt3nCPJKut7BW1EHHbHCTDXdOmXY7icWriVJuQVZ/j7kwA==
X-Received: by 2002:a17:90b:fd1:: with SMTP id gd17mr7064127pjb.41.1626292532230;
        Wed, 14 Jul 2021 12:55:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u33sm3813352pfg.3.2021.07.14.12.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 12:55:31 -0700 (PDT)
Message-ID: <60ef4133.1c69fb81.e1ca1.b8fc@mx.google.com>
Date:   Wed, 14 Jul 2021 12:55:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.131-349-g4bd89bb5de37
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 5 regressions (v5.4.131-349-g4bd89bb5de37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 5 regressions (v5.4.131-349-g4bd89b=
b5de37)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-8    | x86_64_defcon...6-=
chromebook | 1          =

meson-gxm-q200     | arm64  | lab-baylibre  | gcc-8    | defconfig         =
           | 1          =

rk3288-veyron-jaq  | arm    | lab-collabora | gcc-8    | multi_v7_defconfig=
           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.131-349-g4bd89bb5de37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.131-349-g4bd89bb5de37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bd89bb5de37feddc86f1d9ad6ea2e169785a068 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-8    | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef0ed27721b855f88a93a4

  Results:     17 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g4bd89bb5de37/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora=
/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g4bd89bb5de37/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabora=
/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ef0ed27721b85=
5f88a93a7
        new failure (last pass: v5.4.131-349-g6063b14ea179)
        1 lines

    2021-07-14T16:20:21.785093  kern  :emerg : do_IRQ: 1.55 No irq handler =
for vector   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
meson-gxm-q200     | arm64  | lab-baylibre  | gcc-8    | defconfig         =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef141617ba0fcc678a93b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g4bd89bb5de37/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g4bd89bb5de37/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef141617ba0fcc678a9=
3b6
        new failure (last pass: v5.4.131-349-g6063b14ea179) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
rk3288-veyron-jaq  | arm    | lab-collabora | gcc-8    | multi_v7_defconfig=
           | 3          =


  Details:     https://kernelci.org/test/plan/id/60ef12d6337510099e8a93a7

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g4bd89bb5de37/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g4bd89bb5de37/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef12d6337510099e8a93bf
        failing since 29 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-14T16:37:35.182819  /lava-4197029/1/../bin/lava-test-case<8>[  =
 15.166004] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-14T16:37:35.183127  =

    2021-07-14T16:37:35.183305  /lava-4197029/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef12d6337510099e8a93d7
        failing since 29 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-14T16:37:33.759976  /lava-4197029/1/../bin/lava-test-case<8>[  =
 13.741657] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-14T16:37:33.760301  =

    2021-07-14T16:37:33.760480  /lava-4197029/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef12d6337510099e8a93d8
        failing since 29 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-14T16:37:32.722219  /lava-4197029/1/../bin/lava-test-case
    2021-07-14T16:37:32.727705  <8>[   12.722049] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
