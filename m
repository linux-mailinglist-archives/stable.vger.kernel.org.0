Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3F832D93B
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 19:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhCDSGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 13:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbhCDSF5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 13:05:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18B1C0613DD
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 10:04:34 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h13so1105810pjt.0
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 10:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uGXTmD0naCwIqSyQgJ5ejgcb5H4T4yQ0mzfk2H70wY0=;
        b=cvyoL/ts3d57yVEe0GxW7h1GSBLaBeTI8JgNv6bbK6BX8Ezi8YZ3G/g0h7roA3XUWy
         a417VYMfAy7vdI9Qvp/CNbSnvIHF4qrl1X8ZPUX7QdFQGtks3Ozy/dDmJdUOi/Uev+qm
         gjl9T/0MX80umT5bPNTX6NTFC9h6nzAJkE9XaT50YWkO3XPrfq+NkF/Vvu6nC43mFDsw
         gjyDvPUdmb1Mwagtn/G2TLs3vMUfHCxoZ8+Jbm6FZeIC9CoMr32phJvB3qe5NJthF1ug
         Tz29zzBahOpTaJZKs0LX2AV5k0lBk8whSI1Zsz9pNOnvutOvYh1LX6v4VmgL+34OHpSO
         4fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uGXTmD0naCwIqSyQgJ5ejgcb5H4T4yQ0mzfk2H70wY0=;
        b=doFOfcD5KvM0e5+vxURfrk+2NhfZviftKA4M1Va/YysDtV9VKI0DyarEZGiIaui07L
         2B61sdsZ24xLwjnSlcYbh2qZq7SNTTFs1L/FuuZysO5daqH35h1DokFFbR0mBaGgWG2i
         X4JDTxm2dzqInD5uvoJKqWABmZn19PTVA7gtxWpmkDU/H9Ohpkp8zoKASMD4G2RzMmTM
         JuGqlwgUBMAulHQOxB/Th/p/QWPeiV/H79WjGqFFQverRk+wT+IBVG9o+FyvoH9zgOeV
         u6tlgL7HexDN2/LyoBaL0ymruoXjlyMUdgBqhX6nmy6W27yu/LAl6T+aW4bXdWAUeXJ+
         8lhw==
X-Gm-Message-State: AOAM533X9zGvv+KlVtutDwpezXcr7WaTX3oib0IAb4IwitDGEzGvqhNs
        A1epBBcz8x/5wy69EwZzmHEZlA7CL1ZF2+as
X-Google-Smtp-Source: ABdhPJxxuzIu2a0vCcChCv08XBzS72VOzvAaYI2TlulaqT6uVB920J1aIy3TQLikJTUep+IRCJQvww==
X-Received: by 2002:a17:902:edc2:b029:e4:3738:9b23 with SMTP id q2-20020a170902edc2b02900e437389b23mr4929346plk.37.1614881074309;
        Thu, 04 Mar 2021 10:04:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm69515pfs.134.2021.03.04.10.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:04:34 -0800 (PST)
Message-ID: <60412132.1c69fb81.849c7.03eb@mx.google.com>
Date:   Thu, 04 Mar 2021 10:04:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 106 runs, 4 regressions (v5.4.102)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 106 runs, 4 regressions (v5.4.102)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.102/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.102
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f324ea75baa059ea126cddd4141198895880a69 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041186250b0952f72addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041186250b0952f72add=
cb2
        failing since 109 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040eb0501e675ea7daddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040eb0501e675ea7dadd=
cb2
        failing since 109 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040eaa17913ab42f0addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040eaa17913ab42f0add=
cc8
        failing since 109 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604107c96e232c0e6eaddcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604107c96e232c0e6eadd=
cd2
        failing since 109 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
