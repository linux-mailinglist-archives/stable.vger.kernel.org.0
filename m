Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446D46772E0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 22:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjAVVxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 16:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjAVVxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 16:53:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2A716324
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:53:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id jm10so9680580plb.13
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FuyAKfJHqwY8UiduTGXFJg8s+L7dzPtWDtfJVFNdGu8=;
        b=weBa6kLDHffB7xPuPxz0QtVqRZR3MObTAYIGMmd13Yoz86M7pshD486j5qfpVOn0WA
         B9qJOKqF/9oIT6U+VT/JnpbuosimPCDJP4kIpabm8R0l1NNrHPXsHAsjNQzJesEEy46b
         itCMOziY0PwEVP/G4tHcon99muAnUvOPwv8BkBRb/o8MfhxMNXkExbwm86QF3TxPEuXc
         l8+m+03lzYn9Omw0q6LquJoH0fvb3Gs8zYxYaAFK50+QXa9eKPLk9co/hLev9NqGa707
         2tJ5kA+51APSUTyaa3+q4THqRHuUFWf9gHOZ4/weXlgg2rxWR3XGCeut84dzWO8rzMNC
         Zrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FuyAKfJHqwY8UiduTGXFJg8s+L7dzPtWDtfJVFNdGu8=;
        b=YuzeBtLhFdVZdsEQFYvjU+zCTWke6Z++qI6tIvuSbrBLU9MVPIk7E4mm5snPUaL4l3
         +ypQLVjwKbN8o5Jl0XD4JHBY8hNTm/01tUOhSaBNF+yAJ7X+emz3PXwaZbSZUnXhbzjG
         ir555PgFyj3iWWbgqEeOYRVy1XjbLmFgSS3+1dIa251kVwqHNFrTb2Fpqg+4xrFBQ14b
         X93XwL6NiKIce6wD48BKrZ65e+hIdEK9F+P0w0vPhwSYyt/2nHMKLz2ZbHCYKHdvS6vb
         URtMCoWMjr+CsOC5TowtgtU2FIF9hhpw0EKKurwAgwYXo8w+xaGumQRvc7pMlp6CQXUU
         VQyg==
X-Gm-Message-State: AFqh2krtkj9Hkhbtr6jrBuMlIHyldM3pR1gSwLrRScpd/mcY0v5BO1X1
        uWV4Gz+Q5p9FDM59f/w3bBr+WxBHTONJhN3hKEI=
X-Google-Smtp-Source: AMrXdXsDh8DpxM13Nb9iUHrGdMtDeeXyWX3Ynszie+KfTZDibPnQmQlmp1mTaWqz83wGWWrD12jMXg==
X-Received: by 2002:a17:90a:138c:b0:225:c317:137c with SMTP id i12-20020a17090a138c00b00225c317137cmr23326140pja.36.1674424400712;
        Sun, 22 Jan 2023 13:53:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w62-20020a17090a6bc400b00229f68ba7fbsm5189235pjj.19.2023.01.22.13.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 13:53:20 -0800 (PST)
Message-ID: <63cdb050.170a0220.2c182.73f2@mx.google.com>
Date:   Sun, 22 Jan 2023 13:53:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-218-ga350f1c8ba8b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 164 runs,
 1 regressions (v5.15.87-218-ga350f1c8ba8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 164 runs, 1 regressions (v5.15.87-218-ga350f=
1c8ba8b)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-218-ga350f1c8ba8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-218-ga350f1c8ba8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a350f1c8ba8b633cc6376e13242df0daa27a12dd =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63cd7b4dc3360ab214915f0f

  Results:     156 PASS, 11 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
218-ga350f1c8ba8b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
218-ga350f1c8ba8b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.i2c_hid_of-probed: https://kernelci.org/test/case/id/63=
cd7b4dc3360ab214915f6b
        new failure (last pass: v5.15.87-171-g094b789fbd4a)

    2023-01-22T18:06:46.873629  /lava-8833843/1/../bin/lava-test-case
    2023-01-22T18:06:46.879671  <8>[   52.096795] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Di2c_hid_of-probed RESULT=3Dfail>   =

 =20
