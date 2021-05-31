Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1460396524
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 18:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhEaQY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 12:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbhEaQV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 12:21:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286D6C02A19D
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:51:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so1022688pjz.3
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GslhPpxvYe+reFBkydGfWSpRxpk2pZxyLkMzSpZCfHk=;
        b=XMBoll+flWg83YhDE98DtfW+Cz34H+q2hJ7fRLcf6HUb9rNzKM3ZMyZ+wuj7LS5aat
         W9XJq/SO89TgKwD/vWdbM5z9l1HH8XKLXlcmd2rcDHEMYZwUjR2VMBXcrOD9QqBBCMfq
         2JfGVawt8H/M+jO4H5PodFocQ+N7QtjdR5gQNUHA+LYzfB190jDq+NBP5Yqmvn87BAPt
         TNohbYDA4McbXUYZvbkoaZV4MGDMU2ERTW/DEMXNJnhEQ78IaihEHGvoxNJemcmcEMQL
         kTyXZG35sM1isFns+P2cA//6T4VGYb9fpbQRkfUs2lgACDlyzm4m48PaD8vhouMxpEUo
         GN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GslhPpxvYe+reFBkydGfWSpRxpk2pZxyLkMzSpZCfHk=;
        b=UJg96dYb79AbMW1lrRL5psPt0MntZ9eqdRvD1L/R4O0frUN8gxp/mAz4PxXwfpmE3y
         vHrC7n6CY6uOzBSEzH5jhn06KDuvSXNyRF/NjdhhlWz8YZ96o7G1QgAs+N0+D3cFV4Y3
         xRJ22yMz/+OYbRK7kWAP5RFYqXH701ggiDEnCXzRBliBC5RaI+M0P99ixRCZMGHwXn+z
         +8zqjAWRHgfey6r65ePKJCPCnahKvRgrtFsWvlUsATQGOw/+sznqjDnkmcVgrfgK2Mpn
         yl4uZF+XbbZdWt8IYgq0boMmGPh0jGO300jRuj8dVnm5AuA5fkF+a/pG97rZkIHsBRvn
         C74g==
X-Gm-Message-State: AOAM5315neObdcB/kIpPB6hfERwZyYHHo0VcfPlOVebCdDor8rZCSkc0
        MbuO/oPFejl2tEvfysoTo2mZpZZinX4AHzHH
X-Google-Smtp-Source: ABdhPJxrn/bIr07KSrIv5TJO4BzPG9Avmy2mV5hfIRAADe0yYQUVqbtOvFyUkSLrZRxjYzjJ1tVSTA==
X-Received: by 2002:a17:90b:4a88:: with SMTP id lp8mr20033422pjb.176.1622472715487;
        Mon, 31 May 2021 07:51:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u21sm10985434pfm.89.2021.05.31.07.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:51:55 -0700 (PDT)
Message-ID: <60b4f80b.1c69fb81.2ed9c.25b3@mx.google.com>
Date:   Mon, 31 May 2021 07:51:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-259-gdac437d7b2db
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 3 regressions (v5.10.40-259-gdac437d7b2db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 3 regressions (v5.10.40-259-gdac43=
7d7b2db)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
beaglebone-black  | arm   | lab-cip       | gcc-8    | multi_v7_defconfig |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-8    | tegra_defconfig    |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-259-gdac437d7b2db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-259-gdac437d7b2db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dac437d7b2dbcbaa499cb1f0d34f01ed441aa988 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
beaglebone-black  | arm   | lab-cip       | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b4c16296ea5e65c3b3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
259-gdac437d7b2db/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
259-gdac437d7b2db/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4c16296ea5e65c3b3a=
fa2
        new failure (last pass: v5.10.40-252-gefa4dae380d8) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b4c3347a61b196c7b3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
259-gdac437d7b2db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
259-gdac437d7b2db/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4c3347a61b196c7b3a=
fcf
        failing since 0 day (last pass: v5.10.40-98-gef1477410758, first fa=
il: v5.10.40-139-g2cb2acbbafd8) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
tegra124-nyan-big | arm   | lab-collabora | gcc-8    | tegra_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60b4e30436f687ab9eb3afd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
259-gdac437d7b2db/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
259-gdac437d7b2db/arm/tegra_defconfig/gcc-8/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4e30436f687ab9eb3a=
fd3
        new failure (last pass: v5.10.40-252-gefa4dae380d8) =

 =20
