Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9196D452A0D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhKPFxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbhKPFwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:52:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334C3C03E00E
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 20:48:32 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v23so14706290pjr.5
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 20:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hRv1Iu95XpM2sT7eBA2aU/5NWwD86b+dup0YB59aKHI=;
        b=ZOKygyOUT92qgi4dkZV/GwnP0SZic7+TRxDrdvzm70vxYyCqclubwZRuTd8IJI8f1a
         z+b2cqYGvi4oreL/zZ27VmwL99Ox951mpt9tguXVWtMlZtrJyahSf6OlKON14OoCNsd6
         VXvzUF5PNKhzd2ZqZCAQ01eG1wMQBraoXqe+sjPa6gUh18PVs0XJhoZ4+RtLe04XaT3m
         3PISDcfR8gviH/Ypv4fC5M48XZFGHHSF1fhUno6tyTChmHi+CYsZm9iUkS06+gpHGy9V
         2tUYtbjyBdIQbAgMmAUoZhLmnHeeX9Pf6QCOfGJlWX3Np+foTZzDHyix9oEwaerQWSAd
         lMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hRv1Iu95XpM2sT7eBA2aU/5NWwD86b+dup0YB59aKHI=;
        b=CSx45TitgErtlY0Zr+l5oPUQN9wWLlNKhnptdzwV7faYrWIo4Ig9nM/h/qzvx8U0Lp
         eyxNZthHo+gmVHUa+W/8REGNByHJLEdKmh3FPyDsUe1hoci7wVlivMO4roxUjMisL8eJ
         lMn5A7K/zrERMYA4yK1wBR94PEKc+xhKy5s5F6l8XIr0b/eG7OQAKH/fW0Lh1iGA2WCt
         38G6HfKgAkHYKB8FKlO5vVytI3vtgRLwCfx4XFIlaaLTRxqc3PwdzP4pcyUPeSt1R7bf
         STsrIA7KUI3zijEVtzs+eoIGeZTOveU3vVJV/uJaoA3KaHhilQCqjsIRlYPPsUBuhyrs
         cGRw==
X-Gm-Message-State: AOAM531PX+V8TI4CMAa09VVhJ7+nGdYOaSQe3f3gyJ992/Ole7q91KHW
        1sLQT0FU0afaJ/a3+jmPfmWQpL1i/HWx8tIC
X-Google-Smtp-Source: ABdhPJzMpXNsFIReqr3y7v2uLncATy5OcQ3Mxg3rMqBOXP0RDACn/6r1eNHZZ/a/9Vr7O60OU3N5VA==
X-Received: by 2002:a17:90a:ad47:: with SMTP id w7mr72386083pjv.16.1637038111587;
        Mon, 15 Nov 2021 20:48:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y32sm18956946pfa.145.2021.11.15.20.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 20:48:30 -0800 (PST)
Message-ID: <6193381e.1c69fb81.859f7.5f92@mx.google.com>
Date:   Mon, 15 Nov 2021 20:48:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-199-g5f20381f9cc0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 112 runs,
 1 regressions (v4.14.255-199-g5f20381f9cc0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 112 runs, 1 regressions (v4.14.255-199-g5f20=
381f9cc0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-199-g5f20381f9cc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-199-g5f20381f9cc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f20381f9cc095eae31614683bf6689213516759 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193005c9114fb87dc3358e4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-199-g5f20381f9cc0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-199-g5f20381f9cc0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6193005c9114fb8=
7dc3358e7
        new failure (last pass: v4.14.255-198-g40a2f39475a26)
        2 lines

    2021-11-16T00:50:18.633028  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-16T00:50:18.643867  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
