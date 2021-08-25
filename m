Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81B3F6D2D
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 03:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhHYBkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 21:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhHYBkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 21:40:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDDEC061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 18:39:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e7so21542458pgk.2
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 18:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tltw6U1O2A8hOjm34hh+dmYLN1EUnP9AwFvlqMVbH+w=;
        b=qaLbQQaXxNuikTZKPSbdNkxjPWsvY03YyRli3tdpa4xiGwPqXzk5Ms8Xahj/tQGCPy
         2a3qtKCQDXUzFcvUTobFHhGP/TmkKzTBEKg3VDtHLPb872XglYjCLETBgtwWBfnvybZo
         N0CJRp/AvIJ9OJ0eaa7J0cJjOAz/1cf5/UcL3tfH+seEkGdLV9osNusOZSf9igTu4Wz5
         lmqpTPnff/BskBlI7jKh0LUBMur8mNlgciKuZ7ITEmQJJwQ3k3GhgJSZFDIZV4ZoDB4P
         VyZFiKOx6Cidp7SIAjj5ZcldW+/fRmS32u351WrNj9Ri94CRqA+AzN5w+s8NzJ34jQNs
         FKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tltw6U1O2A8hOjm34hh+dmYLN1EUnP9AwFvlqMVbH+w=;
        b=VH4MOQ+20fjNNr1Pvhht6TICash71YJhAwtBCtkMe22OK8BlrZQ446HpxOEuc6I7b3
         axJtNgfmbaMz3jCN/ZgOn7Ak1JZyaf0OOftB1vpifR/7I4qd20hjcybI03hpuSnkvQ4W
         E9ebmtPbYjyZCHBaL5ny/+ZKvOUF+S4cYjiKGFqA1nChxykpjbHqAGvuVrYGZ+6KOWZR
         sQETLGYpnL2jo3kObJrIqgURTVVIwfp/U5P6tRCTHZ60rbfjKmb2gqKE9to+oxQ3SBBB
         90WADmI3MlWM3kbBpDYPZrkEe6esKLwJzB2Oq51X9jW/SvG2MmjpB/Tu2P8MmX6DDbhP
         CEfw==
X-Gm-Message-State: AOAM531Psc7EQoFFvx1+dgBwYFuMSdeZpwjmwQfYhBiKmvXFKuG8wkey
        NA4ZaY8NIX+66zMA3bXq6j65/RJ6OWCbwDEM
X-Google-Smtp-Source: ABdhPJwcksVHt9xd708bQnRtHGSdgxcYj1LTqzJ4PsQsnuYZEnLtBcT5ZJyfs842ZrGkQ6esEDlZ2Q==
X-Received: by 2002:a65:62d5:: with SMTP id m21mr39326055pgv.124.1629855567107;
        Tue, 24 Aug 2021 18:39:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3sm20763962pfw.152.2021.08.24.18.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 18:39:26 -0700 (PDT)
Message-ID: <61259f4e.1c69fb81.22143.c253@mx.google.com>
Date:   Tue, 24 Aug 2021 18:39:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.12-126-g61c83bccf008
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 142 runs,
 1 regressions (v5.13.12-126-g61c83bccf008)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 142 runs, 1 regressions (v5.13.12-126-g61c83=
bccf008)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-126-g61c83bccf008/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-126-g61c83bccf008
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61c83bccf008564f6c6202ac9761826cfcb416c2 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61256b55667cb9c9758e2c8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
126-g61c83bccf008/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
126-g61c83bccf008/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61256b55667cb9c9758e2=
c8c
        failing since 27 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
