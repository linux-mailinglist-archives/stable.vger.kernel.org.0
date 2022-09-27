Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6955ECBED
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 20:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiI0SLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 14:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiI0SLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 14:11:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678E0E11E8
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 11:11:17 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 3so10128768pga.1
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 11:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=dK2N0iuzWt3S8KM9Usw+YtKPlLFtIyowzAIz33G1FNo=;
        b=DsJ+7YH5fmOxbZKC8BCEh0lGKvXYh4Uu9t1LWl0rimToyJ/KuQgTrGEw795+2B2TC9
         b5MTWZHzdGeuK6gCdAUzNpLM0oEBM8is3ya5NWShA9mlI+fu2UmG2BW813eJLTTelQPK
         YmydPfmNTw7uWEuIkeXAAROC7NUfQ87IgOkSjin6EFmTLArrMnSPbyazsw+8H8VFd1Gu
         nL1j2ag0d5Upe+beq2FO8zeF2reCiemOidEbIm3UdnfOPSjgL0O0rWztO5iyYQiLvLHF
         3uNJtDMDnioTXPr0aO8ZICi0dVKEdBzmtX7GymuaLD1YCmKZcaeagk1O5BikHgzuA5je
         cBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=dK2N0iuzWt3S8KM9Usw+YtKPlLFtIyowzAIz33G1FNo=;
        b=Mh2Jd2JSO5wPMar7J+1uVzvfOyAFTLz8hlb8i5MnH+pndNvLpfkSCIlgSJnsDQtvic
         2i3i+098s+c0/93AuXq85HfjbrgZ/qnoa7TK7CnaQJFQ9ZFhnY9Pu01ov393ikUBsPR1
         TG0Vow2es3G9qYk/E4xcd4ok93BfVr/qT5l6E2WKGFnco7RwBPeeX1zmOK7ktLpk8PkN
         iZpvcHEipVH1fZagZjEB2B2A7PZFp5duat/n3er7P832O1x49Otftr5/z2SyzasYZvXP
         42ZvLRFA/dnJnKdBlI5BFTmzNFuymdyni6YztC+HmQUWRPqTkX0XqnDcnANtcGo70ho3
         pNow==
X-Gm-Message-State: ACrzQf1yybkR8u7CiU9dgam141oDcqtY446T6U11/QhB9WaKH1/u5S4W
        CVyjh5z8Mh1+Xt0GE90fxx8h7M6CqavA76/J
X-Google-Smtp-Source: AMsMyM7wtxFN8Yy9O6nCjIAFGBEGmkNv0SybOl68WB0+SNrkEOovmgioEHPYur3TgiUWUjMgQxoYNg==
X-Received: by 2002:aa7:946f:0:b0:541:fcf0:31d7 with SMTP id t15-20020aa7946f000000b00541fcf031d7mr29701220pfq.35.1664302276565;
        Tue, 27 Sep 2022 11:11:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1-20020a630d41000000b0043c9da02729sm1858774pgn.6.2022.09.27.11.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:11:16 -0700 (PDT)
Message-ID: <63333cc4.630a0220.93cbe.3389@mx.google.com>
Date:   Tue, 27 Sep 2022 11:11:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.214-115-g16b4c9cfc300c
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 117 runs,
 10 regressions (v5.4.214-115-g16b4c9cfc300c)
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

stable-rc/queue/5.4 baseline: 117 runs, 10 regressions (v5.4.214-115-g16b4c=
9cfc300c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.214-115-g16b4c9cfc300c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.214-115-g16b4c9cfc300c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16b4c9cfc300c7461acb39cf503e1214fcbbe559 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig  =
                | 2          =


  Details:     https://kernelci.org/test/plan/id/6333083db0a03163acec4ea8

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6333083db0a03163=
acec4ead
        failing since 0 day (last pass: v5.4.214-101-gc4608cf9cd17, first f=
ail: v5.4.214-120-g752560fee8d8)
        3 lines

    2022-09-27T14:26:41.503127  / # =

    2022-09-27T14:26:41.509675  =

    2022-09-27T14:26:41.614461  / # #
    2022-09-27T14:26:41.623892  #
    2022-09-27T14:26:41.725495  / # export SHELL=3D/bin/sh
    2022-09-27T14:26:41.733470  export SHELL=3D/bin/sh
    2022-09-27T14:26:41.834780  / # . /lava-2559556/environment
    2022-09-27T14:26:41.845506  . /lava-2559556/environment
    2022-09-27T14:26:41.947111  / # /lava-2559556/bin/lava-test-runner /lav=
a-2559556/0
    2022-09-27T14:26:41.957831  /lava-2559556/bin/lava-test-runner /lava-25=
59556/0 =

    ... (10 line(s) more)  =


  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
6333083db0a03163acec4eb0
        failing since 0 day (last pass: v5.4.214-101-gc4608cf9cd17, first f=
ail: v5.4.214-120-g752560fee8d8)

    2022-09-27T14:26:42.549592  + sh helpers/bootrr-auto
    2022-09-27T14:26:42.549809  /lava-2559556/1/../bin/lava-test-case
    2022-09-27T14:26:43.554513  /lava-2559556/1/../bin/lava-test-case
    2022-09-27T14:26:43.570347  <8>[   11.802552] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2022-09-27T14:26:43.570641  /lava-2559556/1/../bin/lava-test-case   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633329409ca9152e75ec4ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633329409ca9152e75ec4=
ec7
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6333105f9ea953ab48ec4ee2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6333105f9ea953ab48ec4=
ee3
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633328f024118d16b5ec4ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633328f024118d16b5ec4=
ebd
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63330f6f756bde0942ec4ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63330f6f756bde0942ec4=
ee1
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63332904708b93ffa3ec4ef9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63332904708b93ffa3ec4=
efa
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63330f8d83412a6b8fec4ea9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63330f8d83412a6b8fec4=
eaa
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6333292c9ca9152e75ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6333292c9ca9152e75ec4=
ea7
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63330f8e83412a6b8fec4eb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-1=
15-g16b4c9cfc300c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63330f8e83412a6b8fec4=
eb8
        failing since 63 days (last pass: v5.4.180-77-g7de29e82b9db, first =
fail: v5.4.207-73-ga2480f1b1dda1) =

 =20
