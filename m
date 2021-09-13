Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7882A4097D8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343883AbhIMPwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbhIMPwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:52:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8714DC061A11
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:41:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n18so6089198plp.7
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 08:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ie6HdrYjO4KdOTbwSmnSxG1WqGKl14BJoaMIocB5nvc=;
        b=HYYfRrMsqaHSPMqSaUGCthkAj3LZY+auU1QP4BV7mU3LtAl+Yh4g9RBzlXvmI8mKlO
         UbY0k0sm1CoS9Nbu3pAtrcX8naCzItQUyeg9hJqBYqTgt1c02n+h4Z43e+/MO3JaLn6e
         I5+UbII80aSiPiWFLn9EWdvawIX+hGxTOePq7Qxsa6DG9tmtcZacYMdUxVw3kR0vQxRf
         DjfJncQTpAuw9ZndlT52uN5j9RkodNbrO6vpUfU5TpEWmyPyobltT9B2OSx0TpKys9Lm
         0IBtjn57Ox1ZxAdhKRXFmZCYuFpZ0HJPIfgvIzZ29rq27sjtzXxTyd2xpOFcK0b+Qicg
         4E5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ie6HdrYjO4KdOTbwSmnSxG1WqGKl14BJoaMIocB5nvc=;
        b=gcLozT08JLy95OgNnlnj83M0d/jxCJSBM9dlodCLai6Rf2e3W7mzqzTy9wwYFwXvw4
         /P0eX7ONZpb3kUfXcASNifd3V7RR291KvNX1IOnNLWy3ZeHe89nwxoPKrl2MAcGpu+12
         HMXzsce0yM3lFQB/zgqhX8Wms4mBPnO4lhPb9sUvTAcCK02RnqAmKOOn2fZzXsDW19Hw
         dDLVgLed+ya/fLjQ4K3GAJD7E+GmurSUeCoOxq7gi3HkZNJCMRM1f1IODhZ5eEVVxDn6
         Rva9m39NLmLGH/4UteuS+cQ9u4hS293jd7HAlRQ9Bdgn+3CxQVVOmhNxDIluOYSPqkph
         oyPw==
X-Gm-Message-State: AOAM531p/b8iAP/M7pinyo/wRIVILo/b09QH4DgtdDfdv9x2pAhg+2mN
        Y4EHHyaf3oRHqq4UEBBIkOIG0Xw1jvvyGt3S
X-Google-Smtp-Source: ABdhPJxwrsRDu4enfEetMPjwW3qRjKCZaTKiEbF1yxkzNRHbe9JmnzCenvpKgYKgWiWys5n51OUoyw==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr227829pjq.64.1631547704824;
        Mon, 13 Sep 2021 08:41:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm8593304pgi.21.2021.09.13.08.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:41:44 -0700 (PDT)
Message-ID: <613f7138.1c69fb81.4cae9.816b@mx.google.com>
Date:   Mon, 13 Sep 2021 08:41:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.283-68-g373b6d2c441d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 102 runs,
 6 regressions (v4.4.283-68-g373b6d2c441d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 102 runs, 6 regressions (v4.4.283-68-g373b6=
d2c441d)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.283-68-g373b6d2c441d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.283-68-g373b6d2c441d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      373b6d2c441dd9e41f96a86ad24ddbcef4e206c3 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613f3e69015653ba4b99a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3e69015653ba4b99a=
2fe
        failing since 302 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613f3ebfe7d435a24a99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3ebfe7d435a24a99a=
2eb
        failing since 302 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613f3fdd41bec654c799a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3fdd41bec654c799a=
2e5
        failing since 302 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613f3df2a98c96db4599a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3df2a98c96db4599a=
2f5
        failing since 302 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613f3e475fb25ba3d299a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3e475fb25ba3d299a=
300
        failing since 302 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613f3e76015653ba4b99a31c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
-68-g373b6d2c441d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f3e76015653ba4b99a=
31d
        failing since 302 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
