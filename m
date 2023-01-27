Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7993967E938
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 16:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbjA0PQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 10:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbjA0PQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 10:16:44 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9BF86606
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 07:16:39 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jl3so5246851plb.8
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 07:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6io9f0qG+FeIuCFgWGkOuaIH1Bd0r134hIVSeeos7Qk=;
        b=XPlppghaI78nTbVssbK0IPl50ewtjifbrMHGFM7SDFdueSK3x2NqyYB55vI4x/HHY7
         t1LnXxTwE09D0IyMJxGyoMWwc1w9jIaLG/qZ8rsRxNkzr4SzUg9tCP/924jDnJsbtbwe
         0T4CAAVwJCqJDU/G0b7kZWrXxvrG/p4+SvV1mvSCwjq8EtOxWoUvYIJh4MPjNhcWDVFK
         lrzqKqwfFkbB1I8lG3K2wzqtnRsbhD44zNP9vWIcVpy7d1IJXgVsPOoHO+9bJ3Z0/S49
         BU5W9mOU8xREGTZL5NU3QTxD6Vb2YR9++a1KXEr01tZnWs7+VXroUE8g+7wo0mGr6Q7w
         Xorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6io9f0qG+FeIuCFgWGkOuaIH1Bd0r134hIVSeeos7Qk=;
        b=0wI5Dku9HfZNIklbAC9FU7fA2PUiTVjABGXfGhidwvKLPvNUQ8CZPPDppk7A8G6NSq
         dCxNRvqE5AykXbawqueutZ1beyfyfbeWRcyeoaNRVHdNcrchnNJHtw/iHXtPC37GU32I
         A+muzhNRGeyI6omn6UC8Gu5IxKThklh98gccZu2YHF/6w+LVIGV4i8ijAva6U2CXsSLD
         4+9XfWHyOl75N6v/hpM8aAhixf+D1NVb7L8bPEl8uqpnGiQsokR1ZnKchiHTuJCsgL+4
         3dnGhclEn0Eh83DIlxSyIv4SPjAblw1dobLe/zLnkOgCKAYmWhkceM9YA2lyY7vSXROl
         MtFg==
X-Gm-Message-State: AO0yUKWNT0J4iof/WjjyTINfB0B8MXf5Q62PQW12q5248Vp4rfMtKT1w
        1QuCwpLK/qoH42OvMi/3o4K7W36Zql2kk0Ww+YJcCQ==
X-Google-Smtp-Source: AK7set8qGQsHAmPWAdQ9p+Tx6HpAKeaGcJX+zugVJ94AyLdRl/DWPDyx/6sUXAlAOT7Q2FG5cfM/QQ==
X-Received: by 2002:a05:6a20:3d1c:b0:bc:54c6:b061 with SMTP id y28-20020a056a203d1c00b000bc54c6b061mr1805113pzi.34.1674832598927;
        Fri, 27 Jan 2023 07:16:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k81-20020a628454000000b00589a7824703sm2738508pfd.194.2023.01.27.07.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:16:38 -0800 (PST)
Message-ID: <63d3ead6.620a0220.f5f9.4567@mx.google.com>
Date:   Fri, 27 Jan 2023 07:16:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-146-gbf7101723cc0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 163 runs,
 4 regressions (v5.15.90-146-gbf7101723cc0)
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

stable-rc/queue/5.15 baseline: 163 runs, 4 regressions (v5.15.90-146-gbf710=
1723cc0)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-146-gbf7101723cc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-146-gbf7101723cc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf7101723cc0e864a7d71de3f070b0f547c82560 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3b90b86be98d4ce915ecc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d3b90b86be98d4ce915ed1
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-27T11:43:53.004139  + set +x
    2023-01-27T11:43:53.013136  <8>[    9.934993] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3227218_1.5.2.4.1>
    2023-01-27T11:43:53.121791  / # #
    2023-01-27T11:43:53.225355  export SHELL=3D/bin/sh
    2023-01-27T11:43:53.226565  #
    2023-01-27T11:43:53.328766  / # export SHELL=3D/bin/sh. /lava-3227218/e=
nvironment
    2023-01-27T11:43:53.329959  =

    2023-01-27T11:43:53.432417  / # . /lava-3227218/environment/lava-322721=
8/bin/lava-test-runner /lava-3227218/1
    2023-01-27T11:43:53.434198  =

    2023-01-27T11:43:53.434661  / # <3>[   10.273577] Bluetooth: hci0: comm=
and 0xfc18 tx timeout =

    ... (13 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3b805e1c142accd915edd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d3b805e1c142accd915ee2
        new failure (last pass: v5.15.81-121-gcb14018a85f6)

    2023-01-27T11:39:27.527783  + set +x
    2023-01-27T11:39:27.528080  [    9.345462] <LAVA_SIGNAL_ENDRUN 0_dmesg =
889348_1.5.2.3.1>
    2023-01-27T11:39:27.636270  / # #
    2023-01-27T11:39:27.738352  export SHELL=3D/bin/sh
    2023-01-27T11:39:27.739067  #
    2023-01-27T11:39:27.840540  / # export SHELL=3D/bin/sh. /lava-889348/en=
vironment
    2023-01-27T11:39:27.841206  =

    2023-01-27T11:39:27.942803  / # . /lava-889348/environment/lava-889348/=
bin/lava-test-runner /lava-889348/1
    2023-01-27T11:39:27.943384  =

    2023-01-27T11:39:27.945791  / # /lava-889348/bin/lava-test-runner /lava=
-889348/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3c1e4912fd0f25a915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d3c1e4912fd0f25a915ec7
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-27T12:21:17.638400  + set +x
    2023-01-27T12:21:17.641428  <8>[   16.057771] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3227188_1.5.2.4.1>
    2023-01-27T12:21:17.762445  / # #
    2023-01-27T12:21:17.868466  export SHELL=3D/bin/sh
    2023-01-27T12:21:17.870173  #
    2023-01-27T12:21:17.973927  / # export SHELL=3D/bin/sh. /lava-3227188/e=
nvironment
    2023-01-27T12:21:17.975560  =

    2023-01-27T12:21:18.079202  / # . /lava-3227188/environment/lava-322718=
8/bin/lava-test-runner /lava-3227188/1
    2023-01-27T12:21:18.082050  =

    2023-01-27T12:21:18.085170  / # /lava-3227188/bin/lava-test-runner /lav=
a-3227188/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d3b7fc68e06acb88915ebb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
146-gbf7101723cc0/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d3b7fc68e06acb88915ec0
        failing since 9 days (last pass: v5.15.82-123-gd03dbdba21ef, first =
fail: v5.15.87-100-ge215d5ead661)

    2023-01-27T11:39:25.005756  + set +x
    2023-01-27T11:39:25.009669  <8>[   16.017763] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 193125_1.5.2.4.1>
    2023-01-27T11:39:25.121031  / # #
    2023-01-27T11:39:25.223705  export SHELL=3D/bin/sh
    2023-01-27T11:39:25.224644  #
    2023-01-27T11:39:25.326884  / # export SHELL=3D/bin/sh. /lava-193125/en=
vironment
    2023-01-27T11:39:25.327454  =

    2023-01-27T11:39:25.429209  / # . /lava-193125/environment/lava-193125/=
bin/lava-test-runner /lava-193125/1
    2023-01-27T11:39:25.430501  =

    2023-01-27T11:39:25.434670  / # /lava-193125/bin/lava-test-runner /lava=
-193125/1 =

    ... (12 line(s) more)  =

 =20
