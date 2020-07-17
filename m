Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E256224334
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 20:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgGQSft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 14:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgGQSfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 14:35:47 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BC1C0619D2
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 11:35:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u185so5824086pfu.1
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 11:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/Lu8jz+d2E10uB0Wr9Kf89tGTyB5/0og5uw1ixPd2tM=;
        b=nvkfh4l+8Zim2KhUar5dMxBd0PuXvv8owPu7KYKzmrBEBN4+OjFSf/XHzkV8TT+Vwd
         X1ePo6klwh6fT3NCo0KU4Z/7a2mKtGRzGzUkduUxv0fXg0sk+Ujdco1tesg4HIM+8Vq1
         8Ty6k/P46orgpp9CMFBZbOTqO5URk7evmD/xz08Q4bYWFEM0kn0rTp+Pqy3AB1KKdBPC
         RBVvEEI6gc28FDxpeVztmPQd+FPiGuo9AUMgLQZ5jARSLzD52UheuROrGhmnnUrCPSu1
         ViiOnCRU0Yj+T2bDpAYO7WWT8pDcui5Jwt75vs1w4VxXg9jv6hWLpozF4FGKfLUep78y
         UlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/Lu8jz+d2E10uB0Wr9Kf89tGTyB5/0og5uw1ixPd2tM=;
        b=mp650MGteFXcNPZB20rd/czdmVIY0bC03gU0VWdHuK8Xt7fGrFzOrq5VAh9OMSE9iC
         DCt1eMKtPmkgqsKxxlNteeCIBIStrqZj335WQKqxptDLPa1oUAG2X/qUYUjYB3G4vokO
         i0GFBW99wNEoX3QMM6aWWk+GQk8wuZPiVhtu+72b+uFwczCxe0X9r8QIPO+8tMlMFi9v
         1K7W9JLOGHux82uhPHKM++DPRn7W3/z/gz9Hxb7uZnr+vJYigXzavrJjrg9t61kIc1GP
         X54iIrOMZQvVzGFrKaOHmSspRdc/5X8jHg4r7pGJHJaMH1O8LHH46ZE7PrNIqChDRTFo
         ryFA==
X-Gm-Message-State: AOAM530DwlMpcHsRmXL2BOpjQiD9Q2GF0M9Vfig//i6D3feLrvde2Tps
        TF2uUjpT4SkIzL8NFyF+Nrazyvqs2do=
X-Google-Smtp-Source: ABdhPJxlX+c+DAUg06Rk2x+US1dXDmTaVLCmA1oF5As/brd40vkH536/6CjhNSP1PCIIkRMTHDi7LA==
X-Received: by 2002:a63:4c08:: with SMTP id z8mr9459789pga.201.1595010946226;
        Fri, 17 Jul 2020 11:35:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5sm8516631pfc.130.2020.07.17.11.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 11:35:45 -0700 (PDT)
Message-ID: <5f11ef81.1c69fb81.a8cdf.b39d@mx.google.com>
Date:   Fri, 17 Jul 2020 11:35:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.188-55-g403ad3c8edab
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 80 runs,
 2 regressions (v4.14.188-55-g403ad3c8edab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 80 runs, 2 regressions (v4.14.188-55-g403a=
d3c8edab)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | results
---------------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.188-55-g403ad3c8edab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.188-55-g403ad3c8edab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      403ad3c8edabb297b89be39c770f7a1ce91c296a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | results
---------------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f11b7f04dd79be23d85bb2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-55-g403ad3c8edab/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-55-g403ad3c8edab/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f11b7f04dd79be23d85b=
b30
      failing since 108 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =



platform             | arch  | lab          | compiler | defconfig | results
---------------------+-------+--------------+----------+-----------+--------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f11b78c33e771943885bb41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-55-g403ad3c8edab/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88-55-g403ad3c8edab/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f11b78c33e771943885b=
b42
      new failure (last pass: v4.14.188) =20
