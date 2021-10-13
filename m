Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD3242B3D1
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 05:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhJMDtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 23:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbhJMDtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 23:49:21 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BCEC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 20:47:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f189so184660pfg.12
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 20:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=llDwO0ZBuCMnHzsOxc0azbbM7bZKIPVozqnG6yzKF+U=;
        b=PQKMrXnm7nWy1uNf5cxKqIeQJAF6bCt9ZNhkianw7dnCUikR9iYwBmtNupVk4al96l
         imtOvdr+/wJ0L8+ot+1XSfP7V39g02aRpJknUOFFQCYtLB246H5dRMSL9ND7Lw7jAshM
         KAzs8Q14nxo/rbOF4eFwPZtR4jO+IAGAE3CqZomvkoJbs6b88dLosa46XPa4YcEdCEVv
         fmxz/Sm+WaZIgIQukSiGxrF5nZ4SMKcZA0uOdWnXPWBblnIRQVtira7CYuznoG+t6kn5
         chiQ+L4gHoG/8AQaRAC54qe+hYdHgGi0ReyWhBVfBG7Lnv1M1fpzAAEVZSmv1U2ffy6V
         lh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=llDwO0ZBuCMnHzsOxc0azbbM7bZKIPVozqnG6yzKF+U=;
        b=vlXHROGIxirhPRDz5KTtIZFyymftyXkyNJBtcbMkxg1FKwFWXo8FaopkhXYCl61rda
         QBMm8nWMQko5kEWCWc+MwWUN5mzMZtohXQYnnZ39JpHJSeYyJE2ufRr+yo1h5iM2FNtZ
         R135MmLQgQ+MP1eObf+priSCmbH3eFXn/R8UYJj19DzApV1abkuw1FaLfuYZ8iztLL0w
         HHS712pBY25gBJibCxwC0Z6ATgFtGS+ojxDJrWKENoapj+lSP3I8G31f0FaJ5SAhj9Hs
         +wr7I7/eyVywRujGmxYkPyxaFoDt0TpJ6ifrt8guSlSBW6wYrRtaRTNs8c/uApbaJZEY
         c0Fg==
X-Gm-Message-State: AOAM532U0UCYHmV8ebsoXeVzKz/Qk+hfz32GiET0Z+nYkZ6BTaQYFhBf
        TLm5p3XzrpPOfZqfOwdMGCSmBlmnQ/9rrdCZ
X-Google-Smtp-Source: ABdhPJxuW4TAuPJdUiB6WHHIeO32BJKEoVtZB5b+6uu9/Td/37AQKPP1CInQUbdGv92xSJiv6tpKeA==
X-Received: by 2002:a65:664f:: with SMTP id z15mr25913036pgv.252.1634096838053;
        Tue, 12 Oct 2021 20:47:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s17sm12991497pfs.91.2021.10.12.20.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 20:47:17 -0700 (PDT)
Message-ID: <616656c5.1c69fb81.41335.4c09@mx.google.com>
Date:   Tue, 12 Oct 2021 20:47:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.250-24-g12b005c2c7b6
Subject: stable-rc/linux-4.14.y baseline: 50 runs,
 4 regressions (v4.14.250-24-g12b005c2c7b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 50 runs, 4 regressions (v4.14.250-24-g12b0=
05c2c7b6)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.250-24-g12b005c2c7b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.250-24-g12b005c2c7b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12b005c2c7b6ead129e33a13c5f2351454c2d730 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61661ddb20cd1593bc08fac3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61661ddb20cd159=
3bc08fac6
        failing since 3 days (last pass: v4.14.249-11-g7d769cc629ad, first =
fail: v4.14.250)
        2 lines

    2021-10-12T23:44:06.243902  [   20.739654] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-12T23:44:06.286824  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-10-12T23:44:06.296136  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61661957cddfd0fe7d08fab0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61661957cddfd0fe7d08f=
ab1
        failing since 332 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6166194fcddfd0fe7d08faab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166194fcddfd0fe7d08f=
aac
        failing since 332 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6166195bcddfd0fe7d08fab6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
50-24-g12b005c2c7b6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166195bcddfd0fe7d08f=
ab7
        failing since 332 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
