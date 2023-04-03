Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40666D3D1F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 08:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjDCGKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 02:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDCGKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 02:10:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF59E527F
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 23:10:09 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id iw3so26971385plb.6
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 23:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680502209;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hYbJsOIcsB4m9Qf7DeOxQ6yh/HdNmLbarz8NvRrfoyE=;
        b=15GEf3jiZX44iSzEBIAulK9/PNG9IgswJNl1FZcCSyrEPXLXfz+VxKRQgxOm+AgF0Q
         Of9JuLZCjPfi8eN4QPX5OB6mepFLxYjpWAObzUE+tAE4shtRCzsdqDixcxUyym44wHJI
         uv+31mtqCBhLNQtEAYa4SkfzC+SpqU13kidCZbvb+Vjb7lM/npJ+uExgWLQ2EhNRXQsR
         AivMNKlxvaobQUVRzBxsZNc+QEkPc7ShDr6y3Ziawc4FXOUeqizi1NCvIG10+a9QAhFn
         bmNT7aEiiawv+5IQVTcNlZ8Kh7ZStLBVNA0a16382WhiJuoG3P379x0H3JwRZwf/PJYp
         iCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680502209;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYbJsOIcsB4m9Qf7DeOxQ6yh/HdNmLbarz8NvRrfoyE=;
        b=dCGfrz8vWC3Jagww/ILVLfzuhS3BxiRq0MXWdmP5alvbC3fT9Q8qwFZjbWB46JZUXi
         sqSG8RrAEVuxD/IiKYVs9Fya3jp0BsyBsyT4IprkE8LSUc1Pxr5d9UuDjZohL70yw2hW
         T6Wpgp0rNsGgF5mNiCTTZ+NAphF+k/BcMXmLS6uXNcLUKGDxnKJmvYw/dBb+xT0EWOG8
         dnN2Taz4XK+8hwYb1lbKw2X4UD0jzz3Dj2upu6g/Y6O6A1mmAJswo0VV/ONMhFuTXdZw
         d1pmJ8TJ2xsjbaz7hnK1QxoMKSfY5aPG9/gD3F/EP12P7B3PvEWoOtV2Apepmb57i6bk
         RVkQ==
X-Gm-Message-State: AAQBX9d+o8Bqtzy6N568yEg6ANAsQBp+d7UcmG/xorxS8VW0Mmz/zuZa
        4X/1k22c0XKvnwl+0jd2UVeCJBka0xhaN2m2Pjk=
X-Google-Smtp-Source: AKy350aCAhcxNV1p6gx+TMHjACwWtVK6o1fHiZSZe5ipQZkJVP0YUgbSLiwT0YIw6U8ERG7IpUg06g==
X-Received: by 2002:a17:903:1249:b0:1a2:9ce6:6483 with SMTP id u9-20020a170903124900b001a29ce66483mr13446045plh.64.1680502208839;
        Sun, 02 Apr 2023 23:10:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9-20020a1709026a8900b001a212a93295sm5722145plk.189.2023.04.02.23.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 23:10:08 -0700 (PDT)
Message-ID: <642a6dc0.170a0220.4452a.acfe@mx.google.com>
Date:   Sun, 02 Apr 2023 23:10:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-88-g3e7ef4f45523
Subject: stable-rc/queue/5.4 baseline: 118 runs,
 5 regressions (v5.4.238-88-g3e7ef4f45523)
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

stable-rc/queue/5.4 baseline: 118 runs, 5 regressions (v5.4.238-88-g3e7ef4f=
45523)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-88-g3e7ef4f45523/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-88-g3e7ef4f45523
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e7ef4f45523aa838c0155fb9d7c7a843dd40c3c =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642a3bf4a2df0ce21f62f79c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a3bf4a2df0ce21f62f7a1
        failing since 62 days (last pass: v5.4.230-81-g2ad0dc06d587, first =
fail: v5.4.230-108-g761a8268d868)

    2023-04-03T02:37:11.935746  <8>[    9.772267] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3466200_1.5.2.4.1>
    2023-04-03T02:37:12.043227  / # #
    2023-04-03T02:37:12.144766  export SHELL=3D/bin/sh
    2023-04-03T02:37:12.145635  #
    2023-04-03T02:37:12.247532  / # export SHELL=3D/bin/sh. /lava-3466200/e=
nvironment
    2023-04-03T02:37:12.248400  =

    2023-04-03T02:37:12.350468  / # . /lava-3466200/environment/lava-346620=
0/bin/lava-test-runner /lava-3466200/1
    2023-04-03T02:37:12.351935  =

    2023-04-03T02:37:12.357180  / # /lava-3466200/bin/lava-test-runner /lav=
a-3466200/1
    2023-04-03T02:37:12.440685  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642a3879317013dbf062f77b

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/642a3879317013db=
f062f784
        failing since 165 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-03T02:22:28.298539  / # =

    2023-04-03T02:22:28.299701  =

    2023-04-03T02:22:30.364822  / # #
    2023-04-03T02:22:30.365741  #
    2023-04-03T02:22:32.375576  / # export SHELL=3D/bin/sh
    2023-04-03T02:22:32.376071  export SHELL=3D/bin/sh
    2023-04-03T02:22:34.392093  / # . /lava-3466143/environment
    2023-04-03T02:22:34.392869  . /lava-3466143/environment
    2023-04-03T02:22:36.407593  / # /lava-3466143/bin/lava-test-runner /lav=
a-3466143/0
    2023-04-03T02:22:36.409854  /lava-3466143/bin/lava-test-runner /lava-34=
66143/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a3b6a0168c6c62a62f7df

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a3b6a0168c6c62a62f7e4
        failing since 5 days (last pass: v5.4.238-29-g39c31e43e3b2b, first =
fail: v5.4.238-60-gcf51829325af)

    2023-04-03T02:35:06.672082  + set +x<8>[   10.801566] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9845972_1.4.2.3.1>

    2023-04-03T02:35:06.672171  =


    2023-04-03T02:35:06.774112  #

    2023-04-03T02:35:06.875305  / # #export SHELL=3D/bin/sh

    2023-04-03T02:35:06.875543  =


    2023-04-03T02:35:06.976436  / # export SHELL=3D/bin/sh. /lava-9845972/e=
nvironment

    2023-04-03T02:35:06.976677  =


    2023-04-03T02:35:07.077616  / # . /lava-9845972/environment/lava-984597=
2/bin/lava-test-runner /lava-9845972/1

    2023-04-03T02:35:07.077987  =


    2023-04-03T02:35:07.082960  / # /lava-9845972/bin/lava-test-runner /lav=
a-9845972/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a3b70ba021e154b62f76d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a3b70ba021e154b62f772
        failing since 5 days (last pass: v5.4.238-29-g39c31e43e3b2b, first =
fail: v5.4.238-60-gcf51829325af)

    2023-04-03T02:35:11.338185  <8>[   12.939532] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9845942_1.4.2.3.1>

    2023-04-03T02:35:11.341732  + set +x

    2023-04-03T02:35:11.446437  #

    2023-04-03T02:35:11.447107  =


    2023-04-03T02:35:11.548654  / # #export SHELL=3D/bin/sh

    2023-04-03T02:35:11.549372  =


    2023-04-03T02:35:11.651262  / # export SHELL=3D/bin/sh. /lava-9845942/e=
nvironment

    2023-04-03T02:35:11.651980  =


    2023-04-03T02:35:11.753871  / # . /lava-9845942/environment/lava-984594=
2/bin/lava-test-runner /lava-9845942/1

    2023-04-03T02:35:11.754185  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642a3b9d9c44b8514f62f77e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
8-g3e7ef4f45523/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a3b9d9c44b8514f62f783
        failing since 60 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-04-03T02:35:49.488374  / # #
    2023-04-03T02:35:49.590320  export SHELL=3D/bin/sh
    2023-04-03T02:35:49.590820  #
    2023-04-03T02:35:49.692166  / # export SHELL=3D/bin/sh. /lava-3466191/e=
nvironment
    2023-04-03T02:35:49.692651  =

    2023-04-03T02:35:49.794007  / # . /lava-3466191/environment/lava-346619=
1/bin/lava-test-runner /lava-3466191/1
    2023-04-03T02:35:49.794772  =

    2023-04-03T02:35:49.799468  / # /lava-3466191/bin/lava-test-runner /lav=
a-3466191/1
    2023-04-03T02:35:49.863574  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-03T02:35:49.911398  + cd /lava-3466191/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
