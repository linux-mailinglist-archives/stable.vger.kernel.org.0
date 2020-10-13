Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AB228C6BD
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 03:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgJMB3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 21:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgJMB3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 21:29:44 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A87DC0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 18:29:44 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x16so16282641pgj.3
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 18:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NFrhQiVANGgsclG7LVEVxQt4qmtpHBxwJ6wiksaQ15Q=;
        b=jaODu8dCmBqK355EBfHY7hPfDMn7Bjo+axXuKzLcWR905Xnm93hCZhW0oULc0OSGML
         erYvmu4fTmGrF6eLYxCsY9sW9AaECBpVZKLxDoE6fsbs8puwZ24hykBKBbI22JnU/lSa
         C0DLxQgDwUrd2BOWLBiiAOfvOdeJiKi3AFJimfSjkK/ufs+dL/dGTo0vHGTRk7hP2+hf
         n7E1fV3WDTt4imVMsqRKLfEpir2gS4hoQUh+XXYsI/1YLDFILjk9RXVMQ/zjIsYss332
         AunLwRA08ba0xkG0NC/ByAeSZxrWL/EpwJ7GZPYeMUhArjbEfM4XI6ekqezir87mpm1B
         KsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NFrhQiVANGgsclG7LVEVxQt4qmtpHBxwJ6wiksaQ15Q=;
        b=Sh/owud2J4sZSuKUfPYxGc1k5ecFS3DrbrGVGt4VjiG81JsyUonemlQYH/GURRaW+2
         +0l+PvRYx4L6U6oGUBG2iiznSbxE0/XAZWzBmT8qYQRnOR9ASeXYaK/HP+so700aXqcv
         OOtxi2pwLHuG6KBFW0JgffgihsZQcuQaeCsjLIGzVfreXHLTic290k01pEI178m195PO
         yG10dhxT3vZQam34ffcGC+WYiczRR0v/uwKYOiUuWdPp87nFeHz1OhjlA045sodaHfqm
         xgWEeQq0zbMubEP82qx98hZeQRyg01pJ2ZIzB0EdGQUP2YVt2ajh9ftYGhrFwW2rY3Ks
         eyzA==
X-Gm-Message-State: AOAM532uT3tr8DQ1TTmajUq29wKkXA3ZFvJAsWeqPOWbouFtG2WZ3eXO
        o41OiEYaDSLqloLL/MABqsbXkwB0SQzwIw==
X-Google-Smtp-Source: ABdhPJyDM7z7XkqtsOhJk82OB/W41VX9AMFAwLLXVnM7h3o6+C8tAZVr/iLiSetUbKOkbzZ30fykSw==
X-Received: by 2002:a17:90a:dc07:: with SMTP id i7mr22533411pjv.111.1602552583524;
        Mon, 12 Oct 2020 18:29:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kv19sm25892449pjb.22.2020.10.12.18.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 18:29:42 -0700 (PDT)
Message-ID: <5f850306.1c69fb81.374d5.2733@mx.google.com>
Date:   Mon, 12 Oct 2020 18:29:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.238-40-g36437aaa5512
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 96 runs,
 3 regressions (v4.4.238-40-g36437aaa5512)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 96 runs, 3 regressions (v4.4.238-40-g36437a=
aa5512)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.238-40-g36437aaa5512/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.238-40-g36437aaa5512
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36437aaa551298340a942cd706837e40efdae9c3 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f84c77900433ed3ec4ff3e0

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-40-g36437aaa5512/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-40-g36437aaa5512/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f84c77900433ed3=
ec4ff3e4
      new failure (last pass: v4.4.238-39-g4c60248c7a47)
      1 lines

    2020-10-12 21:13:46.825000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-10-12 21:13:46.825000  (user:khilman) is already connected
    2020-10-12 21:13:46.825000  (user:) is already connected
    2020-10-12 21:13:46.826000  (user:) is already connected
    2020-10-12 21:13:58.058000  =00
    2020-10-12 21:13:58.065000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-10-12 21:13:58.069000  Trying to boot from MMC1
    2020-10-12 21:13:58.259000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-10-12 21:13:58.499000  =

    2020-10-12 21:13:58.499000  =

    ... (449 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84c7790043=
3ed3ec4ff3e6
      new failure (last pass: v4.4.238-39-g4c60248c7a47)
      28 lines

    2020-10-12 21:15:32.324000  kern  :emerg : Stack: (0xcb993d10 to 0xcb99=
4000)
    2020-10-12 21:15:32.332000  kern  :emerg : 3d00:                       =
              bf02f8fc bf014b84 cb9aba10 bf02f988
    2020-10-12 21:15:32.340000  kern  :emerg : 3d20: cb9aba10 bf1fb0a8 0000=
0002 cb8a6010 cb9aba10 bf246b54 cbcfd6f0 cbcfd6f0
    2020-10-12 21:15:32.348000  kern  :emerg : 3d40: 00000000 00000000 ce22=
8930 c01fb3d0 ce228930 ce228930 c0857e84 00000001
    2020-10-12 21:15:32.356000  kern  :emerg : 3d60: ce228930 cbcfd6f0 cbcf=
d7b0 00000000 ce228930 c0857e84 00000001 c09612c0
    2020-10-12 21:15:32.365000  kern  :emerg : 3d80: ffffffed bf24aff4 ffff=
fdfb 00000027 00000001 c00ce2f4 bf24b188 c04070c8
    2020-10-12 21:15:32.373000  kern  :emerg : 3da0: c09612c0 c120da30 bf24=
aff4 00000000 00000027 c040559c c09612c0 c09612f4
    2020-10-12 21:15:32.381000  kern  :emerg : 3dc0: bf24aff4 00000000 0000=
0000 c0405744 00000000 bf24aff4 c04056b8 c0403a68
    2020-10-12 21:15:32.389000  kern  :emerg : 3de0: ce0b08a4 ce221910 bf24=
aff4 cbbab540 c09dd3a8 c0404bb4 bf249b6c c095e460
    2020-10-12 21:15:32.397000  kern  :emerg : 3e00: cbcdd500 bf24aff4 c095=
e460 cbcdd500 bf24e000 c040617c c095e460 c095e460
    ... (16 line(s) more)
      =



platform  | arch | lab           | compiler | defconfig           | results
----------+------+---------------+----------+---------------------+--------
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f84c7670273d9c0d94ff3f5

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-40-g36437aaa5512/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.238=
-40-g36437aaa5512/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f84c7670273d9c=
0d94ff3fc
      new failure (last pass: v4.4.238-39-g4c60248c7a47)
      2 lines  =20
