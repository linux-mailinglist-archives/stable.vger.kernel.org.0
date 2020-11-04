Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26A2A5D4A
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 05:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgKDEQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 23:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgKDEQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 23:16:29 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C813AC061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 20:16:29 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z3so808400pfb.10
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 20:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bwigaYZTwkry5wDKbz2B6lIRJ9jPEyLYkHj3Gj0lMsI=;
        b=WymwUM9HSgzm7IETNKSs3673GSJWj3hCH4jGdCTEq7sPC9Zch1Decs0JB7DKc6uGBp
         p9LvamizDW2FXrYI/C5A51QxNLz3n4GPmrww8KihivH9GmDc4vuXf5NIH5Q1w2/1tzJm
         BkTvz5MZmDtDopS0CJB1IRlbdZM4ZOG6NvRZ0QoMUyS0swUFwmhucwkRQbXRu1badMuj
         KQM+MnJk0Op2CN9Yq9Xq2uaARFoo/Zte5OBJC0qGE22XZojcE9/A/gwoS0QsrNUf5rIx
         +NuXfENR/MYbpIV1Ne13VZgz6M3VFXKiZfEs0g86SSQyqkEe2BjFKxCktsKfcYjkaeYy
         emag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bwigaYZTwkry5wDKbz2B6lIRJ9jPEyLYkHj3Gj0lMsI=;
        b=ou8hvTNszPdP4IJrVO+aO1FtmNN+CggceKytAxhtIieynAzovs4EjiiYdNNfj1y0Dz
         kNoz4rBtc10PrFgOgj3CHg9j5sQ1pZO8BY94wzKhmqiZqugxF1LEjtm8h/2ks3wHKkcl
         hMoPQsHwVdt1uoO0/f+K8RgMstyvu4Ae0xjSaq5q0cnGCr5cgEG3tTf8ParnuOCBtc0J
         fjfCi5/BsyhQUPtq7mharHsGbTCVr0i69nKgQ106R8US5oC4Us2MKWcpZjSgfkJbceIW
         P7nGNtWLqqZwa9hpJjez4Hdu84Has1p/sRK+oU2LUsiNPt4/MrQwNyaIYZRJ+FP6PA6r
         q2VA==
X-Gm-Message-State: AOAM5334cVezsbWZ4GOkmIa3yZRGp4htKZUDkXiznW1Mk9LMacIhzgPj
        +zVGrLkR9Kc1Z/rfK6jgRrpfeTug/3PP6A==
X-Google-Smtp-Source: ABdhPJwARBmWYWCNFhzred2TosisIlO22ETmPjTXs0PbDj1rmhQTdBrq+0kfSdPBXdmlp93eini+rQ==
X-Received: by 2002:a63:3c1b:: with SMTP id j27mr12791889pga.79.1604463388976;
        Tue, 03 Nov 2020 20:16:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w10sm604452pjy.57.2020.11.03.20.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 20:16:28 -0800 (PST)
Message-ID: <5fa22b1c.1c69fb81.f04ee.2511@mx.google.com>
Date:   Tue, 03 Nov 2020 20:16:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-126-g8c25e7a92b2f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 155 runs,
 4 regressions (v4.14.203-126-g8c25e7a92b2f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 155 runs, 4 regressions (v4.14.203-126-g8c=
25e7a92b2f)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
   | regressions
----------------------+--------+--------------+----------+-----------------=
---+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
   | 1          =

meson-gxbb-p200       | arm64  | lab-baylibre | gcc-8    | defconfig       =
   | 1          =

panda                 | arm    | lab-baylibre | gcc-8    | multi_v7_defconf=
ig | 1          =

qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.203-126-g8c25e7a92b2f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.203-126-g8c25e7a92b2f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c25e7a92b2f1688d46addf84ba6e3ec6f8d7d52 =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
   | regressions
----------------------+--------+--------------+----------+-----------------=
---+------------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1f6ecdfbe218a0efb5325

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f6ecdfbe218a0efb5=
326
        failing since 102 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch   | lab          | compiler | defconfig       =
   | regressions
----------------------+--------+--------------+----------+-----------------=
---+------------
meson-gxbb-p200       | arm64  | lab-baylibre | gcc-8    | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1f6c8e2edadc6a2fb5308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f6c8e2edadc6a2fb5=
309
        failing since 217 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch   | lab          | compiler | defconfig       =
   | regressions
----------------------+--------+--------------+----------+-----------------=
---+------------
panda                 | arm    | lab-baylibre | gcc-8    | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1fa56d2ebd58f54fb531d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1fa56d2ebd58f54fb5=
31e
        new failure (last pass: v4.14.203) =

 =



platform              | arch   | lab          | compiler | defconfig       =
   | regressions
----------------------+--------+--------------+----------+-----------------=
---+------------
qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1f8fc9be87b1bc9fb5339

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
03-126-g8c25e7a92b2f/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1f8fc9be87b1bc9fb5=
33a
        new failure (last pass: v4.14.203) =

 =20
