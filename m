Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868CE37EEBA
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348367AbhELWFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 18:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442470AbhELV6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 17:58:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE0EC06174A
        for <stable@vger.kernel.org>; Wed, 12 May 2021 14:57:34 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i13so19881251pfu.2
        for <stable@vger.kernel.org>; Wed, 12 May 2021 14:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rHO3sQbLKwkd/c2z3zljKikIar0GLwZ4Mi80n5Fi8pA=;
        b=sOSxDyVY+BHOM35d0GmDn7L/+dKJYlMjNH4QCvJ1HKTB48M5PlcgrWZUQ6aLMPLVvX
         WXcUxwTEir4+XALlBnUAXxpCPsa5vSm9iJjzXxVi+33TrqCM/BU8BgacNI+sYWtZontO
         zDKm5jwWUUrHLymkz5wDLlmn3tWIgEbpLitwgxTCSnkVPctATedT04CMtXEk/RDuQ+Ez
         chM6Iu8C+O/o4FMbV/nOpn6h5ifHOzrC+A1s0iPM/mhbo0UUZdjgwzo1TSigB8QPceSQ
         e/biW9XUXNjLdWVbxp6DeDDuKoYJUMiju1ax8IFOhj5bp/OgLVKJBZPw0Wm6r6FexJ/R
         oNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rHO3sQbLKwkd/c2z3zljKikIar0GLwZ4Mi80n5Fi8pA=;
        b=Js82X9lDUun6vGvnOY6qDmbQxr0OYBHO9zl3QQz+WOwgsMYtPNs85WryToJTsjhgJ3
         kwN0GULyBI8POWwsYdQ3evHbPM9Xhwr5x3hfjuiFKOmfdJ+iPf930Qxvs4AqakyDp6ZT
         0DLEWWu9IvS1x0hfKxb+v48xtLuW3ZhZoar7d4GtDLeqrS1muZy2RIC0CtG92OemXUhy
         1F8HgZeSadbZbLmUBZZMDGiFXSbG1//JPxx3W0jnXUBh0/tjxm+2ukyV40nT32oIppxl
         tJRWIt8LkkxTUnkhsh47kb9ROaLllrPNv13EPn+tv9we5QurPuuMu3awS9lR3tp1T+FN
         OESA==
X-Gm-Message-State: AOAM53021Z+znkA8cA5g3j7QXz8CiDNHs3yaAUXF1MfMdpESlmuPvG3g
        g6FEx0ZKGnsJsvGXTWmAyxhKoR7kz23XaEoV
X-Google-Smtp-Source: ABdhPJweKKju7R+HuoXxGbbZARABnZNAAw1PLNbsBxFh4RvtALWMWWa/xzz7wHzmYrsutI2EsU7UMw==
X-Received: by 2002:a05:6a00:b48:b029:2a0:583e:3dd4 with SMTP id p8-20020a056a000b48b02902a0583e3dd4mr33996981pfo.6.1620856654245;
        Wed, 12 May 2021 14:57:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i9sm6272950pjh.9.2021.05.12.14.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 14:57:34 -0700 (PDT)
Message-ID: <609c4f4e.1c69fb81.e7df0.4511@mx.google.com>
Date:   Wed, 12 May 2021 14:57:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.190-304-g69ba3015e443c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 143 runs,
 4 regressions (v4.19.190-304-g69ba3015e443c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 143 runs, 4 regressions (v4.19.190-304-g69=
ba3015e443c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.190-304-g69ba3015e443c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.190-304-g69ba3015e443c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69ba3015e443c6bdf3a588d7ead0592d2920f6cb =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1bb5611ea6d4fd1992a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1bb5611ea6d4fd199=
2a8
        failing since 175 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1bb501e324694a199297

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1bb501e324694a199=
298
        failing since 175 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1b09329df5570919928a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1b09329df55709199=
28b
        failing since 175 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c1ac9e80cfddf79199295

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-304-g69ba3015e443c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c1ac9e80cfddf79199=
296
        failing since 175 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
