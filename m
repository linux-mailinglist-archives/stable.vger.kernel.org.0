Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D43C680983
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 10:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbjA3Jak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 04:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbjA3JaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 04:30:12 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D724D65AB
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 01:28:04 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so10453268pjb.5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 01:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FDCMfccTBkEoRp5DUa1rBZML3+oUSviuRaCyW71BQx8=;
        b=qJzc0wD2ZZ/OXEufRVyaExlHFb2wkYZ6H7h+oWExgb95PzLExyLJ2nPmsh7YDAk5yY
         pYbmeA+TnrzX532lxM0tBda3yRDtf0wKx5OON54Uq1nys7+J5l2KNkKtJdWADBUxAbo8
         eP7NXhFPdBzJgtKVHltACPPkClO8SYRuh1Ys/YBUFlLiBetFpqdqosMdqPUVIFwnYUUH
         JRn7iTHM6KBGWocrZrbSlJdT+6UlWUDaSP1WZjli1cUMzuCC3uuLhOxaXK0WUpyQgsZC
         Nbk6V3FQbAHGaq3BkR6vc70vgT1nAEl2RzQMLeAyrlXlkseA1QjEXjrvMHH3QL9SuktU
         RvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FDCMfccTBkEoRp5DUa1rBZML3+oUSviuRaCyW71BQx8=;
        b=ULzjRrvsoK6U1RFv1/b1beJag//2riXyIFYVfq7HgthqVLRUiA3UlT4+ktmQYfPu9L
         Oa7N2rnPQWQ7XeXOh0urvGbPWNjeO5Mrsf8wZ8AEBD5izaVH3spHXi4afkj+RcUfNikH
         yqm25NkM6aLWZrjRX2BftNKhweyDgxAh/GNLAoAPw51XrHSo4vFADqKk7s6s/jbSRmb/
         oeqLaA1Xf+fqdk/giYZAtxAwFPDZSht3SplqAiykDX5KZg3LyMMEz1yYJOLq6iiLYFPx
         Zruy4yTrgVoP17t6JenCED0O9HQQ9rH7m5Dn3jd18abRVRk6yKopHWh+Hay1zBpJBHsW
         zJgA==
X-Gm-Message-State: AO0yUKXQNbhK4XlCGidAbsEYl/zle/jzJBupx4+Bt+rM8WPSSQtTUiuA
        jNj03iA2VR4Es/ilHW3iC8MALegyOy+MtcwyXIs=
X-Google-Smtp-Source: AK7set8/4V/uFuEnpPQKOMZBOIRodWBElzGZIw8DIjMcxcdAArto7Gzj+w9e0Tgsw7QuQ3qoxJpSDw==
X-Received: by 2002:a17:902:d491:b0:196:2e10:ba5c with SMTP id c17-20020a170902d49100b001962e10ba5cmr9707334plg.49.1675070792946;
        Mon, 30 Jan 2023 01:26:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18-20020a170902b61200b0016d72804664sm7258075pls.205.2023.01.30.01.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 01:26:32 -0800 (PST)
Message-ID: <63d78d48.170a0220.e1935.b551@mx.google.com>
Date:   Mon, 30 Jan 2023 01:26:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-196-g9b5da855156e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 182 runs,
 3 regressions (v5.15.90-196-g9b5da855156e)
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

stable-rc/queue/5.15 baseline: 182 runs, 3 regressions (v5.15.90-196-g9b5da=
855156e)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-196-g9b5da855156e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-196-g9b5da855156e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9b5da855156ea192d1080ca081a6ba76e82301dd =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d75b0c5f0baab337915ecb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
196-g9b5da855156e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
196-g9b5da855156e/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d75b0c5f0baab337915ed0
        failing since 2 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-01-30T05:51:48.145942  + set +x
    2023-01-30T05:51:48.146116  [    9.565344] <LAVA_SIGNAL_ENDRUN 0_dmesg =
891523_1.5.2.3.1>
    2023-01-30T05:51:48.253996  / # #
    2023-01-30T05:51:48.355662  export SHELL=3D/bin/sh
    2023-01-30T05:51:48.356068  #
    2023-01-30T05:51:48.457235  / # export SHELL=3D/bin/sh. /lava-891523/en=
vironment
    2023-01-30T05:51:48.457679  =

    2023-01-30T05:51:48.558962  / # . /lava-891523/environment/lava-891523/=
bin/lava-test-runner /lava-891523/1
    2023-01-30T05:51:48.559656  =

    2023-01-30T05:51:48.562424  / # /lava-891523/bin/lava-test-runner /lava=
-891523/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d75d1ab6e2c4a27e915ebf

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
196-g9b5da855156e/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
196-g9b5da855156e/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d75d1ab6e2c4a27e915ec4
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T06:00:33.951639  + set +x
    2023-01-30T06:00:33.955789  <8>[   16.132853] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3242941_1.5.2.4.1>
    2023-01-30T06:00:34.077667  / # #
    2023-01-30T06:00:34.183933  export SHELL=3D/bin/sh
    2023-01-30T06:00:34.185609  #
    2023-01-30T06:00:34.289516  / # export SHELL=3D/bin/sh. /lava-3242941/e=
nvironment
    2023-01-30T06:00:34.291261  =

    2023-01-30T06:00:34.394877  / # . /lava-3242941/environment/lava-324294=
1/bin/lava-test-runner /lava-3242941/1
    2023-01-30T06:00:34.397722  =

    2023-01-30T06:00:34.400084  / # /lava-3242941/bin/lava-test-runner /lav=
a-3242941/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d75b23ecce697c8d915f72

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
196-g9b5da855156e/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
196-g9b5da855156e/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d75b23ecce697c8d915f77
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T05:52:22.218901  + set +x
    2023-01-30T05:52:22.222382  <8>[   16.001310] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 209226_1.5.2.4.1>
    2023-01-30T05:52:22.332507  / # #
    2023-01-30T05:52:22.434412  export SHELL=3D/bin/sh
    2023-01-30T05:52:22.434983  #
    2023-01-30T05:52:22.536647  / # export SHELL=3D/bin/sh. /lava-209226/en=
vironment
    2023-01-30T05:52:22.537271  =

    2023-01-30T05:52:22.638911  / # . /lava-209226/environment/lava-209226/=
bin/lava-test-runner /lava-209226/1
    2023-01-30T05:52:22.639767  =

    2023-01-30T05:52:22.643792  / # /lava-209226/bin/lava-test-runner /lava=
-209226/1 =

    ... (12 line(s) more)  =

 =20
