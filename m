Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3817D44FA27
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 20:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhKNT2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 14:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbhKNT2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 14:28:05 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3C6C061746
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 11:25:10 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t21so12639685plr.6
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 11:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nnJa3muH4x6iKz++fkcOl3SVfthEHcULsKn+xNB+Vcw=;
        b=RAUBPoP6TEal2iwWJeOrqSMvxAu6bjlQ2yv8rNgNmyNTc+d0M4HFyNLK7YF8NctIh+
         AGO78HsGOsbUwoYMLFbh4hNbdsKtlQrH8BX55sOy+Gm+5nYq3TcX65XriWrvpd+twXuD
         ni5S6nd6djCRWkCuvWBf4kR0Ijrfmz2tK2JAcBHUmPLbni0G8qt29e4/pkR9LHlfUmRj
         QP3ZzrKf/cTsJZuc4tCJRk9+MGaVxiWiFuihjONkI+VflKyyGdIuPQMIO0VWI7DVX9eF
         J39wSNVIaWNFUL4faVc3VGtJ6kzNjKvOiscDyTAlwPb+SxWxfShWK0sKaYoV6vEpQOHs
         2Bpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nnJa3muH4x6iKz++fkcOl3SVfthEHcULsKn+xNB+Vcw=;
        b=vZXi5ISOY0rnEbYX5P5fhRTofV8rKgsmcjChYfNFI6cbV/0XaHotEit2Ke/ZXg8owG
         orTeAjF1fQjJtPaWHTilyc/d/qH+DhBWwFzgwuY4nurqmrXKG/Z1M+5g76TAOlIiQEhJ
         +jRzLkmn3fYZ4+Tpw74dH6r7GX0rW1aKEc4hw+mc7qF+jUGUcm7bjqC0yJE9Hkq+rfbc
         EuYghxHv8VC+g81+QbOOmfOvzGI7eLThxN3MMFYaV84pfsg1//XpsahLuNubc2/87h+S
         TjLPOpGSbv/5BrNJRb4vOKt6fFxr9tfc01B971cL1H1meHdqEwzzyhP2b11Ud5odj/NM
         E8JQ==
X-Gm-Message-State: AOAM532RbRYduKs7jsqEUA5GPka/wlb9v6hp8Oi/Nlp4YfWsPf2Ufc8q
        DccuAhA/vImDjzL3ShSFPczi8Luk9k/F3Zui
X-Google-Smtp-Source: ABdhPJxnjH6wtGowtuzUj5RIRzaEVgA1RCNcPgqW0lLdqf1eN9c0b+QMpQ7+1rTXSu+vt5tRSpOeUw==
X-Received: by 2002:a17:90a:af97:: with SMTP id w23mr39313430pjq.128.1636917909679;
        Sun, 14 Nov 2021 11:25:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g13sm10149606pjc.39.2021.11.14.11.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 11:25:09 -0800 (PST)
Message-ID: <61916295.1c69fb81.8a2ea.e945@mx.google.com>
Date:   Sun, 14 Nov 2021 11:25:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.79-152-g219ed2dcc4f8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 198 runs,
 3 regressions (v5.10.79-152-g219ed2dcc4f8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 198 runs, 3 regressions (v5.10.79-152-g219ed=
2dcc4f8)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =

meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.79-152-g219ed2dcc4f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.79-152-g219ed2dcc4f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      219ed2dcc4f84e1a37a62bc72b6136d6066dc7c7 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/61912f6203da3936673358dc

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
152-g219ed2dcc4f8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
152-g219ed2dcc4f8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61912f6203da393=
6673358e0
        new failure (last pass: v5.10.79-125-ga88e699b068a)
        4 lines

    2021-11-14T15:46:14.745299  kern  :alert : 8<--- cut here ---
    2021-11-14T15:46:14.745815  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-11-14T15:46:14.746059  kern  :alert : pgd =3D (ptrval)
    2021-11-14T15:46:14.746717  kern  :alert : [<8>[   42.452653] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-11-14T15:46:14.746954  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61912f6203da393=
6673358e1
        new failure (last pass: v5.10.79-125-ga88e699b068a)
        26 lines

    2021-11-14T15:46:14.797433  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-11-14T15:46:14.797975  kern  :emerg : Process kworker/1:2 (pid: 74=
, stack limit =3D 0x(ptrval))
    2021-11-14T15:46:14.798218  kern  :emerg : Stack: (0xc2689eb0 to<8>[   =
42.498304] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-11-14T15:46:14.798445   0xc268a000)
    2021-11-14T15:46:14.798663  kern  :emerg : 9ea0<8>[   42.509963] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1072033_1.5.2.4.1>
    2021-11-14T15:46:14.798878  :                                     00000=
000 00000000 00000000 cec60217   =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61912bef6089b7d4873358ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
152-g219ed2dcc4f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
152-g219ed2dcc4f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61912bef6089b7d487335=
900
        new failure (last pass: v5.10.79-125-ga88e699b068a) =

 =20
