Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74B867B8D5
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 18:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjAYRvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 12:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbjAYRvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 12:51:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C8BDBF1
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 09:51:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k10-20020a17090a590a00b0022ba875a1a4so2827783pji.3
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 09:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IvQiYXl9DQprA43iYGa5ii2PAyDQjagA+GwgdikQSg0=;
        b=u+DeeBo/UtXmVFtwriMkPE6T1ULZow/t1OKPxWpxW5V2TW/Xjl3XrQAhuw12MqIJXL
         9z/KMj9BkvjJ4n/fBEpho5NW8Fysy9nhzmLwfsoFTFLagb33+hkQdB+Ie0WWn5j8NS9Y
         qKYsT9ySisK9NMIfeKuaB7Fv0+PSDoer1AsBTV2K2Cou3ZPRWTzcNftyojgsijh/UJ4e
         yBe/8ea5GG1p05vJIHX683tfA291eOzX0CE+6WcfX1wSEOmaLubH5y7aeZMv+MzI/DuY
         8QDRikjBX4B0WfeoL6UkTGe8N6CEj+oFFSBbLILgamLponAIMfy3hkrk/zJBR00VhiPs
         Q9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvQiYXl9DQprA43iYGa5ii2PAyDQjagA+GwgdikQSg0=;
        b=EC4vXaH+JH1zActOPbvBODXRvYxs3Esp2nbEtSqw2cUH1hNCTVlr5q9YUcq6nn1jd6
         EiO/0MRY6QlBACysKBwaNN+mVOqUbfbpJXzJ+xsjxDtGii/FsHkaXm4CV10yUGN6FsAm
         4LGPbOvrvur5yZ48/BisgZ/eJbhxIOG296UsUBn8NSyYpm83P56WKIAx3qwDECk6pZei
         4aN1xhcEnx1+vq/1yeB/ZOj1jnw+1pjHrDNn/eVwmvA+V/UCLyl2H4vJ5pFzod4DjJYL
         svMmNrQaGeEr9yK1IhSX45uNpk/o9PI/hH41NYIYltJ12VoBqb1av9oPk0AjhJTnGsqY
         FlYQ==
X-Gm-Message-State: AO0yUKXxDY9cvRLkPsvrSvp8M2F4YtIgTteZfWTa0oxDHsF5MBIQCJie
        8qKkIRY1HkMV+L3ytfkRV01ws1cok1C9u+gXqHM=
X-Google-Smtp-Source: AK7set9RJGKirIDWNwgO5n/dgzDfiIOL4xDxd0rbDpkh0h3KcfQ7GHVcgKbTgznT9r8R5O2yqRg6NQ==
X-Received: by 2002:a17:90b:1b4a:b0:22b:f93b:b5ae with SMTP id nv10-20020a17090b1b4a00b0022bf93bb5aemr5489564pjb.46.1674669078628;
        Wed, 25 Jan 2023 09:51:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090ad3c200b0022c147850cbsm514459pjw.36.2023.01.25.09.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 09:51:18 -0800 (PST)
Message-ID: <63d16c16.170a0220.7be81.1594@mx.google.com>
Date:   Wed, 25 Jan 2023 09:51:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.230
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 137 runs, 20 regressions (v5.4.230)
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

stable-rc/linux-5.4.y baseline: 137 runs, 20 regressions (v5.4.230)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =

cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | multi_v5_=
defconfig         | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.230/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.230
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90245959a5b936ee013266e5d1e6a508ed69274e =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1377ae528f044cb915eee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d1377ae528f044cb915ef3
        failing since 8 days (last pass: v5.4.226, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T14:06:31.995844  <8>[   23.918609] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3210209_1.5.2.4.1>
    2023-01-25T14:06:32.105981  / # #
    2023-01-25T14:06:32.209176  export SHELL=3D/bin/sh
    2023-01-25T14:06:32.210267  #
    2023-01-25T14:06:32.312592  / # export SHELL=3D/bin/sh. /lava-3210209/e=
nvironment
    2023-01-25T14:06:32.313845  =

    2023-01-25T14:06:32.416343  / # . /lava-3210209/environment/lava-321020=
9/bin/lava-test-runner /lava-3210209/1
    2023-01-25T14:06:32.418072  =

    2023-01-25T14:06:32.423256  / # /lava-3210209/bin/lava-test-runner /lav=
a-3210209/1
    2023-01-25T14:06:32.516839  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1361be9b9effd36915ed7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d1361be9b9effd36915edc
        failing since 8 days (last pass: v5.4.226, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T14:00:33.308381  <8>[   23.751434] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3210186_1.5.2.4.1>
    2023-01-25T14:00:33.414963  / # #
    2023-01-25T14:00:33.516540  export SHELL=3D/bin/sh
    2023-01-25T14:00:33.517020  #
    2023-01-25T14:00:33.618476  / # export SHELL=3D/bin/sh. /lava-3210186/e=
nvironment
    2023-01-25T14:00:33.618893  =

    2023-01-25T14:00:33.720152  / # . /lava-3210186/environment/lava-321018=
6/bin/lava-test-runner /lava-3210186/1
    2023-01-25T14:00:33.720801  =

    2023-01-25T14:00:33.725861  / # /lava-3210186/bin/lava-test-runner /lav=
a-3210186/1
    2023-01-25T14:00:33.829478  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13819084e48c30d915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d13819084e48c30d915ebe
        failing since 8 days (last pass: v5.4.226-68-g8c05f5e0777d, first f=
ail: v5.4.228-659-gb3b34c474ec7)

    2023-01-25T14:09:08.096701  + set +x<8>[   10.254085] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3210202_1.5.2.4.1>
    2023-01-25T14:09:08.097273  =

    2023-01-25T14:09:08.204872  / # #
    2023-01-25T14:09:08.307826  export SHELL=3D/bin/sh
    2023-01-25T14:09:08.308648  #
    2023-01-25T14:09:08.410381  / # export SHELL=3D/bin/sh. /lava-3210202/e=
nvironment
    2023-01-25T14:09:08.411199  =

    2023-01-25T14:09:08.513135  / # . /lava-3210202/environment/lava-321020=
2/bin/lava-test-runner /lava-3210202/1
    2023-01-25T14:09:08.515515  =

    2023-01-25T14:09:08.519420  / # /lava-3210202/bin/lava-test-runner /lav=
a-3210202/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
da850-lcdk                   | arm   | lab-baylibre  | gcc-10   | multi_v5_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13675b382fb66dc915ec9

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d13675b382fb66dc915ece
        failing since 8 days (last pass: v5.4.227, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T14:02:06.634760  / # #
    2023-01-25T14:02:06.738720  export SHELL=3D/bin/sh
    2023-01-25T14:02:06.739842  #
    2023-01-25T14:02:06.842294  / # export SHELL=3D/bin/sh. /lava-3210193/e=
nvironment
    2023-01-25T14:02:06.843600  =

    2023-01-25T14:02:06.946802  / # . /lava-3210193/environment/lava-321019=
3/bin/lava-test-runner /lava-3210193/1
    2023-01-25T14:02:06.948897  =

    2023-01-25T14:02:06.961237  / # /lava-3210193/bin/lava-test-runner /lav=
a-3210193/1
    2023-01-25T14:02:07.203140  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-25T14:02:07.206496  + cd /lava-3210193/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d136b74f73beb0fe915eec

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63d136b74f73beb0=
fe915ef5
        failing since 98 days (last pass: v5.4.219, first fail: v5.4.219-26=
7-g4a976f825745)
        3 lines

    2023-01-25T14:03:17.740942  / # =

    2023-01-25T14:03:17.741797  =

    2023-01-25T14:03:19.805898  / # #
    2023-01-25T14:03:19.807874  #
    2023-01-25T14:03:21.817507  / # export SHELL=3D/bin/sh
    2023-01-25T14:03:21.818206  export SHELL=3D/bin/sh
    2023-01-25T14:03:23.832744  / # . /lava-3210168/environment
    2023-01-25T14:03:23.833162  . /lava-3210168/environment
    2023-01-25T14:03:25.849315  / # /lava-3210168/bin/lava-test-runner /lav=
a-3210168/0
    2023-01-25T14:03:25.851305  /lava-3210168/bin/lava-test-runner /lava-32=
10168/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13938528c16652a915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13938528c16652a915=
ec4
        failing since 260 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13a65c4c81ad9ed915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13a65c4c81ad9ed915=
eba
        failing since 260 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13936528c16652a915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13936528c16652a915=
ec1
        failing since 260 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13a6436da34e496915ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13a6436da34e496915=
ef1
        failing since 260 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13939528c16652a915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13939528c16652a915=
eca
        failing since 175 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13a62448049fe71915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13a62448049fe71915=
ed9
        failing since 260 days (last pass: v5.4.191-84-gbea55d0a1d975, firs=
t fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1390220def69693915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1390220def69693915=
ece
        failing since 175 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.209) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1393a528c16652a915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1393a528c16652a915=
ecd
        failing since 155 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-390-g1cece69eaa88) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13a75c4c81ad9ed915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13a75c4c81ad9ed915=
ec1
        failing since 163 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-258-ge86027f8111f5) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1390320def69693915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1390320def69693915=
ed1
        failing since 155 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-390-g1cece69eaa88) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13a4291bf02e5be915ed1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d13a4291bf02e5be915=
ed2
        failing since 163 days (last pass: v5.4.180-59-g4f62141869c8, first=
 fail: v5.4.210-258-ge86027f8111f5) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d13759267513124e915ed2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretec=
h-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretec=
h-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d13759267513124e915ed7
        failing since 8 days (last pass: v5.4.227, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T14:05:48.286567  / # #
    2023-01-25T14:05:48.388463  export SHELL=3D/bin/sh
    2023-01-25T14:05:48.388878  #
    2023-01-25T14:05:48.490240  / # export SHELL=3D/bin/sh. /lava-3210216/e=
nvironment
    2023-01-25T14:05:48.490862  =

    2023-01-25T14:05:48.592421  / # . /lava-3210216/environment/lava-321021=
6/bin/lava-test-runner /lava-3210216/1
    2023-01-25T14:05:48.593326  =

    2023-01-25T14:05:48.613220  / # /lava-3210216/bin/lava-test-runner /lav=
a-3210216/1
    2023-01-25T14:05:48.715012  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-25T14:05:48.715638  + cd /lava-3210216/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d135c7c13302ab89915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech-a=
ll-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-plus-libretech-a=
ll-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d135c7c13302ab89915ecc
        failing since 8 days (last pass: v5.4.227, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T13:59:12.641251  <8>[    5.839781] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3210181_1.5.2.4.1>
    2023-01-25T13:59:12.746391  / # #
    2023-01-25T13:59:12.848222  export SHELL=3D/bin/sh
    2023-01-25T13:59:12.849019  #
    2023-01-25T13:59:12.950856  / # export SHELL=3D/bin/sh. /lava-3210181/e=
nvironment
    2023-01-25T13:59:12.951768  =

    2023-01-25T13:59:13.053671  / # . /lava-3210181/environment/lava-321018=
1/bin/lava-test-runner /lava-3210181/1
    2023-01-25T13:59:13.055236  =

    2023-01-25T13:59:13.072048  / # /lava-3210181/bin/lava-test-runner /lav=
a-3210181/1
    2023-01-25T13:59:13.137979  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1375821c23b4ae7915edb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all=
-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all=
-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d1375821c23b4ae7915ee0
        failing since 8 days (last pass: v5.4.227, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T14:05:46.981065  / # #
    2023-01-25T14:05:47.082743  export SHELL=3D/bin/sh
    2023-01-25T14:05:47.083108  #
    2023-01-25T14:05:47.184425  / # export SHELL=3D/bin/sh. /lava-3210214/e=
nvironment
    2023-01-25T14:05:47.184771  =

    2023-01-25T14:05:47.286097  / # . /lava-3210214/environment/lava-321021=
4/bin/lava-test-runner /lava-3210214/1
    2023-01-25T14:05:47.286699  =

    2023-01-25T14:05:47.292395  / # /lava-3210214/bin/lava-test-runner /lav=
a-3210214/1
    2023-01-25T14:05:47.396217  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-25T14:05:47.396594  + cd /lava-3210214/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | sunxi_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d135c59f3aff559a915ec9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3=
-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.230=
/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3=
-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d135c59f3aff559a915ece
        failing since 8 days (last pass: v5.4.227, first fail: v5.4.228-659=
-gb3b34c474ec7)

    2023-01-25T13:59:10.477727  / # #
    2023-01-25T13:59:10.579391  export SHELL=3D/bin/sh
    2023-01-25T13:59:10.579735  #
    2023-01-25T13:59:10.681047  / # export SHELL=3D/bin/sh. /lava-3210180/e=
nvironment
    2023-01-25T13:59:10.681411  =

    2023-01-25T13:59:10.782779  / # . /lava-3210180/environment/lava-321018=
0/bin/lava-test-runner /lava-3210180/1
    2023-01-25T13:59:10.783428  =

    2023-01-25T13:59:10.789102  / # /lava-3210180/bin/lava-test-runner /lav=
a-3210180/1
    2023-01-25T13:59:10.868075  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-25T13:59:10.868573  + cd /lava-3210180/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
