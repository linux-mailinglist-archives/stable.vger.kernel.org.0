Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6B14838BE
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 23:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiACWNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 17:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiACWNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 17:13:32 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73F0C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 14:13:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u16so25725421plg.9
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 14:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hIt0GFZoUD11tWYgErcOvKupADMGVCp5l5OepF+1Tsc=;
        b=BAQ0dMvL9IGVtJFomIiErmLjyiRTz0IlnRJL/5SQ1bT4kxbVbfAqTaU7tcLpGqVgWk
         US58YrRgD06fn20UO56VRwQUEHf15PjJOwE5ypx8EwWNNYN0FtfzpaC3XGwzyt5ZSOW0
         f78ebw+nW16jsQm9uW9Ye2DEv1shA4v6ZJ9USuOMef2ZNiJqVAQYQFDWm/gGaTL1Xp40
         v/8ZW1Dd8sWImeaUt9lVw83X+RpAEA9AEEvy8gu8T12aIpnGSj8vHtDuG3G/AIxQUumo
         LYFftbxRNFBQlZF+PgGVOpE6Eri68hyVijj4xj2rN5xA7dnWc8a25VsF+LIHl6o2pLTU
         thdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hIt0GFZoUD11tWYgErcOvKupADMGVCp5l5OepF+1Tsc=;
        b=0YMDM8DPHoNR3mnNQcsr2b0ZBOF9Auf4AcLHIRqyYpEtJkX9fxyFSKdTLGmlEptCvA
         ae3XpESrUdMDYSwwbjnHW/WVP+1ldLUKESZbynZeLwD+vQGgNABB3UFeSAtY/7cjklzj
         A28Ca4IQv0jdcrfspsB2cTEIAUbg1xQ1xriwhFwpjf1/4odBw1IC7FO9hmXvtP3zRLOJ
         FOq10iiy4ibiX5Qds+FQhcj6a+HgCh6um08Swf7YJh7i0RkdI25jh64pPF69ssQR+ikp
         9wqbi9ixculrMxkzZTRiCF0U65JM7Fx4CW6i6HOgML6NeWHTjHhqKkLG70WkXi2E9H7/
         pqRw==
X-Gm-Message-State: AOAM533b4AcVvXHRKFGn8ljfhz3jQuh4GUt2y34jTWJjDM6NWuAdL3tx
        2yk/5j8KYt9xTI1YMYgzD3WKo3fKyBHaIVqx
X-Google-Smtp-Source: ABdhPJzuAAnTI1C1jyiFDT3EWDcc0C0n2xsspvDqM9unUYNTkv6HtBbr+rWY6CFDADoSqfrTB5OKag==
X-Received: by 2002:a17:90a:e517:: with SMTP id t23mr57020401pjy.49.1641248011185;
        Mon, 03 Jan 2022 14:13:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm41756381pfv.192.2022.01.03.14.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 14:13:30 -0800 (PST)
Message-ID: <61d3750a.1c69fb81.a7839.db39@mx.google.com>
Date:   Mon, 03 Jan 2022 14:13:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.223-28-g3285af6cecfc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 144 runs,
 1 regressions (v4.19.223-28-g3285af6cecfc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 144 runs, 1 regressions (v4.19.223-28-g328=
5af6cecfc)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.223-28-g3285af6cecfc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.223-28-g3285af6cecfc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3285af6cecfcf350536b55f95214b08192ff25f2 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61d341eb8d2e7d6254ef6752

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
23-28-g3285af6cecfc/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
23-28-g3285af6cecfc/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d341eb8d2e7d6254ef6=
753
        new failure (last pass: v4.19.223-28-g8a19682a2687) =

 =20
