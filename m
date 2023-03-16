Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCEB6BD2AE
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 15:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCPOvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 10:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCPOvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 10:51:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E8C584AA
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:51:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p20so1988687plw.13
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 07:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678978274;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4+C2dnlWafqmRHjAsBGqfpIGgwiVNnQchjrw5UicANc=;
        b=D6GVOSQPIl4mDQJ/ipnbByrXBbFT/mwPVgHwANG1i9nNrwLs2D9d5KfawCr6kro8uW
         vfoaQz7huNAVoFzyRvFP3GghpQr+T60eBUPmJcJRz+wvTy9ZDUYflZL+wmunKtTJgEtv
         GhEKDR+0YPBbjBfdLxAvOgNzFXkI3gI1o4t2VoMefxs+mRNsz+Yl9o9N+6ql/p9dAGC8
         uX97OI7eZzSQu3Z1JilY8o5WZ98YWVzvrnTQ1Jo+uBh8BcjVT7o+4PJepskb3zqYGsRb
         Ccr6CYN7l9x2pJXGZUD7BkszZepsQPwRqlUpDABu6pFT70Z7x/L4Cgficix/4TSknt1Z
         XQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678978274;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+C2dnlWafqmRHjAsBGqfpIGgwiVNnQchjrw5UicANc=;
        b=vZxZeiBc5VvQLqWD+XQdH4NnD0mqYrwz6qODZxQKCWuo+HbcPCrixvg2W9Say9j0ik
         Grpc/KKRpEExFQdFvAzrW9obPszHsuVYxyIDfEEmuIh+d8wX2DozHPO4NBguKm5lLRqy
         8KLwIVBrarR94YmkVNONxf7NsSFzImuE7oRTUQja1JITF/fEqAN7IimY6LtXqAfV2Ldf
         OOtw6SAiUJnQkQjsopwRRHHoE2Cle7u35AfFnW1KkuhzxQpI7ntP/5UTZIOGhNBBDFkR
         7Gjp2IOjpKjonWp3ad4FkaWywUZoeA0I3NK2OswyxeoRb3zgm79OaXUj03tFCdKzFubb
         SB0w==
X-Gm-Message-State: AO0yUKW8IQJ+MooCGw4DRiRGT2Hnp24Hn0SPNTaJCzW3JWDYv0uUTTSA
        g/uWRner0+pBQCg77OMsj060Sxm/ycmEuLgnMXWburV+
X-Google-Smtp-Source: AK7set98lSgEfvO1QUQAvPbJOybp55XVdN8ubEW7erX+08puQIKUuiPHynxxkPuOUNfYPVdWRpFhwg==
X-Received: by 2002:a17:90b:388c:b0:23b:2f4f:1a9b with SMTP id mu12-20020a17090b388c00b0023b2f4f1a9bmr4467450pjb.37.1678978273979;
        Thu, 16 Mar 2023 07:51:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10-20020a17090a304a00b00233acae2ce6sm3275295pjl.23.2023.03.16.07.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 07:51:13 -0700 (PDT)
Message-ID: <64132ce1.170a0220.79ac.6058@mx.google.com>
Date:   Thu, 16 Mar 2023 07:51:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.101-142-gbc64d631a29e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 172 runs,
 2 regressions (v5.15.101-142-gbc64d631a29e)
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

stable-rc/linux-5.15.y baseline: 172 runs, 2 regressions (v5.15.101-142-gbc=
64d631a29e)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =

fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.101-142-gbc64d631a29e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.101-142-gbc64d631a29e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc64d631a29ef83d6cdf41d6285f01e3ac03feb9 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6412fc262aae9164718c8631

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-142-gbc64d631a29e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-142-gbc64d631a29e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412fc262aae9164718c863a
        failing since 58 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-16T11:22:59.327011  <8>[    9.980176] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3416715_1.5.2.4.1>
    2023-03-16T11:22:59.433761  / # #
    2023-03-16T11:22:59.535405  export SHELL=3D/bin/sh
    2023-03-16T11:22:59.535838  #
    2023-03-16T11:22:59.637062  / # export SHELL=3D/bin/sh. /lava-3416715/e=
nvironment
    2023-03-16T11:22:59.637471  =

    2023-03-16T11:22:59.738700  / # . /lava-3416715/environment/lava-341671=
5/bin/lava-test-runner /lava-3416715/1
    2023-03-16T11:22:59.739323  =

    2023-03-16T11:22:59.745458  / # /lava-3416715/bin/lava-test-runner /lav=
a-3416715/1
    2023-03-16T11:22:59.832474  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6412fa7600bc86cb388c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-142-gbc64d631a29e/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
01-142-gbc64d631a29e/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412fa7600bc86cb388c8649
        failing since 12 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-03-16T11:15:41.471375  [   10.791160] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1174934_1.5.2.4.1>
    2023-03-16T11:15:41.577364  / # #
    2023-03-16T11:15:41.679328  export SHELL=3D/bin/sh
    2023-03-16T11:15:41.679906  #
    2023-03-16T11:15:41.781428  / # export SHELL=3D/bin/sh. /lava-1174934/e=
nvironment
    2023-03-16T11:15:41.781854  =

    2023-03-16T11:15:41.883271  / # . /lava-1174934/environment/lava-117493=
4/bin/lava-test-runner /lava-1174934/1
    2023-03-16T11:15:41.883988  =

    2023-03-16T11:15:41.885720  / # /lava-1174934/bin/lava-test-runner /lav=
a-1174934/1
    2023-03-16T11:15:41.902958  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
