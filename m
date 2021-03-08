Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF4433150C
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 18:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCHRmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 12:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhCHRlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 12:41:55 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650BFC06174A
        for <stable@vger.kernel.org>; Mon,  8 Mar 2021 09:41:55 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d8so5198894plg.10
        for <stable@vger.kernel.org>; Mon, 08 Mar 2021 09:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5EF+7cpc/pw8Tz00Qba8kYPhSTf9Vjjbcz1WZsunQ4c=;
        b=1nFRuFg6oGCzycb3KjacxPfSecZfjziBEEgquptmenVSUlR5o1JkdqLm/Gt/bLMNSW
         wAPQerZtLXN2tl6jex+sWoOtWhuhh1Z591QuAJw34h8DsA0rjGdwgurMBEC5h29a4jSE
         kIxygiFFDzmL6773Yz4lp3KnCVPQUnwBSIfzs54rcf2EwWZJAmjd9Wg564NmnoUWltvI
         jQ3hm+vNyORX+A+GQb23eme2Kqi+AmRlGeDxmONmXXpfeUvL651f0y2aQ1PBeAt7z54/
         SoWvjWMxlc3VvktbFJwun7BEnCLpYvPFdKHhQkluQUPG3sCVSznr/PhNPABGOS0lkRaO
         I8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5EF+7cpc/pw8Tz00Qba8kYPhSTf9Vjjbcz1WZsunQ4c=;
        b=XRWsYUTyxdzCvTno1x79nPKI4s7o9FUjtsnH6rwCywBZbWGZeDXxfJtJZt0upJzwUi
         3SVxeK6W5tjy7f/R3Gh7lz4YACDUy9cz/T7pdrGwYOqlIjv5ZlvS4hzYhyf/SfyNdmyC
         IUVwNftKG7O0mwxXP9u1PnSvATgjFDnlHDD7+ogqqkk9zUOifjLS1a9n2LOgpZwAnWCl
         9RB7nFN5m3Dn/Zztc9ppmpJ4x+Qv2qjykOsY9Xv7BXtbVpVMa/aaxrOL7+v8QfYPRYfg
         MP7G6KEHX1hLfoKJF0vv2BX9Qn6zhKCW1mYmGSUiz14ZPeF13LyPi4Z3uCk8EA0Z04Ql
         Fm0g==
X-Gm-Message-State: AOAM531TNSfyitU41Dqob7g9XVIunk2aU0weLhzyjh5S3rnqUEOtNLg2
        5d9h7PNVo2j4COfB5sg/AXWv3rXJhQ1DeFoI
X-Google-Smtp-Source: ABdhPJyMsuTRj0lXTkb/qRc2+szuWO642kiIMvO0DUOKGY490udV8jp1fthLbwHlhYKgs1rSwesJVg==
X-Received: by 2002:a17:902:8204:b029:e3:b425:762e with SMTP id x4-20020a1709028204b02900e3b425762emr22241127pln.13.1615225314759;
        Mon, 08 Mar 2021 09:41:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm3706pjv.49.2021.03.08.09.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 09:41:54 -0800 (PST)
Message-ID: <604661e2.1c69fb81.4e599.0039@mx.google.com>
Date:   Mon, 08 Mar 2021 09:41:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.260-5-ga5a6c27caf2fe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 5 regressions (v4.9.260-5-ga5a6c27caf2fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 5 regressions (v4.9.260-5-ga5a6c27c=
af2fe)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.260-5-ga5a6c27caf2fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.260-5-ga5a6c27caf2fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5a6c27caf2fe3a4ee1ad7794511540b7b868239 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6046314036207422fdaddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6046314036207422fdadd=
cb5
        new failure (last pass: v4.9.259-47-ga72abe756a5ef) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60462e0455ad36c2caaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60462e0455ad36c2caadd=
cb2
        failing since 114 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60462fead2645ce541addcb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60462fead2645ce541add=
cb4
        failing since 114 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60463069090360cc16addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60463069090360cc16add=
cc6
        failing since 114 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60462e070fd7ba8e00addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.260-5=
-ga5a6c27caf2fe/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60462e070fd7ba8e00add=
cb2
        failing since 114 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
