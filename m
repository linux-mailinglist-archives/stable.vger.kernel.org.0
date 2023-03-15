Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F8C6BB469
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 14:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjCONVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 09:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjCONVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 09:21:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D355BDAE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 06:21:46 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v21so9862691ple.9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 06:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678886505;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=38Kqg+5waYRsK4dIZRzQbdEJ8GP4dGvoZCkgIh+E8Hc=;
        b=3i+O6e02JheF4dSyY0T2MGIGniL5XtTngpcsQIKvYWR4jORbFlYPfeiUqpXlHw6JMg
         XfTSofbOt6etcapOAuAmfooN0qkx31o+d5VhElTUwNYXpztE6t3Q2jRll9jNGrvPDZ0Q
         ck20wNDNM6c3yVS0+866gx11SIbirT8ZM4IQ2oSox9MPkJ15X+dCRAaxq/8xibtonh9M
         Vi9uVZ73BeQUrPs+L6tNWPOj4SnrcbYCOLSIz9Ufv4oIfvHgENhu2CLf1GrDeNMsNoE+
         2JsMDwGYmrv/TsCI6y+7LVEFY6BRN6rdyBa+y7o5/6fTrS+Ex/BQGvGbCgmXrdC15yQ1
         VUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678886505;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=38Kqg+5waYRsK4dIZRzQbdEJ8GP4dGvoZCkgIh+E8Hc=;
        b=bQ20eUzuGWneC1TA1bpD0aDYw9M2mlNNCw3ru2fmOdNZTiMhLavm2WLN3g94LU4kpA
         VKSP/VbDgzRSw2ysz0dG0SNfAAn3T5QlpSVR4WKsZ8xrKU9gYuafTLbbJL2bxg2CZtDt
         00yY/92ZZPn5TuTdbNzuNT5u5wFhLmrnmX+lyzPVCgYJ3KSj7R8LZdyHMDlLNBzvTrxW
         IdHuEvXfFWH/+x8Q1oZo1oZxDML9/xL4jiEsQQVhdPSnxXOfluBLY/cP7FSQmUPNem29
         iEYjWwOPR2k76l7lC6ECWnyJtW0OwZOuEENcrpxzvLUjj18Z2uxvhj6q+gMSLo9vUHOp
         A+5A==
X-Gm-Message-State: AO0yUKX+1A2zNbElVKyTFmr0l4t1xkaTnQ2KRIxQuWypltO4eWG6NkYK
        P9BiVmXlsybgtuHHqmqfTdAa8fdxUcJRPBuM7yOnFkie
X-Google-Smtp-Source: AK7set9+9hQuOerjr2Zj6Ksenvp5CwhIO9P4vEJNLHA2waYfSdUM071N1Wb6biS7Jrpnw+67JUouLg==
X-Received: by 2002:a05:6a21:6d95:b0:d6:5102:45ea with SMTP id wl21-20020a056a216d9500b000d6510245eamr1911678pzb.39.1678886505307;
        Wed, 15 Mar 2023 06:21:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16-20020aa78110000000b006251e1fdd1fsm3484298pfi.200.2023.03.15.06.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 06:21:44 -0700 (PDT)
Message-ID: <6411c668.a70a0220.2c38a.714b@mx.google.com>
Date:   Wed, 15 Mar 2023 06:21:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-107-gce2ebcbb3458
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 11 regressions (v5.10.173-107-gce2ebcbb3458)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 11 regressions (v5.10.173-107-gce2=
ebcbb3458)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.173-107-gce2ebcbb3458/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-107-gce2ebcbb3458
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce2ebcbb345857570f59d57a220a0be439e5c9fe =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411937baf7a6a891b8c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411937baf7a6a891b8c8=
656
        new failure (last pass: v5.10.173-89-gbb0818a7908b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641193a530ed2ec8b98c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641193a530ed2ec8b98c8=
645
        new failure (last pass: v5.10.173-89-gbb0818a7908b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411937db1f67b422a8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411937db1f67b422a8c8=
631
        new failure (last pass: v5.10.173-89-gbb0818a7908b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64119361bd9116527f8c8692

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64119361bd9116527f8c86c9
        failing since 29 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-15T09:43:39.637842  <8>[   18.676676] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 165948_1.5.2.4.1>
    2023-03-15T09:43:39.791888  / # #
    2023-03-15T09:43:39.907818  export SHELL=3D/bin/sh
    2023-03-15T09:43:39.913104  #
    2023-03-15T09:43:40.021439  / # export SHELL=3D/bin/sh. /lava-165948/en=
vironment
    2023-03-15T09:43:40.027051  =

    2023-03-15T09:43:40.136592  / # . /lava-165948/environment/lava-165948/=
bin/lava-test-runner /lava-165948/1
    2023-03-15T09:43:40.145499  =

    2023-03-15T09:43:40.149225  / # /lava-165948/bin/lava-test-runner /lava=
-165948/1
    2023-03-15T09:43:40.255434  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64119367487356f8588c864b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64119367487356f8588c8654
        failing since 47 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-15T09:43:41.686268  <8>[   10.942784] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3412917_1.5.2.4.1>
    2023-03-15T09:43:41.796740  / # #
    2023-03-15T09:43:41.900199  export SHELL=3D/bin/sh
    2023-03-15T09:43:41.900955  #
    2023-03-15T09:43:42.002754  / # export SHELL=3D/bin/sh. /lava-3412917/e=
nvironment
    2023-03-15T09:43:42.003764  =

    2023-03-15T09:43:42.105813  / # . /lava-3412917/environment/lava-341291=
7/bin/lava-test-runner /lava-3412917/1
    2023-03-15T09:43:42.107107  =

    2023-03-15T09:43:42.110820  / # /lava-3412917/bin/lava-test-runner /lav=
a-3412917/1<3>[   11.371076] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-15T09:43:42.111250   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411938f30ed2ec8b98c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411938f30ed2ec8b98c8=
634
        new failure (last pass: v5.10.173-89-gbb0818a7908b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411937caf7a6a891b8c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411937caf7a6a891b8c8=
659
        new failure (last pass: v5.10.173-89-gbb0818a7908b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6411937aaf7a6a891b8c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411937aaf7a6a891b8c8=
633
        new failure (last pass: v5.10.173-89-gbb0818a7908b) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/641190c0186eb515a78c862f

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641190c0186eb515a78c863d
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T09:32:25.660794  /lava-9627678/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641190c0186eb515a78c863e
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T09:32:23.600939  <8>[   33.005740] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-15T09:32:24.623941  /lava-9627678/1/../bin/lava-test-case

    2023-03-15T09:32:24.634798  <8>[   34.040178] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64119259bf2bf4cfa18c86d4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-gce2ebcbb3458/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64119259bf2bf4cfa18c86dd
        failing since 41 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-15T09:39:23.360979  / # #
    2023-03-15T09:39:23.462661  export SHELL=3D/bin/sh
    2023-03-15T09:39:23.463013  #
    2023-03-15T09:39:23.564310  / # export SHELL=3D/bin/sh. /lava-3412918/e=
nvironment
    2023-03-15T09:39:23.564897  =

    2023-03-15T09:39:23.666441  / # . /lava-3412918/environment/lava-341291=
8/bin/lava-test-runner /lava-3412918/1
    2023-03-15T09:39:23.667344  =

    2023-03-15T09:39:23.672386  / # /lava-3412918/bin/lava-test-runner /lav=
a-3412918/1
    2023-03-15T09:39:23.770413  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-15T09:39:23.771196  + cd /lava-3412918/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
