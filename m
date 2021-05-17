Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F58386CE3
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 00:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhEQWYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 18:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbhEQWYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 18:24:45 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB9DC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:23:27 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s20so3951529plr.13
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i02TSdWuU4fuymXqQYWUJGr4pgcypbY8VX0djBsNDj8=;
        b=E/C8HFJ+GrxqxQbfsG9j/PX8BbyEGJOWk9xUWV+b44YtTqb0yrUYrZnIEK4NqRQVw6
         iCXT7RRsxZdlk0aIu1c+Jt6FnwSzt2BuMALsH5LRXBVWmy9Plz7hFw7zENKUp+lvYdd4
         jq2HshcecFWkR3iRFRyzo8e//+Xymab5obPsDNmFr26o6UqEXuh60Hg1Th/goz5OOtLs
         4mjCrSTgE6XFMq7enqFvS9wFr1nr7e4jZ3xmYasGTAL6m27MgtPXT2EPQFOIBBAfx8at
         kgs3aMTWeKngzF6INVs09xLJnIY8WiaPtE4xMSUxGmBXVKbJPxv0xhdhLDep1zrrTi7m
         +CCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i02TSdWuU4fuymXqQYWUJGr4pgcypbY8VX0djBsNDj8=;
        b=ui5CgkpIM7k/mps5riPHMzD+7IdbFsz1p5srqJtAP/5K0BXtl/jb1HNKhsCFkJpHJk
         9DJz4iMO5oq4FQgQHg9NO8+MN9DQ6mwTwqoj6W9rhzrzCLeZsVBiCfKTf9Npqan24ZqA
         4PuJ/jnFxzJ8kBa0Bu8Ao8D5Kx8JAs6rE7HwlbDS70282Bo7Zi+lB5GjQjiWBTbCpFSy
         bi3Mo4/gAIMm6dcBMlKxescIGRwtByEr4K9ArjCjHMfIfskrbh5CBy6xQKPQmp8lfb/t
         50xhldbR/TyO1MZeHPwQ+tdREweJzsdGDCr3FdieYm0qSnI8UUKLf1Iq92yabn1IpAfc
         EhiQ==
X-Gm-Message-State: AOAM5310Lor6jGAffqM8QTdqL5SysaHksgQMztYuhPOLhMECYx9QHfk3
        bQnjfOyH6UbZ8NgpKTEc54wOU/1nU0SFa6wX
X-Google-Smtp-Source: ABdhPJwGzhck+y0OV5HO5PGJCBxDWjyHz7RFvMEWv1xW3cblcdQkFmVSFPH2kA5ET0oZ62wsTxv8JA==
X-Received: by 2002:a17:90a:8005:: with SMTP id b5mr1725390pjn.208.1621290207214;
        Mon, 17 May 2021 15:23:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w74sm498732pfd.209.2021.05.17.15.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:23:26 -0700 (PDT)
Message-ID: <60a2ecde.1c69fb81.f8ff0.2741@mx.google.com>
Date:   Mon, 17 May 2021 15:23:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-223-gaf1b2385a78f
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 83 runs,
 3 regressions (v4.9.268-223-gaf1b2385a78f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 83 runs, 3 regressions (v4.9.268-223-gaf1b238=
5a78f)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-223-gaf1b2385a78f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-223-gaf1b2385a78f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af1b2385a78fe42c791a6304ba7a9caab9865fd5 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2b6b850b8037a9fb3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-gaf1b2385a78f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-gaf1b2385a78f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2b6b850b8037a9fb3a=
fab
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2b6a7e36890c8d0b3afb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-gaf1b2385a78f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-gaf1b2385a78f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2b6a7e36890c8d0b3a=
fba
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2b6b0e4e1245083b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-gaf1b2385a78f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
23-gaf1b2385a78f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2b6b0e4e1245083b3a=
f9c
        failing since 184 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
