Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C0A6D0D8D
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 20:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjC3SPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 14:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjC3SP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 14:15:27 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442A4EC71
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 11:14:52 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id kq3so18849435plb.13
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 11:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680200091;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ShYJiR01PshUitlgzxsOVmVKFnpDbnqhJIUWlN5bYHA=;
        b=KFaypOWghzfLnndGNxJpCLmQmFqtu8eWIzPQTKZBdY4TG+lZjnURR8hr4+SW+Ivka7
         DBUxALb+daNwaMoxgPQ/u25yxHYKqoe7hOQi9ZXuxUKSJaItzae4qaDCcWaL1qlHFFPU
         UT0NCWYyTrCtXP/sBcFWzdOGbynEjGfRWP89tRrgNB86RvUqaVo5/hRk6IT+va9vWMnO
         128OngLwPr5VfTm0ClWZHSJjd0PFW2i00J8YZtTPTPkUwQ6NZ0ZHQKzyPRxm3UMNwT56
         wZ2hsEmMfYkmPG+FMG4YdKAQRmN+7VboXY9bJwZ5pITVDXzftcRNgbJgZsMr/VQwa/1n
         9HUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680200091;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShYJiR01PshUitlgzxsOVmVKFnpDbnqhJIUWlN5bYHA=;
        b=7GlkW3Ee+axRmdAp9K34Ky53b+P0h0+ObMgt9yGgsmRaTeDlyf3z+xDE91/Ic0HLjZ
         pXc4ZTkFNJTJgWX6Tx2xbStuBFTb7B+Qwdzn9GEt8XI8hOUNRopUZWGSAFKgR+e6s8bC
         j5jXJzBWQnh9lcme/6tRqscUB/Pm9I+TqN/rj0U5o3BjIGoRUzZyg2pHv18GMawEkBWL
         VE3VJjR1J3VsJWh1bNtOmLv7UI2JZnFlCaqX/kaSSnIduUE7Ik4zXCKjBDevixyhziQ4
         Uq3OVCl57FE2YkQr4nvq1BGig3b747Qhy1Dvqexr+U/UY7csmXRfrLiPatfjjoL4XBOE
         ELDA==
X-Gm-Message-State: AO0yUKW4BG0Dc+Udw1RiqNhElUGYlUfag8mtxCFogb0gj1GvqVF0Kgns
        56kXmlyBrAIVBJks2fHFg3qBEXXwc/90aKsSj0kZOQ==
X-Google-Smtp-Source: AK7set+1b3lSlYhRudtxKSuby7x8+8y5wkiM7PPwkGCieIJTp3saEcHEwDJj7N8ZZzcv/pzougkGNA==
X-Received: by 2002:a05:6a20:b227:b0:da:53ea:5ca3 with SMTP id eh39-20020a056a20b22700b000da53ea5ca3mr21366598pzb.57.1680200091229;
        Thu, 30 Mar 2023 11:14:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020aa78047000000b005897f5436c0sm181152pfm.118.2023.03.30.11.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 11:14:50 -0700 (PDT)
Message-ID: <6425d19a.a70a0220.9c72d.0ac3@mx.google.com>
Date:   Thu, 30 Mar 2023 11:14:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22
Subject: stable-rc/linux-6.1.y baseline: 176 runs, 9 regressions (v6.1.22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 176 runs, 9 regressions (v6.1.22)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b29299e5f604550faf3eff811d6cd60b4c6cae6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f432c6a5b521762f823

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f432c6a5b521762f828
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:38.463967  + set +x

    2023-03-30T14:39:38.470108  <8>[   10.767803] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817194_1.4.2.3.1>

    2023-03-30T14:39:38.575378  / # #

    2023-03-30T14:39:38.678183  export SHELL=3D/bin/sh

    2023-03-30T14:39:38.679022  #

    2023-03-30T14:39:38.781244  / # export SHELL=3D/bin/sh. /lava-9817194/e=
nvironment

    2023-03-30T14:39:38.782051  =


    2023-03-30T14:39:38.883654  / # . /lava-9817194/environment/lava-981719=
4/bin/lava-test-runner /lava-9817194/1

    2023-03-30T14:39:38.884023  =


    2023-03-30T14:39:38.890106  / # /lava-9817194/bin/lava-test-runner /lav=
a-9817194/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f2da3332f943b62f775

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f2da3332f943b62f77a
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:24.810540  + set<8>[   11.212639] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9817168_1.4.2.3.1>

    2023-03-30T14:39:24.811134   +x

    2023-03-30T14:39:24.919645  / # #

    2023-03-30T14:39:25.022596  export SHELL=3D/bin/sh

    2023-03-30T14:39:25.023537  #

    2023-03-30T14:39:25.125524  / # export SHELL=3D/bin/sh. /lava-9817168/e=
nvironment

    2023-03-30T14:39:25.126404  =


    2023-03-30T14:39:25.228448  / # . /lava-9817168/environment/lava-981716=
8/bin/lava-test-runner /lava-9817168/1

    2023-03-30T14:39:25.229841  =


    2023-03-30T14:39:25.235012  / # /lava-9817168/bin/lava-test-runner /lav=
a-9817168/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f2b23ae00c0fc62f853

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f2b23ae00c0fc62f858
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:24.951609  <8>[   10.541701] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817128_1.4.2.3.1>

    2023-03-30T14:39:24.955209  + set +x

    2023-03-30T14:39:25.061168  #

    2023-03-30T14:39:25.164781  / # #export SHELL=3D/bin/sh

    2023-03-30T14:39:25.165754  =


    2023-03-30T14:39:25.267814  / # export SHELL=3D/bin/sh. /lava-9817128/e=
nvironment

    2023-03-30T14:39:25.268766  =


    2023-03-30T14:39:25.370836  / # . /lava-9817128/environment/lava-981712=
8/bin/lava-test-runner /lava-9817128/1

    2023-03-30T14:39:25.372210  =


    2023-03-30T14:39:25.377163  / # /lava-9817128/bin/lava-test-runner /lav=
a-9817128/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/64259a479f2d520e1462f7a2

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259a479f2d520e1462f7d3
        failing since 1 day (last pass: v6.1.21, first fail: v6.1.21-225-ge=
6bbee2ba76f)

    2023-03-30T14:18:25.593437  + set +x
    2023-03-30T14:18:25.597170  <8>[   17.652539] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 250426_1.5.2.4.1>
    2023-03-30T14:18:25.712485  / # #
    2023-03-30T14:18:25.814582  export SHELL=3D/bin/sh
    2023-03-30T14:18:25.815130  #
    2023-03-30T14:18:25.916588  / # export SHELL=3D/bin/sh. /lava-250426/en=
vironment
    2023-03-30T14:18:25.917186  =

    2023-03-30T14:18:26.018758  / # . /lava-250426/environment/lava-250426/=
bin/lava-test-runner /lava-250426/1
    2023-03-30T14:18:26.019798  =

    2023-03-30T14:18:26.025794  / # /lava-250426/bin/lava-test-runner /lava=
-250426/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f2fa3332f943b62f7aa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f2fa3332f943b62f7af
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:17.832942  + set +x

    2023-03-30T14:39:17.839281  <8>[   10.524030] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817127_1.4.2.3.1>

    2023-03-30T14:39:17.944568  / # #

    2023-03-30T14:39:18.045563  export SHELL=3D/bin/sh

    2023-03-30T14:39:18.045761  #

    2023-03-30T14:39:18.146436  / # export SHELL=3D/bin/sh. /lava-9817127/e=
nvironment

    2023-03-30T14:39:18.146639  =


    2023-03-30T14:39:18.247533  / # . /lava-9817127/environment/lava-981712=
7/bin/lava-test-runner /lava-9817127/1

    2023-03-30T14:39:18.247879  =


    2023-03-30T14:39:18.252347  / # /lava-9817127/bin/lava-test-runner /lav=
a-9817127/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f3c2c6a5b521762f7e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f3c2c6a5b521762f7ee
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:33.934677  + set +x<8>[   10.344527] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9817183_1.4.2.3.1>

    2023-03-30T14:39:33.934768  =


    2023-03-30T14:39:34.036777  #

    2023-03-30T14:39:34.138026  / # #export SHELL=3D/bin/sh

    2023-03-30T14:39:34.138233  =


    2023-03-30T14:39:34.239028  / # export SHELL=3D/bin/sh. /lava-9817183/e=
nvironment

    2023-03-30T14:39:34.239235  =


    2023-03-30T14:39:34.340189  / # . /lava-9817183/environment/lava-981718=
3/bin/lava-test-runner /lava-9817183/1

    2023-03-30T14:39:34.340477  =


    2023-03-30T14:39:34.345387  / # /lava-9817183/bin/lava-test-runner /lav=
a-9817183/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f31a3332f943b62f7cb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f31a3332f943b62f7d0
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:27.894634  + set<8>[   11.043123] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9817157_1.4.2.3.1>

    2023-03-30T14:39:27.895181   +x

    2023-03-30T14:39:28.004209  / # #

    2023-03-30T14:39:28.107015  export SHELL=3D/bin/sh

    2023-03-30T14:39:28.107829  #

    2023-03-30T14:39:28.209556  / # export SHELL=3D/bin/sh. /lava-9817157/e=
nvironment

    2023-03-30T14:39:28.210414  =


    2023-03-30T14:39:28.312562  / # . /lava-9817157/environment/lava-981715=
7/bin/lava-test-runner /lava-9817157/1

    2023-03-30T14:39:28.314059  =


    2023-03-30T14:39:28.318757  / # /lava-9817157/bin/lava-test-runner /lav=
a-9817157/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259f30a3332f943b62f7c0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259f30a3332f943b62f7c5
        new failure (last pass: v6.1.21)

    2023-03-30T14:39:28.464749  <8>[   11.597455] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817138_1.4.2.3.1>

    2023-03-30T14:39:28.573194  / # #

    2023-03-30T14:39:28.675752  export SHELL=3D/bin/sh

    2023-03-30T14:39:28.676529  #

    2023-03-30T14:39:28.778123  / # export SHELL=3D/bin/sh. /lava-9817138/e=
nvironment

    2023-03-30T14:39:28.778898  =


    2023-03-30T14:39:28.880906  / # . /lava-9817138/environment/lava-981713=
8/bin/lava-test-runner /lava-9817138/1

    2023-03-30T14:39:28.881985  =


    2023-03-30T14:39:28.886963  / # /lava-9817138/bin/lava-test-runner /lav=
a-9817138/1

    2023-03-30T14:39:28.893751  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64259e2a3ec5609d6462f76d

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22/=
mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64259e2a3ec5609=
d6462f775
        new failure (last pass: v6.1.21-225-ge6bbee2ba76f)
        1 lines

    2023-03-30T14:35:04.330481  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb827dc4, epc =3D=3D 80201f24, ra =3D=
=3D 80204874
    2023-03-30T14:35:04.330746  =


    2023-03-30T14:35:04.395122  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-30T14:35:04.395395  =

   =

 =20
