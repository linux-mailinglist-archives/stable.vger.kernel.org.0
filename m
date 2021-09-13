Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560A7408857
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 11:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbhIMJhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 05:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbhIMJhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 05:37:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC13EC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 02:36:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m21-20020a17090a859500b00197688449c4so6058555pjn.0
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 02:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XzMEa1uPgejn/xVdd81NfoLlttp83bxixjRvpgm0pwM=;
        b=AmA7GjEfoXUyBW70uSKRkEymyswtFtRTT2Y0J+NvUJBIN+Uq0qG8kli1MTaAQlQEGn
         1n9lvHnOIYC9wIGWG+oYHvfXhgvVvAIFXMsdhMtuq+uXiH6UtYsR8E3RagiND2xz7RBm
         Q+fBdQEmWKUo8oLJONHtUKBFKBLaLLRq3UzpFo/iS3oe/Ohvqtq0BNACj0JfxeUbrEdO
         YFodLGOxgTozJc7uJ8wtKy4jAaTAQtaM89Jyl6a6D5qf2MJ8KKhdyHiPtP25+J2FmkvE
         XJir0l+C+AjLUSccLwn2Idy5h8XIOSDk4C2XezppweLuUe89EJQsholSv75PSveGftE/
         pmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XzMEa1uPgejn/xVdd81NfoLlttp83bxixjRvpgm0pwM=;
        b=NI+Declg7rGGZnl1iNrDlizmB3HsdDIRKHFo2LMrQJV7mEFdWeFvXNMPrHJLce8j11
         cjrTp9qgBRH7Ore9Ts9NGuqxJ/FIkCAIHeqT/IMjde3yfZoAO9cYs6HzTnA2huhdaUVx
         bfneO+/vKkDQV2om1OAEpsG6KGEat7eCrARhsUPExgygPAMqf0bC6HjkQQmnUlkffORv
         dT2gKMJo0C/nJQlE4T91wsNOxccm5IxhNl5ZfQfp4IfIkEdk6wGiRPmqUzSCYxf1dVVp
         VtvRtgPE0ZvIS5Nfwbq0Uqh27HwhccqeXloHjUCz2JwHRYKgepKFWXSDIj2yn/P02jye
         MiAw==
X-Gm-Message-State: AOAM532xV01GnDuYgldFiOcQfiorrlEHp9vLZKKJ81+LaKUtYH4/685C
        nWIvCaXRkFb/rT7KmbOoTRIo4b19gv2m1Jdw
X-Google-Smtp-Source: ABdhPJxaX9jRvnwxHHnhQbgLwcoX62S2MV1QLkqtunJhG8U9tFJM7aJgr3wSzHk1d87CVtMbttFCEQ==
X-Received: by 2002:a17:902:d395:b0:13a:25cf:f1c2 with SMTP id e21-20020a170902d39500b0013a25cff1c2mr9696681pld.55.1631525767222;
        Mon, 13 Sep 2021 02:36:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s200sm6473066pfs.89.2021.09.13.02.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 02:36:06 -0700 (PDT)
Message-ID: <613f1b86.1c69fb81.84037.0603@mx.google.com>
Date:   Mon, 13 Sep 2021 02:36:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.16-263-g6cdb0b2e1c97
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 178 runs,
 3 regressions (v5.13.16-263-g6cdb0b2e1c97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 178 runs, 3 regressions (v5.13.16-263-g6cdb0=
b2e1c97)

Regressions Summary
-------------------

platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =

beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =

imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.16-263-g6cdb0b2e1c97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.16-263-g6cdb0b2e1c97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cdb0b2e1c97e37e5a39fc2c1f7a633a0d2fada7 =



Test Regressions
---------------- =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613ee574d767670c68d59680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
263-g6cdb0b2e1c97/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
263-g6cdb0b2e1c97/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ee574d767670c68d59=
681
        new failure (last pass: v5.13.15-22-gd9f9fc203cf9) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
beagle-xm  | arm   | lab-baylibre | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613ee4faeb499a5b4ad5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
263-g6cdb0b2e1c97/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
263-g6cdb0b2e1c97/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ee4faeb499a5b4ad59=
66c
        failing since 3 days (last pass: v5.13.15-4-g89710d87b229, first fa=
il: v5.13.15-6-gd33967f7a055) =

 =



platform   | arch  | lab          | compiler | defconfig           | regres=
sions
-----------+-------+--------------+----------+---------------------+-------=
-----
imx8mp-evk | arm64 | lab-nxp      | gcc-8    | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/613ee83b9a776126f4d596bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
263-g6cdb0b2e1c97/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.16-=
263-g6cdb0b2e1c97/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ee83b9a776126f4d59=
6bc
        new failure (last pass: v5.13.15-22-gd9f9fc203cf9) =

 =20
