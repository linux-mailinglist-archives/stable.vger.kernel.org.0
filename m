Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A703753E1
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 14:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhEFMci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 08:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbhEFMch (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 08:32:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DEEC061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 05:31:38 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h20so3319920plr.4
        for <stable@vger.kernel.org>; Thu, 06 May 2021 05:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9cWLYC5qOPu9oj0k6433PGP53ZwOzDzLsLIHv3m07Tc=;
        b=KtL7Ctp9LYPYgngCZ5JM92HUm7BP/7U7JHc9C0sVpg92dlw6YhgM+hf72SUBlc6HUx
         07QP7DUDR/Zm9j0PBA5E9W/vzpp7bHTJjNpe9jkd5OKCDTKw2E/5CDcvew7uE30SB2BM
         fU8xfz5AtdbJThSq+s211zarX0e5yu/Fl+hCmQXcNpuq79U0NB8tQd6ozrX9hQScn5ox
         Udenftjcp7y9y7tDKcBgIz56u5+m1UPl/uOv8P3EEjaXvuyPKrIDWcXjp1PtQC0M5ALY
         Cqx4gymH0gknek/cOdyrh6M63RSg2kajIOaojM0LxFxo11ZU74uul1cZ5biOLetsy1yM
         P+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9cWLYC5qOPu9oj0k6433PGP53ZwOzDzLsLIHv3m07Tc=;
        b=kVblpz6ozdzzeba5orX1YmhEaFceag9+06skI6lEix+4MBOgr2glrKanuE2bpkvSNq
         cD5vSoiasBl371O0HrNblY2V/BE47IO48PcGDNbSzhH3lp2gS/Bh0Fj5+dWGhoRkQmCo
         OgYJAwAQkoZFiiG54pbTgkLWzJxJx2BC2Q2GEseYh3AGO4JaTr4sSnyawk6FEeDluo+t
         tOCZm6gUMvfljGMheTmqibgiHiUxtzx7Flvzz+AgbeqrKyBjnEjpvers71HCoRonk5xF
         pDGRwYizea7qjwJzeRjMzr8gzko7eBvmdhuFj8iIjXBup7DgABpXcbU6JgoR+gzl16Wa
         HiAw==
X-Gm-Message-State: AOAM532+FVXpKI5AEpShCLbsgtj/SDVvq4803J8pj2y9lHZYJNynUY8y
        neDmqwxIF/D3OMQ7NMDnvZP4gUN48/UqyxUY
X-Google-Smtp-Source: ABdhPJxB0cNfjUYbvWYzILDSo6UrEUYMvuarC9rUGpuU8VaEGFjSUUVwlXhg03TF1FJtMN1eQpH7Xw==
X-Received: by 2002:a17:90a:1389:: with SMTP id i9mr795144pja.232.1620304297964;
        Thu, 06 May 2021 05:31:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w74sm2160641pfc.173.2021.05.06.05.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 05:31:37 -0700 (PDT)
Message-ID: <6093e1a9.1c69fb81.b5e31.608f@mx.google.com>
Date:   Thu, 06 May 2021 05:31:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.189-13-g55525aad8171
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 77 runs,
 4 regressions (v4.19.189-13-g55525aad8171)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 77 runs, 4 regressions (v4.19.189-13-g55525a=
ad8171)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-13-g55525aad8171/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-13-g55525aad8171
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55525aad817171f58e24da52bb87c0b4f147a9b6 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093c16f3473c863086f546d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6093c16f3473c86=
3086f5472
        failing since 1 day (last pass: v4.19.189-7-ge7f760cab9781, first f=
ail: v4.19.189-8-g29354ef37e26)
        2 lines

    2021-05-06 10:14:03.282000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093abb9d0e3290f9c6f5475

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093abb9d0e3290f9c6f5=
476
        failing since 173 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093abd9ca5fad66e26f5475

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093abd9ca5fad66e26f5=
476
        failing since 173 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093ab815efb4ff0406f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g55525aad8171/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093ab815efb4ff0406f5=
46a
        failing since 173 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
