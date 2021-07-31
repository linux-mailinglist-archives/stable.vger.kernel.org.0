Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164E53DC5EC
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 14:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhGaM3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 08:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbhGaM3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 08:29:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F5BC06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 05:28:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ca5so19008361pjb.5
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GD+SFShhwfAbsrI4zInRRV4mh20tsmLEqOi8ZgE+lCg=;
        b=fxl6tRZr5FdqmkDo5loz1DHjofmIuAnQmYpIgIkvt2wicxihlL8WCBMM7ty/4fn/2X
         awZjpDx4xzEHuOAEkSjBHxRcRv497DXuxywZFmBib/KtS0gmyHVUVLYuH42IsExbDLWN
         qMZlOZ8GQjvaKGl6lcgS6a6w+QJEdBKtzFaJnTRk7hj7RRFudyTsQAuv5L63MkUYkiAY
         GjrvQdfV8xeqO8Y7MhziVtOEUyqjuZbRP34MPgIuwOv1qdGRYgZPAD83byZ+DBPZi8TG
         J+03LfxAxKt9VLCwwizPZB8U1S/+FNBqcEIUHUpZs3AvdlIE+CwOM7Va1ev9DZr66jQ8
         Mckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GD+SFShhwfAbsrI4zInRRV4mh20tsmLEqOi8ZgE+lCg=;
        b=oyZMhq1XCWGtCeiyOj8dmyM3aFq+w34xLM/Q2kUPhdA4EF3Nh+BaZZdnn/CDnIq1k3
         9oO1w1tb84NBeuLeZ2OH4wyg5tjsAFfpJ4Exyo5VcGytdPzAyLUcHn6AYS6G/WPpZTk2
         XCmGGhw+fEDfa/ul1wXu/tFXDDF4lyehXv26vL/ojaUjPBFXP7M80GY1OzN5hHxEt6Lm
         uJ1lO5S5cdAXclIPFXGkZLqqUXTW1w+Ecqrag7Z7SY2ogw4rsvgTblarvGMoCvJlXyfg
         ciaIVhBMy76zQxj/jQ9HC3Whm+U8tmRIANI3QWxrMpY4tgghEzLjOHhndTWhHj0ucp+r
         RgQw==
X-Gm-Message-State: AOAM531piPRiV81an748+UrFX1qNih5UzXu1lk4q3zODtiZxvilXpFGi
        A7m73JvZx/wHSTz1itforwW6ono34R2vouFW
X-Google-Smtp-Source: ABdhPJxCSNPE9gQe29UPXApcu5tQWme2i5WOjh/B3IROape8rThUws2zJOX5+hzVc9bT6Le46nHlig==
X-Received: by 2002:a17:90a:c8b:: with SMTP id v11mr7913815pja.114.1627734538048;
        Sat, 31 Jul 2021 05:28:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h5sm5700192pfv.145.2021.07.31.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 05:28:57 -0700 (PDT)
Message-ID: <61054209.1c69fb81.104af.f88e@mx.google.com>
Date:   Sat, 31 Jul 2021 05:28:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.7-34-g5c86ce80c94b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 154 runs,
 3 regressions (v5.13.7-34-g5c86ce80c94b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 154 runs, 3 regressions (v5.13.7-34-g5c86c=
e80c94b)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =

beagle-xm        | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =

imx6ul-14x14-evk | arm  | lab-nxp      | gcc-8    | imx_v6_v7_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.7-34-g5c86ce80c94b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.7-34-g5c86ce80c94b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c86ce80c94b26601c544cfcb8a1525101d34550 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6105118cd85c89dbb485f481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-34-g5c86ce80c94b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-34-g5c86ce80c94b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105118cd85c89dbb485f=
482
        failing since 10 days (last pass: v5.13.3-350-g6c45a6a40ddee, first=
 fail: v5.13.3-349-g1d9dba03aebe5) =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/61050a4572f84c6d1a85f4a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-34-g5c86ce80c94b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-34-g5c86ce80c94b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050a4572f84c6d1a85f=
4a5
        failing since 15 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
imx6ul-14x14-evk | arm  | lab-nxp      | gcc-8    | imx_v6_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/61050afb94577f94cf85f463

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-34-g5c86ce80c94b/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.7=
-34-g5c86ce80c94b/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050afb94577f94cf85f=
464
        new failure (last pass: v5.13.6-23-ga572733cda32) =

 =20
