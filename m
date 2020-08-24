Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0247F24FE2F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHXM4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 08:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgHXM4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 08:56:17 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545E3C061573
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 05:56:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t185so1665836pfd.13
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 05:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r7s4NvOj+EYl2mvX1pF+3Qz8548FYEuNK6d5pO/Q0qQ=;
        b=VazY4gOBBQGqfzoANs1iUOLrWjwFd+NJrfgtdscqj1QM6e79XxbjHFIPW698D83aVd
         TxP4PphxwVz8/e0h4r5aRsVXruumc9MYdvKSpMwVqtEqs3/7kMIlpH53+cO88BufupdV
         /5AJ6OvroFOFxP7URX2B0OUm6CplDrrI6NfmZRfe3TRku2H4ri3LvQUeKObUq0kN8UyF
         3A6W1M6A2qIE3YtPXdTW4WEAdGUGYWO6Xl72Bw5FMYrT98KCasDEfprHXKtnKNn90bhK
         KUCnKacavW2rb6rvVkpn7X9qdHiF3kqijKtx5LDsUKTrbQiyKDWcEv1e+LOh9Kow8Raj
         fIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r7s4NvOj+EYl2mvX1pF+3Qz8548FYEuNK6d5pO/Q0qQ=;
        b=t1Mn1BQhvJHXZ2nHzWCk90X8wG6OQ7gsc9isbOmpfP5S4qredwb2hVfhrbwRTB1blU
         a6WGihRc1XPWNfxnQMHV32zpngXn+kLPjoteqDRqrGZsiCa9DxXs3YO5azhKL9yWA1Q5
         K+GRTKEKoBdz7ZJYh/JG5VjFvz0+79agomw8OyZpEPVCfECTSrnujnL1VHo9hg1eIf0U
         AB/4twLFf9BYQDmFgqNYsmwH9l72inYbpsXIRP7Wx3onVpdWBxRoxmrr8O2rvlxeRBtY
         hB92HITiudwNu88HmYc3sUf/AO8KXwuyhJ3mzaXrwoanYAmBrxO39HGHz6IEDlmfrra3
         CctA==
X-Gm-Message-State: AOAM533sn6B/PLP0267S9CuA1Zery56QVPuck1hEJCRIkFQ77FICcFv7
        +W2jyiRp5uIk1pP5DommvfVvRcpxQzcTTg==
X-Google-Smtp-Source: ABdhPJx7A08g8KZjzIQP7jOpPx2Z4hsxliBNy/z+MjUiNptL1ZbPJTEn9AdfzGrHPrJ+L6leIh/khA==
X-Received: by 2002:a63:1417:: with SMTP id u23mr3412270pgl.289.1598273774639;
        Mon, 24 Aug 2020 05:56:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10sm6085289pjg.0.2020.08.24.05.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 05:56:14 -0700 (PDT)
Message-ID: <5f43b8ee.1c69fb81.b7d82.1776@mx.google.com>
Date:   Mon, 24 Aug 2020 05:56:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.194-51-g509a87150f17
Subject: stable-rc/linux-4.14.y baseline: 124 runs,
 1 regressions (v4.14.194-51-g509a87150f17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 124 runs, 1 regressions (v4.14.194-51-g509=
a87150f17)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.194-51-g509a87150f17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.194-51-g509a87150f17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      509a87150f17c995ca2ed53faba78b0fa5b60e65 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4380a08f912af2dc9fb44b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-51-g509a87150f17/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
94-51-g509a87150f17/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4380a08f912af2dc9fb=
44c
      failing since 145 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
