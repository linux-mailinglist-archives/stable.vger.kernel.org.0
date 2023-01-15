Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497D866B3BC
	for <lists+stable@lfdr.de>; Sun, 15 Jan 2023 20:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjAOT63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 14:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjAOT62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 14:58:28 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439B712F00
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 11:58:27 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c6so28347762pls.4
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 11:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5MfGPaaftG+9Dy+/wG9Z91sKFFYex2y4e6IN+PyXu8Y=;
        b=Vby+XSRSFjkW2RJOoGTtRy8wSlekH1+blsWKjGJTLr4MaIbQxElMMGbVUPrByeK+EJ
         Q7lgkNa9mOoYhr18BNgpBhOWmeiNexqtbGfxvczoRO0PpVxnDu8jm7iNdk9TpLYLM+vO
         zJPdI279mFvSsN88KyhR3Y+jJocpcva6DE8+mctTQ2yGNBBWonvPEKF9BP3PPmNScu2E
         mkqkxKtj12FTWjs+L0ropMY4aBwcGzmQZeeCXRzGmpaeTmgvGr8HshxZBOOEOuoKLPeW
         Xi3Z27ty1D29OBUuXAz/jyZ8e0Pcqdk8bv9bRTlqWWdMU+6mBc/1OSdIOpwvYYGRzbzx
         RDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5MfGPaaftG+9Dy+/wG9Z91sKFFYex2y4e6IN+PyXu8Y=;
        b=ayrZDntok6QW+qhr282BwArr8JYQeSmL3C1ZR05llrhLQkmvyjciZVcvPEBDmJFv3L
         3k9Auyf3sYXfXaXqRzlDyd6PO1BODcqt4j6CdkPyeCe2i0YiHmOswYmNCKv72rtLBNai
         IxHq81ce5zrLxr5xJc96l9PiK1hLaVAb28pyHbh5BQDZToRwr2Bic5++v8gG3Uo7fKyq
         KGP1Bn5fRx+r8TQawghlRw9kywZFqCTZFM4IUFtkZjAsXYhxC22P467DOkcSSf36BzCS
         7seUlTxlLlxp3ZLkupakYgLn6gayTarwp6+Nnk/ERfiyvisPBtIpYEStsbX5DQFVQY4n
         aTaA==
X-Gm-Message-State: AFqh2kqr7jxWC4A4tjxXydalbqs6s3G39x8+MLZg7sBZxaLsn83jQO5L
        wsCjDmNafUqpgoTWBsGxNkuPsSU/evCiwDZTim18Sg==
X-Google-Smtp-Source: AMrXdXuSgmRkjkfMn9qSbbYIb+brVlGy+GwhIpqEmGmCfRFMiAkLfMumF3a3e/3+0A0grBB3XnLoNg==
X-Received: by 2002:a17:902:6b89:b0:18f:6cb:1730 with SMTP id p9-20020a1709026b8900b0018f06cb1730mr84862747plk.26.1673812706511;
        Sun, 15 Jan 2023 11:58:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902b18700b0019335832ee9sm13424600plr.179.2023.01.15.11.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 11:58:26 -0800 (PST)
Message-ID: <63c45ae2.170a0220.16f9f.5f6f@mx.google.com>
Date:   Sun, 15 Jan 2023 11:58:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.87-58-g5043470dbadb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 124 runs,
 2 regressions (v5.15.87-58-g5043470dbadb)
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

stable-rc/queue/5.15 baseline: 124 runs, 2 regressions (v5.15.87-58-g504347=
0dbadb)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-58-g5043470dbadb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-58-g5043470dbadb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5043470dbadb2e721d21f473e968c6340995e9f6 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:     https://kernelci.org/test/plan/id/63c42876b54961773c1d39f1

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
58-g5043470dbadb/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
58-g5043470dbadb/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c42876b54961773c1d39f4
        new failure (last pass: v5.15.87-52-g49b2bfa5a39b)

    2023-01-15T16:22:50.807311  / # #
    2023-01-15T16:22:50.909409  export SHELL=3D/bin/sh
    2023-01-15T16:22:50.910052  #
    2023-01-15T16:22:51.012232  / # export SHELL=3D/bin/sh. /lava-247326/en=
vironment
    2023-01-15T16:22:51.012794  =

    2023-01-15T16:22:51.114204  / # . /lava-247326/environment/lava-247326/=
bin/lava-test-runner /lava-247326/1
    2023-01-15T16:22:51.114763  =

    2023-01-15T16:22:51.119731  / # /lava-247326/bin/lava-test-runner /lava=
-247326/1
    2023-01-15T16:22:51.181075  + export 'TESTRUN_ID=3D1_bootrr'
    2023-01-15T16:22:51.181395  + cd /l<8>[   12.195149] <LAVA_SIGNAL_START=
RUN 1_bootrr 247326_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/63c=
42876b54961773c1d3a04
        new failure (last pass: v5.15.87-52-g49b2bfa5a39b)

    2023-01-15T16:22:53.504114  /lava-247326/1/../bin/lava-test-case
    2023-01-15T16:22:53.504377  <8>[   14.612752] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-01-15T16:22:53.504525  /lava-247326/1/../bin/lava-test-case   =

 =20
