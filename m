Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC52098B6
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 05:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389558AbgFYDER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 23:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389549AbgFYDEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 23:04:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75998C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 20:04:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x8so1249618plm.10
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 20:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0eb1vf9W1DblKhnrISF4aagSHoTHzz3gygx2EVD/TPA=;
        b=bvn06zPdQ1QkOULnM1cI7bnO89QpAiEXEI/qa3N9lDQfYoNQ9uM56nh0H2SgUuA1Zn
         OYTyNuAPYnivBIhjsgVy0lvbrQTur2RUhCaKqI2ke2UMQXSJzuBus2TN2Jpeqo5Vh6ZK
         JhwOLedZVNmStEfpL4ajPc+3KaGmSe9Hd2/GtDwKTCmtwC84917HhAILSK2qVnjfDUzT
         n/po0qT/V/nSIu3jxpIVVOCHbK9y0pv9+8+4XaQpAbL+g4M7cQJQ8wrdLQY629UcMiCE
         sUI8y0Wsk4GuVsvwCHfx4eAT5TCD5ebq30m8f/FnKOyUuXUvl7CCyu66kFRjxD09bbAT
         0kpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0eb1vf9W1DblKhnrISF4aagSHoTHzz3gygx2EVD/TPA=;
        b=S1McIPN+XG8NILh/rgfnbV3XbbJVaQ0Ngs+yFZPmv6jSh8ZwbsOJ/q/SrIApt3hAGK
         bztiWbHmAc+FJQ8fUjPsWlpn626uWGaOeRb08jfZvIKS4fOycPqXmm2S96E6wjsWYvx1
         nndl+MHa7uBboGmSlOYE88dBuqoxfypypSCVb0H4t19eb74LQAsh4mqmy7von+PjwHLF
         mIy+NP6mIEVUfSKhdF5DsP7tN+3J5DFbgv89z/mDJen0qRXXPt1vum8XCsf3mEqrcHHF
         iFpfV+v7SJ2bKbQoZ7pmihlOiG8C8SmGyJnzTCWbRdfEmtVVSdBPtB71cWI1VtEqpobQ
         QXtg==
X-Gm-Message-State: AOAM533QJWGtda65p5zmvVa3bJ76tSJXQF4O7BBg27U8kD7gDSt9NDA4
        5SE6l1xHk2EZ3+PyqkwsneSOjKRmpyE=
X-Google-Smtp-Source: ABdhPJwM1N/dmGyiUY64KjwZCzWfQBlI8uR1RdXdHekuJFf3x0mjIgxWvCIsVXx97ZfGUS35mdD7lw==
X-Received: by 2002:a17:90a:de1:: with SMTP id 88mr992380pjv.124.1593054254502;
        Wed, 24 Jun 2020 20:04:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m129sm19956408pfm.206.2020.06.24.20.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 20:04:13 -0700 (PDT)
Message-ID: <5ef4142d.1c69fb81.bd830.c0b4@mx.google.com>
Date:   Wed, 24 Jun 2020 20:04:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.49
Subject: stable-rc/linux-5.4.y baseline: 76 runs, 1 regressions (v5.4.49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 76 runs, 1 regressions (v5.4.49)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e9688ad3d36e8f73c73e435f53da5ae1cd91a70 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef3dd68ae9c68275297bf09

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.49/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.49/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef3dd68ae9c6827=
5297bf0c
      failing since 0 day (last pass: v5.4.44-781-g065c1728d31a, first fail=
: v5.4.44-778-gf7f032930408)
      1 lines =20
