Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41479454989
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhKQPGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 10:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhKQPGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 10:06:11 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236A4C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 07:03:13 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p17so2521043pgj.2
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YPJI60LZ2uJhGczVwgJo2/b1fSXADUeKDh96cbRTEWM=;
        b=ZJ8mq0pae6ShBuu78aCYSekKCCaYZ/ZHFJ1KypTxULi+x/n6XVZMa7vCzPi/noXz1N
         cgfwbe1J2XWlVp33PjekaIsb52FH1dqSvWE2baryna1Vf471hUBLGP95wKNdx+e83Blx
         tWBeUVsm9hF+btFpd50uifsRikSWPYc/nGhgO5CjsQNW1qnsHsm37X+D5qCHHjNqYHY8
         o2sqRnIgiZrPhK5nNjuRzfOmBaalfIOgTAZqdCHQWNbIwCMcNxFRZJHwgxduQ0/FZo4b
         etKBkkL1Bdq5+z1RIrhDy5jiKB+XBbM8P5gCXZ0YTN2q91c9Y3TPh+aRiv5DDY9TyaO7
         2hJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YPJI60LZ2uJhGczVwgJo2/b1fSXADUeKDh96cbRTEWM=;
        b=gPv7XRAKcRwHtdPyu3mN7F8w5aX9QSVgWnw4xuOafnAuFbGoMAb6/x0dQ3BD+KS8cl
         AQUMHBoKHqloBNuz+qLNpFzkkR0xaAhigJ6A/+dcVNDtJ/DIySwx6KUPqsV22tGJ5Yay
         NMz8o5HY1jByEPuLyWjKDUR7+QdVtQsqz7mQsSu5S+ISGsZKJXDDaHmSpwEkZ32vxZV8
         hkyH5rTL3M+TR1iXBjqQJGeuezuXbFVJGI83lzVfElI8NBC+L8kwyPsx3xSkhHkQ0WJg
         Kh4mt1nyolsYC5bS7ggdWz/CHxyBAuLnCl0gdhU42dCeEPUIw1xzS4QSN6yqNW41PqIo
         Kjqg==
X-Gm-Message-State: AOAM530VE13IM8RVMl9DGc3Pv5nMwLyjn3uoFCH89YTdr7iJ40QxaPTi
        Me3PYfoHq7iVbLYvo7upIPpHsBAJigBHuZnp
X-Google-Smtp-Source: ABdhPJwJsTcjpUajqw1WBzS1kA/kcwpOSAWHzMX+pD/iseHLWoPCHnbw9dRUXbryF9Q6dS80eZgnTQ==
X-Received: by 2002:a63:684:: with SMTP id 126mr5590447pgg.213.1637161390075;
        Wed, 17 Nov 2021 07:03:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t31sm48886pgl.47.2021.11.17.07.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 07:03:09 -0800 (PST)
Message-ID: <619519ad.1c69fb81.f9cac.02b8@mx.google.com>
Date:   Wed, 17 Nov 2021 07:03:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290-159-gb2c6c16b9d4a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 95 runs,
 1 regressions (v4.9.290-159-gb2c6c16b9d4a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 95 runs, 1 regressions (v4.9.290-159-gb2c6c16=
b9d4a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gb2c6c16b9d4a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gb2c6c16b9d4a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2c6c16b9d4a59c218aed68a9567ad55336903e9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6194e03a523c47278c3358ee

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gb2c6c16b9d4a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gb2c6c16b9d4a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6194e03a523c472=
78c3358f1
        new failure (last pass: v4.9.290-159-g2cf93eac9faed)
        2 lines

    2021-11-17T10:57:47.479357  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-17T10:57:47.488590  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
