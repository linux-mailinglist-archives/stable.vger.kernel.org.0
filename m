Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0346AAE81
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 08:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjCEHnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 02:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCEHno (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 02:43:44 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6D0BDD5
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 23:43:43 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id i5so7032647pla.2
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 23:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678002222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=x3Nd16tq/4PCZ044y/vqrppjCXuBOM0vq6Nk9l+sfP8=;
        b=smN3QHQWI/jhcvZjivMyokgoIp22sUDulJkyvvykPZEBA5IVKbg4yo6G6byIte1Hu+
         MhwXlR8JM74p7MVfH49VX/WR6JiTstFPZtlJ7cE3fHQM+/VUNNpT9ecLLgT+SEIdPnZt
         4WUJWEvzkK/Rqq1gIUy4ZG6ooZRfedUrbFm86Vaeb+BvVyZqVogYr6H7O7iGLLbp6vVv
         p8M7iOIWwSS0EER2CymUsnbrFcFT2mPI/QVcpKAepvA8g6YXNcWB6MY/9Yyb635I2Wdk
         Tk9GKWH+AqwRHH1QhvDLO/SrqnvIQGE4cRlH1p3uLn7VF48L7iUxPTRVmNU6YnN5qRJI
         0MWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678002222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x3Nd16tq/4PCZ044y/vqrppjCXuBOM0vq6Nk9l+sfP8=;
        b=M8Siio5V9E1NimvNavbf/mKAd5d/1V/+wonB3zne4ATZI2BpWDseQOVa1kphf4Dp6t
         a5qql2fgj6Lm7geSuEa8IJilgysEKO4+3wkCZHeK944DuFVByqk/q8Mz97Dzm8eF/I2l
         D5ROcDzZO4g6enqVXid8HxdZMvj2unfXZVbI2+iG2+pWcTek3ZbMmmDqdk6sl3uSkGPi
         0vEUb/uwELbQjPZxR8slqvqntL3EqYsu6b5E0QpBO6fAM/faQCB4ivGG2wLE9eTO5jUS
         yyEsYJcWmamLSki/pYtg8+vM628E3Ip3ej4C3i9Nkdo7qHVtlD6Iue2qANczvNQmv5ox
         5ULA==
X-Gm-Message-State: AO0yUKXJi7yG4gUyftA1Y269c/8TOexRx/usU3kjREmzafOZPjJ4Omx9
        CDrsWT+vAwiJiLFFUg6pDQG1kB5aTu9RWvrUTofotYQx
X-Google-Smtp-Source: AK7set8mWxgPod5JjTceAICVRVF5N5FgeeFv+wlWwwEsBFUg+uk9fUNFp19PjCLdP/JFxrkRqJ6m6A==
X-Received: by 2002:a17:90a:1942:b0:233:e9a7:209e with SMTP id 2-20020a17090a194200b00233e9a7209emr7614496pjh.28.1678002222600;
        Sat, 04 Mar 2023 23:43:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1-20020a631e01000000b004fb681ea0e1sm4189302pge.84.2023.03.04.23.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 23:43:42 -0800 (PST)
Message-ID: <6404482e.630a0220.94cbf.7852@mx.google.com>
Date:   Sat, 04 Mar 2023 23:43:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-651-g1da2ded14cbf3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 110 runs,
 3 regressions (v6.1.15-651-g1da2ded14cbf3)
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

stable-rc/queue/6.1 baseline: 110 runs, 3 regressions (v6.1.15-651-g1da2ded=
14cbf3)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie  | gcc-10   | bcm2835_defconf=
ig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g  | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-651-g1da2ded14cbf3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-651-g1da2ded14cbf3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1da2ded14cbf334077fc8ddf8148b5ca3eb30ed2 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie  | gcc-10   | bcm2835_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/64040f6c57a3d91a2b8c8639

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
1-g1da2ded14cbf3/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
1-g1da2ded14cbf3/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64040f6c57a3d91a2b8c8642
        failing since 7 days (last pass: v6.1.13-47-ge942f47f1a6d, first fa=
il: v6.1.13-47-g106bc513b009)

    2023-03-05T03:41:18.114355  / # #
    2023-03-05T03:41:18.217096  export SHELL=3D/bin/sh
    2023-03-05T03:41:18.217975  #
    2023-03-05T03:41:18.320261  / # export SHELL=3D/bin/sh. /lava-100066/en=
vironment
    2023-03-05T03:41:18.321167  =

    2023-03-05T03:41:18.423245  / # . /lava-100066/environment/lava-100066/=
bin/lava-test-runner /lava-100066/1
    2023-03-05T03:41:18.424458  =

    2023-03-05T03:41:18.431473  / # /lava-100066/bin/lava-test-runner /lava=
-100066/1
    2023-03-05T03:41:18.605803  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-05T03:41:18.609411  + cd /lava-100066/1/tests/1_bootrr =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/640411314604583dbe8c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
1-g1da2ded14cbf3/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
1-g1da2ded14cbf3/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640411314604583dbe8c8=
634
        new failure (last pass: v6.1.15-4-gf9fbed52efb7) =

 =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6404115da9227e49ab8c8679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
1-g1da2ded14cbf3/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-65=
1-g1da2ded14cbf3/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6404115da9227e49ab8c8=
67a
        new failure (last pass: v6.1.15-4-gf9fbed52efb7) =

 =20
