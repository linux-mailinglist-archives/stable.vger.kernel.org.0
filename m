Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CAB3A073D
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 00:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhFHWnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 18:43:03 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:34802 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFHWnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 18:43:03 -0400
Received: by mail-pg1-f182.google.com with SMTP id l1so17778333pgm.1
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 15:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gAojpiS+bXiP0yNtuzxgf4kZqTfeg9TwyvFLcN1wY5s=;
        b=OstONpdFuKUc1BxTgJZTFe0cQqXDwoNJYVYzxekDvWZhm7Lp0/3LMLAa2opQ9Z7ztD
         X241NqvGVmaOCEIaGaq3atmgvPXR2BP4fz/lwQ0XGoqcUomSfbEkrhcn4Okg+naeAnQT
         TtlRPMALZw5hJemH7RTHPziUECGLNwzx3rDmjk1+H4CBK/RWJmeydWCD3pKRw8LXxPVe
         uMMoDDrRkQz7VJXkb6kHbFjMdVZ33XyEDyJhJxXuCYFomPQrnFFwxRvurElGQawVoynO
         YXyqgVuVpIjSEIp24EQ11giXT3xGYgrw2EP1aguzvAk+4Ei6+1hZsfF0nQmTE8DxarDF
         PR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gAojpiS+bXiP0yNtuzxgf4kZqTfeg9TwyvFLcN1wY5s=;
        b=C4d/Non9h9jdtCcS9Ohv/ChsYjrM9Sq0zYTR6u88azSXmVnbejoZ8gm1rKBc3+edqY
         0UnIA7geQW4xwLdx8t/TJQHPmMVZtHAKtjnQKY6zhP52g7fUyCusqNdXY8TLvHToFpNM
         dGy1P/AJzBY6IU7AuRQTrrrrn3wV3Lq0ISplWEiizMNKL9cJ2oeowDXX2XINdBdKMD0N
         Fxt5cTXJVDcw7Jr1yXiTcgw9MloitBBZC72XPOLyryyqxpYGdRmTzD41elRrvnrlOfyh
         4xbzd4l6VK4c9dQtid+H73lvSLU5bwIJkx1fZfnHiVwTgfwr9lXtIAdTvkTKxsy1pmDL
         1ZEA==
X-Gm-Message-State: AOAM533SAL/qL/63xLTJgWMX8Li2HWy/jYqDFCFtqFccTunlh6Q3p5Ke
        hG7WDfBLakNaKVB69dsgaZG20CvGg+6nHvtr
X-Google-Smtp-Source: ABdhPJxAPJi23g6Rs3iR1OueZz5M/kMJD3sEn2nXVdB4s+0ljuuJ4O+3qYxXL+3i2FiQzlhYm96ZLw==
X-Received: by 2002:a63:af46:: with SMTP id s6mr529423pgo.446.1623191995602;
        Tue, 08 Jun 2021 15:39:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c130sm11410343pfc.51.2021.06.08.15.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 15:39:54 -0700 (PDT)
Message-ID: <60bff1ba.1c69fb81.6cbe2.3f5d@mx.google.com>
Date:   Tue, 08 Jun 2021 15:39:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-137-gecb190051c9a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 163 runs,
 1 regressions (v5.10.42-137-gecb190051c9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 163 runs, 1 regressions (v5.10.42-137-gecb19=
0051c9a)

Regressions Summary
-------------------

platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-137-gecb190051c9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-137-gecb190051c9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecb190051c9ae77a90f4a9f89ac23cbb7a8266f7 =



Test Regressions
---------------- =



platform         | arch | lab           | compiler | defconfig           | =
regressions
-----------------+------+---------------+----------+---------------------+-=
-----------
beaglebone-black | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bfebdeaed5d4baa80c0e0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-gecb190051c9a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
137-gecb190051c9a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfebdeaed5d4baa80c0=
e0f
        new failure (last pass: v5.10.42-126-gf4185f0d2d83) =

 =20
