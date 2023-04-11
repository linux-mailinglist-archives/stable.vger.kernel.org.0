Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C3D6DE506
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 21:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjDKTeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 15:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDKTef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 15:34:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1AA170D
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 12:34:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id c3so9976931pjg.1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 12:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681241672; x=1683833672;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=udaNBhmE4zJRnlRMORVTnh7Uoa7hnRHfudZt5mGTq0Y=;
        b=6RgZcMhbBpnF2v8FSjVw1U8i42nsfjkr+RmnKJ4cLpg5bCK9xr4yluPouG6h067Gie
         s9sZ3GVGmJ2cTGNc3QazziKuBTvQaNobKyGs4JKRiFYkMlk9Uwd/YfxrSMJWyD8imwNT
         5/uuiZgmvsBaRy+oCzw6XGTV74Gw469TWf0TNFHLLQE8YDuEyeDZL8QIOqZB8l15nDCS
         WcflQGgUZSo6F52XCUEvvhzpjSOqNxD6geG4vu3YWvxr3IUvvgwfYvxkcQ3V1YiGAOuq
         qdWPaJ765UNeale88DBbRjT8SjSNvMSfcn0tzs2YBiHHk8vLePXGxZXKNyMi2Q8a/B+7
         FCUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681241672; x=1683833672;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udaNBhmE4zJRnlRMORVTnh7Uoa7hnRHfudZt5mGTq0Y=;
        b=mZ2h48b/2OaGv8hT0VR4gbpG9xabRHAVqygtHO5i4dgPFNVlFhBgqCRGFyU7bXzut5
         FJGK7s8jRqHLVUWOQ6EuL0WS2vA4XlgdJwGqfQJJ54CpAv92BUzu16IajdNi0OH3rkWB
         cV8iD67Qm1WlFl2cTLhcjbtKXK+218v78niNuJmsiCdSeWSKZXQnH98oOaOT+xzDiOE3
         bNp+qPptg3bnT6NPSGEyr32KU7xZO9l1SWLqMMihpxIzRrcM37ywLmHEGWHwUYJbF1V0
         +xOHEDZa2JiNu5lJO7+AOQK22OnxiZDbckPZekpPBvmJpuE8kRCXRdsIeTGtJvF0G+1B
         TCoQ==
X-Gm-Message-State: AAQBX9cwsC84Yir6ZcH98ksRB8zFxtNoksbRaAj9m1DR47gsj4/GFstt
        GqU5QyAiKlljDcVWxlcXphbVNzCd8kWssCVZSlibQw==
X-Google-Smtp-Source: AKy350bYp+KMivX2IpsSfXfNj5tX7LzMzmj8zrklRAqZtPTxamT0fJzMBe6JVkFaTSMEzraIJi6cqA==
X-Received: by 2002:a05:6a20:4c98:b0:d3:84ca:11b with SMTP id fq24-20020a056a204c9800b000d384ca011bmr15222715pzb.40.1681241671438;
        Tue, 11 Apr 2023 12:34:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23-20020aa793b7000000b00638b13ee6a7sm3855371pff.25.2023.04.11.12.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 12:34:31 -0700 (PDT)
Message-ID: <6435b647.a70a0220.a7ede.8962@mx.google.com>
Date:   Tue, 11 Apr 2023 12:34:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-223-gb73b161a0e35
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 8 regressions (v5.10.176-223-gb73b161a0e35)
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

stable-rc/queue/5.10 baseline: 180 runs, 8 regressions (v5.10.176-223-gb73b=
161a0e35)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe    | gcc-10   | defconfi=
g                    | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-223-gb73b161a0e35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-223-gb73b161a0e35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b73b161a0e35a4edef3eb348c1ae2951675604f0 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643580bd1b867fefbd2e86ad

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643580bd1b867fefbd2e86e2
        failing since 56 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-11T15:45:46.327668  <8>[   19.178841] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 311537_1.5.2.4.1>
    2023-04-11T15:45:46.438576  / # #
    2023-04-11T15:45:46.541236  export SHELL=3D/bin/sh
    2023-04-11T15:45:46.541856  #
    2023-04-11T15:45:46.643707  / # export SHELL=3D/bin/sh. /lava-311537/en=
vironment
    2023-04-11T15:45:46.644262  =

    2023-04-11T15:45:46.746499  / # . /lava-311537/environment/lava-311537/=
bin/lava-test-runner /lava-311537/1
    2023-04-11T15:45:46.747610  =

    2023-04-11T15:45:46.752126  / # /lava-311537/bin/lava-test-runner /lava=
-311537/1
    2023-04-11T15:45:46.860396  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6435821fc8cc606f882e864b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435821fc8cc606f882e8650
        failing since 75 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-11T15:51:42.579396  <8>[   14.016973] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3485897_1.5.2.4.1>
    2023-04-11T15:51:42.690823  / # #
    2023-04-11T15:51:42.793890  export SHELL=3D/bin/sh
    2023-04-11T15:51:42.794760  #
    2023-04-11T15:51:42.896670  / # export SHELL=3D/bin/sh. /lava-3485897/e=
nvironment
    2023-04-11T15:51:42.897650  =

    2023-04-11T15:51:42.999736  / # . /lava-3485897/environment/lava-348589=
7/bin/lava-test-runner /lava-3485897/1
    2023-04-11T15:51:43.001386  =

    2023-04-11T15:51:43.001876  / # /lava-3485897/bin/lava-test-runner /lav=
a-3485897/1<3>[   14.411062] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-11T15:51:43.007459   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435857c9a46d511f22e85ef

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435857c9a46d511f22e85f4
        failing since 12 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-11T16:06:04.577401  + set +x

    2023-04-11T16:06:04.583893  <8>[   10.949058] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939092_1.4.2.3.1>

    2023-04-11T16:06:04.689187  / # #

    2023-04-11T16:06:04.790434  export SHELL=3D/bin/sh

    2023-04-11T16:06:04.790653  #

    2023-04-11T16:06:04.891633  / # export SHELL=3D/bin/sh. /lava-9939092/e=
nvironment

    2023-04-11T16:06:04.891827  =


    2023-04-11T16:06:04.992529  / # . /lava-9939092/environment/lava-993909=
2/bin/lava-test-runner /lava-9939092/1

    2023-04-11T16:06:04.992805  =


    2023-04-11T16:06:04.997164  / # /lava-9939092/bin/lava-test-runner /lav=
a-9939092/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64358498f032d327372e865c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64358499f032d327372e8661
        failing since 12 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-11T16:02:15.478906  <8>[   12.408549] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9939109_1.4.2.3.1>

    2023-04-11T16:02:15.482154  + set +x

    2023-04-11T16:02:15.586909  / # #

    2023-04-11T16:02:15.687935  export SHELL=3D/bin/sh

    2023-04-11T16:02:15.688163  #

    2023-04-11T16:02:15.789151  / # export SHELL=3D/bin/sh. /lava-9939109/e=
nvironment

    2023-04-11T16:02:15.789370  =


    2023-04-11T16:02:15.890323  / # . /lava-9939109/environment/lava-993910=
9/bin/lava-test-runner /lava-9939109/1

    2023-04-11T16:02:15.890623  =


    2023-04-11T16:02:15.895283  / # /lava-9939109/bin/lava-test-runner /lav=
a-9939109/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643585326d43f1ca212e8605

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643585326d43f1ca212e860b
        failing since 28 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-11T16:04:48.151695  /lava-9939164/1/../bin/lava-test-case

    2023-04-11T16:04:48.162628  <8>[   35.071411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643585326d43f1ca212e860c
        failing since 28 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-11T16:04:46.092869  <8>[   33.000558] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-11T16:04:47.116675  /lava-9939164/1/../bin/lava-test-case

    2023-04-11T16:04:47.127360  <8>[   34.036061] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe    | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64358375c262fad10e2e8647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64358375c262fad10e2e8=
648
        new failure (last pass: v5.10.176-216-gf7cdb9db2411) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643581ffe8e82db63b2e861c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gb73b161a0e35/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643581ffe8e82db63b2e8621
        failing since 68 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-11T15:51:16.837767  / # #
    2023-04-11T15:51:16.939534  export SHELL=3D/bin/sh
    2023-04-11T15:51:16.939986  #
    2023-04-11T15:51:17.041344  / # export SHELL=3D/bin/sh. /lava-3485894/e=
nvironment
    2023-04-11T15:51:17.041782  =

    2023-04-11T15:51:17.143121  / # . /lava-3485894/environment/lava-348589=
4/bin/lava-test-runner /lava-3485894/1
    2023-04-11T15:51:17.143796  =

    2023-04-11T15:51:17.148853  / # /lava-3485894/bin/lava-test-runner /lav=
a-3485894/1
    2023-04-11T15:51:17.212971  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-11T15:51:17.252700  + cd /lava-3485894/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
