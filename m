Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327D94EA663
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 06:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiC2EXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 00:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiC2EXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 00:23:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7C23B3ED
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 21:22:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m18so11650879plx.3
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 21:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BHzNm+uvQIL0HXQjAHplegmwyoqcJVOyFFdlXd0XLe0=;
        b=b4fNy1n5NLvBmu2NPeIdRXSHaCTNgAeIc3KpajQkDYIYCh/P/3SkftEpFPtVE4XFuP
         m8AyMvlwRIAS1WU5OTUvaUUTJe00XLahsPUAnm/DPUbk+4BCGuZa8jxTTOMKeUvpj3vQ
         Tl1N2ijmyteNJzudCgnACigEWeu/1/VWvSs1UIPbYt5/EPBNTM9XFsYxfQ4aX659TQO8
         J6us2YQnU+yBhQ9sDQiv6jedXi+ptIrwqQgTWbczgAS6OypdsDIanQhHp0j4kEMgW//Z
         wAgj/kWUEeP2l66KNCKuE8CNwPMZ88TinVAq7rWc5e/LFAWIr676rUI94iHuxT3yz1Wq
         DewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BHzNm+uvQIL0HXQjAHplegmwyoqcJVOyFFdlXd0XLe0=;
        b=AMYTUcnzB58ALiNvf5MxWEhsvZEyWmPheHBglfSSLJZEriO9KugZbYglOKKsrLbUtV
         BQDORa1Qrk2LSxPlUq513PGUnrU7/dkBmbSXrRmVsk448L9TbUGPRxu2ibICQhSLOVJ8
         5z6R4UNF4RWIKKK59SxeLKnYh6511NKhABBrPaYTnUbN7mfPGro1rTFs+tUIJNdyNvqu
         X3NekP4v/+3bTFq9mBTElUkWg6f0k+1JrWP/wNndgOx5V8+AHATDW2fJ+VMTvjTLoARc
         YFgRWH+uV0+/2XxvSWdf9UhRCKzJuiR6wJlm4HtcSK4RDcd53Rm1Wu/BcfFxAwFj1iDG
         EXvw==
X-Gm-Message-State: AOAM5320LVS3RvW85mwrG+eC1PfVaJ7f3M4Sgu5J39DhN/uor1LQhdLm
        mEX6v5FrHXgRIax5oA69aKVKIglHDB7Z5cwtZ9Y=
X-Google-Smtp-Source: ABdhPJxN4ETw3X/RJ7y8Zw68EbxOBk/BloW/tjBZxzL8zG8iVBbq/I9oqbCZVrGmIB3ctw9oe3SpRg==
X-Received: by 2002:a17:90b:1b10:b0:1c7:3413:87e0 with SMTP id nu16-20020a17090b1b1000b001c7341387e0mr2549400pjb.132.1648527729188;
        Mon, 28 Mar 2022 21:22:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020a63370d000000b003810782e0cdsm14411632pga.56.2022.03.28.21.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 21:22:08 -0700 (PDT)
Message-ID: <62428970.1c69fb81.8f98f.7242@mx.google.com>
Date:   Mon, 28 Mar 2022 21:22:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.18-25-g17d8570b1a559
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 74 runs,
 1 regressions (v5.16.18-25-g17d8570b1a559)
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

stable-rc/queue/5.16 baseline: 74 runs, 1 regressions (v5.16.18-25-g17d8570=
b1a559)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.18-25-g17d8570b1a559/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.18-25-g17d8570b1a559
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17d8570b1a55907e5a41d3302d850aebee3c1e05 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624259082241fcd2cdae0697

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
25-g17d8570b1a559/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
25-g17d8570b1a559/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624259082241fcd2cdae06b9
        failing since 21 days (last pass: v5.16.12-85-g060a81f57a12, first =
fail: v5.16.12-184-g8f38ca5a2a07)

    2022-03-29T00:55:17.110033  /lava-5965201/1/../bin/lava-test-case
    2022-03-29T00:55:17.120743  <8>[   33.645745] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
