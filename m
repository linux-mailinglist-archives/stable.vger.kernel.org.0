Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276ED2048E5
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 06:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgFWE5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 00:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728155AbgFWE5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 00:57:51 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAC1C061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 21:57:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d12so2619124ply.1
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 21:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1GoJ/xuwfK1wEFq8HieIUsxeHvAqgcuD+UkJ9JeSgYw=;
        b=QJv6nEmnpygnbJ3oZxfEXCzdX8085FPqMWUv7a34mjENaTxyNjmFkHaJ/DgxORzJ2Z
         wphaE0eoZwqBykBBQavSwezFhvDxAbgpRpsEdtgz1z9rCargdaGVH/XLFRTT8GlWhmvM
         46jEczoKTdwmHpwGicssUz5Xd/dBaXpJQNFZAoHpQvWhmOrJlvriVPz6aZZ05tnzYrXG
         KKwG4dZ5GOlm7VlmC9FX9mgygU319oiID9WSCjCvEdbtTf1e30W4voFdbD0A2M7VHEAV
         fiuK79IAJ20CVmCH6Xl4h/r+FEG5hf+ioz8s23WmV+bcDwe0OAmQphTOlPZeKBFdsjkC
         13qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1GoJ/xuwfK1wEFq8HieIUsxeHvAqgcuD+UkJ9JeSgYw=;
        b=JZKh3GVersZuSc/nmN5oniDvKo94ciiURe6qQZ20b4tyblfQwqIqCLa90nj1FTpXwI
         fzndTkgADzy4LDquZEEFXrsVjEPUOasfnjolqebGJeaxxW215ayAA3SouaDHCbTStcgV
         jVt5kJlFLqGK+9rRU/HMCKmJ1RbwjEUfnYHDOy/nkSku6YNgsGQBIUsqCYiGKogHeQ4f
         hxLqfLyP9b/BvkfIe73gDY5agyWv9P1JnUiGX4btqt8weVFtiP58+AKSSTO2wpJohAqr
         SFp1rFpwF3TB4608XH9vAUF0rZg2oX3mmlelX5Ez/iEb1wpP99xscHCD4s7U8aHOsoE+
         Ohxg==
X-Gm-Message-State: AOAM531BpyXqJFL1B3dGuM+FVFr9WTRyjqlHuKkk33Rhc1bwaq6UxH4J
        iaurJD3YTeY1ptMTvVLT6lznni7xMoU=
X-Google-Smtp-Source: ABdhPJxJBabmnMvgkfv/wm1//GR/8Bf/3XgTPwwEeMFUkig7YE5gPPrGIhiOQSqoEIz5vmPr8baBBA==
X-Received: by 2002:a17:902:b411:: with SMTP id x17mr21468061plr.272.1592888270618;
        Mon, 22 Jun 2020 21:57:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d9sm12596736pgg.74.2020.06.22.21.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 21:57:49 -0700 (PDT)
Message-ID: <5ef18bcd.1c69fb81.ca14d.6648@mx.google.com>
Date:   Mon, 22 Jun 2020 21:57:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.226-205-g47365a65ad5f
Subject: stable-rc/linux-4.4.y baseline: 47 runs,
 2 regressions (v4.4.226-205-g47365a65ad5f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 47 runs, 2 regressions (v4.4.226-205-g47365=
a65ad5f)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2/=
5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.226-205-g47365a65ad5f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.226-205-g47365a65ad5f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47365a65ad5f836ddf0ef75701b34fa76f2d91e0 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2/=
5    =


  Details:     https://kernelci.org/test/plan/id/5ef1558bd6c6dd782997bf0c

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-205-g47365a65ad5f/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.226=
-205-g47365a65ad5f/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap=
3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef1558bd6c6dd78=
2997bf0f
      new failure (last pass: v4.4.226-127-ga9634103dba4)
      1 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ef1=
558bd6c6dd782997bf11
      new failure (last pass: v4.4.226-127-ga9634103dba4)
      28 lines =20
