Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B22463E093
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 20:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiK3TSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 14:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiK3TSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 14:18:41 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0571D83272
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:18:39 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q71so16971345pgq.8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 11:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aYNNU9+X/9ZTebnHHMGvvJTUB4H0iJgIyfV44VH2ZS4=;
        b=hFHl9+NwQ2QWwXSydZBD+0yH7WV7herJBtH+lWaNNlNzywYryBMSKWvDN4mkeEGheT
         Re+7rcUm4W2Ig2PQefVQ14fgy27jtR6PO44f2Mx7I8/2DLITULjxYJ+Ntgqo1nP6iRxD
         L8z8x/0NUMjoagH9exS1wSdXntjwQFqpvJ5WxTSBAfl2cjRG4W1nM4ETO8WP23loadiS
         brDqNcjwmwAOF7VsUanAiWy4zIFqy9/HQPEzGJygKq27/eLom/JCYYkH1LHDHEto5iog
         7U0IYjTtCzByLqY1fJZTK8vVOc2oJfWuE/iCCZhJLfedF4SYz+oVm/9Jsw3zQhAEVccE
         LNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYNNU9+X/9ZTebnHHMGvvJTUB4H0iJgIyfV44VH2ZS4=;
        b=4CwPcWs4gX1qruQSTxvZzU+enNDG2IRaanvWbNk2OwBebEAYN4gxuDfTwWtJEv4WEo
         Yc4ZQz2iRvlU6BeXIe0TlR1BQ1rbQEWcx5rsCt7Ab3+Rq4MKM11qUU5p8FtOR6q5lXLW
         PfmJa7gF1E0SeVd744yzwukbpTl/1WPvpZDRwGEtMn+lnIo+yYfdW2q+v7RscvDnz2LI
         VPJsafLlmF80CjRck9TwAQ4XC/cfrPkqJyAT1WU4FnRmXqBfc/S1MT0SXiZbndX9KcpD
         fs1nVNfXw51zy+MTh9c8YNRDOQl6TPCM50aWjRE2Om3szEOqwCJZ6IEpRaffIEy+S6vV
         n3cg==
X-Gm-Message-State: ANoB5pnCpFdtxYIYLwYc+5kkEH4gA29/DpdSKtCJ4l5v2VVfLqOtKMh4
        G/3lEzUIecjG4XubJUi1iXigi4BXgEGhKFXQ
X-Google-Smtp-Source: AA0mqf6tX4eeqgwT88LSjGELGrKim0bTr2/EmRByB5xsCntxzQwclzVgU+0Tcw2v0pTrY9KrvIGhMA==
X-Received: by 2002:a63:545d:0:b0:476:d44d:358 with SMTP id e29-20020a63545d000000b00476d44d0358mr54969050pgm.521.1669835918217;
        Wed, 30 Nov 2022 11:18:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ij19-20020a170902ab5300b0018685257c0dsm1861789plb.58.2022.11.30.11.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 11:18:37 -0800 (PST)
Message-ID: <6387ac8d.170a0220.74bd9.3d39@mx.google.com>
Date:   Wed, 30 Nov 2022 11:18:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-367-g98a7f39e79899
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 133 runs,
 1 regressions (v5.15.79-367-g98a7f39e79899)
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

stable-rc/queue/5.15 baseline: 133 runs, 1 regressions (v5.15.79-367-g98a7f=
39e79899)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-367-g98a7f39e79899/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-367-g98a7f39e79899
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98a7f39e79899319dde0e221361f5c63ebfeca53 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/638779d92cdb2f77832abd2b

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
367-g98a7f39e79899/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
367-g98a7f39e79899/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/638=
779d92cdb2f77832abd3e
        new failure (last pass: v5.15.79-330-gb107830d5a8b)

    2022-11-30T15:42:11.467768  /lava-220251/1/../bin/lava-test-case
    2022-11-30T15:42:11.468151  <8>[   14.563386] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =20
