Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC431EFAC
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 20:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhBRTVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 14:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbhBRSlc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 13:41:32 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D15C06121D
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 10:40:30 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lw17so3230187pjb.0
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 10:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jdlJMyxQRnZv3Xz8HTkiTgKb8hhuIr/TTuV3NKhJ4Mg=;
        b=TN4Nyt+BYh6D13KbKph2QURTp18559CmHuIqS1IQUAVr9mzkL7QazUuUMwlA2t4zFy
         +NDZZP7mw9SWxOoC+fWImpl8EcakadH8F/ITRbDphCdfXO0XH+eYwIcFJ51vVuM5ku1f
         QDxJURGEHJ74woRY5GVUGT0KVmxXZBVVHMtdBBa1LOLpT2OVzl2NFhFqoqD8GARsk01O
         ko1NmE4eO734PfD9+8NUcQxVqZBpgKNmZC4CQ69K8pCXRZJEmlAXAOMvbLVHp5lk8RDd
         pPxPPRUG/FSf+8F26idYLDzzZGOpLP8kGIkAYcLhaPyiW0cNOcdsg07lpU7s1V9nw5A1
         jCFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jdlJMyxQRnZv3Xz8HTkiTgKb8hhuIr/TTuV3NKhJ4Mg=;
        b=efMv3pUReORkaObTNSAM9B4clqWS99+hdNcrVK+bxNo9nlJhcmhN4o+VET+AGrB5pt
         asDwzv4xXgfox2u5nzxToZ3DtX/Bt8f+aqXyCqgHNOb8u0QOUAnLCvzB6E0P+hSxxxga
         wCSvoa6h8GMAsDZ5gNj3gzN3YoBDIl8pPW0ILNORQE5IlXFOiBOxe2RcpE3Nknp9CvU9
         3qNnTISxt61cjeF0m1DArx8A17gX5YL0YASpqmD1DHO7b6PZ51eNPYcxOfjRuK3Jbd+L
         jOnbSeeQ38Bxzex1Xo6/ftzNTqtWXGwd6k+hQg+KIscee2yhcRroRNAEqcQzk7Y2CAMC
         0WvQ==
X-Gm-Message-State: AOAM533ULr+gz0+qx9aMeDfjucEAdYaUJT6rKvjysLQlBTdCTm6zBash
        irFR5K9scEbuRtG4uCHzbEMVVjTDZCeAYw==
X-Google-Smtp-Source: ABdhPJy9ns6nR817Ts9e5+kU2Kw7uWFWC/a9SY7cxvLl+CB/RkpWchJR6xW1Xee1V3gHBv0qYrDBAg==
X-Received: by 2002:a17:90b:30c9:: with SMTP id hi9mr5348415pjb.81.1613673629863;
        Thu, 18 Feb 2021 10:40:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e26sm7073365pfm.87.2021.02.18.10.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:40:29 -0800 (PST)
Message-ID: <602eb49d.1c69fb81.c2e43.f1b7@mx.google.com>
Date:   Thu, 18 Feb 2021 10:40:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-gba8c335d38a7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 75 runs,
 2 regressions (v4.14.221-44-gba8c335d38a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 75 runs, 2 regressions (v4.14.221-44-gba8c33=
5d38a7)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-gba8c335d38a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-gba8c335d38a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba8c335d38a7709daef881c6e683fef3a7f930c9 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602e935e9d52104f45addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gba8c335d38a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gba8c335d38a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602e935e9d52104f45add=
cb3
        failing since 72 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602e8186324859e199adde45

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gba8c335d38a7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gba8c335d38a7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602e8186324859e=
199adde4a
        new failure (last pass: v4.14.221-44-g6cf22cf83373)
        2 lines

    2021-02-18 15:02:26.942000+00:00  [   20.552459] usbcore: registered ne=
w interface driver smsc95xx
    2021-02-18 15:02:26.960000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/103
    2021-02-18 15:02:26.969000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
