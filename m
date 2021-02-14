Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FC931B06D
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 14:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBNNEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 08:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNNEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 08:04:06 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA365C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:03:25 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id e9so2293100pjj.0
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 05:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wIJ5TSasm0mquVGIkYgEfUyV/Di6srnQp+7R1DDdw7Q=;
        b=2Cl/PeBK6Vr41O9g/9osRAgvGmhtd/HwwCEXw3qw7hYT/1QCHwzmZe1s9VVU7s4Keh
         b/rJfJHZM5WVILmdDo7lRsOAn0nOkWBbM/cDwPjEEDzZIazHoiRWyKA1YQDga2D0M27u
         XOrA34jlmMsIjWPlr3zoP+KxD51pXSEQpp27hnUjNFhLGg36Oaz35i7O58eX1xdQ20th
         TeSUIKP72ce4kPHuSp8aka8qiVfzmyOr2W6CqxfKDvRTzpBFB6AD1V2GZYhWRhOqokL3
         QYr290Dq4cRJ0jLx86J8Gw8OOAsuaPe0O8KFoXIH6FiM3IlamvyI39NeK+KUGWGGsWrR
         efcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wIJ5TSasm0mquVGIkYgEfUyV/Di6srnQp+7R1DDdw7Q=;
        b=HWTh7eGdYeKgb/WakRNT55mYkYcfdNt4kazA2W/jq2YtmSIpuTLjxKChnGFBvYPRAT
         Mrf/z0rKxN8sVWM5fM+pqjZN30QaFXppwE3+VXCNl4iwBRt150zUt4WcsNfiHE9fFbzX
         s4yxEgPPmgy2UzgaBMkXpnz43j0HLjJ12fh8guWTRahRTt7klL5zx7yRkDAuuX3scyMA
         PyH6GbUoHGVNkoH4TsdiRNgZ1KPa1YPrV4E3b2PTeNdmiF9meOsiZubYpeIQq1KdOqnv
         PMEWfYgrBwElfCdsjmDzi+z7/jVV639+COszMh0H4Lv+WFO2y1e1bBUWJWT7gQft+7NF
         dn2w==
X-Gm-Message-State: AOAM533GLW6zoWcMtt4+s2ykJXNV8iQiSVZpEeBO80M8yCSk6NDhEnZt
        t4M70wiNqxYZHjP/dWtVj1h6BTTpoFqEpQ==
X-Google-Smtp-Source: ABdhPJwTlHJKg/8C9Nr3JVicaGxnsTV1DD5+UVu3gQLiYes9XImsuL2gWyD0ds0VQRGZ4JMLzaDWqg==
X-Received: by 2002:a17:902:8342:b029:e1:1465:4bf0 with SMTP id z2-20020a1709028342b02900e114654bf0mr10740472pln.76.1613307804980;
        Sun, 14 Feb 2021 05:03:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm16060372pgj.37.2021.02.14.05.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 05:03:24 -0800 (PST)
Message-ID: <60291f9c.1c69fb81.7562.2fd2@mx.google.com>
Date:   Sun, 14 Feb 2021 05:03:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-20-g80f4ccfc3128
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 44 runs,
 1 regressions (v4.9.257-20-g80f4ccfc3128)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 44 runs, 1 regressions (v4.9.257-20-g80f4ccfc=
3128)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-20-g80f4ccfc3128/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-20-g80f4ccfc3128
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      80f4ccfc3128b371121e40947b194518cf80ab59 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6028eea1849d2a38a33abe8c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-2=
0-g80f4ccfc3128/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-2=
0-g80f4ccfc3128/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6028eea1849d2a3=
8a33abe93
        failing since 2 days (last pass: v4.9.257-12-g43f72a47dfce5, first =
fail: v4.9.257-18-g5fd67f7a65f98)
        2 lines

    2021-02-14 09:34:21.377000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
