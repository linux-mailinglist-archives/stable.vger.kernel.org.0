Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99F322A664
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 06:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgGWENw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 00:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWENv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 00:13:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A83C0619DC
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 21:13:50 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 8so2542174pjj.1
        for <stable@vger.kernel.org>; Wed, 22 Jul 2020 21:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rZmGNk5NTuWKcACzoWaSVFbyQWWTC/GLEzdq1DqsMn0=;
        b=rY0lL/kYcAw1Pg7u5LBK476+2l2mZzxnRBVig5y0MQ9J6De4IGADjbYT1zUbB0mXWx
         dq3nOa1bxq5IESGSiupNHQFRaFmJiu6csv8a59Ej5K2cD/v9zJ6nMn7ZJbwp/fvHh9MD
         cWrMUvNFmEnDilwud4Jzgb73gZ9r3p2AtqVUbm8+YUyuA/d49McxCatA+pmM/4tMZ9Qf
         sz4gNLXOpviudpLdUbZQ298mzFBeTjxAt21hA37Xlup1xWG6kFWd7QNpYklynzFhcGYl
         +EQc9mZFamrciw7aYKdk8zOG/aFqq+rCnJD8VcGUDbPHN+v5hRXAKTkTZF5EMPTJPLrF
         ANmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rZmGNk5NTuWKcACzoWaSVFbyQWWTC/GLEzdq1DqsMn0=;
        b=nXcyYjZl+IWjBAcwNpJQxoTXECPh0Q7++PXuizqYYHFTl/JeFvi9VofTFLZ23ntt03
         5v4k4UU7ojaUmaCH+2wvv0Ro24THJwx3G4CiSdnJo5PEC88RG7VRFI2OoSLPwj5hv8MK
         XZQAK/K/GcoYJL3td7/QZ3xiLX/1rXgk7qbtqB7/P42n5gkToZmXAIsO5xNSpqIIL5qr
         V692LoSe0kFGHdeEFVtGN+in4epF2a6WcdHBB+B2MA/nzAwCfOoVycnuTFUhydSMq80p
         njyL7p6nPxWM/1jDsHNoNkK+E27IUjLQ7kBn27AtItUXXfUT04yf4Scb6SB7Fc6NkaLD
         9YKg==
X-Gm-Message-State: AOAM530OnthphB5tc4ZoG0VukItqM4AQP0N2H4GZhQr45lDvUNvGcbZl
        Lzqfi5JA7f8NTzFC6NhPF4ee6qA5NRg=
X-Google-Smtp-Source: ABdhPJyGSFhFwdgfie9DtrwnARTlczzc83DmsMaEqJeNneFstzmHxBOYEWY81aSv9XACugPYibcSYA==
X-Received: by 2002:a17:902:b58f:: with SMTP id a15mr2321903pls.87.1595477629274;
        Wed, 22 Jul 2020 21:13:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s131sm1249370pgc.30.2020.07.22.21.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 21:13:48 -0700 (PDT)
Message-ID: <5f190e7c.1c69fb81.bdc8d.3e93@mx.google.com>
Date:   Wed, 22 Jul 2020 21:13:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.134
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 171 runs, 2 regressions (v4.19.134)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 171 runs, 2 regressions (v4.19.134)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 4/5    =

hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.134/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.134
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      20b3a3dfdf6c55b50bbdc8e231a3dbf6bf965dc7 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f18aff8d8ccb2ce8685bb1b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.134/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.134/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f18aff8d8ccb2ce=
8685bb1e
      new failure (last pass: v4.19.133)
      1 lines =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f18cb8d5d2df4d63385bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.134/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.134/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f18cb8d5d2df4d63385b=
b19
      failing since 6 days (last pass: v4.19.124, first fail: v4.19.133) =20
