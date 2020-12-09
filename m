Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0552D37F2
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 01:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgLIAsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 19:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgLIAsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 19:48:01 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE0CC0613CF
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 16:47:21 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id j1so38733pld.3
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 16:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g11tqdGwdvv8Z1OUph8DiW1ezzsd1HIQIdb1guIeTYE=;
        b=c6ArYVKbDTPjPUXDdHkTbgP9ndfX2zwW78gT3VxCSRiqrsTHuEV7TjT+opEWCgeH9T
         jFUX0Pz69kUBIFZ9k/jG8bbu6BrgvG7sYl+p0ixur56+DhkJ4Az765i0oVM8GiApt8i0
         sdaS0kSzTK8n3O60/6H1XtvegeYVl8yQATPiSbpM7hU6ZyOXVZQ7vNtaZlHlC2vMsQqR
         o+jOdrumTb59WJQ19SC6YffvQNzLbPNeCwbU566P4gZ+acU3zoUYrs8MePaHzpP+28la
         nisdQ2YEf/ZhbWszkCswDANWWJRpw7kFjNTO3bD8cMrhIMd2+vH6FdWFRCfQfjOxo9Ev
         Wjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g11tqdGwdvv8Z1OUph8DiW1ezzsd1HIQIdb1guIeTYE=;
        b=Go9vXFPrfFHiwqrYbQHEJu0FVZ16Zsf9cgO6Q318SI3h2CpXV4a9Xo8Utx8n1g+MEB
         qbiLIkgzpekC0rV0D2gmUyjw4KBlP2ZrmRo9UNGT6WCRwJaGqFlg2scXe2H9VVssVNww
         A8ZsW+xjMvRxXQMVdkirj6BddUjbFnufEfotzJs7vKIUg/JipBGum4WChlOAz4a9UU67
         9nfJRgi2EOTfcQBbjLg8IHxR+2RNvJ7cTNkZs7tabVPJqQZCvIm+ZV23P2qGQl44LObg
         3cAeiioiG8sXajVjh5ZSvwTqxcAeDjbEY1SXOGC0eJfhwQkvsnh9ZmQwWQ0Z9Xqx6n94
         G+qg==
X-Gm-Message-State: AOAM530q981hcpTC+zYiIwgCsKviSqnZ0RTQLg6zYI5BL82mVdByOw/X
        CvdH4rTYMnd1BhEh0W89KiT1HNVLFk5hpg==
X-Google-Smtp-Source: ABdhPJxdyUULsLWWdFh5fcaqN2yppuZdz7p4rrvxuOhfSDlt9BJjL+1giQ8VNquXnRhSjerte11mbQ==
X-Received: by 2002:a17:902:7207:b029:da:fd0c:521a with SMTP id ba7-20020a1709027207b02900dafd0c521amr95793plb.45.1607474840548;
        Tue, 08 Dec 2020 16:47:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v186sm362584pfb.152.2020.12.08.16.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 16:47:19 -0800 (PST)
Message-ID: <5fd01e97.1c69fb81.318ae.1177@mx.google.com>
Date:   Tue, 08 Dec 2020 16:47:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 160 runs, 7 regressions (v4.19.162)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 160 runs, 7 regressions (v4.19.162)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =

panda                 | arm    | lab-collabora | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =

qemu_x86_64           | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.162/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4abf26854aade9732a215a168205fa9fecd6149a =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe92b48154c709dc94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe92c48154c709dc94=
cda
        failing since 175 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
panda                 | arm    | lab-collabora | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfec34d552aad10fc94cbb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fcfec34d552aad=
10fc94cc0
        failing since 27 days (last pass: v4.19.155-42-g97cf958a4cd1, first=
 fail: v4.19.157)
        2 lines =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe8dfe8dbb68f42c94cee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe8dfe8dbb68f42c94=
cef
        failing since 20 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe8a99016889a9bc94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe8a99016889a9bc94=
cbd
        failing since 20 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe918b5a422ae4fc94cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe918b5a422ae4fc94=
cd3
        failing since 20 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfea7217a8426027c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfea7217a8426027c94=
cba
        failing since 20 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_x86_64           | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfe7c2ca3e835959c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfe7c2ca3e835959c94=
ce2
        new failure (last pass: v4.19.161-33-g35a4debf26a4) =

 =20
