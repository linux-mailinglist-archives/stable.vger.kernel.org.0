Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C0745B397
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 05:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhKXEsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 23:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhKXEsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 23:48:37 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0202C0613FC
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:43:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id v19so826762plo.7
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 20:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DAUhWTKh66yfilHRkeiCz6j5QzyFuMFru32F+kIA650=;
        b=8RAczK0oYvmI0pINLqksm7ijcmlucH8WMbZ677Xd4VnXlprfn9uqyweYdeH5As8KRT
         rX1y+8irijX1sA+1d8yPEHbCl5ek7IkFcuTWaG91u/W1cv1ZbXvUoSnv1WGQDtwmA+/d
         aOhRKcntbDKtOXigwPuCJLbal+5VWcStZu444VOneX2wqe/1Hxn/H6L2fVcIvuxIaETV
         /fHocUqT/PIPzPx7noaY6MNOOADtpUlpEvRMoiIopMD4m2+PdsjfXt36BF69w0QY64eL
         cbcFb8IUb6kI2N0e/fb0Fo/tdvWmyXGhw5wtWOeh7gZhnwSmEwUhrCaM2gBRUc83dm0H
         Iabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DAUhWTKh66yfilHRkeiCz6j5QzyFuMFru32F+kIA650=;
        b=QFx76PYyEaB3QY7fWoDT1tMZ42HAWaeLwD4rHtOMYpV2E2aR+bh3hFH1y4+vwwRbP/
         RSFxLNqWb4KpP+XoC942MjQqMgbzPXowUKtzKI80coCAgMwcKJhf18FfwsyaxZdjTcTJ
         BpVYPRmnmaL4VZz9ZhQjJMuIxWSJCmPz7lBYlJX3Z7nCS4Ks2qqC/kGH5dd5C+15FCQ+
         IOzMPCmZ17aIJW34pkHu1tnxYexz6tbCTNB6TJWJOsu7ieDMkATfUJ7CVLDKC44G8lKH
         uWkOkC7aMafYMlOwgXOFwQH6x10HMchE006pwWKJDn98N1cYjLq89r5klV8PbtNqIIco
         u/MQ==
X-Gm-Message-State: AOAM5323UsgBLMDxxYapAgoT47LYhOw6iasYu8Zd37UemSLu5UHJU6Jr
        kdO2OhgRei9f8RxYM4vN7hz2uUlH8N7NY9Q3
X-Google-Smtp-Source: ABdhPJwfl9/gkZu6cD+yRBhJz1EFqrue0GFKNNYYLwgoMEkUkctQI+YWwJCX47yrBtmQqNZXZwViLw==
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr11174306pja.122.1637729015342;
        Tue, 23 Nov 2021 20:43:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w17sm14132007pfu.58.2021.11.23.20.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 20:43:35 -0800 (PST)
Message-ID: <619dc2f7.1c69fb81.44755.8b4a@mx.google.com>
Date:   Tue, 23 Nov 2021 20:43:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-205-gd6aa2271168c
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 117 runs,
 2 regressions (v4.9.290-205-gd6aa2271168c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 117 runs, 2 regressions (v4.9.290-205-gd6aa=
2271168c)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290-205-gd6aa2271168c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290-205-gd6aa2271168c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6aa2271168c6a9a1f7a3930c5309a11fa1f974f =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/619d87deaf5f406a91f2efb4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-gd6aa2271168c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-gd6aa2271168c/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d87deaf5f406=
a91f2efb7
        failing since 10 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-24T00:31:09.771427  [   20.344635] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T00:31:09.821195  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-11-24T00:31:09.830534  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/619d8b131b6f9fcffef2efb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-gd6aa2271168c/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-gd6aa2271168c/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d8b131b6f9fcffef2e=
fb7
        new failure (last pass: v4.9.290-205-g1c958d9dc5c55) =

 =20
