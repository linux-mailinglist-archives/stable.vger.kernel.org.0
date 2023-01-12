Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1CE668639
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 22:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbjALV5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 16:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbjALV4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 16:56:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647C85B146
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:48:52 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q23-20020a17090a065700b002290913a521so2769047pje.5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LxI79ACmocHISttRUFMBI5Z4GDAwMxZMnSEKKpjQwrA=;
        b=216zds3THGfiXBySevDUdvysYYtPnoicjg0/ElD3G82xr/ZjyOWSx1kXgM/6J3aPyx
         nIm6X9TW5KsBiRLEfJyqsZjb6+MSiOW/iIuY6oelRPsxZvzOo8N/EKQiVUozXOZsYfSu
         YHmOGlQ7u092h5waSm/Ep+9autbTh7ccqN1+zIKioF6szH00k/e5u8CyLp7BoBSgfxSQ
         bk31emw9PRr7w9pZhlyURB3lN7I87Uq7BarOtfphOps9kpINjwzFjLT7DOg1Xuucui61
         oBHN2DgmO1Pnvv2VRsA1HX923TmvPpMvqmNEF9P2mwM61b24Ee2pUV2qbQaxtJq5kGR6
         kgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LxI79ACmocHISttRUFMBI5Z4GDAwMxZMnSEKKpjQwrA=;
        b=zeb+8dmHcBoIjwEmyu8fPbC40G7ItxZiZIjNpaTlzpFZPfSHNfef61NkaotObxRmC4
         e4jCx9qN0VgRUScPH+LLqGgU6aXHkVWC1J1J01DdKdf+18fGUQIjbSsVMD63WsipTNcZ
         KOkaR6gMwSJGey/F5UXXG/IAcD08MnkRJeTxcbvMQ4ZtoTNgewW500QzQCzAmhJQWIbz
         BIsffHgst9JzOyCB5/044qf05cQl9nPqXstWVaIZjPDZT8nuElfguQ9mbw/QFburM3nw
         H9D2GDKH2Ids+nnJZVmjGDrw3zkBgukNK2iAYiyJcYXYyJ757m6V0lC2JMuwdJK1Ns1t
         oGQw==
X-Gm-Message-State: AFqh2kr5uI8FaDgYWoHJkJDf0emx7xlSJzW0V63ZxwzDt0vsZcFYCpXv
        lWvozAphRhO39X3fWxkXE6SAukxZpOsvbDqa933HRg==
X-Google-Smtp-Source: AMrXdXsST/zNNH2VZe+LHzJH2rJTSzrf8SnyrSpqwCwvZWAlevy6EgpQwf7u+6SP2dNSrSX6rRtMJQ==
X-Received: by 2002:a05:6a21:99a4:b0:a3:94cd:1435 with SMTP id ve36-20020a056a2199a400b000a394cd1435mr123972689pzb.38.1673560131436;
        Thu, 12 Jan 2023 13:48:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x16-20020a634a10000000b004812f798a37sm8758556pga.60.2023.01.12.13.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 13:48:51 -0800 (PST)
Message-ID: <63c08043.630a0220.a1fce.d35d@mx.google.com>
Date:   Thu, 12 Jan 2023 13:48:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.228-602-gd08f64f75d4c8
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 96 runs,
 11 regressions (v5.4.228-602-gd08f64f75d4c8)
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

stable-rc/queue/5.4 baseline: 96 runs, 11 regressions (v5.4.228-602-gd08f64=
f75d4c8)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =

bcm2835-rpi-b-rev2         | arm   | lab-broonie     | gcc-10   | bcm2835_d=
efconfig          | 1          =

bcm2836-rpi-2-b            | arm   | lab-collabora   | gcc-10   | bcm2835_d=
efconfig          | 1          =

odroid-xu3                 | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-602-gd08f64f75d4c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-602-gd08f64f75d4c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d08f64f75d4c8c69bc2c15cc0dbe742e8ff20510 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
am57xx-beagle-x15          | arm   | lab-linaro-lkft | gcc-10   | multi_v7_=
defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63c04a8f87072426711d39e3

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
63c04a8f87072426711d39e7
        failing since 2 days (last pass: v5.4.228-590-g9476d91a56e1, first =
fail: v5.4.228-593-g98d16b625f77)

    2023-01-12T17:59:24.712696  <8>[   21.281685] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddeferred-probe-empty RESULT=3Dfail>
    2023-01-12T17:59:25.719168  /lava-6048879/1/../bin/lava-test-case
    2023-01-12T17:59:25.763638  <8>[   22.316150] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2023-01-12T17:59:25.763969  /lava-6048879/1/../bin/lava-test-case   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63c04a8f87072426=
711d39ea
        failing since 2 days (last pass: v5.4.228-590-g9476d91a56e1, first =
fail: v5.4.228-593-g98d16b625f77)
        1 lines

    2023-01-12T17:59:22.557463  / # =

    2023-01-12T17:59:22.566681  =

    2023-01-12T17:59:22.671636  / # #
    2023-01-12T17:59:22.678637  #
    2023-01-12T17:59:22.780472  / # export SHELL=3D/bin/sh
    2023-01-12T17:59:22.790507  export SHELL=3D/bin/sh
    2023-01-12T17:59:22.892051  / # . /lava-6048879/environment
    2023-01-12T17:59:22.902428  . /lava-6048879/environment
    2023-01-12T17:59:23.003995  / # /lava-6048879/bin/lava-test-runner /lav=
a-6048879/0
    2023-01-12T17:59:23.014313  /lava-6048879/bin/lava-test-runner /lava-60=
48879/0 =

    ... (8 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
bcm2835-rpi-b-rev2         | arm   | lab-broonie     | gcc-10   | bcm2835_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63c0477ff3038d95501d39da

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c0477ff3038d95501d39df
        failing since 2 days (last pass: v5.4.228-542-gef9f34da2ed1f, first=
 fail: v5.4.228-590-g9476d91a56e1)

    2023-01-12T17:46:15.376465  + set +x
    2023-01-12T17:46:15.380370  <8>[   17.030604] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 99627_1.5.2.4.1>
    2023-01-12T17:46:15.498010  / # #
    2023-01-12T17:46:15.599827  export SHELL=3D/bin/sh
    2023-01-12T17:46:15.600401  #
    2023-01-12T17:46:15.702046  / # export SHELL=3D/bin/sh. /lava-99627/env=
ironment
    2023-01-12T17:46:15.702595  =

    2023-01-12T17:46:15.804227  / # . /lava-99627/environment/lava-99627/bi=
n/lava-test-runner /lava-99627/1
    2023-01-12T17:46:15.804981  =

    2023-01-12T17:46:15.810885  / # /lava-99627/bin/lava-test-runner /lava-=
99627/1 =

    ... (13 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
bcm2836-rpi-2-b            | arm   | lab-collabora   | gcc-10   | bcm2835_d=
efconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63c078d2c6659c9d371d39c3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm28=
36-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm28=
36-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c078d2c6659c9d371d39c8
        failing since 2 days (last pass: v5.4.228-542-gef9f34da2ed1f, first=
 fail: v5.4.228-590-g9476d91a56e1)

    2023-01-12T21:16:47.168901  / # #
    2023-01-12T21:16:47.270570  export SHELL=3D/bin/sh
    2023-01-12T21:16:47.271101  #
    2023-01-12T21:16:47.372452  / # export SHELL=3D/bin/sh. /lava-8689740/e=
nvironment
    2023-01-12T21:16:47.372971  =

    2023-01-12T21:16:47.474318  / # . /lava-8689740/environment/lava-868974=
0/bin/lava-test-runner /lava-8689740/1
    2023-01-12T21:16:47.475035  =

    2023-01-12T21:16:47.489694  / # /lava-8689740/bin/lava-test-runner /lav=
a-8689740/1
    2023-01-12T21:16:47.597639  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-12T21:16:47.597972  + cd /lava-8689740/1/tests/1_bootrr =

    ... (11 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
odroid-xu3                 | arm   | lab-collabora   | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63c04a9287072426711d3a14

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c04a9287072426711d3a19
        failing since 2 days (last pass: v5.4.228-542-gef9f34da2ed1f, first=
 fail: v5.4.228-590-g9476d91a56e1)

    2023-01-12T17:59:37.243460  / # #
    2023-01-12T17:59:37.346905  export SHELL=3D/bin/sh
    2023-01-12T17:59:37.347451  #
    2023-01-12T17:59:37.448846  / # export SHELL=3D/bin/sh. /lava-8689900/e=
nvironment
    2023-01-12T17:59:37.449358  =

    2023-01-12T17:59:37.550949  / # . /lava-8689900/environment/lava-868990=
0/bin/lava-test-runner /lava-8689900/1
    2023-01-12T17:59:37.551745  =

    2023-01-12T17:59:37.553941  / # /lava-8689900/bin/lava-test-runner /lav=
a-8689900/1
    2023-01-12T17:59:37.653460  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-12T17:59:37.653805  + cd /lava-8689900/1/tests/1_bootrr =

    ... (15 line(s) more)  =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c047eaba97d4fa821d39c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c047eaba97d4fa821d3=
9c8
        failing since 170 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c046b0a7afa7039b1d3a0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c046b0a7afa7039b1d3=
a0e
        failing since 170 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie     | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c047afbc3e22540e1d39d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c047afbc3e22540e1d3=
9d1
        failing since 170 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63c046afce008b76aa1d39d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c046afce008b76aa1d3=
9d5
        failing since 170 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie     | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63c04d00f79fe9120f1d39d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c04d00f79fe9120f1d3=
9d2
        failing since 170 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
                  | regressions
---------------------------+-------+-----------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63c04a98c4c91cceb71d3a2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-6=
02-gd08f64f75d4c8/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c04a98c4c91cceb71d3=
a2f
        failing since 170 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
