Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6201623BF21
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 19:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgHDRxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 13:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgHDRxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 13:53:54 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F34C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 10:53:53 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q17so23537598pls.9
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 10:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GUGFx9pkE+XEFOARIw83oWsLWSjffSSs7ga/CYqeaRk=;
        b=dvcte8dlNuD/TPO4xRfjgoAfmLII1A22EtooQWhnYt0V69IN77koRi8dg+jLqF6VQr
         vbkvXARFsmXSm8ZVzQU7Fo3ucRwg4YRz9t4KvEPSUVqnQfS9mddXI9m4mK6zZdPAyf+0
         fy1PFRGuccl4Nb0+wRZ6fHQLu+3rbr0hb/1fNOiv6KdImmgqBWCx37fhMxx+/r2zwpHE
         +fYp6s9coms6ttEWUkiocbqOR7O+HILkYLSzRzvbLL5IqUy9DdpWDttNbvWzQ2UUZ9Vx
         m3Ouql7GF06E1GcVIHobX6KMgQhyIKshUy8IK81ybHsxr0zRWEVMCZ7Aliwl4QSiQsYL
         gb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GUGFx9pkE+XEFOARIw83oWsLWSjffSSs7ga/CYqeaRk=;
        b=FaUQI/mZLKtKsQNvLuPtP6vfVW0qqgrkeyjXlqx1Mv3vxUL1+H30osjJfbmWBCvkH/
         wXUMKfOWuE73SkPnlye2vwIvpfFabRRwCy/2/RC9yhq3H/yF7MX+Hgwz3v23daLgqir7
         XQkZiiEFBzkn8M+GuxniVty3gFG485cYdFCOnZrK2wTS69SdheXKsqpHQw2IvkEtMfDJ
         enTvapX1QqR2RXmFRtfhmDdoSi7cbScV8NjSeHVT1C2+hktrpFe628DMcp8UfeLtI4wD
         odJps0y4X7rLbuKMPPlv493khifc1iFFlD6Egk//xBF1IOVKbACXuqX1oxCh8VdzfVgl
         GVdA==
X-Gm-Message-State: AOAM533GC5wgptJmXK/TW2JuoVUTTbunql1fo+iyS2G2+qYf27znS45C
        OicyNPT1L6BSHoWK4YZJIOmlzpKkgF0=
X-Google-Smtp-Source: ABdhPJxEUsP5Y2SeAto1gAAE4QJMTtBwDwC89In5Tv9jMfrdFSB+IcGju4KD5vw0Sb4BWtQ6S7PGYg==
X-Received: by 2002:a17:90a:148:: with SMTP id z8mr5847678pje.197.1596563632332;
        Tue, 04 Aug 2020 10:53:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f27sm19894254pfk.217.2020.08.04.10.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 10:53:51 -0700 (PDT)
Message-ID: <5f29a0af.1c69fb81.89a87.00aa@mx.google.com>
Date:   Tue, 04 Aug 2020 10:53:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.12-117-gd3223abaf6fd
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 161 runs,
 2 regressions (v5.7.12-117-gd3223abaf6fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 161 runs, 2 regressions (v5.7.12-117-gd3223=
abaf6fd)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.12-117-gd3223abaf6fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.12-117-gd3223abaf6fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3223abaf6fdd20e0894b357a0f7f1da21a29226 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f296c738ccb87bbf152c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
117-gd3223abaf6fd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
117-gd3223abaf6fd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f296c738ccb87bbf152c=
1a7
      failing since 18 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f296c13edcc97351752c1a6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
117-gd3223abaf6fd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.12-=
117-gd3223abaf6fd/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f296c13edcc9735=
1752c1a9
      failing since 3 days (last pass: v5.7.10-199-g3d6db9c81440, first fai=
l: v5.7.12)
      3 lines =20
