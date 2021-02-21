Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7864320E06
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 22:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhBUVix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 16:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhBUViw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Feb 2021 16:38:52 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ADCC061574
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 13:38:12 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id a4so8958453pgc.11
        for <stable@vger.kernel.org>; Sun, 21 Feb 2021 13:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HX+0hUSLO//nOvEptjzFoiQpkL3/YBEjb75kbm3Heio=;
        b=uZGwAtYj3yMYlYLaE2oBV3O4CsHAmBpPRfWrA13IOinsB8hr+mZeVYeIBl6MnZhNvx
         iXmCtLMLru0EkaYWXldh9W/Ron7ujXUhv1e1JcytHdhBso7B1lr2BSaWw6TBe0ER0eSH
         a3RG1pHwWOE0RlEfHmugDqm7aa+IjyDmJavYKjzWAwsCiFysaoE6bf9i63v6kxxN1OBc
         uB4/rbLDEBCHhBguY7wzKhqXP6iGlnefLLYYCEx5hD31cA19CnOTbkBSvyM5dZ/ln8Ob
         VE8AE1oA+ojEr84RZkqcM7g41zDzbjU3AxMFgYmOo+Sy0hLBf2EoyTxYxAUVTKK7LSzl
         3klg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HX+0hUSLO//nOvEptjzFoiQpkL3/YBEjb75kbm3Heio=;
        b=imnHWdR4O8O8/KbL8KZwxw7dimYn2IGAfIaHE+GvEhG7xNlyz77TRKHQ/5sldGeSDw
         g1a5YjGj42HAYnMSfQ8TbxNBK9Fw0vdnJKfTT13PcjfDZvuAHBrXe6wY/RV3rzakJU20
         zHYAkcGjnic7qe2+gVxuu3Z2zImNby1VsXXrxBgbBCgprdlqpOjeuZqrtujzcBOZM2Yv
         U9a54kyqKqNnp2qlWYijZuxTfBNZg20BXZbMDOM1JsqoNoaC2yPc4LKcd1bCHmq7UNWM
         i2g8v5AsEZ3U5sQ+dd9d/o9sR1tLQIbyQIUhVmyx/JB66SKFTH+SG8u/IOH8ddxSaR3a
         noTw==
X-Gm-Message-State: AOAM530IpjLzdd8L36F2vIXFjMV3bCXMy0GsraTgLToFEq3B9Vi87FOi
        kQ6ShbySbTPUoDpaOckVZEMKPvSpZCaPJQ==
X-Google-Smtp-Source: ABdhPJz+Tv93BDcU1VR7ZnHMxjvVIZoLhUN76cXn40XwcV5LafpR6CSTiwE5UHjXPFAomr2XqVN1wA==
X-Received: by 2002:a62:824d:0:b029:1ed:55f5:f8c0 with SMTP id w74-20020a62824d0000b02901ed55f5f8c0mr10786958pfd.60.1613943491759;
        Sun, 21 Feb 2021 13:38:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o20sm15188240pjt.43.2021.02.21.13.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:38:11 -0800 (PST)
Message-ID: <6032d2c3.1c69fb81.73d18.0dd2@mx.google.com>
Date:   Sun, 21 Feb 2021 13:38:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-gb9da7de2c8eb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 78 runs,
 1 regressions (v4.14.221-44-gb9da7de2c8eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 78 runs, 1 regressions (v4.14.221-44-gb9da7d=
e2c8eb)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-gb9da7de2c8eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-gb9da7de2c8eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9da7de2c8eb7e7022bf3268398518c9e12eca41 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60329e5a3f03753bb1addcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gb9da7de2c8eb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gb9da7de2c8eb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60329e5a3f03753bb1add=
cfc
        failing since 75 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
