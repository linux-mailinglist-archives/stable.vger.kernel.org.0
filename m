Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5C928C20C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 22:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgJLUGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 16:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJLUGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 16:06:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84940C0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 13:06:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d23so9253523pll.7
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 13:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CThdBb0+8GJ/EAcvvuQjqu2UQqKo5Yzxzod1JkwR6Ik=;
        b=LTmT5NtkljKFdoq9sclOg5CEy9lqEbnGrOF6RiPpf5INI1qQA83npBO1f/URcjJIp5
         YoMhSAhBJNjoULNtuKznAbb/CZk+YxPTM6W6x6qxN4t0Pz4+N23aCdYO2QeZ3ZVJ9umz
         OwwIJfx3MaMIjFAa/c0J7XFrldfgLGhkW94glOtD0HgQkIhbbHHNXumTiiAEJwrlLr7q
         S8kMK0AvOBxWw+q3XGx94FqjKMofTbaNnAISWsNUkHNr5V+mge13m+acTjNsunUNg+s6
         BGFEcu61mgIzImVte1D/g4GCHZZy5bLVx38zr3KAyyRWqIoOJgdZtec5AppuAHHmg8k2
         bb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CThdBb0+8GJ/EAcvvuQjqu2UQqKo5Yzxzod1JkwR6Ik=;
        b=OtyUU4v834ralWFwZMVzj6sVzyQmaHYlUbVDu9xFYCWcXKzl4es7TtPvToMDIRVZuq
         Z1m5abwsW8PuDaCveiRhJJoWa6XiECQe24RU6Z5eoOf3ssPhCmZA7cjNCVJhGKEAeeXF
         bvb2H/6Wbxo9mVvaCuHJ+iCbgSMpSe6mYseJot81fMf3I2AZuWo5LQt4AgszitLJcEsq
         YrTEt+6IbnFkBVcCoRhzn+mh19Izp3mDYtBGkujBeTQydaQpkUIb/K3xIVeoTmd82xjs
         1esYwAfs7MuKuQEZ+J3SD+aXxYvF47kOU+9G2vjkYxjLslZpGltq60Tl3czf7N8C+L6t
         LfZg==
X-Gm-Message-State: AOAM530Ymk38pO6pB+o0LRDyq27FU5D8MiYmwR3A8qmjuOeh4DwjtOw3
        vuYZE2jfBWRjjbHMrA4PESUXzAEWpgqTUg==
X-Google-Smtp-Source: ABdhPJyLjus9/xxv9kQcIHeb/fH3zXyynOpRdPhx6i4rBEL2ksVCLBjFOKGa2VCyUnIWxhqRkZ1aGA==
X-Received: by 2002:a17:902:8d96:b029:d2:8cdd:db9d with SMTP id v22-20020a1709028d96b02900d28cdddb9dmr26114112plo.79.1602533179629;
        Mon, 12 Oct 2020 13:06:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm21781315pfd.198.2020.10.12.13.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 13:06:18 -0700 (PDT)
Message-ID: <5f84b73a.1c69fb81.f8df6.b149@mx.google.com>
Date:   Mon, 12 Oct 2020 13:06:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-69-gc6bda4c1748c
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 101 runs,
 2 regressions (v4.14.200-69-gc6bda4c1748c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 101 runs, 2 regressions (v4.14.200-69-gc6b=
da4c1748c)

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
nel/v4.14.200-69-gc6bda4c1748c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.200-69-gc6bda4c1748c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6bda4c1748c18703b3b48bdf33c040538e47032 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f84731eb7197ea92b4ff3e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-69-gc6bda4c1748c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-69-gc6bda4c1748c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f84731eb7197ea92b4ff=
3e6
      failing since 80 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f845cc730e3cc64164ff3fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-69-gc6bda4c1748c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-69-gc6bda4c1748c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f845cc730e3cc64164ff=
3fc
      failing since 195 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
