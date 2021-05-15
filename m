Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5E83816CE
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhEOIRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbhEOIRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:17:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6527EC06174A
        for <stable@vger.kernel.org>; Sat, 15 May 2021 01:16:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id v11-20020a17090a6b0bb029015cba7c6bdeso982017pjj.0
        for <stable@vger.kernel.org>; Sat, 15 May 2021 01:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6lKYo+/NTp96gZJJxY1A99yckFHSBn1oM6bC1/HKokA=;
        b=ONHvZEq8n7aDwK1QvcP4rsj4ROln4kPaX19CxcNQ6HQCLCzmXF6m8+q/fNxyFczl/X
         AZ4xSiwAkTHZbv07l9TDFUFrqIUP+6bi/O1tTaPg1/DtSlp7ZNkssQ8Wzef8C/91sIW0
         xpiGVI+MpsZEwZ+kWgVNk7GCOm6/1g97JSkN5+GphMxBVqzsZzsaf19oBs6cD+mVrvGU
         2otEQTcgA/rSRNdVsQkhgwI1hvwN1Ql+5MRWGhxBKTP91C55cfhY2sxJwuAivJm+teTt
         uyb8UFAqpn4f2ii2USq0hjvgDqPYXbPn0eIhBWKFwZyZtUVLyV+vqnfK59kFlkydSrgX
         R7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6lKYo+/NTp96gZJJxY1A99yckFHSBn1oM6bC1/HKokA=;
        b=UIcoNoHWFZbBudNNZ+s3awK+kfxpblHzn5YcL9dtwp/MmYC41EnfVjXbWDakssc/ar
         mzATqGlDDZpmy3HhD2jAwNe+CUvCV25oqYM1zgKATxeCQOWbjr4JpOvNYCO0LyLyqjb/
         6s3c45SA58Q2oYNjEqfY5Lh6YNlGVv/ltjO2YAeEFJoFzYj08+nb4BqCrDRrJVtYIKpz
         3HY5U5P8tjdueTdz1escGKoGYldmDskLsOTTm4Vlib4aAnyw0KIA6KFPjPu/yfv7nBNZ
         uJMLnY3it/F/xt9Je2XEu1u8vOfhfrBq2AKVajT2yjadIIxv29+9tJSsU5QltCWHPxMm
         3hOQ==
X-Gm-Message-State: AOAM533CppB1iYfVsB/H8O8NmVXFDPNvJobnfYr96XQF1egY/EIj+zuR
        TkH2pNkViSLzYlCvdob89SgQ8QsGBcteR7L4
X-Google-Smtp-Source: ABdhPJz/DYBVvwlP4NgoMmm5EbOT5aqy6luWYzzLmhuoys0Xsf0iIwBkAJxmLbhUSTacSW4NHn8RJg==
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr15937675pjs.231.1621066561816;
        Sat, 15 May 2021 01:16:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y69sm4574582pfb.162.2021.05.15.01.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 01:16:01 -0700 (PDT)
Message-ID: <609f8341.1c69fb81.e41e0.f0aa@mx.google.com>
Date:   Sat, 15 May 2021 01:16:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-94-g0960a1ee7f69
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 127 runs,
 1 regressions (v5.4.119-94-g0960a1ee7f69)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 127 runs, 1 regressions (v5.4.119-94-g0960a1e=
e7f69)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.119-94-g0960a1ee7f69/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.119-94-g0960a1ee7f69
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0960a1ee7f690e29134ec4cb009eb553100cfef0 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/609f5191f4892f054db3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-9=
4-g0960a1ee7f69/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-nano=
pi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.119-9=
4-g0960a1ee7f69/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-nano=
pi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f5191f4892f054db3a=
fb5
        new failure (last pass: v5.4.119-5-gc8cf396f9722) =

 =20
