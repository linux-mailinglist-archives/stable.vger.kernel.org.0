Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0ED4502AA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 11:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhKOKpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 05:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhKOKpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 05:45:02 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62D9C061746
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 02:42:07 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v23so12459175pjr.5
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 02:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dgsl0Dd+8BOep2cCfZEubVHW1XMS685srNMEb6HXlE8=;
        b=zpwrlk3rare/hSYcuGj7ccyOh40Eh8r2vF8/+VBbI/A/wu6ZBjN1bKiyL9vcyLTkWQ
         njoWiAEPpTeCIxUASl9Mq7t3iaNxbgNvw6lIyENE3Af874WwzkJswGedsc9hdkRs5ipM
         cJUCEznVtMRq+wG9O5pqIR4Vc5Wb8qsUJo4mm/yRvZzrFe14iBB2htkWzjksf6a1HwMU
         HfIaQz8Rzc8Gsi/jYLtviFpU/yAn3/ZZlRK4gjyAsszhXP8pEeC6rfrR1cNpU9NDAuN+
         P0h/LBxD3dU3Pt6AtqgWm+5n6onD5JOMvx8i79/3lwBGfIZyp1vFDulHWwUaQTgwlVRl
         4QiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dgsl0Dd+8BOep2cCfZEubVHW1XMS685srNMEb6HXlE8=;
        b=NJVlkNhq5MGQjfulka/PTfLm3oam4QsCu9MmpCC5R4U8WOVoBRlDsMFoX8z36qnaFt
         YD32GW/AB8R3iiG6/T8VzqZCqHsmzqrCglqCN4hV3pdxc0tTpSlfShWauuCXet4WpPUc
         SkAvF96Rk1oWKmlDGOz9oxvVVr5ed9MZwNrkEoY0oiDTjiYLzodedVQqMkapLGkEBlYT
         GbVubKnfshBs/4te+2tvEvoPDbdOoLvGD2IUH2jAue8LdLJHZ4Zk+gjtTiOduXqC83gV
         ZRhWlSe1p/TEUsFgaBkAKuPX/i8Aqts5E0jYlrjLub7Y+Yhwkan5GqQDGjKEi1jrLEAA
         dwxQ==
X-Gm-Message-State: AOAM532vdq6KfhUg7bT6JE+04ETW01gyBm0jALZvsDOFna9PrWQasiJU
        Hbj/60se0rlCFA7qUKWN8YT6+qqCNgKVaZXj
X-Google-Smtp-Source: ABdhPJyGJmBpCFod2qyNKG6h9OL56l1VlIt5M6Hj9nNu3uXIO9fGMMBlbWJQRV125XmYxf24uAb2yg==
X-Received: by 2002:a17:902:ced1:b0:141:e15d:49e0 with SMTP id d17-20020a170902ced100b00141e15d49e0mr34353228plg.27.1636972925957;
        Mon, 15 Nov 2021 02:42:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e23sm11809743pgg.68.2021.11.15.02.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:42:05 -0800 (PST)
Message-ID: <6192397d.1c69fb81.51504.1e13@mx.google.com>
Date:   Mon, 15 Nov 2021 02:42:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-788-gd649998125f4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 179 runs,
 2 regressions (v5.14.18-788-gd649998125f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 179 runs, 2 regressions (v5.14.18-788-gd6499=
98125f4)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-788-gd649998125f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-788-gd649998125f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d649998125f4d4b4356a049f9d22be51e829d62e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/619200fb4257ade8f5335927

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
788-gd649998125f4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
788-gd649998125f4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619200fb4257ade8f5335=
928
        failing since 21 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/619201e77a9b5e4e3233590a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
788-gd649998125f4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
788-gd649998125f4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619201e77a9b5e4e32335=
90b
        new failure (last pass: v5.14.18-204-ge1c25497dccf0) =

 =20
