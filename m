Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A49C6CCF8A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 03:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjC2BeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 21:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC2BeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 21:34:13 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68954173E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 18:34:11 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k2so13459898pll.8
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 18:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680053650;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qma2ty+6/DTpykfToaWzjkahvqUtM0AdyDId+eY97aY=;
        b=Dpaa1/ieTdqHiPhJC93uIjhxls1pJMMy9BiePx9twX6YZoVAKrfu89toygVWxnbuc4
         wPNyj6RAbY3tzjVyrG8m8I1NpbKuQaNDJm5bQ3dUJinZhJnT7ycRs6KA7jg4ipD1zM2j
         Po7FCX9g5ZOZq4H4nzHds7XW/GOaRN1ROeKfPZQwu8RdKrjbOxwyixABrAtWIcWoJVM0
         fYZP4ELxqvshpeYI/lEprm5KpfBMkhCquqNOwyd8A3PNMstHezHMp2N7gx8N37LCFjM9
         eimYW4716YrgmsWeyVHU01ye0job4px4c4vAmmmcJ7F8Td5Msv7QzJS52J+Z9hSLxNGk
         0Prg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680053650;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qma2ty+6/DTpykfToaWzjkahvqUtM0AdyDId+eY97aY=;
        b=YTEoZqO1U+pbMx00zUajFOC1c7tmmLt7KQsyZr3zHlWkcsY1emcD1pjcp3vTqoGQtc
         uiC1T2tUNjeQG8lgh6Xe9j9ayAj9/Z5LtFQhoBL/tv40pPySo0983z9jiVLrPHbSKOg8
         fMjNsLgMLdIg06FlN63OYDEX28ZpFowOT27kGdvjJv8QNV2IqbMCWi1W6unpT4Gx2JRr
         nyMc2qvufS/Wg04eDSjBmSMSyes3PH4xncgOw8lmwByUNeq4sL3QVPv9kFv+niYC3o+W
         A+yeN/VV6ZDTWcndq12Lkn+tt2V54hHWJtQUIAeLXnoKCWLUSKkfxIh802+6bPFFJRfc
         tQNQ==
X-Gm-Message-State: AAQBX9e2ZEIZ+woR2hiNz627hX1bZlzXJXd2UaDOJXNEcu7PSoxbPlLp
        lF3mcT4flAWwmZmuOy2x1tSoR9Zsw7/oTtNyCCa7kA==
X-Google-Smtp-Source: AKy350aaS6/bZNbmMXrQ1XifACHJUf5eMVfbJfZt3d/7K4RPhJA86CAGdD2hWCf324cdCATKtEAiOw==
X-Received: by 2002:a17:902:da87:b0:19c:c9da:a62e with SMTP id j7-20020a170902da8700b0019cc9daa62emr20656695plx.54.1680053650516;
        Tue, 28 Mar 2023 18:34:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20-20020a170902d89400b001a217a7a11csm9009468plz.131.2023.03.28.18.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 18:34:10 -0700 (PDT)
Message-ID: <64239592.170a0220.358d0.0908@mx.google.com>
Date:   Tue, 28 Mar 2023 18:34:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-147-gea115396267e
Subject: stable-rc/linux-5.15.y baseline: 125 runs,
 9 regressions (v5.15.104-147-gea115396267e)
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

stable-rc/linux-5.15.y baseline: 125 runs, 9 regressions (v5.15.104-147-gea=
115396267e)

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

kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.104-147-gea115396267e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.104-147-gea115396267e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea115396267e89b54136b19bb93bd16781a9d033 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bc403b57e51d762f77b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bc403b57e51d762f780
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:24.185341  + set +x

    2023-03-28T21:27:24.191720  <8>[   10.364307] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9799769_1.4.2.3.1>

    2023-03-28T21:27:24.296575  / # #

    2023-03-28T21:27:24.397540  export SHELL=3D/bin/sh

    2023-03-28T21:27:24.397725  #

    2023-03-28T21:27:24.498584  / # export SHELL=3D/bin/sh. /lava-9799769/e=
nvironment

    2023-03-28T21:27:24.498764  =


    2023-03-28T21:27:24.599677  / # . /lava-9799769/environment/lava-979976=
9/bin/lava-test-runner /lava-9799769/1

    2023-03-28T21:27:24.599957  =


    2023-03-28T21:27:24.606057  / # /lava-9799769/bin/lava-test-runner /lav=
a-9799769/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bd919c0c3668762f7d2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bd919c0c3668762f7d7
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:29.044700  + set<8>[    8.904338] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9799750_1.4.2.3.1>

    2023-03-28T21:27:29.045366   +x

    2023-03-28T21:27:29.153615  / # #

    2023-03-28T21:27:29.255098  export SHELL=3D/bin/sh

    2023-03-28T21:27:29.255918  #

    2023-03-28T21:27:29.357714  / # export SHELL=3D/bin/sh. /lava-9799750/e=
nvironment

    2023-03-28T21:27:29.358708  =


    2023-03-28T21:27:29.460746  / # . /lava-9799750/environment/lava-979975=
0/bin/lava-test-runner /lava-9799750/1

    2023-03-28T21:27:29.461935  =


    2023-03-28T21:27:29.466773  / # /lava-9799750/bin/lava-test-runner /lav=
a-9799750/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bbb67d8734f0f62f78d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bbb67d8734f0f62f792
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:10.420517  <8>[   10.350532] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9799721_1.4.2.3.1>

    2023-03-28T21:27:10.423813  + set +x

    2023-03-28T21:27:10.525625  =


    2023-03-28T21:27:10.626579  / # #export SHELL=3D/bin/sh

    2023-03-28T21:27:10.626745  =


    2023-03-28T21:27:10.727635  / # export SHELL=3D/bin/sh. /lava-9799721/e=
nvironment

    2023-03-28T21:27:10.727810  =


    2023-03-28T21:27:10.828717  / # . /lava-9799721/environment/lava-979972=
1/bin/lava-test-runner /lava-9799721/1

    2023-03-28T21:27:10.829003  =


    2023-03-28T21:27:10.833728  / # /lava-9799721/bin/lava-test-runner /lav=
a-9799721/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bcc03b57e51d762f80e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bcc03b57e51d762f813
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:22.748241  + <8>[    9.899303] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9799720_1.4.2.3.1>

    2023-03-28T21:27:22.748341  set +x

    2023-03-28T21:27:22.850054  #

    2023-03-28T21:27:22.850331  =


    2023-03-28T21:27:22.951297  / # #export SHELL=3D/bin/sh

    2023-03-28T21:27:22.951493  =


    2023-03-28T21:27:23.052431  / # export SHELL=3D/bin/sh. /lava-9799720/e=
nvironment

    2023-03-28T21:27:23.052647  =


    2023-03-28T21:27:23.153566  / # . /lava-9799720/environment/lava-979972=
0/bin/lava-test-runner /lava-9799720/1

    2023-03-28T21:27:23.153861  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bce19c0c3668762f76b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bce19c0c3668762f770
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:26.623086  <8>[   10.317317] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9799753_1.4.2.3.1>

    2023-03-28T21:27:26.626625  + set +x

    2023-03-28T21:27:26.732269  #

    2023-03-28T21:27:26.733497  =


    2023-03-28T21:27:26.835699  / # #export SHELL=3D/bin/sh

    2023-03-28T21:27:26.836534  =


    2023-03-28T21:27:26.938309  / # export SHELL=3D/bin/sh. /lava-9799753/e=
nvironment

    2023-03-28T21:27:26.939130  =


    2023-03-28T21:27:27.040973  / # . /lava-9799753/environment/lava-979975=
3/bin/lava-test-runner /lava-9799753/1

    2023-03-28T21:27:27.042334  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bd8c242b7da6a62f778

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bd8c242b7da6a62f77d
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:27.545512  + <8>[    8.486350] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9799726_1.4.2.3.1>

    2023-03-28T21:27:27.545971  set +x

    2023-03-28T21:27:27.653707  / # #

    2023-03-28T21:27:27.756588  export SHELL=3D/bin/sh

    2023-03-28T21:27:27.757374  #

    2023-03-28T21:27:27.859111  / # export SHELL=3D/bin/sh. /lava-9799726/e=
nvironment

    2023-03-28T21:27:27.859986  =


    2023-03-28T21:27:27.961960  / # . /lava-9799726/environment/lava-979972=
6/bin/lava-test-runner /lava-9799726/1

    2023-03-28T21:27:27.963232  =


    2023-03-28T21:27:27.968847  / # /lava-9799726/bin/lava-test-runner /lav=
a-9799726/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
kontron-pitx-imx8m           | arm64  | lab-kontron   | gcc-10   | defconfi=
g                    | 2          =


  Details:     https://kernelci.org/test/plan/id/64235ca773c3d6bc8162f7ee

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pi=
tx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235ca773c3d6bc8162f7f1
        new failure (last pass: v5.15.104)

    2023-03-28T21:31:05.160954  / # #
    2023-03-28T21:31:05.262253  export SHELL=3D/bin/sh
    2023-03-28T21:31:05.262541  #
    2023-03-28T21:31:05.363525  / # export SHELL=3D/bin/sh. /lava-305378/en=
vironment
    2023-03-28T21:31:05.363823  =

    2023-03-28T21:31:05.464620  / # . /lava-305378/environment/lava-305378/=
bin/lava-test-runner /lava-305378/1
    2023-03-28T21:31:05.465056  =

    2023-03-28T21:31:05.469631  / # /lava-305378/bin/lava-test-runner /lava=
-305378/1
    2023-03-28T21:31:05.530515  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-28T21:31:05.530721  + cd /l<8>[   12.167367] <LAVA_SIGNAL_START=
RUN 1_bootrr 305378_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/642=
35ca773c3d6bc8162f801
        new failure (last pass: v5.15.104)

    2023-03-28T21:31:07.853166  /lava-305378/1/../bin/lava-test-case
    2023-03-28T21:31:07.853687  <8>[   14.584187] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-28T21:31:07.854094  /lava-305378/1/../bin/lava-test-case   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64235bcb03b57e51d762f7ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
04-147-gea115396267e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64235bcb03b57e51d762f804
        new failure (last pass: v5.15.104)

    2023-03-28T21:27:29.189222  + set +x<8>[    8.700454] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9799734_1.4.2.3.1>

    2023-03-28T21:27:29.189308  =


    2023-03-28T21:27:29.293742  / # #

    2023-03-28T21:27:29.394815  export SHELL=3D/bin/sh

    2023-03-28T21:27:29.395005  #

    2023-03-28T21:27:29.496054  / # export SHELL=3D/bin/sh. /lava-9799734/e=
nvironment

    2023-03-28T21:27:29.496233  =


    2023-03-28T21:27:29.597156  / # . /lava-9799734/environment/lava-979973=
4/bin/lava-test-runner /lava-9799734/1

    2023-03-28T21:27:29.597424  =


    2023-03-28T21:27:29.601635  / # /lava-9799734/bin/lava-test-runner /lav=
a-9799734/1
 =

    ... (12 line(s) more)  =

 =20
