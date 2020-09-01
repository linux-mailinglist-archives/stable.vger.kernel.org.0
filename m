Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BFF25A0AE
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 23:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgIAVN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 17:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729859AbgIAVNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 17:13:09 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DFFC061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 14:13:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id w186so1366972pgb.8
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 14:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RlZ6SmP3P963gNv1bP1k3F2izrWikjbUvljRRrBJPzQ=;
        b=IP+3LeadEvRs/Eoa+jQp3Cnnvo3OCiQ9XL0xdrx0T2V7njnZL7kSeQbbfqMeme0Tds
         WPKejREWiWbBtF5n8WKpowtcqJPSEVUSdoIYDf2VRsuNUxDyRgj3NacUmJKVs3yOeHhZ
         dwGvpFHC9+xQKxVrlINGQ4dpP/8uRkXuZwJ04At3GVSj73rLIUHcM6e9eHtsMjmQngjL
         4ySNoQ9UWjXRHqAuzpoRrcmpoBlGtLayVLXhr9N7dwM8ehy9fu6n4ccV8EYBvm5vOzTi
         IXzF0Un9KntCdmbGR7J5DQSDaWdCcMbpm+bqjMnJgfiR+ZAU8fdXM2934zOnou0QBO/G
         34xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RlZ6SmP3P963gNv1bP1k3F2izrWikjbUvljRRrBJPzQ=;
        b=QBsOoV6zmPUq1tVuhpCBOWt4w6l0VYw5RH/pN3E8Fo4hEIr48UQ1Fb9aox0RV6sSaV
         4nvoI/RgigG5XA2uK2972rgnNhuVeVUgQHzZN+SIpKqlnAd94F02WQctxcL1J2yehMzU
         hAQsU2ugnxzGfhndf53qUZEAwBnDqzKb13mzMAuJt6ECZT+3EvdMOr138ODsnkMCL1Vh
         Lb4bFNQTquP2V1/FeTguuX8DVnsWWLpRy8/7C5JILVQ8HLjPaBHp9/FULxGAzUuqTxxa
         JEIh7HeZlfErMhwdpDBpgxYTwC48LEgz5jzOLROcO9uzxWLhtKpn3RX0qDvNGVRuUIhy
         /gug==
X-Gm-Message-State: AOAM532zgKodTpikWW82W2G1hpkv8zBNALs/qwNV3qGCVni5vcMJKCs5
        KLzxsQv+aNHoZjY82g3m0Sah/jU1TrcPkw==
X-Google-Smtp-Source: ABdhPJwbsNAJVZwo4LYj1ISv/OZKS78CFG8c/+SgTzRtE9NaSbAdy/0uB+RclSgKCjqzBEOWKpKM0g==
X-Received: by 2002:a63:e1f:: with SMTP id d31mr3218881pgl.262.1598994786537;
        Tue, 01 Sep 2020 14:13:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm2546032pjm.3.2020.09.01.14.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 14:13:05 -0700 (PDT)
Message-ID: <5f4eb961.1c69fb81.91fc8.59e1@mx.google.com>
Date:   Tue, 01 Sep 2020 14:13:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.142-126-gae6e3cc29bb4
Subject: stable-rc/linux-4.19.y baseline: 140 runs,
 1 regressions (v4.19.142-126-gae6e3cc29bb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 140 runs, 1 regressions (v4.19.142-126-gae=
6e3cc29bb4)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.142-126-gae6e3cc29bb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.142-126-gae6e3cc29bb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae6e3cc29bb4eca8baf48409319aa290efcba5f5 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4e83f7a654dfc345081118

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-126-gae6e3cc29bb4/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
42-126-gae6e3cc29bb4/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4e83f7a654dfc345081=
119
      failing since 43 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
