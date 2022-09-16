Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EEE5BAF44
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiIPO0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 10:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiIPOZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 10:25:49 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37C99FA89
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 07:25:48 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fs14so21242797pjb.5
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 07:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=b8ej3nNOOF1BkwUBK/tY98A65tjNQ2Xjnye6SmAudhU=;
        b=jLc7fia4/2fnK03JQ6nQM4ONRR5hecPIH2qeOFjaRqsM/9B0iooGdlg1r+4usE9RBU
         D1O5h2UNvRpPgrY6VyokW09cEfSCUGsGUv8DBnMiPVw1Eth6Brzsvbs1NLtk2alId0zf
         hE8Qbxty65xOyHIjA+vGRV3kZl2xbVBhZG5RH97jDEg49A20SBH5za3642hM1TRtrA+/
         J+T5ptuTHIEzC/whKUdZP3sJorlA6rgN74wG/Dy2Mb6AgLCvBXX6JzxPzL4aCiL1/tki
         U9zyiTCuRWXFrxXarcVjvK+z7p9hfT1XLMWAW3DUlMqUMToC/Sge8AwJG5KAuACQCaRo
         5VCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=b8ej3nNOOF1BkwUBK/tY98A65tjNQ2Xjnye6SmAudhU=;
        b=o2aJ5WJIYQxKtlJv5ZkCuAasvq9afVZlTxTZCiEpi4e8Jw5RUtD+gZdnZUHjNCvbXc
         2E5VHqzBxhyoGtOOZ3aLfwubLCafs+/2iXRgr3l1vc6ercdvDr87e7ssVoKWrXO/kG3p
         BHa9CprpRU3N6YIy5Ve7XhxMuD1xsSNmmEThaKtVBGxhpR9IdJtUVShRFUYBo9lSfVa8
         t9T32V1mLb5MaTenv7K3mUFk7Wj7OBpauBL84vJGJyN6vpTmBskb2BCkl0GE19c1SWlD
         PuVmFcA3iclVsg/tR9DikrbOwbeUIgkpRa7uhomydgnk+PPpzm6f4D/m/kyWilGC5lkp
         LDRA==
X-Gm-Message-State: ACrzQf0sYqcK6WqVbQKG9SEGLSYUGHDoQLbn0VmyQmG0jQWZvJJnWkP9
        B/ifTZBNz6pq+u68BVpRMSXg+RTPQ8WRMCsYYow=
X-Google-Smtp-Source: AMsMyM6sAFIJYX0+lqIIplDwQUS0w/+paRy92KYSXWq1cKMA7BxAMWUGPF04xJX5w0nluaDa2srqzw==
X-Received: by 2002:a17:90a:a69:b0:202:8a60:c869 with SMTP id o96-20020a17090a0a6900b002028a60c869mr6012794pjo.2.1663338347984;
        Fri, 16 Sep 2022 07:25:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902ed5400b00174f7d107c8sm14830720plb.293.2022.09.16.07.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 07:25:47 -0700 (PDT)
Message-ID: <6324876b.170a0220.7e586.b536@mx.google.com>
Date:   Fri, 16 Sep 2022 07:25:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.328-7-g89af30f786fe1
Subject: stable-rc/queue/4.9 baseline: 94 runs,
 5 regressions (v4.9.328-7-g89af30f786fe1)
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

stable-rc/queue/4.9 baseline: 94 runs, 5 regressions (v4.9.328-7-g89af30f78=
6fe1)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.328-7-g89af30f786fe1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.328-7-g89af30f786fe1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89af30f786fe1f3f5647451ae5f49612f16d262f =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/632457a71d6a0a6c3d355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632457a71d6a0a6c3d355=
643
        failing since 129 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/63245794d5e4bc15ce355652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63245794d5e4bc15ce355=
653
        failing since 129 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/632457449c1ecb5fa135564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632457449c1ecb5fa1355=
64c
        failing since 129 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6324594bda4c1cb23c355667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6324594bda4c1cb23c355=
668
        failing since 129 days (last pass: v4.9.312-43-g8ccd2ae24f47, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/63245793de483c68e2355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.328-7=
-g89af30f786fe1/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63245793de483c68e2355=
657
        failing since 129 days (last pass: v4.9.312-43-g5b8113699dd5, first=
 fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
