Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D8C319459
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 21:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhBKUW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 15:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhBKUWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 15:22:06 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4BDC061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 12:21:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cl8so4082101pjb.0
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 12:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vxKoLAkdgeafYd+w+2q0L/wLgczQx+6bMrUVl2Rh3CU=;
        b=GX37vi/1kACrDNF0Xv89BWUM/S1QcksrYchcxIbvC1nmkjLjl32/1GLc0IccJlXE6N
         NNMCk3TYU1pYcrqabhQX/vOd7Of38+GdHUEzy7ncloZ3Li4evYjvXXIsHkdjiObYCY3T
         cM5MrU9Ixv5TtcF8PTe1jAx4/9g7VrNZF+Qp01gFH22NLvQGg+YVzXuoXWaYV6TnmNoD
         3pZUdguP6qP+xiL0wo0y4Sf1nnB12q/1EKUAkzSDMmJ9ZertuvRJNwAvDYypSX4F3t15
         LHQjz66WeYlhsAVjj9kzmF4vuI0j14OaQ3Pn3C/x61WTg2QAmQnNIgU26mxkXe1EX6zE
         XplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vxKoLAkdgeafYd+w+2q0L/wLgczQx+6bMrUVl2Rh3CU=;
        b=breSQD5ZOtwi0WX61lfLLR4Ei/7Y15knxaVv1LvGbcUgIyZ5D4DyDiBI8OmYXJlJmj
         LpHeA2RWqOGkf/9+xctfOifMNLDzQDoNxCoNzUHBdq66CgRT6n69FLDdy3vlHm8gvPhZ
         2QHQxDD2eFSRjRPpiAo5A2PSK88MEKyPg3nf9xznPWOBNeO1qnfnKslaPilo0sTkhJ15
         oCzjsyePZ7+GNV4/Z5uz/QmQxAbbs0JjUtY9dtB1GPyi0hdzYpzUWD61zcPsoh/A6eRx
         uPBu/zy+EZ3dNYhX+4UoEZhzcfv0WYTlC0IIGHCk3gJyap2SKosBWHH5aD1d/zopbyqD
         w7Sg==
X-Gm-Message-State: AOAM532fOmklyKQ2X/ie5BNl18fZQYn+2kA9evY7+anusczpSwJwgH83
        kreniBpByEAC6/T2nCIKLUpctr0Yim1TWA==
X-Google-Smtp-Source: ABdhPJz4Kvahl/wAcFpe/wkP9pIAg5oYKSF8lzqTkMNcl8cFzzB8iebb5dg7l0NJr9Z7bwhw9C0Irg==
X-Received: by 2002:a17:902:c602:b029:e2:8422:ffbb with SMTP id r2-20020a170902c602b02900e28422ffbbmr9231939plr.49.1613074885241;
        Thu, 11 Feb 2021 12:21:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w11sm6567348pge.28.2021.02.11.12.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:21:24 -0800 (PST)
Message-ID: <602591c4.1c69fb81.ed369.eb2e@mx.google.com>
Date:   Thu, 11 Feb 2021 12:21:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257-13-g6868114108438
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 34 runs,
 1 regressions (v4.4.257-13-g6868114108438)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 34 runs, 1 regressions (v4.4.257-13-g686811=
4108438)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.257-13-g6868114108438/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.257-13-g6868114108438
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      68681141084387f3348c5d97f28aa895673292df =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602560260bfa19c7db3abe7c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.257=
-13-g6868114108438/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.257=
-13-g6868114108438/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602560270bfa19c=
7db3abe83
        failing since 2 days (last pass: v4.4.256, first fail: v4.4.256-39-=
g1a954f75c0ee3)
        2 lines

    2021-02-11 16:49:36.165000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
