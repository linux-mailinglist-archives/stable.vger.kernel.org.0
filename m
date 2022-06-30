Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D58B562705
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiF3XUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 19:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiF3XUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 19:20:48 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89883564FD
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:20:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x138so834906pfc.3
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 16:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hsGmIfQvCoSfAROOEPPbjLChkpji/n+TEUL6R9OVSgU=;
        b=TXGidUdLVeh9tyWDH2tNBG7cb66/ibWmlTJ9kN8+6I78sIPPxD8uB3PjtK95uvbZhN
         EDB7ggOvjMhbPnJvGqFD1SsgtcP3xAGW9fuQya6HB4xi5+dcUkNd6/SNVn7OIlcccGu5
         /fFxmC4cD9O/N1uCTHfWrn4jsgEPrd1muZG+rsC2fVi5c8mxdKzuWm3Ve2Owv/MiGlql
         4Jux7Fmwvfo8c7JRVgL+s8x2ZkO9PGvL9mz+MZ0SaNF0FTDv3pW/fjpDlCjUQBQUntgA
         9ftNvFvRxXTHWAO9ZcXM4I7I4QRdxRwgozWAvam/576B5db3w8FxoGiFP+PnLIQShqjJ
         IGYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hsGmIfQvCoSfAROOEPPbjLChkpji/n+TEUL6R9OVSgU=;
        b=KjFqRjjL9di1qXPatFxbWXjsiqykelaLiysTn04qvaEQXroo4aK3k59NFDSKJjCOIh
         d+dQ/2PLDjSo4tuaep37GaSIbLojhJX1qb/OubQyZggOdohphqFwHnmp6s3BGWR24B3T
         gFvT7qc8Jt+O52log7mu/ZwA0L4B6AttxLIpt0ijIoUtqD6QnVk/koqX6PmwWSSffQtE
         7hmsqMKbcVOZW8/Sa/4QXky2GXdE8zz+Xybc+EDuLy+RXHvqMqDCJTbw/fstRzdR+RZs
         ZMMVH2QZNQOiHJWM0UbS44eK/MkcBOO4FxrSHueLZqWnUSO9XjLZSmA6XudZzJ3DGFi+
         SPMQ==
X-Gm-Message-State: AJIora9rLus9jNrnpu1YdoWWuKt/d8LfC1eyk/l9AzF+7b40lGWcYNSG
        0zD0eCoVwzF6CVIB/cP0ZD20gVh2ADJFvPRZ
X-Google-Smtp-Source: AGRyM1vEOmiuHxUJ6/MGMTogtQ2u8ttwqkE0zQ6UKohxnJJOo1UmCPGSlF5uF+2MG/M6uLNcOLicbg==
X-Received: by 2002:a63:cf52:0:b0:40d:fb07:a793 with SMTP id b18-20020a63cf52000000b0040dfb07a793mr10050819pgj.576.1656631241897;
        Thu, 30 Jun 2022 16:20:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i11-20020a1709026acb00b001640aad2f71sm14019236plt.180.2022.06.30.16.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 16:20:40 -0700 (PDT)
Message-ID: <62be2fc8.1c69fb81.1ab3a.42d8@mx.google.com>
Date:   Thu, 30 Jun 2022 16:20:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51-29-g49249bfc4d1b
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 173 runs,
 2 regressions (v5.15.51-29-g49249bfc4d1b)
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

stable-rc/linux-5.15.y baseline: 173 runs, 2 regressions (v5.15.51-29-g4924=
9bfc4d1b)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.51-29-g49249bfc4d1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.51-29-g49249bfc4d1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      49249bfc4d1bc5a4f6c82471a12a13bcc78a40c4 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdf8afba3b620c72a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1-29-g49249bfc4d1b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1-29-g49249bfc4d1b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bdf8afba3b620c72a39=
bdb
        failing since 2 days (last pass: v5.15.48-116-gadd0aacf730e, first =
fail: v5.15.50-136-g2c21dc5c2cb6) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bdfa0be943c19efba39c38

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1-29-g49249bfc4d1b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1-29-g49249bfc4d1b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62bdfa0be943c19efba39c5e
        failing since 114 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-06-30T19:31:09.262637  /lava-6718289/1/../bin/lava-test-case
    2022-06-30T19:31:09.274253  <8>[   60.897213] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
