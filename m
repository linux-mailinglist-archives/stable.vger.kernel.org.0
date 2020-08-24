Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA9D24FECA
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgHXN1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 09:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXN05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 09:26:57 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7522EC061573
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 06:26:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t9so651402pfq.8
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 06:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WIaKScIPwt/ztZ5XnRbiJ/j4zFN+JmJMEyOhSGNkilM=;
        b=xRqzy31rXiiX5IIfzsS4zRZ4mXswZDHndJ+qTZ6Ayi1eHPxUxb4+xFdgjHYaIae2qY
         z+7MNRh+E+8lxHg1xBx2E/I7u3gATp9e4sFtqnJsJcuqT/Ds7J3wVNh8UhVLlAeSzf9j
         EsTj7Wigk+F9c+V5l3iZdUOiA8bZov+aw3AwyG6mWBEJ+142yZSvGeMmcIl+jXrPmep2
         1bwqgiP+gnztfq6Pdz1MPoMzoB7vtpxMBqQZwF9M2r/Zev83N2ZeF381+7o3sJrcGLfc
         w1jLEqqgU4v/vY08UJZUqPVoUJVt3qEc6GONCuHliFQBlTnqU9XpMZGLIIY202roXOr+
         Kgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WIaKScIPwt/ztZ5XnRbiJ/j4zFN+JmJMEyOhSGNkilM=;
        b=S7o0zzoN/rqtFx4h/7tsdGJnFVMPwP9c9aKV7nWa2wtqzy/ehcGtuGvdEBINJQWV1t
         me4uYVzodRcjnV5KqVbUdXkaSd4zdfwUVu6wR0xeWj+vFN7ZYbkjbiWDAz0rHpsAMdXg
         UGcmDLqA8mCLk2vy2R+psZoqt1iP8JzsBg/yraHYqCoiF2lUTlwztl0dd3DPYpDKldsV
         EZTZEJejDLWBqqaXdbAmpwAxOIZfS57N8f0+wlLteYqrK/+DDmwyvj8FScCW1kn6f8rh
         QyKQAmpZ+pE3u24qjmXmdF7uHbeddQ/iZl5DwTQvwQUvSGtD13kRnr5fwNunwlSoKyCM
         NdLw==
X-Gm-Message-State: AOAM532IF+jVUEg6CJZvAF6v6gLbVel59v+omh4ZhWESGaEblPfr6/iB
        zu+49g5ParXRElCGFya70vJRpx2pSFaBnQ==
X-Google-Smtp-Source: ABdhPJwpA+twExzKibgvcHf5FpidwsS39BByEOotbnrf4uxItyCYGpQ0RbylOvJD30776ky9iQbbEA==
X-Received: by 2002:a63:6fc6:: with SMTP id k189mr3284282pgc.165.1598275615422;
        Mon, 24 Aug 2020 06:26:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 77sm11597069pfx.85.2020.08.24.06.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 06:26:54 -0700 (PDT)
Message-ID: <5f43c01e.1c69fb81.1f292.279b@mx.google.com>
Date:   Mon, 24 Aug 2020 06:26:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.17-125-g3e9e863143a3
Subject: stable-rc/linux-5.7.y baseline: 154 runs,
 1 regressions (v5.7.17-125-g3e9e863143a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 154 runs, 1 regressions (v5.7.17-125-g3e9e8=
63143a3)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.17-125-g3e9e863143a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.17-125-g3e9e863143a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e9e863143a3b93dd367ef11e53cd74235083d2d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f439dd3d1078ecee79fb435

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
125-g3e9e863143a3/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17-=
125-g3e9e863143a3/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f439dd3d1078ecee79fb=
436
      failing since 4 days (last pass: v5.7.16-99-gc5aad81e7f2d, first fail=
: v5.7.16-205-g7366707e7e99)  =20
