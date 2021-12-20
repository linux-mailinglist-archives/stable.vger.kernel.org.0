Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308AF47B5CE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 23:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhLTWO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 17:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbhLTWO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 17:14:57 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A664DC061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 14:14:57 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 196so6364116pfw.10
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 14:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=obrGFgO5hbJhKgvuLW+5i1mSio8qCZn8vaYFqPkcVrU=;
        b=pQdSbOIbSZQAGDcvC9iTSiUej6MgDhkduJ04YuTFGxiBiLu4UxILqMfoB5hQBADfZW
         suTyuEcDYu//wL2M8HKyRktXhzo/ce2jxIlr2kZO3HcF5qx7pU6zuINYTz2VGsVcY+VF
         fyZZBArUVhoOoc+3RpKuukITVcE5W2Ti5hghwupmtG7DjJxgnee7Yk+gd7THgXlZedtw
         LvUIO3mKNrvENjxqWn31rVracg/ND3jUWIbM1U6IMc4I9MbbHBwDOZNPvUnDXZGCn49E
         pxQSE79bJQAvNGf4EjFXmvHhB2MDsjtnkVr/xtlFP3kJpLDOT+FYVbn/WoaqThQcrNxY
         I+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=obrGFgO5hbJhKgvuLW+5i1mSio8qCZn8vaYFqPkcVrU=;
        b=dyft+9A56UcZ3GPN4L+xknUXgORGnd6aI7Ar+85AP0CeYtAOPpqzn+8InINI2Q8poz
         +cvgUEpt/Jq0rkPnzNMv5PSkqZs+9sqD2z0ihOqxyDjVvrUYtRuBqTJ9dhaV6TWl2Fsn
         DOFr/eGm7g+n90cUhXAirj44SKphqrnxrhWc0pGutShq6lIj/rogdKq+IC6n5ilvMB1E
         bqjrMZFHaKmJQhaRlLT0GzoINDOr/3OlfjVaWXqKdU+I00jZJxDdXSMe/DUpj/RNZvDE
         5grBN0ANAOneVsisp+/FACQfiyJMhKotfv6dUWCeGBdtQm1JhEgdksKKK+9cMwg7uTQ0
         33uA==
X-Gm-Message-State: AOAM530K+8AN4AMVO4eZXE9mBapgrKcK9XPOocGjqWqb+jUeCUbDSPjP
        EyoUGtNto4bazi31pcui1weSjujhI6XplzEn
X-Google-Smtp-Source: ABdhPJxq6WlE7uIkuaoF03LaZh5XOb9KuCG908n95phdRMdMW9ztnKbH9niIPF1qANahX0BkEdyP9w==
X-Received: by 2002:a63:81c3:: with SMTP id t186mr174659pgd.150.1640038497003;
        Mon, 20 Dec 2021 14:14:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17sm20163288pfv.136.2021.12.20.14.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 14:14:56 -0800 (PST)
Message-ID: <61c10060.1c69fb81.14b5e.7e15@mx.google.com>
Date:   Mon, 20 Dec 2021 14:14:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-32-g4578d170efaa
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 114 runs,
 3 regressions (v4.9.293-32-g4578d170efaa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 114 runs, 3 regressions (v4.9.293-32-g4578d=
170efaa)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.293-32-g4578d170efaa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.293-32-g4578d170efaa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4578d170efaaa2f9aa7f8b3de176c7e80a892bed =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61c0ceffa57f6ace21397140

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
-32-g4578d170efaa/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
-32-g4578d170efaa/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c0ceffa57f6ac=
e21397143
        failing since 7 days (last pass: v4.9.292-29-gdefac0f99886, first f=
ail: v4.9.292-43-gad074ba3bae9)
        2 lines

    2021-12-20T18:43:50.760584  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-12-20T18:43:50.769469  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 2          =


  Details:     https://kernelci.org/test/plan/id/61c0e6740179f5a20039711f

  Results:     62 PASS, 7 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
-32-g4578d170efaa/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.293=
-32-g4578d170efaa/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-dp-edp-probed: https://kernelci.org/test/case/=
id/61c0e6740179f5a20039713d
        new failure (last pass: v4.9.293)

    2021-12-20T20:24:07.768785  [   23.511506] hub 2-0:1.0: USB hub found
    2021-12-20T20:24:07.768981  [   23.515279] hub 2-0:1.0: 1 port detected
    2021-12-20T20:24:07.780541  [   23.519928] ehci-platform ff500000.usb: =
EHCI Host Controller
    2021-12-20T20:24:07.789860  [   23.525605] ehci-platform ff500000.usb: =
new USB bus registered, assigned bus number 3
    2021-12-20T20:24:07.790057  [   23.533628] ehci-platform ff500000.usb: =
irq 42, io mem 0xff500000
    2021-12-20T20:24:07.798473  [   23.541366] mmc2: new ultra high speed S=
DR104 SDIO card at address 0001
    2021-12-20T20:24:07.813043  [   23.552377] Bluetooth: Core ver 2.22
    2021-12-20T20:24:07.813240  [   23.553851] mwifiex: rx work enabled, cp=
us 4
    2021-12-20T20:24:07.823500  [   23.554148] mwifiex_sdio mmc2:0001:1: Di=
rect firmware load for mrvl/sd8897_uapsta.bin failed with error -2
    2021-12-20T20:24:07.834914  [   23.554152] mwifiex_sdio mmc2:0001:1: Fa=
iled to get firmware mrvl/sd8897_uapsta.bin =

    ... (48 line(s) more)  =


  * baseline.bootrr.ehci-platform-usb_host0_ehci-probed: https://kernelci.o=
rg/test/case/id/61c0e6740179f5a20039714d
        new failure (last pass: v4.9.293)

    2021-12-20T20:24:07.639504  [   20.293342] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dehci-platform-usb_host0_ehci-probed RESULT=3Dfail>   =

 =20
