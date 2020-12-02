Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C572D2CC0CA
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 16:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgLBP1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 10:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgLBP1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 10:27:01 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD034C0613D4
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 07:26:21 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id w16so1265935pga.9
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 07:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qlH3dTJMBvFSyl3pJLOOyGSzNxWuz1+oJzLPjMlEgmE=;
        b=WZfgmWv9eeKH57XEG51lIrqBED6Hz27+zC9k+fFafVcvFWiulEptR9nRlI0B9vxFiR
         I4BDXSV4F8nv4ToO6bQvWsH3eiAQGakAKNQjss4+Sd/aUUjZKIN0T3XMWvZUAnlkdqfO
         QziI98oqNPh3As3lM68j1jYbyUVJA+etkXGLRhF0F+6n++YtrrmDdsG3BbZiyyT5hHQA
         xuGW8NnjVSCUP1aaXoF2qZ6Y/H+jrl7NuebpYP6DD7FiEYcox5kNlg4EGrfK8WtYPamW
         AqYmA4N9mL6k8rl4oRFNm2vnJ4zTISz4V8oCFyjdWUvXYch+ElxlrxGG4OK4Gz46X5OF
         atjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qlH3dTJMBvFSyl3pJLOOyGSzNxWuz1+oJzLPjMlEgmE=;
        b=dDT8dqZyhrjXKpy0TtnjGsb5tnbe3Z8vS+CNJ/ZqdhCOEjs8nGmg8iZuv1u/wYwgYj
         fPdpixaY6zbL9cxo0WlLUVELbtIbogMw/a0jIWx7lUUbKUh2ULzJFR1tqv/IuTQmm3NC
         i9xX+9B77EKD08cXDtB8brvbi6lzB4oqeDEQqlmFZxouNeZ9iujr2iyJGTuZX/gUIKTi
         TSOoWVr8byiOGxUwKHLIAa6Vxue32mcgsb25r+5A4a7TGf269RtItX5YSo2QO8d4K625
         nZsCGWXPXIgaH4SXt0MMgJ1AcfXq7NU89wqrdc6d8uXsP/NmLzStJ5VUcklECc1e6Bnb
         EOZw==
X-Gm-Message-State: AOAM530sRIdIDz9wk9OmNMjB+PRAkOLjqnpNHay5cmx8bjVS2CW316Q2
        jOyBQnPlwgc7PPz0HuLXUFD0JqzMMyWW9w==
X-Google-Smtp-Source: ABdhPJxok/foSr1MeT94tD9Oe0g7cmTr7gUbx8GvqBtOSMqJGkjLOqQv475E4Tl6bMGi8uIuq5zpeg==
X-Received: by 2002:a65:68da:: with SMTP id k26mr312678pgt.303.1606922780877;
        Wed, 02 Dec 2020 07:26:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n11sm121790pjf.1.2020.12.02.07.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 07:26:20 -0800 (PST)
Message-ID: <5fc7b21c.1c69fb81.4936b.04ab@mx.google.com>
Date:   Wed, 02 Dec 2020 07:26:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 53 runs, 6 regressions (v4.9.247)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 53 runs, 6 regressions (v4.9.247)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.247/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.247
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d55c2adbefeb2d49d16891ed8ca8d03789fd31b =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc756b5fe3bc33029c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc756b5fe3bc33029c94=
cd3
        failing since 17 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc759aa18520a56c1c94cf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc759aa18520a56c1c94=
cf3
        failing since 17 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc75b1c63eabb3639c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc75b1c63eabb3639c94=
ccd
        failing since 17 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7641e5764e9f80fc94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7641e5764e9f80fc94=
cd0
        failing since 17 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b1f8cc2fe1a9e8c94d3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b1f8cc2fe1a9e8c94=
d3c
        failing since 17 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc753adf54fc62834c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc753adf54fc62834c94=
cc9
        failing since 14 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
