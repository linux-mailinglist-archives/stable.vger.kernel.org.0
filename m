Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6A82DA81B
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 07:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgLOG3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 01:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgLOG3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 01:29:24 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7682FC06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:28:44 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t22so4475736pfl.3
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UnG4Rhf2BpbyLmVgM4IFCV8Q9R0cL7oeq8u+m7uaDZg=;
        b=VMkY5MAUsrwOaG8sjBriwfT4JB2AakQ9GpIuWhmY/a3Z4qpAmp/eoxSZs2nYrBep72
         CgG4qGTBMBFA/6oR3TjKl+L+zmiB+ZohYCWfCiIHAVrGVTi48CuSiJZ67h6+sRwdGZ/U
         x/unD3TnJK5Of2H5RfWiRKZWzASvBYEXF1nccfbck89AFuZ+TKaJosMsrTe+iNA1HKEA
         CTedFTf0rPWACtmwi3qYsuk7QKLGIAseELrJfUmqMXpdPsGoAi6ozgkXV2q8FN8Wkx2P
         0t/2F0nCpBmVjGCVRjKNjTu1zIAuaLqDNymG/v4FdSLFHukaJsQY1zuQlbCtBFVCAlJp
         dxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UnG4Rhf2BpbyLmVgM4IFCV8Q9R0cL7oeq8u+m7uaDZg=;
        b=ho05gSfzJiS9mdt+vcJ7578U9/LJbK2kGIMrMRezFCjNAAGfU+wNZBSiYjUGiGfZJA
         KdK1isGhwC9LYv/ykEYCb0EkQlkBohIyPy91ZJ1RJkZE4vbMn6jqTz9Y71J6BcDDiOn8
         MSxfgEsnKY5iIqbu1VhFA5UvQccF1K28zzrKwiwIDxGwaw1F+ia6KsSBZ6dohuszO4IH
         v4avDfW4p72O8DlsGQs/CEMmhR48DGNQwBJRmSDbJeXNW9Yfb5r9LbViQMexj4VAfjlH
         QDyyynUmXT3XA35dDg/ea63gdsZlbVAlU266x0TWO3bdO6PKOOJqfdw3VjO36OEavO2d
         Fm9Q==
X-Gm-Message-State: AOAM533UrYw6Zermwtc//LUwjOtpX0w4iDfLB18tdneZAJd+RVed3dRw
        2oHaNBkhWD999nNLmrLsEvk7hkkrkDLvvA==
X-Google-Smtp-Source: ABdhPJxBKRwnmC+3WYsQYTWWOrSZ6usUDGI5d5+Qi/MDk36cPNbIOZCWTCLe6JFgyYJFW3N1hmleMg==
X-Received: by 2002:aa7:80d5:0:b029:1a3:832a:1fd0 with SMTP id a21-20020aa780d50000b02901a3832a1fd0mr13134698pfn.6.1608013723573;
        Mon, 14 Dec 2020 22:28:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11sm21519247pjg.46.2020.12.14.22.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:28:42 -0800 (PST)
Message-ID: <5fd8579a.1c69fb81.15cb0.ceab@mx.google.com>
Date:   Mon, 14 Dec 2020 22:28:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-36-g5e3319b6da4d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 139 runs,
 5 regressions (v5.4.83-36-g5e3319b6da4d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 139 runs, 5 regressions (v5.4.83-36-g5e3319b6=
da4d)

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

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.83-36-g5e3319b6da4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.83-36-g5e3319b6da4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e3319b6da4dfc34d195be6eaf4d268d49181ad3 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd822a69a9386e608c94cf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd822a69a9386e608c94=
cf3
        failing since 24 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd822aab885446820c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd822aab885446820c94=
cba
        new failure (last pass: v5.4.83-22-gd980ab12fc40) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd8240a5d432a98fbc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd8240a5d432a98fbc94=
cba
        failing since 31 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd82402f758ec2c2ac94cf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd82402f758ec2c2ac94=
cfa
        failing since 31 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd85293c0c06157a3c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-36=
-g5e3319b6da4d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd85293c0c06157a3c94=
cbe
        failing since 31 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
