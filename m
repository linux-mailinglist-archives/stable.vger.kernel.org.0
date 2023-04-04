Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF56D7109
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 01:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbjDDX7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 19:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbjDDX7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 19:59:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EB44224
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 16:59:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so35605445pjt.5
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 16:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680652770;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CIusesIkfE6j1Ov9GJK34VpL+fB5gMJeqfyieRMAt6A=;
        b=qTDgpaKEAqrMBntwflmttyRmmMObKHAPzEW7KyRn6tTR3AZmazak1irWylUpTm1VcI
         2XTkc0cXsymo4z7y9YJl6TichTRcK2ye15unFo58CoL9GlMhWGjHj4V+TEUd+a7mpFLR
         mKbqTC0nn2xNpQdBjL7hgUDGEFT3g91ZBniDpyRdzRVlTvuC+gxdBB9XOCVq30rkfZ09
         +CDL4+cTNZrXTn5+hNYq5LyU6F16tifJHIpSNLMh5XRUWPTY6JB8P18h3qlL6eKVZspE
         dBvSOT0Mi1mFB3Z/jyQDM8wD94K/O4er1ppyiENvCo0EdjcjbAEEW4phApmFexJvCcVs
         /C1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680652770;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CIusesIkfE6j1Ov9GJK34VpL+fB5gMJeqfyieRMAt6A=;
        b=g1zqG3jBcJG9i8REuo21YYsRsigYeu7Yd/QP0zNyRQG2VFy5gBD1sVSfMscKFIvl+I
         OSsVox9fCVOsusZe4nLja5NGomZl7dEUZH4iNJu7/ZX8YVumditGTl21gv8cCHodpeSU
         2N4FFePlXzNWMUPo7n+MLKfgsz4n+GdQorxrJ6xE5jP4IKNLc29YsfFFlRCaLv8fuBFs
         Ax42z6INytOb3MIBhKfuyOxXiaYCivmbj19KG+l3OawMJ9DpXUa9x6WyyJqo0GzJx78J
         axwitKadB4pGUZXUNaAbEtV4l20rlxN41dfjOVjQ9i/mwzy6P8UWdj/CHNjeiVk9eeiL
         onmQ==
X-Gm-Message-State: AAQBX9eSfSSjoUzD30m0yvLBTueyJYRbVVMmg83ZyoM+a6cBsx9iTs4L
        ZsrgAQDeckugY6HBZmpoLOswpMTF4vTWKdcJUJToLg==
X-Google-Smtp-Source: AKy350bh1DGK/VmevlDeDPdvvCoEh3PA3ZvP61NivkIP3n0DAXwCPSvuMcJkbd1sdi8vy0hhOqDPxA==
X-Received: by 2002:a05:6a20:4e10:b0:d6:847d:c7af with SMTP id gk16-20020a056a204e1000b000d6847dc7afmr823756pzb.16.1680652770429;
        Tue, 04 Apr 2023 16:59:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020aa78047000000b00592626fe48csm9236904pfm.122.2023.04.04.16.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 16:59:30 -0700 (PDT)
Message-ID: <642cb9e2.a70a0220.9e66f.37b6@mx.google.com>
Date:   Tue, 04 Apr 2023 16:59:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-172-g3ee877b09bdd
Subject: stable-rc/queue/5.10 baseline: 97 runs,
 5 regressions (v5.10.176-172-g3ee877b09bdd)
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

stable-rc/queue/5.10 baseline: 97 runs, 5 regressions (v5.10.176-172-g3ee87=
7b09bdd)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-172-g3ee877b09bdd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-172-g3ee877b09bdd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ee877b09bddb415deefc3bdb73b39418626bf6e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642c8111761e5b9a2b79e973

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c8111761e5b9a2b79e9a7
        failing since 49 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-04T19:56:36.205982  <8>[   20.542339] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 277700_1.5.2.4.1>
    2023-04-04T19:56:36.370146  / # #
    2023-04-04T19:56:36.489302  export SHELL=3D/bin/sh
    2023-04-04T19:56:36.494525  #
    2023-04-04T19:56:36.603480  / # export SHELL=3D/bin/sh. /lava-277700/en=
vironment
    2023-04-04T19:56:36.610712  =

    2023-04-04T19:56:36.721458  / # . /lava-277700/environment/lava-277700/=
bin/lava-test-runner /lava-277700/1
    2023-04-04T19:56:36.732309  =

    2023-04-04T19:56:36.736185  / # /lava-277700/bin/lava-test-runner /lava=
-277700/1
    2023-04-04T19:56:36.842374  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c7edfea73e4c61579e954

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c7edfea73e4c61579e957
        failing since 5 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-04T19:47:34.898762  + <8>[   10.158398] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9867711_1.4.2.3.1>

    2023-04-04T19:47:34.899210  set +x

    2023-04-04T19:47:35.004501  #

    2023-04-04T19:47:35.005450  =


    2023-04-04T19:47:35.107553  / # #export SHELL=3D/bin/sh

    2023-04-04T19:47:35.107747  =


    2023-04-04T19:47:35.208674  / # export SHELL=3D/bin/sh. /lava-9867711/e=
nvironment

    2023-04-04T19:47:35.208905  =


    2023-04-04T19:47:35.309989  / # . /lava-9867711/environment/lava-986771=
1/bin/lava-test-runner /lava-9867711/1

    2023-04-04T19:47:35.310799  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c7eddea73e4c61579e949

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c7eddea73e4c61579e94e
        failing since 5 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-04T19:47:27.973423  + set +x

    2023-04-04T19:47:27.979721  <8>[   12.343835] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9867684_1.4.2.3.1>

    2023-04-04T19:47:28.081754  =


    2023-04-04T19:47:28.182657  / # #export SHELL=3D/bin/sh

    2023-04-04T19:47:28.182825  =


    2023-04-04T19:47:28.283824  / # export SHELL=3D/bin/sh. /lava-9867684/e=
nvironment

    2023-04-04T19:47:28.283966  =


    2023-04-04T19:47:28.384870  / # . /lava-9867684/environment/lava-986768=
4/bin/lava-test-runner /lava-9867684/1

    2023-04-04T19:47:28.385091  =


    2023-04-04T19:47:28.390466  / # /lava-9867684/bin/lava-test-runner /lav=
a-9867684/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642c87be62fd34a67379e922

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-172-g3ee877b09bdd/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642c87be62fd34a67379e928
        failing since 21 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-04T20:25:13.289398  <8>[   33.849641] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-04T20:25:14.314976  /lava-9868100/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642c87be62fd34a67379e929
        failing since 21 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-04T20:25:12.252996  <8>[   32.813031] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-04T20:25:13.277929  /lava-9868100/1/../bin/lava-test-case
   =

 =20
