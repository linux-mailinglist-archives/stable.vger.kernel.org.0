Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32861FDA1F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 02:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgFRAOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 20:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgFRAOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 20:14:14 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5934C06174E
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 17:14:12 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j4so1685754plk.3
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 17:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jLvgh5Jpa2WnJwLUYsz+RinHwc37tJ78KPwlQD0eE7Q=;
        b=xJVlG4ijmSVE4BIst8Icjkm1FekOXSXOtDEz4RTEaqiFwdIEjSl+T1BEKqn0w/F5TR
         gPWAUrsxdR/zd4/pVqtRnEsFe0uVNOpAau35sgZ8hStl/t+vSTYoEgEhQ4e2J9SZu3zL
         wKJHfxEgrcRjJAfglj02fwylh8vmdelqNTqsWAT0G1t391/aXMrfkh+HRyyxkyiBKVQ4
         TfDNVD9n1d9USUR7bXv82WfBvylSE3iWdfQvdVBquyQiXQKp5ta4yqBAM1l0dgdrMhrh
         ky0w2zPqSqM1FJxeaYoWz9jzlhZGQu8A24NIom82jeSdKdVhZWh+4JDcJZwTCTFtLOMC
         vzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jLvgh5Jpa2WnJwLUYsz+RinHwc37tJ78KPwlQD0eE7Q=;
        b=gOaFZYNwIhrG4g1Zb2Q7MCm/oEynBw+6R8Uo4pEi9nTiL4/oALazf8nsmoHfWfuyd3
         TbCHouLDu2NTRLGz/F7w5eOeADMDe0evohhiayRe+BLzj2qofgzEJlN1mHqWAp/xAeM9
         qgpnSbiWPilTHf753YhZc9cl3fcz7boVB/W+IWJhDGx9mg2UW0gRXENKkairrc9XK6xa
         GugE/F2uSKkAWm2TjauZIVd/Q5OByecN3+5Fkj0v2ze5nJAeuugtdlINhFNGmHKdzb6F
         E1rM1sLwApROAT7f/n99N8aXHhz61MA9iuCAnR9MOFu1KEOnaschz+FTgedxexWCc29B
         H5sA==
X-Gm-Message-State: AOAM530u1+fmEE4J4m5SdrD3o9jgm+YhT6EOtP1E77Eoc6KcqgT5jDas
        kcHxMw8pMWagCd58OL35Wr7fpQhuAZA=
X-Google-Smtp-Source: ABdhPJxHSCHHG2S9JpGku/YXDjP1eTYIgG6/aaGgCkC2U0+yqfBoSv4d+7VJ3MbQ2sMh+dA1Nk728w==
X-Received: by 2002:a17:90a:32ee:: with SMTP id l101mr1604539pjb.213.1592439251717;
        Wed, 17 Jun 2020 17:14:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w12sm896484pfn.68.2020.06.17.17.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 17:14:10 -0700 (PDT)
Message-ID: <5eeab1d2.1c69fb81.89d8.4506@mx.google.com>
Date:   Wed, 17 Jun 2020 17:14:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.19
Subject: stable/linux-5.6.y baseline: 43 runs, 1 regressions (v5.6.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y baseline: 43 runs, 1 regressions (v5.6.19)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.6.y/kernel/=
v5.6.19/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.6.y
  Describe: v5.6.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      61aba373f5708f2aebc3f72078e51949a068aa6f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5eea7fce9eaf8b0b6497bf27

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.6.y/v5.6.19/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.6.y/v5.6.19/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5eea7fce9eaf8b0b=
6497bf2a
      failing since 6 days (last pass: v5.6.17, first fail: v5.6.18)
      3 lines =20
