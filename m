Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF78597A5D
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 01:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241785AbiHQXxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 19:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241705AbiHQXxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 19:53:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F4B326D0
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 16:53:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso3226575pjl.1
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 16:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=MWhOfrRJFL/sF0uBEa+fvpEa4LMONrRX+4DJU1mMphs=;
        b=zrojlkftKOp9yfExmJ9ZUqIM2Rn34hky7HPcWh97sXTY38ijHbGBdHJ9uquaiRfwxt
         KJJn5DUJo2C/kZXt5LBlNF+Berv6dTtcnuyTHGfkukGLcYWBw6UZFAIiQD7zMtpjJyvr
         /r06j6oyw6p13oIU+BCmygvd6gCdUk67NgqP/O6QDKHWCzcsHHOB9yA9V4mB2yOG9asv
         7mv07/VFN53txw1K8/Npij+OXOkZUcedQB7yUd8jH7IU9cm7RBykpvd/z54dEq4L1kBt
         GsVsMZfZl/qHvv4S15g0yhBjXzMV7V5Ns9fNFUcyv2hD7nFYFIclMkDNTdg/FNumOgRA
         taOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=MWhOfrRJFL/sF0uBEa+fvpEa4LMONrRX+4DJU1mMphs=;
        b=7wr7Kjpzo2AmDp44sR0pT7oU5RXFWpCiBW48BneXuMyl/Ytx3jcqK8V+EzEGu6ZNAM
         +5vAhC4hMwDGQAY6UK8UjTd2RvCsmEBDLcHHVGD1tBvXgagmQ6RttDxokduxS+avf84e
         Jxh6QyURVKhy8Nozfy4zh1WLUuptxxfw38PcV0huBKAJ+GAwJrxTzY2xXBrr2FPQdVpH
         6kXF5HTgMPnKNrZ60vh2TKYCPS2c0XTj7gtvlvlsGqTamWtG2GcoQ1wWcdDu/NMGOvaY
         dVEunvWKtGN6aZP6pRCj3lis0oy3GpZULqbkhG+7W5bvC1o9hteJSWxTJykxJICReuzA
         rqnw==
X-Gm-Message-State: ACgBeo2g4HijqvYbHg+KIVKqgYr+BCLCA+mYVVD/qrSJ6TfoIU6w2FKQ
        jmZKdWp50lCRzTjuG5XJoX7x2r5Ybod1nocA
X-Google-Smtp-Source: AA6agR56bW5mvWOWzRv2/1dQah+jwJONFbC7GtRMOYlKeNxo6dB2ofgKIVqZJSM2xb7m7sIEDT4ghw==
X-Received: by 2002:a17:902:e552:b0:16c:571d:fc08 with SMTP id n18-20020a170902e55200b0016c571dfc08mr276319plf.151.1660780407837;
        Wed, 17 Aug 2022 16:53:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12-20020a17090a600c00b001f2ef3c7956sm2091369pji.25.2022.08.17.16.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 16:53:27 -0700 (PDT)
Message-ID: <62fd7f77.170a0220.e86e.4078@mx.google.com>
Date:   Wed, 17 Aug 2022 16:53:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.255-210-geda83f051ac49
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 6 regressions (v4.19.255-210-geda83f051ac49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 6 regressions (v4.19.255-210-geda83=
f051ac49)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.255-210-geda83f051ac49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.255-210-geda83f051ac49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eda83f051ac497c8e83d33e4cd6d72b6ff7d163c =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4e8c303256251c35565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4e8c303256251c355=
65d
        failing since 99 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4dd5d153678fb2355654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4dd5d153678fb2355=
655
        failing since 99 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4e7534ad36d822355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4e7534ad36d822355=
64a
        failing since 22 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4d0416b0d790c2355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4d0416b0d790c2355=
651
        failing since 22 days (last pass: v4.19.230-58-gbd840138c177, first=
 fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd4e61a75e0fabca35564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd4e61a75e0fabca355=
650
        failing since 99 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62fd519512623fef2c355654

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.255=
-210-geda83f051ac49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62fd519512623fef2c35567a
        failing since 164 days (last pass: v4.19.232-31-g5cf846953aa2, firs=
t fail: v4.19.232-44-gfd65e02206f4)

    2022-08-17T20:37:23.535423  <8>[   36.177890] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-08-17T20:37:24.546930  /lava-7065582/1/../bin/lava-test-case   =

 =20
