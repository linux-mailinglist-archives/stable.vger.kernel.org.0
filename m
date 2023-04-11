Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EEB6DE321
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 19:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjDKRum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 13:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjDKRug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 13:50:36 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503D41FE2
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 10:50:35 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f2so224457pjs.3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 10:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681235434; x=1683827434;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eWhmk1CaGGUz7mUnl3lPNN4Y4o4ejoHXsVzUGLT9p40=;
        b=lUWWQ8ywHtX2uunkS6P+zXWwuqweb8J/fA0qEo7SbAReBXUxEYRXxgpGhHtk2GKpvp
         frb4o+tMc1zf+oyUF2amltyHOzwEY/Vi5Qytrx8lHfGHZmbyVkkW39SMxS7rrnepkWrs
         ayn+6HyD920wiMPnmnlTHyo2fXJAlGH+MUbLVmttRiA0sJeRYStqyd0eiCvzS6zgylmz
         xrT7V1Fzw3gufPV+iHrFDlYRy/uJahFjL8Im5M9gKxtTeOsCwWKu/R3ROINpqwSDFXO/
         60oXOpyUCj6NH+PHnrmJbP5p+8HsWCrB7AgieGCqGQwnx6DwmnflolKINcIgAFDCY6M8
         yrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681235434; x=1683827434;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eWhmk1CaGGUz7mUnl3lPNN4Y4o4ejoHXsVzUGLT9p40=;
        b=aEyM0r39vnuiGE/EaJ4yEnLf9jaFoQatFoY0kFf8b2g+gOoKE1T6nw7jlEtC69r3l7
         i+QMR5al6WtSLBwRHMyOVahBOsZxGrzAghsj/2gV7cklUrITKK4MJ1JyNypmJIv1zLAi
         9dwlt8qqnf1+FikpGGo2pCZIpuN7Dm3Abm9haEBsYfxGAlQhQqGkJU6btyZ4xh3YrlsK
         bU/pZ7oxl6Lb9WBXdCCcStLUQ9N45wP81PomQ38fyssPw/5xZThhPCzEJiwcFxnmwZ6W
         sNWlh+iaVK65LQgqWlwysuzFF/uDK/fOJchWUvIvOuIgQWd2lFROyU4/nv31r4uhKNhx
         B9uA==
X-Gm-Message-State: AAQBX9d3rxSNoXlkfSw9oZwdNe/02FJdm1dJcAXEAAc7hfNobUF9rDEE
        dHFrs7arA29gIROfwZtLd0377zUpcjy9sGhXBaXt4Q==
X-Google-Smtp-Source: AKy350YfQ/kECglZCVko09d3lxnqCb4AKYhKDBpZfZCZFEowkckT+KRu1mMV3rKslmvV1rjDzKljyA==
X-Received: by 2002:a05:6a20:491c:b0:da:4d25:8fdd with SMTP id ft28-20020a056a20491c00b000da4d258fddmr16474927pzb.38.1681235434392;
        Tue, 11 Apr 2023 10:50:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4-20020aa78584000000b0063a577151d5sm2712260pfn.68.2023.04.11.10.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 10:50:33 -0700 (PDT)
Message-ID: <64359de9.a70a0220.53790.66f5@mx.google.com>
Date:   Tue, 11 Apr 2023 10:50:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-307-gbd76ed54ff54
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 168 runs,
 7 regressions (v6.1.22-307-gbd76ed54ff54)
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

stable-rc/queue/6.1 baseline: 168 runs, 7 regressions (v6.1.22-307-gbd76ed5=
4ff54)

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
el/v6.1.22-307-gbd76ed54ff54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-307-gbd76ed54ff54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bd76ed54ff54d16b9095ad715276663b75e2a379 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356779391e5a41902e868c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356779391e5a41902e8691
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:59.321540  + set +x

    2023-04-11T13:57:59.327724  <8>[   10.333930] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9937138_1.4.2.3.1>

    2023-04-11T13:57:59.432384  / # #

    2023-04-11T13:57:59.533356  export SHELL=3D/bin/sh

    2023-04-11T13:57:59.533512  #

    2023-04-11T13:57:59.634392  / # export SHELL=3D/bin/sh. /lava-9937138/e=
nvironment

    2023-04-11T13:57:59.634596  =


    2023-04-11T13:57:59.735522  / # . /lava-9937138/environment/lava-993713=
8/bin/lava-test-runner /lava-9937138/1

    2023-04-11T13:57:59.735805  =


    2023-04-11T13:57:59.741092  / # /lava-9937138/bin/lava-test-runner /lav=
a-9937138/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356770391e5a41902e867f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356770391e5a41902e8684
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:49.388336  + set<8>[   11.320051] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9937132_1.4.2.3.1>

    2023-04-11T13:57:49.388772   +x

    2023-04-11T13:57:49.496878  / # #

    2023-04-11T13:57:49.599692  export SHELL=3D/bin/sh

    2023-04-11T13:57:49.600383  #

    2023-04-11T13:57:49.702058  / # export SHELL=3D/bin/sh. /lava-9937132/e=
nvironment

    2023-04-11T13:57:49.702958  =


    2023-04-11T13:57:49.805225  / # . /lava-9937132/environment/lava-993713=
2/bin/lava-test-runner /lava-9937132/1

    2023-04-11T13:57:49.806430  =


    2023-04-11T13:57:49.811608  / # /lava-9937132/bin/lava-test-runner /lav=
a-9937132/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435676d276e7a74092e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435676d276e7a74092e85fe
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:48.545704  <8>[   10.445844] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9937125_1.4.2.3.1>

    2023-04-11T13:57:48.549494  + set +x

    2023-04-11T13:57:48.654550  / #

    2023-04-11T13:57:48.757531  # #export SHELL=3D/bin/sh

    2023-04-11T13:57:48.758294  =


    2023-04-11T13:57:48.860156  / # export SHELL=3D/bin/sh. /lava-9937125/e=
nvironment

    2023-04-11T13:57:48.860898  =


    2023-04-11T13:57:48.962897  / # . /lava-9937125/environment/lava-993712=
5/bin/lava-test-runner /lava-9937125/1

    2023-04-11T13:57:48.963935  =


    2023-04-11T13:57:48.968687  / # /lava-9937125/bin/lava-test-runner /lav=
a-9937125/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356763a711a247962e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356763a711a247962e85f5
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:46.100043  + set +x

    2023-04-11T13:57:46.106387  <8>[   10.326409] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9937148_1.4.2.3.1>

    2023-04-11T13:57:46.211408  / # #

    2023-04-11T13:57:46.312404  export SHELL=3D/bin/sh

    2023-04-11T13:57:46.312573  #

    2023-04-11T13:57:46.413494  / # export SHELL=3D/bin/sh. /lava-9937148/e=
nvironment

    2023-04-11T13:57:46.413668  =


    2023-04-11T13:57:46.514641  / # . /lava-9937148/environment/lava-993714=
8/bin/lava-test-runner /lava-9937148/1

    2023-04-11T13:57:46.514931  =


    2023-04-11T13:57:46.519547  / # /lava-9937148/bin/lava-test-runner /lav=
a-9937148/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356753e9c3ef80092e85f8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356753e9c3ef80092e85fd
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:26.695397  + set +x

    2023-04-11T13:57:26.702388  <8>[   10.675079] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9937158_1.4.2.3.1>

    2023-04-11T13:57:26.811854  =


    2023-04-11T13:57:26.913980  / # #export SHELL=3D/bin/sh

    2023-04-11T13:57:26.914770  =


    2023-04-11T13:57:27.016838  / # export SHELL=3D/bin/sh. /lava-9937158/e=
nvironment

    2023-04-11T13:57:27.017629  =


    2023-04-11T13:57:27.119798  / # . /lava-9937158/environment/lava-993715=
8/bin/lava-test-runner /lava-9937158/1

    2023-04-11T13:57:27.121128  =


    2023-04-11T13:57:27.126355  / # /lava-9937158/bin/lava-test-runner /lav=
a-9937158/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356769e8d271f4b42e85fd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356769e8d271f4b42e8602
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:48.888058  + set +x<8>[   11.037495] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9937129_1.4.2.3.1>

    2023-04-11T13:57:48.888536  =


    2023-04-11T13:57:48.996839  / # #

    2023-04-11T13:57:49.099384  export SHELL=3D/bin/sh

    2023-04-11T13:57:49.100062  #

    2023-04-11T13:57:49.201893  / # export SHELL=3D/bin/sh. /lava-9937129/e=
nvironment

    2023-04-11T13:57:49.202560  =


    2023-04-11T13:57:49.304601  / # . /lava-9937129/environment/lava-993712=
9/bin/lava-test-runner /lava-9937129/1

    2023-04-11T13:57:49.305688  =


    2023-04-11T13:57:49.310597  / # /lava-9937129/bin/lava-test-runner /lav=
a-9937129/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64356756eb6fb693072e85f5

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-30=
7-gbd76ed54ff54/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64356756eb6fb693072e85fa
        failing since 13 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-11T13:57:29.053297  <8>[   12.467199] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9937104_1.4.2.3.1>

    2023-04-11T13:57:29.157478  / # #

    2023-04-11T13:57:29.258394  export SHELL=3D/bin/sh

    2023-04-11T13:57:29.258569  #

    2023-04-11T13:57:29.359484  / # export SHELL=3D/bin/sh. /lava-9937104/e=
nvironment

    2023-04-11T13:57:29.359692  =


    2023-04-11T13:57:29.460616  / # . /lava-9937104/environment/lava-993710=
4/bin/lava-test-runner /lava-9937104/1

    2023-04-11T13:57:29.460906  =


    2023-04-11T13:57:29.465650  / # /lava-9937104/bin/lava-test-runner /lav=
a-9937104/1

    2023-04-11T13:57:29.472043  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
