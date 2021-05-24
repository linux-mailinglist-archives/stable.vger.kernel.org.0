Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27CC38F154
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhEXQSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbhEXQSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 12:18:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368C2C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 09:16:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso11436138pji.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 09:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y1OQwoNV16+vrlE/sZC1vrTwOoqf0/xHIz4LlJ8O1kc=;
        b=RcCNvxlHASNkVVVUY8AI6RZYEjAofhkw7lyhTVixAOvxKlDLvDMeJhzpYzpxxHr+Hn
         jznU6EPzU1Xs6f05gPLPGmmP4eSGVD6Qto7JeH6ScnyQhHUqyg1j9IDQQ6g3Lj6oqte6
         pS8l7RKw0ydIFuyJ9M4y5Qdj5rty5d0iNe+8k0EnkrzV9//6/WYOSNcX9OWxBU3RFJls
         2B7VKXfSzrsBgt4JBpj3ruj7NoRGVDLRXiV1qlELG7144eN9E7JNRGZcZIpjxypyLkVy
         6SkldCc4kByXwm0lEaiQNyv94PknTMZMiftLiexr+p3nAjfsdLDV7GhwrFy9jYJ6+mc8
         x62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y1OQwoNV16+vrlE/sZC1vrTwOoqf0/xHIz4LlJ8O1kc=;
        b=l7UWEtgN5ZpE7RbOullCeEVMmpkhPtta7O7idlfjww8l+EKrG7QasRLlh4aAOsNerl
         DraIolOoIJ9t+nNu7LnGoeJT/wGTwMgYV9Nc538JvD9BEkaHt86KChEyYihSeVOPaSAr
         o+RUsrrZgHCvQS1rlIi71TEwP5pnkXiN3YO9kOBl5msqI9Tm3YLByHaXGxu21/OlrbKg
         GR0pB/mi3hYzRC6iK0eUI4yM0CykAXjRKxU4manfOd4GWlsbAcUbqA3Q0ymZrbed0oF1
         CmapOnrOW3XQXuF9UqzDqY7Q4ZULkVEDQp3PYP+j5pNmGh5p6zREg+Qt6Vpa8a/GWV3Y
         z0uQ==
X-Gm-Message-State: AOAM532Q1NHXOJ//qA0K3FNV/oB+xVVZNwMdT24Rb3TPH4EzXPF+YRVE
        qIHWdZ1sdZduJVagZmLJQmoEsZ+wHMHmJT5K
X-Google-Smtp-Source: ABdhPJzRLG8pupO/ybLdcWjRrB0mIBf34LK8gVNVbIH1TKVaydL3FeIZQigPxu9lbBAo928d8MSq3w==
X-Received: by 2002:a17:902:f203:b029:f0:d225:c6e4 with SMTP id m3-20020a170902f203b02900f0d225c6e4mr26181301plc.0.1621873015485;
        Mon, 24 May 2021 09:16:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m1sm8190320pgd.78.2021.05.24.09.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 09:16:55 -0700 (PDT)
Message-ID: <60abd177.1c69fb81.1eaa2.969c@mx.google.com>
Date:   Mon, 24 May 2021 09:16:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.269-35-g47d841924d4b
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 77 runs,
 5 regressions (v4.9.269-35-g47d841924d4b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 77 runs, 5 regressions (v4.9.269-35-g47d84192=
4d4b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

qemu_i386            | i386 | lab-collabora | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.269-35-g47d841924d4b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.269-35-g47d841924d4b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47d841924d4b684aae16c05a63d6c6b187fc1c6c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9e5cd073ee3c3eb3afae

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ab9e5cd073ee3=
c3eb3afb5
        failing since 2 days (last pass: v4.9.268-239-g6707ab3bcf1e, first =
fail: v4.9.268-239-g7ec3767d9eb2)
        2 lines

    2021-05-24 12:38:48.609000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9e453e1f469171b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab9e453e1f469171b3a=
fae
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9e553e1f469171b3afc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab9e553e1f469171b3a=
fc9
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9fb10b57387346b3afd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab9fb10b57387346b3a=
fd4
        failing since 191 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386            | i386 | lab-collabora | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ab9ff9aebc7dc75fb3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.269-3=
5-g47d841924d4b/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ab9ff9aebc7dc75fb3a=
fb6
        new failure (last pass: v4.9.269-14-g858d860b7028) =

 =20
