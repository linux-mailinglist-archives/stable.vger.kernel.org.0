Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E0667B9DF
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 19:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjAYSuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 13:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjAYSus (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 13:50:48 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E1B1556D
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:50:38 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id j5so5820687pjn.5
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=a1YeHeZPVmyCIfTulKE6Ch6Y2ReZmlPAozzjui0OwMI=;
        b=inQRWA9fo0rzW2XsFX82Ky9TAfKbdFT1fDVW7yf778sZbf8iTuAmjAVvddBqjPnRY1
         Gnd2QCbCs5w7P3/R1iSdnK6EzWf5Es3VMRaiaU2HS7Gro88M9/clkNXA3KvUiLa5FU+Y
         FqzHKqatEKfGjKRcpRabWG3APoJ43gN1U/7R8kZq20m3uG+G22wYmAKRhiXAJq6UNYsa
         JqgjMxdMoBT+bOjwzNedFkqXJ80uZkW+pC0yQFTd9FEiAJ16wXYHoYuNivCwyy2N21p8
         7uS0xhfArRcVNVFzLyvc1sf+BqkYxB8/XhcohoTQrmxRBo/PA7+kDTzMVA9QA0/aIWeE
         4G5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1YeHeZPVmyCIfTulKE6Ch6Y2ReZmlPAozzjui0OwMI=;
        b=4ckah4Y4qllfLU+4Ij2DgfUXQKwek76Ve2C3uPO5PKjcKvilsseF1s+zfUHhauldmJ
         MG8oNpYYoedEgGYI2zPyav3RuW1v6NMX7qnXgnPiobw1QecrPTnp6iauTCdxvXa0nFAJ
         WImUYfnTUwIMBJaEnyFSPIIjL/tJ3BC38Frv//Lz4nyWtbk4a7ZZaD5zfooYtaE2Gd1C
         vLjrTHuamVWukZM6ypbZtTTEFXZiJ0fL/d3iaBXzXIAeBXwSGXWHrDpLmqTCLob4fmQH
         A9d4678fKBFzg13BQNGECVbCIfc67fvU0PXDyOrLI30FBc4wshHt4ipEGLK0f09b8lBT
         BqOQ==
X-Gm-Message-State: AFqh2kr88U71wnmd0lzOKtzI0iB/Iy15aTODicq0qeH2ys7IkN+MVKvC
        j/OfbCrXcH6i80oLsHkceD7gq1HjZ1C4Wc4P0Tqr0Q==
X-Google-Smtp-Source: AMrXdXucsPYEne9n368cAobKZheivpEeknbgtG5mad3pUN/FKg6hD2mWW7HvAKiM6iLfCKR+sBmdAQ==
X-Received: by 2002:a05:6a20:8423:b0:b9:605b:38dd with SMTP id c35-20020a056a20842300b000b9605b38ddmr31319903pzd.18.1674672637878;
        Wed, 25 Jan 2023 10:50:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b0058134d2df41sm4111280pfu.146.2023.01.25.10.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 10:50:37 -0800 (PST)
Message-ID: <63d179fd.050a0220.e5f57.75c0@mx.google.com>
Date:   Wed, 25 Jan 2023 10:50:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.165
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 151 runs, 3 regressions (v5.10.165)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 151 runs, 3 regressions (v5.10.165)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
cubietruck              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

r8a7743-iwg20d-q7       | arm   | lab-cip      | gcc-10   | shmobile_defcon=
fig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.165/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.165
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      179624a57b78c02de833370b7bdf0b0f4a27ca31 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
cubietruck              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d14760704288142d915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d14760704288142d915ec7
        failing since 7 days (last pass: v5.10.158-107-gd2432186ff47, first=
 fail: v5.10.162-852-geeaac3cf2eb3)

    2023-01-25T15:14:21.320264  <8>[   11.054852] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3210686_1.5.2.4.1>
    2023-01-25T15:14:21.429281  / # #
    2023-01-25T15:14:21.532621  export SHELL=3D/bin/sh
    2023-01-25T15:14:21.533155  #
    2023-01-25T15:14:21.634918  / # export SHELL=3D/bin/sh. /lava-3210686/e=
nvironment
    2023-01-25T15:14:21.636086  =

    2023-01-25T15:14:21.738317  / # . /lava-3210686/environment/lava-321068=
6/bin/lava-test-runner /lava-3210686/1
    2023-01-25T15:14:21.739904  =

    2023-01-25T15:14:21.743803  / # /lava-3210686/bin/lava-test-runner /lav=
a-3210686/1
    2023-01-25T15:14:21.833361  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
r8a7743-iwg20d-q7       | arm   | lab-cip      | gcc-10   | shmobile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d143d5ea03d61119915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d143d5ea03d61119915=
ec0
        new failure (last pass: v5.10.162-951-g9096aabfe9e0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/63d1447c85e8a3ce55915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
65/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1447c85e8a3ce55915=
ed5
        new failure (last pass: v5.10.162-951-g9096aabfe9e0) =

 =20
