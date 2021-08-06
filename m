Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD523E291A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 13:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbhHFLI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 07:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbhHFLIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 07:08:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE8C061798
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 04:08:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso13365121pjb.5
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 04:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ss1bpyKjxTRC7OKE4U0XYKmdrIDcArWDDsp1SUeuKvg=;
        b=O2eJADyz21cNhHv+i67g1DHHFsq1fOe8PDo58XcF6eCH8p5lFVtf/u7ZUyyYNRL7JM
         YeVDDPVWiy0rs7CyrPMltVe5la/e7vRi5unXJNKqHmhThfJJV8r5dS8RFQbUaz0kAayE
         khAmd39OiPCW4r4wSsDfVb5KGCDftFBVzMA91P3st0F+QHT8UTdQDL5PeU4g4WVKMVH5
         knD7GKwnJ4Dfqjp0csmJTnq1YvPN864O8jogWa4oSirluLj32XLtQQMGANI1xCzH+LAK
         m7+xfWFQ1lM7YLtxvX14aRExDPCSQhPEuV+8qjPbyRt5ljyxhNvszqFw6HuaLrIKe564
         kwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ss1bpyKjxTRC7OKE4U0XYKmdrIDcArWDDsp1SUeuKvg=;
        b=K+gkIsph6mkywErNhCivZGNowGNRypkcPOgIjnCXgmxvX2Pg93bjxb9LUjw4EVFkR6
         i1i7I9sjc6iVsSgQ+AhYpUg53ZQxDRThg2ZD17C5Dl7MuhI/l/kIgUyeT5mBpKhLaqwd
         F1KaCRB/exlFeE2aUqQXlgUB4Hs7/FaY9QI9wxEycJYu4xzSn12rmK9NlUxwOqAjBzOH
         tD3GRMxH9q+y8nA+dSMS5gIFb6bh8pM0nm/xerL2N2wEsn21eUBki7ugcjR8Kxop+Ru3
         9k40bE76/qTlfYPWJ61mp1kH3P1S6s4SQJUwyaiPaHMAJ49m9xd5qwEJIVUdTLWsK8v+
         wEqw==
X-Gm-Message-State: AOAM5307vTawwDoHpspwaVpED9oiX7/niEk+AyxhBbJjPRPk6iZn/Va0
        MewzywFmoNZJylrMXOpd6lRdolzHPDp0sA==
X-Google-Smtp-Source: ABdhPJydYXA6ulR4p0LXRtLMejJzo8IFWgacikPaRMkTAdYu0bvkxOSC5YgX+6Ltk31qJEiC02FJRQ==
X-Received: by 2002:a17:90b:f10:: with SMTP id br16mr9628282pjb.76.1628248088958;
        Fri, 06 Aug 2021 04:08:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm8991926pfe.72.2021.08.06.04.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 04:08:08 -0700 (PDT)
Message-ID: <610d1818.1c69fb81.f3531.9c59@mx.google.com>
Date:   Fri, 06 Aug 2021 04:08:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.8-33-gd8a5aa498511
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 106 runs,
 2 regressions (v5.13.8-33-gd8a5aa498511)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 106 runs, 2 regressions (v5.13.8-33-gd8a5aa4=
98511)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig=
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.8-33-gd8a5aa498511/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.8-33-gd8a5aa498511
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d8a5aa498511c9f57f0a64e68cfe4af9b32ee423 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce1cf636f61608bb1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-gd8a5aa498511/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-gd8a5aa498511/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce1cf636f61608bb13=
67b
        failing since 8 days (last pass: v5.13.5-224-g078d5e3a85db, first f=
ail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce82f0c2473d7b5b1368e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-gd8a5aa498511/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.8-3=
3-gd8a5aa498511/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce82f0c2473d7b5b13=
68f
        new failure (last pass: v5.13.8-33-g3fddce574f66) =

 =20
