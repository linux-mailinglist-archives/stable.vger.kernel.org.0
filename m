Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E11468431
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 11:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhLDKuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 05:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346511AbhLDKt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 05:49:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD78C061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 02:46:32 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v23so4219269pjr.5
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 02:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k14K7EfVq4C5bFSlzyj/rT1IrAtXpHzzUpPR0vf+XRA=;
        b=Kr0ZqLOYkZglkTfFXHc6v1J63LbxSJ6dP2vJwMwU8HN8F8Fu7CQSgyQR1uX+1nh9WE
         WUYsSlLflQZeMl3JhFnZq9G+LqBUuUXDEbLaeRRz/SRCgnOgRR1xyTjO9M8SqV4UiZUv
         SslEyGe0/pwd1mWtjCZyaFu6vV6WUSVXH7vOwWpUPv/cX/0rGSzxtudGivhm+a6D4g+c
         WOA6qKzk9w+ch+ek6f4hLN1ySzUhLiaD+paw0A+ffMVna1SbmB+Es3T7LM8n4+/be1Jh
         0J0CfeNZuHlcMJ9E6PBDRzV1lu3Z9iEeuGOMJE9Lgtk4FyrgeaIqpSIYumX3++WbyqEe
         t8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k14K7EfVq4C5bFSlzyj/rT1IrAtXpHzzUpPR0vf+XRA=;
        b=J237J5mYj9evagoMmPWjOFzZNp4dH8WHjmGWKwGzzcLUP72hIPnh/vQpEYdycjry+D
         83VcFcJfxaxrfjPm9ex8eDdGZ1yxVX5+bovm4ifAJnv/hCqjZRZ/5sIUuyHH4TBrOb1w
         1UuoaCCVosF5bSbmmHiWTiLDZvEv0ufIDA9MR7SuSRV2ahzzppKlOwIl+UOw2LUsO8zY
         N6hU8csM1nFMunoAcxjnE+yFnykTK6m2ryHMJwuTgV+j1ozTdgrHKBxRQX8OcKU4pqva
         yPO/kTIVrbk7xYnNNc8C9xLwde8is1E21REnK+u8Fn60C2PGUyTCvGSawnt2AxxEaU80
         D2Rg==
X-Gm-Message-State: AOAM530MMG2Vn4yvMAlWDfbkwNh2NQWEFb7l+FgN3AbW0BGXp02eXC3D
        Cx/vezAsX39Ullu/8o7fOn2GF+qc8bJ8STbV
X-Google-Smtp-Source: ABdhPJz82F09XD/DR+nEy/qQxGK/uAIPZYwhGYBtFyMjLVsXdEDr0nEo31WvYXkCg4Z3VpBygBEkmQ==
X-Received: by 2002:a17:90b:1d0b:: with SMTP id on11mr20780335pjb.163.1638614792180;
        Sat, 04 Dec 2021 02:46:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u22sm6374986pfi.187.2021.12.04.02.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 02:46:31 -0800 (PST)
Message-ID: <61ab4707.1c69fb81.1cc1f.2ad2@mx.google.com>
Date:   Sat, 04 Dec 2021 02:46:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-83-ga02dd07707e4d
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 120 runs,
 1 regressions (v4.14.256-83-ga02dd07707e4d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 120 runs, 1 regressions (v4.14.256-83-ga02dd=
07707e4d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-83-ga02dd07707e4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-83-ga02dd07707e4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a02dd07707e4dc42c1a2f942baa6956561dec52d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ab13d94a2d4732ed1a94a4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-83-ga02dd07707e4d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-83-ga02dd07707e4d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab13d94a2d473=
2ed1a94a7
        new failure (last pass: v4.14.256-72-g83c23c6a513a4)
        2 lines

    2021-12-04T07:07:58.883500  [   20.334472] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T07:07:58.927757  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-12-04T07:07:58.937512  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
