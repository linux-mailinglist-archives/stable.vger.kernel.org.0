Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78022A1F81
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 17:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgKAQ1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 11:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgKAQ1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 11:27:33 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD7EC0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 08:27:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id a3so2103343pjh.1
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 08:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rzbAc7L+dxX8F+WqBOOuaOTKhTaJkGebMHUJTV90gIo=;
        b=jYNiXJW4ZTSZPiGX1fyrx5BQGLEb1oiXrdKS8X58TSnhmdkPp1UXXp7gjWrGyLaYI0
         Bn/oXLvjKDz3jor2UQuH7q5XVhOURzC/efu0H+yuHD92iJQSwoMUI1Dg+5Ugfj/K8YeJ
         1LbhAvIE0BPaGDGAo1/v+9BH1ayspuACSZTl0Wpr/g9xdUBl4F3XAZSIY8ABeUHNKSWZ
         pl9O7xt0xtQ/wdTVmQFAoE5jnycseiM69Lzri2ovUaBB5Izi4mbTyRXb76ymMCWOgcvw
         4emmh7gR92nDoMYT142gr5qLVlfwadCZkUa6t/UJCmSEmAecLlKrLtimOUBSBhEL9NVt
         Xf6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rzbAc7L+dxX8F+WqBOOuaOTKhTaJkGebMHUJTV90gIo=;
        b=WGAezlhKD4kiRGITneaDJiyG3khS3qfkdrBqKExaBnjQgYbcBTkcVtzb5cNFADr/Z7
         Zbe6bTOiLLmswrFKrWkhyQ1JN8wmbxZvRqWeVmRh4mTO9V0W0b7VIeA4JZ2rmKvfMtqZ
         NVGlqSRK87us4q+CNJEnDyJg8obJb2qmzlamtSuaK51A5JP/lrpbeN/hRI2XMLbf4qqg
         MvXQT6UQm9dJH7usktbcbNznlCCu02HLwWsg8Zodq+JwdOOf8bB6+lNbgdryTVqY8XYI
         ru5Buet1KTWbBQTmwrXbi4CNB/I3vu19NTg2xSiSUDaGPQC8+dr9HfWTTQP79lrsmCS0
         bwzg==
X-Gm-Message-State: AOAM530GKuVSX8M11RX1T0zPfU9d7q3ui1Se9cWrwNRjWb0o8pEsWEMZ
        QGf/rC4+B+x89+fJwh3g+vFKs+5K3SE65A==
X-Google-Smtp-Source: ABdhPJyrUCmJUg0lQVebwOqIhSAVKqehN2YirRmqVAUjo1Eqsm2GrS0OzrhI3Mb4MuDJHQ2CIP077A==
X-Received: by 2002:a17:90a:67cb:: with SMTP id g11mr13632080pjm.226.1604248051077;
        Sun, 01 Nov 2020 08:27:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x22sm11707910pfp.181.2020.11.01.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 08:27:30 -0800 (PST)
Message-ID: <5f9ee1f2.1c69fb81.e6c41.e888@mx.google.com>
Date:   Sun, 01 Nov 2020 08:27:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.241-14-ge7f356d87b35
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 2 regressions (v4.9.241-14-ge7f356d87b35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 2 regressions (v4.9.241-14-ge7f356d=
87b35)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-14-ge7f356d87b35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-14-ge7f356d87b35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7f356d87b350941ec7c422fc298caf531b88d15 =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eadabee748c875d3fe7e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
4-ge7f356d87b35/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
4-ge7f356d87b35/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9eadabee748c875d3fe=
7e5
        failing since 3 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9eae5e2fbc6598783fe7eb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
4-ge7f356d87b35/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-1=
4-ge7f356d87b35/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9eae5e2fbc659=
8783fe7f2
        failing since 1 day (last pass: v4.9.241-4-g8d9cc85ab09b, first fai=
l: v4.9.241-4-g40bcb1fe569e)
        2 lines =

 =20
