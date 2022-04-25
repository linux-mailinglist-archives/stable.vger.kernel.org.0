Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DEA50EB3C
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 23:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243355AbiDYVTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 17:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbiDYVTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 17:19:50 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0C33A5F9
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 14:16:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so611296pjf.0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 14:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w6j9veaMdqlHiYDfuGB2vQatbn40fZuUZi09DKksVYw=;
        b=fSlJJKgMlXaX804Ob38E//LjLcNYFy8AboeziTwcyaJKyv3sbD6nQJht5/8SKdxvVM
         UqoKufTrjCun+yWpjQP0tQTJPdeI5JpqaZmUGeyoQLZ3CyZrg15EprzFILwLNn6/URTd
         +FA6RKzX8p5akJFvH8dEn1GW1j3pcnkdTD5PmmEcRklxwe07qtuxUMyMFlznJ84zMoCy
         2Z5Lfm/Pe1bpQ2QPvrmrESOfQE8OYi4bz2Fyhz/mU4PI0VsxV8XGN52euHZgKEYdbxk9
         7t+ouOnSASPnzrYDwNY+m1ZW2urIWXGKeqX4BDJx370+FwO865hkUBeLDBpNlHXyDys+
         2eFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w6j9veaMdqlHiYDfuGB2vQatbn40fZuUZi09DKksVYw=;
        b=17+1d08eNwRVSo5K22qF9XyUFzcW9kGTHwVVaUWl1V6hRKM+AGN1CeGgF8tzPzbg+z
         ANN9PlSyCoPTzbE30jufRIqhxboE3H/BDQCKteK0x5wQyEMnAFrBhozsHUaH/nsHxzJr
         9Xfr2V9hWVEDSNkORSCrtK+Lt9zLXBtnIC8jyNtNiMs2qDoWkmD7qJcpJa7T/wwjJOd0
         Xb6dP2//3X5O3BQXKmrTeInnkbj/cMyC7ZarQRArEWXvaluYOvN6UH5rmPT+nN5D3XoP
         TRsu7eOoCq1Md1QjuhQgBiSEdEJ6C07BuGxRT8Ew7D8MOBVKnWQ15S7Ssb43WNXCJ3vu
         6Tng==
X-Gm-Message-State: AOAM533NdSp13hIG3bNXln5E8hHWdA/s5cpFAJMLhWqypn390PU2yolW
        nsvREimbI2KXOPFqcAYiJ1bTYcYlQNxQRIN1efg=
X-Google-Smtp-Source: ABdhPJykqo26E6x/Bgn0adTuqPi4F/6CEobluQYM6hAXL276Lx4DP6X5k1GBXhMzxz6wR/O++EJW9A==
X-Received: by 2002:a17:902:728f:b0:156:24d3:ae1a with SMTP id d15-20020a170902728f00b0015624d3ae1amr19827813pll.9.1650921404594;
        Mon, 25 Apr 2022 14:16:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm13695599pfk.88.2022.04.25.14.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 14:16:44 -0700 (PDT)
Message-ID: <62670fbc.1c69fb81.6156c.0453@mx.google.com>
Date:   Mon, 25 Apr 2022 14:16:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-84-gf6e137598851
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 118 runs,
 1 regressions (v5.10.112-84-gf6e137598851)
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

stable-rc/queue/5.10 baseline: 118 runs, 1 regressions (v5.10.112-84-gf6e13=
7598851)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.112-84-gf6e137598851/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.112-84-gf6e137598851
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6e137598851e3e18dec018e0dc9fbdfcad7894f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6266deb66557d30c07ff9477

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-84-gf6e137598851/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-84-gf6e137598851/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6266deb66557d30c07ff949d
        failing since 48 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-25T17:47:12.144652  /lava-6173593/1/../bin/lava-test-case
    2022-04-25T17:47:12.155236  <8>[   33.594822] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
