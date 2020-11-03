Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7F2A37B0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 01:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKCAZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 19:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgKCAZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 19:25:06 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B656C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 16:25:06 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z1so7679656plo.12
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 16:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dfCqxGPirv36W6B5nkF5EQmVAJnSamRhB9U2Keoe+0c=;
        b=N6sKh6tTnYPz5uxtSRyV2j0DHfLb8YR8zebZ4JUKh17MyiUDoy5QyrJA5XrcZitGh5
         h9x4KI8q9hQ4I8g9nu7L8rVLi1YqMYs75DdTarz3R54SF8BFBEcFZMAZTK0NDzU3JYGP
         oUK7p5QRjYOrcoWrtljIL9jpWZLNQ8jUTAuDyOnEhZA/D3oPRH/Neldw2Ctcb9XFP3AN
         R3M5VbQ7BLu1vyvh7Dv3zASkPNzMWXF1EVpUwF7tDoON9XFXsuxs85iUHfPuEl5B296m
         hYPYWyJj+VnMMYOZ6g9NPNBDZ7+3MTVi24tKVSep31aMAQqy9gvBv/HshsFb1YhZuR4R
         LdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dfCqxGPirv36W6B5nkF5EQmVAJnSamRhB9U2Keoe+0c=;
        b=No7L1N3TS4WJy6yBByVUVnv4DjBiqm5WwEzmaXgeqN/XLN/q1ZOGO6IWqbUwW5nYAH
         HqbaoAFC4CP0yuanzEih7XZAMzneoUBAQrVwiZnPCuhsJSjtxzahAIqQEMAoGpIJddQt
         iUQFCFva1DzrTnAeOG8+QSIPeSVctFjQJSd96v+mVLEV3BnVhIrclddzxByG0rL/c9wK
         D8J6FJnCaY1C3LZLtZKUlhEaqvJhBRpaU5FURlOYCuMtqVV3+3/HvMyj96XdftWg15+W
         yy1OTV8ehfsLSHuH3tQM62Dz+P8vgIhoAeqZhz/YMgxfPsDjc1h3U/S9Ln5z5IWbOMwn
         +8Zw==
X-Gm-Message-State: AOAM530WEGBKH/oww2f3184nZj3nnl17SUf8GSKFmvJEGY/7coWdgGCr
        XPwmAsFJ56+0QdnCyZ+be7VKNJCllWsZdw==
X-Google-Smtp-Source: ABdhPJyxAQOdxPJtFILqK1A08wT/XuFifeusELJa/TzcI5iWsH5zJVOyy/P5KNBlIniLY0c5Jw1csw==
X-Received: by 2002:a17:902:a608:b029:d6:a1fc:ab75 with SMTP id u8-20020a170902a608b02900d6a1fcab75mr16502964plq.18.1604363105299;
        Mon, 02 Nov 2020 16:25:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i26sm5907378pfq.148.2020.11.02.16.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 16:25:04 -0800 (PST)
Message-ID: <5fa0a360.1c69fb81.1ae6f.36f5@mx.google.com>
Date:   Mon, 02 Nov 2020 16:25:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-111-gc4bf20d39cc2
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 2 regressions (v4.19.154-111-gc4bf20d39cc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 2 regressions (v4.19.154-111-gc4bf=
20d39cc2)

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
nel/v4.19.154-111-gc4bf20d39cc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-111-gc4bf20d39cc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4bf20d39cc24fec3475206b062b82624fcd1189 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa0688f7dd8678f163fe80f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-111-gc4bf20d39cc2/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-111-gc4bf20d39cc2/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa0688f7dd8678f=
163fe814
        new failure (last pass: v4.19.154-97-g7cfb7216817b)
        1 lines

    2020-11-02 20:12:10.091000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-02 20:12:10.091000+00:00  (user:khilman) is already connected
    2020-11-02 20:12:25.388000+00:00  =00
    2020-11-02 20:12:25.388000+00:00  =

    2020-11-02 20:12:25.404000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-02 20:12:25.404000+00:00  =

    2020-11-02 20:12:25.404000+00:00  DRAM:  948 MiB
    2020-11-02 20:12:25.420000+00:00  RPI 3 Model B (0xa02082)
    2020-11-02 20:12:25.510000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-02 20:12:25.542000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa0692200d96715a93fe7f0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-111-gc4bf20d39cc2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-111-gc4bf20d39cc2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa0692200d9671=
5a93fe7f7
        new failure (last pass: v4.19.154-97-g7cfb7216817b)
        2 lines =

 =20
