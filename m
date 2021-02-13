Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD931AE07
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 21:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhBMUrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 15:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBMUrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Feb 2021 15:47:04 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1652AC061574
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 12:46:24 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gb24so1510322pjb.4
        for <stable@vger.kernel.org>; Sat, 13 Feb 2021 12:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5KDzohr0geUPG3FCZB7joUqno9N58oGHTrC37Nf3UXA=;
        b=pPbRRfCs3bhaA869BBR2LBASw3whpAN+9QUO5xwjO3cqfrSPOtdnQKM1cS51xFOAlP
         hAbZR+bk78Un/+Whn9M10tzLUqSMTVdM0VKDEp3MOh5D/NKjMSGBHcxzSwiDL/1WpK/p
         gpZ8CO+27x35GJt5FqpedmnjM1l2X1EyBUmhX1qYVs5so9o/qDSyaSDnSHT8BQIuL/Iu
         xYa7Oa7Vxi1+Vn2QolLn4z9OR4+7bVQhoqLhrKOue6MIxB23ZqS+XXI3UOUFkUgUf49i
         n7nWYuj6iTXn1sC8V+pMWaKw0FzNUodIm5Gbztvgp9/4SrTmT8hi3sznSNqvVSAM1GBO
         vezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5KDzohr0geUPG3FCZB7joUqno9N58oGHTrC37Nf3UXA=;
        b=J8BA0IWGFCh5DXw1SeWbUdFAeZNv7FM6hbPwLDbzKxJRQe+F/LkpUIVHHZpcXKTysW
         IHHNofK2DC6ixjKwOBg4gvb/IWlZ2vUQGOz6boN4SXMs5heQf/X7p7O1htkgiTEn8a2j
         v3IwlGiHO/cfnS7QzA1ZmdqNjr5qrTkCJkedk5DYtnDwy9a4rPtjrFWii95tPEpKCgF9
         10ILbPdoHa+2+1jvgW2y9S94vQnrYXG+a09pxPWmOmiwoZ2QMQI0oRTT5IKmBBCEpBRD
         lVfYSsKYPRfn/sXjd0sqQYzBX/4fovGVPDM8ZBIwirfYgSfN7UGEl4fYcCG3+0qsi6v3
         sf4w==
X-Gm-Message-State: AOAM531H6FaQcP0Kgnm2BRwIfIaGFsxIxnvS5gu6yDiEKYoigtiG/zdX
        eSVaKqQR+ZjtjTDZ8gFxpkXS90OkV9bGeQ==
X-Google-Smtp-Source: ABdhPJwhJw2Urur5xWAnTV/uZWLfWb1mzBLVCfnkwW6Pwuq2GWNC9I0JXBbWnUSD7Lo05MA/f54mFQ==
X-Received: by 2002:a17:902:a3cb:b029:e3:23b7:ef2f with SMTP id q11-20020a170902a3cbb02900e323b7ef2fmr7205177plb.44.1613249181295;
        Sat, 13 Feb 2021 12:46:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d133sm12454242pfd.6.2021.02.13.12.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:46:20 -0800 (PST)
Message-ID: <60283a9c.1c69fb81.96cd1.af6f@mx.google.com>
Date:   Sat, 13 Feb 2021 12:46:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-16-g68b7ef36719c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 53 runs,
 2 regressions (v4.14.221-16-g68b7ef36719c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 53 runs, 2 regressions (v4.14.221-16-g68b7ef=
36719c)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-16-g68b7ef36719c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-16-g68b7ef36719c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      68b7ef36719cc6d328f3fb7c18e434373f5bd2b7 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60281bd8a8eaef4ed63abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g68b7ef36719c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g68b7ef36719c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60281bd8a8eaef4ed63ab=
e63
        failing since 67 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6028091577280224893abea3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g68b7ef36719c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-16-g68b7ef36719c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602809157728022=
4893abeaa
        failing since 6 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-13 17:14:57.927000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
