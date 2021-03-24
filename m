Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6253C34836A
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 22:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbhCXVIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 17:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbhCXVIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 17:08:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E0DC06174A
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:08:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v186so15592280pgv.7
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 14:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3d6MlsoHj8V9CUJst7rViKoJPd2S2E5d+RrYqPqQuho=;
        b=Sbz3M8ZMCPuRs0GMVFw2Gm3jJdsRSInOu6VgGKfBmhB5hpT+NWK6Z2qVHkBmBQzHX1
         3uKmyCY/0wtUwELtY9tprrM57nRVB+i8SvpGTyEpEU4MmYsQxIZy25IK9Q+5Z9nyhSFn
         p1H+flaDo3ifFg0vFFtiqvosjS3FYzyjUCqlfOhdqyLV7k2R3b93nCphsdJhKbcZyoPu
         MXXjTl9CZPY4d91A9UkAaf5JH6PRwvQ7QZPO2mST0Oe5+f2SIUiEJfvDI0eKAcxfOsmA
         qhoyzunEW39vwcNAOTF68zEBq4F0KnYEEQhyDd/v7EmReqwgiKw+SiKyisG3XSvKpw9e
         r+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3d6MlsoHj8V9CUJst7rViKoJPd2S2E5d+RrYqPqQuho=;
        b=jRiAgaXq+Cad+gURbaEipvziv4EZyFPYtaTvJgQWbc2wf+b31FMHbdBm+0j9q23Cjt
         SB3soGUCY1WoJLNR2eXWP06i7t2fc7lN6jdJM1n4b9Ws3O4v2YCHu/IQh3FHPlO+AwP0
         C6oBTf5pd/p8BcpNQfrfy299SUEIy1efGSaUbv30RZVstjOc/NcKD3Ymca0NEU10uaCs
         9Y9Y59D1jeWpS/QQefwwjZN3eP/5Dd+71v0CMBVJkshnDv8sB4A97AVdOFk4G4qJ7/Ut
         Psu8eJqoZUC6Ra7n2jYvt6A7xxShV1CsyD1i+uavmgKaZekgW0sEQYbgiyMN/Qu1+CW5
         RWZw==
X-Gm-Message-State: AOAM532VF/zRD7zvxHJMSwSS8HM0mElGqutDWozuqwjsIUL9vJV9Lv7z
        RAFN48RaXo8rJaCuAnJikSSZTQd5R2I/gw==
X-Google-Smtp-Source: ABdhPJxC+7q1j0gXBw2xgqrYw3YEGO/U8ueKMXcJ9wJRc+2rmL2i17beEPFpAr8jV4mJQA1OW6V56w==
X-Received: by 2002:a17:902:b908:b029:e6:3e0a:b3cc with SMTP id bf8-20020a170902b908b02900e63e0ab3ccmr5437135plb.68.1616620121397;
        Wed, 24 Mar 2021 14:08:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s19sm3477737pfh.168.2021.03.24.14.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:08:41 -0700 (PDT)
Message-ID: <605baa59.1c69fb81.49d04.8c33@mx.google.com>
Date:   Wed, 24 Mar 2021 14:08:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.107-61-g42cf61ad862f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 167 runs,
 1 regressions (v5.4.107-61-g42cf61ad862f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 167 runs, 1 regressions (v5.4.107-61-g42cf61a=
d862f)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-61-g42cf61ad862f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-61-g42cf61ad862f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42cf61ad862ff9f961abe44049b9d9e845fbd118 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/605b762933cf867ca3af02b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
1-g42cf61ad862f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
1-g42cf61ad862f/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605b762933cf867ca3af0=
2ba
        failing since 124 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
