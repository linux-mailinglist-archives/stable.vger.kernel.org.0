Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BE4460982
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 20:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhK1TsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 14:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbhK1TqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 14:46:04 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90890C06139C
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:37:55 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z6so10331469plk.6
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 11:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h/VgOYv8yBPXd8fdW6qQkcWCzdibBPpE3xEK6ozsbDE=;
        b=04kBt38NlO2KXR1uuDC4a8/l0FzbkLbTVzFXI45h0TkjvIugZIBawQsRDTwRDScGot
         LUNBOC48Poz9dHLi9/92vNAhC6Ez61IQKK1k+OLa7SbqXZbTahXMU40oT5vhnubt+yoK
         cL0rfB6goPuiSYTAFkQE58Xg/tDyiXbdBAkEnqEYVpeFbp7qKoThBROp3S31cWRZE2Gc
         GcKLIEK2paeeM0Xn9FGQDm5pb18ChPAf06zg3XQwRGva5iXvRDtoKmm/M2sAY40T4Nkx
         O3VGNyeb4gE7IFL0KayFYlEcjIWTZe6touw27pTidMGzBho8zbz4URej9EI+mAn08McR
         OXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h/VgOYv8yBPXd8fdW6qQkcWCzdibBPpE3xEK6ozsbDE=;
        b=NZcx/WWPJr2McmakHsQ+kgze2TqEJnaF4FD37zyEtklIiXvuL0H+Si8n4Mbki2F9FZ
         ugRfpQC1/0bJGGyGuDfm5J3IZ9Qov8ZfchSzvl5elrPPBtTz/eQH3lDqAGwgjazXBJoy
         U7RuwikU0Bp7NPimXo5IYMMcskS7XjQVItrWePI/dJgfApw7OnTcKR506MGHc3QfKohg
         pS/UlPA2yIN7O9l3Lr6+g2NU2mXnNJlVXdwDQA8NLqZc4kgQ1jzf3d6kl+LRffN/9nGw
         bTNmQHxEXV3JYTJOlyMtt8esnhsUqAQpM7X6FA+MMycPa/RiwfouUb41gvBRD0hhrlJ5
         wGTw==
X-Gm-Message-State: AOAM533J421ur4ARd+IS28dtGIwS5ExGWfUBGEgSXZ22v1Rj8JZidFSt
        JWWYcborFcQXV2ctR8CCxrG3kz8aedc98mGG
X-Google-Smtp-Source: ABdhPJxyQougetia3KBs/4IwYNm/jPdm1gazsbItVbmYfzFtJCj1dp9kVQJT/48JCqNsuQRO8RNa0A==
X-Received: by 2002:a17:90b:3b44:: with SMTP id ot4mr33339076pjb.202.1638128275029;
        Sun, 28 Nov 2021 11:37:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm10266432pfj.26.2021.11.28.11.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 11:37:54 -0800 (PST)
Message-ID: <61a3da92.1c69fb81.d6536.b7d9@mx.google.com>
Date:   Sun, 28 Nov 2021 11:37:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-12-gb49887c8ee2b7
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 1 regressions (v4.9.291-12-gb49887c8ee2b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 1 regressions (v4.9.291-12-gb49887c=
8ee2b7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-12-gb49887c8ee2b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-12-gb49887c8ee2b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b49887c8ee2b7902d5ad12fc465c871262947f9e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a39f27ed6ec642d318f705

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-1=
2-gb49887c8ee2b7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-1=
2-gb49887c8ee2b7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a39f28ed6ec64=
2d318f70b
        failing since 3 days (last pass: v4.9.290-204-g18a1d655aad4b, first=
 fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-28T15:24:05.685524  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-11-28T15:24:05.694210  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
