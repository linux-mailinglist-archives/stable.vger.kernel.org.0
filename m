Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B1E353471
	for <lists+stable@lfdr.de>; Sat,  3 Apr 2021 17:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhDCPEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Apr 2021 11:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhDCPEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Apr 2021 11:04:30 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04307C0613E6
        for <stable@vger.kernel.org>; Sat,  3 Apr 2021 08:04:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso5850861pji.3
        for <stable@vger.kernel.org>; Sat, 03 Apr 2021 08:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P1DGYH02SZ8VVFWov/d0YTf4wBc9EKHRkiWoiukf/Jc=;
        b=ywVKfd4NAx6I6Ysqea3d04FPiszqvBsebdgocH2aPwCCZJAidBKMdpduOmZRKx2VUt
         NqZ+spW2G4jZQ0OQYI6Ycu2TiAWwocEgfPCVpnJWsuKEqmqp6e323EgWnskrUMIOwnes
         Jq1jBOzuB5nvoVJ9zgwhIHx05YiFQQgNKjdTPz2v5DDRTT85slE89PVBHDTuR4dtlohP
         K4cy2gVO7pBmtK+eHFrw2V2IlSktvE+q0WSSE8ECu3R9xlsQO32mJamVUoTo+yFTLDIt
         lofGA5vubvMBi1IHpyewOuPsbdfALtuT2ULuQt3b03C77edzCCVqhPzWB03NfRWnZwm2
         Kmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P1DGYH02SZ8VVFWov/d0YTf4wBc9EKHRkiWoiukf/Jc=;
        b=U+Hfu91Yul7Uaa/ORsDwETrvxLbnuVYdNoMdvuLXtVuRhyTktaGu3t0pwlhW/quMgu
         22FDUDDvg+zmXYtJci8C5K/HWQskQ2ApxD74duItzLDxQIO9fEVSbjz0joRIkfPCRZVH
         PouDQAJw5MdbV9CLGzxS74hHTSP3b4Up2zG8mJBbp4IenZHMTndyFkSJq30KyAksAfqJ
         C9LhrbFdxoDnKZIypHZEFKSvfp20OQYSn7T7ICCCpFCsrR7o+njNk8evb3dB7udndBLA
         MPY9GEfW92miAun16npcUUuGlQ2D1tLdr2hYTWsh9GGzjw7EFklb92KLH8N/etJ7gjiI
         SKAA==
X-Gm-Message-State: AOAM5314yw49QnpbYL6S35h09hcQBu5d/IQnx/8JT6eAk5H7mEiK9pcY
        QYuydxQ2Sh0KOYCXG1qs7qWC3Q4ZjUZPRIec
X-Google-Smtp-Source: ABdhPJwYVw111ZpHDB1j9JpAdrxyZsdzDGs+GBGI3arIDZn0VTv5YecetsSuAS2zG6DswVQyWbKJ/A==
X-Received: by 2002:a17:90a:bd90:: with SMTP id z16mr19214576pjr.123.1617462267397;
        Sat, 03 Apr 2021 08:04:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e65sm11922994pfe.9.2021.04.03.08.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 08:04:27 -0700 (PDT)
Message-ID: <606883fb.1c69fb81.855db.dbdc@mx.google.com>
Date:   Sat, 03 Apr 2021 08:04:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.109-56-gabc4ad86e5da
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 164 runs,
 1 regressions (v5.4.109-56-gabc4ad86e5da)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 164 runs, 1 regressions (v5.4.109-56-gabc4ad8=
6e5da)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.109-56-gabc4ad86e5da/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.109-56-gabc4ad86e5da
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abc4ad86e5dab0057a8609059643c9aa1e2759dc =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60684b0b1ce93ce06ddac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.109-5=
6-gabc4ad86e5da/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.109-5=
6-gabc4ad86e5da/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60684b0b1ce93ce06ddac=
6c3
        new failure (last pass: v5.4.109-39-gf6a310964649) =

 =20
