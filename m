Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFA922FEDD
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 03:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgG1BXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 21:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG1BXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 21:23:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C77C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:23:01 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d188so3997730pfd.2
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EOB5B51t2Eb8h2wGkZk+KzT4iyzncD7k9od+FHXq7cs=;
        b=T/s3K4PYwji+s+Njed8JBNjIyyaKr0rm5OnC1L1E1pLxeJBfiZEqJac9kNZUkLciaw
         AUmBIxRi/dO/JOGDiByql/hMRjWW4gXvA+jRrKGNleSMfd1otkaWWEKk+/jU/r2Iocle
         0/2KQxbmd3nGh+RuoyRcSoRaagnolFFpOD3j4VIXmvj3X26XQRDw4C3QD2D1OIcjwr9T
         8wygwUFPHIn6WVRDecR+gvsFLrBLaYzWMKOXsWkTuy4quaXUk4UaaVfu6lWbSIFS63d0
         rf6LQQdlWL8j6piZQIvwjS366wbGaFgAx0F/CTonwrgAicx8xexwhgeXq4lfTohYTjVR
         hOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EOB5B51t2Eb8h2wGkZk+KzT4iyzncD7k9od+FHXq7cs=;
        b=P2Hu+s7JJrixcn5Rn035ZuSsfVG2w9Om5Pr15wRhqFIBVNTneDd5PI2IuQmSCanIcf
         lIBOpGs/BfuSu4J21cX3Ib9ltSPHqDPjlK6NrP+ZsSxLItye0kq3niycr6ADyGkEVbva
         sBDsDkWC1zYUQI/KUBiCeYm3ouyLCf64xyzLwdLai+ZKHOb38ejTD92MOinrl6NmuptN
         kEB3joThcnbD8/RoqG7OsKzd7wCFlZUICeFyVVEsIYQrnF3J+WHx3E/dUswhDOt2kYgo
         b3+T4vlLLCfN5rN+UXOfhO8uFtUQpTT5kjERr148HUszS4SQEm03Ah+i2mN8nkqihLlw
         IuIA==
X-Gm-Message-State: AOAM530YGK++Lx7KXXyVbKodT1QLOYMyjF4A8Ieoi7fFRG8tNqJGIcQv
        ruvrJ7wU4Hw6n5UgDNCAm6Np73crd5I=
X-Google-Smtp-Source: ABdhPJx5h5M4kiKVLMsK+X5S9XlOc3Hr3SEHop5hNFexIBqiKG5fIqYH1wzTmO6/5LW/e/kEOjYU+g==
X-Received: by 2002:a65:55c2:: with SMTP id k2mr21891176pgs.451.1595899381154;
        Mon, 27 Jul 2020 18:23:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm802151pjb.48.2020.07.27.18.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 18:23:00 -0700 (PDT)
Message-ID: <5f1f7df4.1c69fb81.8a05d.3cab@mx.google.com>
Date:   Mon, 27 Jul 2020 18:23:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.134-87-ge11702667f84
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 153 runs,
 2 regressions (v4.19.134-87-ge11702667f84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 153 runs, 2 regressions (v4.19.134-87-ge11=
702667f84)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 0/1    =

omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.134-87-ge11702667f84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.134-87-ge11702667f84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e11702667f84474535b156dbb194deffa0a6cdb4 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f42c959b0ad60af85bb26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ge11702667f84/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ge11702667f84/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f42c959b0ad60af85b=
b27
      failing since 41 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch | lab          | compiler | defconfig         =
  | results
----------------------+------+--------------+----------+-------------------=
--+--------
omap3-beagle-xm       | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f1f4a320bc32eaa4685bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ge11702667f84/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-oma=
p3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
34-87-ge11702667f84/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-oma=
p3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f1f4a320bc32eaa4685b=
b19
      new failure (last pass: v4.19.134) =20
