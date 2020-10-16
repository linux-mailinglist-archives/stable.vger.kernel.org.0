Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF3290837
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409920AbgJPPUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404767AbgJPPUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 11:20:25 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D5BC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 08:20:25 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l18so1657496pgg.0
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 08:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=45efzC1r9uec+sb9bjExRxA/u5xyXFOm32miStTULm4=;
        b=WmqUfqpCaiejPNcTux5qz1yjs+SQBGYD+74K7Js28z+hT9DLyY+xs0Z8/XOYiAu3gG
         yyHDGjkyykL9cLZC1OgnibmaZt3PHUUwu5y3MoZdh5PVhdDUk5DA1LNmsqjyTq5WiF3N
         wte8thMFaMKShaBpKBUOqXmSq29HSAb5YhO3rCHV2e+VhjBjv0VrScpc+Ej8QMCeCgV+
         HRKmeVpsqRaSq28wV/HhbCOPuP10j8NJPCsTWiJ3ur0MSyrwTFmhttNsJ5K+P11uVSem
         w/6wk8UFnkVXDFb0nPNJrc7vQlt+9ZM7bfl2NwOhk0GlNQ9Sb2GOlWZpyiXp6QbiYs4V
         Yn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=45efzC1r9uec+sb9bjExRxA/u5xyXFOm32miStTULm4=;
        b=SZbAtXOZ2JP/k6WXvuq5walZcn6X8b/XkWnLarIIW7CbqDX3dZzppXggDfPcNaHRmC
         70H0lz66XeHUwajrTMavbFPfcvJKkOVqNCcQOkcO4mzbRW8t2WsmwKFS5cNzUeut71wH
         UEqOZVyrI5eOujUkb45/qaYf2kcH8fYuHohmmNkg3yiskRXF5gxxX1t836NS+hadrEml
         hNqcBOKD8ohGplYRNX/fklGo0677ct1QknlsFKmlVPh2dMA3x0U3WuAYXo8jcLFkgEae
         ZvAGS9UlyNOGayiXtC2Box0lpyWSL0iriA4lk5Tw09ONY5Dz/7h3LEV9EUoWxMq0GO+S
         ySBw==
X-Gm-Message-State: AOAM5317mwNeWoH98sRcfFe6MswBjfvSpsEFgNUuBXi8r0EcmnIw5mxh
        v3oetftmV4z/R2+oOmLIy6LfZqVaVhOjuA==
X-Google-Smtp-Source: ABdhPJwPX4mZWzjgG8vCFOGAYRqSLRXmKfMeXoL9zu+7BSfRY7rbFiydIkt+ol4WfYKFwbrzBlUMfw==
X-Received: by 2002:a63:89c1:: with SMTP id v184mr3614745pgd.320.1602861624061;
        Fri, 16 Oct 2020 08:20:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y10sm3263224pff.119.2020.10.16.08.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:20:23 -0700 (PDT)
Message-ID: <5f89ba37.1c69fb81.7d3b4.69fa@mx.google.com>
Date:   Fri, 16 Oct 2020 08:20:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.151-22-g5f066e3d5e44
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 186 runs,
 2 regressions (v4.19.151-22-g5f066e3d5e44)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 186 runs, 2 regressions (v4.19.151-22-g5f0=
66e3d5e44)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =

hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.151-22-g5f066e3d5e44/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.151-22-g5f066e3d5e44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f066e3d5e44986dffd040360637a0dee8c66ccb =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f898003ba027b50c84ff43d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51-22-g5f066e3d5e44/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51-22-g5f066e3d5e44/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f898003ba027b50c84ff=
43e
      failing since 122 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f89811b2354c8ea714ff3f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51-22-g5f066e3d5e44/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
51-22-g5f066e3d5e44/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f89811b2354c8ea714ff=
3f3
      failing since 87 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
