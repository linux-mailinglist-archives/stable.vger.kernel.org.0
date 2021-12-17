Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424D8478DE0
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhLQOfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhLQOfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:35:07 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2894C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:35:06 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v13so2454647pfi.3
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gLTukVKA1rK8GN9qRZ2RY4mbgQbP4+Ao/LY+3Pi6j74=;
        b=lxC9OLneyTu/u/oVLOLVwRgud5s8kpHETLpSWqeLfauMnjXXi/zvLaFjVcF+4SsjiR
         lLUL0bIK00pwswKva6+sbufYlSvAyHw5G9BgtYbghxV+i7u4mGAdgGhftxGJyi/pISuo
         5t5GDcNaJIf8YzVOWvAnzkrYTOJ/3vkdUn4trUuSu5VcvzwpMT3W66gznbUEAxdr0nwM
         kTkk3ZNYB1CCIw9gEHBAGp0y5NJnr3qXhjX0iy1+RBd+/1kD+5ugpe9q4208PRbetmNe
         DC8wJM5AiKFAU2JGIc2faSp3jiau7RYeawLajuPF31am1nqJvY0eo7tfso0/AFVw8j+K
         +Zvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gLTukVKA1rK8GN9qRZ2RY4mbgQbP4+Ao/LY+3Pi6j74=;
        b=tFlxo4Sdw0caAzcXyaOjCRCV5uGlKmmVjHGNmih437Fw0Fn5G3XQpG0b/4h3dM+/YX
         MyzrBbO2Df27SuHWy8ZpZ6UNTaUhpcZGMFsge3IpYkZ2C2x+a2kFNhCjCF0OPRTV3FFD
         8sGHF0qXQHy12QD/YRckxoVt9bE+IpusRcJI39D+k1k6Ma9Xw+scu6DSGJRLPot29hjL
         wOoMnLSm9Izn9OSASmfimsqXQhLt46AHMU9GZzm6mE9HK56p8Q2jslkWcDbePY3VM+be
         EuCgPvG1wpcsLwmdBSnsQ8EaWBrNOZiw/3m1Jid/OiOAAILpTip52C1RFOJih3JWkeGd
         y+BA==
X-Gm-Message-State: AOAM532sYjpW+mkYZjveNj3LrxddXqoJRoZe9CQ9ZCxeOYJCWyaBhd7l
        r9MUqGTr43/X0eeCpYkL1IcudtSFy2LGP63Z
X-Google-Smtp-Source: ABdhPJxjiyhl/C7FsMUNzAW0/Jo0XkVkqmGa+3NqTS7SJieVQ8/z7dzzeJMKDZ86ovg2KTYOqZTmKQ==
X-Received: by 2002:a63:4c61:: with SMTP id m33mr3061141pgl.307.1639751706229;
        Fri, 17 Dec 2021 06:35:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 38sm8566976pgl.73.2021.12.17.06.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:35:05 -0800 (PST)
Message-ID: <61bca019.1c69fb81.9cf9c.768f@mx.google.com>
Date:   Fri, 17 Dec 2021 06:35:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295-5-gf92bc3511348
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 92 runs,
 1 regressions (v4.4.295-5-gf92bc3511348)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 92 runs, 1 regressions (v4.4.295-5-gf92bc3511=
348)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.295-5-gf92bc3511348/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.295-5-gf92bc3511348
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f92bc3511348178c60405309eb87a712ee193f83 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bc6e5dbad822454e39712e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-gf92bc3511348/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.295-5=
-gf92bc3511348/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bc6e5dbad8224=
54e397131
        new failure (last pass: v4.4.295-5-g889544f2e45f)
        2 lines

    2021-12-17T11:02:30.293665  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-12-17T11:02:30.303354  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-17T11:02:30.321241  [   19.024627] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
