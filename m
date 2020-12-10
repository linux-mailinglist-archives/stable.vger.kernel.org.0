Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697212D66A7
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390360AbgLJThC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390244AbgLJTgw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 14:36:52 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0594C0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 11:36:11 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id q22so5070795pfk.12
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 11:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M0QS/5e+OfwgZFxlUHw+h9aux0wtGaJYa4ASfpsXmXY=;
        b=OQzgnywlCGpfhFH0d/1fLkx5Mo2dQc6zUdXVKHKHsmn21aZnFV7P0sxQERiJalQC6z
         Jn+o1D3CHcY0FtnVSJREhr/kfNwQ/DxP4Sb9OK4NXyXbsISWgY+xTAKjXm/HFVg7+DOm
         MK2yb53wbVfpxdBLa/pmIR2AT99Dkj6IH5zwQxQfnvsqLWzAh1HhiIs1dhteNH0F/JPN
         s3EB4HdRww8kvgB6hlOOAcdfRLZ3jCJ5qJRm3G6iIXdLHvKPmFDGb7FmM/MULkpjJA7I
         xgK0XXxG+wDdrQUvXMlfneKNEEJEvG4vn6BoiDGsc+XItmIwhZN9gDliflG8Kmk8o905
         vl+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M0QS/5e+OfwgZFxlUHw+h9aux0wtGaJYa4ASfpsXmXY=;
        b=IKnVgwWdaOaOdeBJdHunAXbkL1BL/D0DnNLtkjZPkUtOAdvP2uhrHn+1rjxqJAOJxe
         zEvrSMFzbDnKWTTWxYgcbeJbRXpZrg9Ee4MCNlrYtcB5hI0wIx71rPwIlcYkgjqn8nze
         7oLPoQgrUVBfzEocirmJN1EiBm/CGNqiA34daeiUXiptMksDVwg3yK9otvKcNGgO/lIM
         H3g6h5CK1NFnjOk59OjcGM60G5U+xTjN8GEzv01jHYTTQs8Aj0/LBgrl0BSnuut4cNyP
         1bACH/m4PEV1R6mYgSRqUIMfNj/KpfZn2K4Ot7WmGd1TNUx5j3+WLysIHEgZTranZ0u+
         Hhmw==
X-Gm-Message-State: AOAM532tF7GSD/uiQ24Da9aGhsmYmdVS1ARObaZsK4iJjFnOqJIUWpiN
        3YMDJ4mRCBDtWIUCkKBxTbxC0ibJ/pG0Kw==
X-Google-Smtp-Source: ABdhPJzAIg2p79s1M5Oof1GJ06ly9V7fYmt0v4kz/yDNEb6cMSpuP/PmX7WoawtZVyk6i7krNDX2lg==
X-Received: by 2002:a62:524a:0:b029:19e:a3c8:80f5 with SMTP id g71-20020a62524a0000b029019ea3c880f5mr6763373pfb.52.1607628970895;
        Thu, 10 Dec 2020 11:36:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s65sm6766329pgb.78.2020.12.10.11.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 11:36:10 -0800 (PST)
Message-ID: <5fd278aa.1c69fb81.f8b0a.cbbc@mx.google.com>
Date:   Thu, 10 Dec 2020 11:36:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162-39-gf9a489c417aa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 125 runs,
 3 regressions (v4.19.162-39-gf9a489c417aa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 125 runs, 3 regressions (v4.19.162-39-gf9a48=
9c417aa)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.162-39-gf9a489c417aa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.162-39-gf9a489c417aa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9a489c417aa489138cc01d5aa4da21be2dbcd52 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2442efa5826a0a0c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-39-gf9a489c417aa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-39-gf9a489c417aa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2442efa5826a0a0c94=
cc7
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd24439fa5826a0a0c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-39-gf9a489c417aa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-39-gf9a489c417aa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd24439fa5826a0a0c94=
cd3
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd24428fa5826a0a0c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-39-gf9a489c417aa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-39-gf9a489c417aa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd24428fa5826a0a0c94=
cbe
        failing since 26 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
