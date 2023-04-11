Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0036DE224
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 19:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDKROz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 13:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjDKROq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 13:14:46 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD6A59CA
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 10:14:44 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 21so324153plg.12
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681233284; x=1683825284;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ViTRgTVE6z2ffxTpcagT8zF98LGqAEiVzZpbKrQuWh0=;
        b=O9CglpeKYWqR0Q0nzzsG2/qWlJuOikX5aTnyKdOv/43T4QPtHPxm5BD1u007NqaYEX
         zkh4UTJe9RfjYWfiQiexg8JPHpbMuHOA3UK3gdrQA3O1Z9Q8PM53EJ+QZTJl9uFvifcQ
         8beRiDZtnX4pI+iA1fAMt8IqJTItx0IBxbiSYt2rzfJBVCkBysnbMafUAdXVmnXOc5q6
         jRDdyPGZI4UEq/Op3mpXcgT2uNXhp/nuIS6jPXJ4DLoH6gwHF3DVzubX+Wnh5WjmfFRZ
         FVZWAz1kmpPzhE0WG5QlGTN1e8hGluTCOVuPMm3LDBIRgdEgQx601oy/7061S77zOCtP
         NxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681233284; x=1683825284;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ViTRgTVE6z2ffxTpcagT8zF98LGqAEiVzZpbKrQuWh0=;
        b=3uCw5UZm2SMpBpB1hNnGx13D+R+ykpXjofM5k34dQa1SiLHwvwNx0w+O1tqKxqdX6f
         ubJWiangJKYTBYrPqTZp+wasS1fst90NAC3I6y9QUyKhgjj5bJVaGhJzXoJOs16p0hC5
         hIe56LuUIrc+5kgwaXZKOBgzM8mB01ukwRA7bVkCIYq0/ML84Vh7AQf5b2kH93BWJpJF
         G9R1XW6+sqAB0WNPl49KZkUdJy1OSdTQXZnWyK87Ffbyn2vEHINYs4NJYZ0TsYaSFozr
         T9I/K0bSZYOxrTLQDqEkdGCVY9isaPIgsnfkW+dXyrO/6F13L5Nr1Sui6O6Hn7PkfKuo
         D/8Q==
X-Gm-Message-State: AAQBX9djPA8ZgBNYamvHh33s8HtbdjZ4hQNNIbK1acugv9eba+aZ0w29
        HbZb8vkQcFRVYd5TIMFIn7Dkxx6K+R0Pu2RoCfJSCQ==
X-Google-Smtp-Source: AKy350Zg5szkgD4gBkRL4WrsnzsLRPQ/8UVh0VFsTqdBczXRXysj2o9c/msF5a+BZtdkQsMw8of0kg==
X-Received: by 2002:a17:90b:3b4a:b0:23f:618a:6bed with SMTP id ot10-20020a17090b3b4a00b0023f618a6bedmr20170909pjb.47.1681233283998;
        Tue, 11 Apr 2023 10:14:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090aca8b00b0023d28185e35sm68199pjt.32.2023.04.11.10.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:14:43 -0700 (PDT)
Message-ID: <64359583.170a0220.7856a.04b3@mx.google.com>
Date:   Tue, 11 Apr 2023 10:14:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-216-gf7cdb9db2411
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 9 regressions (v5.10.176-216-gf7cdb9db2411)
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

stable-rc/queue/5.10 baseline: 182 runs, 9 regressions (v5.10.176-216-gf7cd=
b9db2411)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-216-gf7cdb9db2411/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-216-gf7cdb9db2411
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7cdb9db2411ce9b254c7216f60ee17a3678c891 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6435615862b9abac772e85f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6435615862b9abac772e8=
5f5
        new failure (last pass: v5.10.176-193-g28e6f16b3a0b) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643560c9a2865e34ed2e8619

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643560c9a2865e34ed2e864f
        failing since 56 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-11T13:29:26.781345  <8>[   21.081383] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 310549_1.5.2.4.1>
    2023-04-11T13:29:26.891810  / # #
    2023-04-11T13:29:26.994223  export SHELL=3D/bin/sh
    2023-04-11T13:29:26.994830  #
    2023-04-11T13:29:27.096627  / # export SHELL=3D/bin/sh. /lava-310549/en=
vironment
    2023-04-11T13:29:27.097213  =

    2023-04-11T13:29:27.199240  / # . /lava-310549/environment/lava-310549/=
bin/lava-test-runner /lava-310549/1
    2023-04-11T13:29:27.200423  =

    2023-04-11T13:29:27.205111  / # /lava-310549/bin/lava-test-runner /lava=
-310549/1
    2023-04-11T13:29:27.308998  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6435600746cedbd0fe2e865a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435600746cedbd0fe2e865f
        failing since 75 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-11T13:26:24.436373  <8>[   11.042180] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3485271_1.5.2.4.1>
    2023-04-11T13:26:24.542730  / # #
    2023-04-11T13:26:24.644901  export SHELL=3D/bin/sh
    2023-04-11T13:26:24.645394  #
    2023-04-11T13:26:24.746676  / # export SHELL=3D/bin/sh. /lava-3485271/e=
nvironment
    2023-04-11T13:26:24.747111  =

    2023-04-11T13:26:24.848441  / # . /lava-3485271/environment/lava-348527=
1/bin/lava-test-runner /lava-3485271/1
    2023-04-11T13:26:24.848966  =

    2023-04-11T13:26:24.854191  / # /lava-3485271/bin/lava-test-runner /lav=
a-3485271/1
    2023-04-11T13:26:24.941029  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356069933a138d562e860c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356069933a138d562e8611
        failing since 12 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-11T13:27:50.840709  + set +x

    2023-04-11T13:27:50.847147  <8>[   10.259416] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9936930_1.4.2.3.1>

    2023-04-11T13:27:50.951725  / # #

    2023-04-11T13:27:51.052732  export SHELL=3D/bin/sh

    2023-04-11T13:27:51.052937  #

    2023-04-11T13:27:51.153846  / # export SHELL=3D/bin/sh. /lava-9936930/e=
nvironment

    2023-04-11T13:27:51.154131  =


    2023-04-11T13:27:51.255190  / # . /lava-9936930/environment/lava-993693=
0/bin/lava-test-runner /lava-9936930/1

    2023-04-11T13:27:51.255569  =


    2023-04-11T13:27:51.260433  / # /lava-9936930/bin/lava-test-runner /lav=
a-9936930/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435605005e00fc24e2e862c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435605005e00fc24e2e8631
        failing since 12 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-11T13:27:32.268105  + set +x<8>[   12.961550] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9936857_1.4.2.3.1>

    2023-04-11T13:27:32.268637  =


    2023-04-11T13:27:32.377501  / #

    2023-04-11T13:27:32.480504  # #export SHELL=3D/bin/sh

    2023-04-11T13:27:32.481235  =


    2023-04-11T13:27:32.582899  / # export SHELL=3D/bin/sh. /lava-9936857/e=
nvironment

    2023-04-11T13:27:32.583625  =


    2023-04-11T13:27:32.685521  / # . /lava-9936857/environment/lava-993685=
7/bin/lava-test-runner /lava-9936857/1

    2023-04-11T13:27:32.686701  =


    2023-04-11T13:27:32.692146  / # /lava-9936857/bin/lava-test-runner /lav=
a-9936857/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6435611df1a0c27cf12e86b0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435611df1a0c27cf12e86b5
        new failure (last pass: v5.10.176-193-g28e6f16b3a0b)

    2023-04-11T13:31:04.265913  / # #

    2023-04-11T13:31:04.367692  export SHELL=3D/bin/sh

    2023-04-11T13:31:04.368214  #

    2023-04-11T13:31:04.469583  / # export SHELL=3D/bin/sh. /lava-9936963/e=
nvironment

    2023-04-11T13:31:04.469990  =


    2023-04-11T13:31:04.571444  / # . /lava-9936963/environment/lava-993696=
3/bin/lava-test-runner /lava-9936963/1

    2023-04-11T13:31:04.572127  =


    2023-04-11T13:31:04.573706  / # /lava-9936963/bin/lava-test-runner /lav=
a-9936963/1

    2023-04-11T13:31:04.615082  + export 'TESTRUN_ID=3D1_bootrr'

    2023-04-11T13:31:04.631608  + cd /lava-9936963/1/tests/1_bootrr
 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64356040953756fcf52e8691

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64356040953756fcf52e8697
        failing since 28 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-11T13:27:23.967015  /lava-9936848/1/../bin/lava-test-case

    2023-04-11T13:27:23.977738  <8>[   35.384372] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64356040953756fcf52e8698
        failing since 28 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-11T13:27:21.907357  <8>[   33.312767] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-11T13:27:22.929890  /lava-9936848/1/../bin/lava-test-case

    2023-04-11T13:27:22.940772  <8>[   34.347133] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64355ffe5dbdd3fdef2e8653

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-216-gf7cdb9db2411/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64355ffe5dbdd3fdef2e8658
        failing since 68 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-11T13:26:00.781623  / # #
    2023-04-11T13:26:00.883305  export SHELL=3D/bin/sh
    2023-04-11T13:26:00.883663  #
    2023-04-11T13:26:00.984973  / # export SHELL=3D/bin/sh. /lava-3485268/e=
nvironment
    2023-04-11T13:26:00.985351  =

    2023-04-11T13:26:01.086683  / # . /lava-3485268/environment/lava-348526=
8/bin/lava-test-runner /lava-3485268/1
    2023-04-11T13:26:01.087304  =

    2023-04-11T13:26:01.092657  / # /lava-3485268/bin/lava-test-runner /lav=
a-3485268/1
    2023-04-11T13:26:01.156682  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-11T13:26:01.196491  + cd /lava-3485268/1/tests/1_bootrr =

    ... (9 line(s) more)  =

 =20
