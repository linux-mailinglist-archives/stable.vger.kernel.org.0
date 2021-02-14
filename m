Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4B31B377
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 00:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBNXsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 18:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhBNXsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 18:48:36 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2247BC061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 15:47:56 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d2so2840067pjs.4
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 15:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ebp7CatQtcpUCQwFCoQeHR3DrfL2Ot2prV9k6J02wJY=;
        b=YoZ7QEw0Tg3x2zvXMFcaInnoRPctIypxpXcdbuq84ScgrNte0VHD1dQoiuTBBrF52d
         cDJlrr8RvElYeA6C/a2EllSvtujeXXSeLu7wxYdNyd0PwXAYdIBVHJY5NY33kmiLC/bD
         HPZWVi2S3gv/XtqFKUxMntSc6wgP13kJk77Q0BVdsil/3vDRapWcn/V65En4ejPgQZZb
         20EwYgszXw025+7RrUGqKcQswKQYvh34lAasX+4rh0dVFvL1hYfIxRqkRo1b1dKjrvGO
         TDqEK6L7JLNS+SeqdzunkgPHTEA2UNm3/KNZDcNe9aA4Q84+ZF5e3/KSPsRXu+rC6opY
         Ufxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ebp7CatQtcpUCQwFCoQeHR3DrfL2Ot2prV9k6J02wJY=;
        b=AfOpGCiW9AsOemhZgemHUDOpB3+uzD/3xFGLZCg05NdOSI2aOQgIeFiRp3Oujp1wqm
         EmekEE8gK7OULM+OHwj3+9Us9vsHQvknpytQRvWMwyofTaL97+O6SMVSs5BnVqWB5SiO
         aNeAFc/gILlf4883N3sbA/soDcW7vFdstzl/JvO5MYqRn97uHh8k0wHu/jLRonP6DX+B
         TzUw41GMJ/IGo+LjFTZja7UXe1gn081W4qTMShvcGuOpCIP0fpIxnCugak65XHCkovVv
         fypjXLTbz+5cNSd5BQpACctwmPr5DA6EAhblKg8ZFlxDWYoP+K41XPFcdbdzy76zMJi2
         wk+g==
X-Gm-Message-State: AOAM532cVH76QCPqzNF+rfiyu4ojn+3hqbOHIYFfWeokV9dJc5I/3paO
        W2Iw2pFRrW76xgDt5fhAxMQzxQYXDckpHg==
X-Google-Smtp-Source: ABdhPJycH2ENNgFQAWLCDaf/+ARJG8c5a4KTiEf1bzlx79CvKbNF3HmnnL1ZatjV0+/po3crjuL5zg==
X-Received: by 2002:a17:90a:7502:: with SMTP id q2mr4429147pjk.120.1613346475239;
        Sun, 14 Feb 2021 15:47:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gt2sm4645278pjb.0.2021.02.14.15.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 15:47:54 -0800 (PST)
Message-ID: <6029b6aa.1c69fb81.ac7f4.9173@mx.google.com>
Date:   Sun, 14 Feb 2021 15:47:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-23-gea8741e5fd91
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 23 runs,
 1 regressions (v4.9.257-23-gea8741e5fd91)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 23 runs, 1 regressions (v4.9.257-23-gea8741e5=
fd91)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-23-gea8741e5fd91/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-23-gea8741e5fd91
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea8741e5fd91c81fd1ddc485503a3ff67eb1ece2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6029830486b5a7e5633abed3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-2=
3-gea8741e5fd91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-2=
3-gea8741e5fd91/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6029830486b5a7e=
5633abeda
        new failure (last pass: v4.9.257-22-g314998b4a38f)
        2 lines

    2021-02-14 20:07:28.696000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/116
    2021-02-14 20:07:28.705000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
