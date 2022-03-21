Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A2E4E3273
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 22:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiCUVuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 17:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiCUVuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 17:50:00 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BB13CE84E
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:46:13 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id k7so6995293qvc.4
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2fZheC+sqhZvGvigUK7kBSqB/16vac+ezpjQ7zFDIwM=;
        b=0GP+hlHyY9dxmAloPHqYOLYGjDJqqdI+b+NM35IqCBkvWjEJopeBH3nsTrs9prdEE7
         cKXTxPkm+FsKIF9FVaENR1cjoI/rQmlkZgC2ITRQVNwY6x+Y/K4z5Xq6PemAGq1XqBrQ
         KgSUvpdd9MVucc6AJXsQ/ZDOvjp0GoqIUszbtfl8kKA/LSk5Bm546+iyjfuWzpUTbls1
         EhgsJ9bEISHS2jJ36binrX2GwZFt9wXGbFP/TUfB258iMmpgiYfoGGRIMUK3EcuCDYtt
         QnKjnIfn2mHNcARoQxxdtzJ/+KP9kUNLPigmqQXG8FsNnpKS1Bls74GwBTZWGxmBXMu9
         lMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2fZheC+sqhZvGvigUK7kBSqB/16vac+ezpjQ7zFDIwM=;
        b=ETUWvg7z8sYzkcg1KMQsRLPCy7bmskQxQn/ePace/5RoyCJDASIE7tBxe53g6c/vBv
         aV5VOwdrfYFlpckhFTdc/jQZUX0uHVkdpcCaO6V2SeGoOKMM6iQcJ3TcXGigFk1lWj+S
         uoDMbf8u6fTznO856nFxR1OJVKxdaqw9arx7IKkcZra5E0oD0D10aAyT54sWbXMEaNN4
         LiFj9PilTxdHM+/wtHHVnwIixkec1mjEftL3e4kocOtLn35235sDiz7iEBEZkSWfbto3
         a4m26LiCGdKUCP+lyJdw/FrNeZRzWDB87Ulk/5imZ73aOZCZvyfMCMXBfJYyazikqOMA
         zdJg==
X-Gm-Message-State: AOAM530Zs/XdwMmffk6uPpGRdL29gaB42veNHvtHBwC8x6f8MCYdDf0f
        QFBG+qG34/Z2t8RhER6iXyA49VhmyZ9+62wz3rg=
X-Google-Smtp-Source: ABdhPJx737PfbjMC9kvf9n8EEjpTzqfYCL2LqBSCw8AmdlKSa9JEkZya918zdQOHC2qDpnq/AxlmVg==
X-Received: by 2002:a05:6a00:238b:b0:4fa:aaa1:ee3c with SMTP id f11-20020a056a00238b00b004faaaa1ee3cmr4277421pfc.52.1647898322547;
        Mon, 21 Mar 2022 14:32:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm20958595pfk.8.2022.03.21.14.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 14:32:02 -0700 (PDT)
Message-ID: <6238eed2.1c69fb81.bce49.8ed6@mx.google.com>
Date:   Mon, 21 Mar 2022 14:32:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.30-33-gca23d8a1f1ca
Subject: stable-rc/linux-5.15.y baseline: 86 runs,
 2 regressions (v5.15.30-33-gca23d8a1f1ca)
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

stable-rc/linux-5.15.y baseline: 86 runs, 2 regressions (v5.15.30-33-gca23d=
8a1f1ca)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.30-33-gca23d8a1f1ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.30-33-gca23d8a1f1ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca23d8a1f1ca986793db05e0398452d325571a3a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b799775bb4db2f2172d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
0-33-gca23d8a1f1ca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
0-33-gca23d8a1f1ca/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238b799775bb4db2f217=
2d5
        failing since 60 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238bd7cc88e190a562172ce

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
0-33-gca23d8a1f1ca/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
0-33-gca23d8a1f1ca/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238bd7cc88e190a562172ef
        failing since 13 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-03-21T18:01:05.881390  /lava-5915537/1/../bin/lava-test-case   =

 =20
