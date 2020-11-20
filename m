Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB6D2BB136
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 18:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgKTRMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 12:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729827AbgKTRMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 12:12:24 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A85C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 09:12:24 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m9so7822405pgb.4
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 09:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ACBmzSgwb+Eq1tSzNxPsRLlPrmNrIYuqu1GEMHO6iWI=;
        b=lnLdGoAg335q4bmmdguOpHa4qe6cV9kXWe06v85TgPo5wOOYwk8zeYTKX0grAVdjoE
         HcYriK6FUUtirPYYJBjSVo0hH0kzXrnP/m38o9sL2D2kpkiWAETpuacdZFziOpEpWAN9
         rPzeEqP+p7jzJOX0k0S7zM1Zd45SVNl7jus1zq325q3WlNeZ7b8IYGBBRrCoZ8OtfEkX
         UkoA6panWX1nMPKZy3GZTdbG+21uUBgbeyHfukvx8UbK0O6UBMdt9Hcfg8WEjoBoQJE6
         J75LCSHPaGE/g94yCvD/kLGHcyvUswZLDrL3gFYhJYIfpXuP0YQVbbwnu9LQpda7jt4l
         ayaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ACBmzSgwb+Eq1tSzNxPsRLlPrmNrIYuqu1GEMHO6iWI=;
        b=RJhU4sLhrgQ/opTf5teu7jFBxMgAFRmnaq7TL75lgyjgRkAHoAH+GpbGe0qTry8vId
         Qcxr+LhtLbq2wKQ5D1QhDao4B18MIcmOJkuhy7a7bkUUqJdeSoXB6TFbhMFIogTrUZu+
         kodxZ9P5b3kZzQCkR+nK9N6ylraSslIo4XTRv7JfaNFl6n+11ky0Z7TUsOTqihE+ehED
         IVNv4Z6RWwobMk4ciYiMfj/9GoyBqwS931LD8OkZ7PD+NiDWcnDKM8/utRHiQ3VBCaYQ
         XfuxW/jVJBtPKl4SJYGxYc5g+XGxHT4zYCyqZn/ST8LU22/4dVf/Wzna3tdT2pQzUhf2
         z2kA==
X-Gm-Message-State: AOAM5301DOT+LDnOKCcn6TVT9JkzR8G1pi5sR8P/vsnr0QgJ0k78Sugi
        GFcWEonsv4I2BPUlMWGh91d+VLvoxHjRTg==
X-Google-Smtp-Source: ABdhPJz/7105vEcF+wPVdX1paAf4/lOTC0FsEWGvxOXPTy45GQcntpKi5D5Byyf8MTuk6dtkz+Z4cQ==
X-Received: by 2002:a17:90a:1b41:: with SMTP id q59mr11175461pjq.17.1605892343453;
        Fri, 20 Nov 2020 09:12:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kr2sm4455150pjb.31.2020.11.20.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 09:12:22 -0800 (PST)
Message-ID: <5fb7f8f6.1c69fb81.ab9f4.863a@mx.google.com>
Date:   Fri, 20 Nov 2020 09:12:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.207-18-g6334af4e50696
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 135 runs,
 6 regressions (v4.14.207-18-g6334af4e50696)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 135 runs, 6 regressions (v4.14.207-18-g633=
4af4e50696)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.207-18-g6334af4e50696/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.207-18-g6334af4e50696
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6334af4e50696e5e03708e10c1da2015a9f37c6a =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c53cda46276d05d8d91c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c53cda46276d05d8d=
91d
        failing since 119 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c4df4a864f8060d8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c4df4a864f8060d8d=
90a
        failing since 234 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c7ec2ff77835d9d8d903

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb7c7ec2ff7783=
5d9d8d908
        failing since 9 days (last pass: v4.14.205, first fail: v4.14.206)
        2 lines =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c50e40b53b3ecfd8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c50e40b53b3ecfd8d=
905
        failing since 5 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c51240b53b3ecfd8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c51240b53b3ecfd8d=
911
        failing since 5 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c4d1df53f5b9c1d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
07-18-g6334af4e50696/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c4d1df53f5b9c1d8d=
91c
        failing since 5 days (last pass: v4.14.206-21-gf1262f26e4d0, first =
fail: v4.14.206-23-g520c3568920c8) =

 =20
