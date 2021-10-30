Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F835440AA3
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 19:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJ3RgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 13:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3RgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Oct 2021 13:36:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37315C061570
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 10:33:36 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id np13so9406751pjb.4
        for <stable@vger.kernel.org>; Sat, 30 Oct 2021 10:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KhkiMYGd4kyb8u6src2QtTSMK/hBSxJXIXIcB5/ZG9g=;
        b=UvyhGJPHtAw+y+cfRYk93ja3k9REMkzZX7s7FxF/ZwSl1NrWnXzAEDupFcUWIIfdKQ
         u4SdVI/SIpbz4gB2yJAYDU9ROV5Qb83svKiJ6pT9y1l0rdwzxWFDJ7u38ueYG4mvkLw0
         7ApO9p6qmLdXBbAJzQlKZPyQqqNVn5GufJHbGH5rhXCXsdRG/2TnBsekGSuS95fuoaXP
         ZcA8c9Z5OBGDWeBVjUWGAru1zc0wVYMg9VqZ1JJlx6alrZtlODCZDfipqLGgPm3953L7
         2klCgP7zUg5wIvsMPdDYrgtB1VJOV1PzNUFIZ88vu7Y+Kp5ah3K3+QQ8jkf3NZZdbwM4
         qQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KhkiMYGd4kyb8u6src2QtTSMK/hBSxJXIXIcB5/ZG9g=;
        b=YgvVNYmhjWZfjtq2D2HTlWP9RbzIFyBA0yPvcAvExHneTUxwvTJJeLO3RnRUvMiPhn
         AVD2m99nnw7p45Q3Dqr24YJRVdN/pT/h7TI6yh3CHxH4cRU+lTnTz51bZqA9pVB362Ly
         ijAfd2wGz/IrnE0HuCQMmfexvo10lOLHx4jcOmExLYY/uP74mNtYmHfiMmFwDb1/tpSG
         r35XQKrxl4C/aUwCz477Pa3CZPmA5G0Ycn8H9DQ2lm6mS4AJdRP8HQHYM0AGrdsYIMBI
         PdI6Vy5bcBDqdBlIJgk9Ad7kXflj+NAp3m6MX6tzvZB92a6H5dBjO5lQ2tWwwOjALJ9R
         FnIQ==
X-Gm-Message-State: AOAM532Quca7iaOuLmlq6rzVneZla+fKOPjJaZ4YhxeWFgdteUOM0B0z
        rl6j3nn8XJPrYa8J38ect6D3Ftllju+Vw2e9
X-Google-Smtp-Source: ABdhPJzo/XTu0ymib86YGnDpayLIgeLJQMdaCqdj11ud6v7LkEmwUDHqKO3MvHPeL14qmhGmXEQxPA==
X-Received: by 2002:a17:902:ec8e:b0:141:da55:6158 with SMTP id x14-20020a170902ec8e00b00141da556158mr147545plg.7.1635615215609;
        Sat, 30 Oct 2021 10:33:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm9602572pji.45.2021.10.30.10.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 10:33:35 -0700 (PDT)
Message-ID: <617d81ef.1c69fb81.f2a4a.b153@mx.google.com>
Date:   Sat, 30 Oct 2021 10:33:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.290-15-g2a82217a1115
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 97 runs,
 1 regressions (v4.4.290-15-g2a82217a1115)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 97 runs, 1 regressions (v4.4.290-15-g2a82217a=
1115)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.290-15-g2a82217a1115/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.290-15-g2a82217a1115
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a82217a1115123823180a9aa609b5bc9730971b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617d503d22954ea1f63358e3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
5-g2a82217a1115/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.290-1=
5-g2a82217a1115/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617d503d22954ea=
1f63358e6
        new failure (last pass: v4.4.290-9-g87e26bdcfc0f)
        2 lines

    2021-10-30T14:01:13.981203  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2021-10-30T14:01:13.989934  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-10-30T14:01:14.010463  [   19.182006] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
