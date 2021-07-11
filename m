Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0023C3EDF
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 21:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGKTju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 15:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKTju (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 15:39:50 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E93C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 12:37:03 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v7so15882265pgl.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 12:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gAiy2G7fCIwsalQRspMcUTgdg/6DK96ZK1t7wrfvRSw=;
        b=2OoBq8w3MDr6qHKSREq5QpPwfm/Kzp19Qg8B6Ard0ZZOA+Z51FcJQfzoMZdVXBNbPJ
         HnNT64NP8YBCbOj3L585EmWIz8qLWsyTfgiKlzCwUoM6t3NxzY0U7JkErh/i1jz6yEMN
         gx4OjDIgIVmrSVyz/nZEc5VWamnn2kLTcis7/hqe09dJoxwnnDhCWwCvL3dWt7Z7EBQ/
         SURS/Tly5Em14JLDDofYc4ZmGrO9JKJaiZZFwliSI1S4vs48D6p5tyAQ/VoF237u8Nea
         C9PBQlAYbNwGe7dG3m1bBM2aXNEkSHzTQnjVy7Wyy6/J93hP4eI4nMZdAD8bqd18pOTN
         R+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gAiy2G7fCIwsalQRspMcUTgdg/6DK96ZK1t7wrfvRSw=;
        b=V+LjktGx4ELI2XZrZQihlUv6Yc8fG7R+1WWwviKZDGAJecMk/C13/bQqMglqQoDFpU
         5WTdrPV256+N9yA5TKhKdCQaYGbnxB/iGbGHPmDgCQCmAVTURBha7E3/vGvfP80EBA35
         zGenOHsM62rlvIJouvmRvpBXNZRb47OkG4+KnmR1l8klcldOnhLuTYQIr8U/e1FNjfK3
         OO8pTNIXEja7PjJmu+8B0kiHKvx1JbBnHGWneSVO4nYEJIqKHcHQyMJ7VJk/T1oEbvFY
         H0SYKmJeiAxRy0DNi2iQ5maYohQx7Osh3eQVJPDjs1iuw+Ic5+H7UYKa89PEq5EXttdr
         0aoA==
X-Gm-Message-State: AOAM532KNftWx1scbR2ZDEVAp3aDt29GHbGjX1JzDZ8g7/jfkx3lYN7s
        UlrBi/IOKk72iCbdv2nA15zvBMwzssDhiu23
X-Google-Smtp-Source: ABdhPJz8mQKp4guW7ZocUv8ABMn6WKVFNITjbSPa55v9+633qnbY+brcPI4tBaYLRyfenmxCKgZmcA==
X-Received: by 2002:aa7:8d56:0:b029:327:6dc:d254 with SMTP id s22-20020aa78d560000b029032706dcd254mr23801055pfe.69.1626032221565;
        Sun, 11 Jul 2021 12:37:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co12sm18310453pjb.33.2021.07.11.12.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 12:37:01 -0700 (PDT)
Message-ID: <60eb485d.1c69fb81.e90d.769d@mx.google.com>
Date:   Sun, 11 Jul 2021 12:37:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-580-g094fb99ca365
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 134 runs,
 7 regressions (v5.10.49-580-g094fb99ca365)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 134 runs, 7 regressions (v5.10.49-580-g094fb=
99ca365)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig =
           | 2          =

d2500cc            | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-=
chromebook | 1          =

d2500cc            | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig  =
           | 1          =

rk3288-veyron-jaq  | arm    | lab-collabora | gcc-8    | multi_v7_defconfig=
           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-580-g094fb99ca365/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-580-g094fb99ca365
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      094fb99ca365bea4ef5961234cf733d17fb7af45 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig =
           | 2          =


  Details:     https://kernelci.org/test/plan/id/60eb0faba283891679117987

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60eb0faba283891=
67911798e
        new failure (last pass: v5.10.48-6-gce110db8e44b7)
        4 lines

    2021-07-11T15:34:44.605088  kern  :alert : 8<--- cut here ---
    2021-07-11T15:34:44.635711  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 2f8c350c
    2021-07-11T15:34:44.636941  ke<8>[   13.608190] <LAVA_SIGNAL_TESTCASE T=
EST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60eb0faba283891=
67911798f
        new failure (last pass: v5.10.48-6-gce110db8e44b7)
        41 lines

    2021-07-11T15:34:44.640536  rn  :alert : pgd =3D bc12db0b
    2021-07-11T15:34:44.641311  kern  :alert : [2f8c350c] *pgd=3D00000000
    2021-07-11T15:34:44.685848  kern  :emerg : Internal error: Oops: 5 [#1]=
 ARM
    2021-07-11T15:34:44.687438  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xe9027572)
    2021-07-11T15:34:44.688208  kern<8>[   13.651028] <LAVA_SIGNAL_TESTCASE=
 TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2021-07-11T15:34:44.689265    :emerg : Stack: (0xc42<8>[   13.662551] <=
LAVA_SIGNAL_ENDRUN 0_dmesg 546011_1.5.2.4.1>   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
d2500cc            | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0f6dbeed0a1dea117991

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0f6dbeed0a1dea117=
992
        new failure (last pass: v5.10.48-6-gea5b7eca594d) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
d2500cc            | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig  =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb10c2c6e2b510581179ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb10c2c6e2b51058117=
9f0
        new failure (last pass: v5.10.48-6-gea5b7eca594d) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
rk3288-veyron-jaq  | arm    | lab-collabora | gcc-8    | multi_v7_defconfig=
           | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb20ab88c0fbb36311798a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g094fb99ca365/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb20ab88c0fbb36311799e
        failing since 26 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-11T16:47:12.121156  /lava-4176334/1/../bin/lava-test-case<8>[  =
 13.737778] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T16:47:12.121691  =

    2021-07-11T16:47:12.122095  /lava-4176334/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb20ac88c0fbb3631179b5
        failing since 26 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-11T16:47:10.697494  /lava-4176334/1/../bin/lava-test-case<8>[  =
 12.313249] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-11T16:47:10.698076  =

    2021-07-11T16:47:10.698533  /lava-4176334/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb20ac88c0fbb3631179b6
        failing since 26 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-11T16:47:09.660203  /lava-4176334/1/../bin/lava-test-case
    2021-07-11T16:47:09.665443  <8>[   11.293881] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
