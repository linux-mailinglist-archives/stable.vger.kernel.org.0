Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F4A273242
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUSxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUSxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 14:53:15 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68523C061755
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 11:53:15 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f2so9835851pgd.3
        for <stable@vger.kernel.org>; Mon, 21 Sep 2020 11:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rN83gcq7m1cRlYxX94bojXWnqIrdzLOrrMGCIscvEz4=;
        b=TtJ4byswsN4LAJ4FrgZ2Wl6jkMBObE+d6sB6YI9TovGPuu42ZImC7wFFCDz8ExeHZA
         B4eZmXqhu2Gq0nB9587bcpRb39k6wFuxozw6N5webn9yj2cWrI+JuesAl63L5MN+V4yX
         hb90awyf8RgPuqtOd9dMGx27nMjHm9aeuEjtY7p0ds9rqRMkHzEjsqcp9BkIdmi9pPtB
         lf1umMLR3KxyEo3EZMxUG/pl+HuAOg1t9SfdhUM1Q8DuDi73S6KTiU+xxz5SDodu+ChX
         WUsFvYxpTv4NHnVMAq6gcYvZ05lFq7r7gMm0l+AUvz4JBAMENZBy6i3DOzMi7rxp09fb
         OFGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rN83gcq7m1cRlYxX94bojXWnqIrdzLOrrMGCIscvEz4=;
        b=hGrsHe1//N3XYHm2eJ/Xr5Ecdm8dgK+F5QEUUzk5cbkALpGpZzsye6XQ5OimVSim4T
         uP1n5+gjDVO7TY8f9+h7iJqcHlURCQL3/lAzcGUhVI+mU7o54ZHAPA4mxUecog/QWcRU
         BE/7ZBkc8twEgO2zlvwByULzUJG0rQocDY6SD/oNQmm6dtk7Fcc4Y+fWvwbJ/wSasi3K
         44yP9AilBzqK2Q3iW/fIdBy3AIuY+YNXcc2rO15oBzNCDiFnBijCqId5gIKjkk84DQ5A
         6qmp3cpsCYy9ZneNcqNrEJ+bwZj/cEemn3rLXLZl2KK6omJ4Otq3loDtc/Hd2Y7b49iH
         5ObQ==
X-Gm-Message-State: AOAM5305GqsyaUQWkrqkP49agFK5d/10QTlglwQxjCaC371G7TGu4Hlv
        tCuM3X2Y25nmJmCbIPpBORNQmrHgReRaGw==
X-Google-Smtp-Source: ABdhPJyFMy9Njv2Y2BnOufv/cjK9eUQRfuBo2xL0R1blnCtYR80RzflT+x2cG+PFsMIgC7MkISz3EA==
X-Received: by 2002:a63:ff07:: with SMTP id k7mr783709pgi.39.1600714394564;
        Mon, 21 Sep 2020 11:53:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x27sm12870628pfp.128.2020.09.21.11.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 11:53:13 -0700 (PDT)
Message-ID: <5f68f699.1c69fb81.1b2f5.e703@mx.google.com>
Date:   Mon, 21 Sep 2020 11:53:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Kernel: v4.4.236-43-gbae349a83c4e
Subject: stable-rc/queue/4.4 baseline: 117 runs,
 2 regressions (v4.4.236-43-gbae349a83c4e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 117 runs, 2 regressions (v4.4.236-43-gbae349a=
83c4e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.236-43-gbae349a83c4e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.236-43-gbae349a83c4e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bae349a83c4e0204e4fb3bb4446b04b9352518bb =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f68be706e541c568fbf9dcd

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-4=
3-gbae349a83c4e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.236-4=
3-gbae349a83c4e/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f68be706e541c56=
8fbf9dd1
      failing since 3 days (last pass: v4.4.236-28-gd232545e8fcc, first fai=
l: v4.4.236-28-g753a2b628a72)
      1 lines

    2020-09-21 14:51:42.689000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-09-21 14:51:42.690000  (user:khilman) is already connected
    2020-09-21 14:51:42.690000  (user:) is already connected
    2020-09-21 14:51:54.679000  =00
    2020-09-21 14:51:54.686000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-21 14:51:54.690000  Trying to boot from MMC1
    2020-09-21 14:51:54.883000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-09-21 14:51:55.120000  =

    2020-09-21 14:51:55.120000  =

    2020-09-21 14:51:55.127000  U-Boot 2018.09-rc2-00001-ge6aa9785acb2 (Aug=
 15 2018 - 09:41:52 -0700)
    ... (448 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f68be706e54=
1c568fbf9dd3
      failing since 3 days (last pass: v4.4.236-28-gd232545e8fcc, first fai=
l: v4.4.236-28-g753a2b628a72)
      28 lines

    2020-09-21 14:53:30.818000  kern  :emerg : Stack: (0xcb95fd10 to 0xcb96=
0000)
    2020-09-21 14:53:30.826000  kern  :emerg : fd00:                       =
              bf02b8fc bf010b84 cb977e10 bf02b988
    2020-09-21 14:53:30.834000  kern  :emerg : fd20: cb977e10 bf1fc0a8 0000=
0002 cb837010 cb977e10 bf247b54 cbcd5a50 cbcd5a50
    2020-09-21 14:53:30.843000  kern  :emerg : fd40: 00000000 00000000 ce22=
8930 c01fb390 ce228930 ce228930 c08595ac 00000001
    2020-09-21 14:53:30.851000  kern  :emerg : fd60: ce228930 cbcd5a50 cbcf=
f2d0 00000000 ce228930 c08595ac 00000001 c09632c0
    2020-09-21 14:53:30.860000  kern  :emerg : fd80: ffffffed bf24bff4 ffff=
fdfb 00000026 00000001 c00ce2e4 bf24c188 c0406ef8
    2020-09-21 14:53:30.867000  kern  :emerg : fda0: c09632c0 c120ea30 bf24=
bff4 00000000 00000026 c04053cc c09632c0 c09632f4
    2020-09-21 14:53:30.875000  kern  :emerg : fdc0: bf24bff4 00000000 0000=
0000 c0405574 00000000 bf24bff4 c04054e8 c0403898
    2020-09-21 14:53:30.883000  kern  :emerg : fde0: ce0b08a4 ce221910 bf24=
bff4 cbce34c0 c09ddba8 c04049e4 bf24ab6c c0960460
    2020-09-21 14:53:30.892000  kern  :emerg : fe00: cbd11180 bf24bff4 c096=
0460 cbd11180 bf24f000 c0405fac c0960460 c0960460
    ... (16 line(s) more)
      =20
