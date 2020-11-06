Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17252A98FD
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgKFQCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgKFQCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 11:02:14 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F9FC0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 08:02:14 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x23so841306plr.6
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 08:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GhnaCfGr+82Ru0NlJ1scrwjS3Pm5KLHQ80N9VLpu0dQ=;
        b=pOptG9mgz/iNgmVj+ELyQL9Kh1llAXpUjbKwvOqW8KI0qabjPOH61SMCRl3zx0F0TA
         cyjDs9EbwbHMJNTJ5EMqUAAYseHRr08vG23MtCeiTrTn1TNT1LYFsSKEf25qHdPG4Dym
         4guC9K2jz9hNqrB2q8vU3UozEs06ABu6kQvhKrqXeDI4BhhXVxpA1Xx7sRpAlLqeljZn
         WJkwQMeo/sUhhFEtFHx7bMftB2rIBWSdESNW7Ty/zHfj8OO3MwLZe2bfbFkIud852ryI
         B8y9NRGjsbPx9I0jpK+xux9pc1ota98mq3wuQvf2wgV32GnXmN6xDvsQTHCtBZTniXc6
         dSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GhnaCfGr+82Ru0NlJ1scrwjS3Pm5KLHQ80N9VLpu0dQ=;
        b=PXlD5b1wzG3pI3+H3ROg0RPxIH0LuQMi0d6LAz/kglJEJ6kfviD5HOSGfKuAO91mr1
         7B5wVGZMQx6FOTZBV3bXgQFrh2ybE7G3Hihi5Jbceo/Njpvg/NkhY0OEdggs+48DTDzq
         cArwjSq/qCQjrlIhHchpLev/s63YFMicw1SdoGKJ6Mfmm0vnENgFrd0agJSGRB/6J7zH
         QskcfLUhbRnlVi+u4u5sfwRlMOUEJi5f22tMq8ceRnppYi5bEwE0ph4iMCgQGd+WsqKX
         qAAlA24CjPhcMEvDblCBp4mLSxy+h4JJa3+HqFM9xksr8wjpSmsJBqMbMDOxM/VeGB5m
         YUYw==
X-Gm-Message-State: AOAM532b/uYA0bVtNqUijOPR3KsD2ZKdG4uE1DA9x+KVthe7mBtWqvhK
        4+ElSdiF5gLYzyi86n24qLcL8DVwMlbTbg==
X-Google-Smtp-Source: ABdhPJwB0aTX9MCftLsPQDDVF/uiUc5PpEOubw4yWMfDIHUlp1SJ/3EPJMt+8MkwRYIvEFOCRlRs7g==
X-Received: by 2002:a17:902:a50a:b029:d4:da2d:c9a1 with SMTP id s10-20020a170902a50ab02900d4da2dc9a1mr2415454plq.6.1604678533286;
        Fri, 06 Nov 2020 08:02:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm2678845pfn.125.2020.11.06.08.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 08:02:12 -0800 (PST)
Message-ID: <5fa57384.1c69fb81.9ed3f.4677@mx.google.com>
Date:   Fri, 06 Nov 2020 08:02:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-93-g35da6e074679b
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 1 regressions (v4.9.241-93-g35da6e074679b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 1 regressions (v4.9.241-93-g35da6e0=
74679b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-93-g35da6e074679b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-93-g35da6e074679b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35da6e074679b5244ac1e62f24474022a0ad3293 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa53a68cf6c206e56db8857

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
3-g35da6e074679b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
3-g35da6e074679b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa53a68cf6c206=
e56db885c
        new failure (last pass: v4.9.241-92-g81e6f07cbc39)
        2 lines =

 =20
