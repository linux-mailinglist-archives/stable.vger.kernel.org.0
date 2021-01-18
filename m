Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16D2F986F
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 05:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbhAREAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 23:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbhARD7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 22:59:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E2FC061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 19:59:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ce17so6462868pjb.5
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 19:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Kto7xW63Y3wplpcWQMTWkwEZ3H1fBGhjUkWZdyOV+M=;
        b=iQPcEekHa/4D1Acx8Ka2MNer+r42nki7hiCOjWEhE16CeGvI+dI8A7DtpQUW9nu4dV
         Xi4OX/5E8wuEU+axLVt5jU1fOEQ4d3JF1kTP1obOe4wsPK821ls8bwfAb/h6bwBozNWu
         n7m4wffuGPhhY2ZHubpoo9EFg1DQJ1uj5FZhIdIJLt8ltN4v6FZ3UyqtAj7k6f4kfkfa
         nYO9eaP1cW2rTXIQxAXEd1FGoATTRayL1NQaoICgDVg0zdPXoQvTyNat5g5d6m16A1IH
         pd5h4nymnyl2vKY3wpIUIqBOppxe1iVo1SWOWSQoHnAkzhahDvvoqDWHj9I/0Yu/Fy93
         TeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Kto7xW63Y3wplpcWQMTWkwEZ3H1fBGhjUkWZdyOV+M=;
        b=hp+W1dTcux6Pusz0vQEuyKCIQOjSa78dlXYaTD9NHnALRu66CFwb5zAgjJeftDgGYu
         FTA0DZSNw19iGUCEE76G4oC10SW9RdOPH+istBDU1iwxaE17EjuF8hO9BOf1NRvoPMDK
         6vE8/5Z0m4HmD4WuTXsMz21t6YEmtOXFrz5ilrtOlozAmtod9Musi7Qq1d6KaM6DzJBW
         JEaAdLW9IwQCDJbUIL1pDNIPjkmYzlFYhHtA5aioSfijE5CvM4kPzTid8DEQf0crG25F
         smzfbAJYLAbltC7px5EjCtHH4bqRg3Skmrhc2XP/yX1IfXZf7wR3QwLNSxiHl8/pScWN
         MnuQ==
X-Gm-Message-State: AOAM530voH/SmmjHWBXVPyN49NcC8BEylsm7ewElBljhYpmHNsI/eP13
        vLrMRcC3/dgfOa+6aAnv/V/9FYVtYea85Q==
X-Google-Smtp-Source: ABdhPJwloyPmg9VwZTaqDO4e8y+WdKK5jxKts7TQgIXBs7eO4JSssy9iX3bgN63Jx3v+QsDmQklcRA==
X-Received: by 2002:a17:90a:ad7:: with SMTP id r23mr23486889pje.149.1610942353688;
        Sun, 17 Jan 2021 19:59:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s23sm14165973pgj.29.2021.01.17.19.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 19:59:13 -0800 (PST)
Message-ID: <60050791.1c69fb81.6ec45.4034@mx.google.com>
Date:   Sun, 17 Jan 2021 19:59:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.252-14-g5a6a27db47a20
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 130 runs,
 5 regressions (v4.9.252-14-g5a6a27db47a20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 130 runs, 5 regressions (v4.9.252-14-g5a6a27d=
b47a20)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.252-14-g5a6a27db47a20/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.252-14-g5a6a27db47a20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a6a27db47a208ae8ca1be41faf4d972d7211d9d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004d54caeeec8af1ac94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004d54caeeec8af1ac94=
ce2
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004d56711ae08a3b6c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004d56711ae08a3b6c94=
cc5
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004d54caeeec8af1ac94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004d54caeeec8af1ac94=
ce5
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004d5053a68ec915cc94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004d5053a68ec915cc94=
ce1
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004e098bfdd8b4ff5c94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.252-1=
4-g5a6a27db47a20/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004e098bfdd8b4ff5c94=
ce9
        failing since 65 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
