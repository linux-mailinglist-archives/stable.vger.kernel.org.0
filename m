Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3BA39FD08
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFHRFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:05:30 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:47063 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhFHRF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 13:05:29 -0400
Received: by mail-pf1-f171.google.com with SMTP id u126so12195694pfu.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 10:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zcLRL9OAcsLaaqTUxan9HumKMoowSnb1xgpX08bGUSA=;
        b=06YHuNBE52FQm86XQgOaG+myhnHb6SGGKzvJwEkM24MX9Y4arGC6ACTe7feucBIA6x
         EP2bX1YGt4fKoC/0zLRbjKqMDz3SYEZ9TkAWYp0AJ+2d34dX4YpezG/j95LD2i0jrpdP
         HrL6LcR2Me4iKxI5CDHxPzD1Tt3ea03mmRBzsGwsLEAiw6Cwt/XM+jN007pmbZNCEAeb
         R/wfJBFI+o8ydcZ1/pDbXs+gW0d9ULidrXXM7iQ9jMCIxmGhC7lZf/CKXEWFTCeQlb2z
         T/cADkhqf5t1uSHDkq9KDizS9E25Vp7J9NmU5MB5lijnXskE8u4QsKc8q+LCdHMe43On
         5wuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zcLRL9OAcsLaaqTUxan9HumKMoowSnb1xgpX08bGUSA=;
        b=LtANKIcj3xr1XLw/MhIiaHIE+cGcxYK1zdhoPRj0g5gAgZM3AbE7W/xikIg/YJHHDI
         R4x/dFCKiyh/LMwPkCP8lzMghxBhpyQbFBwt3ra9KpBJuwmcCk5kqlabAfe9IWOiGei4
         I5TRaZVTG2Jx7MhfDedVnRVNRXdhqtF/jtcQ3s+my+R34fDMFXaGqot4qy7LfKEEvOYn
         S2FtRKc2bB8PGm2oOxTDKCFRc+3aEf2/ZqOKRmBF1b1fquEaN/6wu+y+wb01F4nEY7OM
         dcnOgoFlFc/hy1ufv7upEwoygo5+sUFDrNgNHxlGhMuKlFdAYFW4MRWK2e9CNmwvGZYu
         y6/A==
X-Gm-Message-State: AOAM533obxSX+wbpVcDVGO9mX+ielpaAOzjj+vGMC5WpClmRYPMEsEMn
        1Vt3YOW5a4SzlvZNArwhpRbbYzpF5TOp73zc
X-Google-Smtp-Source: ABdhPJwwVBThPwmqddGQxObUCRy8h4OZO5RJRmivCLcyenrcE3Je7pblLV0BZ4RcF1BiOI8c84QE3Q==
X-Received: by 2002:a05:6a00:a16:b029:2f2:fb20:bac3 with SMTP id p22-20020a056a000a16b02902f2fb20bac3mr643569pfh.6.1623171740175;
        Tue, 08 Jun 2021 10:02:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t5sm11223758pfe.116.2021.06.08.10.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 10:02:19 -0700 (PDT)
Message-ID: <60bfa29b.1c69fb81.85b54.2153@mx.google.com>
Date:   Tue, 08 Jun 2021 10:02:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-21-g9921022a7aba
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 123 runs,
 4 regressions (v4.9.271-21-g9921022a7aba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 123 runs, 4 regressions (v4.9.271-21-g9921022=
a7aba)

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
el/v4.9.271-21-g9921022a7aba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-21-g9921022a7aba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9921022a7abaadb399e3c6f910999c2a19cef801 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf6f6baf9994596b0c0e17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf6f6baf9994596b0c0=
e18
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf74aa5aeeb17cf40c0e57

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf74aa5aeeb17cf40c0=
e58
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf6f516b1bb7b6e10c0e03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf6f516b1bb7b6e10c0=
e04
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bf7279603b3affcb0c0df7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-2=
1-g9921022a7aba/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bf7279603b3affcb0c0=
df8
        failing since 206 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
