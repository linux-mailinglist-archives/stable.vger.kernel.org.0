Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F814E9F36
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 20:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiC1Sz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 14:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245357AbiC1SzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 14:55:25 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6855C63BF6
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:53:43 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id bc27so12915063pgb.4
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 11:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p2Bf3lBkPUV2cHqCajxxMEHuuFQuPlCXi2nXYkqJRUA=;
        b=trC6cLUn+ROUPUg5YAJzk7kLWPb97wWqNpyx/zefNi7tUN7BMCy1Sm0rURdvCTW2m1
         lQouy0ZnC+eMmUAQxkpJbHjSGcf32ZFHLdz4CjXD9PnCzCjv+6IS5ZbeGxtj5h5V+BFY
         MPiXdbOB8Rd4ERcZkaQZXIJxrhmsnslVL0EUzLVrwH3mALmlyafEU7nV3USbv615qdlW
         odLKDjAz0Ma5pZZUdlweeN/6fkIdDHHQt/20X8BMxZck9jFCOmf+DN4UAHMAxKwDDrVx
         JrJu4EhPxX5+xAobXrXWO6aC4iJWRv3aQklinLXUDGww/mFhsBW2/xQZetcZP+R8CzQl
         xfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p2Bf3lBkPUV2cHqCajxxMEHuuFQuPlCXi2nXYkqJRUA=;
        b=jAhwD9iUvxp6Ka/CvmUF70CNJMuR5Hn3nRC5W+mbljE1szgNWyQ9KIUKZnZvdyNTBX
         y8Ayw5+iMMz3kW3Iyx3AnIr5sndqAdJpkmFxGF2b7In2XL9IasidsQovGKcfVEu/OmYB
         F5hNEvxZ23mcpRGUjTZtk6yAbm7GwH+1D3NzU5HdNYwoF6fTSn54kP+Qsa1LpwiPDKVy
         +mKbTcgQidTxNHxblkJcdZTNW5vLSabSPZQBtLZsjIR7pHTOLtXsgFE3Bp55DvsG7ktW
         TFmKZQw57gOPAsRetRyzRKe6hpiLDqmKB/KgLT+Lvww0ZQeD9BKebWGx1FVbsynivCWZ
         +R7Q==
X-Gm-Message-State: AOAM531fNYZb+2bLSh6LVANBiwudxH3oitH4Lf8ykds/utOdAjXoKBxi
        ikRN4M5fwqxRWle48fE0iU8mWlDIjt4Y+Bqk2mg=
X-Google-Smtp-Source: ABdhPJwniCfIvvOutDUMI9c+TzlbRuDkmjCUS+8vRJGAFp4GmLKXqHt4HlyKvKUXDjpYLBtVbYPihw==
X-Received: by 2002:a05:6a00:852:b0:4fb:2cf4:a238 with SMTP id q18-20020a056a00085200b004fb2cf4a238mr12671083pfk.51.1648493623205;
        Mon, 28 Mar 2022 11:53:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a859100b001bc20ddcc67sm206448pjn.34.2022.03.28.11.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:53:42 -0700 (PDT)
Message-ID: <62420436.1c69fb81.41ce1.0bae@mx.google.com>
Date:   Mon, 28 Mar 2022 11:53:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.32
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 130 runs, 1 regressions (v5.15.32)
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

stable-rc/linux-5.15.y baseline: 130 runs, 1 regressions (v5.15.32)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e29be6724adbc9c3126d2a9550ec21f927f22f6d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6241d0d0f33fda6e76ae067c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6241d0d0f33fda6e76ae069e
        failing since 20 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-03-28T15:13:55.904220  /lava-5960090/1/../bin/lava-test-case
    2022-03-28T15:13:55.914922  <8>[   33.656955] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
