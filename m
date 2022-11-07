Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8523A620275
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 23:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbiKGWng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 17:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiKGWne (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 17:43:34 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F901B1C3
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 14:43:32 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so11728038pjd.4
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 14:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+dKrDGmy/ux9iGcUXW+omA/xHUKPKmBW+xw39EHfe8I=;
        b=kkfFET1KE2pKu+yuszeJrZs+TR3AKeD+DmtFsXvJRVzPRcrKHzaqOIcKXLE7w7BEJ9
         N4j3r4dbRfwLtowcZwFH5eTkJ4qYBNVZplVJF3GYVKk5/Zzx/nGTRfK74zavW4JuB2sN
         xlgsfqjGgq+YpLHUA8TrZ/elxHGfKDXQL9v40gZ4+cTWu2q94iMYGNXqFiuuQNqm8y48
         YVmLUy3F1zlHiNfkfQsKgsMHVAHHbv976JKDQRcmook7UO5y+kZMkqZJxS1rBPYyP5xH
         OuhlZ89rolApEH6Ycyi/Abt9MyaEfoq8cswv6wk+A0RE5E6XjcwljtZ/+kWXdx/X+eK7
         t+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+dKrDGmy/ux9iGcUXW+omA/xHUKPKmBW+xw39EHfe8I=;
        b=ktXh34EstfHT5Swpvo323+33N3nUP/nSiTeqTQ+3Uh9oM1avbXa4dLRTz63b3R80Fk
         Ojxw+Ngm9fx/ODRFHXfZyUpgAoEKlYZOx7wC4+d/yIDFX6+TY+4R/A7hAy4R8HUzZqNj
         H06hH9hT4Wg3LEFBJ6fk0Gzdxsbw7p0MIResLcycU1yymDMMfr+Gzr0xlVW/hjtUmKsI
         qViGWAzpGBYsY8txjpGDh1gVeO8GUFBVEKz62nJ3lDh/aYBRozRkkBLdac4h6BPxLiqr
         OLkwNFq+4zef3cEjBAzt2HbOPs2RNq+CvWoTZTJmBIn+WZ0hR8cFFlKYqFRQCh/5v31F
         jKIA==
X-Gm-Message-State: ACrzQf3YE0yhwDf4c9qIhYKm7xmjn53FMe2AL+MaMbIQzjCkmJRpCRr+
        WbqpX+MWTPdZDdAP1BOis2QM7g/N6xeRzrEB
X-Google-Smtp-Source: AMsMyM6WkREp7VFdZB75l/rmQaOZMNqSUhFNsdbwfCoLym0clfE7aJd7JD/hVOxnSZSXo9fAx5Yn2A==
X-Received: by 2002:a17:902:e9cc:b0:186:8816:88d4 with SMTP id 12-20020a170902e9cc00b00186881688d4mr53186970plk.59.1667861012240;
        Mon, 07 Nov 2022 14:43:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f143-20020a623895000000b0056b6d31ac8asm5152604pfa.178.2022.11.07.14.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 14:43:31 -0800 (PST)
Message-ID: <63698a13.620a0220.9697a.8284@mx.google.com>
Date:   Mon, 07 Nov 2022 14:43:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.153-112-g184d8b79bd0f
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 79 runs,
 1 regressions (v5.10.153-112-g184d8b79bd0f)
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

stable-rc/queue/5.10 baseline: 79 runs, 1 regressions (v5.10.153-112-g184d8=
b79bd0f)

Regressions Summary
-------------------

platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.153-112-g184d8b79bd0f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.153-112-g184d8b79bd0f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      184d8b79bd0f6660e0cc7d27c423b3155d5e36de =



Test Regressions
---------------- =



platform   | arch | lab           | compiler | defconfig          | regress=
ions
-----------+------+---------------+----------+--------------------+--------=
----
odroid-xu3 | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/63697723987c006d34e7dbb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.153=
-112-g184d8b79bd0f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.153=
-112-g184d8b79bd0f/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63697723987c006d34e7d=
bb8
        new failure (last pass: v5.10.152-168-g74bd6fff64de) =

 =20
