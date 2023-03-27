Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C56B6C9E75
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 10:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjC0Ioe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 04:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjC0IoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 04:44:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E34F6189
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 01:40:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z19so7724366plo.2
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 01:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679906422;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dQLK/hW7AKbgHNUEK4B79MVPIoXBvbJB6toLc77jEzw=;
        b=Zim8k0vzUE+khl9AfAYch5AnoKeHfUvh+wD2EOIdnpV04EfV/aB7Ibottf3TWjofAA
         Jrn2C5u7FtoMo07xehbH/jWfhvE0ldZNK8Y0SuatDSEiAn4GfTvUcRKLNSDY75cmXT9g
         zNN3r2Svm15ZLeb8zwFduKSEzXg7vodaFqTwWXVPJHnOqRkP9n2pFnhaqqLWA6nzRAOR
         rOQbK/yBq2UfozGToLifTiuKwS6hZ7TSaJwTlEv2T4uZUgYGfuvvgsZTCuGjiFtH2Ao/
         RopAU73Cymok7Gc1BLsDmckYxZIiL+2aywVV0AGklqWzEl/g7GZCzYWeT8k06uAmXvtO
         e5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679906422;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQLK/hW7AKbgHNUEK4B79MVPIoXBvbJB6toLc77jEzw=;
        b=HYZmpbKMiWKUDwWLI4DPYtfflUZgm/hJXtRmj52yJLR+60MNEPQs1VMz+dIflxVak6
         9z9z7d/DWGa2lbQ1Q45OGZtPnJM0RJLfUHHrRwABsonaKt4PTvCNJl3zhWxdky+n3C0+
         62SphFSO8HprjSZ/yQ0drkQEcq9VwGCdCCzlG40ybOnUFKyz5VUDR1dokWDgTd1ahEYu
         TZ04Qb4iJ/w8pvomtZSXkPdj7+WE2gvozioZgiH8bCl+RoyvXCgPzs49H8BnEK1yKYzO
         XSk/vVEHSK/KIYF+dyW5g0imAGIUIoEa/5NnO/uIsgYQbiJDhm2ZSevznm9eUg0PlBHZ
         UArw==
X-Gm-Message-State: AAQBX9faNkJUV5ngLMaJe87fOzQlyivBa6rd/45XyeM0ISDPRS9fo2jq
        wb1Wa9OBX8tgMTBR9let5udveKkIfEsgP7f9aX4=
X-Google-Smtp-Source: AKy350ad9qkZrCaCM+IViq/MKLLo/teXcfcmHvdT5yY4tGYv5jxXI5ywP7CRYXbuSh511dKNKB772A==
X-Received: by 2002:a17:902:f543:b0:1a1:ce5d:5a15 with SMTP id h3-20020a170902f54300b001a1ce5d5a15mr11769818plf.50.1679906422513;
        Mon, 27 Mar 2023 01:40:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1-20020a1709028ec100b0019f0ef910f7sm18571433plo.123.2023.03.27.01.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:40:22 -0700 (PDT)
Message-ID: <64215676.170a0220.a7a57.1fdc@mx.google.com>
Date:   Mon, 27 Mar 2023 01:40:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-60-gfc355b25292e
Subject: stable-rc/queue/5.10 baseline: 119 runs,
 3 regressions (v5.10.176-60-gfc355b25292e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 119 runs, 3 regressions (v5.10.176-60-gfc355=
b25292e)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
beaglebone-black             | arm  | lab-broonie  | gcc-10   | omap2plus_d=
efconfig | 1          =

cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-60-gfc355b25292e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-60-gfc355b25292e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc355b25292e68d1b33300fc30681ec374502ed3 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
beaglebone-black             | arm  | lab-broonie  | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/64211f3d63c7c40e0b9c954d

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-60-gfc355b25292e/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-60-gfc355b25292e/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64211f3d63c7c40e0b9c9585
        failing since 41 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-27T04:44:26.949456  <8>[   20.702586] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 233590_1.5.2.4.1>
    2023-03-27T04:44:27.060721  / # #
    2023-03-27T04:44:27.163669  export SHELL=3D/bin/sh
    2023-03-27T04:44:27.164303  #
    2023-03-27T04:44:27.266162  / # export SHELL=3D/bin/sh. /lava-233590/en=
vironment
    2023-03-27T04:44:27.266943  =

    2023-03-27T04:44:27.369158  / # . /lava-233590/environment/lava-233590/=
bin/lava-test-runner /lava-233590/1
    2023-03-27T04:44:27.370196  =

    2023-03-27T04:44:27.374382  / # /lava-233590/bin/lava-test-runner /lava=
-233590/1
    2023-03-27T04:44:27.485354  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/64211d652e4971f5459c9540

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-60-gfc355b25292e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-60-gfc355b25292e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64211d652e4971f5459c9549
        failing since 59 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-27T04:36:43.366197  + set +x<8>[   10.988897] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3448076_1.5.2.4.1>
    2023-03-27T04:36:43.366513  =

    2023-03-27T04:36:43.473722  / # #
    2023-03-27T04:36:43.575362  export SHELL=3D/bin/sh
    2023-03-27T04:36:43.575706  #
    2023-03-27T04:36:43.677046  / # export SHELL=3D/bin/sh. /lava-3448076/e=
nvironment
    2023-03-27T04:36:43.677466  =

    2023-03-27T04:36:43.677656  <3>[   11.210988] Bluetooth: hci0: command =
0xfc18 tx timeout
    2023-03-27T04:36:43.778792  / # . /lava-3448076/environment/lava-344807=
6/bin/lava-test-runner /lava-3448076/1
    2023-03-27T04:36:43.779324   =

    ... (13 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/64211d49cf05faed769c9570

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-60-gfc355b25292e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-60-gfc355b25292e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64211d49cf05faed769c9579
        failing since 53 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-27T04:36:02.150371  / # #
    2023-03-27T04:36:02.252179  export SHELL=3D/bin/sh
    2023-03-27T04:36:02.252622  #
    2023-03-27T04:36:02.353914  / # export SHELL=3D/bin/sh. /lava-3448079/e=
nvironment
    2023-03-27T04:36:02.354341  =

    2023-03-27T04:36:02.455691  / # . /lava-3448079/environment/lava-344807=
9/bin/lava-test-runner /lava-3448079/1
    2023-03-27T04:36:02.456336  =

    2023-03-27T04:36:02.462687  / # /lava-3448079/bin/lava-test-runner /lav=
a-3448079/1
    2023-03-27T04:36:02.560615  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-27T04:36:02.560962  + cd /lava-3448079/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
