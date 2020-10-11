Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC928AAF6
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 00:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgJKWjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 18:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387717AbgJKWjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 18:39:03 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78A9C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 15:39:03 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id u24so12410619pgi.1
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 15:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YTjdmy/9pMYDj3HqTRhrNhNVGKfe3y0tgoXawHqb5ls=;
        b=MDBdqw90jMMAKq5xyJFoGGe+eMYiSszs+VYvfYZMtH6RHaljlcVAEyXez0a/vQz5o+
         9Ek3Q+ynMh0C6xaIQiBhXtkk6dSYPCt8e7m8FZNmKPHDE260rk4qDJH3ALKeSowthPeC
         RCUR9IdMk9j5kbiOQ44m2lsUB5sNQTLVFznC+lIk1LQ5TeXjVBlK9xPPFwqkTbV/PyK9
         TcTsgqq6AOUuC4GnvAX20a7Ex/lukMfWNMDgfPoLUyOK2WIK+cbimuWzITI/5MpuxJNJ
         iBsXoBe5a8OIQroUyf6lHhMHymSALgI0+/ncaTuOCmuuVDPZLc9h9lHjQ86zgCL/UQ1m
         5nbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YTjdmy/9pMYDj3HqTRhrNhNVGKfe3y0tgoXawHqb5ls=;
        b=EDUzR9FIPaU2q8yhZgLTCfbOdjBsryhbEI8f5fle/Rqlp1v5496WDATap1Kuh7HMiS
         snogccAKDAGpmdK52vCIg4SjcaXyesAuPpw1+XK2WQiGv9szCiSy6v4pLtajk2BfFY6S
         Gso9Sm1FKcMJijKY76GkJ7EudQwi0e54BKNu6VxYVKn5J3sZWKgdwJAIvlnfvLLG/inW
         wlXQTF+dU9yVmi6NBdSqh5tG8Sh7O2m62boy//fTAwjXJUPbiBm+NoUSsjDsee3AFwgD
         TpTBU0z/CV1Yr2xRvZaM3W6p4eG6nqazfz39VQ4RrpZoRBstC1Xdyl/d5y33KM8eJNto
         zvXg==
X-Gm-Message-State: AOAM530UVoNWHXr047v2raVISVwUj86menpKwureMWmGET1q5Sigxb5X
        e9msJhTVu1wu2V+6Co1gTX/q7bTzTC74sA==
X-Google-Smtp-Source: ABdhPJyAQkl6W9uwK/g+GE1Dlme6kFuJ+FenMfZA+NyZ1hts+Eghbxo/MXTc/DxeQDqHen37VrjBYg==
X-Received: by 2002:a63:5117:: with SMTP id f23mr11104522pgb.170.1602455942843;
        Sun, 11 Oct 2020 15:39:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d194sm7086083pfd.172.2020.10.11.15.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 15:39:02 -0700 (PDT)
Message-ID: <5f838986.1c69fb81.e0f11.e095@mx.google.com>
Date:   Sun, 11 Oct 2020 15:39:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-29-gceaee0491313
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 90 runs,
 3 regressions (v4.4.238-29-gceaee0491313)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 90 runs, 3 regressions (v4.4.238-29-gceaee049=
1313)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.238-29-gceaee0491313/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.238-29-gceaee0491313
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ceaee0491313d7242c8d53c6306df48bf451d9ef =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f834e1b9068c8b3484ff3eb

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
9-gceaee0491313/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
9-gceaee0491313/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f834e1b9068c8b3=
484ff3ef
      new failure (last pass: v4.4.238-27-g1d9c092d06ca)
      1 lines

    2020-10-11 18:23:40.328000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-11 18:23:40.328000  (user:) is already connected
    2020-10-11 18:23:40.329000  (user:khilman) is already connected
    2020-10-11 18:23:40.329000  (user:) is already connected
    2020-10-11 18:23:52.711000  =00
    2020-10-11 18:23:52.717000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-11 18:23:52.722000  Trying to boot from MMC1
    2020-10-11 18:23:52.911000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-11 18:23:53.151000  =

    2020-10-11 18:23:53.152000  =

    ... (451 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f834e1b9068=
c8b3484ff3f1
      new failure (last pass: v4.4.238-27-g1d9c092d06ca)
      28 lines

    2020-10-11 18:25:27.115000  kern  :emerg : Stack: (0xcb965d10 to 0xcb96=
6000)
    2020-10-11 18:25:27.123000  kern  :emerg : 5d00:                       =
              bf02f8fc bf014b84 cb8d8a10 bf02f988
    2020-10-11 18:25:27.132000  kern  :emerg : 5d20: cb8d8a10 bf2610a8 0000=
0002 cb8a6010 cb8d8a10 bf28eb54 cbcdd390 cbcdd390
    2020-10-11 18:25:27.140000  kern  :emerg : 5d40: 00000000 00000000 ce22=
8930 c01fb3d0 ce228930 ce228930 c0857e48 00000001
    2020-10-11 18:25:27.148000  kern  :emerg : 5d60: ce228930 cbcdd390 cbcd=
d450 00000000 ce228930 c0857e48 00000001 c09612c0
    2020-10-11 18:25:27.156000  kern  :emerg : 5d80: ffffffed bf292ff4 ffff=
fdfb 00000025 00000001 c00ce2f4 bf293188 c04070c8
    2020-10-11 18:25:27.164000  kern  :emerg : 5da0: c09612c0 c120da30 bf29=
2ff4 00000000 00000025 c040559c c09612c0 c09612f4
    2020-10-11 18:25:27.173000  kern  :emerg : 5dc0: bf292ff4 00000000 0000=
0000 c0405744 00000000 bf292ff4 c04056b8 c0403a68
    2020-10-11 18:25:27.181000  kern  :emerg : 5de0: ce0b08a4 ce221910 bf29=
2ff4 cbb9a0c0 c09dd3a8 c0404bb4 bf291b6c c095e460
    2020-10-11 18:25:27.189000  kern  :emerg : 5e00: cbc01a40 bf292ff4 c095=
e460 cbc01a40 bf296000 c040617c c095e460 c095e460
    ... (16 line(s) more)
      =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f834e0d9068c8b3484ff3e0

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
9-gceaee0491313/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.238-2=
9-gceaee0491313/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f834e0d9068c8b=
3484ff3e7
      new failure (last pass: v4.4.238-27-g1d9c092d06ca)
      2 lines  =20
