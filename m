Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27C5588BA2
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiHCL7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 07:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiHCL7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 07:59:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6A451A0D
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 04:59:30 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h132so14900834pgc.10
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 04:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R3Yimz4s7zfmbo1u1wxFRGZmzCAhaW8kYRCGe0JkIO8=;
        b=eph0FEX6lp8RTQ79Vbfz+UW2/Va4lqgJKH3y+EwMgBSy0zU/BA+8zERv6Lrv4Su12t
         ju06I0RyhQmMyXu82qbkHcooN1JDj7T2MwApzyFplEpaAOuTu9RFIrurDGd2G9Ufh5X1
         NP0l5XW3dYK4RJrwowek/OkMD5k3OxSNoXefEr+0Lyje4w4D5JOeJzweMu9SlpSnp/1y
         LEWpmxcbYmB3d/K+QGNlViNH+lIdVI/ke/V1L0aScyyu38CaDjnSXnLnaZzVcR2H6Wkb
         cLS57BwlpQERMRodyH9NFnvLztRBkPi/Y9GywmvgZfoJq8RZfXR7F1u3/p0hY8zfpYY4
         W+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R3Yimz4s7zfmbo1u1wxFRGZmzCAhaW8kYRCGe0JkIO8=;
        b=jros+oFEbbLHPS330iTxHaz26L+Wn6CsjsjyHqe4NOfxuiEUDkxjZE3soH9pcXXqlu
         wnIZXnxfK6isMdPUBZ5VDo6c6SrZwIf56ctytFOF97Vy1oXUmo17YbO48WPYQVY6s1GA
         tsT8OdJfaPTn7rZGzdsUpMgaNixc8CTp46CTXGoxWzL5qM+UJcmbk917PgfCeFXjzwaR
         +TSwHrPOeklmEjlI9MuUaS25rjGSGe1rNU6+43KJ5OS8Oli9QwaZew5yL9CwbHo5o6yV
         y1DtGZnOs2g/7bDQTfGLP+9pkHzbUtgdhB7bU1kudVcvSi5iRUtOfzZ6cfeX1SwHCjuH
         0PMg==
X-Gm-Message-State: AJIora9m/LTEFG/fDzuOvCmC9NL0Fhj4D/RDdwqnh9xps2cM1zS6uFdM
        K8tJIDJJwVn7KTKalUqhPyRRiHPjXSrs1jfEIes=
X-Google-Smtp-Source: AGRyM1s+ZSBLIuGnGZfSCYrmlAUwITlvNjoOHCo2NHhgEKtRxD8bz0K90WGDvCuMSNbuayFsnSVcHQ==
X-Received: by 2002:a63:dd43:0:b0:416:8be5:94d6 with SMTP id g3-20020a63dd43000000b004168be594d6mr21348030pgj.450.1659527969862;
        Wed, 03 Aug 2022 04:59:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5-20020a63f105000000b0041b3c112b1esm10907118pgi.29.2022.08.03.04.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 04:59:29 -0700 (PDT)
Message-ID: <62ea6321.630a0220.933cb.fb2e@mx.google.com>
Date:   Wed, 03 Aug 2022 04:59:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.289-47-gb8cbd5c5f931c
Subject: stable-rc/queue/4.14 baseline: 80 runs,
 9 regressions (v4.14.289-47-gb8cbd5c5f931c)
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

stable-rc/queue/4.14 baseline: 80 runs, 9 regressions (v4.14.289-47-gb8cbd5=
c5f931c)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.289-47-gb8cbd5c5f931c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.289-47-gb8cbd5c5f931c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8cbd5c5f931cf08877c3a66a1775d55aabd0485 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea32051ee5934026daf075

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea32051ee5934026daf=
076
        failing since 106 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea2ffdef85164fa3daf05e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea2ffdef85164fa3daf=
05f
        failing since 84 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea322fb73d9727a9daf0ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea322fb73d9727a9daf=
0cb
        failing since 85 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea2fe99ba71b4278daf088

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea2fe99ba71b4278daf=
089
        failing since 84 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea321a1ee5934026daf085

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea321a1ee5934026daf=
086
        failing since 85 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea2fc14bff5b4907daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea2fc14bff5b4907daf=
069
        failing since 84 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea321bb73d9727a9daf0b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea321bb73d9727a9daf=
0b6
        failing since 85 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea2fadca03878b70daf06c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea2fadca03878b70daf=
06d
        failing since 84 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/62ea322ed439253331daf057

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.289=
-47-gb8cbd5c5f931c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ea322ed439253331daf=
058
        failing since 85 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20
