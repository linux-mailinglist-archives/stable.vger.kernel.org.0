Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2BD400691
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350505AbhICU0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 16:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350464AbhICU0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 16:26:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CE8C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 13:25:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d5so332715pjx.2
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 13:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XIjz/uumtvzqO3lvZEVGG9pejJidWmITpZbamH4DKIU=;
        b=qsqNJYTIF1VzpOd15L8o7mbWHlmohU65LafoNo2zXdgrfitcgOgruh60KyTVQ0cjBR
         zEbDxt9qbMTC07I8uVbJgw9OJJI5RdZUIusvHCLr/i9DBrVQqPFIy+ENpDmDS/CNs9Oo
         WqVacOz9WG+BUvXt5tKQcFgUbNDgVtrRbWbnxA56jBLX7yy29E6gX7iZ8XMSLNo5rnQw
         3+j8rrVbXth1V70/XaliNO/KyTAolK552S9hpVCeFgLO3qHbkELTOGs5Zw5Ni9oIbA6b
         rke5LUVpAunDeauTDMAcnHjxY14kUX9AqdULV7Fy1reGzROVjTAaHb27K1DAkHd18I5I
         DF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XIjz/uumtvzqO3lvZEVGG9pejJidWmITpZbamH4DKIU=;
        b=s8hfmlCAEFPm7wAZKQhthu10Nnm4le5oak4SdpHgc2M4hCXuDTFWxWvHV1EUwpIKuG
         3F1gjf2UT0rbRwlS11nYkupetimWRuHNEOVnLtxqEf6kuUx0GLIO4xN8wFAeP4e0FOHq
         KN0Pe3cTQcPvA3HQe/LCgBvzSRwKddQVES76tHrYKBtRjMAeTWxbxH2NYgYfI2ckZ9qJ
         0KN3Zj0Dwr4ElO0BsvBdRCCm+R/8Kd6vDOVr/5ba3HrZKI8XX3IwfOSlTUf4ap60px0G
         u6Ewp+knu3l2vMav16HhLrAIFsjYkke2LrjESDFXUfkbgYsaEnRF81IgPDYXerl6UJxr
         aH0A==
X-Gm-Message-State: AOAM53016Lka8Pu+ZIRMPl7A8PRQqYbf8nBRkxnnT6dwDQ6qK8mVhWMi
        4/DArer4y7z19PEBy8xJfWJ0SfnjeQckyG6j
X-Google-Smtp-Source: ABdhPJxhx4HdreHnjlIU2nDQcYKFN6nzUlEKi8meljYXie6g7jFjPVNQcozF3STxyqL7KjDkIx8FDA==
X-Received: by 2002:a17:902:da81:b0:138:77fc:5583 with SMTP id j1-20020a170902da8100b0013877fc5583mr560065plx.47.1630700717811;
        Fri, 03 Sep 2021 13:25:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm232330pgn.36.2021.09.03.13.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 13:25:17 -0700 (PDT)
Message-ID: <613284ad.1c69fb81.50f5c.12dc@mx.google.com>
Date:   Fri, 03 Sep 2021 13:25:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-2-g1b53bca7aeb0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 176 runs,
 1 regressions (v5.13.14-2-g1b53bca7aeb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 176 runs, 1 regressions (v5.13.14-2-g1b53bca=
7aeb0)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.14-2-g1b53bca7aeb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.14-2-g1b53bca7aeb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b53bca7aeb04d9fa7cc57a9fe31ac8f9aefd64e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613250fa637db292bcd59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g1b53bca7aeb0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g1b53bca7aeb0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613250fa637db292bcd59=
666
        failing since 37 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
