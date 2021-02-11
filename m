Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7E73194D1
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 22:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhBKVCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 16:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhBKVCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 16:02:35 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB43C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:01:49 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id my11so5185790pjb.1
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 13:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mKN7Ayg1oebHV+lWQ+3Mwz99MH/wvrDbYTaTb9llcBM=;
        b=2OlvP8mHpQ3e3zRumi9BCGoMKDxaSwYBr+4KDAf946ktHnw/dWbCu3/eIHZYy6ckYh
         UvNoTWo122cv9ihq5Y3bJ5r33/m+jA3pDyqJhdBSJ0TweTRCXbnC3TSEXTvspN2agkso
         /mC7cROXXzmHWZNiqx2IaFd3wBvpfvyjnbC7nUqGObj4enXadRCwXdvAWyky3BxSAyjE
         LiXe2ISj437CNRqPU4f3pTbzgGOCQ8EFkdH3WxBPOpghc9m3fuo5K9v7T8TuJtnrZ4O0
         H2WsrbO49z8oZFY//ZPM/0s7tZosBIt18UHR8ygVo07+AVovKTd8dvGbvkuCIE+RoZ36
         QltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mKN7Ayg1oebHV+lWQ+3Mwz99MH/wvrDbYTaTb9llcBM=;
        b=Wk+ZvbwdbxXKYH/485n92cT/Qn3V40+oT+V3JQ5bMHkxtysJLxTmU0pXKFZko/03lq
         IbDxXgTo4VNL7jaBNpJ/CUkGBU3+DSoK0E0eUE/QcpL0xfTdhHRXdOGpjj05E+pbuMTG
         CgzKKC0QSP4slbN5bNn6SSZ8bcjS3DFC+sYfYxmZrarebNWSkSDMAYphDSBRRntv51AY
         KbEQBFcAm5q26b48hI4HfhjUhFc7oK6k2RsuJ/ujnYTk9Rz3/V+0Rc5LaXFOcXyM866v
         U7ZxoNbZi+M0ey6kyVHkJcs04CZ9FAPCKYAnv4wfkaumVKo/qoGYfLFzu5fqFM5NSGNN
         tPvQ==
X-Gm-Message-State: AOAM533fpCt8csARzwjkRv7+gQdY7xc/P5euJYeh1vBWhIyTXyVBzXSA
        MRvVPARUd0ZLBHA01PX1A3ojwZDXze7BDQ==
X-Google-Smtp-Source: ABdhPJxFtauYd+878JlzHGynYvyFMW7EjTSP/CxTmwYe+bu8NyZIHpGpIsTqZMlyt9n/3vU9lMJWCA==
X-Received: by 2002:a17:902:ed4d:b029:e2:ba0b:fc53 with SMTP id y13-20020a170902ed4db02900e2ba0bfc53mr34414plb.0.1613077308731;
        Thu, 11 Feb 2021 13:01:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i25sm6710476pgb.33.2021.02.11.13.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:01:48 -0800 (PST)
Message-ID: <60259b3c.1c69fb81.f6690.eead@mx.google.com>
Date:   Thu, 11 Feb 2021 13:01:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-18-g5fd67f7a65f98
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 35 runs,
 1 regressions (v4.9.257-18-g5fd67f7a65f98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 35 runs, 1 regressions (v4.9.257-18-g5fd67f7a=
65f98)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-18-g5fd67f7a65f98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-18-g5fd67f7a65f98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fd67f7a65f987599075b2b2b5755180f1dc4f52 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6025692226d832deee3abe6f

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-g5fd67f7a65f98/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
8-g5fd67f7a65f98/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6025692326d832d=
eee3abe76
        new failure (last pass: v4.9.257-12-g43f72a47dfce5)
        2 lines

    2021-02-11 17:27:59.384000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-11 17:27:59.399000+00:00  [   20.570159] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
