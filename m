Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0306DC7C4
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 16:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDJOUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 10:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDJOUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 10:20:17 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BCA49D6
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 07:20:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id c3so5369308pjg.1
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 07:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681136414; x=1683728414;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wMVXzUFDsBhQ0oEjtjCqu8FPflJZGf5KVF32ylXebi4=;
        b=yNWekBGmB0OI4db6kW0TlC0BEXDd6gtO87msUEeKzqNcZmy4YPaytT8E8M89xqFdcw
         ufIml7I1O445m2YqenbqCjyl3nJJ7WGO76UsLfrQQBDVr/6IWBzt1oIrmb7cDBLP+bVE
         AoFxCed8B9beTWjCwg9dDUFJ/fQaXdER4ZIQwUTHAT96HV9pkbVn+EVTbsXfM/sOUmlP
         pZtDAn6gChJTolEyKKmlValedXMYhbVT+mPYxBhCRqyLXr4Qa/lSeUDMMGRjOMeWlVZR
         P8UwdZjoM3XXEuB4xBWOMwHhSR54qI8yJM0FvP8NvEZ/kOzYELFDugDHE+TZpJINh/tf
         LzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681136414; x=1683728414;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wMVXzUFDsBhQ0oEjtjCqu8FPflJZGf5KVF32ylXebi4=;
        b=Hg553iXqfvzq/lF5zG1cTLKE49Y42Ilkp0+aPRYcN2b0F05g2/3YG0cv2mDCm855pl
         kgg+YNR0rPh7Uek+W4vijl+paQ3ZFnxKB4EdFwefy2NIBM3CB4W7wfJKZGdYeJ7aW//d
         2mSj1Q4+15zrUgWLRCVbVBQk1lVFusmHxw00Xt88QD5WGBrrMC1Ox/kh60zEe8j0KYtF
         ljj36zk9za1NmTdlJGlpnISi1peFsNvY6+qHpZVE3+5k7o33xQCD5DUPNMG3fivORcM5
         HZyVHxkKl6sbxsXh8IXCc+JzbmkA5nw1CcSVAy7YIUmkA11J0XvFsU8+J2iT7WsfPMD7
         bQIw==
X-Gm-Message-State: AAQBX9csAWV0lsWRvc6dcxD99GDNaeSHRVgI7kPB8zjVqLM+MBCq0jEZ
        OZR3uUyslT4BiUfZ6wtHY3b16KUg8VO2dR/zTMq5nw==
X-Google-Smtp-Source: AKy350YPIi6xTjhV11mOjuXOK+vvOQAbOZxitY/L62QNrcDmaxcXTAiIGworQe3neZzTsaXPmiEnfw==
X-Received: by 2002:a05:6a20:6aa7:b0:e9:5b0a:e784 with SMTP id bi39-20020a056a206aa700b000e95b0ae784mr8115222pzb.29.1681136414412;
        Mon, 10 Apr 2023 07:20:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20-20020aa78494000000b005a8bf239f5csm1580132pfn.193.2023.04.10.07.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 07:20:13 -0700 (PDT)
Message-ID: <64341b1d.a70a0220.e83cf.286e@mx.google.com>
Date:   Mon, 10 Apr 2023 07:20:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-154-g64628d98b12ec
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 111 runs,
 9 regressions (v5.15.105-154-g64628d98b12ec)
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

stable-rc/queue/5.15 baseline: 111 runs, 9 regressions (v5.15.105-154-g6462=
8d98b12ec)

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
nel/v5.15.105-154-g64628d98b12ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-154-g64628d98b12ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64628d98b12ec87c4f8b301c74161c2b2d0f9cdd =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e3b2d47eb9bd4c79e9e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e3b2d47eb9bd4c79e9f1
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:23:23.168008  + set +x

    2023-04-10T10:23:23.174656  <8>[   10.621313] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925463_1.4.2.3.1>

    2023-04-10T10:23:23.282971  =


    2023-04-10T10:23:23.385068  / # #export SHELL=3D/bin/sh

    2023-04-10T10:23:23.385868  =


    2023-04-10T10:23:23.487848  / # export SHELL=3D/bin/sh. /lava-9925463/e=
nvironment

    2023-04-10T10:23:23.488588  =


    2023-04-10T10:23:23.590481  / # . /lava-9925463/environment/lava-992546=
3/bin/lava-test-runner /lava-9925463/1

    2023-04-10T10:23:23.591737  =


    2023-04-10T10:23:23.598211  / # /lava-9925463/bin/lava-test-runner /lav=
a-9925463/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e343b212910de779eb7f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e343b212910de779eb88
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:21:50.315934  + set +x<8>[    8.991426] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9925389_1.4.2.3.1>

    2023-04-10T10:21:50.316360  =


    2023-04-10T10:21:50.424432  / # #

    2023-04-10T10:21:50.527152  export SHELL=3D/bin/sh

    2023-04-10T10:21:50.527819  #

    2023-04-10T10:21:50.629503  / # export SHELL=3D/bin/sh. /lava-9925389/e=
nvironment

    2023-04-10T10:21:50.629697  =


    2023-04-10T10:21:50.730699  / # . /lava-9925389/environment/lava-992538=
9/bin/lava-test-runner /lava-9925389/1

    2023-04-10T10:21:50.730973  =


    2023-04-10T10:21:50.735608  / # /lava-9925389/bin/lava-test-runner /lav=
a-9925389/1
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e346b212910de779eb9b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e346b212910de779eba4
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:21:45.116139  <8>[   11.012531] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925440_1.4.2.3.1>

    2023-04-10T10:21:45.119123  + set +x

    2023-04-10T10:21:45.220963  #

    2023-04-10T10:21:45.323670  / # #export SHELL=3D/bin/sh

    2023-04-10T10:21:45.323942  =


    2023-04-10T10:21:45.425161  / # export SHELL=3D/bin/sh. /lava-9925440/e=
nvironment

    2023-04-10T10:21:45.425304  =


    2023-04-10T10:21:45.526478  / # . /lava-9925440/environment/lava-992544=
0/bin/lava-test-runner /lava-9925440/1

    2023-04-10T10:21:45.527693  =


    2023-04-10T10:21:45.532506  / # /lava-9925440/bin/lava-test-runner /lav=
a-9925440/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e59768063072a479e94b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6433e59768063072a479e=
94c
        failing since 66 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6433eb0ffcfdc0321379e94d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433eb0ffcfdc0321379e956
        failing since 83 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-10T10:55:02.452951  <8>[   10.019258] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3482541_1.5.2.4.1>
    2023-04-10T10:55:02.562414  / # #
    2023-04-10T10:55:02.666088  export SHELL=3D/bin/sh
    2023-04-10T10:55:02.667268  #
    2023-04-10T10:55:02.769534  / # export SHELL=3D/bin/sh. /lava-3482541/e=
nvironment
    2023-04-10T10:55:02.769976  =

    2023-04-10T10:55:02.871543  / # . /lava-3482541/environment/lava-348254=
1/bin/lava-test-runner /lava-3482541/1
    2023-04-10T10:55:02.872496  =

    2023-04-10T10:55:02.872747  / # <3>[   10.353453] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-10T10:55:02.877368  /lava-3482541/bin/lava-test-runner /lava-34=
82541/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e3567776eedd5f79e94b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e3567776eedd5f79e953
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:21:56.329147  + set +x

    2023-04-10T10:21:56.335660  <8>[    9.996445] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925422_1.4.2.3.1>

    2023-04-10T10:21:56.440303  / # #

    2023-04-10T10:21:56.541323  export SHELL=3D/bin/sh

    2023-04-10T10:21:56.541522  #

    2023-04-10T10:21:56.642451  / # export SHELL=3D/bin/sh. /lava-9925422/e=
nvironment

    2023-04-10T10:21:56.642695  =


    2023-04-10T10:21:56.743621  / # . /lava-9925422/environment/lava-992542=
2/bin/lava-test-runner /lava-9925422/1

    2023-04-10T10:21:56.743997  =


    2023-04-10T10:21:56.748754  / # /lava-9925422/bin/lava-test-runner /lav=
a-9925422/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e345b212910de779eb8a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e345b212910de779eb93
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:21:38.187805  + set +x

    2023-04-10T10:21:38.194404  <8>[   10.181290] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925430_1.4.2.3.1>

    2023-04-10T10:21:38.296714  =


    2023-04-10T10:21:38.397482  / # #export SHELL=3D/bin/sh

    2023-04-10T10:21:38.397664  =


    2023-04-10T10:21:38.498586  / # export SHELL=3D/bin/sh. /lava-9925430/e=
nvironment

    2023-04-10T10:21:38.498806  =


    2023-04-10T10:21:38.599738  / # . /lava-9925430/environment/lava-992543=
0/bin/lava-test-runner /lava-9925430/1

    2023-04-10T10:21:38.600053  =


    2023-04-10T10:21:38.605268  / # /lava-9925430/bin/lava-test-runner /lav=
a-9925430/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e35a7776eedd5f79e9ae

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e35a7776eedd5f79e9b7
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:21:59.151936  + set<8>[   11.281690] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9925414_1.4.2.3.1>

    2023-04-10T10:21:59.152021   +x

    2023-04-10T10:21:59.256754  / # #

    2023-04-10T10:21:59.357768  export SHELL=3D/bin/sh

    2023-04-10T10:21:59.357970  #

    2023-04-10T10:21:59.458888  / # export SHELL=3D/bin/sh. /lava-9925414/e=
nvironment

    2023-04-10T10:21:59.459093  =


    2023-04-10T10:21:59.559994  / # . /lava-9925414/environment/lava-992541=
4/bin/lava-test-runner /lava-9925414/1

    2023-04-10T10:21:59.560334  =


    2023-04-10T10:21:59.564806  / # /lava-9925414/bin/lava-test-runner /lav=
a-9925414/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433e422e77924721c79e930

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-154-g64628d98b12ec/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433e422e77924721c79e939
        failing since 12 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-10T10:25:20.079398  + set<8>[   12.286524] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9925385_1.4.2.3.1>

    2023-04-10T10:25:20.079810   +x

    2023-04-10T10:25:20.186597  / # #

    2023-04-10T10:25:20.289269  export SHELL=3D/bin/sh

    2023-04-10T10:25:20.290050  #

    2023-04-10T10:25:20.391971  / # export SHELL=3D/bin/sh. /lava-9925385/e=
nvironment

    2023-04-10T10:25:20.392849  =


    2023-04-10T10:25:20.495134  / # . /lava-9925385/environment/lava-992538=
5/bin/lava-test-runner /lava-9925385/1

    2023-04-10T10:25:20.496398  =


    2023-04-10T10:25:20.500604  / # /lava-9925385/bin/lava-test-runner /lav=
a-9925385/1
 =

    ... (12 line(s) more)  =

 =20
