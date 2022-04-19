Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5674506209
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 04:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbiDSC1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 22:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344443AbiDSC1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 22:27:04 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370062C116
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 19:24:23 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s137so22277524pgs.5
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 19:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R/NuabtUnJpQV6IdzCzy+LjOVUkSwfdQl2Q1XbqZY44=;
        b=Q/33kPjhBS87QW68JdbYpDkuEhrer1+cgbGjYKqV32HbSk98ZTlYuXyFdka4ebLZ4U
         hrHlMrpumIE6Z/EBctNiKpOV+yCF/N7DFBQuDNwX8huutRGdInmZ7F/SB8mVRMgREHx2
         l39pKGhSkkUxmcipc7o62ckklqForDfvgz0j0TIXUTHIdKVFzAJpAvuIA61gC6eluR1O
         L1GFiNJe2uJfAHDA8f/BpIUCeSgIXIw2NwgPcBxxfF+QCcPPsZt4ZWLr1O0FnYpsNtt4
         LdXBkwCwDiGcmDhRHTG7CXanRbUDE7Hk8K2ec1JMlqUA686MZ8K7DbZP4KV+2HuXEmAY
         5Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R/NuabtUnJpQV6IdzCzy+LjOVUkSwfdQl2Q1XbqZY44=;
        b=YaPZg5tjPKjachwUzPpxz6NoaHPEiuo4BdOnbqmRHI0cJ69ghLkzYLCeYFkHHwk5kt
         +gEnkSA9fXIu/pPNzSemQeBnl2DG0BCVsYOUJSaM+7ITyXBnQ6aN7r3EU5Y6pWah7lHr
         XmkXptqMG5tw2sDWJ1TskYnMpyZVBq9T/rFoHJqWhoiX0fGVs0L+zuvT2OL5kbua9DJj
         Nxb1lu4VXQ4n4vYcEuWgtNsAZUhI600tHz6ID/0yjQ4zPumrGz4Ok/fRjOJAr+LIXgez
         2o00UwJLk6N28Epa34T157ebR0Udj7J056GNKUqG89+pxCHilLMwlZketmp7xn4xlOOI
         uhPw==
X-Gm-Message-State: AOAM531OJ0sogmodrrNjkcpBmXw4fOOk2fixN0NRMDUGCiJdecAXI4Cy
        Bb/ya5yFbSzb7Ff7COrsRV9QC/hAoKSLxpnA
X-Google-Smtp-Source: ABdhPJxJ/pRdzTj80CGKvFpTB+goL2ocnKwpkXzLPO6CXy4vRmCSzbVPDWJDR3dyixIIcxJ6w7nSbw==
X-Received: by 2002:a05:6a00:1c5c:b0:505:7469:134a with SMTP id s28-20020a056a001c5c00b005057469134amr15341379pfw.16.1650335062562;
        Mon, 18 Apr 2022 19:24:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004fae885424dsm14690203pfx.72.2022.04.18.19.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 19:24:22 -0700 (PDT)
Message-ID: <625e1d56.1c69fb81.6727.2d2e@mx.google.com>
Date:   Mon, 18 Apr 2022 19:24:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.111-105-ge7a4ce8e03724
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 145 runs,
 1 regressions (v5.10.111-105-ge7a4ce8e03724)
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

stable-rc/queue/5.10 baseline: 145 runs, 1 regressions (v5.10.111-105-ge7a4=
ce8e03724)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.111-105-ge7a4ce8e03724/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.111-105-ge7a4ce8e03724
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7a4ce8e037246e04bedc9189e47c69fde914c9d =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625de702cc00b50868ae06e1

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-105-ge7a4ce8e03724/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.111=
-105-ge7a4ce8e03724/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625de702cc00b50868ae0701
        failing since 42 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-18T22:32:17.126232  /lava-6118737/1/../bin/lava-test-case   =

 =20
