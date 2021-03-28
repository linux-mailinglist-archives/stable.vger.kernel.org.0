Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A7734BBFC
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhC1KSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 06:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhC1KSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 06:18:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE11C061762
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 03:18:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h20so3016977plr.4
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 03:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HAl60JWYSVL4HIoILakDOqrFaBSC2tY/Lwzp2wQDuow=;
        b=mQHBQh62ERAJPUROhaUZRRDMNMD1N+8J5bbXJBK28ZW3c3JbcVzDiJSfS1qy5IvV+m
         zvXaa5mv+FqEEGRmFNZLOZFhml9h/ZkzCda31wMZlZy0udrrr0X1dri6LcpfHbeOzmxG
         c61dJ7/v3n7D70b0DiOVUbSQjEECKfqDkcETnfSFiPFSmsTddRfG2qT/BVqXg3yA/NGs
         3YbaODVlkjiLV2amsmZmfr5p9EVeRMivvs7UPxZNvuH9flWQqsT6HuJcuxEj8+S2xkYq
         uT79eaOWXaJYeOoL5Tb08oFgmfK/ryZQAs9hueu3ARrAn91ORwAomqgKq5af1sQSHUf0
         wMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HAl60JWYSVL4HIoILakDOqrFaBSC2tY/Lwzp2wQDuow=;
        b=LG8o80CxmEpr3MHptAh8AWMhqW37fDSTdlLceskDsiGKAJ9QypTZjw88KB13J6oPAE
         1HEl5FG79Yc6YHGSUrEW/k5uN2KGprsDfG/GR94faZgg7YiwLkkmyEhwcY66Z15leXlV
         Cuh8jtrVdrRiat2q7L/0fzLSbmfp5+fdtrFPBrYk+292DjaHxemmyLFtA4HgzvcFqpU/
         kEgsY/dX+zWCndGMHFLwPyw4UcHeyBKNm6lRc2gOMZMIDPx6x8+UsS9zvOqeQer9Rdxw
         7p+atxdjHGho8ebKL6wisY+xTUJ7zP8+Q06uQ8oUORYI512PjBDr3wos0YqXNSWb4IAJ
         7TGg==
X-Gm-Message-State: AOAM533q2tZr00WGlBa5d2b73wFPt6F5oZfwPVK7OHC56dzRE/IaBX+/
        rIMR5HaztLBY3/+IfCd5DGYYrrm8MRv2xQ==
X-Google-Smtp-Source: ABdhPJxZVC1IhG36hLZV195ZVReFXlUi5N6S4ZFu4obbPLSVllcyWLU3UD+YSW7/teAoc4NWaOuHdw==
X-Received: by 2002:a17:90b:94c:: with SMTP id dw12mr21577277pjb.119.1616926690292;
        Sun, 28 Mar 2021 03:18:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f65sm6651629pgc.19.2021.03.28.03.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 03:18:09 -0700 (PDT)
Message-ID: <606057e1.1c69fb81.335ca.fbad@mx.google.com>
Date:   Sun, 28 Mar 2021 03:18:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-195-ge081b1bfa89f5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 150 runs,
 3 regressions (v5.10.26-195-ge081b1bfa89f5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 150 runs, 3 regressions (v5.10.26-195-ge081b=
1bfa89f5)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =

meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-8    | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-195-ge081b1bfa89f5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-195-ge081b1bfa89f5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e081b1bfa89f581b7bf4771bbf6df7d87e5fbcd3 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
imx8mp-evk           | arm64 | lab-nxp      | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6060211751600df54aaf02cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
195-ge081b1bfa89f5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
195-ge081b1bfa89f5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6060211751600df54aaf0=
2d0
        failing since 1 day (last pass: v5.10.26-56-g525a07fb82ba, first fa=
il: v5.10.26-61-gc7b7b08c4bb5) =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-8    | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/60601fba8606d8e139af02db

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
195-ge081b1bfa89f5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
195-ge081b1bfa89f5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60601fba8606d8e1=
39af02e0
        new failure (last pass: v5.10.26-90-ge291d8cd10776)
        1 lines

    2021-03-28 06:16:30.829000+00:00  Connected to meson-g12b-odroid-n2 con=
sole [channel connected] (~$quit to exit)
    2021-03-28 06:16:30.830000+00:00  (user:khilman) is already connected
    2021-03-28 06:16:43.574000+00:00  =00G12B:BL:6e7c85:7898ac;FEAT:E0F8318=
0:2000;POC:F;RCY:0;EMMC:0;READ:0;CHK:1F;READ:0;CHK:1F;READ:0;CHK:1F;SD?:0;S=
D:0;READ:0;0.0
    2021-03-28 06:16:43.574000+00:00  bl2_stage_init 0x01
    2021-03-28 06:16:43.575000+00:00  bl2_stage_init 0x81
    2021-03-28 06:16:43.618000+00:00  hw id: 0x0000 - pwm id 0x01
    2021-03-28 06:16:43.618000+00:00  bl2_stage_init 0xc1
    2021-03-28 06:16:43.618000+00:00  bl2_stage_init 0x02
    2021-03-28 06:16:43.618000+00:00  =

    2021-03-28 06:16:43.618000+00:00  no sdio debug board detected  =

    ... (668 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60601fba8606d8e=
139af02e2
        new failure (last pass: v5.10.26-90-ge291d8cd10776)
        2 lines

    2021-03-28 06:18:10.420000+00:00  kern  :emerg : Code: f9401bf7 17ffff7=
d a9025bf5 f9001bf7 (d4210000<8>[   45.364086] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-03-28 06:18:10.421000+00:00  ) =

    2021-03-28 06:18:10.421000+00:00  + set <8>[   45.373605] <LAVA_SIGNAL_=
ENDRUN 0_dmesg 41761_1.5.2.4.1>
    2021-03-28 06:18:10.421000+00:00  +x
    2021-03-28 06:18:10.526000+00:00  / # #   =

 =20
