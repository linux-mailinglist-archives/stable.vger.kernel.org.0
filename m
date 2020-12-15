Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81A12DA87F
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 08:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgLOH03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 02:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLOH0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 02:26:22 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E44C06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 23:25:42 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id h186so3483649pfe.0
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 23:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I5hOl0l/7i7gyhyhAgrAZcyRz3ADUzaDQuRzDsgepWk=;
        b=rCTjJLrAbOcrAaXXIm0rO/TmwNHOUeVNTUnqn11Lyjs2CmqBYDTcm7wf5kb0wWQXtx
         yaA1a6hAhXS1C/PTbmdqrTolp263tkXJqyQxAwPe2fIbXBhta4KnE/HT0h2RQF4AVGvL
         X1CA42opuDMV9PTQ4Mum6gJMOkuuGuK4dRuDRaytUXH4+Vayp7ZnlI3cABEuJqqZ6ilF
         JkrFi3QBKF2sdw7wOfUMFGZPrTEMJ5noMT55VN4fx6rzkT/Pk/93DrysU9rTpLMtZGGJ
         DjzAZ5oR1L5jAqq1SYGzbbflmI3lLN4ElVAt8J7MdL4qfKJLLUS7zk11+bfN15pgv+cU
         o3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I5hOl0l/7i7gyhyhAgrAZcyRz3ADUzaDQuRzDsgepWk=;
        b=JVt0alSEmEZvORv+bfcTY81VsI56nUuSPeDzJaKoMurYHJwV9+9yYJ/0Hoe8nNXkKf
         WZQ7QRZm6gRgIzOv5b83OUbIsjJWMRupvZufmpXizwLmnLbwTU18kle8F+QnqE1HXfKN
         gp6um4+6BIMUNaX4JpPkdiv+SOaYJmiwWsGmoT4JRoMKuz7535qnetTXxPDGAkzA1sxT
         QtSCbCn3c1S8lsdQtHhQWYVz0BU5o/VIKQYmdyq4D+8GMK/WTIKC4ilowmamHjDvTkaI
         Zi9qxK2Qv4t1woY9HDlvY/bBVv667cP/SDZf/ifQZROjuxRtJYeg+TWfJssdSSAzGChz
         DU3A==
X-Gm-Message-State: AOAM533by5M6Z+/A1A4k6zgaLnc0tpW5nw1Ro4RwF8e0P1BokifiOS8R
        M8s+6kCWYSNbhNoF0blyLVyZgRysb/PYGA==
X-Google-Smtp-Source: ABdhPJzJ93kU4Lj7SOh4qk3YgOO8DP9G3AEkwWbhoOEOfesYiL143kMW0Xn9EWkxdDbH9sy+lNrxYQ==
X-Received: by 2002:a62:37c4:0:b029:197:bfa9:2078 with SMTP id e187-20020a6237c40000b0290197bfa92078mr114570pfa.15.1608017141546;
        Mon, 14 Dec 2020 23:25:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e29sm22409896pfj.174.2020.12.14.23.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 23:25:40 -0800 (PST)
Message-ID: <5fd864f4.1c69fb81.5fa77.eee8@mx.google.com>
Date:   Mon, 14 Dec 2020 23:25:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-37-gfbaf54ae613a4
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 143 runs,
 5 regressions (v5.4.83-37-gfbaf54ae613a4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 143 runs, 5 regressions (v5.4.83-37-gfbaf54=
ae613a4)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.83-37-gfbaf54ae613a4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.83-37-gfbaf54ae613a4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbaf54ae613a47a62193642683ab9f23997aaa50 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd8307b253fa2be8ac94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd8307b253fa2be8ac94=
ccb
        failing since 24 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82f244a4b4e0498c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82f244a4b4e0498c94=
cbd
        new failure (last pass: v5.4.83) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd8323f44dd43f448c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd8323f44dd43f448c94=
cc9
        failing since 30 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd8323e4c0a12a6f1c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd8323e4c0a12a6f1c94=
ccf
        failing since 30 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd86374943612c764c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83-=
37-gfbaf54ae613a4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd86374943612c764c94=
cba
        failing since 30 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
