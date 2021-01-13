Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEEE2F5509
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 23:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbhAMWme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 17:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbhAMWlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 17:41:31 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53750C0617AA
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 14:40:10 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 11so2165128pfu.4
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 14:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N7yXl5IAALNUWjJ5YmXK44zSvLkPzDi7bzKzoIK1L2U=;
        b=CsOOVXEU2t6T0qRVjo0ce3gV/7emdo5wqkBAVa9BwZDvZbpKryfKuGg4UBg5bPSDbx
         Hk2j/HeaeiQfVgVeZs0ziUbCL8jSCf6PUF22WIYqHJbaV8onRcoJI9OzxnNNknyplKSH
         yPUAp7mAZWCM9CfzJz4+OmoslL6DxgZ9W5oxPoVAT9iyd7MWg4bmNj+AbzkvuO2tOMx9
         lnnEGSnwO21aMtjS8sKfcAyph+ImGHSGC4PJNRk3fjgLL/cR7xNSl609vAxXeJ48NLOf
         4zLWG+qrjZwkaTdwLhbHmHiyaqRkSXwVTHhHjm2i9etCbOiD3nG6QcQivT2zK5Y2fu0K
         JSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N7yXl5IAALNUWjJ5YmXK44zSvLkPzDi7bzKzoIK1L2U=;
        b=ZcHXGnSRUxRjku+PHFeyAacWrL+meBiIVbxKo9xnu63TF25F/tACotpQcYanD/iWN9
         5Q1IeYz2lgmeS55Q/2bWXM1nzcqzWAj4E0XGUO1MP2G4LrllrrJDNjyg2KFD6GmV4l6g
         AiCtTy1LfX6KIwrA5nAqb00r/oMBC2r5wUmj1JkGvw6f+WQwRkFJ502t4nHlijHe+nF9
         MFY2c0Rwueb3zXiCi80L7iuMDIHOs2tPlPHtpjOmGu8zrQIXDqNXgYj66It+lYMxa4io
         qc4bkQhYkErzelWhokwdiHwZQzcy982WKwdxr6hQjqCVeZSQXG4ycHxLl7LGulvgTbw6
         coVg==
X-Gm-Message-State: AOAM533JIXsfyuBbroRmqPIyughVmBJNHTc7KKN1LfojrTQc33Oil/4S
        Ne68a3TCuek4QAeFqrY8Z4uRbQQKva9dYQ==
X-Google-Smtp-Source: ABdhPJxWZLoNeFnGWk+RmgI+fDtcnklyxRbkYreu3agSS4m9BjgtbK+LfohwsnxTv2v2yPFJJtwRvQ==
X-Received: by 2002:a62:1c97:0:b029:1ae:6d94:75c6 with SMTP id c145-20020a621c970000b02901ae6d9475c6mr4275382pfc.34.1610577609484;
        Wed, 13 Jan 2021 14:40:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm3489098pfq.154.2021.01.13.14.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 14:40:08 -0800 (PST)
Message-ID: <5fff76c8.1c69fb81.21337.862e@mx.google.com>
Date:   Wed, 13 Jan 2021 14:40:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.251-7-g381823e73371
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 127 runs,
 8 regressions (v4.9.251-7-g381823e73371)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 127 runs, 8 regressions (v4.9.251-7-g381823e7=
3371)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386            | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =

qemu_i386-uefi       | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.251-7-g381823e73371/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.251-7-g381823e73371
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      381823e733713997ed94858adfafadee36055b4e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3fc49d424e060ac94cca

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fff3fc49d424e0=
60ac94ccf
        failing since 3 days (last pass: v4.9.250-3-gad22df8e1d0e, first fa=
il: v4.9.250-4-g5c199034ff75)
        2 lines

    2021-01-13 18:45:20.230000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3de31f0e46c4ddc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff3de31f0e46c4ddc94=
cc6
        failing since 60 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3de7e9669eb80fc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff3de7e9669eb80fc94=
cc9
        failing since 60 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3de01f0e46c4ddc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff3de01f0e46c4ddc94=
cc3
        failing since 60 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3f7082e6a55456c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff3f7082e6a55456c94=
cba
        failing since 60 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff4b4c94fccd7b60c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff4b4c94fccd7b60c94=
cd4
        failing since 60 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_i386            | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3d0d584b98db2cc94d37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff3d0d584b98db2cc94=
d38
        new failure (last pass: v4.9.250-44-g22c7991bbd2a) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_i386-uefi       | i386 | lab-baylibre    | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff3d0e584b98db2cc94d3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-7=
-g381823e73371/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff3d0e584b98db2cc94=
d3b
        new failure (last pass: v4.9.250-44-g22c7991bbd2a) =

 =20
