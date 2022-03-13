Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466B94D721F
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 02:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiCMBis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 20:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiCMBis (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 20:38:48 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147DFFE427
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 17:37:42 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e2so10775164pls.10
        for <stable@vger.kernel.org>; Sat, 12 Mar 2022 17:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LoqaMC6um6lvHqSB256sfRPJWZCgm+6v7LsMci7pUWQ=;
        b=t3VRjAvhJvavNNwMUjGeLuheskvJsue6nuweK6qKplvgctrfEGjw6awndb3jY5dvgz
         HZzrQ720yyyOZKm9vjPS/gSCPTAMsjgp2WFcOmx3HYMTSQm0+A+Q9Sj7y5nTXjSnHMjY
         +g5lY49fM/QHRiaPzP2QV35RlgUIiFH4FlQv6v6RO4Cas3sLXnv9rMVAYVtNUTWiXDke
         SEQ3SFbs107qFGF9U/oW/1mtWYzO4J1bCSKN7wFQPfhjLOQci6uRRdBQOQYco7iIwDX9
         CkxFrLGfUPvLR87fcSASEDFzFA1Lbt/fErFr3OEmu3kBC3pNgKoGh94k351bodhGPPsI
         luXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LoqaMC6um6lvHqSB256sfRPJWZCgm+6v7LsMci7pUWQ=;
        b=UUL0PjEc7E1XazD+OQX2jDzsgyiiBzMO4+3eET4tpC1OM5PTRMUjGMvVxCHkr8U/Tj
         EWsnR0uMXSSV8Uy/hWBnN8gcNvF8qy83FoFxP6DY2MBes9TpHpnPDiTdf0A7P7ZtRdUq
         tx9rLYzztyodkxDgTPloYrDNx03HvUSiN3S63XMh85gBzNTeXfSEeLgGCF9FIIERdbll
         j39z2VXnUaVM2QjRvrz0OY27G7dOOhFo5ZB2NtbbEZYMY3Kk6c2oziBZC705LPRBtmjb
         c0wteAQlscrpRYV/DbW4Kf1stoxyUnr84V1BL8f4cm99hGZcE775LwV3mEq6uc9LUXkU
         jZbA==
X-Gm-Message-State: AOAM531xhP3dVxb6axRiHjeJSo5yXgJYCaKXpBUxIw8optBa7t9ZCR06
        pSj4QDSW1e9uG7psFVnoK6VbK3YJmlA39x1pxXM=
X-Google-Smtp-Source: ABdhPJypOIEimPdrhTcG/5sNFgqy+/WL6DeKSzeHArCBuZxLZi6kntXNyOw0+liNun46y5e4j38TtA==
X-Received: by 2002:a17:90b:1214:b0:1bf:f7f0:81a7 with SMTP id gl20-20020a17090b121400b001bff7f081a7mr16475091pjb.146.1647135461475;
        Sat, 12 Mar 2022 17:37:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi10-20020a17090b1e4a00b001bf9749b95bsm15956037pjb.50.2022.03.12.17.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 17:37:41 -0800 (PST)
Message-ID: <622d4ae5.1c69fb81.ffec8.8bca@mx.google.com>
Date:   Sat, 12 Mar 2022 17:37:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.28-100-g531348d188ce
Subject: stable-rc/queue/5.15 baseline: 113 runs,
 1 regressions (v5.15.28-100-g531348d188ce)
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

stable-rc/queue/5.15 baseline: 113 runs, 1 regressions (v5.15.28-100-g53134=
8d188ce)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.28-100-g531348d188ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.28-100-g531348d188ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      531348d188ceeb9debd3fd9748beb352252c68fa =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/622d160f9a2a1f1457c6296d

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
100-g531348d188ce/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.28-=
100-g531348d188ce/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/622d160f9a2a1f1457c62993
        failing since 5 days (last pass: v5.15.26-42-gc89c0807b943, first f=
ail: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-12T21:51:57.061793  /lava-5867464/1/../bin/lava-test-case
    2022-03-12T21:51:57.072953  <8>[   33.691909] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
