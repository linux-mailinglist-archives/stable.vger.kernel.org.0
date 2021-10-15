Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3E842E8BA
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 08:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhJOGQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 02:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhJOGQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 02:16:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73280C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 23:14:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c4so5753776pls.6
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rJ1qV6wHBtZhfOpFjgg/3gSLCvEO1VpY++1rsh/kxrE=;
        b=Ip/VeR/89gri4fHTmU+mGz60LRHQ5EvjuWjV6SiPJ8vokEYu9SAHzBAIHRKdhkmi6C
         cVF2McaNFrvfUip3wulw86HEw3aP44CUXL9qYwR+NzqLKNcezXXCbVk1ziBtXLjyxjgn
         8sUrQSPdqiy5t9V9a5OrRYD1buqWDLpxIJlUEm473d5t+USIKIIEb9f9wGme2/A76Kyo
         3cZS/Kemlcn8iNG4PXQ5GOCDHIibXdlnYeFpetsoN1Xq4k4ft8eQE3v8lFqGuMJt+5GX
         pPJkQW2TIvdAvji0uRXCGwfjJYzDg8pGubY2gm5NfX/uGNQZXyRulVDJ9UFDqKF4Tl2o
         tOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rJ1qV6wHBtZhfOpFjgg/3gSLCvEO1VpY++1rsh/kxrE=;
        b=y3KVfkqhmK+4FFnCnz8pBakrznSGW+3SUQij53iPySu1nE4upmgeUeFGTWBKiiRQY/
         BHEASEw+QlfL6HUMd94wnoHn5dDc7von9qETen+rD14y3csCm0od14zuujP7dDojOixb
         HGt/06zaE5Rp2L+e4V+KT32SeVRLyKCE7b25+3OgVgMWSU9eTr3QfaUU2dymcp8e0KCk
         3+hL/Ihg/Wop4RiiVBTIpe0M2KVywOSCrV2aSvhbp/QRYtBZHnPHMiLGzkUIPHICGLx8
         /WGFDuCDiIpYbegeCI2+nsUxUye9Mw8kdrywfddP+ILXMsB7bmSdmeKVXXMLhZGxp/kZ
         pbzw==
X-Gm-Message-State: AOAM530EKNzJXdsRekF/PjRIKwnyh5xWO3RI+QYhlphoFsXtnNitLnfR
        VhIy4aKOXHh/KqbX53K0FndCg2vW2+u6ziLZ
X-Google-Smtp-Source: ABdhPJxTmGUTHMr8hWHJ5KCiGjYFeOp8otZksQSIh96T3cxUhpl4vNOwBgSJxktzxhh145YgYgPlEA==
X-Received: by 2002:a17:90b:3b52:: with SMTP id ot18mr11497556pjb.245.1634278491755;
        Thu, 14 Oct 2021 23:14:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f33sm10397881pjk.42.2021.10.14.23.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 23:14:51 -0700 (PDT)
Message-ID: <61691c5b.1c69fb81.fa7c1.f76a@mx.google.com>
Date:   Thu, 14 Oct 2021 23:14:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.211-13-g2be6a8418bd1
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 83 runs,
 3 regressions (v4.19.211-13-g2be6a8418bd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 83 runs, 3 regressions (v4.19.211-13-g2be6=
a8418bd1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.211-13-g2be6a8418bd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.211-13-g2be6a8418bd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2be6a8418bd1568db7e752ea68f73e6f24fca984 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6168e29e46bed242b93358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g2be6a8418bd1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g2be6a8418bd1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e29e46bed242b9335=
8dd
        failing since 330 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6168e2979461800bec335902

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g2be6a8418bd1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g2be6a8418bd1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e2979461800bec335=
903
        failing since 330 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6168e29dfb687ae94f3358f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g2be6a8418bd1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g2be6a8418bd1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e29dfb687ae94f335=
8f2
        failing since 330 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
