Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400E22A5CD6
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 03:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgKDCxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 21:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbgKDCxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 21:53:23 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C03BC061A4D
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 18:53:23 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id u4so3481677pgr.9
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 18:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3NLlFpkPG+vQnu9YSYTv98XlxNdgup4/dBCnZqgQ8MA=;
        b=WDEi+fWT+LoODluK3vjn/JRooE9+DDajWO3OuMfB/uJbOVl7oJlZ2Acs7niBALHQZn
         jHkWOgpUnyyVk64u2Ce3EYv9lSZAbrfKX7Gk2gQFw7w130OqtdK8W5aJl5cYDmmAHwGF
         JatPkuiMfq/GAaFCPsdKYx0f4rsgVz3WD0r7IhG0q66CV39CAaDNN1vZafaZ1IxQ0jsu
         uJBB3mhvhLSQf9a36C2RwDRgUOtPINrsfyr9ofM5A/H0nFkV0ADalWXyfAXFT034Kvz4
         CUKeqlYZhwLOqfa4VSiZo7hrWbZLZd81yVE+kfeLiYlHX8A7vzGZECJocNxwbRy5K2rf
         Hd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3NLlFpkPG+vQnu9YSYTv98XlxNdgup4/dBCnZqgQ8MA=;
        b=hqR0feuDmdddgjSU/HihwlQfg/siW+z/1L+hKddvBToAvOcRiVhr97FOjqzbahEJTg
         gK62thy259bvtxNrF6gWhJzxeGP5itnwzZ8Kx4zyOpv1Fh09pAJSB3ojizVcPHAfiPZu
         bFGavr8JkkTw/eD/KswcvsPTtMljxCybA9EbNBZ9Uj+D+Po0gx6RsNiXOQiFIFSlFy7Y
         4QDc9KKr4eAVCZoZRvTotPOA3SNgk9RwAc6Mhhx8zXARjzgl6jPHuOR/1zCdg2eO6He2
         l61Z4KRs5n5AcMlNcnGqQZzGMkdxJjvCQDZErzBFLi5Ofddkn680QNxztHkjbAdkk3cu
         BXuw==
X-Gm-Message-State: AOAM5327abL6I/MxFysm0Gg3m3hKksxPcilWHLmz1x5liDVE47SXJAHJ
        BsD0hkqFFoFevNcU1eqvL6GlStc4yQ9iGQ==
X-Google-Smtp-Source: ABdhPJzTwhi4iF0MXlpVv6nv1URfefGHPRrkMinwwLmb108NBbnglEEht+FN6BSpAts1WPLVyekj9g==
X-Received: by 2002:a17:90a:4417:: with SMTP id s23mr1807842pjg.156.1604458402048;
        Tue, 03 Nov 2020 18:53:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r8sm311368pgl.57.2020.11.03.18.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 18:53:21 -0800 (PST)
Message-ID: <5fa217a1.1c69fb81.ca56b.14cf@mx.google.com>
Date:   Tue, 03 Nov 2020 18:53:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-191-g43abc622c570
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 174 runs,
 2 regressions (v4.19.154-191-g43abc622c570)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 174 runs, 2 regressions (v4.19.154-191-g43ab=
c622c570)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

sun8i-h3-orangepi-pc | arm  | lab-clabbe    | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-191-g43abc622c570/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-191-g43abc622c570
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43abc622c570d0c7e49ac4b371ef9b8571a8e3a1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1e64b8eb518e733fb5315

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-g43abc622c570/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-g43abc622c570/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa1e64b8eb518e=
733fb531c
        failing since 1 day (last pass: v4.19.154-97-g7cfb7216817b, first f=
ail: v4.19.154-111-gc4bf20d39cc2)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
sun8i-h3-orangepi-pc | arm  | lab-clabbe    | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa1e55a12dc45ce74fb5308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-g43abc622c570/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-g43abc622c570/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa1e55a12dc45ce74fb5=
309
        new failure (last pass: v4.19.154-97-g7cfb7216817b) =

 =20
