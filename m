Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD04D3959
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiCITAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiCITAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:00:39 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3A79E9C2
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 10:59:40 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cx5so3183270pjb.1
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 10:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k0AX3Q9YMBXYjJN2Kbd7c5KqUKC2H9oKk+OaWw9k1TY=;
        b=b3TWPj5cI6Gmy2k7/c2OmHUyFq1VTo1eiMsmrxEhW0/6d8nklqTNNomUOt/OJ6J99/
         yfDuKi7zOR2AJ21/oL7uJvs0Fo1AZpsty70OLp3oB993edhymYAV3MY1hCuZrkmZa41E
         M4KIS98BjqpCzRgwsoPAHham0jlnSuMKmCyVZEItP52PuWlkfclQWK8KCbjJqSsJLfug
         kRrBYWRNpzh9xqZarsq1+VD1CsnAO5y5VKvtKwivlmCwbAgik8nNNHZXJCU2UKRiJcQA
         nBpALLH625CdDaWRXSDLLOZW66+dv0f3ORDn7XKjHXLONEH5QkXTZZEWrPxtbLJdNE5A
         7M4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k0AX3Q9YMBXYjJN2Kbd7c5KqUKC2H9oKk+OaWw9k1TY=;
        b=l6C1JaxV5PXiOyM4j3brNzqtTHr+PnJuAnBjzppvxjzez1tY277C5AW+IalfMpZS7x
         HDGpL+XHvmy7I5D7ecib9pcv+ZRLZrCd5E6NNwj+nFQ8ZGD0rhhwbz0ckTUzBDihZeLj
         xtDUnpHzJZ3i516Oi/0pn69OYp6GBwc0EXBy3ZXmHDVvym0d46tyMTy3hHSQ3IOCJ1WZ
         RqlYBmBTKBx6tp+KEdeD46vpxYiwVBk1CuetY64dE0sQDwjo0K8eg8TSEsAVSbluD6NU
         m69PgHPRwNjuksc10OI37UV8+yEfzA0FiaAxirNpBadn3IFVWJTgfQstzUSc1KIzD/s3
         Dj9g==
X-Gm-Message-State: AOAM532GIAAR5De+2zPgqNanWyeB1RlpCtG4PffwMggdGTRLUrpebYJz
        ekf4c+mu6M0HFZRuRv6hoepGuAp9fhnjaaljTXk=
X-Google-Smtp-Source: ABdhPJyWIdGjNCDERtARivSQ5yKlfZUqJuWBoBYkwSKg3XXFSTmu1JzVDQL3MTtYNJGZsoNwr5xKGw==
X-Received: by 2002:a17:90a:fe14:b0:1bf:a3a0:d212 with SMTP id ck20-20020a17090afe1400b001bfa3a0d212mr889317pjb.207.1646852379794;
        Wed, 09 Mar 2022 10:59:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y16-20020a056a00191000b004e155b2623bsm4109907pfi.178.2022.03.09.10.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:59:39 -0800 (PST)
Message-ID: <6228f91b.1c69fb81.dde32.a41b@mx.google.com>
Date:   Wed, 09 Mar 2022 10:59:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.27-43-gfdbaaabda94c
Subject: stable-rc/queue/5.15 baseline: 96 runs,
 2 regressions (v5.15.27-43-gfdbaaabda94c)
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

stable-rc/queue/5.15 baseline: 96 runs, 2 regressions (v5.15.27-43-gfdbaaab=
da94c)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.27-43-gfdbaaabda94c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.27-43-gfdbaaabda94c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fdbaaabda94cc954d7f6758b492f45bad879ee32 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/6228c4975564b86c03c6297e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
43-gfdbaaabda94c/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
43-gfdbaaabda94c/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6228c4975564b86c03c62=
97f
        new failure (last pass: v5.15.26-42-gc89c0807b943) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6228c42cb1c4124bb3c62973

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
43-gfdbaaabda94c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.27-=
43-gfdbaaabda94c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6228c42cb1c4124bb3c62999
        failing since 1 day (last pass: v5.15.26-42-gc89c0807b943, first fa=
il: v5.15.26-257-g2b9a22cd5eb8)

    2022-03-09T15:13:30.331490  /lava-5845911/1/../bin/lava-test-case
    2022-03-09T15:13:30.342016  <8>[   60.922831] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
