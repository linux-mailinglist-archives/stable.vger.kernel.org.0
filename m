Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61142DF0FE
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 19:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgLSSUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 13:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbgLSSUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 13:20:09 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7D2C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:19:28 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id v2so3563632pfm.9
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3qMh8RTzIk1bU+YVK8MFjRBK9ShLMqEj9W3vS+piPWw=;
        b=HTY4s3ZAZfCvVmPAlcWbwRrB3ex+lrxET5zZLJW3a1PEs+C7D9FCu7bTVxIcrqhbAn
         FyKUrcJwcfyLGahR0jnDt907sVOvxa99BjHAe2rPpbLMfGp84UuhSp5w7NLabVWknPjx
         NfQc0kE4o3y4GCD5UFv3kBKmeVNspOboZ1I6D1xvlsMCXCfkvvIJ9MLhqf6pdBvM2QRq
         X0Tiwz2ljV8RPKCYX67cQ5uu6FuMuMx2hzqSrTKhtWnF4NRgstgYs9+HG9O3sh2aqW27
         aZ28qNVdpxXkOTozsL7Zd8+Nyml3quUUJo+QqAwbNznSuHjYY7L1gcwO+mNFYyZ78Mqm
         B8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3qMh8RTzIk1bU+YVK8MFjRBK9ShLMqEj9W3vS+piPWw=;
        b=aKRllV2qyF2p+HxFp7sYdxxgUv7mN3TqyVj5Vs4RjwjPPWmQb+WTzxMzviW+3WkVkV
         Qi3LenqOmrqiGeuybsNjirr68wBOtNON74UDpWcvERDZrIINNJMwM350xN3MnLtxrnnL
         rQVfC3tWBPNnx1i1EZ/ZJS5GGPFmtCvYwQ+0jqOLuaGXlabV10zOjRuASlm/0oxpezBY
         PB4G+Vi89bvG5bf6bTaRhYRBJn8Rj+b4MKfRmsHTwLajeWGx4vxRsIwohlC6qtdrf3Ub
         gGLWGtgASINFMCHw4bhSSdf115KupwMfeg/QBDdU27zBoXYJJzblJLIaYQOdcpn3Pzwu
         VL4g==
X-Gm-Message-State: AOAM533ur6f7fRZ6/W4UaGOQE42IsYKuTEUIhtcVy8QwRXA9xJ1n3++S
        cOugCnJx1Q2HuENlCUtQLdw0X/YnAN+93Q==
X-Google-Smtp-Source: ABdhPJzz3caJ+AeEBcLXqspvfGnUuHZy7creOZ4tM2p0D/5LGNYqwYTOSJLHGsvW2r6pYHPjShptEw==
X-Received: by 2002:a65:48c9:: with SMTP id o9mr9166509pgs.156.1608401967915;
        Sat, 19 Dec 2020 10:19:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i184sm12658178pfe.126.2020.12.19.10.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 10:19:27 -0800 (PST)
Message-ID: <5fde442f.1c69fb81.7e99d.212d@mx.google.com>
Date:   Sat, 19 Dec 2020 10:19:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-25-g096917b1829b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 95 runs,
 5 regressions (v4.9.248-25-g096917b1829b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 95 runs, 5 regressions (v4.9.248-25-g096917b1=
829b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-25-g096917b1829b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-25-g096917b1829b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      096917b1829bc0d49eaaba65403f8ef7728db39b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde131de34f769c15c94cd2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fde131de34f769=
c15c94cd7
        new failure (last pass: v4.9.248-25-g21c08444d8cfc)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde1184a890772814c94cf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde1184a890772814c94=
cf2
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde118aa890772814c94d03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde118aa890772814c94=
d04
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde1143ef973edd35c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde1143ef973edd35c94=
cba
        failing since 35 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde181e100adeb570c94cf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-g096917b1829b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde181e100adeb570c94=
cf5
        new failure (last pass: v4.9.248-25-g21c08444d8cfc) =

 =20
