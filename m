Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7343D845
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 02:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhJ1A7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 20:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhJ1A7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 20:59:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1215AC061570
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 17:56:52 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y1so3215935plk.10
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 17:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zkxEdUKoxg+5khwjvJ7eWJCVOFiLsUnJVePGgEGWsyA=;
        b=hFddG8tY2ImPSlMtAo5A22um512Y2uvCeu/ZY7JsFSaE246YLR8PsEku6yiQjkPTNf
         orJc0ZhHiYcitPiAj618co5wAxGKv/zYt40Fy3G5Y7BkFVKyO+FOVUnEFSXYvzkqoV2P
         782F8/Cgdrz/fiSco0/FmEwCaAbrUAhBQQG11keMyNT0oEb5hp4S+SMpgDx4wUpHbP3K
         PnDAEVBTDaW8a4u2mr/wG7G+o3gW5iQYbw2O3ijppDHx57WxYJqeStIacXlnkjwDDNc2
         PY8bxpZ73wgMo3uzwTsINe1wwjIplAoQa/C9ngahqUBn/LtgmlcB9pKUqk4s9U/+j6F8
         TE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zkxEdUKoxg+5khwjvJ7eWJCVOFiLsUnJVePGgEGWsyA=;
        b=nUjXIrsOb0NRyBCuJvWTq3sL/rA+Ro01izHGGqX3j3FlOOtZBD+jzDW3vC5xFkXWWB
         YYfNVh5QdEtoOReH0L+5r8/dl406WT5qOEuP9fC2sPJ/uT9E4iOcwd9i5sqqa6UWqlsh
         jaTDuN9ePa3nxcKUeNT5KOpRnJ2ZM5v9887GDkdxKTcOEN2ASHOggu9Vwu9lZw3rTbZ+
         3/IE1xGJ1X03DGiE8ZDxv4qoHNXxu7r1ypwCUhf/7wHAmUWwmVGd2/WaYTxmE24ZnGmF
         FKgl9kX+eVLrHvLq2luRzJdEV59VnzqpZmsjen9YpdE4qkSGqhQN3T+OOAGoBwQT7XnJ
         j3NA==
X-Gm-Message-State: AOAM532mhrMHUt5qFE0M7TgBSwykT11bVlDkAVCMukXUIJM25kxWDkFX
        uTYGfwiP7G/HRyQ86/mL0PXgEPGudxnz+gjGDGc=
X-Google-Smtp-Source: ABdhPJyz4myHX5hR/GoEpbtMjsnmAkDnJcNsecWpAnoNVL+FSqQIuH/JanEfh2vGiTXdAHy5I6favg==
X-Received: by 2002:a17:90b:1988:: with SMTP id mv8mr1094991pjb.193.1635382611474;
        Wed, 27 Oct 2021 17:56:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm1101458pfa.39.2021.10.27.17.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 17:56:51 -0700 (PDT)
Message-ID: <6179f553.1c69fb81.37cc4.4fa6@mx.google.com>
Date:   Wed, 27 Oct 2021 17:56:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.15-7-g2c815de0cfd2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 118 runs,
 1 regressions (v5.14.15-7-g2c815de0cfd2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 118 runs, 1 regressions (v5.14.15-7-g2c815de=
0cfd2)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.15-7-g2c815de0cfd2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.15-7-g2c815de0cfd2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c815de0cfd2582f3ceff88c2ce806ba47f7cfed =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6179bee0a227d911553358ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
7-g2c815de0cfd2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.15-=
7-g2c815de0cfd2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6179bee0a227d91155335=
900
        failing since 3 days (last pass: v5.14.14-64-gb66eb77f69e4, first f=
ail: v5.14.14-124-g710e5bbf51e3) =

 =20
