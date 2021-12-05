Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443D4468C85
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 18:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhLESB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 13:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbhLESBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 13:01:54 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F34AC061714
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 09:58:27 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g18so8044433pfk.5
        for <stable@vger.kernel.org>; Sun, 05 Dec 2021 09:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bf1qMWhBeMrsuFV1ctvB0DZsk0wPiSbTv245IM2eETc=;
        b=W6hQgcQhUMt+0/O32n+r6IMN/9LU8Prq82XeFeXyEkCTVnESWlrTa5EQdobEwFCOUL
         eZc7q2oyucrILzVC/UgeikqhtIGovW0wery1PNevLT6wb2EXnFVgmDoUTSwjtRRK05fR
         mJxFR/l2UetIHmmjnPQKGzeB8rmk3U5zHLJUV/KfMXhPoIfhGRTP6GWycoKrDCXyKLfV
         SfsQOYizYXC21qfcDR20mxA54Sxht62FkbDIwUb+r2XryjLwbmwpaeGqFd31cQOjOims
         8JSnmS3xxvm4ZROaUAQyoSco5Eq3e0d1g5OIOkkoy+gKtC+2H9dO2NRy+dpHnfQRiWF0
         uVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bf1qMWhBeMrsuFV1ctvB0DZsk0wPiSbTv245IM2eETc=;
        b=X+Mssh1Yi5UiFsIsjMN78cGHgd40VVQR5fiSZkF0tB1Cq2rptNS84YDkd+w27/eGmP
         dLgyAzyNotVxfrXphB5qwi94bv5gxlZfwiNppM0pdJUpKv37rX7M9gb0Pegb2aQEyRTN
         65Eu7b1j1NX9+yFXEyKJtCnStq3uNFKGyPa11DQYMKNi/Ce1z3IkjnNplW4MrhCNM4bd
         mI+79HTaM8SLLL9gpJUViHj8I7RK7GMpN5jH1saNJ/ADwOejRKi8ywNHhs29K7BNQcui
         BwcmmbxINtunJsPK2U96QPcn3lytig3QIAMQZ2Xc4NJ/Qnj0Un/d9z2SazGCPKqE3MgA
         JUsQ==
X-Gm-Message-State: AOAM531RcD0oF+WbV2Ryj+BlOCiiFfgZe5eg7jEMl/OZ29YLbKCtJ1yw
        Zb8PSRuPKfJd/Wlj9aZhGG4ODJpuSyikA0fH
X-Google-Smtp-Source: ABdhPJz4KeMP9psGoYMmu1XWhQgInZRUiJ1LupgRBjAmZeg5eBvPEIr+qG8KIWqdYn/eOVF1Gi/sNg==
X-Received: by 2002:a62:884c:0:b0:49f:9947:e5cd with SMTP id l73-20020a62884c000000b0049f9947e5cdmr32064842pfd.45.1638727106743;
        Sun, 05 Dec 2021 09:58:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p49sm3742710pfw.43.2021.12.05.09.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 09:58:26 -0800 (PST)
Message-ID: <61acfdc2.1c69fb81.41fac.a2b6@mx.google.com>
Date:   Sun, 05 Dec 2021 09:58:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-56-ga36422485852
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 101 runs,
 1 regressions (v4.9.291-56-ga36422485852)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 101 runs, 1 regressions (v4.9.291-56-ga364224=
85852)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-56-ga36422485852/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-56-ga36422485852
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a36422485852c23b51e82b46ae04eaaff3d1a2aa =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61acc63b9ddbfeb8081a9487

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
6-ga36422485852/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
6-ga36422485852/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61acc63b9ddbfeb=
8081a948a
        failing since 1 day (last pass: v4.9.291-47-g43f5262d9792, first fa=
il: v4.9.291-51-g9e9032945598a)
        2 lines

    2021-12-05T14:01:07.367971  [   20.298065] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-05T14:01:07.411964  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:2/74
    2021-12-05T14:01:07.421526  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
