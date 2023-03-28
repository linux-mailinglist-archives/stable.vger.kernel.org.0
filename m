Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2F16CC5AD
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjC1PQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjC1PP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:15:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124D41042B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:15:10 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so12942723pjb.0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680016485;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c1YAOZjy7KCEP302bg2Kk3IUhzlJ3s1WJRoR9luz6qw=;
        b=4L40TXMrlJKPU+jsGz3l4FeyNG0o4exf88izPa0dVOs9K6hkGzwQmy9P2l29TIOtx6
         MI/pCojuVvtHFUokTXe3bd6ok3RaRTpX5jtkzGLvn8/9cvudOok0IDTcdfd0xmwwj6dM
         aMYMBVMtHo3vzWCIOA4lgTv13EkT51QdVeL5QjIyPJAEa176KHIdjciSiY8N3nH6iS+D
         BQSspA0FDZ0kGDbwseb9P+9JiTprX24OqXaC0IBJDziC33bZ386afXlsSK6e4K0BB57m
         ySqmHHqckEfixkPbDk4FPktD8rHTvJ7rCORG5iJdV5MRsrFCZCrxDsGTyKg+g2KPB58i
         GwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680016485;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c1YAOZjy7KCEP302bg2Kk3IUhzlJ3s1WJRoR9luz6qw=;
        b=ZDesVGAerDByvC7lAmo714d1nUFHYckWeY6xGjypc9bADDYQaENI1VRv/x/8T1RcWZ
         gbryQu5uanNRfOuMo9XPf1DNEnDD9HRlRU94zu+XgB07UDtG+L4ebxkuwKi3HYmnqX+l
         d6Gpt1gkLs9K+4+jE7gVpBAmwU5q4N0/cQ39geILsaU3fjXK3Tn2po6fPJju6zVYjw9H
         jaAVTmOGZdYPQVYIf7IL/aIKo1J4LQ91eBB2yThTctXENNVchvHx0mumoR0wCS1ocy/u
         LazM1SzSuZCWaFpW9JRxtcyB4R6X1l1x0cbX7+jtj7iquB9iWAt37Ez97olkessccIvP
         mcyQ==
X-Gm-Message-State: AO0yUKUSY8LKFr/KAZNN1qXZsLj5hmtzQm+Eg+7nsRMNUKLXfCzXO6Xl
        v1Zuempd9H/oaCsKB0SQ0z4JUDc8eXDLWtsgwU3Ubw==
X-Google-Smtp-Source: AK7set9gWL0pGkEwDzN+Gq2wRh2nzvpV9c6wcfvoPk8v76VoWtJV5oKqsaE9Y/qLxB0LgG9vyDR1Kw==
X-Received: by 2002:a05:6a20:7a29:b0:dc:a214:6352 with SMTP id t41-20020a056a207a2900b000dca2146352mr12350629pzh.10.1680016485291;
        Tue, 28 Mar 2023 08:14:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k9-20020aa790c9000000b00625ee4c50eesm21192592pfk.77.2023.03.28.08.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:14:45 -0700 (PDT)
Message-ID: <64230465.a70a0220.49ed2.5e06@mx.google.com>
Date:   Tue, 28 Mar 2023 08:14:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-83-ga131fb06fbdb
Subject: stable-rc/queue/5.15 baseline: 111 runs,
 7 regressions (v5.15.104-83-ga131fb06fbdb)
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

stable-rc/queue/5.15 baseline: 111 runs, 7 regressions (v5.15.104-83-ga131f=
b06fbdb)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-83-ga131fb06fbdb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-83-ga131fb06fbdb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a131fb06fbdb9d36793e8e53fc2966006e33daf9 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbf363d945481c62f7db

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbf363d945481c62f7e0
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:13:32.253137  <8>[   10.387937] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9793313_1.4.2.3.1>

    2023-03-28T11:13:32.256237  + set +x

    2023-03-28T11:13:32.360931  / # #

    2023-03-28T11:13:32.461981  export SHELL=3D/bin/sh

    2023-03-28T11:13:32.462225  #

    2023-03-28T11:13:32.563218  / # export SHELL=3D/bin/sh. /lava-9793313/e=
nvironment

    2023-03-28T11:13:32.563413  =


    2023-03-28T11:13:32.664550  / # . /lava-9793313/environment/lava-979331=
3/bin/lava-test-runner /lava-9793313/1

    2023-03-28T11:13:32.664849  =


    2023-03-28T11:13:32.670566  / # /lava-9793313/bin/lava-test-runner /lav=
a-9793313/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbe4f45cb5664062f77a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbe4f45cb5664062f77f
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:13:19.451555  + <8>[   10.910005] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9793249_1.4.2.3.1>

    2023-03-28T11:13:19.452064  set +x

    2023-03-28T11:13:19.560386  / # #

    2023-03-28T11:13:19.663076  export SHELL=3D/bin/sh

    2023-03-28T11:13:19.663259  #

    2023-03-28T11:13:19.764221  / # export SHELL=3D/bin/sh. /lava-9793249/e=
nvironment

    2023-03-28T11:13:19.764462  =


    2023-03-28T11:13:19.865576  / # . /lava-9793249/environment/lava-979324=
9/bin/lava-test-runner /lava-9793249/1

    2023-03-28T11:13:19.866850  =


    2023-03-28T11:13:19.871338  / # /lava-9793249/bin/lava-test-runner /lav=
a-9793249/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbe3055172b33f62f7ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbe3055172b33f62f7f2
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:13:16.545657  <8>[    7.922685] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9793274_1.4.2.3.1>

    2023-03-28T11:13:16.549014  + set +x

    2023-03-28T11:13:16.655237  =


    2023-03-28T11:13:16.757508  / # #export SHELL=3D/bin/sh

    2023-03-28T11:13:16.758390  =


    2023-03-28T11:13:16.860273  / # export SHELL=3D/bin/sh. /lava-9793274/e=
nvironment

    2023-03-28T11:13:16.861148  =


    2023-03-28T11:13:16.962980  / # . /lava-9793274/environment/lava-979327=
4/bin/lava-test-runner /lava-9793274/1

    2023-03-28T11:13:16.964129  =


    2023-03-28T11:13:16.969013  / # /lava-9793274/bin/lava-test-runner /lav=
a-9793274/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbdf055172b33f62f7ae

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbdf055172b33f62f7b3
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:13:18.370749  + set +x

    2023-03-28T11:13:18.377150  <8>[    9.960895] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9793252_1.4.2.3.1>

    2023-03-28T11:13:18.481967  / # #

    2023-03-28T11:13:18.583039  export SHELL=3D/bin/sh

    2023-03-28T11:13:18.583293  #

    2023-03-28T11:13:18.684234  / # export SHELL=3D/bin/sh. /lava-9793252/e=
nvironment

    2023-03-28T11:13:18.684466  =


    2023-03-28T11:13:18.785454  / # . /lava-9793252/environment/lava-979325=
2/bin/lava-test-runner /lava-9793252/1

    2023-03-28T11:13:18.785786  =


    2023-03-28T11:13:18.790429  / # /lava-9793252/bin/lava-test-runner /lav=
a-9793252/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbc3ff0cfb876c62f7bd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbc3ff0cfb876c62f7c2
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:12:53.269917  <8>[   10.842871] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9793295_1.4.2.3.1>

    2023-03-28T11:12:53.272830  + set +x

    2023-03-28T11:12:53.374576  #

    2023-03-28T11:12:53.374924  =


    2023-03-28T11:12:53.475887  / # #export SHELL=3D/bin/sh

    2023-03-28T11:12:53.476115  =


    2023-03-28T11:12:53.576897  / # export SHELL=3D/bin/sh. /lava-9793295/e=
nvironment

    2023-03-28T11:12:53.577144  =


    2023-03-28T11:12:53.678054  / # . /lava-9793295/environment/lava-979329=
5/bin/lava-test-runner /lava-9793295/1

    2023-03-28T11:12:53.678387  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbde055172b33f62f7a3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbde055172b33f62f7a8
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:13:19.454445  + <8>[   10.884547] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9793280_1.4.2.3.1>

    2023-03-28T11:13:19.454544  set +x

    2023-03-28T11:13:19.559032  / # #

    2023-03-28T11:13:19.660041  export SHELL=3D/bin/sh

    2023-03-28T11:13:19.660274  #

    2023-03-28T11:13:19.761174  / # export SHELL=3D/bin/sh. /lava-9793280/e=
nvironment

    2023-03-28T11:13:19.761413  =


    2023-03-28T11:13:19.862363  / # . /lava-9793280/environment/lava-979328=
0/bin/lava-test-runner /lava-9793280/1

    2023-03-28T11:13:19.862689  =


    2023-03-28T11:13:19.867363  / # /lava-9793280/bin/lava-test-runner /lav=
a-9793280/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6422cbc10667c09c0462f770

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-83-ga131fb06fbdb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6422cbc10667c09c0462f775
        new failure (last pass: v5.15.104-76-g9168fe5021cf1)

    2023-03-28T11:12:55.511429  <8>[   12.327846] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9793253_1.4.2.3.1>

    2023-03-28T11:12:55.615798  / # #

    2023-03-28T11:12:55.716866  export SHELL=3D/bin/sh

    2023-03-28T11:12:55.717075  #

    2023-03-28T11:12:55.817961  / # export SHELL=3D/bin/sh. /lava-9793253/e=
nvironment

    2023-03-28T11:12:55.818224  =


    2023-03-28T11:12:55.919195  / # . /lava-9793253/environment/lava-979325=
3/bin/lava-test-runner /lava-9793253/1

    2023-03-28T11:12:55.919531  =


    2023-03-28T11:12:55.923870  / # /lava-9793253/bin/lava-test-runner /lav=
a-9793253/1

    2023-03-28T11:12:55.929437  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
