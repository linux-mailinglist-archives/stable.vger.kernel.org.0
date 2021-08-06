Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835E43E2999
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 13:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhHFLbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 07:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbhHFLbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 07:31:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E99C061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 04:31:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j3so6658492plx.4
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 04:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g4trEunHVpTZpPnGdV3WaY1jzeje0sC2D86od5hZwQk=;
        b=uUJJy0uS8lx0QPhThAYIFsudlUynvb9FqJimvTn+2BkOm7rFChNasHhNKPNU6zgCE+
         ag7hiEYnjJC/Yo5SLTkxGQbfeMzbNw/vlCnwacwz0++L40vyi2qEcQfzDrYYxaGgObXF
         khx69nMRzmMer9ZB+1ObuO8tRnlZosbzH0lYf8hSRYK3AGfcofHwZ7GdDJBzS3nfZiOI
         zGilXaioQxSV0PKeWs2+TNwYgUBQ1mWSe8q5mExCBzQuAppUXtOIoIBxUC50rNm8SDL3
         NtwZPR8nzTsRPmuctuYuCvY1wcFgbW2fu0Bdd/+hOQ+kQ31869iWCO8Shi/sGjvK7R7m
         lWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g4trEunHVpTZpPnGdV3WaY1jzeje0sC2D86od5hZwQk=;
        b=OUdoN+O9qE9Cyagqdapn4Vxc8dSaftdYCDFJomA0ECuHwxJz0tXpbKcIBDd1zklwIq
         r6dNwVC8OrGVUslNlNdp92r4A/kJJYfClckoengdvvSiFrXJyuYqLsOiI1Am0stZ3sgf
         SCDXVjK4GoS8pV5mmz6B0Pwsc47ggCNN4EGUN0eoUu+Pefxy6I1AsVLYBoKqxsadgM1w
         hTkF9YEt72G4ByjiJXoxpYF8oAaWe1IaAW/Zne+ncjDs2xiw/OO0sraDRkMYTp6vdmcY
         NtdFKGGHyf8fFsSi4/wd9xg7J/UqR+eozgoVDnJHNLSIyhj6Q86KBq3+LnmWoKa3XmUN
         XlEg==
X-Gm-Message-State: AOAM532SV8BYB0Xz15iyr0QMIs05VUfD95a5NvXSms9kfgD9McOqXn29
        cnZr5oWkxCQlzpvtbb9BOfJQfFt4e0/Agg==
X-Google-Smtp-Source: ABdhPJynptljdgHWXUoOu4ZJty72aVzgjX9+p6TlENorHa4sRQcDOzJm017ILyn43ZM5pLsBvxs3pA==
X-Received: by 2002:a65:4785:: with SMTP id e5mr562747pgs.186.1628249475182;
        Fri, 06 Aug 2021 04:31:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v15sm8718149pja.53.2021.08.06.04.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 04:31:14 -0700 (PDT)
Message-ID: <610d1d82.1c69fb81.e971b.9fd6@mx.google.com>
Date:   Fri, 06 Aug 2021 04:31:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.278-6-g289266ac6f24
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 75 runs,
 3 regressions (v4.9.278-6-g289266ac6f24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 75 runs, 3 regressions (v4.9.278-6-g289266ac6=
f24)

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
el/v4.9.278-6-g289266ac6f24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.278-6-g289266ac6f24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      289266ac6f245f8244a617326864594ee81b1825 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce3bef782540563b13689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-6=
-g289266ac6f24/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-6=
-g289266ac6f24/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce3bef782540563b13=
68a
        failing since 265 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce2ff36c80f39f9b13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-6=
-g289266ac6f24/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-6=
-g289266ac6f24/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce2ff36c80f39f9b13=
666
        failing since 265 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce276eb44e66764b1367c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-6=
-g289266ac6f24/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.278-6=
-g289266ac6f24/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce276eb44e66764b13=
67d
        failing since 265 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
