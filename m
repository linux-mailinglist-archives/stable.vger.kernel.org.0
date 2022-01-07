Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE85D487E3F
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 22:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiAGV1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 16:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiAGV1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 16:27:38 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09C3C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:27:37 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s1so6488928pga.5
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 13:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xdrK9f4Z/XgG7JWvfoRFe2YrCd5m3RPCpafeo7xeE5Y=;
        b=rJnpKI99aczPVSkLjT850NQwpjKua/y2ATN9+iIW4/UeCv3R3om1x7b1QvgsKQcYmU
         5nA8StWOBOFem7+qms5QaeD2YuEXAvTWZBhEHZWTiNEAvwsoA9U9asg7w5kklvIZ5W0T
         0cOyhvzSI9uG0FRPrfuePcDRpGIqrSy5mfcvR7+5qnJ9weYlGG1BtgUnzQOgU6/PqW0S
         SqgRiIiPLQE/pdTxDZlLLkKjdLgWv7+hD444k6jEWyGqdoFi7xm1XKNph2WnIqypbCeq
         lAA6sWCuS1KEcTXQqTlyOe+8CWSS6IouItDUkmadfvcZQNMaa/Wuaqy3q43g6R/kzeF1
         yE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xdrK9f4Z/XgG7JWvfoRFe2YrCd5m3RPCpafeo7xeE5Y=;
        b=1dwSvYHCHcdk2QAfGHW8oQMtWpKyez/xr6W+9RNrKGNVm73XWAl8QUH885EYVrid86
         On2IlLRfAP0yb4aOHLWT1ukVBMkgCuWseMxRs9TaZe7s/OY+s2QbV0+EYFubRu6gGssb
         Y9s6e2RlTZ5Q+DhmVzpFRxlxH0rvfQXQeHdsUSDBOX3xLG/UVoXnwcDFGdJxQ+p2qj1w
         KEfafS74HZayRG4Z8CFOCyPDqrVOdkktilOKLzAcCShy2qzwiiHGxXVXaKRjt9CNPWBr
         8mb4Dy1C1LrifivZZvpWr1LaI/4XE8413ryjTyMUF3hcgeDgWoZFXdMRKa/SJNJIKWoR
         pvWQ==
X-Gm-Message-State: AOAM531aEwo8ckLCz7JuuJyA2VhUz/cEqn4mvS0TVWuvkjAGGvAuz8/X
        Q1CWqodXgJMN6F5WpbK+LBvPVyTufm17iHqW
X-Google-Smtp-Source: ABdhPJw8FGqYYHYIGIXcx1lrjs5i/XGzQq7UocksoBQebhBXi8PPvkrWBYimevR2hwP1y4tQpR88WA==
X-Received: by 2002:a05:6a00:810:b0:4bb:bdf9:cab9 with SMTP id m16-20020a056a00081000b004bbbdf9cab9mr58263925pfk.35.1641590857331;
        Fri, 07 Jan 2022 13:27:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16sm7431384pfh.88.2022.01.07.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 13:27:37 -0800 (PST)
Message-ID: <61d8b049.1c69fb81.4c680.2677@mx.google.com>
Date:   Fri, 07 Jan 2022 13:27:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-12-g140eb4f8e3bc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 147 runs,
 2 regressions (v4.14.261-12-g140eb4f8e3bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 147 runs, 2 regressions (v4.14.261-12-g140eb=
4f8e3bc)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-12-g140eb4f8e3bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-12-g140eb4f8e3bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      140eb4f8e3bc001a9b99d8edfd4cc60a43c34ba9 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d87cb0bb3fbeebc7ef675e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-g140eb4f8e3bc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-g140eb4f8e3bc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d87cb0bb3fbeebc7ef6=
75f
        new failure (last pass: v4.14.261-7-g0a2b042fe0e2) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d87bd8461c9ced88ef6797

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-g140eb4f8e3bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-g140eb4f8e3bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d87bd8461c9ce=
d88ef679a
        failing since 4 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-07T17:43:33.878997  [   20.206359] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T17:43:33.924123  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2022-01-07T17:43:33.932939  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
