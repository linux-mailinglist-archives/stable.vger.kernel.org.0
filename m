Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29633195FE
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 23:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBKWqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 17:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBKWqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 17:46:08 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50D2C061756
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 14:45:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fa16so4301392pjb.1
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 14:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EvPG2asY0OmM6ijjFHTtX3lw/ByKLIOWJ9R/BB9Af8c=;
        b=yNmv+IdD9tIlSWhbGAiePn8iqTGFumRPCBUQnilCZrN9sSKAbxFuvmA4ik4WHhQxt7
         psw84m1FNjyKpdkXv6Y5HJpdKYXJ3gKgZaPsxryxnWtLjS9QPh6xFiAEskoP7y3ewzLO
         JAaB/I1gOv5S4F7//ltxCYz5L0DSIKsdQgb23sZWMFB+tZDCUqQ0d0wVsT/gpOddVwnb
         5NVxMqdc++zWb5NxQEr2F8aWeP/jnSb4G0AtoqMWZLgNj0YO3xHrHZheOb5SxFFDeOAY
         FhYtD1ZPFqMAdFu4UcPQ/sUOJD7yVHvD6z7MPJ9WaXV0l9PgHISvWPYjqREHuDcJPqS+
         Liyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EvPG2asY0OmM6ijjFHTtX3lw/ByKLIOWJ9R/BB9Af8c=;
        b=RtGYIUp8Cx8OeaP1ebdMSDE+L92h/2oilpM1Ln13kTasxXw+WozVRsuNTCihsd+a+4
         HdfYNbAtWAYGbSOIR8Nfe4FuQFXDjRXFGlnt7U3/rWytfcmLeMpCeKl42uzckmZ4Qc+l
         8pKCru0GrnE+/Wh5B6BJeAqhbZE6VWReOlYQZmb3nRCYnFpOM9l9nf7DqZ2VlRR1g4ke
         JJZTs5sTKizNseqkKbouokR8xL0yHgYlg3aoH11UTbV99OfYste9jpacnBGS/PpUcjJX
         M29vrQe/RilwLi+NHUZLJnhZfuS9F/dUElUNSsxmnX5jh7JeswjLRPZHH9fZ+rTWaG/y
         So7Q==
X-Gm-Message-State: AOAM5310d6RDKQnY//fYsi7a0x3iDZszTF2MsJCLFMIsKcQD/uq2WnM0
        DUCfvioSbhcCVHKcaeGOqpT2NuqxMcWkpA==
X-Google-Smtp-Source: ABdhPJx6krvUu5WbzCgXuop0DNILudy5f2Fb4OE5yImod76k4PPKPWMgqIH7L6Hy+75E7hXTeA4bsA==
X-Received: by 2002:a17:90a:fe11:: with SMTP id ck17mr5852702pjb.152.1613083527845;
        Thu, 11 Feb 2021 14:45:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t21sm6562160pfe.174.2021.02.11.14.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 14:45:27 -0800 (PST)
Message-ID: <6025b387.1c69fb81.d4789.f35b@mx.google.com>
Date:   Thu, 11 Feb 2021 14:45:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.15-54-gfaaa62b470c92
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 106 runs,
 2 regressions (v5.10.15-54-gfaaa62b470c92)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 106 runs, 2 regressions (v5.10.15-54-gfaaa62=
b470c92)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =

meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.15-54-gfaaa62b470c92/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.15-54-gfaaa62b470c92
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      faaa62b470c92fb9b1525790565817f59937a98a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60257f3289e082636f3abe82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.15-=
54-gfaaa62b470c92/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.15-=
54-gfaaa62b470c92/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60257f3289e082636f3ab=
e83
        new failure (last pass: v5.10.15-43-g907ad2685b8f) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60257f86b3fbb02b923abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.15-=
54-gfaaa62b470c92/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-na=
nopi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.15-=
54-gfaaa62b470c92/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-na=
nopi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60257f86b3fbb02b923ab=
e6c
        new failure (last pass: v5.10.15-43-g907ad2685b8f) =

 =20
