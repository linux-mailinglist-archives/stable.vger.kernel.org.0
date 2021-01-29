Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E22308CC2
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhA2Ssg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhA2Sr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:47:57 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B31AC061573
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 10:47:17 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r38so7262757pgk.13
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 10:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zo0/AydVYfDAmr97aYXbYV1yai2BThuSnKnui6bVmRc=;
        b=JrItdgGeTy+00DZIS65NNs6/D/hqU0F31kj3yk8fQbbTrF614iK7UFQxwnwvX8HMQZ
         GDwW4JczphVssfD3B+tCGMzJ+6kJK/tB+j5DAMBtngVeAEVERbxrnnugkD1YmxBTGTe1
         +NnDffkBEEBSaGQTu2yqcEdDrIxj3n9RPI7gGThr5N7x+GsbLtu5QmGXEjvjvL4qrMh0
         AzASVxx5Vg9z4KBTliBdsjV2AhyYDdBKXaQyBun22sKWs+Pw2bylz/GNcW3bnoeXgyld
         WrtsAGg9JHYrX5dyyvXPiePEcwHCvvzeL/4MqlFypUGc3euq9padwVoyaYwanfN6MSOK
         Czsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zo0/AydVYfDAmr97aYXbYV1yai2BThuSnKnui6bVmRc=;
        b=UiCWOaxFANFdaMjiGH0p/e/6Kpz6LKtqpSgTvM9dd9/EfinLcGLWitdBtkg7na1kxT
         vnmwRJuybfVClC6vp8OEwHFUVz7prIYx1VKhWtpoqT+7BZ51c+IZuUrwFtGVthFVdYxQ
         W2ofhlEA69ozHF76UDR0bTALrdcNS+2sw8TlCfDxyWkI4kzCek7RBr4FSD0tk/fIFT6C
         l3rnpb8Zo+F+UNGqFuT71AyGchXGBBu3jR3o4FR/Jzh0sRQbKuSEyFX3VbsWWXXM9sCi
         NN1y2KSbln8le1bg4jZPeRkraUjfYAPdBFsW8mjKgxI01ryRfRgVZAQcx40BLJNfno+h
         Lq1A==
X-Gm-Message-State: AOAM533rQ+Pn8An/oq/65ydvFmtFFFc19kSIIWRBi5l5zPEADCMrbqxa
        9rYXR07T0kFTmGrfr978W1vwEDW7agowJQ==
X-Google-Smtp-Source: ABdhPJycp/UqXlVgMGkD8e6MleOsDF60jsBp45yovrYkoxJ0AUPw303gzvwsapj+XhIwwg59TlHQLw==
X-Received: by 2002:a62:7896:0:b029:1b6:7319:52a7 with SMTP id t144-20020a6278960000b02901b6731952a7mr5744607pfc.30.1611946036435;
        Fri, 29 Jan 2021 10:47:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18sm9561421pfd.206.2021.01.29.10.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 10:47:15 -0800 (PST)
Message-ID: <60145833.1c69fb81.38442.6f3f@mx.google.com>
Date:   Fri, 29 Jan 2021 10:47:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.93-19-g5a6e0182cbe9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 99 runs,
 5 regressions (v5.4.93-19-g5a6e0182cbe9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 99 runs, 5 regressions (v5.4.93-19-g5a6e018=
2cbe9)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.93-19-g5a6e0182cbe9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.93-19-g5a6e0182cbe9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a6e0182cbe9eb6e7cefcb8761c5c9b4f15c02b1 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60141ebbb099232f10d3dffc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60141ebbb099232f10d3d=
ffd
        failing since 70 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60141cfd6c711ca400d3dfd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60141cfd6c711ca400d3d=
fd3
        failing since 75 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60141d224712d6dd3fd3dfe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60141d224712d6dd3fd3d=
fe2
        failing since 75 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60141d2a1800133edcd3dfec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60141d2a1800133edcd3d=
fed
        failing since 75 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60141caea0e1e98b4bd3dfe3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.93-=
19-g5a6e0182cbe9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60141caea0e1e98b4bd3d=
fe4
        failing since 75 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
