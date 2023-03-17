Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38D6BECF5
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 16:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjCQPbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 11:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjCQPb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 11:31:29 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAF6B0BB9
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 08:31:06 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t83so3107234pgb.11
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 08:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679067066;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=96qkr9/KwBJIHuAbKKUencUrB9FbPnVwABzZtaAsBhg=;
        b=Xs+BO2Jo1r3nJUyhOt09/UqU8SCyqUuArXYnQzGpzna1uwx9BhoCf8zRwee8FN5dpr
         N5IhW4u1OfA7/AekQO5DXCu6OkGxwy4zxhPualwhDujETj8F7fbKhX4nql5vTc9AZm7N
         M9mXsSwshGcGp68wiRflfM4kI7cJbgp0u7z/ZwaHCQtUz4G6/+b3IaBsp/jhJFD5Yau4
         3+dhrwLUumOb2aKNLFBHc0BwFKGBKmVRDucL5Q3vgA6izAqzOT9RAJJZXJGkHoM8swDv
         dN2Bb2gyUfgsJpFVDVlRlucWMyuOTtFu6dDa1bMF8P59mDusCjkSu9kV1Gb9Gy/azo9L
         hGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067066;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96qkr9/KwBJIHuAbKKUencUrB9FbPnVwABzZtaAsBhg=;
        b=C3Bep+1rHh42k8HYldmwAuYGxWHy11Zv3fviMqbKrooiFCXgqvF9hc19jhDI2DBjPX
         Rxyog7E+2DRsUlXomUZMyC2v5gnYtZ0Lffi/HKRYk2xcGg65ckoWJ+leRv92piTYd/3h
         LuAyQWUiLxKra8BQwt5F5Dadusurs5na1YptcOWCq6MW6Vfumc9m+hdydkiRrn2u7fOK
         w1VJBcj9p1hwwgE6WQKpyvosaPfjL8c6OxjFiH3om0n0sbBo9Hp/1qDZGDkMtu1FCfxA
         619fILo0G6/m3w311N1yYbg2TTqOHRsX3OUbTjwpd2uc6vReAs6iWsBn7iJuVGg5IOQv
         ZFpQ==
X-Gm-Message-State: AO0yUKXZcRMoebWVEG+Sm2C2g7/kzeYu/XGJaq0i6qIpJOzhhplllf6Q
        05BI/iYXgfkm4MmexBPAbQ4fU2x5qJjrFjWk8Os=
X-Google-Smtp-Source: AK7set/uikyWxhfalkn3mxOk3NnWCsA+c8aG2BOQtFCLWRNZvVrX4PmgMzk3wIXCj77uWPN7U71+cQ==
X-Received: by 2002:aa7:97ba:0:b0:623:cc95:e517 with SMTP id d26-20020aa797ba000000b00623cc95e517mr7004935pfq.17.1679067065825;
        Fri, 17 Mar 2023 08:31:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f14-20020aa78b0e000000b005898fcb7c1bsm1752923pfd.177.2023.03.17.08.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:31:05 -0700 (PDT)
Message-ID: <641487b9.a70a0220.f3909.39c0@mx.google.com>
Date:   Fri, 17 Mar 2023 08:31:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.103
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 188 runs, 2 regressions (v5.15.103)
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

stable-rc/linux-5.15.y baseline: 188 runs, 2 regressions (v5.15.103)

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
nel/v5.15.103/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.103
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8020ae3c051d1c9ec7b7a872e226f9720547649b =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
cubietruck      | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/641454cf3b21dd820c8c8641

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641454cf3b21dd820c8c864a
        failing since 59 days (last pass: v5.15.82-124-gd731c63c25d1, first=
 fail: v5.15.87-101-g5bcc318cb4cd)

    2023-03-17T11:53:39.551322  <8>[   10.013721] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3420241_1.5.2.4.1>
    2023-03-17T11:53:39.658024  / # #
    2023-03-17T11:53:39.759808  export SHELL=3D/bin/sh
    2023-03-17T11:53:39.760277  #
    2023-03-17T11:53:39.760526  / # export SHELL=3D/bin/sh<3>[   10.193222]=
 Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-17T11:53:39.861753  . /lava-3420241/environment
    2023-03-17T11:53:39.862231  =

    2023-03-17T11:53:39.963610  / # . /lava-3420241/environment/lava-342024=
1/bin/lava-test-runner /lava-3420241/1
    2023-03-17T11:53:39.964330  =

    2023-03-17T11:53:39.969273  / # /lava-3420241/bin/lava-test-runner /lav=
a-3420241/1 =

    ... (12 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-lx2160a-rdb | arm64 | lab-nxp      | gcc-10   | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/641457b3533cab40558c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
03/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641457b3533cab40558c8649
        failing since 13 days (last pass: v5.15.79, first fail: v5.15.98)

    2023-03-17T12:05:43.637695  [   11.128715] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1176482_1.5.2.4.1>
    2023-03-17T12:05:43.743188  / # #
    2023-03-17T12:05:43.844482  export SHELL=3D/bin/sh
    2023-03-17T12:05:43.845050  #
    2023-03-17T12:05:43.946424  / # export SHELL=3D/bin/sh. /lava-1176482/e=
nvironment
    2023-03-17T12:05:43.946978  =

    2023-03-17T12:05:44.048379  / # . /lava-1176482/environment/lava-117648=
2/bin/lava-test-runner /lava-1176482/1
    2023-03-17T12:05:44.049152  =

    2023-03-17T12:05:44.051063  / # /lava-1176482/bin/lava-test-runner /lav=
a-1176482/1
    2023-03-17T12:05:44.070054  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
