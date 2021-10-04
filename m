Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC964206C5
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 09:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhJDHpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 03:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhJDHpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 03:45:19 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CDFC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 00:43:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g184so15738311pgc.6
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 00:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ebQPxvRAL4BN4raHmmAjxQxKv2tDfp3o5HviD/VWrBM=;
        b=IXAnIEHjiTbGtubknuKhe+e6GEYDlo9RWjSKLXDFgCofyBlhgKf+f0bqXVSRj0ZChT
         0z0b/8ps88zqvXRxNBsSNm937CUQjc36JewAWWqFj+eNMLOFVCtCG15JVE0AiZEcGaM4
         ezZprdgqASB6xXKSY56zTBZu2YCXT8C5kR5Q4iljo5EaqXkvp2jdq0lTzP/i/J/U3p7e
         wZbNY46Gcx+bbDyd+xHsRn+QSpc5QeZuEHX6ZojNMp9lwmCrDZ8avzTFve9ctrd0En5U
         YwanplH9dxACxcF2iHnq08W9QRsGBnb74BT1oxG9n7tuAjp1ABKD4Nxl/leJBebKtxIU
         tttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ebQPxvRAL4BN4raHmmAjxQxKv2tDfp3o5HviD/VWrBM=;
        b=fmagjZR7ZRanXRate+5d1KtBmftoUcQdoF52lpbtY4ODNfC4YkAs0m6Na39rz0G6jT
         Lra9UC5h1N4MvhMeD+1IbnsPzkrQl4XCu6Q/JqEhzbmEJWp9K6/K7t5AcEJQi2GxXmwk
         1iMdrjpphs1ljzrL35bLIiszRmjh4e7zyFudur5jd6S/6Q2r8DC4xAeh7QmqkPJWLYEG
         lc8Q9rpd58yl96OpmEy4CTo+EUXzaSjB6FeI2CCsol17/wkcgRE+HHvWx0sOUgSaROo7
         0PYCq6Yf7iCHWDHAt7N4fcUdmE/Ky32aBW64ZgaAr9FZZIMBFMrmpradhRSX7sJIO3d/
         c7cA==
X-Gm-Message-State: AOAM530TAOXAyoqtXmxdWvvfejjrhI7zNfbgZsA/5XsaDD5iJOqXDrGC
        PTO14qJjJa4eROYdSv+zTq9ZxdC3P6M+tqyw
X-Google-Smtp-Source: ABdhPJxlq2NqkvQ9oe2axOu4N8O/06lc/hl0Sj+ngd8FxYEqat05WIq5ar8e2xORdDwfu9eOEgNfag==
X-Received: by 2002:a63:ef57:: with SMTP id c23mr9493221pgk.60.1633333410661;
        Mon, 04 Oct 2021 00:43:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm13283774pfg.136.2021.10.04.00.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 00:43:30 -0700 (PDT)
Message-ID: <615ab0a2.1c69fb81.a36f0.7688@mx.google.com>
Date:   Mon, 04 Oct 2021 00:43:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-73-gb9d08ffadf94
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 204 runs,
 3 regressions (v5.14.9-73-gb9d08ffadf94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 204 runs, 3 regressions (v5.14.9-73-gb9d08ff=
adf94)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.9-73-gb9d08ffadf94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.9-73-gb9d08ffadf94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9d08ffadf94289c2c38b2036becf442c0ed482d =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/615a7c40c7f4f3c07e99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-7=
3-gb9d08ffadf94/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-7=
3-gb9d08ffadf94/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a7c40c7f4f3c07e99a=
2e1
        failing since 5 days (last pass: v5.14.7-248-gf2e859a1e522, first f=
ail: v5.14.8-160-gc91145f28005) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615a7d94d87938d5d299a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-7=
3-gb9d08ffadf94/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-7=
3-gb9d08ffadf94/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a7d94d87938d5d299a=
2db
        failing since 3 days (last pass: v5.14.8-160-gc91145f28005, first f=
ail: v5.14.8-160-g69e08636c9b8) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615a7f771a5a3b501299a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-7=
3-gb9d08ffadf94/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.9-7=
3-gb9d08ffadf94/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a7f771a5a3b501299a=
2dd
        failing since 9 days (last pass: v5.14.7-3-g11f9723f1192, first fai=
l: v5.14.7-100-g3633965a8dc7) =

 =20
