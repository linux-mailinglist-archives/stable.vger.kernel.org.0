Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62BF42717D
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 21:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhJHTmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 15:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhJHTmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 15:42:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F889C061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 12:40:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 66so4046622pgc.9
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 12:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AgVdqOTecoDYRXhiI4x9+aIWjebsmwmfGtAOQTLSMDU=;
        b=dI5ehMKjMEb+sdIlL6rRALN7BA6DSlSZCJ9vFFqTDIm1pXku1CwzJDvcHvMZhZo5at
         O1xjFDmU+QnbGkKRHaRN4KyUWftO+eeKb/xSA4Cy5bK6wjZGf9i8NfkIuUfBTRq+P+cF
         Zoo6XbLgvSSe0EN/CgBr5s8KehND4tMSTv2wCPAPdL0gHXGry2t8522iy/oHxNOWKT47
         ip0HK4ju5RtmCmEvUwikwbAYiUZQ3f8aPiepJUVbMzjg5pdYNwiOK6QPv5ZHDdPtOAvK
         rYGRXsaLuHh0PZ/iqV76iFShCJFJnbyXkOmJ1kxytqxk7HxCzgN5bS5XdMyQsEhEHuxl
         +knA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AgVdqOTecoDYRXhiI4x9+aIWjebsmwmfGtAOQTLSMDU=;
        b=A9lc22Sw1WVJaMn36jOw04EzoBHT/aqHG4VlWoOlYP+9zYO5WkI11MHF1cX1r5rKQl
         H6w0zDnFjhfgFOFzM7AUIozuNVZZTAHja3DS89CrK3pEPK7V42yWXmNG+bWIzryn3l3F
         q7OF3rKq590DzmGzV5lj48tVvvWhsVQNCsBkF+s1WUF54u8ppSJbe4uPUTIWCfQegH/C
         cHssLPTRr7cCrVCgOlDRMpa/PuL1s/5j/d/SfFKR6Uk66zLfbsECCTMw1sDtKTp3NXkF
         P7jOyMwTACkKwfBrVWorX+9gCDfEHrYOWdxCyNDtynOEUglm7mID4vPOTNxVgIs43ACA
         pzbQ==
X-Gm-Message-State: AOAM532HUwXshqS5lriwU4YZQ+3jl0iWnjeC4+qpK0m/B8rlKpgICE6S
        E24A1BKnNUPUrmJ+WxQs1/uHV8IybFNklVUg
X-Google-Smtp-Source: ABdhPJyOEc0qAskpGGLjPtoGjDKOhovAik7cLoh4lil22aOjIknubmiKsurpq0gZCUxh/7ZOe5x1Zw==
X-Received: by 2002:a62:6541:0:b0:44c:2988:7d9d with SMTP id z62-20020a626541000000b0044c29887d9dmr11860503pfb.50.1633722016453;
        Fri, 08 Oct 2021 12:40:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2sm138731pfi.120.2021.10.08.12.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 12:40:16 -0700 (PDT)
Message-ID: <61609ea0.1c69fb81.6f55b.0d0a@mx.google.com>
Date:   Fri, 08 Oct 2021 12:40:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.209-12-g165573c6b5e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 148 runs,
 4 regressions (v4.19.209-12-g165573c6b5e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 148 runs, 4 regressions (v4.19.209-12-g16557=
3c6b5e7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.209-12-g165573c6b5e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.209-12-g165573c6b5e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      165573c6b5e7366ff94e95b2c22867b3dfa401d4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616069860d1f902e8499a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616069860d1f902e8499a=
300
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616099e841bd5db31599a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616099e841bd5db31599a=
2fc
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6160696819b4e3351099a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6160696819b4e3351099a=
2dc
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61607c77b37b954baf99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.209=
-12-g165573c6b5e7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61607c77b37b954baf99a=
2db
        failing since 328 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
