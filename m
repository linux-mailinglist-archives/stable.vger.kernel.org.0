Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9660EAFA
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiJZVwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 17:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbiJZVwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 17:52:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5FA9B846
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:52:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ez6so15410846pjb.1
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=awIBFyyi7dEbAJ7faG+pTX4DFZJXn0MIoAexLWdZK3A=;
        b=WaBKGOT2tdvrAyfeNWTeiG5ZRmXDR8LiSB4OWV9r45zVLhNCaaxc4xEycPfRDXbMKz
         4FmhsjYc1XvvCyD9tDMvjA1xQDbsZWPTDWXpS2OV2IsA8MxDnXgiDTEjeiMNu7zLjxRR
         izelpFDFTbke6uk1Ea9rETBojdWL7HrdW2YCTc1OGeIiK+94VU2RzhoKLeZJQ6AfITe6
         q/USrBpGZ+3DXBAwtFvCmIDVS3h4G9rT8RvRPTyubxhS5K4+khhi73ZfeVsgic7hOzot
         za/4knMMt4gRe34U0qSF2Yemf0ltRvAEt6gQJOHYy1doVHevbYzishgqHZouT5bFWqZI
         3iYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=awIBFyyi7dEbAJ7faG+pTX4DFZJXn0MIoAexLWdZK3A=;
        b=a3vdGWt+UHU+SAn0JkzrKjI1vRgx2HMbR/1aro5SsDys1oukxRNkBHR2Io0UBmLBbv
         kW7s+TA2CX4DKVo3V/5OysEwjoo03h1Guo+2wPf4K1ZTPNs356UWH4MKi2r6Rn0ximyO
         MJwpTtcsvZVbWhlpigwNo6C50GNqi0u+FgR1oxQQAE3mEEgxn4QVhIFBYdGTUHNY5f+0
         FaYkIPfy0Kdqr8UBbLcs6UjWa8rDAokcMCCn+MDyyIqkk9OOHDwQoh3Xur6sO3hx2Kis
         +9Pz3f97uMFxLGZxuOkVDJRD3sBsGxXL3T7KUkKh7UnvVt96ysjivg6i9I6vAE/TD5Dr
         8jeA==
X-Gm-Message-State: ACrzQf0+PLT43l9/pPYDaz0uNaX5jbglavhLXw3pF9IetDynifLk/3lP
        y6as55Jgh9FyEYl9uDs2biRaKj+O2dRhM/fL
X-Google-Smtp-Source: AMsMyM6SoinskAQnb0xg9jC9k0m8qlzbr/anK/PIOF0Jo4jsNbKmxK9a71lg9sHAh7vwOkvfU2kgcw==
X-Received: by 2002:a17:903:447:b0:186:b945:c0b2 with SMTP id iw7-20020a170903044700b00186b945c0b2mr13470397plb.25.1666821155419;
        Wed, 26 Oct 2022 14:52:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9-20020a656cc9000000b004308422060csm3184015pgw.69.2022.10.26.14.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:52:34 -0700 (PDT)
Message-ID: <6359ac22.650a0220.f61ff.6cf0@mx.google.com>
Date:   Wed, 26 Oct 2022 14:52:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.75
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 139 runs, 1 regressions (v5.15.75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 139 runs, 1 regressions (v5.15.75)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.75/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      bd8a595958a5b02e58cdd6fed82d4ebc77b1988a =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63597ea6a4b65ada91e7db64

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.75/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.75/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63597ea6a4b65ada91e7db8a
        failing since 231 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-10-26T18:38:12.331931  <8>[   59.474583] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-10-26T18:38:13.355546  /lava-7730234/1/../bin/lava-test-case   =

 =20
