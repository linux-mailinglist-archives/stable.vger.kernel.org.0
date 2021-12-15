Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B594758BE
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 13:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242400AbhLOMV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 07:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242384AbhLOMV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 07:21:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2D2C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 04:21:28 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k4so16262463plx.8
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 04:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MG1RiR3DQGOtnrwyiftXNIkecVYzVowFOXgpWz2U/jA=;
        b=3b0NEfzm5yI0i5sC+In2Tp+lP91FSKwOFEL13CssYkeITOX5SvJWWtHwT7lbZibtUz
         xNHgx6GeIrIiP9EDmhxeqvniJqShEYoWuIp6mYbCt1xtN6EU3w1xHp26ckmQJoM8bRjm
         G1A245lmXGBGvUMJN8SDiOI3KyW97nYqPfpMZniV65VGdRn3HSw9NiFt/PQ9xBoVGXko
         ODBSAOFrSINrYSiLfT2ngElLkQe6xOoxkCpgiOaoYqs5T14IS/PfMF8siwaB1el8A/eX
         yrmiajxb67tjPqRfYL/88KbLGlkcNEsQcZPasCkDTZpUKhT8geDcuENM3bk6ObVx7zzI
         qmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MG1RiR3DQGOtnrwyiftXNIkecVYzVowFOXgpWz2U/jA=;
        b=3nTydvBWeBZOW66JY2FMC+s4GOuNsrZ2BsohTvLcOy3SV1eKVGPnmfB64KS6cWWm4Y
         CAS/OJhfm4d2J4tZRpFZarDSUcGloIcnydzW8S0gu1PJe4oqks2nZG37MBqJUtxKia78
         wIEySZqJsWV9s8XjMjTkld4PnqJwP0b225/Jl8YyE1FNM0YeqONv87rnwdByZUthwzQO
         ZtVIBd23a5z7CA825hpm+ab2XxrTcFKjt71hfPReOXXLXiChNVF2yIqbNb+KRnTbTltB
         zfalRI4ilaaZtEtTui438OU5kw5fYWrfqCW01vuDfhJl+1t0fz4H5qfzX4B7JjKZeDiG
         9UOQ==
X-Gm-Message-State: AOAM532kJXL8PgWFotKcfw6cL6Bf7MZei/a3/AUCFoMBllpxNOy5LO5g
        udYXGqhOmCyI0fyL4lY/fe3NXZ+dpnvMOuZJ
X-Google-Smtp-Source: ABdhPJz/8RT7hvOek4Xhazc33frTE+70zNbHIIQdpGcm+CCy/ZnrBNFIauXrPPXjuc6LLAxhwEwS6g==
X-Received: by 2002:a17:90b:38c1:: with SMTP id nn1mr11425032pjb.91.1639570887883;
        Wed, 15 Dec 2021 04:21:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm2750322pfh.82.2021.12.15.04.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 04:21:27 -0800 (PST)
Message-ID: <61b9ddc7.1c69fb81.a34b9.65b5@mx.google.com>
Date:   Wed, 15 Dec 2021 04:21:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-7-g93489bfff549
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 110 runs,
 1 regressions (v4.14.258-7-g93489bfff549)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 110 runs, 1 regressions (v4.14.258-7-g93489b=
fff549)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-7-g93489bfff549/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-7-g93489bfff549
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      93489bfff5495e498b3932e011b0221ff242e0b7 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61b9a662b9fba185e3397136

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-7-g93489bfff549/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-7-g93489bfff549/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b9a662b9fba18=
5e3397139
        failing since 1 day (last pass: v4.14.257-33-gcf9830f3ce18, first f=
ail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-15T08:24:48.380136  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-12-15T08:24:48.389438  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-15T08:24:48.405831  [   19.961425] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
