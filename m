Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27716519304
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244054AbiEDAyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244858AbiEDAx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:53:59 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC2E02C
        for <stable@vger.kernel.org>; Tue,  3 May 2022 17:50:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so3831392pjb.3
        for <stable@vger.kernel.org>; Tue, 03 May 2022 17:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2qDfP52BylJjlCxrz+im9Tjk6/G6UXrSwPRT+ocLcgI=;
        b=rJTMqT+tH9lGd3b/z2A5cn6W3q4S66L1Jt96RDRlH/1ZzQp2iBEtuJMibPKTdmdS/+
         5RJI/Sdaggc2Gjs+mSui80Hpe80vLLE2Bi6n0VLPFsKYz0RE7xjKceC+3XFPAFrI2vQW
         iZUZtl35AEvWNI7dF2e++l4+t2lmvIF35hL6FWAWT812fe8CxukP+ydVfB5E9egvYTTW
         uXcaRnD6vWM7zIdjBhcdN0YWZQ4ezOkjRggDOqlSCjVrMcWavGrBUxpRhJoSHJKnZA+g
         Okdz8hXSCKwdvK2aKPAmNij7R9/34UAXlt6nGKwTKfuZrgGnZZlR7cLKyOxqS2oTj94W
         t0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2qDfP52BylJjlCxrz+im9Tjk6/G6UXrSwPRT+ocLcgI=;
        b=5rORi9rByknxFqbcYnS5MARwpuI0ZHSLPAYZbCMl+zxjlmfFkiD42NB24eYpwsJZoc
         On006zVuZQI/5gy4cJevtPbTAjvMMTF9D1u+iGx8s9QtrPyEf8JZnU5euvLcTpTRpCOX
         4ojRdjcxn0F7Ew5sf94NbK8mKao12uaaO8XFjrYGSEL9WvMPMzyZMR75usI2pWowVfBu
         ldgls3+f7EsNK2azyJwrPawE4FNQMes7gVCoAmTc6BR3zAAZSn85m4eWEyY+vG2EM61s
         Ywr5Rp5oO42UMY+x4F9ILO4jNirvHB4TQSyIlExViTAz+84v+JxMy0d9pQHn32zCjZwU
         lYNw==
X-Gm-Message-State: AOAM533HzRnqImvcvO8bJjmqrY6mRvj2dBOVg74kd06ahKcYtaYEE8vq
        eqGc3dt57BkitF7SjdNWXUgigboi4fYdlFDYjOU=
X-Google-Smtp-Source: ABdhPJwrEulRO//E7NAD/d5CjCHRXBZ/lzdhfx90UyGu/P+7raugzYTlv2lBTXtuRYdl1w/s9oHPtA==
X-Received: by 2002:a17:90b:1b52:b0:1dc:54ea:ac00 with SMTP id nv18-20020a17090b1b5200b001dc54eaac00mr7681745pjb.99.1651625423259;
        Tue, 03 May 2022 17:50:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c20300b0015e8d4eb20esm6940092pll.88.2022.05.03.17.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 17:50:22 -0700 (PDT)
Message-ID: <6271cdce.1c69fb81.639a4.1679@mx.google.com>
Date:   Tue, 03 May 2022 17:50:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.113-128-g9dac235e860e9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 129 runs,
 1 regressions (v5.10.113-128-g9dac235e860e9)
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

stable-rc/queue/5.10 baseline: 129 runs, 1 regressions (v5.10.113-128-g9dac=
235e860e9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.113-128-g9dac235e860e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.113-128-g9dac235e860e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9dac235e860e99b2d161fecdf616cb87f84d973c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627149b175ac758b74dc7b41

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-128-g9dac235e860e9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.113=
-128-g9dac235e860e9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627149b175ac758b74dc7b67
        failing since 56 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-05-03T15:26:33.231343  <8>[   32.978625] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-05-03T15:26:34.254418  /lava-6251218/1/../bin/lava-test-case
    2022-05-03T15:26:34.265875  <8>[   34.013272] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
