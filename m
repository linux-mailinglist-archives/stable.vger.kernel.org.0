Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD927B909
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgI2Atq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 20:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgI2Atq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 20:49:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537C7C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 17:49:46 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x22so2810829pfo.12
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 17:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fXZXR4czHhfXu1Dp3QTjxYYlfwkdTuByjjFRcdpcGcg=;
        b=PgT7v9WlV0DRyqJUql6iXKdYlzOemwY54G0oizg/E8Eug3ck6/fvx6cxKHvcmRbPXX
         L9XXJBYHf+jiq4Sa1KUyDOJXwSHiF3BA1noy24fMzOiXU0tNVMMt+6Q0UNx1RlealwRc
         M//ofU4Ic76CFOch8pfgfGE7HjPO1eBKP/YD0PKEUi8PcpYCkRtukHi3WUuoyDJFi9pR
         Kcw9pCNYELhPLkkOZjcYZe8+HFI6qXLkt2H2ncbcqtFqVe3kzVtKdCUrTkk+vgnbaXHE
         dRjocJy60yj3+WTLaZ9WPiKaQDieBAXrxZIcsW0ng/t0+nHKa2wD4jltHV6cB9ehG5Xv
         LWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fXZXR4czHhfXu1Dp3QTjxYYlfwkdTuByjjFRcdpcGcg=;
        b=nMLnudkwhUY5p/YDBh1lH40Jw3/FLBNa/6dX3a0c6YYbqsMHVLHct3qQGcvzSykUsC
         4UMHeUAxijzgqEpqslqFl425cXoijzPwEWhFybnqBobSW/t3FDCzhBTmnhgsxBkni0Qb
         kwEbhlsZC+kzr92csTbT8FBpXFzDcxmEAj2vIy3wVzyW5lo5/Pcd58P0KlopE4PYRJiJ
         J1wX9n1m9RkDMu5HPCBuBPiyl6c53TQ//c2Zui6wvEbsnOeikjxADyiWGwrKe2hImcMC
         vD8q6lQ2BcjVAMGU78vHnkgnFzHnVlna/RIK5ZFpU3o+f2VN+cVQuedPqtgogCbOl0xa
         lzDQ==
X-Gm-Message-State: AOAM531TYgf8OH0dgjWa/ACYIq9qSeKLS4ghOQX4LrUDi0jsg447n8lf
        iNe1SL0b80JHR3IoWtxhBUbs2guBmY/zDA==
X-Google-Smtp-Source: ABdhPJzAjeXnC6BcO40dv8SxBdLzwXOjJbvkQXFD2hQ5ZN+Yi9wqbxCL9yalVbiuUSS2hgPXI//zlA==
X-Received: by 2002:a63:a51d:: with SMTP id n29mr1223542pgf.249.1601340584810;
        Mon, 28 Sep 2020 17:49:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10sm2627998pjf.34.2020.09.28.17.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 17:49:44 -0700 (PDT)
Message-ID: <5f7284a8.1c69fb81.8367c.560c@mx.google.com>
Date:   Mon, 28 Sep 2020 17:49:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.237-84-gd4533552bc4d
Subject: stable-rc/linux-4.4.y baseline: 57 runs,
 1 regressions (v4.4.237-84-gd4533552bc4d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 57 runs, 1 regressions (v4.4.237-84-gd45335=
52bc4d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.237-84-gd4533552bc4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.237-84-gd4533552bc4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4533552bc4d4649cdf05bfa6b431bb5d08b810b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f724d0d0aefdc3f80bf9db7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.237=
-84-gd4533552bc4d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.237=
-84-gd4533552bc4d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f724d0d0aefdc3=
f80bf9dbe
      new failure (last pass: v4.4.237)
      2 lines  =20
