Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BD842CA9A
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 22:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhJMUFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 16:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbhJMUFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 16:05:30 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B07C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 13:03:27 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r2so3355867pgl.10
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 13:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CjzF5ALq/yzqbq38VPFXUawITy/vaW/bOAZuzsAlToU=;
        b=tCTTxaaFL+ryDHDRkcOiEi/odsHDuwPA+U35eZEjdgRZbKqwfD1430LnaO2AB6wjQ/
         44LllDK1Q0mihO8MfT4QPtLAW7WIhyhN8HqEYcvsAsa3QL8QjWp2eOYanGrZ8HPCDo28
         P8LkNT5UY1qSp/UU5HGB8wRKMr5XjHhpw22GBrPaD6OLR3sUvAQEP6SRIAHBiMc1+ffj
         0R8OBhOrswwXeHoWrr24oA8sFYCa1Equq1TT4dj1/XoLw4XaOPLhS1UzwbpFKjR62Rgy
         /x+zKn8jvuTszXFQya/+LlBdh+LSgabEUqqADaUIiqZTN1Ctegzyv8JsBAgGliJj+oFd
         JWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CjzF5ALq/yzqbq38VPFXUawITy/vaW/bOAZuzsAlToU=;
        b=l2svK1GUTAy3Ntz+Bl+0ADyDQc2AHyhDEMKaz6wM77X+8TvFEljpQZawWTatNs2yMa
         Y+E0wReMVmBir5XfXpnJKiek0nJL6rtYyA0VjC70eIYYGtQEpifQEnHcwlMNTURGugam
         EsSNGdaaE6Hkx5CSEO8gQDxr/34f8Jp8rJKGsJ5JNmzT7qKg1Edua7LEK/wtTKaDg8vp
         WF4eSXPTR5JTBCWF9n4XIzYEu/ln1arV4pU1V73u1eRHbUgMD2SD5w+F+uGs9w3fdC3Y
         KdlzM7LDWcwpZOgcmYeBYz2m6dgiw76J7G+QjWDz1mENFKzXoQAimlc8h+ONBNWvR2Bz
         P1Pg==
X-Gm-Message-State: AOAM530jyfAk1hE/ALOskNBn0Ye8q+Om98m+wfhpYrkwmJ97+sK58Qxc
        3e2RzdWzLtEbb6EZvF7iG9pMcEjqGRJeLPv+a+g=
X-Google-Smtp-Source: ABdhPJxVEMkTg5C636m8/FoAonql1JI40c4NXNhwVqd26nmH013PVtdqhNrhY51exenJkHkSpIbtMQ==
X-Received: by 2002:a62:8f53:0:b0:44c:5d10:9378 with SMTP id n80-20020a628f53000000b0044c5d109378mr1342435pfd.19.1634155406577;
        Wed, 13 Oct 2021 13:03:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p31sm296274pfw.201.2021.10.13.13.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 13:03:26 -0700 (PDT)
Message-ID: <61673b8e.1c69fb81.da1a5.15d2@mx.google.com>
Date:   Wed, 13 Oct 2021 13:03:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.211
Subject: stable/linux-4.19.y baseline: 87 runs, 3 regressions (v4.19.211)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 87 runs, 3 regressions (v4.19.211)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.211/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.211
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3f8a27f9e27bd78604c0709224cec0ec85a8b106 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616703f1ec7f1bb8ab08fab2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.211/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.211/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616703f1ec7f1bb8ab08f=
ab3
        failing since 328 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616703f8a1093dc9ae08faa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.211/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.211/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616703f8a1093dc9ae08f=
aa7
        failing since 328 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616703fbec7f1bb8ab08fab9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.211/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.211/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616703fbec7f1bb8ab08f=
aba
        failing since 328 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
