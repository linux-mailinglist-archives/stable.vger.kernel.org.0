Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6D4612AEE
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 15:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJ3OPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 10:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3OPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 10:15:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C2EB485
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 07:14:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id b5so8687202pgb.6
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VURECodNNK5Qz5YqWEEzGVDhDyzlX3NyP228GgfRP/A=;
        b=eQh+6n+Cqwm+0dZjE2+QxrCP/3qN2/VA0E2Sc4pANVe6y8ENTLykyF1QhNCtSSgadd
         cXL+DKSe5NC5rQrdIQzDp9v3u+eQScbteTVIvkVkVSUnng2mRx9sijx1oLaF1bxWqK2C
         gy9HWTcfC7ZFr0CfT25JFneauC6rLPRdZAQ9xXBoRfP6arZdgYVFTJmy2g6pB0gnJIit
         yEheKJ1c0nHg0KCOzIJqbtUezIyVb9Act9wtESVclvoplqw9L1uVwZd2IaIUb0tuJBy+
         LW/D3tIEaAUBQPU7SEFjvR4tVC6jgUNq9T1aCnc2Vk8zSJfgu+wY9+BXXeC7DJsmxAS5
         7Qaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VURECodNNK5Qz5YqWEEzGVDhDyzlX3NyP228GgfRP/A=;
        b=r0NSABb7cNc+shIbCx38M6DAjr3droyob7GGtgvTMYabq/TuZx/wcj36t4p7btE282
         hYTEUIWh13tTV4zUZXzt36SWDrSKzhRBLrA5/sayjrV+COcpn7RChclL7J6yowFWVSa5
         NZawL6agTWrHWtdC5BLA57vEEoq2+vsOUpJMWP8mIlLDhX8m4MaLMQUSen5ukb5VKvai
         grT6Og7kROo/KKUDumEF87cy0iEJNmBOj+t+AWsrZuKBTHsSCrOahmtgAViND2UtfcaJ
         yMjvBQvg3YY56DYNiKDdD1ZhH5Q8cvmjU/cK7KpthPAW+4nI6AdsTK8rMUMcTYrIEUTd
         cVFw==
X-Gm-Message-State: ACrzQf1IgzjKT2D25cQ6SpecAx+lOInFT/zIY9wD2vtDMIWteMCco3uB
        Xh8Kbz4TfwacvBTucH3O8Dwz1MIggnrIJwrI
X-Google-Smtp-Source: AMsMyM5mvXdCWAFi3aq2nNT8EptchU6nDC068OgAjVOW5EbVi/B4fY7dCduEvHxfkeL+7tBWTl1/Og==
X-Received: by 2002:a63:6b49:0:b0:46a:fcba:308f with SMTP id g70-20020a636b49000000b0046afcba308fmr8419551pgc.8.1667139297035;
        Sun, 30 Oct 2022 07:14:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5-20020a170903234500b0017808db132bsm2754772plh.137.2022.10.30.07.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 07:14:56 -0700 (PDT)
Message-ID: <635e86e0.170a0220.e4e0b.44f4@mx.google.com>
Date:   Sun, 30 Oct 2022 07:14:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.331-9-g38ee902a7080
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 24 regressions (v4.9.331-9-g38ee902a7080)
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

stable-rc/queue/4.9 baseline: 114 runs, 24 regressions (v4.9.331-9-g38ee902=
a7080)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.331-9-g38ee902a7080/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.331-9-g38ee902a7080
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38ee902a708023be4d82039b15f42640edd99a00 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e566408719bbfc8e7db5a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e566408719bbfc8e7d=
b5b
        failing since 173 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56d98ad080d82ce7db70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56d98ad080d82ce7d=
b71
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e575c9fc5e48303e7db5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e575c9fc5e48303e7d=
b5d
        failing since 173 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e5860faafe46ce5e7db82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e5860faafe46ce5e7d=
b83
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e568f1ee965a83ee7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e568f1ee965a83ee7d=
b4f
        failing since 173 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e578e7492e74d44e7db7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e578e7492e74d44e7d=
b7e
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56623e27e01483e7db7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56623e27e01483e7d=
b7f
        failing since 96 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56db8ad080d82ce7db73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56db8ad080d82ce7d=
b74
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56bc0d23d8e452e7db78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56bc0d23d8e452e7d=
b79
        failing since 96 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e587534adfa0eebe7db58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e587534adfa0eebe7d=
b59
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56613e27e01483e7db78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56613e27e01483e7d=
b79
        failing since 96 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e57a18c8caa9f13e7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e57a18c8caa9f13e7d=
b4f
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56617965ee4c6de7db64

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56617965ee4c6de7d=
b65
        failing since 96 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56dd8ad080d82ce7db79

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56dd8ad080d82ce7d=
b7a
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56941ee965a83ee7dbab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56941ee965a83ee7d=
bac
        failing since 96 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e58c5bf256b4702e7db63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e58c5bf256b4702e7d=
b64
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e564ddd100de7fee7db56

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e564ddd100de7fee7d=
b57
        failing since 96 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e57ce68df5e967ae7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e57ce68df5e967ae7d=
b50
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e566308719bbfc8e7db4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e566308719bbfc8e7d=
b4f
        failing since 173 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56dc8ad080d82ce7db76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56dc8ad080d82ce7d=
b77
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e56bd6b10e32939e7db57

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e56bd6b10e32939e7d=
b58
        failing since 173 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e58882debce4877e7db8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e58882debce4877e7d=
b8e
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/635e568d2a19bb25bce7db6a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e568d2a19bb25bce7d=
b6b
        failing since 173 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/635e57b58c8caa9f13e7db5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.331-9=
-g38ee902a7080/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/635e57b58c8caa9f13e7d=
b5d
        failing since 173 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
