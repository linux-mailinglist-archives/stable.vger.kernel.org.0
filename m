Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3DB337B2D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCKRnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhCKRm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:42:57 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F144C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 09:42:57 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id a24so10551287plm.11
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 09:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p59HxFqZ0BgTT9YIy8HZIaX4VVnSfnOCkHCNJY3TgDY=;
        b=jU0Eum7JNr1g9OyNxSu/8l3OC8zozDn2ZKRUyGjx3ur2xlhkwmVSAl5b9raqL7gfVt
         q+tTXSMDW7a0r7jo3w0UHJdhG49AbdDiLWC56plsHa6py5Amue0zczxJUMM3OgVy2IHq
         srH5d3OZsU9hSmUFsjKqBipNZNEGX1HeTrjKsF6BHtZqIXgjLA4ujejx849lXNa9p5s2
         oiN0/4QnVZCzSB0eMv9nzJIit5NiCbkThJInPPSVP3faMTaCUG/CNZMKznb6PuJ7rcKz
         jORgiItVFi88iqCp+RU3eOpb+5Z39C0Q/0Iod51HOznE+9faMMsNIY735puhq2f9xdPk
         SVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p59HxFqZ0BgTT9YIy8HZIaX4VVnSfnOCkHCNJY3TgDY=;
        b=YTWPl59pXiM8SZD1qURNRkSNF0U86tBMntYYGRJGV2GBGkCevSBnaayRmuvcryiKfF
         ee2OdKSIPygQBtr5zEXVXsRdmoE4nVGIy1Y0I+98HmXkjVLKhuwcT3oO3YseEVuqyemE
         jA/hM2aMAIAR0C2BcnqftfoURRMFOJ9Jr2J+KETwpFFiiv/L3CY159QXBfKTLrwBo6gp
         MQukqgRWcTpMZ7xTa6d7XRwVDwYUuSjkBo8QB80Neg1mwJ2yFUW30QpGKOo8xY9WkqZE
         Zh1p35mMHqRm0EN6IRkSeI1lR8aY5wnLdAURmm+XrZMSrwGstHM3jibYPXigKayqTzjv
         9vfg==
X-Gm-Message-State: AOAM530iaheVh3vkKOsFSr0/N3YwkuiFnmQ0VCwFwCy9luhg3ek8seI4
        bC51904iuFSIk9bpUiRZvUlY0Usd/5ZUib5A
X-Google-Smtp-Source: ABdhPJwwDlpv9xQib4Z1+dra9RZ7aYE/55IiLn/aRgMuczy5jW89UhQPT3Zqotvn/Ik52+K97K+ASw==
X-Received: by 2002:a17:90a:9b18:: with SMTP id f24mr9621188pjp.96.1615484576706;
        Thu, 11 Mar 2021 09:42:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm3009740pfs.185.2021.03.11.09.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 09:42:56 -0800 (PST)
Message-ID: <604a56a0.1c69fb81.658d8.82a9@mx.google.com>
Date:   Thu, 11 Mar 2021 09:42:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 93 runs, 4 regressions (v5.4.105)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 93 runs, 4 regressions (v5.4.105)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.105/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ce615a08404c821bcb3c6f358b8f34307bfe30c9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a2185cf6d23d38aaddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a2185cf6d23d38aadd=
cbd
        failing since 112 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a218f4eb68c585baddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a218f4eb68c585badd=
cbc
        failing since 112 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a212ff4379b4319addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a212ff4379b4319add=
cbb
        failing since 112 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604a213bf4379b4319addd0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.105/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a213bf4379b4319add=
d0e
        failing since 112 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
