Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029DF48053E
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 00:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhL0Xq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 18:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbhL0Xq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 18:46:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04D9C06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 15:46:57 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c7so12352006plg.5
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 15:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQ5liIFpMXxMlSy4Sv5q0x7Aonk5FJKpJ14t0JuTxls=;
        b=kNgR6n/3yzegofdrU7BKfzRLPuQSVIvD15zYQgBWcJN794w/eJejS6eUvvS/9HlgSf
         +qEmWwEBTesE7YLSsywStLt0dDFTi7n6S+gaqrwX/Zkm3ySmHpLDHj5xIHmJM7r076np
         QbJGLWFxhVUVVwWVS4mvIHk+jM6c1umgyVYxA5cakllaWmNVGwsvwLenpOqNd8n86rhO
         EWMyBZca5pX0WsIj7tfT6eAtgmcGIPg3ZnKXE1gBeoVDwnNvP6/YQ5cozHirXPM2u8LJ
         wuKkkAzHkMZ7dn6ViFGMdTyVIGCx+sGiY1VH7UC1b5PRO0j7GfYjqjhWDMS+1Pma9cAX
         YrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQ5liIFpMXxMlSy4Sv5q0x7Aonk5FJKpJ14t0JuTxls=;
        b=btkjCaP+NwGOtPqVZaCQM0LOOjDhGFidd4xz4TriuMX2dtkm91d5kmM1/kDD3+LIKq
         v1zSFDHW69HeYIpl0fWHNPC9mac3CpgZYFMn7Lkxz431vy6cQpMYJ/jQ8yeZl5+yB6Qh
         mtyiwAShWz1lazVBNHYGD8Xsz/otMxVCEmambatW2/J60uuj/nVFA0yOuLjyZYozNFNn
         iphN7YD1CmNm6wgFjc09rpvIUuNtFCw4U86hH3SLqQYum/SY1giA+U95FcDucXvHyVyE
         FLKtZu/rhIg03SNtwuoUBmi9vuE6IiWTg//5x2VeU4Vm8anJzO2L8UvH3PBc4XNKQ7ht
         Rj+g==
X-Gm-Message-State: AOAM533v+1HOQNCtqJw1C12bFeVkZ6ytajfQrrs6g6tAMjMhnTB2Kfpa
        al05lQJXrUTrtjuk9X/kYV7gDKVA7wDSp+6h
X-Google-Smtp-Source: ABdhPJyktisaGd7lWKMdGdWH13QGNI59Ljd7OwyMdeOjfOXLgEr09TPrIyhb6GAzyqWQe5LyH/D9Uw==
X-Received: by 2002:a17:90b:4a84:: with SMTP id lp4mr23726357pjb.150.1640648817236;
        Mon, 27 Dec 2021 15:46:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 190sm17787139pfe.190.2021.12.27.15.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 15:46:57 -0800 (PST)
Message-ID: <61ca5071.1c69fb81.8326a.384a@mx.google.com>
Date:   Mon, 27 Dec 2021 15:46:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.222-39-gc3b6f5a58bb3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 152 runs,
 1 regressions (v4.19.222-39-gc3b6f5a58bb3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 152 runs, 1 regressions (v4.19.222-39-gc3b=
6f5a58bb3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.222-39-gc3b6f5a58bb3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.222-39-gc3b6f5a58bb3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3b6f5a58bb324123904facb3806b3bcc00bdccb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ca157e81096f4a2f397158

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22-39-gc3b6f5a58bb3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
22-39-gc3b6f5a58bb3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ca157e81096f4=
a2f39715b
        new failure (last pass: v4.19.222)
        2 lines

    2021-12-27T19:35:11.630656  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-27T19:35:11.639700  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
