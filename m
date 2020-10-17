Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B0D2911FC
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438040AbgJQNXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 09:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436577AbgJQNXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 09:23:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56974C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 06:23:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w21so2701790plq.3
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 06:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0hOBvHOidd1uQtZK+I7MJP5+iCREmtm3L1lYkF+SOqA=;
        b=gZJLhx9Iqc4zHhw76a8Ydr1LKBD0Hhvm0gLf8QzniNnPnxMyRQrDwg0Q2DFU0zHtWy
         n6HKpMJOJAnttIDJ1ci6MjLPD/VN11IodPEQ7l5jVWMC4m38P6bALUVBA954l9BvbhW1
         Rv+oUULvyoG7ZmQMOLR/3aJJC+CT/YHVxXqbA13WHhRWTZ00jvNVhIoHEyPRehx32Tpg
         EnBmnLg/ebE4qMSCBivr3hS4FTWdlNbNxouPr8nS2XIouGjN0Lw8QSSaMYfmAxCnOnpw
         GfV0Ob3nmfuOarplFDvwf2Y0KgEO+7rlsZ31ayGERFepHntzwGLEOigHPPSS9sAi/DvC
         7skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0hOBvHOidd1uQtZK+I7MJP5+iCREmtm3L1lYkF+SOqA=;
        b=bu+3QZG/KWHYqSFNaWifZrkRRvthjOous6Vq0b1i9FU0Ex8BpypXwWLa7iu4PIy7aZ
         ylju1VNHT8ftus4i+Y3MSzXrR3VpD0RNajSJPQRJ8KiFgRPYwEbKiUsuN3fQaCvObcVn
         fkP4pqeZWgR+tGC4JGeUZ2DIJ6AM1xYJtSS0oX2NKRk4ERwWdgCUr0cW9fB1bsVGqP2c
         VJ2goJyuirxMkz6Zfvca+9A/hWXcldnV50eDnH+u55PS5+mkJh15XVkOiN/+Xzquc8Z3
         EiKLR15om35ka+DmuDFsqyELAlHwNgenLGSqDCk6K4lwXOCoF/jUbrvxKAdCJbtOJvYm
         sdIA==
X-Gm-Message-State: AOAM5322ahj9a31wAh+Ro+3Gjt4YMv/2udg05UW/H1ZFdfPooan1sL/8
        Xm4K5pP0p4GKVF+PNWAQdN7pN45fuzX/eg==
X-Google-Smtp-Source: ABdhPJxX93/AVnrV1A2W26e5JJcBtzkaCBzTLNHRIaInKdP7tIS9fGXOtm2c+ANMV+YGRSkCw55jEA==
X-Received: by 2002:a17:902:21:b029:d2:564a:5dc6 with SMTP id 30-20020a1709020021b02900d2564a5dc6mr8932566pla.14.1602941028654;
        Sat, 17 Oct 2020 06:23:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm5641932pff.71.2020.10.17.06.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 06:23:48 -0700 (PDT)
Message-ID: <5f8af064.1c69fb81.1264c.c6d1@mx.google.com>
Date:   Sat, 17 Oct 2020 06:23:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.239-16-gc4bb1b6c44ba
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 121 runs,
 2 regressions (v4.4.239-16-gc4bb1b6c44ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 121 runs, 2 regressions (v4.4.239-16-gc4bb1b6=
c44ba)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.239-16-gc4bb1b6c44ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.239-16-gc4bb1b6c44ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4bb1b6c44baf067d44741c284d079d7a5817dc9 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f8ab82fe832e052794ff3ee

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.239-1=
6-gc4bb1b6c44ba/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.239-1=
6-gc4bb1b6c44ba/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8ab82fe832e052=
794ff3f2
      failing since 0 day (last pass: v4.4.238-39-g1779016429f0, first fail=
: v4.4.239-16-g1d6d5935a9bb)
      1 lines

    2020-10-17 09:22:03.812000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-17 09:22:03.813000  (user:) is already connected
    2020-10-17 09:22:03.813000  (user:) is already connected
    2020-10-17 09:22:03.813000  (user:) is already connected
    2020-10-17 09:22:03.813000  (user:) is already connected
    2020-10-17 09:22:03.814000  (user:khilman) is already connected
    2020-10-17 09:22:03.814000  (user:) is already connected
    2020-10-17 09:22:03.814000  (user:) is already connected
    2020-10-17 09:22:03.814000  (user:) is already connected
    2020-10-17 09:22:03.814000  (user:) is already connected
    ... (457 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f8ab82fe832=
e052794ff3f4
      failing since 0 day (last pass: v4.4.238-39-g1779016429f0, first fail=
: v4.4.239-16-g1d6d5935a9bb)
      28 lines

    2020-10-17 09:23:54.455000  kern  :emerg : Stack: (0xcb977d10 to 0xcb97=
8000)
    2020-10-17 09:23:54.463000  kern  :emerg : 7d00:                       =
              bf02b8fc bf010b84 cb9a9810 bf02b988
    2020-10-17 09:23:54.474000  kern  :emerg : 7d20: cb9a9810 bf2430a8 0000=
0002 cb839010 cb9a9810 bf289b54 cbcc4ed0 cbcc4ed0
    2020-10-17 09:23:54.483000  kern  :emerg : 7d40: 00000000 00000000 ce22=
8930 c01fb3d0 ce228930 ce228930 c0857e78 00000001
    2020-10-17 09:23:54.490000  kern  :emerg : 7d60: ce228930 cbcc4ed0 cbbf=
3c30 00000000 ce228930 c0857e78 00000001 c09612c0
    2020-10-17 09:23:54.497000  kern  :emerg : 7d80: ffffffed bf28dff4 ffff=
fdfb 00000023 00000001 c00ce2f4 bf28e188 c04070c8
    2020-10-17 09:23:54.508000  kern  :emerg : 7da0: c09612c0 c120da30 bf28=
dff4 00000000 00000023 c040559c c09612c0 c09612f4
    2020-10-17 09:23:54.513000  kern  :emerg : 7dc0: bf28dff4 00000000 0000=
0000 c0405744 00000000 bf28dff4 c04056b8 c0403a68
    2020-10-17 09:23:54.524000  kern  :emerg : 7de0: ce0b08a4 ce221910 bf28=
dff4 cbb9b940 c09dd3a8 c0404bb4 bf28cb6c c095e460
    2020-10-17 09:23:54.530000  kern  :emerg : 7e00: cbc22940 bf28dff4 c095=
e460 cbc22940 bf291000 c040617c c095e460 c095e460
    ... (16 line(s) more)
      =20
