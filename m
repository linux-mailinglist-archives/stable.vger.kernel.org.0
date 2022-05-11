Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE152401A
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 00:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235676AbiEKWMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 May 2022 18:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiEKWMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 May 2022 18:12:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4726EC4C
        for <stable@vger.kernel.org>; Wed, 11 May 2022 15:12:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h186so305300pgc.3
        for <stable@vger.kernel.org>; Wed, 11 May 2022 15:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BsAhKWa82XoGFi4QO58hnKoecmbQ11fF08MwG+JVryI=;
        b=rqsksQKICZqMXGPE59g0HA6rNto+o9d+ZV+GWCuMriFpFZRxzR1QVIGX86r0PaBeo3
         pNk15pXeYXfH75IctkcTB/IM9Kycu6lTy01aYRxk9dZ1zALlfBvGsQWA3nfdQBHCrO/s
         kLUKFV/kT+Hs9hnE31EyVmiKDRErGLkUkRNolMzELezWI3mTvqDQaAa0/ruYCpnSQ075
         TWQVAMZbt39iwdbbfj8bBPdW5OpTlWr//yn/Tn4NS/hKF+LbvKB/1wD42EaIQiMDY9tW
         1/1HEGZcHX4ajex7OBjGZ8fIMSIzag2avNvFehBBbqHCdPc4d7eSWoLainPEwnmCNp8I
         X/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BsAhKWa82XoGFi4QO58hnKoecmbQ11fF08MwG+JVryI=;
        b=T6WY+oQy1PRgXE7fh9JfIz/hoxmxO58RaLxhphqa8Dc9hDDAksEYUqdhJqmgjqKp80
         YPMpdgR3EPQCC5kAt3+KjbxXhblvmRlo/Z8L4i4y6ZE5yzkLoaq9dWswk2LaomhfIjXY
         xIsvjl1NfX2SpzR4n/hEiNp0HYEfyg9c2B192GpN+3f4Kn4cZ61DaqNKoa4HUproywyE
         lqGyWH2xD2IRDUSuB1DreUaYasI6cgSuAtGDY89AkElHOi5M15VKTqmA2CU4uiSeHlYi
         SU4I8EjA4hTQNtEz/35sQhH8j/u8AHpRQEHQ56WDW5n7XWNXOb8M1EeQWFRyFVPXllX9
         pGww==
X-Gm-Message-State: AOAM531d/peSgzjzUwkgoTtKnv0JFiW+3zZwLOb7kDaWJjfl99l+atAi
        5Njc/2iXWra8MCmZj0MYUVfgMcf6omXfLAUth3E=
X-Google-Smtp-Source: ABdhPJwXDOpqQf/VkD7DAW/SNixhN7gfnyjDcGPpt1HUaWLRPp600PgKeZkSW4xcicJqZ0pBqdq7/A==
X-Received: by 2002:a63:e218:0:b0:3c6:7449:15a2 with SMTP id q24-20020a63e218000000b003c6744915a2mr18955549pgh.515.1652307170778;
        Wed, 11 May 2022 15:12:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2-20020aa78582000000b0050dc762814esm2272491pfn.40.2022.05.11.15.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 15:12:50 -0700 (PDT)
Message-ID: <627c34e2.1c69fb81.f77c5.51da@mx.google.com>
Date:   Wed, 11 May 2022 15:12:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.38-150-g305e905f7031
Subject: stable-rc/queue/5.15 baseline: 142 runs,
 3 regressions (v5.15.38-150-g305e905f7031)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 142 runs, 3 regressions (v5.15.38-150-g305e9=
05f7031)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.38-150-g305e905f7031/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.38-150-g305e905f7031
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      305e905f70311e1b49cc730931a19c3e364f4d8c =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
beagle-xm           | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g        | 1          =


  Details:     https://kernelci.org/test/plan/id/627c0345099af32bf48f5725

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.38-=
150-g305e905f7031/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.38-=
150-g305e905f7031/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627c0345099af32bf48f5=
726
        failing since 41 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/627c085f60a525ed988f5722

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.38-=
150-g305e905f7031/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.38-=
150-g305e905f7031/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627c085f60a525ed988f5=
723
        new failure (last pass: v5.15.37-313-gf15ef1d11d7a) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627c0fbb2a8313eb4a8f571a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.38-=
150-g305e905f7031/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.38-=
150-g305e905f7031/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627c0fbb2a8313eb4a8f573b
        failing since 64 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-11T19:33:50.098479  <8>[   32.562303] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-11T19:33:51.120845  /lava-6341783/1/../bin/lava-test-case
    2022-05-11T19:33:51.132243  <8>[   33.597075] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
