Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD666C5D2B
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 04:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCWD0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 23:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCWD0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 23:26:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C25F2449D
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 20:26:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u5so21101780plq.7
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 20:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679541967;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GueOvVl7rutkM/Ad2d6Dd68EmRolGzzcZOInXyn3Y0w=;
        b=hYkn2EPGcabeasDPCWq6ag1z0k24mdpwbgZ4N9aDuszxceztxCUM3DG4fAElYqob2n
         ruBbgWb6gGdEHyUxQdvwQt7RmsI46jvfNPAXKoeoPoCs3PEBdtxwlrwrLFkPrisYbhK+
         6eZeAI+5/UMZ3XM3reoTR1AZeNC4yKNi2J8pW6TsSHS2XBwlSdMrt6XMNIpIK/0C8Nfw
         eL8ym+RCLNVl3Ibvpgfr25uSBdnlj/GMgy87cboyr6oZq4EE1K6nzESynNEsfBb6aoM3
         3cNmUBUrKpDWlWHgIBVBH3BRdptL/DR2K5rUHaLLJEBB6DT0z/5eQh072GGsSP1p/1YQ
         Hdjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679541967;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GueOvVl7rutkM/Ad2d6Dd68EmRolGzzcZOInXyn3Y0w=;
        b=E5VSGJUH4pTXNs5iWhhq0oLV+BXO+ROjOdowi33sUQvrYo6zQvtzbXBKMxTCMGn8W0
         Osp15Lr5+3nAUej/plZkPeHt9lvEifFGw1QRftMYqViYpKDn9voJOKShGxkxa0euO7ir
         JACXMPqK9OkzqGaWC+lBbuWdAEHpvHZRBBMycBWIpIfWatThIt1/CQbkO9FFbqx/srns
         IJuv2RQ8WijMa28liXm1/Yb7FcARQT6tQCXs2EqyItALKiL8iZTHmu1dZaUjIlpt2+uT
         CC3el6jLafH9LreFOkeM1e3mSfTd40QskPys/EoGCyQK6YVTEw8tPS06h0aPucmyRjTo
         H2LA==
X-Gm-Message-State: AO0yUKUXO97WekXdeU7OO9dz2rWcirJsm38VTsYfs6SH6iR5cbRCZ4/Y
        uqEn7jA0J4KJ7QTgo3YaIE8MTWyAoQ1uZVrl6OENmg==
X-Google-Smtp-Source: AK7set9sKRNO+pSkzKqEPInXYf2laO1SQXUzjsLru7ScqC8gV9sraQ4TfFmtTTa2XAN9Y84+RWZQcw==
X-Received: by 2002:a17:902:d486:b0:19a:ad2f:2df9 with SMTP id c6-20020a170902d48600b0019aad2f2df9mr6761614plg.55.1679541967477;
        Wed, 22 Mar 2023 20:26:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jf9-20020a170903268900b001967580f60fsm11226150plb.260.2023.03.22.20.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 20:26:07 -0700 (PDT)
Message-ID: <641bc6cf.170a0220.26406.4f42@mx.google.com>
Date:   Wed, 22 Mar 2023 20:26:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-18-gb3194d89d7e27
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 5 regressions (v5.10.176-18-gb3194d89d7e27)
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

stable-rc/queue/5.10 baseline: 175 runs, 5 regressions (v5.10.176-18-gb3194=
d89d7e27)

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
nel/v5.10.176-18-gb3194d89d7e27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-18-gb3194d89d7e27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3194d89d7e27b1a95c494c53aeb2825fee404d6 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/641b93e04623078aee9c9508

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b93e04623078aee9c9541
        failing since 37 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-22T23:48:26.185637  <8>[   19.938254] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 211734_1.5.2.4.1>
    2023-03-22T23:48:26.295966  / # #
    2023-03-22T23:48:26.398316  export SHELL=3D/bin/sh
    2023-03-22T23:48:26.398867  #
    2023-03-22T23:48:26.500518  / # export SHELL=3D/bin/sh. /lava-211734/en=
vironment
    2023-03-22T23:48:26.501105  =

    2023-03-22T23:48:26.602628  / # . /lava-211734/environment/lava-211734/=
bin/lava-test-runner /lava-211734/1
    2023-03-22T23:48:26.603532  =

    2023-03-22T23:48:26.607187  / # /lava-211734/bin/lava-test-runner /lava=
-211734/1
    2023-03-22T23:48:26.707270  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641b919a54a92c07829c9505

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b919a54a92c07829c950e
        failing since 55 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-22T23:38:51.576149  <8>[   11.117393] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3436184_1.5.2.4.1>
    2023-03-22T23:38:51.683763  / # #
    2023-03-22T23:38:51.785238  export SHELL=3D/bin/sh
    2023-03-22T23:38:51.785654  #
    2023-03-22T23:38:51.886918  / # export SHELL=3D/bin/sh. /lava-3436184/e=
nvironment
    2023-03-22T23:38:51.887488  =

    2023-03-22T23:38:51.887791  / # <3>[   11.380891] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-22T23:38:51.989203  . /lava-3436184/environment/lava-3436184/bi=
n/lava-test-runner /lava-3436184/1
    2023-03-22T23:38:51.989888  =

    2023-03-22T23:38:51.994743  / # /lava-3436184/bin/lava-test-runner /lav=
a-3436184/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/641b93334f10313a859c9509

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641b93334f10313a859c9513
        failing since 8 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-22T23:45:51.314555  /lava-9740836/1/../bin/lava-test-case

    2023-03-22T23:45:51.326083  <8>[   34.905915] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641b93334f10313a859c9514
        failing since 8 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-22T23:45:50.277818  /lava-9740836/1/../bin/lava-test-case

    2023-03-22T23:45:50.289126  <8>[   33.868898] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641b90e502884f41249c952d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-18-gb3194d89d7e27/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b90e502884f41249c9535
        failing since 49 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-22T23:35:36.225067  / # #
    2023-03-22T23:35:36.326790  export SHELL=3D/bin/sh
    2023-03-22T23:35:36.327225  #
    2023-03-22T23:35:36.428518  / # export SHELL=3D/bin/sh. /lava-3436190/e=
nvironment
    2023-03-22T23:35:36.428896  =

    2023-03-22T23:35:36.530223  / # . /lava-3436190/environment/lava-343619=
0/bin/lava-test-runner /lava-3436190/1
    2023-03-22T23:35:36.531130  =

    2023-03-22T23:35:36.536389  / # /lava-3436190/bin/lava-test-runner /lav=
a-3436190/1
    2023-03-22T23:35:36.635355  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-22T23:35:36.635995  + cd /lava-3436190/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
