Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC393FA4FF
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 12:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhH1Ke7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Aug 2021 06:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbhH1Ke7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Aug 2021 06:34:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95E0C061756
        for <stable@vger.kernel.org>; Sat, 28 Aug 2021 03:34:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fz10so6421996pjb.0
        for <stable@vger.kernel.org>; Sat, 28 Aug 2021 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=78yXAfSDafcPmefXpftQqE7tzQkLx/OcbWxeHjEzszI=;
        b=T1iQBN3QWQ8PdIAB+upN1cjnSlC3lBkinTWwDEcO4t5txKwrq6FG3aYNJtngqOQqoC
         o0eSuPUwe/sdpI7F5FkuwFrpZaUJoh5TBnml6xS24GLU0PG6gu2cy9vhRzp4bAmndHq0
         XzWS3APm3pFz68Era08IW30NvLBLJTSEb72LiFmCmDBeFWx/JvcLXw1FxMoTJ2lwsI67
         qrx2EVWizJro3Yb8wSG32c5O54uUT3HMuYc1w/nkbTdfQfA4VbMt3jUQdqvCNA75QfWq
         Vx3e6A3N0QQGu/nLt9ui+kCNZGZdK/j4JSp964x0+NYB2/BMd/ETb5BUSso/e9BcJXf8
         YpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=78yXAfSDafcPmefXpftQqE7tzQkLx/OcbWxeHjEzszI=;
        b=Tu/e4zemdQ4nURGNDc5Gd8AYCZn6hb+k1sKfmrRwH1vlLobxWBUvdEj/1WyPRAcdvI
         tqZius7zojbYhrorapECGZvhtUjjyRrs7p06l+0euUMVaDavdOegzpSZKcdqTCLVybpA
         R5lSQnxHNfAn9NrXSs1cPGn7DGwcuRHQjAsbzcoulWQ8NK5NPP35YIVIMYSUq4vrq0HG
         hc7ceTP17r07gLJ+9re3+9YJi9dLDenLl7UjKCJIiRV/JrQqllE0QyVJf4OP1Rsk2VOS
         hUSrrOV/VQGP/4kKU7fypV+czZv8212vh1BPRt/Rzbzjnv2a55rDsotKF0ZfeAppDxJT
         iMtw==
X-Gm-Message-State: AOAM532CSb5IOHL0aPDuXv+fbVQUNjsVcF2CAB8VfXjUIcuZd9+luxkL
        25DJV8REZXyj8RWX1R5i8IyhbE9E328uXuVV
X-Google-Smtp-Source: ABdhPJywRogOhcEL1cfgJH4BZDkld4O4CDgkB6vCXO0N/9BVTXLqx9AdvNt4cv5s222Haf4KLyc/GA==
X-Received: by 2002:a17:90a:28a6:: with SMTP id f35mr16324797pjd.68.1630146848267;
        Sat, 28 Aug 2021 03:34:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20sm9343198pgb.2.2021.08.28.03.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 03:34:08 -0700 (PDT)
Message-ID: <612a1120.1c69fb81.f2bb3.9893@mx.google.com>
Date:   Sat, 28 Aug 2021 03:34:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.13-13-gbe4cd3483df8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 154 runs,
 3 regressions (v5.13.13-13-gbe4cd3483df8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 154 runs, 3 regressions (v5.13.13-13-gbe4cd3=
483df8)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =

beagle-xm       | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =

fsl-ls1043a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig           | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-13-gbe4cd3483df8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-13-gbe4cd3483df8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be4cd3483df86f48ce6558c3c810319a779fcee2 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6129dc586f7395ecfd8e2c93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gbe4cd3483df8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gbe4cd3483df8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129dc586f7395ecfd8e2=
c94
        failing since 1 day (last pass: v5.13.12-126-g61c83bccf008, first f=
ail: v5.13.12-125-gf6c5dda713c6) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
beagle-xm       | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6129dda7254e3ed5ee8e2cb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gbe4cd3483df8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gbe4cd3483df8/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129dda7254e3ed5ee8e2=
cb7
        failing since 30 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform        | arch  | lab          | compiler | defconfig           | r=
egressions
----------------+-------+--------------+----------+---------------------+--=
----------
fsl-ls1043a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6129f6f07fe2a7ddfc8e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gbe4cd3483df8/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gbe4cd3483df8/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129f6f07fe2a7ddfc8e2=
c88
        new failure (last pass: v5.13.13-13-gc528c5e23aa0) =

 =20
