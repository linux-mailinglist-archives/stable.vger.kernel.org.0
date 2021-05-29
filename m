Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEFA394B08
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 10:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhE2IH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 04:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2IH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 04:07:56 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEA3C061574
        for <stable@vger.kernel.org>; Sat, 29 May 2021 01:06:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f8so3857626pjh.0
        for <stable@vger.kernel.org>; Sat, 29 May 2021 01:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s+jKq5CoRNf7RKCrBCeRzt/Lfojakniq1JcUJrT3N00=;
        b=N082kkUw7gacvPPntv1KbTvkl0u960OBeqUlBB/O/uXwwljDVcTeqLqd9+kPz1XqWt
         mbxYG8S09SRjeZl0CfHzYlGbS46w78HD4HFKrT2GJr/VB/BIct4wYP785lKkQtMx/iPR
         jGhy4kh32VYgrThMI62r5BqXis/K4tw2VsTG5x15iMFJDmRgGkO/uQqZoSimhbTnRWmu
         1p00Arn+ECKcp5tR8EKhLXCHu5qciWtY74bqJD2JxthOsT0ZAiUIKhvySJ8gZh+4wqoA
         DUlGLDMww6kZTld/GdNCLEgyt2bTP2+VDNo64+C/LqKlJbQ4LDfJNkj7hSrk4UZeLiXM
         yJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s+jKq5CoRNf7RKCrBCeRzt/Lfojakniq1JcUJrT3N00=;
        b=lFL/yfweSIobl+md1VhvAogpsOAIcXMMeyG9GTHGC2QGy6UwVWuid1vEHA6paRFv9e
         LfOnLLCq50DajaMlYcDLvWXn7/FWIDiADnx5Y6tCoA7O7eIImdCN2MF7CBYatc1ICjWD
         LdYev54KBktk6Kj5sZw2u8qWxao2FSxdHyBAl76znGQGMOGfOCV9qkHKeAGTdHhwtdpE
         FrVvTnxesuG8jo9Sh6QRwzmMmVShxiF2SXuJA/C+zP1IVKxi7flGS5j4l9YM3nkrLtUQ
         lvxC62CYO0Gp5Hokd13d4Y+WSV1b3i+Mez5BRoe4lt4SnDxjtW7x+J5XX/DBnkhHz6QD
         yhvA==
X-Gm-Message-State: AOAM530hTBRp4pRR6oedyLd55OM+0zyy6prXmfELMQFNGghb//LWwkpd
        lhG6kmics8qZps7xiOIURgJ/yffKnsz3HekL
X-Google-Smtp-Source: ABdhPJwZUCkdMYKxILzAmGn3MQzwPT3eiKRavCqSY0EsSD+VrtCTINRX4THT1MwrqyYZ39tCxRIPNA==
X-Received: by 2002:a17:90b:4a11:: with SMTP id kk17mr8985453pjb.124.1622275579009;
        Sat, 29 May 2021 01:06:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w63sm1067341pfw.153.2021.05.29.01.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 01:06:18 -0700 (PDT)
Message-ID: <60b1f5fa.1c69fb81.e86d9.34b4@mx.google.com>
Date:   Sat, 29 May 2021 01:06:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-7-g252aaf0d38df
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 197 runs,
 4 regressions (v5.12.7-7-g252aaf0d38df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 197 runs, 4 regressions (v5.12.7-7-g252aaf0d=
38df)

Regressions Summary
-------------------

platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
imx6sll-evk      | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =

imx6sx-sdb       | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =

imx6ul-14x14-evk | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =

imx8mp-evk       | arm64 | lab-nxp | gcc-8    | defconfig          | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-7-g252aaf0d38df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-7-g252aaf0d38df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      252aaf0d38df5f3db47fcc797acdd2719543715c =



Test Regressions
---------------- =



platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
imx6sll-evk      | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60b1c58fabb891916ab3afbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sll-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1c58fabb891916ab3a=
fc0
        new failure (last pass: v5.12.7-6-g71f64ab23af6) =

 =



platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
imx6sx-sdb       | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60b1c58bb3c46cac82b3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1c58bb3c46cac82b3a=
fc2
        new failure (last pass: v5.12.7-6-g71f64ab23af6) =

 =



platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
imx6ul-14x14-evk | arm   | lab-nxp | gcc-8    | multi_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60b1c588abb891916ab3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1c588abb891916ab3a=
fbb
        new failure (last pass: v5.12.7-6-g71f64ab23af6) =

 =



platform         | arch  | lab     | compiler | defconfig          | regres=
sions
-----------------+-------+---------+----------+--------------------+-------=
-----
imx8mp-evk       | arm64 | lab-nxp | gcc-8    | defconfig          | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60b1bfe2d1390d548ab3afd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-7=
-g252aaf0d38df/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1bfe2d1390d548ab3a=
fd8
        failing since 2 days (last pass: v5.12.6-124-ga642885de2c1, first f=
ail: v5.12.6-127-g3e985cc005fd) =

 =20
