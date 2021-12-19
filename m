Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D46D479FD5
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 08:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhLSHyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 02:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhLSHyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 02:54:24 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2EDC061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 23:54:24 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id a23so6425611pgm.4
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 23:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p/R4ERgqX9UvVlCBXlJh98N7KWcU/Byys3d1Wem8ToI=;
        b=nTXtA/c42cZN+yC30qAtEM5OIHqdraZ4Eb12G2gd+z+hVpsdRxrBRXWYa+D3HYOctY
         FJN+V05uUznsx1ntP9wkNhxgbbly7zBX9xnKX0xit8k1humJ/Bkk9tZj+5DuX2g/N3XN
         yerJEUYLE0kEBbd7JfrO40/kJf8gIRNk4E1dPepx4V0XALUtHVozchdXkCTtsiVrCXNU
         PMDhgqR+RwPVsrRPw6d1PkoKSDj36JYkD9MswgfgoD/iDH4CyC7vCan8qovrxg/MEIVh
         0Nh50+Pf1e+Is1T2CDTkaG/aBilOBsxU4Gf9FT+OD9L06AqMqQ0p5GFPx5lwA2UVjFPl
         fJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p/R4ERgqX9UvVlCBXlJh98N7KWcU/Byys3d1Wem8ToI=;
        b=59nS3mqSDoccnwdlciKldU5jQH8m5X5GeGoLy2csq+W1lN29VKwrnMa60jG+bqi3b4
         ZVRKgKf5z2MeYM1zBDsxBsduJyVZG7tYXxN5eJ+hNmfseTldLi0Y4cEVpYuSW70GG69z
         9UCp3IgFM940q86TX1BmEzAqstB0+HTzHsWV6QlKTpS/rjHdsTID219OloVuA80vtRFG
         F0AGuIeM52ed/GDpXc9NLUvs95owtAYpOOfJ6QXOA4EzZHfTwk18ZUCoJHH73VGn5SMj
         0B6d8gr+aW5ON8TrjuxybQ+lc1KU9EaG0G/RTia68IUKOzDkRYxwW68PxTrhT3T+K/Ev
         gdqA==
X-Gm-Message-State: AOAM532HRkxvbrmZePx/Mkx44FH0rU1pOqCQbi1bLFoSgG8cE2qf//QK
        zV+ytxa78nzEwCtrNZV2L5XvFuTmRra0ppi5
X-Google-Smtp-Source: ABdhPJxTbNPrQxsmDqgn7q700+FwKRFFskOXiRnqgd4x+9IUIDQKt6gSsXK8lh9kYumdx21lHxflcw==
X-Received: by 2002:a63:6d4f:: with SMTP id i76mr9890114pgc.611.1639900463667;
        Sat, 18 Dec 2021 23:54:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kb1sm4846902pjb.45.2021.12.18.23.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 23:54:23 -0800 (PST)
Message-ID: <61bee52f.1c69fb81.8a5fd.da37@mx.google.com>
Date:   Sat, 18 Dec 2021 23:54:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.10-112-g7598a4f34463
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 200 runs,
 1 regressions (v5.15.10-112-g7598a4f34463)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 200 runs, 1 regressions (v5.15.10-112-g7598a=
4f34463)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.10-112-g7598a4f34463/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.10-112-g7598a4f34463
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7598a4f34463cd9e4ab006ba1c69b50df5213108 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61beadad5b6be92bc139711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
112-g7598a4f34463/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.10-=
112-g7598a4f34463/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61beadad5b6be92bc1397=
11f
        failing since 1 day (last pass: v5.15.8-42-gadd3d697af60, first fai=
l: v5.15.8-42-g0a07fadfda6d) =

 =20
