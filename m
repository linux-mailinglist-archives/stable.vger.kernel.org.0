Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1946565D993
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbjADQ0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbjADQZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:37 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEEA33D79
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:25:37 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 78so22560113pgb.8
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 08:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TrYbkdEvSmRLIbogKmsveztllTLzgG1UZPO0HQg4E/I=;
        b=cbdikJzky6onJEMUj8UNpWed4F598GjKxHNqW27SzzXJ2W217Qe35oDksZPntGy1cL
         XatMKwEx6AlzCcY6c2geB5VT+7VYAzGoTk7kkkDqpyx1DBbHetzwTInpUbn744hdeO8u
         dYgs/aXdKlLqvixV95FTzMakE4c2wZ38UQza9ZAxW/0/LYypYdkM82DBuqefuyJvBjOD
         cc6MW/17QFi05pkQctf3fjrerWwk+aHDXZdMlbRdKvOY1A0Q8vbW5z5kCrN9xTNaHe4z
         ccs2odpts6uEu9bQ3ojdu8dabZpF54uBb4yCOzCF7nIVohIAQq/aU2j03JVQ7jmmjgw1
         TNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrYbkdEvSmRLIbogKmsveztllTLzgG1UZPO0HQg4E/I=;
        b=TEL1v4Nw+rTPGCGb2R0/H4IoxMfX/tUBe4ZTWV0K0qcoDV6OC77IYdceVsqrapD71E
         697FbZfhX49MuJdyCnIvtCubToWRszDa+bIE8m414uqcHFdK/1tkLd1dtfmDQJVffNGf
         E6f7/cHCFt76c4R7j/mAhYwuiJQdzJnWPGx6MO2blV4Y/OU4M0kLljT565qcTOKgMnhX
         00U8A4ntTUmecrOS4A6i/eDRKcur0q5ditXs6CoLudtgG+DcMdKYajG+Lr1Cq9LuvOcQ
         RW+z+scp3XBKhbbWiXxhb/u0uN1DJy5yz3xxIibyCHYqDjoBnmARN0VXO3mnlmBflww7
         RmkA==
X-Gm-Message-State: AFqh2koQXMmd3dOxPPDYPtK3uGlguGK296PbZAg8noknoAlhEEbL/hap
        nwJrZ7jKHC1UhT8CLSgsn6l36lg2/wTk7Q8Qu6qj4w==
X-Google-Smtp-Source: AMrXdXt1jTiBcL2BpULHVzj4kCIaQ1c5iZKM90MAY/sXMGAZ7q92pjXO1tBRWGwHL9ZseyMvbBdBhg==
X-Received: by 2002:a62:ae0f:0:b0:577:15e:d9eb with SMTP id q15-20020a62ae0f000000b00577015ed9ebmr68572566pff.1.1672849536285;
        Wed, 04 Jan 2023 08:25:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15-20020a63190f000000b0046ffe3fea77sm20477731pgl.76.2023.01.04.08.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:25:35 -0800 (PST)
Message-ID: <63b5a87f.630a0220.b904b.0994@mx.google.com>
Date:   Wed, 04 Jan 2023 08:25:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 136 runs, 4 regressions (v5.10.162)
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

stable/linux-5.10.y baseline: 136 runs, 4 regressions (v5.10.162)

Regressions Summary
-------------------

platform               | arch  | lab        | compiler | defconfig         =
 | regressions
-----------------------+-------+------------+----------+-------------------=
-+------------
r8a7743-iwg20d-q7      | arm   | lab-cip    | gcc-10   | shmobile_defconfig=
 | 1          =

sun50i-h6-orangepi-3   | arm64 | lab-clabbe | gcc-10   | defconfig         =
 | 1          =

sun8i-a83t-bananapi-m3 | arm   | lab-clabbe | gcc-10   | multi_v7_defconfig=
 | 1          =

sun8i-a83t-bananapi-m3 | arm   | lab-clabbe | gcc-10   | sunxi_defconfig   =
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.162/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0fe4548663f7dc2c3b549ef54ce9bb6d40a235be =



Test Regressions
---------------- =



platform               | arch  | lab        | compiler | defconfig         =
 | regressions
-----------------------+-------+------------+----------+-------------------=
-+------------
r8a7743-iwg20d-q7      | arm   | lab-cip    | gcc-10   | shmobile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63b57397f3e144dddd4eee45

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b57397f3e144dddd4ee=
e46
        new failure (last pass: v5.10.161) =

 =



platform               | arch  | lab        | compiler | defconfig         =
 | regressions
-----------------------+-------+------------+----------+-------------------=
-+------------
sun50i-h6-orangepi-3   | arm64 | lab-clabbe | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63b5758d8673ee882b4eee48

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orangepi-3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orangepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63b5758d8673ee882b4eee4b
        new failure (last pass: v5.10.156)

    2023-01-04T12:47:57.013886  <8>[   16.473948] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 373707_1.5.2.4.1>
    2023-01-04T12:47:57.122138  / # #
    2023-01-04T12:47:57.224542  export SHELL=3D/bin/sh
    2023-01-04T12:47:57.225212  #
    2023-01-04T12:47:57.326907  / # export SHELL=3D/bin/sh. /lava-373707/en=
vironment
    2023-01-04T12:47:57.327614  =

    2023-01-04T12:47:57.429325  / # . /lava-373707/environment/lava-373707/=
bin/lava-test-runner /lava-373707/1
    2023-01-04T12:47:57.430440  =

    2023-01-04T12:47:57.443847  / # /lava-373707/bin/lava-test-runner /lava=
-373707/1
    2023-01-04T12:47:57.502920  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab        | compiler | defconfig         =
 | regressions
-----------------------+-------+------------+----------+-------------------=
-+------------
sun8i-a83t-bananapi-m3 | arm   | lab-clabbe | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63b573f6d5e5fe35c14eee4c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63b573f6d5e5fe35c14eee4f
        new failure (last pass: v5.10.143)

    2023-01-04T12:41:17.379750  [   15.280498] <LAVA_SIGNAL_ENDRUN 0_dmesg =
373696_1.5.2.4.1>
    2023-01-04T12:41:17.380077  [   15.286692] usb-storage 2-1.1:1.0: USB M=
ass Storage device detected
    2023-01-04T12:41:17.380668  / # [   15.295492] scsi host0: usb-storage =
2-1.1:1.0
    2023-01-04T12:41:17.380952  [   15.307813] usbcore: registered new inte=
rface driver uas
    2023-01-04T12:41:17.487108  #
    2023-01-04T12:41:17.589328  export SHELL=3D/bin/sh
    2023-01-04T12:41:17.589949  #
    2023-01-04T12:41:17.691535  / # export SHELL=3D/bin/sh. /lava-373696/en=
vironment
    2023-01-04T12:41:17.692141  =

    2023-01-04T12:41:17.793820  / # . /lava-373696/environment/lava-373696/=
bin/lava-test-runner /lava-373696/1 =

    ... (21 line(s) more)  =

 =



platform               | arch  | lab        | compiler | defconfig         =
 | regressions
-----------------------+-------+------------+----------+-------------------=
-+------------
sun8i-a83t-bananapi-m3 | arm   | lab-clabbe | gcc-10   | sunxi_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63b56ef5dcf1eb98574eee95

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.162/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63b56ef5dcf1eb98574eee98
        new failure (last pass: v5.10.143)

    2023-01-04T12:19:47.832673  + set +x[   15.272361] <LAVA_SIGNAL_ENDRUN =
0_dmesg 373687_1.5.2.4.1>
    2023-01-04T12:19:47.832993  =

    2023-01-04T12:19:47.939457  / # #
    2023-01-04T12:19:48.041817  export SHELL=3D/bin/sh
    2023-01-04T12:19:48.042532  #
    2023-01-04T12:19:48.144126  / # export SHELL=3D/bin/sh. /lava-373687/en=
vironment
    2023-01-04T12:19:48.144778  =

    2023-01-04T12:19:48.246433  / # . /lava-373687/environment/lava-373687/=
bin/lava-test-runner /lava-373687/1
    2023-01-04T12:19:48.247570  =

    2023-01-04T12:19:48.263645  / # /lava-373687/bin/lava-test-runner /lava=
-373687/1 =

    ... (12 line(s) more)  =

 =20
