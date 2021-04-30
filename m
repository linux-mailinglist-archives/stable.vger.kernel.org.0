Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE337018B
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 22:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhD3TyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbhD3Txr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 15:53:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BB6C061345
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 12:52:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p4so1713262pfo.3
        for <stable@vger.kernel.org>; Fri, 30 Apr 2021 12:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b9C5+22w9vk9iPr4CCCEwNjOYoOptiOPDu8L/bkgAos=;
        b=NXL8hOYyZbnurHBBYKEk6+jqmKYIF6Cccb7uwhdkJwmX9gc/UIqqcIhx5sfFn+1pvH
         IOq6qg133J55cPOdGDOK54MbzqyyQhbxLyQPV1juYnpJNByeIGOretohCV2JWuJQ6ogZ
         LyId32IN/mROc6r8lBTTqZy1StN+BWwPxuS/Z7cNkNrap8HHfm2/NdAlaTR745DYpS1Y
         lBJ97eoEbM33KX3UiNBBSgpxw+/UFyKaLezqHDxkOoOQn5sIsu+EyYP+CF26F3XOl0JH
         MusbGopBh1IIGiKos/+DVyyjUmBKmUeIReu4U6MUB+pN5MiKC0rSwuUkCPOJuG0ue/Mb
         LM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b9C5+22w9vk9iPr4CCCEwNjOYoOptiOPDu8L/bkgAos=;
        b=RbZWYnlpNN1M/Sxf0MGsfsHy61Spptl5I9nRyE48D4NMJMTH5RwXouFaPxcGJiWpwZ
         myhWFNYKLQ64gGYw3nIUdBiYZCPEvd32Ko8VSAG/DEUhxgFv9Y5GfVUqx1spEh/7Ha/M
         WrRC70KnT8okOd+VQTCbkkBjC5X7nz0qFBX1YUzGDlYLP4A4sQoF2sy2OpC/sDLNf0Yh
         oXLb8Vg4kWCLjBkzNJ84Yl9vNxodmjyV9ZOTZBz8oTq1mh7qDMARnpNxsD7GZvzS5JMr
         ir4I06l5mfdcKVoI1oT2H3Wn+L9Z+K1I1dtWDkeVC2/iLFkifUNo48/OEQdZlYVLUimD
         IiyA==
X-Gm-Message-State: AOAM5336kEFCtRhANy/Ua1hfKGedwMcpEgPYpI0ex658nqtveCKtBA6h
        bNDMAXzJoyH1KaRVQzIzvhgsG4ZRlLDlYxaO
X-Google-Smtp-Source: ABdhPJzNewT73v20B7qwlxH4Mh9It+TQ8FpwcHLjO4WiNd4m7wZLWD4B6JYCxc4X0G3W2h0ra/gUfA==
X-Received: by 2002:a65:43c9:: with SMTP id n9mr6037345pgp.19.1619812377778;
        Fri, 30 Apr 2021 12:52:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u17sm2817559pfm.113.2021.04.30.12.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 12:52:57 -0700 (PDT)
Message-ID: <608c6019.1c69fb81.834c7.7254@mx.google.com>
Date:   Fri, 30 Apr 2021 12:52:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.268-1-g10c9a2bbb189b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 63 runs,
 1 regressions (v4.4.268-1-g10c9a2bbb189b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 63 runs, 1 regressions (v4.4.268-1-g10c9a2bbb=
189b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.268-1-g10c9a2bbb189b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.268-1-g10c9a2bbb189b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      10c9a2bbb189b216959300a7586181850a5ba432 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/608c2b23233fbdd3a59b7796

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
-g10c9a2bbb189b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
-g10c9a2bbb189b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/608c2b23233fbdd=
3a59b779d
        failing since 0 day (last pass: v4.4.267-33-g5625f77ed03e, first fa=
il: v4.4.268-1-gce891544df907)
        2 lines

    2021-04-30 16:06:55.521000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
