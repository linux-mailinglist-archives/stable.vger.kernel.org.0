Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96C2DF05F
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgLSQDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 11:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgLSQDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 11:03:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8C8C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:03:02 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m5so3145557pjv.5
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jscy+raazXDnRggJ0dU1gZLZzce/QQ+4Sl6vrTF952c=;
        b=ICrxbfFCyrhDoWTLwxtgx+FZ3S37j/+c5ZReuOgKTeFnFJ37cg1BoacIRbJXiEklWz
         TirE3ThQSTl+OQOuW2rP+cibNcCRm/DfGhaVF8tFaEmhN8BrIDJhk4WIooA//dLJapk+
         fk/HZaipL/1YM/v+plTti36ard2yeKCxwH7H+ev9/4CcHc9bLHlVVdWTVdW1ELl4d2mN
         s9znadUsVjho1Zo8xTcLC5EFZbOArc9FhBNmT2eJyoPl4O8UZcIFAll9XCm9G54RHbIG
         wzkfmIlns9ZUtj9nL3/ciq53bFWV5/sMGQ+QMSXoq5711ob+Gtfc6spYqgI2mfihzcIS
         km3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jscy+raazXDnRggJ0dU1gZLZzce/QQ+4Sl6vrTF952c=;
        b=dmW9AlDVfBADxbiwZy5AnC2nnYlshuYY4brtIDAhoNLlxhiZ/GntU2WY8uiGnYVawc
         MkRgMb+9LA9i8v2Q5ZxMijR24MF1pHCaZOeBBMTqxa+tLQXnDOmQe5VOAA7VvF8WOaOB
         ADpYxgXfvzg5GloZVvFDjgx6BZfr3zTmd/od/2MfgJ6KN/TCBkWX4J/CJYGKhIsx67gl
         P9fvr0R/J6vrL2rScIyzPqq5uVqY5129YA8REESdXRJ8UdD9c6tGmBPjGMOvcrXNeqsd
         5oSPrZGr+UrnXBDDpdB2KRO9c/tkyGTEr5r4IiYzv6S/fhk5ague1j3fq2mI/WQITluc
         XqWg==
X-Gm-Message-State: AOAM530Z+GmsFzNwE475tdgGLU5QBKlFlxFsknEtzwBiMhCTVnQG9J4d
        VNWMViZtI0sCQg3gg2OOd1alZQiscJR3BQ==
X-Google-Smtp-Source: ABdhPJydGLJcUIDG3QvC/0+Rdqcx9WtFONI0a51+wlMrxRsXDVsSYKXk7MTbB07Ay2+DV/N4RpwJDA==
X-Received: by 2002:a17:90a:f28f:: with SMTP id fs15mr9623860pjb.121.1608393781875;
        Sat, 19 Dec 2020 08:03:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w18sm12058183pfj.120.2020.12.19.08.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 08:03:01 -0800 (PST)
Message-ID: <5fde2435.1c69fb81.16c64.01bc@mx.google.com>
Date:   Sat, 19 Dec 2020 08:03:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-55-gcba1195e54487
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 6 regressions (v5.4.83-55-gcba1195e54487)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 6 regressions (v5.4.83-55-gcba1195e=
54487)

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

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.83-55-gcba1195e54487/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.83-55-gcba1195e54487
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cba1195e544874bc8b9b823d3acd894be46c742f =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddef15a354becc21c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddef15a354becc21c94=
ce5
        failing since 29 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddea1974478adf00c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x=
-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x=
-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddea1974478adf00c94=
cc8
        failing since 4 days (last pass: v5.4.83-22-gd980ab12fc40, first fa=
il: v5.4.83-36-g5e3319b6da4d) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddeffbd29bd0ae7cc94d16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddeffbd29bd0ae7cc94=
d17
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf016314052f3b7c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf016314052f3b7c94=
ce2
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddefc84bae95c3d9c94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddefc84bae95c3d9c94=
cdc
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddefc97037c1626cc94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-55=
-gcba1195e54487/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddefc97037c1626cc94=
ce9
        failing since 35 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
