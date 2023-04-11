Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8400B6DE606
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 22:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDKUwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 16:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjDKUws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 16:52:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B210655A7
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:52:45 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a4f7b041dfso6649455ad.3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681246365; x=1683838365;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=afX80bL26mQoTrWyFgYKXbxi9XJCAnJke+44wFeyPdk=;
        b=ciBvl6MAksmRQ+k0rs4B8IYdKrMl5teEXAhAo+NKEeor4mvfXO6Z/kReFzbe3pgeLO
         qmWKbuSDxEa6Y0htY5USCJP74iATv8KUvRhV2lq2FojKXKXyniGiyiZlmL61myOadtQw
         a8dJSlIAwNgMmvM4Fcvd76cx/4q2BgayTvOr0HbsiPRWeSdoGwWzIA+0cljO306KUUUp
         nl3Jf99ytinLnBH/HOf2z8SqX14Cuzaa4lbj3H/AgmCUi584bEWW+1LuBR+H76ZtFwhk
         elLWknJ2ll7ddGfxn0/x8KYq8OXOTNixB/6jXrAHAbt1xGdH7VTiETr3lEmk3E2aADMF
         UYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681246365; x=1683838365;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afX80bL26mQoTrWyFgYKXbxi9XJCAnJke+44wFeyPdk=;
        b=bovi4usxsC85VTRUo33U/Bk/aptrDnvFp+IF7GvFgvxkJAr7w/oWpLVgPAxR+2DDyk
         D0aJn4TXdE2sMjqJFf0VUE2Td+AG9V6RrMJ6iQsuTr+lohZyS8T+PAf5Odbx1vSAkRiy
         J6p+ajKT1vSqDZI292FpBzxMH89SGeW4986dRKZZ8cuocA2JnXbBuJBM/TDiutss4fCr
         aLArIwS0LQ9+6cp0nx67ztkVTOjkbp1AeCUkrnHbaJ78R33F5yCbI7C37TEwX1UAD5ER
         ZtKyLNJR+LWApu7U/Rlp6c4fRubMKKIJb1IOqaFR/Ytlt4QzpM4/xXVkNIl8VifvQAZy
         QJFw==
X-Gm-Message-State: AAQBX9e/5wscfD/R3h91paM7ufVo/DgXv/o31E9XOPWzUWgOS7VPUsDM
        05kaNAGnoL8lYRc0EHFCmkX9iVyrmJ3wMmqs1EdzGA==
X-Google-Smtp-Source: AKy350YoPVqOj1fTE61n+Ihdet6uib3k8Rv99E/M4Zde0lTsYiPz5NdTqPIG81+KApIVmGxssfRX5Q==
X-Received: by 2002:a62:4e43:0:b0:638:ce16:8a95 with SMTP id c64-20020a624e43000000b00638ce168a95mr6939492pfb.27.1681246364823;
        Tue, 11 Apr 2023 13:52:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15-20020aa791cf000000b0062dae524006sm10268563pfa.157.2023.04.11.13.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:52:44 -0700 (PDT)
Message-ID: <6435c89c.a70a0220.93a02.3c62@mx.google.com>
Date:   Tue, 11 Apr 2023 13:52:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-327-g5d6cb90df983
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 190 runs,
 8 regressions (v6.1.22-327-g5d6cb90df983)
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

stable-rc/queue/6.1 baseline: 190 runs, 8 regressions (v6.1.22-327-g5d6cb90=
df983)

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
el/v6.1.22-327-g5d6cb90df983/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-327-g5d6cb90df983
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d6cb90df9834327df167cf4ae22411453d03a97 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643594e77ec6dc1f992e8633

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594e77ec6dc1f992e8638
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:11:50.544422  + set +x

    2023-04-11T17:11:50.551028  <8>[    9.898871] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9940225_1.4.2.3.1>

    2023-04-11T17:11:50.653993  =


    2023-04-11T17:11:50.755060  / # #export SHELL=3D/bin/sh

    2023-04-11T17:11:50.755294  =


    2023-04-11T17:11:50.856253  / # export SHELL=3D/bin/sh. /lava-9940225/e=
nvironment

    2023-04-11T17:11:50.856480  =


    2023-04-11T17:11:50.957458  / # . /lava-9940225/environment/lava-994022=
5/bin/lava-test-runner /lava-9940225/1

    2023-04-11T17:11:50.957837  =


    2023-04-11T17:11:50.962146  / # /lava-9940225/bin/lava-test-runner /lav=
a-9940225/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643594e8c63c1a57922e85fd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594e8c63c1a57922e8602
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:11:45.964344  + <8>[   10.796901] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9940237_1.4.2.3.1>

    2023-04-11T17:11:45.964459  set +x

    2023-04-11T17:11:46.068961  / # #

    2023-04-11T17:11:46.170105  export SHELL=3D/bin/sh

    2023-04-11T17:11:46.170361  #

    2023-04-11T17:11:46.271201  / # export SHELL=3D/bin/sh. /lava-9940237/e=
nvironment

    2023-04-11T17:11:46.271463  =


    2023-04-11T17:11:46.372433  / # . /lava-9940237/environment/lava-994023=
7/bin/lava-test-runner /lava-9940237/1

    2023-04-11T17:11:46.372790  =


    2023-04-11T17:11:46.377545  / # /lava-9940237/bin/lava-test-runner /lav=
a-9940237/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643594e902275edca12e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594e902275edca12e85eb
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:12:00.301582  <8>[   10.179198] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9940283_1.4.2.3.1>

    2023-04-11T17:12:00.304676  + set +x

    2023-04-11T17:12:00.406285  #

    2023-04-11T17:12:00.406554  =


    2023-04-11T17:12:00.507578  / # #export SHELL=3D/bin/sh

    2023-04-11T17:12:00.507831  =


    2023-04-11T17:12:00.608823  / # export SHELL=3D/bin/sh. /lava-9940283/e=
nvironment

    2023-04-11T17:12:00.609006  =


    2023-04-11T17:12:00.709899  / # . /lava-9940283/environment/lava-994028=
3/bin/lava-test-runner /lava-9940283/1

    2023-04-11T17:12:00.710161  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/643594e3e764ad6d312e8659

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594e3e764ad6d312e868c
        new failure (last pass: v6.1.22-278-gb95c5e4f2816)

    2023-04-11T17:11:49.398887  + set +x
    2023-04-11T17:11:49.402852  <8>[   16.853082] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 312303_1.5.2.4.1>
    2023-04-11T17:11:49.522819  / # #
    2023-04-11T17:11:49.624800  export SHELL=3D/bin/sh
    2023-04-11T17:11:49.625440  #
    2023-04-11T17:11:49.727022  / # export SHELL=3D/bin/sh. /lava-312303/en=
vironment
    2023-04-11T17:11:49.727784  =

    2023-04-11T17:11:49.829635  / # . /lava-312303/environment/lava-312303/=
bin/lava-test-runner /lava-312303/1
    2023-04-11T17:11:49.830718  =

    2023-04-11T17:11:49.837271  / # /lava-312303/bin/lava-test-runner /lava=
-312303/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435956ac0a26b1b892e861e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435956ac0a26b1b892e8623
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:14:01.302359  + set +x

    2023-04-11T17:14:01.308884  <8>[   10.722934] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9940250_1.4.2.3.1>

    2023-04-11T17:14:01.413526  / # #

    2023-04-11T17:14:01.514593  export SHELL=3D/bin/sh

    2023-04-11T17:14:01.514775  #

    2023-04-11T17:14:01.615690  / # export SHELL=3D/bin/sh. /lava-9940250/e=
nvironment

    2023-04-11T17:14:01.615907  =


    2023-04-11T17:14:01.716845  / # . /lava-9940250/environment/lava-994025=
0/bin/lava-test-runner /lava-9940250/1

    2023-04-11T17:14:01.717173  =


    2023-04-11T17:14:01.721644  / # /lava-9940250/bin/lava-test-runner /lav=
a-9940250/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643594f1042e22be022e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594f1042e22be022e85ee
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:11:54.782484  <8>[   10.192144] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9940296_1.4.2.3.1>

    2023-04-11T17:11:54.785630  + set +x

    2023-04-11T17:11:54.888041  =


    2023-04-11T17:11:54.989938  / # #export SHELL=3D/bin/sh

    2023-04-11T17:11:54.990686  =


    2023-04-11T17:11:55.092629  / # export SHELL=3D/bin/sh. /lava-9940296/e=
nvironment

    2023-04-11T17:11:55.093564  =


    2023-04-11T17:11:55.195342  / # . /lava-9940296/environment/lava-994029=
6/bin/lava-test-runner /lava-9940296/1

    2023-04-11T17:11:55.196412  =


    2023-04-11T17:11:55.201359  / # /lava-9940296/bin/lava-test-runner /lav=
a-9940296/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643594e67ec6dc1f992e8622

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594e67ec6dc1f992e8627
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:11:40.331827  + set<8>[   10.996846] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9940243_1.4.2.3.1>

    2023-04-11T17:11:40.331944   +x

    2023-04-11T17:11:40.436618  / # #

    2023-04-11T17:11:40.537725  export SHELL=3D/bin/sh

    2023-04-11T17:11:40.537949  #

    2023-04-11T17:11:40.638896  / # export SHELL=3D/bin/sh. /lava-9940243/e=
nvironment

    2023-04-11T17:11:40.639121  =


    2023-04-11T17:11:40.740032  / # . /lava-9940243/environment/lava-994024=
3/bin/lava-test-runner /lava-9940243/1

    2023-04-11T17:11:40.740309  =


    2023-04-11T17:11:40.745262  / # /lava-9940243/bin/lava-test-runner /lav=
a-9940243/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643594e4e764ad6d312e86ce

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-32=
7-g5d6cb90df983/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643594e4e764ad6d312e86d3
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T17:11:42.179367  <8>[   11.087832] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9940222_1.4.2.3.1>

    2023-04-11T17:11:42.284742  / # #

    2023-04-11T17:11:42.385776  export SHELL=3D/bin/sh

    2023-04-11T17:11:42.385996  #

    2023-04-11T17:11:42.486941  / # export SHELL=3D/bin/sh. /lava-9940222/e=
nvironment

    2023-04-11T17:11:42.487187  =


    2023-04-11T17:11:42.588200  / # . /lava-9940222/environment/lava-994022=
2/bin/lava-test-runner /lava-9940222/1

    2023-04-11T17:11:42.588539  =


    2023-04-11T17:11:42.593256  / # /lava-9940222/bin/lava-test-runner /lav=
a-9940222/1

    2023-04-11T17:11:42.600679  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
