Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6DD6E167E
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 23:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDMV3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 17:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDMV3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 17:29:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3F912A
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 14:29:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1a508c1333cso9934985ad.3
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 14:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681421380; x=1684013380;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=26zKsTEkSflxxJgsI/EKEuZ3wQfGfHRY6XSu8/ZiPvo=;
        b=3eRd4PgjywePXP9TKYDI82QM/jiTHTSMl+igmy9Lk+IO5W24WBHIbjzs7q50z0uGlA
         CqCDlacB2Lz5dsQInSnCQhfcBCmHmK7SNQItShY3+lQILs8FhtgEbtXv5Xi7cztokTX8
         bKzHC7mY3C7SpJf3bIArJbPbsdr+djTyoM1HyzQkCMqpJKFqM7V3d7f2OnSJJzeVBCsU
         vW4geFPjiVmbgqsvIuaCR06cTEx+Oj+wtMFFfhVHwkrRNykQEAQ4ctWpO7YX6oRI2Nwr
         3YYkzcehzVnBSAqJsGvuV3Z2v3kaATnuEXTNEUM40ddIuHFe5HlMOtHnAlfVQiaFgoWk
         1mEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681421380; x=1684013380;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26zKsTEkSflxxJgsI/EKEuZ3wQfGfHRY6XSu8/ZiPvo=;
        b=IDqttSb8mgPJf17BP9CNVPNmkPlAyTPGVQOg692EJo1zHgfX9fLDfP8ETklUH0sckx
         adeFfSx4QZy8sUi0G0LzJaJoO+I7n+UcTXOyyxnTuwh8zSYCXbKUa4qZAyOvutOnyLUf
         O+lNdpm7hHHzUmH/MY7aeIi3kIldcG8MNvAjUC95GBjI7QcwG0PA8j8cRnrff75KCN6E
         Mnvr1l0yv1dhDy74EOjDVspGviPNkejsL49g7vRJw/M2sz26dnl9nFQH88DWZGGxAymx
         yNWeK7d4g58JTm0QSz2ktnqFRIXGbiz7vMnjADuScRvITkRIDDvcKZgE1CG62I7bQoyR
         DgfQ==
X-Gm-Message-State: AAQBX9cf02yVIqIrn7oIRaClVcGALAWigfoW0ufbZWU4pZOERf7l8YjU
        BHKiVyeVtthoGRQM/ZcrJiYG3teZHyHL3RrPC6xOitxz
X-Google-Smtp-Source: AKy350bSdA7v+mcQbsguUNWJ8TMUpzToy6es51Gvysbork7gZOr3y1f/ycrJArEqYXwHcj0XaHpeZA==
X-Received: by 2002:a05:6a00:1a93:b0:638:d5a7:acc6 with SMTP id e19-20020a056a001a9300b00638d5a7acc6mr5604403pfv.9.1681421379659;
        Thu, 13 Apr 2023 14:29:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5-20020aa78105000000b006390e90b4e0sm1784829pfi.190.2023.04.13.14.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 14:29:39 -0700 (PDT)
Message-ID: <64387443.a70a0220.3d41e.4154@mx.google.com>
Date:   Thu, 13 Apr 2023 14:29:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.24
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 190 runs, 9 regressions (v6.1.24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 190 runs, 9 regressions (v6.1.24)

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

bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.24/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0102425ac76bd184704c698cab7cb4fe37997556 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6438401641e4558ba52e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C436=
FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438401641e4558ba52e8605
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:42.171142  + set +x

    2023-04-13T17:46:42.177791  <8>[   10.075022] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9963585_1.4.2.3.1>

    2023-04-13T17:46:42.286351  =


    2023-04-13T17:46:42.387324  / # #export SHELL=3D/bin/sh

    2023-04-13T17:46:42.387497  =


    2023-04-13T17:46:42.488433  / # export SHELL=3D/bin/sh. /lava-9963585/e=
nvironment

    2023-04-13T17:46:42.488964  =


    2023-04-13T17:46:42.590877  / # . /lava-9963585/environment/lava-996358=
5/bin/lava-test-runner /lava-9963585/1

    2023-04-13T17:46:42.592070  =


    2023-04-13T17:46:42.596892  / # /lava-9963585/bin/lava-test-runner /lav=
a-9963585/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643840096bca0088e62e8621

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-CM14=
00CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643840096bca0088e62e8626
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:30.103890  + set<8>[   11.411883] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9963534_1.4.2.3.1>

    2023-04-13T17:46:30.103980   +x

    2023-04-13T17:46:30.208649  / # #

    2023-04-13T17:46:30.309744  export SHELL=3D/bin/sh

    2023-04-13T17:46:30.309958  #

    2023-04-13T17:46:30.410680  / # export SHELL=3D/bin/sh. /lava-9963534/e=
nvironment

    2023-04-13T17:46:30.410898  =


    2023-04-13T17:46:30.511865  / # . /lava-9963534/environment/lava-996353=
4/bin/lava-test-runner /lava-9963534/1

    2023-04-13T17:46:30.512183  =


    2023-04-13T17:46:30.517197  / # /lava-9963534/bin/lava-test-runner /lav=
a-9963534/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64384015d87ea0a4832e85f2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-cx94=
00-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64384015d87ea0a4832e85f7
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:38.000480  <8>[   10.204520] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9963525_1.4.2.3.1>

    2023-04-13T17:46:38.004163  + set +x

    2023-04-13T17:46:38.105752  #

    2023-04-13T17:46:38.106049  =


    2023-04-13T17:46:38.207035  / # #export SHELL=3D/bin/sh

    2023-04-13T17:46:38.207223  =


    2023-04-13T17:46:38.308105  / # export SHELL=3D/bin/sh. /lava-9963525/e=
nvironment

    2023-04-13T17:46:38.308306  =


    2023-04-13T17:46:38.409245  / # . /lava-9963525/environment/lava-996352=
5/bin/lava-test-runner /lava-9963525/1

    2023-04-13T17:46:38.409543  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
bcm2835-rpi-b-rev2           | arm    | lab-broonie   | gcc-10   | bcm2835_=
defconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/6438402741e4558ba52e8620

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438402741e4558ba52e8653
        failing since 27 days (last pass: v6.1.19, first fail: v6.1.20)

    2023-04-13T17:46:55.923260  + set +x
    2023-04-13T17:46:55.927167  <8>[   17.817361] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 324133_1.5.2.4.1>
    2023-04-13T17:46:56.044098  / # #
    2023-04-13T17:46:56.146683  export SHELL=3D/bin/sh
    2023-04-13T17:46:56.147271  #
    2023-04-13T17:46:56.248784  / # export SHELL=3D/bin/sh. /lava-324133/en=
vironment
    2023-04-13T17:46:56.249391  =

    2023-04-13T17:46:56.350916  / # . /lava-324133/environment/lava-324133/=
bin/lava-test-runner /lava-324133/1
    2023-04-13T17:46:56.351735  =

    2023-04-13T17:46:56.357811  / # /lava-324133/bin/lava-test-runner /lava=
-324133/1 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64383ff3ede165e2e52e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
2b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64383ff3ede165e2e52e85ec
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:11.645464  + set +x

    2023-04-13T17:46:11.652009  <8>[   10.253049] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9963556_1.4.2.3.1>

    2023-04-13T17:46:11.757078  / # #

    2023-04-13T17:46:11.858138  export SHELL=3D/bin/sh

    2023-04-13T17:46:11.858375  #

    2023-04-13T17:46:11.959435  / # export SHELL=3D/bin/sh. /lava-9963556/e=
nvironment

    2023-04-13T17:46:11.959678  =


    2023-04-13T17:46:12.060671  / # . /lava-9963556/environment/lava-996355=
6/bin/lava-test-runner /lava-9963556/1

    2023-04-13T17:46:12.061023  =


    2023-04-13T17:46:12.065505  / # /lava-9963556/bin/lava-test-runner /lav=
a-9963556/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643840004c218bc0c92e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643840004c218bc0c92e8600
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:25.618464  + set +x

    2023-04-13T17:46:25.624724  <8>[   11.125377] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9963558_1.4.2.3.1>

    2023-04-13T17:46:25.726937  =


    2023-04-13T17:46:25.827961  / # #export SHELL=3D/bin/sh

    2023-04-13T17:46:25.828160  =


    2023-04-13T17:46:25.929146  / # export SHELL=3D/bin/sh. /lava-9963558/e=
nvironment

    2023-04-13T17:46:25.929336  =


    2023-04-13T17:46:26.030265  / # . /lava-9963558/environment/lava-996355=
8/bin/lava-test-runner /lava-9963558/1

    2023-04-13T17:46:26.030583  =


    2023-04-13T17:46:26.035398  / # /lava-9963558/bin/lava-test-runner /lav=
a-9963558/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64384007ede165e2e52e862a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360-1=
4a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64384007ede165e2e52e862f
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:28.489823  + set<8>[   11.593721] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9963581_1.4.2.3.1>

    2023-04-13T17:46:28.489910   +x

    2023-04-13T17:46:28.594565  / # #

    2023-04-13T17:46:28.695602  export SHELL=3D/bin/sh

    2023-04-13T17:46:28.695821  #

    2023-04-13T17:46:28.796804  / # export SHELL=3D/bin/sh. /lava-9963581/e=
nvironment

    2023-04-13T17:46:28.797007  =


    2023-04-13T17:46:28.897999  / # . /lava-9963581/environment/lava-996358=
1/bin/lava-test-runner /lava-9963581/1

    2023-04-13T17:46:28.898279  =


    2023-04-13T17:46:28.902802  / # /lava-9963581/bin/lava-test-runner /lav=
a-9963581/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64383ff46bca0088e62e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/x86=
_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo-TP=
ad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64383ff46bca0088e62e85ee
        failing since 14 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-13T17:46:16.862276  <8>[   12.458346] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9963535_1.4.2.3.1>

    2023-04-13T17:46:16.971096  / # #

    2023-04-13T17:46:17.073207  export SHELL=3D/bin/sh

    2023-04-13T17:46:17.074020  #

    2023-04-13T17:46:17.176050  / # export SHELL=3D/bin/sh. /lava-9963535/e=
nvironment

    2023-04-13T17:46:17.176995  =


    2023-04-13T17:46:17.279289  / # . /lava-9963535/environment/lava-996353=
5/bin/lava-test-runner /lava-9963535/1

    2023-04-13T17:46:17.280652  =


    2023-04-13T17:46:17.285572  / # /lava-9963535/bin/lava-test-runner /lav=
a-9963535/1

    2023-04-13T17:46:17.292106  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64383e52f5c4c978602e8658

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.24/mip=
s/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64383e52f5c4c97=
8602e8660
        new failure (last pass: v6.1.23)
        1 lines

    2023-04-13T17:39:06.840205  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eb673308, epc =3D=3D 80201ff4, ra =3D=
=3D 80204944
    2023-04-13T17:39:06.840413  =


    2023-04-13T17:39:06.877972  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-13T17:39:06.878151  =

   =

 =20
