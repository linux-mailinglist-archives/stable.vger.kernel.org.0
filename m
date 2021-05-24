Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B248838E73D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 15:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhEXNSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 09:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhEXNSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 09:18:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E61C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:17:06 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q15so20063206pgg.12
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KTkc+6nHyhF+dnua4l0FbG4jxqKU9Ny/OYOnVEQS4io=;
        b=wIJVuIn8OAtQjKHGj3svhK+fSCDTxHu4VzJNR+GkvoksA5pdI6+kjVRb1oiFzs+oaP
         I9DKor9OUbLTNqsMTFbjEvqyODn5A9WyCQvTiOdYaY3GOQXlsoGAujVIwBnKJR6Ys8++
         e9RC578DehtKn5RLl6C1hY1cATk+ZbHSleYcKQ0XatlFb3qV/FqhK6+XmgRS4mK1AL+p
         3c0MgaW1BlaZJfyAvWhVq5yq+Uy8eNDfq5e09rPtFj8VgGLijdBUbHuWZgLK3U+cn3ey
         lhLPZFNnN/U4o3rt/b+89K7YqblJNv0RUFBvBNypimNL2yDDbDSbpx+BUwYZh4jO3vl1
         etJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KTkc+6nHyhF+dnua4l0FbG4jxqKU9Ny/OYOnVEQS4io=;
        b=FZ1W4L4p2Ua/w6NnRiTwUSYHe1R17wmOUa1CX+uXmm16CnX8K+MOd/DBRyPk0B1FtE
         NF+JtikdzOWGyOoNTK2rgB4d84VR5gZV8/pi73UZ+KSZNjJqh0+a+1tiUKHqu4cC+D85
         ktrWq+gE1nktQphyXNjEk7HETzDWGhfgPVemkDHkvHVfh8g83cU/dFWslheN1fluT6LM
         6ZkCBzAZEs3ioIxrYdWqlbxMjslkRpRYZZXj9NjLSYV9Zy9fp4UrIMjS5/QMuU412Zv9
         G8ayl/RxRcmXpLl0t4f1o55HtoM2Qt3c9FSaRRFDP563mjbTjQDOtIueVSicbKID8NZC
         JcyA==
X-Gm-Message-State: AOAM5323rHioyAMuk2bzMUscrpOgt8Ux9WNySVQAw/tTPruGIY/izZnA
        C0ZaJxvBPp0ufnirft6m3a3Aazw7RmSPunj1
X-Google-Smtp-Source: ABdhPJzlv8ejOaMsMELBTNsH2LN4ybt0DRpWbz8VW3YmY5rPpd+xEodeCNmjhQioXziCCxpASlDmxQ==
X-Received: by 2002:a63:205b:: with SMTP id r27mr13794839pgm.95.1621862225907;
        Mon, 24 May 2021 06:17:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm10956316pfl.191.2021.05.24.06.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:17:05 -0700 (PDT)
Message-ID: <60aba751.1c69fb81.ae95f.432c@mx.google.com>
Date:   Mon, 24 May 2021 06:17:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.233
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 85 runs, 4 regressions (v4.14.233)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 85 runs, 4 regressions (v4.14.233)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qcom-qdf2400         | arm64 | lab-linaro-lkft | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.233/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.233
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96afcb20f36f07683aaa342e592ea8ec76fd1fa6 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qcom-qdf2400         | arm64 | lab-linaro-lkft | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab7436b404085858b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf2400.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm64/defconfig/gcc-8/lab-linaro-lkft/baseline-qcom-qdf2400.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab7436b404085858b3a=
fc8
        new failure (last pass: v4.14.232-324-g7c5a6946da44) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab7628b9ca29f4f0b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab7628b9ca29f4f0b3a=
faa
        failing since 190 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab76055be96c8d99b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab76055be96c8d99b3a=
f99
        failing since 190 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab79e4281a2d1cd8b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
33/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab79e4281a2d1cd8b3a=
f98
        failing since 190 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
