Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DFC2842F5
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 01:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgJEXd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 19:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgJEXd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 19:33:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B45C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 16:33:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id w21so7926704pfc.7
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 16:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RREQAbekcVCZrKqcMYkQW/NT6LHG+5tb8U1i095yRaQ=;
        b=Pb0jrVYxQZ0ITcxAEvhb5lTR4Wnz26poBVw+jVnavdMk4/hl2zMWcrSJsH+jIFQMGQ
         WA4hX5OenPVGJMdFTAl9k7J5LIYcxqg46mrfTS0p+Gy6YzbeNnowzInD2kmhuSMMQPbQ
         x4U7hX0Ah9poILHqeaDsUq5XmWaoz6POw9F93E2bm8mo25rhT0UbeW3Oj9rg1pdYiE3b
         cOO3ewFEfov+J+HOftL3gzXNKPlJT+0tYWWvh33HqHSouq8tUfJfK4J9DC9B0gECkvM6
         2vsz/Xw+Uj1ePS21AeQouFGcc7DALb7KsP/1gPasTVA/1iF7jeYeJGkMo4uUdCCBOYcg
         ascA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RREQAbekcVCZrKqcMYkQW/NT6LHG+5tb8U1i095yRaQ=;
        b=WZM2+LUiQER/A9Q0ewNDL9VhQab/6laz2pYIhmIRrZgMEa7QERlShE6Gr+vlITsq+S
         Aflc+m6TPoT/2J1ltXCR+Da6Fpap9y28nnOrr6y6P/y1CI9/FehITDhmHz1kgePwpjVG
         jXdja/v3aUJESGIrCWl2gAxh5lQ7LRwgIJmtCmjY3wSaqOlE4KTnJKxifhOmJP7VB7K6
         B/eWBGz/5+nkEBKb5NENB8r82DmKwqDEr22QVDDrtb2MuSmZn58d4FyIi6MHypv0gzhJ
         /JaUS6QI8gFsC1oDO1y6prYSX+iVm8Onpp2U1W6xAGfhP+/ByL6ZwHcY/rraMjeM2ukY
         WgNA==
X-Gm-Message-State: AOAM533pWs6zMtfHJLNJ6FpsZAwVLgZ3xsVvylWSiychglh9/Ee9G4I7
        QaSsx92H9RPIcKrXjsYbFo8kJiQ6+bMJMg==
X-Google-Smtp-Source: ABdhPJzobJlj/CWLkO9D6CfnIUCfivCHOigF46BdMXvdJKn7PtvLwUUoDk1oYwIsyrykKoJncWO28w==
X-Received: by 2002:a63:f807:: with SMTP id n7mr1642283pgh.311.1601940804397;
        Mon, 05 Oct 2020 16:33:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a4sm744217pgl.51.2020.10.05.16.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 16:33:23 -0700 (PDT)
Message-ID: <5f7bad43.1c69fb81.4e2b.1e9a@mx.google.com>
Date:   Mon, 05 Oct 2020 16:33:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.13-86-g8bb413de12d0
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 136 runs,
 1 regressions (v5.8.13-86-g8bb413de12d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 136 runs, 1 regressions (v5.8.13-86-g8bb413=
de12d0)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.13-86-g8bb413de12d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.13-86-g8bb413de12d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8bb413de12d0ad809391ab5a965b0fcf1b9bb3fb =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7b7216dd1836674e4ff46c

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.13-=
86-g8bb413de12d0/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.13-=
86-g8bb413de12d0/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7b7216dd183667=
4e4ff470
      failing since 3 days (last pass: v5.8.12, first fail: v5.8.13)
      1 lines

    2020-10-05 19:18:46.323000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-05 19:18:46.323000  (user:khilman) is already connected
    2020-10-05 19:19:02.603000  =00
    2020-10-05 19:19:02.603000  =

    2020-10-05 19:19:02.604000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-05 19:19:02.604000  =

    2020-10-05 19:19:02.605000  DRAM:  948 MiB
    2020-10-05 19:19:02.619000  RPI 3 Model B (0xa02082)
    2020-10-05 19:19:02.705000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-05 19:19:02.737000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (383 line(s) more)
      =20
