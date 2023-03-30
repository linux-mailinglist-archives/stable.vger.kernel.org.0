Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84C86D0E4F
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjC3TGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbjC3TGN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:06:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D920E1FEC
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:06:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l7so18178506pjg.5
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680203167;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GE0W0YYK7EWcUhaCEJ3kbnyPva0ujqSs7oYaBdkkTYU=;
        b=x+FZchz6VZ9VaHKfhFd2naZrTbDQJK7iow/+/AlCW45mSovh883QTCtcsY4geF9CP0
         mZtK3yCEc2d32YHLFipMiomT9pQhkeRfmvfcxeG/oedaCEefZ+ZrYmr5EvcZy8DHNveE
         BjrNACtRBnX9TIV9sY8GPTXRLOCg6OfVAifCYcdzQNZG8QUU48Tn/74s5xK+tGoBn6om
         uX6tS1+vcolPD6GYq2AWddYmzEvipHsoAFnXqVwcyDnmQijEFdscVgljB3dFowb8gJsI
         tmpXM/DrV63T8JqHkovh/UjRP5ODyV5f25TQ+LLqhVEQDFkLvjONeYOvzSKmIQaaZzMK
         Wb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680203167;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GE0W0YYK7EWcUhaCEJ3kbnyPva0ujqSs7oYaBdkkTYU=;
        b=s6NuTCUG67+dHZMU1aiuQFnQTCw8vJBMTXmMJq30rJGUztfz9qa4h//W6q39di0s/u
         3lkyBflAoMYL3q7FiSTtCsCOen2KDHUAYJ7G0drY+tNnQCoVAgZl/azpj2GfgyX398Nj
         3E2MmYhpafD/vdF0yzAEF5z7sQ3NRIfbhur2LIaIMmk2cGgWG8HVa1rRxUrt89VvodEH
         jf7b7u/44OsSdRoBYT2S6/WxIVwfTuxl4DPZcg22ODgHpXGL0Wt8SUKJjC566FvXQqKk
         54erBv7trHvv4bbJCb7Zq12/U4qqw9Ps1cHuEu+bR17Xy6gkntqczpm/HFj0l6ZG5/Mq
         k+KQ==
X-Gm-Message-State: AAQBX9f/hYaVKFL5e+c1deZsMyKBHre3e32C3QnRgATFB+aIC6j4SPt4
        OQT3azGhPLkmmRszQ+YoOGyBdsS/rriJN5vIKog=
X-Google-Smtp-Source: AKy350ZUwXCubLjkP5vZtPcwe9so4nxsM2uFu5nLZCvkXnVqnXBBVspVXwbxh0yqmQ2VtxLuuSvcug==
X-Received: by 2002:a17:902:e192:b0:19f:a694:6d3c with SMTP id y18-20020a170902e19200b0019fa6946d3cmr19739941pla.55.1680203166824;
        Thu, 30 Mar 2023 12:06:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709027c0700b0019468fe44d3sm100656pll.25.2023.03.30.12.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 12:06:06 -0700 (PDT)
Message-ID: <6425dd9e.170a0220.69b0b.06eb@mx.google.com>
Date:   Thu, 30 Mar 2023 12:06:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-23-gc5d1731f243b
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 9 regressions (v5.15.105-23-gc5d1731f243b)
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

stable-rc/queue/5.15 baseline: 172 runs, 9 regressions (v5.15.105-23-gc5d17=
31f243b)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-23-gc5d1731f243b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-23-gc5d1731f243b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5d1731f243b8c7d962daeed0feb8dd0d9aacc56 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a55838a16e7f5a62f793

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a55838a16e7f5a62f798
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:05:46.883734  + set +x

    2023-03-30T15:05:46.890709  <8>[   11.153535] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817609_1.4.2.3.1>

    2023-03-30T15:05:47.000483  =


    2023-03-30T15:05:47.103053  / # #export SHELL=3D/bin/sh

    2023-03-30T15:05:47.103963  =


    2023-03-30T15:05:47.206208  / # export SHELL=3D/bin/sh. /lava-9817609/e=
nvironment

    2023-03-30T15:05:47.207131  =


    2023-03-30T15:05:47.309346  / # . /lava-9817609/environment/lava-981760=
9/bin/lava-test-runner /lava-9817609/1

    2023-03-30T15:05:47.310726  =


    2023-03-30T15:05:47.316904  / # /lava-9817609/bin/lava-test-runner /lav=
a-9817609/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a56238a16e7f5a62f7ad

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a56238a16e7f5a62f7b2
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:05:44.966359  + set<8>[    8.857909] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9817577_1.4.2.3.1>

    2023-03-30T15:05:44.966445   +x

    2023-03-30T15:05:45.071121  / # #

    2023-03-30T15:05:45.172149  export SHELL=3D/bin/sh

    2023-03-30T15:05:45.172359  #

    2023-03-30T15:05:45.273259  / # export SHELL=3D/bin/sh. /lava-9817577/e=
nvironment

    2023-03-30T15:05:45.273466  =


    2023-03-30T15:05:45.374381  / # . /lava-9817577/environment/lava-981757=
7/bin/lava-test-runner /lava-9817577/1

    2023-03-30T15:05:45.374733  =


    2023-03-30T15:05:45.379716  / # /lava-9817577/bin/lava-test-runner /lav=
a-9817577/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a56543cff6412362f7a2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a56543cff6412362f7a7
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:05:57.425461  <8>[   10.665632] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817553_1.4.2.3.1>

    2023-03-30T15:05:57.428596  + set +x

    2023-03-30T15:05:57.530224  #

    2023-03-30T15:05:57.530519  =


    2023-03-30T15:05:57.631543  / # #export SHELL=3D/bin/sh

    2023-03-30T15:05:57.631785  =


    2023-03-30T15:05:57.733013  / # export SHELL=3D/bin/sh. /lava-9817553/e=
nvironment

    2023-03-30T15:05:57.733913  =


    2023-03-30T15:05:57.836005  / # . /lava-9817553/environment/lava-981755=
3/bin/lava-test-runner /lava-9817553/1

    2023-03-30T15:05:57.837136  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a9e028394f18ee62f78a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6425a9e028394f18ee62f=
78b
        failing since 55 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a8e580030da6bd62f7aa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a8e580030da6bd62f7af
        failing since 72 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-30T15:20:42.688820  <8>[    9.933707] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3456083_1.5.2.4.1>
    2023-03-30T15:20:42.795088  / # #
    2023-03-30T15:20:42.896854  export SHELL=3D/bin/sh
    2023-03-30T15:20:42.897731  #
    2023-03-30T15:20:42.999709  / # export SHELL=3D/bin/sh. /lava-3456083/e=
nvironment
    2023-03-30T15:20:43.000640  =

    2023-03-30T15:20:43.001145  / # <3>[   10.193448] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-30T15:20:43.103022  . /lava-3456083/environment/lava-3456083/bi=
n/lava-test-runner /lava-3456083/1
    2023-03-30T15:20:43.104563  =

    2023-03-30T15:20:43.109331  / # /lava-3456083/bin/lava-test-runner /lav=
a-3456083/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a57a1653ece9e062f793

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a57a1653ece9e062f798
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:06:15.123529  + set +x

    2023-03-30T15:06:15.130462  <8>[    7.885753] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817564_1.4.2.3.1>

    2023-03-30T15:06:15.239686  / # #

    2023-03-30T15:06:15.342079  export SHELL=3D/bin/sh

    2023-03-30T15:06:15.342364  #

    2023-03-30T15:06:15.443370  / # export SHELL=3D/bin/sh. /lava-9817564/e=
nvironment

    2023-03-30T15:06:15.443654  =


    2023-03-30T15:06:15.544678  / # . /lava-9817564/environment/lava-981756=
4/bin/lava-test-runner /lava-9817564/1

    2023-03-30T15:06:15.545001  =


    2023-03-30T15:06:15.549665  / # /lava-9817564/bin/lava-test-runner /lav=
a-9817564/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a55238a16e7f5a62f779

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a55238a16e7f5a62f77e
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:05:39.755291  <8>[   10.119194] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817541_1.4.2.3.1>

    2023-03-30T15:05:39.758947  + set +x

    2023-03-30T15:05:39.860441  #

    2023-03-30T15:05:39.860706  =


    2023-03-30T15:05:39.961674  / # #export SHELL=3D/bin/sh

    2023-03-30T15:05:39.961899  =


    2023-03-30T15:05:40.062789  / # export SHELL=3D/bin/sh. /lava-9817541/e=
nvironment

    2023-03-30T15:05:40.062999  =


    2023-03-30T15:05:40.163925  / # . /lava-9817541/environment/lava-981754=
1/bin/lava-test-runner /lava-9817541/1

    2023-03-30T15:05:40.164225  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a55fb5f3f1074d62f79a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a55fb5f3f1074d62f79f
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:05:50.853375  + set<8>[   11.429381] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9817610_1.4.2.3.1>

    2023-03-30T15:05:50.853968   +x

    2023-03-30T15:05:50.963966  / # #

    2023-03-30T15:05:51.067245  export SHELL=3D/bin/sh

    2023-03-30T15:05:51.068110  #

    2023-03-30T15:05:51.169982  / # export SHELL=3D/bin/sh. /lava-9817610/e=
nvironment

    2023-03-30T15:05:51.171055  =


    2023-03-30T15:05:51.273272  / # . /lava-9817610/environment/lava-981761=
0/bin/lava-test-runner /lava-9817610/1

    2023-03-30T15:05:51.274827  =


    2023-03-30T15:05:51.279101  / # /lava-9817610/bin/lava-test-runner /lav=
a-9817610/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425a556b5f3f1074d62f774

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-23-gc5d1731f243b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425a556b5f3f1074d62f779
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T15:05:44.038574  <8>[   11.729112] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9817579_1.4.2.3.1>

    2023-03-30T15:05:44.147355  / # #

    2023-03-30T15:05:44.250022  export SHELL=3D/bin/sh

    2023-03-30T15:05:44.250897  #

    2023-03-30T15:05:44.352846  / # export SHELL=3D/bin/sh. /lava-9817579/e=
nvironment

    2023-03-30T15:05:44.353670  =


    2023-03-30T15:05:44.455556  / # . /lava-9817579/environment/lava-981757=
9/bin/lava-test-runner /lava-9817579/1

    2023-03-30T15:05:44.457041  =


    2023-03-30T15:05:44.461801  / # /lava-9817579/bin/lava-test-runner /lav=
a-9817579/1

    2023-03-30T15:05:44.467314  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
