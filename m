Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51ED26EC1A8
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjDWStg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 14:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjDWStf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 14:49:35 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD7E170F
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 11:49:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b4960b015so3048585b3a.3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 11:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682275768; x=1684867768;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NrkEndb3GSVx0hwAGiDkkrCR0ZnITQyUM314hs7iQf8=;
        b=bJVFVCqgp+zwcMMzaqmQ2zXLYN8LlhtaaKQxF1G4ikApeonhHDeIzytv100kt71zmD
         wDFNytnqdJ1+iNTzTEunJV2bCJXH7WrIwSkPuptNd6RfahYIaAB+74L+H1I3Ia5wt/KU
         PuN8+szOeDP4cd3kogsL1f8F7UZhbZplQlmVT/vtlFSsJ3t1N1GWBi2P0PmemGFE8Sd+
         IYJE4OZYAheIncywfkHrmBpnzmfYAGvzqvuZzGDY44JDM8Qo+OtP2x+wnZozJlsp1jRk
         3yeac5aYhRL3A+4CPntdtAI3zt3BGOXyFAuAw2DqRNphSm7srTBGc28D2fxywiGR/Xvh
         z03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682275768; x=1684867768;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NrkEndb3GSVx0hwAGiDkkrCR0ZnITQyUM314hs7iQf8=;
        b=WX3u7iFAC5C6NppuFpA5K8QDcyiUAnj6cKQGzEZbkaw+nGh6EaYSQC/Ao341e45s+i
         LueFUyzAjMnSOcbVkUgRd+2Y2CK5OHFPVrA6eSuPSwVv5+laWCqMVCIz3E6tXwJ1WPCk
         /3n4oW5+S3gc3XS2iCTDz4nDF7Uou1TnrCsYHqyUiVRpEnJ/iR45uGTy0voM8YwObub3
         ZOqiJ5J2Qt3vPeIkeUP2ZNNfDNS+b9Jy0S8HJKUbmUGucCqaIFWzqS/+WVsA7AhUa/1/
         DH94W6tJIjzx2QvRBLv1/aVmrBqZ7Do0bVNLi2ogVtjzpPTCElwDf6lcBUecApc7XLwU
         uQ8A==
X-Gm-Message-State: AC+VfDz3st2vM4iHk4QBpgkQaQJdaPnWhuNB0mo6gIfzg1nzANJvImpr
        ar1g7PViPLriM+yE55dzrp5D0IXns6DHCgtx6SqugA==
X-Google-Smtp-Source: ACHHUZ5iuZd88bCxUVcVvHJ6edASeGEs6L/sm14OEVcZjhKUkHtq2PBPxC/h6F9EJGnRBj+g6OqvOg==
X-Received: by 2002:a17:902:ea02:b0:1a9:7bf4:17c0 with SMTP id s2-20020a170902ea0200b001a97bf417c0mr106775plg.4.1682275768513;
        Sun, 23 Apr 2023 11:49:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d90200b001a6dc4a98f9sm5338819plz.195.2023.04.23.11.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 11:49:28 -0700 (PDT)
Message-ID: <64457db8.170a0220.1fe06.b06f@mx.google.com>
Date:   Sun, 23 Apr 2023 11:49:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-348-g13f9a2e131347
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 7 regressions (v5.10.176-348-g13f9a2e131347)
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

stable-rc/queue/5.10 baseline: 132 runs, 7 regressions (v5.10.176-348-g13f9=
a2e131347)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-348-g13f9a2e131347/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-348-g13f9a2e131347
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13f9a2e131347ad8eae7bccd76f366262953666b =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64454d284bd120e56c2e85f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64454d284bd120e56c2e8=
5f3
        new failure (last pass: v5.10.176-341-g1d5db9e9c890e) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64454823c882b870d82e85fb

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454823c882b870d82e8627
        failing since 68 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-23T15:00:33.734238  <8>[   18.738169] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 374287_1.5.2.4.1>
    2023-04-23T15:00:33.843049  / # #
    2023-04-23T15:00:33.944814  export SHELL=3D/bin/sh
    2023-04-23T15:00:33.945354  #
    2023-04-23T15:00:34.046800  / # export SHELL=3D/bin/sh. /lava-374287/en=
vironment
    2023-04-23T15:00:34.047341  =

    2023-04-23T15:00:34.148803  / # . /lava-374287/environment/lava-374287/=
bin/lava-test-runner /lava-374287/1
    2023-04-23T15:00:34.149576  =

    2023-04-23T15:00:34.154416  / # /lava-374287/bin/lava-test-runner /lava=
-374287/1
    2023-04-23T15:00:34.255907  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644544d4da928df2bf2e85fa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644544d4da928df2bf2e85ff
        failing since 87 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-23T14:46:16.200184  + set +x<8>[   11.133856] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3524309_1.5.2.4.1>
    2023-04-23T14:46:16.200781  =

    2023-04-23T14:46:16.309911  / # #
    2023-04-23T14:46:16.411964  export SHELL=3D/bin/sh
    2023-04-23T14:46:16.412332  #
    2023-04-23T14:46:16.513699  / # export SHELL=3D/bin/sh. /lava-3524309/e=
nvironment
    2023-04-23T14:46:16.514450  =

    2023-04-23T14:46:16.616697  / # . /lava-3524309/environment/lava-352430=
9/bin/lava-test-runner /lava-3524309/1
    2023-04-23T14:46:16.617388  =

    2023-04-23T14:46:16.622638  / # /lava-3524309/bin/lava-test-runner /lav=
a-3524309/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454648415ed7bbab2e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454648415ed7bbab2e8600
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-23T14:52:41.529449  + set +x

    2023-04-23T14:52:41.535802  <8>[   10.979259] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10093508_1.4.2.3.1>

    2023-04-23T14:52:41.640963  / # #

    2023-04-23T14:52:41.742036  export SHELL=3D/bin/sh

    2023-04-23T14:52:41.742330  #

    2023-04-23T14:52:41.843346  / # export SHELL=3D/bin/sh. /lava-10093508/=
environment

    2023-04-23T14:52:41.843614  =


    2023-04-23T14:52:41.944650  / # . /lava-10093508/environment/lava-10093=
508/bin/lava-test-runner /lava-10093508/1

    2023-04-23T14:52:41.945067  =


    2023-04-23T14:52:41.949580  / # /lava-10093508/bin/lava-test-runner /la=
va-10093508/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64454602627d28489f2e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64454602627d28489f2e85f9
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-23T14:51:33.867388  + set +x<8>[   12.541597] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10093456_1.4.2.3.1>

    2023-04-23T14:51:33.867828  =


    2023-04-23T14:51:33.975497  #

    2023-04-23T14:51:34.078494  / # #export SHELL=3D/bin/sh

    2023-04-23T14:51:34.079254  =


    2023-04-23T14:51:34.181048  / # export SHELL=3D/bin/sh. /lava-10093456/=
environment

    2023-04-23T14:51:34.181541  =


    2023-04-23T14:51:34.282844  / # . /lava-10093456/environment/lava-10093=
456/bin/lava-test-runner /lava-10093456/1

    2023-04-23T14:51:34.283725  =


    2023-04-23T14:51:34.288821  / # /lava-10093456/bin/lava-test-runner /la=
va-10093456/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64454316d39eac183b2e85e6

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-348-g13f9a2e131347/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64454316d39eac183b2e85ec
        failing since 40 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-23T14:39:04.855961  /lava-10093117/1/../bin/lava-test-case

    2023-04-23T14:39:04.866833  <8>[   33.329971] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64454316d39eac183b2e85ed
        failing since 40 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-23T14:39:02.794981  <8>[   31.256749] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-23T14:39:03.818805  /lava-10093117/1/../bin/lava-test-case

    2023-04-23T14:39:03.829481  <8>[   32.292843] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
