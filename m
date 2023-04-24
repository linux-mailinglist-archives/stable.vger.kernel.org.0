Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590AF6ECC30
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDXMlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 08:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDXMls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 08:41:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074172D79
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 05:41:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b70f0b320so5992530b3a.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 05:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682340105; x=1684932105;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jT94LRe3ez+G8k+OLdtRQ/h1QJEDlpZAsP0CU+Yz7JM=;
        b=kUG9mF3ixikR8CP0MqblvmFz3A4F53t33I6pQ0tWo3opryMgjIjJ2nCyfwywTlsh63
         3WXy3OaxMajy0pDnuJTu419vEmidcUDNWVOo5tpHEj0SLzhoZ9h6zltZGVGHpl+EuxFE
         n//FjhlWVKgCk9oibYoEttxLFFrykBCoESOIXBJmWabCEtX92ORca1nl8k8haU39xnCn
         Sd5FswtSwng9jzws78eadsXcfbGSGqxXYdCfmix2urHZN7iCeOHDKVy5sLH1twMLSjc2
         Y31e9V3qWRG+Z0dGqgGlDD/UHhGh9V9SCptOOq622o4y/MmX1hCERrKurQkmvmV955hl
         2Tgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682340105; x=1684932105;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jT94LRe3ez+G8k+OLdtRQ/h1QJEDlpZAsP0CU+Yz7JM=;
        b=Rh8dapQhHGfTid1YZfIc0elrrRfVlACMRQ6HoXmHESU4/O9D0QYSy8mxWnAcZbtYxP
         Us8LeDTIZYKFaBriyPqWeacfi6zUc1MU9+KNc72PN//lALMOH23gW4e5hqiVpE/CYN/l
         +X3AjZgypqAJsWqYdX6Hnxfsnp4Ph2RhQt9gO4XRQqq/244J0KFEvMPHExkxPjd2oy/+
         X2y6xgILV4RHXbOy62KHxR9whje3wVZX/I+xHW1uTStdBzVlwT4lp2lcKRLhmdZlyrJC
         nOC8J66iO4nCV9PfgHZ69W885CFGBdrPfuFMhp79jD6KvtgyrHdo2lEnvXF1R7WDvkBN
         cr9g==
X-Gm-Message-State: AAQBX9fEe4GMTiG6GKwDyTxtyW66GcT+wyW9VKkhB1Z/5aOa5Ft06skj
        ZLrF8v4Xe9Q3gqTc5kMUtCdk3APstnmQ5vAIp+RdRw==
X-Google-Smtp-Source: AKy350ZxzKdAK9rirQyC1MwHJAqRG59P86emWQmZ34yplsdTe/ycr7DSRQNRuOhBeKoiwy+l+prouw==
X-Received: by 2002:a05:6a00:b42:b0:63d:2d99:2e72 with SMTP id p2-20020a056a000b4200b0063d2d992e72mr20285320pfo.7.1682340105033;
        Mon, 24 Apr 2023 05:41:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g2-20020a62f942000000b0063799398eaesm7322200pfm.51.2023.04.24.05.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 05:41:44 -0700 (PDT)
Message-ID: <64467908.620a0220.b088c.da9a@mx.google.com>
Date:   Mon, 24 Apr 2023 05:41:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-339-g758e4ea64e974
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 135 runs,
 10 regressions (v5.15.105-339-g758e4ea64e974)
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

stable-rc/queue/5.15 baseline: 135 runs, 10 regressions (v5.15.105-339-g758=
e4ea64e974)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-339-g758e4ea64e974/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-339-g758e4ea64e974
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      758e4ea64e974258a328b40c9ab498430d05e3a8 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642eba155571b1c2e8613

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642eba155571b1c2e8618
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:50:27.932363  <8>[   10.281580] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100798_1.4.2.3.1>

    2023-04-24T08:50:27.935712  + set +x

    2023-04-24T08:50:28.040311  / # #

    2023-04-24T08:50:28.141021  export SHELL=3D/bin/sh

    2023-04-24T08:50:28.141231  #

    2023-04-24T08:50:28.241767  / # export SHELL=3D/bin/sh. /lava-10100798/=
environment

    2023-04-24T08:50:28.241992  =


    2023-04-24T08:50:28.342517  / # . /lava-10100798/environment/lava-10100=
798/bin/lava-test-runner /lava-10100798/1

    2023-04-24T08:50:28.342802  =


    2023-04-24T08:50:28.348946  / # /lava-10100798/bin/lava-test-runner /la=
va-10100798/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642d4f2035df1b02e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642d4f2035df1b02e8600
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:50:10.087991  + set<8>[   10.905455] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10100792_1.4.2.3.1>

    2023-04-24T08:50:10.088603   +x

    2023-04-24T08:50:10.197943  / # #

    2023-04-24T08:50:10.300361  export SHELL=3D/bin/sh

    2023-04-24T08:50:10.301032  #

    2023-04-24T08:50:10.402376  / # export SHELL=3D/bin/sh. /lava-10100792/=
environment

    2023-04-24T08:50:10.403155  =


    2023-04-24T08:50:10.504811  / # . /lava-10100792/environment/lava-10100=
792/bin/lava-test-runner /lava-10100792/1

    2023-04-24T08:50:10.505971  =


    2023-04-24T08:50:10.510983  / # /lava-10100792/bin/lava-test-runner /la=
va-10100792/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642cff2035df1b02e85ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642cff2035df1b02e85f2
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:50:01.140049  <8>[   10.637224] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100837_1.4.2.3.1>

    2023-04-24T08:50:01.143105  + set +x

    2023-04-24T08:50:01.244307  #

    2023-04-24T08:50:01.244649  =


    2023-04-24T08:50:01.345235  / # #export SHELL=3D/bin/sh

    2023-04-24T08:50:01.345493  =


    2023-04-24T08:50:01.446057  / # export SHELL=3D/bin/sh. /lava-10100837/=
environment

    2023-04-24T08:50:01.446291  =


    2023-04-24T08:50:01.546821  / # . /lava-10100837/environment/lava-10100=
837/bin/lava-test-runner /lava-10100837/1

    2023-04-24T08:50:01.547151  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644645b3df6c5999dc2e8606

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644645b3df6c5999dc2e8=
607
        failing since 79 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64464220baa993e3322e8678

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64464220baa993e3322e867d
        failing since 97 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-24T08:47:18.585918  <8>[    9.849695] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3526637_1.5.2.4.1>
    2023-04-24T08:47:18.697381  / # #
    2023-04-24T08:47:18.800530  export SHELL=3D/bin/sh
    2023-04-24T08:47:18.801603  #
    2023-04-24T08:47:18.903740  / # export SHELL=3D/bin/sh. /lava-3526637/e=
nvironment
    2023-04-24T08:47:18.904849  =

    2023-04-24T08:47:19.007003  / # . /lava-3526637/environment/lava-352663=
7/bin/lava-test-runner /lava-3526637/1
    2023-04-24T08:47:19.008814  =

    2023-04-24T08:47:19.009297  / # /lava-3526637/bin/lava-test-runner /lav=
a-3526637/1<3>[   10.272675] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-24T08:47:19.013674   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642ccac444afa042e85ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642ccac444afa042e85f2
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:50:08.472734  + set +x

    2023-04-24T08:50:08.479726  <8>[   10.497243] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100806_1.4.2.3.1>

    2023-04-24T08:50:08.587211  / # #

    2023-04-24T08:50:08.689607  export SHELL=3D/bin/sh

    2023-04-24T08:50:08.690338  #

    2023-04-24T08:50:08.791776  / # export SHELL=3D/bin/sh. /lava-10100806/=
environment

    2023-04-24T08:50:08.792576  =


    2023-04-24T08:50:08.894133  / # . /lava-10100806/environment/lava-10100=
806/bin/lava-test-runner /lava-10100806/1

    2023-04-24T08:50:08.895534  =


    2023-04-24T08:50:08.900303  / # /lava-10100806/bin/lava-test-runner /la=
va-10100806/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642bdcfc65269b72e860f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642bdcfc65269b72e8614
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:49:48.010065  + set +x

    2023-04-24T08:49:48.016389  <8>[   10.334631] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100834_1.4.2.3.1>

    2023-04-24T08:49:48.118927  =


    2023-04-24T08:49:48.219576  / # #export SHELL=3D/bin/sh

    2023-04-24T08:49:48.219809  =


    2023-04-24T08:49:48.320371  / # export SHELL=3D/bin/sh. /lava-10100834/=
environment

    2023-04-24T08:49:48.320586  =


    2023-04-24T08:49:48.421121  / # . /lava-10100834/environment/lava-10100=
834/bin/lava-test-runner /lava-10100834/1

    2023-04-24T08:49:48.421462  =


    2023-04-24T08:49:48.426456  / # /lava-10100834/bin/lava-test-runner /la=
va-10100834/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642d1a0bbe4f7b82e866d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642d1a0bbe4f7b82e8672
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:50:00.355789  + <8>[   11.253624] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10100839_1.4.2.3.1>

    2023-04-24T08:50:00.355875  set +x

    2023-04-24T08:50:00.459852  / # #

    2023-04-24T08:50:00.560748  export SHELL=3D/bin/sh

    2023-04-24T08:50:00.560974  #

    2023-04-24T08:50:00.661534  / # export SHELL=3D/bin/sh. /lava-10100839/=
environment

    2023-04-24T08:50:00.661784  =


    2023-04-24T08:50:00.762376  / # . /lava-10100839/environment/lava-10100=
839/bin/lava-test-runner /lava-10100839/1

    2023-04-24T08:50:00.762686  =


    2023-04-24T08:50:00.767494  / # /lava-10100839/bin/lava-test-runner /la=
va-10100839/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64464235036a7737b12e8600

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64464235036a7737b12e8605
        failing since 86 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-24T08:47:22.706458  + set +x
    2023-04-24T08:47:22.706634  [    9.410567] <LAVA_SIGNAL_ENDRUN 0_dmesg =
935420_1.5.2.3.1>
    2023-04-24T08:47:22.813094  / # #
    2023-04-24T08:47:22.914518  export SHELL=3D/bin/sh
    2023-04-24T08:47:22.914895  #
    2023-04-24T08:47:23.016047  / # export SHELL=3D/bin/sh. /lava-935420/en=
vironment
    2023-04-24T08:47:23.016467  =

    2023-04-24T08:47:23.117503  / # . /lava-935420/environment/lava-935420/=
bin/lava-test-runner /lava-935420/1
    2023-04-24T08:47:23.117985  =

    2023-04-24T08:47:23.120860  / # /lava-935420/bin/lava-test-runner /lava=
-935420/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644642bbf701ee83f52e866b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-339-g758e4ea64e974/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644642bbf701ee83f52e8670
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T08:49:50.446566  <8>[   12.393693] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100799_1.4.2.3.1>

    2023-04-24T08:49:50.550857  / # #

    2023-04-24T08:49:50.651537  export SHELL=3D/bin/sh

    2023-04-24T08:49:50.651745  #

    2023-04-24T08:49:50.752337  / # export SHELL=3D/bin/sh. /lava-10100799/=
environment

    2023-04-24T08:49:50.752610  =


    2023-04-24T08:49:50.853173  / # . /lava-10100799/environment/lava-10100=
799/bin/lava-test-runner /lava-10100799/1

    2023-04-24T08:49:50.853502  =


    2023-04-24T08:49:50.858101  / # /lava-10100799/bin/lava-test-runner /la=
va-10100799/1

    2023-04-24T08:49:50.863691  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
