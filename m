Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC63FDD62
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244263AbhIANoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 09:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244221AbhIANoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 09:44:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9E9C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 06:43:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so4699145pjr.1
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 06:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NXnbxXiLJMLxk9Mez5HxUe5QnSUiSp/IK4wsBDzotTg=;
        b=iVNPn1CD4Mzw0yNah/eEoqTOMUhsFY2r8nWIBaEKXW4T813RD6TWtS9/erxHRUfrwf
         6PVHoNDgccFYsj+zi9w7R6U7futC8xrbXHILnIJWrcLOFHNEKh3igm3hFB1A66YZJ5Pr
         PtFlfKqMqyi1LWCvhdWmATULN6guy7xAD0nlLZ2clzIzyPsbZ34lNHhSVz5N7xeiPiZY
         /toXbPZYVq7Oky4E8N/mghOI+H4yPQLTLtvUb3IvaGbB2RgToi2+GcYbOIUVaO1RRwGP
         ulu8XipEv4JducTlgmpr1sJe+B58ACyq9IOQxQbjCSGpqUL/zoUtLS7BFSppjeabHBst
         QEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NXnbxXiLJMLxk9Mez5HxUe5QnSUiSp/IK4wsBDzotTg=;
        b=AT79HjS7FvS3bGZjxGC2VkDX2vOL1FPTjYi7bNXKKRn7PijxDXSxpOF4vN/NrvGuPv
         esdK+aRWKlnyg+ztWG/6c4NUGnDCDUVNhJFYAJGhYB//i6UH7WpRYC6KDt3SHeqjdDE2
         Z0vQVzC+sm9wmIA5CKrr7YoiCOnKS6fWiiM7lWQGSbOvyjpaLg8Ty0XbhAMbK5oinW28
         HN4VIXjmARrWsgb3KJwuCYp3WhPQwQAtA0MBhfi8bIKJHvVh5bdm1yq1059vC+xy0GoF
         Yyj5AoaLFcjTR+UbNLNzUtoePLontvoC0mqbXZYw/Ba6W8+A1+IBGuUUSmjZiO4VFCtF
         G30w==
X-Gm-Message-State: AOAM530+rDibur/A4RtRQ+mez/W7jc5aOwWqcJdeLUSPXHhWUWzS4M6a
        myMk3fsRBNT+RamohohAuSAF3STT9NA0RBDb
X-Google-Smtp-Source: ABdhPJydrOl1DldKToAMU6YFpBZv0NWJonL/DjgK9F8k2IcHFwRE1d00sc7iotS2OXrtgX9CgZE5bw==
X-Received: by 2002:a17:903:11c5:b0:138:ce68:68b6 with SMTP id q5-20020a17090311c500b00138ce6868b6mr9615777plh.35.1630503802741;
        Wed, 01 Sep 2021 06:43:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b12sm82333pff.63.2021.09.01.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 06:43:22 -0700 (PDT)
Message-ID: <612f837a.1c69fb81.118d4.035a@mx.google.com>
Date:   Wed, 01 Sep 2021 06:43:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.245-20-g225c85b6b578
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 121 runs,
 2 regressions (v4.14.245-20-g225c85b6b578)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 2 regressions (v4.14.245-20-g225c8=
5b6b578)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.245-20-g225c85b6b578/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.245-20-g225c85b6b578
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      225c85b6b5787adfa9716f639b1bf5d44e8d7db3 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612f534c5ecd582abd8e2c97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-20-g225c85b6b578/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-20-g225c85b6b578/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f534c5ecd582abd8e2=
c98
        failing since 2 days (last pass: v4.14.245-6-g90f882f2bebc, first f=
ail: v4.14.245-12-gf3c09773d6fe) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612f61c225dc82e0048e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-20-g225c85b6b578/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-20-g225c85b6b578/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f61c225dc82e0048e2=
c78
        failing since 184 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
