Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7651381A86
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 20:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhEOSck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 14:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhEOScj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 14:32:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07C5C061573
        for <stable@vger.kernel.org>; Sat, 15 May 2021 11:31:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf4-20020a17090b1d84b029015ccffe0f2eso3365686pjb.0
        for <stable@vger.kernel.org>; Sat, 15 May 2021 11:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YjxsmB+2KaUwY411PUC0SJE/9BcDxY7TFv2fsg5f5lo=;
        b=SYrj8vyzHfjUpLKIt/TbdL8Go7U0w5d0ZH5TO090qxeWQQWBvFAVS5p6wXKMuHenC8
         35h933VbP+yMr277FP8HbzHcPUD19w38COYN+H98I3lju9/khWpGnInLp8E5EQ74Dv0T
         0kPqs//DnFwHqCHlIzCES8o11IOlqPIWHZjtyzi/7ltigqor8WwG5UUyB6Pxt6GglgKa
         D7LrAqiQG18StkMD1NkKfxj1etFmXcmD3iJm/O0nvTq5XEV1UO3doCaJ1V1nn4m0eXB8
         HRvOVlM2B6DridR2hoh2LWx0dtZK3TCIsYwsCkbAe9yyFlRcQ2xbecwykOe/PoaDanZ6
         gLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YjxsmB+2KaUwY411PUC0SJE/9BcDxY7TFv2fsg5f5lo=;
        b=g9SAySfx/WsbOxcDgB3qD6ICjUIu7lsWdCIf1Gmd4dF7vMBu0M0YITUFiQTnGS2M4+
         OdY9/fvEVf4+HWvXR6o/I/7gyame4I+dZA5DLgLiFbHpcDYzWmX3C5kyVpqtlkz//BNx
         dyuzJc28EEPcDZb4Bv3xOxeGPtHUhGPDkqP7sbLK/Q06Kd8dnmiMuv1SNN+zaMJNGVkX
         HMtWPTYOFt788LWIfzhG6PQLkTo/WOqaRUj7sgClxsXFFmcWRWlLY1zL7ToaCa120Pvm
         osJ0BEanPfY3GI5Cby6VPVE4u2kkq1EZyzR8UoxRehEv17u/JI9EMyoCblm1gWc4pO79
         EJjA==
X-Gm-Message-State: AOAM532Qkx+lff4HkjIwDzld6qQ2aabJ1nJf0B4yCtDE1nLjiOXPtuL4
        rW53isMlkuLUxPCjUQyGFP6GlzQ557vwXtBR
X-Google-Smtp-Source: ABdhPJwPtN4v0h1kbcXgC57PgI41Uupjx37ha/QSqqJeMkEjW2PW0Y7LPgn8nNcJx+dWEZojQQkQVw==
X-Received: by 2002:a17:90a:c096:: with SMTP id o22mr18132573pjs.231.1621103485005;
        Sat, 15 May 2021 11:31:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f20sm6872839pgb.47.2021.05.15.11.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 11:31:24 -0700 (PDT)
Message-ID: <60a0137c.1c69fb81.26235.7c69@mx.google.com>
Date:   Sat, 15 May 2021 11:31:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-95-g597e9eb189ad
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 77 runs,
 3 regressions (v5.4.119-95-g597e9eb189ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 77 runs, 3 regressions (v5.4.119-95-g597e9e=
b189ad)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.119-95-g597e9eb189ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.119-95-g597e9eb189ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      597e9eb189ad42b0e2d9125d720f45f51adeab09 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609fd70c6ca405990ab3afbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-95-g597e9eb189ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-95-g597e9eb189ad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fd70c6ca405990ab3a=
fbd
        failing since 181 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609fd722a4cbc9a0feb3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-95-g597e9eb189ad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-95-g597e9eb189ad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fd722a4cbc9a0feb3a=
fa1
        failing since 181 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/609fd724a4cbc9a0feb3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-95-g597e9eb189ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-95-g597e9eb189ad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fd724a4cbc9a0feb3a=
fa4
        failing since 181 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
