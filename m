Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0362D440E
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgLIOSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgLIOSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 09:18:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB89C06179C
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 06:17:43 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 69so1261772pgg.8
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 06:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YOY9pRiXkP1gcJIl7gDBPo4i49l6/hw4Zb2TKo3WT8s=;
        b=NSNTlK6VcUNGjVnhkLQR1PbKYtT/1GKDbr5z8Yhj4gyXM38PRK8BLFr6qihVAy5h3V
         Agtg5sTR9aDEBA5SWsvuirASv13LkUcuvjnX/q/ae3ZQssjlWS4IKxB5I87Tu7G61eyi
         ujwsRZlRPHObHPco1CsvnSHIM+S8ZsVfjsjf7xzRXgXRwolqr4cQhKfaVdJRmjIo7bUt
         N5ZwN5bzs3n/ZpqHRI3OWpUatCyDajsQhHDUHwrks99kATI0UKFfwkITldIa1AZFLScw
         bxB543Xy3FxPTXhfCVtpCPCAXDbi5OHRuln7b10HvezmhDqWq7Fpncde7cfTbFr0pQlt
         HJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YOY9pRiXkP1gcJIl7gDBPo4i49l6/hw4Zb2TKo3WT8s=;
        b=OeKWTkxISZc3j950AWyQwpe/c3B/MGMzfow8tFsy9BMtPcmPJ1NahT94zsVmQc5flN
         doHM79lkmDOWX5XkIYjjFdVlPVQDQJXFfSbijsfcatvGRurYH/N4hNztD3HrfYZdpw2U
         dkc/wP/9Y+i/EcB5UkwF0AvmED9WvTC7O6gkf/opsONegE28ArBf1xo7ZuY9QpNARV9B
         r/PrgOq09SgDisY3Pqfto1LIx9mC+tpS3j6+JfT2ELmqa7fbYJC1dCaVOLDdQd2drNtE
         j0TfZ8vnWxPjZWf1GkjuJgYFPtd8VNcpvKev8ZDtsvKmGRSUdEZKUoOuzEaTLLf+3liX
         BLcQ==
X-Gm-Message-State: AOAM533tPvOyECXHmJQ7LmiJEPijSht4H0TDjZc4GKhIQvE7Fzb26FHK
        K8e26itRZsPxsLJ6HOwN/AmL5sHXPbGAqQ==
X-Google-Smtp-Source: ABdhPJzy6R22eQZwcUR5609OTd1MwFUHQjUiI0Ef75loMtBENlCdC0U4OhNFkSVoquBFVcGZ09mvpg==
X-Received: by 2002:a62:8895:0:b029:19e:92ec:6886 with SMTP id l143-20020a6288950000b029019e92ec6886mr2337550pfd.12.1607523462895;
        Wed, 09 Dec 2020 06:17:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u25sm2665047pgl.68.2020.12.09.06.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 06:17:42 -0800 (PST)
Message-ID: <5fd0dc86.1c69fb81.b29af.48d8@mx.google.com>
Date:   Wed, 09 Dec 2020 06:17:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-33-ge34980fc14c5e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 5 regressions (v4.9.247-33-ge34980fc14c5e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 5 regressions (v4.9.247-33-ge34980fc=
14c5e)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-33-ge34980fc14c5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-33-ge34980fc14c5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e34980fc14c5e6ace1328d73d85a55b1b104486d =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a91eb3fd47c64fc94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a91eb3fd47c64fc94=
ce4
        failing since 41 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a7a531a302d13ac94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a7a531a302d13ac94=
ceb
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a9f2caa65abe94c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a9f2caa65abe94c94=
cd1
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a7b4202944159fc94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a7b4202944159fc94=
cbd
        failing since 25 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
r8a7795-salvator-x    | arm64 | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a808a6b6e2bcecc94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-3=
3-ge34980fc14c5e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a808a6b6e2bcecc94=
ce3
        failing since 21 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20
