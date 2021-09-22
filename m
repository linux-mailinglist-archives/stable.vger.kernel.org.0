Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B11C414FB6
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 20:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbhIVSSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 14:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbhIVSSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 14:18:33 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E451C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 11:17:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t4so2384608plo.0
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 11:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xREKtRqnGUrn40r/bC0EdYOyJe2jO+fxJ9K2zvUT+ZY=;
        b=reqp00H7Mlb7LwOVnyOhaAnXP9ey8Jl8RRNmgrX4R58bKsCrmkeMyCC97HMLnqCvkK
         D3pHII/5luksp+rP0Sx9U730huiBU6Y4wkTop6Xawz9iHGlhLOzfQgYtGq6uIIqxS2VF
         lr+5vbKxB9G8jw2cPkOcDxp3JuVgdOV4SOP4JlmeG+MaqzYso4OMrR+jomVtyFlSBoAO
         qoL1QCJv97ZHWZAsiOWpzQ2RnAenlrGGw7rSPTLI9djuGeAK34VV9urdFUNGZUYtgaGO
         QgJlI8r4w1qpC57QpaewZ4kI5Nyr2bO6tUUoDklehPj48aJNRkNzPcYU5bUf5CADdrnL
         H+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xREKtRqnGUrn40r/bC0EdYOyJe2jO+fxJ9K2zvUT+ZY=;
        b=ep9OvvzohhtjeC1ZylMyFOu6tIxSmtdCNSFv5RXexzY53RDbrAqUYC6TBzlAwYekKV
         TOkbJt8m6JiAtIXaTtBWUY5VXsP+TJU1CgWCV0FPuspSB+zm9z8t7bTCGNgnVjLcHgA4
         MarBr7gUvb2U9dSkZbe/49V+lurjFsKjr/sIp7EAtxjwYyCDFHkDeHxaTxY/OS6KTTUv
         P6vW4zr05vx1a1grQ7x/qZIRumUo2Qp+A4dprmBjMMf+5ixgAWwjS9iITT7utJLrR8vO
         P5qF/Dw0Qliq9m1PNNfuOUsubVTTVfwFHws/YgTV1mpMLqhbKooyAJCcxOEsCmWS5Q6e
         p/TQ==
X-Gm-Message-State: AOAM530SHCnyFPmvOPHhk2d1Vf6n6540o6hjdzfeHZ8RVFyS9ps/A3U4
        L5RNLG+RTD4uTWUbXFp+vzNBMZGoWxApeXzr
X-Google-Smtp-Source: ABdhPJzscc98dUZ6aciNZrCr0kUag4eb1fbGUb5FChLacEaUwLj7EYt77w63IAzz1TOmFFy1kCi/7A==
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr12752019pjb.143.1632334622865;
        Wed, 22 Sep 2021 11:17:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m9sm3350745pfh.94.2021.09.22.11.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 11:17:02 -0700 (PDT)
Message-ID: <614b731e.1c69fb81.e2ad7.96cf@mx.google.com>
Date:   Wed, 22 Sep 2021 11:17:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.148
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 125 runs, 4 regressions (v5.4.148)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 125 runs, 4 regressions (v5.4.148)

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
v5.4.148/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.148
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      07e5f23d3fa6ca98457d1a2177a735fcc65923c2 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/614b3c9d8352d4fcbd99a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b3c9d8352d4fcbd99a=
302
        failing since 40 days (last pass: v5.4.139, first fail: v5.4.140) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b3a5dbb747fd47299a342

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b3a5dbb747fd47299a=
343
        failing since 307 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b3a62c6b275b37b99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b3a62c6b275b37b99a=
2db
        failing since 307 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/614b3a227823b1a60299a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.148/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b3a227823b1a60299a=
2de
        failing since 307 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
