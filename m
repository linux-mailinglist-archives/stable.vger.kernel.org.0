Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB72732135D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 10:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBVJqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 04:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhBVJpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 04:45:47 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1461C061786
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 01:44:55 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id u26so288426pfn.6
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 01:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ui9e9Yf6rwzcQXusvF+aNkloG0LHp5sKNrgCRQB20g=;
        b=gELeeUQSTKihuHIphJr5JIqFUc30xLoG1sSu71iCj1Me6OSKipXo5QvxEeNvx42xFr
         Bz/cPMqs1bB7Hih3m+m4tRgCHk3A9T9Xuw5n9SX0Qqfqm7ifYPyrtPpl9ly4LZbaFY8h
         8y0pXkjW1ZKtFE8b76cN0LHfunpga/a+8PFtcPVZCFZsHnXYHPQWgxV6xC98/ZuTq5dc
         BQQQ3s0Sm7hA5FowJa3qupMVmwI5qb30kpMLzuIhGF2HtNFxCcHXWa6NOXDhTbxAHPaZ
         RMSpk2PtzK16tPFgP4l/L5jfzY/m+qA54rn17D9zozXpEn8rvTUk8+AOy7DfyU6wnAhn
         wY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ui9e9Yf6rwzcQXusvF+aNkloG0LHp5sKNrgCRQB20g=;
        b=n6NFQS90dx964+gVjeqRU5KfvpE8k6yemcgSPyQPlAXrm4zc+FudxL8dLYp5q1OD1F
         JqMMM+kVhr0Rq6PQROE0Ac5X+acLcf0vs/6nomAbubKZf047ZaQ9PEyiM+JCdwb4kgdi
         bYe5lXEphY0nx1+ysf0a94o5QgPviZU4mL13YMsSKPeON/vEV8ICLK2/I73A5ro3LRXg
         sfxl1LMpDlgRsOBkQ/4bwaFYpXRY3LqGXQcpHhRbKQx/lkfiv1MLso86wNrMfLkmA0tR
         MSDABLQQ82xvM9UQT2BLcLzAQPXtBaZt+TmEUfg0O6CaumGQMRg0N+gxAhAw3DVJZb4s
         1rPA==
X-Gm-Message-State: AOAM533e5/8aahptP5sUbAk57PRFK7PqkS7o0J8EojdKY/lTMCPcUpNi
        teth4c8LXInTwdE+Vst6ELcRXUXSQPASCw==
X-Google-Smtp-Source: ABdhPJwvK2BspLYxoChPJq7NGQzQamQYAespgIq9330AQ3R8CHg/ynFU/UDxdNQ2LLsteM+5ZZ4Xhg==
X-Received: by 2002:a65:6402:: with SMTP id a2mr15401131pgv.438.1613987095037;
        Mon, 22 Feb 2021 01:44:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a24sm18665205pff.18.2021.02.22.01.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 01:44:54 -0800 (PST)
Message-ID: <60337d16.1c69fb81.3e458.8698@mx.google.com>
Date:   Mon, 22 Feb 2021 01:44:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-gd93860ef4f55
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 76 runs,
 2 regressions (v4.14.221-44-gd93860ef4f55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 76 runs, 2 regressions (v4.14.221-44-gd93860=
ef4f55)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-gd93860ef4f55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-gd93860ef4f55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d93860ef4f557fcc62b605e961f99cdcc4089756 =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60334b9b8f4e482e00addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gd93860ef4f55/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gd93860ef4f55/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60334b9b8f4e482e00add=
cb7
        failing since 75 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/603348efd508224bbdaddce2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gd93860ef4f55/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-gd93860ef4f55/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603348efd508224=
bbdaddce7
        new failure (last pass: v4.14.221-44-gb9da7de2c8eb)
        2 lines

    2021-02-22 06:02:19.472000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/98
    2021-02-22 06:02:19.481000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-22 06:02:19.493000+00:00  [   20.518951] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 86:43:aa:da:d1:22
    2021-02-22 06:02:19.500000+00:00  [   20.533081] usbcore: registered ne=
w interface driver smsc95xx
    2021-02-22 06:02:19.528000+00:00  [   20.558044] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
