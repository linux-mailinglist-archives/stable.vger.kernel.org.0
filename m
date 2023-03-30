Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96446D08B9
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 16:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjC3Owf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 10:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbjC3Owb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 10:52:31 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696CF975E
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 07:52:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id z11so12701090pfh.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 07:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680187944;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wpI+oSsiIG0As4onzJoDuabNJbmkZBM/RrizMddWKBQ=;
        b=3YSP8N0jajDIGbXPPBsS4qT+JvHh43cNZsUBegimirBzGH6Yyu0isqf4HT23r8e6F5
         z+OQKU6oLYGNBru68NL76YWW+ANtzNGST55mCkyKOxvW6EcUivAugg9qGMUZ7FBANteU
         gwGg0mr0ddUKwefG3h9kR85TWicgxuL4iuqe2a/wkprg9EJRag3rlBiCCqGbNZZPtfxW
         BHUtfHTkfdUzugarr//x15CNF46jBVhCVtememLUn6ntrZeo+M5YATMWihGPpe2KSSAJ
         FE1Y6DJC9Thw9Li1gUMXVndG07Jc6yM1UiJsw4geisW9sGUuDFHsdSA7ktkdjv59oUsQ
         Wv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680187944;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wpI+oSsiIG0As4onzJoDuabNJbmkZBM/RrizMddWKBQ=;
        b=NmneACJHech4kcjOvFXM1bbTQqppA5RhXt2zx19hepi/Js5xp+Zugvprij4h8q9UPO
         tL/SVwvrFKm8KqwOvt+Ob7ZO7haI3uhz2SraVIeyA7Nqii2o9XCilJrC2l7LY5xu5R4G
         82dMxjQ4w7X83h4COnCaEPW0tLPvph27Q3MmRohBbyEvxceZt+dfNMiESHd0zZwwPTp6
         z1MuSZ7+YaD96X7V8J/rL74rIeAjYQKmgUeoufTE29986+elP0rcSNlXxtoRL/bf6liX
         bm+ylJAk/2pZJ7olqCk3CnSciqdRy1wV2UrDDWnJ4EozoYo9yRh3t1cmWy04Jt/RJfY3
         zg7g==
X-Gm-Message-State: AAQBX9dDRvdIO3acnSyFlgsotvxC0DqC0TcHN1BO0nwBoOzboV3BqHUK
        yBJeVzv+sZIXBooFZaEATCncDPFfKtxDI6L5pe1owQ==
X-Google-Smtp-Source: AKy350ZJizJP+OhjNvSbYDsqO9MJMAs2bTO1yQPHZQBGDumSd2NWu8d9w5REE5uXYiCw3gKV0UBKew==
X-Received: by 2002:a62:1b12:0:b0:627:f9ac:8a33 with SMTP id b18-20020a621b12000000b00627f9ac8a33mr20518093pfb.13.1680187944131;
        Thu, 30 Mar 2023 07:52:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c22-20020aa78816000000b005a8b28c644esm1954pfo.4.2023.03.30.07.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:52:23 -0700 (PDT)
Message-ID: <6425a227.a70a0220.a1640.0030@mx.google.com>
Date:   Thu, 30 Mar 2023 07:52:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/6.1
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.21-223-g5b480bfab207
Subject: stable-rc/queue/6.1 baseline: 180 runs,
 9 regressions (v6.1.21-223-g5b480bfab207)
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

stable-rc/queue/6.1 baseline: 180 runs, 9 regressions (v6.1.21-223-g5b480bf=
ab207)

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

odroid-xu3                   | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.21-223-g5b480bfab207/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.21-223-g5b480bfab207
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b480bfab207dc807ba916c8b11944edd3b34a34 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256bded57efd68e262f778

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256bded57efd68e262f77d
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:00:29.384612  <8>[   10.650872] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813909_1.4.2.3.1>

    2023-03-30T11:00:29.387857  + set +x

    2023-03-30T11:00:29.495919  / # #

    2023-03-30T11:00:29.598451  export SHELL=3D/bin/sh

    2023-03-30T11:00:29.599226  #

    2023-03-30T11:00:29.701032  / # export SHELL=3D/bin/sh. /lava-9813909/e=
nvironment

    2023-03-30T11:00:29.701774  =


    2023-03-30T11:00:29.803495  / # . /lava-9813909/environment/lava-981390=
9/bin/lava-test-runner /lava-9813909/1

    2023-03-30T11:00:29.804674  =


    2023-03-30T11:00:29.810531  / # /lava-9813909/bin/lava-test-runner /lav=
a-9813909/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256be3b1a256d0a562f7b7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256be3b1a256d0a562f7bc
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:00:36.281436  + set<8>[   11.166959] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9813903_1.4.2.3.1>

    2023-03-30T11:00:36.281534   +x

    2023-03-30T11:00:36.386139  / # #

    2023-03-30T11:00:36.487188  export SHELL=3D/bin/sh

    2023-03-30T11:00:36.487393  #

    2023-03-30T11:00:36.588268  / # export SHELL=3D/bin/sh. /lava-9813903/e=
nvironment

    2023-03-30T11:00:36.588473  =


    2023-03-30T11:00:36.689378  / # . /lava-9813903/environment/lava-981390=
3/bin/lava-test-runner /lava-9813903/1

    2023-03-30T11:00:36.689722  =


    2023-03-30T11:00:36.694639  / # /lava-9813903/bin/lava-test-runner /lav=
a-9813903/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256c0bd5af45a77562f76f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256c0bd5af45a77562f774
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:01:24.921892  <8>[   10.275736] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813963_1.4.2.3.1>

    2023-03-30T11:01:24.925352  + set +x

    2023-03-30T11:01:25.030872  #

    2023-03-30T11:01:25.134234  / # #export SHELL=3D/bin/sh

    2023-03-30T11:01:25.135174  =


    2023-03-30T11:01:25.237245  / # export SHELL=3D/bin/sh. /lava-9813963/e=
nvironment

    2023-03-30T11:01:25.238234  =


    2023-03-30T11:01:25.339990  / # . /lava-9813963/environment/lava-981396=
3/bin/lava-test-runner /lava-9813963/1

    2023-03-30T11:01:25.340336  =


    2023-03-30T11:01:25.345324  / # /lava-9813963/bin/lava-test-runner /lav=
a-9813963/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256d8196b19779cd62f7b2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256d8196b19779cd62f7b7
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:07:32.215479  + set +x

    2023-03-30T11:07:32.221773  <8>[   10.592187] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813929_1.4.2.3.1>

    2023-03-30T11:07:32.330458  / # #

    2023-03-30T11:07:32.433755  export SHELL=3D/bin/sh

    2023-03-30T11:07:32.434719  #

    2023-03-30T11:07:32.536534  / # export SHELL=3D/bin/sh. /lava-9813929/e=
nvironment

    2023-03-30T11:07:32.536797  =


    2023-03-30T11:07:32.637711  / # . /lava-9813929/environment/lava-981392=
9/bin/lava-test-runner /lava-9813929/1

    2023-03-30T11:07:32.638054  =


    2023-03-30T11:07:32.642472  / # /lava-9813929/bin/lava-test-runner /lav=
a-9813929/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256c7a50d38835f362f76e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256c7a50d38835f362f773
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:03:01.828919  <8>[   10.205713] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813948_1.4.2.3.1>

    2023-03-30T11:03:01.831942  + set +x

    2023-03-30T11:03:01.934688  #

    2023-03-30T11:03:01.935820  =


    2023-03-30T11:03:02.038154  / # #export SHELL=3D/bin/sh

    2023-03-30T11:03:02.038977  =


    2023-03-30T11:03:02.140664  / # export SHELL=3D/bin/sh. /lava-9813948/e=
nvironment

    2023-03-30T11:03:02.141390  =


    2023-03-30T11:03:02.243219  / # . /lava-9813948/environment/lava-981394=
8/bin/lava-test-runner /lava-9813948/1

    2023-03-30T11:03:02.244504  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256bd89a91e2636262f7bf

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256bd89a91e2636262f7c4
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:00:19.786190  + <8>[   11.096269] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9813923_1.4.2.3.1>

    2023-03-30T11:00:19.786277  set +x

    2023-03-30T11:00:19.890000  / # #

    2023-03-30T11:00:19.991020  export SHELL=3D/bin/sh

    2023-03-30T11:00:19.991287  #

    2023-03-30T11:00:20.092345  / # export SHELL=3D/bin/sh. /lava-9813923/e=
nvironment

    2023-03-30T11:00:20.092638  =


    2023-03-30T11:00:20.193870  / # . /lava-9813923/environment/lava-981392=
3/bin/lava-test-runner /lava-9813923/1

    2023-03-30T11:00:20.195195  =


    2023-03-30T11:00:20.199627  / # /lava-9813923/bin/lava-test-runner /lav=
a-9813923/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64256bc6684a78287162f7e5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256bc6684a78287162f7ea
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)

    2023-03-30T11:00:09.918407  <8>[   11.911778] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9813919_1.4.2.3.1>

    2023-03-30T11:00:10.023414  / # #

    2023-03-30T11:00:10.124470  export SHELL=3D/bin/sh

    2023-03-30T11:00:10.124703  #

    2023-03-30T11:00:10.225598  / # export SHELL=3D/bin/sh. /lava-9813919/e=
nvironment

    2023-03-30T11:00:10.225827  =


    2023-03-30T11:00:10.326754  / # . /lava-9813919/environment/lava-981391=
9/bin/lava-test-runner /lava-9813919/1

    2023-03-30T11:00:10.327065  =


    2023-03-30T11:00:10.331504  / # /lava-9813919/bin/lava-test-runner /lav=
a-9813919/1

    2023-03-30T11:00:10.338246  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
odroid-xu3                   | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64256d63b411b9577262f798

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64256d63b411b9577262f=
799
        new failure (last pass: v6.1.21-104-gd5eb32be5b26) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64256aa6e2f85c7a9a62f784

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.21-22=
3-g5b480bfab207/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64256aa6e2f85c7=
a9a62f78c
        failing since 1 day (last pass: v6.1.21-104-gd5eb32be5b26, first fa=
il: v6.1.21-224-g1abeb39fad59)
        1 lines

    2023-03-30T10:55:11.708779  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb827dc4, epc =3D=3D 80201f24, ra =3D=
=3D 80204874
    2023-03-30T10:55:11.708994  =


    2023-03-30T10:55:11.748863  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-30T10:55:11.749042  =

   =

 =20
