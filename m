Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EDB6D39F1
	for <lists+stable@lfdr.de>; Sun,  2 Apr 2023 21:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDBTLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 15:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBTLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 15:11:16 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF90AF33
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 12:11:15 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id bt19so17748746pfb.3
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 12:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680462675;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=d9E0sbb5fp9+fPeH9G9T61jMtdT6VdmCYXDrOb5MOmU=;
        b=2LDF7rSYKy55JXrhIGA3flGETcx5ou9mAAXyDxIIkR8ivL5FSoV75dYElAn8tIhk5y
         Oh6wtYCrjFLfVhl6Dsb38mLReTBjiHlOm+n6veG+v/Z8dXMZ3IgHF4F59eR3/z+GxCnL
         216etWehruvvMoj8W6twZGPhEKRg5sLx+kVOjjcTlbRPbl8Q22D5HPYG24JbZApQfsR+
         +AHD0/YZszinNWtofCTLUsdzn7ij3KdLxJ1I8lW419ccz7K1yWS4TWk7S8h04Ps4azwZ
         mAIU1ho0sTl7ThY99M0Nh4rYJZpZY7syRq2Cnw8MsMnNMf99EsMw9VJAQf5t6MRCuii4
         dCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680462675;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d9E0sbb5fp9+fPeH9G9T61jMtdT6VdmCYXDrOb5MOmU=;
        b=LI0fZsHI9zoNx7Rgih7WipcFS+Od7maZrz3IopY++xUcAdCct+VEfEmZJGkek/t/3A
         F3Py0OZbHvyAY99mNvx2+5PGBjaiDKYlo6eA11k0TEtZZBkgqAm86FDcj1E3Djq4b8T8
         IXoyaDj4y9K8/B6DbD2tRFsUq7TBhB9ku5X2sZ6b8MMz191V8z4SJoaUXfOBT5tgzceQ
         wL+yXp66kLWePvVePmx1kSPSuTZxoNNFVfBK8+ERvq4sVvJ1AFem5ofZc5ejvtiqgpzQ
         4I99ek6fFF6FcN2r+YqY7u2fazSjPN3xmFqnPyJcFUJa4KFdOU8s7W5LKztYgB6wMTav
         /12g==
X-Gm-Message-State: AAQBX9fuVkRq8a/5eTGqp5Jez37DoSYNthcscHL7YlGBeU/UZmsb03Vo
        IlWtlhd2TkNQBm9PoQw1UpV20G4A3AiyfdrCFzg=
X-Google-Smtp-Source: AKy350aoA3YMFhYxPnqghe1S2VXAofM52dfWgGT0krSKVF1tAKdLMGbIMWKmXERYGAiB//eAT1vh6Q==
X-Received: by 2002:aa7:9809:0:b0:62e:32c:b579 with SMTP id e9-20020aa79809000000b0062e032cb579mr3638428pfl.12.1680462674593;
        Sun, 02 Apr 2023 12:11:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020aa78d43000000b005aa60d8545esm5350911pfe.61.2023.04.02.12.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 12:11:14 -0700 (PDT)
Message-ID: <6429d352.a70a0220.7aaf4.a54e@mx.google.com>
Date:   Sun, 02 Apr 2023 12:11:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-87-g0b9484596642
Subject: stable-rc/queue/5.4 baseline: 116 runs,
 5 regressions (v5.4.238-87-g0b9484596642)
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

stable-rc/queue/5.4 baseline: 116 runs, 5 regressions (v5.4.238-87-g0b94845=
96642)

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
el/v5.4.238-87-g0b9484596642/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-87-g0b9484596642
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b9484596642aeb43bd415d97f1c4950fb5e10f2 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a290daea5ae20a62f7ad

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a290daea5ae20a62f7b2
        failing since 62 days (last pass: v5.4.230-81-g2ad0dc06d587, first =
fail: v5.4.230-108-g761a8268d868)

    2023-04-02T15:42:54.019913  + set +x<8>[    9.829424] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3464485_1.5.2.4.1>
    2023-04-02T15:42:54.020202  =

    2023-04-02T15:42:54.126996  / # #
    2023-04-02T15:42:54.229788  export SHELL=3D/bin/sh
    2023-04-02T15:42:54.230801  #
    2023-04-02T15:42:54.332972  / # export SHELL=3D/bin/sh. /lava-3464485/e=
nvironment
    2023-04-02T15:42:54.333943  =

    2023-04-02T15:42:54.435994  / # . /lava-3464485/environment/lava-346448=
5/bin/lava-test-runner /lava-3464485/1
    2023-04-02T15:42:54.437327  =

    2023-04-02T15:42:54.442574  / # /lava-3464485/bin/lava-test-runner /lav=
a-3464485/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64299cc489d6cc064562f78c

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/64299cc489d6cc06=
4562f795
        failing since 165 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-02T15:18:08.994429  / # =

    2023-04-02T15:18:08.995076  =

    2023-04-02T15:18:11.058012  / # #
    2023-04-02T15:18:11.058698  #
    2023-04-02T15:18:13.072593  / # export SHELL=3D/bin/sh
    2023-04-02T15:18:13.072972  export SHELL=3D/bin/sh
    2023-04-02T15:18:15.088927  / # . /lava-3464418/environment
    2023-04-02T15:18:15.089367  . /lava-3464418/environment
    2023-04-02T15:18:17.104797  / # /lava-3464418/bin/lava-test-runner /lav=
a-3464418/0
    2023-04-02T15:18:17.106024  /lava-3464418/bin/lava-test-runner /lava-34=
64418/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64299c25fd8c9b35cd62f78e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64299c25fd8c9b35cd62f793
        failing since 4 days (last pass: v5.4.238-29-g39c31e43e3b2b, first =
fail: v5.4.238-60-gcf51829325af)

    2023-04-02T15:15:30.078794  + set<8>[    9.839161] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9841985_1.4.2.3.1>

    2023-04-02T15:15:30.079351   +x

    2023-04-02T15:15:30.187441  #

    2023-04-02T15:15:30.290663  / # #export SHELL=3D/bin/sh

    2023-04-02T15:15:30.291650  =


    2023-04-02T15:15:30.393575  / # export SHELL=3D/bin/sh. /lava-9841985/e=
nvironment

    2023-04-02T15:15:30.394366  =


    2023-04-02T15:15:30.496086  / # . /lava-9841985/environment/lava-984198=
5/bin/lava-test-runner /lava-9841985/1

    2023-04-02T15:15:30.496432  =


    2023-04-02T15:15:30.501217  / # /lava-9841985/bin/lava-test-runner /lav=
a-9841985/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64299bd42a738093ec62f79a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64299bd42a738093ec62f79f
        failing since 4 days (last pass: v5.4.238-29-g39c31e43e3b2b, first =
fail: v5.4.238-60-gcf51829325af)

    2023-04-02T15:14:12.366788  + set +x

    2023-04-02T15:14:12.373485  <8>[   12.422025] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9841915_1.4.2.3.1>

    2023-04-02T15:14:12.475680  =


    2023-04-02T15:14:12.576673  / # #export SHELL=3D/bin/sh

    2023-04-02T15:14:12.576938  =


    2023-04-02T15:14:12.677954  / # export SHELL=3D/bin/sh. /lava-9841915/e=
nvironment

    2023-04-02T15:14:12.678145  =


    2023-04-02T15:14:12.779043  / # . /lava-9841915/environment/lava-984191=
5/bin/lava-test-runner /lava-9841915/1

    2023-04-02T15:14:12.779327  =


    2023-04-02T15:14:12.784461  / # /lava-9841915/bin/lava-test-runner /lav=
a-9841915/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a27385dc4bb85862f7ad

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-8=
7-g0b9484596642/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a27385dc4bb85862f7b1
        failing since 60 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-04-02T15:42:18.953413  / # #
    2023-04-02T15:42:19.055507  export SHELL=3D/bin/sh
    2023-04-02T15:42:19.056164  #
    2023-04-02T15:42:19.157587  / # export SHELL=3D/bin/sh. /lava-3464481/e=
nvironment
    2023-04-02T15:42:19.158143  =

    2023-04-02T15:42:19.259592  / # . /lava-3464481/environment/lava-346448=
1/bin/lava-test-runner /lava-3464481/1
    2023-04-02T15:42:19.260410  =

    2023-04-02T15:42:19.279956  / # /lava-3464481/bin/lava-test-runner /lav=
a-3464481/1
    2023-04-02T15:42:19.367900  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-02T15:42:19.368301  + cd /lava-3464481/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
