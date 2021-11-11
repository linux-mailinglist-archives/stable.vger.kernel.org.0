Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA02D44D033
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 04:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhKKDDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 22:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhKKDDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 22:03:32 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215EAC061766
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 19:00:44 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id p17so3947566pgj.2
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 19:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=emaU97g2PIgayWrYFLWjuLGWBCX+amZHncXcro3Idt4=;
        b=p7j8aJ9958f+IqCU9hdGhkRYCqymwr23sqQsrFWozYjFUon1filaX+TI4BD/Aze36h
         ecX9GHU/1X/axabzGx8yuLERtwMLXQsZ4X+vbdhA70qWrVMg2ABgD1eVs1cbjtpqYCiI
         C2YUZhABnmRHvDElyUh8twgYJ1B7QWVTTbys94OgrpjRfUOOVnHf9GFaiC99Qip7ijAd
         8VEmQwA5p+GrW8dwueTQN0VePwd08wKeQhFSARSRvPuv7E5QydUjNY3XeMEmDhecZRKy
         F+VE0696wN7qNQydKxhXFXx+KSeFwpTaEvtP6IsN7Ikq9ybfKVCB0ryyK3wlSPfim+nv
         AUyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=emaU97g2PIgayWrYFLWjuLGWBCX+amZHncXcro3Idt4=;
        b=enU9xtX0pILbLiewZsPrjjn51LFzeuL7scIc8LPPAlj68xJGMe++xGWLBRqaaSArQa
         LAh2PbGzW2oG2FXlCuv4e9Kznnf9HgAVZ8+M5pgzSC3LQPr22GNzAFpzKcnDt3YuQYr7
         y/O5mf2jK6AQuSwEpsc/XBwM4Lj2OFJLTobUEquCC32aIPdR4g2NaQ0cGQcVjOzVuWog
         P6BTDnF2pMPL5VR8Ic9AXe2iCdNghx1rqsqpmUf7VicYim3YnFAOEc1O5J4x9ntrF7Pu
         6AOTPMxzde2KO3Dg0kGmlPE3iqOiSn9aNbMJ/5N3pWegF39diW+VmymEpRPJXnilyw5i
         tHZw==
X-Gm-Message-State: AOAM531Yl3jaQ9sNJSR+gebE39SuCSpYtAhRPpjDRIDTSVLQdsMyt6Dh
        sqZjvL/6/+MQZ9irTp6mDZoqSG0JvOjUxAWFVpY=
X-Google-Smtp-Source: ABdhPJwhWvyQc0QvgjYoV8IrSwTfeaKoePfLyloQTLMuntFAj5/kSVgfNlLgZfwWnkX71nqzjgOb3g==
X-Received: by 2002:a63:9844:: with SMTP id l4mr2466273pgo.271.1636599643523;
        Wed, 10 Nov 2021 19:00:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lj15sm845584pjb.12.2021.11.10.19.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 19:00:43 -0800 (PST)
Message-ID: <618c875b.1c69fb81.15006.3a03@mx.google.com>
Date:   Wed, 10 Nov 2021 19:00:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-24-g490e6570185e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 171 runs,
 1 regressions (v5.14.17-24-g490e6570185e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 171 runs, 1 regressions (v5.14.17-24-g490e65=
70185e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-24-g490e6570185e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-24-g490e6570185e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      490e6570185e6437cf1186a728921c1311ebdcc6 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618c4e46cfa5b918f83358fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
24-g490e6570185e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
24-g490e6570185e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618c4e46cfa5b918f8335=
8ff
        failing since 17 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
