Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE282327AE9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 10:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhCAJgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 04:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbhCAJgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:36:24 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E829C061786
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 01:35:44 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id r5so11071771pfh.13
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 01:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qNWR/6U449abG5kIlbby7oYD5gK3+0DfQ4u1SqzwNxw=;
        b=lfW7jN9IsTv6S+iCF2rBwsspXCCFClSpP7EKckQAOSvwZ3htqCRjFzp0pC9Df7NbPt
         pL7u3XK7BOxQPYiRx5mkOx3T3lg4O2P0SeGtuzJJt8K3WMWETcDVOYutesKtYPuDFWiX
         U8Y5g80PI2xZKkpid9iOvuHhOuxuNylQQqjFUZJXcTm1K+I+JKPV0oFCKcVlURhdtTOX
         xPrv3fiQ9TOB5GDNpAgWihJTb7xyh/se/loR9fkEyLBax5deVIuKQtjLiFCOTawM8E03
         wW9CHPyPS34/EUDjPhAJf1V7D3GQgrvjriGJ3AO2WfJTHETcqCFtsIYdBsu7Qm3RoT43
         J4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qNWR/6U449abG5kIlbby7oYD5gK3+0DfQ4u1SqzwNxw=;
        b=H0+47hrrteqD4G4V9hItCchiczAdG8d5huOLFUQSLAD0J21Rgjg6S+EF7zxooONENV
         5E0zVTQOcBmNH5wlUKOf+zoptn4r62fek6I/xgbJ1hwHmdLuwGbUUITJfod1bDFdxw7D
         cAXSUpfBqtykok7ejHrIYupT7tePKVzliXS2DnVylf7mJO3nM4yKY8kMuSpaeeqIeq3f
         xQjNQWtxAJK6BQ/lRw+5YTHYWK4DYo1FtQx3h0BcOE9I1unVy4heT+sKhdPnHMRAcbmc
         qSyYP6sSWbSYqXZfZluwdu7Sjda31mD1rOVr+ZHPEnTg0m4phQOEmje8DeEp/RcGkV2A
         Az9g==
X-Gm-Message-State: AOAM531KtnS3pTWapc41OPh9rOhbwJ4MPWnPUuLa8R4vRDfiG6vHkmom
        OGfv8f+HO67dh5LwXKtB60+IFsUfERpjkg==
X-Google-Smtp-Source: ABdhPJxGXB6G7MZpW2xo+n+3TagNSPebUbdJAnwYDk+EstTniNPtKMxc43Gg11j+iFE3VzqA6aRNzQ==
X-Received: by 2002:a63:f209:: with SMTP id v9mr6453902pgh.97.1614591343797;
        Mon, 01 Mar 2021 01:35:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 184sm17867289pfc.176.2021.03.01.01.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 01:35:43 -0800 (PST)
Message-ID: <603cb56f.1c69fb81.ff418.a12e@mx.google.com>
Date:   Mon, 01 Mar 2021 01:35:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-120-gdc8887cba23e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 65 runs,
 2 regressions (v4.14.222-120-gdc8887cba23e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 65 runs, 2 regressions (v4.14.222-120-gdc888=
7cba23e)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-120-gdc8887cba23e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-120-gdc8887cba23e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc8887cba23e2bdbb5d6c255d559c5e17a31f72e =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/603c89230eb8a7e98daddcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603c89230eb8a7e98dadd=
cc9
        new failure (last pass: v4.14.222-11-g13b8482a0f700) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/603c81667bdf3bda9faddd0e

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-120-gdc8887cba23e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603c81667bdf3bd=
a9faddd13
        new failure (last pass: v4.14.222-11-g13b8482a0f700)
        2 lines

    2021-03-01 05:53:39.201000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
