Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86E6414C9B
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhIVPBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbhIVPBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:01:43 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19725C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:00:14 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id j15so515207plh.7
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D7mfg9cKaqeZgqEbJcBVcumJ1RbkwzowuvqKaLa9fCw=;
        b=DFwOVd4pvutB+X8R92GdMCDDZajium8jLxGuuEXqVuoarwZjDUOjl+3mquz+J/KRSW
         1cooOFlYa5aAHYFshftVGKgSlSL1vT5bwObGNFX9EEZlNf7RJiqjkJBlwepQ1dp51SPs
         zqlXjB61/79tGPP9oa+W/YUW8XV6LqxDA9iiPh7rYQqOWvUYHpOfiH1E0ekqrheuIjgB
         9dZUugf5wiygpRTXO8WmriGxd0C2GiiYrHUMAQ8ZRJ4Hh/UoFueUnO1Kg4T3aPBT3673
         +0PQpTENzae3lINB/oIomHXV2FJ9wvWQnHp3iqkAylzbzo9XjiRhgFrhSlMIG7QJYf9F
         eLpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D7mfg9cKaqeZgqEbJcBVcumJ1RbkwzowuvqKaLa9fCw=;
        b=rUjAv+EjuWLfR8KeCSzITIV80KKJuOODvr1W2OnT26wPpOga0y6Sskv2GJUIMNSwPs
         osWFa/6tdHyaPpzYseXG1C2XtqSR7DeyVCRjp6XkYF1MINXpjemzzoHITm6Cgo2g0J3b
         dalUiF7ts212Aqh/dRCgM/dpTfhjB0MUJWPLtGgpI9UZMXSFmJUJSfIWITMeYIHnw8i4
         hyXmBjk0dNl/EkMJStFlJfMQbyMsmk1OXtVunqNMZFuUBnAZWTBh3muY1CISAZJzRGSi
         lETG/pVLuE8tu8KOLJMvj/Y4OouSprXGco+EphRG/78g1EQoSdGetDgxujPjTxeqCdje
         Zubg==
X-Gm-Message-State: AOAM5333sSctTN/zKwiD3BZG8cAPNtB+1THX+l083/xmYlw1eNcupav7
        jK9KYS45nZcVvNL92dGhms3R6oXq0LnE9EJj
X-Google-Smtp-Source: ABdhPJwviYHSie+m5SAyOPGrx5JoY83elWV9a1dL7JNjx7WqtHtVdEXN6HyW6yF3jbUV3LZYpNwnlg==
X-Received: by 2002:a17:902:db11:b0:13c:7a6e:4b57 with SMTP id m17-20020a170902db1100b0013c7a6e4b57mr266894plx.43.1632322813388;
        Wed, 22 Sep 2021 08:00:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6sm2648773pjn.27.2021.09.22.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:00:12 -0700 (PDT)
Message-ID: <614b44fc.1c69fb81.1b79a.6c3c@mx.google.com>
Date:   Wed, 22 Sep 2021 08:00:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 105 runs, 3 regressions (v4.19.207)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 105 runs, 3 regressions (v4.19.207)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.207/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.207
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2950c9c5e0df6bd34af45a5168bbee345e95eae2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b0bc105f635d61599a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.207/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.207/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b0bc105f635d61599a=
2ec
        failing since 307 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b0bc41a4c62310899a313

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.207/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.207/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b0bc41a4c62310899a=
314
        failing since 307 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b0b644bd81e13b499a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.207/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.207/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b0b644bd81e13b499a=
2e7
        failing since 307 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
