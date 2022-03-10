Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979404D505D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 18:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiCJR0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 12:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245078AbiCJR0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 12:26:41 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A98C115E
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:25:24 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id c11so5262331pgu.11
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 09:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KX2Ho2OHg1iRmyCWPRV5MYK3vsgr9fYCr0XHLUoSJN4=;
        b=XAv6QTjAKURc8p4thQdj7mzLNIa66Cyv4v8hsGp/XK7t2PxdQdBYslIL/NbBZQwcU4
         JIksPcOTklKqQ8odq1XZxsMEh6rSFRVoD2nYm7lgP1cNzVeyd95Yo3t2aM1A87P9G7ay
         rTLX/bijQeaWM/g0hTJyyrgLUrew/T6OJ+kiuVBaIyTd+mcjxK4R4Eo5JjiMeq+fio1E
         V9Iuy+r+z37/3NxwSkLrNFCBCkt/ediZiIDTT09bL1E/tsdSeMLZ6FbsAatG8XZbrlSd
         a7ZscidI8wgzxlWiUBrujOBAIyfZ/SYWyCOLhlPy18ithbgP8z+EbzlIVUJXjPUcWIpQ
         0w1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KX2Ho2OHg1iRmyCWPRV5MYK3vsgr9fYCr0XHLUoSJN4=;
        b=riIC2I4YGytDXZLTHY7pfqXxafq/0YF/LQ5XQWrfhPsFb3GaWbvqRSQGmeOftzVos/
         pK1Zzu9Iil9FOWbso0QBa04fizpxf87BkHmfvK1REzxoB1gPir/xa9TymAuyUC7o1IoY
         ZDjMsDtB9ibYBjQfktflxfqvUa26gh5zSbmppD2bJwWOGWC4FKHeVP3eQNvytew0UvPV
         V7KHtwcPyHihkrA4unZVe7Rr+eUykI8BI6OeDwoiEYZkK4VipFrHMX/Igc+scM6fYpDk
         KSINm5nmq4NWbe+x6Hp0/H7cWivyaXLTzv6g82HU3M6FFOcfcK0pQSOM+0aPSeK0BXpQ
         yWfA==
X-Gm-Message-State: AOAM533Sbr0rgabucEBfMPrMIoQGa3Y6Hvy9su5AH0z8v9mIHS+5OL/s
        ZRicMr93944bM+5LEdKmADenEfXpTWDlnnAaX4Q=
X-Google-Smtp-Source: ABdhPJwML/djCMCT82kGYGQjbMI1ve6EdTWNMM6e5g46Ft0zBtNQoW/YzJ8kF7NFFtAzbw2M/V9aeg==
X-Received: by 2002:a05:6a00:2296:b0:4e1:905f:46b6 with SMTP id f22-20020a056a00229600b004e1905f46b6mr6084464pfe.16.1646933123633;
        Thu, 10 Mar 2022 09:25:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s10-20020a63214a000000b003652f4ee81fsm6027965pgm.69.2022.03.10.09.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 09:25:23 -0800 (PST)
Message-ID: <622a3483.1c69fb81.1836f.ed87@mx.google.com>
Date:   Thu, 10 Mar 2022 09:25:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-57-g6d793b104fe2
Subject: stable-rc/queue/5.10 baseline: 104 runs,
 2 regressions (v5.10.104-57-g6d793b104fe2)
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

stable-rc/queue/5.10 baseline: 104 runs, 2 regressions (v5.10.104-57-g6d793=
b104fe2)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-57-g6d793b104fe2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-57-g6d793b104fe2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d793b104fe2cca174eb48d314b67f46e75829ab =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6229fb50b0aace137ec62975

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-57-g6d793b104fe2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-57-g6d793b104fe2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6229fb50b0aace137ec6299b
        failing since 2 days (last pass: v5.10.103-56-ge5a40f18f4ce, first =
fail: v5.10.103-105-gf074cce6ae0d)

    2022-03-10T13:21:12.431794  <8>[   32.790501] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-10T13:21:13.455208  /lava-5851925/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/6229fe6a091b68e583c6298e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-57-g6d793b104fe2/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-57-g6d793b104fe2/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6229fe6a091b68e583c62=
98f
        new failure (last pass: v5.10.104-44-gcb860ee1d45c) =

 =20
