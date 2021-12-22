Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BC747D52C
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 17:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhLVQjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 11:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhLVQjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 11:39:44 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225DCC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 08:39:44 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n16so2294570plc.2
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 08:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f8Qw+raQFywXmfqbHiH6QeskUQQYnn6cJsGmrxWoWCU=;
        b=IaXFXKGeQyuWnFm6ktJV/s8He+H74CmHkCCW3y385dORxLS5t+9kJOimBs3z/2VSMM
         0tjOHEgyWT46ADlc6Y1jlOnsjDtQtcGU7UQ6bpb3ws00XVYo425f1ivGx1cv/y3Pj9gi
         dJowWfVmPivhplB67/PUEGhXIyqKeXhUNFG3ZTae27OCsdaOR+2Ji9EhRs4/TLHRLNcQ
         ngzRusUhZwAdWt/HeC1l73Mr55lQuYvx8yt3eTPUt45hz5sdX5NZ/P5pUgNnRLqS4oJU
         bZ5u6zaJf177FKvG+kUWCKEFmWcEkLKoIU4iVkEC+HAsEGbM9OHPrpyYxrouHZueRjQc
         jb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f8Qw+raQFywXmfqbHiH6QeskUQQYnn6cJsGmrxWoWCU=;
        b=yXKneDlWtwUvOzUdf6oe5tcaAPAYs3zaD1hk+9kO36m77RHqFdoYFfHMVP7pjA9Jjd
         0DVeRUU8yI1Msu+ilMKV5+BoXduaYIGiznYibQT785F4BCmqqMOB2MIkF9/utRnkNSyK
         64a1hlQGCcrVDIZC3nNu5FZYksl9ebeBO8oRZxmetxm7TXnUjli9MO3Uqqy82iA2eFkk
         3LoW/gFzRY5yrmTGcWsJT5T2h2+ehm/HAGn3GS+ctooQOdR8LLjTm5h5C3aVMefjtrt3
         +nRgwXBKGro8ExG5lymk91WQR54yOesGgefiJv7Fz9iWGMNKKw+qJ2wdqHhpVYaK4nxm
         7exA==
X-Gm-Message-State: AOAM5320O2qkFnOrG8mkNdFXLaPlY24Oahpfweh6ORcB31jw1UVEQQ+r
        YzQaqqfIzOsKdL58XXfkrNBXOGXXYVoTeR26YtE=
X-Google-Smtp-Source: ABdhPJwzanagRjsuen8IgYWZDNfVh25y5DOOp+lh3txS1xrlAiKV2KYsU51Ekz81baGzEKPaPxIC9A==
X-Received: by 2002:a17:902:7248:b0:148:eb68:f6d7 with SMTP id c8-20020a170902724800b00148eb68f6d7mr3601875pll.97.1640191183218;
        Wed, 22 Dec 2021 08:39:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16sm1420993pfv.135.2021.12.22.08.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:39:42 -0800 (PST)
Message-ID: <61c354ce.1c69fb81.19c50.34b8@mx.google.com>
Date:   Wed, 22 Dec 2021 08:39:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.222
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 193 runs, 2 regressions (v4.19.222)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 193 runs, 2 regressions (v4.19.222)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.222/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.222
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      508a321e02f2cc9dfb1f226f7b10dd889887d249 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c31af428958b7d1739716f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.222/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.222/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c31af428958b7d17397=
170
        failing since 8 days (last pass: v4.19.220, first fail: v4.19.221) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61c31c2478bec77a1f397142

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.222/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.222/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c31c2478bec77=
a1f397145
        failing since 14 days (last pass: v4.19.219, first fail: v4.19.220)
        2 lines

    2021-12-22T12:37:40.569197  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-12-22T12:37:40.578600  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-22T12:37:40.594743  <8>[   21.448669] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
