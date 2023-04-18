Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6EA6E6CED
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 21:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDRT2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 15:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjDRT2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 15:28:53 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EA68694
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:28:51 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g6so10913927pjx.4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681846130; x=1684438130;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QZ7SP3WQhBZBFMLfjIp4Oa4P6UpWEMDGHuNo3vscNso=;
        b=gXEo93OzMAoSAvL9Ph7dXL/gfeAtX4+gtQGJTM7h0ABhiO5KhSFw52K5C0HmfR5Gea
         faAHbTkeGMoLN6LsRBFGBBK5/A50qYZ0GQKn4z1AX9DiMyFI2SRLfDbHbLhk9oKKae6M
         T57XzIYbcGRrXaGmtsgH/OuCZQTkCb5BJtSnEYRuFkye6JP4eXnowKbFmgq8ZcIQYBy/
         QJIL2sabeno7aQpnOcOOZB3P12Kc9AaRZ63dk51D575bvyNjV+y++DJxGD/+I5ZYGTck
         EG24FWe+2w0Gpw0c5uBk9z6iedD/ToYrRykkL8MkHfsUnZTAc8ba1Z8YyQT6srNMR4lx
         Dc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681846130; x=1684438130;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZ7SP3WQhBZBFMLfjIp4Oa4P6UpWEMDGHuNo3vscNso=;
        b=edyWW5sDq6s4OPWyxwkFj71A/8sGSt1LIVLK4CnItk4TcHjzJ0gkXrOa82Uia9z3Wr
         7F6xmkC7LpFRFkJfhDG22bLRfbHO0qGrumN2wGb/2veyxsKqxbIBsrHzfHd/9UATw1Nm
         9TPiz1Zni8z3DzXWAAmt2ChGOxYZM1qWVFXZtI835zOciC5TUKr4vYOeBrUDBhuO+Xzn
         rFWbzK90Bg5qodddk8+B5/S6W0plNFqMVPsPIFmGFbvfegsRJdcJBA1E/WvJ47wxCEXl
         090+8SCOA9MeCxf+fbQz/CfBv+p6UlsQSfPmVzr+5hHNow1FCZAZHB5ystOfcVY13FlG
         1DVQ==
X-Gm-Message-State: AAQBX9f5Y3kg8CrDshdYTwRsb1g3R2iwD3EWnwSkoyz3VXeZ5t3CZ9lD
        pQdY/QXg0WT3mro7xTOYJsS8+JrKbxiL3HZcZ3/7UhuC
X-Google-Smtp-Source: AKy350ZnsCSOtFTmbkPhpYne1qS3hHczyF7O6ukiuxXbB/JekRm7XcaCYcmpe61Yop539SCUplvSFA==
X-Received: by 2002:a05:6a20:918c:b0:d9:ecba:b9fc with SMTP id v12-20020a056a20918c00b000d9ecbab9fcmr664336pzd.54.1681846130204;
        Tue, 18 Apr 2023 12:28:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y128-20020a633286000000b005143448896csm9118403pgy.58.2023.04.18.12.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 12:28:49 -0700 (PDT)
Message-ID: <643eef71.630a0220.4e27.476c@mx.google.com>
Date:   Tue, 18 Apr 2023 12:28:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-479-gd4d11e11a24d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 140 runs,
 10 regressions (v6.1.22-479-gd4d11e11a24d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 140 runs, 10 regressions (v6.1.22-479-gd4d11e=
11a24d)

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

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

meson-gxl-s905d-p230         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-479-gd4d11e11a24d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-479-gd4d11e11a24d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4d11e11a24d899510aac2d7e796da1a025a2f4b =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb8822835764d92e8633

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb8822835764d92e8638
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:47:04.539583  + set +x

    2023-04-18T15:47:04.545446  <8>[    7.940903] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10032347_1.4.2.3.1>

    2023-04-18T15:47:04.648292  #

    2023-04-18T15:47:04.649800  =


    2023-04-18T15:47:04.751903  / # #export SHELL=3D/bin/sh

    2023-04-18T15:47:04.752491  =


    2023-04-18T15:47:04.854221  / # export SHELL=3D/bin/sh. /lava-10032347/=
environment

    2023-04-18T15:47:04.855006  =


    2023-04-18T15:47:04.956860  / # . /lava-10032347/environment/lava-10032=
347/bin/lava-test-runner /lava-10032347/1

    2023-04-18T15:47:04.958144  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb9095dad29cf42e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb9095dad29cf42e85ec
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:47:07.761193  + set<8>[   12.076621] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10032321_1.4.2.3.1>

    2023-04-18T15:47:07.761318   +x

    2023-04-18T15:47:07.866198  / # #

    2023-04-18T15:47:07.967505  export SHELL=3D/bin/sh

    2023-04-18T15:47:07.968158  #

    2023-04-18T15:47:08.070036  / # export SHELL=3D/bin/sh. /lava-10032321/=
environment

    2023-04-18T15:47:08.070779  =


    2023-04-18T15:47:08.172568  / # . /lava-10032321/environment/lava-10032=
321/bin/lava-test-runner /lava-10032321/1

    2023-04-18T15:47:08.173670  =


    2023-04-18T15:47:08.178478  / # /lava-10032321/bin/lava-test-runner /la=
va-10032321/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb894cf31cbe582e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb894cf31cbe582e85eb
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:46:56.411162  <8>[   10.041257] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10032319_1.4.2.3.1>

    2023-04-18T15:46:56.414792  + set +x

    2023-04-18T15:46:56.516648  #

    2023-04-18T15:46:56.516914  =


    2023-04-18T15:46:56.617974  / # #export SHELL=3D/bin/sh

    2023-04-18T15:46:56.618272  =


    2023-04-18T15:46:56.719484  / # export SHELL=3D/bin/sh. /lava-10032319/=
environment

    2023-04-18T15:46:56.719734  =


    2023-04-18T15:46:56.820765  / # . /lava-10032319/environment/lava-10032=
319/bin/lava-test-runner /lava-10032319/1

    2023-04-18T15:46:56.821087  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebc5fd71c94c32e2e85eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ebc5fd71c94c32e2e8=
5ec
        new failure (last pass: v6.1.22-479-g35f051d5ebe4) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebbad04bcb047902e8649

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebbad04bcb047902e864e
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:47:43.238562  + set +x

    2023-04-18T15:47:43.245044  <8>[   11.009329] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10032283_1.4.2.3.1>

    2023-04-18T15:47:43.350088  / # #

    2023-04-18T15:47:43.451128  export SHELL=3D/bin/sh

    2023-04-18T15:47:43.451341  #

    2023-04-18T15:47:43.552248  / # export SHELL=3D/bin/sh. /lava-10032283/=
environment

    2023-04-18T15:47:43.552480  =


    2023-04-18T15:47:43.653401  / # . /lava-10032283/environment/lava-10032=
283/bin/lava-test-runner /lava-10032283/1

    2023-04-18T15:47:43.653733  =


    2023-04-18T15:47:43.658698  / # /lava-10032283/bin/lava-test-runner /la=
va-10032283/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb6fc50f5a93262e8673

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb6fc50f5a93262e8678
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:46:38.908036  <8>[   10.037705] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10032281_1.4.2.3.1>

    2023-04-18T15:46:38.911017  + set +x

    2023-04-18T15:46:39.012685  =


    2023-04-18T15:46:39.113684  / # #export SHELL=3D/bin/sh

    2023-04-18T15:46:39.113873  =


    2023-04-18T15:46:39.214671  / # export SHELL=3D/bin/sh. /lava-10032281/=
environment

    2023-04-18T15:46:39.214844  =


    2023-04-18T15:46:39.315802  / # . /lava-10032281/environment/lava-10032=
281/bin/lava-test-runner /lava-10032281/1

    2023-04-18T15:46:39.316056  =


    2023-04-18T15:46:39.320809  / # /lava-10032281/bin/lava-test-runner /la=
va-10032281/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb730b43d902622e85e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb730b43d902622e85ed
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:46:52.517577  + set<8>[   11.431713] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10032274_1.4.2.3.1>

    2023-04-18T15:46:52.518017   +x

    2023-04-18T15:46:52.625548  / # #

    2023-04-18T15:46:52.728153  export SHELL=3D/bin/sh

    2023-04-18T15:46:52.728833  #

    2023-04-18T15:46:52.830554  / # export SHELL=3D/bin/sh. /lava-10032274/=
environment

    2023-04-18T15:46:52.831326  =


    2023-04-18T15:46:52.933233  / # . /lava-10032274/environment/lava-10032=
274/bin/lava-test-runner /lava-10032274/1

    2023-04-18T15:46:52.934467  =


    2023-04-18T15:46:52.938360  / # /lava-10032274/bin/lava-test-runner /la=
va-10032274/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebb6e2619f21e182e8628

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ebb6e2619f21e182e862d
        failing since 20 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-18T15:46:41.904319  <8>[   12.486335] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10032272_1.4.2.3.1>

    2023-04-18T15:46:42.009378  / # #

    2023-04-18T15:46:42.110408  export SHELL=3D/bin/sh

    2023-04-18T15:46:42.110616  #

    2023-04-18T15:46:42.211517  / # export SHELL=3D/bin/sh. /lava-10032272/=
environment

    2023-04-18T15:46:42.211719  =


    2023-04-18T15:46:42.312661  / # . /lava-10032272/environment/lava-10032=
272/bin/lava-test-runner /lava-10032272/1

    2023-04-18T15:46:42.312938  =


    2023-04-18T15:46:42.317798  / # /lava-10032272/bin/lava-test-runner /la=
va-10032272/1

    2023-04-18T15:46:42.324847  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-gxl-s905d-p230         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebc5e5ac3c3dc4c2e8603

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ebc5e5ac3c3dc4c2e8=
604
        new failure (last pass: v6.1.22-479-g35f051d5ebe4) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643ebae89d2bd21ba32e8602

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-47=
9-gd4d11e11a24d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643ebae89d2bd21ba32e8=
603
        failing since 0 day (last pass: v6.1.22-462-g16a9aa862d1a, first fa=
il: v6.1.22-479-g35f051d5ebe4) =

 =20
