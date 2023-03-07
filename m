Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44BC6AD705
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 06:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCGF6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 00:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCGF6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 00:58:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E38126E8
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 21:58:08 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id i5so12999529pla.2
        for <stable@vger.kernel.org>; Mon, 06 Mar 2023 21:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678168687;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9/OyrBgLnBFeVreFfp13j3oh9D16KSkqWW+TgoworWc=;
        b=iERWgtv3gTFH3liFF4m/XR6EBTckcetmzU/diaWP//0I4WDGmOt8lF5vODDP7Az7M9
         C9upr3Wj2b9TqAJhbJ8Cl/2GHyDZehs/aNM0c1/cy25Gfts1XKnQxseniXlCcXtE0z7h
         LFR+ytVZZAjSWx1ryW/T5GBh5SgX2yDeGsur7tJoBXjSiPOu4evHx/YEdbiKWQfmoPIZ
         c/7fRiVRHB1MNdU/SbwVXZ8GiqVQp8ROQHzD0xgHLp2j2kllOw96ys4qYd1nkFpGmoOL
         gCFrVT4wUztyUqkR69IKt+HPvzsHy/1lHfjSRmHQ659ZsoSLYD78mVBNE2lxfPem1wJ6
         EL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678168687;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/OyrBgLnBFeVreFfp13j3oh9D16KSkqWW+TgoworWc=;
        b=PAq3TDrZXN0/bZwusAs4+Qc9gJEWKfDRLleXBSTYAEtSb7kqDdn4FkZxQKjGGDX4ur
         a9t5PaNXbnA2mJEtY2XCkpZ1ZCMGzTN+H5mjgytFgPI8pvnWeShLISdD180SIW2FOa0v
         T5eJM+gQSwhi+1caY3pbooUFIlXP+/hV66YCHfgHOqxtiIYbxsbbfE7qGHR/AxjIzBT4
         hY7/h73nNXCJTHFOUz2yVuVQrfDb7L+0ahGRZETM5DhdP0iumhMZuN5ZYiJNXfO89u/j
         +j3c81USRUtjoIaHVs0PY+pwygN5qGMzotVBj8c1io7qpW8YtGpFsCq5QTQn8XYKnELA
         OIYw==
X-Gm-Message-State: AO0yUKVcomsorKxf0Zc+YvwtlBP+RTK0AQEcufoQCEZzl9u4oh1adXKt
        hKtrfhaGaEOuygmarNvc+oPCodP4CUklK0LhgyoQgcH4
X-Google-Smtp-Source: AK7set9r2kb1GytzrTiNRKEPS1Vhxh8GxEXnYKPHvc3VRii9p35vXmDemte3vGlZKQkAI0HK0wTXxA==
X-Received: by 2002:a17:90a:1de:b0:237:3d0c:89ae with SMTP id 30-20020a17090a01de00b002373d0c89aemr14055335pjd.34.1678168687645;
        Mon, 06 Mar 2023 21:58:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 196-20020a6306cd000000b0050336b0b08csm7141853pgg.19.2023.03.06.21.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 21:58:07 -0800 (PST)
Message-ID: <6406d26f.630a0220.4b783.d42b@mx.google.com>
Date:   Mon, 06 Mar 2023 21:58:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-782-g0dcd2816cbbf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 176 runs,
 3 regressions (v6.1.15-782-g0dcd2816cbbf)
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

stable-rc/queue/6.1 baseline: 176 runs, 3 regressions (v6.1.15-782-g0dcd281=
6cbbf)

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
el/v6.1.15-782-g0dcd2816cbbf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-782-g0dcd2816cbbf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0dcd2816cbbff4d216a23183da8c4b00cae466fc =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
bcm2835-rpi-b-rev2     | arm    | lab-broonie  | gcc-10   | bcm2835_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/64069e17c5950a11fe8c8664

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-78=
2-g0dcd2816cbbf/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-78=
2-g0dcd2816cbbf/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64069e17c5950a11fe8c866d
        new failure (last pass: v6.1.15-660-g430daf603d29)

    2023-03-07T02:14:24.448963  + set +x
    2023-03-07T02:14:24.452988  <8>[   17.566362] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 114364_1.5.2.4.1>
    2023-03-07T02:14:24.568466  / # #
    2023-03-07T02:14:24.670197  export SHELL=3D/bin/sh
    2023-03-07T02:14:24.670641  #
    2023-03-07T02:14:24.772110  / # export SHELL=3D/bin/sh. /lava-114364/en=
vironment
    2023-03-07T02:14:24.772742  =

    2023-03-07T02:14:24.874618  / # . /lava-114364/environment/lava-114364/=
bin/lava-test-runner /lava-114364/1
    2023-03-07T02:14:24.876343  =

    2023-03-07T02:14:24.882130  / # /lava-114364/bin/lava-test-runner /lava=
-114364/1 =

    ... (14 line(s) more)  =

 =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/64069c1b3183cbbe8d8c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-78=
2-g0dcd2816cbbf/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-78=
2-g0dcd2816cbbf/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x=
86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64069c1b3183cbbe8d8c8=
632
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =



platform               | arch   | lab          | compiler | defconfig      =
   | regressions
-----------------------+--------+--------------+----------+----------------=
---+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/64069d8f6d180dd3668c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-78=
2-g0dcd2816cbbf/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-78=
2-g0dcd2816cbbf/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64069d8f6d180dd3668c8=
649
        failing since 1 day (last pass: v6.1.15-4-gf9fbed52efb7, first fail=
: v6.1.15-651-g1da2ded14cbf3) =

 =20
