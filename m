Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7831B2FA
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 23:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhBNWMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 17:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhBNWMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 17:12:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6695C061756
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 14:11:37 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id f8so1071852plg.5
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 14:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2orBR9OYW5BKPAJ7AUQqRPGmm1xoHW5Oit/il/3Xfxc=;
        b=Op94sF5oBLL66NIdX6/K56BaonIeXXOiaAlM7IhiIGrqTBncYmJjgdHCeYRY83OVND
         sM1o5moqOinpXei4Xk09Mo/VDxG+mBZD6p2Xifb+YDbMqss8Cmhan8Wi9lf05GdQf1ZY
         LQMKrBbJfH1xIA4wUl5e3BS7D4L44OzTTZP/Dca293xoolt+ME5H9zZMc5hVXVVH5o4S
         GUX2dnlAnwqHqDNZK/xJdd6V7HrVLZRFN2wFIFpAN85whtk9aRX5nc2hnBGC1Qbd3UAY
         322jtjWaKonZA7zzmlTSSk6hJURN637YXQfBxH7woLukD/znmZAtxbVP6+JgrEJ975Ba
         ilng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2orBR9OYW5BKPAJ7AUQqRPGmm1xoHW5Oit/il/3Xfxc=;
        b=bKBWYiGQ3uMCd1Mk38/syJEC1zlX4AJY1DMPeRoFSoaTS4sxurXGWa9CfwYZauEvIy
         ooEo1qJ/S3WWQniL2QjkU9UKZYeiO61lxvcVT+ZmaaCWYEUbtxUQBjLMrtzY90xIwh88
         O+resNtknaooEyTt8NTaSsqfv+LRlQt7/BVRZ7zgy9pktcNlki7QC91s6e3qoKVmhosc
         uClcTapqA2S+1s0FnMMq1CT5cGn3g6HZ6QOcODO8yULE1d8Zvvi0/smiYUKin5hY0xwU
         jG2d1xMVZNbmEZrraxohhgfASQT+T8S3yWHlK16ufHlwupFkPYjp9oCrc8K8aP5vc+tQ
         TvHw==
X-Gm-Message-State: AOAM532QIP8FndxVorpVkBiJ9BpFofNTYZ9cYYl4WK80xybfb+Wo5f+L
        eri6A0je2XEqM8DLJJoWwmmf7HHUoi/oBg==
X-Google-Smtp-Source: ABdhPJzZ+eFpxKLLVsZ7Hbiougar+Z8b1qNtfgEbzzytJxoexU8TJ3U9qLZUQLd96+omgEGGQTWG4A==
X-Received: by 2002:a17:902:d64d:b029:de:8aaa:d6ba with SMTP id y13-20020a170902d64db02900de8aaad6bamr12653531plh.0.1613340697039;
        Sun, 14 Feb 2021 14:11:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z2sm15753674pfj.100.2021.02.14.14.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 14:11:36 -0800 (PST)
Message-ID: <6029a018.1c69fb81.2014b.186b@mx.google.com>
Date:   Sun, 14 Feb 2021 14:11:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176-15-gc9fac9124144
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 78 runs,
 1 regressions (v4.19.176-15-gc9fac9124144)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 78 runs, 1 regressions (v4.19.176-15-gc9fac9=
124144)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-15-gc9fac9124144/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-15-gc9fac9124144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9fac912414487d724cc2a4f653e85c0e74121dd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60296c3ac6bf4403ef3abeb0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-15-gc9fac9124144/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-15-gc9fac9124144/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60296c3ac6bf440=
3ef3abeb7
        failing since 6 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-14 18:30:13.635000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-14 18:30:13.647000+00:00  <8>[   22.693237] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
