Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CAB6E7A68
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 15:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbjDSNPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 09:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjDSNPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 09:15:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F01118F7
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 06:15:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a686260adcso33586785ad.0
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 06:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681910139; x=1684502139;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wOGvueCIFeDyugeceJUrPMi5E3hLEQjUuzoAsL0yE98=;
        b=087lIJimDF4iy+FIfha8yiaCOzXtgm8hkBXju9+aIuWaulsF0UGqxZ6IgsYc5d0l0p
         TKy/teDrxyn7ULfweVFJQ31PKda+zD7JDUtGdi5exJ8Y9+onDfaAf2S/QmUGOFIIjl3g
         tOwhbCTuaekMZM8gfvsmlxYTXWkqBT2ft8PkdrLSLwqNaVTgzzybcuAnEBblVNM9IwB+
         W2K4aZrn6zxGlnFn9huYTtIPcqHyxWD+wbaBZLhBWKFaSWC3OOtGJluwEd4d6nQPs0n1
         IOmuE3FOIlQr6aocjXqNXcQZOIG6r0v2hDbZr4w2lx2g1UFEGUQWWfBv5f8I2ZqP+0+R
         vlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910139; x=1684502139;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOGvueCIFeDyugeceJUrPMi5E3hLEQjUuzoAsL0yE98=;
        b=U4KNAgxxj4tozZKSKGxPr5/buASipCaf6w8g62wLlG850ehUVe3KxnPBIdbNTevmxm
         zhHl8qKGKdqH8FPAdLIN9OeYr/kt4Y3yhx9/TPE6lUEzL6d751h82JylK5zDX8XG+uL7
         hjvzUGZ2GqwNgQydqzNsAB0cUL0JXTBBdzs9zeedkHgbQzha7X8qLpC3yx8Vs7TpgcGa
         a5p6DvLy+bYIJI36uYS7Mi7m4Q1u7dReG2S611H17fQtoTnDtXsdxtepJBpjKK7/jSRi
         M28d9yefZO/4LbV2tJyZgPO5Q7VXXqGM72Q++ztjoykwfoClb6VrkuT8WZr3PzUZuxro
         leKg==
X-Gm-Message-State: AAQBX9fs4GdqpN8gFMup6zDS8UBqKRFfGB6Ri/N/70Qrer7i+JNfjRsn
        3hHtVsWUj/dNf7orGscMs0fX1GIacPuF9qSFVsYAEMhl
X-Google-Smtp-Source: AKy350ZP/E/zFHpgtoNaLLT/Ghu3osIsbvDOwAuhOOXHwdWu56Q4770M2bNM8tScyGCm8/3avbmJEg==
X-Received: by 2002:a17:902:bb93:b0:1a1:bff4:49e9 with SMTP id m19-20020a170902bb9300b001a1bff449e9mr4896732pls.23.1681910138789;
        Wed, 19 Apr 2023 06:15:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iw18-20020a170903045200b001960706141fsm11484457plb.149.2023.04.19.06.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:15:38 -0700 (PDT)
Message-ID: <643fe97a.170a0220.efaf8.911d@mx.google.com>
Date:   Wed, 19 Apr 2023 06:15:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-479-g7149a0de08fa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 181 runs,
 10 regressions (v6.1.22-479-g7149a0de08fa)
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

stable-rc/queue/6.1 baseline: 181 runs, 10 regressions (v6.1.22-479-g7149a0=
de08fa)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-479-g7149a0de08fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-479-g7149a0de08fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7149a0de08fa5db2b39c5aaed0aff45402b49905 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb60f2c4f05c2db2e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb60f2c4f05c2db2e85fc
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:35:58.367333  + set +x

    2023-04-19T09:35:58.372896  <8>[   10.517014] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043461_1.4.2.3.1>

    2023-04-19T09:35:58.481413  / # #

    2023-04-19T09:35:58.584310  export SHELL=3D/bin/sh

    2023-04-19T09:35:58.585155  #

    2023-04-19T09:35:58.686994  / # export SHELL=3D/bin/sh. /lava-10043461/=
environment

    2023-04-19T09:35:58.687808  =


    2023-04-19T09:35:58.789780  / # . /lava-10043461/environment/lava-10043=
461/bin/lava-test-runner /lava-10043461/1

    2023-04-19T09:35:58.791063  =


    2023-04-19T09:35:58.797903  / # /lava-10043461/bin/lava-test-runner /la=
va-10043461/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb5b8a0b1a6dc962e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5b8a0b1a6dc962e85f9
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:34:34.132538  + set<8>[   11.860609] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10043472_1.4.2.3.1>

    2023-04-19T09:34:34.132660   +x

    2023-04-19T09:34:34.237562  / # #

    2023-04-19T09:34:34.338735  export SHELL=3D/bin/sh

    2023-04-19T09:34:34.338945  #

    2023-04-19T09:34:34.439948  / # export SHELL=3D/bin/sh. /lava-10043472/=
environment

    2023-04-19T09:34:34.440178  =


    2023-04-19T09:34:34.541082  / # . /lava-10043472/environment/lava-10043=
472/bin/lava-test-runner /lava-10043472/1

    2023-04-19T09:34:34.541361  =


    2023-04-19T09:34:34.546247  / # /lava-10043472/bin/lava-test-runner /la=
va-10043472/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb5b1d2e2cedcbb2e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5b1d2e2cedcbb2e860d
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:34:32.745898  <8>[    9.743867] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043412_1.4.2.3.1>

    2023-04-19T09:34:32.749376  + set +x

    2023-04-19T09:34:32.854484  =


    2023-04-19T09:34:32.955406  / # #export SHELL=3D/bin/sh

    2023-04-19T09:34:32.955592  =


    2023-04-19T09:34:33.056481  / # export SHELL=3D/bin/sh. /lava-10043412/=
environment

    2023-04-19T09:34:33.056686  =


    2023-04-19T09:34:33.157812  / # . /lava-10043412/environment/lava-10043=
412/bin/lava-test-runner /lava-10043412/1

    2023-04-19T09:34:33.158753  =


    2023-04-19T09:34:33.164037  / # /lava-10043412/bin/lava-test-runner /la=
va-10043412/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb59f4b7287f1292e85e7

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5a04b7287f1292e8619
        new failure (last pass: v6.1.22-479-gd4d11e11a24d)

    2023-04-19T09:34:00.670152  + set +x
    2023-04-19T09:34:00.673759  <8>[   18.295807] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 352976_1.5.2.4.1>
    2023-04-19T09:34:00.790085  / # #
    2023-04-19T09:34:00.892686  export SHELL=3D/bin/sh
    2023-04-19T09:34:00.893441  #
    2023-04-19T09:34:00.995286  / # export SHELL=3D/bin/sh. /lava-352976/en=
vironment
    2023-04-19T09:34:00.995906  =

    2023-04-19T09:34:01.097530  / # . /lava-352976/environment/lava-352976/=
bin/lava-test-runner /lava-352976/1
    2023-04-19T09:34:01.098494  =

    2023-04-19T09:34:01.105697  / # /lava-352976/bin/lava-test-runner /lava=
-352976/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb9846d0cee81c52e8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fb9846d0cee81c52e8=
634
        failing since 0 day (last pass: v6.1.22-479-g35f051d5ebe4, first fa=
il: v6.1.22-479-gd4d11e11a24d) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb5d6dd3a8c48792e8613

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5d6dd3a8c48792e8618
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:35:02.913999  + set +x

    2023-04-19T09:35:02.920287  <8>[   11.035869] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10043425_1.4.2.3.1>

    2023-04-19T09:35:03.025380  / # #

    2023-04-19T09:35:03.126426  export SHELL=3D/bin/sh

    2023-04-19T09:35:03.126626  #

    2023-04-19T09:35:03.227532  / # export SHELL=3D/bin/sh. /lava-10043425/=
environment

    2023-04-19T09:35:03.227739  =


    2023-04-19T09:35:03.328562  / # . /lava-10043425/environment/lava-10043=
425/bin/lava-test-runner /lava-10043425/1

    2023-04-19T09:35:03.328906  =


    2023-04-19T09:35:03.333122  / # /lava-10043425/bin/lava-test-runner /la=
va-10043425/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb5b279d2b55df52e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5b279d2b55df52e85ee
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:34:24.901744  + set +x<8>[   10.355612] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10043449_1.4.2.3.1>

    2023-04-19T09:34:24.901830  =


    2023-04-19T09:34:25.003818  #

    2023-04-19T09:34:25.104994  / # #export SHELL=3D/bin/sh

    2023-04-19T09:34:25.105152  =


    2023-04-19T09:34:25.206097  / # export SHELL=3D/bin/sh. /lava-10043449/=
environment

    2023-04-19T09:34:25.206256  =


    2023-04-19T09:34:25.307183  / # . /lava-10043449/environment/lava-10043=
449/bin/lava-test-runner /lava-10043449/1

    2023-04-19T09:34:25.307438  =


    2023-04-19T09:34:25.312641  / # /lava-10043449/bin/lava-test-runner /la=
va-10043449/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb5c379d2b55df52e865b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5c379d2b55df52e8660
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:34:36.948830  + set<8>[   11.693696] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10043471_1.4.2.3.1>

    2023-04-19T09:34:36.948921   +x

    2023-04-19T09:34:37.053616  / # #

    2023-04-19T09:34:37.154652  export SHELL=3D/bin/sh

    2023-04-19T09:34:37.154854  #

    2023-04-19T09:34:37.255753  / # export SHELL=3D/bin/sh. /lava-10043471/=
environment

    2023-04-19T09:34:37.255965  =


    2023-04-19T09:34:37.356896  / # . /lava-10043471/environment/lava-10043=
471/bin/lava-test-runner /lava-10043471/1

    2023-04-19T09:34:37.357216  =


    2023-04-19T09:34:37.362047  / # /lava-10043471/bin/lava-test-runner /la=
va-10043471/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb5b1a240eb0f2d2e8617

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fb5b1a240eb0f2d2e861c
        failing since 21 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-19T09:34:28.297299  + set<8>[   12.175521] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10043426_1.4.2.3.1>

    2023-04-19T09:34:28.297469   +x

    2023-04-19T09:34:28.402248  / # #

    2023-04-19T09:34:28.503327  export SHELL=3D/bin/sh

    2023-04-19T09:34:28.503547  #

    2023-04-19T09:34:28.604513  / # export SHELL=3D/bin/sh. /lava-10043426/=
environment

    2023-04-19T09:34:28.604753  =


    2023-04-19T09:34:28.705741  / # . /lava-10043426/environment/lava-10043=
426/bin/lava-test-runner /lava-10043426/1

    2023-04-19T09:34:28.706075  =


    2023-04-19T09:34:28.710875  / # /lava-10043426/bin/lava-test-runner /la=
va-10043426/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643fb8ab8303ec0c352e862a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-g7149a0de08fa/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fb8ab8303ec0c352e8=
62b
        failing since 1 day (last pass: v6.1.22-462-g16a9aa862d1a, first fa=
il: v6.1.22-479-g35f051d5ebe4) =

 =20
