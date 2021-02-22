Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA43321F77
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhBVS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhBVSyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:54:50 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D896C06178B
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:54:09 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p5so3436754plo.4
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZqjWTaBnXveSFf+V0mUv7KVeMUsrxyX/IEl74AL4lXc=;
        b=NbJJsAHDQQM0aLcdFTP5G4sFZInqFJ6AO7eoVrdjmofjjJsMeVt+8Z+aQW9Gg8gzv8
         zAPr6f+Az6a01jcW6S6M5xEpC5Te6Okqjsta+BKEIlfnxgi2IP0e1UHkaEpvTRrBE8/3
         XOUDh4HZKWD7NNaXJ64M5PiW2lHgp7Lsmwzp2NCuiG+NCFNIZ6gpxIjcAM1sAuc+e1Mw
         wwP+OU/TX1z6D7/iB4SkT36swVU85JpRhGHggzzxax7EIBcy6PSwNdJvcFfwveh2QFL2
         83AEdI+Nomdlek1KX+EQunVkrl125HG1UfYadm0uuPzL6PpjRlvP7Sv9uYVdlIPNOaSD
         9rQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZqjWTaBnXveSFf+V0mUv7KVeMUsrxyX/IEl74AL4lXc=;
        b=fOpNcr2h0VGpPd5IXRrgUtK2C8l+Qw83iiVmjQIDHGkGU+gRRc/66q64VcWDwTXIo9
         OBafbtPqt6fTvaFOodb/ixd5ClWfI5YD7PP6m9alg65Epf9wkSZOgFKFrat+S73fmzaq
         2LhLOhnDjaCWAtMLuxbRoLyRPQCfKlSWNDphRpuvY/vCIdQMmnfmr/RIxwKw68pdnfkL
         epz3WBpnHby9xsOoqX62H9Q4BTPyVBmPsM1g6GpQHYDBjsyk2yYKfUHC/TphYqxHocmi
         jZCmsMDb5lIVJeATR/ai53nvQOzBLOezYHch25aZzLlO9r/tdhzGNTrAWVtk+XDId/ui
         9Y7g==
X-Gm-Message-State: AOAM5325mOu3HoKBQGxpTz0A9CHUN4j55dLg2TzOTx9yDUNBDRtjonii
        lMVFW7+iVB7QAWMYxr+ryjls4T512TihAw==
X-Google-Smtp-Source: ABdhPJxFQaKffzUwbNjq5zHq13RWal4mBl3JoktVK9pQg/OkcmF4rI+hM0YosZ2himXzZtT0v3WMEQ==
X-Received: by 2002:a17:902:ee84:b029:e3:afe5:dd1b with SMTP id a4-20020a170902ee84b02900e3afe5dd1bmr20627166pld.35.1614020048602;
        Mon, 22 Feb 2021 10:54:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j73sm20752165pfd.170.2021.02.22.10.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 10:54:08 -0800 (PST)
Message-ID: <6033fdd0.1c69fb81.21c2e.c1f7@mx.google.com>
Date:   Mon, 22 Feb 2021 10:54:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-57-g02c8546b3397
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 69 runs,
 1 regressions (v4.14.221-57-g02c8546b3397)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 69 runs, 1 regressions (v4.14.221-57-g02c854=
6b3397)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-57-g02c8546b3397/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-57-g02c8546b3397
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      02c8546b3397375915cc9695b9fd10b1f0891c6a =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033cda14744af3d91addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-g02c8546b3397/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-g02c8546b3397/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033cda14744af3d91add=
cbf
        failing since 76 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
