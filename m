Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5115A30CE13
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 22:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhBBVkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 16:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhBBVjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 16:39:52 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2641DC061573
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 13:38:36 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id q20so15247617pfu.8
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 13:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ILZ53Eb+cRJ7gbr/NNxFKZz97qfOmdC9+YWnPma9Oj8=;
        b=LGXyLwA0zpcXHz1Wgx7MkLSrAdzDyP6o/qG2jJk4gcOt5a0GEjUG8W3XdP0sd3Nmwf
         2EzdnBwKY2opP4naYqrteoDgS9e1JppiqRrue4+2xcoIlgD+I6t71+wxQhq8t3Evn1OZ
         DZU8ztHkGShS3NF+wgPOWZUBaUW5WJUyTFlMLjLyJWuuuikMfjrqWO0IgiPvasK4QGRB
         BN0ZgIqHhBO9HoPuqn1LaRvlkDfPp5NbUWPCd7nr5iX5w1YXz4z4lsafxQ9s7cN2ELPs
         uKwp5ZWvejyhQmW38ybMmhzAmD6ws/rAbqdemtXxGAG3pu5MP7jrexoz+esicPxsfYNc
         59QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ILZ53Eb+cRJ7gbr/NNxFKZz97qfOmdC9+YWnPma9Oj8=;
        b=B5OjLpfnFNYVfuJlRmokRUd3qD6M9NVxZgRG5rggA4tb2ZVEnKimTHvpd+glDB6lMY
         WYbfJvYYR0IJ+FXljbJjq5aVuB9CcrDVvV5ktpXda0P99JJXuvGcyDEexv5JsjS8+Hb3
         sQzsIlsWkOqLiG3Z64/kvRLiNwu8LXU33DwEfJmsTgtcSwQwzPSN1h56XiU/4y+LtrCv
         3KLaycDRTNCX/B6UOlkisy+khNJvEI48PQR5AO1691xEBXjzjsnO0bZGmoS8yGz7JI66
         EGTGwbu0ekPktsMldJjJdWZKfhOam+L22CywVzt31nvXs5MUGXLLpahpMzqJX3l2c66L
         IoGw==
X-Gm-Message-State: AOAM533/IHPbh2LNaIJ3IDV6R0YYTle8gO12FUZ3ZJBo6BjTdwLp1SwX
        9e/SCOyezi6i91qNU9BXLJJz9ShF3sn6uw==
X-Google-Smtp-Source: ABdhPJwCWWR4L1PReA7p19zSZ/YAGpRZkcI0cGnRgIDqtv9S4DsaGJ+7D0Dq7fEgshEEZHomvZo3pg==
X-Received: by 2002:a62:7bc8:0:b029:1bb:2947:5810 with SMTP id w191-20020a627bc80000b02901bb29475810mr23770483pfc.39.1612301915295;
        Tue, 02 Feb 2021 13:38:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 83sm22295905pfu.134.2021.02.02.13.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 13:38:34 -0800 (PST)
Message-ID: <6019c65a.1c69fb81.b8e38.4151@mx.google.com>
Date:   Tue, 02 Feb 2021 13:38:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.12-142-g1dbf6d5fcc60
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 193 runs,
 5 regressions (v5.10.12-142-g1dbf6d5fcc60)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 193 runs, 5 regressions (v5.10.12-142-g1dbf6=
d5fcc60)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre  | gcc-8    | bcm2835_defco=
nfig  | 1          =

hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.12-142-g1dbf6d5fcc60/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.12-142-g1dbf6d5fcc60
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1dbf6d5fcc600526a20888c7d4db7e6b162d3627 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre  | gcc-8    | bcm2835_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60198d8b09edb16d583abe7e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60198d8b09edb16d583ab=
e7f
        new failure (last pass: v5.10.12-131-gd0ba7d735ad1d) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6019987ddf713306ff3abe73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6019987ddf713306ff3ab=
e74
        new failure (last pass: v5.10.12-131-gd0ba7d735ad1d) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/601991439ce7ece63e3abe7d

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/601991439ce7ece=
63e3abe83
        new failure (last pass: v5.10.12-131-gd0ba7d735ad1d)
        4 lines

    2021-02-02 17:51:54.286000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-02-02 17:51:54.286000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-02-02 17:51:54.287000+00:00  kern  :alert : [<8>[   43.525583] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-02-02 17:51:54.287000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601991439ce7ece=
63e3abe84
        new failure (last pass: v5.10.12-131-gd0ba7d735ad1d)
        26 lines

    2021-02-02 17:51:54.338000+00:00  kern  :emerg : Process kworker/3:1 (p=
id: 52, stack limit =3D 0x(ptrval))
    2021-02-02 17:51:54.339000+00:00  kern  :emerg : Stack: (0xc2373eb0 to<=
8>[   43.571732] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-02-02 17:51:54.339000+00:00   0xc2374000)   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx8mp-evk               | arm64 | lab-nxp       | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/601996a56903ee0b393abe71

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
142-g1dbf6d5fcc60/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601996a56903ee0b393ab=
e72
        failing since 2 days (last pass: v5.10.12-3-g0bb4aea7b36b5, first f=
ail: v5.10.12-31-g38757cf9716b) =

 =20
