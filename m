Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94BF3CF13D
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 03:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhGTAjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244309AbhGTAhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 20:37:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B296C061766
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 18:18:09 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id x13-20020a17090a46cdb0290175cf22899cso1520875pjg.2
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 18:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xA7694GlJ863jXMVdud7ovkkCemkeCUDlF+G4ZqZ+8M=;
        b=pp2F2421cuMU/PwAtjz63M7sA2aFNom2QL1X1VI1Dv9y6jola8Lh5uIquoHUrbUGmi
         RdEPMU7NZazS8Fkf9DQzP+YAtH93rs4vSxJO6123Z1zS2n+9r3iNpOG8/4anMp8lIkMO
         mEifmkKFN3kSLi7K4EE/38CDXR27zHpYeOmfZgm3Hp38Embb5Y3VLRfGeqJTK1S9UOZJ
         0Hh2puWBh0g0nokaOxDw0cxRXgHVD8ihV6zwbScW1zrpZGLoHtzM1yCb91YvfeDGa5Xo
         u+hI8x9c5wb6YsnMxbiauma5WbJ4iG70J0j7ZRUYGjNpW8E/H+bWsZViXW3eop2I6AvG
         ftgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xA7694GlJ863jXMVdud7ovkkCemkeCUDlF+G4ZqZ+8M=;
        b=amXyTkyGW5xmfVU/odBvErySFnfF0Tg9lOfboay0esZUdQCmawQ3xErm/8SQADB7kr
         RJ8bk6HxdQk6J5As0DqCSzR/t7tKR1hjfZzgjZZhC/HO/d85rXgAhFYMaf2QucoUxtI/
         k1D/ENdvYroEqbykaj7qSyuU1ousFObX7pdbpYd8qlPS1PKM9KRsxZRrl1oDKpilLRJ+
         Mqj/aWJrEz0HjdepdCeN3KXN+6mUg3X3e3PjiPGR40PdhACkZ1SeOBM+Uisb7BFbCCm/
         4lHO7v9EEBaFoFM958poKwW1l3JTTWAeD9S4wpROkXqlIb5VW0XyGiac+iHys8zTtgTz
         KSJA==
X-Gm-Message-State: AOAM5308iLcbC0UBIc1P74+uNH9hQG3RCeugTKP5ma4dStYRLjIlmcG5
        dR1/y7TNHBUOMwlFXa69/X+dyDvEOKwZQg==
X-Google-Smtp-Source: ABdhPJzGKSvv3zW3GGsYvQ0iVnZkVBonIciSHPF/btwfoWm4TuIpuC1wU2nRv/Guf6Pe8iUVoQogTQ==
X-Received: by 2002:a17:90a:404a:: with SMTP id k10mr27314936pjg.145.1626743888737;
        Mon, 19 Jul 2021 18:18:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p25sm21523512pff.120.2021.07.19.18.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 18:18:08 -0700 (PDT)
Message-ID: <60f62450.1c69fb81.15178.0732@mx.google.com>
Date:   Mon, 19 Jul 2021 18:18:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.3-350-g6c45a6a40ddee
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 192 runs,
 2 regressions (v5.13.3-350-g6c45a6a40ddee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 192 runs, 2 regressions (v5.13.3-350-g6c45=
a6a40ddee)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =

d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.3-350-g6c45a6a40ddee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.3-350-g6c45a6a40ddee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c45a6a40ddee3fd5e7e780dd68cac22203fed77 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f5eb5daf18934e101160be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-350-g6c45a6a40ddee/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-350-g6c45a6a40ddee/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5eb5daf18934e10116=
0bf
        failing since 8 days (last pass: v5.13.1, first fail: v5.13.1-783-g=
664307fdb480) =

 =



platform | arch   | lab        | compiler | defconfig                    | =
regressions
---------+--------+------------+----------+------------------------------+-=
-----------
d2500cc  | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook | =
1          =


  Details:     https://kernelci.org/test/plan/id/60f5ed65544aaab1a21160cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-350-g6c45a6a40ddee/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.3=
-350-g6c45a6a40ddee/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5ed65544aaab1a2116=
0d0
        failing since 8 days (last pass: v5.13.1, first fail: v5.13.1-783-g=
664307fdb480) =

 =20
