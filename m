Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3602A3D708E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 09:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhG0Hqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 03:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhG0Hqt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 03:46:49 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97694C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:46:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e14so14861639plh.8
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rDIn2y3BnmWb2XeDUCtivddkh9JmonD8mz0xrxtuIjo=;
        b=OCM56yKEAzRdtLw8f9FaO5HmzsfHmGKzanydrXwGzQFzEatkRhdf1BRqWchMIu5xLu
         nFu1Kzi9mcKwlcxPMMzNZhPDoVrW2THl1dBoS6SpIsBuWMqY6ahd31NSsCykD3Yg4zwC
         q5adg4R/Ly6/lKVutlfcp6b7kl7jWDY/OtdZd+7DsghQ+6PJraR7oVNVloWOfIxTf2ds
         IarlfPvkgTMSnc/tCRQNzeL8v+x0oXMsm6drGLiRiFwqtspEVuWoM064EJszZ2qnCP/H
         LJPstKyVtfj5FV56/XtDSDHpT3B/zukTGAECvNDWCPgG+w9irKP550wupxHLHiiMPGWs
         8vxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rDIn2y3BnmWb2XeDUCtivddkh9JmonD8mz0xrxtuIjo=;
        b=ED38Xmz5pibMj+eC9zMqdzBwos0YtHDoNkle8cODQO389TA7R1tMoxFT7T6jSBmL8y
         6uumXp8CzBVzMLbxuOhotNrewm2ZlP/ae3jnOBisQQPmmTBxxF2G8YslC4N5+7Dll9mr
         5ia9PEWODoniD28YZa9hS0IaXhuwcMQCGvneWSmTbsEbkSrKWU6wG1+AUguAuZI9JOPf
         iKXQoIY9NDaLz9LSBvLoAERC6bFf03EJ11uIw9jYUQ2Bqq8y+7Npg4y3WVzu+/QcTapz
         B4iwBX6XRGW4KDbbj+Ae3Amdx/RCaV1yKGoJWk8141QQuE9PkMw7fp/Tn/DXdtWLotXj
         fOUQ==
X-Gm-Message-State: AOAM532c7oLLgzHnyfP3o1Paobae08eZhpDxaNBuoqHKVqDm0pVkH2AG
        YXJUMLBDz/RIlR1TlTsrQhAPHK+jpyLHeufj
X-Google-Smtp-Source: ABdhPJwKpZbp6rYRvF+DNzzFkmdWie09/6WT3ENmHB7ckVSVI+RaczEUlOSBYz9oIdnuvGLIdfrwJQ==
X-Received: by 2002:a17:90b:a4c:: with SMTP id gw12mr1552524pjb.187.1627372008998;
        Tue, 27 Jul 2021 00:46:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u21sm2407189pfh.163.2021.07.27.00.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 00:46:48 -0700 (PDT)
Message-ID: <60ffb9e8.1c69fb81.25956.8437@mx.google.com>
Date:   Tue, 27 Jul 2021 00:46:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.5-224-g6b468383e8ba
Subject: stable-rc/queue/5.13 baseline: 105 runs,
 3 regressions (v5.13.5-224-g6b468383e8ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 105 runs, 3 regressions (v5.13.5-224-g6b4683=
83e8ba)

Regressions Summary
-------------------

platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig        =
  | 1          =

d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =

imx8mp-evk | arm64  | lab-nxp      | gcc-8    | defconfig                  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.5-224-g6b468383e8ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.5-224-g6b468383e8ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b468383e8baa8fe9622bc4af971566a940a9df5 =



Test Regressions
---------------- =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff829a90cd34142d3a2f35

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g6b468383e8ba/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g6b468383e8ba/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff829a90cd34142d3a2=
f36
        failing since 12 days (last pass: v5.13.1-804-gbeca113be88f, first =
fail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
d2500cc    | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-chromeboo=
k | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff8da3c50d9b91483a2f5c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g6b468383e8ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g6b468383e8ba/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/ba=
seline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff8da3c50d9b91483a2=
f5d
        failing since 15 days (last pass: v5.13.1, first fail: v5.13.1-782-=
ge04a16db1cc5) =

 =



platform   | arch   | lab          | compiler | defconfig                  =
  | regressions
-----------+--------+--------------+----------+----------------------------=
--+------------
imx8mp-evk | arm64  | lab-nxp      | gcc-8    | defconfig                  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff830e8e26648c8d3a2f23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g6b468383e8ba/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.5-2=
24-g6b468383e8ba/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff830e8e26648c8d3a2=
f24
        new failure (last pass: v5.13.3-506-geae05e2c64ef) =

 =20
