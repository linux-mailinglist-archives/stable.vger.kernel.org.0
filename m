Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC241FBF12
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 21:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgFPTfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 15:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbgFPTfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 15:35:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC60C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 12:35:50 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z63so9062864pfb.1
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 12:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GiT1kd7lOgGV4RsvVeS8xYGaq8Dzay+iunIG96mN4/A=;
        b=zVIwxkmtxepAdm2DuVbHOLmkJIfERs5uRYdeVn3N96nZXtYfFbSKXg30Bwan9bhKtD
         ykNrrhznlPrSFWjXF6edZp94QZik5UXrbP6BNQ4k2RBKey4Bs9MatFkfLH1yyLmpSIF6
         u3OOE71y6I7Dg3vlXqia7V/OtREtCNIg7O+V/Q10aUYB3HMAVsVureNG+X3JJ7Q251U8
         e2Iv7hj8St9o2suDMvTuhDTpMk/68rO6Wq8G9sxPEHxeAU7AEfFD5mbEnG5FRtb0uu1o
         HjG46o8P1L9XUBHTgO6g6E2GCTwnd3ejq8WmLlGLainifxyrv3a4DuzUKBjfd8Zm9So3
         KUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GiT1kd7lOgGV4RsvVeS8xYGaq8Dzay+iunIG96mN4/A=;
        b=f7I/N1hAJemD1rBLDMS9RmucGlZmusCN4n8iipoHhQfB112To8ZGiliZYOkiOLDAAP
         EU8Kb54/mkbSZvsa0ikSTzVcEoqKh5A4RVQhTiaHD2jDxXnzycXoN32w3zhnyWxQJszI
         DmuUEY+qTxV9pg0b1/dIiUfzaRHFuJow6et5XwMBgEOTgDd3twntftan7hjmwD+UzCaG
         /molMJcI72qumUWNE4sqOa2/lfcTnRH046wVE5h57mjF1zdhEXQ5u5AaJwJl3pSh35Fv
         AIQljuAhU4AH7fpEKdtLxY5hAaDlR9fMi5oBiMmhOCicg/EaFAEO88vA1noUdqD/xyTH
         757Q==
X-Gm-Message-State: AOAM533O/GpuF4AV/Fa5N5PfT04wbdRQ8Yu3UtuwyittXdK347xBP+80
        w+yRcd0NnGjlZ3iN79bv2clRSHC6Sp0=
X-Google-Smtp-Source: ABdhPJxz3eJikNrdVpnBhlFpBJmDQuwlsO5Xm+dKqUl/tpOF4vAvVgpCtKR1VT67dA6rk8EnqfuEWA==
X-Received: by 2002:a63:b252:: with SMTP id t18mr3244111pgo.133.1592336149238;
        Tue, 16 Jun 2020 12:35:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w18sm7530370pgj.31.2020.06.16.12.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 12:35:47 -0700 (PDT)
Message-ID: <5ee91f13.1c69fb81.ab904.5243@mx.google.com>
Date:   Tue, 16 Jun 2020 12:35:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-207-gfb0f5b2f83d5
Subject: stable-rc/linux-5.4.y baseline: 82 runs,
 2 regressions (v5.4.44-207-gfb0f5b2f83d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 82 runs, 2 regressions (v5.4.44-207-gfb0f5b=
2f83d5)

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
el/v5.4.44-207-gfb0f5b2f83d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-207-gfb0f5b2f83d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb0f5b2f83d55889e853c892505f02fd31a61a90 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee8e85bf60127a96697bf1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
207-gfb0f5b2f83d5/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
207-gfb0f5b2f83d5/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee8e85bf60127a96697b=
f1b
      failing since 65 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee8e948c57af2cca697bf10

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
207-gfb0f5b2f83d5/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
207-gfb0f5b2f83d5/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee8e948c57af2cc=
a697bf13
      failing since 10 days (last pass: v5.4.44, first fail: v5.4.44-39-g0e=
4e419d5fc3)
      1 lines =20
