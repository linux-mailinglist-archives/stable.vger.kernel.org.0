Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7852DD67
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 21:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiESTCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 15:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244348AbiESTBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 15:01:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911515A2FC
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:01:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o13-20020a17090a9f8d00b001df3fc52ea7so9551174pjp.3
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QdBCV8WkUIJ5PrWJCHYdFDmWRAxDSW2nCoM2U3fcSUw=;
        b=D+1Ljg7cJClj9JCjATsiRLge8q74N+LgEn0ieV6FCl9IvU7ZhqZVL+Va5O921Cvcy2
         IH9sMtjEQAGAIfdZgH4AngWh97ZG4KACkphOYG4g7Dc95F4UfKlFf8n+K/fE5ns5yL9Q
         R/dy6HO0JhfI+R/kKy05fPuurZjGLKTR9wgLUncZ0Zt93srnKEoWi9tUKviOrR09SYdk
         k/uQ5D5jCb6hJc9jLN8UULX57QQpo0tVBtN7tfBraYacdRmP4akKI4MGd/UNtMpIN+D4
         gegAvFVCj2I82I5sfN09KvwN2CL2Drr628Jvu8L4h9bcgfzG4pDxYHzsmOQIFwqCjraF
         85NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QdBCV8WkUIJ5PrWJCHYdFDmWRAxDSW2nCoM2U3fcSUw=;
        b=O86HKQIFwDXcizq/cbqoXL1mYwvS4QD/TWKbs08trsGEyAFao3YwawX1GXAuyXqLPs
         0snzHivedvl2rHqWmgeLZeRVdXiqIzI1IqvKKOtyYyBL81RqyNKmp1gk31XcqNRyBtWr
         75HSgIw7CM9ADeKRT7HlFsrj807jZdB2ZoISf/Z/QD+5aNCnh7xJhXyPt+mxPFjvjC2F
         Ap/PgVQkQ66wrkdJrLCc9WKyZnHe9aUdqp4ptXwsAdU5vNuWt0fIzJKcte0I/LDnZuym
         Uh0BTCjVv/fMqUKsuzA9bdeLQZsmXmdhKImJjEU3hWbo8BFBsGytqFJjNNH4+CsOs34x
         /aAw==
X-Gm-Message-State: AOAM533DITNskXEj2XD4pAL4IM4uL3dnyQQaXeLkmT0faucEEujkZv5i
        rita6fw5Cpnvpuv4DGbhbbR9G+fw2LiXoQ3Npxs=
X-Google-Smtp-Source: ABdhPJzzm0E8Bi0Vah1ibDyms8yrlGMOIKIEo3PAZpQJ/5ZyzS7ZXCCZvHc+UwBcWh0ELwv57J1Qog==
X-Received: by 2002:a17:90b:4c0a:b0:1dc:e81a:f0c with SMTP id na10-20020a17090b4c0a00b001dce81a0f0cmr6739113pjb.2.1652986910565;
        Thu, 19 May 2022 12:01:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1-20020a170902e48100b00161e1a5c2easm1654682ple.43.2022.05.19.12.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 12:01:49 -0700 (PDT)
Message-ID: <6286941d.1c69fb81.3d6da.3c3f@mx.google.com>
Date:   Thu, 19 May 2022 12:01:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.41-44-g056e35d45b1e9
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 115 runs,
 1 regressions (v5.15.41-44-g056e35d45b1e9)
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

stable-rc/queue/5.15 baseline: 115 runs, 1 regressions (v5.15.41-44-g056e35=
d45b1e9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.41-44-g056e35d45b1e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.41-44-g056e35d45b1e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      056e35d45b1e9dff6f7c9c965a01548ebc81220f =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/628664b7361e61a08da39c37

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
44-g056e35d45b1e9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.41-=
44-g056e35d45b1e9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/628664b7361e61a08da39c5d
        failing since 72 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-05-19T15:39:15.217847  <8>[   32.240863] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-19T15:39:16.241725  /lava-6423834/1/../bin/lava-test-case
    2022-05-19T15:39:16.252646  <8>[   33.276911] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
