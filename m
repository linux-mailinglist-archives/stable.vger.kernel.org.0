Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883A73E0D68
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 06:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhHEEzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 00:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhHEEzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 00:55:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B7AC061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 21:55:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so12295637pjr.1
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 21:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sw4q2URfzGwlUFHSUdBeAJze5MD9DaUZ7uXgjWgTgco=;
        b=kuwyRADwdvYLCoMZzzR/KrYTDPoxgnwzRnXfHlVgh+sZg277ezevd0os2eVb+08n/L
         LAraIEurpkBYRstXoF5EwRyY/lF5JMXkfbupI/iwXJLYq3fK5T8vSObl1l1xPjSDPLDM
         TarvSKhPympKsX+CYCrx1SSM72fLsPi4FQuC4CukIFK5aBKTVlQa9EpNOxbHp88Biu4b
         GA5Z43S3xDLBs5VxaddWhpRn84LoVxkSnpLHwbTKRVoQ3g5c7mzb43xLljF9x2wvGjXk
         Eh3iRSeH6TheuQG1FvneHQsVT0idmMC+i5FM6m9e1FZ0KebQfVUlxe9SYKLldgxx7cbL
         KSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sw4q2URfzGwlUFHSUdBeAJze5MD9DaUZ7uXgjWgTgco=;
        b=IRq41RKqgFFV6EyAV7iXAN4UXKGE4LGQw4QKlZkQFtHqpvI4GWZOraIlzvX2SkBZIH
         qqE1sgxk2FnGrjFjvRJX86wGigNwbi3um/TBy0JJSFmM7MDjqgc3+C5g8PK5AIHeRY4i
         ClyGSpNpawuHyeow1eZSMFsovON6y1ozMOr24S51X5Xs+20loyM+DZJWS5/SEyjBuYQZ
         IV1hD3t8858c02PvyzLBhZ7SRZe91SuLZ9Q1MADHBjXzNUvVB6ok4alTNn+E5nY+XDnu
         Pz4TKqN7wMwkkIrbqXtWy8xRrNgfyvstkRldAJlrGpoKUGevW7nk7tCpcoeOnH2k1rKh
         bR+A==
X-Gm-Message-State: AOAM530fMsQ/ofhHnxHD1cvrbJY2jCFvRWb5QDR5uIIPIEimHCJsOMkD
        KHUpbukmlUlPXoADJewsIHrGzyJYn8G5M4x0X8M=
X-Google-Smtp-Source: ABdhPJy+MXxiYz8JnLo9GmpBSrP1in/l/amzKg3r7Ocfz0hGkbrIOQ1KinLq0Znn2cPeYDqhZosDLA==
X-Received: by 2002:a63:682:: with SMTP id 124mr159038pgg.299.1628139309845;
        Wed, 04 Aug 2021 21:55:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm543058pfm.27.2021.08.04.21.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 21:55:09 -0700 (PDT)
Message-ID: <610b6f2d.1c69fb81.42ec4.19d0@mx.google.com>
Date:   Wed, 04 Aug 2021 21:55:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-13-gcc9b1847f9a0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 130 runs,
 3 regressions (v5.13.8-13-gcc9b1847f9a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 130 runs, 3 regressions (v5.13.8-13-gcc9b184=
7f9a0)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig   =
| 1          =

imx7ulp-evk        | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfig =
| 1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig           =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-13-gcc9b1847f9a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-13-gcc9b1847f9a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc9b1847f9a0d4b01f7ad463d2699a7249b2f16d =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/610b38758c277a507eb13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-1=
3-gcc9b1847f9a0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-1=
3-gcc9b1847f9a0/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b38758c277a507eb13=
688
        new failure (last pass: v5.13.7-13-g46719403ead9) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
imx7ulp-evk        | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/610b3bf52e3a9794d0b13666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-1=
3-gcc9b1847f9a0/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-1=
3-gcc9b1847f9a0/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b3bf52e3a9794d0b13=
667
        new failure (last pass: v5.13.7-13-g46719403ead9) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/610b3b4c5c6f7cad94b13679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-1=
3-gcc9b1847f9a0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-1=
3-gcc9b1847f9a0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b3b4c5c6f7cad94b13=
67a
        new failure (last pass: v5.13.7-13-g46719403ead9) =

 =20
