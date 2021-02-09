Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF507314843
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 06:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBIFeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 00:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBIFek (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 00:34:40 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55ABC061786
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 21:33:58 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 18so9044010pfz.3
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 21:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AgCWI0BTSsFDBe6LMt78Glz7R3br6yOvP6D8xBFrvo8=;
        b=U1HeYtQl9Tsy6fqYDHGZzAlphPodf51IV+mJVJJZy7nkQudmHvMjn9YqyLRQxkNMDn
         gLOubPGoGHceKCEZnTX/1rgMCHZwZn0iqqM9p+4K232zDJPWb7sh6jZ/Jr0U75OLrxmU
         00a6GCC9tjsI5Rq83EuSYizWsdEvAFGbehHGtZPW3AHjchiQbHHg6ktAHGrpF73hoOiO
         GRU8jzr0zyJldk43VtGGZjZikfM650WMahGA3JMAFTfy0fErnZJCJGumgTSx/s+dgAMZ
         tttGNV2+JeTV65/7JTXstaL6pSj6pSlzXASAp56gwNKZyDo2vd3HxGoXREj0h18PptBB
         SbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AgCWI0BTSsFDBe6LMt78Glz7R3br6yOvP6D8xBFrvo8=;
        b=ikW5ufavNIuD2HrCTe80jpJy+0TBnlVbCX1jWnFELi/44Bq+mhNKy9vDTBvukYU43H
         s7lqx+ZURuJQMmZ7+guBfunhIIvE2UK9Rf4nbmzCuO40x9HX8ftvkVUG/bfyxghftLHu
         vZ3iEXEJzP6nMfkcmM24MeV+nluFtjDhN73WHMi2TytGJs/7YXqaQ02Qfscu7JgGqrW7
         A90dvxyqtKggc/GujqVNhTFau1ODPFiqM4YrzEo4cWF6h+uCIGWpmEb1syUWAGBgq8DW
         LqMd8Ldt69113lSUnHjQG4nhbPvqnMtylsBTYYSsuU9FNGt5JWz/LLszGAee4ME6LF9x
         qF3w==
X-Gm-Message-State: AOAM533J67zHemhbG56iq2nRpr8BKF2bmctcEZ+70vQRsK73JVLnvp+m
        OOcGqkBTvLyDgKdrld7iRaPTFv3+FvzNEg==
X-Google-Smtp-Source: ABdhPJwb8OghBr16Cn4ZXWZrQ8OESoOWiuriLogUjv3XjJ+o4T6no9MtUDwpQ2t+ulRSRqKK9StCdA==
X-Received: by 2002:a05:6a00:5a:b029:1dc:8ecd:81c7 with SMTP id i26-20020a056a00005ab02901dc8ecd81c7mr9241229pfk.33.1612848837734;
        Mon, 08 Feb 2021 21:33:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y26sm20877454pgk.42.2021.02.08.21.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 21:33:57 -0800 (PST)
Message-ID: <60221ec5.1c69fb81.389dc.f04a@mx.google.com>
Date:   Mon, 08 Feb 2021 21:33:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.256-44-gcffa06cb070f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 46 runs,
 2 regressions (v4.9.256-44-gcffa06cb070f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 46 runs, 2 regressions (v4.9.256-44-gcffa06=
cb070f)

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
el/v4.9.256-44-gcffa06cb070f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.256-44-gcffa06cb070f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cffa06cb070f1ce0015e19c0f54b7a2b86ab4d24 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
panda              | arm   | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6021edb37d1c0280023abe88

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-44-gcffa06cb070f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-44-gcffa06cb070f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6021edb37d1c028=
0023abe8f
        new failure (last pass: v4.9.256)
        2 lines

    2021-02-09 02:04:31.438000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/124
    2021-02-09 02:04:31.447000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-09 02:04:31.464000+00:00  [   20.763031] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
r8a7795-salvator-x | arm64 | lab-baylibre  | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6021ec33c181b0c56a3abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-44-gcffa06cb070f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.256=
-44-gcffa06cb070f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6021ec33c181b0c56a3ab=
e67
        failing since 82 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
