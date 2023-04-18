Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C850C6E6D56
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 22:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDRUMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 16:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDRUMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 16:12:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B4E4C1A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 13:12:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-517c57386f6so1894068a12.2
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 13:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681848753; x=1684440753;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ5Ig+BlOho8c4n4kn1IbeYlZXD9WxQRrdAifG7br/k=;
        b=zIPJNFyUz2l9NjeehWZsKECT3z1+RkSRhUD/s85Epg3ebQtbp0WEjmF3dKvRYmYgNO
         m3l/YSChBQdiEfdU0iIgNX3OOl00WR/zJ9Bc+XdC8W9OwqVyleF8lqlE/uN7QI9Xtr2b
         IhVQ6KwaGzZPhU5WbFXa7yteNLerzrpQ3uUx3Lg9jQMmylQ5FLGCwcqNW72JFSsgFptE
         lCeOMiqY/R74TrBWp7UhIDev+uhe4wuObIjLfa5bwjgOhxDiaGNIJppuln1ii/ZX1fTm
         1sahlHmnvrJMuG+Mns69qBQdaQq0MMUqIdGIC9Zb2P9AweFJvtLfP+48aUKKeFy2Dief
         6d0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681848753; x=1684440753;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fQ5Ig+BlOho8c4n4kn1IbeYlZXD9WxQRrdAifG7br/k=;
        b=XMiQCSl7UcKCaA/JL4rFJ+DF0oYzc1qb/ANmrQxAyHrxtnpHIVBG7QxonaI+jac82G
         JujvVSdNupW2d4TcDDq7dT6dUacPyJp6bQ0IoxyjvgOubmmwdeaZxqYdYChvqYiASisL
         Ud47TrPAF3M6/nvV5qAR8TLRBzcuHZnH3RT/j+vx/yYdUTZkCQ0dyzugQAHORHiTejRe
         7p5OwJn2Yg6IYfsy/ihN7l3/z+7Ezm4A/OH7AjmM0+vdDRyoTGj8VaBQ0+izf4gZX6+G
         lET40kFJWeb2Ew7nOlYuvFNEzdWn5HLf1yFOcctsTnkgW7iNocN+nvwjilcwiMOUCFtJ
         A8BA==
X-Gm-Message-State: AAQBX9dH3S1LuLFF9J1TRF+Bbp9k+n6iGNfMDlYQAk2qew3wQKn8VbBO
        nA+oowHrOtiOggpwDlZPLImywGs13cICCMlsMC2+fW70
X-Google-Smtp-Source: AKy350ZMmMAvfhX3TaSuqAhkRmCvNKev8AH+C55D1CvXKVZLfApevtNJ3gMXjBcoGXHDcJ7oG1SO8g==
X-Received: by 2002:a17:90b:1e04:b0:240:f8a6:55c7 with SMTP id pg4-20020a17090b1e0400b00240f8a655c7mr745816pjb.20.1681848752880;
        Tue, 18 Apr 2023 13:12:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x18-20020a170902821200b001a6cb827fafsm5030280pln.278.2023.04.18.13.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 13:12:31 -0700 (PDT)
Message-ID: <643ef9af.170a0220.a6300.b847@mx.google.com>
Date:   Tue, 18 Apr 2023 13:12:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-279-gec40996c2eea
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 78 runs,
 10 regressions (v5.15.105-279-gec40996c2eea)
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

stable-rc/queue/5.15 baseline: 78 runs, 10 regressions (v5.15.105-279-gec40=
996c2eea)

Regressions Summary
-------------------

platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
cubietruck                | arm   | lab-baylibre    | gcc-10   | multi_v7_d=
efconfig | 1          =

hifive-unleashed-a00      | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =

imx53-qsrb                | arm   | lab-pengutronix | gcc-10   | multi_v7_d=
efconfig | 1          =

qemu_riscv64              | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =

qemu_riscv64              | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =

qemu_riscv64              | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =

qemu_smp8_riscv64         | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =

qemu_smp8_riscv64         | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =

qemu_smp8_riscv64         | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =

sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre    | gcc-10   | sunxi_defc=
onfig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-279-gec40996c2eea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-279-gec40996c2eea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec40996c2eeacb96d6a8f06f270cc0d5aa89d2a5 =



Test Regressions
---------------- =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
cubietruck                | arm   | lab-baylibre    | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec74f47bb2e96832e85f3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ec74f47bb2e96832e85f8
        failing since 91 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-18T16:37:18.662712  <8>[   10.044343] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3508476_1.5.2.4.1>
    2023-04-18T16:37:18.773729  / # #
    2023-04-18T16:37:18.877035  export SHELL=3D/bin/sh
    2023-04-18T16:37:18.878595  #
    2023-04-18T16:37:18.980912  / # export SHELL=3D/bin/sh. /lava-3508476/e=
nvironment
    2023-04-18T16:37:18.982001  =

    2023-04-18T16:37:18.982785  / # <3>[   10.273028] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-04-18T16:37:19.085378  . /lava-3508476/environment/lava-3508476/bi=
n/lava-test-runner /lava-3508476/1
    2023-04-18T16:37:19.086734  =

    2023-04-18T16:37:19.096706  / # /lava-3508476/bin/lava-test-runner /lav=
a-3508476/1 =

    ... (12 line(s) more)  =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
hifive-unleashed-a00      | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec7375b2a5289eb2e85f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ec7375b2a5289eb2e8=
5f5
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
imx53-qsrb                | arm   | lab-pengutronix | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec6adcf278531c72e860d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ec6adcf278531c72e8612
        failing since 81 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-18T16:34:46.781864  + set +x
    2023-04-18T16:34:46.782034  [    9.398914] <LAVA_SIGNAL_ENDRUN 0_dmesg =
929728_1.5.2.3.1>
    2023-04-18T16:34:46.889167  / # #
    2023-04-18T16:34:46.990774  export SHELL=3D/bin/sh
    2023-04-18T16:34:46.991304  #
    2023-04-18T16:34:47.092761  / # export SHELL=3D/bin/sh. /lava-929728/en=
vironment
    2023-04-18T16:34:47.093288  =

    2023-04-18T16:34:47.194504  / # . /lava-929728/environment/lava-929728/=
bin/lava-test-runner /lava-929728/1
    2023-04-18T16:34:47.195073  =

    2023-04-18T16:34:47.197651  / # /lava-929728/bin/lava-test-runner /lava=
-929728/1 =

    ... (12 line(s) more)  =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_riscv64              | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec64c7aa420dab42e85f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ec64c7aa420dab42e8=
5f7
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_riscv64              | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee2ea7964ef8d012e85f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee2ea7964ef8d012e8=
5f2
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_riscv64              | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec5c5c7d1626eef2e85f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ec5c5c7d1626eef2e8=
5f6
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_smp8_riscv64         | riscv | lab-baylibre    | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec64ea8229c53fc2e85f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ec64ea8229c53fc2e8=
5f2
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_smp8_riscv64         | riscv | lab-broonie     | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ee31232f59db9c22e861f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ee31232f59db9c22e8=
620
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
qemu_smp8_riscv64         | riscv | lab-collabora   | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec5c6f5bfef416e2e8608

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ec5c6f5bfef416e2e8=
609
        failing since 1 day (last pass: v5.15.105-244-g4632bdfc359d, first =
fail: v5.15.105-251-ge618cb6cad09) =

 =



platform                  | arch  | lab             | compiler | defconfig =
         | regressions
--------------------------+-------+-----------------+----------+-----------=
---------+------------
sun8i-h2-plus-orangepi-r1 | arm   | lab-baylibre    | gcc-10   | sunxi_defc=
onfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/643ec2fbf3b1b7e7fc2e8651

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-279-gec40996c2eea/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ec2fbf3b1b7e7fc2e8656
        failing since 77 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-18T16:18:56.879405  / # #
    2023-04-18T16:18:56.984896  export SHELL=3D/bin/sh
    2023-04-18T16:18:56.986498  #
    2023-04-18T16:18:57.089821  / # export SHELL=3D/bin/sh. /lava-3508404/e=
nvironment
    2023-04-18T16:18:57.091339  =

    2023-04-18T16:18:57.194775  / # . /lava-3508404/environment/lava-350840=
4/bin/lava-test-runner /lava-3508404/1
    2023-04-18T16:18:57.197536  =

    2023-04-18T16:18:57.204471  / # /lava-3508404/bin/lava-test-runner /lav=
a-3508404/1
    2023-04-18T16:18:57.362134  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-18T16:18:57.363193  + cd /lava-3508404/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
