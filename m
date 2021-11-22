Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A202458887
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 05:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhKVEGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 23:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhKVEGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 23:06:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D4C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 20:03:07 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso14111266pjb.2
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 20:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3rRiGTPIQg1A9juZh8tc/PNrXvUttZZZh5Hgz3/Ip1M=;
        b=48HyISC4o6ZrJpqAiLu9+SZZY3A1YA61/k/NCH39TkOswH6zVnaDZcr8X6/4B6vm6p
         9HDPoBcsSc9vO63ud3Mnd2f2Jkmr+/OmBNvsxUGYRpa82RxNh8bFm/wdfYYiwzolV/Jx
         vdnglZfSymBDarsLT2vM2kOGXpaQ2NRlUcLcdyF+KLRHW/j671cYGfXzn2i9tcaje/Aj
         CsEXMkU6q2osXZHn4/Qhdh/cTsr5eknx89PunNdomtKxxOQmbyKEb/pH/aygNUvXovU2
         bfsFxK3onECkkcxoDABzBWlbGl9QwEyd/Lcs01r57yGk9sN7XT8C1z9WlhDqYtQxUfaR
         voUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3rRiGTPIQg1A9juZh8tc/PNrXvUttZZZh5Hgz3/Ip1M=;
        b=lwp+8h0z679UFLv3q7dSLZTcdGAVKLIA9cRHMrm+lzPZ+SdCcdUcehNABLlgGKCCEl
         fB8VXERLRr28W25w0h3r2wDWyNjQWZ+UnFU0B9pBoebpxkdpN7b+sgmVlQuPKn6f9mTi
         hauBxJKDTFWN4qY6AMvRgr6rl765w+AsnBElqO+dZkHIoj4bGwzdzoBC8CYKo+3hlgwP
         F5zoBntp2oIaETMCGOXslmjPjwKcp1oUvM3VkQ+zUch6A5HbEUnBUGYpKHol5aKgHMyi
         zrxMnoi9u77BhMpAzRoFI0Rl2faA5frE1KEbFbwNoh+qaTI8GuilIYet0dn7MR2C4C15
         jIlg==
X-Gm-Message-State: AOAM530oBZXIsabQiUS8h66UkxMpXWnVlZkGn3SXOVD83oL+/dRB4cJB
        WT+SEH+K7OIAhfO08gMJlLKWn2LbnKfhaSYr
X-Google-Smtp-Source: ABdhPJws+yZGT0SPi3TXHVKd04BBrqZ/HPm0qDxDDIfF7IQnxDpNnWPTiNeQue4hTF1tRuFiDVOVhw==
X-Received: by 2002:a17:902:d2c7:b0:142:f06:e5fa with SMTP id n7-20020a170902d2c700b001420f06e5famr103416414plc.87.1637553786362;
        Sun, 21 Nov 2021 20:03:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm7462871pfh.82.2021.11.21.20.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 20:03:06 -0800 (PST)
Message-ID: <619b167a.1c69fb81.3ee3d.5f2d@mx.google.com>
Date:   Sun, 21 Nov 2021 20:03:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.292-140-g1794f2b1b0d51
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 122 runs,
 1 regressions (v4.4.292-140-g1794f2b1b0d51)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 122 runs, 1 regressions (v4.4.292-140-g1794f2=
b1b0d51)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-140-g1794f2b1b0d51/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-140-g1794f2b1b0d51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1794f2b1b0d5189b2d0a6c34db1755b9cf2ca725 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619add9c742431dddbe551c7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
40-g1794f2b1b0d51/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
40-g1794f2b1b0d51/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619add9c742431d=
ddbe551cd
        new failure (last pass: v4.4.292-116-gc13aef2ca259)
        2 lines

    2021-11-22T00:00:04.510863  [   19.309295] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T00:00:04.556593  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-11-22T00:00:04.565360  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
