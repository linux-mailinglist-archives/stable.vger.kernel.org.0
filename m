Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075A1297D89
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 18:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762451AbgJXQzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 12:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762450AbgJXQzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 12:55:22 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE61C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 09:55:22 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id o7so3501833pgv.6
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 09:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sRUtMmS91XnVH/UM0bh5+lsVvwZeow9yzOErNVuHnqw=;
        b=agivkIHlT0OGCIvsVpDP0WE897LfPYEoTgavLlllrWytTg5m95hjiO6sLx/PDnuEJm
         oy43ssbCxom8jK3fHMI0gIuYf++27uDje99d7dTBYiBbKdUoUfeZV7/kYbuv2boEPDEl
         ahjmmcPwDy0ZXRXjz2uWYDuwk4/8aODx69GJFbMKuxTC63cuQ2wks89ARCf5Py7jAEkK
         cOuq82GC34KzMT3uxaBJ8YObGuNijAzUQE/tvemxWFFEpJD03An1ZrN+1Nfd1zmV8cZN
         gH9P4rGtjdFrdss2o8mcjB3qs7ey/OaVixiXFxPW+MJnJHCmueo4sOZ34pYTUxsX6srD
         AD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sRUtMmS91XnVH/UM0bh5+lsVvwZeow9yzOErNVuHnqw=;
        b=CIOU7Kieu+XS4dIW2EdDUXm0g8W61uKGj/2lFmidrjuLNuX7mlNRcKWBnP2GdsLmGj
         Qzq6QVMTyrToSluqg+GAi42E60RmaNFVx3iJSjd2kKlsrcWYXGWgpfSdxXBXlNfelb5/
         8gwhvo5eFOHw6r8bxrjLI5sxMgoV7502e8RyXTbRLlUpgSDySCtmKxV9KsA/Tr++N57K
         d28VqcFEoJPaPlg9lfAZ+ueFVSmlPvxWxsaFqSuY82lwSoldrciSyO4Lx9PjQ2K+nUR0
         TDXQTQrrGMneJ0YpcCvhr/ulVxrl32EBDYpMr/IrqPX9ByRO2Q0q2PnGW35xQt7svljt
         B3jw==
X-Gm-Message-State: AOAM532xmWEMVlP62+ThgLMrTvsABpC1Fw4umttMPytEjSKLRhxk7pU5
        Wy9SInmEXOawL1qXAFjEmvCZAhq3S9hsSQ==
X-Google-Smtp-Source: ABdhPJy3iq6+iRzxBCH7+YXSoPnTFkzbBm1MGQQcMVLGyTFVox9HsEF75IqyNrKgsMAi4ieU5+P1Pg==
X-Received: by 2002:a63:af11:: with SMTP id w17mr5593041pge.212.1603558521645;
        Sat, 24 Oct 2020 09:55:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u5sm6651690pjn.15.2020.10.24.09.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 09:55:20 -0700 (PDT)
Message-ID: <5f945c78.1c69fb81.627d9.bacd@mx.google.com>
Date:   Sat, 24 Oct 2020 09:55:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-33-g0f1e84b5bbc2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 177 runs,
 3 regressions (v4.19.152-33-g0f1e84b5bbc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 177 runs, 3 regressions (v4.19.152-33-g0f1=
e84b5bbc2)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.152-33-g0f1e84b5bbc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.152-33-g0f1e84b5bbc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f1e84b5bbc2df0907ccd948dc8e05f4e015a939 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9427ba163a080bb1381028

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-33-g0f1e84b5bbc2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-33-g0f1e84b5bbc2/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9427ba163a080bb1381=
029
        failing since 130 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
hsdk                  | arc  | lab-baylibre  | gcc-8    | hsdk_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9427efbaf32deb7438107c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-33-g0f1e84b5bbc2/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-33-g0f1e84b5bbc2/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arc/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9427efbaf32deb74381=
07d
        failing since 95 days (last pass: v4.19.125-93-g80718197a8a3, first=
 fail: v4.19.133-134-g9d319b54cc24) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f94294c7d7407a05e381054

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-33-g0f1e84b5bbc2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
52-33-g0f1e84b5bbc2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f94294c7d7407a=
05e38105b
        new failure (last pass: v4.19.151-22-g5f066e3d5e44)
        2 lines =

 =20
