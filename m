Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A89F4D0C56
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 00:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiCGX5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 18:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343959AbiCGX5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 18:57:50 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F25DE098
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:56:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m22so15593702pja.0
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 15:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S0kzPI20v4Liv13PHZ7dsqJs+QlGGaSKpvPUsJvjzag=;
        b=4KUsnnKgEP9krECB9GTbnLozbPTtab1rQXRojG18qMfp58vEcfzLsTEZTdS95p8Olz
         EK/CmjuNmR231rHynuuFPPTeINqmhNLm/PU01L/1FQifdxZbeHjLedRegMTW//KWyiAD
         v2azmxyR2z3nCjhK8d87i/LtrrXw6GT+InWhbs/eD3uRfM9QZbF6f7UOhWR+uWMmAlEE
         8tQfkWDB32luQlO/QDQUKJNJ4H25iyMFqBG6x9P4Abjum2TuTmqPloWV0hY59Rq/XwTt
         4kkzDH8HHRp2mWUfyM9WpZF6cyNT88mN3Tto8jkXab1U2KURJmZbGB6TKOyl+VJzVoCO
         nAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S0kzPI20v4Liv13PHZ7dsqJs+QlGGaSKpvPUsJvjzag=;
        b=25ygxE3crgzj8OkaCOB+1tolBjCh0XlKYOZMh8iQzmmGj4qfMW3r/mN8bIbYvgWmO8
         3v7is0+L/HkF4V/db9RMrXGzqkuH+8JDd5GMio3WCYGLweJfmFzw1lYtVP3d94M5D7Jp
         wb6ALg7evIJ9r2F84kEUgMPLmXmrTmpQNyxksI6aWsXnXUhZqZfBCNMX3R88D9RwLk1X
         gCytltFiEBrMns+gT/+SOMzQqjy0Ni3Hoq5lPpW1rJLMDRVqGNYdAcN3vGIpCn5cIuYP
         JC60vtV9TE3ATsXGSFcxQASl5Dqw6ND0TVGV0wX1NqtbFqTvOEorRY6mnGGGG5YeXe9C
         Ix5A==
X-Gm-Message-State: AOAM53179HnELd0C3TclS8Qg3RedBYLcXSc0w9QDxqhTcJU+15dkzy45
        vwqg0qi/M8gxCXiJ4H/jEsYDdejOOwq0eGC6qU4=
X-Google-Smtp-Source: ABdhPJyfaY0vzJd5Ml2qFvg+9q7ApzJNGyZz24uInFWUSF2cgUUQySyHX5ew+kfRGm1Ech8NfT5vLg==
X-Received: by 2002:a17:90b:3a8e:b0:1bf:7fb5:af06 with SMTP id om14-20020a17090b3a8e00b001bf7fb5af06mr1612148pjb.7.1646697414351;
        Mon, 07 Mar 2022 15:56:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j16-20020a63e750000000b00373598b8cbfsm12725429pgk.74.2022.03.07.15.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 15:56:54 -0800 (PST)
Message-ID: <62269bc6.1c69fb81.60c5a.0ba2@mx.google.com>
Date:   Mon, 07 Mar 2022 15:56:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.182-65-g5aabde525ba7
Subject: stable-rc/queue/5.4 baseline: 83 runs,
 2 regressions (v5.4.182-65-g5aabde525ba7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 83 runs, 2 regressions (v5.4.182-65-g5aabde52=
5ba7)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
meson-gxm-q200   | arm64 | lab-baylibre  | gcc-10   | defconfig            =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.182-65-g5aabde525ba7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.182-65-g5aabde525ba7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5aabde525ba7e106feb1a768e9ec3dd78b472dc3 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
meson-gxm-q200   | arm64 | lab-baylibre  | gcc-10   | defconfig            =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62266e7cde060a42ecc629a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-6=
5-g5aabde525ba7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-6=
5-g5aabde525ba7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62266e7cde060a42ecc62=
9a5
        failing since 1 day (last pass: v5.4.182-53-ge31c0b084082, first fa=
il: v5.4.182-53-gb54ccf4e0b7c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622664c7afeaac1554c6296e

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-6=
5-g5aabde525ba7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.182-6=
5-g5aabde525ba7/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622664c7afeaac1554c62994
        failing since 1 day (last pass: v5.4.182-30-g45ccd59cc16f, first fa=
il: v5.4.182-53-ge31c0b084082)

    2022-03-07T20:02:01.215385  <8>[   31.703669] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-07T20:02:02.227187  /lava-5830692/1/../bin/lava-test-case   =

 =20
