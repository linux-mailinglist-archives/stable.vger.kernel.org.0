Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78CF2C94EC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 02:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgLAB7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 20:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgLAB7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 20:59:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC2AC0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 17:58:32 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j13so253169pjz.3
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 17:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LEhfv0mkAvS0Rop7Cd9gorFvAaqB6O181ose16QBl48=;
        b=0obp2D9H0cL5QMuUY5ha3fZEvvyxuPgAx5AhzfQAHcANJrTtiJ3Gl+dWw35FtprpMq
         ZhchWx6wRZaBKBbk6nE/ghjZ0H/m41Y6vwIExdd51tKH5XSvRHjKEk6nBRzB4QrEFKkV
         vBo6Fq4pDHp/tSZuBc4zMNlf5Q16z8trGgD754/VufQV5Ft71ua5tRM1iDp0Ca0elWk9
         0VygOfH083cafaMB840QLMhF9+YMTFfnFdcC2kZAlbji/cJH5t7hSYf7hkGlH1ia00K7
         BPGRj+vvpF4GrxHpa1qfvy5W1kGqy5RZ92wZAx1E/La1B9Knk4UojRozEELxKaBRsQCj
         3NqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LEhfv0mkAvS0Rop7Cd9gorFvAaqB6O181ose16QBl48=;
        b=tByv08T8Pkha6BiaXOkzXMPeikbUz5IuOnpDMXlzVU8oTlxhWD1po/AWdLqQm1MqlR
         7ur/H+aTmGSRQetBSemFBH13nk8zNIhOWTUlbCnjs6E87zjNonh2AqSjFUAShU/9fEAh
         mdNeLSmBX0adfKsG8pzr7inpTMVMWbL2FB4NuxBtBe7YskrJsn7j3/1IgbtaoDLBKyGK
         ZT9mUzYWTYB1SsUeEVOdDZzpvoP59BhLoq0tBCIXOdpTULQaTF/jrZ5mHy5IIjZbwh46
         Wd503zpbJ6uSxzd+GTKsGzWQsT1NlLFWz6xQpaPLZ+ZSsGgNzdoBWKiT3ePnvSkp/5j2
         vjuQ==
X-Gm-Message-State: AOAM532m13iENDtdi6CwLNrRZFMvu0QxZDMKDf4L7mTVsUamjWFoHr6d
        M2mjqUcGOxwoDl30Sx5OFo+VQmZgLj/55Q==
X-Google-Smtp-Source: ABdhPJzV8wo511XrGFVJJXS4NdzQsFMUjYS3IVGH99IlnPDZe+4HJCIJk7EEaDSTdLp1BGBLkYonVw==
X-Received: by 2002:a17:90a:d3c2:: with SMTP id d2mr247127pjw.221.1606787911526;
        Mon, 30 Nov 2020 17:58:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c2sm263548pfb.196.2020.11.30.17.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 17:58:30 -0800 (PST)
Message-ID: <5fc5a346.1c69fb81.11281.0e20@mx.google.com>
Date:   Mon, 30 Nov 2020 17:58:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.246-39-gdf4d70323c7e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 140 runs,
 7 regressions (v4.9.246-39-gdf4d70323c7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 140 runs, 7 regressions (v4.9.246-39-gdf4d703=
23c7e)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

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

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.246-39-gdf4d70323c7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.246-39-gdf4d70323c7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df4d70323c7e015dd90830d31499891c35bcec0f =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc5709a5971c6e0bac94cba

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc5709a5971c6e=
0bac94cbf
        failing since 3 days (last pass: v4.9.246-2-g124a1dbc39c7, first fa=
il: v4.9.246-5-gcf4f22640d7d)
        2 lines

    2020-11-30 22:22:14.514000+00:00   udevd/128
    2020-11-30 22:22:14.524000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2020-11-30 22:22:14.539000+00:00  [   20.419067] smsc95xx v1.0.5   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc56f8f254bae76adc94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc56f8f254bae76adc94=
cbe
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc572017315af5ec5c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc572017315af5ec5c94=
cde
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc57099353793185ac94d11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc57099353793185ac94=
d12
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc57929927667acc7c94d20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc57929927667acc7c94=
d21
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc56f07cf1a125401c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc56f07cf1a125401c94=
cdb
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc570eb8361d8e724c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
9-gdf4d70323c7e/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc570eb8361d8e724c94=
cc5
        failing since 12 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20
