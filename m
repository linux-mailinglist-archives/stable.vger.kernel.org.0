Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C408D6EF85B
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjDZQXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 12:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDZQXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 12:23:51 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779BBE6E
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 09:23:50 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a920d4842bso55570155ad.2
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 09:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682526229; x=1685118229;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=67Vu5GYpksd3eyM3qBT0gJtYBfGWmBWACDNiWa+T5yY=;
        b=R37vzGAFmF/WZcKNZd8/FZhBC5pmG7EkD/lRSFyaNsIkMFOjRYZ3JjuXT9XDUjqBzM
         piyo/VVS2XQEakW71DQYUNDFLrNrxZvooih6bfcY0SdvpP/P0LjDRx7NhQNoDEqKR4pp
         ltKawfdh/1Hxc5gjyfHma/YgzCJ8rblSMQ2nhjiLNh+8vl84/+zQxxOojjOmAnRxS4JJ
         w7W+Gvkll4WUF8VVPBN7SFEkpj1LkKsUAbFoP/cTM5Nqi303XXm5XarRvi8nwr8S3RyE
         w0ehoHJIfIN5HBJvqaWaZ4uRC4TdtF7JgGAAooM3qmmc7P5wpNMzEPPrVQT+0LUZv8wY
         Hvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682526229; x=1685118229;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67Vu5GYpksd3eyM3qBT0gJtYBfGWmBWACDNiWa+T5yY=;
        b=PLAtdenBWneeWL2w0VfvLOGBQ+NbLEjjAdHCfB6rqMGQpRck8uPlI2eWJw87O3M27h
         h/kj7TRHpsrerY00owGvtr3FRXke5R08C3JDacrMjbSu808t649AQDXX0jWUoNm7hyCU
         2jjfp2sI9nhvDVMOfjDbuLmL39xHYIMW+zZ+yB0RByo+TaglxjO6qhK5VROgTT8Lgfj3
         2004n9wR/nBiam+5HZMMfLIVPgHgxwFtdRbbVbz42JCeOAnlz3RlvCa8rd2mBBvC8MwG
         nvkPDA6bd6gfpZ3E45uO3EykOaBBjtXcP/GzRJ47yymtYknhGaCNaqZJDvjLENB/QhCN
         kOpA==
X-Gm-Message-State: AAQBX9d29QqM5fRaXroavxTgukaH7sluWZW1zuwDf/TlOGtNjcjNnADk
        bLRg4mV1wh1dn2ux8L7f1sM+T4RhEZF5+T8v2nmEPQ==
X-Google-Smtp-Source: AKy350YEfbfSH+6138Oc0qENAhFAK9j7n88F/aE4wnADiKaibkVsbAfqoXozacVieeOx26ANvU50Gg==
X-Received: by 2002:a17:903:228d:b0:1a6:565a:16cb with SMTP id b13-20020a170903228d00b001a6565a16cbmr27105811plh.3.1682526229422;
        Wed, 26 Apr 2023 09:23:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709027d8b00b0019aaab3f9d7sm10119918plm.113.2023.04.26.09.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 09:23:48 -0700 (PDT)
Message-ID: <64495014.170a0220.a4f94.43e1@mx.google.com>
Date:   Wed, 26 Apr 2023 09:23:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-362-gbf5d822d0e7f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 92 runs,
 5 regressions (v5.10.176-362-gbf5d822d0e7f)
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

stable-rc/queue/5.10 baseline: 92 runs, 5 regressions (v5.10.176-362-gbf5d8=
22d0e7f)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-362-gbf5d822d0e7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-362-gbf5d822d0e7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf5d822d0e7fd140fde48eacf7a00ad1a33e867e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644919954684fd94d22e85e7

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644919954684fd94d22e861d
        failing since 71 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-26T12:30:54.851962  <8>[   19.188009] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 389929_1.5.2.4.1>
    2023-04-26T12:30:54.960753  / # #
    2023-04-26T12:30:55.063876  export SHELL=3D/bin/sh
    2023-04-26T12:30:55.064783  #
    2023-04-26T12:30:55.166780  / # export SHELL=3D/bin/sh. /lava-389929/en=
vironment
    2023-04-26T12:30:55.167353  =

    2023-04-26T12:30:55.268931  / # . /lava-389929/environment/lava-389929/=
bin/lava-test-runner /lava-389929/1
    2023-04-26T12:30:55.269935  =

    2023-04-26T12:30:55.274365  / # /lava-389929/bin/lava-test-runner /lava=
-389929/1
    2023-04-26T12:30:55.381056  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644916b7b7bee89b7d2e8603

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644916b7b7bee89b7d2e8608
        failing since 27 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-26T12:18:55.418844  + <8>[   14.503187] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10130148_1.4.2.3.1>

    2023-04-26T12:18:55.418952  set +x

    2023-04-26T12:18:55.520456  #

    2023-04-26T12:18:55.520776  =


    2023-04-26T12:18:55.621441  / # #export SHELL=3D/bin/sh

    2023-04-26T12:18:55.621661  =


    2023-04-26T12:18:55.722143  / # export SHELL=3D/bin/sh. /lava-10130148/=
environment

    2023-04-26T12:18:55.722337  =


    2023-04-26T12:18:55.822832  / # . /lava-10130148/environment/lava-10130=
148/bin/lava-test-runner /lava-10130148/1

    2023-04-26T12:18:55.823131  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644916ca0edccbeaa62e862f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644916ca0edccbeaa62e8634
        failing since 27 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-26T12:19:10.206150  + set +x

    2023-04-26T12:19:10.212660  <8>[   11.671038] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10130184_1.4.2.3.1>

    2023-04-26T12:19:10.314549  =


    2023-04-26T12:19:10.415091  / # #export SHELL=3D/bin/sh

    2023-04-26T12:19:10.415289  =


    2023-04-26T12:19:10.515830  / # export SHELL=3D/bin/sh. /lava-10130184/=
environment

    2023-04-26T12:19:10.516063  =


    2023-04-26T12:19:10.616593  / # . /lava-10130184/environment/lava-10130=
184/bin/lava-test-runner /lava-10130184/1

    2023-04-26T12:19:10.616881  =


    2023-04-26T12:19:10.621820  / # /lava-10130184/bin/lava-test-runner /la=
va-10130184/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/644921b55dab7af4ab2e860b

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gbf5d822d0e7f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/644921b55dab7af4ab2e8611
        failing since 43 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-26T13:05:45.405298  /lava-10130609/1/../bin/lava-test-case

    2023-04-26T13:05:45.416279  <8>[   62.083989] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/644921b55dab7af4ab2e8612
        failing since 43 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-26T13:05:44.369742  /lava-10130609/1/../bin/lava-test-case

    2023-04-26T13:05:44.381082  <8>[   61.048603] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
