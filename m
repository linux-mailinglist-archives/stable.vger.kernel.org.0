Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5481FA728
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 05:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFPDxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 23:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFPDxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 23:53:04 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6055C061A0E
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 20:53:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id l24so33950pgb.5
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 20:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ve+/ExGPS0JUJ25KQEIHvIjHu/7QFiIR/GM/4LrinGU=;
        b=JcsyJdVK2EkrYC6d5c2JZlnk9WS2L7lqrMyZU1FfuLlZPh72UJjmGd0E1jO6z+ulQj
         tQ4m6bbU4+RX2shaRugewPXtEeaNawtUg3WwoFwJrUdjgbxdZ27W8jHWGDPXEW6veCfP
         ncNeY5krcw34uPprShLY8x+p/IRE2oNfOpxPZIfl9vobEzsjr/jDNZX+AZOkbAtghwUS
         VZvIhDaQQYbu2nyRTl7qGeDJGIKE+4MOuEOuw0yieQOeZyqp2/YJESqfLJ/+Aui6jDwP
         CfUaKgRGFmmngoDd+DEu0sNtuW3QTiEWyGC6wT7r9ISm2vRk6ZYHA8k/E15OyB0uBQk4
         48lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ve+/ExGPS0JUJ25KQEIHvIjHu/7QFiIR/GM/4LrinGU=;
        b=ocXm2h9C3PF+3Chm8PCy0daaaWvaJ+0SSZpJsjxvc5vLvRDPZqeRJ+L9hMGy+c1Pcr
         KLdWouFWsfohJVpjPu08h/2bnqgU2l88blVheUk9xDnxmIuth+a+iH2NqT5g+9k2StFc
         Ac02qAroxeDpHnAaRAicWIP6BXsi1m/a4KbyateLQpg/ji2NsfVd1b1krgaoJATChu1c
         W0YSUbYxUpwVJXAjqjTJaVjkge7qTTjkfMboHPTXicT+jHTGVFXLLONar5YuWVw2qCmW
         7/+/hFnK+pyCESQmIjKbZ2jwKIb7heDRQvlecIEwc3Xkk0ZWWirpiEdJh8TKtwk+07qf
         MaQQ==
X-Gm-Message-State: AOAM532CIM2z+JSTKzKRGk6dD7nRkIoy7knZ814p/nYDKN2voDiiOgNj
        G0aauibZJW497VfAmB5mpq4FWXZUvao=
X-Google-Smtp-Source: ABdhPJyeJeyiHwNo1M9L+wf0ditmd2d5Qt+Z5jrVil1S0phGlP8SeRm2BcHB4T9p5fuR1Hz6E84wIg==
X-Received: by 2002:a62:1a45:: with SMTP id a66mr362934pfa.54.1592279583488;
        Mon, 15 Jun 2020 20:53:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f14sm824144pjq.36.2020.06.15.20.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 20:53:02 -0700 (PDT)
Message-ID: <5ee8421e.1c69fb81.1904f.387d@mx.google.com>
Date:   Mon, 15 Jun 2020 20:53:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.16-190-gd73794b63b4e
Subject: stable-rc/linux-5.6.y baseline: 76 runs,
 2 regressions (v5.6.16-190-gd73794b63b4e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y baseline: 76 runs, 2 regressions (v5.6.16-190-gd73794=
b63b4e)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
 | results
---------------------+--------+---------------+----------+-----------------=
-+--------
exynos5422-odroidxu3 | arm    | lab-collabora | gcc-8    | exynos_defconfig=
 | 0/1    =

qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kern=
el/v5.6.16-190-gd73794b63b4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.6.y
  Describe: v5.6.16-190-gd73794b63b4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d73794b63b4ef9b4bd884d4e00d1fd78679a74e0 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
 | results
---------------------+--------+---------------+----------+-----------------=
-+--------
exynos5422-odroidxu3 | arm    | lab-collabora | gcc-8    | exynos_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee80cd6c80f40beac97bf13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
190-gd73794b63b4e/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
190-gd73794b63b4e/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee80cd6c80f40beac97b=
f14
      failing since 14 days (last pass: v5.6.13-193-g67346f550ad8, first fa=
il: v5.6.15-178-gc72fcbc7d224) =



platform             | arch   | lab           | compiler | defconfig       =
 | results
---------------------+--------+---------------+----------+-----------------=
-+--------
qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee80efbc265d839af97bf2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
190-gd73794b63b4e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
190-gd73794b63b4e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee80efbc265d839af97b=
f2b
      failing since 5 days (last pass: v5.6.15-178-g1c16267b1e40, first fai=
l: v5.6.16-86-g1bece508f6a9) =20
