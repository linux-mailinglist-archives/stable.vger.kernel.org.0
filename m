Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725692639B4
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgIJCAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 22:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbgIJBma (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 21:42:30 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D347AC061373
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 18:27:05 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id u13so3364109pgh.1
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 18:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fr7nTAHPmLjJicGEfTQB5/SX5nBJ5dBx52eWhnMCe4M=;
        b=JEvderLXATtkvaPM5g81QyN2bBpB3RGLeWoazmlyR5SDac8ZHuLXiYeRSz9j+yulaJ
         UCTIwBFELrgEr21D9d3LQQgAgSaJmgKML7gshUJOL8wH7Sj2MCrCYhcuBw4LJ8Ueun8E
         E/AtZCGWX6XiekzPWJk7IkesDYBtko6q1aJPanVW47whdk1QK51lqEC/pt6bZuF1+85O
         pDsEBe1D9fNK+cThKJDm60UWD6dmw+uCXUx8pwZQZsMeOqg2PXjrs+mdsls/sJStpt7V
         /F7VpeSnEvXBcVAC5dr1EKk90bhImFyszWpUGbEngKUlJ82R4naeqPsuA6hiXz7obR4n
         UljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fr7nTAHPmLjJicGEfTQB5/SX5nBJ5dBx52eWhnMCe4M=;
        b=Txbex9Rih/TfV4wdYBE4uOdieiOi+yeM4GRziPSbXQahBMdXYpaZxz67A3tgi75yXQ
         Ccgyu//l0Z/ADYQKIkUCbniCFvj+Dd5hLayTovN7LeTABIipM6RH36kV1wk+AyUd/z7u
         6tuP6l1xf9kaU62trnZnpMqOFI0g34G/b79L9lM9Ekt4HsuW4GA/wdO2lYYBV7zMV6Yp
         pLi3vQkY/U1n+KSjplFVKhjrK6cvEJ0UybzLlgCA/GYE33WGQZcn01BQ19jaNxY48NgK
         fk7MyCfwRgM9gc1tQW2ehfFQrmYRrREt48NdS/W/hKSe+KCSYzGUr2aA6vzDiWJFNUwO
         3PjA==
X-Gm-Message-State: AOAM531+DgfOMJlxtIExafgz8kSUctscSBUa0xBwD2uPH1bHx5Gxq8UB
        g8LjMZyRkJluDnpg80o3ON1kRTyl/LP7dg==
X-Google-Smtp-Source: ABdhPJy9GSlEF2L7nNBe99XbHXR4HkTWbWmeH7xgCz93jx1L0Ikqlcxtx5FEfdJZZWKdReMVIeVe2g==
X-Received: by 2002:a63:c608:: with SMTP id w8mr83413pgg.252.1599701223484;
        Wed, 09 Sep 2020 18:27:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w203sm3801063pfc.97.2020.09.09.18.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 18:27:02 -0700 (PDT)
Message-ID: <5f5980e6.1c69fb81.738ca.b73f@mx.google.com>
Date:   Wed, 09 Sep 2020 18:27:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.235
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 101 runs, 2 regressions (v4.4.235)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 101 runs, 2 regressions (v4.4.235)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.235/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.235
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aafe133906196555c6fa4a1d65977dc3cd2c4349 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f549d660c71b44850d35390

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.235=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.235=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f594ed76c351d86=
acd35382
      new failure (last pass: v4.4.235-51-g772d4c8889e4)
      1 lines

    2020-09-09 21:51:36.525000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-09-09 21:51:36.525000  (user:) is already connected
    2020-09-09 21:51:36.525000  (user:khilman) is already connected
    2020-09-09 21:51:48.689000  =00
    2020-09-09 21:51:48.695000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-09 21:51:48.699000  Trying to boot from MMC1
    2020-09-09 21:51:48.889000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-09-09 21:51:49.129000  =

    2020-09-09 21:51:49.130000  =

    2020-09-09 21:51:49.136000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    ... (449 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f594ed76c35=
1d86acd35384
      new failure (last pass: v4.4.235-51-g772d4c8889e4)
      28 lines

    2020-09-09 21:53:23.172000  kern  :emerg : Stack: (0xcb927d10 to 0xcb92=
8000)
    2020-09-09 21:53:23.180000  kern  :emerg : 7d00:                       =
              bf02b8fc bf010b84 cba92c10 bf02b988
    2020-09-09 21:53:23.189000  kern  :emerg : 7d20: cba92c10 bf2100a8 0000=
0002 cbc18010 cba92c10 bf24bb54 cbccc390 cbccc390
    2020-09-09 21:53:23.197000  kern  :emerg : 7d40: 00000000 00000000 ce22=
8930 c01fb000 ce228930 ce228930 c08564f8 00000001
    2020-09-09 21:53:23.205000  kern  :emerg : 7d60: ce228930 cbccc390 cbcc=
c450 00000000 ce228930 c08564f8 00000001 c095f2c0
    2020-09-09 21:53:23.214000  kern  :emerg : 7d80: ffffffed bf24fff4 ffff=
fdfb 00000025 00000001 c00ce2e4 bf250188 c0407668
    2020-09-09 21:53:23.222000  kern  :emerg : 7da0: c095f2c0 c120aa70 bf24=
fff4 00000000 00000025 c0405b3c c095f2c0 c095f2f4
    2020-09-09 21:53:23.230000  kern  :emerg : 7dc0: bf24fff4 00000000 0000=
0000 c0405ce4 00000000 bf24fff4 c0405c58 c0404008
    2020-09-09 21:53:23.238000  kern  :emerg : 7de0: ce0b08a4 ce221910 bf24=
fff4 cbba0140 c09d9ba8 c0405154 bf24eb6c c095c460
    2020-09-09 21:53:23.246000  kern  :emerg : 7e00: cbc08940 bf24fff4 c095=
c460 cbc08940 bf253000 c040671c c095c460 c095c460
    ... (16 line(s) more)
      =20
