Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604F22E2266
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 23:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgLWWVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 17:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLWWVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 17:21:32 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A079C06179C
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 14:20:52 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id n25so449618pgb.0
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 14:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mtTxzLNpqq0EU4jmClJJVwtiruCH2rOlURJjcWQMMc8=;
        b=rp+klHtLSMqkfTeESYE/Q8YEMD8svBfGglM3j95AC/Ku61vO03FjsgJku+vgPIw44v
         WrpRoInNw7adzC/hgVCA14ndiSQ7VRY93BuzpIxop9Gx0oMV9oC6fRadwa2xtIXBFCp+
         919dQ+mbqh7kfDt5zX/kHFvpRzDvsBVEz/bx+E9VwADdW6IrkaCDTQx9ZiizVEOfgrlR
         Izs1+AaMYx7TICAUI4JzcQqOt3bZGKiPp8AJZfkm0xjcdxPSv+CSzyCJLqs4zaATiEy7
         CBw/PgQ11JVfphBxEkCrP7Uup7HGvbAAQnYKn1fu9LCpkQ3hVXvjA9n30fMY4DlJfCHR
         Aieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mtTxzLNpqq0EU4jmClJJVwtiruCH2rOlURJjcWQMMc8=;
        b=qQCFliAnM14oi6ZDzl/eKFqk0pOK4fWHGWx4PgpyXKdjpatGQ26Yv7OnakmGlebbP+
         G3YN8HtGbkJ4MtZ9Cs1nvB8eH8C6hZQAfBtNqP5f763lzvbjcer84N4M7L/3P1y+lvbP
         Z6Gu+qAomuCB6ob166cRbEAtKTu4x0Ygaj3HLlhIGQdNBLK4eUz8Qz2KOIS4TlsLAeTH
         6iLLJJVkRFPUwNrCzIL1bHz5eIK+/F8qx8UZV637f7KthUoUkWrzUWY4xsbVREskLugr
         CBAXc6tMqtcgUkrPdR/v0DkMdxywPMj+72wEVWLpWIzgRaYwTkHVgEwKN1EoLs++dk+t
         L1aw==
X-Gm-Message-State: AOAM531f3ofzHmoukSwXaNKnNEYB2Gj7OsHfr9wucfIZ+fLGfO5iAj5y
        a/4zwNeTF7i8be0wws5mMSvOihvYAkw0jw==
X-Google-Smtp-Source: ABdhPJwgFHBfP7FE9KAC2RnNFJKPqnVC366y9ckRd45OWy8ssIIOIcA4mIF86nLdlRVc4maV5EodRw==
X-Received: by 2002:a63:1152:: with SMTP id 18mr26224684pgr.268.1608762051215;
        Wed, 23 Dec 2020 14:20:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o193sm19317742pfg.27.2020.12.23.14.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 14:20:50 -0800 (PST)
Message-ID: <5fe3c2c2.1c69fb81.f3f42.6580@mx.google.com>
Date:   Wed, 23 Dec 2020 14:20:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-48-g718e3a8728c0d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 124 runs,
 4 regressions (v4.9.248-48-g718e3a8728c0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 124 runs, 4 regressions (v4.9.248-48-g718e3a8=
728c0d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-48-g718e3a8728c0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-48-g718e3a8728c0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      718e3a8728c0d445daf135989ab890ef6a0a9f27 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe38f161028119b43c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe38f161028119b43c94=
cc7
        failing since 39 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe38f1076f6148722c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe38f1076f6148722c94=
ce3
        failing since 39 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe38f0b76f6148722c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe38f0b76f6148722c94=
cda
        failing since 39 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe38ec0bf494d16efc94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
8-g718e3a8728c0d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe38ec0bf494d16efc94=
cc0
        failing since 39 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
