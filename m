Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE69A6D3A03
	for <lists+stable@lfdr.de>; Sun,  2 Apr 2023 21:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDBTi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBTi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 15:38:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B52903C
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 12:38:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r7-20020a17090b050700b002404be7920aso26442288pjz.5
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 12:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680464304;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dg+gvl39+PSDU0/EVZLbbJbibZWQUgC1J2cx07vZyY8=;
        b=3C9XxwMqCSLjrwkZy77KFu31+rXCQbaxyo4qAysOq1jJ+UWLqCZeD9RrA7YswneLqZ
         233PEmS3S8XDUMg1zaGGPdo7V6vmkmPtg6Ry/2sa832FgB6u3rutbLDH2RXnqGo9QTDU
         aUIHDREopS8lu3cOW8q83YOYyJRLvnHkyl2tslA9R1D9McA8WLG1cO57BlinhSevctS2
         6TiZvRQtlSKs/UjiaIt1yWbhHZIU2Je3TIoVd2poAUC78CDJPYIzB0qN29Y0hP7zgsCF
         XA6fQbFVmTRB3mNPFUd1wxW6Ay4emBwJbVYGIUbk77AVcdeUfDXT6XB3vVpuCIfMi6t4
         +7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680464304;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dg+gvl39+PSDU0/EVZLbbJbibZWQUgC1J2cx07vZyY8=;
        b=n7iuszHpKFule7xo5WHvmGGgSiuO8DvBIKe8kWdAqCOlCO53sTVIWP4Lq393U1dDYu
         oPh+TYkj8UnKB9iDzPfiquHM2ePfDNds051MmB/VO0XuxZvsFR/JotgRdruGXBorEZE8
         XE9ALZ8YJW0REXaauPAB4wriOsFUWkWjcGiYxcweHDtl2Kc0w4QWUxjJxq9jAO+vD3FU
         k0ZjwYQGO2mdCLsWtIHb8hogUF+q06yPRmHykP0jWEat2barDEG68C47VHYnDRbTXeJS
         oFIYQBNd4bxWG5rzdgeyQsEX8b42utuldwpdlC3/xyTUx3D8CCBw0dMSvX/ogx/tLPJH
         +4Vw==
X-Gm-Message-State: AAQBX9dI+J3l9vkYvGrmH+EDmNsACqTqzjCUkPuoMvgUe4NwX3BR85Og
        hI5cF1n9FTYIg3VvhbpL4GXB+w3DYfGaAs0Pg5g=
X-Google-Smtp-Source: AKy350blzqJqM9N/XBct1zhEFmdJFCcXi439KAFs+MO2P1WebstD+DovMripfdxgCbh+wi6VoroZHA==
X-Received: by 2002:a05:6a20:8c05:b0:de:808e:8f3d with SMTP id j5-20020a056a208c0500b000de808e8f3dmr16834542pzh.13.1680464304338;
        Sun, 02 Apr 2023 12:38:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11-20020aa781cb000000b00627df889420sm5517425pfn.173.2023.04.02.12.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 12:38:23 -0700 (PDT)
Message-ID: <6429d9af.a70a0220.18466.a445@mx.google.com>
Date:   Sun, 02 Apr 2023 12:38:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-143-g8f8a64155b282
Subject: stable-rc/queue/5.10 baseline: 160 runs,
 5 regressions (v5.10.176-143-g8f8a64155b282)
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

stable-rc/queue/5.10 baseline: 160 runs, 5 regressions (v5.10.176-143-g8f8a=
64155b282)

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-143-g8f8a64155b282/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-143-g8f8a64155b282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f8a64155b282adc02b30f339d3703e373b12460 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a0d034cf94b1bb62f79f

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a0d034cf94b1bb62f7d5
        failing since 47 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-02T15:35:33.620921  <8>[   26.311156] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 264813_1.5.2.4.1>
    2023-04-02T15:35:33.730782  / # #
    2023-04-02T15:35:33.834981  export SHELL=3D/bin/sh
    2023-04-02T15:35:33.836199  #
    2023-04-02T15:35:33.939941  / # export SHELL=3D/bin/sh. /lava-264813/en=
vironment
    2023-04-02T15:35:33.940601  =

    2023-04-02T15:35:34.042199  / # . /lava-264813/environment/lava-264813/=
bin/lava-test-runner /lava-264813/1
    2023-04-02T15:35:34.043061  =

    2023-04-02T15:35:34.047415  / # /lava-264813/bin/lava-test-runner /lava=
-264813/1
    2023-04-02T15:35:34.149152  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a52ebae77d78e962f7fb

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a52ebae77d78e962f800
        failing since 66 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-02T15:53:55.639471  <8>[   11.035959] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3464541_1.5.2.4.1>
    2023-04-02T15:53:55.750144  / # #
    2023-04-02T15:53:55.851864  export SHELL=3D/bin/sh
    2023-04-02T15:53:55.852690  #
    2023-04-02T15:53:55.954822  / # export SHELL=3D/bin/sh. /lava-3464541/e=
nvironment
    2023-04-02T15:53:55.955658  =

    2023-04-02T15:53:56.057569  / # . /lava-3464541/environment/lava-346454=
1/bin/lava-test-runner /lava-3464541/1
    2023-04-02T15:53:56.058922  =

    2023-04-02T15:53:56.059315  / # <3>[   11.371700] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-02T15:53:56.063427  /lava-3464541/bin/lava-test-runner /lava-34=
64541/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a6e5ef20292cfb62f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a6e5ef20292cfb62f780
        failing since 3 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-02T16:01:24.726765  + <8>[   10.722051] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9842318_1.4.2.3.1>

    2023-04-02T16:01:24.726861  set +x

    2023-04-02T16:01:24.828685  #

    2023-04-02T16:01:24.829000  =


    2023-04-02T16:01:24.929978  / # #export SHELL=3D/bin/sh

    2023-04-02T16:01:24.930229  =


    2023-04-02T16:01:25.031153  / # export SHELL=3D/bin/sh. /lava-9842318/e=
nvironment

    2023-04-02T16:01:25.031396  =


    2023-04-02T16:01:25.132372  / # . /lava-9842318/environment/lava-984231=
8/bin/lava-test-runner /lava-9842318/1

    2023-04-02T16:01:25.132715  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a71dcf44bd506d62f7a6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a71dcf44bd506d62f7ab
        failing since 3 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-02T16:02:18.993893  <8>[   12.741467] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842351_1.4.2.3.1>

    2023-04-02T16:02:18.997099  + set +x

    2023-04-02T16:02:19.099355  #

    2023-04-02T16:02:19.100462  =


    2023-04-02T16:02:19.202481  / # #export SHELL=3D/bin/sh

    2023-04-02T16:02:19.203291  =


    2023-04-02T16:02:19.304990  / # export SHELL=3D/bin/sh. /lava-9842351/e=
nvironment

    2023-04-02T16:02:19.305923  =


    2023-04-02T16:02:19.408159  / # . /lava-9842351/environment/lava-984235=
1/bin/lava-test-runner /lava-9842351/1

    2023-04-02T16:02:19.409388  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6429a35081370340ca62f78d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-143-g8f8a64155b282/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429a35081370340ca62f792
        failing since 59 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-02T15:46:04.794502  <8>[    8.516418] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3464542_1.5.2.4.1>
    2023-04-02T15:46:04.900360  / # #
    2023-04-02T15:46:05.002404  export SHELL=3D/bin/sh
    2023-04-02T15:46:05.002915  #
    2023-04-02T15:46:05.104293  / # export SHELL=3D/bin/sh. /lava-3464542/e=
nvironment
    2023-04-02T15:46:05.104809  =

    2023-04-02T15:46:05.206187  / # . /lava-3464542/environment/lava-346454=
2/bin/lava-test-runner /lava-3464542/1
    2023-04-02T15:46:05.207066  =

    2023-04-02T15:46:05.225359  / # /lava-3464542/bin/lava-test-runner /lav=
a-3464542/1
    2023-04-02T15:46:05.313236  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
