Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D876C1D2D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 18:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjCTRFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 13:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbjCTRFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 13:05:17 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F299DDA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:59:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id i24so13873728qtm.6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 09:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679331513;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=M4m5XCrm3/C//jeG9Jl4bbfShJxFHpqgQHQ58N1X68w=;
        b=J6kK9P66anJbB1xSqXDJZRwQ65btvjozmg0IRJrCHFvTthNSDhxz8Vp+XPy8/tEtJQ
         2weTs57diOfmhmrlbpH1+Eq63fTr0plnbMTFePf7SPSMezwNuIkrn7pA0fGp0HViaOG4
         5GwkG/vH7ltl5tImtxOukV+zjKyOCKIzG8d612CK92okVyNQgjPWLLsFYcmNNSa4FOM5
         Ha+96cXczKVlhEh+NaAiKbkL8gaPt4yfIebHhQkDGkOYoJUUsA47fGEkDGa8KqWXj0Pw
         PL2D9LDIgCBlAPykUjf9VV8ABK+y+D4Z6TadHFIC+8Y3NmqtZHNTfzmTLdRiniqqipTO
         ZSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679331513;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4m5XCrm3/C//jeG9Jl4bbfShJxFHpqgQHQ58N1X68w=;
        b=ovlvBajdFt43/sH/gKBwMqk/B54pzTlMB1RyM8NRjfMS+9qoiDlPzkuM18R47RmV1L
         5nifwP/7i+VbFlElV28jhImyuAIP/E+1VHJ9dV6iwHiSvK9n9a+gD0OxLQn+r+msxUlg
         NEfBgAd366MVW1aQI1IQL7Cl8vZ9KzFp2jDXxPtfy2wg0CYjonRGXnReoCo54tMMFZIp
         OOkeNT6Zmj/IYuCefnkftVaFE4DHfqTI5Pmy4rWEXRH8i+IGKPaF50Sf+F+l9Sd95J0y
         559BUFdDK72Wm4Z9zWIhBSHGDs8ovwfUFMhNAUgsGPJ1Tltn8rzf/3jB9C/dr/wRDuJH
         m75A==
X-Gm-Message-State: AO0yUKUEampbLeTvLZfG1n911+iMxvUCQPLB3QHy1Vdjl7rokU/ng2V9
        r77C2BglUmSLecF01wj+47mecex6xZzmBFjeT7xq+w==
X-Google-Smtp-Source: AK7set8qumeQlC2VdaLj+o5EBmZvNsK85XHO7LsMZ6YgHvuvCZZSL88Iq+pETeLYIdnRKOg5wcf5Bg==
X-Received: by 2002:aa7:9813:0:b0:625:d630:4e1b with SMTP id e19-20020aa79813000000b00625d6304e1bmr16688083pfl.31.1679331030732;
        Mon, 20 Mar 2023 09:50:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 135-20020a63078d000000b0050c08fcff4asm6516832pgh.8.2023.03.20.09.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 09:50:30 -0700 (PDT)
Message-ID: <64188ed6.630a0220.d7780.a793@mx.google.com>
Date:   Mon, 20 Mar 2023 09:50:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.175-69-g9116b59ba9be
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 11 regressions (v5.10.175-69-g9116b59ba9be)
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

stable-rc/queue/5.10 baseline: 168 runs, 11 regressions (v5.10.175-69-g9116=
b59ba9be)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-69-g9116b59ba9be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-69-g9116b59ba9be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9116b59ba9beda283020f587cb9cb07cac934e98 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641856f1f75951deb58c8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641856f1f75951deb58c8=
651
        failing since 5 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641856c83000106ae78c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641856c83000106ae78c8=
642
        failing since 5 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641856a240ff11b8678c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641856a240ff11b8678c8=
630
        failing since 5 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/641859122ab72b19198c863e

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641859122ab72b19198c866f
        failing since 34 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-20T13:00:31.361851  <8>[   19.663206] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 192390_1.5.2.4.1>
    2023-03-20T13:00:31.528406  / # #
    2023-03-20T13:00:31.643406  export SHELL=3D/bin/sh
    2023-03-20T13:00:31.649334  #
    2023-03-20T13:00:31.760436  / # export SHELL=3D/bin/sh. /lava-192390/en=
vironment
    2023-03-20T13:00:31.767038  =

    2023-03-20T13:00:31.878134  / # . /lava-192390/environment/lava-192390/=
bin/lava-test-runner /lava-192390/1
    2023-03-20T13:00:31.887370  =

    2023-03-20T13:00:31.891118  / # /lava-192390/bin/lava-test-runner /lava=
-192390/1
    2023-03-20T13:00:31.994153  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64185cbb6b2474d8698c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64185cbb6b2474d8698c8638
        failing since 53 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-20T13:16:33.222434  <8>[   10.917371] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3428774_1.5.2.4.1>
    2023-03-20T13:16:33.329427  / # #
    2023-03-20T13:16:33.431110  export SHELL=3D/bin/sh
    2023-03-20T13:16:33.431794  #
    2023-03-20T13:16:33.533358  / # export SHELL=3D/bin/sh. /lava-3428774/e=
nvironment
    2023-03-20T13:16:33.533829  =

    2023-03-20T13:16:33.635193  / # . /lava-3428774/environment/lava-342877=
4/bin/lava-test-runner /lava-3428774/1
    2023-03-20T13:16:33.635859  =

    2023-03-20T13:16:33.636055  / # <3>[   11.291531] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-20T13:16:33.641164  /lava-3428774/bin/lava-test-runner /lava-34=
28774/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6418576a247a0fdc4a8c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6418576a247a0fdc4a8c8=
642
        failing since 5 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641856a640ff11b8678c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641856a640ff11b8678c8=
652
        failing since 5 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641856a26c6c186e398c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641856a26c6c186e398c8=
660
        failing since 5 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64185e362ce4609f138c8639

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64185e362ce4609f138c8643
        failing since 6 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-20T13:22:56.705598  /lava-9699668/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64185e362ce4609f138c8644
        failing since 6 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-20T13:22:55.670254  /lava-9699668/1/../bin/lava-test-case

    2023-03-20T13:22:55.681179  <8>[   34.064470] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64185ca2a5a4775e778c8651

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-69-g9116b59ba9be/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64185ca3a5a4775e778c865a
        failing since 46 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-20T13:15:47.208863  / # #
    2023-03-20T13:15:47.310557  export SHELL=3D/bin/sh
    2023-03-20T13:15:47.310912  #
    2023-03-20T13:15:47.412232  / # export SHELL=3D/bin/sh. /lava-3428771/e=
nvironment
    2023-03-20T13:15:47.412603  =

    2023-03-20T13:15:47.513939  / # . /lava-3428771/environment/lava-342877=
1/bin/lava-test-runner /lava-3428771/1
    2023-03-20T13:15:47.514547  =

    2023-03-20T13:15:47.520148  / # /lava-3428771/bin/lava-test-runner /lav=
a-3428771/1
    2023-03-20T13:15:47.618055  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-20T13:15:47.618540  + cd /lava-3428771/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
