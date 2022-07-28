Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767A9584862
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiG1Wru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiG1Wru (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:47:50 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260994F65E
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 15:47:49 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso3837134pjq.4
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 15:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hs3amOE8xXaBiotujqn39/E+gBfjBLoCfzMWkbAcQAA=;
        b=0vdvhgBK47Igi/HCCfF3a/6SHjxeNU0LMDVi7YMtzOQex7TfiynLXmLxHNzaX0GJZ6
         XBVv3888IEWM6HfDLrN45Df8QObv49fARZ5Uy95zNwj+qAAIWRRGtAbsB3am6UqWWFRV
         IBSD53FNg8nBP1xuSVf5LHMEca1TTl1tFnvORg+q6rVwmOpZfIjxGAmQj++0fOmier/z
         TTQKoAlj2SQPNP6+6CQvphzW3tSEnYAvtEZHzfUFL8Vtis6ZStDsKjMF43w5aRU1lr5H
         4vy5teMPi1a5vWkaDYUXs8s01hZEVFMD9wkza7hgN8WhHGI+4ichn0EPRW37EiDQg9pi
         nwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hs3amOE8xXaBiotujqn39/E+gBfjBLoCfzMWkbAcQAA=;
        b=Xj8Le/0CUO3vSYA1cK3Yot+GgzEe/Jadat7YEpoTmDuapGdYpcq4lY+IszuG9R0a5d
         reJntGNZ7MSodtupHQAbdkUV6WuZujHNlE7m2seetkDhoSw0l2CPCoY0V2bLs5gv7Muj
         XrH8YszPVdF3fReykF3LlLJtSHYHlBMt95xG7iovuHUWM4y1LW7BwP/EB9udBf6OQKo3
         L80mKS7unDYmdDl7C+cAi9KuBa84BZ6JP1z5IUvALExjf9WVHchmT0VBy1+sCDtpY7sM
         N7Gg9i9zv+zM0GApeSN2OMeFUSUygOCk3s5z6vYi1NdJbwji2b4OCu7NcyeHRpOPoiQi
         gFCg==
X-Gm-Message-State: ACgBeo3PAmh1sGRmp6l9C82bBCImne6xw9kpOsmbkdVjLoZmTujJUcWa
        QoeJdEzFZr1U1e4izO9WhVFRA7G4oEg8/osI
X-Google-Smtp-Source: AA6agR4wgklPFnwgHlKiHyUSSBTDMWlvC4hnfDaawB/Hl8vtURvbJba6DcXrnY96ozCJijh3CJG1EQ==
X-Received: by 2002:a17:902:da8f:b0:16d:1c82:624b with SMTP id j15-20020a170902da8f00b0016d1c82624bmr940681plx.163.1659048468408;
        Thu, 28 Jul 2022 15:47:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902e74b00b0016c408ce56fsm1845782plf.301.2022.07.28.15.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:47:47 -0700 (PDT)
Message-ID: <62e31213.170a0220.6ba1.2d68@mx.google.com>
Date:   Thu, 28 Jul 2022 15:47:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.253-62-gda549b1ab82a2
Subject: stable-rc/queue/4.19 baseline: 78 runs,
 5 regressions (v4.19.253-62-gda549b1ab82a2)
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

stable-rc/queue/4.19 baseline: 78 runs, 5 regressions (v4.19.253-62-gda549b=
1ab82a2)

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

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.253-62-gda549b1ab82a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.253-62-gda549b1ab82a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da549b1ab82a2af10e24c87488ce297f608fb0ea =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2da72f855f935fddaf089

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2da72f855f935fddaf=
08a
        failing since 79 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2da71f855f935fddaf086

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2da71f855f935fddaf=
087
        failing since 79 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2da74f855f935fddaf08c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2da74f855f935fddaf=
08d
        failing since 79 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2da75f855f935fddaf08f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e2da75f855f935fddaf=
090
        failing since 79 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e2d985ca364db183daf0c3

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.253=
-62-gda549b1ab82a2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62e2d985ca364db183daf0e5
        failing since 144 days (last pass: v4.19.232-31-g5cf846953aa2, firs=
t fail: v4.19.232-44-gfd65e02206f4)

    2022-07-28T18:46:07.891407  <8>[   35.855796] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-28T18:46:08.907613  /lava-6909018/1/../bin/lava-test-case   =

 =20
