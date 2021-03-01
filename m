Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C337D327B05
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhCAJly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhCAJlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:41:40 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CB4C06174A
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 01:40:59 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 201so11114743pfw.5
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 01:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TLQp2iAvJqWQLIIlPWk4VcBvjXrH1Q8X0R9QrSv2IyM=;
        b=xPVUNxtrIRDHHuVLfRHW2M8OrdsFinLqoqvKsOCPprBufS5uKHoT7qE8qF9ug5UZAt
         joRFZ97DsGQnT5Gdjz+GfaKtkEzCtRqnQlH6blA2IWU7r7gXNX8zWa+bg00I0DsBlgSf
         e0HGO2LWx6CL61lZBt2N6FZBAFvFUMGv3uaZrgS8WdenjBEnFK/ShtJ+qJRnDP+Qgzq9
         i+DwZH4idcGfg8RJ1It9tfrjtrA0Yg716A4+zYQjwhxVNjNhMbIekQyOONyKoKZgo0nb
         FPr2BYQ3ViJD7usv8uTEAv8oeH14gNvF6pZs5k1t2lVFvIaAhNV7A3HCZaMDVXHF9ea6
         jmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TLQp2iAvJqWQLIIlPWk4VcBvjXrH1Q8X0R9QrSv2IyM=;
        b=R9w5RFw6L1c28kemmJptNzTK+X7Sv4pVq0RoN57L8WCV1YhdR81QMGKAoPse1uG7Tq
         lye9M6K71tr2YlVgTky3ZJ+R+swmzb8dX93RHK24zsoK5SaAe2g4usBbVoIrvl/2nnnm
         f6W6o09zC8fNkvSUehh5xEqFVXpVqgpoITyp5xmBZFONofIvju6FNUKOIWMwMxK2HPIl
         c8KgOCqECrOJ10qeTadcvbZQ2i2Yt53jpfUy0FhKCinnQU99SSJE7l8ZeDIdjK4gieqU
         SY8OAyoYJf3hijerQa1344uVw0V/ApwvsASVm1SQqP9scSRJYDnXtVicStC8HIa7ru4C
         45AQ==
X-Gm-Message-State: AOAM532gx9LUcq29PENlelNw+Wjddhpvi5Lix05DsC+jdHvzauoLtx/v
        LjiCxUoTtkpFfVIYjGtG/P88n0a0TZeGZQ==
X-Google-Smtp-Source: ABdhPJzO6z0OFGXEJSPIwFuJ9SofSUsH5zY+5D5NldqKecSLDGmCEKTG5xW3pfE+Kj7rOeErAYGIaA==
X-Received: by 2002:a63:1d1c:: with SMTP id d28mr12602095pgd.216.1614591658927;
        Mon, 01 Mar 2021 01:40:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s27sm15275853pgk.77.2021.03.01.01.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 01:40:58 -0800 (PST)
Message-ID: <603cb6aa.1c69fb81.2160f.3aac@mx.google.com>
Date:   Mon, 01 Mar 2021 01:40:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-120-gdc8887cba23e2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 64 runs,
 3 regressions (v4.14.222-120-gdc8887cba23e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 64 runs, 3 regressions (v4.14.222-120-gdc888=
7cba23e2)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-120-gdc8887cba23e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-120-gdc8887cba23e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc8887cba23e2bdbb5d6c255d559c5e17a31f72e =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/603c94b618cacbd7b4addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e2/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e2/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603c94b618cacbd7b4add=
cb2
        new failure (last pass: v4.14.222-120-gdc8887cba23e) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxm-q200  | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/603c8e3322b7a4783aaddcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603c8e3322b7a4783aadd=
cbe
        failing since 0 day (last pass: v4.14.222-11-g13b8482a0f700, first =
fail: v4.14.222-120-gdc8887cba23e) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/603c8493f2b9020b1caddcde

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603c8493f2b9020=
b1caddce3
        failing since 0 day (last pass: v4.14.222-11-g13b8482a0f700, first =
fail: v4.14.222-120-gdc8887cba23e)
        2 lines

    2021-03-01 06:07:12.298000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2021-03-01 06:07:12.307000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
