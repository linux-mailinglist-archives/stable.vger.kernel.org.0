Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBF231976E
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 01:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhBLAZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 19:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhBLAZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 19:25:09 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F84C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:24:29 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r38so5105834pgk.13
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OEic+Ez7lLBHPdX4XMC/udxfhBTBh7RfYSbZlk1p7X0=;
        b=sUkquMJrxDBM9kR48Qcf60IgeSEHoInCt5pZ1XbbWhofRFFV8PpRI0CYkRB4zpExSg
         Bvpz0INCRnJm1SZ2W8P8PufkobXdX2VOwNNQPeKGcPNXBfaLa9XDl6n0fZ/R9HfoZd8W
         DDTdbBCCXtfhti3CmlYIXrLdbBGEC8/N7blSIVgFVoKC6zpTRZZaJVPq+MeGmwFUzx2j
         zPizW41jPVCIG15uA68f7tUk8bzo+o+uJmHRX5uEQ+ciZb/+B1RGuqkRQcmUJL6eg+Om
         qnd8+DbiB4Mw4vlLe9vvuPm4NHQ+vrwwyg23DHqIybP5Coii4qjh8ybH5XvHfAzBVXvY
         7dGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OEic+Ez7lLBHPdX4XMC/udxfhBTBh7RfYSbZlk1p7X0=;
        b=gWXW2cqbQwa0LGsSrz/pE0vK6ztM/1D90ZKaF+ShJZaD4jok9/X/Uc6tBcD27+jaIF
         5c/wfUGht6T8/jx0EzDI+UMAfQ1w/0U+5FZOePVq3ZKw7+uKZ1W56Y1AemqFzlpiHh3E
         WDwmVm4bR/S/aB7aJaHZ5vupLqR6qKL5Y+gd7TDNcKtDLHda5N0OB5w2x6JTktS06l/V
         deKpcy6P8i9ElGkRMJLHbz9Gf0Q2qLjaBgo2HlbKHBiuhYJug8bvzRqGRzUAYiqMKIFq
         UcPJ6J/jK4BAQHgM8TCIhRaZjz8bevl5Ro3VpssUgefJPWpe5jQtKhyxHUHaEeS/1+jm
         tCiw==
X-Gm-Message-State: AOAM530qkAFZhPdegbzBqJ+uiZ1qWNfmi14B8W7LtAizAeumjwpcXyOL
        LEKePdzRK+BzfgPF1pLiRgt8IoLZ42lowA==
X-Google-Smtp-Source: ABdhPJx6tG2HiLiW3JskeNnTM1ggDj5tFS3gDk2aWilAXQkl9nXpjlX1kIuZMTvXtjavb/Ao4hik8w==
X-Received: by 2002:a63:2009:: with SMTP id g9mr636921pgg.219.1613089468580;
        Thu, 11 Feb 2021 16:24:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w123sm7039839pgb.13.2021.02.11.16.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 16:24:28 -0800 (PST)
Message-ID: <6025cabc.1c69fb81.4a268.0336@mx.google.com>
Date:   Thu, 11 Feb 2021 16:24:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.175-27-g88ddaef7a495
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 56 runs,
 1 regressions (v4.19.175-27-g88ddaef7a495)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 56 runs, 1 regressions (v4.19.175-27-g88ddae=
f7a495)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.175-27-g88ddaef7a495/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.175-27-g88ddaef7a495
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      88ddaef7a495c2f57611698d6823ad32fa7812d6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602597ceb418b0f5893abe6d

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.175=
-27-g88ddaef7a495/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.175=
-27-g88ddaef7a495/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602597ceb418b0f=
5893abe74
        failing since 3 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-11 20:47:05.945000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-11 20:47:05.959000+00:00  <8>[   22.838470] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
