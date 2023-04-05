Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A186D8572
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDER7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDER7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:59:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E5E5254
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 10:59:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so38072846pjl.4
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 10:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680717576;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Zq1L8Z4a4bVzuG+Vt6zK4UzhFgHD13SW9scCuc0JJnM=;
        b=CFlkbb/NnVpr5V9UZTKXfAQKy1FExXW7UfRvBziq8+vvvRO12jJbW15ZlLkQpWFiwF
         u8rW9VqsubfkUZdtd9g+VZ+T+A2cOjeIhmfPM7kR4yyS0EQZCwO4nYlN2nua054Sofep
         q7k8fbbffuwml35KtPNT5XtEbGEdVTaZWWL1SlP7tUOtA25uHRpbLijp2e2/kYJuRuXJ
         4WFsOy4Bi9BGJPQEDlzUZJzBJDwLmgFTdFHJ4BROtDq70ahuTmsa4RDiOcaygW6eHOOm
         V1wFUYGYvF4vXyR+GtwS4QgWq57Df/od0VLuCQiNF84iaL+K2saPjnTwif+sGiNiG1ih
         t7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680717576;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zq1L8Z4a4bVzuG+Vt6zK4UzhFgHD13SW9scCuc0JJnM=;
        b=ClZjSP+fMJmzcZEQ6zrCZkgwudYr6/osGGpK3Qf3Z1Td/wfYW0K+qR0VY6LjIqik6i
         kDv5P3f/iN2pses9LuJZx744SeR8DlRJkB7/e/VOuDOSK8vmFSazdMQJ8fGqvjHrO9DR
         YsNuOTuZco1j9//Io5j/HiS5uJZd378HXKPPb+XDJ2QVr/Uqg4J9tTWoFosW3eZK26No
         jAn+O/k3p67zcU2FvLhjl3P5zYLYTJKt5qVN4XNfQPeJ6EBzW/RuqyqM7ROz5LrIcF3V
         L6crkOVu+y66nKGzC8DE6kqX2eewZH79BKCQYdpOe5VK7gHRvkAICuuK24XPPyVF/xHL
         wxHQ==
X-Gm-Message-State: AAQBX9dGcJXV8r3BKQ+P+q5Ql1GyKjDlyZgDJG9qDiokVdDJJTjKPEt8
        tf8N8Y0hdGSK0AYT0DjMkGa2jSI1lZ8kzmZpfoQeag==
X-Google-Smtp-Source: AKy350YHhtr/P1r/seLu/HhxnLQidt+V0qP+M3LrzFd9zMwHnIuzTnQz58ioTJT33q/7NO+y07v9hA==
X-Received: by 2002:a17:903:2012:b0:1a1:a44f:70ed with SMTP id s18-20020a170903201200b001a1a44f70edmr5662727pla.61.1680717575963;
        Wed, 05 Apr 2023 10:59:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11-20020a170903010b00b0019a5aa7eab0sm10403863plc.54.2023.04.05.10.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 10:59:35 -0700 (PDT)
Message-ID: <642db707.170a0220.56d0a.582c@mx.google.com>
Date:   Wed, 05 Apr 2023 10:59:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-178-g526133810841
Subject: stable-rc/queue/6.1 baseline: 178 runs,
 8 regressions (v6.1.22-178-g526133810841)
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

stable-rc/queue/6.1 baseline: 178 runs, 8 regressions (v6.1.22-178-g5261338=
10841)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-178-g526133810841/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-178-g526133810841
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      52613381084184c29b593176ede1dda8106cc37e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d846963d2eb4da379ea21

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d846963d2eb4da379ea26
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:23:28.775310  <8>[    9.869681] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9880818_1.4.2.3.1>

    2023-04-05T14:23:28.778761  + set +x

    2023-04-05T14:23:28.887596  / # #

    2023-04-05T14:23:28.990635  export SHELL=3D/bin/sh

    2023-04-05T14:23:28.991430  #

    2023-04-05T14:23:29.093548  / # export SHELL=3D/bin/sh. /lava-9880818/e=
nvironment

    2023-04-05T14:23:29.094356  =


    2023-04-05T14:23:29.196192  / # . /lava-9880818/environment/lava-988081=
8/bin/lava-test-runner /lava-9880818/1

    2023-04-05T14:23:29.197485  =


    2023-04-05T14:23:29.203306  / # /lava-9880818/bin/lava-test-runner /lav=
a-9880818/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d847cf225d1d02679e95c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d847cf225d1d02679e965
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:23:32.873027  + set<8>[   10.872582] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9880742_1.4.2.3.1>

    2023-04-05T14:23:32.873636   +x

    2023-04-05T14:23:32.982314  / # #

    2023-04-05T14:23:33.085491  export SHELL=3D/bin/sh

    2023-04-05T14:23:33.086383  #

    2023-04-05T14:23:33.188501  / # export SHELL=3D/bin/sh. /lava-9880742/e=
nvironment

    2023-04-05T14:23:33.189416  =


    2023-04-05T14:23:33.291520  / # . /lava-9880742/environment/lava-988074=
2/bin/lava-test-runner /lava-9880742/1

    2023-04-05T14:23:33.292822  =


    2023-04-05T14:23:33.297597  / # /lava-9880742/bin/lava-test-runner /lav=
a-9880742/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d846bc48888af2779e92f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d846bc48888af2779e934
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:23:26.658524  <8>[   10.937701] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9880819_1.4.2.3.1>

    2023-04-05T14:23:26.661936  + set +x

    2023-04-05T14:23:26.767939  =


    2023-04-05T14:23:26.869995  / # #export SHELL=3D/bin/sh

    2023-04-05T14:23:26.870693  =


    2023-04-05T14:23:26.972499  / # export SHELL=3D/bin/sh. /lava-9880819/e=
nvironment

    2023-04-05T14:23:26.973382  =


    2023-04-05T14:23:27.075388  / # . /lava-9880819/environment/lava-988081=
9/bin/lava-test-runner /lava-9880819/1

    2023-04-05T14:23:27.076575  =


    2023-04-05T14:23:27.081843  / # /lava-9880819/bin/lava-test-runner /lav=
a-9880819/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d84885cb41dc7d079e984

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d84885cb41dc7d079e989
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:23:53.450577  + set +x

    2023-04-05T14:23:53.457670  <8>[   10.753183] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9880780_1.4.2.3.1>

    2023-04-05T14:23:53.566054  / # #

    2023-04-05T14:23:53.669194  export SHELL=3D/bin/sh

    2023-04-05T14:23:53.670122  #

    2023-04-05T14:23:53.772325  / # export SHELL=3D/bin/sh. /lava-9880780/e=
nvironment

    2023-04-05T14:23:53.773078  =


    2023-04-05T14:23:53.875005  / # . /lava-9880780/environment/lava-988078=
0/bin/lava-test-runner /lava-9880780/1

    2023-04-05T14:23:53.876281  =


    2023-04-05T14:23:53.880740  / # /lava-9880780/bin/lava-test-runner /lav=
a-9880780/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d84660960bd626279e951

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d84660960bd626279e956
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:23:11.284943  + set +x

    2023-04-05T14:23:11.291821  <8>[   10.209578] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9880770_1.4.2.3.1>

    2023-04-05T14:23:11.393888  =


    2023-04-05T14:23:11.494846  / # #export SHELL=3D/bin/sh

    2023-04-05T14:23:11.495019  =


    2023-04-05T14:23:11.595904  / # export SHELL=3D/bin/sh. /lava-9880770/e=
nvironment

    2023-04-05T14:23:11.596169  =


    2023-04-05T14:23:11.697166  / # . /lava-9880770/environment/lava-988077=
0/bin/lava-test-runner /lava-9880770/1

    2023-04-05T14:23:11.697495  =


    2023-04-05T14:23:11.702914  / # /lava-9880770/bin/lava-test-runner /lav=
a-9880770/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d8461241ca2107e79e936

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d8461241ca2107e79e939
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:23:06.738989  + set<8>[   11.153169] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9880763_1.4.2.3.1>

    2023-04-05T14:23:06.739086   +x

    2023-04-05T14:23:06.843652  / # #

    2023-04-05T14:23:06.945033  export SHELL=3D/bin/sh

    2023-04-05T14:23:06.945744  #

    2023-04-05T14:23:07.047626  / # export SHELL=3D/bin/sh. /lava-9880763/e=
nvironment

    2023-04-05T14:23:07.048308  =


    2023-04-05T14:23:07.150099  / # . /lava-9880763/environment/lava-988076=
3/bin/lava-test-runner /lava-9880763/1

    2023-04-05T14:23:07.151312  =


    2023-04-05T14:23:07.156175  / # /lava-9880763/bin/lava-test-runner /lav=
a-9880763/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d844925e98b112179edf6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d844925e98b112179edfb
        failing since 7 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-05T14:22:57.232770  + set<8>[    8.948490] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9880759_1.4.2.3.1>

    2023-04-05T14:22:57.233375   +x

    2023-04-05T14:22:57.342584  / # #

    2023-04-05T14:22:57.445240  export SHELL=3D/bin/sh

    2023-04-05T14:22:57.446063  #

    2023-04-05T14:22:57.547836  / # export SHELL=3D/bin/sh. /lava-9880759/e=
nvironment

    2023-04-05T14:22:57.548514  =


    2023-04-05T14:22:57.650380  / # . /lava-9880759/environment/lava-988075=
9/bin/lava-test-runner /lava-9880759/1

    2023-04-05T14:22:57.651585  =


    2023-04-05T14:22:57.656793  / # /lava-9880759/bin/lava-test-runner /lav=
a-9880759/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-broonie   | gcc-10   | defconfi=
g+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/642d84a46f050cd6f079e94a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-meson-gxl-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-17=
8-g526133810841/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baselin=
e-meson-gxl-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642d84a46f050cd6f079e=
94b
        new failure (last pass: v6.1.22-177-ge130cbb3aea4d) =

 =20
