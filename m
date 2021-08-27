Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5453D3F92DB
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 05:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244128AbhH0DWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 23:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244121AbhH0DWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 23:22:13 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C180C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:21:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id u6so3880813pfi.0
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nO3xVJSUOkZTV5u9YfU9lwv1kXHm0mkRXqMzo/UfyVU=;
        b=eFtqmyZltk8mFKLPwsEIVwNDsmogs+o1VB++AmuXnkuvtX/srkG7unNSGT2isYQI7l
         9SbQmVcwT9Ciib0J5POal5GaFxKE1D35uAyy65QfxOFnLSqtmZLEhdTbIdXDGD4xgzyk
         m0fhA1ydIKeO7BLkc12ek1TNdoDAeJ8G8OnqBoavUowp5k1T0EtkpbhJw/kTx9QKdUW0
         Ku1K3ndfB2Kq+DWOhxnbXwpdaZAdIBBG0sydleVCrdDxVQkY3qQq6jbFJ1cmbtcYW5a5
         MBRnyoQVTJI5fbvboVe+/LWVTIeFxo8rJdm0+TOG+3WB4QYa98G5Z3pZoChgOPItB32J
         y+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nO3xVJSUOkZTV5u9YfU9lwv1kXHm0mkRXqMzo/UfyVU=;
        b=t8KnmNyiqyKT7cpWTTSHCLY8CDc5VxeG1ofhhtMZts5w/qTfLFl7IdIZzHPNt6fagg
         gTNAN1mOn/G7Gk7lFjRW6eykzchn5xapU1VgCYO5MRF+XUHM582ul1wKFv4TxL7FLcUk
         Yl5Rx5dorHM+chZIP2s9Xqj5FuNXyw5C4MRZpfLgbBwSVjs0FswbEsa411eZsKRQVeK4
         bhbSg8Y1HsJrVbHkXH0Y2Gx7EMZBHGPdfdfhpp0p5pjEOSWRf4dlfASaZuD1H0hDdS0n
         UYumpqMbXkQ422vJghjfEtQTD9hurvbAlsM5P1FEIuxbefbeEe3VRKsgmydLmvjlcub/
         oXTA==
X-Gm-Message-State: AOAM532ySOyBr60zsMmO+LqotEhQp4g/XZ0caI0NQysMaVg5JWQl9zQ7
        ImzGNgxw7dsZNyfW0lWIvW7pHVLjLolasNhI
X-Google-Smtp-Source: ABdhPJxP2f/JtN3CL8HrnpMA7YpJe0tdOVnYf42L6tCIaY52TagxU5YjHmDW5x4wmEBU7tDl/Z8P7A==
X-Received: by 2002:a65:6287:: with SMTP id f7mr6062930pgv.444.1630034484699;
        Thu, 26 Aug 2021 20:21:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm4170770pjr.48.2021.08.26.20.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 20:21:24 -0700 (PDT)
Message-ID: <61285a34.1c69fb81.72805.c1d9@mx.google.com>
Date:   Thu, 26 Aug 2021 20:21:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.281
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y baseline: 81 runs, 2 regressions (v4.9.281)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 81 runs, 2 regressions (v4.9.281)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.281/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.281
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ee4959c91711d87bc57c762cd050804c04b08739 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612825f1fcca45b4b08e2c9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.281/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.281/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612825f1fcca45b4b08e2=
ca0
        failing since 281 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612825e8944bed39e78e2c9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.281/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.281/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612825e8944bed39e78e2=
c9b
        failing since 281 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
