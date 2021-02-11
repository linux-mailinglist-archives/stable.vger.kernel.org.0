Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E922319420
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 21:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhBKURu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 15:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhBKURr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 15:17:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37049C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 12:17:06 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gx20so4078727pjb.1
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 12:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s9bP0M+hVrRyk7irE1TDGHcZPl/pgMdMMyP31d0ixu4=;
        b=qiztnzGfwEHiZASLUpnH0pgZW8mNkBX+krcSAIJbnnTu874WmZ19ysc8/UQIEDohFa
         MtekFqAbm1lrL56X54dh8scFWDL/gZmz/hgz3IiOVBAYK720oHYB659g5/bRqPOYdecv
         L+sIIZMM4mXgAUl+qyldz0FphFjs3WjMd4yENQHGOUt2AKaXZuZY37IP44vqhctpF1fG
         nbsOIzEvCtKOqjNlveQZBzXfgZaEtasgnPb8utMFn5qI68cRD5CMmRmHfPXbVou2rgUW
         KY7RpwEZzYUzEwPFXwuU7t0f7RtX+X/fyMEd/x2EelD9nPaxSQb/Mry4hBBtrCFWBB3+
         F7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s9bP0M+hVrRyk7irE1TDGHcZPl/pgMdMMyP31d0ixu4=;
        b=nrO+YMu21nnSYOcJv+h7sVhbgC1IlY7bMdClC4wdwcGl+EfvaZ5UGNuF8bCJINMYzt
         V/Zw1reeUmS3cioYvWRPiejXbMN3NXhvJK0bdg4Jlpp8arM6nQVP6UrSlGSc5q2H5i6e
         vt+Bwlte3jL71SPL8OVjO6kqzMgHk6+k2s0mkvkmq5EeDCtwE39o3TQUQH8eOo0rJFjR
         gIlU3an797U1SPyVBJl6npHQJfha+ZqdFbNYw3141G4iAbNdtnswXEu2q9L434NGRD8Y
         8ssH+Qw5KPu5H7JcvaIZKC5hJDn3YqRMAxWR8o73ZSU9EU0xd19N1yu7D0nFKkpMYKt3
         3mSA==
X-Gm-Message-State: AOAM532Y5WbWWI7FBa5Wh7CFziBbffYBhxpphqXLfzDZ8rWTV3tC6Sus
        FxrSYQWQR6QbBx2Ho3AhDcYic+6Y/uEs6Q==
X-Google-Smtp-Source: ABdhPJxw8Kz3OsV4xW+7ydf8Ckq9YJTpVe4e/n6WtqPM8tuGFeMNGJYYUFYTxqcuuaPiXFFBNjmv8g==
X-Received: by 2002:a17:90a:d98a:: with SMTP id d10mr5542508pjv.116.1613074625971;
        Thu, 11 Feb 2021 12:17:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm5834441pjd.29.2021.02.11.12.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:17:05 -0800 (PST)
Message-ID: <602590c1.1c69fb81.a5c51.d324@mx.google.com>
Date:   Thu, 11 Feb 2021 12:17:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-17-g0317491e2730
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 65 runs,
 3 regressions (v4.14.221-17-g0317491e2730)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 65 runs, 3 regressions (v4.14.221-17-g0317=
491e2730)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.221-17-g0317491e2730/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.221-17-g0317491e2730
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0317491e2730fe6d5203cc060f27aeb30719b339 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/60255fa7d3967638eb3abe69

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-17-g0317491e2730/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-17-g0317491e2730/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60255fa7d3967638eb3ab=
e6a
        failing since 317 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/60255e96023aa02e9d3abe78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-17-g0317491e2730/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-17-g0317491e2730/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60255e96023aa02e9d3ab=
e79
        failing since 0 day (last pass: v4.14.220-31-gc7c1196add208, first =
fail: v4.14.221) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60255e2864debac1ef3abeba

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-17-g0317491e2730/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
21-17-g0317491e2730/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60255e2864debac=
1ef3abec1
        failing since 3 days (last pass: v4.14.219-16-g9bdfeb6e50d8, first =
fail: v4.14.220)
        2 lines

    2021-02-11 16:41:08.943000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/98
    2021-02-11 16:41:08.944000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
