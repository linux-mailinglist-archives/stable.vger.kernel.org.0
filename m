Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0315D298AC3
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771845AbgJZKwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:52:18 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:37463 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771748AbgJZKwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:52:17 -0400
Received: by mail-pj1-f43.google.com with SMTP id lt2so2893128pjb.2
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 03:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ficI1vNH0mHoneGjD+a02ZkrkbfX8dMVF6maMXiGZ6w=;
        b=nWw4NrWJlexKNXyeZY6EVjDkTiiwcFWHbyacEAPt1hgfnQxFeBLpZcxvP+V/XmJxJY
         oFRH9HLVG7OF/IGt5AACPKTPVHEVpP0AyJ5osat798Qfh3fpFrhB/9HvXOyIiOk8E1mV
         QY1X9obJbvuGug4b+dQ9mav/kZqoIXD1M7qH/eppXT12p0QKkDSRUgI98bonPScHeMH4
         0jTL74aktQGLNvWTUDX2osFvKsuIXUB5135+bspTHkMvw3RETnj6THHElWbx7vlXDKEN
         8ZoSW07nsGjW3XKTaHcsGourB0NGwLQO9hJE20e4nxmZh/6L8UwmN+tkYEvAvBBw2Jey
         CY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ficI1vNH0mHoneGjD+a02ZkrkbfX8dMVF6maMXiGZ6w=;
        b=KFccO+Z9IN811U3AHPQ66UkaaNz1RBBuHv4MtjGS7OeNVn7fv3vEwMKcuHS8aLwHqW
         3y43lYE03UDCk4HjUYyO8/RVTgI9se6zzKdY4mCVW7dfnUpuebRYbV7mzIFvVby13VpB
         /daL2TpzrSu1+7smsfr9aPJxbg5KSUDrL45UZsR7sxV/o46mU1F3srsFVEwYHKZeF0Ja
         7HQfUYWxHVGa+MkBW8m0N3//a/+PQX960w6E/rm67TsFNX5zwLIBk2B8U3udQN6+K91L
         lQDdVwnwJ/0o4CXW1ghcpDmggzgr/+cdahkk+/TJyDaxaeS9MluJifDtK4legvOMEDxB
         qEBg==
X-Gm-Message-State: AOAM530nnxugVhHkC69yWS7BeRo+BzKcSn75fQuKgBBnGgg/VZVnEo2k
        xTpDepOkdfmJErz1cVM+ky2rUqljlYnIFw==
X-Google-Smtp-Source: ABdhPJwxd7ZHu9tQMy5d7Bia6rnlFbyqc4o4noSZkK8wzsLeOJ35MMtyGrZ+S78jNvkbgrnHD5vAtg==
X-Received: by 2002:a17:90a:a394:: with SMTP id x20mr15834025pjp.213.1603709536752;
        Mon, 26 Oct 2020 03:52:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v6sm12123110pjh.10.2020.10.26.03.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:52:16 -0700 (PDT)
Message-ID: <5f96aa60.1c69fb81.94e5d.8b03@mx.google.com>
Date:   Mon, 26 Oct 2020 03:52:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-109-g76d7a01ba8bf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 113 runs,
 2 regressions (v4.4.240-109-g76d7a01ba8bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 113 runs, 2 regressions (v4.4.240-109-g76d7a0=
1ba8bf)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =

qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-109-g76d7a01ba8bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-109-g76d7a01ba8bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      76d7a01ba8bf7f3d7a4767227c86ce2a024fe93d =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f96783ca77285b91938101c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-g76d7a01ba8bf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-g76d7a01ba8bf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f96783ca77285b=
919381023
        failing since 1 day (last pass: v4.4.240-11-g59c7a4fa128e, first fa=
il: v4.4.240-18-ge29a79b89605)
        2 lines =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
qemu_i386 | i386 | lab-baylibre  | gcc-8    | i386_defconfig      | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/5f9679147b9f20cef7381035

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-g76d7a01ba8bf/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-g76d7a01ba8bf/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9679147b9f20cef7381=
036
        new failure (last pass: v4.4.240-18-gec7216aecf8f) =

 =20
