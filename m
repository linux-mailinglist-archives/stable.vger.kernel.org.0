Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2571D6D3A23
	for <lists+stable@lfdr.de>; Sun,  2 Apr 2023 22:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjDBUIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 16:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjDBUIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 16:08:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B145FEE
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 13:07:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id fb38so17784331pfb.7
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 13:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680466079;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mjdb9OdQRiV3uvtrjlyb3J4leqYAgwFN6S4D+DJzjEM=;
        b=0Mwp37jEym5MJ1UH1OR7vg6Qq33fVletoSu5bl8ppCso2/L2zWZTZlbaG0PDBdsIrU
         /rJcJL/MA1zwHrTSVcrHmEnfr6Jl7PvrmPv4/upMT0Nw3oCljkD2nwAF/x3cnFDynIsr
         aB9cmo6LKtLQC5OrGVINDRHUDHb3p8Aa29uumLGer61rOyWTD1a9ab5bZSGI0Bzy11Qi
         R+hziD4zc+BVCoBFHlMt6QyQjC70TjgRU3RR4WpiP3rPNPY/tNtuX6QeDeUtvTwehAaz
         2yvWUXu+kUaECUmCdfwzABjCiQfQVIINVFpqLg03BAW2bX7NgcYty0hcd92ZDdj6Kt5w
         ag+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680466079;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mjdb9OdQRiV3uvtrjlyb3J4leqYAgwFN6S4D+DJzjEM=;
        b=Oj0lRbvnecInNBj6wzEnaAHycMmNX/BIAa1HJlZic2ALiI18HKatRgdoDqjBuG2Asy
         kk0uql8WXDgT7AMpxtQ+SVF+/JCC43nAuQ/MGOZ5Xi8T9qBX1JuQgAh4Mdb008fw5/eZ
         jNzK22xksABJWH6CeShDpBQYPg75nSdUDI6znhHxX7waPFsuUWA9bCBni4v3/3NaBIHP
         G/ZMKmghFUALSptSG2J4V0ABoPjRD+K0FJa24ZmKBWEAo9JGv8lHyQE4Bo5Wu2dsdEHh
         jTX3DFcT0xDbwAHEb+9SgTw3D74EMbrwHuFMGdacu9mIMeZ84EFXRSVA8rX0lZzC6c4i
         e6Xw==
X-Gm-Message-State: AAQBX9cxf6OM34vTaRSGzQfcF9USqKPpAmczTyKMBlgdxLfo46dOJiLe
        uZBHtUcxkf5HRb2zPetGwPXld31WxMNoKSyhn8Y=
X-Google-Smtp-Source: AKy350azBKKsfrk567wC2QxI/kFhWR1BzwU1kJ6thxtKUFolhu3SFQiYRukH+Eb6Jm1eMUrvNkxIvw==
X-Received: by 2002:a62:cfc1:0:b0:625:2ed6:9070 with SMTP id b184-20020a62cfc1000000b006252ed69070mr30336289pfg.22.1680466078714;
        Sun, 02 Apr 2023 13:07:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15-20020aa7928f000000b0062a474cd46asm5373538pfa.137.2023.04.02.13.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 13:07:58 -0700 (PDT)
Message-ID: <6429e09e.a70a0220.ea2e7.a8bb@mx.google.com>
Date:   Sun, 02 Apr 2023 13:07:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105-62-g42320e2d46ce
Subject: stable-rc/queue/5.15 baseline: 180 runs,
 9 regressions (v5.15.105-62-g42320e2d46ce)
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

stable-rc/queue/5.15 baseline: 180 runs, 9 regressions (v5.15.105-62-g42320=
e2d46ce)

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
nel/v5.15.105-62-g42320e2d46ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-62-g42320e2d46ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42320e2d46ce03208203fea393fd39c0df81cad6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429acac69aa3399df62f7be

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429acac69aa3399df62f7c3
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:25:58.375288  + set +x

    2023-04-02T16:25:58.382009  <8>[   10.625178] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842716_1.4.2.3.1>

    2023-04-02T16:25:58.483982  #

    2023-04-02T16:25:58.484210  =


    2023-04-02T16:25:58.585164  / # #export SHELL=3D/bin/sh

    2023-04-02T16:25:58.585290  =


    2023-04-02T16:25:58.686252  / # export SHELL=3D/bin/sh. /lava-9842716/e=
nvironment

    2023-04-02T16:25:58.686480  =


    2023-04-02T16:25:58.787409  / # . /lava-9842716/environment/lava-984271=
6/bin/lava-test-runner /lava-9842716/1

    2023-04-02T16:25:58.787650  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429ac441bcd73a80b62f81f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429ac441bcd73a80b62f824
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:24:12.040421  + set<8>[    8.975515] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9842712_1.4.2.3.1>

    2023-04-02T16:24:12.040511   +x

    2023-04-02T16:24:12.145618  / # #

    2023-04-02T16:24:12.246614  export SHELL=3D/bin/sh

    2023-04-02T16:24:12.246798  #

    2023-04-02T16:24:12.347723  / # export SHELL=3D/bin/sh. /lava-9842712/e=
nvironment

    2023-04-02T16:24:12.347908  =


    2023-04-02T16:24:12.448859  / # . /lava-9842712/environment/lava-984271=
2/bin/lava-test-runner /lava-9842712/1

    2023-04-02T16:24:12.449166  =


    2023-04-02T16:24:12.453464  / # /lava-9842712/bin/lava-test-runner /lav=
a-9842712/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429ac45a99cdce2f562f7c6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429ac45a99cdce2f562f7cb
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:24:14.435164  <8>[   11.088330] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842713_1.4.2.3.1>

    2023-04-02T16:24:14.438455  + set +x

    2023-04-02T16:24:14.540054  #

    2023-04-02T16:24:14.540325  =


    2023-04-02T16:24:14.641289  / # #export SHELL=3D/bin/sh

    2023-04-02T16:24:14.641483  =


    2023-04-02T16:24:14.742382  / # export SHELL=3D/bin/sh. /lava-9842713/e=
nvironment

    2023-04-02T16:24:14.742606  =


    2023-04-02T16:24:14.843509  / # . /lava-9842713/environment/lava-984271=
3/bin/lava-test-runner /lava-9842713/1

    2023-04-02T16:24:14.843794  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6429b00454ce5c30e462f76c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6429b00454ce5c30e462f=
76d
        failing since 58 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6429afb3feec44ac0962f76b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429afb3feec44ac0962f770
        failing since 75 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-02T16:39:02.681143  + set +x<8>[   10.015507] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3464795_1.5.2.4.1>
    2023-04-02T16:39:02.681409  =

    2023-04-02T16:39:02.787985  / # #
    2023-04-02T16:39:02.889842  export SHELL=3D/bin/sh
    2023-04-02T16:39:02.890785  #
    2023-04-02T16:39:02.992705  / # export SHELL=3D/bin/sh. /lava-3464795/e=
nvironment
    2023-04-02T16:39:02.993665  =

    2023-04-02T16:39:03.095722  / # . /lava-3464795/environment/lava-346479=
5/bin/lava-test-runner /lava-3464795/1
    2023-04-02T16:39:03.097167  =

    2023-04-02T16:39:03.102131  / # /lava-3464795/bin/lava-test-runner /lav=
a-3464795/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429ac74915e78a1ea62f79f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429ac74915e78a1ea62f7a4
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:25:07.270070  + <8>[   10.737277] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9842732_1.4.2.3.1>

    2023-04-02T16:25:07.270156  set +x

    2023-04-02T16:25:07.371704  #

    2023-04-02T16:25:07.372009  =


    2023-04-02T16:25:07.473054  / # #export SHELL=3D/bin/sh

    2023-04-02T16:25:07.473306  =


    2023-04-02T16:25:07.574256  / # export SHELL=3D/bin/sh. /lava-9842732/e=
nvironment

    2023-04-02T16:25:07.574454  =


    2023-04-02T16:25:07.675370  / # . /lava-9842732/environment/lava-984273=
2/bin/lava-test-runner /lava-9842732/1

    2023-04-02T16:25:07.675648  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429ac461bcd73a80b62f830

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429ac461bcd73a80b62f835
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:24:19.450385  <8>[    7.991242] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842714_1.4.2.3.1>

    2023-04-02T16:24:19.453685  + set +x

    2023-04-02T16:24:19.558613  / # #

    2023-04-02T16:24:19.659638  export SHELL=3D/bin/sh

    2023-04-02T16:24:19.659857  #

    2023-04-02T16:24:19.760777  / # export SHELL=3D/bin/sh. /lava-9842714/e=
nvironment

    2023-04-02T16:24:19.761008  =


    2023-04-02T16:24:19.862044  / # . /lava-9842714/environment/lava-984271=
4/bin/lava-test-runner /lava-9842714/1

    2023-04-02T16:24:19.862343  =


    2023-04-02T16:24:19.866851  / # /lava-9842714/bin/lava-test-runner /lav=
a-9842714/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429ac54602d4b8d3162f77e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429ac54602d4b8d3162f783
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:24:39.010476  + set<8>[   10.956016] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9842655_1.4.2.3.1>

    2023-04-02T16:24:39.010903   +x

    2023-04-02T16:24:39.118475  / # #

    2023-04-02T16:24:39.221326  export SHELL=3D/bin/sh

    2023-04-02T16:24:39.222116  #

    2023-04-02T16:24:39.324358  / # export SHELL=3D/bin/sh. /lava-9842655/e=
nvironment

    2023-04-02T16:24:39.325165  =


    2023-04-02T16:24:39.427173  / # . /lava-9842655/environment/lava-984265=
5/bin/lava-test-runner /lava-9842655/1

    2023-04-02T16:24:39.428630  =


    2023-04-02T16:24:39.433387  / # /lava-9842655/bin/lava-test-runner /lav=
a-9842655/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6429ac4d09c0b3951662f777

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-62-g42320e2d46ce/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429ac4d09c0b3951662f77c
        failing since 5 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-02T16:24:23.566807  <8>[   12.307594] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9842729_1.4.2.3.1>

    2023-04-02T16:24:23.671954  / # #

    2023-04-02T16:24:23.772941  export SHELL=3D/bin/sh

    2023-04-02T16:24:23.773138  #

    2023-04-02T16:24:23.874077  / # export SHELL=3D/bin/sh. /lava-9842729/e=
nvironment

    2023-04-02T16:24:23.874299  =


    2023-04-02T16:24:23.975101  / # . /lava-9842729/environment/lava-984272=
9/bin/lava-test-runner /lava-9842729/1

    2023-04-02T16:24:23.975378  =


    2023-04-02T16:24:23.980349  / # /lava-9842729/bin/lava-test-runner /lav=
a-9842729/1

    2023-04-02T16:24:23.985874  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
