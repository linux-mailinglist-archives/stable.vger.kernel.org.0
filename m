Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FD13A06F3
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 00:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhFHWhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 18:37:03 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:51177 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbhFHWhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 18:37:02 -0400
Received: by mail-pj1-f50.google.com with SMTP id g4so236264pjk.0
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 15:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4WzLSDru4Fmt8rPIJ/2qtXCv7RTUsdftfEAI27pk6mA=;
        b=JSMIc+PWvaZAp11jxD9BKl3RHvxrqyA+KqGkHfQ0F2QAYkUHRjIxEmJ+/GjmHNCQp5
         /VE1dXYd58Czse9Gxb94DARr0fqhhFZhVnvYcb9Hze303Xx3rU8OC9Ct51WKc7R6xlzb
         eeu5UiTO14DArvpli7YDEXZYxI9aOyDs2XuRT+Qi47g4fWUM/Xv9n2axOpyRhyWAOW1v
         adqN8nJFV9vRPRyKtSlW+2OSAuAOgg93i8oVAVk4vgdw7fWkqwz7ewI23xXw8zPKTD8M
         1eSGMts6yRXamW6kOtV0ZsveNcz4GmY0cxQOxEJNkno6zs8a4crq6ZzgaSAWdiWeQry+
         kHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4WzLSDru4Fmt8rPIJ/2qtXCv7RTUsdftfEAI27pk6mA=;
        b=EZ4k1Ab3y6vhGsvLpaXQWD9Z5Jc9Y9anCy3lq955jnKKnZc8VfFR6TWj/t1no0MjY5
         28anQn5SlbMhgLTvQeJaH5WkegpqslpVA1kSekbrG1wn/ekcMob8l7kAJhDm5TBQkoSQ
         7XBMrmZR9Ajc/zPzfAsG8XCp+7H7vCs+i+xksJVqxuKLSmbqNsf9hT60ayRgJa+Lk14I
         4zaWDuS9ocwG4YP//KpiMMmOT6qM4I2Z6UnVHfVt9rTG12XmROHgpnfSMT/PccAqWdy3
         ViBJQ9zF18Q7xax5q0cJY6AQF7+M6nWTBc29UBl923HJitRoOZWwqea/JRs4nMHA2XC1
         5K/g==
X-Gm-Message-State: AOAM532KDZG/4sUnwsRB1nCK1I0L0Qw8IZOKQLfQP/BOsDhXl3R4GluJ
        KgduiRovrlMIqGxUrCrq/XWFnngsrLJaWRUC
X-Google-Smtp-Source: ABdhPJzpKfIgg9QWXLR95qMOz8XTmDYw75LJX+W5tLyE4IGfW3RlUdUc7c7i/WwtU9Msx7NB70QBPw==
X-Received: by 2002:a17:90a:8804:: with SMTP id s4mr14279718pjn.200.1623191649133;
        Tue, 08 Jun 2021 15:34:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b195sm12536481pga.47.2021.06.08.15.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 15:34:08 -0700 (PDT)
Message-ID: <60bff060.1c69fb81.4dc00.71f5@mx.google.com>
Date:   Tue, 08 Jun 2021 15:34:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-29-gb9ac29bc7220
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 116 runs,
 4 regressions (v4.9.271-29-gb9ac29bc7220)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 116 runs, 4 regressions (v4.9.271-29-gb9ac29b=
c7220)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.271-29-gb9ac29bc7220/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-29-gb9ac29bc7220
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9ac29bc7220cd61d7f0beb44876b88096e0f9e5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfbc4a4a3d863f8d0c0e12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfbc4a4a3d863f8d0c0=
e13
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfbc86077385b6de0c0e04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfbc86077385b6de0c0=
e05
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfbc68b911b1c8e50c0e04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfbc68b911b1c8e50c0=
e05
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfd55f0c314e13ef0c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
9-gb9ac29bc7220/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfd55f0c314e13ef0c0=
df6
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
