Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AE3289E0A
	for <lists+stable@lfdr.de>; Sat, 10 Oct 2020 05:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgJJDmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 23:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730803AbgJJDeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 23:34:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C0AC0613D0
        for <stable@vger.kernel.org>; Fri,  9 Oct 2020 20:26:15 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y14so8800145pgf.12
        for <stable@vger.kernel.org>; Fri, 09 Oct 2020 20:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ttHi4UBnJ/AoDdLHcm/Kqu06KPMRq8p9J7rBKPElyMg=;
        b=CILWUtBKNbWxoq+fQPV1Hlw3KuHiyPfMSyD+gMfsDz/IJ9EAM5r9+BpRTY9VtEVN5e
         MMaO0SW0nWp5snS9pP1lDkIhMs+P3wGYlZRovrcoSKhJVE2ZViflsGF98spnxO+lEeCF
         OAQzobuZZWgCa1XiBzBy2P5KM9v3CxJkxlqOdecFK2t6brdoYLZpyzMevrLSzQgg2tzW
         wUeUsyxnY+VEBwa0KK73wq3gmqoCaxMSUE8epbI+vHGS/0hxi/BRzKplEMzkAPuOKGHV
         nlNK7bT3+vW0n+TmxGl7GHCGWpoF9dICev9BxUFkmiR1IuvOXTbIFEEUCRypCOG36xr1
         U9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ttHi4UBnJ/AoDdLHcm/Kqu06KPMRq8p9J7rBKPElyMg=;
        b=bMEekj8FhR0ifSeB9d5bVIq35PRkrlnrd0rs17ja2Y/R48VLqfUL1FRd0VFqsckRzN
         69WVODSuzaXVUDfi0uOXDfojx+aUt+k3d1Daw8TNhrZO5dFmDea0XKcdLKsg9PCvJzER
         dOmWtBkVbItDBr3iQBqSTyRl0nCQCRI+xfpkzx8f8IJy8NGGwgZcMbjKk/Z7edAEU8bY
         yWnbh0KQpnP/j7uO4jckFrXMnHg2s+NkhwiZB5hvXNjOabUqCwHYz7+DcNYzeILrSFIK
         RaCPVPtsw597vrPLF/N2aMLLoD/K/2dwERu0zGwJCZSkZn5ZzHCxTobD3S9rhf6F8I7h
         4Tgg==
X-Gm-Message-State: AOAM5312TK1eVEGs8EdIXALrKl7AI7FKVIPYk0JefVxhbk19610m/oSm
        WCZ+lOP5eyjRfOiQUtvWEQUa7RIKt8cLPw==
X-Google-Smtp-Source: ABdhPJxRcX8nL4xS5rq9PhCGwt5VlxTvw4bp9i0s8cw6BIPjMI7U7una3k/+PHd7nqmy1Xu0dc6KrQ==
X-Received: by 2002:a17:90a:7d09:: with SMTP id g9mr7579425pjl.63.1602300373506;
        Fri, 09 Oct 2020 20:26:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q24sm14259268pfn.72.2020.10.09.20.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 20:26:12 -0700 (PDT)
Message-ID: <5f8129d4.1c69fb81.aa8d4.b683@mx.google.com>
Date:   Fri, 09 Oct 2020 20:26:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-44-g1bef439a8958
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 100 runs,
 1 regressions (v4.14.200-44-g1bef439a8958)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 100 runs, 1 regressions (v4.14.200-44-g1bef4=
39a8958)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-44-g1bef439a8958/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-44-g1bef439a8958
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bef439a89585a99cb892ecfd61b00316d79d183 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f80eafea0503fd5fc4ff3f6

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-44-g1bef439a8958/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-44-g1bef439a8958/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f80eafea0503fd=
5fc4ff3fd
      new failure (last pass: v4.14.200-39-g650bb80f17b6)
      2 lines  =20
