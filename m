Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C7D32B1FF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbhCCAvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447370AbhCBRaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:30:05 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE815C06121D
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 08:53:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o10so14209895pgg.4
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 08:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=40duJ/vrXkp8IUm6rUGArPkwzF2/vy90ODxMpmZ+g4s=;
        b=Y5PYtzafTTLF3DTirjJWrCu3MRgccT1jJu6K8Qv/tzhgVc6y+P/0LjZ1iERf0vZGWA
         j0DEf+/vLCPEsAD8mjZNQbau8U4OmypXyvYacISHb8nLGeY4b7t9i6cIdX6P4ZHDoW7h
         w07PZNwtDjjaMKvHmO0/fqbnmenvkQ7dyQjHltJLwKeU0h4PQ03bMoBFX+aLoEqIgKDw
         tHwhMlnmfHK2pIqNp5/LtUZRo9T2IFZSQjQGcpeJUlINuht7x8Vs6G0accDSnXyV1rmT
         7g9LZhedC683BSXuAVz7sYGBBoBZgl1IY/5cfPTRPBX8u7IgqWzfA7wkTFxSauUdlEoT
         SvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=40duJ/vrXkp8IUm6rUGArPkwzF2/vy90ODxMpmZ+g4s=;
        b=WCv5P9TBeiXs+oIZj98Z2PwfrdOy/yxQzZZv02T0wvLvzKpELHsuwK/dKtvxgIbcCj
         h8vSyS2ea6pb7MvNh9Gqdr8Wa7Puyxa0CfD85LoN1aCBFBDAm52CWqm3rBBxTX9qKqt2
         zSrwNzt+srsZzlX/aKGVJfoH/YJL3rTtmucGR4g2Dqm0qK4ZIdAPQ7XzGi4G0Ryn1DTm
         HY/hSzN6IleOHS/taKoUMv4fLdBZbr9dLUjjxZdzRQu4inG+U7PaHJg50LslPHg91ftK
         +bLqpU3LFnXytBt3NlnbC0bNu54K2iLjgwUg/WDRqbbqMcMZ5PYar6vUQeETGjyBPix6
         q51Q==
X-Gm-Message-State: AOAM533D1dCrtU5H1Db22g20utMvaYhgR8d7//v3Wm+LsRds//LcT1kS
        ofeMMrYcXr7wZV3Vsi038SlkJ11598+QrQ==
X-Google-Smtp-Source: ABdhPJz1AO1kSEwVDLvpAAzs7bnmmwKPWsk0JFKkh11o1DaFMWSRweBvhqyqaK5EifVGR9m3EF21wA==
X-Received: by 2002:a63:f549:: with SMTP id e9mr18992047pgk.114.1614704002241;
        Tue, 02 Mar 2021 08:53:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm4119216pji.14.2021.03.02.08.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 08:53:21 -0800 (PST)
Message-ID: <603e6d81.1c69fb81.30473.8e7b@mx.google.com>
Date:   Tue, 02 Mar 2021 08:53:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-136-g5fde7b797e1e9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 77 runs,
 3 regressions (v4.9.258-136-g5fde7b797e1e9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 77 runs, 3 regressions (v4.9.258-136-g5fde7=
b797e1e9)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.258-136-g5fde7b797e1e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.258-136-g5fde7b797e1e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fde7b797e1e9e7ec636b1ec3884340949fecc7e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e33c2263fa0106faddcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-136-g5fde7b797e1e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-136-g5fde7b797e1e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e33c2263fa0106fadd=
cc3
        failing since 107 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e33cc349faacf57addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-136-g5fde7b797e1e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-136-g5fde7b797e1e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e33cc349faacf57add=
cb9
        failing since 107 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e33755501005484addcd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-136-g5fde7b797e1e9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.258=
-136-g5fde7b797e1e9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e33755501005484add=
cda
        failing since 107 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
