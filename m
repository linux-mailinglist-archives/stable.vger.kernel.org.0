Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D522E29CB0B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 22:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373688AbgJ0VQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 17:16:20 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:37079 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368846AbgJ0VP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 17:15:29 -0400
Received: by mail-pl1-f174.google.com with SMTP id b12so1434304plr.4
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 14:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2/Q718ZNMnSXOZQVogtwyAFwdnKORPoPglzzlAbzxdg=;
        b=LtnrXNe54t9HDBQ4b007PlygS60+bGX9Rv52P2hLoU32yUIXQYGpvpZLteJ2hlnf6Q
         HxHq9bsxlXagvcELyy734sa816Czk+WRvph6O0wX7DieWwlX4YPKiox3mCM/43jc32vA
         cbtj4FqgZ81/vOpehp6nenCNT4vYQqei6ep2iMuHggwSl77VlPM3WG4ek82+7GhAM8UD
         dKiLK4wohgjdxEtkUNJdBHn12Jcs2lUF+xvWFe6bBw34uBTDOtBnuz6N7eSXWwOR5N/d
         hmnVYxwAqTCORfXIaKrzx354bZy796VGDNZIKfrP4oQwk3Scd6QV9JqqOwmkWGsKeU27
         xFRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2/Q718ZNMnSXOZQVogtwyAFwdnKORPoPglzzlAbzxdg=;
        b=Cv5TFYPbyYibgvdi3vUfudIkJkVavF7e8gSbpMokmXlwuTD2CN0cTCuogSJ/fcym+E
         H/mhTjrxbufL76glrmkqvQuaVQIBar1iV2pERB16sQnHQg9Vv8qyjgUvW46hnp80+sf3
         S6eMG+jTAFnzn/kx9g7uIHUwEgFfQgdItp6O1DfbnG5f1APB1yxmGWJ+HaNqyYSMUKOC
         vs8U2PnkI77vtwjSHSawx25lbhJ9KGJMEHjAbPpOVn6XZui2gpxS8+k4llREOnTlCj6Z
         r8pgreISRdes88E3/fzw0wycuepqhLVAg08ICLkdt8dYtKWom1tz71sNgNE7x79kG4dy
         xXBA==
X-Gm-Message-State: AOAM530xuBgFrGqKYs+V2tFltL9Uq0lmQaxjNNms+cLzXQBS1jTeHjva
        qvnjFGEPuUyzdmrxBmnC/Eo8JIaQvJw4yw==
X-Google-Smtp-Source: ABdhPJyLfdRLWgVgAYZvqhCveFH5Gok26xyTqGeB6YBzIYKcw2uWAF97T/j67Ftf38ruIKtTFPnwkg==
X-Received: by 2002:a17:902:6a83:b029:d5:e98f:2437 with SMTP id n3-20020a1709026a83b02900d5e98f2437mr4035211plk.38.1603833327008;
        Tue, 27 Oct 2020 14:15:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm2970989pgp.90.2020.10.27.14.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 14:15:26 -0700 (PDT)
Message-ID: <5f988dee.1c69fb81.d341f.59c8@mx.google.com>
Date:   Tue, 27 Oct 2020 14:15:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.202-191-ga749788345ca
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 2 regressions (v4.14.202-191-ga749788345ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 2 regressions (v4.14.202-191-ga749=
788345ca)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-8    | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.202-191-ga749788345ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.202-191-ga749788345ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a749788345ca060618953cb6429878ac78ea8e43 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-8    | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f985a52cd5d4f6db738102a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-191-ga749788345ca/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-191-ga749788345ca/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f985a52cd5d4f6db7381=
02b
        new failure (last pass: v4.14.202-187-gb76e374d6454) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-8    | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f985a66cd5d4f6db7381049

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-191-ga749788345ca/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.202=
-191-ga749788345ca/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f985a66cd5d4f6=
db7381050
        new failure (last pass: v4.14.202-187-gb76e374d6454)
        2 lines =

 =20
