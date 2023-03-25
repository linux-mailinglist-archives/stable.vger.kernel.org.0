Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7D6C8C13
	for <lists+stable@lfdr.de>; Sat, 25 Mar 2023 08:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjCYHH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Mar 2023 03:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjCYHH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Mar 2023 03:07:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F48166CE
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 00:07:26 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so7078135pjb.4
        for <stable@vger.kernel.org>; Sat, 25 Mar 2023 00:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679728045;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IuY0m8HZcPhBzzY3Odb1xZzYGcPdqnlrMCudh4rUpkw=;
        b=Uu0lkoGIh/G2GPACl0gSehP6AqGaptd12oaC7Pl0OBIIULDXoQ9HEKK7w4yyNwdQho
         GTdddcpHkl3glcojIdBtQ10hJWBrCyzmi2NxevAQYIH04k8QjAEkvh8uR9Ytit4B1u6F
         oDVPqF/is8qUBGzi/TrbF9OyihJ6nGLMSnuDUWxL3QiskD64KTtZtq7HsoA6Lk/okz/4
         ojtrTuz9MX3IvQxxFAt9Oq1VPHSrTdpLtrLbHrhlB4EqOSF/kX14lJHaLQoVvCKIVo5O
         CiGbuJD3NHP5IhOr5P9dmK7qwSuIidKMMYTRdTTlCjKxrznkykBLI5Wmy07Ol3ulfKom
         XjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679728045;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IuY0m8HZcPhBzzY3Odb1xZzYGcPdqnlrMCudh4rUpkw=;
        b=TiLUUlypTbi/G0RsvOhx4Hf7jgQ1ept03oHgclR5wxm7rdE9A87hQ5ka67gxSc5mQd
         vHaR6NU1YovP4d3QJxBLd5bZxWYIErX6nApugqcEEPRQC9oNoCvn9Si3vez1K5lUFnlt
         brWjRyTbomLD0/MmhC67XCB4qvU/a5PRHNBhKQ7N/DZPw/JsaLWIPVzDMGTtGA+860Qr
         +jjJNDWwLQuhua1mPuvalT8N0HqCwEp3iOj3rEClbHBuIg+ghi1ID5XQTka4Y7NTLfSv
         avUCK5hcHTLwAe+MdEHbWETidYo7opwXLY6ZAAOfIQLASeKPG64egp5cYQRAS1g5YUtC
         7zSQ==
X-Gm-Message-State: AO0yUKXYFBWr9FP1Ts8sk0Xf+grArU6bf0dik7ZYGvCYN5bopMqdpWb9
        +cc+6NlbRGkxilQqp3MT2sjzPMYPzSdCDRKjjjq9Lg==
X-Google-Smtp-Source: AK7set9Nw4rhHwe6AeUUscFS6eS2lBf9afz65T0fk/nKcGe6W5dEL860nNzBZcXpVYvcMsZHaJy9Fg==
X-Received: by 2002:a05:6a20:bb12:b0:db:7116:2a48 with SMTP id fc18-20020a056a20bb1200b000db71162a48mr4752683pzb.57.1679728045453;
        Sat, 25 Mar 2023 00:07:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bs187-20020a6328c4000000b0050f74d435e6sm10529598pgb.18.2023.03.25.00.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 00:07:25 -0700 (PDT)
Message-ID: <641e9dad.630a0220.e61b4.3902@mx.google.com>
Date:   Sat, 25 Mar 2023 00:07:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-19-g73d274d59cbec
Subject: stable-rc/queue/5.10 baseline: 183 runs,
 5 regressions (v5.10.176-19-g73d274d59cbec)
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

stable-rc/queue/5.10 baseline: 183 runs, 5 regressions (v5.10.176-19-g73d27=
4d59cbec)

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
nel/v5.10.176-19-g73d274d59cbec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-19-g73d274d59cbec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73d274d59cbec581f0e9701971dec691c04e9181 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/641e66d6e819c9191a9c9506

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641e66d6e819c9191a9c953b
        failing since 39 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-25T03:12:53.675359  <8>[   16.948762] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 226161_1.5.2.4.1>
    2023-03-25T03:12:53.828884  / # #
    2023-03-25T03:12:53.949369  export SHELL=3D/bin/sh
    2023-03-25T03:12:53.954561  #
    2023-03-25T03:12:54.064360  / # export SHELL=3D/bin/sh. /lava-226161/en=
vironment
    2023-03-25T03:12:54.069302  =

    2023-03-25T03:12:54.179235  / # . /lava-226161/environment/lava-226161/=
bin/lava-test-runner /lava-226161/1
    2023-03-25T03:12:54.187662  =

    2023-03-25T03:12:54.191288  / # /lava-226161/bin/lava-test-runner /lava=
-226161/1
    2023-03-25T03:12:54.300334  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641e68b84e09f9760f9c957c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641e68b84e09f9760f9c9585
        failing since 57 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-25T03:20:57.804910  + set +x<8>[   11.078871] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3442952_1.5.2.4.1>
    2023-03-25T03:20:57.805581  =

    2023-03-25T03:20:57.916218  / # #
    2023-03-25T03:20:58.017915  export SHELL=3D/bin/sh
    2023-03-25T03:20:58.018976  #
    2023-03-25T03:20:58.121047  / # export SHELL=3D/bin/sh. /lava-3442952/e=
nvironment
    2023-03-25T03:20:58.121681  =

    2023-03-25T03:20:58.223406  / # . /lava-3442952/environment/lava-344295=
2/bin/lava-test-runner /lava-3442952/1
    2023-03-25T03:20:58.225153  =

    2023-03-25T03:20:58.225850  / # <3>[   11.450923] Bluetooth: hci0: comm=
and 0xfc18 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/641e69541941f38afa9c9527

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641e69541941f38afa9c9531
        failing since 11 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-25T03:23:45.958502  /lava-9770449/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641e69541941f38afa9c9532
        failing since 11 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-25T03:23:44.921841  /lava-9770449/1/../bin/lava-test-case

    2023-03-25T03:23:44.932754  <8>[   34.153770] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/641e683dddffaaab969c95cd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-19-g73d274d59cbec/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641e683dddffaaab969c95d6
        failing since 51 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-25T03:19:05.375300  / # #
    2023-03-25T03:19:05.477049  export SHELL=3D/bin/sh
    2023-03-25T03:19:05.477457  #
    2023-03-25T03:19:05.578828  / # export SHELL=3D/bin/sh. /lava-3442948/e=
nvironment
    2023-03-25T03:19:05.579345  =

    2023-03-25T03:19:05.680732  / # . /lava-3442948/environment/lava-344294=
8/bin/lava-test-runner /lava-3442948/1
    2023-03-25T03:19:05.681512  =

    2023-03-25T03:19:05.686741  / # /lava-3442948/bin/lava-test-runner /lav=
a-3442948/1
    2023-03-25T03:19:05.774744  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-25T03:19:05.775346  + cd /lava-3442948/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
