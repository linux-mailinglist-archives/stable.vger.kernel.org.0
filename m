Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530F469AC15
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 14:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjBQNF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 08:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBQNF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 08:05:26 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9724C4AFF3
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 05:05:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u14-20020a17090a4bce00b002341fadc370so1193638pjl.1
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 05:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fiVlTxzmN/r5Rrh0+BoHcbqziyfn/4k6kRm2wzdWfC8=;
        b=UTjB8R2KllzNF18tPSqMqoY/H9eTpZuXr2GB6DWYwSxVKS5Jy7ZjbC5FRvmBo4n3j3
         KcvMFrFkWgy23HhTTOnOwD6M15hRbVnt/TF+fTbXV8Ai8Mz9lXbz+PzkxvB52uj4UECQ
         pHobq0R5/uqXER4Q86CjOGsWx1Gj+ir+VpZD4oGOzT8CI/R0uop2yWDG2n0Bqngm5KTG
         9M5Gr4ZinkAPTQmYqD2j0BjTGnsLAUgPYXrVAnEL76Fflo+TI1t7jafR8wQoNluc8iNr
         VxabX65L3j0vHbqvsV8QyB2WNTrSOzdtqhGCWzl1eu1TzsSp2LRKN1j36PWfKzFNyavO
         mx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fiVlTxzmN/r5Rrh0+BoHcbqziyfn/4k6kRm2wzdWfC8=;
        b=zDX8OpmEdnlaL2eMCTiprroTmA3szZbCL2opGm9M4V9UWIXTXujGYLY9NI/Sa8t/JD
         iw7fCjR8ZGbD5dQTEzlmSw+PZln3eqfYrtKXHRBSgGA1wXzy+E8ITmfqe8xiIDQMK6x7
         4daXuhmsAT8WVIj+fBanQTDeYyzEa3SrMOZvCPMFmnJ6flqk25xIwzC1S27zBcZys5R4
         Ic3dV5hx4vD8JK/P9HBCgVlm3gGTY5bYRWwpEaXvGF6SHGbn7EgTQYbtTSoKaAfUYFu0
         nf/+zR48XROv33czijI7EBbbzuUMAKBegM2u9JdDiInNJ41n7IcmTRMYg3oFOeuXR5y+
         iqng==
X-Gm-Message-State: AO0yUKVlZKlQhQWkuHE3TzzeU2XiRDB1aJ1Ut2Ym95/iz8/XSXRibV7Y
        teDH+PD0RGE3tmDa9bTcungRrz3zyNu75c8s1+A=
X-Google-Smtp-Source: AK7set8Dg0HBPJS9j2QH5MWvoks4B/2Xqt5b80+EDi9NfB/EijN9SMpwZpdYwd55wNVO1R8QvpBIAQ==
X-Received: by 2002:a17:903:2451:b0:194:5c63:364c with SMTP id l17-20020a170903245100b001945c63364cmr904250pls.62.1676639122651;
        Fri, 17 Feb 2023 05:05:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ff0200b00198e12c499dsm3070196plj.282.2023.02.17.05.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 05:05:22 -0800 (PST)
Message-ID: <63ef7b92.170a0220.c844.5f21@mx.google.com>
Date:   Fri, 17 Feb 2023 05:05:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.94
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 166 runs, 19 regressions (v5.15.94)
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

stable-rc/linux-5.15.y baseline: 166 runs, 19 regressions (v5.15.94)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =

cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

kontron-pitx-imx8m     | arm64  | lab-kontron     | gcc-10   | defconfig   =
                 | 2          =

qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2c1a934fd8e4288e7a32f4088ceaccf469eb74c =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef48b2f2258afab58c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef48b2f2258afab58c8=
63a
        failing since 280 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
cubietruck             | arm    | lab-baylibre    | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef49645689f114698c8633

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ef49645689f114698c863c
        failing since 31 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-02-17T09:30:54.844420  <8>[    9.975679] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3344277_1.5.2.4.1>
    2023-02-17T09:30:54.951270  / # #
    2023-02-17T09:30:55.052836  export SHELL=3D/bin/sh
    2023-02-17T09:30:55.053179  #
    2023-02-17T09:30:55.154344  / # export SHELL=3D/bin/sh. /lava-3344277/e=
nvironment
    2023-02-17T09:30:55.154661  =

    2023-02-17T09:30:55.255868  / # . /lava-3344277/environment/lava-334427=
7/bin/lava-test-runner /lava-3344277/1
    2023-02-17T09:30:55.256454  =

    2023-02-17T09:30:55.256637  / # /lava-3344277/bin/lava-test-ru<3>[   10=
.353662] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-17T09:30:55.261494  nner /lava-3344277/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef48cc4e1de1481b8c8651

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ef48cc4e1de1481b8c865a
        failing since 17 days (last pass: v5.15.81-122-gc5f8d4a5d3c8, first=
 fail: v5.15.90-205-g5605d15db022)

    2023-02-17T09:28:19.716090  + set +x
    2023-02-17T09:28:19.716256  [    9.362122] <LAVA_SIGNAL_ENDRUN 0_dmesg =
906916_1.5.2.3.1>
    2023-02-17T09:28:19.823195  / # #
    2023-02-17T09:28:19.924923  export SHELL=3D/bin/sh
    2023-02-17T09:28:19.925528  #
    2023-02-17T09:28:20.026893  / # export SHELL=3D/bin/sh. /lava-906916/en=
vironment
    2023-02-17T09:28:20.027517  =

    2023-02-17T09:28:20.137238  / # . /lava-906916/environment/lava-906916/=
bin/lava-test-runner /lava-906916/1
    2023-02-17T09:28:20.141507  =

    2023-02-17T09:28:20.142466  / # /lava-906916/bin/lava-test-runner /lava=
-906916/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
kontron-pitx-imx8m     | arm64  | lab-kontron     | gcc-10   | defconfig   =
                 | 2          =


  Details:     https://kernelci.org/test/plan/id/63ef483f926b9fdb908c8656

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ef483f926b9fdb908c865d
        new failure (last pass: v5.15.93-68-g2bf3e29e9db2)

    2023-02-17T09:26:13.638885  / # #
    2023-02-17T09:26:13.740434  export SHELL=3D/bin/sh
    2023-02-17T09:26:13.740963  #
    2023-02-17T09:26:13.842398  / # export SHELL=3D/bin/sh. /lava-277311/en=
vironment
    2023-02-17T09:26:13.843105  =

    2023-02-17T09:26:13.944544  / # . /lava-277311/environment/lava-277311/=
bin/lava-test-runner /lava-277311/1
    2023-02-17T09:26:13.945423  =

    2023-02-17T09:26:13.951807  / # /lava-277311/bin/lava-test-runner /lava=
-277311/1
    2023-02-17T09:26:14.010705  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-17T09:26:14.011107  + cd /l<8>[   12.057586] <LAVA_SIGNAL_START=
RUN 1_bootrr 277311_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/63e=
f483f926b9fdb908c866d
        new failure (last pass: v5.15.93-68-g2bf3e29e9db2)

    2023-02-17T09:26:16.329855  /lava-277311/1/../bin/lava-test-case
    2023-02-17T09:26:16.330324  <8>[   14.470924] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef46c9268a0bede28c86b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef46c9268a0bede28c8=
6b3
        failing since 3 days (last pass: v5.15.93, first fail: v5.15.93-68-=
g2bf3e29e9db2) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef483e357af348fd8c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef483e357af348fd8c8=
63d
        failing since 3 days (last pass: v5.15.93, first fail: v5.15.93-68-=
g2bf3e29e9db2) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef45102fb5686bb28c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef45102fb5686bb28c8=
636
        new failure (last pass: v5.15.91-21-gd8296a906e7a) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef453c72708891b48c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef453c72708891b48c8=
63b
        failing since 3 days (last pass: v5.15.93, first fail: v5.15.93-68-=
g2bf3e29e9db2) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef469a9551f8ccd08c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef469a9551f8ccd08c8=
644
        new failure (last pass: v5.15.91-21-gd8296a906e7a) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef46eab869ed8bc98c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef46eab869ed8bc98c8=
649
        failing since 3 days (last pass: v5.15.93, first fail: v5.15.93-68-=
g2bf3e29e9db2) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef44f95dea1454948c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef44f95dea1454948c8=
640
        new failure (last pass: v5.15.91-21-gd8296a906e7a) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef455dbeffca5b2f8c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef455dbeffca5b2f8c8=
65a
        failing since 3 days (last pass: v5.15.93, first fail: v5.15.93-68-=
g2bf3e29e9db2) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef4511e50275ec648c8656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef4511e50275ec648c8=
657
        new failure (last pass: v5.15.93) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef453b72708891b48c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mix=
ed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mix=
ed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef453b72708891b48c8=
635
        new failure (last pass: v5.15.90-205-g5605d15db022) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef46c2c75f6645598c8659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef46c2c75f6645598c8=
65a
        new failure (last pass: v5.15.93) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef46d6a63c8a39438c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixe=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mixe=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef46d6a63c8a39438c8=
635
        new failure (last pass: v5.15.90-205-g5605d15db022) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef450d2fb5686bb28c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef450d2fb5686bb28c8=
630
        new failure (last pass: v5.15.93) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ef453586533ff8908c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-mi=
xed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_x86_64-uefi-mi=
xed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ef453586533ff8908c8=
631
        new failure (last pass: v5.15.90-205-g5605d15db022) =

 =20
