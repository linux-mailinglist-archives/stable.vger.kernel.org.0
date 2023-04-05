Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DBF6D82C2
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 17:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjDEP4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 11:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238153AbjDEP4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 11:56:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF05119
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 08:56:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id ix20so34844797plb.3
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 08:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680710184;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uROdUI4AEH6IibzyIshr/YCQqYcf7lgbRzatzbgkGPM=;
        b=eZTNUmpj7B5bXbVLn1c7B5izISyZvaOidLguxHfrche7t494RFeVzmyelPJCgG1CIp
         nsHZ15rpI6oRoZQGlufK/Isak0dph4LxlwtukmrEbFqvpQAI3GvSiSKuXIVQWpQqVwKC
         ocX2/UX0iBq64vfVOkAZ2rVy9PtwSasnEygG1t/5S/juVIJRPqsh1BWSs29M4Rh/g6n8
         X+/pw3t0V1zaC5NTxd/NtCVnRrMmee3QOLNMKxwJIFljJg/sU2iP+rlpynYi3Eb26kOb
         BaVNx+kOovQW5GpaPrAF5C5dFZyV8Xi5i2Zl1TxT7Qxgllg1zudTs1YDDqs9x0M+n2zE
         3b1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710184;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uROdUI4AEH6IibzyIshr/YCQqYcf7lgbRzatzbgkGPM=;
        b=SZ9itrGq0hkso7NQPbBgP40zVvhA3AQPnqxecV4PsBg9AomNbo4gPg27y6zoQ49kfk
         LQlr+OAT7T4dj62kzYARyMC1gxl3M1u+QccGoAHOPLOaIeU9B9Eh89a/iW5sYmLKBa/9
         LPdJwocXD7sdLN35SuB9s/Mmu9TvOZYkO82Ffdmcxj4AYhuniWPEk+6b342c5PuGYcYg
         OkU8rxvUIEWBVb0hs20/ZGIvGi6tz8JvO87xzUTM/TBjH9a6vDiQ96p+firCg5zStbNP
         iU+eX+X//TKPuD17PT2E6m/xyq0W30+x1jXlXx3VCG7SJMKyUKag8AaloF3cjIoSlwja
         H8fQ==
X-Gm-Message-State: AAQBX9fSMoOrTFhlO7oAeE6AlgA+E7tY36DtP7OJYHYOOPbVwJdeWBZv
        quLwILoZqSXBGJOyuOAdrdEThjJtAr1cX9rM4zWSKw==
X-Google-Smtp-Source: AKy350ZbRooqx2HvxXszm2gj0M0VWAqacdym4/RKzOZCaHK6TokCuIMRa2aqDUMWJGYFBqM+L4x2yg==
X-Received: by 2002:a17:902:cacd:b0:1a2:9d86:c366 with SMTP id y13-20020a170902cacd00b001a29d86c366mr4955815pld.64.1680710183885;
        Wed, 05 Apr 2023 08:56:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x16-20020a170902b41000b0019f3e339fb4sm10300301plr.187.2023.04.05.08.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:56:23 -0700 (PDT)
Message-ID: <642d9a27.170a0220.fca47.58f6@mx.google.com>
Date:   Wed, 05 Apr 2023 08:56:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.106
Subject: stable/linux-5.15.y baseline: 231 runs, 16 regressions (v5.15.106)
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

stable/linux-5.15.y baseline: 231 runs, 16 regressions (v5.15.106)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm...ok+kselftest | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.106/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.106
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d86dfc4d95cd218246b10ca7adf22c8626547599 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d641951f91c99de79e92a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d641951f91c99de79e92f
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:05:37.160411  + set +x

    2023-04-05T12:05:37.166988  <8>[   11.912120] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878187_1.4.2.3.1>

    2023-04-05T12:05:37.276359  / # #

    2023-04-05T12:05:37.377400  export SHELL=3D/bin/sh

    2023-04-05T12:05:37.377566  #

    2023-04-05T12:05:37.478585  / # export SHELL=3D/bin/sh. /lava-9878187/e=
nvironment

    2023-04-05T12:05:37.479218  =


    2023-04-05T12:05:37.581305  / # . /lava-9878187/environment/lava-987818=
7/bin/lava-test-runner /lava-9878187/1

    2023-04-05T12:05:37.581565  =


    2023-04-05T12:05:37.586236  / # /lava-9878187/bin/lava-test-runner /lav=
a-9878187/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d661bc7de7b484479e972

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d661bc7de7b484479e977
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:14:01.539393  <8>[   10.745211] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878364_1.4.2.3.1>

    2023-04-05T12:14:01.542763  + set +x

    2023-04-05T12:14:01.647533  / # #

    2023-04-05T12:14:01.748647  export SHELL=3D/bin/sh

    2023-04-05T12:14:01.748844  #

    2023-04-05T12:14:01.849733  / # export SHELL=3D/bin/sh. /lava-9878364/e=
nvironment

    2023-04-05T12:14:01.849922  =


    2023-04-05T12:14:01.950816  / # . /lava-9878364/environment/lava-987836=
4/bin/lava-test-runner /lava-9878364/1

    2023-04-05T12:14:01.951107  =


    2023-04-05T12:14:01.955976  / # /lava-9878364/bin/lava-test-runner /lav=
a-9878364/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6432df6a9d6dc179e93b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6432df6a9d6dc179e940
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:06:02.609843  + <8>[   12.287769] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9878203_1.4.2.3.1>

    2023-04-05T12:06:02.610526  set +x

    2023-04-05T12:06:02.719177  / # #

    2023-04-05T12:06:02.822153  export SHELL=3D/bin/sh

    2023-04-05T12:06:02.823037  #

    2023-04-05T12:06:02.925333  / # export SHELL=3D/bin/sh. /lava-9878203/e=
nvironment

    2023-04-05T12:06:02.926225  =


    2023-04-05T12:06:03.028353  / # . /lava-9878203/environment/lava-987820=
3/bin/lava-test-runner /lava-9878203/1

    2023-04-05T12:06:03.029933  =


    2023-04-05T12:06:03.033974  / # /lava-9878203/bin/lava-test-runner /lav=
a-9878203/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d661253e51c38c679e93a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d661253e51c38c679e93f
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:13:57.109204  + <8>[   11.744888] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9878312_1.4.2.3.1>

    2023-04-05T12:13:57.109803  set +x

    2023-04-05T12:13:57.218184  / # #

    2023-04-05T12:13:57.321308  export SHELL=3D/bin/sh

    2023-04-05T12:13:57.322217  #

    2023-04-05T12:13:57.424323  / # export SHELL=3D/bin/sh. /lava-9878312/e=
nvironment

    2023-04-05T12:13:57.425232  =


    2023-04-05T12:13:57.527463  / # . /lava-9878312/environment/lava-987831=
2/bin/lava-test-runner /lava-9878312/1

    2023-04-05T12:13:57.528820  =


    2023-04-05T12:13:57.533270  / # /lava-9878312/bin/lava-test-runner /lav=
a-9878312/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d641d51f91c99de79e938

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d641d51f91c99de79e93d
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:05:42.709208  <8>[   12.016164] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878195_1.4.2.3.1>

    2023-04-05T12:05:42.712568  + set +x

    2023-04-05T12:05:42.814303  #

    2023-04-05T12:05:42.814548  =


    2023-04-05T12:05:42.915542  / # #export SHELL=3D/bin/sh

    2023-04-05T12:05:42.916263  =


    2023-04-05T12:05:43.018046  / # export SHELL=3D/bin/sh. /lava-9878195/e=
nvironment

    2023-04-05T12:05:43.018809  =


    2023-04-05T12:05:43.120495  / # . /lava-9878195/environment/lava-987819=
5/bin/lava-test-runner /lava-9878195/1

    2023-04-05T12:05:43.120818  =

 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d660dc7de7b484479e938

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d660dc7de7b484479e93d
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:13:42.563184  <8>[   10.815514] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878306_1.4.2.3.1>

    2023-04-05T12:13:42.566485  + set +x

    2023-04-05T12:13:42.668025  #

    2023-04-05T12:13:42.769183  / # #export SHELL=3D/bin/sh

    2023-04-05T12:13:42.769368  =


    2023-04-05T12:13:42.870281  / # export SHELL=3D/bin/sh. /lava-9878306/e=
nvironment

    2023-04-05T12:13:42.870523  =


    2023-04-05T12:13:42.971516  / # . /lava-9878306/environment/lava-987830=
6/bin/lava-test-runner /lava-9878306/1

    2023-04-05T12:13:42.971784  =


    2023-04-05T12:13:42.976080  / # /lava-9878306/bin/lava-test-runner /lav=
a-9878306/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6961c5f6cbc32f79e956

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642d6961c5f6cbc32f79e=
957
        new failure (last pass: v5.15.105) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642d69660ff118d9b679e96b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d69660ff118d9b679e970
        failing since 76 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-04-05T12:27:37.449114  <8>[    9.921703] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3473399_1.5.2.4.1>
    2023-04-05T12:27:37.560948  / # #
    2023-04-05T12:27:37.662336  export SHELL=3D/bin/sh
    2023-04-05T12:27:37.662771  #
    2023-04-05T12:27:37.764035  / # export SHELL=3D/bin/sh. /lava-3473399/e=
nvironment
    2023-04-05T12:27:37.764408  =

    2023-04-05T12:27:37.764562  / # <3>[   10.193246] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-05T12:27:37.865674  . /lava-3473399/environment/lava-3473399/bi=
n/lava-test-runner /lava-3473399/1
    2023-04-05T12:27:37.866241  =

    2023-04-05T12:27:37.871588  / # /lava-3473399/bin/lava-test-runner /lav=
a-3473399/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6518d8ea7cd0e679e9a4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6518d8ea7cd0e679e9a9
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:09:52.426911  + set +x<8>[   12.070894] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9878199_1.4.2.3.1>

    2023-04-05T12:09:52.427039  =


    2023-04-05T12:09:52.531645  / # #

    2023-04-05T12:09:52.632824  export SHELL=3D/bin/sh

    2023-04-05T12:09:52.633013  #

    2023-04-05T12:09:52.733987  / # export SHELL=3D/bin/sh. /lava-9878199/e=
nvironment

    2023-04-05T12:09:52.734186  =


    2023-04-05T12:09:52.835084  / # . /lava-9878199/environment/lava-987819=
9/bin/lava-test-runner /lava-9878199/1

    2023-04-05T12:09:52.835359  =


    2023-04-05T12:09:52.839913  / # /lava-9878199/bin/lava-test-runner /lav=
a-9878199/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6690d51eb68cde79e93a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6690d51eb68cde79e93f
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:16:00.170967  + <8>[    9.973352] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9878351_1.4.2.3.1>

    2023-04-05T12:16:00.171051  set +x

    2023-04-05T12:16:00.272697  #

    2023-04-05T12:16:00.272988  =


    2023-04-05T12:16:00.374095  / # #export SHELL=3D/bin/sh

    2023-04-05T12:16:00.374722  =


    2023-04-05T12:16:00.476405  / # export SHELL=3D/bin/sh. /lava-9878351/e=
nvironment

    2023-04-05T12:16:00.477103  =


    2023-04-05T12:16:00.578965  / # . /lava-9878351/environment/lava-987835=
1/bin/lava-test-runner /lava-9878351/1

    2023-04-05T12:16:00.580119  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d64d502061b22e679e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d64d502061b22e679e927
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:08:48.093058  + set +x

    2023-04-05T12:08:48.099477  <8>[   11.285253] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878196_1.4.2.3.1>

    2023-04-05T12:08:48.207686  / # #

    2023-04-05T12:08:48.308937  export SHELL=3D/bin/sh

    2023-04-05T12:08:48.309676  #

    2023-04-05T12:08:48.411405  / # export SHELL=3D/bin/sh. /lava-9878196/e=
nvironment

    2023-04-05T12:08:48.412125  =


    2023-04-05T12:08:48.514004  / # . /lava-9878196/environment/lava-987819=
6/bin/lava-test-runner /lava-9878196/1

    2023-04-05T12:08:48.515163  =


    2023-04-05T12:08:48.520797  / # /lava-9878196/bin/lava-test-runner /lav=
a-9878196/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6432df6a9d6dc179e946

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6432df6a9d6dc179e94b
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:05:49.492174  + <8>[   12.576152] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9878181_1.4.2.3.1>

    2023-04-05T12:05:49.492702  set +x

    2023-04-05T12:05:49.599988  / # #

    2023-04-05T12:05:49.702696  export SHELL=3D/bin/sh

    2023-04-05T12:05:49.703539  #

    2023-04-05T12:05:49.805401  / # export SHELL=3D/bin/sh. /lava-9878181/e=
nvironment

    2023-04-05T12:05:49.806172  =


    2023-04-05T12:05:49.907943  / # . /lava-9878181/environment/lava-987818=
1/bin/lava-test-runner /lava-9878181/1

    2023-04-05T12:05:49.909162  =


    2023-04-05T12:05:49.914118  / # /lava-9878181/bin/lava-test-runner /lav=
a-9878181/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6613c66f9909dc79e94f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6613c66f9909dc79e954
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:13:52.240856  + set +x<8>[   11.106298] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9878302_1.4.2.3.1>

    2023-04-05T12:13:52.241290  =


    2023-04-05T12:13:52.348586  / # #

    2023-04-05T12:13:52.450961  export SHELL=3D/bin/sh

    2023-04-05T12:13:52.451644  #

    2023-04-05T12:13:52.553351  / # export SHELL=3D/bin/sh. /lava-9878302/e=
nvironment

    2023-04-05T12:13:52.554263  =


    2023-04-05T12:13:52.656420  / # . /lava-9878302/environment/lava-987830=
2/bin/lava-test-runner /lava-9878302/1

    2023-04-05T12:13:52.657488  =


    2023-04-05T12:13:52.662328  / # /lava-9878302/bin/lava-test-runner /lav=
a-9878302/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d64232d050bc14679e953

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d64242d050bc14679e958
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:05:36.826971  + <8>[   12.892298] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9878188_1.4.2.3.1>

    2023-04-05T12:05:36.827056  set +x

    2023-04-05T12:05:36.931942  / # #

    2023-04-05T12:05:37.032987  export SHELL=3D/bin/sh

    2023-04-05T12:05:37.033192  #

    2023-04-05T12:05:37.134119  / # export SHELL=3D/bin/sh. /lava-9878188/e=
nvironment

    2023-04-05T12:05:37.134336  =


    2023-04-05T12:05:37.235294  / # . /lava-9878188/environment/lava-987818=
8/bin/lava-test-runner /lava-9878188/1

    2023-04-05T12:05:37.235608  =


    2023-04-05T12:05:37.240455  / # /lava-9878188/bin/lava-test-runner /lav=
a-9878188/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d65f4435a4314c579ea44

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d65f4435a4314c579ea49
        failing since 5 days (last pass: v5.15.104, first fail: v5.15.105)

    2023-04-05T12:13:32.351944  + set<8>[   13.733013] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9878300_1.4.2.3.1>

    2023-04-05T12:13:32.352056   +x

    2023-04-05T12:13:32.456854  / # #

    2023-04-05T12:13:32.557883  export SHELL=3D/bin/sh

    2023-04-05T12:13:32.558116  #

    2023-04-05T12:13:32.659059  / # export SHELL=3D/bin/sh. /lava-9878300/e=
nvironment

    2023-04-05T12:13:32.659282  =


    2023-04-05T12:13:32.760071  / # . /lava-9878300/environment/lava-987830=
0/bin/lava-test-runner /lava-9878300/1

    2023-04-05T12:13:32.760456  =


    2023-04-05T12:13:32.765660  / # /lava-9878300/bin/lava-test-runner /lav=
a-9878300/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
mt8173-elm-hana              | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642d67755f4510226579e941

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook+kselftest
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.106/=
arm64/defconfig+arm64-chromebook+kselftest/gcc-10/lab-collabora/baseline-mt=
8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642d67755f4510226579e=
942
        failing since 71 days (last pass: v5.15.89, first fail: v5.15.90) =

 =20
