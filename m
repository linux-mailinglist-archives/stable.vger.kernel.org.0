Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610516D0BE8
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 18:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjC3Qxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 12:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjC3Qxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 12:53:34 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63ACEC52
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:53:09 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id l14so12962696pfc.11
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680195189;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zmvhps19aZI8ItK4lGrUtvfKMVknYhoYSk6vTbGhiiQ=;
        b=7QoxMRtsKcYKaFhzIefyPxhSnOr7n8AOo+pmAJiin/B3JhaQZVrcRyRMyOHyLnHNuq
         NZY2cReNgy2nox9kiGOne7iHgK/lnqBI7A0LY1WM6pL1JeJWJyTGsMacRqK1ROrXTRo+
         +u4299RyCifmuNPwV3gPdog1k4tDhRdJMHWLuPt2Eynx2m5raNmfZ6DCeb+OhMGTJgjw
         NEpA5iP6cJdxZZwVpkJEJ1F+rNdgMUhGUZry4V/+Sg5hWqz1hfe61xxuK/7U6jyXXooA
         3Iv9EFULUQgEE7cBJ/akbmhjppuD6kViN+D8trsO5d/KvPrqLp2w2VXE0+RNq6ZNpTZU
         zzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680195189;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zmvhps19aZI8ItK4lGrUtvfKMVknYhoYSk6vTbGhiiQ=;
        b=Y7nwZgOmj5VWMc9i4c/wL6YRWdQyb/1bLJunJ+r3Nh8Io4s77XbXzWhZBczIsyJ5Vx
         q3JC46L2UvCYCqFbaE/BzzT/cBn7dcqIyRjtIezGUqE2afx7c+kYvDtSu62JVHwvr/Aj
         /cXtGXkml8fFC4UR7zkKRtsKAm55JXdoPehIsautUz5IVQw0i7QHlwUbh9FJq4EHXEwd
         iSzBCRF7o1fRCf+509gaLKoIe19ljWDoel+jhFfHkeJOxnlTBIybcewTKVabpies4WZX
         mNR6bAJMuxPpFRIntb04po4yO/cquLoCutjmjLSEmi+W43bLlAjEg42q0loLwWrmfbyI
         yXQw==
X-Gm-Message-State: AAQBX9d6OiOxNaLSN83dJ/fwqcInluAYSSE5yi73B6hCoKTrl7mbMac1
        oGlZd3EbW+2Si/HFCLe2SGWUjzBlEVQvDDwLY6LPtQ==
X-Google-Smtp-Source: AKy350Za/MQcjiXJE7WhyN/cooOcrtLcAsedULe85X4hB+Mwv3T+d1nNxSN1mnu9EdyUSWT3kKJgXQ==
X-Received: by 2002:a62:1dca:0:b0:627:de2e:f1a5 with SMTP id d193-20020a621dca000000b00627de2ef1a5mr21335108pfd.4.1680195188799;
        Thu, 30 Mar 2023 09:53:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020aa78006000000b00627e87f51a5sm93273pfi.161.2023.03.30.09.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 09:53:08 -0700 (PDT)
Message-ID: <6425be74.a70a0220.fc95a.052a@mx.google.com>
Date:   Thu, 30 Mar 2023 09:53:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.105
Subject: stable/linux-5.15.y baseline: 241 runs, 16 regressions (v5.15.105)
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

stable/linux-5.15.y baseline: 241 runs, 16 regressions (v5.15.105)

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

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.105/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c957cbb8731536ddc9a01e4c1cd51eab6558aa14 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588ce0fcce46ae462f7a7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588ce0fcce46ae462f7ac
        new failure (last pass: v5.15.104)

    2023-03-30T13:03:54.057602  + set +x

    2023-03-30T13:03:54.064203  <8>[   11.571222] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816029_1.4.2.3.1>

    2023-03-30T13:03:54.173732  / # #

    2023-03-30T13:03:54.276810  export SHELL=3D/bin/sh

    2023-03-30T13:03:54.277663  #

    2023-03-30T13:03:54.379414  / # export SHELL=3D/bin/sh. /lava-9816029/e=
nvironment

    2023-03-30T13:03:54.380268  =


    2023-03-30T13:03:54.482136  / # . /lava-9816029/environment/lava-981602=
9/bin/lava-test-runner /lava-9816029/1

    2023-03-30T13:03:54.483497  =


    2023-03-30T13:03:54.489186  / # /lava-9816029/bin/lava-test-runner /lav=
a-9816029/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425899308311d84cd62f7a7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425899308311d84cd62f7ac
        new failure (last pass: v5.15.104)

    2023-03-30T13:07:11.787511  + set +x

    2023-03-30T13:07:11.793638  <8>[   10.449044] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816127_1.4.2.3.1>

    2023-03-30T13:07:11.901158  =


    2023-03-30T13:07:12.002316  / # #export SHELL=3D/bin/sh

    2023-03-30T13:07:12.002520  =


    2023-03-30T13:07:12.103651  / # export SHELL=3D/bin/sh. /lava-9816127/e=
nvironment

    2023-03-30T13:07:12.103851  =


    2023-03-30T13:07:12.204875  / # . /lava-9816127/environment/lava-981612=
7/bin/lava-test-runner /lava-9816127/1

    2023-03-30T13:07:12.206096  =


    2023-03-30T13:07:12.211006  / # /lava-9816127/bin/lava-test-runner /lav=
a-9816127/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588df56e1bf7cb362f76d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588df56e1bf7cb362f772
        new failure (last pass: v5.15.104)

    2023-03-30T13:04:16.228844  + <8>[    9.711006] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816042_1.4.2.3.1>

    2023-03-30T13:04:16.228934  set +x

    2023-03-30T13:04:16.333869  / # #

    2023-03-30T13:04:16.434914  export SHELL=3D/bin/sh

    2023-03-30T13:04:16.435173  #

    2023-03-30T13:04:16.536096  / # export SHELL=3D/bin/sh. /lava-9816042/e=
nvironment

    2023-03-30T13:04:16.536353  =


    2023-03-30T13:04:16.637373  / # . /lava-9816042/environment/lava-981604=
2/bin/lava-test-runner /lava-9816042/1

    2023-03-30T13:04:16.637709  =


    2023-03-30T13:04:16.642408  / # /lava-9816042/bin/lava-test-runner /lav=
a-9816042/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642589849a1f1f2c0062f7eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
M1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642589849a1f1f2c0062f7f0
        new failure (last pass: v5.15.104)

    2023-03-30T13:06:53.657204  + <8>[   11.135048] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816095_1.4.2.3.1>

    2023-03-30T13:06:53.657291  set +x

    2023-03-30T13:06:53.762630  / # #

    2023-03-30T13:06:53.863590  export SHELL=3D/bin/sh

    2023-03-30T13:06:53.863792  #

    2023-03-30T13:06:53.964719  / # export SHELL=3D/bin/sh. /lava-9816095/e=
nvironment

    2023-03-30T13:06:53.964924  =


    2023-03-30T13:06:54.065827  / # . /lava-9816095/environment/lava-981609=
5/bin/lava-test-runner /lava-9816095/1

    2023-03-30T13:06:54.066162  =


    2023-03-30T13:06:54.070757  / # /lava-9816095/bin/lava-test-runner /lav=
a-9816095/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588c3418cf757fd62f77c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588c3418cf757fd62f781
        new failure (last pass: v5.15.104)

    2023-03-30T13:03:57.342394  <8>[   11.261441] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816038_1.4.2.3.1>

    2023-03-30T13:03:57.346056  + set +x

    2023-03-30T13:03:57.451775  #

    2023-03-30T13:03:57.554430  / # #export SHELL=3D/bin/sh

    2023-03-30T13:03:57.555248  =


    2023-03-30T13:03:57.657324  / # export SHELL=3D/bin/sh. /lava-9816038/e=
nvironment

    2023-03-30T13:03:57.658161  =


    2023-03-30T13:03:57.760187  / # . /lava-9816038/environment/lava-981603=
8/bin/lava-test-runner /lava-9816038/1

    2023-03-30T13:03:57.761904  =


    2023-03-30T13:03:57.766634  / # /lava-9816038/bin/lava-test-runner /lav=
a-9816038/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64258986eb77991b5e62f76d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-c=
x9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64258986eb77991b5e62f772
        new failure (last pass: v5.15.104)

    2023-03-30T13:06:56.483902  <8>[   10.566423] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816150_1.4.2.3.1>

    2023-03-30T13:06:56.487448  + set +x

    2023-03-30T13:06:56.589257  #

    2023-03-30T13:06:56.690447  / # #export SHELL=3D/bin/sh

    2023-03-30T13:06:56.690776  =


    2023-03-30T13:06:56.791617  / # export SHELL=3D/bin/sh. /lava-9816150/e=
nvironment

    2023-03-30T13:06:56.791832  =


    2023-03-30T13:06:56.892864  / # . /lava-9816150/environment/lava-981615=
0/bin/lava-test-runner /lava-9816150/1

    2023-03-30T13:06:56.894571  =


    2023-03-30T13:06:56.899514  / # /lava-9816150/bin/lava-test-runner /lav=
a-9816150/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64258cf3193012c42b62f78e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64258cf3193012c42b62f793
        failing since 70 days (last pass: v5.15.82, first fail: v5.15.89)

    2023-03-30T13:21:24.107292  <8>[    9.864738] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3455500_1.5.2.4.1>
    2023-03-30T13:21:24.217611  / # #
    2023-03-30T13:21:24.321458  export SHELL=3D/bin/sh
    2023-03-30T13:21:24.322885  #
    2023-03-30T13:21:24.425504  / # export SHELL=3D/bin/sh. /lava-3455500/e=
nvironment
    2023-03-30T13:21:24.426686  =

    2023-03-30T13:21:24.528967  / # . /lava-3455500/environment/lava-345550=
0/bin/lava-test-runner /lava-3455500/1
    2023-03-30T13:21:24.530897  <3>[   10.193096] Bluetooth: hci0: command =
0xfc18 tx timeout
    2023-03-30T13:21:24.531389  =

    2023-03-30T13:21:24.535994  / # /lava-3455500/bin/lava-test-runner /lav=
a-3455500/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642589458224cac10062f7c6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642589458224cac10062f7c9
        failing since 27 days (last pass: v5.15.79, first fail: v5.15.97)

    2023-03-30T13:05:26.141272  [   10.656359] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1190369_1.5.2.4.1>
    2023-03-30T13:05:26.245299  / # #
    2023-03-30T13:05:26.347812  export SHELL=3D/bin/sh
    2023-03-30T13:05:26.348124  #
    2023-03-30T13:05:26.449203  / # export SHELL=3D/bin/sh. /lava-1190369/e=
nvironment
    2023-03-30T13:05:26.449763  =

    2023-03-30T13:05:26.551205  / # . /lava-1190369/environment/lava-119036=
9/bin/lava-test-runner /lava-1190369/1
    2023-03-30T13:05:26.552016  =

    2023-03-30T13:05:26.553814  / # /lava-1190369/bin/lava-test-runner /lav=
a-1190369/1
    2023-03-30T13:05:26.571211  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588df4737abc7ad62f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588df4737abc7ad62f780
        new failure (last pass: v5.15.104)

    2023-03-30T13:04:20.413600  + set +x<8>[   11.887428] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9816052_1.4.2.3.1>

    2023-03-30T13:04:20.414049  =


    2023-03-30T13:04:20.521511  / # #

    2023-03-30T13:04:20.624002  export SHELL=3D/bin/sh

    2023-03-30T13:04:20.624838  #

    2023-03-30T13:04:20.727137  / # export SHELL=3D/bin/sh. /lava-9816052/e=
nvironment

    2023-03-30T13:04:20.727885  =


    2023-03-30T13:04:20.829994  / # . /lava-9816052/environment/lava-981605=
2/bin/lava-test-runner /lava-9816052/1

    2023-03-30T13:04:20.831277  =


    2023-03-30T13:04:20.836475  / # /lava-9816052/bin/lava-test-runner /lav=
a-9816052/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642589bb71eef7e82162f79d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642589bb71eef7e82162f7a2
        new failure (last pass: v5.15.104)

    2023-03-30T13:07:53.460244  + set +x

    2023-03-30T13:07:53.466616  <8>[   10.431576] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816075_1.4.2.3.1>

    2023-03-30T13:07:53.571124  / # #

    2023-03-30T13:07:53.672159  export SHELL=3D/bin/sh

    2023-03-30T13:07:53.672371  #

    2023-03-30T13:07:53.773246  / # export SHELL=3D/bin/sh. /lava-9816075/e=
nvironment

    2023-03-30T13:07:53.773508  =


    2023-03-30T13:07:53.874439  / # . /lava-9816075/environment/lava-981607=
5/bin/lava-test-runner /lava-9816075/1

    2023-03-30T13:07:53.874720  =


    2023-03-30T13:07:53.879718  / # /lava-9816075/bin/lava-test-runner /lav=
a-9816075/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588da0fcce46ae462f80c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588da0fcce46ae462f811
        new failure (last pass: v5.15.104)

    2023-03-30T13:04:12.530566  + <8>[   11.221483] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816067_1.4.2.3.1>

    2023-03-30T13:04:12.534171  set +x

    2023-03-30T13:04:12.635795  /#

    2023-03-30T13:04:12.737065   # #export SHELL=3D/bin/sh

    2023-03-30T13:04:12.737408  =


    2023-03-30T13:04:12.838184  / # export SHELL=3D/bin/sh. /lava-9816067/e=
nvironment

    2023-03-30T13:04:12.838409  =


    2023-03-30T13:04:12.939306  / # . /lava-9816067/environment/lava-981606=
7/bin/lava-test-runner /lava-9816067/1

    2023-03-30T13:04:12.939617  =


    2023-03-30T13:04:12.945064  / # /lava-9816067/bin/lava-test-runner /lav=
a-9816067/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642589789a1f1f2c0062f78b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642589789a1f1f2c0062f790
        new failure (last pass: v5.15.104)

    2023-03-30T13:06:55.571903  <8>[   10.744772] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816115_1.4.2.3.1>

    2023-03-30T13:06:55.574983  + set +x

    2023-03-30T13:06:55.676619  #

    2023-03-30T13:06:55.777556  / # #export SHELL=3D/bin/sh

    2023-03-30T13:06:55.777781  =


    2023-03-30T13:06:55.878706  / # export SHELL=3D/bin/sh. /lava-9816115/e=
nvironment

    2023-03-30T13:06:55.878940  =


    2023-03-30T13:06:55.979863  / # . /lava-9816115/environment/lava-981611=
5/bin/lava-test-runner /lava-9816115/1

    2023-03-30T13:06:55.980165  =


    2023-03-30T13:06:55.984947  / # /lava-9816115/bin/lava-test-runner /lav=
a-9816115/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588cc0fcce46ae462f791

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588cc0fcce46ae462f796
        new failure (last pass: v5.15.104)

    2023-03-30T13:04:00.644859  + <8>[   11.462264] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816055_1.4.2.3.1>

    2023-03-30T13:04:00.644944  set +x

    2023-03-30T13:04:00.749739  / # #

    2023-03-30T13:04:00.850750  export SHELL=3D/bin/sh

    2023-03-30T13:04:00.850918  #

    2023-03-30T13:04:00.951845  / # export SHELL=3D/bin/sh. /lava-9816055/e=
nvironment

    2023-03-30T13:04:00.952010  =


    2023-03-30T13:04:01.052998  / # . /lava-9816055/environment/lava-981605=
5/bin/lava-test-runner /lava-9816055/1

    2023-03-30T13:04:01.053296  =


    2023-03-30T13:04:01.057988  / # /lava-9816055/bin/lava-test-runner /lav=
a-9816055/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642589859a1f1f2c0062f803

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642589859a1f1f2c0062f808
        new failure (last pass: v5.15.104)

    2023-03-30T13:06:53.546994  + <8>[   11.589582] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816117_1.4.2.3.1>

    2023-03-30T13:06:53.547085  set +x

    2023-03-30T13:06:53.651648  / # #

    2023-03-30T13:06:53.752613  export SHELL=3D/bin/sh

    2023-03-30T13:06:53.752827  #

    2023-03-30T13:06:53.853495  / # export SHELL=3D/bin/sh. /lava-9816117/e=
nvironment

    2023-03-30T13:06:53.853704  =


    2023-03-30T13:06:53.954617  / # . /lava-9816117/environment/lava-981611=
7/bin/lava-test-runner /lava-9816117/1

    2023-03-30T13:06:53.954897  =


    2023-03-30T13:06:53.959559  / # /lava-9816117/bin/lava-test-runner /lav=
a-9816117/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...ok+kselftest | 1          =


  Details:     https://kernelci.org/test/plan/id/642588b613bfa27b3c62f78a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook+kselftest
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook+kselftest/gcc-10/lab-collabora/basel=
ine-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642588b613bfa27b3c62f78f
        new failure (last pass: v5.15.104)

    2023-03-30T13:03:44.780001  + <8>[   13.595458] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816036_1.4.2.3.1>

    2023-03-30T13:03:44.780434  set +x

    2023-03-30T13:03:44.888232  / # #

    2023-03-30T13:03:44.991179  export SHELL=3D/bin/sh

    2023-03-30T13:03:44.991879  #

    2023-03-30T13:03:45.093632  / # export SHELL=3D/bin/sh. /lava-9816036/e=
nvironment

    2023-03-30T13:03:45.094318  =


    2023-03-30T13:03:45.196184  / # . /lava-9816036/environment/lava-981603=
6/bin/lava-test-runner /lava-9816036/1

    2023-03-30T13:03:45.197607  =


    2023-03-30T13:03:45.202385  / # /lava-9816036/bin/lava-test-runner /lav=
a-9816036/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425897a9a1f1f2c0062f796

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.105/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-lenovo=
-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425897a9a1f1f2c0062f79a
        new failure (last pass: v5.15.104)

    2023-03-30T13:06:50.125827  <8>[    9.186251] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816109_1.4.2.3.1>

    2023-03-30T13:06:50.230971  / # #

    2023-03-30T13:06:50.331957  export SHELL=3D/bin/sh

    2023-03-30T13:06:50.332188  #

    2023-03-30T13:06:50.433096  / # export SHELL=3D/bin/sh. /lava-9816109/e=
nvironment

    2023-03-30T13:06:50.433303  =


    2023-03-30T13:06:50.534168  / # . /lava-9816109/environment/lava-981610=
9/bin/lava-test-runner /lava-9816109/1

    2023-03-30T13:06:50.534509  =


    2023-03-30T13:06:50.539507  / # /lava-9816109/bin/lava-test-runner /lav=
a-9816109/1

    2023-03-30T13:06:50.544778  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
