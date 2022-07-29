Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEBF5856A9
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 23:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiG2Vwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 17:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238276AbiG2Vw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 17:52:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40BB6715C
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 14:52:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so6427637pjf.5
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 14:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LroTWGjXL/WPT1Rdn6hcETx22Uy/eRfhpMQEBeU7dNs=;
        b=0qoNIvYj1h+mGob/YTGW+DSuwS/OacGOeF2pB2zXBPU0zERz97/sgEwPeG+OafCw/U
         dUgKXP9r52kmSLXHyh9LnJnM91DU3kI6WXNOISYm/entueCcFCxf4yjeizhruPgV8oRN
         pY1fib7rgLAgNcOxEJuZn6a9g2FJIzJgTc3OthJJgurZixP3z8SzDGVyXRiBXaI3FjRY
         mkGMg4Gw+IL0fut9zVDn8ZsRFhwoQXsRddFyDvX4wOroMBHMmfTybu4qWFShvJqV8hHN
         HxX8YI6Om3ggTZPVPzfHc2X5633imt+U6yVegpciXiKmqNsjm1JaT/8EypCtZmMWkSiu
         ydWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LroTWGjXL/WPT1Rdn6hcETx22Uy/eRfhpMQEBeU7dNs=;
        b=xSES+mbd2Vln1Wu3zdbFDHM3BOSg6eYO/rrLPRBLLi9ooX8h5EsXyUz+j97gjxmWeh
         yXnXjMud42JWEb6ViaTU/fgVcm+rvCDVIBPrZbbuB4Hj2SIoSyI3LaVfTywVhadcyNrc
         X5wLTnfY4Rg3YIW2KckGaxaLVy/65YMqsJqVeVD6ILEDovIkm0ugA5uvrwY1UZnbtY7z
         xmx6aWfftBOC4d+G5e6LfPZOj3Eorc0Naml8WOi7zTge4s86AC37nOLMA1FpuBtS+dYV
         fABjHQh3yGmHhyBLGrE7RgX8UYAPeOSgAgMKa1mMN97gthxGQRgz9o/MImgSCSwlcqUW
         OzBw==
X-Gm-Message-State: ACgBeo03G5OmGKAUWeDhsVh8fm2aC8PZ9lHzNwtE2SMFnNUleTmoWbQS
        0WkAJlt+qYHtzB/b7tp6bMF55ueKrpTgzzbP/Sc=
X-Google-Smtp-Source: AA6agR4kOxE5JPDp4jREwXnNS1IkuOgvDbi6Oq/UxYFr5D/LVlHHr1BLZe4NwFA9MBJRTudyuwNEWQ==
X-Received: by 2002:a17:903:2589:b0:16d:c26c:d641 with SMTP id jb9-20020a170903258900b0016dc26cd641mr5798640plb.8.1659131548133;
        Fri, 29 Jul 2022 14:52:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1-20020a623101000000b0050dc7628183sm3494943pfx.93.2022.07.29.14.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 14:52:26 -0700 (PDT)
Message-ID: <62e4569a.620a0220.d2d58.59b5@mx.google.com>
Date:   Fri, 29 Jul 2022 14:52:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.207-87-g63a366361d9d8
Subject: stable-rc/queue/5.4 baseline: 76 runs,
 5 regressions (v5.4.207-87-g63a366361d9d8)
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

stable-rc/queue/5.4 baseline: 76 runs, 5 regressions (v5.4.207-87-g63a36636=
1d9d8)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.207-87-g63a366361d9d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.207-87-g63a366361d9d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63a366361d9d89f26e7ca11b30edc7f5dc917cb9 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e420e5dadffe2261daf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e420e5dadffe2261daf=
068
        failing since 3 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e420dbdadffe2261daf061

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e420dbdadffe2261daf=
062
        failing since 3 days (last pass: v5.4.180-77-g7de29e82b9db, first f=
ail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e420e6dadffe2261daf06a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e420e6dadffe2261daf=
06b
        failing since 80 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e420e4dadffe2261daf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e420e4dadffe2261daf=
065
        failing since 80 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e420e7dadffe2261daf06d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.207-8=
7-g63a366361d9d8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e420e7dadffe2261daf=
06e
        failing since 80 days (last pass: v5.4.191-84-g56ce42d78d96, first =
fail: v5.4.191-125-g5917d1547e6e) =

 =20
