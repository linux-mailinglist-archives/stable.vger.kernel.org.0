Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70A49BB7E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 19:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiAYStp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 13:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiAYSto (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 13:49:44 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6178C061401
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:49:41 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j16so9671766plx.4
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 10:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oTClQX4/8y/IqFEiCbkuJi2hzzLiE25mcwor5qZ2z+8=;
        b=B5WRCrLWBaeEG68Kgfllm+xvH9O1jvRDgYbyVx1/DK/W9szfPEGaNRaFOYyxWtPUrC
         geLk9wv+FEJk5IZjOAfJu9wRt4bH+fPFcmSKlHz18Zt4KOChFKwru9NAH61F0oanCQOh
         1gYsQi8e8ZV1hfivfwxDg0vo1joCAn7Ig4jfyQR1xuGfpakpZve2PW7Ff9UOGYKG3nQj
         TSD01Xst35XZMj2Eq59Y1iWaVugn0Y06qiI+JTw7mbFVwjAc+2uUj1x7HuEslMF3bBN4
         uUK4KOZkHkRzLUar4LOy3fWxoO18valczCXilGkLQbOEYpXCvGeRdga0Bykn19/8jJYY
         vvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oTClQX4/8y/IqFEiCbkuJi2hzzLiE25mcwor5qZ2z+8=;
        b=BMM7lDKSvwerLrXmZrWpFHt/w9hbu8UpO27HNhmVzz9pF+/Re/fCDOdiy1EJazyu3+
         yy5jhYgEDp0nupn+B/OdPyVwxOpQbP94kxTqvF6aTlIvngDj048C1El2r0cNWtkPKx/X
         wQ4CxbruwM71f8JbQv++WDs4BkNj1dja7CxKCjNerAArkS39sxfb/H4qJvGCQ01V4MYV
         1tWhCvtyt9RKUw9bPP3Wa6g6+cHNX3XiP2h/fAVvDiNztOZI3zkIFEYUbg4ZyAKc0QnW
         6j3BpHe8GdcSZLgsqMoy2kJlgdyQLc4TEakUaAY9/ur+e863w2KGQY2cRgnIUKVIv++Z
         3FTg==
X-Gm-Message-State: AOAM530G8e2lMzEXA+ceq3bVMxtGXYg4v9n/0lNSHLArvpzfjzpTMAQs
        OJeo48AouObrf/plRDBoCx+mGx1x0fdot5qA
X-Google-Smtp-Source: ABdhPJyJ6/sCj24/WOFPMLQ8KgcrQKgHiyF0sQrP73ediehhYnLPusRjuPjfmkwsnHJ4/QzqWGK6tw==
X-Received: by 2002:a17:90b:3007:: with SMTP id hg7mr4949229pjb.78.1643136581086;
        Tue, 25 Jan 2022 10:49:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16sm21765844pfa.147.2022.01.25.10.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:49:40 -0800 (PST)
Message-ID: <61f04644.1c69fb81.c25d9.b554@mx.google.com>
Date:   Tue, 25 Jan 2022 10:49:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.299-113-g69586d700c98
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 1 regressions (v4.4.299-113-g69586d700c98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 1 regressions (v4.4.299-113-g69586d7=
00c98)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-113-g69586d700c98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-113-g69586d700c98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69586d700c9831a5ddf09b26b8493230ab2aeb63 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f00dc2a7e2442578abbd79

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
13-g69586d700c98/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-1=
13-g69586d700c98/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f00dc2a7e2442=
578abbd7f
        failing since 0 day (last pass: v4.4.299-114-gf2a0d44e5c7a, first f=
ail: v4.4.299-114-gf17c34b78a00)
        2 lines

    2022-01-25T14:48:11.821483  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2022-01-25T14:48:11.830809  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
