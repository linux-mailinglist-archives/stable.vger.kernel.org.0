Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49F3FF4D4
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345907AbhIBUXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 16:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhIBUXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 16:23:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44109C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 13:22:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e1so1916865plt.11
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 13:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mBse7eIxBou79BW7ov51qh+Ba9bv6O+/AJxF0fXgiA0=;
        b=cnjios+oFoPrSogCcAOIEFKWggZcgwm48D4/sE6FdyDAXX1/lCPOc3qe/t76hJCVTl
         2BOd1xrbDTEqojNQZctSfK1jf6iWtb3cyqAGE/cAuMnzBNjYQLYYHc1VGXzg7ICO66wr
         2ayOsu8RuxWAt31amlK367oLjM0ENNwhmXrCyHHJERC4Ztcbo0ZlXV6hpsbvJK28PxaO
         CIFO4ZJUPArUxlVV2Q9YwjjElBIXqSab3Oqn3CTtmbt2vyXRuXInAVsJxyBPgxr8D3Zs
         AkolAssNSNUtwYiF8RF63/tQ6Jhq/qG7uehxAkkeADGhlrNMrFbeEA4hufo/sBh50g0l
         0yXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mBse7eIxBou79BW7ov51qh+Ba9bv6O+/AJxF0fXgiA0=;
        b=JPq8FXlkQBcBS47GWqQTY2mymOplpmDAhwZIgdVtfbWZ+VE8qzzsC3gGRJoav/woLg
         htHPNvklq55JcCvK+tVm3xuVDgIXmqPJEKRYYR6hcsyxLILhwNrPJBbnlIA7DEB+/9QN
         6xihzEbYMGq6xWXYePM3XCJNPeKhtcdCVBxEUz7JILWqJr3qCzbgAxMO4jxd2IDkUyRg
         8BOpE0aBL1SJtQbpr30z/Wckk08GKRWQL4aPNi09y8gxtutKpgzcM3wjPctmgEWstzuG
         cqZTeedKQYSXfFUyklaTzAg9KjQyvmO9nvbadOxSdC2orm8QxBh7SHUowx5vyI6231zh
         6TrQ==
X-Gm-Message-State: AOAM5318Zlrg3/BdWyyIrkYrwKZtE/WzpL2JvsI4P12wCce3juCICzEZ
        rRZzE7gI+keVqvGBtuN84CvDqNXY2up1UsM2
X-Google-Smtp-Source: ABdhPJwBlZodA5Bms0z0MyXWtaCvX/ICy4Nf36ISMC2rnIOR9Of3bb5h6DKAQ/5c/qar1ZB6RC6e8Q==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr5773452pjk.236.1630614136556;
        Thu, 02 Sep 2021 13:22:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i132sm3989122pgc.35.2021.09.02.13.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:22:16 -0700 (PDT)
Message-ID: <61313278.1c69fb81.ad81b.a249@mx.google.com>
Date:   Thu, 02 Sep 2021 13:22:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.13-114-gbeff94e284f7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 158 runs,
 2 regressions (v5.13.13-114-gbeff94e284f7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 158 runs, 2 regressions (v5.13.13-114-gbeff9=
4e284f7)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-114-gbeff94e284f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-114-gbeff94e284f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      beff94e284f735cfdd988c53018eab4207f1ab58 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6130fc12c041f1fa10d59683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-gbeff94e284f7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-gbeff94e284f7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6130fc12c041f1fa10d59=
684
        failing since 2 days (last pass: v5.13.13-73-g193ded4206f9, first f=
ail: v5.13.13-97-g4abdf2bb4e76) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6130fdcc0117054176d59669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-gbeff94e284f7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
114-gbeff94e284f7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6130fdcc0117054176d59=
66a
        failing since 35 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
