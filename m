Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21A523D62A
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 06:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgHFE32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 00:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgHFE32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 00:29:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B637EC061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 21:29:27 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p1so26860336pls.4
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 21:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RkV8X+eWIQeCfM7XkVboVSs8TaL/6gkgCV9DftKCoaM=;
        b=hf+HXyaogr9EV/g8J0pmg8OdLDbJU9m6YHiQWe2pnBesTEdYNqZNd0PypdNZNjZXXU
         U/C2xncuP3fmI3VR8nokN5jI3GJ/SaQUKNuYjmEbA+5bkpi4a/qbxW76MC2TlCdxrZyT
         Tq9wzNHgW+VAPks97mpkDV0nYzHpQW5ltydoGTHTJQbXNI3zDJV6Zr2jmk1P4DVRNwYj
         Rs/fwAMbkItZbYBUsiAxFQVhl7ZYx4PNyR3+Hwa3xRH8H+h9bprQdRWgas6ZdoiJkuQn
         EIVkgKyV8tVa2exaBbTA2Vd0RHqehnD6yVwK6D/XwQ8XRJCdxuanUmztzzW49qrG/LAT
         /rdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RkV8X+eWIQeCfM7XkVboVSs8TaL/6gkgCV9DftKCoaM=;
        b=FZh4SBlxwje3qaEBMSGDSjlxuXEpTw4Drv0MaY7EBQnqaQLjp26Z8DZGBdvoewWaJH
         m8yRjbD2YjiCV/6VITfkTW6d27j9dVcn18bSdBcteb22/AY4OKAG9/DT4Pa2G3x1En0G
         vflB1FyXbf9Mcxf7nE+Blxqu3Qylr05qQMbarsK6+acRC2XpZNLWD7JTg33hdAkrrGMM
         inZNgmnAqg8mknMzsx58CQ6L/BZfsmmbI9x/HU4g4ncVcSnS9fN6w93i12lMHI9tJA9b
         gVxc3wynwIodEKwu3L6Lc7VO4bbFYKsCJ+iojXHlMa1IXl+h4YKqILLYgO/mE9kJPeSd
         CWtQ==
X-Gm-Message-State: AOAM530lBA+U5jPUlwCExHFojrAreqiMwVEFKeRaU2s5M+8hlQDru8+X
        yT7wpbxMlvf6h8W5w6XfTUN0l7C8Kxs=
X-Google-Smtp-Source: ABdhPJxw70bivI2AV9XnVZHbkryQTiqmAposdMBIoridV/xEvfGYv/iM6O6bJQ1ntfOX/eYX159qLA==
X-Received: by 2002:a17:90a:bc96:: with SMTP id x22mr6907956pjr.164.1596688166574;
        Wed, 05 Aug 2020 21:29:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b63sm5562750pfg.43.2020.08.05.21.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 21:29:25 -0700 (PDT)
Message-ID: <5f2b8725.1c69fb81.f1f4c.e556@mx.google.com>
Date:   Wed, 05 Aug 2020 21:29:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.12-125-g0ceaad177e51
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 143 runs,
 1 regressions (v5.7.12-125-g0ceaad177e51)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 143 runs, 1 regressions (v5.7.12-125-g0ceaa=
d177e51)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.12-125-g0ceaad177e51/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.12-125-g0ceaad177e51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ceaad177e510974c093f79a5d1f3bb058a4fdf2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2b5570e37c4625c752c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
125-g0ceaad177e51/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
125-g0ceaad177e51/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2b5570e37c4625c752c=
1a7
      failing since 20 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =20
