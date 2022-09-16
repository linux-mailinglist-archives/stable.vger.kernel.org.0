Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863A35BB136
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 18:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiIPQoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 12:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiIPQoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 12:44:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021AD6EF26
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:44:21 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t3so21966080ply.2
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=q++lEfz//7EcPS3sPJrOc+PhuvUOOmKCWzKpBH4Ky5U=;
        b=NiQ3Ca6O01aONBjxyT+VVCv9agJthgtu/f8Rq184Dd2n8XWmLalsCV/kykwA3d6d0s
         7JRfR8mz4WZOvlU+MPE/4PbImuc05r8hyYLisAZ1fFLb2mft3TBWUtUWXMlRG9ygLyC6
         ErdLgusEf/KUdNNcUfcmXx0DjDoHiW+IZJY7vPBcVQAcsuf6YWbEOxZRgUxSpHAwWvbu
         VsmhAoVe/sqszDhJnGzSA6rAeDJ08MIE2vSkl3y/sfbT1qYlk6snqoC4/mRwHFzXa8EQ
         rPd4oAp0fGxhDb7Wh6Vuj6nJCMMmZ8r0GN8bHc+4HsyPeNwwBrFANM5TdZUd+tPwttTq
         9hhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=q++lEfz//7EcPS3sPJrOc+PhuvUOOmKCWzKpBH4Ky5U=;
        b=vrM00w3WsfzrjZRS7+iyMrEc82NrkbDTd8DOz7b8CPYdpi6d7oY+lVP8HJnAVNN8TG
         xF4qK9ZymowBzwPxog9EI5rxJcNdcKuV2MzBqOpHqvEUf2t3zsQtQDcJ5tZZy7nTNT2V
         x2faz6CCkG3QFmQYvTD+gQG6yxwVk34VWYuoAJAxylcXqmu3xC2vboG29IxvGnIQU7dM
         66bH3AYqhFDplRI0ec45vTNq5jbWxpanwU9dw70yU9wf2c8xfLGFAdXo10ByX0QW/08W
         ACxLuViG9hWAJYR4iJoZjgp/AKXXHkiT34uGQNeWyzjKbcNr73Btd2Pu7Eds6vrWFWyc
         YyOw==
X-Gm-Message-State: ACrzQf3qPGM6Vv8gUoGAHoMqQsQPLrtzmEXKr6DiGC9Iy7fkee0w0d81
        H020PGgc9762XRbQb4YK98/RfARqFJf5d9YhWPU=
X-Google-Smtp-Source: AMsMyM5kY1eYI5D1qX8XPlX5U1TQgyHZO5mRyHM928BLa5P6eB0ngn08KxaxwXyEkLCqyX2XuORYSw==
X-Received: by 2002:a17:90b:1d0f:b0:202:be3e:a14a with SMTP id on15-20020a17090b1d0f00b00202be3ea14amr17138674pjb.102.1663346660178;
        Fri, 16 Sep 2022 09:44:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903244f00b001755e4278a6sm15074198pls.261.2022.09.16.09.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 09:44:19 -0700 (PDT)
Message-ID: <6324a7e3.170a0220.939e.cabb@mx.google.com>
Date:   Fri, 16 Sep 2022 09:44:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.328-7-g5d0e3c79d9c7
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 11 regressions (v4.9.328-7-g5d0e3c79d9c7)
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

stable-rc/queue/4.9 baseline: 104 runs, 11 regressions (v4.9.328-7-g5d0e3c7=
9d9c7)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.328-7-g5d0e3c79d9c7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.328-7-g5d0e3c79d9c7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d0e3c79d9c74f770655f1ea10c1398eec4591ef =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6324778db41157c247355644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6324778db41157c247355=
645
        failing since 129 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/632479082cfabc4ec8355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632479082cfabc4ec8355=
679
        failing since 129 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6324778cd2b3f67ed0355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6324778cd2b3f67ed0355=
676
        failing since 129 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63247945666a44db6b355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247945666a44db6b355=
656
        failing since 52 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/632477bb0cb568afef355661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632477bb0cb568afef355=
662
        failing since 52 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632476757e40a55e4735564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632476757e40a55e47355=
64e
        failing since 52 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/63247946254e4b22b135565d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247946254e4b22b1355=
65e
        failing since 52 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632475b384242bac46355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632475b384242bac46355=
643
        failing since 52 days (last pass: v4.9.302-28-g96ac67c43b2b, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/632477bc2d642552d9355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632477bc2d642552d9355=
679
        failing since 52 days (last pass: v4.9.302-31-gdbb0728e500a, first =
fail: v4.9.324-19-gbc9f55260bb17) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6324767448437c234a355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline=
-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6324767448437c234a355=
647
        failing since 129 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/632479092cfabc4ec835567b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g5d0e3c79d9c7/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632479092cfabc4ec8355=
67c
        failing since 129 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
