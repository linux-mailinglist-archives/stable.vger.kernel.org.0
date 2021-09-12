Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701B5407DBC
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 16:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhILOLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 10:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhILOLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 10:11:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14171C061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 07:10:37 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e7so6856055pgk.2
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 07:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J+rKw8y7SmYzy2EYYgck3roiC2cmgIvmyuzJgRzIUWY=;
        b=Dxj+iywA2wcCrVCPNb8nP1sWk11J+PAHEUOj1RG2Qt4tN4N8eTIKqYGBT4aQgEj44W
         Ndf9qGBwzdLXEudgSaGs21lI6cA5tyKpAVHbwcKWnnmP+7dOvfs3u1snFSEOf86rhUDs
         Sv3gYKTJB6LlMcxYX1qso1QmfoRpk1rVrRcUcPzGzw21BS+eFpaUnHG6oevyZK73NTrw
         UjsCDObwOG/nPPdMZLP6R5AzPsyMXj7WMxDlQD8pXlHUiYD/9P27pNoFQI7P354Tb9b8
         sL4PvDR01+k8LF/wVG7RqRm4gr0K5Gu8n74u4L0KTWWkr/+7yZpumQD9t+CR2cMKIJZR
         gPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J+rKw8y7SmYzy2EYYgck3roiC2cmgIvmyuzJgRzIUWY=;
        b=UxCstn+y3a32HRTL0QYp4+b8O7CX/RQPIrCaSnUVd6jgxl/VAfVaaTt9Gy39Wlfq0e
         AK7bhy1prjtzkCRW9fvELgbeGKEPH7kIxyTIUXx5ysAaxvnRBhteb6VCO2/6Q+Nd3+XW
         yr2/DlKU+AOg695rIsuryqNwpZN1OzKfoBjTUbe0tUw1L+ZoE2Ppp0h/S29kzMfa2/b6
         Z2hWleIPCToo9jHvE2BcgftS9bE2DWoHhU5pQ64uvYzzLdhVeoQTUYEkpAwKY5sMaZcz
         lpGVjPAyvmJPIHlgmWALrqYZIil6lWmwZRdad6kfzfKT4jCtyb8docHZAfckH3/IBP+J
         n1AQ==
X-Gm-Message-State: AOAM530RKPMoucjf+F0pv1LOtteNV3RoUTyeNkdqyiZ0bmRkuKxdN4SG
        ThwryIdyK+P0VH/kIYc7qJLuv58dQ0mDEtFF
X-Google-Smtp-Source: ABdhPJzgVURc90/OHjnpQStrq3kc+VUyTkgocw35UsiUZwyzq4oeI39St0GpU30BMs7gENYX8lqVZQ==
X-Received: by 2002:a62:1c0f:0:b0:40a:5b7b:76b3 with SMTP id c15-20020a621c0f000000b0040a5b7b76b3mr6670027pfc.5.1631455835656;
        Sun, 12 Sep 2021 07:10:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm5122747pgl.90.2021.09.12.07.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 07:10:35 -0700 (PDT)
Message-ID: <613e0a5b.1c69fb81.cec9c.d542@mx.google.com>
Date:   Sun, 12 Sep 2021 07:10:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.15-22-gd9f9fc203cf9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 218 runs,
 1 regressions (v5.13.15-22-gd9f9fc203cf9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 218 runs, 1 regressions (v5.13.15-22-gd9f9fc=
203cf9)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.15-22-gd9f9fc203cf9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.15-22-gd9f9fc203cf9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9f9fc203cf97139bc204b10959199e55f40f5ed =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/613dd7909821d90917d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-gd9f9fc203cf9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.15-=
22-gd9f9fc203cf9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dd7909821d90917d59=
666
        failing since 2 days (last pass: v5.13.15-4-g89710d87b229, first fa=
il: v5.13.15-6-gd33967f7a055) =

 =20
