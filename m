Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2801E502F54
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 21:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349153AbiDOThm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 15:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348162AbiDOThd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 15:37:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680A049F19
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 12:35:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q3so7836568plg.3
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 12:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=04Wfnq6fC97To/ml+7QZvUB10uKoCK64QGxmHVaAENw=;
        b=IHweF92ltVldL7ziGPeUDgcxgCyM4+wmGIsZY6qQGWPiPVtUA3gLxmYrC/IBK+7f5T
         yUKuaiatk3LgLP0M8359K8t8PKhj5Dz1c7QVsiq8pYDsnbpoRJciPfiTCzH6rrwNtryj
         mwmK9V9rv7dPnB1LH40pMVPht8alIW8O3jWRPzT0HOmfGKfuDJs+IdSh9+vU2DhwR77Z
         Exnz3qj8cBVvX0I1a97hKkj4HsUGkVRhXrgdpye3hlJo39wZ4vnMI7IwD82pqJStJEbh
         hJ0nmqRfTGTKC+tzcDG3sCVuCbqlO62ST8YoNLBT0bSOfq+K8xMTQpgC1VcpUw0HLsJr
         1mMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=04Wfnq6fC97To/ml+7QZvUB10uKoCK64QGxmHVaAENw=;
        b=n1u22rBdND9uXrv8G/zVZJx5XpcyQsE9aItFpiJoJPiYjvOsJBamtneOwwTb35I4rs
         Rkv/DBLfU0e54+lGUfMXTXFm1sj9tS582UFxlEOxP04W3VcPfwRcQ8v74Ib8Q3jitIqn
         Fni2R86BXqNxCGzKPCYLdQzv4Y9hB4rX3CnkVMTRzxlSnslOgKvXIWg2/zUJatwMtdyj
         o0rVtMNAoVVGyBd4UWOx/fwsvEpo3fDPg9JIsyY0F2aQJJkj7ixSYrN7JfamkUWIspGw
         Qf2hqhJdWEe30+kdAUPXGDvIZ7+0yhr9Ct3aqP+g487BolkckH92DFC9/iCNuk7Ou5Qj
         ODwA==
X-Gm-Message-State: AOAM533PstBOjaNQaVAWkVG3a8RwCBimBQQzGofT3UxY8Mn8WvjV50Dy
        BDeI7IobFzKzMLWdRzFtPzPHBAA6jK6kgbM2
X-Google-Smtp-Source: ABdhPJzke72rWb/QYni2iRObBMitLk2/gTX59HVoLIhKydT5PwhzQUDIjYDzvnNpn0fkNfSeA6kwwg==
X-Received: by 2002:a17:902:ab01:b0:156:f1cc:6d2d with SMTP id ik1-20020a170902ab0100b00156f1cc6d2dmr334868plb.127.1650051302792;
        Fri, 15 Apr 2022 12:35:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79d84000000b00505f920ffb8sm3601830pfq.179.2022.04.15.12.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:35:02 -0700 (PDT)
Message-ID: <6259c8e6.1c69fb81.25f85.9a37@mx.google.com>
Date:   Fri, 15 Apr 2022 12:35:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-6-gfd52dd72478ce
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 139 runs,
 1 regressions (v5.10.111-6-gfd52dd72478ce)
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

stable-rc/queue/5.10 baseline: 139 runs, 1 regressions (v5.10.111-6-gfd52dd=
72478ce)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-6-gfd52dd72478ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-6-gfd52dd72478ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd52dd72478ce6c2ec00847b959b153328b5faaa =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6259971a9eb394e40cae06e1

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-gfd52dd72478ce/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-6-gfd52dd72478ce/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6259971a9eb394e40cae0703
        failing since 38 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-15T16:02:15.729647  /lava-6099245/1/../bin/lava-test-case
    2022-04-15T16:02:15.740491  <8>[   34.007036] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
