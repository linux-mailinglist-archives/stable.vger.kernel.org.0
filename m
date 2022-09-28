Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D555EDE10
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiI1Nqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 09:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiI1Nqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 09:46:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F0F9DB66
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 06:46:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b23so12554945pfp.9
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 06:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=R8Xa05dVJETQI1KIZNIi1u/6aHftz/Hie8q1swsTyBU=;
        b=kDcqlXFWakBDnw6BxDmGBH36Fw/w9zWtn+bw2nDNEOGtHttLVidPXJ+AJHUW2t/Br+
         QPhmK2wRvusnFbRTd2XxdqLi7kulDwMRyKyaBmhwccIRxZ4KYD11Qa7XqFN66AdME1ot
         w/EA8k82DHxsyd5UoEiBe8XJVVyOwe+gpPPmDy1p47RaAN4NJxKN7F7BB7LpBlBRHQPf
         ZmPegBpjmBk2lkCCfxZxl8KydVqETQoIuz0LL+VObZXZgM2cWYG8oAaBiVvMp3qtecU7
         CfFkocUZVv9nCDAEOhkuVbEKrshIuQ09P0ic6z7SZzbg48OA1xf09itMZjcdwUWwk9qJ
         NqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=R8Xa05dVJETQI1KIZNIi1u/6aHftz/Hie8q1swsTyBU=;
        b=2SCMByI/5uP8H/1SIOyMBQ9dHviZ9TbbGipT+BrXEal+F/8DHavzUIQjrc+hDlJuUQ
         R6jqZ03xTybx4x7YWJAlx4e+MyGGYoO+9QaHzDiBHVvJ6CuFDQ+lKJYUkLp7OpJQodQO
         E+BFBbp6nwxSyDCxPfmAoFOvGHfpUrWDB4T28MogMEj6sVkiLZQc6HdocLsyFjMrVqwZ
         +F3soGGB78Bk0HC8Xx1NPIN15mt6IvAxDGqFJERQhb/+1NnHsuKjMLSmxGuwfFGBS21x
         w43jNzXvMMtSQEIvQy5h9xxHuU9MNQ1rbzkQ6ak+zqA/bTU2wwA45jyXgVBXCq3E0xSK
         zmsQ==
X-Gm-Message-State: ACrzQf1q7SIuOJeeDA/HQsmsxueUbME1l6UBvw8Pz1/jQBHsBB5qdkPR
        d41SivF1k2uWwkDPP9eqAPqUvEHWfnHq/61d
X-Google-Smtp-Source: AMsMyM6pJGyijIZ553wWHU7Dcn9OwRhNTZFXi3iRfRc/2VHiX/bcfZz+rPkZcrGQS1CLhu/r8z407Q==
X-Received: by 2002:a63:d915:0:b0:43a:20d5:9112 with SMTP id r21-20020a63d915000000b0043a20d59112mr28419216pgg.460.1664372789930;
        Wed, 28 Sep 2022 06:46:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e21-20020aa79815000000b0053db6f7d2f1sm4029979pfl.181.2022.09.28.06.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 06:46:29 -0700 (PDT)
Message-ID: <63345035.a70a0220.b5d1a.73d4@mx.google.com>
Date:   Wed, 28 Sep 2022 06:46:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.215
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 94 runs, 11 regressions (v5.4.215)
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

stable/linux-5.4.y baseline: 94 runs, 11 regressions (v5.4.215)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.215/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.215
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6215647d9699cb8f1bf7333ec849242c4a9cf9a6 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =


  Details:     https://kernelci.org/test/plan/id/63341e173fba86f1aaec4ea6

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ri=
scv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63341e183fba86f1=
aaec4eab
        new failure (last pass: v5.4.213)
        3 lines

    2022-09-28T10:12:07.472993  / # =

    2022-09-28T10:12:07.479166  =

    2022-09-28T10:12:07.585778  / # #
    2022-09-28T10:12:07.590962  #
    2022-09-28T10:12:07.693591  / #export SHELL=3D/bin/sh
    2022-09-28T10:12:07.703167   export SHELL=3D/bin/sh
    2022-09-28T10:12:07.805786  / # . /lava-2566998/environment
    2022-09-28T10:12:07.815339  . /lava-2566998/environment
    2022-09-28T10:12:07.917744  / # /lava-2566998/bin/lava-test-runner /lav=
a-2566998/0
    2022-09-28T10:12:07.927347  /lava-2566998/bin/lava-test-runner /lava-25=
66998/0 =

    ... (11 line(s) more)  =


  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
63341e183fba86f1aaec4eae
        new failure (last pass: v5.4.213)

    2022-09-28T10:12:08.521923  + sh helpers/bootrr-auto
    2022-09-28T10:12:08.535076  /lava-2566998/1/../bin/lava-test-case
    2022-09-28T10:12:09.526646  /lava-2566998/1/../bin/lava-test-case
    2022-09-28T10:12:09.539564  <8>[   11.839990] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633426b01f4686eb88ec4ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633426b01f4686eb88ec4=
ebc
        new failure (last pass: v5.4.180) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63342461b454f9a145ec4ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342461b454f9a145ec4=
ecf
        new failure (last pass: v5.4.180) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633426ee074a04ba98ec4ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633426ee074a04ba98ec4=
ed6
        new failure (last pass: v5.4.180) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63342520a7768abb1bec4f00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342520a7768abb1bec4=
f01
        new failure (last pass: v5.4.180) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633426d8d37278b15aec4ef4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633426d8d37278b15aec4=
ef5
        failing since 47 days (last pass: v5.4.180, first fail: v5.4.210) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63342462b454f9a145ec4ed1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342462b454f9a145ec4=
ed2
        failing since 47 days (last pass: v5.4.180, first fail: v5.4.210) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633426ec63aa6c8a01ec4ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-virt-=
gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633426ec63aa6c8a01ec4=
ec6
        failing since 60 days (last pass: v5.4.180, first fail: v5.4.208) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633424751d39fd4c7dec4eb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633424751d39fd4c7dec4=
eb4
        failing since 60 days (last pass: v5.4.180, first fail: v5.4.208) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633422b3dd4b1d89b7ec4f16

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.215/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/633422b3dd4b1d89b7ec4f3c
        failing since 203 days (last pass: v5.4.181, first fail: v5.4.183)

    2022-09-28T10:32:15.572978  /lava-7436287/1/../bin/lava-test-case
    2022-09-28T10:32:15.581316  <8>[   32.631929] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
