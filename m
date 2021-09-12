Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ADE4081C8
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 23:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhILV0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 17:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbhILV0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 17:26:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE506C061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 14:24:58 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w7so7481704pgk.13
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tqyK72xU4WWiV10i9Us99F8cqD2OTRGyeC8VNscDyUM=;
        b=mfo4yghyYhN0PyFDnj+msLyL0vandtAW13iGEvlogCob6ZW9PSK8Zhp8U1M1R/qGeV
         1wkwoV8VGauQx3COoAxEQfZQew7YXOkTpFTK6UY+nF5gSXq6Idcp4F0SSSqpnaZ1wKBs
         kubWo8ndRG9vlju6REz1fGXrSF/i4m6HSu+ERzER69yHs40RITm03N7ZuOA2Vi03n5V+
         M4ZIfkgMmpgQc+THeEE9JcPWtA+Hw3q/SVuhLrGngg1dwOQr6HeV5evtgu5jN0s9yRry
         OMFoMEScbI+tL6csaKHEw/oOdHOesXw7MLtxvHkZSXsBqmQIlU6I5UXecBO84wM23dtH
         4SWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tqyK72xU4WWiV10i9Us99F8cqD2OTRGyeC8VNscDyUM=;
        b=mtGycwTzueLjcktZoYBAeYWRZ++zrDV74kM002ZgFOguQOpg9ky2X5AQbyw2Dl9Mj/
         fMvCDduVePgCdpUF5njGifHjCv9t8/caQrMRqFsKzJW8SQ0DqEnlaSAqFlut9/DcXbVB
         c8pCHkgCBdFLh8oZf7kX+AoRwElzdmVvboIUD6lJm3PIp2/aWYAexYZcqlHHl0V/e7sV
         fJhK1uZdkay8LhVI7PyVniayBg2R/ovcKFYPZG8GVcSLndZ+Q+IIdCRupaOpA2pwVGp3
         NtuA4YREv9xJug6ohB/4ITz0pUIwwoefU1QrCNjJxlE6T7QMWK9lni8QMI06Gf11k1k5
         X+5A==
X-Gm-Message-State: AOAM533IafaWsdNUhvglbJMw97ueTNXVx1NL8hVmu0//3pDOmigKqiO6
        RXH1Ua2IO8xVhab3OAJwn9irrTYEL/PhqA==
X-Google-Smtp-Source: ABdhPJxRotAUhbTOiHxOVmo7r8xiDk1igJNf+RKePXTG68crAW+Zh3+FYg/Mhf3SHMkilh3KIH2C7Q==
X-Received: by 2002:a63:c101:: with SMTP id w1mr8111422pgf.53.1631481897262;
        Sun, 12 Sep 2021 14:24:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 17sm4451098pfx.167.2021.09.12.14.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 14:24:56 -0700 (PDT)
Message-ID: <613e7028.1c69fb81.9a93b.a8c6@mx.google.com>
Date:   Sun, 12 Sep 2021 14:24:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.16
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
Subject: stable-rc/linux-5.13.y baseline: 194 runs, 4 regressions (v5.13.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 194 runs, 4 regressions (v5.13.16)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a92a476e53c140e715287901aef73df9b5e1570b =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/613e4025cfada16a0fd5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613e4025cfada16a0fd59=
67e
        failing since 2 days (last pass: v5.13.15-23-g950636fd38b0, first f=
ail: v5.13.15-23-g7f3773195533) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613e3e6c2295ae7cb0d59684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613e3e6c2295ae7cb0d59=
685
        failing since 59 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613e3e37fdb47aa1f3d59776

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613e3e37fdb47aa1f3d59=
777
        failing since 2 days (last pass: v5.13.15-23-g950636fd38b0, first f=
ail: v5.13.15-23-g7f3773195533) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613e3d9996a3ab7a02d5967e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613e3d9996a3ab7a02d59=
67f
        new failure (last pass: v5.13.15-23-g7f3773195533) =

 =20
