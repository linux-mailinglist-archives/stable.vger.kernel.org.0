Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8B66E79E4
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDSMoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 08:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjDSMob (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 08:44:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A13C15
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 05:44:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2496863c2c7so1470834a91.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 05:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681908269; x=1684500269;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=J8bCMQ6BXjprpxvEW+CWEkQbIvtp3xMZ6RW3FJ+zhoI=;
        b=tWZaFeesUImVOGBSvxa4kbXthIqcfqz21D1vzt2wniLVusGv2xDgmavrnWDkZ07jsJ
         GSiZsLRrotg1VzPXB9fu1uegoZyMNz+zlenD/T3NXNOIMSag4CdeA0w3SU+Lx73caWA/
         iW3Mm8kxQNUQrGmAhBJ+y43Y6MrgPSs/Dw0ojdt8O2MJd8Udv3ntZca1se2lkLsrQA8C
         tBOekCqia5yTLjfy2rR5U7qyzyk79W/iCsmhPc2+tYsOUY9GwB59rodKVWATeFUR19Sh
         /iBtRIqrA9TVXFxdevZMedPDmMFCeIb+8gcAqNSDHnRdqDpSxBkTMsxVWH7XEq4EN2IT
         a9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681908269; x=1684500269;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J8bCMQ6BXjprpxvEW+CWEkQbIvtp3xMZ6RW3FJ+zhoI=;
        b=G6RFL3HVrViEpwEfM9Bvf5wmBu7VsqUc9P6fjaL+yWPE3ifo6x/I5XI4nk/HLzRFm7
         01ZTzWfFRrlR4f7wh232RVgL0/S5s9UY/OI7ptBkmBUOpZB9jYAGrVZPA6xyZ6hdOeDV
         hllIEoyAENii6ez+1ZglsisvKAaENp5u4Af11IkYTvsywSK09ZhBrRGFebTFvYeSWUMM
         zQTP7qHq8epTVRj+g0HaS8derkJIeuSmfz+mM7iy+hZpLukHtqWE50BxgwAeUq9/O3RC
         HXkX72pxZ/laFJZIP8HGmskHzWnlclVjjfhqp+vM7oujHZ9fRA1H7n0gGvBCcPDdaq2p
         oslg==
X-Gm-Message-State: AAQBX9do/TIL9gRYc3WVGlIVsVvPqe8UX+4lFbQ07VJwVQ/D1UobEqtB
        cVehfhgkAJaVmVqewtEWd0FyjBNw8YOyc8z09dkHo9Uz
X-Google-Smtp-Source: AKy350a5eut2z2VEHOQ5mmyyyR2121rqhKZRLo2804Zv8NQWWVS/fr0dZWm5Xh952WdBewhTZcPBSA==
X-Received: by 2002:a17:90a:ce18:b0:23f:5247:3334 with SMTP id f24-20020a17090ace1800b0023f52473334mr3099250pju.19.1681908269239;
        Wed, 19 Apr 2023 05:44:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902860200b001a80ae1196fsm2491209plo.39.2023.04.19.05.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 05:44:28 -0700 (PDT)
Message-ID: <643fe22c.170a0220.4b53d.5ce8@mx.google.com>
Date:   Wed, 19 Apr 2023 05:44:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-293-gcb6f60118144
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 6 regressions (v5.10.176-293-gcb6f60118144)
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

stable-rc/queue/5.10 baseline: 171 runs, 6 regressions (v5.10.176-293-gcb6f=
60118144)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-293-gcb6f60118144/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-293-gcb6f60118144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb6f601181446ed9de9b013528bedb7bdab07bca =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643faffcf0ef52c2ff2e861b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643faffcf0ef52c2ff2e8620
        failing since 82 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-19T09:10:05.590415  <8>[   11.081453] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3511118_1.5.2.4.1>
    2023-04-19T09:10:05.702582  / # #
    2023-04-19T09:10:05.806452  export SHELL=3D/bin/sh
    2023-04-19T09:10:05.807497  #
    2023-04-19T09:10:05.909950  / # export SHELL=3D/bin/sh. /lava-3511118/e=
nvironment
    2023-04-19T09:10:05.911431  =

    2023-04-19T09:10:06.013878  / # . /lava-3511118/environment/lava-351111=
8/bin/lava-test-runner /lava-3511118/1
    2023-04-19T09:10:06.015742  =

    2023-04-19T09:10:06.020456  / # /lava-3511118/bin/lava-test-runner /lav=
a-3511118/1
    2023-04-19T09:10:06.107119  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fafd12077be77bd2e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fafd12077be77bd2e85f9
        failing since 19 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-19T09:09:21.913762  + set +x

    2023-04-19T09:09:21.920145  <8>[   10.889446] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10042868_1.4.2.3.1>

    2023-04-19T09:09:22.025250  / # #

    2023-04-19T09:09:22.126306  export SHELL=3D/bin/sh

    2023-04-19T09:09:22.126511  #

    2023-04-19T09:09:22.227460  / # export SHELL=3D/bin/sh. /lava-10042868/=
environment

    2023-04-19T09:09:22.227688  =


    2023-04-19T09:09:22.328603  / # . /lava-10042868/environment/lava-10042=
868/bin/lava-test-runner /lava-10042868/1

    2023-04-19T09:09:22.328924  =


    2023-04-19T09:09:22.333282  / # /lava-10042868/bin/lava-test-runner /la=
va-10042868/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fae25db1f57cb462e861d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fae25db1f57cb462e8622
        failing since 19 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-19T09:02:18.200275  + set +x<8>[   13.186442] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10042865_1.4.2.3.1>

    2023-04-19T09:02:18.200411  =


    2023-04-19T09:02:18.302551  #

    2023-04-19T09:02:18.403826  / # #export SHELL=3D/bin/sh

    2023-04-19T09:02:18.404041  =


    2023-04-19T09:02:18.504993  / # export SHELL=3D/bin/sh. /lava-10042865/=
environment

    2023-04-19T09:02:18.505199  =


    2023-04-19T09:02:18.606151  / # . /lava-10042865/environment/lava-10042=
865/bin/lava-test-runner /lava-10042865/1

    2023-04-19T09:02:18.606471  =


    2023-04-19T09:02:18.611284  / # /lava-10042865/bin/lava-test-runner /la=
va-10042865/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643fb175cfafde8cb12e85f8

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643fb175cfafde8cb12e85fe
        failing since 36 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-19T09:16:31.425722  /lava-10043207/1/../bin/lava-test-case

    2023-04-19T09:16:31.436770  <8>[   35.071297] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643fb175cfafde8cb12e85ff
        failing since 36 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-19T09:16:29.363923  <8>[   32.997622] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-19T09:16:30.390826  /lava-10043207/1/../bin/lava-test-case

    2023-04-19T09:16:30.402032  <8>[   34.035709] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fafa3c50ecce9d72e86af

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gcb6f60118144/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fafa3c50ecce9d72e86b4
        failing since 76 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-19T09:08:22.571191  / # #
    2023-04-19T09:08:22.672908  export SHELL=3D/bin/sh
    2023-04-19T09:08:22.673262  #
    2023-04-19T09:08:22.774561  / # export SHELL=3D/bin/sh. /lava-3511117/e=
nvironment
    2023-04-19T09:08:22.774918  =

    2023-04-19T09:08:22.876262  / # . /lava-3511117/environment/lava-351111=
7/bin/lava-test-runner /lava-3511117/1
    2023-04-19T09:08:22.876905  =

    2023-04-19T09:08:22.882481  / # /lava-3511117/bin/lava-test-runner /lav=
a-3511117/1
    2023-04-19T09:08:22.946560  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-19T09:08:22.986313  + cd /lava-3511117/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
