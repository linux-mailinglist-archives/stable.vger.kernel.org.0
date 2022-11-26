Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C476396A9
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 15:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKZOv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 09:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiKZOvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 09:51:54 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B4A1B9C4
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 06:51:53 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id h33so1176441pgm.9
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 06:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ACY627mP2WuprKo5sJ5FatZz+BR4El96SyiQeAFg1FM=;
        b=dmvD6ksqSz/nI3ZqcvxvwpvVEXwSIKq6RYf/hnOXSc2K05KcxjMamSalLXfkfvonhV
         Cum9h0QxU03mXJDMmOW6Y9H1CvNxTjEwCCkjCWLPA4yjXEztDR70oEXrIqJJAJ1nn89j
         kd4wPV6WruzkF9FGEfb74poe7kYMTeMhsNOIwuOlicdBw5QT8cXnUg7osbGjKgVr7cKu
         RIk0cjN3QYQBVn8vxE+cJMvl3XVNEA/K3+hm5UFNIjwXXKLLFZ+gRhFJjXmHuBCW1vpz
         PItOa3y4Bwree5jDN9PlbPm/M5JylEDHvfasyuqjs6TjBYYN6GNKiPYRHHRXt4rY7NvC
         ISrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ACY627mP2WuprKo5sJ5FatZz+BR4El96SyiQeAFg1FM=;
        b=KdlVdAPtNGi63tFb7sxfkqnVeyfsZ5Pjye3NVUbJyZ0DczLe0nXRSCPhP6+hicTP79
         JTjIbUKevWxrSxAeOySDO19ydaGylBANxGBFPq9JlRPU6cRgN4gTM/J5kizdj1ifkSKo
         FYk8Ecr70DfawnuWfJKdWSfMtvMYqbCoOazzyF9/cwZI6Lzc3pmCDI9dBm81dtLfChxP
         nhi8Btn/TcWJ4hp2l6KhuHp+5iLUr53QXMgyT02amTN4xeFY7jUqNqDK7ogwNYzpmlCx
         e2HHgbUGIq4R1xknA4X2VipS3vo3tUhvcswnrbJrMc2l3tpxVmBWiFDJdTG2kf9BtnDf
         Z77A==
X-Gm-Message-State: ANoB5pmjH5InJC+zYY4Rc4PhJP5ZOjp8forK4KxgUpDMhO6QQrohx/Xe
        x6F+nCmimmoVd89QB6ayp/ldS8QaPeA6H4SFvSU=
X-Google-Smtp-Source: AA0mqf5LmAwsgNziNBtvBce58CJJ/D3wCW3P0SrA3x+ZdpqbaQMBNF7mWuwHjgt50ZA3BUzHe2h9Xw==
X-Received: by 2002:a62:1e03:0:b0:56b:d68e:41f6 with SMTP id e3-20020a621e03000000b0056bd68e41f6mr44700718pfe.36.1669474313010;
        Sat, 26 Nov 2022 06:51:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21-20020aa796d5000000b0056bad6ff1b8sm4847420pfq.101.2022.11.26.06.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 06:51:52 -0800 (PST)
Message-ID: <63822808.a70a0220.1ebe4.651a@mx.google.com>
Date:   Sat, 26 Nov 2022 06:51:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.80
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 117 runs, 4 regressions (v5.15.80)
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

stable/linux-5.15.y baseline: 117 runs, 4 regressions (v5.15.80)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | multi_v7_defconfi=
g         | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =

sun8i-h3-orangepi-pc | arm   | lab-clabbe    | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.80/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      71e496bd338221709b180b60ba419fa542c2b320 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6381f3fbd321f7955d2abda5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6381f3fbd321f7955d2ab=
da6
        failing since 59 days (last pass: v5.15.67, first fail: v5.15.71) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
imx7ulp-evk          | arm   | lab-nxp       | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/6381f5634e29c5f0c22abd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6381f5634e29c5f0c22ab=
d17
        failing since 51 days (last pass: v5.15.70, first fail: v5.15.72) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6381f94ed6651ec4a02abcfd

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6381f94ed6651ec4a02abd1f
        failing since 262 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-11-26T11:32:14.645243  <8>[   59.900801] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-11-26T11:32:15.674090  /lava-8138741/1/../bin/lava-test-case
    2022-11-26T11:32:15.684993  <8>[   60.941326] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
sun8i-h3-orangepi-pc | arm   | lab-clabbe    | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/6381f59cab84deb90d2abd00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.80/a=
rm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6381f59cab84deb90d2ab=
d01
        new failure (last pass: v5.15.79) =

 =20
