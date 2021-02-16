Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9E31D28E
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 23:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhBPWWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 17:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhBPWWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 17:22:53 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4B0C061574
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:22:07 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id ba1so6299543plb.1
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 14:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C3G5WhK8HP+3BlxgMW2eks6SNn1Ch2kywC/YOOsUfiI=;
        b=nOuYYJlat814wNCamAsNHj3qgwuzhBkibNYyYYg1Di8T+RkIyExoxu8lw0NaUGoAYI
         LYAgyWuCIDkc8UUr73Tj7g26L7Ln714gNwyCQ3GJunmdp0bM4Y4gpAS0oJq/Z2lwhQ6N
         jRFP/oPyJWfbtn8dte62HVq5UCAfIj22SVWh46tQJQSU+1z0h4LA+BCbTCcmfjlhms0s
         vrd4y892d+b+5q6+Xn0ItMQ2n6YkyghBjvN7NEoF4AJbgPjl5DuS5VJPsykpx7EMzvWn
         OVW0RHAh58fNW7Z0lucWqvPo++kgpn839mhN3USBHUIfTXsAMeOtOI7v6MtCrjFT4lgb
         hpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C3G5WhK8HP+3BlxgMW2eks6SNn1Ch2kywC/YOOsUfiI=;
        b=mCAmWa2I9CJwvOBFbvvcBFmDkg28GJmPwa6k4s8nDP3uPgzOtjlEtO33sm2Y2ZeYZV
         NdEezKAwL41c2GRB5c2Axvk7TGNtVaw6+6drVaBaXt2tnvNvjjWXrZbhScsG9+pVW97w
         WDI4krLmDx/zLZKSvyr99t8IeKJ9MrnrNNZLpZ3Kr+FL7nheELpkm98f41eQwG80ryBc
         LQ7K1D35PECJN+azvRYQ6c3Ace1qJjQiQzPsc+RrCMOfyP/73x+cPPaLIZEhVQ4VSmq6
         nSOdReMa7hTigqHXy4XHe9dNLr9R1K7Z+7ItP/3FPRy3wD0v8Lsx2gsowBZrfPbOftEs
         7QGA==
X-Gm-Message-State: AOAM530aJIxGsnhFMUaBR4O6sBZIfV6ypTlMoYC27mjIB7Zp7nHF8Cer
        ns3jIEfvtS+NH4xf3L5kzuALhAboHYM2GA==
X-Google-Smtp-Source: ABdhPJwcdk/n1vUbfBCJ+UNeK4thWAl+8UNku7cF7XnU7TIP+cPVTelBzo2XoEQHhrRHiCYSdYClXw==
X-Received: by 2002:a17:902:7246:b029:e3:2313:20e7 with SMTP id c6-20020a1709027246b02900e3231320e7mr20761711pll.42.1613514127196;
        Tue, 16 Feb 2021 14:22:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1sm22796388pfd.212.2021.02.16.14.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 14:22:06 -0800 (PST)
Message-ID: <602c458e.1c69fb81.e4cc4.0c65@mx.google.com>
Date:   Tue, 16 Feb 2021 14:22:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.98-60-g0afc1071289d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 104 runs,
 2 regressions (v5.4.98-60-g0afc1071289d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 104 runs, 2 regressions (v5.4.98-60-g0afc1071=
289d)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.98-60-g0afc1071289d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.98-60-g0afc1071289d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0afc1071289da10172fabf648b3f71b0af5b7924 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602c119a9969a7f608addce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g0afc1071289d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g0afc1071289d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602c119a9969a7f608add=
ce5
        failing since 88 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602c15b56625426ad0addd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g0afc1071289d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.98-60=
-g0afc1071289d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602c15b56625426ad0add=
d2d
        new failure (last pass: v5.4.98-60-g5fea8afedb8f) =

 =20
