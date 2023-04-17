Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6766E46E6
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 13:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDQL4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 07:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjDQL4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 07:56:09 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0478A76
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 04:55:05 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso13950623pjc.1
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 04:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681732477; x=1684324477;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mMYEP0HDAkOA/1CDiUv45JeKYIWHYB+5YS9ZRVjXQFM=;
        b=AMVRt3TWj3Dc+isUeFx56Aaj4uSSqDIVOnfcDzfXLAahJqtuQuObraNlOnozR0US2u
         RoI9CoR4s1nABrLGx2BBchIxLFSoF+C1EQql+fKcZq3HtbBxrIWx34uiyM8RIWmdksbi
         Pv0bDrB4/tmobkmggOcoBnRizPBsexIKoynyH885m64P+darspMqLILe6K+BSNJ3Sb83
         7moIzFLs7tuctw3l8yJQX8w8aDmW1tDzK+39RZyAvTPhRcqczILtTcbVET6vk0YbtMso
         P9aQWiL1eabPRub6/7aqei/BV22gqYYOq3eBhn7MCI03WvO5RMabSKt/ZGVK9bpx5cIj
         1Bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681732477; x=1684324477;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMYEP0HDAkOA/1CDiUv45JeKYIWHYB+5YS9ZRVjXQFM=;
        b=BYsmpslRGo2DGfRC/XYP98DiREZi8pjoKu9tB6TwWPHsqWw8mgty+VoTJjKaHg8lZQ
         ZPtjEQzfiSYJwOWVWKVscO20RNZT1bsur2SJ25yEiqmDOgxYwUOOKujy6IbnJiTGmSte
         RP7oTZhoS69y+Q/zBltu+fndwOXpgU10Yi7N831IE1z7Itym0ONT3yVCdfnsG4o9iTdH
         fL6FpvWg/xyIsvwv00EWMFSE83CfoJ8yJCk6vbFNrCeYNGH6lvEEjFbJBD9gk7+fsZLR
         fKlEr7sjrANDWTA9TD6cTG3s5yMh4lTVohA/mXLxCWYIhPadKoQZRKdV40TihJa9qhH/
         oRdg==
X-Gm-Message-State: AAQBX9cFwdJhYGF831HApTgplZxA3/bR+bkl3ZflzSBYqTuzkVDhJncw
        03Yck8sSVxAb6wwZZyLzOipjuhlhucJMu9iYw/fP6hGS
X-Google-Smtp-Source: AKy350bj6RaeWNpnvje/Nz8e2YV8gJUbdCq1uOfTdGilLqLmT3qqaGVEEXgmqTznCfQWW28Q0dFlTQ==
X-Received: by 2002:a05:6a20:12c6:b0:f0:154c:5104 with SMTP id v6-20020a056a2012c600b000f0154c5104mr1736485pzg.18.1681732477092;
        Mon, 17 Apr 2023 04:54:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22-20020aa784d6000000b00638965d4248sm7388209pfn.184.2023.04.17.04.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 04:54:36 -0700 (PDT)
Message-ID: <643d337c.a70a0220.92a3d.f4bc@mx.google.com>
Date:   Mon, 17 Apr 2023 04:54:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-454-g7711a076dd12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 183 runs,
 18 regressions (v6.1.22-454-g7711a076dd12)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 183 runs, 18 regressions (v6.1.22-454-g7711a0=
76dd12)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =

qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-454-g7711a076dd12/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-454-g7711a076dd12
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7711a076dd12c5df3d74bd9361ab62b7d87c8569 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe5edcbc1206642e8622

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe5edcbc1206642e8627
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:41.480736  + set +x

    2023-04-17T08:07:41.487336  <8>[   10.095856] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016207_1.4.2.3.1>

    2023-04-17T08:07:41.595915  / # #

    2023-04-17T08:07:41.698749  export SHELL=3D/bin/sh

    2023-04-17T08:07:41.699541  #

    2023-04-17T08:07:41.801621  / # export SHELL=3D/bin/sh. /lava-10016207/=
environment

    2023-04-17T08:07:41.802421  =


    2023-04-17T08:07:41.904502  / # . /lava-10016207/environment/lava-10016=
207/bin/lava-test-runner /lava-10016207/1

    2023-04-17T08:07:41.905760  =


    2023-04-17T08:07:41.910474  / # /lava-10016207/bin/lava-test-runner /la=
va-10016207/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe4d267163874c2e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe4d267163874c2e8615
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:23.098130  + set<8>[   11.375636] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10016162_1.4.2.3.1>

    2023-04-17T08:07:23.098214   +x

    2023-04-17T08:07:23.202691  / # #

    2023-04-17T08:07:23.303827  export SHELL=3D/bin/sh

    2023-04-17T08:07:23.304032  #

    2023-04-17T08:07:23.405129  / # export SHELL=3D/bin/sh. /lava-10016162/=
environment

    2023-04-17T08:07:23.405278  =


    2023-04-17T08:07:23.506268  / # . /lava-10016162/environment/lava-10016=
162/bin/lava-test-runner /lava-10016162/1

    2023-04-17T08:07:23.506549  =


    2023-04-17T08:07:23.511351  / # /lava-10016162/bin/lava-test-runner /la=
va-10016162/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe4f267163874c2e8627

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe4f267163874c2e862c
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:20.253428  <8>[   10.285767] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016209_1.4.2.3.1>

    2023-04-17T08:07:20.256505  + set +x

    2023-04-17T08:07:20.358399  #

    2023-04-17T08:07:20.358755  =


    2023-04-17T08:07:20.459777  / # #export SHELL=3D/bin/sh

    2023-04-17T08:07:20.459983  =


    2023-04-17T08:07:20.560934  / # export SHELL=3D/bin/sh. /lava-10016209/=
environment

    2023-04-17T08:07:20.561149  =


    2023-04-17T08:07:20.662125  / # . /lava-10016209/environment/lava-10016=
209/bin/lava-test-runner /lava-10016209/1

    2023-04-17T08:07:20.662425  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd83a4de66965d2e8603

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfd83a4de66965d2e8632
        new failure (last pass: v6.1.22-446-gccec7b96e5e7)

    2023-04-17T08:03:55.975736  + set +x
    2023-04-17T08:03:55.979549  <8>[   18.221465] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 341074_1.5.2.4.1>
    2023-04-17T08:03:56.095304  / # #
    2023-04-17T08:03:56.198402  export SHELL=3D/bin/sh
    2023-04-17T08:03:56.199132  #
    2023-04-17T08:03:56.301578  / # export SHELL=3D/bin/sh. /lava-341074/en=
vironment
    2023-04-17T08:03:56.302312  =

    2023-04-17T08:03:56.404640  / # . /lava-341074/environment/lava-341074/=
bin/lava-test-runner /lava-341074/1
    2023-04-17T08:03:56.405794  =

    2023-04-17T08:03:56.413051  / # /lava-341074/bin/lava-test-runner /lava=
-341074/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd92f42527c7d02e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cfd92f42527c7d02e8=
5f3
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe39c7dc3b41e32e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe39c7dc3b41e32e85fc
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:13.782339  + set +x

    2023-04-17T08:07:13.788661  <8>[   10.749723] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016140_1.4.2.3.1>

    2023-04-17T08:07:13.893654  / # #

    2023-04-17T08:07:13.994656  export SHELL=3D/bin/sh

    2023-04-17T08:07:13.994860  #

    2023-04-17T08:07:14.095762  / # export SHELL=3D/bin/sh. /lava-10016140/=
environment

    2023-04-17T08:07:14.095953  =


    2023-04-17T08:07:14.196904  / # . /lava-10016140/environment/lava-10016=
140/bin/lava-test-runner /lava-10016140/1

    2023-04-17T08:07:14.197185  =


    2023-04-17T08:07:14.201771  / # /lava-10016140/bin/lava-test-runner /la=
va-10016140/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe3d5a0cfc853f2e8633

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe3e5a0cfc853f2e8638
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:13.867889  <8>[   10.578246] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10016147_1.4.2.3.1>

    2023-04-17T08:07:13.871070  + set +x

    2023-04-17T08:07:13.976582  #

    2023-04-17T08:07:13.977731  =


    2023-04-17T08:07:14.079888  / # #export SHELL=3D/bin/sh

    2023-04-17T08:07:14.080661  =


    2023-04-17T08:07:14.182350  / # export SHELL=3D/bin/sh. /lava-10016147/=
environment

    2023-04-17T08:07:14.183106  =


    2023-04-17T08:07:14.284986  / # . /lava-10016147/environment/lava-10016=
147/bin/lava-test-runner /lava-10016147/1

    2023-04-17T08:07:14.286143  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe4f05ed4ee2e42e8617

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe4f05ed4ee2e42e861c
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:22.383794  + set<8>[   11.235693] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10016208_1.4.2.3.1>

    2023-04-17T08:07:22.384223   +x

    2023-04-17T08:07:22.492478  / # #

    2023-04-17T08:07:22.595096  export SHELL=3D/bin/sh

    2023-04-17T08:07:22.595782  #

    2023-04-17T08:07:22.697562  / # export SHELL=3D/bin/sh. /lava-10016208/=
environment

    2023-04-17T08:07:22.698221  =


    2023-04-17T08:07:22.799983  / # . /lava-10016208/environment/lava-10016=
208/bin/lava-test-runner /lava-10016208/1

    2023-04-17T08:07:22.801025  =


    2023-04-17T08:07:22.805445  / # /lava-10016208/bin/lava-test-runner /la=
va-10016208/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =


  Details:     https://kernelci.org/test/plan/id/643d00eeafee2a7aec2e85fa

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d00eeafee2a7aec2e85fd
        new failure (last pass: v6.1.22-446-gccec7b96e5e7)

    2023-04-17T08:18:46.291617  / # #
    2023-04-17T08:18:46.394537  export SHELL=3D/bin/sh
    2023-04-17T08:18:46.395352  #
    2023-04-17T08:18:46.497357  / # export SHELL=3D/bin/sh. /lava-320373/en=
vironment
    2023-04-17T08:18:46.498178  =

    2023-04-17T08:18:46.600067  / # . /lava-320373/environment/lava-320373/=
bin/lava-test-runner /lava-320373/1
    2023-04-17T08:18:46.601423  =

    2023-04-17T08:18:46.617308  / # /lava-320373/bin/lava-test-runner /lava=
-320373/1
    2023-04-17T08:18:46.672125  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-17T08:18:46.672628  + cd /l<8>[   14.459765] <LAVA_SIGNAL_START=
RUN 1_bootrr 320373_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/643=
d00eeafee2a7aec2e860d
        new failure (last pass: v6.1.22-446-gccec7b96e5e7)

    2023-04-17T08:18:49.023099  /lava-320373/1/../bin/lava-test-case
    2023-04-17T08:18:49.023588  <8>[   16.906661] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-04-17T08:18:49.024001  /lava-320373/1/../bin/lava-test-case   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfe3ac7dc3b41e32e8604

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cfe3ac7dc3b41e32e8609
        failing since 19 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-17T08:07:09.671728  + set +x<8>[   12.201480] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10016151_1.4.2.3.1>

    2023-04-17T08:07:09.672071  =


    2023-04-17T08:07:09.779035  / # #

    2023-04-17T08:07:09.881995  export SHELL=3D/bin/sh

    2023-04-17T08:07:09.882776  #

    2023-04-17T08:07:09.984647  / # export SHELL=3D/bin/sh. /lava-10016151/=
environment

    2023-04-17T08:07:09.984869  =


    2023-04-17T08:07:10.085972  / # . /lava-10016151/environment/lava-10016=
151/bin/lava-test-runner /lava-10016151/1

    2023-04-17T08:07:10.086283  =


    2023-04-17T08:07:10.091165  / # /lava-10016151/bin/lava-test-runner /la=
va-10016151/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd72a4de66965d2e85eb

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/643cfd72a4de669=
65d2e85f3
        failing since 0 day (last pass: v6.1.22-438-gda4a613e2013, first fa=
il: v6.1.22-446-gccec7b96e5e7)
        1 lines

    2023-04-17T08:03:39.257485  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00000000, epc =3D=3D 00000000, ra =3D=
=3D 8023f81c
    2023-04-17T08:03:39.257705  =


    2023-04-17T08:03:39.298677  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-17T08:03:39.298890  =

   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd770e4a4b803e2e85e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv64.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv64.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cfd770e4a4b803e2e8=
5ea
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cff6809a7b467922e860e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cff6809a7b467922e8=
60f
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd35a5cd23b2d62e861a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv64.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv64.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cfd35a5cd23b2d62e8=
61b
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd75c62cd0da1d2e8606

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_risc=
v64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_risc=
v64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cfd75c62cd0da1d2e8=
607
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cff4088361988312e85ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cff4088361988312e8=
5eb
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643cfd36b72be3e45b2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_ris=
cv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-45=
4-g7711a076dd12/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_ris=
cv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643cfd36b72be3e45b2e8=
5e8
        new failure (last pass: v6.1.22-446-gccec7b96e5e7) =

 =20
