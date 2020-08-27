Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AD7254526
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 14:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgH0Ml6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 08:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728951AbgH0MlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 08:41:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45929C061264
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 05:41:08 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id i13so2559061pjv.0
        for <stable@vger.kernel.org>; Thu, 27 Aug 2020 05:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pvYe2yAYM6imtJ1vXMSkSZKSx+p7QCzj0wsUvqZOw9M=;
        b=gwCWh8qA4GvdHwj1zDTfeGkr9PsYbu0ffpyoWwsZrbgswuIhH2ecF/1zkjcj0fcAAg
         i4JmFuBfFtcdonze61pPOAcJl0esdR4Vb8cQOEvu+iW5gVPbNC6dsoxZScf2nI1j1nfn
         6mSmMBpRPgQwdN9zIUN2TpsXQkHhT2gSMEB1GP3Ww1RIMhn3zJZ8WtNWwdLXiakW9woq
         2nYQAh3rLC2BsDZkk6XmyUm5KLaT5qrwKtia8WwMNzUDLcGZhlR6ROGZVkCCginex8GB
         R0DA1hrXMw7sSKlit8kO6pxGcydN3jJx4wwmVEJLLnpIOoxwSGBJSdaeDvQ/5fKWcNr6
         UQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pvYe2yAYM6imtJ1vXMSkSZKSx+p7QCzj0wsUvqZOw9M=;
        b=QS8xnJdm1TbfnmNamgXGmmdxFr9nsKpFzSbPRef6phZx9CDWYyjnO/KrdQ21DZ/7WB
         Pb8CpEXtVTrKSr0CT2Lmw44tRwJrKYJ1Szl693SIKpjBCJQfoigB0iQAq/kjygQHJOh0
         KFItNopoAOjP+b6xCIS8lI+YLk91jssLExMRrgQND7fPlfbRrOSuyaD46AbJsng1ZReL
         0+oIZZWELCC03Vif3wGJzQr0WdrDuvbTl83piEOgiHIElJ/z0RwCdS/8WC0/qkwIL9Pw
         jl1FKra+pNpVJfSHrs2d2sQTxw8OpBuJQ1BcxZc8YGVSbzbyRfEo1ii0/G2VZvRibxuM
         U1fg==
X-Gm-Message-State: AOAM533+RmqzTqUiVTIYj0jnaAHsAO5cL435Zx8r8YFKN9lFzBJEKCW1
        7MHiBkaJaLjG/ubJmhBPnJXVSKJlHSxaug==
X-Google-Smtp-Source: ABdhPJwvB0JU8u3kF8Ej8n29x6sOs0ILPI/M6Kr6KPDqg2Z5GD1Q9DSfDveXbBawchlOyMQ1Iy+63Q==
X-Received: by 2002:a17:90a:a101:: with SMTP id s1mr9752654pjp.205.1598532067462;
        Thu, 27 Aug 2020 05:41:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm2404522pgi.87.2020.08.27.05.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 05:41:06 -0700 (PDT)
Message-ID: <5f47a9e2.1c69fb81.7bdf6.5cbb@mx.google.com>
Date:   Thu, 27 Aug 2020 05:41:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.19
Subject: stable/linux-5.7.y baseline: 170 runs, 2 regressions (v5.7.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.7.y baseline: 170 runs, 2 regressions (v5.7.19)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
| results
---------------------+-------+---------------+----------+------------------=
+--------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
| 3/4    =

exynos5422-odroidxu3 | arm   | lab-collabora | gcc-8    | exynos_defconfig =
| 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.7.y/kernel/=
v5.7.19/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.7.y
  Describe: v5.7.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6b9830fecd4a87d7ebb4d93484fef00f46d0fa0f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
| results
---------------------+-------+---------------+----------+------------------=
+--------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
| 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f47740dd9f4000d7a9fb438

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.7.y/v5.7.19/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.7.y/v5.7.19/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f47740dd9f4000d=
7a9fb43c
      failing since 0 day (last pass: v5.7.17, first fail: v5.7.18)
      1 lines

    2020-08-27 08:49:19.571000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-08-27 08:49:19.571000  (user:khilman) is already connected
    2020-08-27 08:49:35.676000  =00
    2020-08-27 08:49:35.677000  =

    2020-08-27 08:49:35.677000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-08-27 08:49:35.678000  =

    2020-08-27 08:49:35.678000  DRAM:  948 MiB
    2020-08-27 08:49:35.692000  RPI 3 Model B (0xa02082)
    2020-08-27 08:49:35.780000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-08-27 08:49:35.812000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (380 line(s) more)
      =



platform             | arch  | lab           | compiler | defconfig        =
| results
---------------------+-------+---------------+----------+------------------=
+--------
exynos5422-odroidxu3 | arm   | lab-collabora | gcc-8    | exynos_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f477d80a09afa1a669fb481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.7.y/v5.7.19/arm=
/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.7.y/v5.7.19/arm=
/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f477d80a09afa1a669fb=
482
      failing since 5 days (last pass: v5.7.16, first fail: v5.7.17)  =20
