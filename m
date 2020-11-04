Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648E32A662C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKDOPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgKDOPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:15:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF13C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 06:15:20 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t6so10334518plq.11
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 06:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HIl/tX482k7qTRaITJNMq7VFkWMzLtrdl71zIrjwR+s=;
        b=A4e4pWoRASxxvG4oLaPZZSbLR7GcvZKGc4Y2EcBhtEE2aIwSxAkdqyfmc2e4cLEMLZ
         xQkmehWC53yYSehN/KxzCzDDE8ujT900+AJOpmvjX78pCWC8yXxQsJLaCD06AWUCzYcg
         vop+gTnILAmXRUvejgGo03+6YRBB7VIj0w434T3TVs4nt+URgxb95of48W+JHPxy1RER
         A6zLUCh5OY8lHQj+mHe6AMcdSk56jr8FVTYMbHxTomGHYksL2VB5twCzlPTIyd6lf+sJ
         DlAfzwZAU0HLgj6fptAFdDek4VbrkON2hqUIM3sVRmsHAM1qNhWic+lHaIWPmo0RGFDW
         KiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HIl/tX482k7qTRaITJNMq7VFkWMzLtrdl71zIrjwR+s=;
        b=Tvg55QBJ+Qui25r0ABBZsKwX/1m5P3Vlps65NoQVqoO3/1ZN74E/fOUW6YK/2OQKiW
         l9+r+mAXaRDfwjRQfcHG/WlHC7hSpHuFtCKu3L0Jio2tliOuNhesHaOoO8pbA61wnN0Y
         9MPLBArCQs/5smtIf90ZaTqG3sqda0icaHFMk0MJm6wrmTSZp1zWtmVy9n7JER3zWJNT
         2j1HoIZypQ+4o+Gok0feytfa1mNcSRZp4LHHe7ucC2oNXPupJrGXECHagEiEnCOGrRE0
         XGCWEqOc+Gta6CPGhcfGDZL8zXzD6Zd88bXssQ6XarXxYVGA24/IHDBtCs2oDheF+46f
         c+sA==
X-Gm-Message-State: AOAM530U2i3dlQDestxpXGM/ZwrDhc2gZYmUL+l3n/OolxEI7qG7Qv8t
        +/WEf1LvVnGEt6p0b0cVAPAy2wC5B2RqcQ==
X-Google-Smtp-Source: ABdhPJzQ5tJDztyC3SSLJlpAe1enwQBjfw7M7Vjgk/icjRRlOuwFUDk/6TaElHV3jZ6M9J9laO+YqQ==
X-Received: by 2002:a17:902:ed01:b029:d6:bb79:d46a with SMTP id b1-20020a170902ed01b02900d6bb79d46amr18905560pld.76.1604499320046;
        Wed, 04 Nov 2020 06:15:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w187sm2716182pfb.93.2020.11.04.06.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:15:19 -0800 (PST)
Message-ID: <5fa2b777.1c69fb81.678a.62d5@mx.google.com>
Date:   Wed, 04 Nov 2020 06:15:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-191-gc54d2808d7bf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 1 regressions (v4.19.154-191-gc54d2808d7bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 1 regressions (v4.19.154-191-gc54d=
2808d7bf)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-191-gc54d2808d7bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-191-gc54d2808d7bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c54d2808d7bf52a8c131c25af3d7dbdb2bad22a0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa28414cbf629414efb5431

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-gc54d2808d7bf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-191-gc54d2808d7bf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa28414cbf6294=
14efb5438
        failing since 1 day (last pass: v4.19.154-97-g7cfb7216817b, first f=
ail: v4.19.154-111-gc4bf20d39cc2)
        2 lines =

 =20
