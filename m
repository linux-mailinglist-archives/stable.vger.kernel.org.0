Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037735363DA
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 16:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiE0OOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 10:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiE0OOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 10:14:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86F15AA4A
        for <stable@vger.kernel.org>; Fri, 27 May 2022 07:14:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n10so4698995pjh.5
        for <stable@vger.kernel.org>; Fri, 27 May 2022 07:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t332oZevTt6sAOTTyY29zbgPczwvwOfkwPpJNAybpVA=;
        b=EpM12SXqOVM1/IhXBsmC/m7+GnEJCEVyZsSPBM2oCaVdYsYly6DGDybLBOqHGCDIFJ
         qfhsjNGmQMF9mygbtgF9e0/HyZonkBo6juv9pW5Vx5M2zjI1UiZM142qfVHUaWcuzdvH
         R3msFSfKozy5vnElrRWe0yFcYeNl0RBxQfgiL1ejq9e2BZdveq1SOyUX58MLoq1hv8IC
         gcscNk0GBsdNfHIjb+3qb9n+wdu5+bKnBiKsxYyaYFK8b+nzp3IiOiyUOBCwZcdCQm62
         hBrDbsMOaJ/TuoSaCGEwYOa+WST84PRG/SSDgXTgz3s124rXfhephga2MTJygSiZkh48
         oRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t332oZevTt6sAOTTyY29zbgPczwvwOfkwPpJNAybpVA=;
        b=Vz6ieaory4I7/AQDOm8gg6BXRZtCgSM7mSInOImZy+8UAvkPCKYoCV4V0zy2oi8AI0
         k4WZaGhsjvR1C8ZUvho7cBKMqGJT1rKQmYhODiy3t88rGrfrevtiLEx1zhbjzctcr+Pt
         fHPdf/EKjNI/D8FVwpP2lT904uQBosLxfG6YbxGV+ovgM9P4Otx1/+LkGt3LKK0GvwZL
         K2Ne1t1oLLExG/x5Y+mCVj5n2T6dtkorB3uSDZMcffm42W+umZtynV9auzbr+TGlwZxY
         T5eH5W1XPFbQUaZ2RDk16BnHxg4tGXGRhQuSuIiEtj1L+A4ylzx1WfbIbaCt40lhm82v
         I9Nw==
X-Gm-Message-State: AOAM531zVFfqpwSOlh7VJi0HCHPf2RHBWikHtf9BGRsb1HxhDI3nXlAg
        Yn7MGRyX4NT1eRG7++dORbd74P/BWCDPdVdrVLg=
X-Google-Smtp-Source: ABdhPJz9P2wZTtEgoEsCnvCDplIS2uNUItn+T51ZSC50NpqjyxARZnoQbAxursQAlR0WwHxW3YwwpQ==
X-Received: by 2002:a17:90b:180b:b0:1df:b2ac:faf9 with SMTP id lw11-20020a17090b180b00b001dfb2acfaf9mr8518334pjb.150.1653660841111;
        Fri, 27 May 2022 07:14:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b005183fc7c6dasm3587597pfq.5.2022.05.27.07.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 07:14:00 -0700 (PDT)
Message-ID: <6290dca8.1c69fb81.ad2fa.7fa3@mx.google.com>
Date:   Fri, 27 May 2022 07:14:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.281-6-g635768163f4e1
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 74 runs,
 9 regressions (v4.14.281-6-g635768163f4e1)
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

stable-rc/queue/4.14 baseline: 74 runs, 9 regressions (v4.14.281-6-g6357681=
63f4e1)

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
nel/v4.14.281-6-g635768163f4e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.281-6-g635768163f4e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      635768163f4e1c1b0a12399f59a87177b977e634 =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6290acc31f11589ddca39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290acc31f11589ddca39=
bdb
        failing since 38 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fir=
st fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b672b31b378078a39c0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b672b31b378078a39=
c0c
        failing since 17 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b7ee21ec8ac5d3a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b7ee21ec8ac5d3a39=
bd0
        failing since 17 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b5fa26e73ecf89a39beb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b5fb26e73ecf89a39=
bec
        failing since 17 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b7b3813750c05fa39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b7b3813750c05fa39=
bd1
        failing since 17 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b6227d2f127d57a39c29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b6227d2f127d57a39=
c2a
        failing since 17 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b8032846216c49a39c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b8032846216c49a39=
c9c
        failing since 17 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b63663a7e849baa39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b63663a7e849baa39=
bd4
        failing since 17 days (last pass: v4.14.277-54-gf277f09f64f4, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =



platform                     | arch  | lab         | compiler | defconfig  =
                | regressions
-----------------------------+-------+-------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/6290b7db65daf913cda39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.281=
-6-g635768163f4e1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6290b7db65daf913cda39=
bf6
        failing since 17 days (last pass: v4.14.277-54-gfa6de16ffc4e, first=
 fail: v4.14.277-75-g7a298ff98d4a) =

 =20
