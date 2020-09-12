Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A6C267C6B
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 23:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgILVDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 17:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgILVDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 17:03:36 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD65C061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:03:35 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id t14so8673260pgl.10
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HH00ze0B4aDyHfi+1iA5DlZX/WAMvwYywlcKEm+6Wyc=;
        b=d9WBGytbnCDOx+dBKJ7Oin5Wl94e1cuO0HaPic9eLsJdgZCtyjyKaA/T1QifXu6o/I
         B546UTg1dbBEVCsNbkxZepYfXiGCqPpmTG7pDW8EdCH12nJugoQQGtKM9FUdXbw64vQW
         pPhuexx1dd3KKTAYW0xDq7EohCoE9eJ+055T3+JYeGWaaaubgepgPMcuFVF/BXiAp0aj
         VGgGfjO7Aug5FwFpAtVo8nJvrYO0GjAsi045m7OcffLIQPrVc2hiM2+xLIMkI0VCfiG7
         eBc3e7QyahXBIqkfK511DbCuJL90ujk8CLYDYdD6xHNULChyRqpAuyITruxyk3B6B/kW
         KpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HH00ze0B4aDyHfi+1iA5DlZX/WAMvwYywlcKEm+6Wyc=;
        b=aOYMpFq+eL30ON36IspaUJTCiRjE0ykM1FRkIGM7nNLGgpZSA7d4zCE4EoSOD7QWEB
         USt6TGaTycumszPeMNJEQEfpawjBrpbQOdKmXGJ+UtisNBrJK/xB8BsaJo6DBaMAYcrF
         vMzRuRGrbMEjNJCYhxx8C6yFHKdqgH9pzAuLPAuYTaeEVGLLUgMkTS8moWNYdiP1m4Ff
         ydmsdSYecjP3NzzLxY26mylqIiiVxmKdMedwRH7Nv2TLJVNPDWBZfsmrdc/G8NXmZPb4
         ynx8dLPUNPf7U94zczT8seD/6rawkVk0BL5BqKGaQ4eFmpfrgYcwtv0LrSlrcEsRYwPY
         o6zA==
X-Gm-Message-State: AOAM533GcVul5mwl20yXIKPSFAyHhv+XcRXOlvnoUtVcydMQSf6x/yID
        WSYvzNXLJuKdgVEAUZzf8avApWoucJz3Bg==
X-Google-Smtp-Source: ABdhPJykUTa3qiQkgicvs2MSS2yd1N8zmFpgzDqdQy7wi9qMpp7v3Hr9OnTMpX10LY56Upj00cnRKg==
X-Received: by 2002:a05:6a00:808:b029:13e:d13d:a05d with SMTP id m8-20020a056a000808b029013ed13da05dmr7251592pfk.35.1599944613153;
        Sat, 12 Sep 2020 14:03:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm5944356pfh.151.2020.09.12.14.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 14:03:32 -0700 (PDT)
Message-ID: <5f5d37a4.1c69fb81.372b0.f6d7@mx.google.com>
Date:   Sat, 12 Sep 2020 14:03:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.236
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 110 runs, 2 regressions (v4.4.236)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 110 runs, 2 regressions (v4.4.236)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.236/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.236
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42b5f72fbe6b5f9c63207f3f6152673c6c9af451 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | results
----------+------+--------------+----------+---------------------+--------
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1/4    =


  Details:     https://kernelci.org/test/plan/id/5f5d03873da1022f0aa60914

  Results:     1 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.236=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.236=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5d03873da1022f=
0aa60916
      new failure (last pass: v4.4.235-63-g5a444641713b)
      1 lines

    2020-09-12 17:19:20.815000  Connected to omap3-beagle-xm console [chann=
el connected] (~$quit to exit)
    2020-09-12 17:19:20.815000  (user:) is already connected
    2020-09-12 17:19:20.815000  (user:) is already connected
    2020-09-12 17:19:20.816000  (user:khilman) is already connected
    2020-09-12 17:19:20.816000  (user:) is already connected
    2020-09-12 17:19:32.167000  =00
    2020-09-12 17:19:32.174000  U-Boot SPL 2018.09-rc2-00001-ge6aa9785acb2 =
(Aug 15 2018 - 09:41:52 -0700)
    2020-09-12 17:19:32.178000  Trying to boot from MMC1
    2020-09-12 17:19:32.367000  spl_load_image_fat_os: error reading image =
args, err - -2
    2020-09-12 17:19:32.608000  =

    ... (452 line(s) more)
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f5d03873da1=
022f0aa60918
      new failure (last pass: v4.4.235-63-g5a444641713b)
      28 lines

    2020-09-12 17:21:06.350000  kern  :emerg : Stack: (0xcb97bd10 to 0xcb97=
c000)
    2020-09-12 17:21:06.359000  kern  :emerg : bd00:                       =
              bf02b8fc bf010b84 cbcd1610 bf02b988
    2020-09-12 17:21:06.366000  kern  :emerg : bd20: cbcd1610 bf21e0a8 0000=
0002 cb89a010 cbcd1610 bf24bb54 cbbe4390 cbbe4390
    2020-09-12 17:21:06.374000  kern  :emerg : bd40: 00000000 00000000 ce22=
8930 c01fb390 ce228930 ce228930 c0859628 00000001
    2020-09-12 17:21:06.382000  kern  :emerg : bd60: ce228930 cbbe4390 cbbe=
4450 00000000 ce228930 c0859628 00000001 c09632c0
    2020-09-12 17:21:06.391000  kern  :emerg : bd80: ffffffed bf24fff4 ffff=
fdfb 00000025 00000001 c00ce2e4 bf250188 c04079f8
    2020-09-12 17:21:06.399000  kern  :emerg : bda0: c09632c0 c120ea70 bf24=
fff4 00000000 00000025 c0405ecc c09632c0 c09632f4
    2020-09-12 17:21:06.408000  kern  :emerg : bdc0: bf24fff4 00000000 0000=
0000 c0406074 00000000 bf24fff4 c0405fe8 c0404398
    2020-09-12 17:21:06.416000  kern  :emerg : bde0: ce0b08a4 ce221910 bf24=
fff4 cbb9e140 c09ddba8 c04054e4 bf24eb6c c0960460
    2020-09-12 17:21:06.423000  kern  :emerg : be00: cbc53b80 bf24fff4 c096=
0460 cbc53b80 bf253000 c0406aac c0960460 c0960460
    ... (16 line(s) more)
      =20
