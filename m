Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187C8314872
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 07:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBIGGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 01:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIGGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 01:06:22 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4F1C061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 22:05:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z9so1010163pjl.5
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 22:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6F7rW6Ch7bmgIRQbQFQ1SdlV1fugyPZD/sV/YVFJ1RM=;
        b=MP+pkM6nAfKdMRUMBkIGBlUh0oi+uG5eQljD/mXS23peOvW3MkWElvmX8vKCQkYzkK
         G/zHSJO8hy9mx7nEMqIvkXsmPtf+4nx+7QStZbRPzHk2DVD2Pr9DoXBBgx6yc6WiZVIP
         hYTDBLoLOeDkSicKbS4fkqY/oUXdnI8P4jwB+D/2CPIsFY2SpG72xywVtwEIX5FA9mkf
         XCr37Y5TzAzkanOjClY/+GhxepSFWvG4JC6iHcO2Ne4H+bkiSPbEoF/8Cf5Pi77UvZBz
         8d9/g6knNXcdYta4RkUJYAbMBema2MxDOEG+aQ9TKMhfXSqryVKq/jmNi+ZkGwJptkNH
         QOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6F7rW6Ch7bmgIRQbQFQ1SdlV1fugyPZD/sV/YVFJ1RM=;
        b=IVFUMMiFM/FNy3aWj0ARzG80aVDdizXLj5Z3v8B05Me25qYzKRS63i6rE+PaDMpwas
         Kqwxmn2dcpBZmwND+DzvpMt9qOMhPyNaR7WgY/OaDLz+ziq6iLyaGqeO9TQF6T1Sz47c
         IwTvGqv4R6ULg6WBA22rweEfxOSfOrGmqNVjiIRgBueAOOBPJRomSmgoZbI31b1rl4i/
         vvZG2V/o9fCsOGyTJkqUNFylDzhP+27O8/ACtHnvDINo6X9emjbLi3VrWHy5fHOuEed4
         fjsxmnqHdLYRzy+M9/kXFb5o+3X+Fgn4pe+oUF3LS9ZWsmrKcUd7SaP2fqhXbbWUGvY6
         s2Yg==
X-Gm-Message-State: AOAM530JbCG5kCY3JT+nIWHthTZEf2/41n1xO/ZfGTN+dPK3x7uBZtE0
        bO9wj3mbdvjMl3tXaPWrMzqHew93zJNrZg==
X-Google-Smtp-Source: ABdhPJyiAJvwQympHIn+r/JUZIkiJxb0evlDiPdvbwJZ8d/Gg4m1YWfXU2TSWUzWh9jlFCm2klsfsg==
X-Received: by 2002:a17:90a:6383:: with SMTP id f3mr2459822pjj.14.1612850740506;
        Mon, 08 Feb 2021 22:05:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o76sm20670238pfg.164.2021.02.08.22.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 22:05:39 -0800 (PST)
Message-ID: <60222633.1c69fb81.5efa5.ede9@mx.google.com>
Date:   Mon, 08 Feb 2021 22:05:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.96-66-g7b6a7cd488bf
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 107 runs,
 3 regressions (v5.4.96-66-g7b6a7cd488bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 107 runs, 3 regressions (v5.4.96-66-g7b6a7c=
d488bf)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.96-66-g7b6a7cd488bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.96-66-g7b6a7cd488bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7b6a7cd488bf6be0b5d83709c148c3d69c737a15 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6021f2d312c861f4133abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.96-=
66-g7b6a7cd488bf/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.96-=
66-g7b6a7cd488bf/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021f2d312c861f4133ab=
e8e
        failing since 80 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6021f6ded308fc084c3abeb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.96-=
66-g7b6a7cd488bf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.96-=
66-g7b6a7cd488bf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021f6ded308fc084c3ab=
eb5
        new failure (last pass: v5.4.96) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6021f4f2ab54eb98ab3abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.96-=
66-g7b6a7cd488bf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.96-=
66-g7b6a7cd488bf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021f4f2ab54eb98ab3ab=
e78
        new failure (last pass: v5.4.96) =

 =20
