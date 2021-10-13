Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3128242B464
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 07:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJMFGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 01:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhJMFGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 01:06:21 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C711C061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 22:04:18 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id f5so1130022pgc.12
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 22:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bgp8cEwCuIihkWXEbcnP72dqwTlZBgG2vFzBxHZuxqk=;
        b=mxCXN8DUJAPh4xLV050UUr++ENzdxopSKDqCcc7sdgWT/r/8mdlAXMcPUZVjv3U+oI
         Q/syp+PQ/crqJsWrrFYLYVvHOd4MRr0M7EYyWAPm6R2xdJPbIt+qb92ejWlwFvB39gpW
         gWu5+HznGqtGc6IjknjR4YEZzaBBabxQavinTfu0sLuLM2xRxBW23CfNzDyFqIl4owx5
         YBdvUqZdNfy2aWxF/vtGuuRtXSsLJ6equmfYx19DrY2WfN1t54YSX8mjxV1euBBzSpug
         EidfJqXr0oIu7Wf1osvMvwViFcK+p3E8Pd2NpBuDRd4IDGgdSvzFwtPQoDLhS+QpZmZn
         sOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bgp8cEwCuIihkWXEbcnP72dqwTlZBgG2vFzBxHZuxqk=;
        b=mViNObaY7UzuW4LfHEEN370XUqinwCuf2AyPj/sJesd2A6VT9FEabmpCEw/tYAwUea
         DXrbczBuHKGwzkIJMyrCS+RerSESL+oCVCnMisleRcsMVML4MD0QMRKZyEyzalIpY1KD
         5oGS61IfxPK6lPVeCpve/Szi5OIe3TVHAeZXtHZc8ytPgIxLsDI+VmxSyQHudZtFbtYs
         wTfxH4WnJB0W9qv6Hngkwj/qJsKxypOKHiurxPZcSF/Il6OD+1HvaGOSaXMLcJ6eA9an
         8PvAQ/NSHm4fnQ0i2KpdTnDyCTycA/N8oIYLdmn0IAkxT84r6dirmOVygzuNYOnETiQk
         JxkQ==
X-Gm-Message-State: AOAM532ViWC9DtN54t4Kwna39Uv+dqmzBf1xPPTf28q3Z4rAfSRAXCOi
        j6p2HTiTYp9qiHzCxwKZeF9tmu3mWTy+tQEo
X-Google-Smtp-Source: ABdhPJxgq2GVleBxSiVD+yw+lS9RYn2oUNV2r17ek409MO9FbR5fhWK8xQCTegVCo/ytDKxaTeI3RQ==
X-Received: by 2002:a63:5b09:: with SMTP id p9mr25906155pgb.321.1634101457905;
        Tue, 12 Oct 2021 22:04:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z24sm13600835pgu.54.2021.10.12.22.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 22:04:17 -0700 (PDT)
Message-ID: <616668d1.1c69fb81.4b63c.7001@mx.google.com>
Date:   Tue, 12 Oct 2021 22:04:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.286-19-g8297d3ca4f6e
Subject: stable-rc/queue/4.9 baseline: 81 runs,
 3 regressions (v4.9.286-19-g8297d3ca4f6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 81 runs, 3 regressions (v4.9.286-19-g8297d3ca=
4f6e)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-19-g8297d3ca4f6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-19-g8297d3ca4f6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8297d3ca4f6e724bd18bbb6c9e3b8bd7ac95cdde =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61662cf8e7560fc02d08faac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-g8297d3ca4f6e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-g8297d3ca4f6e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61662cf8e7560fc02d08f=
aad
        failing since 333 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61662f98d9b788db9008facb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-g8297d3ca4f6e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-g8297d3ca4f6e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61662f98d9b788db9008f=
acc
        failing since 333 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61662e4ced694f2e3508faa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-g8297d3ca4f6e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-1=
9-g8297d3ca4f6e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61662e4ced694f2e3508f=
aa7
        failing since 333 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
