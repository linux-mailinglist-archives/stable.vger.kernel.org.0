Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B806C5C85
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 03:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCWCWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 22:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCWCWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 22:22:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC0993E3
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 19:22:22 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so515737pjv.5
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 19:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679538141;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rluaUWPwFu8TuohwSe11eZl2pr8Zza6rPIUwVJN0JmU=;
        b=zd0lBaZ5wOskObAKxNYjagtnOaIRfwyCcdzAixCqZp6lg1xqKpJ36Drl1dGfphVpBs
         95d3HT7Yz8KtNbpsWZiTJlF4uER8gVE5Sdjw628BbfF+hUz0svdBIPAMXeB/LiKTf+7b
         MrpnnQXg6hzo7jCgnDAXrmU1eoDcTH8MrjYAhSgzogBCY6OEM14lUV6Sp/dYERb+mIlG
         m9zEEnRxpvRWu36p9Iu++sAOB5GU23qJzrKLNDZc2Ktq/9Xq+zkE74pKvnSoUb5nnHct
         xXzRhgtcjttJNipsXlmDX7YlmvL24ffpGULT70HBwoZGFV1zEAXoV5Schybo17BlLCbu
         su+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679538141;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rluaUWPwFu8TuohwSe11eZl2pr8Zza6rPIUwVJN0JmU=;
        b=KB6DwLSBX9b1qfjACdQWIHruUUYgm1Dkxpf2enCSWmj5QutGCuP0IjesA9wRBLzxDc
         QPpovkQu3T4ZPnlaSa3em018YkbsI2gnckz1+SwPaMN0Zhe5DIrhGybhenhR6odQDVym
         NCKkLVvtw/qC3SinRAUqs01T+eXZZ6eCsdgK42mQmbkFxyYyPei3VvAHu3RRE965L6qc
         AlfgmouX+IZSI3JUiTOUxUMH6jTK5iX/Jiu2IJ2DfNx9DK5grpOIjobGvQFxbLsvzmU2
         lRfxz1INwXHJ4wUMP704dQIdyivmLk2yFCmWQazC/HzRHdQuI5a2wtQGoNaRxEGcEGA4
         usyw==
X-Gm-Message-State: AO0yUKUOEfeMku/0YLM9iC9U3N0A36uepaCgFRGTup7cI1oPLIzU0mJQ
        K31ryEhMwFamVhNqPvtFciLBpwZg9DR5am5pMCE4tg==
X-Google-Smtp-Source: AK7set9p36uc6WR/HyT5Q2Cr8CJvwPV8W6mYa7J4kVEYnRo1Qpgcmn7L0oQLyEhZbZtVIkFAtE67Vg==
X-Received: by 2002:a17:902:db10:b0:1a1:db10:7ba3 with SMTP id m16-20020a170902db1000b001a1db107ba3mr6027591plx.2.1679538141418;
        Wed, 22 Mar 2023 19:22:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17-20020a170902a41100b0019f232619d7sm11161060plq.173.2023.03.22.19.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 19:22:21 -0700 (PDT)
Message-ID: <641bb7dd.170a0220.4d728.5541@mx.google.com>
Date:   Wed, 22 Mar 2023 19:22:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176
Subject: stable-rc/linux-5.10.y baseline: 186 runs, 4 regressions (v5.10.176)
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

stable-rc/linux-5.10.y baseline: 186 runs, 4 regressions (v5.10.176)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
cubietruck        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca9787bdecfa2174b0a169a54916e22b89b0ef5b =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
cubietruck        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/641b83fa9782325bc09c95bc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b83fa9782325bc09c95c5
        failing since 63 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-22T22:40:31.025328  <8>[   11.066555] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3435904_1.5.2.4.1>
    2023-03-22T22:40:31.137553  / # #
    2023-03-22T22:40:31.241441  export SHELL=3D/bin/sh
    2023-03-22T22:40:31.242406  #
    2023-03-22T22:40:31.344338  / # export SHELL=3D/bin/sh. /lava-3435904/e=
nvironment
    2023-03-22T22:40:31.345211  =

    2023-03-22T22:40:31.447615  / # . /lava-3435904/environment/lava-343590=
4/bin/lava-test-runner /lava-3435904/1
    2023-03-22T22:40:31.448341  =

    2023-03-22T22:40:31.448565  / # <3>[   11.451243] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-22T22:40:31.453653  /lava-3435904/bin/lava-test-runner /lava-34=
35904/1 =

    ... (12 line(s) more)  =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/641b825dd25284da849c9520

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641b825dd25284da849c9=
521
        new failure (last pass: v5.10.175-100-g1686e1df6521) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 2          =


  Details:     https://kernelci.org/test/plan/id/641b83cdd402e5c97d9c9544

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641b83cdd402e5c97d9c954e
        failing since 8 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-22T22:40:04.362801  /lava-9740005/1/../bin/lava-test-case

    2023-03-22T22:40:04.373856  <8>[   35.399329] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641b83cdd402e5c97d9c954f
        failing since 8 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-22T22:40:03.325837  /lava-9740005/1/../bin/lava-test-case

    2023-03-22T22:40:03.336836  <8>[   34.362606] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
