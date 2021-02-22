Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890C7321B37
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhBVPTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 10:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhBVPRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 10:17:20 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98B2C06178A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 07:16:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c19so8774008pjq.3
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 07:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iiIcFlVhw83DjHv8mKTT1Yav5l1k98n1gd5NdTyFdXk=;
        b=bopilaeCP3Wr9F6iw+o23YHRDWuwKUzau/xLq1eS2XUvALCiTBRAO0qoUaGw6rQOQm
         z40o2XOwlzAJLf/sb9mYW6XXeM7kv76J+oWuVBarYUE0vB7XkX2rtPTpYhOnNsI62yx2
         EG/0dz6b56CP6ILvO6FxjzoXZBAZw5Pl9XI6BvwzaSMpOjJOHhzhIpOBO0Fuu161KaPT
         D5K+CTcrbP3cjrVk4sxaApQJMduB+aAVZ3euB8fpnt6OLDOMLJZq5m31TDLohjFNDOsp
         WRj42CEYKTtL/Gk2lFPcpjppXXo9P34PH+2AoAKozkO/Ph2/UrfUaSw8mtN2fdZUk0dL
         LvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iiIcFlVhw83DjHv8mKTT1Yav5l1k98n1gd5NdTyFdXk=;
        b=k8tq+dcGEyCIG6mKlrFypYn3JISiX5WK1k54TaL6YtB+LoTVVxAgWJc5cu64XDc40w
         I31OlpYIprQvGDtjdt2atvD6PsNjJLN2HgOZrOGj+AFnul7CQ4aCRTM9/h+iLUtBH5a5
         n+7JspcP/DdkzjfRmEFPiSUDVm2zyxj9ApjNUiWHOTOOiiOgfez7MVsqwISjPh5IYwed
         tYpya2J0Uq2kN2F837KktmT+6spfGCKBWCEbjX71fvXoIqDgrqxNch+WRtL/AXQrHx6v
         E/+iwMu8c/oqZVhlYgvurnONIFdFxJj/y39Iv9npF3fbMlsb0pZnVNY4Kl3p10RxRfyg
         6Wsg==
X-Gm-Message-State: AOAM533DDYvL3u+QvvKuM0d0T9/ya2SjzX3DfUrFhp4ep1V5yrwN88Qq
        2zdLUQHI0GnavhplT4gluGLRokxR3DpfMw==
X-Google-Smtp-Source: ABdhPJxkx3S653CWLV87CZpb+uejeA9Sh0tj7pfFGayb7kKLYSNa35saleA7T7cwpsRVBUL+FP094Q==
X-Received: by 2002:a17:90a:c698:: with SMTP id n24mr8439390pjt.81.1614006997024;
        Mon, 22 Feb 2021 07:16:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id me5sm17745235pjb.19.2021.02.22.07.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 07:16:36 -0800 (PST)
Message-ID: <6033cad4.1c69fb81.5b6a1.4d88@mx.google.com>
Date:   Mon, 22 Feb 2021 07:16:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.257-33-g503da28c4418
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 37 runs,
 1 regressions (v4.4.257-33-g503da28c4418)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 37 runs, 1 regressions (v4.4.257-33-g503da28c=
4418)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-33-g503da28c4418/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-33-g503da28c4418
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      503da28c44181b67c1261b1d0fcde82d567388db =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6033923c51e9e41e76addcbb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-3=
3-g503da28c4418/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-3=
3-g503da28c4418/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6033923c51e9e41=
e76addcc0
        new failure (last pass: v4.4.257-24-g8b0d95badf63)
        2 lines

    2021-02-22 11:14:57.259000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/120
    2021-02-22 11:14:57.268000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-22 11:14:57.283000+00:00  [   19.116516] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
