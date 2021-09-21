Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D904135D1
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhIUPGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhIUPGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 11:06:11 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE61C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:04:43 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e16so19765246pfc.6
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=igF7gohztpvJX9R0jRmFQg9brhi1QK2RebUX7rjYzQk=;
        b=ljm4hxSptbWosv50Eh2rUQdCG6i6tPFziJ1jCxNS30Oa64LDrpcroyunmWtUXqh65O
         RjjovNxvTKilKTDoh0kcPWVT68cii42mvTA/VZ9gFs1MMTzLGjiiv4nPKVXUdtnN6YvR
         92VzGgMoxw980lcRHjPxKIg85xkP4XslxoIuwHsX1Nj2LDDf2VbchRoFtGLB0Ng4xjj/
         zlNsiTmSxDH08FTAS9V1ie4n7kcryUKTWbxGllXNVFttnaBoZTn98t47TR4ij4simAMY
         1GNnvU3UaiN7gCW5bpgboNGILqCIoPObtWFEzePYesZbW3gxJWn3v3JjbYMwLj4Ewzmz
         A/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=igF7gohztpvJX9R0jRmFQg9brhi1QK2RebUX7rjYzQk=;
        b=4rfM4VAE00x/akN3KJShxTTDZLa4BfBNPj/7fdy8EhFSS7S/X59M8D3S+6iHsfnZHC
         cgLDNYWZYfFkXk8TbztGOeLRMjXsDgWKxybSAr5nR3PR2IYueoKdQVFzAwOXrjoP2BOl
         OMRo8Bc3ItyzWMl+M2myR91UUh78N4QUdCYO+hKTkVt5H0TBkYrpQq5KUe9cmapG3wRS
         Cf2L++5J5NHLgD/2nG4G+aAxp9rZIqX/zvqZW0j21VR8u9rTBDXfVXpnTmlShn1hFTPQ
         7Vdi9v2QFzpepkpmZWaegC2nPazAqlTMhYX6+Ugtodh44VPwvuZN5DEgCdwKGrtnmjAK
         YxXg==
X-Gm-Message-State: AOAM531a6ZPbqznya6v1HgTZar+NG3QtYLphzfIWzHB0cW/BDewBSm2y
        Tqo32JXEVkCGagfoEN8oiuiY9EEv8Ekd6cUh
X-Google-Smtp-Source: ABdhPJwUHTN+FjiaQxHSgc/v7AmbNV8afW/LI6yT3sF/IMhSfkQ3n+AUIP0NbAu1MCpwSnZAb+baSw==
X-Received: by 2002:aa7:9513:0:b0:44a:c112:64f3 with SMTP id b19-20020aa79513000000b0044ac11264f3mr712087pfp.33.1632236682773;
        Tue, 21 Sep 2021 08:04:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 77sm18106552pfu.219.2021.09.21.08.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 08:04:42 -0700 (PDT)
Message-ID: <6149f48a.1c69fb81.efe21.12d4@mx.google.com>
Date:   Tue, 21 Sep 2021 08:04:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.18-378-g4988c1d6e3eb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 169 runs,
 2 regressions (v5.13.18-378-g4988c1d6e3eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 169 runs, 2 regressions (v5.13.18-378-g4988c=
1d6e3eb)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.18-378-g4988c1d6e3eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.18-378-g4988c1d6e3eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4988c1d6e3ebe06a1d0a27eed85ca138da07cee1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149beb8ef6bb1ac6b99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.18-=
378-g4988c1d6e3eb/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.18-=
378-g4988c1d6e3eb/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149beb8ef6bb1ac6b99a=
2e4
        failing since 5 days (last pass: v5.13.17-17-ge0578f173e9a, first f=
ail: v5.13.17-68-g71a177e69b76) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149c1c5d2a80e7aaa99a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.18-=
378-g4988c1d6e3eb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.18-=
378-g4988c1d6e3eb/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149c1c5d2a80e7aaa99a=
2ff
        new failure (last pass: v5.13.17-349-g6b59c9139e8e) =

 =20
