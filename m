Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C239268BE82
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjBFNml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 08:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjBFNmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 08:42:39 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127CFE38F
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 05:42:38 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b5so12138559plz.5
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 05:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2HCP/IA1WK+WSWH/Rvaw3tgjQBwMLkg9qBKfyThxH/w=;
        b=4DHeUgyd4p08f8kw8sdBV5rSCqTy0ElExRsTQjL2FPikw1XBShYezm+BRmowdxuRz6
         G/QnOl+2HjtK+04pn40kOW7S/XhdXPEqunS3ZzFJXnfNMxR7ZgOYW7+37VEIWSQrX80q
         ScvQkEZG2bpwEnQWpLaY9TL70CMtLcgLRtRpvHlkWyf4QStC9EdnQ+BBKHCX8wTjS7nI
         y/8ZjIF/g9mNRnDlWfUEK7qMKuW5aRyrOGzpQdXY/OZ8xzbTRCsko8tJvuMvU35e6yFJ
         SwEOyTfP30WhrLDsHIBZlJ0cBNgNbGs6bNBFZ3FJQjYi9/NbduKaAhTwa/yNuLKK7lw+
         Ca5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2HCP/IA1WK+WSWH/Rvaw3tgjQBwMLkg9qBKfyThxH/w=;
        b=0rJLjwRwuVaFI3qyrGqlch/H+RhIii3M71a4ceEHIU5NC+ei8WL9EcAYynaOWvJwmc
         aPIDIo8uWCrEWla/Pne7Cd+KkGwIkf8x7QIiGrMAeQ5ivldovg0vaF4lErO3cQIlvOsn
         ZTPKwA0IpmaH6OJPkzLRtVmBYSxC49ftC0aj4byqL/2g+kAEiTHePpxflsFvoF+/6kpZ
         xvw60dOKk06Tw+Y/rDl7ivV83xk9DIBsuQdgFliqrmT6nDppbmIFhXRtsvLSLgrI4v0q
         fC+/GsHEaXjDZBZdqlHNmRYVLYqjKZ9l5XoY6PqPgiYgewOH2kxR5wewK+LqYRKO1p+k
         lKqQ==
X-Gm-Message-State: AO0yUKU7oaKqg/yTfq65/8HVEBTZd65PbRjrA/azw/USdF2+K94Ow0TF
        61qPoc9OU6VkvSgqRi1ouGmTQWDvrc3kyzdhT7E=
X-Google-Smtp-Source: AK7set+UTuyuW0BVU3VD7JVPD96Gt4klQgNNOE0wztLslKIRhT5U86xho0xzUsad7K1gXMSsw37BDQ==
X-Received: by 2002:a17:902:d2c8:b0:198:b284:c2ca with SMTP id n8-20020a170902d2c800b00198b284c2camr21818798plc.51.1675690957208;
        Mon, 06 Feb 2023 05:42:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14-20020a170902e8ce00b001949c680b52sm6875742plg.193.2023.02.06.05.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 05:42:36 -0800 (PST)
Message-ID: <63e103cc.170a0220.84a1.abbd@mx.google.com>
Date:   Mon, 06 Feb 2023 05:42:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.91-20-gcb49f24ce02b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 165 runs,
 5 regressions (v5.15.91-20-gcb49f24ce02b)
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

stable-rc/queue/5.15 baseline: 165 runs, 5 regressions (v5.15.91-20-gcb49f2=
4ce02b)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =

cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.91-20-gcb49f24ce02b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.91-20-gcb49f24ce02b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb49f24ce02b811544a78059d68f692c0f325cfb =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
beagle-xm              | arm   | lab-baylibre    | gcc-10   | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0d07d9d123de55c915f52

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0d07d9d123de55c915=
f53
        failing since 2 days (last pass: v5.15.91-12-g3290f78df1ab, first f=
ail: v5.15.91-18-ga7afd81d41cb) =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cf9323b3e683de915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0cf9323b3e683de915ebe
        failing since 20 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-06T09:59:33.900421  <8>[    9.942993] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3295042_1.5.2.4.1>
    2023-02-06T09:59:34.010409  / # #
    2023-02-06T09:59:34.113585  export SHELL=3D/bin/sh
    2023-02-06T09:59:34.114537  #
    2023-02-06T09:59:34.216474  / # export SHELL=3D/bin/sh. /lava-3295042/e=
nvironment
    2023-02-06T09:59:34.217447  =

    2023-02-06T09:59:34.320269  / # . /lava-3295042/environment/lava-329504=
2/bin/lava-test-runner /lava-3295042/1
    2023-02-06T09:59:34.322327  =

    2023-02-06T09:59:34.322963  <3>[   10.273850] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-02-06T09:59:34.329927  / # /lava-3295042/bin/lava-test-runner /lav=
a-3295042/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cde316b7dcad51915f32

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0cde316b7dcad51915f37
        failing since 9 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-02-06T09:52:12.605203  + set +x
    2023-02-06T09:52:12.605534  [    9.377013] <LAVA_SIGNAL_ENDRUN 0_dmesg =
899096_1.5.2.3.1>
    2023-02-06T09:52:12.713302  / # #
    2023-02-06T09:52:12.814887  export SHELL=3D/bin/sh
    2023-02-06T09:52:12.815331  #
    2023-02-06T09:52:12.916709  / # export SHELL=3D/bin/sh. /lava-899096/en=
vironment
    2023-02-06T09:52:12.917150  =

    2023-02-06T09:52:13.018389  / # . /lava-899096/environment/lava-899096/=
bin/lava-test-runner /lava-899096/1
    2023-02-06T09:52:13.019136  =

    2023-02-06T09:52:13.021407  / # /lava-899096/bin/lava-test-runner /lava=
-899096/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cf531f9c7232e2915f18

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0cf531f9c7232e2915f1d
        failing since 19 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-06T09:58:18.896471  <8>[   16.098222] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3295113_1.5.2.4.1>
    2023-02-06T09:58:19.016605  / # #
    2023-02-06T09:58:19.122169  export SHELL=3D/bin/sh
    2023-02-06T09:58:19.123739  #
    2023-02-06T09:58:19.227182  / # export SHELL=3D/bin/sh. /lava-3295113/e=
nvironment
    2023-02-06T09:58:19.230166  =

    2023-02-06T09:58:19.336558  / # . /lava-3295113/environment/lava-329511=
3/bin/lava-test-runner /lava-3295113/1
    2023-02-06T09:58:19.342006  =

    2023-02-06T09:58:19.344584  / # /lava-3295113/bin/lava-test-runner /lav=
a-3295113/1
    2023-02-06T09:58:19.391200  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
       | regressions
-----------------------+-------+-----------------+----------+--------------=
-------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cf2b1f9c7232e2915ef1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.91-=
20-gcb49f24ce02b/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0cf2b1f9c7232e2915ef6
        failing since 19 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-06T09:57:53.093412  + set +x
    2023-02-06T09:57:53.097466  <8>[   16.183195] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 259916_1.5.2.4.1>
    2023-02-06T09:57:53.207792  / # #
    2023-02-06T09:57:53.309880  export SHELL=3D/bin/sh
    2023-02-06T09:57:53.310369  #
    2023-02-06T09:57:53.411949  / # export SHELL=3D/bin/sh. /lava-259916/en=
vironment
    2023-02-06T09:57:53.412584  =

    2023-02-06T09:57:53.514031  / # . /lava-259916/environment/lava-259916/=
bin/lava-test-runner /lava-259916/1
    2023-02-06T09:57:53.514882  =

    2023-02-06T09:57:53.518716  / # /lava-259916/bin/lava-test-runner /lava=
-259916/1 =

    ... (12 line(s) more)  =

 =20
