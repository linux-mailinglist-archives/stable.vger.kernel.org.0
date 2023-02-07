Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46168DD50
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 16:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjBGPtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 10:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjBGPtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 10:49:51 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645DF38B6E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 07:49:48 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id hv11-20020a17090ae40b00b002307b580d7eso11582636pjb.3
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 07:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4XlcGUDj7L81G0UVDAqwHFpL7PV/ubv1DxNAe1VVCdY=;
        b=QWTdkhhS/lOl6CdYbL9+xUQVMYkIq6wb0+EC4MFtyl4bg/FcGPsr9jf85M8gyu5ZEf
         V5pbL9bABN6Az8+EJTF8rQEIm0lDqL2Gl+nzql8q1iEUsNKKjNamMB3779zfEfOKf3IC
         oJtUvZDFT7Y35qDXpRj2tb2g/dOL0E2SdB/VCYYvjSOXPxDcj3pWhe+2JFZvy1tXChdm
         kkrl6hhQnZXGARQSMbVhkvhGTDXi1+imSdyL5qL+zaIPNpkVTtGa+I8ChRsP0GS28GYH
         v/R1rt0+j/goj7i2Pkawk2M5ODui+YufIeOLWlTTRx0w4fTzRVX5xdQ5abg0o76PVPQ6
         D2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4XlcGUDj7L81G0UVDAqwHFpL7PV/ubv1DxNAe1VVCdY=;
        b=CpaniU1smalNFDVUs29K3cAhPNeTyRB0I9Nf0NZJY3PG/g5VFHcSXSAjotobV4IsVT
         Q/QjHKPHXxPltDd2sUS5ka/CKRKPJOl1IR4k4nbkK2coHIYhYsjo99ayM5IlXo1mEk2m
         3ClgNuo5ujWt3rs0DJJkXZANp+DfJlwiXuY4qYXBBSyg+vpuElVy0N4TESF3YtMbQoi0
         jb6iapSA9T/5v9i337qseqS3wt0BQqchypEDjeotY79HeZ9xoTEICt9PZlsuvhTaF9Ny
         qTx5IEIxlA5MQlUi5u8NlABmSxZxaVzxcRjCRjNG9489LuN3OVRmGN0eeAAQGc7rBVLx
         kA2A==
X-Gm-Message-State: AO0yUKXzKxIhJfhWR6bDVWRJcsesxChAhrGsEgXP4ncEOd8gOb8VxERO
        C75eX8lJgXfjtK689NkmdhZtRCYJQf4CUsD2IHm9Jg==
X-Google-Smtp-Source: AK7set8XOAzrKpta8Z82FjprFzEh45XG9plLQbMkIxgzL6jidAaiveA+x15HVOeSNfH3+FFrZuyFTA==
X-Received: by 2002:a17:902:e88b:b0:199:2955:13f7 with SMTP id w11-20020a170902e88b00b00199295513f7mr4131380plg.7.1675784987679;
        Tue, 07 Feb 2023 07:49:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902680300b0019601b73e33sm9073348plk.30.2023.02.07.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 07:49:47 -0800 (PST)
Message-ID: <63e2731b.170a0220.e5bed.f360@mx.google.com>
Date:   Tue, 07 Feb 2023 07:49:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.166-95-geb159903f7bb
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 174 runs,
 4 regressions (v5.10.166-95-geb159903f7bb)
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

stable-rc/linux-5.10.y baseline: 174 runs, 4 regressions (v5.10.166-95-geb1=
59903f7bb)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.166-95-geb159903f7bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.166-95-geb159903f7bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb159903f7bbe6ca015618599ba9f9b9f46aaf49 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2401e1bcec2c3418c865f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e2401e1bcec2c3418c8668
        failing since 20 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-02-07T12:12:00.408666  <8>[   11.067213] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3301187_1.5.2.4.1>
    2023-02-07T12:12:00.516483  / # #
    2023-02-07T12:12:00.619665  export SHELL=3D/bin/sh
    2023-02-07T12:12:00.620610  #
    2023-02-07T12:12:00.722663  / # export SHELL=3D/bin/sh. /lava-3301187/e=
nvironment
    2023-02-07T12:12:00.723482  =

    2023-02-07T12:12:00.723901  / # . /lava-3301187/environment<3>[   11.37=
1018] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-07T12:12:00.825917  /lava-3301187/bin/lava-test-runner /lava-33=
01187/1
    2023-02-07T12:12:00.827581  =

    2023-02-07T12:12:00.832327  / # /lava-3301187/bin/lava-test-runner /lav=
a-3301187/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
r8a7743-iwg20d-q7      | arm   | lab-cip      | gcc-10   | shmobile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2401d1bcec2c3418c865c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e2401d1bcec2c3418c8=
65d
        failing since 12 days (last pass: v5.10.162-951-g9096aabfe9e0, firs=
t fail: v5.10.165) =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e24384f7861509fa8c86df

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e24384f7861509fa8c86e8
        failing since 7 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-07T12:26:23.127310  + set +x
    2023-02-07T12:26:23.131042  <8>[   17.076461] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3301272_1.5.2.4.1>
    2023-02-07T12:26:23.253419  / # #
    2023-02-07T12:26:23.359119  export SHELL=3D/bin/sh
    2023-02-07T12:26:23.360725  #
    2023-02-07T12:26:23.464363  / # export SHELL=3D/bin/sh. /lava-3301272/e=
nvironment
    2023-02-07T12:26:23.465970  =

    2023-02-07T12:26:23.569664  / # . /lava-3301272/environment/lava-330127=
2/bin/lava-test-runner /lava-3301272/1
    2023-02-07T12:26:23.572433  =

    2023-02-07T12:26:23.575721  / # /lava-3301272/bin/lava-test-runner /lav=
a-3301272/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2418e6fa3426af48c863a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-95-geb159903f7bb/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e2418e6fa3426af48c8643
        failing since 7 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-07T12:18:10.479701  + set +x
    2023-02-07T12:18:10.483783  <8>[   17.001615] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 268253_1.5.2.4.1>
    2023-02-07T12:18:10.594562  / # #
    2023-02-07T12:18:10.696522  export SHELL=3D/bin/sh
    2023-02-07T12:18:10.858298  #
    2023-02-07T12:18:10.858611  / # export SHELL=3D/bin/sh
    2023-02-07T12:18:10.960242  / # . /lava-268253/environment
    2023-02-07T12:18:11.062434  /lava-268253/bin/lava-test-runner /lava-268=
253/1
    2023-02-07T12:18:11.063963  . /lava-268253/environment
    2023-02-07T12:18:11.067294  / # /lava-268253/bin/lava-test-runner /lava=
-268253/1 =

    ... (12 line(s) more)  =

 =20
