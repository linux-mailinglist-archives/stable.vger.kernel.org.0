Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B1D2AE1CA
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 22:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgKJVcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 16:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgKJVcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 16:32:14 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3467C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 13:32:13 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r10so11375595pgb.10
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 13:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kKRqcKPfF1JvSFocRPt7m5jQzIHghYMKMuPKC+VZHN8=;
        b=efWkfXcAxk+uN9XAAtHtKUDynvSRCYvO9qFkQPzLP8jB6gILfDqbqGISumLYC3K7Q4
         tYhpGjuoCPIe4WjldsJJqwCSE38dbb5imUaqLBrffmasteZOQ56gWimj1Wo3IjrfAEXn
         KpHBoA0Wt2kfGbjOH+W/kLT8i8RoRe5qCdMEiIORibn8matY3H12bzAW8HKU2etthzL/
         ZQtDCN7SO2g8T2mAyLD7u4zKELR6l9CzEyQZANWgT+LKqjXJsPNjDuc/KKG6PWZSIqMo
         oN48liKzKeEHRsY8ut1Ni7h+xYKVGYqsPpoP9pFxChjJ+JqGDJQBmdR9ERTr18kxD0pC
         TI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kKRqcKPfF1JvSFocRPt7m5jQzIHghYMKMuPKC+VZHN8=;
        b=Kbwb/b9rzx13IsCCXQhuKBA9DNPE6vvbqIsJ+806wWeU4jXgYEmyD9RfY0LIO3bjH7
         L8f3E147mO/Gs7xwdhUa5dipbxpeU98Bd3qG2oGKh4EpTHbjfyuBQHQ3jaJ1KOQ4l3g4
         K4DnDGPZqUY4tzG7jzW4cJxw07iYd3EZ0CtWcBvZzmA+TyZ1z9KbL4nx1o8bNAAnCO7n
         mkSHQ0z/r3xAV9brfIgmA2kbL4UmMwLXfD/m9seBY9IlZTYUopqBHWPHM/iyt4CVCSKS
         qeR6D0xUYAmpLbyKO6tDJ+Jh+WJhqjUiUbRAgSRO+2rs5yxns+bBkQ7MLxbSWHYX8Y3p
         DGsQ==
X-Gm-Message-State: AOAM533u6m1p+AInGI55rh6MrCC8w++a/PBl9jn37NKQ6cSh1GPenKKH
        1ccOScx/3FW5c8hBjgyhlCMfjTAf0q/Obw==
X-Google-Smtp-Source: ABdhPJzLBprr3hp6a2c+ThN8V+X/oCI6uhj4Djz4F/1bx1PTKH2kQ+RUO45gUr7IIEI/Bi157g8yCA==
X-Received: by 2002:a17:90a:fa4:: with SMTP id 33mr121471pjz.47.1605043933192;
        Tue, 10 Nov 2020 13:32:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3sm4400759pjv.27.2020.11.10.13.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:32:12 -0800 (PST)
Message-ID: <5fab06dc.1c69fb81.d6c44.ae69@mx.google.com>
Date:   Tue, 10 Nov 2020 13:32:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.76
Subject: stable-rc/linux-5.4.y baseline: 195 runs, 1 regressions (v5.4.76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 195 runs, 1 regressions (v5.4.76)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec9c6b417e271ee76d1430d2b197794858238d3b =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/5faad377ba27134dcadb8874

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.76/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.76/=
arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faad377ba27134dcadb8=
875
        new failure (last pass: v5.4.75-86-g0972a1f5fd7d) =

 =20
