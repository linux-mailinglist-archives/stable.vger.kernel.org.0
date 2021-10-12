Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE41F429F0B
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 09:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhJLHzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 03:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbhJLHzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 03:55:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8108FC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 00:53:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so1274797pjc.3
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 00:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y8rwFVgpmbmz9iHq7Ty2VJHYqKNufP22ef728+lV9Xw=;
        b=Ye5KMAiCZ9p5m5sFhK9rEyICBA1ZncrYnKAnluotvf1fzSLztIEkrq82Q8WTFkOU12
         UtFQHyty6Qz3sextoE7GQin28EzUGtjo0dWC05spjXBrWrnsPsnRK1Uw6cMB3o4rM/g2
         eD/OAkC0I6/hK6e1Tk2zodYmg8dIzvz0K4KoTKuVeOs6WawrPg6JfLZDDafZNaik34SU
         CHqyCJBt7/xqNcOCfmfLAyONGJsnXthViW2v4Jg24A+gixmolOPvNKG6G8TWqKLi+3TT
         DxuY7Pj+vVKI0tX98D6ibvXz5Pz0z3gT1t1ZQcVhDRIOsLBdipRrcuaGum3A7Z6Lf9wY
         qf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y8rwFVgpmbmz9iHq7Ty2VJHYqKNufP22ef728+lV9Xw=;
        b=XgAqoYQZmGd6CJ28Q3p28FKSoz1KxjotHY6jZDgy8ZTNkaIsHQXIexbVmp87ws+ukz
         m6scZkUo2KRkHS1RT6ztmaiqf6PGwqOFpUyt/qbHDxQ37gyaxZs1OofkLWQJp73owa5V
         7sfRh57eAr1LInSf2U9oopNZqqwmZK0E/w7+DYe/oiym34xastSSNIflFO9WUHlmJKwj
         DxpFAY2IJt0dSRoos/nVMUwLEte5MQb9teGdJWP1NLjMzk91Dh5jE5rFeF8l0XvJs+Ic
         wdtvpBI//CE7nx2JA0G/S2xFTfK9LhQH2pQhdfLPZGOVzzWh7SsLTt4v3pLymyPKXobZ
         FUsw==
X-Gm-Message-State: AOAM531QHpQj7MaRKFlT3kPh9bEUpYhdX36EWh86B6gBSk/gPNC7J+RF
        03Vq+a3eQYM5in6JWfQBqK53xzBp1K2QDBr2
X-Google-Smtp-Source: ABdhPJweHLnDLPX/izL/hMeytsz+/0JnJQB4sH7xHOKnEpN2uFAYUPpbBSryaT7ukNp0N2bgPGkSWw==
X-Received: by 2002:a17:90a:db14:: with SMTP id g20mr4254165pjv.43.1634025214824;
        Tue, 12 Oct 2021 00:53:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b23sm10280229pfi.135.2021.10.12.00.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 00:53:34 -0700 (PDT)
Message-ID: <61653efe.1c69fb81.fbc86.cef5@mx.google.com>
Date:   Tue, 12 Oct 2021 00:53:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.250-24-g0c04723a59cf
Subject: stable-rc/queue/4.14 baseline: 91 runs,
 1 regressions (v4.14.250-24-g0c04723a59cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 91 runs, 1 regressions (v4.14.250-24-g0c0472=
3a59cf)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.250-24-g0c04723a59cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.250-24-g0c04723a59cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c04723a59cf12fd181f0525a928b13b31fb3a94 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6165055ada90c4cc5008fad5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-24-g0c04723a59cf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.250=
-24-g0c04723a59cf/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6165055ada90c4c=
c5008fad8
        new failure (last pass: v4.14.250-10-g360a25ea0f96)
        2 lines

    2021-10-12T03:47:17.681838  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-10-12T03:47:17.690585  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-10-12T03:47:17.707126  [   20.571258] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
