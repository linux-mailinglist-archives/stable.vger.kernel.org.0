Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF6C462B05
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 04:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbhK3D1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 22:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbhK3D1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 22:27:04 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB678C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:23:45 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id f125so4968562pgc.0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 19:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iSbD5sm/aENuJMgPhczyZIKjThIojqN9mZ5j5fbJU3o=;
        b=rIIZKMfn1+W4nf4klV/ZSZuQQURExhPcRj4inI7u65aNQVUjc8eYrCEqBxdWnNT5vr
         g8lhcgrvd6LbOPjSCk/OlDtNtcQyUHBeLQopY8YRJsRtCI/AZwPBU5vHevv836gFuKdN
         GaVEtXpX6CVPAgBhXXLTMQu/eFsSs1QhSi80b5/VqvpvTjWIo2CR9nYGWmv/PIZRHMoq
         e6n7cuc6JG3rWsyeLTIDBHOYZAPHB170wGZvIHHaB20+aDPFEzkaUexLDzWqF1SUQHVs
         /fx92EyXZ1Y85DThbmNkNvj7wuOEmEm2VdScu3aGjhxywlej7YM4RzthXeGIfr6/aV0B
         eBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iSbD5sm/aENuJMgPhczyZIKjThIojqN9mZ5j5fbJU3o=;
        b=pjk0J9aY1dIfP1q0ciM6WuRFdr42EiF9l4L49x+3iGWHoFBSYvTe/srNOksLkA49FC
         /mBU2v6WrUEWKN4k4BF3jrZLaaHSCNm+DQ45q6UG3JITRfzRND1RrLyjz16poWTtCKSk
         Uba8aGjmEHObaNwMGy+2YpnGj+Z4RsBxipiPVEKtYIJf/y2aReh5agc4T1v5K4iksJDa
         gzDYPaXV/cAhT2JXQssbN2HW5kyqEsgMT3qGpAElE/qeew0wJCPBwz4Zs9cK79uTWtIP
         yvBiQ2rBM9xR655Zt9LxuXTBgvziDxM+3wt3p3qMBPgoiKZPaJBCul2Y1W9tUXxYbNFP
         l+wQ==
X-Gm-Message-State: AOAM532vxIvofnfpFvqCJqsVErJ4+SV/w+jOor/YRmK+hBMGwndq5xqZ
        LpJLJIKMdNBCQuoR164GAYFtZdz2LRRWsHSj
X-Google-Smtp-Source: ABdhPJxudXE9s2xQp+Oa8asIHJFae+iirS6RkrchTQVCsKDnkMXVoLz8RcDklVubCwZzaKnB5yVRtg==
X-Received: by 2002:a63:b515:: with SMTP id y21mr24340230pge.615.1638242625208;
        Mon, 29 Nov 2021 19:23:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q9sm20325331pfj.114.2021.11.29.19.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 19:23:44 -0800 (PST)
Message-ID: <61a59940.1c69fb81.a11d4.671b@mx.google.com>
Date:   Mon, 29 Nov 2021 19:23:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-70-g9697017144726
Subject: stable-rc/linux-4.19.y baseline: 122 runs,
 1 regressions (v4.19.218-70-g9697017144726)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 122 runs, 1 regressions (v4.19.218-70-g969=
7017144726)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.218-70-g9697017144726/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.218-70-g9697017144726
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9697017144726ee73f348d6bb4c549151f92320a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a564861cde547c9b18f6dd

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18-70-g9697017144726/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
18-70-g9697017144726/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a564861cde547=
c9b18f6e3
        failing since 3 days (last pass: v4.19.217-321-g616d1abb62383, firs=
t fail: v4.19.218)
        2 lines

    2021-11-29T23:38:30.230998  <8>[   21.405700] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T23:38:30.275382  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-29T23:38:30.284832  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
