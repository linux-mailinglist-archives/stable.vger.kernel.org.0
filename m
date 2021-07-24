Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4053D44B2
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 06:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbhGXD2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 23:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbhGXD2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 23:28:30 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A57C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 21:09:02 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so6341822pji.5
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 21:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I80J/f6kQ7mU1QGf0+4LR0AMRpU28QQNFjetaoyKgs0=;
        b=r8l0N37Mc7yw27PScOMIyGh+zxzpAZPdf2iOnyF/32eaIgl5CduKBnJuyC0Qojsh+B
         l2tvXGiiVql58ZzpE2zPLaO+5BuVNs4lac8a/eQ/XwplZdsdntmUir7YTsTpQDruDwqL
         bL1f1fqadLiJfX0poYTWFi9ux7ictpUkxQ0g+XBHuuRfBRmwEh2kL1V1TPifsXh4SnVJ
         aVTJldtbBt7LBlWhvOssqYNMnsOe5J7ZYKF3KZvtNijgJREv1WbggqORs3fHshXl7KW/
         pVCnKFeXI0JL2giFH/wcrNuAoQC2cMBXK9Ye1spvyOw6D+4+DZII/Zl1F0SgPYopqGot
         yE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I80J/f6kQ7mU1QGf0+4LR0AMRpU28QQNFjetaoyKgs0=;
        b=HYBLOjUh5wfM++a324tVckc3N3tHUzqVggAmYgAWK3Fg6RCoNTQlGB+5KfSyBjvVHn
         6rKfVeOrXcX+iTVHVg+ibGeGUuudU5aUP9VmFVm00owkFJzj6i4s4Uxy3ExlRL1G57R2
         3aWIIxR9WPzrQ9SNqFJUKdlPSXacFln42b1aU8qLRy5T2anH8krVG+nCnJQXPB2VRlKe
         MGicXWSM5kqj7fQ+lTMGp62puU12Sdkexz8HiEkAWdKd1PZ7gRcmhN1h0q4LMmf56y8O
         4BuTYit/0GyKEa5dsXM1mUpAGSpCqRNxlH6R6KE9WI2V0rPU4V7b6zJgDJnUjR9jSgIS
         EpFQ==
X-Gm-Message-State: AOAM530ZJL1zRa2m/GyyjZDEyG9e5pMOzTHHrRNrQhRzahRI5ghWG+W9
        qzggi7DBG1zNRsNCQI014H15RKBsYl+Rw7Z+
X-Google-Smtp-Source: ABdhPJzIYd9osSzO0FDAFZFQglbVTsAnsTIXIov1D1LcNgYJ53xFe1gMS/57elE9zRyNnm7S6Iae7Q==
X-Received: by 2002:aa7:88d4:0:b029:329:be20:a5c with SMTP id k20-20020aa788d40000b0290329be200a5cmr7613830pff.61.1627099742287;
        Fri, 23 Jul 2021 21:09:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm36939662pfl.92.2021.07.23.21.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 21:09:01 -0700 (PDT)
Message-ID: <60fb925d.1c69fb81.5a4de.0060@mx.google.com>
Date:   Fri, 23 Jul 2021 21:09:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.3-506-geae05e2c64ef
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 206 runs,
 2 regressions (v5.13.3-506-geae05e2c64ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 206 runs, 2 regressions (v5.13.3-506-geae05e=
2c64ef)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.3-506-geae05e2c64ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.3-506-geae05e2c64ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eae05e2c64efc2c9ca30e8dce8c7829fc108815d =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb5a6d00282847e53a2f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
06-geae05e2c64ef/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
06-geae05e2c64ef/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb5a6d00282847e53a2=
f27
        failing since 9 days (last pass: v5.13.1-804-gbeca113be88f, first f=
ail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60fb5beaddcb265d123a2f59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
06-geae05e2c64ef/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-5=
06-geae05e2c64ef/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb5beaddcb265d123a2=
f5a
        failing since 3 days (last pass: v5.13.2-253-g45582c2691e0, first f=
ail: v5.13.3-349-g948be23c1d3d3) =

 =20
