Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CEF253A04
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 00:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgHZWCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 18:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHZWCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 18:02:16 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D9C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 15:02:16 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 2so1542248pjx.5
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 15:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EAdLS87RzCPew2e9d7Odm/dzl7GRsMIndWNQ5FpyBWk=;
        b=w0VBJ3TNhncOk00XGTXDG2xVbpW305o7zVMx0kZ25f0Luj94W2YEbAdIozpXAtdeNv
         L+vsDi+RbZx2p/tQI1U7XIOM6PmLVN2BpX3b/fX38DIn53RvVeMKce2LeOYbt3AHXPJr
         Tisv4IPlM4aprwYw2R5heocfS9fE6VEQ6Q6RWxMTwhESnFvsbQ4zx6HFsKr6F0dGOdxt
         P1uGXD9onANIB15/dlCSEgKMTs+wLgb8iYtIrkhsNiDnC769NyEzBQgDbL09D+leok4H
         MTRGBtnGtNKmox2kaIytWeabeJjka83BTzmCL9ZPvoS/BaoXYPaUafLiHqD810OZcwj0
         QLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EAdLS87RzCPew2e9d7Odm/dzl7GRsMIndWNQ5FpyBWk=;
        b=aySiloQvtKjnLdXRwWIzW/IeSF/DOKzjIoANtt2CkJTPPdhXNfHOU5oXWIE5Q2UMER
         Q2lvGk0s01nq/TRO+EXjjkYNjFOvgVKPbyERxCch4rmf3Mvfbv5l+eboqUhxt8FlopPS
         mvVa6RTGY63KbBMAQBNj/Y7x2z+hhEIWse0KRA0nLRJcYB7oYuJEXAaUvNe8S33TaKHI
         rms6bKG9JV7kLIWvExmMAlmgjKA6xvLOjF8de6JeaW0hTuxbhaHGLWNHix+CE3WUwWuT
         FTvqzmnUeMFP/OSHQ0R8rlUkG/B7ZcFqkyG89Svuhm6UpgOFBm/peo+0FvQUODiSXfc7
         DNhg==
X-Gm-Message-State: AOAM531b3b9yVti0NTXqWcMgFrQm65t6ZqZRNiSn1H58dnIZBZcNh9gA
        t3217WADU2KUlLaqqXRk9jeNKstKoY5D2Q==
X-Google-Smtp-Source: ABdhPJxuceSWZ/IP0y4SKIka+LLe0tzS4CR2QJ9trD0a4DexojjZL4pX30P/LSYKeyK0mDHzp2qGGA==
X-Received: by 2002:a17:90a:19d1:: with SMTP id 17mr7585157pjj.93.1598479334198;
        Wed, 26 Aug 2020 15:02:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm24648pgb.23.2020.08.26.15.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:02:13 -0700 (PDT)
Message-ID: <5f46dbe5.1c69fb81.903dc.03a2@mx.google.com>
Date:   Wed, 26 Aug 2020 15:02:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.18-16-g6ae4171ed2cd
Subject: stable-rc/linux-5.7.y baseline: 184 runs,
 3 regressions (v5.7.18-16-g6ae4171ed2cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 184 runs, 3 regressions (v5.7.18-16-g6ae417=
1ed2cd)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
 | 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
 | 3/4    =

exynos5422-odroidxu3  | arm   | lab-collabora | gcc-8    | exynos_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.18-16-g6ae4171ed2cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.18-16-g6ae4171ed2cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ae4171ed2cd47d945dbd8ce6a2918c00b498022 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f46a9f918fe22a1399fb460

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.18-=
16-g6ae4171ed2cd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.18-=
16-g6ae4171ed2cd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f46a9f918fe22a1399fb=
461
      failing since 41 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
 | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f46a889ca4fa4077e9fb446

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.18-=
16-g6ae4171ed2cd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.18-=
16-g6ae4171ed2cd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f46a889ca4fa407=
7e9fb44a
      new failure (last pass: v5.7.17-128-gf16d132bb2de)
      5 lines

    2020-08-26 18:20:19.227000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-08-26 18:20:19.228000  (user:khilman) is already connected
    2020-08-26 18:20:35.763000  =00
    2020-08-26 18:20:35.764000  =

    2020-08-26 18:20:35.764000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-08-26 18:20:35.764000  =

    2020-08-26 18:20:35.764000  DRAM:  948 MiB
    2020-08-26 18:20:35.780000  RPI 3 Model B (0xa02082)
    2020-08-26 18:20:35.866000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-08-26 18:20:35.898000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (399 line(s) more)
      =



platform              | arch  | lab           | compiler | defconfig       =
 | results
----------------------+-------+---------------+----------+-----------------=
-+--------
exynos5422-odroidxu3  | arm   | lab-collabora | gcc-8    | exynos_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f46b94936ad1484099fb44a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.18-=
16-g6ae4171ed2cd/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos54=
22-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.18-=
16-g6ae4171ed2cd/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos54=
22-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f46b94936ad1484099fb=
44b
      failing since 6 days (last pass: v5.7.16-99-gc5aad81e7f2d, first fail=
: v5.7.16-205-g7366707e7e99)  =20
