Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C9C4162D9
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhIWQSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 12:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhIWQSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 12:18:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DD2C061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 09:16:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id pf3-20020a17090b1d8300b0019e081aa87bso5286358pjb.0
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rxfR4PmGnqE6N4UVA39rEEyj/9cPYlh35dic5kiyraY=;
        b=vNuAZqIchbhpE+vDJZ3UeYWJdxmCo+TaIh33GSyLjf3+uutXx9iD5ZdTwgPbEV96o+
         2lcKrmnPJaYLKlYmLQMpYsCCreIq211tbgEg8umAWNOBHL/qovm1cqurgVjy7X1naGCK
         ns0yYPloic+NhK6mobCD4+fdnezdYvExa2zzTVmxEhsgKvazoo0Mt38sNQu/IqstUgah
         Kdp9e0FwSZoP7jy6RVbrL5A1gM5OL8v3Ss5RXOJWhq2NGk5B7wIRymjIzIaAFVV891O+
         7NvTSOpYKph+XHmV0XAoQekvausOEHslAkkauoCzw6eRYC0kTeKX+o8x/4OiUA47QGj2
         nQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rxfR4PmGnqE6N4UVA39rEEyj/9cPYlh35dic5kiyraY=;
        b=K1MkqkbCvyxIGyk0TgdPcBnrG83HP30yM/d4xWRmvoQChhoVWTCMqD017xHpCF3qq8
         x3uhoZFke2kJeQer1i1gv/j6p9l9C98U53e7cGHrjgVb/Mfl7EiMCyzs4ZM9hEkvcUNG
         j/vJqTaHHkpM1YJcNNWS6YyWUo3UVqZJ3nUvJEKz/cC/dBea0cBNFqUFVPB+DfxMriZQ
         pCsYpgf814p44BlXEjA9CdmIBN2ScMElnHSc16MtRv/mzglsuqSQ06lD3qfcT+dFyswd
         kAbjPgSltm9f4JMOFxVmdMUL74nqhHdqDi4VivLdAP2tcuExt1E2WdJIdt4Dm4r/tnLZ
         kNQw==
X-Gm-Message-State: AOAM533Y3LS4jjob9LrQ1+/iO42Dd8IlZxfij4e4Ytvavk3Qa3iuojs4
        jAy/UDpBknCYZY3Y4ULff7ljMivdf5rzt3f/
X-Google-Smtp-Source: ABdhPJwTqvme7Hs1lpJYzK5O/OPo1M7IANzR+1N8/m+vUtr1FBZ+M4DbsD7ihk6QKJxX2nQW6M7XWw==
X-Received: by 2002:a17:90a:4983:: with SMTP id d3mr6279123pjh.53.1632413790332;
        Thu, 23 Sep 2021 09:16:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm6845645pfm.27.2021.09.23.09.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 09:16:30 -0700 (PDT)
Message-ID: <614ca85e.1c69fb81.404ef.433d@mx.google.com>
Date:   Thu, 23 Sep 2021 09:16:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 149 runs, 4 regressions (v4.19.207)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 149 runs, 4 regressions (v4.19.207)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.207/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.207
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2950c9c5e0df6bd34af45a5168bbee345e95eae2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c6d73ca8948118399a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c6d73ca8948118399a=
2dd
        failing since 309 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c9c7db0ed4babc299a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9c7db0ed4babc299a=
2f3
        failing since 309 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c6dacc3f67ecdd099a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c6dacc3f67ecdd099a=
2f9
        failing since 309 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c7878c7cf9b61e599a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
07/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c7878c7cf9b61e599a=
2fe
        failing since 309 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
