Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0EF4E6A8C
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 23:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355276AbiCXWQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 18:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiCXWQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 18:16:59 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B64A1441
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 15:15:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s72so4932692pgc.5
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 15:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cV/jdOLEFuNXKfqQUO2pS597nCwnmDVmSVZXRg5DK6c=;
        b=Td5BPhMFiRujmVnkIaVx/GRRugR3rucU7JbNpzuYN+oX2M5HjefGETeiIoohSU4C8z
         LofLKeQoZRUH7uZ0k/H/qZ/owUXQT7Ba3pknbDPAs2O7TA3nl704O6I+VGAvXxC+pe93
         pX67CJcl5rtowI5S95NHMWT4k5YRDLmwPLLdZiTDAcaduEdIu6VbqbkbztO25o4NlC+g
         VANQhyYS57whN+QgpW9OmTR688hPPNEYRzPOMGaOmexIUleUJVnzvC2eaa1p42KlQIv1
         N2ndDcPB1dlk3rAlfvOlqCssm2wK3sXSQJGE5ylynh2OKbM/DgBkiBAkLm4ATLdHMhNd
         A3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cV/jdOLEFuNXKfqQUO2pS597nCwnmDVmSVZXRg5DK6c=;
        b=dYtrZHVHWc0TYxMIiHjw9DA2f3cjoH9bQlhhQnDnCle5YZiv3KasumkTxteV04Poop
         yWG9Mt3h3KayPy6/vfF60oQhAoHlcnFo4r3GK0Hsv1YmIgwIPmLGKe9GNflHV0enbwlw
         ElH8kwkh9YKH4g/+WaD8I6g789uSuiv1zr4+ZcbRBtvdKP4+IbW8H1guHmOxWHcCBxyP
         iarfylqLtDaL5tN3pvU8/fpi56VXFe0w3kqA1ItpdcIYqtgT3WcW1mceLsq3Wd61Gkge
         P8B0tv5jCmGUqMKitOkMN13IW3XQ93FTycCrlojXu5O5EuzAtTif+2jlZHIMW3Uofrqg
         2pLQ==
X-Gm-Message-State: AOAM530eNJlW1OBzPvJQY8ReB3oEF9XCoVXRUbeJdx4WEBgb7He6PosB
        kD8Ffos/yulDSD8qc+yKajUpeTNs0XY86avzOi0=
X-Google-Smtp-Source: ABdhPJyxkzz2yInyjS/r0PZ90Wvbyxrs7KTEbiJL8xy15AJgeSXROqVVsKOIQBe0uOOMaEmXZPIWog==
X-Received: by 2002:a63:2d07:0:b0:381:e49:ae0c with SMTP id t7-20020a632d07000000b003810e49ae0cmr5526989pgt.261.1648160123091;
        Thu, 24 Mar 2022 15:15:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a190300b001c61add3386sm3933367pjg.35.2022.03.24.15.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 15:15:22 -0700 (PDT)
Message-ID: <623ced7a.1c69fb81.5edbd.b4ed@mx.google.com>
Date:   Thu, 24 Mar 2022 15:15:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.108-6-g7f2f3f28404e
Subject: stable-rc/queue/5.10 baseline: 99 runs,
 1 regressions (v5.10.108-6-g7f2f3f28404e)
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

stable-rc/queue/5.10 baseline: 99 runs, 1 regressions (v5.10.108-6-g7f2f3f2=
8404e)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.108-6-g7f2f3f28404e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.108-6-g7f2f3f28404e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f2f3f28404e6bbf24efc45876ef07dcbada0955 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623cbac31e89a83341772507

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
-6-g7f2f3f28404e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.108=
-6-g7f2f3f28404e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623cbac31e89a83341772529
        failing since 16 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-24T18:38:43.554905  /lava-5941931/1/../bin/lava-test-case
    2022-03-24T18:38:43.566134  <8>[   33.948083] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
