Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E5E2B28AD
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 23:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgKMWkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 17:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKMWkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 17:40:39 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAC0C0613D1
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 14:40:39 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g7so8862201pfc.2
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 14:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cUfTJqOL+6JvLcp/44ZBPTmAXsSfhV97Q0pq2UjFKfg=;
        b=X1oVhSWotDqZIrbKwBJtvRBJaOACz+wng5UHJHLxZTHl2ejv7k0eoFQ3yM2+cZjKBQ
         jFUCNQtL2tAF1ZQYjwJvRx9N6bcwGcOBv2MhQv3WGzgTFE6LHwpJI6UW9sjlvgHxvJ1p
         hJPcpYb6/9vu2LfiOQ9B5mBOpj7BDUpifNsAT1LfJYmLOfL2OIN/e6fDQzvc+747F8Qv
         vkzOK5Ux5R7fSjeFC7GSDE8EmomU/WtZYJf7D1Ab+X2Aoa7GGIK+k4gSm7DIuhQgN8KR
         5IkiJcHrLxzQCEgJzR6bSYjQa912BXXR84D3RCLJmkOmNZO7mj7y/wY6hxVQQqhNvG5+
         efYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cUfTJqOL+6JvLcp/44ZBPTmAXsSfhV97Q0pq2UjFKfg=;
        b=M5ImwSpjC1tRKSLaLjR5x5Q2Ogr/kX5sfC1UFkM7rFqlQ5XuCm43eDBifC9BSbY1y1
         Arr60W+sYIQumAUT6Kh49AmYiOPy6eqrRREN9eFVmn6B8JSVcgCgmHHmfWt1YvlHCeJP
         XjSG6xvfRbJDWM5TmUgbhV8bGSjzg4XlmznmMgRRAk8SadWww4mrGW3h5akyJSTmlXVU
         qxm/p6Fg7ao7FNSvhy8ckxeKvaNnpaXl8LXQsNPxtrFnw1L/6+ou4/AMEdYpns7lDQJT
         ZxTDkWvwYAqjblGyCRJHHqBoVu1otzYSD4PdIWgK1RgivZN4tSJV3xWGIukykte4g4Y5
         YQRQ==
X-Gm-Message-State: AOAM531nm8XNyyMc/+uM/UJocWUnG31KqlCMYk/84DC8w58PTV7DkQVd
        iufLTidS4CCULUGSmnTNunLoQ0LC45cwIQ==
X-Google-Smtp-Source: ABdhPJwynrEfkuQWehHRsyhQEPS6j1ajQ1L0PYj25J6p4jDbL/RyJk+98BNGfOp99h+GxLAaWaSoig==
X-Received: by 2002:a63:ca0a:: with SMTP id n10mr3619900pgi.326.1605307238207;
        Fri, 13 Nov 2020 14:40:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e14sm9251824pgv.64.2020.11.13.14.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 14:40:37 -0800 (PST)
Message-ID: <5faf0b65.1c69fb81.dce7e.37a9@mx.google.com>
Date:   Fri, 13 Nov 2020 14:40:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.77-45-gfd610189f77e1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 208 runs,
 7 regressions (v5.4.77-45-gfd610189f77e1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 208 runs, 7 regressions (v5.4.77-45-gfd610189=
f77e1)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.77-45-gfd610189f77e1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.77-45-gfd610189f77e1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd610189f77e1ce3736622c4bbf7e22201da4ad9 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5faed4f21bb3e66efc79b9ae

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5faed4f21bb3e66e=
fc79b9b3
        new failure (last pass: v5.4.77-44-gce6b18c3a8969)
        2 lines

    2020-11-13 18:46:11.074000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-13 18:46:11.074000+00:00  (user:khilman) is already connected
    2020-11-13 18:46:26.401000+00:00  =00
    2020-11-13 18:46:26.401000+00:00  =

    2020-11-13 18:46:26.401000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-13 18:46:26.401000+00:00  =

    2020-11-13 18:46:26.402000+00:00  DRAM:  948 MiB
    2020-11-13 18:46:26.417000+00:00  RPI 3 Model B (0xa02082)
    2020-11-13 18:46:26.503000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-13 18:46:26.535000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5faecf56c7df50f46579b8ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faecf56c7df50f46579b=
8ad
        new failure (last pass: v5.4.77-44-gce6b18c3a8969) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faed1c6bec5a6136779b89e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faed1c6bec5a6136779b=
89f
        new failure (last pass: v5.4.77-44-gce6b18c3a8969) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faed1cd4df5f64f1b79b8a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faed1cd4df5f64f1b79b=
8a3
        new failure (last pass: v5.4.77-44-gce6b18c3a8969) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faed1d20a912790e679b8aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faed1d20a912790e679b=
8ab
        new failure (last pass: v5.4.77-44-gce6b18c3a8969) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faed190f6950e347379b8b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faed190f6950e347379b=
8ba
        new failure (last pass: v5.4.77-44-gce6b18c3a8969) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faed17bf6950e347379b8b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-gfd610189f77e1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faed17bf6950e347379b=
8b3
        new failure (last pass: v5.4.77-44-gce6b18c3a8969) =

 =20
