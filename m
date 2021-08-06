Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ECF3E2F38
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240460AbhHFSYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbhHFSYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:24:10 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927FCC0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 11:23:54 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mt6so17960325pjb.1
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 11:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZcOOdzhHrPLpRBXfXslMomo3EuK8IOCd/CIGnhtWfao=;
        b=YZY7jKtPDFnUDtRGws+Z1qXZpj2dFKkZcKaCtBnZizuBQwzK834ANGU9ADCZYrM6ZN
         Xt110dxHmlvSCfyTCOJHGZQjF6B4WI1r++1krZmdDDwe5vFj6QvVabFzf6ArzvQ1rfVH
         fGsbaO5UIcbEt7v7XdnDca1nX3k6VowbJmjMtrdu3OongWkGZhH8X0TEGaikBsAKXQl2
         /p6ZLc6CPiWFC96KwyPn+Hm4NFuLvGHaiAHl7g/vt4VVFRwkMOlu/GjOd5N46n2gMBMq
         ib6SaYRrYaSubAxbmD+JH5CkJG+w0+xgQ0Zq8IM7Fm6ryeAT3hFK5c+7Tts+BTdzVaPp
         bVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZcOOdzhHrPLpRBXfXslMomo3EuK8IOCd/CIGnhtWfao=;
        b=ge4rqw9oTe/vUTVrQCVvZW6F2tlhRHXfHQH5WLX2xhif6yX2W4EtietBPvs7bIqac4
         UOXrFeVIFtw2Hwl+yiIoXBpoe8EQVVrKM16mrcSqaOuB9W21cPQcvahwTRP8XRoTL4+N
         NlzqId9TKAUDaA1QueSljMoYAbl5+KqaxSkoci+cxXo/z8sObDsFqLrQx+uE3eOhR8YW
         /hRjVF43sTxjzErufRRL5xTfHi8p6McO/EEl+Aq7865Tchv1F4CQBHKmSO/CK7HvcDSm
         bQ6S7LJb6hY7VXsDWX8Z7szQQ9CMY98z6E+KcvL2sIVos1TKSyN+9/RrCQX6473j9WBV
         LLUw==
X-Gm-Message-State: AOAM530HFsKFaqDqOvdTMT79phc4nDT++Hz4SY79wzufT3VLRjUREGY9
        rOJCIq4amctorvNT3jzfl75NSgYHglKtyw==
X-Google-Smtp-Source: ABdhPJykoHleiNu4TAujpFvArPXCPlKvxlPFxitULp3hMSsk7dtQ5/9WhDUdnvdrP2pvl2YMvSiLsA==
X-Received: by 2002:a65:6554:: with SMTP id a20mr92069pgw.107.1628274233424;
        Fri, 06 Aug 2021 11:23:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n35sm12997383pgb.90.2021.08.06.11.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:23:52 -0700 (PDT)
Message-ID: <610d7e38.1c69fb81.dc8ca.6984@mx.google.com>
Date:   Fri, 06 Aug 2021 11:23:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-8-g36c4ea3b072f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 63 runs,
 3 regressions (v4.9.278-8-g36c4ea3b072f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 63 runs, 3 regressions (v4.9.278-8-g36c4ea3=
b072f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.278-8-g36c4ea3b072f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.278-8-g36c4ea3b072f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36c4ea3b072f93b011cbb5d863808049e393bdff =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610d4360c5c1e096c3b13697

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
-8-g36c4ea3b072f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
-8-g36c4ea3b072f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d4360c5c1e096c3b13=
698
        failing since 264 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610d437e679c1d5140b13698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
-8-g36c4ea3b072f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
-8-g36c4ea3b072f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d437e679c1d5140b13=
699
        failing since 264 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/610d4290c52cebf694b13688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
-8-g36c4ea3b072f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.278=
-8-g36c4ea3b072f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d4290c52cebf694b13=
689
        failing since 261 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
