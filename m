Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7EE6E81C2
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 21:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDSTRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 15:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDSTRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 15:17:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AAD5248
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 12:17:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z2so217379ple.0
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 12:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681931833; x=1684523833;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UrQjdyQ+n6rBEorvP5ZV05y6cOI0pZS5id6pmgfjtwM=;
        b=iTlEybyK1cLxaHrXnaDBi97T4zelgyC7U4q3RzeUU17t6/H+5hN079B8fQW44/8Q63
         268euA7cPfpWW5CuTiAgIAjCp92dgzPiwOiDPUe0Zec9xGmNSFVp0jKU1o6HHAaA8EgA
         AlIt9439jHYh2WQcD62J+LQoaHVlALtwZIBR08gB3AxOTSpOwfB7nuONZLdI9lSTT2A6
         5CljqVLVtki/cc3x5WxLvhzUvu9+Z1MSufg6xghIhcW4nDFjGqpyee5t+0TXKol/GfMV
         HUMa1vm7Do4cev8YTz86CDHkuJxXAntmVz8aH7tb0/ZDCx1zUKdS07+7IABau8QKkJbT
         Aj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681931833; x=1684523833;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrQjdyQ+n6rBEorvP5ZV05y6cOI0pZS5id6pmgfjtwM=;
        b=RP/hWO/AqBTsPZeO30UIm9AOX2BCjgTVdw9NscvhEoU1d7izhsiUOkJ3KWWP06BxYu
         bmSNl8MGQccL2/ivsayVXpJ/d/+ZjeiwPtYepicmvW2AjiEgQLVV4/if+58V+1hhzFXZ
         2tA3HwKGlFH3p7P99FHCSfnZcaYZzkdxZaOcU1ISrjBfPTeo4GALwUKor6voq5yT3JsU
         jBUhixHqcNmZStVEGmkZx+0ZFDrDoBj2L+HmyIUFqSofV1tsRa3dCcKv9/RhQc23J93I
         jOc9E3b/kjJwsWtVaHoyPQ5d/aVipmp05nREz6R1cEx6tPldoH+J1IfKJD2ACYW6pFQ1
         p3XQ==
X-Gm-Message-State: AAQBX9cnCeSgWn0mNLU68IMbZKVoilMpRNanYGUZ2TaQPQDjTYeqhcPc
        cx1Dbe0sniWv931wrdu6QhDxYTzmuMlkpO0RtTHfodIi
X-Google-Smtp-Source: AKy350bawThnXWhIXFp415GiCwqbtcvuAs+BpEUpfDOxJCwjjWAYBdz1BkuZJiRdxDNUJREg1OipYQ==
X-Received: by 2002:a05:6a20:431e:b0:f0:3724:a9b0 with SMTP id h30-20020a056a20431e00b000f03724a9b0mr5082261pzk.3.1681931832722;
        Wed, 19 Apr 2023 12:17:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n4-20020a63ee44000000b005136b93f8e9sm10433355pgk.14.2023.04.19.12.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 12:17:12 -0700 (PDT)
Message-ID: <64403e38.630a0220.f964b.7c89@mx.google.com>
Date:   Wed, 19 Apr 2023 12:17:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-272-g462a824b77c9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 176 runs,
 10 regressions (v5.15.105-272-g462a824b77c9)
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

stable-rc/queue/5.15 baseline: 176 runs, 10 regressions (v5.15.105-272-g462=
a824b77c9)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-272-g462a824b77c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-272-g462a824b77c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      462a824b77c967e72957166f11d085b01a43f369 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400afc6700ee65782e861d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400afc6700ee65782e8622
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:38:16.671651  <8>[   11.110723] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049295_1.4.2.3.1>

    2023-04-19T15:38:16.675010  + set +x

    2023-04-19T15:38:16.780152  / # #

    2023-04-19T15:38:16.881244  export SHELL=3D/bin/sh

    2023-04-19T15:38:16.881495  #

    2023-04-19T15:38:16.982498  / # export SHELL=3D/bin/sh. /lava-10049295/=
environment

    2023-04-19T15:38:16.982722  =


    2023-04-19T15:38:17.083685  / # . /lava-10049295/environment/lava-10049=
295/bin/lava-test-runner /lava-10049295/1

    2023-04-19T15:38:17.084053  =


    2023-04-19T15:38:17.089794  / # /lava-10049295/bin/lava-test-runner /la=
va-10049295/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400d0948f66e50c92e860a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400d0948f66e50c92e860f
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:47:16.561356  + set +x<8>[   12.292459] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10049281_1.4.2.3.1>

    2023-04-19T15:47:16.561463  =


    2023-04-19T15:47:16.666097  / # #

    2023-04-19T15:47:16.767171  export SHELL=3D/bin/sh

    2023-04-19T15:47:16.767438  #

    2023-04-19T15:47:16.868425  / # export SHELL=3D/bin/sh. /lava-10049281/=
environment

    2023-04-19T15:47:16.868651  =


    2023-04-19T15:47:16.969608  / # . /lava-10049281/environment/lava-10049=
281/bin/lava-test-runner /lava-10049281/1

    2023-04-19T15:47:16.970026  =


    2023-04-19T15:47:16.974594  / # /lava-10049281/bin/lava-test-runner /la=
va-10049281/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400af96700ee65782e8602

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400af96700ee65782e8607
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:38:18.029873  <8>[   11.400311] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049313_1.4.2.3.1>

    2023-04-19T15:38:18.033243  + set +x

    2023-04-19T15:38:18.138703  #

    2023-04-19T15:38:18.140125  =


    2023-04-19T15:38:18.242144  / # #export SHELL=3D/bin/sh

    2023-04-19T15:38:18.242817  =


    2023-04-19T15:38:18.344574  / # export SHELL=3D/bin/sh. /lava-10049313/=
environment

    2023-04-19T15:38:18.345432  =


    2023-04-19T15:38:18.447149  / # . /lava-10049313/environment/lava-10049=
313/bin/lava-test-runner /lava-10049313/1

    2023-04-19T15:38:18.447634  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64400d212e9df8c5062e8611

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64400d212e9df8c5062e8=
612
        failing since 75 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64400ab19c152e1f862e8608

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400ab19c152e1f862e860d
        failing since 92 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-19T15:36:45.825995  <8>[    9.926021] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3512787_1.5.2.4.1>
    2023-04-19T15:36:45.935670  / # #
    2023-04-19T15:36:46.038813  export SHELL=3D/bin/sh
    2023-04-19T15:36:46.039711  #
    2023-04-19T15:36:46.141709  / # export SHELL=3D/bin/sh. /lava-3512787/e=
nvironment
    2023-04-19T15:36:46.142724  =

    2023-04-19T15:36:46.143224  / # <3>[   10.192777] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-19T15:36:46.245349  . /lava-3512787/environment/lava-3512787/bi=
n/lava-test-runner /lava-3512787/1
    2023-04-19T15:36:46.247259  =

    2023-04-19T15:36:46.251621  / # /lava-3512787/bin/lava-test-runner /lav=
a-3512787/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400c10f8bc2991352e865a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400c10f8bc2991352e865f
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:42:56.435526  + set +x

    2023-04-19T15:42:56.442205  <8>[   10.804642] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049266_1.4.2.3.1>

    2023-04-19T15:42:56.546850  / # #

    2023-04-19T15:42:56.647915  export SHELL=3D/bin/sh

    2023-04-19T15:42:56.648107  #

    2023-04-19T15:42:56.749046  / # export SHELL=3D/bin/sh. /lava-10049266/=
environment

    2023-04-19T15:42:56.749222  =


    2023-04-19T15:42:56.849890  / # . /lava-10049266/environment/lava-10049=
266/bin/lava-test-runner /lava-10049266/1

    2023-04-19T15:42:56.850212  =


    2023-04-19T15:42:56.854822  / # /lava-10049266/bin/lava-test-runner /la=
va-10049266/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400ae115e00341a92e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400ae115e00341a92e85fb
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:37:54.656100  + set +x<8>[   10.555537] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10049279_1.4.2.3.1>

    2023-04-19T15:37:54.656218  =


    2023-04-19T15:37:54.758834  #

    2023-04-19T15:37:54.759186  =


    2023-04-19T15:37:54.860249  / # #export SHELL=3D/bin/sh

    2023-04-19T15:37:54.860488  =


    2023-04-19T15:37:54.961478  / # export SHELL=3D/bin/sh. /lava-10049279/=
environment

    2023-04-19T15:37:54.961696  =


    2023-04-19T15:37:55.062648  / # . /lava-10049279/environment/lava-10049=
279/bin/lava-test-runner /lava-10049279/1

    2023-04-19T15:37:55.063016  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400ae07a00180ec12e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400ae07a00180ec12e85eb
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:38:03.817455  + <8>[    8.612801] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10049256_1.4.2.3.1>

    2023-04-19T15:38:03.817546  set +x

    2023-04-19T15:38:03.922078  / # #

    2023-04-19T15:38:04.023123  export SHELL=3D/bin/sh

    2023-04-19T15:38:04.023364  #

    2023-04-19T15:38:04.124316  / # export SHELL=3D/bin/sh. /lava-10049256/=
environment

    2023-04-19T15:38:04.124550  =


    2023-04-19T15:38:04.225520  / # . /lava-10049256/environment/lava-10049=
256/bin/lava-test-runner /lava-10049256/1

    2023-04-19T15:38:04.225868  =


    2023-04-19T15:38:04.230427  / # /lava-10049256/bin/lava-test-runner /la=
va-10049256/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64400a4b2426f4083d2e8610

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400a4b2426f4083d2e8615
        failing since 82 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-19T15:35:31.125104  + set +x
    2023-04-19T15:35:31.125294  [    9.397527] <LAVA_SIGNAL_ENDRUN 0_dmesg =
931050_1.5.2.3.1>
    2023-04-19T15:35:31.233015  / # #
    2023-04-19T15:35:31.334627  export SHELL=3D/bin/sh
    2023-04-19T15:35:31.335020  #
    2023-04-19T15:35:31.436273  / # export SHELL=3D/bin/sh. /lava-931050/en=
vironment
    2023-04-19T15:35:31.436783  =

    2023-04-19T15:35:31.538049  / # . /lava-931050/environment/lava-931050/=
bin/lava-test-runner /lava-931050/1
    2023-04-19T15:35:31.538621  =

    2023-04-19T15:35:31.541012  / # /lava-931050/bin/lava-test-runner /lava=
-931050/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400b1cc5d7f409332e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-272-g462a824b77c9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400b1cc5d7f409332e85f0
        failing since 22 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-19T15:38:49.135280  <8>[   12.026223] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10049323_1.4.2.3.1>

    2023-04-19T15:38:49.240381  / # #

    2023-04-19T15:38:49.341433  export SHELL=3D/bin/sh

    2023-04-19T15:38:49.341678  #

    2023-04-19T15:38:49.442655  / # export SHELL=3D/bin/sh. /lava-10049323/=
environment

    2023-04-19T15:38:49.442904  =


    2023-04-19T15:38:49.543857  / # . /lava-10049323/environment/lava-10049=
323/bin/lava-test-runner /lava-10049323/1

    2023-04-19T15:38:49.544227  =


    2023-04-19T15:38:49.548591  / # /lava-10049323/bin/lava-test-runner /la=
va-10049323/1

    2023-04-19T15:38:49.554004  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
