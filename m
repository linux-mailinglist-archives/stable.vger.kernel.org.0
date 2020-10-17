Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F8D291357
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 19:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438674AbgJQRhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 13:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438633AbgJQRhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 13:37:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A94C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 10:37:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id c20so3391443pfr.8
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 10:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cIsq/QpKryWZ9NTZNUngl8+kdsk+Pot7iSDqNPFhr0E=;
        b=eoKQElnmNxLQQ9ekBVI8Er0ujaiEkmd8tymjVGf6mOsxk9EDxELj3MREPRPZFHPkHR
         Jbnb7TWL3BU1T2aKc7tWpNiscSdVS5wj1JIHEpFvHVsiYMipesky1RXVvzYfKHcJSCPr
         6rBpcytwrtHHDEe4DNpwn9t1Rbo7F4wjMWcKC29CphvGpUi4VOq3uuGGLymehFLN+dA7
         q834V33VYNdP+8j+1HzbpFmGGHwIJt9UZizhJbgUjz9AgTCiAuRSWnesc5IYx0EOI73D
         AtdrJG6dThepqFNmfAFh7QAAQaDcrR1mzfSuR3d9Ek+X2j7WpZqhX6aFuZeuUL7JShfH
         6KoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cIsq/QpKryWZ9NTZNUngl8+kdsk+Pot7iSDqNPFhr0E=;
        b=TYxwul6vqqvQrGnANaoOcMQ4d4u26/c2VX/wMWOasEY/eyHNF8lEI5eP8zIVnJOm4c
         yEocGAz6aXVHvAJk05nBBdOMcGMTaF5m9yRUbauEZxxETxHJswMYWe+pnr7jw8u7EkgV
         O1Z6GcQKgpdJIMvO3u7BJ6pd4jIuiiwl5Ykd8iM+8IlYVmkiByPVwV2HUzNyDb5Kh7eR
         7t72L3KsIvzcGWz7E6VUsQJD8PF11wDa7+Br1PJbchnYa0J5us0IFp/bOpL0Pyqnnu4z
         7TlDqvdVY2WrEzdJ3WLK+V9Squ8EFeSlo5AmXy+4NLX/sm5aN6UiTAubr/DPRB2jU2Wi
         wOgg==
X-Gm-Message-State: AOAM532aXg/xfbx289wbnJrjy2MmJVMfC09OxvuqM9NoSqEfQdl6N1dG
        WWnW6fETnWkvacUv3UEVdNuZibx0SMCpPA==
X-Google-Smtp-Source: ABdhPJyhQOZEQMWW6oM4TI0x+LlcaOGA35lNHINaXJB3iuuq+dAhryx3wAutfEyPts53JuxSy2WNtQ==
X-Received: by 2002:aa7:85c3:0:b029:156:78e8:1455 with SMTP id z3-20020aa785c30000b029015678e81455mr9393866pfn.68.1602956236118;
        Sat, 17 Oct 2020 10:37:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13sm466767pfo.35.2020.10.17.10.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 10:37:15 -0700 (PDT)
Message-ID: <5f8b2bcb.1c69fb81.94eef.104b@mx.google.com>
Date:   Sat, 17 Oct 2020 10:37:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.240-5-gba0afff56cd5
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 120 runs,
 3 regressions (v4.4.240-5-gba0afff56cd5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 120 runs, 3 regressions (v4.4.240-5-gba0afff5=
6cd5)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-5-gba0afff56cd5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-5-gba0afff56cd5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ba0afff56cd530ec6902c79b8c3d80c2626c379a =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f8af214ec3ad7a6fe4ff421

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-gba0afff56cd5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-gba0afff56cd5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8af214ec3ad7a6=
fe4ff425
      new failure (last pass: v4.4.239-16-g087a494a7e9c)
      1 lines

    2020-10-17 13:29:09.475000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-17 13:29:09.475000  (user:) is already connected
    2020-10-17 13:29:09.475000  (user:) is already connected
    2020-10-17 13:29:09.475000  (user:) is already connected
    2020-10-17 13:29:09.476000  (user:) is already connected
    2020-10-17 13:29:09.476000  (user:) is already connected
    2020-10-17 13:29:09.476000  (user:khilman) is already connected
    2020-10-17 13:29:09.476000  (user:) is already connected
    2020-10-17 13:29:09.476000  (user:) is already connected
    2020-10-17 13:29:09.476000  (user:) is already connected
    ... (457 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8af214ec3a=
d7a6fe4ff427
      new failure (last pass: v4.4.239-16-g087a494a7e9c)
      28 lines

    2020-10-17 13:30:55.656000  kern  :emerg : Stack: (0xcb997d10 to 0xcb99=
8000)
    2020-10-17 13:30:55.665000  kern  :emerg : 7d00:                       =
              bf02b8fc bf010b84 cb8d8a10 bf02b988
    2020-10-17 13:30:55.673000  kern  :emerg : 7d20: cb8d8a10 bf26a0a8 0000=
0002 cb8a6010 cb8d8a10 bf28eb54 cbbed690 cbbed690
    2020-10-17 13:30:55.681000  kern  :emerg : 7d40: 00000000 00000000 ce22=
8930 c01fb3d0 ce228930 ce228930 c0857e78 00000001
    2020-10-17 13:30:55.689000  kern  :emerg : 7d60: ce228930 cbbed690 cbbe=
d750 00000000 ce228930 c0857e78 00000001 c09612c0
    2020-10-17 13:30:55.698000  kern  :emerg : 7d80: ffffffed bf292ff4 ffff=
fdfb 00000025 00000001 c00ce2f4 bf293188 c04070c8
    2020-10-17 13:30:55.706000  kern  :emerg : 7da0: c09612c0 c120da30 bf29=
2ff4 00000000 00000025 c040559c c09612c0 c09612f4
    2020-10-17 13:30:55.714000  kern  :emerg : 7dc0: bf292ff4 00000000 0000=
0000 c0405744 00000000 bf292ff4 c04056b8 c0403a68
    2020-10-17 13:30:55.722000  kern  :emerg : 7de0: ce0b08a4 ce221910 bf29=
2ff4 cbbfd1c0 c09dd3a8 c0404bb4 bf291b6c c095e460
    2020-10-17 13:30:55.730000  kern  :emerg : 7e00: cbc956c0 bf292ff4 c095=
e460 cbc956c0 bf296000 c040617c c095e460 c095e460
    ... (16 line(s) more)
      =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f8af1fae0b4f1aa324ff3e0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-gba0afff56cd5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-5=
-gba0afff56cd5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8af1fae0b4f1a=
a324ff3e7
      new failure (last pass: v4.4.239-16-g087a494a7e9c)
      2 lines  =20
