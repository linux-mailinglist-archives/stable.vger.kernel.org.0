Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215946972A4
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 01:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBOAY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 19:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBOAY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 19:24:26 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1B72D14D
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 16:24:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id w14-20020a17090a5e0e00b00233d3b9650eso439545pjf.4
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 16:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mLLeU7dPXet5/8AbsJEdHwpokZyPkkQw26kgAx/a4Nc=;
        b=d5HtIYVn1lDSBpK3VzVog/huI2l7/1DrFqoRHup6yoyVS9LY1tqCvK3AM2AN0bD9cn
         kjWwLfVTCFMoL0HDzFhiWn/qkJO2PZ8Kn0zbdFy8S9+3kv/oHBEyasGyBfRam5IjtlJU
         BnZ3e8cUy7/Ea9iptALFv6+QrfXw8YNAdwf3dbgV3ke+0IFuUh/07XQCGCimXocWQNjO
         z7PFlCjJ1rv+Aboj6OjES2BoClVqqKjfax2l1lmjlLv2ffMWAevzgcXQH+lxUZsdy0hM
         +16KRHf52ES+Dz0DjiiKaxy6hV1I9zT0l4NpmJs75IO/nku9O04+kkrXiPR+AI7Omspo
         764A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLLeU7dPXet5/8AbsJEdHwpokZyPkkQw26kgAx/a4Nc=;
        b=ikiSAt89HuXIdrGPGvfBlpyyvUp96SyfiVNdncrqeTfLmkRXzNMpyg1CThcz6RQqaU
         bvRmAHrWJ7pRvRfhUPZLn+eMmBdIUMHfqXRIL06SRkcAyKQrNPiUwwt/Ey6VYWmjHsRm
         9S5vgKIDk2PcJRjSeJZ/c5tq7IDW7ewllpBahUKQgohG6TTLRXROqcGx41QMtmWUzRdM
         ycKPfBucKdJzfJcD7ttKYqUnGt3KX45NQVbyveEtEnZrKB8mlqa9CVV1ekDn3gaWYawY
         KZAUDy17UfSZkY6lqyPTr0qJO2vuR7/E7/bEorY6n8xEculqhANKhWBxupBFC7gVY8Nc
         1Ubg==
X-Gm-Message-State: AO0yUKWPZjDTMdrtCe+j8D4OA3I2EElGnjlSTgB3JARlwUyyWIJf4OHO
        rfeQJ8yYHHNNwTczckiPTNq0YwstiLbOgsmd
X-Google-Smtp-Source: AK7set8VG+WFk/6qGUu1lxj+PF86QhHnH0UHOw/ie5ZD7OXxrbJiJuqOMv6qdt8BIb53r8jUQIbA/A==
X-Received: by 2002:a05:6a20:12d2:b0:b8:66d3:30aa with SMTP id v18-20020a056a2012d200b000b866d330aamr4823991pzg.50.1676420662856;
        Tue, 14 Feb 2023 16:24:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jb11-20020a170903258b00b0019a81a8bb14sm5704464plb.32.2023.02.14.16.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 16:24:22 -0800 (PST)
Message-ID: <63ec2636.170a0220.241ae.aed4@mx.google.com>
Date:   Tue, 14 Feb 2023 16:24:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-66-g19d6d9c927f3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 161 runs,
 17 regressions (v5.15.93-66-g19d6d9c927f3)
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

stable-rc/queue/5.15 baseline: 161 runs, 17 regressions (v5.15.93-66-g19d6d=
9c927f3)

Regressions Summary
-------------------

platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =

imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =

kontron-pitx-imx8m     | arm64  | lab-kontron     | gcc-10   | defconfig   =
                 | 2          =

qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =

qemu_i386-uefi         | i386   | lab-collabora   | gcc-10   | i386_defconf=
ig               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-66-g19d6d9c927f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-66-g19d6d9c927f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19d6d9c927f39f70d6612ed9cd5def1c2899e4bd =



Test Regressions
---------------- =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
beagle-xm              | arm    | lab-baylibre    | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf579abe46814548c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf579abe46814548c8=
644
        failing since 11 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
imx53-qsrb             | arm    | lab-pengutronix | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf1d0a04f21e4128c8657

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ebf1d0a04f21e4128c8660
        failing since 18 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-14T20:40:23.022030  + set +x
    2023-02-14T20:40:23.022292  [    9.400988] <LAVA_SIGNAL_ENDRUN 0_dmesg =
905964_1.5.2.3.1>
    2023-02-14T20:40:23.129112  / # #
    2023-02-14T20:40:23.230652  export SHELL=3D/bin/sh
    2023-02-14T20:40:23.231176  #
    2023-02-14T20:40:23.332548  / # export SHELL=3D/bin/sh. /lava-905964/en=
vironment
    2023-02-14T20:40:23.333036  =

    2023-02-14T20:40:23.434315  / # . /lava-905964/environment/lava-905964/=
bin/lava-test-runner /lava-905964/1
    2023-02-14T20:40:23.435049  =

    2023-02-14T20:40:23.437441  / # /lava-905964/bin/lava-test-runner /lava=
-905964/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
kontron-pitx-imx8m     | arm64  | lab-kontron     | gcc-10   | defconfig   =
                 | 2          =


  Details:     https://kernelci.org/test/plan/id/63ebf6b4dbc9c780eb8c8642

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ebf6b4dbc9c780eb8c8649
        new failure (last pass: v5.15.93-63-gd97c32e15f6e)

    2023-02-14T21:01:24.325049  / # #
    2023-02-14T21:01:24.427087  export SHELL=3D/bin/sh
    2023-02-14T21:01:24.427572  #
    2023-02-14T21:01:24.528957  / # export SHELL=3D/bin/sh. /lava-275689/en=
vironment
    2023-02-14T21:01:24.529504  =

    2023-02-14T21:01:24.631039  / # . /lava-275689/environment/lava-275689/=
bin/lava-test-runner /lava-275689/1
    2023-02-14T21:01:24.631972  =

    2023-02-14T21:01:24.636862  / # /lava-275689/bin/lava-test-runner /lava=
-275689/1
    2023-02-14T21:01:24.696759  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-14T21:01:24.697145  + cd /l<8>[   12.152727] <LAVA_SIGNAL_START=
RUN 1_bootrr 275689_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/63e=
bf6b4dbc9c780eb8c8659
        new failure (last pass: v5.15.93-63-gd97c32e15f6e)

    2023-02-14T21:01:27.014956  /lava-275689/1/../bin/lava-test-case
    2023-02-14T21:01:27.015355  <8>[   14.564516] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-baylibre    | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf30bdc36da71c88c869b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf30bdc36da71c88c8=
69c
        failing since 0 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-broonie     | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf913cdef7f1eb68c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf913cdef7f1eb68c8=
650
        failing since 0 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_i386-uefi         | i386   | lab-collabora   | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf2f80e002b0c718c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf2f80e002b0c718c8=
65e
        failing since 0 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-gf3091fc0051b) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf1df3965f4571a8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf1df3965f4571a8c8=
630
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf2d040f7b8e6098c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf2d040f7b8e6098c8=
654
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf606f0ed7e6f968c86c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf606f0ed7e6f968c8=
6c6
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf8af4a95b82c968c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf8af4a95b82c968c8=
639
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi       | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf2d25bef3495698c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf2d25bef3495698c8=
633
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf1e00431e78fe58c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf1e00431e78fe58c8=
63b
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre    | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf2cf12310607128c867d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf2cf12310607128c8=
67e
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf67e86b204caad8c867e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf67e86b204caad8c8=
67f
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie     | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf89b50d17a13f88c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf89b50d17a13f88c8=
64d
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =



platform               | arch   | lab             | compiler | defconfig   =
                 | regressions
-----------------------+--------+-----------------+----------+-------------=
-----------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora   | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebf2d012310607128c868b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
66-g19d6d9c927f3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebf2d012310607128c8=
68c
        failing since 1 day (last pass: v5.15.93-48-g91b0616b8246, first fa=
il: v5.15.93-67-g85c6595a0daa) =

 =20
