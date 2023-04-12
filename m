Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CEA6DF8AF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 16:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbjDLOh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 10:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjDLOhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 10:37:21 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA6E93E1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 07:36:48 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n14so36720646plc.8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 07:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681310206; x=1683902206;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vm7HuDCEA6CVYVCwQuC2dCDiNlhqxnDCrfOLiRhrjnY=;
        b=jtSNLMA8s3ZSdCUpNnBk+BV1ApIgTtRFDUhhIasJl21T2/EAQB6NbaJ9rl8Q6OzFav
         4Hf8QCTTQCyyyzIIIOKrwn0H+oPbhF9GRpQnbw29gWDPyv2jtJVUFEdNXOtppbWakMX3
         VKI7GgrwA74gZiSC2UM1B5me0tM3Nd0Q97XYJoOjKU4rNz6h7zEGWVte+GFnCSdwzp3a
         um1ZtJeviyPCia8VQoWrQo92Hg08P7583sFEBWUUAuOIQEKRbVrYaT7oAO5BEFFNTMVj
         I88TUtU5+W2bUf9iQ4RHu/3vsBpXKokxOTnkHnVRDhjHUWZeOB1cAAlzQF7k0kAlpfpn
         J/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681310206; x=1683902206;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vm7HuDCEA6CVYVCwQuC2dCDiNlhqxnDCrfOLiRhrjnY=;
        b=rU2NoZA0tXNBYBekm2BjOHSSHE2Y93P2B87hw7ijPUtdL6WaOyrw/8COk5BcDBnAVP
         M3ojw7eIZu6+NQKoF0kBzGrhTsTCwgJ+T4F8QSg4xTaVRlbWRQ2EkE5Ivq3C0Dq4gQ96
         23oqGJAiYUa+gvuxcpmUviORQgo8P6dqutlIzYAmsI9Akx7QC3WFkC5nOUWwyuAP70Au
         eCZPmtH2esiQrZYwjtF5zyTvD5+fJFFIOxoDpMIC0vHYO15XDGJNgLH4TfkwOhwD68MM
         8Zn3/pLKDCtMRN/IUVc8eJoCRk2CFiEDpjCgsnt+4TR2rHEqWiYqvD940FWumLOjOes6
         wWoA==
X-Gm-Message-State: AAQBX9fkTfWi+VsMR98BZRfjplmrQgfkxbwE8P5qJD6ZFO/MgA9+2Ohj
        b2egCb4FjvXEQx5UVY1uDQ76UzJTrqXtvcnZlro=
X-Google-Smtp-Source: AKy350ZS4GjH5/K++JhfgO0wAcDQun42Anh2oHP8fPRNq95G7MdHJomcejyfFXos8iNkjf7Feghohg==
X-Received: by 2002:a17:902:e1cc:b0:1a4:fe85:ab05 with SMTP id t12-20020a170902e1cc00b001a4fe85ab05mr14382259pla.48.1681310206191;
        Wed, 12 Apr 2023 07:36:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9-20020a170902b08900b0019e8915b1b5sm11677588plr.105.2023.04.12.07.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 07:36:45 -0700 (PDT)
Message-ID: <6436c1fd.170a0220.a5b44.805a@mx.google.com>
Date:   Wed, 12 Apr 2023 07:36:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-224-g10e9fd53dc59
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 188 runs,
 8 regressions (v5.10.176-224-g10e9fd53dc59)
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

stable-rc/linux-5.10.y baseline: 188 runs, 8 regressions (v5.10.176-224-g10=
e9fd53dc59)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

r8a774a1-hihope-rzg2m-ex     | arm64  | lab-cip       | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-224-g10e9fd53dc59/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-224-g10e9fd53dc59
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10e9fd53dc595489ab53b6349760e4abaf849226 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64368cf30fa5764e3a2e862b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64368cf30fa5764e3a2e8630
        failing since 84 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-12T10:50:12.140201  <8>[   11.160192] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3488734_1.5.2.4.1>
    2023-04-12T10:50:12.253137  / # #
    2023-04-12T10:50:12.355049  export SHELL=3D/bin/sh
    2023-04-12T10:50:12.355410  #
    2023-04-12T10:50:12.456525  / # export SHELL=3D/bin/sh. /lava-3488734/e=
nvironment
    2023-04-12T10:50:12.456960  =

    2023-04-12T10:50:12.457185  / # . /lava-3488734/environment<3>[   11.45=
1313] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-12T10:50:12.558286  /lava-3488734/bin/lava-test-runner /lava-34=
88734/1
    2023-04-12T10:50:12.558923  =

    2023-04-12T10:50:12.563413  / # /lava-3488734/bin/lava-test-runner /lav=
a-3488734/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64369167268fb2bebe2e85f8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64369167268fb2bebe2e85fd
        failing since 39 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-04-12T11:09:18.662403  [   11.406173] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1198046_1.5.2.4.1>
    2023-04-12T11:09:18.768046  / # #
    2023-04-12T11:09:18.869815  export SHELL=3D/bin/sh
    2023-04-12T11:09:18.870359  #
    2023-04-12T11:09:18.971713  / # export SHELL=3D/bin/sh. /lava-1198046/e=
nvironment
    2023-04-12T11:09:18.972200  =

    2023-04-12T11:09:19.073570  / # . /lava-1198046/environment/lava-119804=
6/bin/lava-test-runner /lava-1198046/1
    2023-04-12T11:09:19.074454  =

    2023-04-12T11:09:19.076279  / # /lava-1198046/bin/lava-test-runner /lav=
a-1198046/1
    2023-04-12T11:09:19.093967  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64368ad97c11f321482e85ee

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64368ad97c11f321482e85f3
        failing since 14 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-12T10:41:11.058842  + set +x

    2023-04-12T10:41:11.065096  <8>[    8.024081] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9947119_1.4.2.3.1>

    2023-04-12T10:41:11.170263  / # #

    2023-04-12T10:41:11.271342  export SHELL=3D/bin/sh

    2023-04-12T10:41:11.271557  #

    2023-04-12T10:41:11.372504  / # export SHELL=3D/bin/sh. /lava-9947119/e=
nvironment

    2023-04-12T10:41:11.372712  =


    2023-04-12T10:41:11.473687  / # . /lava-9947119/environment/lava-994711=
9/bin/lava-test-runner /lava-9947119/1

    2023-04-12T10:41:11.474003  =


    2023-04-12T10:41:11.478950  / # /lava-9947119/bin/lava-test-runner /lav=
a-9947119/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64368a4d0301f9c1252e8617

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64368a4d0301f9c1252e861c
        failing since 14 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-12T10:38:49.012476  + set +x

    2023-04-12T10:38:49.019580  <8>[   11.314774] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9947051_1.4.2.3.1>

    2023-04-12T10:38:49.129034  =


    2023-04-12T10:38:49.231370  / # #export SHELL=3D/bin/sh

    2023-04-12T10:38:49.232172  =


    2023-04-12T10:38:49.334085  / # export SHELL=3D/bin/sh. /lava-9947051/e=
nvironment

    2023-04-12T10:38:49.334886  =


    2023-04-12T10:38:49.436886  / # . /lava-9947051/environment/lava-994705=
1/bin/lava-test-runner /lava-9947051/1

    2023-04-12T10:38:49.438145  =


    2023-04-12T10:38:49.443961  / # /lava-9947051/bin/lava-test-runner /lav=
a-9947051/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64368c9a513bc3483d2e85e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64368c9a513bc3483d2e8=
5e8
        failing since 20 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a774a1-hihope-rzg2m-ex     | arm64  | lab-cip       | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/64368fe30e2164344e2e85fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseli=
ne-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseli=
ne-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64368fe30e2164344e2e8=
5fb
        new failure (last pass: v5.10.176-174-g7d617ad89b616) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64368eb10c5fb328942e8640

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-224-g10e9fd53dc59/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64368eb10c5fb328942e8646
        failing since 29 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-12T10:57:47.044679  /lava-9947620/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64368eb10c5fb328942e8647
        failing since 29 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-12T10:57:46.007239  /lava-9947620/1/../bin/lava-test-case

    2023-04-12T10:57:46.018727  <8>[   34.000052] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
