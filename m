Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02D32E2290
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLWWrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 17:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgLWWrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 17:47:12 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7501C06179C
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 14:46:31 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n25so481822pgb.0
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 14:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Aoa2jL4MSpuNZXmExdoIuQRNH7KICo9n78C76PnoXcg=;
        b=Z2FEr7uZp52wm6RxwEQtt1BstLzaJgjNvSO4EBbaDUYwDDC0K0cNZSewqv+FDSJQoe
         GEqEYMIhCCD9xwioaPqKb5P2qF4MrAW0slEly38q2aIf6DDkf8kCrV/iAFzqdiHFDOzX
         qtbir4Cj2J5hlvUjjUUdQPkJk6aYRkoToVR7djSq1IuMjITCVn+av7CY3ZhDbXsDTy2G
         9fcFLUFJ4ptAP+DzXRgnSY8a9s9o1uCzPHaDNhN2+8mCiBknuvGDPv1+vHzBcQxrGKxf
         qFm2hBOdRLkaU5Aop/bTZEZ1KtWKpZ3RZLz1zTmbVVCNQbLEFkPg3u8tP/DdaTVoLhIo
         1Blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Aoa2jL4MSpuNZXmExdoIuQRNH7KICo9n78C76PnoXcg=;
        b=gijLf+BSEkwdbnEnFbBta6G7F2TPLI5UKDqd44NSiMIIP9md9E26pk4qiCsrutMp1F
         NW7UGDoLqTFXyVLSRimE4M2EQdCytsZ2pPpPoVRQuF84lsqXf2cwxnuMD9O6zJwUpS2Q
         U2VUEuBSZA5DyjQCYcMnxa2jSBLrUtkinfvWvZ80/JOaQrCd7/bSnU8sOquft/ffpp9H
         mCbMMONfR2xz+Jn4vWzIATGmrkoRpW4xQuQ0ActEvliymbJr01jez7Rpdk3SRIIPkQaG
         1+IZMRC9s0PI15ae6FPHfvHBY/GFxyTNS3kzI3dfkOyBjY8qdStyUKzU5w4d1fKGWezp
         fmAQ==
X-Gm-Message-State: AOAM5312KNBPxqk0sG6IelNydigRVaEzsnV9ElG8DpqUHBI8jy+uSGer
        TBDyz21BsnEYOIojq/w0qqfe02VlECoCJQ==
X-Google-Smtp-Source: ABdhPJzhawjmxUWC4dCo/uOKWwYf6GOZcIj5m8+uRz/+lEXrXz93X/XZUFRHdL1FG0DBFKiYSKpt/A==
X-Received: by 2002:a63:560b:: with SMTP id k11mr26472233pgb.89.1608763590816;
        Wed, 23 Dec 2020 14:46:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o123sm23697801pfd.197.2020.12.23.14.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 14:46:30 -0800 (PST)
Message-ID: <5fe3c8c6.1c69fb81.29807.ff54@mx.google.com>
Date:   Wed, 23 Dec 2020 14:46:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.248-31-g5518a5e31cef2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 69 runs,
 2 regressions (v4.4.248-31-g5518a5e31cef2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 69 runs, 2 regressions (v4.4.248-31-g5518a5e3=
1cef2)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig           | regr=
essions
-----------+------+-----------------+----------+---------------------+-----=
-------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig  | 1   =
       =

panda      | arm  | lab-collabora   | gcc-8    | omap2plus_defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.248-31-g5518a5e31cef2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.248-31-g5518a5e31cef2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5518a5e31cef2eaf6032c10bc79415b7b141dbc0 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig           | regr=
essions
-----------+------+-----------------+----------+---------------------+-----=
-------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5fe396f9aee254249ec94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-3=
1-g5518a5e31cef2/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-3=
1-g5518a5e31cef2/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe396f9aee254249ec94=
cc3
        new failure (last pass: v4.4.248-29-g847e9e7f8e717) =

 =



platform   | arch | lab             | compiler | defconfig           | regr=
essions
-----------+------+-----------------+----------+---------------------+-----=
-------
panda      | arm  | lab-collabora   | gcc-8    | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/5fe396d72ec7902f14c94cd8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-3=
1-g5518a5e31cef2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-3=
1-g5518a5e31cef2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe396d72ec7902=
f14c94cdd
        failing since 1 day (last pass: v4.4.248-21-g91c1ef779a3c, first fa=
il: v4.4.248-25-g32a037da5956)
        2 lines

    2020-12-23 19:13:23.391000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
