Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEFB28C9BA
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389387AbgJMIDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbgJMIDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 04:03:45 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9901FC0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:03:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o8so10242843pll.4
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HUrQ1ThhhoCp0Zk+VTRKUu3XZvkGZgFTXHWQ9n8Bjn0=;
        b=g0zQ7be1E2AWz/hnj5mOOkzJBEzz96mn5mjMQA0i0WooVJY3A21DTv1aiKdLTuwERv
         04JKmbzcj9+uhhnT4f1lzhz/JMht3KLLuejHyf0vIEaGdxf3D0/TIaIBg+wc7Js+Juxb
         8TgbMZqzAp2t5jo5HyBUXIopZi0Rg15a5BMrFpuMi+bY1rbQAIf9EQDaGM/i20pvS8tQ
         uLHnUqGDYa3bEUmbuJo+Mrll9llWr1N5mUeXME4dnJFvlopESQxNOwTiJ6WWVK7sOaLe
         sF33z9YO6oYf8lP5NrFLM1USRlJyDkT/vHSXWKv8ObnHWFb/9lGP5xYopfZMPwz4tghQ
         pf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HUrQ1ThhhoCp0Zk+VTRKUu3XZvkGZgFTXHWQ9n8Bjn0=;
        b=E+gs09IiNA+DWhIqT5zn6qFsJQKkirKNHEtc5/n+mr82TzMitles/HFFd+lloDCMCT
         YqOLwXIIkbo0/yCTRpGjwWwqlfn5YLIaha118+BH/4PA+eUUcs8cviPqSB5wzMDPHHHt
         1D1CEKLwapiSuuKELmZiKcy2+KXwq33N+zI/A1qE8jp1WJRLXi3fF1lT4bmYevklkHAy
         WkoOPvn0vIwz7RTINPcCloxOIE6/mSYAaG9z40P+ac/I5Az3dkDY3icR6yOjMMclJXbU
         ppIguAgw9R66VFVOH4UbeSF1zOrKdcMwuzfhqWsL6eSoEGYhUdZRCIhrxZ7K2QHggYBJ
         jUBw==
X-Gm-Message-State: AOAM531TMgx7y1pwG1FHwv16RMtktSrznujKxSADRph9dytkwzOpiM/a
        gPGKIPjvi0QOfo54vw95kO2X2V+V1+bG8Q==
X-Google-Smtp-Source: ABdhPJxootHD6Pr95kDgJ01j/J6xy/p+2Dt3hSw37BcHgY8RYhOhlb6C3DtvSS3y5+mcf9OpfMrz3w==
X-Received: by 2002:a17:902:8d8f:b029:d0:cc02:8527 with SMTP id v15-20020a1709028d8fb02900d0cc028527mr27505096plo.33.1602576224720;
        Tue, 13 Oct 2020 01:03:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5sm21902955pfo.64.2020.10.13.01.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:03:43 -0700 (PDT)
Message-ID: <5f855f5f.1c69fb81.1a2bb.bf3a@mx.google.com>
Date:   Tue, 13 Oct 2020 01:03:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-54-gc912bbabd033
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 1 regressions (v4.9.238-54-gc912bbabd033)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 1 regressions (v4.9.238-54-gc912bba=
bd033)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-54-gc912bbabd033/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-54-gc912bbabd033
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c912bbabd03341614249d61f5685cf564a640e69 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 2/4    =


  Details:     https://kernelci.org/test/plan/id/5f851d78ebead51ea54ff3f0

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-5=
4-gc912bbabd033/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-5=
4-gc912bbabd033/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f851d79ebead51=
ea54ff3f6
      new failure (last pass: v4.9.238-52-g811d5df016ff)
      2 lines

    2020-10-13 03:22:29.226000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
234 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
      =20
