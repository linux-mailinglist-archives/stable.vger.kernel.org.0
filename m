Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B6735C92B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 16:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhDLOur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 10:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbhDLOur (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 10:50:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E1C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 07:50:29 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id z16so9568736pga.1
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 07:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+06TzuVPTP6ExaT23SBeFLN5M7K8qFBZdAr3yR1w8jQ=;
        b=FHbE3jowu0lnKfN8xZES/AklWNy0Ki5+swLu73/wNHxtpxUw4gCNJTNWP6/OYKQWUZ
         63/ParnNF9i3AN3x6gdoEKLZRil0/c5UJ2O7BVLOoS4djcrUUDhno/tjQLmyJ6ZUa9HY
         61zadQ5BPmSpniPv1NSHj0ruyxmBWKbccc34zaksMig83KHz+a1alFcA6Ks0XrX8xq+9
         GAcQAxanzvUGGO8pvxNgbuFTanWhJIPPBOnEa+fyOQD8Sg2f2iiSONsfKnnDEeQKG3D6
         nhyFj1BvPN98h5qYGIizg5o3xI9/YWuMegGH+/HjGQH/8MbTycMcWQek/pKCWimcNXWz
         U4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+06TzuVPTP6ExaT23SBeFLN5M7K8qFBZdAr3yR1w8jQ=;
        b=f7q26hHmftIZs+/mS54Z5GFZbyU7eitT5x1lWL34YiWwyjQV9N7e58s9ovUg4E5Vrk
         YOOdBUHDZBpStORzT60RwuZLi5Ad7ogh4Llq59Fujs1sZr262ekH1SBncJHZqStFX8vU
         NWmoRMWuTqXkuO9z4mU6MiuZtX4Vo2PsB++9KhRWNo5LzIiPARmiodQ2WUP+NmoWjioI
         hZ7iETlMgWXk+1YWnOVxmS6SdewcLkZqWbMFTgNIqZ0TUZsuq+kqzWVlGr2/SJ/AgsJk
         BUWsNvjE8YfBCU5w40b6iTCjO0Scb+IQW3CKsBLdG5ZoCKx+IZJFHyMzs8qtmt9oebHR
         ke5g==
X-Gm-Message-State: AOAM530yGihA/F8s/GxElHyUh4ocPQO7KL0253ijIjvFsWgc3mBD/8mw
        N4EAkQorKmhMjelfYR60A68pzmn7e2cM4WOO
X-Google-Smtp-Source: ABdhPJzGrfJEDEtwB57F9E2d/F2/tAoJtr9JZbZF58GvvylU0WOmnnm0ZweBDA6xajDm0DHhNU8Tug==
X-Received: by 2002:a63:c48:: with SMTP id 8mr26911620pgm.74.1618239028955;
        Mon, 12 Apr 2021 07:50:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l25sm12701865pgu.72.2021.04.12.07.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 07:50:28 -0700 (PDT)
Message-ID: <60745e34.1c69fb81.4248.e2e0@mx.google.com>
Date:   Mon, 12 Apr 2021 07:50:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29-188-g7271ea473bcc4
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 137 runs,
 1 regressions (v5.10.29-188-g7271ea473bcc4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 137 runs, 1 regressions (v5.10.29-188-g7271e=
a473bcc4)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.29-188-g7271ea473bcc4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.29-188-g7271ea473bcc4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7271ea473bcc48fd26124f02fba613fa7fa51004 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60742814f7e9d8363edac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
188-g7271ea473bcc4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.29-=
188-g7271ea473bcc4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60742814f7e9d8363edac=
6cc
        failing since 0 day (last pass: v5.10.29-90-g9311ebab1b30e, first f=
ail: v5.10.29-93-g05a9d4973d3b9) =

 =20
