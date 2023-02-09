Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480A6690F51
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 18:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjBIRfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 12:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIRfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 12:35:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A724216
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 09:35:11 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m2-20020a17090a414200b00231173c006fso6250225pjg.5
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 09:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6ggscCm8U2X9n+0r8A4NZp9fTTruTYKVdxeAQDH4VKw=;
        b=PuW92lt+HsS/LtCjDqeGnnYuM5ZkqfIRtX5HH8PVnUk4n6VhK3yg4CpOruJU+Fz2E0
         WIZYGrSu3R5zXwYJh2NH3FgXGfXMuwCGgxWDWPgJmCL7aAYkV8/1MdGp101wP23M92Q8
         YcNsN7gNDiob+kZ0u//2T/JBQFjri9G1/PcdfVzPscjs3CkJE53v+DsXLV/YQuvR55dY
         EkFXuG3COoBtw268K+CEIbm1ihGa5E1bQj/N9RA1MkW1O9YKJ6b0abGhYME3SS5mb7Do
         QdqXHnvR5ZVs+2Z3/wR1w5fs3a24zpwJY9s6VFt1tWd9PM3tG0J8p5IYEmR6cDEXaT8O
         SoYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ggscCm8U2X9n+0r8A4NZp9fTTruTYKVdxeAQDH4VKw=;
        b=5z3LehGBf+HHvKNBSoYykH/YBNNO8kVSZFz1p6ZX0tnpCbjpwfeiHm0eC6/RdW4uIW
         F1R9oz9pMq4Oq4nS726WsNM7FvEELD6JhJhkdHUJWBH1xjovYqHLSFLeQ8q56ULQmzd/
         m4WoR7rMA6yygSWfdZJfhAfjPRwNsMsg1QrIzWp8uP1Mp1kH8hb3s68foDHa/JmLMhtc
         R+l+xe5QLbc5wSAaDGyDIF3Wx1lIIwCLSCQZcbhoKAM7IweGTlRt2Wedsiv9ltU7GoG5
         nXTWTuyiEGbMJuvA6MSgjtv01TcospKx0+wficf1/c6cbP28FAcWILjoj0tP/5JXxNKP
         PD3Q==
X-Gm-Message-State: AO0yUKXChYTyyenalX9xnQzyclqL616LnlZ4MH1Or16AGnV5b1g3/7r4
        HWGmYDISsFkTJ9emDjKIQe5X/IRisz4IpBMrM0s=
X-Google-Smtp-Source: AK7set/UHSrLM24djVa4o7UOFcUZKcKII2oZ4das3I/hTa1+GXcWaheCSJSNSfQoDHxJOOpXJnb0DQ==
X-Received: by 2002:a17:902:d40d:b0:194:586a:77ba with SMTP id b13-20020a170902d40d00b00194586a77bamr9679599ple.52.1675964111182;
        Thu, 09 Feb 2023 09:35:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d68b00b00192b23b8451sm1779089ply.108.2023.02.09.09.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 09:35:10 -0800 (PST)
Message-ID: <63e52ece.170a0220.974c0.3121@mx.google.com>
Date:   Thu, 09 Feb 2023 09:35:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.15.93
X-Kernelci-Report-Type: test
Subject: stable/linux-5.15.y baseline: 219 runs, 4 regressions (v5.15.93)
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

stable/linux-5.15.y baseline: 219 runs, 4 regressions (v5.15.93)

Regressions Summary
-------------------

platform        | arch  | lab             | compiler | defconfig           =
         | regressions
----------------+-------+-----------------+----------+---------------------=
---------+------------
cubietruck      | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfig  =
         | 1          =

imx53-qsrb      | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfig  =
         | 1          =

meson-gxm-q200  | arm64 | lab-baylibre    | gcc-10   | defconfig+kselftest =
         | 1          =

mt8173-elm-hana | arm64 | lab-collabora   | gcc-10   | defconfig+arm...ok+k=
selftest | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.93/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      85d7786c66b69d3f07cc149ac2f78d8f330c7c11 =



Test Regressions
---------------- =



platform        | arch  | lab             | compiler | defconfig           =
         | regressions
----------------+-------+-----------------+----------+---------------------=
---------+------------
cubietruck      | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4fb2795bfdc33888c867a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4fb2795bfdc33888c8683
        failing since 21 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-02-09T13:54:30.821246  <8>[    9.964333] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3313035_1.5.2.4.1>
    2023-02-09T13:54:30.932000  / # #
    2023-02-09T13:54:31.033659  export SHELL=3D/bin/sh
    2023-02-09T13:54:31.034669  #
    2023-02-09T13:54:31.136842  / # export SHELL=3D/bin/sh. /lava-3313035/e=
nvironment
    2023-02-09T13:54:31.137820  =

    2023-02-09T13:54:31.138305  / # . /lava-3313035/environment<3>[   10.27=
7524] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-09T13:54:31.240440  /lava-3313035/bin/lava-test-runner /lava-33=
13035/1
    2023-02-09T13:54:31.241948  =

    2023-02-09T13:54:31.246404  / # /lava-3313035/bin/lava-test-runner /lav=
a-3313035/1 =

    ... (12 line(s) more)  =

 =



platform        | arch  | lab             | compiler | defconfig           =
         | regressions
----------------+-------+-----------------+----------+---------------------=
---------+------------
imx53-qsrb      | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4fab8e8a969a0b18c863d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4fab8e8a969a0b18c8646
        failing since 8 days (last pass: v5.15.81, first fail: v5.15.91)

    2023-02-09T13:52:33.331879  [    9.390339] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-02-09T13:52:33.339335  + set +x
    2023-02-09T13:52:33.339536  [    9.401399] <LAVA_SIGNAL_ENDRUN 0_dmesg =
901903_1.5.2.3.1>
    2023-02-09T13:52:33.451892  / # #
    2023-02-09T13:52:33.555880  export SHELL=3D/bin/sh
    2023-02-09T13:52:33.556474  #
    2023-02-09T13:52:33.663891  / # export SHELL=3D/bin/sh. /lava-901903/en=
vironment
    2023-02-09T13:52:33.664282  =

    2023-02-09T13:52:33.766304  / # . /lava-901903/environment/lava-901903/=
bin/lava-test-runner /lava-901903/1
    2023-02-09T13:52:33.767130   =

    ... (13 line(s) more)  =

 =



platform        | arch  | lab             | compiler | defconfig           =
         | regressions
----------------+-------+-----------------+----------+---------------------=
---------+------------
meson-gxm-q200  | arm64 | lab-baylibre    | gcc-10   | defconfig+kselftest =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/63e501a1182f300e6e8c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm64/defconfig+kselftest/gcc-10/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm64/defconfig+kselftest/gcc-10/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e501a1182f300e6e8c8=
644
        new failure (last pass: v5.15.92) =

 =



platform        | arch  | lab             | compiler | defconfig           =
         | regressions
----------------+-------+-----------------+----------+---------------------=
---------+------------
mt8173-elm-hana | arm64 | lab-collabora   | gcc-10   | defconfig+arm...ok+k=
selftest | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4feb21a9678bac28c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.93/a=
rm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt8=
173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e4feb21a9678bac28c8=
633
        failing since 16 days (last pass: v5.15.89, first fail: v5.15.90) =

 =20
