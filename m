Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0157F06E
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbiGWQaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 12:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiGWQaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 12:30:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F186FE0FE
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 09:30:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y24so6931715plh.7
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 09:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EvvJUGSzFFuzWLWENq81wbpyq7HaF6X6vQ9I/vS8MPo=;
        b=ACP9/yfo2Dpw1R6YmF3KadgJvekiu2wawfjQQG6TVIqJW6SDnTnu52nbPhxxZe/kwA
         5wWSsKSOEv7gPJV6MRJdKzjVcI/wLoJ0AW64tRbqfK82xHvPUO8jBrcObHhcoDAkemVm
         Kkf5E2Vr5+v4Vwt9EBqJxp+H+48PNAvxb/mBduPFwm0XkhgMBAfIXIwRb/+B9BAzAwAD
         vSq5BwWD9mKhxGMwifyJagXlTcY/GejGEf+LWSKzsKIPAiR1XcCtgnEfxT4aAmpp8T1h
         Pe9HjQjqELrFDFpXmQAQS6CDGYubprIeTR+iOWuECPF+7VAN7NNJ74emgPRBDgtzgJ9Y
         BwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EvvJUGSzFFuzWLWENq81wbpyq7HaF6X6vQ9I/vS8MPo=;
        b=8BsP8DmdbLwdNYiZEcOXhX2KU8NH1qBu3ilLGfIzGsKVcO0wJa9MmHKt3qivTIQKnu
         vpJ6V64womsnaCZteCbziVSFSL1FdYAGD+a9SIxy2D6z5rKWrZVqBD4UJCjal3omP7//
         bkYuFJ2ZA+nJv40NFwlrSAGK7vNGyjE7GRTP7bqr5xUYuXCeNQVTVYSdlr+NBF/9785F
         /TkDX4Dbtlmq86plbx2GGUsWkQXtwMG1sKYDwC0oG57snKcogfE/v8n7FUrcxXH3JzeN
         1vO//zZPaP4KWoaVwt6ix9k6KWCtyI/S3a8djiFN59c+fLBODIbkVNSvMesZELlNyMi8
         k9Tw==
X-Gm-Message-State: AJIora+4ei07+1zpnnsZLlrYDtqbmPMuwpJ2xsI86Gm7WGsYihIWUtea
        NY+v/nLkitrT23awl8YO8byUiZpvSJUjyrCZ
X-Google-Smtp-Source: AGRyM1tTZ8k+l4GMWWIIpFoYHlYjchj3yYI8dVx5nPdvwnqantDhwsq/WQKwhQfo2Xx0tupKagpK/g==
X-Received: by 2002:a17:903:18a:b0:16c:4f75:7297 with SMTP id z10-20020a170903018a00b0016c4f757297mr4773877plg.133.1658593817142;
        Sat, 23 Jul 2022 09:30:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9-20020a170903110900b0016be4d78792sm5939061plh.257.2022.07.23.09.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 09:30:16 -0700 (PDT)
Message-ID: <62dc2218.1c69fb81.eac29.96fa@mx.google.com>
Date:   Sat, 23 Jul 2022 09:30:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.57
Subject: stable/linux-5.15.y baseline: 164 runs, 1 regressions (v5.15.57)
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

stable/linux-5.15.y baseline: 164 runs, 1 regressions (v5.15.57)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.57/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.57
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a9e2d8e52e1c0d87c0fa4f9d2d38e210aabed515 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbf08c17acbe1759daf076

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.57/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.57/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62dbf08c17acbe1759daf098
        failing since 136 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-07-23T12:58:25.385748  <8>[   59.920655] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-23T12:58:26.408990  /lava-6877238/1/../bin/lava-test-case
    2022-07-23T12:58:26.419299  <8>[   60.955364] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
