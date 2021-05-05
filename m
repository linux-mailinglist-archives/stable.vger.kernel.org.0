Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548E937486A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbhEETGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhEETGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:06:34 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1B5C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 12:05:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id h7so1642112plt.1
        for <stable@vger.kernel.org>; Wed, 05 May 2021 12:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U89aXWfEsxJ/+aNLNfARAy4KYfUKLocLSk7fH9ILj/w=;
        b=Gq2JZ5SgWg4iCfxBh7tx+mlhE7LL6T91pTXeNs5wn+jf1u46jEZyGIEXRg3+gvPZPz
         vtTF4u2vnx+EBt3AXOD/KzSdAcE0P0/XqbtTIXu1qtaFib2/m4DcboNTwEJrIfoWgGh8
         3Qr69m9QyCJx4AlN/Q0+LzbWOAE73fUw6IONhDji2cnwNXvr4kIAHRRj7oA1OqS6mwNQ
         Ab+ouBBm4ZZo/aHbQFs9yG7fGJpGI9mie6vmGOg/r0zOy7wx+hlh901LsDmbn8DHwHlp
         S3B32AAR9vHxmiTbWpz/LiOEpLSeRf1BcmcFChZvpuDLf2hDMMAmbHnhPpdtaZobmIzO
         yQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U89aXWfEsxJ/+aNLNfARAy4KYfUKLocLSk7fH9ILj/w=;
        b=h0msityLq6L8a1AMxl6tojJbdqp3YxvcywBfiocSzPD0oyp/9jZ4q9XeYxe54YR1/k
         ntYH7HUJwg4POUbVqjajR/xUJK8dVcFux8hu5UpyTKM1s7gWBOFO+0WWZcYmlVlap6Ix
         dv0FCy/f4iy8ujpjUqQylmMHsC4A2MI/Nt8smEUSzGU4jPoX9mAfIBFgLMBqpLQBN72i
         hY+NpzoRqhm5xHwApnEewNacSU3TUyhL7tDw5kTM10dSs35AshkXEIO1ENphRsuKvdwI
         6SMBstP0zkKlnOHBA2eOB6mAXE3wbKLW4FfCfpibQAfd0hJYI16FB5etHjVbEh/wpfn/
         gPtQ==
X-Gm-Message-State: AOAM530OH9hB8/ysaputfWGKELJtIOK0USiXQ5RR2KANTEUTFOfV8h7i
        elHAb5dMCAoD1m9Dy9jb3FYn3jScAo8kfXXt
X-Google-Smtp-Source: ABdhPJxtTMmVheWpQBmEAU5x+h8RBd4msOBOZxx2CopRY9PFQKWrZxcJb8lu/qm3QFsnBOJq0nXQsA==
X-Received: by 2002:a17:902:c211:b029:ed:7a6b:d4bf with SMTP id 17-20020a170902c211b02900ed7a6bd4bfmr539438pll.63.1620241536632;
        Wed, 05 May 2021 12:05:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ge4sm60191pjb.4.2021.05.05.12.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 12:05:36 -0700 (PDT)
Message-ID: <6092ec80.1c69fb81.3210d.0518@mx.google.com>
Date:   Wed, 05 May 2021 12:05:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.116-22-g73e74400c797
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 84 runs,
 4 regressions (v5.4.116-22-g73e74400c797)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 84 runs, 4 regressions (v5.4.116-22-g73e744=
00c797)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.116-22-g73e74400c797/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.116-22-g73e74400c797
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73e74400c797af9bc645d41cfd350b15e3e52d2c =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b950fe2730ff4f6f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b950fe2730ff4f6f5=
471
        failing since 166 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b92570a9431a8f6f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b92570a9431a8f6f5=
471
        failing since 171 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b7ddd4e5a126626f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b7ddd4e5a126626f5=
469
        failing since 171 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092b7dbee25e69aa76f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.116=
-22-g73e74400c797/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092b7dbee25e69aa76f5=
46a
        failing since 171 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
