Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F694218CA
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhJDU4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 16:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhJDU4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 16:56:16 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2309BC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 13:54:27 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h3so7102105pgb.7
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QPF7zNYf8E05tW5ku/k4Nlsl1bf2PjFwWIenStxFMrs=;
        b=BzLeoe9VebR3W3UiFYd9+8jt4gKKJkgx/rvtfNfNhGekxO5C5HSU770LAdHPDTwS96
         H8/cx04jr0vooPk9lHDC3NEiEhrN1VYArkxcB/el1CTBq7p3tiC0o/J84nILv/1ArTln
         Cu2z6/5vtc0DgJDuZzYd+LTwwh+pQFFez6fBPQkj/zyLp6hPDZ8Yn6IdiHdyWfw/gErr
         wsnHyNBzTJGdop+T8P3c2m5fo9mo0LEkVe+HV7ZVGK0AH5wYula4niVBCQthv6JhqL2v
         c0uEoqCex68eFtj9dGqqW8t8fFb3Xd+RJB0h1IfxlFw49TpyqbTu1F3FeCkRsNxmuN7L
         eZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QPF7zNYf8E05tW5ku/k4Nlsl1bf2PjFwWIenStxFMrs=;
        b=BOIcvY89VLyYskujDB3eKVFoqPqTWhBEktTw21AvH4eqwpDe/C1m8kzsXoylETEAhi
         VBImq++AzQBykASFk7sDWqhGMTEqbUVhGO0OJ8rvB2miPQi5/n01KDwdGhmQgUeSZauM
         oVuCPZkRrw5BwkvVHCLhNwO9TcpWfm0u0nVYoo4u2tkROcuVCcUWgrCJguMVnUGKmQoQ
         HWxTg4E8IPzXoal4740JSMqhx7D1uoC/8LhKZjj13YP6sL45AxNeypDd5jXvvDkPmAV9
         khxgAAWmngGRNOazNmQDwR4rex1OgEaOlDKqw7sT72spayH6ECB37WKzfJwN+52Uu3Az
         XbGg==
X-Gm-Message-State: AOAM5301DoX77SnBmGb/Qrk6fwV6d6ZRDXlWLwmUt7i94iYRl1hW1crz
        AiCFsQeFp6ESDsvzPnMm7ZEBNCmQdBWQRG81
X-Google-Smtp-Source: ABdhPJx/gzMeUJswaHm3CIy+eZwxo5/imLcr+G5V6yruAsrIQWxuFgcMs8p/PRVzgt9HxsT7rB7jEQ==
X-Received: by 2002:a05:6a00:1a01:b0:44c:1ec3:364f with SMTP id g1-20020a056a001a0100b0044c1ec3364fmr18972260pfv.86.1633380866405;
        Mon, 04 Oct 2021 13:54:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d22sm15210001pgi.73.2021.10.04.13.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:54:26 -0700 (PDT)
Message-ID: <615b6a02.1c69fb81.80374.d522@mx.google.com>
Date:   Mon, 04 Oct 2021 13:54:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.150-56-g7a20c2f48815
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 125 runs,
 3 regressions (v5.4.150-56-g7a20c2f48815)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 125 runs, 3 regressions (v5.4.150-56-g7a20c2f=
48815)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.150-56-g7a20c2f48815/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.150-56-g7a20c2f48815
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7a20c2f48815499296505c4dd843cdbfbc8a9200 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/615b4f2a4a1a4435bf99a2dd

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.150-5=
6-g7a20c2f48815/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.150-5=
6-g7a20c2f48815/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615b4f2a4a1a4435bf99a2f1
        failing since 111 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-04T18:59:46.201641  /lava-4642627/1/../bin/lava-test-case<8>[  =
 15.472959] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-10-04T18:59:46.202207  =

    2021-10-04T18:59:46.202745  /lava-4642627/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615b4f2a4a1a4435bf99a301
        failing since 111 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-04T18:59:44.758743  /lava-4642627/1/../bin/lava-test-case
    2021-10-04T18:59:44.777062  <8>[   14.047528] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-04T18:59:44.777476  /lava-4642627/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615b4f2a4a1a4435bf99a302
        failing since 111 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-10-04T18:59:43.740001  /lava-4642627/1/../bin/lava-test-case
    2021-10-04T18:59:43.745182  <8>[   13.027692] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
