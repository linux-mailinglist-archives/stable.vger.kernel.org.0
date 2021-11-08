Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A93447FFB
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 14:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbhKHNEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 08:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhKHNEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 08:04:21 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8173CC061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 05:01:37 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g28so6436528pgg.3
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 05:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GlLDJTpeVh/QBbR4c0nobyMF6oRDfpRTNNXiYowiWMo=;
        b=IjEBA0CZL4gNGVIUqZAy3LHMglVc+KJjdr5vpifi+BWhn+vTcFOZeNBskZXzpvQaKk
         BRjFmRJ26NUPbt3xjXGZTXEWUVjkv1FkFhKxTObuH6cSFTbMr7FkKb9kNT+xFbgNu3wN
         z9bEylev74leU0xJuXBn/slUSsPxcRiPTJSfHTEP2byZ4fblurCfRGb0m6r99si6+ptH
         DpQmPoIRvTx8PDLVB0oBSVh1nQWucp1ToR2vrcyJzriH2sMZmwANcEjzSH6+NnfnUt30
         IMaJt//C2qwqFYCRvaomgj8OFCZOBNbsrCz+bMwQXxsqC0hXaVctstmDQblCQDzKW8n4
         HpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GlLDJTpeVh/QBbR4c0nobyMF6oRDfpRTNNXiYowiWMo=;
        b=yrqWKgLvsJE/FzeiwYxYBDc2mCN7aa+9Oqyet5CtKDlI4cKQKig3e1XhoaApBS4EA5
         CPIjZjKJYfqueyWjI/lhQXIlgLQuD8bXK5W6wqcXXlzxv1ui3KjAi7YLj5L/i1kcOVh/
         LimhaxsBWwNeOQ7FE/EXlENTYNK61/AQFZXuN19GinDw/LoYKBe+2Eea75FSqk98J7Qo
         xJ/wjFv83F5EcGqPfxgWZtr0v2h/gFJtlBZQItPdg9r4nvlbhuBraUzl/e7jHG/Bc2EH
         sYJ/963vBlj82nG2BafE8WD0HlNMj75fKlMfZQuAh5vjmxs8SV6LZAFEYkDB4d835zW0
         1Cug==
X-Gm-Message-State: AOAM531r+cBj4jLO2IRNnEYbj7HagFdsdlqCEOPD5PLKH9mkdGyaN71Q
        3+zXc9WgAvKZ8qPHHwVcXnX3MhyV1jQXh/Tr
X-Google-Smtp-Source: ABdhPJz/AQZ9I3CItapNFjdZ7x9RyycKPBoniSIrFRWDgASVLG5x4smYO3B3L1+hY2r7Xjoh3DkvTg==
X-Received: by 2002:a63:83c2:: with SMTP id h185mr44241012pge.342.1636376496834;
        Mon, 08 Nov 2021 05:01:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm16451811pfm.28.2021.11.08.05.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 05:01:36 -0800 (PST)
Message-ID: <61891fb0.1c69fb81.971c.0e34@mx.google.com>
Date:   Mon, 08 Nov 2021 05:01:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-5-gd64db7a57ba2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 190 runs,
 1 regressions (v5.14.17-5-gd64db7a57ba2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 190 runs, 1 regressions (v5.14.17-5-gd64db7a=
57ba2)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-5-gd64db7a57ba2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-5-gd64db7a57ba2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d64db7a57ba2ca1407224a72ac884dcf410f5209 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6188e7cae4c2725c5d3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
5-gd64db7a57ba2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
5-gd64db7a57ba2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6188e7cae4c2725c5d335=
8dd
        failing since 14 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
