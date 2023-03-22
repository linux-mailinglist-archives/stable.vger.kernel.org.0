Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC786C3F71
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 02:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjCVBMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 21:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCVBMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 21:12:23 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9048A1C7E7
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 18:12:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso22016807pjb.3
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 18:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679447542;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=troyXz+JIntlPAydHX+Kur0DCTqysGWwsPJ/mCzyL/g=;
        b=qQTB+S5PsFkloiP15CCLqbiC7PwKxgrbkMhaEOq7+rTNK1XsVdPE0d4HQmQiKWd1fp
         Z0czbDuwDHRP0orKvvc50IzXY/GL854HB9ZEGLcwTuLvZQsG91qko/Di63ov+0qUreMh
         c4fzrleaBCXfsx1qykjOptM3RKhlLNdrbQ+Gw+23GeKxIKazBmOlmIQzBqQ7pkc548jR
         QIiVP1mD77nXhwPhFgLL9hxW35av122VuOrLqjjI8YU3b12Fi0BiNxOdYYr3ujlVgjWZ
         3nCutThwyJL0g4wRp2lJ3SmaOn5k2H3H835D4iXbZBzvQf7om5rom3WylVGMPv5pFxDJ
         D1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447542;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=troyXz+JIntlPAydHX+Kur0DCTqysGWwsPJ/mCzyL/g=;
        b=6ODWEwpZrL5ARVWFmU3WJRtIi1R3eAK99te+G4qAMb/ii2LnGVu4pZcvCH/UMc3NTv
         IQNPokkOUOTR5+DPPoSGTdXIyQ3NX/YDrcQTg8BEPXzQuwxakOxLeTX+AINbktg/jX2C
         vW7I/7CYQgdq9RHwv6qftwoFq4XH4RzJN2tEJ4I8EtAFYQMvmdoi/SB4suv1nhr+khvl
         sw6IEihUD/+N1RpMoOP1+4OSEH/z/E0vJJPV0ZvPhLaYsJZiBpt2NUoRsCw1PtUyMhS4
         npaLsi/I4hJKBbiU0A/9YbfWCRYLXiTLJfpSiCV+m25gaoARaJHCTQdRbN+OJcpXUWh6
         Ff0g==
X-Gm-Message-State: AAQBX9fYLDeogtECbuJUk4irEeIcp0L3TtGJ9YC+PbBJrozufDtCwj3I
        rXKWq+ZCIMAHLWiz+WeoUQvbL2CDkWXQwWQAL9T8wg==
X-Google-Smtp-Source: AKy350Y/rphuzbE0QT8MsYpWjoNoeZjX+NN0vu9xExcORtbM/pG6kdF6J3aKwhQ87K06iDotwIoaww==
X-Received: by 2002:a17:902:ec8f:b0:19c:eaab:653d with SMTP id x15-20020a170902ec8f00b0019ceaab653dmr489251plg.15.1679447541779;
        Tue, 21 Mar 2023 18:12:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iw21-20020a170903045500b0019aa8149cb9sm9452649plb.79.2023.03.21.18.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:12:21 -0700 (PDT)
Message-ID: <641a55f5.170a0220.72396.19de@mx.google.com>
Date:   Tue, 21 Mar 2023 18:12:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.175-98-g8076323939d8f
Subject: stable-rc/queue/5.10 baseline: 138 runs,
 5 regressions (v5.10.175-98-g8076323939d8f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 138 runs, 5 regressions (v5.10.175-98-g80763=
23939d8f)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =

cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-98-g8076323939d8f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-98-g8076323939d8f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8076323939d8f9646b0aaa5498c793e84a4addaf =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/641a1d85bd6148a86e9c951e

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641a1d85bd6148a86e9c9551
        failing since 35 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-21T21:11:12.586720  <8>[   19.920244] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 203353_1.5.2.4.1>
    2023-03-21T21:11:12.694940  / # #
    2023-03-21T21:11:12.798204  export SHELL=3D/bin/sh
    2023-03-21T21:11:12.799081  #
    2023-03-21T21:11:12.901376  / # export SHELL=3D/bin/sh. /lava-203353/en=
vironment
    2023-03-21T21:11:12.902251  =

    2023-03-21T21:11:13.004647  / # . /lava-203353/environment/lava-203353/=
bin/lava-test-runner /lava-203353/1
    2023-03-21T21:11:13.006048  =

    2023-03-21T21:11:13.010471  / # /lava-203353/bin/lava-test-runner /lava=
-203353/1
    2023-03-21T21:11:13.111350  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641a1fb6a7ee84e9099c9546

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641a1fb6a7ee84e9099c954f
        failing since 54 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-21T21:20:22.749317  <8>[   11.065676] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3432710_1.5.2.4.1>
    2023-03-21T21:20:22.856573  / # #
    2023-03-21T21:20:22.958713  export SHELL=3D/bin/sh
    2023-03-21T21:20:22.959148  #
    2023-03-21T21:20:23.060475  / # export SHELL=3D/bin/sh. /lava-3432710/e=
nvironment
    2023-03-21T21:20:23.060896  =

    2023-03-21T21:20:23.061133  / # <3>[   11.291178] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-03-21T21:20:23.162412  . /lava-3432710/environment/lava-3432710/bi=
n/lava-test-runner /lava-3432710/1
    2023-03-21T21:20:23.162977  =

    2023-03-21T21:20:23.168005  / # /lava-3432710/bin/lava-test-runner /lav=
a-3432710/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/641a1c6ee10d7c6ff59c951c

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641a1c6ee10d7c6ff59c9526
        failing since 7 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-21T21:06:37.982262  /lava-9721892/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641a1c6ee10d7c6ff59c9527
        failing since 7 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-21T21:06:36.944707  /lava-9721892/1/../bin/lava-test-case

    2023-03-21T21:06:36.956329  <8>[   61.000892] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641a1f24d8dbd168719c9535

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-98-g8076323939d8f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641a1f24d8dbd168719c953e
        failing since 48 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-21T21:18:05.010029  / # #
    2023-03-21T21:18:05.111912  export SHELL=3D/bin/sh
    2023-03-21T21:18:05.112323  #
    2023-03-21T21:18:05.213736  / # export SHELL=3D/bin/sh. /lava-3432709/e=
nvironment
    2023-03-21T21:18:05.214163  =

    2023-03-21T21:18:05.315612  / # . /lava-3432709/environment/lava-343270=
9/bin/lava-test-runner /lava-3432709/1
    2023-03-21T21:18:05.316416  =

    2023-03-21T21:18:05.320549  / # /lava-3432709/bin/lava-test-runner /lav=
a-3432709/1
    2023-03-21T21:18:05.384566  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-21T21:18:05.419318  + cd /lava-3432709/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
