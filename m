Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E97425E45
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhJGU7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 16:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhJGU7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 16:59:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EBFC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 13:57:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y1so4685077plk.10
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 13:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LDZ6ngqMa/LAkYdj1hhysRxverQ2G83jm9or+5aApEs=;
        b=Jl1tQi05SsVYV+zm2cT1qfng4C7Dfl7DO+vsuHI8A0jxTiZB1DRSGmya0XRlOAtkYh
         If7G80QUcRZAHlpP1M2II6m1sin5uvfq2lSsBo9DjV3G7CRXNeNw+m2z+Uu9TzV2Vp6k
         NYh0G076Y8v1ea92xAnGXAA9gqWGfxKVWwM+ubiEKp4VNq+wiiXa2Kx4yEpF3X5Z3Ya8
         HFIZxn8tpqer5Izl9ZVrO0ImCOYWxqaH1zPXf3Qk9Lgw+HNaxa2l+anlm8xSxPFr+cOb
         MrqRcx4mrKHu78uOV2X5pTRY1xhFEuxLvAHCS46KBW95t4B6ecemqEs2Opr7dazQiBJt
         1fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LDZ6ngqMa/LAkYdj1hhysRxverQ2G83jm9or+5aApEs=;
        b=Qox4nETqdOIhks4wlFF0yJp9sFk4hZ1sRjOUhJd9UUlRfLdjYvn3dysDaqVwxU322n
         QVbaVb0LDtiyingQ2cJUWNjMJNCL6WkRT4xDxRI6qgcxIh8NdLU981yVg+2MdQ0QLwFq
         liaOJT5QKDCQ4fTtArc7Ex4Pz2XM4XM20NV8UgWNJ50CngaprRgP0CPX2vAtM3i5CJNC
         fFSjXn3igLcXDvZGXwR6oKV7awkViYEh8RyW4mVTh0ct/mZ/jpVAjSdg6zSH7MHVYysQ
         Txkf8U6kWfZ4p+i8c/OuI2nzEt01V7Kdu3VyVSUekX8mtAT5dj2MwtstHiXZIJcxm3AL
         ANSw==
X-Gm-Message-State: AOAM530CB/uV3fg/HRisQuQxHAT+GR9nRrBtJpWTgI5DhevcA6nWGTW0
        e+GlVXyNvRRw5caqPaiJ45kXflquR//WmokL
X-Google-Smtp-Source: ABdhPJwTYTyykl6OIgd+dZ6jS/yFXxUAqqQay5ZdCOPcCBzu9z+5R9tPYVNGxwbQa1G1QEptomp+Pg==
X-Received: by 2002:a17:902:d887:b0:13e:e77:7a21 with SMTP id b7-20020a170902d88700b0013e0e777a21mr5783006plz.66.1633640227173;
        Thu, 07 Oct 2021 13:57:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d137sm313882pfd.72.2021.10.07.13.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:57:06 -0700 (PDT)
Message-ID: <615f5f22.1c69fb81.bb05b.15bb@mx.google.com>
Date:   Thu, 07 Oct 2021 13:57:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285-8-g99ce080e6545
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 74 runs,
 3 regressions (v4.9.285-8-g99ce080e6545)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 74 runs, 3 regressions (v4.9.285-8-g99ce080e6=
545)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.285-8-g99ce080e6545/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.285-8-g99ce080e6545
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99ce080e6545c05b548037ff234a68e3c50c1eab =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615f2b4358604da9f299a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-g99ce080e6545/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-g99ce080e6545/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f2b4358604da9f299a=
2f6
        failing since 327 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615f2d7968c8a1639099a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-g99ce080e6545/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-g99ce080e6545/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f2d7968c8a1639099a=
2fb
        failing since 327 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615f42048aa7ea532799a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-g99ce080e6545/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.285-8=
-g99ce080e6545/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f42048aa7ea532799a=
2fb
        failing since 327 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
