Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC748FDC2
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 17:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiAPQFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 11:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiAPQFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 11:05:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365E4C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 08:05:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id hv15so17758053pjb.5
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 08:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1aRSxaIMfAPJYxTSSX9fqQlUjG+QIdmAN7BxQ3ncPyw=;
        b=ZARXqX8x4y54jWG0xPpJ6NHwrWlQps/Gqrw13dNnWqJ3HTkV7e+ywsqJ4P6TbtSqVb
         b6RQM5nJC6shqkd+4Tkk8HC7NeUEjOZK9/LwbHFBUZpjoMwZTDbfH/QkQ7Wr5uFIyCId
         /OOgEUDb/kwPgSFXT7b+o6el+oDtNv8autQr05PnXx4Ph8LzkW4dnNL1Ik/f09b8g8IT
         t2+B+wP7aaMCwk/dlSaGSGWgsJbhC1OMMNsKc1RKcn7gKayJJ8Pxnup2ZiJ4FhFvs8ra
         kxRsolvSAFAwvJAnIS2bLbzICAt/6CnzuqDVLzca7OrY6BLByBVQ4UddgXvp1WdXlCdE
         gP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1aRSxaIMfAPJYxTSSX9fqQlUjG+QIdmAN7BxQ3ncPyw=;
        b=rxoFCSqPubmk+6mpMDVURZgV5dh+ZWg01ndXD2mqhc/CCDv4EDdfmKBC5LLH5DbUTs
         FBXITRkko7MftlDxPilRnwkwBIBMx2pvGX602leR5x42y10iyaiVHqulYi9hmBykIKXq
         qYzqarmzsrxiskkXzZqik+dlParM5dEN9Vur5D72TDibSvoFiwiOMWdOhPaOjc+seE7J
         9DJgKXcbuWa2zf/+wA/qBkYj212NepawMe99Cq8g6yEvivR/5fhJXvnGU6RgEe8YIc7i
         19sdu+P5EvloXfbw1sehs08SNgVpeMkKLK2+igo8eJEigYyjWWqe9OKp5TK07GRh4Tng
         JFPg==
X-Gm-Message-State: AOAM531cbhlfEG9xjeAjF7qvgTRE1MmIIBhOy9s7NaVwR5J0FAKLchA3
        3Defqaw8T5JgBzv4kK/bDm6U/a0Jrix3X8Am
X-Google-Smtp-Source: ABdhPJyO/ZJcjnOuf+z2lbZKcC0crykZzd5O6ji/cYU05loDiDq2sojCvtlEJ13D4WIGDjJvRfP8jQ==
X-Received: by 2002:a17:902:b68b:b0:14a:b4c8:2aea with SMTP id c11-20020a170902b68b00b0014ab4c82aeamr2307300pls.148.1642349109523;
        Sun, 16 Jan 2022 08:05:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p18sm11311582pfq.174.2022.01.16.08.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 08:05:09 -0800 (PST)
Message-ID: <61e44235.1c69fb81.ac13d.ff54@mx.google.com>
Date:   Sun, 16 Jan 2022 08:05:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 165 runs, 1 regressions (v4.14.262)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 165 runs, 1 regressions (v4.14.262)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ba8e26127c393c32776dff6d79c5b82de6dc542 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61de778d64d5cb4c02ef6759

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61de778d64d5cb4c02ef6=
75a
        new failure (last pass: v4.14.259-30-g5ddb49631ce8) =

 =20
