Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4753B565C9A
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 19:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiGDRLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 13:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGDRLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 13:11:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D258711C02
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 10:11:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so5668949pjf.2
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FWlUhrIWD9GD6p9ejLpULAVQUHF9+f2oomNfKVKLyZc=;
        b=6wka6eoB5Nacn4QvVdeK58dhABLgzqMTgTqF7P0TcrttlMTdds8NN0ybiFeG7spr0w
         R2OknG95LUkJ9Ee7JEn745ZZA9KQGjug7CMm2KJKzroelFsFnVYI2xrrAnD0QrrmaeJB
         pD/AwG9QKc6NKJfaRiJG+WQaabjt2nxNM8T7D97OpX7NvM/XyH4/1CnFBQTlAUyed3MC
         EcRyvh0NVnXA/HDPFZYbZ0rpfhZesrc+iRHnjbteQgt6Hio3opk8BXtwFz2cKF/yk6N1
         SevMFUmuEe/JHgK/okqtlB/O+PRfAmxkw0IxOgVR04SBbIdpCmevgcsP9Pj2ECvzlQ4G
         n3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FWlUhrIWD9GD6p9ejLpULAVQUHF9+f2oomNfKVKLyZc=;
        b=vsXFg8mMARTLedoikkZsBUZMehzk4ynt1ldTHGTaDmOcT4pyRvL5HF9tsxaw3h6Hb3
         tQsIUWAEI5wo+Lvhiu9fMem9xVkMM5mV6K0eYcBciAfQdtKCpOArIQ8F9bma+FfHPwWV
         sKtT7pLMSK6gx3s3oPvKFRx8e5yT17IEgGx2zEr+wY0Z1yyzsQKsTQL17MV3q2DO9DXi
         xw8rFJf5Lp6e2kX9MNwbv3+a4z1Mg/JtqEJCxGWnIkmwMD2a0WpDJ3bfKCU91/NQOkm4
         1prdrq25/mh9jLmwdMzg1UQ+KiTPBKQxRJJitczleHmZ/M5ICUogU5f+siGxh3JiKore
         bxQA==
X-Gm-Message-State: AJIora//NP2jKC+fKXUDd0ds4d6YLQ6NH+xqB8TpW9aQysfJy+RCpuVy
        a7xHcFjWKQdDn8oFwzQSTqnPR61mIHod4iRD
X-Google-Smtp-Source: AGRyM1tI6NAgfRB69hlarCkR8QPMcxxTTtOedtvKkhMczbvGqDOR4uUit8+pTB3a19ju7LhXToatDw==
X-Received: by 2002:a17:90a:1c02:b0:1e0:df7:31f2 with SMTP id s2-20020a17090a1c0200b001e00df731f2mr36963760pjs.222.1656954676254;
        Mon, 04 Jul 2022 10:11:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a0d0900b001e8520b211bsm12876293pja.53.2022.07.04.10.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 10:11:15 -0700 (PDT)
Message-ID: <62c31f33.1c69fb81.8ab0e.27c9@mx.google.com>
Date:   Mon, 04 Jul 2022 10:11:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51-60-g300ca5992dde
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 4 regressions (v5.15.51-60-g300ca5992dde)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 173 runs, 4 regressions (v5.15.51-60-g300ca5=
992dde)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

jetson-tk1         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g         | 1          =

jetson-tk1         | arm   | lab-baylibre    | gcc-10   | tegra_defconfig  =
          | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.51-60-g300ca5992dde/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.51-60-g300ca5992dde
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      300ca5992dde2a8372591456e875c886a4a79515 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2f0ae26ea2cecd7a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2f0ae26ea2cecd7a39=
bdc
        new failure (last pass: v5.15.51-43-gad3bd1f3e86e) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
jetson-tk1         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2ef73432bf88221a39bf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2ef73432bf88221a39=
bf4
        failing since 23 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
jetson-tk1         | arm   | lab-baylibre    | gcc-10   | tegra_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2ed9330bbd6b7aea39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2ed9330bbd6b7aea39=
bf5
        new failure (last pass: v5.15.51-43-gad3bd1f3e86e) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c2e93a4a8963da85a39bd5

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
60-g300ca5992dde/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62c2e93a4a8963da85a39bf7
        failing since 118 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-07-04T13:20:44.083497  <8>[   59.827099] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-04T13:20:45.103705  /lava-6746138/1/../bin/lava-test-case
    2022-07-04T13:20:45.114127  <8>[   60.859551] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
