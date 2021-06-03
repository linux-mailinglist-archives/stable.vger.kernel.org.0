Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5823739A297
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 15:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFCN6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 09:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhFCN6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 09:58:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDB9C06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 06:56:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ei4so3677035pjb.3
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ubkfrzjWT0BV5xIJWqfuDpKU6EP0LqjefMAPgsmpBwY=;
        b=VH7OU3ReOmU8IQ3n7nboe0uuv/9KzRaVl1OVsscZVRIAok8ePaQKk/CB5+7E+4Tc9q
         VlLQyAN4nLdMDvewxgAgwxFKVfgBV2fCmfxx4LYEo4W8XOwKML4JjmTbvv9lN5Q8FvuD
         5X+9X2Bn4R1S8n61CGcqiiXi8GTKlAvHcfBrrZTroF0jqcodqziL224VOKpafWECfbHz
         Trkth4M9a6gcIHowA/bMBSWPOdgZQj2a+Eqt29iCRAt2dXDOBtEdppR2k+9cG1vbmFxf
         b9trG+bjwLMr6d43sPLP33vctoDNeNbB9gyNiFr7H87Cj4B1vBukj3XHtQQJglZTpxBK
         hULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ubkfrzjWT0BV5xIJWqfuDpKU6EP0LqjefMAPgsmpBwY=;
        b=JEOHatRE/ouSSFLENpe/EJhVz82QHnM7Sf6a/w2ALB9LskYRdaAKvGLAI2RZCZ4p9E
         GORg/+8zUKDvWzuRj7LgBsiHMLUKom67qdvPYdq+0DCnnTv5SHocVw0BdcAe5E7tGGNQ
         1ItX3hkKVKwwOTKvB8fBy3MZ/oof9DxTQIQzDmV/mavohnZn8pI1RKHXw5CHgBI5eh4C
         vitROyHCrR6v1nWHIcLV8jy4R1+tkTottzIulnYlkjTwbRqs2f78ZD3xeIt8auIIptko
         hLBFjKm4UAKQCKiaa7Kel9NQKZCIQmkKYgiwPg/y5CmUtjl/LKlDCLbQ4rNLkq6uPovi
         p6KA==
X-Gm-Message-State: AOAM532b9j/jdocqK6fFhfgrI2M54DIs5zfnlhwYNFuwd97Frsdj4AZr
        GBVIlMv2jmpsf1CHvDd8hyIgKCREm+B8Rg==
X-Google-Smtp-Source: ABdhPJwAsgPF0THIchzGn9+baJn55Eb92X51V4U1LqOW0sTLT5uBPZLm9WMYrmWQfrBQHoYNH70EUQ==
X-Received: by 2002:a17:902:6a84:b029:f3:f285:7d8 with SMTP id n4-20020a1709026a84b02900f3f28507d8mr35142860plk.57.1622728600446;
        Thu, 03 Jun 2021 06:56:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m14sm2541976pff.17.2021.06.03.06.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:56:39 -0700 (PDT)
Message-ID: <60b8df97.1c69fb81.1c390.7b49@mx.google.com>
Date:   Thu, 03 Jun 2021 06:56:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.124
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 116 runs, 4 regressions (v5.4.124)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 116 runs, 4 regressions (v5.4.124)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.124/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.124
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      70154d2f82a9058e8316b6e106071c72fcc58718 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8a5abcbb8c50ee3b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8a5abcbb8c50ee3b3a=
fb2
        failing since 196 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8a5d04c4a4daef8b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8a5d04c4a4daef8b3a=
fa8
        failing since 196 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8a5dc4c4a4daef8b3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8a5dc4c4a4daef8b3a=
fc1
        failing since 196 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8a5850df5c52605b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.124/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8a5850df5c52605b3a=
fa1
        failing since 196 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
