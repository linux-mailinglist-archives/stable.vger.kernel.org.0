Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C39453B88
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhKPVUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 16:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhKPVUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 16:20:49 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF717C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 13:17:51 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r132so273549pgr.9
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 13:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ga+fFJn/fhBdu09jJHauzCEPefgC+ZAFG/IRJyq8IZg=;
        b=ByjVs/36ttGG0X/WdPWUxd4IgUr8fuToiJIZqZnCDCmiHgFgPSSN7iDPuegq7ySsGw
         ewDInFKhcbBy/JftoG7Bb33eu346uSpGbqNlLWX/KRNHu0b2SdTkyz3hWpGYpP3L04SE
         Qm/48zoTFU6xzpBz7aT/fGWIrXfBMAkaQvCNUaCo0hyor2Gzc+x5WM0cYhAEvXOMHCNt
         u4m03okmLXsfna6nd9cPMqygSwCkBNcBJcGIrK7dIoF34LpMFFiVy0kllJdJYnb3NSjJ
         YikogsTB7kNl8bqS5PYP0wt8nIo1lPHecsYS3a/2BCKHPkS7csWFDhSF+Jdh+4RMiX7K
         kKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ga+fFJn/fhBdu09jJHauzCEPefgC+ZAFG/IRJyq8IZg=;
        b=jhzKf9s8rtjYPKZS2B1ek36LdUl2xe9bVByO1bNlBuPxc5SkEtC8M2qfvSE8EO6IPH
         nuQ/hq1KZDi8lnDeUNl9FfHnUBeQ+zaPeNIkbUMo3bWwB4lTwBfm/CzOHC7WsHQg8lMS
         /n+oKDW8leb2OYkO8XVVP7tcGRFgiSv9DMaN3f4eRwpwyp4mP7sl7TxtKvmF4BFw3BWO
         65bR3rVDjuLzg/i8Ryitrwkn8k16xApOxyJjw14KdVvfi/zdeDvivGMaVjhYsea6g5hN
         jRiXD2Sgq03UxzI4/xv3ZnDllIz1nKLiLB/di6wc2uWhu2/HrCM2ZPJ+i2q2UJJhq0ok
         nt9g==
X-Gm-Message-State: AOAM531G6zEJ4clOhCBxeINP9jL+OL+2baOjO7kESFkBlkf/SMR5ZSJy
        rVaHGglHuW/eJm2uFBpY10kf9v4gVq08hRLy
X-Google-Smtp-Source: ABdhPJzXCPJlg4IiDjHKakONR1HbpQeBIOjJL52+u2bglfOs2YhM0fmgIlBAjHe6SbLHUYnrTJboCg==
X-Received: by 2002:a63:9142:: with SMTP id l63mr1518981pge.384.1637097471163;
        Tue, 16 Nov 2021 13:17:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9sm10140577pfh.37.2021.11.16.13.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:17:50 -0800 (PST)
Message-ID: <61941ffe.1c69fb81.80445.e5a7@mx.google.com>
Date:   Tue, 16 Nov 2021 13:17:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-200-g9ac4e6b250bf
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 77 runs,
 1 regressions (v4.14.255-200-g9ac4e6b250bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 77 runs, 1 regressions (v4.14.255-200-g9ac=
4e6b250bf)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255-200-g9ac4e6b250bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255-200-g9ac4e6b250bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9ac4e6b250bf3282bac9e3b94f1f5a6937611f24 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193e5ab3e96a92b453358fb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-200-g9ac4e6b250bf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55-200-g9ac4e6b250bf/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193e5ab3e96a92=
b453358fe
        failing since 2 days (last pass: v4.14.255, first fail: v4.14.255-5=
4-gb6f4d599e1d3)
        2 lines

    2021-11-16T17:08:35.908085  [   20.237731] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-16T17:08:35.949305  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-11-16T17:08:35.958453  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
