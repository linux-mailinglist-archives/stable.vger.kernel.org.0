Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E665A33A7A0
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 20:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhCNTSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 15:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhCNTSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 15:18:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D57C061574
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 12:18:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id e2so8972325pld.9
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 12:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cAjMCvHJxFmEjvwFJElLU2gV407ZGKr6BbZu9DROfDc=;
        b=lhDicp7x4Ng/f3nfqeidX8aPEbbbAvH/BzizpCURRbaCHBRxl97KbQmj1wH5xWEI2Y
         DwGhp9bj6/0E0Y6VMgRGBgtdP22oMuUY9SV+v2Lo2sjbK1VtctqZ/61+ToVUekyydsWj
         rH8CFV8QdADS9xNQC0TmUGHU3m/CSsI0z8lntFt14/N6vFT6GIdMTyam+JrpfEBxs9T4
         zJr3P8p/o3KD37BhDX3n1AwuQXSHiFb+6GgxhnV9C4nYgQgWsLIEUAvUsPtAEHXelS7P
         hbQMVeDWLBuU7veVG5r5EHdHzLwRqFtjMfhQLMb48r3rsDX1ObQ84LoCj+eoqQ8w+P/+
         bTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cAjMCvHJxFmEjvwFJElLU2gV407ZGKr6BbZu9DROfDc=;
        b=djEV9OO0yU33cZrM2KbKxlgdwPEOSP99qsEV1IUj3XtYN5eSkAYZ8f5bQnGl+oCaxs
         WtzV+SocYOT2IVkzKPyCnHawl3Rs1FmFrclR4Vdgci9qYZfYIY+Hmlfa5Vxz3AMrYImb
         BBrmiT1AOqlZOT7wNB6+F4YQqG1CBuIvRLBIPcAhLdEULxjtWbTu5z+ck4zS6bUtcwRI
         IzISMeRtH4fVs2lVM/N+9HvH6ImO3HbBflGIlbXFKBlmGV21Z5NC/JUW5ergtODQyi3z
         fp2M674RSgowJNrdn1MEyZz+FJA0mm223qeOem/bA/Sjh+Ltqo5y8Zvfz9mALXO8Y38q
         conw==
X-Gm-Message-State: AOAM533+VPNFqNuJLcN1UUqeQF4EyHV2Q3dpwsGJ5X4ykGdnmcjnr0q8
        IExr1VpHty72qLYEpgX4vdDuk42md6I7Ug==
X-Google-Smtp-Source: ABdhPJxdLPIb8DFfgHdNLQ+OEgQ1oJMasNjThYj24DwX3CxDBn/LoIrTM3MBfZDDNJR4Fwg5o0vHgg==
X-Received: by 2002:a17:90a:d507:: with SMTP id t7mr9206389pju.54.1615749520850;
        Sun, 14 Mar 2021 12:18:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s8sm7972223pjg.29.2021.03.14.12.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 12:18:40 -0700 (PDT)
Message-ID: <604e6190.1c69fb81.61148.2621@mx.google.com>
Date:   Sun, 14 Mar 2021 12:18:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-241-g9d497633439f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 179 runs,
 1 regressions (v5.10.23-241-g9d497633439f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 179 runs, 1 regressions (v5.10.23-241-g9d497=
633439f)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-241-g9d497633439f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-241-g9d497633439f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d497633439f3f87aebd5e6c69425edf8f74e172 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604e29071d583348c4addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
241-g9d497633439f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
241-g9d497633439f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604e29071d583348c4add=
cc6
        new failure (last pass: v5.10.23-132-gc2d4d7bec382e) =

 =20
