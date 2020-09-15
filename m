Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC02426B604
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgIOX4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbgIOX4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 19:56:08 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F26C06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:56:08 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id k14so2841704pgi.9
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 16:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5WuydkDbsWmjTCW95J42kzueNrdrNRDWav3C+lSziOA=;
        b=PtJ7Bs8QxawA57H4G3z61asdWjT+e5fSHkbRR43HHkeYwRuL0SL1XZdk9VOwCn0MGZ
         KCEOehvhh2fe1o485YJShniYxhUy/tgCshFRl4B0DyiQYsEjLGg4Ibhfpd+IjJRyfpCF
         u+XsYybYS0mVJuDqeg9EvHYKYUImvfKjSzaO6a70RGZqtXE+Ut9+Z8bo89RrkCXh6AuI
         J1tiPlRCZ4J0rjeJFfaUzuUe3V4mfVwKNM6F5BeDfyzARuo0L55zlVtYYikvaD0My2us
         BBh5t37IrUATEMAor+BPU/O3Fmv4kcw0YTESDx8SBIUSMU/wexfSuAd5oLCe5VZogm/C
         zNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5WuydkDbsWmjTCW95J42kzueNrdrNRDWav3C+lSziOA=;
        b=bHXvancAqPe3vd7YltC8FtoiUPyw9yvl/1S8OoDJbr3p8zTNrl9WQmhB6gr5Wxah0e
         EL4JiXUIehrbYZPF4CCYvmk5ohk6we5Z/3pzWs0hsJgNVjImwjlk+zGV+JFRdS7ygSK1
         Usg7rUNfFS6StpYw3RsWvaHPcn6GrvPeYk0BzV2rzGB2k21wUexN1DnP+ikFik/gYWSs
         ulwygcOINhDqbM3lZyKIarSZgsnlDHi2lWmi21IzUHp3m56pC9wIyREz3cQ/rZhw2jSQ
         WH3RznACVidvI7Ro/NOonL9+EhMzprW/t+5H7C2NwcYLTAZFMQdl23vYHDi/85zjs/Yg
         V5ug==
X-Gm-Message-State: AOAM531iuhSJ0e+BvxPWs8pqY+wbb/Cu5p/gEfhMZbQH2EoKZ2CbRprp
        AZ89DJwCILgzMqWFBjS+ed+HGefiYPb5GQ==
X-Google-Smtp-Source: ABdhPJzdv8zc78dagf9/MH9OnzgMjMwPCNw3feVpY0TaAgOJpej54pkgusJHY/E4265BZq/rmN36Rg==
X-Received: by 2002:a62:8c88:0:b029:13e:d13d:a08b with SMTP id m130-20020a628c880000b029013ed13da08bmr19933854pfd.34.1600214167117;
        Tue, 15 Sep 2020 16:56:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w203sm14520665pfc.97.2020.09.15.16.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 16:56:06 -0700 (PDT)
Message-ID: <5f615496.1c69fb81.3d201.7470@mx.google.com>
Date:   Tue, 15 Sep 2020 16:56:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.236-27-g5ae111cedb9e
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 110 runs,
 2 regressions (v4.4.236-27-g5ae111cedb9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 110 runs, 2 regressions (v4.4.236-27-g5ae111c=
edb9e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.236-27-g5ae111cedb9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.236-27-g5ae111cedb9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5ae111cedb9e9221274e1df7c537dbbc3046478e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f612389a14db6a0bebed96d

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-2=
7-g5ae111cedb9e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-2=
7-g5ae111cedb9e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f612389a14db6a0=
bebed96f
      new failure (last pass: v4.4.236-19-g85b7132c76df)
      1 lines

    2020-09-15 20:24:57.998000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-09-15 20:24:57.998000  (user:khilman) is already connected
    2020-09-15 20:25:09.780000  =00
    2020-09-15 20:25:09.786000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-15 20:25:09.791000  Trying to boot from MMC1
    2020-09-15 20:25:09.980000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-09-15 20:25:10.550000  =

    2020-09-15 20:25:10.556000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-15 20:25:10.560000  Trying to boot from MMC1
    2020-09-15 20:25:10.749000  spl_load_image_fat_os: error reading image =
args, err - -2
    ... (452 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f612389a14d=
b6a0bebed971
      new failure (last pass: v4.4.236-19-g85b7132c76df)
      28 lines

    2020-09-15 20:26:44.638000  kern  :emerg : Stack: (0xcb991d10 to 0xcb99=
2000)
    2020-09-15 20:26:44.646000  kern  :emerg : 1d00:                       =
              bf02b8fc bf010b84 cbb69610 bf02b988
    2020-09-15 20:26:44.654000  kern  :emerg : 1d20: cbb69610 bf2000a8 0000=
0002 cb8ac010 cbb69610 bf24bb54 cbcb07b0 cbcb07b0
    2020-09-15 20:26:44.662000  kern  :emerg : 1d40: 00000000 00000000 ce22=
8930 c01fb390 ce228930 ce228930 c08595ac 00000001
    2020-09-15 20:26:44.670000  kern  :emerg : 1d60: ce228930 cbcb07b0 cbcb=
0870 00000000 ce228930 c08595ac 00000001 c09632c0
    2020-09-15 20:26:44.678000  kern  :emerg : 1d80: ffffffed bf24fff4 ffff=
fdfb 00000022 00000001 c00ce2e4 bf250188 c0406ee0
    2020-09-15 20:26:44.687000  kern  :emerg : 1da0: c09632c0 c120ea30 bf24=
fff4 00000000 00000022 c04053b4 c09632c0 c09632f4
    2020-09-15 20:26:44.695000  kern  :emerg : 1dc0: bf24fff4 00000000 0000=
0000 c040555c 00000000 bf24fff4 c04054d0 c0403880
    2020-09-15 20:26:44.703000  kern  :emerg : 1de0: ce0b08a4 ce221910 bf24=
fff4 cbc337c0 c09ddba8 c04049cc bf24eb6c c0960460
    2020-09-15 20:26:44.711000  kern  :emerg : 1e00: cbceef00 bf24fff4 c096=
0460 cbceef00 bf253000 c0405f94 c0960460 c0960460
    ... (16 line(s) more)
      =20
