Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511205002F1
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 02:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiDNAPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 20:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiDNAPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 20:15:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1682317A81
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:13:00 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h5so3262528pgc.7
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 17:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oCJUJCMDk5e0pj/KHlUz/w+E+59weOyXEwTZ1w5mACI=;
        b=wpdC6uCn8KwymgFmlBkqElCkms8I3kYGx575TBDenfoHe0g/VXNJISld9JzK30S+sa
         QZF27VmEzpjpra2SJ+zyR93/CpyggcEQrguB4tJBxeFWtxkFE9q46eKsabj1rdlPfoH2
         pumEZ7MbZ3Zp6NO+n3YLbQ8cTWBn2nBxAAPed3LJBbUYMAT/5etsGy+R2pe4eBCV0AWI
         nEDnT6WsmO4oPlfWgRjIt4+EeDeqhpiWUZ/uo5yS9Rwrxb1caivqfcvqUqWBCpjqMnGx
         iEVm3KRojAUAmIY9ec/RWYqvwP292iOaatu0cDpty+DUbPCujLRxT/YEs+0v8HMg32QK
         mILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oCJUJCMDk5e0pj/KHlUz/w+E+59weOyXEwTZ1w5mACI=;
        b=ernyjbCx7Y3xJABfw5Mct7KTBjMvLhOIt/fuZSduKzax7ARE8aEWJzmqDdvnCf0Lhg
         GeqxZC1rvJk3kVF6M6jft/DgDN66W8Va1KIEDFf6y8PEFnmCHoENV01J3S3srwkm/r64
         KHFuxzhSrcO6G/nvDW/toLlFl1O5TLa5YpvXeX//MihxN6M9DaGDh9SUVzOY8dats7JR
         KSNGwWHNHhP4iRF38f8uek7FHVOmL3nLoQuKjvd1VbyoWNm6Ai/R6d/dIslAZ50wglxt
         mbAcEE5bFVbgGPNHrXa7GbBttfFTnBV/Fb6aFumlqWlZSFInUD3/EX4Sv3TJ9YxM/6ac
         qdgg==
X-Gm-Message-State: AOAM530GY99K9CoPPaScCHxP8vnH8xvCymEH2Os10sgc4aThcZIHdFiY
        xuTRhDXOXbdOBr9toiKWphojgTkJz5o3NFnX
X-Google-Smtp-Source: ABdhPJyExccBlfcny5ZdfRZ3YHONgybXigLBxcbpjaAqxhKIJ9O0DBAewBR+nbe98zVgFX3l9Czdgg==
X-Received: by 2002:a63:7c42:0:b0:39c:c333:b3d4 with SMTP id l2-20020a637c42000000b0039cc333b3d4mr117442pgn.456.1649895179348;
        Wed, 13 Apr 2022 17:12:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u22-20020a17090adb5600b001ce08729657sm38953pjx.30.2022.04.13.17.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 17:12:58 -0700 (PDT)
Message-ID: <6257670a.1c69fb81.d3782.029e@mx.google.com>
Date:   Wed, 13 Apr 2022 17:12:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.111
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 126 runs, 1 regressions (v5.10.111)
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

stable/linux-5.10.y baseline: 126 runs, 1 regressions (v5.10.111)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.111/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.111
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6c8e5cb264df8e9fbfe1309550c10bccddc922f0 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62573c1aa0e8de2e42ae06a0

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.111/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.111/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62573c1aa0e8de2e42ae06c2
        failing since 35 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-04-13T21:09:26.252550  /lava-6081999/1/../bin/lava-test-case
    2022-04-13T21:09:26.263587  <8>[   60.597932] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
