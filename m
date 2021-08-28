Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB15D3FA36F
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 05:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhH1Dyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 23:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1Dyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 23:54:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096CBC0613D9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 20:53:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j2so5269556pll.1
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 20:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ENNboMEPtdbjr2HrV6CUUftd4aYEjIpHbbiJZHepCp4=;
        b=U/RCvByvPwlWjHnnaZw0MW7darbcN4pHob9oHc8anQN0FSdeyhdRhuWpHQJoCl8rPl
         1qkHNPcFo2quPikzEGydG5hLEaju2yVrPwo8txoNlEcO50Luo690k+dUz8EPV5lTuroN
         paBq59V74jvX6Zu6I51ASfHa1q8+hw3qlKXbBfuBUwSHys0Sg+3DtBvTGwDqTu7lzgfF
         SaDPm9Ct2364uugWlY7sGLpEQgb4sV6aKQvPilM3kGbRs2UuurgaxMUkOa8XecohGgLH
         mnMm+NCGcdoW2ewUsCUv9b9busR4voQxhH8oMH6AykOOLVuidRm6usuMB+eeLfEUKz6V
         hOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ENNboMEPtdbjr2HrV6CUUftd4aYEjIpHbbiJZHepCp4=;
        b=bVyTUaFSKGYOljmttY3mRFNA4QYX4L+4l/y37424hYawehaq3AG80LGbTHBkKddyzS
         ZcR4CDX+Pum/CDh5owct3ihNc7wXZGZtyGkssW32Z99q5mv+Rf6S60XOTGX7UvWZ0Z/L
         EcwIpEE6/NxX6Vee9OWQz6246VZvNFXfoKHg57T51jKJDv6qFSxwEh+ZuG36QeZ1yy/H
         XwS33qKAb5xe/N9T7RcPBN77VVL+0wGm1AblVHtLKM5o4IGfTud8oOjIl8okLC9du0YV
         RkkALg9Bx2dPbiO5QBUsm+vOYprv5fsVVHKy8PRNXQ8iZDmWtWTrQxSFdZah/4o/6mRk
         +R4w==
X-Gm-Message-State: AOAM531YfikAE5CZG15aMSCwMFURcaGIhgF6SbbOtBVyHBsJJLL1HPzz
        Ceh7b9J1fgSPqEFVI1j3eus9oI0jsDpeDVOA
X-Google-Smtp-Source: ABdhPJyDxCqlOnarUUcKyb1iEv84z+y6N2L7XIXAjLkk/pI+kyKilusf/24+3MfYtFx2Tksyc5i4RA==
X-Received: by 2002:a17:902:6b47:b0:12d:7aa6:1e45 with SMTP id g7-20020a1709026b4700b0012d7aa61e45mr11651845plt.80.1630122822265;
        Fri, 27 Aug 2021 20:53:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c16sm7723438pfb.196.2021.08.27.20.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:53:41 -0700 (PDT)
Message-ID: <6129b345.1c69fb81.5de8f.5aa2@mx.google.com>
Date:   Fri, 27 Aug 2021 20:53:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.281-1-g541bc8044fa7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 3 regressions (v4.9.281-1-g541bc8044fa7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 105 runs, 3 regressions (v4.9.281-1-g541bc804=
4fa7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.281-1-g541bc8044fa7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-1-g541bc8044fa7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      541bc8044fa762f411d405c0de5604bcce3b157a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612980339240a85fb38e2c95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g541bc8044fa7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g541bc8044fa7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612980339240a85fb38e2=
c96
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61297ab4fbf7a845568e2c8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g541bc8044fa7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g541bc8044fa7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61297ab4fbf7a845568e2=
c8d
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612979ed86111e59528e2c98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g541bc8044fa7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
-g541bc8044fa7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612979ed86111e59528e2=
c99
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
