Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9172AA6CD
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 18:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgKGRGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 12:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgKGRGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 12:06:35 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C36C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 09:06:33 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id v12so4392472pfm.13
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 09:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9nJl4a/tgq6vOm90pvQ8xd8Rikl0N4TTSnXAztjN4jA=;
        b=HU+HjqnLpC+cxrtz5nBvfr6uxr07apS0X/bTGkNPK0OnE3dRNYL8Cbzw33Wd3t0Fvf
         4QwyKsvIWCj7xWEPmOYZal4SXogTiCJbId9+B2Kh/g7mHvQO+GtHIPZMpq+JmxhCFu9w
         vH48R9EiiKRCTfprCAm2zoGOCUQib4qwpggFZ6iO+Soc9Twg4qbbpSPU2gAt+5WrjkV7
         EYXtL52MFNB3w2dHUZ76UPsT/yCf4KKw9fjHWT23iRPEwsZ1e8JXy1hyB8WymRF8IP17
         TldNPNw+uDs9i8SiltAXq+sQdN/K9gbxBgXmfWJYzNQTboGboRggPqSDJ6dw2kHCKGWm
         iquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9nJl4a/tgq6vOm90pvQ8xd8Rikl0N4TTSnXAztjN4jA=;
        b=moqhyn2rf2d5WUPAw6bGVf1L16Cls/+CSXTF7gWRxnUpYuJQVmauqBfvEDZ80b3D1+
         P5CEXvtpvovIQccPnJ18AJbnDP74B+59HTOXTyA+msS1pfj/qxxGxhJQrz8CuIeqfuuc
         8VOiD/d88oP20d9vO/BoP7a8yia96cnq1bJAEqWWTlFmLVjBJQXsi6GT1E9oVu3OykUI
         JtkWKbnr+hIgF+L5eRlIQ8ClBWMhk1t6APJLD8RgLwj5SapbEPNZThcQZs6KFYwNw11N
         z80qVm7slsDs8LLdoR/mCLcZO9+FzGSCiUEb4SSEf+/8LEi8Atld1uU+v/C/BzOtIO3R
         EPQg==
X-Gm-Message-State: AOAM531klz5VCDEwclbQ9r3o2BBiny9VcHuwY+qGu7x9t6RLMvQP56Ki
        nPVWGESTq0WAfi4TJLc+S5dzP+XJCI5rew==
X-Google-Smtp-Source: ABdhPJxA2HDPTMKG1bz5sBvdMFLlF/653cIY3tOwlxnc/66y5bugUhDJ4AcjkIfgZkkY0pxSgOqmGQ==
X-Received: by 2002:a62:6304:0:b029:164:38fe:771e with SMTP id x4-20020a6263040000b029016438fe771emr6858910pfb.1.1604768792557;
        Sat, 07 Nov 2020 09:06:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m23sm5544303pgk.84.2020.11.07.09.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 09:06:31 -0800 (PST)
Message-ID: <5fa6d417.1c69fb81.54570.a267@mx.google.com>
Date:   Sat, 07 Nov 2020 09:06:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-3-g56d783e7ef1e3
Subject: stable-rc/queue/4.19 baseline: 191 runs,
 2 regressions (v4.19.155-3-g56d783e7ef1e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 191 runs, 2 regressions (v4.19.155-3-g56d783=
e7ef1e3)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-3-g56d783e7ef1e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-3-g56d783e7ef1e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56d783e7ef1e3897dc75b7341c73cf60f5acf175 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa69a3bc21f771b4cdb8881

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-3-g56d783e7ef1e3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-3-g56d783e7ef1e3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa69a3bc21f771b=
4cdb8884
        new failure (last pass: v4.19.155-3-g27b0e9c213a8)
        1 lines

    2020-11-07 12:57:06.032000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-07 12:57:06.032000+00:00  (user:khilman) is already connected
    2020-11-07 12:57:20.779000+00:00  =00
    2020-11-07 12:57:20.779000+00:00  =

    2020-11-07 12:57:20.779000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-07 12:57:20.779000+00:00  =

    2020-11-07 12:57:20.779000+00:00  DRAM:  948 MiB
    2020-11-07 12:57:20.795000+00:00  RPI 3 Model B (0xa02082)
    2020-11-07 12:57:20.882000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-07 12:57:20.914000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa69b5a42c1be3e84db885d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-3-g56d783e7ef1e3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-3-g56d783e7ef1e3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa69b5a42c1be3e84db8=
85e
        new failure (last pass: v4.19.155-3-g27b0e9c213a8) =

 =20
