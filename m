Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDD46D0F9C
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjC3UCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC3UCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:02:47 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FAFFF19
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 13:02:46 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so20980893pjz.1
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 13:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680206566;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6V/LwL2HxlV4mf0045TgFM1GfBaH3xJRaStE/o3aqSY=;
        b=ditPWEelV9UnNR77PzVFEA2XNM9O5OhUlJNC8E7W702JHFDfXGgN0ALKFlxW95zOz0
         N1a6/klcDCA0wTXppZOK20NBeMFr6CUM1nFPmdFb35u0MzBD/8XXl36Zx9mBeHdLfQwR
         /LljuNwa9E7xuzmV9hOKCt/FW7IK5LKuypr5LTUpmRbktM1WJKqV2tft1S3MVvWesSOo
         0a35G5YNColMkmxVCuxHoBRhab+wLQGINIGrUVlMp83dY5Ne3WukOj8ZPmo40UgOyf5O
         LHamjaw9LegzPfQz0vEf9gCgdwxxo05fFrJKrbeyr/HwepYlj1KujY8OQCnI6SaxkQnd
         uUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680206566;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6V/LwL2HxlV4mf0045TgFM1GfBaH3xJRaStE/o3aqSY=;
        b=mIIEAPVCfo4yD0sf3gwe7A9RbbMyOt1OJ09ieY3r3a+inGN9TjRgkgt+FUR+OHH8TM
         61nrQ46tL3hoeU7BlKiDev2inB1eaiP7IfQ13Ds0SXw2jDmbUCCZ41pOiCYfm5Wtmb4G
         VEJsXUmjf3qmX6VIF1T7NovIgCa7h3NuEdDeEY3ccXKzwy5weocrU5UlNcRe9o9F1nwJ
         q3+sUdUlgRZh6OQIXLVOiDEEjJm9HMKaMoQMxIDX1WYjxUHv34dc0oPWJAepw34o6XKz
         qO17f2GcroNnK2oHh/3W8g9gPVOpw1auzfIIJWVJk1Eks7x3IAdZubnyJe8q3rAffDP+
         WJsg==
X-Gm-Message-State: AAQBX9dviTu+ZA2soRIEGjKT6GhJK5TnzM5QxTmizDtSPg3efNUNxaOu
        LsKStzkemxEvHn7Vu4IpuFfrbBF0SbfLUVzHc5U=
X-Google-Smtp-Source: AKy350ZpH2AFVUhmqsR/T6F1UliarIFIvVuzwpHdvetO/rgmTGFPpdP2f0sJwe9Ici4URbqgaJLPNA==
X-Received: by 2002:a17:903:1106:b0:1a2:58f1:5e1d with SMTP id n6-20020a170903110600b001a258f15e1dmr17100010plh.36.1680206565678;
        Thu, 30 Mar 2023 13:02:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001a285269b70sm83804plb.280.2023.03.30.13.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 13:02:45 -0700 (PDT)
Message-ID: <6425eae5.170a0220.cf94.08e1@mx.google.com>
Date:   Thu, 30 Mar 2023 13:02:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-72-gadbd85cd5948
Subject: stable-rc/queue/5.4 baseline: 114 runs,
 5 regressions (v5.4.238-72-gadbd85cd5948)
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

stable-rc/queue/5.4 baseline: 114 runs, 5 regressions (v5.4.238-72-gadbd85c=
d5948)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-72-gadbd85cd5948/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-72-gadbd85cd5948
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      adbd85cd59484b90ddc1ac24815f31321af5c9b4 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b674b2801c223562f787

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b674b2801c223562f78c
        failing since 59 days (last pass: v5.4.230-81-g2ad0dc06d587, first =
fail: v5.4.230-108-g761a8268d868)

    2023-03-30T16:18:34.754892  <8>[    9.777444] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3456328_1.5.2.4.1>
    2023-03-30T16:18:34.861434  / # #
    2023-03-30T16:18:34.962945  export SHELL=3D/bin/sh
    2023-03-30T16:18:34.963332  #
    2023-03-30T16:18:35.064384  / # export SHELL=3D/bin/sh. /lava-3456328/e=
nvironment
    2023-03-30T16:18:35.065223  =

    2023-03-30T16:18:35.167423  / # . /lava-3456328/environment/lava-345632=
8/bin/lava-test-runner /lava-3456328/1
    2023-03-30T16:18:35.169420  =

    2023-03-30T16:18:35.175951  / # /lava-3456328/bin/lava-test-runner /lav=
a-3456328/1
    2023-03-30T16:18:35.265082  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b5723db8108f4c62f7b4

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6425b5723db8108f=
4c62f7bd
        failing since 162 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-03-30T16:14:21.166790  / # =

    2023-03-30T16:14:21.167685  =

    2023-03-30T16:14:23.229975  / # #
    2023-03-30T16:14:23.230613  #
    2023-03-30T16:14:25.241886  / # export SHELL=3D/bin/sh
    2023-03-30T16:14:25.242715  export SHELL=3D/bin/sh
    2023-03-30T16:14:27.257407  / # . /lava-3456290/environment
    2023-03-30T16:14:27.257855  . /lava-3456290/environment
    2023-03-30T16:14:29.273636  / # /lava-3456290/bin/lava-test-runner /lav=
a-3456290/0
    2023-03-30T16:14:29.274880  /lava-3456290/bin/lava-test-runner /lava-34=
56290/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b4ee153761d02162f788

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b4ee153761d02162f78d
        failing since 1 day (last pass: v5.4.238-29-g39c31e43e3b2b, first f=
ail: v5.4.238-60-gcf51829325af)

    2023-03-30T16:12:21.035711  + set<8>[   10.747976] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9818856_1.4.2.3.1>

    2023-03-30T16:12:21.035850   +x

    2023-03-30T16:12:21.137936  #

    2023-03-30T16:12:21.239230  / # #export SHELL=3D/bin/sh

    2023-03-30T16:12:21.239486  =


    2023-03-30T16:12:21.340439  / # export SHELL=3D/bin/sh. /lava-9818856/e=
nvironment

    2023-03-30T16:12:21.340675  =


    2023-03-30T16:12:21.441637  / # . /lava-9818856/environment/lava-981885=
6/bin/lava-test-runner /lava-9818856/1

    2023-03-30T16:12:21.441973  =


    2023-03-30T16:12:21.446517  / # /lava-9818856/bin/lava-test-runner /lav=
a-9818856/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b4d3b6133786a662f76b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b4d3b6133786a662f770
        failing since 1 day (last pass: v5.4.238-29-g39c31e43e3b2b, first f=
ail: v5.4.238-60-gcf51829325af)

    2023-03-30T16:11:49.734580  <8>[   12.930795] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9818877_1.4.2.3.1>

    2023-03-30T16:11:49.738237  + set +x

    2023-03-30T16:11:49.839865  /#

    2023-03-30T16:11:49.941064   # #export SHELL=3D/bin/sh

    2023-03-30T16:11:49.941267  =


    2023-03-30T16:11:50.042159  / # export SHELL=3D/bin/sh. /lava-9818877/e=
nvironment

    2023-03-30T16:11:50.042396  =


    2023-03-30T16:11:50.143359  / # . /lava-9818877/environment/lava-981887=
7/bin/lava-test-runner /lava-9818877/1

    2023-03-30T16:11:50.143631  =


    2023-03-30T16:11:50.148199  / # /lava-9818877/bin/lava-test-runner /lav=
a-9818877/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b668c316c33c9b62f7a4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-7=
2-gadbd85cd5948/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b668c316c33c9b62f7a9
        failing since 57 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-03-30T16:18:32.339191  <8>[    7.764635] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3456329_1.5.2.4.1>
    2023-03-30T16:18:32.459640  / # #
    2023-03-30T16:18:32.561865  export SHELL=3D/bin/sh
    2023-03-30T16:18:32.562489  #
    2023-03-30T16:18:32.664032  / # export SHELL=3D/bin/sh. /lava-3456329/e=
nvironment
    2023-03-30T16:18:32.664652  =

    2023-03-30T16:18:32.766260  / # . /lava-3456329/environment/lava-345632=
9/bin/lava-test-runner /lava-3456329/1
    2023-03-30T16:18:32.767310  =

    2023-03-30T16:18:32.786988  / # /lava-3456329/bin/lava-test-runner /lav=
a-3456329/1
    2023-03-30T16:18:32.859010  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
