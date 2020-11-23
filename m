Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E397A2C0E4D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbgKWO7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731120AbgKWO7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 09:59:37 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C191C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:59:36 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w6so15155065pfu.1
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ejh1V78bzyxyXjx7Mfa6m9RsyE+SUcmdqsTRvZpvz9A=;
        b=ynLmBNR4huaPU6tMgp/YL+JZ1T05ueO+IO2+buYlLrLqP+PkK82F9LN2F9vI0kJBCK
         c7eO1cL8HC6WtsZUBvl60BIPxVIm+54szY3eT6kkkLgCgBc2/NEbPdrdRdcc+rDjOdew
         vBQFlJQT+UAPVLlycF+zUKW7vycVI5cqHutYUtOhig3eDdvugq/Qp8Hx6goQI79uX931
         aoZxSarDF6jZt3cP5PuqjbNvI9IGiAP3Sr64mkxFyn59XCLmRw89AD0WPlRmnvZdfsRc
         FxYsn79ZnmAu7CtRKFFYUkKR+o9+g8ZZEIAW4MT6a7hPnFSeSseBsKLjkJ4yHHf3pHRH
         6SSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ejh1V78bzyxyXjx7Mfa6m9RsyE+SUcmdqsTRvZpvz9A=;
        b=j+03bfH7ZccjzKmQu4hG52RXsxHBnXUNgqnrg2kMYIzemk8vKjPkJyW6qqYKblZz1Z
         Z4pAvtjLKy5jozBNiXQBSoq3r1lQXgy2RDkRg6ziz1x64XkJ0PKjE3QIy/Kp4pXLWQjz
         N0u1dDhbd4020NiV86Dts5/sOhIfipj9RDYNyblXs0kwBjyv92lfjL/1VBiBOWOyJTd9
         GzKvhwKbFjTcPpUkRWsluipPVRK+jTwORZTiFfetEFQh9OKGZdx171jihosQHQfZYUt5
         ydePVRGr+zQx2XBhUudsu6eG3zDy5/UHjUv3CN8EYXhl8Z2pI4Szqh8gwzcDu++gvGQn
         pgqg==
X-Gm-Message-State: AOAM533NPOtWsXD/gI1pahq1sUHKqA/UzCmn+w8GZgGyTY4BLcKrLGo/
        SJC/BWWPk13rH6/3NAfJUVRANijH/zES2A==
X-Google-Smtp-Source: ABdhPJwlD+OcgY26PHkKQVKh9XXsjbJJb5fK0DkgXcnRpOLLLd96N5hjUw9Q8FX9YZdGkLnlImPbbg==
X-Received: by 2002:a17:90a:2c47:: with SMTP id p7mr159286pjm.48.1606143575239;
        Mon, 23 Nov 2020 06:59:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1sm11951311pfe.80.2020.11.23.06.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 06:59:34 -0800 (PST)
Message-ID: <5fbbce56.1c69fb81.743d5.a066@mx.google.com>
Date:   Mon, 23 Nov 2020 06:59:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.79-157-g6e58d6dfcba1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 185 runs,
 7 regressions (v5.4.79-157-g6e58d6dfcba1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 185 runs, 7 regressions (v5.4.79-157-g6e58d6d=
fcba1)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-q200        | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.79-157-g6e58d6dfcba1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.79-157-g6e58d6dfcba1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e58d6dfcba1d26d3654ac5201d5c64b71a2fc65 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9bee39c41dd2bad8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9bee39c41dd2bad8d=
90f
        failing since 25 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9b5449a2ce6ac9d8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9b5449a2ce6ac9d8d=
90a
        failing since 3 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-q200        | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbb361df7d2aba3bd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbb361df7d2aba3bd8d=
8fe
        new failure (last pass: v5.4.79-116-gba57a964cea32) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb98f3db879d7b39d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb98f3db879d7b39d8d=
91c
        failing since 9 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb98e5db879d7b39d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb98e5db879d7b39d8d=
8fe
        failing since 9 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9910db879d7b39d8d948

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9910db879d7b39d8d=
949
        failing since 9 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb98837c2175aad8d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.79-15=
7-g6e58d6dfcba1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb98837c2175aad8d8d=
905
        failing since 9 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =20
