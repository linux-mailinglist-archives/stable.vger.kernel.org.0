Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB30C57A729
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiGSTWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 15:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiGSTWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 15:22:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DCD45980
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 12:22:16 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id w185so14513119pfb.4
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 12:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RBAtglnM91Dmu3SVzL2iIShyCBFpC2s0KmEbcWnDvb4=;
        b=r3G/OhXYnbw9LvdcCajFLMwZjANLVdtWhjtvGgfYETG6BlSZBnxh7s6qEoVxtYdSdx
         bRZBNxND2OelSfOtVGMxnGxFqhyl2XZwVCUIpSNPS9RytAKV+wVATTdrR99gNG8BF1HR
         ZYT07K89m4G2Xjf7n4tQF0bSBO6wCuv6idmGZF9/1VtkthN38T9Fen7Dn3CfMwLAsEeA
         AO8t81i61+yVhIIZL2qDd2fiqBgRPrfBB+LIEdyaa1G4QTW/72OC86G79rrN3PDRTyWU
         ww1pRCFvFtxxT++V1rZVGtToy9Et3AmQZngyOGmnWA6RNbIdmSxebXaLYBk0xiRNGQwt
         gH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RBAtglnM91Dmu3SVzL2iIShyCBFpC2s0KmEbcWnDvb4=;
        b=dHw464uMkuuxC2Qqcn2CI6eR4Ab6+O3QwHoXQJSgSEem+vDMhX+9B/eEhsTM1/Xens
         1UHrf8daSfpwPWv8C0tgiVEv+lkuSusJiVUzIdwcYnA/S59RhTLUWkOMX/h6lDC4+0It
         P5UbDWmdMdF8i8bC51gMJ5kDGhDnMPklFM8+tmDKfd4qGChbV/JY3ZleC7MzqgE2i7+R
         XXtL00xfEBc4ppFVy1pnyB3xdo1UkL4ZYCXnZpRGHKOyrk7q2xnN3mXxiaXvvnBYMx8W
         w22a1It0buhzQ9QGSQe5XooM/HfskPYq8s8KmY2A5EchXa0vC8KNu5ec5cNTBiqJioz+
         U32Q==
X-Gm-Message-State: AJIora8OBu2/Mc+OZmhuv60TkG2EZ55jflkWsLupuDApsX3ARoEcgevP
        mcT4eUxk6KSIHtKrF4zdOBKOkFl8lLAJrMHL
X-Google-Smtp-Source: AGRyM1uYuTZTG5zjgr066XzSVz/UNAf3LfrWUfTXArZu+UDsBNGDIZ6de+SWhyzPpIKlOAdmEDLj0Q==
X-Received: by 2002:a63:7456:0:b0:415:320b:67e9 with SMTP id e22-20020a637456000000b00415320b67e9mr29967537pgn.27.1658258536018;
        Tue, 19 Jul 2022 12:22:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a201-20020a621ad2000000b0050dc76281e0sm11770960pfa.186.2022.07.19.12.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:22:15 -0700 (PDT)
Message-ID: <62d70467.1c69fb81.86b03.1986@mx.google.com>
Date:   Tue, 19 Jul 2022 12:22:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.323-28-gb082ac7b724a
Subject: stable-rc/queue/4.9 baseline: 45 runs,
 9 regressions (v4.9.323-28-gb082ac7b724a)
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

stable-rc/queue/4.9 baseline: 45 runs, 9 regressions (v4.9.323-28-gb082ac7b=
724a)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
at91sam9g20ek              | arm   | lab-broonie  | gcc-10   | at91_dt_defc=
onfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.323-28-gb082ac7b724a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.323-28-gb082ac7b724a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b082ac7b724a1ca514eb804957af96e883b4574b =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
at91sam9g20ek              | arm   | lab-broonie  | gcc-10   | at91_dt_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6ca8924a41abd32daf066

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6ca8924a41abd32daf=
067
        failing since 0 day (last pass: v4.9.323-1-ge4cffab0e47d, first fai=
l: v4.9.323-26-g6aedd4814268) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6cb6480d5a3c00cdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6cb6480d5a3c00cdaf=
057
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6d269b6b7e5bb1edaf0d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6d269b6b7e5bb1edaf=
0d4
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6cb6322b2897d18daf0ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6cb6322b2897d18daf=
0bb
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6d151c2b9c43acbdaf0eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6d151c2b9c43acbdaf=
0ec
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6cb6122b2897d18daf0b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6cb6122b2897d18daf=
0b5
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6d101d6c05e2d68daf0ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6d101d6c05e2d68daf=
0ac
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6cb6222b2897d18daf0b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6cb6222b2897d18daf=
0b8
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
      | regressions
---------------------------+-------+--------------+----------+-------------=
------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62d6d129747ce7563adaf07c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.323-2=
8-gb082ac7b724a/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6d129747ce7563adaf=
07d
        failing since 70 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
