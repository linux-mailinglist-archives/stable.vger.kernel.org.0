Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD06317065
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 20:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhBJTkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 14:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhBJTjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 14:39:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ACFC0613D6
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:38:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cl8so1719566pjb.0
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 11:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R5ogvTV9BE1tzJYX2t3w2zKHnnrn3/vuYok0Hvd6lX0=;
        b=VeYGRi6bG2oitUrih6HLLG4f5FaU2gSdTKvKlIGpr5TRY0z1eeoBnPQQ0Tan6xsGmL
         j3YeNot1L+D57CaQUOX9ohuUYZapifscjskRRU3nLm/tA5Uia0mEEueblprZq2NiMaul
         okDX22yQFwgPLsjuDvDuJjoFP7Ue6t2gwhovW7brZSUfrpeKP7S5P+LRMBh2+PsiuYU+
         wU0ntJ82CwlPCIaC+y+pR7m6c+3Ie1oXsvRLiJxGoYTwt4Lq10w5YllrpxnyunRUNi1e
         iJ0P91e9je6pAtQcjsnQ6EnsVZbIOfKryF9KkX/nkHFG6PtmhwPVj7jQAVtb476ejrOl
         GOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R5ogvTV9BE1tzJYX2t3w2zKHnnrn3/vuYok0Hvd6lX0=;
        b=sLW81iqXFXEuczVVtkSN8J8ciQNnbgGb8robhVx+c7Y50dXAJfXLmDmZ6okp40rpiW
         xkAZ020+owlQ+EZ6iyhDNkPm/T3W7/a5pAI8ypprPeFeRusuH7Pa0C3bR/FZKSsjo2bI
         lGp5Y2T2D6oWznmci6NyEO9xPK8hIJsUv6TUh9rYuXQLmLTOby69XhIxIRMDcPlGKcn1
         Qg2C9WCXVwmWxlU9bnobqRpPgx/ZBCPV4+b3Jfx2NzsfisNsDMley/wk3pNWMIqCMMKI
         eZNmPQCLKstuAKco1HUMPmQ9km8VOda7k++ilLgstq6LyOeceF9/4z3yD9bFvkhhp1oD
         PM4w==
X-Gm-Message-State: AOAM530pBV18RFjfvqnDxK9j2991ecZj2Xl2AL3i1A5J18V8mR28I9Wp
        qBs1Guxu/LgqPsenxPJxzEXZupfmulb5xg==
X-Google-Smtp-Source: ABdhPJxnrlUpq0Oqg6aC+QkXz6W3pgN1TYi41ZR82EuFEzOToIArVdXFsS/SpE6pctNiZJI9cZKY3A==
X-Received: by 2002:a17:90a:2f82:: with SMTP id t2mr443721pjd.107.1612985902729;
        Wed, 10 Feb 2021 11:38:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h188sm3196839pfg.68.2021.02.10.11.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:38:22 -0800 (PST)
Message-ID: <6024362e.1c69fb81.5a35f.6e11@mx.google.com>
Date:   Wed, 10 Feb 2021 11:38:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 86 runs, 1 regressions (v4.19.175)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 86 runs, 1 regressions (v4.19.175)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.175/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.175
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      54354bc5e2a599518c25769b56d76eabe94e67c9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602403ffcd45d122cc3abe6d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.175/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.175/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60240400cd45d12=
2cc3abe74
        failing since 21 days (last pass: v4.19.168, first fail: v4.19.169)
        2 lines

    2021-02-10 16:04:11.306000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/111
    2021-02-10 16:04:11.315000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-10 16:04:11.329000+00:00  <8>[   22.782104] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
