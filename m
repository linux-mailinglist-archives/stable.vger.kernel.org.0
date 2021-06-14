Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20E63A71AE
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 23:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhFNWBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 18:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhFNWBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 18:01:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EEBC061767
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 14:59:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e7so7371668plj.7
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 14:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H3wluu7FsW1sjcK1nTI3wgwXZBukgYRc78wsphbgtYI=;
        b=E/0M1G4NMDDgWPxcXJBDpGwvD7e2r5iIvTFqd9bIM/5XeDWn4YGPMuEDqY/A72/TKF
         3GtLJA+yKyfuYTCAaBezNYtfa+i/UTUnKEugK6fkbnkKtLiwTpRXpEsnfsJI0JhQ9nV+
         9RM+JBcn4zMjL/gMgCBh80fhjItBLAyKhItq37pgRGysAfDS+ldH9fW4nE08t/OcrjGk
         pRXXWzdO36b0JumQ0hvfM9cJRn1CG4Ow8mM6ako10+gsWLKiwXk1iKlqpu0zC06v87bH
         R1tMISekucU3EnLVvyeXXqD6cukPbjo5drj9VQwL2hFK+uljQbAssk8wojZovfFWhjv5
         iZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H3wluu7FsW1sjcK1nTI3wgwXZBukgYRc78wsphbgtYI=;
        b=Wnn/4VVqdnZzrgIIPYyJWBjEFaP44RXFKHa1uLer6p5/DbEZacI0ESqjwIjRHeR3zs
         rW6fVpP/dIhuWsv6h72lgCW5pVeKHDqRIoDctkWfL8fEGEEmUPcYNzMTgelFlSd5+OQF
         bdh5Mg+zev2Iar99sQGU6f+AF1/IxLOjYnEAjnRPmThHGGGZSs24yB9N923YPnMNbA2R
         /KoVTGnGUj8JzybrZXO0yo9eUg1t/a5j+rncn95hOz/f2vIGM5YEpvZA9t1YOKkkQHdT
         ZaYlNH3cjAWuITIxiEpRCqMMcqYIVYAhpttXdlpeN/m72tuPjvGGIitUCvq6+qzNSjGz
         gw4g==
X-Gm-Message-State: AOAM530ZpoyEXo9SABHmxjXKynatpNh430Afr65CWhcUOBVpJHFyahQH
        Hdg9s28AdseA0Ikoq200m17bmeBsg4+PC0KJ
X-Google-Smtp-Source: ABdhPJz+bn3CwoIXUn5HlkwNBFCDLvESRDPKSr/81gj1qETceBCvwzfwNEgW6CgP+PA+ZPX1YUZJtg==
X-Received: by 2002:a17:90b:4a01:: with SMTP id kk1mr21291125pjb.129.1623707960321;
        Mon, 14 Jun 2021 14:59:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z14sm13583802pfn.11.2021.06.14.14.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 14:59:19 -0700 (PDT)
Message-ID: <60c7d137.1c69fb81.2fc9e.7d13@mx.google.com>
Date:   Mon, 14 Jun 2021 14:59:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.10-174-g38004b22b0ae
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.12.y baseline: 149 runs,
 2 regressions (v5.12.10-174-g38004b22b0ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 149 runs, 2 regressions (v5.12.10-174-g380=
04b22b0ae)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.10-174-g38004b22b0ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.10-174-g38004b22b0ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38004b22b0ae0ed236de37f13b323c9d89311f9e =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7a09bb206a86d66413280

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0-174-g38004b22b0ae/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0-174-g38004b22b0ae/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7a09bb206a86d66413=
281
        new failure (last pass: v5.12.10) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mp-evk         | arm64 | lab-nxp         | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c79ca67dae300c11413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0-174-g38004b22b0ae/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
0-174-g38004b22b0ae/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c79ca67dae300c11413=
26a
        failing since 18 days (last pass: v5.12.7, first fail: v5.12.7-8-g6=
fc814b4a8b3) =

 =20
