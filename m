Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5997B29C7B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829009AbgJ0SqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:46:25 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:51408 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829053AbgJ0SqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 14:46:20 -0400
Received: by mail-pj1-f51.google.com with SMTP id a17so1244135pju.1
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 11:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qAZVwCXBuOwqSCLajNO+q89dNarf7zRrYCZTnkFs8VE=;
        b=Fgu0UTwqShasxfgpkVCLKSUjNEMmuibFP/5WqX5YhLdF54GllSNNQE1l9ATabCh9HX
         CI2OgRId/fM+587OporUcd3lw6W/yzAJZyMhZHhvZ7CdFoxhZKR1p2E+RMPfcP+zSeYQ
         zR2BLoq/glOKS8pCHowF4MgLUk+M1Ttz29AN1AVPoTAV+0aThu/oyhv/aJISA2gbhic/
         aoSUIyft6QY9AyB+3fy35nWVd2ZviPNjZsgF7oUk8TS4Uz3PJLfp20s11kkqZcXbhYhK
         P9VdIlku/M00Dn5QvtmZk8bQjgps7JMhDa6cy4b9T6qfF7wiH+5L4QxTOCx7u050buc3
         773w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qAZVwCXBuOwqSCLajNO+q89dNarf7zRrYCZTnkFs8VE=;
        b=qMqtzfxaqJIvQXxKWGGlIx5LApPnb9n82aCemzm8Dd2MeG1jgfDIBGxYbONOH9NWQX
         zaBeK7yUEYCp9oIw3Xy7hxWEXG/H4fYfxvuXGpg3VbndYROsifgqTjLovnRc4c8O8V9i
         Z5opQd9V/Wk2qFW5NMz9OvJwhPlk4NrIuqt6xI/EeJ2UvRr7cBOocStac0LGGW5SJJVi
         lwO5G9aixRTvjsPNeGgyNnnDrI1yE51YasKnqWes0Et1LXIMQUGkPtNx/L09vQYLnJqD
         yawLKna2TXTdh3xRC2+zKkh/dxRhSgbb/ao7rsLy2mJEiIwq+kouyXgoxomaDkOqNam6
         waLg==
X-Gm-Message-State: AOAM530zS0Z6l5Tva3nY5GlR3ZFdN39YH+Kt789QtDI1eTpBVMPeh6To
        nKsZzxpdw2lhAY9TUYLkrPgGWSU0itUV1A==
X-Google-Smtp-Source: ABdhPJxl0rU+preXQ3oeXXpj0lftow+u7Ie00l7QfrVv5m4PHESHdI9i+6fLSGLpObLsSyggf38+sg==
X-Received: by 2002:a17:90b:300a:: with SMTP id hg10mr3364965pjb.72.1603824378891;
        Tue, 27 Oct 2020 11:46:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm2702825pgm.79.2020.10.27.11.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 11:46:18 -0700 (PDT)
Message-ID: <5f986afa.1c69fb81.75c45.4daa@mx.google.com>
Date:   Tue, 27 Oct 2020 11:46:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-192-ga42f5f48c6ae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 146 runs,
 3 regressions (v4.14.202-192-ga42f5f48c6ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 146 runs, 3 regressions (v4.14.202-192-ga4=
2f5f48c6ae)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.202-192-ga42f5f48c6ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.202-192-ga42f5f48c6ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a42f5f48c6ae133fc827daac1a64c70c300e32bb =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9836153c12716295381030

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-192-ga42f5f48c6ae/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-192-ga42f5f48c6ae/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9836153c12716295381=
031
        failing since 95 days (last pass: v4.14.188-126-g5b1e982af0f8, firs=
t fail: v4.14.189) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98358c3c0b0f84c938101f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-192-ga42f5f48c6ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-192-ga42f5f48c6ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98358c3c0b0f84c9381=
020
        failing since 210 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98381e1b25cf3e50381029

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-192-ga42f5f48c6ae/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-192-ga42f5f48c6ae/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f98381e1b25cf3=
e5038102f
        failing since 3 days (last pass: v4.14.202-11-g83970012a2ed, first =
fail: v4.14.202-22-gc247dbbd6699)
        2 lines

    2020-10-27 15:09:14.768000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
