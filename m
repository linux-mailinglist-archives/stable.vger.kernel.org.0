Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E413532ED6C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 15:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCEOsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 09:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhCEOr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 09:47:58 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0D9C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 06:47:58 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g4so1521057pgj.0
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 06:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9R5na7CIbNgbi5U/F/S2VaIxnUDus0z8f6qJhpfy/Bc=;
        b=L7xCI4g1fEanO1Xz0Z5/3rf7QHMDdSnN3r19LztTS4793NOO2K/WogQamSdN2CKKSc
         ajH2Wnd37gMgwuhp9TtFhiwE/zwLTJHDKtko2qLG/vlB390fYEh4/S2l21uL1pIbmfYR
         GdsXTntkRoQw/PJNKqat8vrypkyqdDz0L00BWlOiRzBlabNzNtD3q+b8fUBv6BmHWtid
         gh5k8/pXpQ5Le+W4e0p6BLMuZykzWSGNSnwY8P3FYrowf/97KS1C5+SpWza46G5LBDVB
         uyoOPTsh88Hag+KXRV3lgM1GkNDz4j1QAcirgXIjoRqgKGyXo/kMfELADuQP31Ziykb0
         sG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9R5na7CIbNgbi5U/F/S2VaIxnUDus0z8f6qJhpfy/Bc=;
        b=pehj140zALCotfRFXe2kHCYupoc34mX8sBVxLU1dmRTEXKHUgt5e1yMcNd03oNeT4j
         zK9v+yfO6E40yBYGvACkVpPB4aUY84U0L9ns9udlC+QGNYfDh1SiprJDQ/0yf/hfLdSQ
         3ZqjjlYQNmk8uULV56RS8mTZ4qsIWQ68o5YMqO3N+7dh5tqZfj3fDSs9N7fWbsptF//O
         nDHu3HSTZXaQc2oygOlrVSl21FKqdcSAXHQJ/cYFkgWGTR7l72/QtkREVsi3cHdTydwP
         TeHWe2c8ZmAumcXF6spl/LYAiPw1FP8LKnc7Qia3ZfzXcStb7uZmMQS0IMA+/+MSK+hU
         B/jg==
X-Gm-Message-State: AOAM531vHlTU2pec1dGDfeaUUoeQeWHADf5VWP2x4XDbMzJYpjSUVkw1
        RjgK4py5me+kjb+r3/S2f+/yjXMENPD8SJ3z
X-Google-Smtp-Source: ABdhPJyPAjXr7KTRObqCOOUHP04/c1UP3ShRyjh6FDTONh9ucIlWHzVvie1vk4cyA3oakRohmWfT4w==
X-Received: by 2002:a63:e84f:: with SMTP id a15mr8769354pgk.249.1614955677467;
        Fri, 05 Mar 2021 06:47:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 202sm2986877pfu.46.2021.03.05.06.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 06:47:57 -0800 (PST)
Message-ID: <6042449d.1c69fb81.4c67f.78c3@mx.google.com>
Date:   Fri, 05 Mar 2021 06:47:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.223-38-gdcddff98c60b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 92 runs,
 4 regressions (v4.14.223-38-gdcddff98c60b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 92 runs, 4 regressions (v4.14.223-38-gdcddff=
98c60b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.223-38-gdcddff98c60b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.223-38-gdcddff98c60b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dcddff98c60b97bac922f614dc73fd6bfe6af07b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042127cd36ad67e79addcc0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6042127cd36ad67=
e79addcc5
        failing since 0 day (last pass: v4.14.223-18-gf8c6d72769b4d, first =
fail: v4.14.223-30-g374ec523e01b9)
        2 lines

    2021-03-05 11:14:00.053000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/101
    2021-03-05 11:14:00.062000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604238fe20bab117f4addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604238fe20bab117f4add=
cbe
        failing since 111 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604228311acafe7263addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604228311acafe7263add=
cbd
        failing since 111 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60421aa8eec9880d6baddcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-38-gdcddff98c60b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60421aa8eec9880d6badd=
cc9
        failing since 111 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
