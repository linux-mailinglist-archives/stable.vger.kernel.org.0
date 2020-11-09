Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFB22AB053
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 05:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKIEww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 23:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgKIEwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Nov 2020 23:52:51 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC35C0613CF
        for <stable@vger.kernel.org>; Sun,  8 Nov 2020 20:52:50 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 62so6028776pgg.12
        for <stable@vger.kernel.org>; Sun, 08 Nov 2020 20:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Ru6V711o6URV5rgvsL2Skuzu6PaOHj4A0UuaqjnDpE=;
        b=jo1YPvRA1vyBdimJwCqry4rLNfyx+5D1oDZ0rg7mxSL3uFApOBD8xv/5ZB5UoCbVLa
         VthLxsR8VFv18mS9jn2uSnABRbmo43y/6jCUFAN4IdcstZ8m4krLPn+FD5633zsmXM4V
         z8chgzgfBtBNtD9lNqErOk2RLU9wf66M6In+hkEACIYll+Wie6fVBr4tSqFPuZwJYAZy
         9gbOx8IgnaZ2hmM+vFhLE2Z6WBzBrM+kafhV6qXjL6/yH82o9j6KWTwJy+tlNCDLZH0L
         Tsn9Qgkni97dPvF0kguxEqTPfBRpbseoPcRlinZM+fkjtzlFY2UAeX0coXTX4APIDev1
         ttGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Ru6V711o6URV5rgvsL2Skuzu6PaOHj4A0UuaqjnDpE=;
        b=CQ3vzR7/nfd/x922xKwzAqZgQFnDhsmkhl+q8il3FMhTQRSip+iZGmXkt+MWg2DVdm
         LsjEYSXVWBX5Q55ST6AY2VnZIngB12Lk+7/R8asUzrtBZdppyGKXcmkq1rWujIOO1Oxu
         2z+NKuHQHtUY4+YvAgXdE4NZaxdwBsPr6rMw1K+sKOw89LNOJmTbJbP1n3V17uZyrV7n
         hASepVpeGbLOcvHTU/NQBMcls77mJLNveltWk/9n5h+lHqgSI8F6xIxdRrGgl/tzc6Xe
         4TSDOvpieYwzpKku6UtHhtarG+ghzWE6IQplhbpdmm9ybz/8KnBaMuQb1FEsSqJz3aOF
         VX2Q==
X-Gm-Message-State: AOAM532rWzaCgJstPlIYTl00vXycld3lUjhk6Tjr0EtfcCRTwENixaB7
        ziKWAh1TGJw/nQI59X/gUwEUZ51WqiBJlA==
X-Google-Smtp-Source: ABdhPJxL2bk36DhB8brDDv/V8WxwoKcKG/9o1xSh3dF5yaazBkr8LWnM4haEb0EDj6SggyBIDanSVg==
X-Received: by 2002:a63:4c10:: with SMTP id z16mr11491145pga.440.1604897569613;
        Sun, 08 Nov 2020 20:52:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11sm9605898pfe.80.2020.11.08.20.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 20:52:48 -0800 (PST)
Message-ID: <5fa8cb20.1c69fb81.3a563.4f8e@mx.google.com>
Date:   Sun, 08 Nov 2020 20:52:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-55-g37e579005ca6
Subject: stable-rc/queue/4.19 baseline: 183 runs,
 1 regressions (v4.19.155-55-g37e579005ca6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 183 runs, 1 regressions (v4.19.155-55-g37e57=
9005ca6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-55-g37e579005ca6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-55-g37e579005ca6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37e579005ca66be15a862628136ade3464a58230 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa89a252716d37fdddb8857

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-55-g37e579005ca6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-55-g37e579005ca6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa89a252716d37f=
dddb885a
        new failure (last pass: v4.19.155-45-g6679aabaf3341)
        1 lines

    2020-11-09 01:21:47.727000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-09 01:21:47.728000+00:00  (user:khilman) is already connected
    2020-11-09 01:22:02.920000+00:00  =00
    2020-11-09 01:22:02.921000+00:00  =

    2020-11-09 01:22:02.921000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-09 01:22:02.921000+00:00  =

    2020-11-09 01:22:02.921000+00:00  DRAM:  948 MiB
    2020-11-09 01:22:02.936000+00:00  RPI 3 Model B (0xa02082)
    2020-11-09 01:22:03.023000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-09 01:22:03.055000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =20
