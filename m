Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A376C5516
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCVTkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjCVTkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:40:01 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966FA57D25
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:40:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l7so2418095pjg.5
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679513999;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OtrZLxdzWTPzd8HoJktDRnEhAk92IbDSRTxY1FEai6Q=;
        b=FuNQ3PhuQ/J4xewvbL0/8AA5vB/hQuW4f70xw0dj+MQofEBJCDot+I0F8xpBsuwiOQ
         zsMYMwyFP6p8bG9ykClWyfShpniPukzh1cEN0fuM3uQ/7Dh6im3PSObFZ9Nylqs/9Ll4
         XndzZFt0VNSYBcigniPT/dVk1EEh4pdJWBfhMIrCJ6UbLz6vkr8hZ7BblwB2sgKzQp7e
         6x3A6Z8BbITB4nWyPSAuVNsY/7ds8bLqhIqPo3JFk8NIdtjgJ0sVU0vcf46cf7KF1B1G
         y4urLrD3yhbrlvHdkp3zPJ1ANdsk98/ELm4F5SO4ibEgYqjwVtDSEd0e60y7tVQBcWEc
         SuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679513999;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OtrZLxdzWTPzd8HoJktDRnEhAk92IbDSRTxY1FEai6Q=;
        b=ic7+jOte4KwKBLkLs6G2QNh0NXSROZcJ1hip7o3ufVfA6rsN14GA8PbSqXUVy0ksef
         iJDfgBHkKjjy7WcnEdRjteXl+UbRyrg2QFXR1LcShsGMJ87sXFL1kkR7X2eXvP9KgZIW
         aHcZXpj6hCI3JumYf6e86GuojO8RusmvZKEcAoz3G0fBDt/LzOq8StyIpUBcSLjVQgiW
         1N7I+sB5FRN/ZDSYysiEYVqF2pwTIAmNc+hPnlr9XSpkt7NWn2ugtjwfcEHEAs4i2ZKj
         osslFPmrGzBPEr0zRLmjgM/ZqMQ1FvKswweiRel/hFlw7DxsyD16iFBCkxYPP2JrRIN7
         MwUg==
X-Gm-Message-State: AO0yUKV8ZJ9wnFTRwnxBJPmUVCcu4p75Hl5FAuoOGjA09ag7fD5u8+bk
        OTZVueT7cQnekUF9n2y4YV3TsSMJQklIu4dCA1YqIw==
X-Google-Smtp-Source: AK7set/CMFuOGbVw7qDeJp57D+Do3KmcEwAv9sXc8sVssFVWX8HY0R1Xh9L/1VnrF6jsDYOCCVBu4A==
X-Received: by 2002:a17:90a:191e:b0:233:76bd:9faa with SMTP id 30-20020a17090a191e00b0023376bd9faamr4983749pjg.47.1679513999668;
        Wed, 22 Mar 2023 12:39:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10-20020a17090a598a00b00233e860f69esm13438669pji.56.2023.03.22.12.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:39:59 -0700 (PDT)
Message-ID: <641b598f.170a0220.7db71.83e2@mx.google.com>
Date:   Wed, 22 Mar 2023 12:39:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176
Subject: stable/linux-5.10.y baseline: 189 runs, 4 regressions (v5.10.176)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 189 runs, 4 regressions (v5.10.176)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
cubietruck        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.176/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ca9787bdecfa2174b0a169a54916e22b89b0ef5b =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
cubietruck        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/641b262ef325ca3dd49c9505

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.176/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.176/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b262ef325ca3dd49c950e
        failing since 62 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-03-22T16:00:10.673894  + set +x<8>[   11.106425] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3435223_1.5.2.4.1>
    2023-03-22T16:00:10.674706  =

    2023-03-22T16:00:10.786448  / # #
    2023-03-22T16:00:10.890760  export SHELL=3D/bin/sh
    2023-03-22T16:00:10.891131  #
    2023-03-22T16:00:10.992127  / # export SHELL=3D/bin/sh. /lava-3435223/e=
nvironment
    2023-03-22T16:00:10.993047  =

    2023-03-22T16:00:10.993595  / # <3>[   11.371052] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-22T16:00:11.095688  . /lava-3435223/environment/lava-3435223/bi=
n/lava-test-runner /lava-3435223/1
    2023-03-22T16:00:11.097237   =

    ... (13 line(s) more)  =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/641b22262885ed47839c950c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.176/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.176/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641b22262885ed47839c9=
50d
        new failure (last pass: v5.10.175) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 2          =


  Details:     https://kernelci.org/test/plan/id/641b26c573a7d1d3069c9525

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.176/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.176/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641b26c573a7d1d3069c952f
        failing since 5 days (last pass: v5.10.174, first fail: v5.10.175)

    2023-03-22T16:03:02.923476  /lava-9733121/1/../bin/lava-test-case

    2023-03-22T16:03:02.934407  <8>[   61.995905] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641b26c573a7d1d3069c9530
        failing since 5 days (last pass: v5.10.174, first fail: v5.10.175)

    2023-03-22T16:03:00.863110  <8>[   59.922220] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-22T16:03:01.886521  /lava-9733121/1/../bin/lava-test-case

    2023-03-22T16:03:01.897540  <8>[   60.958742] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
