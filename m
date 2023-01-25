Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409EB67B92D
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 19:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235780AbjAYSVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 13:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbjAYSVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 13:21:10 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D0348587
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:21:06 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z3so14034063pfb.2
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 10:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ynsEMs4EgWtgRIOrJXCpRZ7/TKREwNI+cTTrOTD1OjQ=;
        b=ZLHrkM4UKnMF8srTlHp8l++63fO8c2KcAB/HbwuiRc485FyCqQFBDpUQPgkYH6+9K5
         3OnQBbQpD5Vx5DoWv8MOyN/vH8Jh3dahK/Xp5TpgxRsw3VSP99I6WBcIlWSqIZMAnTlu
         /hP/8fCufJqIYDXCt+vNS2mg6qB36RG5rxaub5Wp72pVawSxLmxn7y5MTx3/md1eiHMd
         qchLOkHcyXbIq4pgJC21gQUo/9ivi6IgC6t7BxWJFT0zbD/f4Fq/QoXb6+aI3ZTFC7WS
         kMxQLrLPFt3qTHiwXttQD+qmND2rlr3GCIDcwB02s9ftRSpts2nQZpucBYDiS/6cwnAt
         arWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ynsEMs4EgWtgRIOrJXCpRZ7/TKREwNI+cTTrOTD1OjQ=;
        b=WIsWQclL1iWYbG15lbWFz48pFNlBYf16YKZVllvbf/72YYKDCDOQZ0rpS5rGptRbdX
         dz0ozSWQ55E6QfMbb2mmcxQe8AWKptqS1ZXuBguzr1LpyOFYR/mhD3G+3iSYyZDurCKj
         WVnJYALtRqgX7q647nA7GPXHMpitBimP748/T4Ot4Mx3QdKmW0kaSaGXp+W8EcwASt9E
         vQFXMPixMQvpOYoAbCjeH9dPrKCJppw9HMT2GKBA21uHstNtqApApTBb2Tx42c+MBuaO
         lldzB9w94BHjoowR6xJL5Sjy3IrCA2S3PTaTJNX7pfgJUAghNi6b1LMuxKAkffs1BI+q
         Euvg==
X-Gm-Message-State: AO0yUKU/vAB8VzF5CxqPS392Mqhvus2f7Fr5R6JIocslgNH3rm+QGj9M
        YMXqPnzyXTnRsdnWZ90MPKMxn9bRGF2z7qiFBjU=
X-Google-Smtp-Source: AK7set/OTEEn2uOXKYyKCwPQl90rrSnHUxWMt7TEGMM2Ieib3JqJ1yYN9GnlebvSGkYbmzyZng18rw==
X-Received: by 2002:a05:6a00:e88:b0:590:7735:57f8 with SMTP id bo8-20020a056a000e8800b00590773557f8mr453035pfb.25.1674670866160;
        Wed, 25 Jan 2023 10:21:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f64-20020a623843000000b0058bc37f3d1csm3947900pfa.44.2023.01.25.10.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 10:21:05 -0800 (PST)
Message-ID: <63d17311.620a0220.ffcd0.7cca@mx.google.com>
Date:   Wed, 25 Jan 2023 10:21:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.90
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 142 runs, 2 regressions (v5.15.90)
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

stable-rc/linux-5.15.y baseline: 142 runs, 2 regressions (v5.15.90)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =

cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aabd5ba7e9b03e9a211a4842ab4a93d46f684d2c =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63d1422f99e0641388915ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d1422f99e0641388915=
ef1
        failing since 258 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63d14219cd4f6b89b2915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.9=
0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d14219cd4f6b89b2915ecc
        failing since 8 days (last pass: v5.15.82-124-gd731c63c25d1, first =
fail: v5.15.87-101-g5bcc318cb4cd)

    2023-01-25T14:52:01.843565  <8>[   10.077444] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3210492_1.5.2.4.1>
    2023-01-25T14:52:01.954720  / # #
    2023-01-25T14:52:02.058730  export SHELL=3D/bin/sh
    2023-01-25T14:52:02.059817  #<3>[   10.195397] Bluetooth: hci0: command=
 0x0c03 tx timeout
    2023-01-25T14:52:02.060360  =

    2023-01-25T14:52:02.162748  / # export SHELL=3D/bin/sh. /lava-3210492/e=
nvironment
    2023-01-25T14:52:02.163704  =

    2023-01-25T14:52:02.265902  / # . /lava-3210492/environment/lava-321049=
2/bin/lava-test-runner /lava-3210492/1
    2023-01-25T14:52:02.267731  =

    2023-01-25T14:52:02.272416  / # /lava-3210492/bin/lava-test-runner /lav=
a-3210492/1 =

    ... (12 line(s) more)  =

 =20
