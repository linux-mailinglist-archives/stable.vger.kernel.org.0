Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ABB3195AB
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 23:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhBKWPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 17:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhBKWPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 17:15:18 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52378C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 14:14:38 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id o38so4917303pgm.9
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 14:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xKWKymS0yRm5cujcilx7/SOxpit6jI1B6tObdcI05Ms=;
        b=jjjUbx1YdLbkexGM4D3c7Iq08qB+ke8Jh9Pac1j/UKIxmR1w4MEF/9pu0/j7A0hPOM
         u1iHpc2jKOymqfKZ9f1W+shL/vuz0oVejyfbPm0vbRzj2ek17BML/VIORNpNGXKLdyJW
         +uKq14qMGL2dxLc6MTXuCHyjW7pjFuCSLIFLKfwHJrisnh6uzaJ3f0UsMmha+Q9MEXMt
         oNDMT0FhaC84JBvCtma+zrmr83ZB+Xmz1+ihNsav0m73uMBRjWRN92OLUQxTv4yZlD3y
         +f04mWGHFG3v6+WvpS5sX/UY+ysmtdB3k0iwkfa+nw8Pfj4xGWn/in7ZWp51HZM9dhJn
         LvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xKWKymS0yRm5cujcilx7/SOxpit6jI1B6tObdcI05Ms=;
        b=IXfsgW7xSUjy8Ie2pefSTR3YmG4LIj71rpyFiuqwIGskE6DNpSLQSvngK9ZaqM6qAp
         T9RfkXFoNBeNhezJtbbo/CSgUE71d8FbwZtxxB7u+xjhEyIFUg37ZBzWjs2PCkDfotAE
         M6gvN+UcfHlB28cQtL21zh9pYLukjfutqfwZgcwGsC3VkdRvf1vzb4C425lxWijD+JKt
         zTV7ZShxTro/H2pX/KPgfne/LYwm8oS+dC7g2t7MLDSbscAxHhB46sMCHVKw/RLXZVKw
         0E6oYzCQbFsmO/bxF0yFOcNYxdzoUbt+MkbnQMDaYrlT4YQV9TJ0v1QHLj+UyU4bq0X6
         pHNw==
X-Gm-Message-State: AOAM5332ZDXJ+hH3jc0HT5LkMbH/GjFYWe4uNsPwDNFiIBePdFEecc85
        RAV3dF2J2Ds057uG5jrnt2qq5+jlDWCyjw==
X-Google-Smtp-Source: ABdhPJwWiwMQegI8hUlcNcbU1+OClHcLI0lBMxac4uG64WCzWgAlcuTCYGGkjXTJqiLNz1OoDgpX/A==
X-Received: by 2002:a62:ae0b:0:b029:1d9:eb3f:8900 with SMTP id q11-20020a62ae0b0000b02901d9eb3f8900mr66572pff.53.1613081677535;
        Thu, 11 Feb 2021 14:14:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 77sm7090732pgd.65.2021.02.11.14.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 14:14:37 -0800 (PST)
Message-ID: <6025ac4d.1c69fb81.632ce.fa9f@mx.google.com>
Date:   Thu, 11 Feb 2021 14:14:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257-12-gc08ef8682866
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 33 runs,
 1 regressions (v4.4.257-12-gc08ef8682866)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 33 runs, 1 regressions (v4.4.257-12-gc08ef868=
2866)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-12-gc08ef8682866/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-12-gc08ef8682866
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c08ef8682866c4c48522d96de28fcdb6e1235e4e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6025797c74220478303abe75

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
2-gc08ef8682866/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-1=
2-gc08ef8682866/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6025797c7422047=
8303abe7c
        failing since 5 days (last pass: v4.4.255-14-ge5269953cc26, first f=
ail: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-11 18:37:44.623000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/110
    2021-02-11 18:37:44.631000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
