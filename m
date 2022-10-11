Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809B75FA950
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 02:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJKAat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 20:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJKAas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 20:30:48 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BB45C376
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 17:30:45 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y1so4948076pfr.3
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 17:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4xpbjDRSwoho7BP64DgU8aoSP42n4YBbu5lUYJtW9hs=;
        b=DFYQYlcV0SxWrsBzhjCJZm0FzchXGNGtLXDLwKBq9TkDpZeZ4wg+ZXVix17fVnzf/l
         EJkvfVUcy4aEINY8JnM5nglV6kxPeWYIA3PgMn3yvmBCTQWvvgBc63lgqKDf28DP1Kj6
         caNRBmpqFtiR7K3FUlhGfk2EedPfexAqHjXkXjuN+2cpyBem3YGpMn62vx33s7p8UGLt
         aESdoh3Mtjv18rRL7a0LGFrQ863L54NAEQIo9edoyNg1MoJNqEbnn1APIAqjjpcQBND9
         l46cpSGtp4DQySzgEuNScqACvAG4298ZH0IGxChecaaNk6mxFbEMFXj2oazXpxVlcdPn
         bG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4xpbjDRSwoho7BP64DgU8aoSP42n4YBbu5lUYJtW9hs=;
        b=LyGrmtkcw53dHirlYUexjOCX/vL0tSF2tGajcWHdqW5K/0qb3hRiIkYUylHooR7/JG
         jyxilKbaNChz7SpCUdgvQlHzsHOZf7FtlhCNPFC19/SDebtl95gmEA4zqn50sN6+s3VD
         bphGTrXW2r8CgXkUNPdvhWvTB8ixHHJGuHK24TFwiyzV80+2ZRNChj6yW1eyLwJamny8
         Un1lwGrp3HSz2xjql2nO8qZwyUaDlWN2/CyvEhS1YGS4I5Q39RXM8H28Gj5PNkbhd3K7
         AQNsCDMvuVKAqvOPyoBxIypQ8mIjpXsSkV1pc0wGvoa7HdYFgArbFoR2KyuW6kbJwwsq
         NMrQ==
X-Gm-Message-State: ACrzQf1n3OWoNYHSUl9XpNsgGYp2gfnMsmNHithQ3s8uaPIkhDYj80at
        fpaadYHoMQVKOo5VJBqzX+rVG8tqn8k6Y6fkDPU=
X-Google-Smtp-Source: AMsMyM7gl1DYrkFuIo8rD5EKa/Yx7yKL61BzcxdG05Uq6fzUOQY45uvQc9OUDb2sPiPOwPEc14Kxeg==
X-Received: by 2002:a63:6cc3:0:b0:43c:7585:1ec with SMTP id h186-20020a636cc3000000b0043c758501ecmr18968006pgc.571.1665448245211;
        Mon, 10 Oct 2022 17:30:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6-20020a17090a39c600b0020063e7d63asm6664842pjf.30.2022.10.10.17.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 17:30:44 -0700 (PDT)
Message-ID: <6344b934.170a0220.dc6b2.b605@mx.google.com>
Date:   Mon, 10 Oct 2022 17:30:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-36-g197d9e17aabe
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 38 runs,
 1 regressions (v5.15.72-36-g197d9e17aabe)
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

stable-rc/linux-5.15.y baseline: 38 runs, 1 regressions (v5.15.72-36-g197d9=
e17aabe)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.72-36-g197d9e17aabe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.72-36-g197d9e17aabe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      197d9e17aabe8a6d8a323d8dd3d08487fd9cb33e =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63448a6e949648f1a1cab5fd

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-36-g197d9e17aabe/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.7=
2-36-g197d9e17aabe/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63448a6e949648f1a1cab61f
        failing since 217 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-10-10T21:10:51.992888  /lava-7546489/1/../bin/lava-test-case   =

 =20
