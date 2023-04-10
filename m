Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394E56DC83D
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDJPLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjDJPLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:11:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE6A4EF2
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 08:11:48 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id p8so4953400plk.9
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 08:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681139507; x=1683731507;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JU2izFJ1yJYqBU4ABkrevHMC9toOYj0BVzSCVe7FEhU=;
        b=GYdgUGOOc0ASt1ib4JfRJ3XzxGgSPSKOmoiMiTA97LMwy2sfS0CAIqA8vMPhPsBjhe
         Rg7hMfw/qzxB8r8YICDDMM0ziwJm7PpO0ZhXYS4Cu9imTXd26/Tbb5iX2Op/MOFv8hIu
         j5KOgYyW33fWYyT4FvdIWr7JrWQi3zNHYlxHFoeUKg8qgeJDUNrHDQ/cS5lWnB/10D0f
         N63NBJUh0Rud75FfX6u+/x2GrIoXZcqHjnDcLS9UCvz+b8+H9Z/LLj/wn/SOPQE2wyJE
         sOHlUaYOFwzHQTCU2RRyATiD4flJa+pQV7sU+AhBiJxgX9zrM8kSFlGDH3B4MROhVAZs
         DO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681139507; x=1683731507;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JU2izFJ1yJYqBU4ABkrevHMC9toOYj0BVzSCVe7FEhU=;
        b=Lrn/n9j4Dy2lHWXxbJpbrGw5fSYEgFTdioq3Ws3VG4ye0b6P9pFihdJmud2J3HPDNi
         NMrp0Ieqfud2UlhoQ2fuzr/0ojnKLTGBdhUaWnz1bgPM/9l3fabvyZOFLAT82uOD+20m
         U2z7UARi7qGxLGi/ogo3wKIJ47jAyGHzJ8z9m0wLLf6qqkPskXvy9utnmWrOhwS6tv0V
         hvRG4vlUz+jagka7ZjY3QkolNB+Kf7R06rLPBWG+6fdFuJDr64EWJVbKSxnVxgvsopCx
         oX1wYdbizasByUYNq5tE5twQllh/YJFbQjpBL7f6wqNYsJznWCARYuK/QO/Cd9e3DYmD
         0H7w==
X-Gm-Message-State: AAQBX9dugXFWeV0AjX2wq6HtpnUEBcYVPyYShvMXu6CqI8N8e1bIz3GK
        ZbhQmNQaw8nXpriuPGRYCaWmoNoaKZF+zUEZx7oAEA==
X-Google-Smtp-Source: AKy350bPyMhddETwJBOosPnG59pN6WREoqsqws7mNGKoqBRGfAP/k9+RBFXPoltVZGDCR6y/F3An4A==
X-Received: by 2002:a17:903:288e:b0:19e:e39b:6d98 with SMTP id ku14-20020a170903288e00b0019ee39b6d98mr11525815plb.35.1681139507173;
        Mon, 10 Apr 2023 08:11:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3-20020a635943000000b0050b026c444fsm6735329pgm.62.2023.04.10.08.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 08:11:46 -0700 (PDT)
Message-ID: <64342732.630a0220.94e94.bef2@mx.google.com>
Date:   Mon, 10 Apr 2023 08:11:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-154-g8cb40b7e3c0e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 110 runs,
 9 regressions (v5.15.105-154-g8cb40b7e3c0e)
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

stable-rc/queue/5.15 baseline: 110 runs, 9 regressions (v5.15.105-154-g8cb4=
0b7e3c0e)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-154-g8cb40b7e3c0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-154-g8cb40b7e3c0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8cb40b7e3c0e6ad64c9037013796ae2f0e35ed61 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f2145e1b28705979e92b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f2145e1b28705979e934
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:48.826294  <8>[    8.165353] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925815_1.4.2.3.1>

    2023-04-10T11:24:48.829749  + set +x

    2023-04-10T11:24:48.931408  #

    2023-04-10T11:24:48.931653  =


    2023-04-10T11:24:49.032646  / # #export SHELL=3D/bin/sh

    2023-04-10T11:24:49.032824  =


    2023-04-10T11:24:49.133582  / # export SHELL=3D/bin/sh. /lava-9925815/e=
nvironment

    2023-04-10T11:24:49.133755  =


    2023-04-10T11:24:49.234662  / # . /lava-9925815/environment/lava-992581=
5/bin/lava-test-runner /lava-9925815/1

    2023-04-10T11:24:49.234951  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f214f935035b8b79e931

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f214f935035b8b79e93a
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:43.593998  + set +x<8>[   11.558320] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9925881_1.4.2.3.1>

    2023-04-10T11:24:43.594092  =


    2023-04-10T11:24:43.698800  / # #

    2023-04-10T11:24:43.799811  export SHELL=3D/bin/sh

    2023-04-10T11:24:43.800010  #

    2023-04-10T11:24:43.900960  / # export SHELL=3D/bin/sh. /lava-9925881/e=
nvironment

    2023-04-10T11:24:43.901159  =


    2023-04-10T11:24:44.002182  / # . /lava-9925881/environment/lava-992588=
1/bin/lava-test-runner /lava-9925881/1

    2023-04-10T11:24:44.003340  =


    2023-04-10T11:24:44.007668  / # /lava-9925881/bin/lava-test-runner /lav=
a-9925881/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f2114a9cafaad679e94f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f2114a9cafaad679e958
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:44.618548  <8>[   10.595444] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925823_1.4.2.3.1>

    2023-04-10T11:24:44.621801  + set +x

    2023-04-10T11:24:44.727145  #

    2023-04-10T11:24:44.728282  =


    2023-04-10T11:24:44.830585  / # #export SHELL=3D/bin/sh

    2023-04-10T11:24:44.831292  =


    2023-04-10T11:24:44.933135  / # export SHELL=3D/bin/sh. /lava-9925823/e=
nvironment

    2023-04-10T11:24:44.934003  =


    2023-04-10T11:24:45.035751  / # . /lava-9925823/environment/lava-992582=
3/bin/lava-test-runner /lava-9925823/1

    2023-04-10T11:24:45.036073  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f253100bca721e79e92a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6433f253100bca721e79e=
92b
        failing since 66 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6433efff8ef46a04c179e924

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433efff8ef46a04c179e92d
        failing since 83 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-10T11:15:59.300507  <8>[   10.047935] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3482623_1.5.2.4.1>
    2023-04-10T11:15:59.410617  / # #
    2023-04-10T11:15:59.514379  export SHELL=3D/bin/sh
    2023-04-10T11:15:59.515514  #
    2023-04-10T11:15:59.617818  / # export SHELL=3D/bin/sh. /lava-3482623/e=
nvironment
    2023-04-10T11:15:59.618908  =

    2023-04-10T11:15:59.721382  / # . /lava-3482623/environment/lava-348262=
3/bin/lava-test-runner /lava-3482623/1
    2023-04-10T11:15:59.723200  =

    2023-04-10T11:15:59.723653  / # /<3>[   10.433231] Bluetooth: hci0: com=
mand 0x0c03 tx timeout
    2023-04-10T11:15:59.728162  lava-3482623/bin/lava-test-runner /lava-348=
2623/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f20c4a9cafaad679e930

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f20c4a9cafaad679e939
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:48.607791  + set +x

    2023-04-10T11:24:48.614953  <8>[   10.142175] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925855_1.4.2.3.1>

    2023-04-10T11:24:48.723645  / # #

    2023-04-10T11:24:48.826611  export SHELL=3D/bin/sh

    2023-04-10T11:24:48.827368  #

    2023-04-10T11:24:48.929227  / # export SHELL=3D/bin/sh. /lava-9925855/e=
nvironment

    2023-04-10T11:24:48.930003  =


    2023-04-10T11:24:49.032021  / # . /lava-9925855/environment/lava-992585=
5/bin/lava-test-runner /lava-9925855/1

    2023-04-10T11:24:49.033173  =


    2023-04-10T11:24:49.037984  / # /lava-9925855/bin/lava-test-runner /lav=
a-9925855/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f20c0cfd809c3c79e975

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f20c0cfd809c3c79e97e
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:42.946194  + set<8>[   10.087182] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9925805_1.4.2.3.1>

    2023-04-10T11:24:42.946648   +x

    2023-04-10T11:24:43.052475  / #

    2023-04-10T11:24:43.156020  # #export SHELL=3D/bin/sh

    2023-04-10T11:24:43.156840  =


    2023-04-10T11:24:43.258782  / # export SHELL=3D/bin/sh. /lava-9925805/e=
nvironment

    2023-04-10T11:24:43.259931  =


    2023-04-10T11:24:43.361595  / # . /lava-9925805/environment/lava-992580=
5/bin/lava-test-runner /lava-9925805/1

    2023-04-10T11:24:43.362846  =


    2023-04-10T11:24:43.368445  / # /lava-9925805/bin/lava-test-runner /lav=
a-9925805/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f21c179c2a27a579e93c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f21c179c2a27a579e945
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:52.567234  + set<8>[   11.291458] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9925827_1.4.2.3.1>

    2023-04-10T11:24:52.567811   +x

    2023-04-10T11:24:52.676783  / # #

    2023-04-10T11:24:52.780230  export SHELL=3D/bin/sh

    2023-04-10T11:24:52.781083  #

    2023-04-10T11:24:52.883016  / # export SHELL=3D/bin/sh. /lava-9925827/e=
nvironment

    2023-04-10T11:24:52.883812  =


    2023-04-10T11:24:52.985610  / # . /lava-9925827/environment/lava-992582=
7/bin/lava-test-runner /lava-9925827/1

    2023-04-10T11:24:52.987009  =


    2023-04-10T11:24:52.991344  / # /lava-9925827/bin/lava-test-runner /lav=
a-9925827/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f20f4a9cafaad679e941

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g8cb40b7e3c0e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f20f4a9cafaad679e94a
        failing since 13 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T11:24:46.433045  <8>[   12.282121] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925843_1.4.2.3.1>

    2023-04-10T11:24:46.538010  / # #

    2023-04-10T11:24:46.639166  export SHELL=3D/bin/sh

    2023-04-10T11:24:46.639795  #

    2023-04-10T11:24:46.741549  / # export SHELL=3D/bin/sh. /lava-9925843/e=
nvironment

    2023-04-10T11:24:46.742177  =


    2023-04-10T11:24:46.843952  / # . /lava-9925843/environment/lava-992584=
3/bin/lava-test-runner /lava-9925843/1

    2023-04-10T11:24:46.844961  =


    2023-04-10T11:24:46.849520  / # /lava-9925843/bin/lava-test-runner /lav=
a-9925843/1

    2023-04-10T11:24:46.854702  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
