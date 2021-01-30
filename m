Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D846E3098D1
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 00:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhA3X3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 18:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhA3X3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 18:29:47 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1FC061574
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 15:29:07 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u15so7901456plf.1
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 15:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fWhyOzOvfLL7MaRuaR3F/NtRQPIWxmQWrjxHzJCvQ50=;
        b=QilEfJNTA2raEPrK8ohwSEm/7GSRFhEK2ZoF/HZD6mo4lX373Lk+QJBYJB2a0YDLDP
         Ol2X2+agip7QpKek3OblQUQBoXPxktJONxJeb0McnhzUpf9ezNOCXf3dccMM+C8dn4eH
         GAzZVYbhz4L2fTtIOG9PzXfONQLlIiJbjRDEIeuDO3dsfsCSR4HpYwDeVEttAqotXuNs
         mJMdZTQBW/1fjSvtHRcqOO+y94q/utD5so+FLGMlckYxhwa67XCCeq2aRACwq5FVzWE6
         QZZ4be88TgGyiMVdmd6xhrQuMpw57EDIL38nxRWttIbEgei15mJIVwCGTc91Uz7nK7AN
         BtkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fWhyOzOvfLL7MaRuaR3F/NtRQPIWxmQWrjxHzJCvQ50=;
        b=XnGLhKGYlESSeZsm2ldHeuchC9smQLCkkrNKRMV64h1bBvXERblxmVHWQXaFTxluX3
         DWqufc0V+1HemRU0OCnMGmxB7hSk9PVyG22Gw+vNFg0dNhmfr3D50XJh60KmcwcrHN3f
         Q2fO8M5KkOVChM0uBPYs5rN9AzeT9O6NZ0rVj12cN/X63Rqi8/As9E9ouMFYizuC71hf
         6IfW+NXxSA+YeaWt63VEaCm3Uf7OV0gXpIePREtEnx9KtTFEaVYYxFuRS+S2w4EWeDyG
         IXTdtEQq2lK6D9XJG5AF1iV2K/4Lp6I7+v3LmMR6KClVo5eY4goIMGTznv3YQQF+x+hO
         IkTg==
X-Gm-Message-State: AOAM531JM/3peUSeYaIIhJSP4AIhr0geKxPA/eWdc526BLupx4LkqXgH
        TQR/JMh6oNngEJjxnUiwtW8k3xxsZ3Rh+w==
X-Google-Smtp-Source: ABdhPJxkOsVcII8yBudmwLmr5/zUbm+WzruWCeDWyaRhsBDDejfCca5+ThJinQHsbcu8gsL6NrmP+A==
X-Received: by 2002:a17:90a:d145:: with SMTP id t5mr10715564pjw.104.1612049346903;
        Sat, 30 Jan 2021 15:29:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 192sm12975315pfv.209.2021.01.30.15.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:29:05 -0800 (PST)
Message-ID: <6015ebc1.1c69fb81.bda77.fdab@mx.google.com>
Date:   Sat, 30 Jan 2021 15:29:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.254
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 51 runs, 2 regressions (v4.9.254)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 51 runs, 2 regressions (v4.9.254)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.254/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.254
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8020355f44545d6e69179d49d317130132a121cb =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6015b4b83f92681ca4d3dfcd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6015b4b83f92681=
ca4d3dfd2
        failing since 1 day (last pass: v4.9.253, first fail: v4.9.253-31-g=
1aa322729224b)
        2 lines

    2021-01-30 19:34:11.807000+00:00  kern  :emerg :  lock[   20.486968] sm=
sc95xx 3-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95=
xx USB 2.0 Ethernet, ce:2d:d2:ea:a4:a1
    2021-01-30 19:34:11.818000+00:00  : emif_lock+0x0/0xfffff24c [emif], .m=
agic: 00000[   20.503417] usbcore: registered new interface driver smsc95xx
    2021-01-30 19:34:11.821000+00:00  000, .owner: <none>/-1, .owner_cpu: 0=
   =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60159f3184f15f97ffd3e04e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.254=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60159f3184f15f97ffd3e=
04f
        failing since 73 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
