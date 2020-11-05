Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18A02A8ADD
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 00:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKEXmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 18:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgKEXmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 18:42:02 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A85C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 15:42:02 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y7so1561230pfq.11
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 15:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rKA2v53Xal4oHFl5/VSOBnwIysa8lsFZSDXQ0zRDu1I=;
        b=hkjj7El2r3NXzZib+MR5ozTAxnbasZ1LGtDiQ6RzSyqPOI2wXZ+ZgnNCmvlDYi8Rdk
         hVkZy4aiuK5bw1OiHsCBmkqo6IvBWs6SsTLz/flCHmlyFdTJ5IoX2RUa+2482LB0bIwU
         azulVxskUD5p2B4hdsM+rY7/M/3d7kMu5SAXxT9aOuK2YREcF0vwHJPmQgwResHcw320
         kmFo6+XI5QWgKyHiXaADLWjqm6vstDfgEPhiJQ2G+XeipQ+j6Nip4VVEwL8VGbVyks8k
         cdtZdPBJu4K+E/8K8sdUVaGbGijDkGZ80LolQezL8ySJkoNkThu1KyqZARrh3IX724Kx
         CqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rKA2v53Xal4oHFl5/VSOBnwIysa8lsFZSDXQ0zRDu1I=;
        b=sFCNFe+5j+xgt8qgSFPXGc/JKPYdcHyICyVKTZAvcPODpMYuzeXjzIQCg5+aYbjKrz
         A8hos5Vazibq6f/SxCmljmvd9d0Ec/V2rdtTG1zFY+APdau452rlvV26kt0BSmTj7WeG
         H7EQBgFRLmi3ZKnX4Q5fa7IxNUO4cMmo+LrLL8wOaRKIBWyDjfZlIC8+P/W9XY5XxUeS
         O4Rr8ZgVSeUycL4IFMQpr26sJK7F8gy12Fn/k+LWhSXPacWbzzTcnMiTrgic3QrxfTM4
         x8EtivHHsgTCEmtLDxj22O9b2elJnxuBlfzGid3Ze6lyqhaUbrNeG54qA7zpHuSLWjgg
         SZwg==
X-Gm-Message-State: AOAM533tvH6VGIwwV7A4XHm7mcWPvBkKlsi9wNxMwv8YZh8rbHJp92xe
        2uESRc6W4hPEq8vMSiZhBSSkjuKyRnalyg==
X-Google-Smtp-Source: ABdhPJx8/yDZDgAGZCZXE8aiu5JDA2j1K37xByVrDP/Fi3Fjts/XkQJw6doUhfj+1teAkEbSURNkKQ==
X-Received: by 2002:a17:90a:7886:: with SMTP id x6mr4609438pjk.21.1604619721732;
        Thu, 05 Nov 2020 15:42:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm3666130pjc.53.2020.11.05.15.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 15:42:00 -0800 (PST)
Message-ID: <5fa48dc8.1c69fb81.3b6fa.6efe@mx.google.com>
Date:   Thu, 05 Nov 2020 15:42:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.75
Subject: stable-rc/linux-5.4.y baseline: 175 runs, 2 regressions (v5.4.75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 175 runs, 2 regressions (v5.4.75)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.75/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e97ed6efa701db070da0054b055c085895aba86 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa45a69c7331a7e2ddb8853

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa45a69c7331a7e=
2ddb8856
        failing since 4 days (last pass: v5.4.73-49-gbf5ca41e70cb, first fa=
il: v5.4.74)
        5 lines

    2020-11-05 20:00:07.237000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-05 20:00:07.237000+00:00  (user:khilman) is already connected
    2020-11-05 20:00:23.268000+00:00  =00
    2020-11-05 20:00:23.269000+00:00  =

    2020-11-05 20:00:23.269000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-05 20:00:23.269000+00:00  =

    2020-11-05 20:00:23.269000+00:00  DRAM:  948 MiB
    2020-11-05 20:00:23.283000+00:00  RPI 3 Model B (0xa02082)
    2020-11-05 20:00:23.372000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-05 20:00:23.403000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (394 line(s) more)  =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa45c81a0712a4f05db8861

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa45c81a0712a4f05db8=
862
        failing since 9 days (last pass: v5.4.72-55-g7fa6d77807db, first fa=
il: v5.4.72-409-gab6643bad070) =

 =20
