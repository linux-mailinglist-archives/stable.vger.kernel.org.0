Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F914F5AE9
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 12:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344321AbiDFJuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 05:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389971AbiDFJs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 05:48:57 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A830774B
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 23:22:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n8so1135885plh.1
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 23:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zcImhSiSAe/TtSypW0DvfxdPqgg4TdoNUVnXBVbW/PM=;
        b=V6efL+phgesApSv81vdmYUxH4KjCZdJd6ugPNlVpSWCDkukzTLVzlF2moFinnjerbi
         udFUmAqBogFyvO06NAn9I0B4Cr9MQspD/0RxklIGBiUzU3KTwGemJ+/dk8UbDQ8vKL97
         eItNban80NTyHUIwHrXoswjRuy6WL7iE6zUrdZykkIlGsWNnDGwdmo01oj14nfVIAUjP
         n6KhH4NakalZvZYZKZMzdUUjyZYJaQVWGlM8Q+ZBW+75FoSfXfh6r/inbB7lrL/nJG/s
         iN4vMRWQsR3nWbp2PrLuIIxpd0Fs07KoTnp0ym+pWnUKLdNdF524A9CoEGgqf7rGgvou
         xadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zcImhSiSAe/TtSypW0DvfxdPqgg4TdoNUVnXBVbW/PM=;
        b=nzpaMh1SAtAlIMTdonXh9Sl6ni9epd6PyaeQx1zttUUO/9L1alaZHfAUgc0CNaMuMg
         NivBr6a0T6qTWit5j2BIXgreE+inBpGPgIa0sjRrMxbSFdPonsU90+Naw+zVibnIbtCH
         wrjIZpr8rVg9DVNPyCPswmRr8dRELLrN5FIlxE7Y1WUq2BtDd4nq5FCgyEw0ysgZZoZv
         4o1st+mMR/poUHMBmbgQF9nXuRgIinoDqQ6D+slN4l0DnYv1tkrOzISB6ixxdeoHQAPw
         juLMyjSiRLRb8Ajf/Boh0FEmMGu+9DcomRMsQiAK0sf11HadUmQqg3IxUm4VeZ32aQt/
         XqRA==
X-Gm-Message-State: AOAM530seJKvkcpBI66Oa3nQtFjwf4XTSJwiNQsNHu6WKCInhCwdFG3p
        P7QaSdM2zbkn4tnz17b1I7MRtTE1khhRSY5mys8=
X-Google-Smtp-Source: ABdhPJzk42zZBNdihNnFU2B37SJYUewO7HlhTfiJN6DupxdEXTTelHFNTkdyomvtusUewLp+QBfnWA==
X-Received: by 2002:a17:902:a981:b0:156:229d:6834 with SMTP id bh1-20020a170902a98100b00156229d6834mr6858101plb.128.1649226138747;
        Tue, 05 Apr 2022 23:22:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15-20020a63be4f000000b0039934531e95sm6870884pgo.18.2022.04.05.23.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:22:18 -0700 (PDT)
Message-ID: <624d319a.1c69fb81.15be5.30e1@mx.google.com>
Date:   Tue, 05 Apr 2022 23:22:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.32-912-gdb744579cce93
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 67 runs,
 1 regressions (v5.15.32-912-gdb744579cce93)
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

stable-rc/queue/5.15 baseline: 67 runs, 1 regressions (v5.15.32-912-gdb7445=
79cce93)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.32-912-gdb744579cce93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.32-912-gdb744579cce93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db744579cce930b29f4bdd53a17cf805e0757b2d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624cfb6b57492d8f71ae069e

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
912-gdb744579cce93/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.32-=
912-gdb744579cce93/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624cfb6b57492d8f71ae06c0
        failing since 29 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-06T02:30:43.907970  <8>[   32.346186] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-06T02:30:44.932153  /lava-6033793/1/../bin/lava-test-case
    2022-04-06T02:30:44.942956  <8>[   33.381876] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
