Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A427E624F0D
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 01:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiKKAru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 19:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKKArt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 19:47:49 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052F861BB3
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:47:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u6so2963668plq.12
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mSJmtPdTzYmmc8c1PKL4Mxh1KAC3DMKkuedzr9CTlY0=;
        b=CESIa7+sHs4SFLQXsNXAHjUmKVCrhCYS6S65dMwYF1WRsTWmM87/w8M278SePmJrsM
         V7IU9dlO3jb0+5LCSVNr2VVG78HO5fgQMjvQu6Pl7RYiLM2lL+gVWc/XLENl7sAWPsKd
         z8L6B0X8a7KcHplwebRiCZXWs8O0mRb14lh/V8sAEneeTymuR879b8HW75pyzNf1Xa9P
         J26YTIVHy0Ki8HM75rUyNp3N8K0kCjXCKnH/VVG3SsxHHRlktfUrQI3teewyrG5ZzMHa
         JCb/vN/ga//7/qSa5UiIwjPbCa/vS90CWnTFHVTGBqRTnwoYNWCy4uG4YCNBKKHit68A
         36MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mSJmtPdTzYmmc8c1PKL4Mxh1KAC3DMKkuedzr9CTlY0=;
        b=yDE2i4w+e3A4j1tkm6G+lUl/AYrwFoNCbvYarusaECzfYE+MbyNvxUxFlw9YCqRIJ6
         6DDyi+qn+vqM2euZNhmGBaOeO+HErhmLOTVX0DUBXD2Su1W8gAK9GOxaTHjFvSPY+WNL
         4qp6viBUmYxIy1ke/YYkMBr5JVKxDF70/FCM4XTerflVd9doAYE408GM7bOjGghrC2mR
         OD+vGS7W0MpppC/z/6Rcygd+hjcTtYWTOnX7wZoC0yIOM+OXDTmWU9u+gT0FQqqPdYS+
         RMxqmccluHVB4b27Vstp9An4MJ/ehylZpeZasSGP+KUG/LI6Yc2uObNXNwFu0j5VaEBL
         1lwA==
X-Gm-Message-State: ACrzQf2zKKocFeNq4nN0aB1LyXVwwff+GHeh4PoVhrQ11Z3jEM9I1Q8s
        7OjxMIQcUYFin0WP2Bubs8zZVZtfAaUrTBdzk9g=
X-Google-Smtp-Source: AMsMyM6ziLOG0Y33OviY5fu+2MAeTmN8ik8Dqh1FeIVEAftY4F56E+Xv/Cd6S9t+XOI4Y902raXhuw==
X-Received: by 2002:a17:90a:2bc7:b0:212:c6f4:fa5 with SMTP id n7-20020a17090a2bc700b00212c6f40fa5mr2855815pje.49.1668127667248;
        Thu, 10 Nov 2022 16:47:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ne9-20020a17090b374900b00213a9e1ec44sm3642056pjb.52.2022.11.10.16.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 16:47:46 -0800 (PST)
Message-ID: <636d9bb2.170a0220.df233.660d@mx.google.com>
Date:   Thu, 10 Nov 2022 16:47:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.154
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 141 runs, 1 regressions (v5.10.154)
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

stable/linux-5.10.y baseline: 141 runs, 1 regressions (v5.10.154)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.154/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.154
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f5b40c0eb9ea3d8233b9a2e9af6784c81204d454 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d6f37611445bca6e7db53

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.154/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.154/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/636d6f37611445bca6e7db75
        failing since 246 days (last pass: v5.10.102, first fail: v5.10.104)

    2022-11-10T21:37:46.307504  /lava-7938207/1/../bin/lava-test-case
    2022-11-10T21:37:46.308101     =

 =20
