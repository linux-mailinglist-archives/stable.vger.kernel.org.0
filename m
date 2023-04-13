Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826716E15E2
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 22:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDMUcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 16:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDMUca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 16:32:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C46A1999
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 13:32:28 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-247061537b3so351969a91.2
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 13:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681417947; x=1684009947;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=i9BZG4EJiUGlwi1Uiuc6ZHVPHEHbnX7rpyS0NfPzomU=;
        b=qQIdTmNXqtvCEokb7h1q3hhX00pSkQRdip8yCWrAMaEsq5SuVIbomTj3UXfr8KqnWB
         ord6TQSK2Udx+CsRsDKWq7uYWJuCiEKm0Fui9lBqVjK2nAXLAGLTQ0wSTcMs/WK8TPMQ
         Y4WDkUDTsglANh7rKE/wjW3IA/YsZFMCMV3s81DZD2CFeVThLhJCe/j65QRA9eOkZcfq
         x9r4t263pa12yt5OkbQ6Z8cILSkoDhAMNc3bCMBBA9gNWlgUDnMheIlxFCtX3dbYq9oc
         FXBCZv72JJFToA5a/4JrMpn/xVAC9SUeoChUKW5So52gwMigGsvblCpWdPlBNTPsZWHG
         yoKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681417947; x=1684009947;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9BZG4EJiUGlwi1Uiuc6ZHVPHEHbnX7rpyS0NfPzomU=;
        b=HrQlfDuel3EjK/25soD/KV/Mit3EuyOqZw/PcS0p5BHOhu0WIujL8bCa8BCq9t9TEp
         4LVtBFTajEnKUYs2alqpVfyGvOeG2s3e54sl7UcAMhl3sWgXngNZwy+UKF+TPpLT65KE
         3nBv4BK+c/YR4Ckm6xXy/ImJs4jQmZaoN9bdmGmWPI20NuHYQfKcOY3M8ZCDeI7+XdhQ
         nhWquF3XbRwrA/lUuKt6S4ySCJcRMLr8j0FSu8ESRSEV8A49ramXcepckqrhkXtZG8Ni
         EYItLKWQ5p9SeknZr58CEbasApNKG9PzqhAFIKB0VQJEBX9Ue+2NvqcxS8ABV1PKPzYj
         9LQQ==
X-Gm-Message-State: AAQBX9f4qU6EAfQ2mKQeJY1ir4MFc/pd2gu1ZaqSBMaxU5Y7hCDvRzeP
        NtdAZdMnO0aJNOwlOxx8Wif2EqLVs0O7/z/Erj6kpoBd
X-Google-Smtp-Source: AKy350b1pLUd+7NcVDE9h65a+td44QNHXHvipX5SbohcYB3NXp4+CQFiAan+z+qXJ2yni/nbZYQfyw==
X-Received: by 2002:a05:6a00:1a8c:b0:625:ea57:389b with SMTP id e12-20020a056a001a8c00b00625ea57389bmr5439283pfv.5.1681417947150;
        Thu, 13 Apr 2023 13:32:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22-20020aa784d6000000b00638965d4248sm1750274pfn.184.2023.04.13.13.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 13:32:26 -0700 (PDT)
Message-ID: <643866da.a70a0220.92a3d.3dcc@mx.google.com>
Date:   Thu, 13 Apr 2023 13:32:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-187-gb3794375c5f0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 188 runs,
 10 regressions (v5.15.105-187-gb3794375c5f0)
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

stable-rc/queue/5.15 baseline: 188 runs, 10 regressions (v5.15.105-187-gb37=
94375c5f0)

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

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-187-gb3794375c5f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-187-gb3794375c5f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3794375c5f050500698c75668e0d7e0901e5273 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643834638741539de42e8608

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643834638741539de42e860d
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:56:52.464834  <8>[   11.134621] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962447_1.4.2.3.1>

    2023-04-13T16:56:52.468487  + set +x

    2023-04-13T16:56:52.573980  / #

    2023-04-13T16:56:52.677218  # #export SHELL=3D/bin/sh

    2023-04-13T16:56:52.677990  =


    2023-04-13T16:56:52.779589  / # export SHELL=3D/bin/sh. /lava-9962447/e=
nvironment

    2023-04-13T16:56:52.779840  =


    2023-04-13T16:56:52.880796  / # . /lava-9962447/environment/lava-996244=
7/bin/lava-test-runner /lava-9962447/1

    2023-04-13T16:56:52.881053  =


    2023-04-13T16:56:52.887049  / # /lava-9962447/bin/lava-test-runner /lav=
a-9962447/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64383463430156a2332e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64383463430156a2332e85eb
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:56:43.833895  + set<8>[   11.423365] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9962477_1.4.2.3.1>

    2023-04-13T16:56:43.833985   +x

    2023-04-13T16:56:43.938465  / # #

    2023-04-13T16:56:44.039448  export SHELL=3D/bin/sh

    2023-04-13T16:56:44.039679  #

    2023-04-13T16:56:44.140416  / # export SHELL=3D/bin/sh. /lava-9962477/e=
nvironment

    2023-04-13T16:56:44.140602  =


    2023-04-13T16:56:44.241561  / # . /lava-9962477/environment/lava-996247=
7/bin/lava-test-runner /lava-9962477/1

    2023-04-13T16:56:44.241858  =


    2023-04-13T16:56:44.246964  / # /lava-9962477/bin/lava-test-runner /lav=
a-9962477/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6438346193b46a18ed2e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438346193b46a18ed2e8606
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:56:44.690840  <8>[   10.879670] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962438_1.4.2.3.1>

    2023-04-13T16:56:44.693834  + set +x

    2023-04-13T16:56:44.795672  =


    2023-04-13T16:56:44.896429  / # #export SHELL=3D/bin/sh

    2023-04-13T16:56:44.896629  =


    2023-04-13T16:56:44.997551  / # export SHELL=3D/bin/sh. /lava-9962438/e=
nvironment

    2023-04-13T16:56:44.997744  =


    2023-04-13T16:56:45.098690  / # . /lava-9962438/environment/lava-996243=
8/bin/lava-test-runner /lava-9962438/1

    2023-04-13T16:56:45.098977  =


    2023-04-13T16:56:45.104349  / # /lava-9962438/bin/lava-test-runner /lav=
a-9962438/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64383755f956dae2132e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64383755f956dae2132e8=
5e7
        failing since 69 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6438343a7292613a6d2e85f6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438343a7292613a6d2e85fb
        failing since 86 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-13T16:56:01.749054  <8>[   15.523707] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3492064_1.5.2.4.1>
    2023-04-13T16:56:01.859732  / # #
    2023-04-13T16:56:01.963529  export SHELL=3D/bin/sh
    2023-04-13T16:56:01.964427  #
    2023-04-13T16:56:02.066467  / # export SHELL=3D/bin/sh. /lava-3492064/e=
nvironment
    2023-04-13T16:56:02.067356  =

    2023-04-13T16:56:02.169376  / # . /lava-3492064/environment/lava-349206=
4/bin/lava-test-runner /lava-3492064/1
    2023-04-13T16:56:02.170853  =

    2023-04-13T16:56:02.175955  / # /lava-3492064/bin/lava-test-runner /lav=
a-3492064/1
    2023-04-13T16:56:02.261279  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643834821dbb5c3bc02e85f8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643834821dbb5c3bc02e85fd
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:57:22.061427  + set +x

    2023-04-13T16:57:22.068159  <8>[   10.799213] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962454_1.4.2.3.1>

    2023-04-13T16:57:22.173421  / # #

    2023-04-13T16:57:22.274557  export SHELL=3D/bin/sh

    2023-04-13T16:57:22.274773  #

    2023-04-13T16:57:22.375775  / # export SHELL=3D/bin/sh. /lava-9962454/e=
nvironment

    2023-04-13T16:57:22.375985  =


    2023-04-13T16:57:22.476892  / # . /lava-9962454/environment/lava-996245=
4/bin/lava-test-runner /lava-9962454/1

    2023-04-13T16:57:22.477289  =


    2023-04-13T16:57:22.482234  / # /lava-9962454/bin/lava-test-runner /lav=
a-9962454/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6438344d8b8040703b2e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438344d8b8040703b2e860b
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:56:30.237574  <8>[   10.254347] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962478_1.4.2.3.1>

    2023-04-13T16:56:30.240912  + set +x

    2023-04-13T16:56:30.342853  #

    2023-04-13T16:56:30.343187  =


    2023-04-13T16:56:30.444254  / # #export SHELL=3D/bin/sh

    2023-04-13T16:56:30.444492  =


    2023-04-13T16:56:30.545461  / # export SHELL=3D/bin/sh. /lava-9962478/e=
nvironment

    2023-04-13T16:56:30.545688  =


    2023-04-13T16:56:30.646666  / # . /lava-9962478/environment/lava-996247=
8/bin/lava-test-runner /lava-9962478/1

    2023-04-13T16:56:30.647039  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6438346160f31809a22e85ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438346160f31809a22e85f2
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:56:43.587509  + <8>[   11.637636] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9962481_1.4.2.3.1>

    2023-04-13T16:56:43.587593  set +x

    2023-04-13T16:56:43.692691  / # #

    2023-04-13T16:56:43.793683  export SHELL=3D/bin/sh

    2023-04-13T16:56:43.793941  #

    2023-04-13T16:56:43.894944  / # export SHELL=3D/bin/sh. /lava-9962481/e=
nvironment

    2023-04-13T16:56:43.895266  =


    2023-04-13T16:56:43.996290  / # . /lava-9962481/environment/lava-996248=
1/bin/lava-test-runner /lava-9962481/1

    2023-04-13T16:56:43.996574  =


    2023-04-13T16:56:44.001157  / # /lava-9962481/bin/lava-test-runner /lav=
a-9962481/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6438344e7a0d9e65122e860d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438344e7a0d9e65122e8612
        failing since 16 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-13T16:56:30.190625  <8>[    9.602929] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9962437_1.4.2.3.1>

    2023-04-13T16:56:30.294926  / # #

    2023-04-13T16:56:30.395714  export SHELL=3D/bin/sh

    2023-04-13T16:56:30.395874  #

    2023-04-13T16:56:30.496777  / # export SHELL=3D/bin/sh. /lava-9962437/e=
nvironment

    2023-04-13T16:56:30.497037  =


    2023-04-13T16:56:30.597993  / # . /lava-9962437/environment/lava-996243=
7/bin/lava-test-runner /lava-9962437/1

    2023-04-13T16:56:30.598250  =


    2023-04-13T16:56:30.602804  / # /lava-9962437/bin/lava-test-runner /lav=
a-9962437/1

    2023-04-13T16:56:30.608413  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre  | gcc-10   | sunxi_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/64383a1d1051c577872e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-187-gb3794375c5f0/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64383a1d1051c577872e85eb
        failing since 72 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-13T17:21:23.823879  <8>[    5.717466] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3492036_1.5.2.4.1>
    2023-04-13T17:21:23.943190  #
    2023-04-13T17:21:24.049142  / # #export SHELL=3D/bin/sh
    2023-04-13T17:21:24.050752  =

    2023-04-13T17:21:24.154022  / # export SHELL=3D/bin/sh. /lava-3492036/e=
nvironment
    2023-04-13T17:21:24.155556  =

    2023-04-13T17:21:24.259027  / # . /lava-3492036/environment/lava-349203=
6/bin/lava-test-runner /lava-3492036/1
    2023-04-13T17:21:24.261656  =

    2023-04-13T17:21:24.268693  / # /lava-3492036/bin/lava-test-runner /lav=
a-3492036/1
    2023-04-13T17:21:24.389542  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
