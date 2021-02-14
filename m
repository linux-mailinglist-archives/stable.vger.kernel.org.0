Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D3D31B058
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 13:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBNM3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 07:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBNM3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 07:29:48 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1E1C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 04:29:08 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z6so2546776pfq.0
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 04:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wAl8C8xaCPgcV25Bq3HH58U3XAE0Bwt8dYnPNttL8lE=;
        b=haXAPf61wUuCR3LIWpqHI2dUvwWNEmxxpfwtqyEGwzpDTGa9pmCvtDi5z8tnkx1e7V
         2cFdAVrMsz662o7WLz0gdgVEv/rNSC9bOgjGltZOG3IhvPl9cekqmc7vWjLKeLgFOVUD
         fw2KQr0PIAXh3H3iTY2WFvSl3tVCnmvuA2tV2ofciLkMePAY6HgmRPRuSycgdsE/mhsX
         6i93itUc71NoKSbJ2xCfaEnKIlbfFsmFEfBn7FEjKcX01K0b/1w/fI9qccpgHQeR4zut
         suB8KCTfbcBtQqD06U6GHRzbdkYY8olRMBruPFL7yRpz1MPDA7LG/h9i1Y0tOCUKU7h1
         0bQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wAl8C8xaCPgcV25Bq3HH58U3XAE0Bwt8dYnPNttL8lE=;
        b=c1tc7z18Y21r57rXvV7MB27sV8DozHEzbgpChax6QIkJ/JsOq9GabxOoj+tlu8Z0L9
         UE8TZErUXUPmSs6nIDm12yykCYbHtiVKAFp3oT0qF/pmeWZyMB/j+YsfAoCvBniAJZr4
         5fq1NNchYRmQFQx2C/KZ+4e0XUnT73rdSLscNIP2R0znlHAYO5TRT1A5D0YXvubEGKCi
         q2OZmvoO9KZNfdUXGW81ysT6vMpRliUh7Dm7QyB8K7FNvHNP4u7mRFHeu10FZpoZwhRX
         56E7fQ6+MyyV2erROpEMHtfbte4Mv0LHJcajPGNsSfoJhaBfrC3avmYgqvm1pzo9EJ9B
         XkyQ==
X-Gm-Message-State: AOAM531Erv2l2E7c21DDZbsIdcmVsU62b9XME5kboBw3v1P66OkDcpOG
        7IKLETpsv9l9IgDUsF7Vsvc92xmGEK9OVw==
X-Google-Smtp-Source: ABdhPJzuEdNVYF04WsNZKclmnRsD6dzT6bcBe+mvHKrPjRR44C+o3VEMugLc6uOvDoezGi+4fTMyZQ==
X-Received: by 2002:aa7:910a:0:b029:1c8:9947:305c with SMTP id 10-20020aa7910a0000b02901c89947305cmr11144882pfh.75.1613305747249;
        Sun, 14 Feb 2021 04:29:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s23sm14890102pfc.211.2021.02.14.04.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 04:29:06 -0800 (PST)
Message-ID: <60291792.1c69fb81.84a6a.f9db@mx.google.com>
Date:   Sun, 14 Feb 2021 04:29:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176-3-gf4cdb0de2301
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 79 runs,
 1 regressions (v4.19.176-3-gf4cdb0de2301)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 79 runs, 1 regressions (v4.19.176-3-gf4cdb0d=
e2301)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-3-gf4cdb0de2301/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-3-gf4cdb0de2301
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f4cdb0de2301c1ae2cd18fd172f2ea0f51e9ee12 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6028e53648b0bbdd223abe6f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-3-gf4cdb0de2301/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-3-gf4cdb0de2301/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6028e53648b0bbd=
d223abe76
        failing since 6 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-14 08:54:10.408000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
