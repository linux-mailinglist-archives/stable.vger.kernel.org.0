Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FDF6D6C1C
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 20:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbjDDSbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 14:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbjDDSbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 14:31:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AE1B3
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 11:28:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id ix20so32176902plb.3
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 11:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680632904;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=B8IysjRCmJKhm0mCJkB37iSvZf8Ln54jRIJBtqQmKuo=;
        b=x2oeFCJvjYMGZaDEzdEt6CutceBs5FH/JkzxOgx0vVZQcOBAvCkgkMa+s8k8m/wmMD
         O/6ECEIjghIlNO5SkRXG8G99u8m8HwK72btSm26YIdNfS2KR0bb0+9MpGGSHJ3INJRRT
         A94hfO7UZvVVVs4HdIyE8/eUk93yBmfUNnsN8eDMGg8g+G6BUWCWUBXerCBTBmJEGdbK
         +cq6AZlip65l2b71zn+gdjDXhtfdsgj+SrOr+l5Z6rmk2lrdJuTJ0mDFgzCNfmjvWgk7
         ZPieyhXhBOZaPOjGYjL2TXNoOceCSa3PLIb57NFl3TIvvPr+bevWaffmt+BcFHS1E1f7
         sTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632904;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B8IysjRCmJKhm0mCJkB37iSvZf8Ln54jRIJBtqQmKuo=;
        b=HWABOLIViUnmj6Wz7CU8q562pQAy69nymc8nP3H48ElbHrOVkFWHeNdPWrTsxZ2y3k
         fVtYtvoxW9J5ApnznIjbbzXCA9FTGRyEh7Jrs+oMqYDl6H1z/GcLipJoyNj3V95FqeGL
         Qu7fM1MPqiU+mXR9JLe2GVGv3mhVNLSIu3IML3Dv0ys2e2uB2LMTpRsOIs49dNJCHE+a
         IHhiUyYVWCbjYiiw/jgtcWq2dCe9uvAvmhd/TneXxtbgRVFWgztEKldar09XDK67W99P
         jSmLxLj5HXcIdfkCWBJoWKtXicvKBPimrAZarSdoKdcX4kkwXrf2kN1xvDk5jpHWT3Yf
         fQlQ==
X-Gm-Message-State: AAQBX9dGjYBLXC+H/WWYG8O/2f8vi3AHeWQ7Umc9G8vj6ukC8ZtrAyMa
        jSoQlu0F9ESHIul+uvfeX2FSDdi+8/bBPGEY9AFXTQ==
X-Google-Smtp-Source: AKy350ZeJl6gfRwLnxEluXYkS1t3aSj7FJO7bFFYmgoVYdPnPwWaObFQi/cGm2vMvWZbm+/Ci7k6NA==
X-Received: by 2002:a17:90b:3e8b:b0:23a:ad68:25a7 with SMTP id rj11-20020a17090b3e8b00b0023aad6825a7mr3872365pjb.2.1680632904129;
        Tue, 04 Apr 2023 11:28:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0019edcc30d9bsm8692908pli.155.2023.04.04.11.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:28:23 -0700 (PDT)
Message-ID: <642c6c47.170a0220.87aba.1964@mx.google.com>
Date:   Tue, 04 Apr 2023 11:28:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-181-gcacf34e34abf0
Subject: stable-rc/queue/6.1 baseline: 114 runs,
 7 regressions (v6.1.22-181-gcacf34e34abf0)
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

stable-rc/queue/6.1 baseline: 114 runs, 7 regressions (v6.1.22-181-gcacf34e=
34abf0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-181-gcacf34e34abf0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-181-gcacf34e34abf0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cacf34e34abf0f144a8dfdb71c4a54cd50836497 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c37b198465501ba79e928

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c37b198465501ba79e92d
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:43:41.869820  + <8>[   11.086631] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9863073_1.4.2.3.1>

    2023-04-04T14:43:41.872797  set +x

    2023-04-04T14:43:41.978151  /#

    2023-04-04T14:43:42.081217   # #export SHELL=3D/bin/sh

    2023-04-04T14:43:42.081990  =


    2023-04-04T14:43:42.183817  / # export SHELL=3D/bin/sh. /lava-9863073/e=
nvironment

    2023-04-04T14:43:42.184491  =


    2023-04-04T14:43:42.286312  / # . /lava-9863073/environment/lava-986307=
3/bin/lava-test-runner /lava-9863073/1

    2023-04-04T14:43:42.287432  =


    2023-04-04T14:43:42.292944  / # /lava-9863073/bin/lava-test-runner /lav=
a-9863073/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c378ed0ba6f039479e936

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c378ed0ba6f039479e93b
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:43:11.815081  + set<8>[   11.968094] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9863118_1.4.2.3.1>

    2023-04-04T14:43:11.815632   +x

    2023-04-04T14:43:11.924147  / # #

    2023-04-04T14:43:12.026915  export SHELL=3D/bin/sh

    2023-04-04T14:43:12.027580  #

    2023-04-04T14:43:12.129399  / # export SHELL=3D/bin/sh. /lava-9863118/e=
nvironment

    2023-04-04T14:43:12.130095  =


    2023-04-04T14:43:12.231914  / # . /lava-9863118/environment/lava-986311=
8/bin/lava-test-runner /lava-9863118/1

    2023-04-04T14:43:12.233003  =


    2023-04-04T14:43:12.238204  / # /lava-9863118/bin/lava-test-runner /lav=
a-9863118/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c37861af4a64db079e9c3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c37861af4a64db079e9c8
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:42:55.661143  <8>[   10.082383] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863075_1.4.2.3.1>

    2023-04-04T14:42:55.663998  + set +x

    2023-04-04T14:42:55.766292  #

    2023-04-04T14:42:55.767537  =


    2023-04-04T14:42:55.869845  / # #export SHELL=3D/bin/sh

    2023-04-04T14:42:55.870782  =


    2023-04-04T14:42:55.973074  / # export SHELL=3D/bin/sh. /lava-9863075/e=
nvironment

    2023-04-04T14:42:55.973869  =


    2023-04-04T14:42:56.075935  / # . /lava-9863075/environment/lava-986307=
5/bin/lava-test-runner /lava-9863075/1

    2023-04-04T14:42:56.076543  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c378bd80018846479e95f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c378bd80018846479e964
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:43:05.654896  + set +x

    2023-04-04T14:43:05.661030  <8>[   10.919432] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863131_1.4.2.3.1>

    2023-04-04T14:43:05.766007  / # #

    2023-04-04T14:43:05.866999  export SHELL=3D/bin/sh

    2023-04-04T14:43:05.867215  #

    2023-04-04T14:43:05.968174  / # export SHELL=3D/bin/sh. /lava-9863131/e=
nvironment

    2023-04-04T14:43:05.968376  =


    2023-04-04T14:43:06.069275  / # . /lava-9863131/environment/lava-986313=
1/bin/lava-test-runner /lava-9863131/1

    2023-04-04T14:43:06.069620  =


    2023-04-04T14:43:06.074424  / # /lava-9863131/bin/lava-test-runner /lav=
a-9863131/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c379136cd95b33479e93d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c379136cd95b33479e942
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:43:07.140555  + set<8>[   10.455823] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9863135_1.4.2.3.1>

    2023-04-04T14:43:07.140647   +x

    2023-04-04T14:43:07.242622  /#

    2023-04-04T14:43:07.343830   # #export SHELL=3D/bin/sh

    2023-04-04T14:43:07.344013  =


    2023-04-04T14:43:07.444938  / # export SHELL=3D/bin/sh. /lava-9863135/e=
nvironment

    2023-04-04T14:43:07.445114  =


    2023-04-04T14:43:07.546027  / # . /lava-9863135/environment/lava-986313=
5/bin/lava-test-runner /lava-9863135/1

    2023-04-04T14:43:07.546275  =


    2023-04-04T14:43:07.551117  / # /lava-9863135/bin/lava-test-runner /lav=
a-9863135/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c378fd80018846479e992

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c378fd80018846479e997
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:43:05.739870  + <8>[   11.319377] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9863117_1.4.2.3.1>

    2023-04-04T14:43:05.739960  set +x

    2023-04-04T14:43:05.844741  / # #

    2023-04-04T14:43:05.945444  export SHELL=3D/bin/sh

    2023-04-04T14:43:05.945615  #

    2023-04-04T14:43:06.046548  / # export SHELL=3D/bin/sh. /lava-9863117/e=
nvironment

    2023-04-04T14:43:06.046717  =


    2023-04-04T14:43:06.147610  / # . /lava-9863117/environment/lava-986311=
7/bin/lava-test-runner /lava-9863117/1

    2023-04-04T14:43:06.147864  =


    2023-04-04T14:43:06.152420  / # /lava-9863117/bin/lava-test-runner /lav=
a-9863117/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c3790d0ba6f039479e944

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-18=
1-gcacf34e34abf0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c3790d0ba6f039479e949
        failing since 6 days (last pass: v6.1.21-104-gd5eb32be5b26, first f=
ail: v6.1.21-224-g1abeb39fad59)

    2023-04-04T14:43:06.546588  <8>[   12.699911] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9863134_1.4.2.3.1>

    2023-04-04T14:43:06.655308  / # #

    2023-04-04T14:43:06.758561  export SHELL=3D/bin/sh

    2023-04-04T14:43:06.759367  #

    2023-04-04T14:43:06.861285  / # export SHELL=3D/bin/sh. /lava-9863134/e=
nvironment

    2023-04-04T14:43:06.862079  =


    2023-04-04T14:43:06.963990  / # . /lava-9863134/environment/lava-986313=
4/bin/lava-test-runner /lava-9863134/1

    2023-04-04T14:43:06.965076  =


    2023-04-04T14:43:06.970074  / # /lava-9863134/bin/lava-test-runner /lav=
a-9863134/1

    2023-04-04T14:43:06.976884  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
