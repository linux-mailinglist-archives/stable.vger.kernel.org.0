Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A902D81B7
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406722AbgLKWOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406155AbgLKWNm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:13:42 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACBEC0613D3
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:13:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p6so5289126plo.6
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gBq5BEG6QMfZ8029sC8GRUTsyhI4bV4i4MR2eZTAZpw=;
        b=ZkAsx17EF+zHgjB5QOT+XuHucDctD4a4AEJdxSRZESon1fn15YzJzjye7V69Ku4NWx
         Kk6KJkUD8SF/pBWzjpl2sq+cw67GrmTY3TdParVxeE8iFo/RZ7nO6y+vfm5EvM8tjzP7
         H9T1NFGS92m9DsRxrkBqwLH4x4Hq6nEfeBdiSaUjyy5SbnsLDYA/uxjwQv76SExnhSua
         pJYoBDt0wk8HVAoWLgI4camGsow5nSkD2vZktltiE9wp+IGdQwgjirN45RsmFJXjU2py
         igfLE3+qYZV6JtaGlU+bupG0YA0u7xUQv6RxzU/bBOnoP+YLpuNPtd77SR9D3N6WeV5Y
         wmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gBq5BEG6QMfZ8029sC8GRUTsyhI4bV4i4MR2eZTAZpw=;
        b=ovHomw8vnljEaomozNhbtqNoWchouZHeJ6NqAL3ePqOMQ/CJXoWmuPzp1LxCpgh0uS
         Pqic9ohw8TZKDB02hK3elLGRbwfgUyHisVA+donbLvUporyIM6DyjI0z6SKi5yAjoMy5
         mEIc/dzjUmJgBvW46MrjJnv6XyDKCXorGoNYxypg8ol9OQuJqr9WBVhSdtfbPwHjxSHG
         4WhqdCEIMk+y0dVBKlez+xsQHnzsQZlMK4V/Be48bClpdsFx56j7WTEGK51Gt8bahYLa
         675vl0utyUJwehHT4oVufdX3sKrlfnaPyBWyCdFyAiBM7PYQoByH8IN8SCHxaTya4YpM
         GUMQ==
X-Gm-Message-State: AOAM530sU2ovA+PtOKdgGxC9PayEKQ0MWUmBOR0WmaYEknEm8WKt+S1A
        v53AcA5MUOVUiHpVux7knK1OsumnnbaZ/A==
X-Google-Smtp-Source: ABdhPJyZU6d9pSN3quo4ogAeX9kdPu3Hj59xkYW4Bwj+5xn7pFwmjHIW0kz9Eqb/dxuLtHwtyfTF3g==
X-Received: by 2002:a17:902:9888:b029:db:e9b9:d183 with SMTP id s8-20020a1709029888b02900dbe9b9d183mr3909433plp.7.1607724781933;
        Fri, 11 Dec 2020 14:13:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm6sm10999715pjb.25.2020.12.11.14.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 14:13:01 -0800 (PST)
Message-ID: <5fd3eeed.1c69fb81.b89ce.4b2f@mx.google.com>
Date:   Fri, 11 Dec 2020 14:13:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-2-gec9e5f49683b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 112 runs,
 4 regressions (v4.9.248-2-gec9e5f49683b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 112 runs, 4 regressions (v4.9.248-2-gec9e5f49=
683b)

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
el/v4.9.248-2-gec9e5f49683b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-2-gec9e5f49683b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec9e5f49683bd77e7ef5adb4bb78e548b73d5f73 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3bba886084da936c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3bba886084da936c94=
cc5
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c83e75aa9fe928c94cf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c83e75aa9fe928c94=
cf6
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3bbb986084da936c94cfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3bbb986084da936c94=
cfd
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3bb58561a0f0f63c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
-gec9e5f49683b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3bb58561a0f0f63c94=
cde
        failing since 27 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
