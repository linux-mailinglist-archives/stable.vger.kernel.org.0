Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99B01F607F
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 05:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFKD3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 23:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgFKD3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 23:29:32 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FE2C08C5C1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 20:29:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a45so2675508pje.1
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 20:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X5qvg/WPHo1O0GmrDtkhONV3vVHBeaPunQsFj8PiHAI=;
        b=HmBv05AVwv/lpvsnk+Y+NlPZmV8lsJxYin8jgU6pMtHXCRi8WInSPMUbYHPw6jWASz
         Fvn0NHKXVXGoCNYnsSOHlk468jDmXY3BJFZtFu/8JFwjw/Ni9vIxDnsKDWYD7ERpPuva
         aH0b0Sx1SCpu0NkWavsac+W+aPVxGO8e8Iq4H/olLVxUyGdbJGNgdu45Z+NSJq7mJ7zG
         SX/xQpFqtfMnNMZBfRRVTqz1d5PcUk4pZgRfr0bhYVeKdXZO9Y1qtdsEBBdbxmzp2mtw
         eZFdZFDjz6suZg+cRUQp0l8WHSdwKrjZEmI6eHvBkKHAvSHqY0EjJGEkhB/ifpWUzD3G
         qaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X5qvg/WPHo1O0GmrDtkhONV3vVHBeaPunQsFj8PiHAI=;
        b=rWA6WjVjaqu/GEobps7IVwYFp40CKGMIed2agail/R7aEAbER4dykMVU6eaMWJeVlo
         gcXaTGxjClifDn6by0N7Sm8lFtn3I4Zs0CgxcNGrH8L9+l3JJzZPBjYq5jkvEug2ZR+Y
         vBT5VErnsqyyw/+q5f6KkrLdi6iNwXG3sfybmzr5xaXCKDQPqy5FgI8/SbNkGi9hxReY
         3dFTh/2QwX1AN5/NCaZxMOwOMy9tTIdFYmIKYji/f3T1+ABCNxzOBB2g/mQpFDmK0DYu
         ozRB9SmtXL8DQ7/oNx5ALOiGoaybfsd6h4cPdP9WSbTQegT6MXAx2rjxThiUPZc3qswX
         U6Pg==
X-Gm-Message-State: AOAM533enNqP3y64YpIJkaLaIjeRKGhtIYpG+kRDnRCcSNP6Z/lUOrgm
        1A6DnxWJdo8ylnvuzcKU09mG9OudIcg=
X-Google-Smtp-Source: ABdhPJzWtUHcoEArnc36jC5tZGCqVaaZiJv6JNKhS+4CYktXWQbRZWsHoIAHpDdq8RyuFR1kTfQ9fw==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr6090704pjh.10.1591846170104;
        Wed, 10 Jun 2020 20:29:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p11sm1383305pfq.10.2020.06.10.20.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 20:29:29 -0700 (PDT)
Message-ID: <5ee1a519.1c69fb81.c2615.4dd0@mx.google.com>
Date:   Wed, 10 Jun 2020 20:29:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.18
Subject: stable/linux-5.6.y baseline: 47 runs, 2 regressions (v5.6.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y baseline: 47 runs, 2 regressions (v5.6.18)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 4/5    =

qemu_i386       | i386  | lab-baylibre | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.6.y/kernel/=
v5.6.18/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.6.y
  Describe: v5.6.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ebc59901aad6745e9eade4a13ee616a71e7a5315 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ee171c47ce5f3bd5997bf09

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.6.y/v5.6.18/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.6.y/v5.6.18/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ee171c47ce5f3bd=
5997bf0c
      new failure (last pass: v5.6.17)
      2 lines =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
qemu_i386       | i386  | lab-baylibre | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee170e971f2e582f997bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.6.y/v5.6.18/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.6.y/v5.6.18/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee170e971f2e582f997b=
f0a
      new failure (last pass: v5.6.17) =20
