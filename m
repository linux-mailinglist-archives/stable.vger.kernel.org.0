Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FB6527AFF
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 02:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiEPAXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 20:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiEPAW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 20:22:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC9C35A83
        for <stable@vger.kernel.org>; Sun, 15 May 2022 17:22:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i17so12949170pla.10
        for <stable@vger.kernel.org>; Sun, 15 May 2022 17:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t27hfATMzpCrt++3kdiNX2/xfoMB4jU8RRXNW8N9a4w=;
        b=ytugty9bTq6P47lloXsJASLxz21ip0BQOkA/eZUhCrsWdZlUKUi7AWjuh7Mq7l0Z8e
         QshZYXVkB570KjkLjkbs7B/61dpfTClmTSTGor/BnjaCw06IM5euQ7kq8Lrl7YmCZLDH
         OtWqg3M0CbJFXzPY+dnfoxRXBLYB0DGFCGpwO45hwOQOOGu3Tbl3E0MzOutu5jHTB1bZ
         jvd8I0SmpQmsGasdqX3ueajiDBbgNn/y7cwZaZi+8fLaQP/gkS3KC6p708VzFSSBYQf2
         x4c95O8O/pYhMeDSQJx2gD88s3rx6TDMFpo2cRzNPopghDXE1GKhIr69f/ztAmSxPjrF
         kwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t27hfATMzpCrt++3kdiNX2/xfoMB4jU8RRXNW8N9a4w=;
        b=dqze2lIvQLnxJd4Q5qBO+jIOK0/U9Krh24p3x9y2pLsdLCtOzklnibyDw5fBQLDO2w
         Acscquox4fq7BivSP7YqvpqszdzgQvptuHGl3YIuOnKOk0/wVehqyvy870M8pRJIi+tN
         dt8IqJQiLSZUFL305AhorjJ83cYi5SRSxNrPj/R4HFkWdHKLD8xzwDmrF50zKmiq2dEg
         8Ut4YmcPnIMsiSZfrP92a8N0g6q0kcbnykuuop/oHMlksPALb3K/P+Xpd0vFVNgTsRv/
         AsYjRbi8Q10ep4JjJr/UGXqDpBQSBNpfwuzdQMsejvghQrUDwu3bPJaA7NnQO4Iwi34w
         Bh3A==
X-Gm-Message-State: AOAM5327vINNIkcYRzQ8HPxnXjF7MQ8wOSc0zx3+NHOXoUgCEbThQCVi
        bVcuC5nqul87HWJCXcCp5dZ898nhH91ysn0o+98=
X-Google-Smtp-Source: ABdhPJyVnfaEc+7nngaVT0YosgrJOYomVLHYZ07/yYoFCLOXRcvHQlXtPI7sHOQPiNKfy0i7ZGYKGQ==
X-Received: by 2002:a17:902:c2d8:b0:15e:fa17:56cc with SMTP id c24-20020a170902c2d800b0015efa1756ccmr15479428pla.40.1652660577572;
        Sun, 15 May 2022 17:22:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f10-20020a6547ca000000b003c5e836eddasm5419700pgs.94.2022.05.15.17.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 17:22:57 -0700 (PDT)
Message-ID: <62819961.1c69fb81.1632b.d882@mx.google.com>
Date:   Sun, 15 May 2022 17:22:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.39-83-ge8ec14207c651
Subject: stable-rc/queue/5.15 baseline: 108 runs,
 4 regressions (v5.15.39-83-ge8ec14207c651)
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

stable-rc/queue/5.15 baseline: 108 runs, 4 regressions (v5.15.39-83-ge8ec14=
207c651)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
beagle-xm           | arm    | lab-baylibre  | gcc-10   | omap2plus_defconf=
ig          | 1          =

hp-x360-14-G1-sona  | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6=
-chromebook | 1          =

r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-10   | defconfig        =
            | 1          =

rk3399-gru-kevin    | arm64  | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.39-83-ge8ec14207c651/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.39-83-ge8ec14207c651
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8ec14207c6519d4090698dc7a43865865b15dfd =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
beagle-xm           | arm    | lab-baylibre  | gcc-10   | omap2plus_defconf=
ig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6281674971b87a6b008f5798

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6281674971b87a6b008f5=
799
        failing since 46 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
hp-x360-14-G1-sona  | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628166362324b2ab6a8f574b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628166362324b2ab6a8f5=
74c
        new failure (last pass: v5.15.39-21-g8fbe504de79e) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-10   | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/6281675d349bda4cc18f572a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6281675d349bda4cc18f5=
72b
        new failure (last pass: v5.15.39-21-g8fbe504de79e) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
rk3399-gru-kevin    | arm64  | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6281774c73198627be8f5737

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.39-=
83-ge8ec14207c651/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6281774c73198627be8f5759
        failing since 69 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-15T21:57:17.361844  <8>[   32.429577] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-15T21:57:18.384896  /lava-6383881/1/../bin/lava-test-case
    2022-05-15T21:57:18.396204  <8>[   33.464190] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
