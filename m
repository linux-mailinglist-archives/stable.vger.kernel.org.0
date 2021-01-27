Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F55F30617C
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 18:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhA0RCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 12:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbhA0RAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 12:00:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABBBC061756
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:59:51 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id u4so1734572pjn.4
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 08:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W+itvWsMn985O0xmR0A7kyUeuqb69CkYvbtuVLrWm+8=;
        b=VJEZQTTwbsrfBlKYLCAhHNhSCZj+gY/BNrj/2Yi2dyG7Xw3MUUcFrByYl/v9Ab1rjk
         7ThtPBxEMSIFNOueCCSNYn2IA42VIrFadNEBRNaxIbsxcOKGs4aDB8T4SLbjSz2/hqlp
         FZl3WtqgnIiIY4VRF5StdfJAt6vzGHBqSiOScWDCBbejnVu+9IhvlGih0bPDLAtv6e0Z
         rjKMrfytyPoMQaq3x2+dL4+fUEJKnT48xSfvrcVbIVivr6JJ0SdF5sr/1lFiuFkAiz3q
         XRaS0fjWotodVoYfG5FcYohFxdbe9Y+R23Yugvd6oBeuS9iMQCs+dB3kw22Q9jfIi64C
         Cqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W+itvWsMn985O0xmR0A7kyUeuqb69CkYvbtuVLrWm+8=;
        b=NZWGnyo/xnWkiAJIejfMTR2vAhUq2vHii6GnFx2lJM+x+yjCSZg/PRJBI2bRa//0rY
         IrOob1vrovWbzL6jMfO5+cuvv/1xhjbRszxbOyi+H6ITmSmakSZQdRsyAA2Od4Qo66fg
         GVNZ5NWnYuFSAxFS6hplG3+YNJdeUsTD20TlfTxjeYVewu+Ouu0U3A9rVclEXuYVo/6r
         3fDxRXXQBPwju6UoSd7mgzed/2rhwzP/EmcGztV4/hJV7Y2Yc04QNrDoAk+bxy5BMGyf
         F3UybkjytNZsqwQfQceqjIIxXh9ZhFIGpY6W1ucCG59+Gzin24NVNNcX/QVruEPsxQEU
         7GKQ==
X-Gm-Message-State: AOAM531rrCEdoy+qaxnrxewf/bhv+MLXs7QK8NxxVXoDqY4lUVWekK/v
        CDLIojIgtPkOOOMk9EvPOexLKuKcFsvscP+k
X-Google-Smtp-Source: ABdhPJzkYdCrb9UviakJFOgL7rJjTYF6CMmScus8vMw19enRnQA4UHQEniEbq7iL4eKvRgF5ky0DZw==
X-Received: by 2002:a17:902:ed88:b029:de:86f9:3e09 with SMTP id e8-20020a170902ed88b02900de86f93e09mr12151698plj.38.1611766789650;
        Wed, 27 Jan 2021 08:59:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j198sm612185pfd.71.2021.01.27.08.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:59:48 -0800 (PST)
Message-ID: <60119c04.1c69fb81.cd41c.1642@mx.google.com>
Date:   Wed, 27 Jan 2021 08:59:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.92-87-g06149f11a09b7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 171 runs,
 6 regressions (v5.4.92-87-g06149f11a09b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 171 runs, 6 regressions (v5.4.92-87-g06149f11=
a09b7)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
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
el/v5.4.92-87-g06149f11a09b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.92-87-g06149f11a09b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06149f11a09b76cea974433bd2c179a891df6b9c =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/601163d6f94960729ad3dfff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601163d6f94960729ad3e=
000
        failing since 68 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6011661facc183a131d3dfe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-khada=
s-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-khada=
s-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011661facc183a131d3d=
fe2
        new failure (last pass: v5.4.92-87-g16671f282756) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601162f42c56723a36d3dfe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601162f42c56723a36d3d=
fe5
        failing since 74 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6011630d459b7e35e7d3dff5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011630d459b7e35e7d3d=
ff6
        failing since 74 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601163051c978203eed3e0d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601163051c978203eed3e=
0d6
        failing since 74 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601162b7efc13582a9d3dff8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.92-87=
-g06149f11a09b7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601162b7efc13582a9d3d=
ff9
        failing since 74 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
