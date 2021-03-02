Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 313EA32B08C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344959AbhCCAy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361126AbhCBXao (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 18:30:44 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F19C061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 15:30:04 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s7so5764107plg.5
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 15:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C9ryLSjfoH1vNvyjTsF56iF4+jfQ3l16jzLvg3sxEl8=;
        b=hE4r+YLKVR3Jy07+TYQ7RQBUtAS0qnER8G1N728bSIIGpUl1JNmNTCZUXTXyQwzSj5
         qbc8F/vkKd3at5evTf17NGzHJhC4M7jFJe1RgY/dkGshrKv3vAARYbSZkqxDoQ7NRGzS
         Hrln1wpy5c5KpReczE1Qup2b+eQM9yZjg6CoBepAbboa7Q7EiNKOGglB/Vv9M3LlyceB
         mDBquhTPY4TcNv4oVMgss/88YS6VfuZSw9wbeb2AXyqZQGt6JYbdWw4KlBtjjsfy1yWV
         EhV4HyA33EYIetiBSPzCBeRIJMeTv89Dh7idZW1wWfIs8qXBSLirx0hLRvpd3u4Tg3RN
         GtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C9ryLSjfoH1vNvyjTsF56iF4+jfQ3l16jzLvg3sxEl8=;
        b=nhAHliT0VfbCp9nuQpU5p+sYsJb5TcXZSp4IsbfC8Ox0peo8YQjgdWfyEvV3pbF3QB
         se4CLSOQkKjSRP/cf5szLMKlvC/fBOnhCYABE8+61rFn6I2p0C+QMB/vXBImHHlqVsM2
         oE2M964YxM3Gbmc9SdkrJK/WowllYlwKN7RRI/hmkcLQalEpm2sgEQWMa1pk7M7BG1MV
         6JE4Dws8Z5h/BT4iWa98Hr5cntWbRa3wYKmu7unS+7YJjeAufdM0fsREpKgraJwhtj0Y
         m8kR/rBn8BjotMSjjeiHYBhrI6SP3msRK/xglgdUMm5NvjAqgQ/FQLLuKbK7ru8Rw3P0
         6i0g==
X-Gm-Message-State: AOAM531TPbNd6nLGBZ4kjta2l3hjUdVbgr2cOeR697BMwHmmlu9sSi7O
        cLOjAyFn6mMlZDz2I4Mrp7zFEXvf/9rGTw==
X-Google-Smtp-Source: ABdhPJz9dvw2CD451W+AotlOBvv+JXiFMnYJBS0TXSlBGLvGez4CugnGIQgzlPdfGk8ecm2E5eVtgw==
X-Received: by 2002:a17:902:bd44:b029:de:74ae:771e with SMTP id b4-20020a170902bd44b02900de74ae771emr291641plx.73.1614727804182;
        Tue, 02 Mar 2021 15:30:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q66sm3554243pja.27.2021.03.02.15.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 15:30:03 -0800 (PST)
Message-ID: <603eca7b.1c69fb81.e9149.6c88@mx.google.com>
Date:   Tue, 02 Mar 2021 15:30:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-337-g2d0a98c0d46c9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 96 runs,
 3 regressions (v5.4.101-337-g2d0a98c0d46c9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 96 runs, 3 regressions (v5.4.101-337-g2d0a98c=
0d46c9)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-337-g2d0a98c0d46c9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-337-g2d0a98c0d46c9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d0a98c0d46c9e671512be774fa4babeab4ed09f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e98368d8439aeedaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g2d0a98c0d46c9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g2d0a98c0d46c9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e98368d8439aeedadd=
cb2
        failing since 109 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e983c034917fe8daddcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g2d0a98c0d46c9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g2d0a98c0d46c9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e983c034917fe8dadd=
cdc
        failing since 109 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603e97dc6b231907f3addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g2d0a98c0d46c9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
37-g2d0a98c0d46c9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e97dc6b231907f3add=
cd4
        failing since 109 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
