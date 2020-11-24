Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92D62C30C3
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 20:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgKXTcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 14:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgKXTcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 14:32:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A820FC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 11:32:24 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 62so47947pgg.12
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 11:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ejRNJF76cszhyAm1j5VmRIhLAELF+P/IPTREo6xLOAo=;
        b=EQbGioZGeYX3nzVH8Nx5dF+Bye6JHUs78ejs2Vo0aaL/nN6fPxsMAaKinPbHsvtEAi
         X2KeHYSSbSVx1HrCqKcVNtrrGHIahXsyddNHEXXc2i4/l7OQaruGm4hU2Vxod091wDN0
         YK81Bq+P8JRxC6+7JFo6K8xRfnzY75W+7Q7FyQ+HQJrAgLV53Ja7zr2O21oGby9SGCAH
         g3gOlPg4gvkadK+8RKZldZKcnJOiix9aC0jlub4WId+kJsYZMJo5EnPgP7L/fE1NJHV4
         UxL9o1Vd/lOILyKnRtaKB7zgbbVafwtvewN2schwdaOIf0DcrqhiHF+aYxA7J5C8jkcQ
         jaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ejRNJF76cszhyAm1j5VmRIhLAELF+P/IPTREo6xLOAo=;
        b=e0O2dqHmwok2+5wiWG15Oe2o/cPygidkKqfhd4DGM70D2e/e5BRhLg3ibiKwLLFavv
         CiVQR17AfnBPu9w/ppMA+A9t/eXoVHyxZsRIGto2fl/5LtdeMCWpaiiW6MzpiWACYMc4
         rAxWL/a9UX1hfyzzYUALhET2nccjq1ABsk0z34KWl4VOGoCbz48zKhuaZCeVFKbRBUyw
         Gz/qldnsFh1ULd+Qa3DcHp7Wwzv8PZHYJ6MZJTqeuWJZ0guOrpBxs13vwOIfsnZ3zesc
         X6QTKc0EhH0Wn5esQSmUK5jGCQtFRLVBxmpWswcwUoBh2npI7acUWbAt82sw8ohRkZVX
         pa3Q==
X-Gm-Message-State: AOAM532cmNekH6WfXH44Np4eJk2w1RTFe/C0Sito/jCSuScqtS7EjRfq
        d+JhaC5lHxtZ13/+oydGE87XP+55wBbA/w==
X-Google-Smtp-Source: ABdhPJw2S2K9Rq2XyfBW+ljuvBWQwXvw/88sfbyt5eD7NVNG29M+aiOwDryyHCDh6C39sjIcV32rcA==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr156060pjb.110.1606246343938;
        Tue, 24 Nov 2020 11:32:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm20859pgl.83.2020.11.24.11.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 11:32:22 -0800 (PST)
Message-ID: <5fbd5fc6.1c69fb81.02d2.0120@mx.google.com>
Date:   Tue, 24 Nov 2020 11:32:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.160
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 169 runs, 4 regressions (v4.19.160)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 169 runs, 4 regressions (v4.19.160)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.160/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.160
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0c88e405c97ed1828443b67891e6d4bb6e56cd4e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd2ad383f824b589c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd2ad383f824b589c94=
cd0
        failing since 5 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd2aebf9be0e9236c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd2aebf9be0e9236c94=
ce2
        failing since 5 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd2afb669240bd37c94cf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd2afb669240bd37c94=
cf7
        failing since 5 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd2a92756589c87ec94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.160/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd2a92756589c87ec94=
cc4
        failing since 5 days (last pass: v4.19.157, first fail: v4.19.158) =

 =20
