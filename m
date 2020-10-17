Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A5B291447
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 22:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439783AbgJQUXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 16:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439782AbgJQUXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 16:23:52 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C99FC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 13:23:52 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id l18so3544319pgg.0
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 13:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z+eHTd5oF1z2hsrEl/zU+BspaHzj1xeSOEUaFNYP4J8=;
        b=Xy8CfBWYlj8FNVmcXVcc9eTA+UX+U2veHTiEOB2M3IkjzXuNAeEEW6mBsrQ7XI8F5f
         ofBfCKE1rYzB7USRE99s9WkUoN3G6bwTfsE9XjUVzBDlz1l4BYTNBEsBavRvIGl8gT9r
         oAKQMHusHVNCkNxvcM/kAOD0nPeUMlT9goflfPTO3pMz40Q82V2HAJU8K2xUoffAlKPX
         xYhGOLZJVMw/34Q+WgaG5vKcKz+QlsEl6uU5eKzFg9GwlM5gGpWZSWldiMdvonxn5V1T
         yqFqxHeB8krVShQ8OqvxXms4aknKye4XThQipAG6bBt7MwsOPIi92tythni3Wwp5PkZ4
         U36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z+eHTd5oF1z2hsrEl/zU+BspaHzj1xeSOEUaFNYP4J8=;
        b=GDrbwJsUeqEdC+CeZE+13OuDUuDzMzJrOc3I/Utg1OrCLaSSSpX214o9hAPoz8Ur48
         twaAkEb6RCAHQn2+gnvsqb8f9TLphpbntTHHB8s1hZIPyH+Wti0HXK0NZL0ZLiXxtbKk
         w6UM92StKsf5kClAT3USHnU2UfCKggBmrZo4c9MRG0zMOSAQ5fciv6JitfvZUuYYEo6h
         HnyxyYM20rLHcFxAF1FQkAzD12sNOQ0ljMT5pca3bPLQsiAuIzGsN0e0wsEw3dlQuVlL
         Eodsdfc3wI8MuDwdf/jwa6JrR7qgykH8MGGQHHda86gLgiRVDEUIOunb30pHspWt1cGW
         JP1A==
X-Gm-Message-State: AOAM532/N1KxS6EdTA7La98AcEcWxe0YpB2zksqIhG/9zifXw6ofkfmm
        teGpCUjKpQcJViJYYCLjV0TG95eRwAkWrg==
X-Google-Smtp-Source: ABdhPJz+Y4OvtJnxNgUpYTXeExtJjbwhxOXv4Ek/fJwRTzEKdCXBEIzyFQx/RaWXPjo8GH0o1IZTDA==
X-Received: by 2002:a63:5352:: with SMTP id t18mr8282642pgl.51.1602966231569;
        Sat, 17 Oct 2020 13:23:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b207sm6737234pfb.8.2020.10.17.13.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 13:23:50 -0700 (PDT)
Message-ID: <5f8b52d6.1c69fb81.600aa.e4dc@mx.google.com>
Date:   Sat, 17 Oct 2020 13:23:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.202
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 170 runs, 3 regressions (v4.14.202)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 170 runs, 3 regressions (v4.14.202)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
0/1    =

panda           | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  | =
0/1    =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
3/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.202/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.202
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5b7a52cd2eef952cee8a72512ef370bcdef46636 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8b18846c70899c154ff3e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.202/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.202/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8b18846c70899c154ff=
3e5
      failing since 197 days (last pass: v4.14.172, first fail: v4.14.175)  =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8b1a850d446ca9244ff4e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.202/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.202/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8b1a850d446ca9244ff=
4e1
      new failure (last pass: v4.14.201)  =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
3/5    =


  Details:     https://kernelci.org/test/plan/id/5f8b1842ab68a7feb44ff3e3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.202/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.202/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8b1842ab68a7f=
eb44ff3ea
      failing since 2 days (last pass: v4.14.200, first fail: v4.14.201)
      2 lines  =20
