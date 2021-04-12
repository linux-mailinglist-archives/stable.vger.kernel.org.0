Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0513F35B7CE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 02:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhDLAri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 20:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDLAri (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 20:47:38 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC88FC061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 17:47:19 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so8108386pfn.6
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 17:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kQ9Am1Cw4tzrcu51Q89ztAJUkD2tobsczuFJBCmTThA=;
        b=LUoSj3WKgn3GwzUPBZOLstfp1SqQ/m6N/NMXXP7PSaFi8tG1Ua/GQJgTqGFkGp80Bq
         j76PTqPmbblWNZVrAstFbT85Pdnrc9jLybwrF52GBn2YAR9X9fGJoCHBrba2iVPKJYWG
         OL+D+4C4rL88zUpNbq2zZa/aR3JE3fqpEd/PI45tCvtdBENN2PJY0ybIU8As4bBAMQUk
         IdFZ3P+MFP4YKiit+S6moLj/59HHbi9cGnAMRlnO4XuXcetNICf8N328ZBEel4x0QvcW
         9lyRNPukW0lRBCnop1qySHrXnvqZiiob0DzWNK77sUVXYPw7Js05FrJHWg41FMGpqhxW
         nYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kQ9Am1Cw4tzrcu51Q89ztAJUkD2tobsczuFJBCmTThA=;
        b=sBoYeo2Gpxe2KEuLWjk+28beiuDNUGLDce7dpk0qhJxqFerZi5RuDGwEj4ND3GrtQU
         XfSfqzvG6FwHlNSCk9kxAt4SGtFEIaZRdRJsrYazZS9LbcfXJMsIU8ZQMoM5j4GFkxbP
         d27+lmKIQaYMOZkaBfuU6Ur8u1EDfgPGeUPCKEw0hSKQ0DUNYtVw5vwu+KdAE9yxkxgg
         U1tvZ7/yrkBNZq8iDV6r2pSDWzZFBalErR3hw16iwcM1t3oODziV03W9Qsv0Q4b2Nm89
         8jp+2yMac/i74j5Jy8HydfTpbXgVJidnopcFWA5Kr1IPaw+7cv9RyubKD+87ldcIrLNf
         PYrw==
X-Gm-Message-State: AOAM530TcUfQd1ltwyJ4kXE6CDXidtTGtCMo2trRVakWfYWybAitaqKQ
        7fdg46VAkjDYLXMPV8nDsQZuoofcDWWzj+Bj
X-Google-Smtp-Source: ABdhPJyYCIrPf1C5ngyvFS5E9pREIcLoBxjBoaAbPuLOXf0DRRmIPW2HO1vuvMNi7h5uggqmgMrQkg==
X-Received: by 2002:a65:5585:: with SMTP id j5mr24122375pgs.316.1618188439246;
        Sun, 11 Apr 2021 17:47:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm9231201pgq.16.2021.04.11.17.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 17:47:18 -0700 (PDT)
Message-ID: <60739896.1c69fb81.35fed.6a06@mx.google.com>
Date:   Sun, 11 Apr 2021 17:47:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-93-g05a9d4973d3b9
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 177 runs,
 1 regressions (v5.10.29-93-g05a9d4973d3b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 177 runs, 1 regressions (v5.10.29-93-g05a9d4=
973d3b9)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.29-93-g05a9d4973d3b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.29-93-g05a9d4973d3b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      05a9d4973d3b94f4ac939c18a9347df875337cbe =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60736818c12fc1e9c2dac73e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
93-g05a9d4973d3b9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
93-g05a9d4973d3b9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60736818c12fc1e9c2dac=
73f
        new failure (last pass: v5.10.29-90-g9311ebab1b30e) =

 =20
