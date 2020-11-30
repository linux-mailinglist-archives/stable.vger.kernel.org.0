Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030032C8413
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 13:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgK3M01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 07:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgK3M00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 07:26:26 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E636C0613D2
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 04:25:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id t21so1267028pjw.2
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 04:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xh2jlfsgea7iXGc37FNqJSwXtX4OnjZzwhK8TnNXSzw=;
        b=svrzgoyssFWYFAzJOrfwO9/Uw5myLCRs4IlOHyhx9R7bp0W8wLXvNxG7eDoh/DSpRm
         csCs2xO2v5pBGEi0t4iH0IErtq9/x3NzHgEdbBA1ekTyIJaZa4wGAo+PLOkC/yKqQLiZ
         5hpj9YBjYVC/MTJJ5JLhu3cbAZehV9z59J7OuO+BGe8cnTTCtMwDcgfPNdYX4UTMMCC7
         mlYfTmtxLztFcwqdUtjdoAR1n1OuanLGShsQ9SdecG4AZvxBz5zvinx/xLWsqXRmX8PY
         ciTYtiunpEnOinAjyYHhIe4rWCUVk+9V8EzzyOQCak825GSbVfeMSgYIOokg0SxONDf7
         UJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xh2jlfsgea7iXGc37FNqJSwXtX4OnjZzwhK8TnNXSzw=;
        b=PiY08DAd463gMLRxk7nKYOxW0sIk5G66aN0X680vlz6iMF5mDORYYHwRoPOH4bzVz/
         JpNy2aAVkWpq/m0Lddy9tBUfqSgwQw/Qw7VqXDAPS4rT8SG7aahEr91PtYMSVHXJ1sbs
         uFqSZqkFjlde9TgiF6s74F0qvo3PpjdsbfFmrJRD9MNkzW8szhHonp0r5E1goLlXTAiD
         NvWwS6DvGj/l4RX3dQ7YDV39ttSa6LxEiLKQkv9krd5/FGpKbKqQwPB+RmrQGT9Y8MpV
         iBrAFifd3cep5jrYWvVREaGfTqvURjLOOLcrNYTuuT9nWQY+gCsOpZX9bLRc1o2/JXZY
         hxIQ==
X-Gm-Message-State: AOAM5331f//lq6WiYSCvkBO4HoKReCNDqHJ4Wiu91Ai7Xxip3bJb+3l8
        5hHZb6SPM2xe3EVttmNay+nSqGAaoacFKA==
X-Google-Smtp-Source: ABdhPJzhYr2FZcc08qqPwVkUDA0BMKc8PsAidXw4CSdqSyC/tqq3gS7Pjux+Xfrasq2zP91ix9JFQA==
X-Received: by 2002:a17:902:8341:b029:d8:d123:2297 with SMTP id z1-20020a1709028341b02900d8d1232297mr18485220pln.65.1606739145627;
        Mon, 30 Nov 2020 04:25:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id js9sm1961949pjb.2.2020.11.30.04.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 04:25:44 -0800 (PST)
Message-ID: <5fc4e4c8.1c69fb81.76d36.24ba@mx.google.com>
Date:   Mon, 30 Nov 2020 04:25:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.246-35-g0ffec7e8d748
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 140 runs,
 8 regressions (v4.9.246-35-g0ffec7e8d748)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 140 runs, 8 regressions (v4.9.246-35-g0ffec7e=
8d748)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

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
el/v4.9.246-35-g0ffec7e8d748/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.246-35-g0ffec7e8d748
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ffec7e8d7483bd9d0d137178c2f838793fa2844 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b34681ca881dc6c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b34681ca881dc6c94=
cdf
        new failure (last pass: v4.9.246-35-g7e9c0dd2da61) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b30e1eb3a9a80ac94cd3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc4b30e1eb3a9a=
80ac94cd8
        failing since 2 days (last pass: v4.9.246-2-g124a1dbc39c7, first fa=
il: v4.9.246-5-gcf4f22640d7d)
        2 lines

    2020-11-30 08:53:30.416000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b12691bcc08371c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b12691bcc08371c94=
cc9
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b130c996153ce5c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b130c996153ce5c94=
cd3
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b12d5eba407104c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b12d5eba407104c94=
cd1
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b39099284c2a0fc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b39099284c2a0fc94=
cc6
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b0daeaa125f395c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b0daeaa125f395c94=
cce
        failing since 16 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4b746bd881cf79ec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.246-3=
5-g0ffec7e8d748/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4b746bd881cf79ec94=
cba
        failing since 12 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20
