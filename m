Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA64CEB8E
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 13:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiCFMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 07:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCFMfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 07:35:15 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FC36583B
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 04:34:22 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id k92so1877316pjh.5
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 04:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JzpjqnlsN7t1D8TvRacuS6xgEP2lp+nCfIgK/+rIB7g=;
        b=MyvMNBlas60kS1QVQjJjmc0vS/R1nPKCCtWRh8anJZZqNbWPZI08QH0jry40U1lq47
         ghzHHPMMjvyTdoXEQojkOoWBf5QsQjeIQ1pXr4zZb+dkYv7qEBU8rHWgniB2HzCfkrzm
         04nfqgthpHaK7PXzUdPmjiiFknWIjTf5DaIyO9DOK/m6IRzpe7smfAguPxucz6lUXu2H
         4ezuquecdxKgCnB+mafl+pVlvSa0ytrPehWaBHroKyfwRVSYYYkW51Fc6XBcYCUV5oCt
         vR7WDDE/vFyz1NhtAhYC3o4CeiA4BUwrgFRQ7gheh7/+3yixyESJJE0Y+nom9yogc5ID
         5UbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JzpjqnlsN7t1D8TvRacuS6xgEP2lp+nCfIgK/+rIB7g=;
        b=Wfq1nZt0CP/tJIrapfBtNmAPEJHSOh6Sx7RPHnhracz/R5p2CDHsX8sGFPEAmfhkAD
         qu/ZBcWMokajF2eYw6hF8WHToo2toPTd6ZaSD4HWBITpMU2Kbjk7nZCwiYvz/yrrhHYy
         4G+76DoMtOk9hvOUR1eSxJRcMPh6iSMSoQSiSMwQuOVUfdpX8OLflFrU+MehIysnxmrv
         b8AZCfZn2wVvUvX3YPXw7br8qhmWHtqfwtsk2gR3y2aGeAbtArg6qdGblhE9VnFNI2nG
         DdyuKYlJ4BNoutDyCIiH6gKWYpAgoftqiu4bESbDA1A1/zwHM9a+YsSfdCMUceEGaYL8
         uI3w==
X-Gm-Message-State: AOAM531ZlXecGhYk4l8VsnFTeI8NGJ0+oKKnNDGlkzb+qfqnbB1WNJF0
        WgZP4i9PMrigQycSkAyP6/8V9JQyeMB/V8ox0bU=
X-Google-Smtp-Source: ABdhPJxME9mATcL8tfxAVMcNN4tIXN1oVI3TBM9RDN/VIxtSNjViM3NGLzzMK+iwMEN1x6LUviJTrA==
X-Received: by 2002:a17:902:b28a:b0:151:bbc9:ec1c with SMTP id u10-20020a170902b28a00b00151bbc9ec1cmr7646280plr.13.1646570061724;
        Sun, 06 Mar 2022 04:34:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm277062pjb.4.2022.03.06.04.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 04:34:21 -0800 (PST)
Message-ID: <6224aa4d.1c69fb81.25e63.0809@mx.google.com>
Date:   Sun, 06 Mar 2022 04:34:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-53-gb54ccf4e0b7c
Subject: stable-rc/queue/5.4 baseline: 98 runs,
 4 regressions (v5.4.182-53-gb54ccf4e0b7c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 98 runs, 4 regressions (v5.4.182-53-gb54ccf4e=
0b7c)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxm-q200           | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-53-gb54ccf4e0b7c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-53-gb54ccf4e0b7c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b54ccf4e0b7c7e874aa658bec236f4237263c7ce =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxm-q200           | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62248fd7689d508cc5c6296f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62248fd7689d508cc5c62=
970
        new failure (last pass: v5.4.182-53-ge31c0b084082) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62247551793d1e1bc7c62975

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62247551793d1e1bc7c62=
976
        failing since 80 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62247578793d1e1bc7c62994

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62247578793d1e1bc7c62=
995
        failing since 80 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62247226e181d51f00c6297d

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-5=
3-gb54ccf4e0b7c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62247226e181d51f00c629a3
        failing since 0 day (last pass: v5.4.182-30-g45ccd59cc16f, first fa=
il: v5.4.182-53-ge31c0b084082)

    2022-03-06T08:34:38.920231  /lava-5824810/1/../bin/lava-test-case
    2022-03-06T08:34:38.928794  <8>[   32.765051] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
