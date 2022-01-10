Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179E3489C6C
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 16:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiAJPmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 10:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiAJPmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 10:42:11 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CFEC061751
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 07:42:11 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id l8so10175655plt.6
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 07:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hVKI9Lh2uckPXXTqycT8D+71uXeggG+jPIlm+iB8mNw=;
        b=nlzjGlo52p1eBu92BtshIifJqb/ElhNRbN6WLj8hjUQmLANgqiJ1zvPy1zT5I27VQt
         bzNvoHhZO60N0AdcTCHcgw2d9ojqyJmaH9mpgOB721yxn/m0hvFGvMQ6a1jTpCVLfBR3
         qbhQUB9AizQBDbK0W6iZvWzwVvJ5SKdVwxeQ02HTvD8R64EoFC3iZ5sKSyckg5nsl6Su
         kiKyrkx5lJZnnfWcxrGGIsKRajp4P/gKyThGJuBxjE/JYDRBx49wQDmopy2YbILelCSM
         iM4SH0sJjd6X/C/TlISVCb8tY1fv1+vsQFlxXXb/5sbC3Zjg8b2obZYeASnpL/pVHEU4
         vr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hVKI9Lh2uckPXXTqycT8D+71uXeggG+jPIlm+iB8mNw=;
        b=L+JzQTd18UMsjMhY13NYRdr9JpppioFKAm/RMcU8uctQsHF9zX7AXxdoYq0Zt+R5gE
         iIck4F+RCUAgxQZlGwc7U+u7RJn3aFzWoxuOVfFD5ijyzWKBwZYPlvRbR01jTqqrc83G
         GldarNbUh8f0YjhRPQUUv+8mUv1EvTbQpqp9gIrlecHkxsi9T8OoMnckeTPBhic8Qiju
         0QMOYI44VT8qh8MSnbRXu0UlPfSkMLP+y+ZFJCEX39roY1c9ZuE0fBWhccL+4gh5U6VR
         ksp4ccpDUN8aRDUY866EWg/co95zknkctPq1uFEnVo7LWZaKvPt5LIbTNt/Co61xbJPP
         nXkA==
X-Gm-Message-State: AOAM530ZbfOufu1hy8PWzv34AoNpccD6TBL342atN3aGFXvMBe7G+++L
        uoOKjM7zO7I6ctLsY7UAxO7GqoughcFvnSXm
X-Google-Smtp-Source: ABdhPJzhv5ZiTgB9ayuRTOgmAdKm9up+ci8PMJl7DTiXRhixCJT6tp3O3oTj9CCETj4auqLNm3gPIg==
X-Received: by 2002:a17:902:a50a:b0:149:7aa8:37f6 with SMTP id s10-20020a170902a50a00b001497aa837f6mr32150plq.91.1641829331016;
        Mon, 10 Jan 2022 07:42:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm5943994pgq.63.2022.01.10.07.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 07:42:10 -0800 (PST)
Message-ID: <61dc53d2.1c69fb81.1a076.eb26@mx.google.com>
Date:   Mon, 10 Jan 2022 07:42:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.13-73-ge8d40b0a7738
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 146 runs,
 1 regressions (v5.15.13-73-ge8d40b0a7738)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 146 runs, 1 regressions (v5.15.13-73-ge8d4=
0b0a7738)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.13-73-ge8d40b0a7738/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.13-73-ge8d40b0a7738
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8d40b0a77381adfdcadb8307596341334c9e18d =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61dc210a130e690636ef6740

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
3-73-ge8d40b0a7738/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
3-73-ge8d40b0a7738/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dc210a130e690636ef6=
741
        new failure (last pass: v5.15.13) =

 =20
