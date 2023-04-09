Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB36DC106
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 20:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDISmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 14:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDISmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 14:42:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA02630D3
        for <stable@vger.kernel.org>; Sun,  9 Apr 2023 11:42:42 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ik20so2856593plb.3
        for <stable@vger.kernel.org>; Sun, 09 Apr 2023 11:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681065762; x=1683657762;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lS42006qzSu1kHe7giZAU8JNz6gIoRzzOw3vfQgCB7k=;
        b=RbPhuV6F7I9Vu3slxkU6PO5FOm/tCPeQpcDZjXVAVTeD2xm7u2ChSiZPWsU1FP+qDo
         Z4xjpWhHj8RD86XqoArNRVb/zrGMi0nBUY1KW1iB0pXrup9fZXCRnT1pzVY+0ZwbpSQc
         D2PV335/dgkw8QfXJDvfOxxSnDW7GaZWC/EkBKd4eIQUtdrYAB6Xj+5PnfTIDw/WuZrQ
         XjuuSyjjUyI0Xt6vpCWCKbUWcqj969HoHaLbq/+iKCajh0cvN17OeFStudS0dppgJWDM
         1JtJMgls6TUz/Qv0lPc+XejfHk3geB3SR35wzyTdRLosGaGIeXeKMK/T8zNT1RlHrqv1
         bO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681065762; x=1683657762;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lS42006qzSu1kHe7giZAU8JNz6gIoRzzOw3vfQgCB7k=;
        b=Ge0JMGAypwIx1vbbjfV7Fb7PvsmxyNktb6H+TheJZMTWK2a3b4xfjfoCdTahntvQTF
         wbA6bpCH6bKTZMbnZSKt8l3CFLvDj2I2rZzAieDp2Ludx4L7zRNP9ejcjU/jljuwDYHO
         4wovIcDJIEnr3CcYMVVTagzQbYkJYNYIq3NXEMsPx1ErtG12k96L2MmyIYU6TW23r2T/
         o8O62Or+zhw46IYXj9c+d+CPALjYNT2arf/0dxxTaW9vJi5tHZPVJnN0gPaggTp+YG1c
         uDHmdXV3EIGcaEITEy2lXDUr3AxCZudkZfTcNDLIo7eb8Uw3b9dxcP3/aByXP2XVvwlf
         TzBA==
X-Gm-Message-State: AAQBX9fjRO/3g4Npy9J/vcs59SL3oVI7pg485Ea9HLUe/UIGZ4meXJiN
        oxY6sFU+zmbPcpSxY1+actLfEN0hZwLCI19sRh0=
X-Google-Smtp-Source: AKy350YRiuMUoIivWEZKT9wRdJFnHZpPE4KFdwgC6oZBDgFccvWQ0wqDbQMygtQU6VOC9sneGieZjw==
X-Received: by 2002:a17:90b:384f:b0:23d:48a9:3400 with SMTP id nl15-20020a17090b384f00b0023d48a93400mr11297844pjb.31.1681065761980;
        Sun, 09 Apr 2023 11:42:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w20-20020a17090a8a1400b0023f355a0bb5sm973206pjn.14.2023.04.09.11.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 11:42:41 -0700 (PDT)
Message-ID: <64330721.170a0220.90358.1327@mx.google.com>
Date:   Sun, 09 Apr 2023 11:42:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-152-g55b8fb5a47fc
Subject: stable-rc/queue/5.15 baseline: 111 runs,
 9 regressions (v5.15.105-152-g55b8fb5a47fc)
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

stable-rc/queue/5.15 baseline: 111 runs, 9 regressions (v5.15.105-152-g55b8=
fb5a47fc)

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
nel/v5.15.105-152-g55b8fb5a47fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-152-g55b8fb5a47fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55b8fb5a47fcf1314c67d9c84dbb2fb29a9bef5c =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d12fcdab4cd33479e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d12fcdab4cd33479e92b
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:52:08.195070  <8>[   10.833380] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9920415_1.4.2.3.1>

    2023-04-09T14:52:08.198091  + set +x

    2023-04-09T14:52:08.303330  / # #

    2023-04-09T14:52:08.404389  export SHELL=3D/bin/sh

    2023-04-09T14:52:08.404584  #

    2023-04-09T14:52:08.505337  / # export SHELL=3D/bin/sh. /lava-9920415/e=
nvironment

    2023-04-09T14:52:08.505545  =


    2023-04-09T14:52:08.606519  / # . /lava-9920415/environment/lava-992041=
5/bin/lava-test-runner /lava-9920415/1

    2023-04-09T14:52:08.606819  =


    2023-04-09T14:52:08.612797  / # /lava-9920415/bin/lava-test-runner /lav=
a-9920415/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d11ffe88df82cf79e923

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d11ffe88df82cf79e92b
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:51:51.069392  + set<8>[   11.076413] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9920451_1.4.2.3.1>

    2023-04-09T14:51:51.069489   +x

    2023-04-09T14:51:51.174223  / # #

    2023-04-09T14:51:51.275327  export SHELL=3D/bin/sh

    2023-04-09T14:51:51.275544  #

    2023-04-09T14:51:51.376516  / # export SHELL=3D/bin/sh. /lava-9920451/e=
nvironment

    2023-04-09T14:51:51.376717  =


    2023-04-09T14:51:51.477667  / # . /lava-9920451/environment/lava-992045=
1/bin/lava-test-runner /lava-9920451/1

    2023-04-09T14:51:51.477963  =


    2023-04-09T14:51:51.483063  / # /lava-9920451/bin/lava-test-runner /lav=
a-9920451/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d10fd72f6fb4fe79ea72

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d10fd72f6fb4fe79ea7b
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:51:48.346383  <8>[   10.694009] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9920404_1.4.2.3.1>

    2023-04-09T14:51:48.349900  + set +x

    2023-04-09T14:51:48.451787  =


    2023-04-09T14:51:48.552754  / # #export SHELL=3D/bin/sh

    2023-04-09T14:51:48.552956  =


    2023-04-09T14:51:48.653859  / # export SHELL=3D/bin/sh. /lava-9920404/e=
nvironment

    2023-04-09T14:51:48.654061  =


    2023-04-09T14:51:48.754969  / # . /lava-9920404/environment/lava-992040=
4/bin/lava-test-runner /lava-9920404/1

    2023-04-09T14:51:48.755326  =


    2023-04-09T14:51:48.760232  / # /lava-9920404/bin/lava-test-runner /lav=
a-9920404/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d5290afd346b8679e9a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6432d5290afd346b8679e=
9aa
        failing since 65 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d2d0fbf45dda8879e962

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d2d0fbf45dda8879e96b
        failing since 82 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-09T14:59:07.175992  <8>[    9.941915] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3480992_1.5.2.4.1>
    2023-04-09T14:59:07.285615  / # #
    2023-04-09T14:59:07.388722  export SHELL=3D/bin/sh
    2023-04-09T14:59:07.389560  #
    2023-04-09T14:59:07.491609  / # export SHELL=3D/bin/sh. /lava-3480992/e=
nvironment
    2023-04-09T14:59:07.492502  =

    2023-04-09T14:59:07.594370  / # . /lava-3480992/environment/lava-348099=
2/bin/lava-test-runner /lava-3480992/1
    2023-04-09T14:59:07.595772  =

    2023-04-09T14:59:07.596184  / # /lava-3480992/bin/lava-test-runner /lav=
a-3480992/1<3>[   10.352986] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-04-09T14:59:07.599918   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d11dfae87da26479e93b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d11dfae87da26479e944
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:51:54.985656  + set +x

    2023-04-09T14:51:54.992230  <8>[   10.230102] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9920423_1.4.2.3.1>

    2023-04-09T14:51:55.097367  / # #

    2023-04-09T14:51:55.198507  export SHELL=3D/bin/sh

    2023-04-09T14:51:55.198711  #

    2023-04-09T14:51:55.299667  / # export SHELL=3D/bin/sh. /lava-9920423/e=
nvironment

    2023-04-09T14:51:55.299884  =


    2023-04-09T14:51:55.400825  / # . /lava-9920423/environment/lava-992042=
3/bin/lava-test-runner /lava-9920423/1

    2023-04-09T14:51:55.401151  =


    2023-04-09T14:51:55.406107  / # /lava-9920423/bin/lava-test-runner /lav=
a-9920423/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d0fa5cd99f918579e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d0fa5cd99f918579e92b
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:51:32.156812  <8>[   10.143311] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9920407_1.4.2.3.1>

    2023-04-09T14:51:32.160365  + set +x

    2023-04-09T14:51:32.265523  #

    2023-04-09T14:51:32.368456  / # #export SHELL=3D/bin/sh

    2023-04-09T14:51:32.369144  =


    2023-04-09T14:51:32.471133  / # export SHELL=3D/bin/sh. /lava-9920407/e=
nvironment

    2023-04-09T14:51:32.471838  =


    2023-04-09T14:51:32.573729  / # . /lava-9920407/environment/lava-992040=
7/bin/lava-test-runner /lava-9920407/1

    2023-04-09T14:51:32.574953  =


    2023-04-09T14:51:32.580052  / # /lava-9920407/bin/lava-test-runner /lav=
a-9920407/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d1202d59e47fb979e988

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d1202d59e47fb979e991
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:51:51.690262  + set<8>[   11.344429] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9920442_1.4.2.3.1>

    2023-04-09T14:51:51.690780   +x

    2023-04-09T14:51:51.799117  / # #

    2023-04-09T14:51:51.901875  export SHELL=3D/bin/sh

    2023-04-09T14:51:51.902669  #

    2023-04-09T14:51:52.004781  / # export SHELL=3D/bin/sh. /lava-9920442/e=
nvironment

    2023-04-09T14:51:52.005570  =


    2023-04-09T14:51:52.107392  / # . /lava-9920442/environment/lava-992044=
2/bin/lava-test-runner /lava-9920442/1

    2023-04-09T14:51:52.108649  =


    2023-04-09T14:51:52.114429  / # /lava-9920442/bin/lava-test-runner /lav=
a-9920442/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d109d72f6fb4fe79ea56

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-152-g55b8fb5a47fc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d109d72f6fb4fe79ea5f
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-09T14:51:39.920062  + set +x<8>[   11.959988] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9920439_1.4.2.3.1>

    2023-04-09T14:51:39.920169  =


    2023-04-09T14:51:40.025070  / # #

    2023-04-09T14:51:40.126170  export SHELL=3D/bin/sh

    2023-04-09T14:51:40.126414  #

    2023-04-09T14:51:40.227360  / # export SHELL=3D/bin/sh. /lava-9920439/e=
nvironment

    2023-04-09T14:51:40.227617  =


    2023-04-09T14:51:40.328580  / # . /lava-9920439/environment/lava-992043=
9/bin/lava-test-runner /lava-9920439/1

    2023-04-09T14:51:40.328939  =


    2023-04-09T14:51:40.333887  / # /lava-9920439/bin/lava-test-runner /lav=
a-9920439/1
 =

    ... (12 line(s) more)  =

 =20
