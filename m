Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992065B897E
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 15:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiINNvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 09:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiINNvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 09:51:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A25A74E10
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 06:51:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id jm11so15160172plb.13
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 06:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=wxvMljnf/4ZKAcwiSCUuh11obHAcN5YtgdJ+q3tDK4U=;
        b=PLq0uuFpUe5V1tWi6azQQX4Mxq4R+ckYadCmpWEzeUwl/EMfuiO1+lkSjcwPLj4JLb
         g0XmArJIwGoyDXuksNb/plEkCJ3C+uw1GD/4t3ObMZASbJPiZiZOEIaGP8m2Y/S5GKSl
         ORQmSZSje9dTE5uNzUHMLqwPWYG8WMTNNJZFXbGOTjwIbbOX/+YXgBkneMvW4aeYF7MQ
         Bxd2sBp2iddZBLihcyBrgWYql00UgLbnMNM6RBSypI5fr8pem64PaDsOBPYqJkf40RqW
         3moRPRRMrLY+tqX5zP0cpSiLGNbMg/GcvfkmEYVRgN88obatGc5Oo3TXi50jDKnsUVFO
         U+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=wxvMljnf/4ZKAcwiSCUuh11obHAcN5YtgdJ+q3tDK4U=;
        b=WM6a4OGsY8Yk58v45kHqf28DpjRh76tbx/oXpT3IrqRZtYbuFcyX4QcButS8DjNtSj
         IUVVq8g906Znd61wt9ZITRUiB2c2NZYDL9gzcYZ8klo4N2LOvB547Mrwbah9Cf1iAVOj
         G0GetEcgETaz1boyNZ8fLHF9gCLdVB7l6M2qhpweUodedvNTmjge8YcgA81+yyd/V6k9
         BymkLOfx5dAS4OpAag0wCaqViDIA0fXU/Ip+XjT3HRth+2njk4guQ0nmyE8wwQK4KvwW
         TSGPXm0nGDZRK7I+FdhT/Ef1NXV5Ri6UitcAt94krKztDaKYhnaBR2UJucRqltRZYd+C
         ChFQ==
X-Gm-Message-State: ACgBeo2BIQ+I3bsffmhfZU1RS8QPlAdKBGfYaumt5tf1ukCnCCC7mtrL
        aL1Q6OJS+K5ipg9R7loLBR7PM4ChPTaPJqA3kEI=
X-Google-Smtp-Source: AA6agR4VYgc9wy8din//w8v22C0qXyTqscSnYUA4H78kxyqc7aN6dJTxTFKRV2IL1wpxm6Z2Zairpg==
X-Received: by 2002:a17:902:b7c3:b0:176:b7e6:ae6c with SMTP id v3-20020a170902b7c300b00176b7e6ae6cmr36692020plz.163.1663163468260;
        Wed, 14 Sep 2022 06:51:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w14-20020a17090a380e00b001fa9e7b0c3esm9219003pjb.41.2022.09.14.06.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 06:51:07 -0700 (PDT)
Message-ID: <6321dc4b.170a0220.35507.f63f@mx.google.com>
Date:   Wed, 14 Sep 2022 06:51:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.327-43-g3ed886339090f
Subject: stable-rc/linux-4.9.y baseline: 107 runs,
 9 regressions (v4.9.327-43-g3ed886339090f)
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

stable-rc/linux-4.9.y baseline: 107 runs, 9 regressions (v4.9.327-43-g3ed88=
6339090f)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | at91_dt_def=
config          | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.327-43-g3ed886339090f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.327-43-g3ed886339090f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ed886339090ff4300e95c34546dcca0e468fb1b =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | at91_dt_def=
config          | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cd7e9a8159a274355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cd7e9a8159a274355=
651
        new failure (last pass: v4.9.327-43-gc2ac0e8fe911) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cf588e33b2ccef35564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cf588e33b2ccef355=
64e
        failing since 43 days (last pass: v4.9.302, first fail: v4.9.324-43=
-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cebc5a8e82b079355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cebc5a8e82b079355=
643
        failing since 43 days (last pass: v4.9.302, first fail: v4.9.324-43=
-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cf1c5511dd93a4355651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cf1c5511dd93a4355=
652
        failing since 41 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320ceb0446c53ded935566c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320ceb0446c53ded9355=
66d
        failing since 41 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cf1e17af64846c35564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cf1e17af64846c355=
650
        failing since 29 days (last pass: v4.9.302, first fail: v4.9.325-51=
-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cebbdb9f33770435564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cebbdb9f337704355=
64f
        failing since 29 days (last pass: v4.9.302, first fail: v4.9.325-51=
-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cf6c8e33b2ccef355657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cf6c8e33b2ccef355=
658
        failing since 29 days (last pass: v4.9.302, first fail: v4.9.325-51=
-g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320cea6446c53ded9355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
-43-g3ed886339090f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320cea6446c53ded9355=
643
        failing since 29 days (last pass: v4.9.302, first fail: v4.9.325-51=
-g469b0835c7652) =

 =20
