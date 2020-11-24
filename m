Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3682C1FC8
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 09:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgKXIWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 03:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbgKXIWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 03:22:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DC3C0613CF
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:22:18 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v21so9061306plo.12
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 00:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SuQcJKrtC4Cq+N/04ylOsn+LDrK0PzGxeJYJ3wcx4JU=;
        b=ufXSBF+mPmVov7bCf7eAqTajomYcGrmgzBfRkjSccJldKrvWTP8zQD8H/T5HVvxQVR
         JVQgXHlpDvbIO/J+4HSXW1X0RbOMbGxuASMgTZ9XUrG22N8BuyhMTeDRI09/w554aQZY
         wBveX0o9HKGB5KR8W0rSNZUPWARVZ7XSqGxSOSmptu7KfCi/USFmvyJtoWsb/gxBhLwZ
         JEaLNrtQaGmEWGTQnwZtXwQ/9/DPe690DDy9yLIBNMDkZ600ttmY5l63CBp7xroExVG1
         IHTtdzAUrErS382z9MtYV9HJVLcnflEQgUAng1POD92P7u+iStN/g1Sh5OMNim7O0+ye
         0CGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SuQcJKrtC4Cq+N/04ylOsn+LDrK0PzGxeJYJ3wcx4JU=;
        b=ZxrHHyQTyfewcpN5RHo8/BNBSMKkdI4Ga4yyxtHW9TlnSkGlAKTWsvE/vLKuuGUU5v
         n2DATSwffQh+XmBvjedp4EQbnhaaiudKkoUIBY21/ZWM4XYPxUqFZGDc4687bsBw+f7z
         Dnu1WS+fXGWzrD7wZ3vfL2x+r8XsC6SXtOuh/D01csYk3xXMFVV3dkjPTB8gP/140HXR
         0c4vAypS/vWPzwt2IWJTQ3w1Cr9hp3N+OBvaI75IZHNs94ZZgPU1Q7mnVEORiQZQgVHn
         kU+YkNeEwku7095RdzrnNxeAtgVHFs587dmq34S/ySJbjY3aAJkZUoE8mfSPq6SvBtCy
         RQoA==
X-Gm-Message-State: AOAM5310gq+H73l9w+Jb3IsyTcd697BF0w11IUVWpEFe8/JNsQxD8jbU
        nSCggI79kY+YlmFLBN9v8zR1R3YhohmWHg==
X-Google-Smtp-Source: ABdhPJyw3gR5xo52tq7qdqQDVoL/361lB6b9oAZxdD4jUi6TiLlMzuGfNeIs+cBgpsIRLi/gwmbqgg==
X-Received: by 2002:a17:902:b18c:b029:d9:f:15fc with SMTP id s12-20020a170902b18cb02900d9000f15fcmr3082325plr.29.1606206138144;
        Tue, 24 Nov 2020 00:22:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm13941810pfo.46.2020.11.24.00.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 00:22:17 -0800 (PST)
Message-ID: <5fbcc2b9.1c69fb81.dfe94.03bd@mx.google.com>
Date:   Tue, 24 Nov 2020 00:22:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.208-60-gb76a43507589
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 124 runs,
 4 regressions (v4.14.208-60-gb76a43507589)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 124 runs, 4 regressions (v4.14.208-60-gb76a4=
3507589)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.208-60-gb76a43507589/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.208-60-gb76a43507589
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b76a43507589da9885bb251034148451f2bb7539 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbc8c83f1b97ab73bc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbc8c83f1b97ab73bc94=
cc3
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbc8c85f1b97ab73bc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbc8c85f1b97ab73bc94=
ccf
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbc8c78010f78c8ccc94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbc8c78010f78c8ccc94=
cbe
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbc93239707be1a46c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.208=
-60-gb76a43507589/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbc93239707be1a46c94=
cc8
        failing since 10 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
