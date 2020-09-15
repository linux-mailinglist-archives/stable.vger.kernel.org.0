Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5B269EA1
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 08:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgIOGfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 02:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgIOGfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 02:35:52 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A31C06174A
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 23:35:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id j34so1441454pgi.7
        for <stable@vger.kernel.org>; Mon, 14 Sep 2020 23:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+Fs4ZeznpGm60Fj0sCenmnLEAnI6NhSQDwrtv0OtO5U=;
        b=hR1i7iQUcROdEDuPUOzQwfH5sj8DTo/wySqdR2jKDfRzEl6judCnRiXN3/J8k3g1KS
         tAThggSywtwIxWCRDECXi0ahO8m4YnNClFaBqyzbbExenrUKQXWmQnhXTxKJ+75N6F3V
         xsuGS6YQ0kY1KQeK0wUF9IY9oTcWUKAVCsGB/tPMqurvHMb0id+Q/LGFBT5/TE5UBevt
         l4o/He7H4lGXL+pJADrKobTv2U6EhpvDjZboEN3EH09SCH2VWf/cOUsPLsSE2VEajgcQ
         vq0IZd3DRmnOOhfEJxnxA8VtWpmVYyoVRdf4UTvRbhElwGNeQhHowtiPOGH8/bxhA9P4
         +MgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+Fs4ZeznpGm60Fj0sCenmnLEAnI6NhSQDwrtv0OtO5U=;
        b=Cxmeo1QtPKQV2jSB+9AoAxCW9GuvdEIdg2qX2k6i3ofcsjK5WN4mEQrjL9v4KwT5Ax
         IcA9NRxHMmojPD2qPwBxOseYfmT/NUyFOF0D3igoX2XSFhZABhP6OklG1vnQjaxRZsuV
         jwpB7wRMVHpwl0WAbIGBdU6eX+EAaEzIjm5i8MZRIr3PZrfxp5hg/XusMBhPyuPessdc
         sQlc+klZfTcYsntFCSXQwlUV6hYiaspBdU+Ygv6XjjJBuIfAxTUhbGv9gdLSgWm0aPcU
         PTR1KQbpwKzf0HDmBIRND6r+tt5KOkPB6tiIx7w3JKSfB71Ip6wX7QWQS9CATYMCzcTU
         eiSQ==
X-Gm-Message-State: AOAM533gk5b5+t4DM/k8AZCQE4YM/khqKkTQ2Yry3M6VkdAlXxGnDrUS
        1Q5zuk2rHNchRQhOzLSe33AcGjJ81Xtuqw==
X-Google-Smtp-Source: ABdhPJzdYwBf23BSKiqmSoPZhgxQff+2ybWJC7l6ixsTuwSevWxQoeEqTgRjNF/7pi6NvaFo51/7zA==
X-Received: by 2002:a63:4d56:: with SMTP id n22mr13124732pgl.177.1600151750312;
        Mon, 14 Sep 2020 23:35:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z7sm6828314pgc.35.2020.09.14.23.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 23:35:49 -0700 (PDT)
Message-ID: <5f6060c5.1c69fb81.a76fa.2862@mx.google.com>
Date:   Mon, 14 Sep 2020 23:35:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.145-54-g7a39ee461951
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 173 runs,
 1 regressions (v4.19.145-54-g7a39ee461951)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 173 runs, 1 regressions (v4.19.145-54-g7a39e=
e461951)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.145-54-g7a39ee461951/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.145-54-g7a39ee461951
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a39ee4619519fdd8f40b8f6500fb710f446e336 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f602cfe344e697983a60917

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.145=
-54-g7a39ee461951/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.145=
-54-g7a39ee461951/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f602cfe344e6979=
83a60919
      new failure (last pass: v4.19.145-39-gd737ff1f1723)
      1 lines

    2020-09-15 02:53:04.357000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-15 02:53:04.357000  (user:khilman) is already connected
    2020-09-15 02:53:20.758000  =00
    2020-09-15 02:53:20.758000  =

    2020-09-15 02:53:20.774000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-15 02:53:20.774000  =

    2020-09-15 02:53:20.774000  DRAM:  948 MiB
    2020-09-15 02:53:20.790000  RPI 3 Model B (0xa02082)
    2020-09-15 02:53:20.879000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-15 02:53:20.911000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =20
