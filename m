Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6C27DBEC
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 00:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgI2WW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 18:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbgI2WWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 18:22:15 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFA1C061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 15:22:15 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s31so5093397pga.7
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 15:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EEO+bk2i/5riIxD3efcxZ56ob6rCY1J76WlSIVy053k=;
        b=qyZJED7BuArdYWrcYNx+CPq7QqDuZN82hhHJ6ffmiPCRhiRzzevMXM69T7V2CnvR9N
         BASMz/zhqqL6xEbLkeoeTFHzbon0eCnS7f9i0U2VjhrrlCU4jaRlgZvAngLK/XDA3g+e
         Ki602w/NX6Hs+xARH4IRMy0vmepxzpU4uYV22eVij8sbkj6NpMI3g/UtXWEdORuo16jm
         e49F8kW33llhxQehwP2dMfkaSbGQ/81wiBtf3UDtIbbwwRn+7mq5NQmVYuKmo52XzQop
         nTgGL3qwxMWF3BFMQ2R3jwVQbgd2M0xqpbdSAHe2C/t73eu325ZYuYFJJXtpFyGO+onq
         4kxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EEO+bk2i/5riIxD3efcxZ56ob6rCY1J76WlSIVy053k=;
        b=R8jORLjgEga812HPLoadpF0hBN08XKmEmqslO16dYPnwH6hLAqpd4QbPvKhN6a9h3y
         EYrAJ6coKUOR2vcfsHSB30UpcQuleGc0+L4mkvKP22hTlXgSbiXXaeld/Hn2tx0QXl7Z
         3XGFsCgvetwZsPAMaovcsF3ge8mUh3yTUtmL73dSjXxclLUysm7Wv/78XvceTfFRemQe
         yYeporWpf2yqkZe9b5jDZZIgCfZSjBrDjWJy9X4eBhq4FFZHf3RXx9thFIImGWHgf1FU
         C5hStGrEXYtYG6jRW9pAkdBE+FIM8JZNgMolCL6SBVi1b7ID9UbS3AHfLy7JOuAgq63y
         vozg==
X-Gm-Message-State: AOAM530SNt68/OIhQEBxhg8pfVgRgd3Ac4tNiQvX4jc85/iWJujoJPrt
        u8mlKCQDqjtVnv+BFWjNFdsNFH/c/3wLaA==
X-Google-Smtp-Source: ABdhPJzk23JDizxNfptRg+FThgT8ZZd0mhzr2Ak2raoX7cHyO+3qVa+ow1jkPpZmFDnnSKC8FnJFnw==
X-Received: by 2002:a63:e057:: with SMTP id n23mr4609250pgj.87.1601418134606;
        Tue, 29 Sep 2020 15:22:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f207sm7005576pfa.54.2020.09.29.15.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 15:22:13 -0700 (PDT)
Message-ID: <5f73b395.1c69fb81.4407e.e90d@mx.google.com>
Date:   Tue, 29 Sep 2020 15:22:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.199-167-g7b80cb61f2b2
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 128 runs,
 2 regressions (v4.14.199-167-g7b80cb61f2b2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 128 runs, 2 regressions (v4.14.199-167-g7b=
80cb61f2b2)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.199-167-g7b80cb61f2b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.199-167-g7b80cb61f2b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b80cb61f2b2cf4f291246ded2d1c29e3797c095 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f737ea896b57f0341877176

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-167-g7b80cb61f2b2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-167-g7b80cb61f2b2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f737ea896b57f0341877=
177
      failing since 67 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f737e3f117a859bd3877176

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-167-g7b80cb61f2b2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
99-167-g7b80cb61f2b2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f737e3f117a859bd3877=
177
      failing since 182 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
