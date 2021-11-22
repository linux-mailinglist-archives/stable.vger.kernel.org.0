Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14CA4595D4
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 20:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240258AbhKVUAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 15:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239711AbhKVUAW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 15:00:22 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143DFC061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 11:57:16 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k4so15020856plx.8
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 11:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=joIk6XvF7qtrbzTzsbdJ6wl687VVha04GXYIL4ua6Q4=;
        b=tXhsx4ARZz5K1rIqwKXpFq4sNZMO9DVpygDu5ZBXndmMSz7FFL/6I+6Sjzg2yKHDWw
         lOEfSk4p38YdagjYXlnfewrt91+w8sERtZuBjdBb/NNtMiLKGA5bPpqqgclp2uj1mLmj
         xOJnJyinvxfTCZIxq5JX+kgAxx21Xco2jhtCiHDDny1n9jLvd61lQmMA/BjN6ADsrzkF
         xPQwneh3LYiCROkE1S2xy4arWxDZ/Ey1FB8B7PGITx+6HwbvTkRKQmAyFpqwl9zmc+ys
         UMRF17XWIhHODwTc9sKspYGYaLtpTGZDd2NMf4xxHa4JDYIv6Q0aUHeLovghvqPLOfby
         d+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=joIk6XvF7qtrbzTzsbdJ6wl687VVha04GXYIL4ua6Q4=;
        b=MBsImyc+QaQCA0ioiMMWpo9RNzFDkTCzlC/8BIoWRnkkomTZH4eaL+echsniqCoIXe
         kKOkgLIGaMhVHv5EqSFYmdHJ1IYk51wmkEdziqKNMOWPh5l4YvigO/HdKl5TIs+CtdEp
         ZhjjxaWrW/cE6qD7WgyqhfEQgragGg/5Nt7+3ekQ4+rYQvBzFFVwfKWWUTJ1Z7LgllXL
         wd2TIuwYbi6X31Q9uwKJ9ins3DyUvibKziVojdvF8Q1DwTxyVqDh6xE5fSS3P/qQPoI6
         UNx5fDBeETsUT+8hivedOEbSRdMFg+0+7FK5Ja9f99mElDjm8wDpbTIoOo+EhxdVnpOq
         sUng==
X-Gm-Message-State: AOAM531TCt5jB9BXVq7J0iKBcZu9LTpfAozdZo+yyH8vH8uxPdzPkZf0
        9EAxdz44yN4ajxFcn3efNNt6fzrI2PZfYDAV
X-Google-Smtp-Source: ABdhPJwZVxKOWd/rNv2HI7wxfpXOw7OSJhms+kuntgV0mGCWpU0Z60QJCs6WQOtWbXz0HZLgmxg4BA==
X-Received: by 2002:a17:90a:bb84:: with SMTP id v4mr35330729pjr.4.1637611035503;
        Mon, 22 Nov 2021 11:57:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12sm18842043pjq.16.2021.11.22.11.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 11:57:15 -0800 (PST)
Message-ID: <619bf61b.1c69fb81.2c53b.825c@mx.google.com>
Date:   Mon, 22 Nov 2021 11:57:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 154 runs, 1 regressions (v4.9.290)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 154 runs, 1 regressions (v4.9.290)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab95ef83dddbae37b60263e092d08d5cd2b0059e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618faebb1160764876335906

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618faebb1160764=
876335909
        new failure (last pass: v4.9.289-23-g6ecf94b5fd89)
        2 lines

    2021-11-22T15:48:40.705433  [   20.585174] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T15:48:40.756489  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2021-11-22T15:48:40.766979  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
