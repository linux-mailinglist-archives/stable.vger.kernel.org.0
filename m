Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50D56D7128
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 02:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbjDEAQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 20:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjDEAQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 20:16:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D5244A2
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 17:16:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o11so32926514ple.1
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 17:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680653801;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PuvxhJmwUuKWGaHxMr3QgHY8G83o0UdJEPmVbxNn77M=;
        b=M6pszkHatFZecHkGN+ozcUlhbFAaL4Mud0akuN90V1Lo1d08wEAh+eypAP0LzelObJ
         YAzHpZwZuthZBeCGr8kFSkaHsMactrpU97MmUBIwaih7Fag/S6WBAqyuHgc+X7QhpJhR
         E3Giom46SlQoQ0YnA7Mc0nq/8+T/yr+2P1/GAfBI0yUtiyOc4fO7plvZZxfOTmxEe39E
         HolxHXkPkvyk/wa4+hJgWadwh+mmrE0ThhZgdRzLW2tzyphJIjRIQ3tqUNNtmj8sLyFb
         qKXre2m0g+vK8hnOR2q3EmxLuaVFkFSLxUH718IAYJ8l/6PQWwcSPhRsOA5MAE4g0yjQ
         zXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680653801;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PuvxhJmwUuKWGaHxMr3QgHY8G83o0UdJEPmVbxNn77M=;
        b=0dYAmskYMlkKZxC2pcPhPlVNOmxSu9eZl9Do2PeTIS3ybS4bvEw6L3syEJMEy+Cv+2
         k4PhAhx/fBzKbaFLsrWuh0JKRJm3uFFG+HopwRQh+4gUPZQ9IdD6HU+dX0s2z2Zs5afe
         FSdkzF5AKc82Brwd4E4HoXZQW3t0NZTSlVqFvfu96uYoGuoRoW2cLl40Np+UTbTYqwrY
         AzXD/uMisJvnzrSsk4KkHdHqsH3H1NxhaXTohcUmiuY5+e+6dcPxh2clMq954zr9YQyC
         Qx88ZOe06osWc/MnkO2qr6h4cguKOX6vSCrBQS85o4l1hWKLvIWTZyfm1gQs8twMPQu7
         WmbQ==
X-Gm-Message-State: AAQBX9dqeMJxztl/EiWV9ADzXdoB0+xIxOQEwaxmSTeaO0vO/1y7nbHx
        XOnXAHhhLdV0CDbpX543ng8h/3Bc68+ED/lsyJlaHw==
X-Google-Smtp-Source: AKy350YQXuzZThoukmhuNspVIvptIvLBq5YYBkfeNmpoMhraJjQtuAKxVUrtaHFrTFfrUVbCAxZEMg==
X-Received: by 2002:a17:903:905:b0:19e:bc8e:6421 with SMTP id ll5-20020a170903090500b0019ebc8e6421mr3631183plb.47.1680653801337;
        Tue, 04 Apr 2023 17:16:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j5-20020a170902c08500b0019a723a831dsm8878010pld.158.2023.04.04.17.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 17:16:40 -0700 (PDT)
Message-ID: <642cbde8.170a0220.f8f9.2d2d@mx.google.com>
Date:   Tue, 04 Apr 2023 17:16:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-179-ga7cb9fb3a7e4e
Subject: stable-rc/queue/6.1 baseline: 115 runs,
 8 regressions (v6.1.22-179-ga7cb9fb3a7e4e)
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

stable-rc/queue/6.1 baseline: 115 runs, 8 regressions (v6.1.22-179-ga7cb9fb=
3a7e4e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-179-ga7cb9fb3a7e4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-179-ga7cb9fb3a7e4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7cb9fb3a7e4e62eb245bb6d86dca7d5a390c376 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c829a235da5f1e879e93f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c829a235da5f1e879e943
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:03:25.586190  <8>[   10.228727] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9867914_1.4.2.3.1>

    2023-04-04T20:03:25.589159  + set +x

    2023-04-04T20:03:25.694139  #

    2023-04-04T20:03:25.797177  / # #export SHELL=3D/bin/sh

    2023-04-04T20:03:25.797835  =


    2023-04-04T20:03:25.899709  / # export SHELL=3D/bin/sh. /lava-9867914/e=
nvironment

    2023-04-04T20:03:25.900481  =


    2023-04-04T20:03:26.002586  / # . /lava-9867914/environment/lava-986791=
4/bin/lava-test-runner /lava-9867914/1

    2023-04-04T20:03:26.003781  =


    2023-04-04T20:03:26.009446  / # /lava-9867914/bin/lava-test-runner /lav=
a-9867914/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c827c6246468bbd79e9e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c827c6246468bbd79e9ee
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:02:58.171038  + <8>[   11.266643] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9867917_1.4.2.3.1>

    2023-04-04T20:02:58.171135  set +x

    2023-04-04T20:02:58.275698  / # #

    2023-04-04T20:02:58.376699  export SHELL=3D/bin/sh

    2023-04-04T20:02:58.376884  #

    2023-04-04T20:02:58.477619  / # export SHELL=3D/bin/sh. /lava-9867917/e=
nvironment

    2023-04-04T20:02:58.477815  =


    2023-04-04T20:02:58.578838  / # . /lava-9867917/environment/lava-986791=
7/bin/lava-test-runner /lava-9867917/1

    2023-04-04T20:02:58.579132  =


    2023-04-04T20:02:58.584259  / # /lava-9867917/bin/lava-test-runner /lav=
a-9867917/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c827a6246468bbd79e9d0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c827a6246468bbd79e9d5
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:02:44.964953  <8>[   10.131510] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9867890_1.4.2.3.1>

    2023-04-04T20:02:44.968432  + set +x

    2023-04-04T20:02:45.073624  #

    2023-04-04T20:02:45.176779  / # #export SHELL=3D/bin/sh

    2023-04-04T20:02:45.177574  =


    2023-04-04T20:02:45.279349  / # export SHELL=3D/bin/sh. /lava-9867890/e=
nvironment

    2023-04-04T20:02:45.280133  =


    2023-04-04T20:02:45.382087  / # . /lava-9867890/environment/lava-986789=
0/bin/lava-test-runner /lava-9867890/1

    2023-04-04T20:02:45.383538  =


    2023-04-04T20:02:45.388547  / # /lava-9867890/bin/lava-test-runner /lav=
a-9867890/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/642c870e218b51f30379e940

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c870e218b51f30379e972
        new failure (last pass: v6.1.22-181-gcacf34e34abf0)

    2023-04-04T20:22:12.449150  + set +x
    2023-04-04T20:22:12.453923  <8>[   18.285313] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 277891_1.5.2.4.1>
    2023-04-04T20:22:12.569967  / # #
    2023-04-04T20:22:12.671890  export SHELL=3D/bin/sh
    2023-04-04T20:22:12.672332  #
    2023-04-04T20:22:12.774229  / # export SHELL=3D/bin/sh. /lava-277891/en=
vironment
    2023-04-04T20:22:12.774854  =

    2023-04-04T20:22:12.876577  / # . /lava-277891/environment/lava-277891/=
bin/lava-test-runner /lava-277891/1
    2023-04-04T20:22:12.877799  =

    2023-04-04T20:22:12.883977  / # /lava-277891/bin/lava-test-runner /lava=
-277891/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c8263a2f71d2ab979e971

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c8263a2f71d2ab979e976
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:02:35.379271  + set +x

    2023-04-04T20:02:35.386252  <8>[   10.271469] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9867866_1.4.2.3.1>

    2023-04-04T20:02:35.490509  / # #

    2023-04-04T20:02:35.591494  export SHELL=3D/bin/sh

    2023-04-04T20:02:35.591705  #

    2023-04-04T20:02:35.692658  / # export SHELL=3D/bin/sh. /lava-9867866/e=
nvironment

    2023-04-04T20:02:35.692881  =


    2023-04-04T20:02:35.793903  / # . /lava-9867866/environment/lava-986786=
6/bin/lava-test-runner /lava-9867866/1

    2023-04-04T20:02:35.794255  =


    2023-04-04T20:02:35.799290  / # /lava-9867866/bin/lava-test-runner /lav=
a-9867866/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c827e56ff5f322c79e93e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c827e56ff5f322c79e943
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:02:48.689977  + set<8>[   10.662863] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9867901_1.4.2.3.1>

    2023-04-04T20:02:48.690374   +x

    2023-04-04T20:02:48.795625  / #

    2023-04-04T20:02:48.898761  # #export SHELL=3D/bin/sh

    2023-04-04T20:02:48.899496  =


    2023-04-04T20:02:49.001480  / # export SHELL=3D/bin/sh. /lava-9867901/e=
nvironment

    2023-04-04T20:02:49.002281  =


    2023-04-04T20:02:49.104156  / # . /lava-9867901/environment/lava-986790=
1/bin/lava-test-runner /lava-9867901/1

    2023-04-04T20:02:49.105869  =


    2023-04-04T20:02:49.110606  / # /lava-9867901/bin/lava-test-runner /lav=
a-9867901/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c82796246468bbd79e9c5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c82796246468bbd79e9ca
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:02:57.103416  + set<8>[   11.387483] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9867905_1.4.2.3.1>

    2023-04-04T20:02:57.103510   +x

    2023-04-04T20:02:57.207884  / # #

    2023-04-04T20:02:57.308894  export SHELL=3D/bin/sh

    2023-04-04T20:02:57.309098  #

    2023-04-04T20:02:57.410078  / # export SHELL=3D/bin/sh. /lava-9867905/e=
nvironment

    2023-04-04T20:02:57.410309  =


    2023-04-04T20:02:57.511348  / # . /lava-9867905/environment/lava-986790=
5/bin/lava-test-runner /lava-9867905/1

    2023-04-04T20:02:57.511637  =


    2023-04-04T20:02:57.517040  / # /lava-9867905/bin/lava-test-runner /lav=
a-9867905/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c827b6246468bbd79e9de

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
9-ga7cb9fb3a7e4e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c827b6246468bbd79e9e3
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T20:02:45.779667  + set<8>[   11.373570] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9867909_1.4.2.3.1>

    2023-04-04T20:02:45.779763   +x

    2023-04-04T20:02:45.884518  / # #

    2023-04-04T20:02:45.985533  export SHELL=3D/bin/sh

    2023-04-04T20:02:45.985745  #

    2023-04-04T20:02:46.086634  / # export SHELL=3D/bin/sh. /lava-9867909/e=
nvironment

    2023-04-04T20:02:46.086826  =


    2023-04-04T20:02:46.187729  / # . /lava-9867909/environment/lava-986790=
9/bin/lava-test-runner /lava-9867909/1

    2023-04-04T20:02:46.188080  =


    2023-04-04T20:02:46.192534  / # /lava-9867909/bin/lava-test-runner /lav=
a-9867909/1
 =

    ... (12 line(s) more)  =

 =20
