Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221EC6EC124
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 18:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjDWQpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 12:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDWQpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 12:45:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54C910DB
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 09:45:01 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a6715ee82fso41745765ad.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 09:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682268301; x=1684860301;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2tfe0g1SYcDKFp+/dg9Q2Civs6tdLOgtMogxMxQJBks=;
        b=Hb8832a3jAvI6mGNhgXq0qs9sx2cSISjmEi/u1608YIq1RYAPZQrMDrf4aHwgvb+ar
         fDyV0n13WD19UhxbhUfogQaLAiVVPGpan3ythjt6dhpV3YudIqvkxuNJPGYx/5usqc7Q
         UkugOEJJIZdidmkIBxP5o6MH3aqxP4uSO/b3uCdZm3MgN+Q3lyOciGpSOoTyf+aap90v
         sdyIjjWdT1ZdZ85Z7HybczNMm9cHUJzC+oNU4YKu85kDBgltuLWWN85NawwhYHHJxqxK
         gJ5yZsUA+DtYuylKm/NU4TxHk8ROiD5+NfErWPgr989LT6/yFwvWDeHdfsyswV2Sjq2T
         9ADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682268301; x=1684860301;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2tfe0g1SYcDKFp+/dg9Q2Civs6tdLOgtMogxMxQJBks=;
        b=i9KG8KAfPe8c/GWnrM3dAXGqYC4RCwnfnz7RV4JKUY9vqggEbtOx4HUA0Mk0lWeqEH
         b+W+Oh9+O3jwTkJBT6hC5/ujfj8PhGHuZFLujgh9jP3IYKTFI0p8T6rnBblOuqeNqEm9
         86PvdOK+GEgcVbi9E/JnC+xrK0/IfGzZrvO1k4wSNvX32Vs3M399h6URNM60KuyMFrs2
         5O2LyBk3RBPRKCWbXNPo15SKq4ZGYNnBFKpOt+R11y+MAyfRPE5wTVZcR6OdQ4ZO8DLV
         t3fDIq91HueBVcc0B3fN7y64l2aUzrgtXeGN2XuQNtlx8T1RmzRjHEhH/WSRuW5khfql
         ILyA==
X-Gm-Message-State: AAQBX9crHYghevHTQiNUbXK3IGUXu+ebJPIMAQDkviBQwaCw4tWLsRY4
        t8Mpc5p0Q7SMcQ9H5DjKtzKpDJF6JRXk1Jzitfz/Iw==
X-Google-Smtp-Source: AKy350bQyOn0SeIgKC8DnJCQgX9/k5ghbVnHVcOxErc9gkA7SXA1ppBexLoPVgxkcR3b9OUD2DvhqQ==
X-Received: by 2002:a17:902:fa87:b0:19a:9890:eac6 with SMTP id lc7-20020a170902fa8700b0019a9890eac6mr10792296plb.24.1682268300807;
        Sun, 23 Apr 2023 09:45:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id az11-20020a170902a58b00b001a1ed2fce9asm3785211plb.235.2023.04.23.09.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 09:45:00 -0700 (PDT)
Message-ID: <6445608c.170a0220.bfa74.6d7e@mx.google.com>
Date:   Sun, 23 Apr 2023 09:45:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-341-g1d5db9e9c890e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 135 runs,
 5 regressions (v5.10.176-341-g1d5db9e9c890e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 135 runs, 5 regressions (v5.10.176-341-g1d5d=
b9e9c890e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-341-g1d5db9e9c890e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-341-g1d5db9e9c890e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d5db9e9c890e87d6fe4d34acd3b33f0616b5251 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64452d344e9db802d72e869f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64452d344e9db802d72e86a4
        failing since 87 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-23T13:05:40.221181  <8>[   11.065765] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3523947_1.5.2.4.1>
    2023-04-23T13:05:40.328569  / # #
    2023-04-23T13:05:40.430277  export SHELL=3D/bin/sh
    2023-04-23T13:05:40.430726  #
    2023-04-23T13:05:40.531988  / # export SHELL=3D/bin/sh. /lava-3523947/e=
nvironment
    2023-04-23T13:05:40.532438  =

    2023-04-23T13:05:40.532668  / # <3>[   11.291347] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-23T13:05:40.633917  . /lava-3523947/environment/lava-3523947/bi=
n/lava-test-runner /lava-3523947/1
    2023-04-23T13:05:40.634613  =

    2023-04-23T13:05:40.639805  / # /lava-3523947/bin/lava-test-runner /lav=
a-3523947/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64452e8bd5d5ccb8212e862f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64452e8bd5d5ccb8212e8634
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-23T13:11:27.307565  + set +x

    2023-04-23T13:11:27.314334  <8>[    7.989189] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092389_1.4.2.3.1>

    2023-04-23T13:11:27.419497  / # #

    2023-04-23T13:11:27.520409  export SHELL=3D/bin/sh

    2023-04-23T13:11:27.520612  #

    2023-04-23T13:11:27.621546  / # export SHELL=3D/bin/sh. /lava-10092389/=
environment

    2023-04-23T13:11:27.621770  =


    2023-04-23T13:11:27.722739  / # . /lava-10092389/environment/lava-10092=
389/bin/lava-test-runner /lava-10092389/1

    2023-04-23T13:11:27.723052  =


    2023-04-23T13:11:27.727654  / # /lava-10092389/bin/lava-test-runner /la=
va-10092389/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64452e8f48a40bbe0e2e863f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64452e8f48a40bbe0e2e8644
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-23T13:11:26.582387  + set +x

    2023-04-23T13:11:26.588433  <8>[   12.371796] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092432_1.4.2.3.1>

    2023-04-23T13:11:26.697004  / # #

    2023-04-23T13:11:26.799274  export SHELL=3D/bin/sh

    2023-04-23T13:11:26.799932  #

    2023-04-23T13:11:26.901699  / # export SHELL=3D/bin/sh. /lava-10092432/=
environment

    2023-04-23T13:11:26.902372  =


    2023-04-23T13:11:27.004095  / # . /lava-10092432/environment/lava-10092=
432/bin/lava-test-runner /lava-10092432/1

    2023-04-23T13:11:27.005426  =


    2023-04-23T13:11:27.010909  / # /lava-10092432/bin/lava-test-runner /la=
va-10092432/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64453056aab2686b892e8608

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-341-g1d5db9e9c890e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64453057aab2686b892e860e
        failing since 40 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-23T13:19:07.783768  <8>[   34.025823] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-23T13:19:08.809700  /lava-10092357/1/../bin/lava-test-case

    2023-04-23T13:19:08.820302  <8>[   35.063213] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64453057aab2686b892e860f
        failing since 40 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-23T13:19:07.771402  /lava-10092357/1/../bin/lava-test-case
   =

 =20
