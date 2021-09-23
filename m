Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F4741621E
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 17:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242044AbhIWPdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 11:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242052AbhIWPdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 11:33:43 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3CAC061757
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 08:32:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t4so4311138plo.0
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WUkKVBA3MBUQnU4GZJMcbR4pef1ANSPyaeYYA7SLltI=;
        b=rIwxkC+BygLWncR6yM0HL9AHZjJR0PqtP7zaG2QlwSlCoFe9tS/lN3OciUNfTzS8RG
         FVK1Bv2JBSM1+RWoL2b0Sgmc2Ij5ApbMCsxitGsF+n8h5BDQ4kAVAIzMzueA2G4025AO
         3DeC4w320Cj8byuerk9PDq8bC63WbRedbmXPfZGv/Q/jh44rrosKITKYqIOEmCPBnGpc
         JQ4l0Kt7rDzhdCR7wF08w5f6FBnOze3BTepZUDG9/VqQc1HP/UkdJ2gVoqtm6HbkH+iX
         eCLamqc13G7CirhqmgW/JKarQceBfou6bVpPbCOmNFOupacv0lO8Sb4oNNgvxvvTbfya
         b7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WUkKVBA3MBUQnU4GZJMcbR4pef1ANSPyaeYYA7SLltI=;
        b=DC/cBpDHCe75ZCfOxn1zaAtgaW7PzSSdmu1cwXlabtvUS1pFh0IiCLwa4JP/E4vf54
         wYJzZu2IBkxOJa8Yx3TSzCxFD7IIUTQ8SjB0M8/hpEQJ9ZcOHJXjKFCsiLh8VLl8aN4S
         mq6MtSQHrshdxDn58+0Km1TDPPnKyCtsvf7SHZI+r7+91ERRzP9qYnRSmelWbSQJB0yg
         LQL1obAW4WfbVCetZUNzR6/68+/bQ75O2CVIMGngyKSTrI3kHk7lnxorcWfgVeI2D/p2
         4SvnSefYCCJBFI6/s8mu3wL17jvqNVUBjgTq+xo+V182D9rX9BWmQlNKCN7aUU8wpqPu
         hjAg==
X-Gm-Message-State: AOAM532KSBdO5mDqBU+CiwasiarVHAzcqLNJ97UjMSb3zeCImlJ/jfyw
        gTxkn2f9B3gwLO+5wkfDABaVlZ1y6hiTxGcq
X-Google-Smtp-Source: ABdhPJySsqyqbMbQpjaW9/jMhk3nSHW0x38QtpLSuPzh4YSp+cHxvjYw9uNvQOkrobb0sb45iczF/Q==
X-Received: by 2002:a17:90b:3508:: with SMTP id ls8mr18439739pjb.240.1632411131279;
        Thu, 23 Sep 2021 08:32:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm6140031pfr.124.2021.09.23.08.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 08:32:10 -0700 (PDT)
Message-ID: <614c9dfa.1c69fb81.e64f.257a@mx.google.com>
Date:   Thu, 23 Sep 2021 08:32:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 120 runs, 5 regressions (v4.14.247)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 120 runs, 5 regressions (v4.14.247)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.247/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.247
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ea4f73cfa7e0555dc03aedde52db54a6587ab43 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
i945gsex-qs          | i386 | lab-clabbe    | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/614c6a21df89c25d3599a2ed

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/i386/i386_defconfig/gcc-8/lab-clabbe/baseline-i945gsex-qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614c6a21df89c25=
d3599a2f5
        new failure (last pass: v4.14.246-124-g4ee8e281f1b2)
        1 lines

    2021-09-23T11:50:42.972713  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-09-23T11:50:42.981701  [   13.904335] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c6a029b6c31f2bb99a325

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c6a029b6c31f2bb99a=
326
        failing since 312 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c9ab265585c4df599a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9ab265585c4df599a=
2df
        failing since 312 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c6b7d8a0acf789699a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c6b7d8a0acf789699a=
310
        failing since 312 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c769c3666d992c499a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
47/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c769c3666d992c499a=
2fe
        failing since 312 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
