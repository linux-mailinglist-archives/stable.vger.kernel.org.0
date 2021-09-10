Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62BF406F92
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 18:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhIJQXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 12:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhIJQXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 12:23:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED3C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 09:22:01 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d18so1460877pll.11
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 09:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MHxhtvqsDuKAYqEgYjfRVkbh4sy+GQlSTQ0KhfPN/Tw=;
        b=TlKOmRv0HwjtCbfZ1zkfvGcK+23CUuZwvH224NsFLiY/IwngsX/531DLYD51nAPGPz
         ujK4gC+VD0i2/42ydBasnp5QARruGmitlr/DbuKgFqXFgu90v4RGQyh/5SNAP4JKjY9y
         nGFuvJZpxm3FQOISu4DfkCFx9VN1Rk5OqXDZ3CgqsbV+S/8PM91pDt0/b/LVaTNbJfTA
         BsHjOBKfY29wo/hJK2kATLbrZqKer2pV0r7j29WUcbH3pR9jrAleQdXTVPaUdsbDc2Ek
         lXO6HA9OzxB8WGKJiwEa0kifLrVloKcuccvdSnE2e2FzqkqIrHXud47oFYL0BBgl9/UB
         D66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MHxhtvqsDuKAYqEgYjfRVkbh4sy+GQlSTQ0KhfPN/Tw=;
        b=HxiLqmTC1BzXWeCq1ZpxQyUwxW8ALgx8uh76sazvIfvw+QuB6goZxDyjX6nSy6u5bn
         3Ogm89VCZhyAqKgSBViEIJMlgIsUkD/c5PgDyEXfE1kgvuKg6SGaVWZGwLS16iKe0KLf
         m4xqxZQRq3ziDfqfgzLuE3Bl2GJ0T/icJCinHxqqg2Y3LCnqeQYfLuBShQX1CAyNBlol
         Vl8Rd0mRQM2i/ozKYhwtJ26Te7IGmwi4jmBnUqXI7tUDTnTvGos106kG5ONP2GxE2NFG
         wnsRVEJUqaoUnPpHMYHcWlRsr/g+FQLolk00ewoC+39WAhXpmMqt0JPSEn50g0TuRbQg
         ep9A==
X-Gm-Message-State: AOAM530tb4HeT9CWJePo6i5EMCMpFUbQ6F/bERLHwQBObsTG3EIe8JN0
        ne2i9yXuZeSqZHwHFVY239tIzN6CSrYuLQsz
X-Google-Smtp-Source: ABdhPJw22PVsNG4/TVRqg1fv1BEZxe7sxOm16ev/LYZSL86mx8OZbrXcWLk+4Jo1ejTrCJ4qlDMPsg==
X-Received: by 2002:a17:90b:957:: with SMTP id dw23mr10219490pjb.125.1631290920863;
        Fri, 10 Sep 2021 09:22:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f144sm209273pfa.24.2021.09.10.09.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:22:00 -0700 (PDT)
Message-ID: <613b8628.1c69fb81.bea8c.0a89@mx.google.com>
Date:   Fri, 10 Sep 2021 09:22:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-23-g950636fd38b0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 184 runs,
 2 regressions (v5.13.15-23-g950636fd38b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 184 runs, 2 regressions (v5.13.15-23-g9506=
36fd38b0)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.15-23-g950636fd38b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.15-23-g950636fd38b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      950636fd38b05594a5ab457db34ac2aa433a755d =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613b5349dda2646ebad59672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g950636fd38b0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g950636fd38b0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b5349dda2646ebad59=
673
        failing since 56 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b55a2b1b52c6931d5966f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g950636fd38b0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
5-23-g950636fd38b0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b55a2b1b52c6931d59=
670
        new failure (last pass: v5.13.15) =

 =20
