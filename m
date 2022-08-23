Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D4159E8BB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 19:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244619AbiHWRLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 13:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344989AbiHWRLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 13:11:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A314B11B00D
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 06:57:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id z187so13523945pfb.12
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 06:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=Opoyavn7pq18g2xDVtJ94HIQQozrYdBb8shkZ73uI/M=;
        b=hy5ARu5Y1hEbhvk+LBlRmLr73FIgh5JlDonXH8gDmTQgDJYGLCUtnfDrnAi8xUcAEY
         ImpmxXhCZSnYFy3lGNF0yR3F3XKQ25uq6kQ5sG86NagrGx9fNMqAgUzOHPgwWbm2dhIN
         nqDIuDecUXEMwDOb1ndYjctDgWsLjutHyK7A2lDsVtasvXNHt5fUZWqpZUTlkq+aYbXt
         z8K2SoTUspOeTrEIyteOQfPguI/t2GPEOpvP2p7wrw9Ayo9/h4C6tAfWP8dg56yoX3ZY
         kTrLnFWsmsHN89bhxt9++FtPHXITx0P0ASftE22KEg7jJwFP4LzBvtA9u7rz6GOLydFP
         kPgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Opoyavn7pq18g2xDVtJ94HIQQozrYdBb8shkZ73uI/M=;
        b=gBoWYzT7c8t/rueyJS2wKdfGvPDilBuqW0TP6XonBMrtE24b9Kl/lIOlLfHunoZIGM
         onqdF4DDzkgZhTGQGW7lax3mEo/dzQefXstfR7+h1/5fLUNqm2/zsuAT8n2ls2ZsVj2t
         s5eWk/hw72PNG3H5h2txW/qddpOBniIx8zYwizlSWrMlOfk/vOZKyale2h8Cg43os7Qc
         PKRizl94J7CyG1CifBwU6K4pz5eniS5puwgsZvRWiFYLyYqEk/uAN2GLYS2JWs8luEzr
         9wlwNEONnQnjcxDlo//4PCbFB+XXWVRxUB1K3Fqo6BGzgWjM7mUbjtsjas9qM4+eSdNS
         mJUQ==
X-Gm-Message-State: ACgBeo0Vy6b53NIBRAqSQfOqy0UxGlg8P3ZxXaM0eXVMW5dDjzH90jZA
        pax2kl0b/ypZBvta/bclj+oHSkz+QZ5KyX/V
X-Google-Smtp-Source: AA6agR4V2frVmgvk0xmxvd866mBc+60RBx2bYhWDRmLcbnI056W58H3VwnFuNYCgYKaF3zeP8+JhlA==
X-Received: by 2002:a05:6a00:2354:b0:536:c154:1ffc with SMTP id j20-20020a056a00235400b00536c1541ffcmr7364438pfj.28.1661263075015;
        Tue, 23 Aug 2022 06:57:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6-20020a63e106000000b0042a2777550dsm8464749pgh.47.2022.08.23.06.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 06:57:54 -0700 (PDT)
Message-ID: <6304dce2.630a0220.b4137.f4f3@mx.google.com>
Date:   Tue, 23 Aug 2022 06:57:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.62-245-g1450c8b12181
Subject: stable-rc/linux-5.15.y baseline: 171 runs,
 3 regressions (v5.15.62-245-g1450c8b12181)
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

stable-rc/linux-5.15.y baseline: 171 runs, 3 regressions (v5.15.62-245-g145=
0c8b12181)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
bcm2836-rpi-2-b  | arm   | lab-collabora | gcc-10   | bcm2835_defconfig    =
      | 1          =

beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.62-245-g1450c8b12181/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.62-245-g1450c8b12181
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1450c8b121813b14fb8de1c76fda4f87261c7cfd =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
bcm2836-rpi-2-b  | arm   | lab-collabora | gcc-10   | bcm2835_defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6304c1354bd70232a33556b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2-245-g1450c8b12181/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm=
2836-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2-245-g1450c8b12181/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm=
2836-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304c1354bd70232a3355=
6b5
        failing since 7 days (last pass: v5.15.59-31-g9c5eacc2ad1f6, first =
fail: v5.15.60-758-g5ab97c8bc34ec) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6304ad71cc99a5bb78355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2-245-g1450c8b12181/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2-245-g1450c8b12181/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304ad71cc99a5bb78355=
649
        failing since 102 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304ab9e685b9e5e75355642

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2-245-g1450c8b12181/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
2-245-g1450c8b12181/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6304ab9e685b9e5e75355668
        failing since 168 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-08-23T10:27:29.377590  /lava-7100475/1/../bin/lava-test-case
    2022-08-23T10:27:29.387813  <8>[   60.897280] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
