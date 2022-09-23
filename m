Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8717A5E801B
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIWQoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiIWQne (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:43:34 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46703115BF0
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 09:43:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 3so759909pga.1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 09:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=lLavvycl6amnoNBffWbpTjRpscXmApWDrVOUYyGEu+I=;
        b=FYqjrL7d8bdN8X6XK34TemDnLqWP5BzYWCrHiXi5oajkZ/56fFhmTka28HuK4b1pOb
         wUThFYTONY8HmgYRJL5pManejpPNyoTPbOFQh86vWQ4j0OhV72S60BjwlmDNpkchjiN1
         6wvq25+kgtlWNCKr1dIzO5xfWmm1f0wEeXQ1aVJktDcE6o4SIkV0yYcwlEqeUhMDT8Zv
         /M9qCGHEUJR6dFFh1byUu0qMu86UGlYkBbpHW84DLdLiu48RfoB1OiPT26N4GhFlQnNm
         MQJ0cJQ8SrAJ+e9oEcNXwU29hVJ+AG5cgrlX14Muh9NQm07MQsI9p9fdACGbo6PGsxsL
         sYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=lLavvycl6amnoNBffWbpTjRpscXmApWDrVOUYyGEu+I=;
        b=KfuDdp6PK9b+GXwz68m33Ayr/QU4uvyH4snRpk/Cf5RZ/p4GCr0NiAZKLVkCyYEzJl
         QJlHINJPzbl6DTRiM37vsMPqlHDu0EWpfmEONVQDU33WGRYccge7Mq695waVLdqGexY9
         ueotMCeD0qIIoGyWiTRccXL8OsqzMKlzoV6AnB0P7iMzbXQ5NEmDikS1WVesAgDJd/iy
         zl085g5uD3S8EYnUUpVhXFG4ew11nW0WB6Qa4G32iZe6siMZLUHfdHgKFtX5p8idU2n1
         8PDGNVDCTd9zwCVF+EyZwu0gC19O7TxUjMChuj8fN5yiiSQDtxskm/lroeB40xELdWHx
         CKVQ==
X-Gm-Message-State: ACrzQf3yjRBzCm591923R36an44+sk/0oH00zFf/5+vaChP6RJtzX9Xn
        /XHeVkBU/TSx9smiDLadOQdfQhvnpl+iFf0F9HY=
X-Google-Smtp-Source: AMsMyM6EsP21puqS5z0IKfpvXDcX7zln/4Jlx8zOUqtdHDwkwcYgYcwfzhsS4Kq9mNA+2KWjyrmDkg==
X-Received: by 2002:a63:1750:0:b0:43a:9392:2676 with SMTP id 16-20020a631750000000b0043a93922676mr8380364pgx.463.1663951411490;
        Fri, 23 Sep 2022 09:43:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d27-20020aa797bb000000b005411a68fe74sm6580474pfq.183.2022.09.23.09.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:43:30 -0700 (PDT)
Message-ID: <632de232.a70a0220.f9c8b.dbaf@mx.google.com>
Date:   Fri, 23 Sep 2022 09:43:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11
Subject: stable/linux-5.19.y baseline: 98 runs, 1 regressions (v5.19.11)
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

stable/linux-5.19.y baseline: 98 runs, 1 regressions (v5.19.11)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fcf22aefe87101424563a8dd8adec8a75b8c7576 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/632dae820dc38b0fa335564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.11/r=
iscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.11/r=
iscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dae820dc38b0fa3355=
650
        new failure (last pass: v5.19.10) =

 =20
