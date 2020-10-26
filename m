Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D29299933
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 22:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391343AbgJZV6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 17:58:42 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:40682 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391338AbgJZV6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 17:58:42 -0400
Received: by mail-pf1-f171.google.com with SMTP id w21so6952072pfc.7
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 14:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uvEPsN5r2aujTGqF5bIUzH3t0Rz5ZTpN6WHvvDe/FqE=;
        b=YEBIC9tacq3qY1GAfH+uqjK89SbFLjnO3awXbcVNB50sEptyGiM0V/EdBfZyUkSOmz
         2yPxUh9yh6b958lXBDO28thkYHAM8LW/wrrHaI6V+IuknaqlNSlFKq+HX/XHk5QEzZEz
         5q9Hz3QWWZA1oz+TIPoUIb96yJhz+0wXEeUIFby+sJIvZN5sl1Q1RX/3jkroQACq2ppZ
         ZXDsfwFLKQ8coo7XW7y/GSODLCY6ogNROPxIQ3Ivi7X5UxJxd1CXIrZO1Hsps5Yu3S8F
         LDJkbR/XOVq1ULMYcFQsMQ9R2gq6+uY47OMFQOMw+tZeQX8V8A6aspuW4plQ9mOAmmEd
         WLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uvEPsN5r2aujTGqF5bIUzH3t0Rz5ZTpN6WHvvDe/FqE=;
        b=WnfegoNhhMlhjImb+6JQV8d1/aFwi2A4EfKVcG8bbFv7zy0Ipcxm5o0QQCVc3IB45n
         9d4Al4jowS20JQw2cNNKPs+9BK1CjGLceneb6tz9B2X0kQ3h3kvfQWE0uTFc7gBfcGKQ
         F9LZ3CwqigmRgnFAxWyHD920lTTJEANFosPA65SOQ0eu2B7rFnLxQ8Fjyo834qtNIite
         qZm6NXXz0t/y/MUaTipbGU5WJW9iONd2+kvm9ZiRJYYe/hXvpkoX3NmDIb2IAVecXcRR
         sifm1sc1Lemidnw+jQzuaegyZDskmWo9J23PMXpdwop9tEw5gOt2FgagkzvcNoXgxGAK
         kGoQ==
X-Gm-Message-State: AOAM533kiVd1u/dCcm+fqVvHmNCSn135N3KLFECTf7/4cWhpcZEzFJ+l
        2tW4n4OgcSPuRw5c/ieUBtQ7mkZq11a5WQ==
X-Google-Smtp-Source: ABdhPJz6Gy5qy3pr1St2KVw/4B3dlrxB5ecrJcGb/VJF4bWek49Ge/bWs/JhLRUZIjBkrzHW6qkXDg==
X-Received: by 2002:a63:4457:: with SMTP id t23mr15291541pgk.108.1603749521088;
        Mon, 26 Oct 2020 14:58:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm13580033pjw.13.2020.10.26.14.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 14:58:40 -0700 (PDT)
Message-ID: <5f974690.1c69fb81.363dd.be3c@mx.google.com>
Date:   Mon, 26 Oct 2020 14:58:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-110-gdf2675c594de
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 110 runs,
 1 regressions (v4.4.240-110-gdf2675c594de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 110 runs, 1 regressions (v4.4.240-110-gdf2675=
c594de)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-110-gdf2675c594de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-110-gdf2675c594de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df2675c594deb1e81d38934c0ad9c6b963e567fd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9713c06b8f9a9811381038

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-gdf2675c594de/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
10-gdf2675c594de/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9713c16b8f9a9=
81138103f
        failing since 2 days (last pass: v4.4.240-11-g59c7a4fa128e, first f=
ail: v4.4.240-18-ge29a79b89605)
        2 lines =

 =20
