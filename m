Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE52A468D1E
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 20:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhLEUBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 15:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbhLEUBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 15:01:22 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F3BC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 11:57:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u11so5718535plf.3
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 11:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yzOpWj9P9Gc8fJhjA1FQfSGyhH9eRcNSOlBUEb3Emr0=;
        b=KOXusSKXv1PsDkhVpmH6C4zD31zOZlvn+tOpfTtIMk4CeeYBz/zIl9OhWC65Rho5Hn
         txoIoc6G4ZwUp7FCOlhcpmNZ+0CIfgv94lgxj6ULuaBNHDUq5RvBPwW0D/jFRDD/FVuo
         AQN/w4JcBE0CBlFqzcu2Ot13JmIoTMTbHmGEq07xAHdg5Uqd4VNx3FrOenokmAXPe688
         KI3F8P/E31bjZ4CIESQ2rc6OVNyscOCu5NtSesD5EoBXvVs5hpo7FDjxJqFZ3E4KIL9c
         oSv410F2R7smLGKhpgMo947HIXpwWjnsNJFbuoGs6XL4HsZN8Y8E6vHd5vq+4hK/yCjF
         2TJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yzOpWj9P9Gc8fJhjA1FQfSGyhH9eRcNSOlBUEb3Emr0=;
        b=KVJ0M/IjYQHv6EbYsGobyeyrZlVfiBl3Y15YEUIkz9VpjzUHn2POBWW97Sn2bm0euU
         zMw048x5BQcLScVnelOhXldXc1EZPtLNRjHvailcMZDxfPnI+cGu8GPuCAjkuieLfnMz
         NpLN1gJkCtOe1OIY20OchJ6ewJrYTbqfymcWPSPILCwNiazca0txwvybEkn6hzFSXWI3
         nimc69krqFj3vHZudkSrZZcrIrgX4s2ExS45jn49qMgo2RrR8INkzWMGbqTQtFVt7mYV
         gUZi9abYchb0Xq966B84qzrKd9K64XN2zHHDTMKkt0M97U22Mf7A2gYGT6i1HirsCVVK
         E0Hw==
X-Gm-Message-State: AOAM530idvC3ifqMmnFAIMriIAX42XnVtzQSFJjH0kvCgXCK7XtkgP3B
        n9/Npgo0+T+skQA1lnqOkL31aS/X97+OQ54+
X-Google-Smtp-Source: ABdhPJxqFnVyHZiyVlq4SQNGs1t74eXt/e0Z5Xivrtku3KrWExUo1TpgK1D0xSQ4P1KFhkQM+Gh7Iw==
X-Received: by 2002:a17:903:1d2:b0:142:24f1:1213 with SMTP id e18-20020a17090301d200b0014224f11213mr39045005plh.81.1638734274291;
        Sun, 05 Dec 2021 11:57:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq14sm11256271pjb.54.2021.12.05.11.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 11:57:54 -0800 (PST)
Message-ID: <61ad19c2.1c69fb81.b01aa.05a4@mx.google.com>
Date:   Sun, 05 Dec 2021 11:57:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-97-ge5a48f2247a18
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 106 runs,
 1 regressions (v4.14.256-97-ge5a48f2247a18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 106 runs, 1 regressions (v4.14.256-97-ge5a=
48f2247a18)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.256-97-ge5a48f2247a18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.256-97-ge5a48f2247a18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e5a48f2247a18f0c2fb25141a9d19a6de2660d47 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61acdf543c526bdf5e1a94ad

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-97-ge5a48f2247a18/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56-97-ge5a48f2247a18/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61acdf543c526bd=
f5e1a94b0
        failing since 9 days (last pass: v4.14.255-251-gf86517f95e30b, firs=
t fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-05T15:48:18.498963  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-05T15:48:18.508602  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
