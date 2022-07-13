Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F495736E3
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 15:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiGMNIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 09:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbiGMNIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 09:08:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3670029C8E
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:08:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g4so10419224pgc.1
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 06:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Mo7dt/N9bwMcRHYPHLgdsbt+C0IT0vg4lmBEMJ8vV4=;
        b=8VOxd6YwcQIuLIExaoQQAPt9iFEE7pJEgXwga/zO2T0pkZSefhCDZSgcc5tHUn/AH3
         ijqoDzhq5nmIdEE3GpAmUZlaYQe9zk1FOCa65f1DIwojJHW1h+Ey/bVFOGUAOBSPbel2
         xnNOMRVFNCBYl8M7OVWpXRfmHQZ6Dl+3YT6l2EY45tcbin6umRt2Xr+1XSYH0YfTFGqH
         BEzLKl9NXGQoiAVGFcnPPbhw1QOP7f6mWattcG3ekBVDubltbuzj/gRmsEjIQfI0thLV
         ivtGjXMwrFiZxIF33HmLhvovMJUXCh1qMThCF908ks8GcnPuBEiUXknrezYAHGVI3N7L
         lRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Mo7dt/N9bwMcRHYPHLgdsbt+C0IT0vg4lmBEMJ8vV4=;
        b=uDBcKmMEPgaKZ0A5jXa42ecvJwrlAKmfFkCSd5VOfBqWMQfrfT1K8e39EJgi24dP+x
         evIGtXrriCedBZlp0EUBGSccKeGMowK9ZCkS5y1sUfdAR+/yEEvXTDNTPNbINvzwxUj7
         16jgwrD9l3HP6FKuurKDRWr+jbRbBd6OZJnBxHn68w2UengsqdwH8bxcPM6vPvbAVet3
         sXP3TtJOcNsoUSUFcdNe4Z0x517M6JhMUOndNfcxuzCCLS+zncA4I33tYRvFRyO4F+gG
         5y/NJwoTBiqXjLw3M7U5OXER64Bh8TpVROCTDpUi7a3dbsIHq0oirz6iPRszso6kA/u4
         wb5Q==
X-Gm-Message-State: AJIora/PukKorOQSvvIudc8Mjy+0ywmCGQQJhmKx5XpWwyRm815OwF/T
        WbC7z3KkZiimgsOTAXNj5Hxngg5F007WJur/
X-Google-Smtp-Source: AGRyM1uo05vqxieqNeLy7dhKCZ+cp/045Uz7CLQqSpwrIxcrzFy0iry1+bOfTyegGqGtyFCGjCNu9w==
X-Received: by 2002:a63:4664:0:b0:416:3564:2a94 with SMTP id v36-20020a634664000000b0041635642a94mr3025707pgk.112.1657717690270;
        Wed, 13 Jul 2022 06:08:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x5-20020a623105000000b005289ef6db79sm8797311pfx.32.2022.07.13.06.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 06:08:09 -0700 (PDT)
Message-ID: <62cec3b9.1c69fb81.b200b.d17e@mx.google.com>
Date:   Wed, 13 Jul 2022 06:08:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11-61-gfb3840cbaa38
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 163 runs,
 6 regressions (v5.18.11-61-gfb3840cbaa38)
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

stable-rc/queue/5.18 baseline: 163 runs, 6 regressions (v5.18.11-61-gfb3840=
cbaa38)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.11-61-gfb3840cbaa38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.11-61-gfb3840cbaa38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb3840cbaa38d1b97fae7cd130f06a1c834ef156 =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx6ul-pico-hobbit     | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea882b4c89f4140a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea882b4c89f4140a39=
bdb
        failing since 7 days (last pass: v5.18.9-96-g91cfa3d0b94d, first fa=
il: v5.18.9-102-ga6b8287ea0b9) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
jetson-tk1             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea21f6b5b2c3b32a39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea21f6b5b2c3b32a39=
bec
        failing since 0 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce8eacecbd74a800a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce8eacecbd74a800a39=
bdc
        failing since 0 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce8ebeecbd74a800a39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce8ebeecbd74a800a39=
c06
        failing since 0 day (last pass: v5.18.10-27-gbe5c4eef4e40, first fa=
il: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce93437190c4e73aa39c04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce93437190c4e73aa39=
c05
        failing since 0 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce936a5f61895f82a39c4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
61-gfb3840cbaa38/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce936a5f61895f82a39=
c4e
        failing since 0 day (last pass: v5.18.10-27-gbe5c4eef4e40, first fa=
il: v5.18.11-61-g8656c561960d) =

 =20
