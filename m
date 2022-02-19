Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31154BC3A5
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 01:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiBSAtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 19:49:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbiBSAtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 19:49:02 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E802727792B
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 16:48:35 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id i10so8425560plr.2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 16:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Hz7OjtyhYIuAmy0JR0wECAZlk7R7BokCnQIQAn6a1X0=;
        b=stMeVRmVzU9C+bdhqo46k4LaKkfyQx1cM4ROjslrB9dMo5NpKRR5inezFfsGF/UmVz
         Xb08gAZvtKU9EFBfUR3h1ubQjONlHmZvU9B2+Xm31YajxToYRvzfI2dhGtM1PpvVScR7
         RWermG/I0X7JnBmwCvLb2AKSiE60aTTaKkjtRfYfgKiS3S8y+G7CH7Zk7NX1F6io6DR2
         nEK3RrzhliYXrmQ+l+4T4IuVykLF4nelSbkxpkE5au16XwRWHozLYTfWGnXEfa4Tv2li
         KN2JxQ0z4OrbUfHnFcnDNn5Xtt5ymkAHAavT2SaC6B9XCbJQUy3JKEgJGAOL9UvkniYj
         Z4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Hz7OjtyhYIuAmy0JR0wECAZlk7R7BokCnQIQAn6a1X0=;
        b=3fuNhUD85dZdV9AAUuzIGh50DPtyxxskf9w7IUQ8DBxwt1HaoG2rPcNrVA2W6f80l8
         rTuoEJkpxqk7q6jza5IQr5+ZlvVTL0166IBMEgEjyV7rS6aTWR+iVqQdZKza2T2o2eFv
         eWSHeKlVn4/5L5+7DFOCBn3tT7tTWsKKgg/+QxOrGxAAMQU0HfjrfbK0Rtp27tIrG6DQ
         LJ8Gy5wfnkJSoiGNHNhbbNW/F7abRFJzjDKXKz9rUKiTTXh8Ntxdf3earkvpCLsDOyBX
         OgIvqRPb5618rlv2qaFMFbF3ry2pV7/LH6VWNt2rNv3kPhI2IVtEXMuq7xjBQk5BCaxZ
         P0/A==
X-Gm-Message-State: AOAM530ZVM6XH58jJKcjAX1pYwVLX1fEHWjXPwkiWeyjo94lTbwa513D
        NCpDFf1K+g+dkvQj8Y3Vgi3f4fuGY2X+MBrw
X-Google-Smtp-Source: ABdhPJzuNMGI5jFZJq32FlZMGH9FV+jA5ExHn89dX3OQ/AUg4ECzgGP/8iLmvV6BU5S0QLmGcMXjKQ==
X-Received: by 2002:a17:903:2348:b0:14d:d2b6:b71 with SMTP id c8-20020a170903234800b0014dd2b60b71mr9566553plh.35.1645231715178;
        Fri, 18 Feb 2022 16:48:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 84sm3946006pfx.181.2022.02.18.16.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 16:48:34 -0800 (PST)
Message-ID: <62103e62.1c69fb81.bfd8.c1e5@mx.google.com>
Date:   Fri, 18 Feb 2022 16:48:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.180-45-gc346a97f4b11
Subject: stable-rc/queue/5.4 baseline: 69 runs,
 8 regressions (v5.4.180-45-gc346a97f4b11)
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

stable-rc/queue/5.4 baseline: 69 runs, 8 regressions (v5.4.180-45-gc346a97f=
4b11)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.180-45-gc346a97f4b11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.180-45-gc346a97f4b11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c346a97f4b116d2766818b01a16efb6dfec8471c =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6210058dcf965f1254c6296d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6210058dcf965f1254c62=
96e
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6210059361fa8498d1c6298c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6210059361fa8498d1c62=
98d
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6210058bad2de42d6ac6298c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6210058bad2de42d6ac62=
98d
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100590ad2de42d6ac62993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100590ad2de42d6ac62=
994
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6210058961fa8498d1c6297d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6210058961fa8498d1c62=
97e
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6210058f31abd090c2c6296b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6210058f31abd090c2c62=
96c
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6210058c61fa8498d1c62986

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6210058c61fa8498d1c62=
987
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62100592cf965f1254c62973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.180-4=
5-gc346a97f4b11/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62100592cf965f1254c62=
974
        failing since 10 days (last pass: v5.4.177-44-g60a800bc1417, first =
fail: v5.4.177-44-gd87bb386a4e2) =

 =20
