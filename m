Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40FD280266
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 17:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbgJAPSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 11:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732339AbgJAPSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 11:18:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF535C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 08:18:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x123so4795046pfc.7
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 08:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xd3kX257+tYoKo/5L9OIDkJVkbmtDxPGglwHryIThIw=;
        b=zKBc2pyD3OG0rju8VVFKV9tC1lF1Q/JBKNlG5RPIq8VX+7ASirhTeJh9RRT+ivyBqF
         62neu0qmJMPjTeUvvY/wgSQy5d0Eutnr6K5Ce8iQBPvvhjRmbNIvHtKsnf6Arj6UMy51
         w5K1rXb4/z2ynn6eUuc91zYQ/mqIXtSwSBRTiodA47Sckzu161uvVZrKASUOleBVksIp
         uTpmJ0TJoO4/VuosxD6ghcbdtPPg+CT8JT21WZRAb5CxLBbpsS6+87cXkVuW05BNUCHj
         1lAfJ3mQwi8BOM1wpuERlXguRZOxyQFDcIcQHplTmSp5gcPlenSS5Az4wH9XedXm6BmT
         Zhyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xd3kX257+tYoKo/5L9OIDkJVkbmtDxPGglwHryIThIw=;
        b=CaR7Jk5YxJmzxooC7a/Ori0MzN52zX7mOQZIQXR+l312IIkFFXfOp9wvtEr2cw4RrL
         ikgeRujn9X1IhJl1cNDeoQsgtPuxjHP8cb1ot96ep73vE4zraxvXGAz6L/LxhPzTEFq2
         2NKTAIdjzomDdmNViwY76CPWz6xJV+0sZaFnXBvwQdIIH4u8QUh6RDQ3hkbEnJnqIzvY
         1ZUqwbx9LGB72FxPhvAMIXYDfXdbOLTC33hOHpuCo89YEzqAOy7HKRspZiNcS7xIXlUJ
         0DGzPmjcQHDjszyBdYJc2VaYERDyl+CWCFpB7HOWloTh9uCl0wZa3TFWhr/aVPvQCfEG
         B0gQ==
X-Gm-Message-State: AOAM531CrWxDuuEaRDvraoYPXdymZ7h1VaJS0tSWqQ7S66raqf0ZSv55
        OvPnMPNomPol+JwHEPEemRyHf8wncviqUw==
X-Google-Smtp-Source: ABdhPJwHCW1FJ4GJe3jg0rJLAoWM0MfzfPFl0ooGH3ojNF771J1RD0ENj6F+dpZN4PJivfTPjpWsRg==
X-Received: by 2002:a63:2e42:: with SMTP id u63mr6552446pgu.292.1601565511797;
        Thu, 01 Oct 2020 08:18:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z1sm6902981pfj.113.2020.10.01.08.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 08:18:31 -0700 (PDT)
Message-ID: <5f75f347.1c69fb81.c96ff.deae@mx.google.com>
Date:   Thu, 01 Oct 2020 08:18:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y baseline: 107 runs, 2 regressions (v4.4.238)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 107 runs, 2 regressions (v4.4.238)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.238/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.238
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      18f617d6f398c264e3172532a5d3c656f17cecfa =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f75bf8550013d0fe0877177

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.238/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.238/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f75bf8550013d0f=
e087717b
      failing since 19 days (last pass: v4.4.235, first fail: v4.4.236)
      1 lines

    2020-10-01 11:35:50.050000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-01 11:35:50.050000  (user:khilman) is already connected
    2020-10-01 11:36:01.799000  =00
    2020-10-01 11:36:01.806000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-01 11:36:01.810000  Trying to boot from MMC1
    2020-10-01 11:36:01.999000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-01 11:36:02.239000  =

    2020-10-01 11:36:02.240000  =

    2020-10-01 11:36:02.246000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    2020-10-01 11:36:02.246000  =

    ... (450 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f75bf855001=
3d0fe087717d
      failing since 19 days (last pass: v4.4.235, first fail: v4.4.236)
      28 lines

    2020-10-01 11:37:36.922000  kern  :emerg : Stack: (0xcb947d10 to 0xcb94=
8000)
    2020-10-01 11:37:36.931000  kern  :emerg : 7d00:                       =
              bf02b8fc bf010b84 cb94d610 bf02b988
    2020-10-01 11:37:36.938000  kern  :emerg : 7d20: cb94d610 bf2000a8 0000=
0002 cb837010 cb94d610 bf24bb54 cbc05390 cbc05390
    2020-10-01 11:37:36.945000  kern  :emerg : 7d40: 00000000 00000000 ce22=
8930 c01fb3f0 ce228930 ce228930 c0859648 00000001
    2020-10-01 11:37:36.953000  kern  :emerg : 7d60: ce228930 cbc05390 cbc0=
5450 00000000 ce228930 c0859648 00000001 c09632c0
    2020-10-01 11:37:36.962000  kern  :emerg : 7d80: ffffffed bf24fff4 ffff=
fdfb 00000025 00000001 c00ce2e4 bf250188 c0407090
    2020-10-01 11:37:36.969000  kern  :emerg : 7da0: c09632c0 c120ea30 bf24=
fff4 00000000 00000025 c0405564 c09632c0 c09632f4
    2020-10-01 11:37:36.978000  kern  :emerg : 7dc0: bf24fff4 00000000 0000=
0000 c040570c 00000000 bf24fff4 c0405680 c0403a30
    2020-10-01 11:37:36.987000  kern  :emerg : 7de0: ce0b08a4 ce221910 bf24=
fff4 cbb16f40 c09ddba8 c0404b7c bf24eb6c c0960460
    2020-10-01 11:37:36.995000  kern  :emerg : 7e00: cbbdcc40 bf24fff4 c096=
0460 cbbdcc40 bf253000 c0406144 c0960460 c0960460
    ... (16 line(s) more)
      =20
