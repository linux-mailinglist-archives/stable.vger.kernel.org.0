Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C52422728A
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 00:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgGTW5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 18:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTW5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 18:57:45 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD6EC061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 15:57:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a14so9806975pfi.2
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 15:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iIYU2RhiE9LcOY8iaQcKQsvhbG9nlzgaS5XzTJY5NXg=;
        b=dHU+X5r8M3/FnVwIbVwddW+k1/mzQ1IewtVE+UFKK96qgnftM8EZaAzUp/Cq/zrKEB
         HviTRoknJdT83KT5QiYFOYxG0th8kVu8UrdEwkRvMwSlO8YAusSUkOJDjj3ln9i28xaP
         HdLcrCpl29KeElnWavkhKbz82TuJzSES1kPxbaqo7gdSvljmkuOWNRHlH0KcqjHN2mL0
         amvAUDK2Dm8aLH6b/mcuWXH2L7ZuTiHtFyquIbOULWNGsPedpB3GImgCpLpyhUYBhkMY
         +W//mFtGnzwdsqhJSFFY8fvJNmi2/ZzrdQ7fZrx9N/7iq8eM0tut88dGIXhVj/QKrmqD
         XCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iIYU2RhiE9LcOY8iaQcKQsvhbG9nlzgaS5XzTJY5NXg=;
        b=Jx7cO82d0DQKNZ8lQPDVzcHei8MPbxkcubD6mq5PykNjBlO+2bFGzlGfN+vd4AHx3K
         LYBH4tk0KHA3St5PFp2n05024Xu0izmG+HFKi2f3Y8GWxjBW5+2Xez7i8b8gy44Q8+rV
         9ae/TYbpHcsHQDrC0+6p1ElVoOjaZJnQ9vRn7YqCAUbfwOHNFpcPs9MJ+PhnfC6o/dTq
         Pii2bUKVXfnQGiqqhuIexcULc9rDd/rCr9+iGU9tS0GMf+431OvUS36O16/sEZ6LHjWx
         6K8iTej60lalwBLp9i9QR74ISllNn3iT0GOAR+rQCczshq0CzUOvcc7llgq0PB4M5xDN
         pK3A==
X-Gm-Message-State: AOAM532CSvuIbBxxt3iWa3RtArTR8XAUbpJTmU06xopSM5/p4xkFSXbA
        wYqhfvMu5hQ+2DWpjdsjuYUOiaZ0fEk=
X-Google-Smtp-Source: ABdhPJzIB9yvBMlqZC+bMz88RZle3S/DJrtkCwQRn3SrNpgMFWUlO2Xm7UFCyHNPRkUwh8EAibLfYw==
X-Received: by 2002:a63:be47:: with SMTP id g7mr20169559pgo.7.1595285863809;
        Mon, 20 Jul 2020 15:57:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4sm16700782pgf.9.2020.07.20.15.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 15:57:43 -0700 (PDT)
Message-ID: <5f162167.1c69fb81.6a229.87e9@mx.google.com>
Date:   Mon, 20 Jul 2020 15:57:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.52-216-g95f1079149bd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 84 runs,
 2 regressions (v5.4.52-216-g95f1079149bd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 84 runs, 2 regressions (v5.4.52-216-g95f107=
9149bd)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.52-216-g95f1079149bd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.52-216-g95f1079149bd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95f1079149bd5596df492ff3dd12dacdd264e0ea =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f15d3d2f1184d693685bb1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
216-g95f1079149bd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
216-g95f1079149bd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f15d3d2f1184d693685b=
b1d
      failing since 99 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f15ef10f83368263185bb18

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
216-g95f1079149bd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.52-=
216-g95f1079149bd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f15ef10f8336826=
3185bb1b
      new failure (last pass: v5.4.52-30-ge4f3e790ad57)
      3 lines =20
