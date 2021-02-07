Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC3D312737
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 20:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBGTgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 14:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGTgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 14:36:46 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281F5C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 11:36:06 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s15so6670469plr.9
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 11:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XUD2zBriUIeIZwv3b+7RNtwsEF+vUhDc4nKn7DdFXD8=;
        b=t5RlUj/c8N912/Ha9ooluwxme5W21JXJ1TlYHLSUmOSZC0arETK2+AVPjuE+Q5Qc7o
         xuMdG97+CUXvyKwlm4eHEVmC8jA/Km10QEZj8cGK8REIo+faSzPnPDKPvX+wTrX1Wpf/
         uJH8ZwXJBxeWGaVaS47dSJgfODUYbzf7Dq4cTT6p7djD4zIn2queB2utUdJrRz1On77M
         COvHBOuzUJYBm3Zjnvl8XFq7NMYBdRyg/PXn8iH8KsEAx4qaovT5jWCzIxCBR/0BMb51
         Tfp8fjTyKSZGF5NnO/k9WRwLJQdF2TRhrSu32WgNpIRsiEAUpakYW3BtCWoZmS9sBlkh
         Poow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XUD2zBriUIeIZwv3b+7RNtwsEF+vUhDc4nKn7DdFXD8=;
        b=jf1K8deTfjobKPr9+cQ8yOEUwjWGFENiBOR5qQyCmFsdoGUCvmEyo/aeeEqvPvpZag
         XHI6jlDWVxEfWJYeXp2Ol+36ujttByo7B1WnnIWV56Ep0Nw9aPzUQelfLU6EQHjUjMAl
         zOX4rVvqq+DvotYZFa3UNjjX9H92mcBFZsgFUfbpIgYvXg8fMhKXlD7UoJsQJAL5HC/e
         a/Q6eZjNnFOARX57UVbMLsihDZFWoOLrq4BOtoFsjpL1UzVvUBEzJPHx9wcUEjDqrh5G
         tb0ZHf94OjAbb/KBKNBHTv2Unwkbu4334VhqrmJGj/oQsKiWvoySUBQgMLVXYxQh7znY
         d6qA==
X-Gm-Message-State: AOAM5305S8dzODqbzWPlgpaCx0QODvu86Cdoi5mcE18wCeJ2J9eRDwi7
        q3pOmHX/GoZLOo+/1aZUBIUpMF9M5HmFvg==
X-Google-Smtp-Source: ABdhPJwcZ9IogKtS7Q5zEqGPsP7zkxH+HIKXckUWLadSZqcHFj2yO4bhKP4hIVwqT0jTmIoZdaYHdA==
X-Received: by 2002:a17:902:102:b029:e1:2a4c:61ed with SMTP id 2-20020a1709020102b02900e12a4c61edmr13658981plb.61.1612726565240;
        Sun, 07 Feb 2021 11:36:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g198sm16575150pfb.37.2021.02.07.11.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 11:36:04 -0800 (PST)
Message-ID: <60204124.1c69fb81.3a443.3b5a@mx.google.com>
Date:   Sun, 07 Feb 2021 11:36:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13-57-gadb6856092da6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 2 regressions (v5.10.13-57-gadb6856092da6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 2 regressions (v5.10.13-57-gadb685=
6092da6)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig        | regres=
sions
------------+--------+---------------+----------+------------------+-------=
-----
hip07-d05   | arm64  | lab-collabora | gcc-8    | defconfig        | 1     =
     =

qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.13-57-gadb6856092da6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.13-57-gadb6856092da6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      adb6856092da6c66a44d7a5016e28115712b99c6 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig        | regres=
sions
------------+--------+---------------+----------+------------------+-------=
-----
hip07-d05   | arm64  | lab-collabora | gcc-8    | defconfig        | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6020118dec4d2009d23abe62

  Results:     2 PASS, 3 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-gadb6856092da6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-gadb6856092da6/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020118dec4d2009d23ab=
e63
        new failure (last pass: v5.10.13-57-g1231f5f0cde54) =

 =



platform    | arch   | lab           | compiler | defconfig        | regres=
sions
------------+--------+---------------+----------+------------------+-------=
-----
qemu_x86_64 | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60200c22e416e5bda13abe91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-gadb6856092da6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.13-=
57-gadb6856092da6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60200c22e416e5bda13ab=
e92
        new failure (last pass: v5.10.13-57-g1231f5f0cde54) =

 =20
