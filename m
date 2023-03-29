Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438DA6CCFD2
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 04:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjC2CNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 22:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC2CNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 22:13:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE51271C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 19:13:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so17106624pjp.1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 19:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680056025;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DuXhMUQstv/ZbIrSHskcb59p8mprXCkM5rcUKkevlcs=;
        b=avmD90k8DWr31bnFeQFBEKy2r1/0/K3AiKZyumMfD5PvbHKwhO45zmbjAix8c6isnJ
         9B18JArgIoCJkoBiI/DtITBn7ZrTfK5pc6x09iAjRqO7T40/mwmVDHkzasJ8D/KVw07b
         Q68QT1fyaaAMupETt8x1H5CL5WgkEeaIVi+hI7zws/FXEhoFAIxUJUoVbleOkQWFjEIO
         at7OpZrS42UhG3NgFWQq/2xpFR0QqsRnrzkDNPZxx7hRoZFhNYopAqd25KqDk8M6i4x5
         eY12xBsmI+qTTfubmtrmTBfD/d1vD0g3yR7YVCH27xof9LBM9JYWcSmRfFcZzHDMAB3R
         DRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680056025;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DuXhMUQstv/ZbIrSHskcb59p8mprXCkM5rcUKkevlcs=;
        b=PLSh5F8yFoKhGpe1xanWRthCFRtYtoNG/SS711YSHurMEVasCmje0MLL0IuSpPrn8r
         h1HDV7ScE5M6K9ExFJQ5C6Sg4AKYorIunCTNWRdC1rU4MjsD+lFI4nxRMA8VE1tXll/L
         8L4rlh+SXZnCCe+8A73UxDTCFGC2PNawDCrYSSnTWxQDa1WsyJ17NNV5epCb1fxawJOM
         I1tMfyDkxZFaf5iaKcssE/MNJd/nE9CVe/i5VF3hKl5mfbO41Mzt8lHLO4jIy+N0JWw4
         QXWHtVFGW+4ZkeMRNhiFqw+SHCSIZQ91dtVURl5k6Bz7lRc4gSS5ASErZmThPU6T2rlp
         bZEw==
X-Gm-Message-State: AAQBX9fRNWg3tvMSOPROis6qruccdcqpADb1gzBoCJzcWyNlKX1auW9X
        G8y64Hapzm+5shUaxIlrnv90wlDfh43iRKddQ2WMEg==
X-Google-Smtp-Source: AKy350bzZgmV6fKEfPjCaSZKlZdQ2Sw/U+gJ+OZLmxKe1Gfux4MLainoNkDKkuBwYaaSL2l39GJHXw==
X-Received: by 2002:a05:6a20:4b10:b0:d6:847d:c7af with SMTP id fp16-20020a056a204b1000b000d6847dc7afmr817362pzb.16.1680056024790;
        Tue, 28 Mar 2023 19:13:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i12-20020aa787cc000000b00580e3917af7sm14788010pfo.117.2023.03.28.19.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 19:13:44 -0700 (PDT)
Message-ID: <64239ed8.a70a0220.1be8b.b090@mx.google.com>
Date:   Tue, 28 Mar 2023 19:13:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-61-g2468eefe2b80
Subject: stable-rc/linux-5.4.y baseline: 110 runs,
 18 regressions (v5.4.238-61-g2468eefe2b80)
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

stable-rc/linux-5.4.y baseline: 110 runs, 18 regressions (v5.4.238-61-g2468=
eefe2b80)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | multi_v5_=
defconfig         | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.238-61-g2468eefe2b80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.238-61-g2468eefe2b80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2468eefe2b808e51a8ab52087c251c3f746829a3 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | multi_v5_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/642391fb41bf24a64162f78d

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850=
-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850=
-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642391fb41bf24a64162f792
        failing since 70 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-03-29T01:18:28.797380  / # #
    2023-03-29T01:18:28.900353  export SHELL=3D/bin/sh
    2023-03-29T01:18:28.901125  #
    2023-03-29T01:18:29.003159  / # export SHELL=3D/bin/sh. /lava-3451575/e=
nvironment
    2023-03-29T01:18:29.003930  =

    2023-03-29T01:18:29.105929  / # . /lava-3451575/environment/lava-345157=
5/bin/lava-test-runner /lava-3451575/1
    2023-03-29T01:18:29.107120  =

    2023-03-29T01:18:29.119547  / # /lava-3451575/bin/lava-test-runner /lav=
a-3451575/1
    2023-03-29T01:18:29.362022  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-29T01:18:29.365278  + cd /lava-3451575/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/642364e5e5fa1ca56562f76c

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/642364e5e5fa1ca5=
6562f774
        failing since 160 days (last pass: v5.4.219, first fail: v5.4.219-2=
67-g4a976f825745)
        3 lines

    2023-03-28T22:06:11.823232  / # =

    2023-03-28T22:06:11.824023  =

    2023-03-28T22:06:13.889188  / # #
    2023-03-28T22:06:13.889817  #
    2023-03-28T22:06:15.903205  / # export SHELL=3D/bin/sh
    2023-03-28T22:06:15.903645  export SHELL=3D/bin/sh
    2023-03-28T22:06:17.919756  / # . /lava-3451554/environment
    2023-03-28T22:06:17.920205  . /lava-3451554/environment
    2023-03-28T22:06:19.935286  / # /lava-3451554/bin/lava-test-runner /lav=
a-3451554/0
    2023-03-28T22:06:19.937790  /lava-3451554/bin/lava-test-runner /lava-34=
51554/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369d0af289c0ca462f772

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369d0af289c0ca462f=
773
        failing since 237 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64236a826dcdc0794062f77b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64236a826dcdc0794062f=
77c
        failing since 237 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369b720307e7b5c62f779

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369b720307e7b5c62f=
77a
        failing since 237 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369cf20307e7b5c62f79a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369cf20307e7b5c62f=
79b
        failing since 239 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64236a46e76ce5ce6062f76c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64236a46e76ce5ce6062f=
76d
        failing since 239 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369b12c19e28be062f7cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369b12c19e28be062f=
7cd
        failing since 239 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369d3af289c0ca462f778

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369d3af289c0ca462f=
779
        failing since 237 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64236aaad104819cb962f8de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64236aaad104819cb962f=
8df
        failing since 237 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369b22c19e28be062f7cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369b22c19e28be062f=
7d0
        failing since 237 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369d4a0ae5f3bd862f771

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369d4a0ae5f3bd862f=
772
        failing since 225 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-258-ge86027f8111f5) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64236afcf9211108e462f76d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64236afcf9211108e462f=
76e
        failing since 225 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-258-ge86027f8111f5) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642369b85658f3378562f777

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642369b85658f3378562f=
778
        failing since 225 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-258-ge86027f8111f5) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/642369fedc910cf97462f76c

  Results:     82 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642369fedc910cf97462f772
        failing since 14 days (last pass: v5.4.235, first fail: v5.4.235-4-=
gb829e8b6e1a7)

    2023-03-28T22:27:52.127725  /lava-9800354/1/../bin/lava-test-case

    2023-03-28T22:27:52.136120  <8>[   33.690944] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642369fedc910cf97462f773
        failing since 14 days (last pass: v5.4.235, first fail: v5.4.235-4-=
gb829e8b6e1a7)

    2023-03-28T22:27:51.105014  /lava-9800354/1/../bin/lava-test-case

    2023-03-28T22:27:51.113483  <8>[   32.669226] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/642365d8fcdc73f27562f799

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642365d8fcdc73f27562f79e
        failing since 70 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-03-28T22:10:00.458844  / # #
    2023-03-28T22:10:00.561039  export SHELL=3D/bin/sh
    2023-03-28T22:10:00.561525  #
    2023-03-28T22:10:00.663024  / # export SHELL=3D/bin/sh. /lava-3451585/e=
nvironment
    2023-03-28T22:10:00.663517  =

    2023-03-28T22:10:00.765040  / # . /lava-3451585/environment/lava-345158=
5/bin/lava-test-runner /lava-3451585/1
    2023-03-28T22:10:00.765891  =

    2023-03-28T22:10:00.783478  / # /lava-3451585/bin/lava-test-runner /lav=
a-3451585/1
    2023-03-28T22:10:00.831572  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-28T22:10:00.871294  + cd /lava-3451585/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/6423653373cad16fd162f77a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.238=
-61-g2468eefe2b80/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423653373cad16fd162f77f
        failing since 70 days (last pass: v5.4.227, first fail: v5.4.228-65=
9-gb3b34c474ec7)

    2023-03-28T22:07:22.914310  / # #
    2023-03-28T22:07:23.016526  export SHELL=3D/bin/sh
    2023-03-28T22:07:23.017003  #
    2023-03-28T22:07:23.118570  / # export SHELL=3D/bin/sh. /lava-3451570/e=
nvironment
    2023-03-28T22:07:23.119124  =

    2023-03-28T22:07:23.220783  / # . /lava-3451570/environment/lava-345157=
0/bin/lava-test-runner /lava-3451570/1
    2023-03-28T22:07:23.221877  =

    2023-03-28T22:07:23.238822  / # /lava-3451570/bin/lava-test-runner /lav=
a-3451570/1
    2023-03-28T22:07:23.310648  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-28T22:07:23.311099  + cd /lava-3451570/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
