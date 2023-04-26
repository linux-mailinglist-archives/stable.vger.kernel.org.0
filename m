Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783DE6EF6EF
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 16:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbjDZO5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 10:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjDZO5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 10:57:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F72D8
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 07:57:09 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-246fa478d45so6413834a91.3
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 07:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682521028; x=1685113028;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=o417ZTAFgcYcNESGnaDA5u8wrOdHPPDPwLEy7/lY7BM=;
        b=aOmUSpIrrMGQRCen/sX2qtU1OBnE2BDbs5n/O6gnrHe4z2qhth0YGYror7L7us97Bp
         fCMadrzJMxyYMagvZshLcmyoEd+MJcKdyOZRYBdCT4u8kynvsJYS+nwFm0pirWNU5zpz
         4nb/ni4uhS6dpCVY2+z9g+QsaD5iH6Baqh7ouPhUGqudFgZ9J1Do/+KXCugwdphNRVdy
         hJRXKWmM90FyB+ordNqhhDFyQWv5ZK3q4EQlOY4coIpd9kWlkTLa6IlpZJjrhco+gSfQ
         mB1QTqQA8aHfRQOVgXaZXRfx+The9hAYbCWtkKFi2kZPhGdGb24VffDCsB+p3IYsI9fh
         s1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682521028; x=1685113028;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o417ZTAFgcYcNESGnaDA5u8wrOdHPPDPwLEy7/lY7BM=;
        b=e/X5QN5lUeByKEzcqOVUXVuz5DZEgf/mYykxigefXeAzn27VJgPYBhCQbY8X+QMlnI
         zSctRytsJy0tNVGqn/R1km1z8Q6+fSftCaMrxjBc/cRijThjcRCiU8+2shSJ1Gnjjsr7
         8oKk0JT4cZkbYi1ZHJbvdge3bvQvy6cOwLoqBHhqwJ09aa0wJ3CudjUA43vDAYX7ISsd
         PW1smHHhtARh2tkvRmXIeTHmlsNT+YcyP+dK9VrrMENwJv63Dc4xW0T+D43ZR3aJ9s5V
         lUSCIgRzSj3jCeRcaeywF4HevWpmPbK+noi3MK7qDxAcu/oj/y0NJvY9o2zH+pE71tze
         uhPA==
X-Gm-Message-State: AAQBX9fA4rOlb8TmkFN/3OqzIrJS2VAJx1Kp8I3XDSdoLsbBdh2v7IuE
        GKd5QifWTsCC9sE/ZV3BRkjUDXWvlhFrCV0ocTqdNw==
X-Google-Smtp-Source: AKy350YRzyXDGJUmjcEqEZEVTBfO48w4JxI3YdapqNT2zffHs17fawAIE28hl+Xxg5TghR8uBMzJZw==
X-Received: by 2002:a17:90a:ca12:b0:24b:a860:a09 with SMTP id x18-20020a17090aca1200b0024ba8600a09mr10863867pjt.49.1682521028186;
        Wed, 26 Apr 2023 07:57:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gg6-20020a17090b0a0600b0023d386e4806sm9784122pjb.57.2023.04.26.07.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:57:07 -0700 (PDT)
Message-ID: <64493bc3.170a0220.b1208.3ad7@mx.google.com>
Date:   Wed, 26 Apr 2023 07:57:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.242
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 92 runs, 14 regressions (v5.4.242)
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

stable/linux-5.4.y baseline: 92 runs, 14 regressions (v5.4.242)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

imx6sx-sdb                   | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =

imx6ul-14x14-evk             | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =

imx7d-sdb                    | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.242/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.242
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ea7862c507eca54ea6caad9dcfc8bba5e749fbde =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64490389bfea1f5f272e8600

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-=
12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-=
12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64490389bfea1f5f272e8605
        failing since 26 days (last pass: v5.4.238, first fail: v5.4.239)

    2023-04-26T10:56:56.354189  + set +x<8>[   10.737038] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10129262_1.4.2.3.1>

    2023-04-26T10:56:56.354671  =


    2023-04-26T10:56:56.462399  #

    2023-04-26T10:56:56.463851  =


    2023-04-26T10:56:56.565902  / # #export SHELL=3D/bin/sh

    2023-04-26T10:56:56.566771  =


    2023-04-26T10:56:56.668415  / # export SHELL=3D/bin/sh. /lava-10129262/=
environment

    2023-04-26T10:56:56.669261  =


    2023-04-26T10:56:56.770594  / # . /lava-10129262/environment/lava-10129=
262/bin/lava-test-runner /lava-10129262/1

    2023-04-26T10:56:56.771026  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx6sx-sdb                   | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6449054181c257b8e12e8611

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6sx-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6449054181c257b8e12e8614
        failing since 97 days (last pass: v5.4.224, first fail: v5.4.229)

    2023-04-26T11:02:16.703759  / # #
    2023-04-26T11:02:17.862634  export SHELL=3D/bin/sh
    2023-04-26T11:02:17.868182  #
    2023-04-26T11:02:19.415021  / # export SHELL=3D/bin/sh. /lava-1208847/e=
nvironment
    2023-04-26T11:02:19.420725  =

    2023-04-26T11:02:22.243381  / # . /lava-1208847/environment/lava-120884=
7/bin/lava-test-runner /lava-1208847/1
    2023-04-26T11:02:22.249528  =

    2023-04-26T11:02:22.262296  / # /lava-1208847/bin/lava-test-runner /lav=
a-1208847/1
    2023-04-26T11:02:22.345277  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-26T11:02:22.345651  + cd /lava-1208847/1/tests/1_bootrr =

    ... (18 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx6ul-14x14-evk             | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6449053d81c257b8e12e8603

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6449053d81c257b8e12e8606
        failing since 40 days (last pass: v5.4.213, first fail: v5.4.237)

    2023-04-26T11:02:57.052798  + set +x
    2023-04-26T11:02:57.053933  <8>[   31.305114] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1208846_1.5.2.4.1>
    2023-04-26T11:02:57.163375  =

    2023-04-26T11:02:58.323125  / # #export SHELL=3D/bin/sh
    2023-04-26T11:02:58.328810  =

    2023-04-26T11:02:58.329135  / # export SHELL=3D/bin/sh
    2023-04-26T11:02:59.876773  . /lava-1208846/environment
    2023-04-26T11:02:59.882444  / # . /lava-1208846/environment
    2023-04-26T11:03:02.704739  /lava-1208846/bin/lava-test-runner /lava-12=
08846/1
    2023-04-26T11:03:02.711019  / # /lava-1208846/bin/lava-test-runner /lav=
a-1208846/1 =

    ... (18 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
imx7d-sdb                    | arm    | lab-nxp       | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6449047ee3c9a379c42e85fc

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6449047ee3c9a379c42e85ff
        failing since 97 days (last pass: v5.4.224, first fail: v5.4.229)

    2023-04-26T11:00:25.970431  / # #
    2023-04-26T11:00:27.130501  export SHELL=3D/bin/sh
    2023-04-26T11:00:27.136259  #
    2023-04-26T11:00:28.684023  / # export SHELL=3D/bin/sh. /lava-1208848/e=
nvironment
    2023-04-26T11:00:28.689747  =

    2023-04-26T11:00:31.512136  / # . /lava-1208848/environment/lava-120884=
8/bin/lava-test-runner /lava-1208848/1
    2023-04-26T11:00:31.518235  =

    2023-04-26T11:00:31.523156  / # /lava-1208848/bin/lava-test-runner /lav=
a-1208848/1
    2023-04-26T11:00:31.571133  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-26T11:00:31.625034  + cd /lava-1208848/1/tests/1_bootrr =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644913370f798723ef2e85ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644913370f798723ef2e8=
600
        failing since 210 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6449021fb3f6999ce92e85f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6449021fb3f6999ce92e8=
5f9
        failing since 210 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64491233f50f7532002e8617

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64491233f50f7532002e8=
618
        failing since 210 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6449021e7e217f918b2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6449021e7e217f918b2e8=
5e8
        failing since 210 days (last pass: v5.4.180, first fail: v5.4.215) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6449139b7c772c39232e85f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6449139b7c772c39232e8=
5f2
        failing since 257 days (last pass: v5.4.180, first fail: v5.4.210) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/6449024490c5279d632e865b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6449024490c5279d632e8=
65c
        failing since 257 days (last pass: v5.4.180, first fail: v5.4.210) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/644911cf66549471db2e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644911cf66549471db2e8=
5e7
        failing since 270 days (last pass: v5.4.180, first fail: v5.4.208) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64490223b3f6999ce92e8603

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64490223b3f6999ce92e8=
604
        failing since 270 days (last pass: v5.4.180, first fail: v5.4.208) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64490a990608b7c77e2e863e

  Results:     82 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.242/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64490a990608b7c77e2e8644
        failing since 40 days (last pass: v5.4.235, first fail: v5.4.237)

    2023-04-26T11:27:04.279955  <8>[   32.584341] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-26T11:27:05.292539  /lava-10129107/1/../bin/lava-test-case

    2023-04-26T11:27:05.301593  <8>[   33.606202] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64490a990608b7c77e2e8645
        failing since 40 days (last pass: v5.4.235, first fail: v5.4.237)

    2023-04-26T11:27:04.271088  /lava-10129107/1/../bin/lava-test-case
   =

 =20
