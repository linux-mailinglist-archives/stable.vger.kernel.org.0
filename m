Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA274F788E
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 10:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiDGIAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 04:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242519AbiDGIAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 04:00:17 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79A7111749
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:58:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b15so4759453pfm.5
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 00:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SnN7onJ8oFvHgqlTXVlO4NwrqDvzCvE35Ujbg+1HQ2w=;
        b=VghiQfhsJdBQ+dSnwloO1drWG4k2/CnnogRxPAFzmYuxI0btFzrlnyvP/fyFCQ29BR
         nbqwCfv+hD0MrgcxV4jwV/BM8byKZfiGFH9RLTHkE3tAplXHDbwgI66hO6c1qqjLq/s5
         ukUv3CVcmADVwFeSbDLMFUJBUPSxu7FxqbRZz0/aFryQN6/+q/nJjP7MSm/cGCO4u5SX
         gp73VVErMYvIVoQUDsMOKwNDlQU90+l4xhywRLueT6n4+901mPRR4f0y5yLr5Tj0k2D8
         RDacN4rrxZkjzd1asLrGFcK1Ux+ARxw7WQ5l30Bcg5NOOo0Ef3tRUwoOIeqPIgg6t5cA
         FP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SnN7onJ8oFvHgqlTXVlO4NwrqDvzCvE35Ujbg+1HQ2w=;
        b=VfRzChud0TXMO9MVwQx/ES/xaJUpBb0IdlwZUCZPyl/ADOxiQS12/XedWgcbD5JXCW
         y250OApExOtShMN7IiJhEe78Z+Lbbr1oy1sWJGxYcvmk4zc/32VdHk7pgVMvgsHVX5Kg
         c667qt+jFi3qlfOq+63xDpQQSRKSFoDDwOUIvjPV6Isy80vq/jIOveKJBaBTvpGRh0aU
         isiPhD/IiTWmUwmCnnqV4nQ7rI5FQu7BD1P2wqdBSbr8DYhKXarO1/i8SzBAZXTSVd4B
         STU15J5kPsiHNqYdS73PP3UvMS3rX++3Dj0tvPe1wo49f7s695W/Qx5XRDWPW3yP6cZd
         iMoA==
X-Gm-Message-State: AOAM5330uZfp70tLJmFPsu955GWP8HvPfZdemBqPzP3qQ7tfyq3rFdrS
        IKymfLJuKTpNdwqp4nFvEveXVNS6FWuu5y2l1Jw=
X-Google-Smtp-Source: ABdhPJyLaLRQqlKRvcx2AoX0tBUfYK+0YhteskWyUFAZoGquf7wFxLRkWGn6/Rr00gJjJZ9P+MMlTQ==
X-Received: by 2002:a05:6a00:130c:b0:4bd:118:8071 with SMTP id j12-20020a056a00130c00b004bd01188071mr12896783pfu.28.1649318298033;
        Thu, 07 Apr 2022 00:58:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm22009899pfc.182.2022.04.07.00.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 00:58:17 -0700 (PDT)
Message-ID: <624e9999.1c69fb81.969b2.aabc@mx.google.com>
Date:   Thu, 07 Apr 2022 00:58:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-367-gb24d8cb81a709
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 57 runs,
 1 regressions (v5.4.188-367-gb24d8cb81a709)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 57 runs, 1 regressions (v5.4.188-367-gb24d8cb=
81a709)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-367-gb24d8cb81a709/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-367-gb24d8cb81a709
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b24d8cb81a7098a3ecc3c65730e925136c3a58ba =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624e685411dfaa1c21ae06a3

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-gb24d8cb81a709/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
67-gb24d8cb81a709/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624e685511dfaa1c21ae06c5
        failing since 32 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-04-07T04:27:47.860085  /lava-6043206/1/../bin/lava-test-case   =

 =20
