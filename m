Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC84D0D23
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 01:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344157AbiCHA7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 19:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344146AbiCHA7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 19:59:05 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D7824F15
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 16:58:10 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id q19so2388411pgm.6
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 16:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0AcJkXU52zluwW/FeKX0KTQA9WY63Qz3OLSK8dp8GHc=;
        b=elC3x7ZHyvjtyMu4SICEvwaDKpnrtrjn2SCrpWoJpwbTNvXf0onSkSKtwtlBKy6i+g
         7Il7wfOks0ofOn9r2DRHjI5fI2TFtPYIrTXaneBFlqcEo0/nO3GJJBnaWC7OFk4bZKiV
         yhI7TBQZUQ1AS/f4j6ByW3CducTc0uuR4Tu+Apm5qWW/DRYQ9KjMQb+B/haxFoiP1YYd
         jX1B1gNZg2ayPsyQRjTQsPYB1cccWEQsq0IdLbvsIJTQhRx1S7Q3cc6DE/khPUJ65SUt
         bssOf7syxLkCodPHtwtKxvuDCHye3b6KYGMawFzTlIDBpIFdiAx9UG9w1mIu/REZ4ev/
         wZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0AcJkXU52zluwW/FeKX0KTQA9WY63Qz3OLSK8dp8GHc=;
        b=7Jb9OPRW6dHoFvt9sFw5ofUV05ICF2j0OaYAYmcUorpbxXnTyk4QfAu/r2IiUVKn3N
         L3BkvENI6814LUXZnDX0qJoj++ZOfKPqkkPc0K9WUI6sRsPwRg9nob2wJykc7NxzeYhu
         jBD1DxiT9C802qG456WBDAHnH5Rt5o3kEEPOGTjBNYvbTHMBRCIDrzUs7IJw0MC+2En/
         X+o1PdAjikayu+vqxhsI4D+t1AYkURUjNJDekZpEq24dvFDxZiJ8J12NzhowdVAu/2SR
         cM4Tit6tDJ3zt9fC//IBxEA6S/pyjqoI/6d1vQZMpuCmkoIGuhLLmBmuL+9Th/LVRFsY
         DU8A==
X-Gm-Message-State: AOAM531nim5VuTvyGleOLh/x5WVulmar6UJBg99GPd3uY/gYRAeD/0rQ
        Sqrywml5gLXSEeyOP6uppCc8YMM4wntQWAx5r1Y=
X-Google-Smtp-Source: ABdhPJxkCumi8q+Bjn7Qr9FAwAPShGYwVp7jqUt2HdiwlqljdHTFtpyTaYYHSXWwzmZqeHYmAeVTOg==
X-Received: by 2002:a63:1662:0:b0:378:8b0b:1c9 with SMTP id 34-20020a631662000000b003788b0b01c9mr12341347pgw.537.1646701089683;
        Mon, 07 Mar 2022 16:58:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7-20020a637a47000000b003803fbcc005sm4563514pgn.59.2022.03.07.16.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 16:58:09 -0800 (PST)
Message-ID: <6226aa21.1c69fb81.6f436.b485@mx.google.com>
Date:   Mon, 07 Mar 2022 16:58:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.232-53-ge227a7bfe445
Subject: stable-rc/linux-4.19.y baseline: 87 runs,
 1 regressions (v4.19.232-53-ge227a7bfe445)
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

stable-rc/linux-4.19.y baseline: 87 runs, 1 regressions (v4.19.232-53-ge227=
a7bfe445)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.232-53-ge227a7bfe445/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.232-53-ge227a7bfe445
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e227a7bfe445a282a8ba16771c3716b19839820b =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/622671ebc804a96074c629ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
32-53-ge227a7bfe445/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
32-53-ge227a7bfe445/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622671ebc804a96074c62=
9ef
        new failure (last pass: v4.19.232-45-g5da8d73687e7) =

 =20
