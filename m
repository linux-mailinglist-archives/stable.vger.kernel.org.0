Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927FD6DE490
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 21:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDKTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 15:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDKTRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 15:17:15 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA70420E
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 12:17:13 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v9so14314301pjk.0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 12:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681240633; x=1683832633;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eVxiEYWy1aMzKt7sbQ9IXTOZUR5uJM4iYI7/96kaXrM=;
        b=kKtRaSKpIPqDmwssjJImM5PhVUdkg671+5JBP18YZgbH2acqrzvWIvJ6G2BQADcw2q
         S7MN6dhbOSYkV5Oe+3vAB6KNMBxJ2W0aUs73nYVi9otv0VC+mevd5xVBEAzmZH52nkMv
         FCRP76XCoJ/ccC5LLk2L+yocTxysVponF2e1tEzgsjqR/Z7asfGJjPAXmW6WT2QSCKfO
         1fzTiSUixZzQ6O6l7iizUsAjtsjOC1gKRP9H06W3JnkCLLIkTrEymmWxPhVk2ik0/c8V
         r8PNuClib3bl0bd+kU11xUuiT7/PbfsYyKHufcy80HgO+QcB5lnAy3xOS+duHb4EGiE4
         nyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681240633; x=1683832633;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVxiEYWy1aMzKt7sbQ9IXTOZUR5uJM4iYI7/96kaXrM=;
        b=w23aVmayEVO6190RYRaYAW9cZyEx9bRn/KjBle6J4CNxLYz479gXtmcACRs3Je2pos
         BSiIf6e+XPM0M0J24t9drpZfTWq1MMG/ORJymdhrzkY0AOdhLbpQq/NdYVaCs3FMT5fP
         0553ysk5fU9oVq2x/O/9CT4B1kKIdE7BWMKlt9nR59n3CWm4yungBD7HlQHVD7TAmQwY
         FKywwTagH5u4NKCqG2axcleXhGS7Vc1lyVJXnpGMNOF/L6nec/Ef6qN5qdCMqKD07o3q
         zbQ0l+IpNPObYThK8Kkn0N2csiQ9fg+/7NsQbo9SawheryEAgZrSkoptgEoq1Mrk8lU+
         yx6A==
X-Gm-Message-State: AAQBX9fTBNSYnI/Ku4nWpVShJFRXgzShcFUgJ7xgrUncf0++t+lD302s
        lbf6GwctSaxcvVYO1c1kBrvvULg3YV+xv8wu7Bnzeg==
X-Google-Smtp-Source: AKy350Z7tFH3HeJNek37tsJPtmrx4K0kjPC9qPYXCz4AEGBAYuKPX9LZr2jL5RvzCRywqGXJX2xk3Q==
X-Received: by 2002:a17:903:1110:b0:1a5:206:4c88 with SMTP id n16-20020a170903111000b001a502064c88mr4832497plh.18.1681240632793;
        Tue, 11 Apr 2023 12:17:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902d38400b001a651326089sm2314650pld.309.2023.04.11.12.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:17:12 -0700 (PDT)
Message-ID: <6435b238.170a0220.33a46.5f0d@mx.google.com>
Date:   Tue, 11 Apr 2023 12:17:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-327-gddc6e8108cbb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 142 runs,
 7 regressions (v6.1.22-327-gddc6e8108cbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 142 runs, 7 regressions (v6.1.22-327-gddc6e81=
08cbb)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-327-gddc6e8108cbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-327-gddc6e8108cbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddc6e8108cbbb00af916e18663c3966ddd399c57 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643579d6d4dad2e3202e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643579d6d4dad2e3202e8606
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:16:17.657499  + set +x

    2023-04-11T15:16:17.664192  <8>[   10.039108] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9938254_1.4.2.3.1>

    2023-04-11T15:16:17.772648  / # #

    2023-04-11T15:16:17.875342  export SHELL=3D/bin/sh

    2023-04-11T15:16:17.875918  #

    2023-04-11T15:16:17.977444  / # export SHELL=3D/bin/sh. /lava-9938254/e=
nvironment

    2023-04-11T15:16:17.978203  =


    2023-04-11T15:16:18.079746  / # . /lava-9938254/environment/lava-993825=
4/bin/lava-test-runner /lava-9938254/1

    2023-04-11T15:16:18.081079  =


    2023-04-11T15:16:18.086823  / # /lava-9938254/bin/lava-test-runner /lav=
a-9938254/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435797986468466ef2e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435797986468466ef2e85ec
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:14:45.449675  + <8>[   11.630277] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9938239_1.4.2.3.1>

    2023-04-11T15:14:45.450147  set +x

    2023-04-11T15:14:45.557561  / # #

    2023-04-11T15:14:45.660190  export SHELL=3D/bin/sh

    2023-04-11T15:14:45.661017  #

    2023-04-11T15:14:45.762874  / # export SHELL=3D/bin/sh. /lava-9938239/e=
nvironment

    2023-04-11T15:14:45.763572  =


    2023-04-11T15:14:45.865328  / # . /lava-9938239/environment/lava-993823=
9/bin/lava-test-runner /lava-9938239/1

    2023-04-11T15:14:45.866531  =


    2023-04-11T15:14:45.871760  / # /lava-9938239/bin/lava-test-runner /lav=
a-9938239/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64357983c4a4e029132e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64357983c4a4e029132e85eb
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:14:54.008666  <8>[    9.839470] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9938221_1.4.2.3.1>

    2023-04-11T15:14:54.011842  + set +x

    2023-04-11T15:14:54.117011  /#

    2023-04-11T15:14:54.219810   # #export SHELL=3D/bin/sh

    2023-04-11T15:14:54.220567  =


    2023-04-11T15:14:54.322527  / # export SHELL=3D/bin/sh. /lava-9938221/e=
nvironment

    2023-04-11T15:14:54.323261  =


    2023-04-11T15:14:54.425059  / # . /lava-9938221/environment/lava-993822=
1/bin/lava-test-runner /lava-9938221/1

    2023-04-11T15:14:54.426176  =


    2023-04-11T15:14:54.431214  / # /lava-9938221/bin/lava-test-runner /lav=
a-9938221/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435798c27d0da26d82e8618

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435798c27d0da26d82e861d
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:15:06.865598  + set +x

    2023-04-11T15:15:06.871895  <8>[   10.152473] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9938210_1.4.2.3.1>

    2023-04-11T15:15:06.977060  / # #

    2023-04-11T15:15:07.078090  export SHELL=3D/bin/sh

    2023-04-11T15:15:07.078296  #

    2023-04-11T15:15:07.179212  / # export SHELL=3D/bin/sh. /lava-9938210/e=
nvironment

    2023-04-11T15:15:07.179394  =


    2023-04-11T15:15:07.280282  / # . /lava-9938210/environment/lava-993821=
0/bin/lava-test-runner /lava-9938210/1

    2023-04-11T15:15:07.280553  =


    2023-04-11T15:15:07.285304  / # /lava-9938210/bin/lava-test-runner /lav=
a-9938210/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435796d56b59373872e861d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435796d56b59373872e8622
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:14:38.021090  + set +x

    2023-04-11T15:14:38.027644  <8>[   10.601996] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9938222_1.4.2.3.1>

    2023-04-11T15:14:38.129873  =


    2023-04-11T15:14:38.230870  / # #export SHELL=3D/bin/sh

    2023-04-11T15:14:38.231056  =


    2023-04-11T15:14:38.331825  / # export SHELL=3D/bin/sh. /lava-9938222/e=
nvironment

    2023-04-11T15:14:38.332017  =


    2023-04-11T15:14:38.432905  / # . /lava-9938222/environment/lava-993822=
2/bin/lava-test-runner /lava-9938222/1

    2023-04-11T15:14:38.433314  =


    2023-04-11T15:14:38.438609  / # /lava-9938222/bin/lava-test-runner /lav=
a-9938222/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435797b3ad5ed82df2e8640

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435797b3ad5ed82df2e8645
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:14:44.903694  + set<8>[   11.215088] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9938259_1.4.2.3.1>

    2023-04-11T15:14:44.903824   +x

    2023-04-11T15:14:45.009178  / # #

    2023-04-11T15:14:45.110193  export SHELL=3D/bin/sh

    2023-04-11T15:14:45.110432  #

    2023-04-11T15:14:45.211404  / # export SHELL=3D/bin/sh. /lava-9938259/e=
nvironment

    2023-04-11T15:14:45.211647  =


    2023-04-11T15:14:45.312516  / # . /lava-9938259/environment/lava-993825=
9/bin/lava-test-runner /lava-9938259/1

    2023-04-11T15:14:45.312860  =


    2023-04-11T15:14:45.317665  / # /lava-9938259/bin/lava-test-runner /lav=
a-9938259/1
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64357c82909f04b0642e86ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-gddc6e8108cbb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64357c82909f04b0642e86f4
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T15:27:45.229988  <8>[   11.658555] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9938225_1.4.2.3.1>

    2023-04-11T15:27:45.334865  / # #

    2023-04-11T15:27:45.435735  export SHELL=3D/bin/sh

    2023-04-11T15:27:45.435949  #

    2023-04-11T15:27:45.536893  / # export SHELL=3D/bin/sh. /lava-9938225/e=
nvironment

    2023-04-11T15:27:45.537156  =


    2023-04-11T15:27:45.638144  / # . /lava-9938225/environment/lava-993822=
5/bin/lava-test-runner /lava-9938225/1

    2023-04-11T15:27:45.638518  =


    2023-04-11T15:27:45.643304  / # /lava-9938225/bin/lava-test-runner /lav=
a-9938225/1

    2023-04-11T15:27:45.649386  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
