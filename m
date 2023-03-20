Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C406C0988
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 05:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjCTEB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 00:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjCTEBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 00:01:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF1EE049
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 21:01:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j13so10845602pjd.1
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 21:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679284882;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7rrUxq9jlmXMPakqb/AnNt3ACkRLoBMHCqM3F7jCIvc=;
        b=D5gWM7wGbCOKzC5gnnzHELmwBXpLj3gC4JCicMBJvEjti+wk+YB2IU5pSnkl8nEYa/
         dnWVdO2ECMp5LhYBKQBbx7KgSlGXmcLpRp6JxKVHADSnj6ZCNUuxGGgLQ25UizEXK2n+
         WGkCN7pmugvFeoTtCC6VmpHyCTlUndSJmbbp6aC3CC04oC/obNLJevtNifObpWq8QCbS
         8IzC2OO0dSK+ZdPTPNAT1sgxoc1FlI4rKhg9NiMyN6qtUuv5/Zl+V7UDZqyWkLQvWFcD
         AF39kEhaqHfMmcFPfVJFQcWL02xY2dpd24QHrf/MgI+/6bQ+6yYZocYFpwoIquoSfeAS
         xcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679284882;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7rrUxq9jlmXMPakqb/AnNt3ACkRLoBMHCqM3F7jCIvc=;
        b=0dBXICDbYsrhDK2MtNM3pSGN4D8eIPXgQ9Pw9suuRlj894zOSy49y742yZwR5p01JA
         wdu7vDeFxiEsVmdw7rkcqWL+V5U6Hki08pH+KG9lIYiNlguZ47Iv0e3QhhECk71A6jY3
         Yk0N2xPh1atHfIK2JopV18I+5QVgM6pZKuDYyhAya4H5aRL0lEpguUuNN31e5ALwBBDL
         yhrijJmS7lWrfkenF4Ed96HpifNSfWTORLg4DPg4jZRddIp+s/PZM4RE+1zTc9mYnHcJ
         Nx8K+VZBCKlmOzXnFgPzothA/hUxNyekNDVZ7P1OpzoXbGXsTU//iGRQikze/B9imlxk
         2u7w==
X-Gm-Message-State: AO0yUKV0UXOPToyno1KST9jczp3QfQ7J3MHde6jVhneeBi44+DryCxmz
        7XwwhzWxIpewXtRm5KJCLDF0iJV7LtGM23yp+7I=
X-Google-Smtp-Source: AK7set8xG5u225DAWbqyYGqpsetPfCe3ov4+1XyjnqDpxIK4KnBigm2WYFcxS9VFkvLi6qc/NHZSjg==
X-Received: by 2002:a05:6a20:609:b0:d3:c972:9a83 with SMTP id 9-20020a056a20060900b000d3c9729a83mr13164563pzl.56.1679284882432;
        Sun, 19 Mar 2023 21:01:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15-20020aa791cf000000b005dd65169623sm5246554pfa.190.2023.03.19.21.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 21:01:22 -0700 (PDT)
Message-ID: <6417da92.a70a0220.f9206.926f@mx.google.com>
Date:   Sun, 19 Mar 2023 21:01:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.175-55-ge66cfb4eaff0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 9 regressions (v5.10.175-55-ge66cfb4eaff0)
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

stable-rc/queue/5.10 baseline: 118 runs, 9 regressions (v5.10.175-55-ge66cf=
b4eaff0)

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-55-ge66cfb4eaff0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-55-ge66cfb4eaff0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e66cfb4eaff04dbc0dc044b41634d4fe4a0b7cb0 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a3d9f9c5e1a1d08c8673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a3d9f9c5e1a1d08c8=
674
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a3d8f9c5e1a1d08c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a3d8f9c5e1a1d08c8=
65a
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a3d9f9c5e1a1d08c8670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a3d9f9c5e1a1d08c8=
671
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a488b31fb333cc8c8632

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417a488b31fb333cc8c866b
        failing since 34 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-20T00:10:31.007500  <8>[   19.917502] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 189473_1.5.2.4.1>
    2023-03-20T00:10:31.117796  / # #
    2023-03-20T00:10:31.220002  export SHELL=3D/bin/sh
    2023-03-20T00:10:31.220587  #
    2023-03-20T00:10:31.322144  / # export SHELL=3D/bin/sh. /lava-189473/en=
vironment
    2023-03-20T00:10:31.322713  =

    2023-03-20T00:10:31.424338  / # . /lava-189473/environment/lava-189473/=
bin/lava-test-runner /lava-189473/1
    2023-03-20T00:10:31.425302  =

    2023-03-20T00:10:31.429936  / # /lava-189473/bin/lava-test-runner /lava=
-189473/1
    2023-03-20T00:10:31.537231  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a4dbce798e5f4c8c8644

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417a4dbce798e5f4c8c864d
        failing since 52 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-20T00:11:52.834137  <8>[   11.046430] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3426735_1.5.2.4.1>
    2023-03-20T00:11:52.943266  / # #
    2023-03-20T00:11:53.053932  export SHELL=3D/bin/sh
    2023-03-20T00:11:53.054425  #
    2023-03-20T00:11:53.155924  / # export SHELL=3D/bin/sh. /lava-3426735/e=
nvironment
    2023-03-20T00:11:53.156707  =

    2023-03-20T00:11:53.258564  / # . /lava-3426735/environment/lava-342673=
5/bin/lava-test-runner /lava-3426735/1
    2023-03-20T00:11:53.259106  <3>[   11.371972] Bluetooth: hci0: command =
0xfc18 tx timeout
    2023-03-20T00:11:53.259243  =

    2023-03-20T00:11:53.264103  / # /lava-3426735/bin/lava-test-runner /lav=
a-3426735/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a3d7f9c5e1a1d08c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a3d7f9c5e1a1d08c8=
657
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a3daf9c5e1a1d08c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a3daf9c5e1a1d08c8=
677
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a504d14182289e8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a504d14182289e8c8=
630
        failing since 4 days (last pass: v5.10.173-89-gbb0818a7908b, first =
fail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6417a49fb31fb333cc8c869c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-55-ge66cfb4eaff0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417a49fb31fb333cc8c86a5
        failing since 46 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-20T00:10:47.733059  / # #
    2023-03-20T00:10:47.834898  export SHELL=3D/bin/sh
    2023-03-20T00:10:47.835413  #
    2023-03-20T00:10:47.936807  / # export SHELL=3D/bin/sh. /lava-3426732/e=
nvironment
    2023-03-20T00:10:47.937332  =

    2023-03-20T00:10:48.038713  / # . /lava-3426732/environment/lava-342673=
2/bin/lava-test-runner /lava-3426732/1
    2023-03-20T00:10:48.039507  =

    2023-03-20T00:10:48.044094  / # /lava-3426732/bin/lava-test-runner /lav=
a-3426732/1
    2023-03-20T00:10:48.108156  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-20T00:10:48.147947  + cd /lava-3426732/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
