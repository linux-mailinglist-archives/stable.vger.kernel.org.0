Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4738E44B91C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhKIXAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 18:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhKIXAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 18:00:00 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D36EC014A84
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 14:48:41 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b11so1233016pld.12
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 14:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RyUbzbLT7TyFTwsD4K+vvBkFaPCFe0nrPtJ3YkrUusU=;
        b=HyOX0DXuUXOTPNrAah15F4KqQbsnBC6ZPmAz19M35N72oghtoWehDsgf9ddtiqUSc+
         QIIN+3hGJuDr8JtE8lNNGFtsoW1u8fRjOoF+lwn4npLYCNQnLciZvFUzB4PWRWB3OnqG
         iHXJSJ+oz9daC3EqZ4FQDw6bsWT1ephSx8zAIXFTeSKWVaAYyGPaf59jIIDrOMgW5yYa
         WE2Wb0qi0E1fQlicB/ktmKH3NNsfYPqCmmWlDZ5uP5J+eSRnuAfZDByoU2g9pA2kl4Ig
         OQo+0eYyu+yUK08RMDm0ymDGNy3aPJAJccMcTnUBUEVqCEId30vujknP6wQboSpIMaOr
         EVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RyUbzbLT7TyFTwsD4K+vvBkFaPCFe0nrPtJ3YkrUusU=;
        b=GYoMVo7iywOh6binkrS+wZQeZKhnjpyGgI1Xg1zkBKY4z7pWF+O2wkXl891KhJtoTj
         syNuKS0FeFje3iYIfXEY8bJ8+uBvMBSzeku8T5aANtkIYgRUE7s/XUZj9M/FM1NSOtrm
         tHeyanIsgH82kEnKs+8J26s6QnFDRTMEKv6HcpUcLnR6GTs3J3Wmjt6v/XOuOCz9F3v+
         bSzQX0rXEwmzLoBReSVy3lmufCn0n20EeRotTOzY7rLTFe4Cn9SCRArLi7EZLe9liKNC
         /61DBB6gt9noCofFttkZtDRsxztHIIX25/gUxmQkyXgp7V2AfIBE/A7cLzBoPs09vlkR
         nsFg==
X-Gm-Message-State: AOAM530YXbcpblPWjiQ9R21GqiXyzr5Fs9DgkerS3kVnL9WJpLETnOkW
        5x0cIM3TaGd5SMet+E9E0Y7JwVeShthWouKl
X-Google-Smtp-Source: ABdhPJy7JRPd3rrQQ7s1aE+zQ+MWHBTGfndUkElCldCbKVzkwgOOrVQQNPY6CRUtNYlbXztu2ZEJfA==
X-Received: by 2002:a17:90b:1812:: with SMTP id lw18mr11271269pjb.196.1636498120694;
        Tue, 09 Nov 2021 14:48:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j62sm15699402pgc.62.2021.11.09.14.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 14:48:40 -0800 (PST)
Message-ID: <618afac8.1c69fb81.fcb49.06b3@mx.google.com>
Date:   Tue, 09 Nov 2021 14:48:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-13-gbb0509ba5901
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 218 runs,
 2 regressions (v5.14.17-13-gbb0509ba5901)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 218 runs, 2 regressions (v5.14.17-13-gbb0509=
ba5901)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-13-gbb0509ba5901/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-13-gbb0509ba5901
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bb0509ba59015cf61f988fcf8d302e23be5817b6 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/618ac401e8d18e882b3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-gbb0509ba5901/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-gbb0509ba5901/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ac401e8d18e882b335=
8f4
        failing since 16 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/618ac478fdec7f74ef335906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-gbb0509ba5901/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-gbb0509ba5901/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ac478fdec7f74ef335=
907
        new failure (last pass: v5.14.17-9-g9f7eecaa70b3) =

 =20
