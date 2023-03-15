Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E196BA978
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 08:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjCOHj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 03:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCOHi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 03:38:57 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F42412B
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:37:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so935730pjg.4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 00:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678865861;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=z9hzRuyk4nrSeTWiGAlIhk25dK0oMBxJi9VTWf6eqeo=;
        b=IowXZHUVqO42+XWlL980bicdD58T3ttiBDA2V2Gzh8ZR51+8liFQs9+g6uslQIyXiM
         UQmaRiWglgO7NGLJNftUQPqymso0unsO75vESyQm8tqtc8e+S+Tqi3ZNYIX+dVhVcZ1w
         ivGkLKWx9NgMnvhsI26udFznV+D9Z3t7WPBMNzTdngw65PD7RncvH0TUF1tIqfRNTGcB
         fDdZl4XqASwW+7yaRSLzd+mu4GnhKDX4U9vIKqQhzr6CQlPocFY0WR64aewzrrW2pP6C
         xQ/XMUOOzt/AlpdUIf6Z/nxuJOzJWM5j5Ue3Etb7Lb8wK4RjgGzaABhTXRbvaIg1Z/UM
         vhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678865861;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9hzRuyk4nrSeTWiGAlIhk25dK0oMBxJi9VTWf6eqeo=;
        b=dG81mo2tHEb8N2CKS4fxBzpKmvK7VpnCFMqzZkxV0rUlw8HviEvuTGMKw8T9GJjxKm
         a1kyuxYwJPZe1P9OnqQWNUdA7RifQY6UviQF+sQHlktAvF1g2vxBp4RJsZCaV1JYUbrg
         2/Jro6zTugdXaEr/eWpAMMSmgKy773TgvSCnchl9+CQpiqZ9n8O8lFXhfE5ow9/hWsF1
         NOWoBioNYEcj14S6jCX6cVB/DJipSV/ZotyMWobGDQya6W14u8UBz3psyUE6g+ulN5NR
         GmV1c7jqaMuiioBIve2s+QYv0XcZs4tVQ+TTRdlhGJcH8nNJE8957fWVsBc6jC9xWPAX
         B9gQ==
X-Gm-Message-State: AO0yUKVGLMfK+y/c2GTG+SXTASmBxkWBivgm8nABusEUbR7LYueWRIzs
        UrLV2Fos5XdzqC2rYRZXGw7e1m58J96BU0xfrIZVwciJ
X-Google-Smtp-Source: AK7set+Xuu2ZOuOtdvXHHsbCfUQhjSg5+KElXazEHhFyFpANurKe1aphtq1ZvIKUsm4S58+3e/ndqw==
X-Received: by 2002:a05:6a20:4d8a:b0:c7:13be:fb53 with SMTP id gj10-20020a056a204d8a00b000c713befb53mr32699750pzb.3.1678865861023;
        Wed, 15 Mar 2023 00:37:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z20-20020aa785d4000000b005a8a5be96b2sm2813394pfn.104.2023.03.15.00.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 00:37:40 -0700 (PDT)
Message-ID: <641175c4.a70a0220.136b4.69a2@mx.google.com>
Date:   Wed, 15 Mar 2023 00:37:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-89-gbb0818a7908b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 176 runs,
 5 regressions (v5.10.173-89-gbb0818a7908b)
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

stable-rc/queue/5.10 baseline: 176 runs, 5 regressions (v5.10.173-89-gbb081=
8a7908b)

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
nel/v5.10.173-89-gbb0818a7908b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-89-gbb0818a7908b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb0818a7908bae8863a2ea628dd3fc43a9cdd702 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/641144ec1a95dcfed98c862f

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641144ec1a95dcfed98c8669
        failing since 29 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-15T04:08:58.859427  <8>[   20.989108] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 164345_1.5.2.4.1>
    2023-03-15T04:08:58.968297  / # #
    2023-03-15T04:08:59.070838  export SHELL=3D/bin/sh
    2023-03-15T04:08:59.071392  #
    2023-03-15T04:08:59.173313  / # export SHELL=3D/bin/sh. /lava-164345/en=
vironment
    2023-03-15T04:08:59.174210  =

    2023-03-15T04:08:59.276851  / # . /lava-164345/environment/lava-164345/=
bin/lava-test-runner /lava-164345/1
    2023-03-15T04:08:59.277994  =

    2023-03-15T04:08:59.282794  / # /lava-164345/bin/lava-test-runner /lava=
-164345/1
    2023-03-15T04:08:59.383456  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641141b3a91ebb732f8c86a4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641141b3a91ebb732f8c86ad
        failing since 47 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-15T03:55:03.337833  + set +x<8>[   10.997314] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3411623_1.5.2.4.1>
    2023-03-15T03:55:03.342734  =

    2023-03-15T03:55:03.448725  / # #
    2023-03-15T03:55:03.551792  export SHELL=3D/bin/sh
    2023-03-15T03:55:03.552793  #
    2023-03-15T03:55:03.655157  / # export SHELL=3D/bin/sh. /lava-3411623/e=
nvironment
    2023-03-15T03:55:03.656280  =

    2023-03-15T03:55:03.758492  / # . /lava-3411623/environment/lava-341162=
3/bin/lava-test-runner /lava-3411623/1
    2023-03-15T03:55:03.759861  =

    2023-03-15T03:55:03.760260  / # <3>[   11.370628] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/64114533815fc37c908c86b4

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64114533815fc37c908c8705
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T04:10:08.335806  <8>[   60.645329] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-03-15T04:10:09.360848  /lava-9622185/1/../bin/lava-test-case

    2023-03-15T04:10:09.372046  <8>[   61.682477] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64114533815fc37c908c8706
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T04:10:08.323803  /lava-9622185/1/../bin/lava-test-case
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/64114088912ff268db8c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-89-gbb0818a7908b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64114088912ff268db8c8638
        failing since 41 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-15T03:50:08.914628  / # #
    2023-03-15T03:50:09.016546  export SHELL=3D/bin/sh
    2023-03-15T03:50:09.017070  #
    2023-03-15T03:50:09.118408  / # export SHELL=3D/bin/sh. /lava-3411612/e=
nvironment
    2023-03-15T03:50:09.118916  =

    2023-03-15T03:50:09.220346  / # . /lava-3411612/environment/lava-341161=
2/bin/lava-test-runner /lava-3411612/1
    2023-03-15T03:50:09.221234  =

    2023-03-15T03:50:09.225240  / # /lava-3411612/bin/lava-test-runner /lav=
a-3411612/1
    2023-03-15T03:50:09.289360  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-15T03:50:09.324158  + cd /lava-3411612/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
