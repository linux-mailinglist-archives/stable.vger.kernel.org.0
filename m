Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE02A1F64
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 17:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgKAQDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 11:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgKAQDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 11:03:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88470C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 08:03:52 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id a17so2024744pju.1
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 08:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eVUX71SIjPUP20XWfae0G5vxlgt0TNqfGvEk8mY1KMU=;
        b=vXyoN8/g9fNDzY2wtQqVFQHHvfGfGYR/tRgoecnTG4rdCbzmflGc7HR+OrBpTlyOI6
         vQWBfTin2PY2PqmpvMxEXpjrJjBruI5FJlmaMH9SbDQ+xA8RaQ6nCHk5xz43sWUFO/ED
         fNA1ldqAo2UYg1Y9cDlVg+EWSQ1ISEhmpy6tZH4B4ZqjnoL6dfG08gUhEFLznKRQezvF
         QTKNduJMbV9PnhOKRIqMzuc9eV6KzIqoXAvE/m4Xe0jfB0IaFSW6tO3qzkrMqCN9nniZ
         gmYedj3kV4gJNDy+iKlcxZnUCybu1uKr4jiSK6uGUqgxiw9Y0+fM9POzQyXYQaAvVgcX
         58PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eVUX71SIjPUP20XWfae0G5vxlgt0TNqfGvEk8mY1KMU=;
        b=F0bbiA3zTLU1d0VgadsUJRZUeIm0lXohQmXTDr4XDvDkZwLDDP1GNPH7USTAOqzbXN
         D0BcPTDPgUQOaZipq4/Y+SXcuP2sFgW/wM/60DtNDQQPyL8L6kjCdUtaTS30BmGRDK9L
         sIsvKpgHzw1zlLRDYaomsatd8tJro8ib+L+g4tzSSEKtWL0MoTgTLUqlG9itlQ50ClgB
         NgP7ydNCT40U7EwN3RdNwuvDEiuXJiYTuiLzeAcafo8bN5T+N6l7i9f8Eab1BB8MzxNx
         LdIHp515OkhZO3yfDLH2z4w2ITvrGjaPX46+1yqKbADC371PC8bYgCzbcY18Rr3tFZTH
         4OLg==
X-Gm-Message-State: AOAM533UR8/vjB/k6mTchZXcvFSNrSIuJhuY7KMi8sfNyaVTqRPxmEmR
        Q+UGe/km0HYME7Xxy9+ce+DafOzfw8B+cg==
X-Google-Smtp-Source: ABdhPJxuIP1L5wxz1nESsnVZf/WCYRHaZn+DY2vRkKnJzIx8nRcDnmR7F5FO7Nd0lvwlVn1gFFofQQ==
X-Received: by 2002:a17:90a:b383:: with SMTP id e3mr12881913pjr.61.1604246631643;
        Sun, 01 Nov 2020 08:03:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y3sm11353075pfn.167.2020.11.01.08.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 08:03:50 -0800 (PST)
Message-ID: <5f9edc66.1c69fb81.19655.da65@mx.google.com>
Date:   Sun, 01 Nov 2020 08:03:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 214 runs, 2 regressions (v5.4.74)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 214 runs, 2 regressions (v5.4.74)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.74/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.74
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b300b28b78145b832f1112d77035111e35112cec =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ea6cf07a5c86ef93fe7d9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.74/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.74/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ea6cf07a5c86ef93fe=
7da
        failing since 136 days (last pass: v5.4.46, first fail: v5.4.47) =

 =



platform              | arch  | lab          | compiler | defconfig       |=
 regressions
----------------------+-------+--------------+----------+-----------------+=
------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 1          =


  Details:     https://kernelci.org/test/plan/id/5f9ea181e6df0ab6da3fe7de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.74/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.74/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ea181e6df0ab6da3fe=
7df
        new failure (last pass: v5.4.73) =

 =20
