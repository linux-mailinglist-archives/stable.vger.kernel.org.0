Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66ABC681786
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 18:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbjA3RYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 12:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbjA3RYQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 12:24:16 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9317835258
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:24:13 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id j20so1705286pfj.0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jx2c1ZF6t+l+eaUwiceA3pcaQrcutUyEMVszmIzwMUw=;
        b=JRzpU49vBY4hVVoZG8qPiO7zMlQnUMpkAtqq2mF3KtNBnPRWSmbs+tru+HS0xTmP7E
         Iw4VhXHOIBncdzPl0HFLWFG1jPSzL657HFiVfcOedm3vYH59LY80Bjycja/5SYuQhnlR
         yXpPlWi8f4H0x3Z9ZEWa6M/2gJggwjBG24aKoHR75ej3biqsCpUF94uoVb0fBy/p5miV
         evjSmLgDI8hPWzWw0mOP3TNGUu6rZsySJs/kJm/rb//vROwAq6ZbfuVKkoZF8mcxJsLZ
         AIC5iU8L07WMoFSlrZvzB0+0P42MzqO6ZRD/XxqQgEH8z8czOPT8u8X58pxgNhJghvNa
         a1VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jx2c1ZF6t+l+eaUwiceA3pcaQrcutUyEMVszmIzwMUw=;
        b=t/HFZ6LIUhftTtPXXoJKQLBvFk2akKCkrRjv90qMpIwIHXqQQWb5HnXOuu1pp2WzQV
         CTJqATRCjaXE7hc/wQacFA8UsNg1CGyOnLGA7wMQytEDGuVUMrA0l226s6zajCcmrZxW
         MoTabT9p4RE/WCvjVWT5uAW2KmD7+zp69PTJyx+S6Qv2YTBvlwxC03e+chyEu8R6fQNr
         QbI1EHL4ndcZ6lZGjyCnbwXlxF9mhMCaoA+3m2Mc0teRbKYioZw7bWNk97EXiSn8hLm4
         PFSKwKsTxR93yFTvRgIi5aVCm9QW+EWl7Rrt04kYckUPZ79yen5w+3ZEj8O9GUpImBSR
         29yQ==
X-Gm-Message-State: AO0yUKVjE/VA7U9zI0C0+tlGnVbiqiq73KGGFubsGIDOAcUfYNUO7DPb
        U2bKeUdCbFhFW47IzN/xEkLWBiO3ONoK0I8BoMmd9Q==
X-Google-Smtp-Source: AK7set+XWHFX6D5CYgQP/VXBg4uznET1oiIfyXIL7CHYLT6RKEV4Vr+3Mw8wMtUTLIJfJDtH8hhtxg==
X-Received: by 2002:a62:7b4c:0:b0:592:3eeb:51d9 with SMTP id w73-20020a627b4c000000b005923eeb51d9mr15666253pfc.21.1675099452733;
        Mon, 30 Jan 2023 09:24:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w22-20020a056a0014d600b0058dbb5c5038sm7654446pfu.182.2023.01.30.09.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 09:24:12 -0800 (PST)
Message-ID: <63d7fd3c.050a0220.ba74a.c359@mx.google.com>
Date:   Mon, 30 Jan 2023 09:24:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-204-g2b5e530f8c37
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 164 runs,
 4 regressions (v5.15.90-204-g2b5e530f8c37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 164 runs, 4 regressions (v5.15.90-204-g2b5e5=
30f8c37)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-204-g2b5e530f8c37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-204-g2b5e530f8c37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b5e530f8c376e2b796066ee157977d773fdf6d5 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7cd19b4d8930009915f3c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7cd19b4d8930009915f41
        failing since 13 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T13:58:35.588406  <8>[    9.854955] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3247845_1.5.2.4.1>
    2023-01-30T13:58:35.699897  / # #
    2023-01-30T13:58:35.804002  export SHELL=3D/bin/sh
    2023-01-30T13:58:35.805264  #
    2023-01-30T13:58:35.907807  / # export SHELL=3D/bin/sh. /lava-3247845/e=
nvironment
    2023-01-30T13:58:35.909021  =

    2023-01-30T13:58:36.011532  / # . /lava-3247845/environment/lava-324784=
5/bin/lava-test-runner /lava-3247845/1
    2023-01-30T13:58:36.013457  =

    2023-01-30T13:58:36.018806  / # /lava-3247845/bin/lava-test-runner /lav=
a-3247845/1
    2023-01-30T13:58:36.108272  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7cd7fa0750bd896915eea

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7cd7fa0750bd896915eef
        failing since 3 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-01-30T14:00:07.757642  / # #
    2023-01-30T14:00:07.860989  export SHELL=3D/bin/sh
    2023-01-30T14:00:07.861812  #
    2023-01-30T14:00:07.965534  / # export SHELL=3D/bin/sh. /lava-892120/en=
vironment
    2023-01-30T14:00:07.966607  =

    2023-01-30T14:00:08.075226  / # . /lava-892120/environment/lava-892120/=
bin/lava-test-runner /lava-892120/1
    2023-01-30T14:00:08.077559  =

    2023-01-30T14:00:08.107561  / # /lava-892120/bin/lava-test-runner /lava=
-892120/1
    2023-01-30T14:00:08.270567  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-30T14:00:08.271174  + cd /lava-892120/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7d38ca65b91349f915eda

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7d38ca65b91349f915edf
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T14:25:16.783508  <8>[   16.102983] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3247443_1.5.2.4.1>
    2023-01-30T14:25:16.909848  / # #
    2023-01-30T14:25:17.019457  export SHELL=3D/bin/sh
    2023-01-30T14:25:17.022110  #
    2023-01-30T14:25:17.128342  / # export SHELL=3D/bin/sh. /lava-3247443/e=
nvironment
    2023-01-30T14:25:17.132045  =

    2023-01-30T14:25:17.237936  / # . /lava-3247443/environment/lava-324744=
3/bin/lava-test-runner /lava-3247443/1
    2023-01-30T14:25:17.242636  =

    2023-01-30T14:25:17.245703  / # /lava-3247443/bin/lava-test-runner /lav=
a-3247443/1
    2023-01-30T14:25:17.314526  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d7c44b138701a1b4915ef8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
204-g2b5e530f8c37/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d7c44b138701a1b4915efd
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-30T13:21:05.259934  + set +x
    2023-01-30T13:21:05.263671  <8>[   16.029673] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 213371_1.5.2.4.1>
    2023-01-30T13:21:05.374415  / # #
    2023-01-30T13:21:05.476911  export SHELL=3D/bin/sh
    2023-01-30T13:21:05.478197  #
    2023-01-30T13:21:05.580366  / # export SHELL=3D/bin/sh. /lava-213371/en=
vironment
    2023-01-30T13:21:05.580985  =

    2023-01-30T13:21:05.682673  / # . /lava-213371/environment/lava-213371/=
bin/lava-test-runner /lava-213371/1
    2023-01-30T13:21:05.683447  =

    2023-01-30T13:21:05.687578  / # /lava-213371/bin/lava-test-runner /lava=
-213371/1 =

    ... (12 line(s) more)  =

 =20
