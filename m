Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A40202427
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 16:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgFTOcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 10:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgFTOci (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Jun 2020 10:32:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978E7C06174E
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 07:32:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id k6so5295823pll.9
        for <stable@vger.kernel.org>; Sat, 20 Jun 2020 07:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nXyxG1Yx9RpbTWwdr4QTBiaY54SMtf0dL8FK++4kD7g=;
        b=QdNAzWOsbn6308/bimNH7mGYg62uejAvgLEA8ZXMCd1WOTOoTPvVP+oEL7qeVcMXjQ
         YpJmjOxWFoV6TLBzwovV2gGCHz0uH1srPeRcfkdO2RIj+jVt4W/wNRvVwBv4fvZz+zvR
         topw4KWFxVhGAmJ+TuH3SbX0eq3YxyQvRW9E5b1pxrvIMygxeRdKpcGNY/7ayyiFggHT
         gpPQVzGepO/XglEnzLs/cgZd4+bCcrJIntWU36hKkHCXgVzsPOp/X734tKWYKstf26iV
         0VTAPr8/I8TScoY+fgquL3UTXPUGm6SQh7tFk4AAAbsxrgLmtjnr8NXl4OmwKGRXWcPe
         V8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nXyxG1Yx9RpbTWwdr4QTBiaY54SMtf0dL8FK++4kD7g=;
        b=mdImWvwTkOLeuiiOnfuNiy+sHgkk4MilFNG5LWeAwtvJJxU3HFyop8HVRwXulR6h1M
         M3id8FLFH8djHNxui62ZT/VH3TzC/lkzXk2kGvWc47bwquve7lQl/9CTjocoSpo7yvtp
         Cdsjcgyzw8zi8kM8it3UaJwuQr4kqjOz/gYM7NdFq6K3HLf49vancZlD4W7dpTCa1kw4
         TNX22QQCi0W7uTMUJCWWxUhBaLQSor73bRpo0ShtHEcqzxWddW4AXwpgfY8G8XHzkF/n
         bUReh7nmmSyDeSTZ7/qnmfqrHqsg7YTsICbPTzq1yPMIZdrlVveYFnbrCqukzfGcvoF1
         RBrw==
X-Gm-Message-State: AOAM531vn898nAK503cnhIDPK7Aksy0Cq99NIi7umvwlwMkFLsssZxN/
        9FupVHR1XUD35xRPqe4B2CrnBEelxcg=
X-Google-Smtp-Source: ABdhPJyoIcVvdfZplbRT1l8qQLx+/KvQOoU5xz/a01c4dMS/pm2yRHWoN6XXWxyU0ibYLwqiBWFhCw==
X-Received: by 2002:a17:90a:7849:: with SMTP id y9mr8983438pjl.143.1592663556045;
        Sat, 20 Jun 2020 07:32:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv9sm8567519pjb.6.2020.06.20.07.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 07:32:35 -0700 (PDT)
Message-ID: <5eee1e03.1c69fb81.d7fa0.9e9e@mx.google.com>
Date:   Sat, 20 Jun 2020 07:32:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-321-g7e6addf7237f
Subject: stable-rc/linux-4.19.y baseline: 84 runs,
 2 regressions (v4.19.126-321-g7e6addf7237f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 84 runs, 2 regressions (v4.19.126-321-g7e6=
addf7237f)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-321-g7e6addf7237f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-321-g7e6addf7237f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e6addf7237fd56f0e64fd045b1d9e999705b189 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5eedecb2c4c7be894797bf0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-321-g7e6addf7237f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-321-g7e6addf7237f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eedecb2c4c7be894797b=
f0d
      failing since 4 days (last pass: v4.19.126-55-gf6c346f2d42d, first fa=
il: v4.19.126-113-gd694d4388e88) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5eedec4d7929f2522597bf09

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-321-g7e6addf7237f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-321-g7e6addf7237f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5eedec4d7929f252=
2597bf0c
      new failure (last pass: v4.19.126-323-ga00c59b63756)
      3 lines =20
