Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260AB2DF0AC
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 18:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgLSR06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 12:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgLSR05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 12:26:57 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0404C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:26:17 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id f9so3500118pfc.11
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 09:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D+ZgadKUgzP16JGTjoqflR64agreDe2jX5OGAEVg6s8=;
        b=PV9xX0l0tj92KLUUE90GHBX9aBGx+Anuo5lFrz+JZPJ0iG53csqDU4KLeCCRKkEOSR
         WSP8ck7FOUc7WK7HU39IgGrVsE9FwJzev+YkJQC7S5VGXcCtQZ0f9Ycs5fwx7pqtiOat
         ey18nb2aV9o3lul1vMNuS/qObw+VVTaZWTO4l2tyC14LWwDlVvaFZ8Dx2I8y19mqMCuc
         oNB1fiKJuUPzjSZ+/7sqKtOvhp0MjAhjBhuMggvcrOx+VHCP2IkzbvbTBmIz6MZSA1GC
         XwhlLjBUrwf2Ar0mMPb0zajrU9iHQOqwrk47LzQX51qEvHpKBSLY5ZyvD0svuL/vupQr
         4pVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D+ZgadKUgzP16JGTjoqflR64agreDe2jX5OGAEVg6s8=;
        b=RyeVmyedbWE+H/hdffzm11tplZFk/DJGz6LDcUTP9BB1jMPFOclX/LYHWBLYzFptEo
         FiqJRU+6gB3DR1jMTrqX4h1wi9htoCtCfpADzeDnomXUSRMaNlA8iZyLsWahLbMg/snx
         8LAKNMr8OVMJLCLkJe5O1ae2IrqH+I6NH6hrN+MHhmMufMsFZDs6smsTwnpIwl+/N5Kh
         96NjQfqafWXI15Z2NgbaluoYVPKqBzXPRuSnz1CtJ8Lo/B/7WfOm+Mn38w4b7XHYRXNy
         x5327sxICQOgzP1EwBLEosWV3zz0Lmcd1Q+qA5LbHZRqXkGVNbdOIsqacEMOU+qehjgV
         VUvA==
X-Gm-Message-State: AOAM530qbz1Vq3TUiOnnIwujg0ZRb/fpkwuCzCLXHElp740DC6Sb3s/N
        SVxdviFBipWbalaw20cdb0gHM9rWnEYVNw==
X-Google-Smtp-Source: ABdhPJxMDNNJhoolh3a2szWn7ootdfyMaKftTllN6R+qsO5NlRe+B3Da8NL2ImsdalffK3/Bvnsm3w==
X-Received: by 2002:a65:56c6:: with SMTP id w6mr8983549pgs.438.1608398776898;
        Sat, 19 Dec 2020 09:26:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7sm12591356pfr.210.2020.12.19.09.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 09:26:16 -0800 (PST)
Message-ID: <5fde37b8.1c69fb81.84790.1b94@mx.google.com>
Date:   Sat, 19 Dec 2020 09:26:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-26-g45e6bbdf655a5
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 100 runs,
 3 regressions (v4.9.248-26-g45e6bbdf655a5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 100 runs, 3 regressions (v4.9.248-26-g45e6b=
bdf655a5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.248-26-g45e6bbdf655a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.248-26-g45e6bbdf655a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45e6bbdf655a56121b2a4c18e47b40d8154a58fa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde03c8029f529752c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-26-g45e6bbdf655a5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-26-g45e6bbdf655a5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde03c8029f529752c94=
cd4
        failing since 34 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde03d7a075cf0d30c94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-26-g45e6bbdf655a5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-26-g45e6bbdf655a5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde03d7a075cf0d30c94=
cd3
        failing since 34 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde03b5639c68e63ec94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-26-g45e6bbdf655a5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.248=
-26-g45e6bbdf655a5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde03b5639c68e63ec94=
cc9
        failing since 34 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =20
