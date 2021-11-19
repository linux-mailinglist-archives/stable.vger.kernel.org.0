Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167F74578DA
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 23:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhKSWht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 17:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhKSWhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 17:37:48 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C4EC061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 14:34:46 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id np3so8932528pjb.4
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 14:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vbTXY5qrK1/ADHYWfrXeZxt5G4i7AgXei6+9/5z+3cA=;
        b=Gl9HUXOEbAqfa3CW4eJ3RcYp6LS/W0eFtstDBdffL1ILCNPcN/j6BHq0eoqIU2LNYb
         ggtMAtawwE+uhTg4azY4NNgxh+egpnZdvmT/d0navKua7cEwQVMl6y+auS3yyjKHyKNn
         y9Oa/mQli7fYWS20l9jnxjJmWLmAr/3uH/WPv1cOlrs2u3iZGN8dWcJLBf5q7VoByYhX
         aEwRAlaAT4RyqJ1S7dSkjnShtAkZhTzC0XWt5laroMoEjCyn2YhfdA+bBbe+CI47W5R6
         fVVKJQyr6GFZUjH9nMdFNax9avNgIZT/wNJuP07L9POcddu3DENtT0sO6TZs0/QYra38
         8sXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vbTXY5qrK1/ADHYWfrXeZxt5G4i7AgXei6+9/5z+3cA=;
        b=Vt/ui5l6QJYRkq9qfmmYZwIi4nM/nmkWUitIxQRveYmOx1eTe/3MAUMGhddMuQKc7r
         enpCk9WH8xZhBZGiB2jCasJvyGLjNvEKkyjwge0ilUjLbN1dpJKOnCh8sL0u0FTNIqVk
         QhyScpQBYYZsU9HSKb1h2hNTmz5N7FSGq3GS4vM6xS5AwgHRy/1XlY1o1j8rm1umH2Ow
         /colfr45mp/h482wnPYESIi5uCVleahESDntctQ3vPPg3DilJ4YO6IULKfcq+8eU8LN/
         Svs0SUQYz6I4PyTAT6O3SeJdF/WPM5ZG/vqGrt4O2C61ViRWjeqrBc7FIZ49S4LRG8Aw
         1MkQ==
X-Gm-Message-State: AOAM530kbdbxn7UQ9iip62QBw8KtKcrJfGH5I0m6fhSodP93Zi2A0Ht7
        etcqkGr4YRWvctP9ho8BTEZkLcgZJ5Y1DFWJ
X-Google-Smtp-Source: ABdhPJyympP/ZbB05Y6wA5+9eeGd4VubIXaYWPJBHAWxLVbh6VJP/HC+7IbCyQe2zPOSYL4z5Xorfw==
X-Received: by 2002:a17:90b:1bc3:: with SMTP id oa3mr4070653pjb.52.1637361286134;
        Fri, 19 Nov 2021 14:34:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u22sm636621pfk.148.2021.11.19.14.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 14:34:45 -0800 (PST)
Message-ID: <61982685.1c69fb81.6f5d1.2a8a@mx.google.com>
Date:   Fri, 19 Nov 2021 14:34:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.217-258-g71fd6c08f1a97
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 97 runs,
 1 regressions (v4.19.217-258-g71fd6c08f1a97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 97 runs, 1 regressions (v4.19.217-258-g71fd6=
c08f1a97)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-258-g71fd6c08f1a97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-258-g71fd6c08f1a97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71fd6c08f1a97335e6cc83b95013bf2f744e9ca2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6197eea94faa30b400e551d2

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-258-g71fd6c08f1a97/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-258-g71fd6c08f1a97/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6197eea94faa30b=
400e551d8
        failing since 0 day (last pass: v4.19.217-251-gdb8a90cbc48f, first =
fail: v4.19.217-251-gd104c0a7fd2c)
        2 lines

    2021-11-19T18:36:12.863257  <8>[   21.303833] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-19T18:36:12.911851  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-11-19T18:36:12.920936  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
