Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE4628A995
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgJKTPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 15:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgJKTPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 15:15:43 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF02C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 12:15:43 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f19so11393203pfj.11
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 12:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q+By3SMzyuyrJtKAmX7XlOHe5INo8xyzOHlq4UQtGmM=;
        b=yIVosf88vFaO06HlETXA61yT6K1qxFdlirinKe7SoJ5r5xkjQo2tl1JOnFVTCsAsca
         /mV4dx9slA1uNbOwQ00iI3hKhRyI9cZsT6aSdzmynkfGv3IwXqXm5y8FcV60plnFrsDz
         nv7rDPXD6o0KqMyPcweGJDtCs00e16WeQCNRSf+Red4A9uFz9EsxF21E/adr/U5n4lqX
         1NT5vzP+emRVfJ7gnck3QRG6OuO57yL18CzI/Dw54iWnhfN/Ij0HyOLSelESPXylptNA
         NWtk2SSI5jhfbv1AYRscbNnnDWeoyf3xfePUNtnhhUNH4OepBIqsWW3PHW0Tzgpw4+nX
         F4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q+By3SMzyuyrJtKAmX7XlOHe5INo8xyzOHlq4UQtGmM=;
        b=BlYCWOtr46tM1xN6FEv/UckCAVhltuGFfybClfSEqaYnKcb0MzVAVwyYvs1Svkw3iL
         2xl2gfAGWZNa9ZGGYxt3S17EhwfhuE6WXpvxN9QGV5oYN36zLbrBJO6S9xNqO/D9UyVN
         ntq6SIpn/OK3oYAq1YoqYN7GPlqGd9hMIQtNtlIS7q56mNSou9cvQIbX2NkHt4g/KmlA
         /2d9HyoXQBfH39LYS2OFDbVnaoDvr9uCZKizuilUNwEFvl53Of4/C47FLNRSLGethD7I
         l8VmcYfbIADKypBB7jKbIUwjDqbdboYxtG62num4ebLTLlSFTWbm2h26EULXcwJg+kGl
         fYEg==
X-Gm-Message-State: AOAM530A1jORCO/GLjklWqES/m4lGxqjcX9a8vxzB8VV1IErrYsLePjf
        C126kcmmu0t4RExp8f6mHQHkQOR6Ud7RwQ==
X-Google-Smtp-Source: ABdhPJz+6NRYppnZW1re0tQ0A6Ov6EdIEm4EMXmMYWOYOgT8JXrIVB68XwOk5TW65L1MQCP2zmK7Zw==
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr16584920pjj.101.1602443742491;
        Sun, 11 Oct 2020 12:15:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f9sm20046056pjq.26.2020.10.11.12.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 12:15:41 -0700 (PDT)
Message-ID: <5f8359dd.1c69fb81.76b8e.61ce@mx.google.com>
Date:   Sun, 11 Oct 2020 12:15:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.14-35-gd950cb73ff1f
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 132 runs,
 2 regressions (v5.8.14-35-gd950cb73ff1f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 132 runs, 2 regressions (v5.8.14-35-gd950cb=
73ff1f)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig          | r=
esults
----------------+-------+---------------+----------+--------------------+--=
------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig          | 3=
/4    =

odroid-xu3      | arm   | lab-collabora | gcc-8    | multi_v7_defconfig | 0=
/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.14-35-gd950cb73ff1f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.14-35-gd950cb73ff1f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d950cb73ff1f79da97aeedd84f61a996123ec210 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig          | r=
esults
----------------+-------+---------------+----------+--------------------+--=
------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig          | 3=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f82ff294d3ae788d74ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.14-=
35-gd950cb73ff1f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.14-=
35-gd950cb73ff1f/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f82ff294d3ae788=
d74ff3e4
      new failure (last pass: v5.8.14-5-g0b030df1725b)
      1 lines

    2020-10-11 12:46:38.499000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-11 12:46:38.499000  (user:khilman) is already connected
    2020-10-11 12:46:54.394000  =00
    2020-10-11 12:46:54.394000  =

    2020-10-11 12:46:54.409000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-11 12:46:54.410000  =

    2020-10-11 12:46:54.410000  DRAM:  948 MiB
    2020-10-11 12:46:54.425000  RPI 3 Model B (0xa02082)
    2020-10-11 12:46:54.516000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-11 12:46:54.547000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (383 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig          | r=
esults
----------------+-------+---------------+----------+--------------------+--=
------
odroid-xu3      | arm   | lab-collabora | gcc-8    | multi_v7_defconfig | 0=
/1    =


  Details:     https://kernelci.org/test/plan/id/5f832537ab2747d7af4ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.14-=
35-gd950cb73ff1f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.14-=
35-gd950cb73ff1f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f832537ab2747d7af4ff=
3e1
      new failure (last pass: v5.8.14-5-g0b030df1725b)  =20
