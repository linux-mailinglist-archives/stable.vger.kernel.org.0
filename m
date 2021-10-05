Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6FD422C92
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 17:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhJEPfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 11:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJEPfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 11:35:36 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB24C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 08:33:45 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c4so2568635pls.6
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 08:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rWgMxsPebxUxnETX9D0RS/G6iMDYu9yTUiVinpV598Y=;
        b=QUaZJoge0DdeyimZzOSY16hmWxYg9nUBkNOnYwDx0DgLAvZKg0JsX5aLvBCS5+Ywf+
         NT/cjGGA2sZFN4fYznu0w2CqB3A06P+lRjNigWleXCgnqpMDaYzKkBOO2NyJ/wE0hSqS
         7PQCJdFYUDM2ITgd7eY4gItsqIyuERB2/SBqvtN1xK2dwigWoQw8nfJdP+v2wvegFG91
         nbCS4e6OBDrT6A+kL2BN/cIkbSPk/LppjQuavqYkRcJxBHOU4/Y1EvySXTrP611LLoVC
         6vq2f3H+LFP2iOhvc1TfOZW67WvnZv1dPk1anfCrfa906VPQFIVFgM6gxteOZIuxDX6O
         j45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rWgMxsPebxUxnETX9D0RS/G6iMDYu9yTUiVinpV598Y=;
        b=4CZziXEOh+uKyRJi8w6MmTu+WrRidOg/g7PtzoKeOzoDN5qrkMlI+oa4ZHu8sDFOrl
         HzFBqR9WRJinlSUKBWxH6r6gRIYypcObUaRBrlH/DvFXRWLrrhRM5tKEslpnvEiLmTGb
         52sBmbL4HdyJ/mIPHSK2ieLL5szoupAx5J/BNtjFga4AG9PR1db4akPr5vAaqWusZull
         h4GXvK+TxPmz7oFasqdMxKpyemD6JL/1gDez24nxWCs7yDZySTXUoRhfwKmuSUAtHtWa
         /YD0OQnfDHTGXCjWW9xxqkMmmk0Eg8ToXks6+XHMCyUmoUEX5oIbcBir1d3FvQitVBUx
         Ld8Q==
X-Gm-Message-State: AOAM53335MJWcDXBzwGLhZqDLsYRhmo66eqYkq+CA7uD6vtmXS/8XGWi
        VRPz1RaTIVGF9zFJbUcwk3kLoQP24H8iDs/b
X-Google-Smtp-Source: ABdhPJyErEqjmb42E0X/oGaYRP2j8fvmMEuZv49g7cGoc86FY4gPDaXYhd/zls1lFqMo0LDMZdpccw==
X-Received: by 2002:a17:903:1cc:b0:13e:3a0f:b2ae with SMTP id e12-20020a17090301cc00b0013e3a0fb2aemr5868446plh.3.1633448024859;
        Tue, 05 Oct 2021 08:33:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm5172879pfn.193.2021.10.05.08.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 08:33:44 -0700 (PDT)
Message-ID: <615c7058.1c69fb81.7832.fc57@mx.google.com>
Date:   Tue, 05 Oct 2021 08:33:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.9-174-g355f3195d051
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.14.y
Subject: stable-rc/linux-5.14.y baseline: 108 runs,
 2 regressions (v5.14.9-174-g355f3195d051)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 108 runs, 2 regressions (v5.14.9-174-g355f=
3195d051)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.9-174-g355f3195d051/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.9-174-g355f3195d051
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      355f3195d051ae6f8a0ac840e7a737f1e8b79c2c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/615c3c02ca35d9ed0499a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-174-g355f3195d051/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-174-g355f3195d051/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3c02ca35d9ed0499a=
2e9
        failing since 0 day (last pass: v5.14.9-74-gb50148bf3122, first fai=
l: v5.14.9-173-gcda15f9c69e0) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/615c3b62bf6c66cb6099a325

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-174-g355f3195d051/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.9=
-174-g355f3195d051/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3b62bf6c66cb6099a=
326
        failing since 13 days (last pass: v5.14.6-169-g2f7b80d27451, first =
fail: v5.14.6-171-gc25893599ebc) =

 =20
