Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D4B2A2A93
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 13:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgKBMSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 07:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbgKBMSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 07:18:52 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4283C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 04:18:52 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w4so408106pgg.13
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 04:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mmuWvPFQ6i/jgGYXodirc8wfjuyXjXWrtEeMm6/9ots=;
        b=1smgJcy1XBhGfl4EIxySUzUeBfkhZORweNA1kfBUNdPOGvoeygby8AUd21gJhyNLBM
         0UIyNKyzv/upnzX3X2ntcgNo3VkFZ+oZfZ2Gj9LZySZ4Irv0rEQ3T1Ee9dN6pIyiYyuU
         Dt8RuPbEtP+SMdFT9OHCC2GT1w4Ut4bDfnfvnShfoBfRE4YP17EhIRXRhCCxZE5Llm3H
         ApWL+x0x7ZJCZf81JjPdVjZgU/gxOFU86hIev4rsBNLl7qKS1if5WnEEYdpxJXM1y8Em
         aKpmnS9y/kxFFQEFcWbjsDueeozb1j+V/rEHsKDO+CRCZaMRSlc54HjnGc0U6GCjS/QX
         gtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mmuWvPFQ6i/jgGYXodirc8wfjuyXjXWrtEeMm6/9ots=;
        b=XePlFrnoJNVansio5vxf+wLTNHzKfK6ezKeh5Y2uEaHKEwvwwkOWPtsN3Qh25YbGO9
         BIxIFRkR3bB4NZqI2hPiXqn3jyBrmcXfDKtfDlj5V8OaaDQDzeacMcYkhWBHx9wVAoA1
         vc9Dg7O0cWV+hJ0R/grkiIEPLBITtOZ05Yxp4z7GRRiJRrd9+PvRIpsfwOeDXrlPE5PC
         m1Ez1p+Vtj+3xpErdAgLXAYmzplaPNGgfpe1i0zZg6hKr7ZGdpDRcFShajxajebvqMOQ
         6MsckXlhjill310kgy7QSZB8/46TN458Xfh5Sh2MrOfYnsY/PT8XC2H0btjjutkxnmeY
         bZpA==
X-Gm-Message-State: AOAM530ZUKb2e3HGemiyAObY3jsKuU8cC5czSLK6eL0wFrKrhRd7yqk/
        XTHzK8W6quTK9res2dSPEtZjtynMc0kxow==
X-Google-Smtp-Source: ABdhPJzL+c8+04ZSoekPbWpn8OxaUgaX4ZD81oMduVdfJoJZlXZ2alWXoIOymnQlrEzLBDWt9xDySA==
X-Received: by 2002:a17:90a:aa85:: with SMTP id l5mr17664238pjq.119.1604319531873;
        Mon, 02 Nov 2020 04:18:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm8172417pfp.40.2020.11.02.04.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 04:18:51 -0800 (PST)
Message-ID: <5f9ff92b.1c69fb81.f70ed.8946@mx.google.com>
Date:   Mon, 02 Nov 2020 04:18:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-82-g6b43b55dd0d7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 204 runs,
 3 regressions (v5.4.74-82-g6b43b55dd0d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 204 runs, 3 regressions (v5.4.74-82-g6b43b55d=
d0d7)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.74-82-g6b43b55dd0d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.74-82-g6b43b55dd0d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b43b55dd0d7bd4aaa47c533661200adbc2b3214 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fc3afb78b22b56a3fe7dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-82=
-g6b43b55dd0d7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-82=
-g6b43b55dd0d7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9fc3afb78b22b56a3fe=
7de
        failing since 4 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fc3a68d06afc6343fe7d5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-82=
-g6b43b55dd0d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-82=
-g6b43b55dd0d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9fc3a68d06afc6=
343fe7da
        failing since 0 day (last pass: v5.4.73-48-g1a794ced991d, first fai=
l: v5.4.73-48-g756e19810764)
        1 lines

    2020-11-02 08:28:20.681000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-02 08:28:20.682000+00:00  (user:khilman) is already connected
    2020-11-02 08:28:36.608000+00:00  =00
    2020-11-02 08:28:36.609000+00:00  =

    2020-11-02 08:28:36.609000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-02 08:28:36.609000+00:00  =

    2020-11-02 08:28:36.609000+00:00  DRAM:  948 MiB
    2020-11-02 08:28:36.624000+00:00  RPI 3 Model B (0xa02082)
    2020-11-02 08:28:36.710000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-02 08:28:36.742000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (377 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9fc90c0413358b9c3fe7f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-82=
-g6b43b55dd0d7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-82=
-g6b43b55dd0d7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9fc90c0413358b9c3fe=
7f7
        failing since 7 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
