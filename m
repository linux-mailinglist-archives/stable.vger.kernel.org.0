Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B446149ADD3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbiAYIK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240623AbiAYIIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:08:51 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552CAC0604D8
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 22:43:54 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d5so16576757pjk.5
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 22:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g1y0JeBuTLYx/ANvVrzCUtjLJSgorm1k5hEnJ+lrG1Y=;
        b=iHKT+CblVERJlRDelYMLjtLr905xxvWp2O9GA5/PD1ceq1EhNBGBDUQlmilRefIdPk
         H/WzAehE5LPvfu4a5F5qLra6PKwnRMp+fKm6MUWQqduMBbjZ3mBOjb9YImD9/JUQBycJ
         e6gCPX4rprdPmSkXDU+qMWF9QwQJGZanEL3WYK2zHKJMqV/cqefGM2FbPp6uLS/Sj90+
         1kxKD+t7SR15JgRcG+3pzxJZbXkrvFHY9kkyXPmxMZmUosbALq5u+cbm/+qssuhplLFB
         ZZCJlzdU4FLflA11aeoUHCH9uT2Ja2TDYV0XfDKI8KmdMTv9EDUTQiYgVGcsIjEotNBP
         8Pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g1y0JeBuTLYx/ANvVrzCUtjLJSgorm1k5hEnJ+lrG1Y=;
        b=dcLFFCgfriIAaq4yVc4gzt6gbIgebaYp0Gb65HCwEiKQx75gDjdrvF7Ca77eawHLM0
         H0hE1lQAzqGe1GT6FmqKrRUZj8jUbAHhVIjljVzKT2nzRj+FH52ydTpMH7kcidOdi4xo
         2W14RyhOZOpXaqlZnN5a5M0FVu/O0FsRYIrGmOVwnn+CY1LuCtc7OMwDfW3AwUDzsdzi
         OZ53p+1LT+lA+r3Q1u7u8BKg5zvrlPty+U+sph6OdlwTE+4XilV1ANNdpY2hNOcTg/r7
         gmX0xu3sdI9/2WCeXvRLRcWQL3TqHZYgDOp71Tei5+1BB0fVcm3PQQmZfgGapKWRNzCK
         aN8A==
X-Gm-Message-State: AOAM532iWePu/70oD8wzQdgi7z/ap7WTt1wRr7MXVQm7oHKl17YOiHyC
        1agUJN8Ac/gSUlV+hq98+hVVWoGommUCjmjb
X-Google-Smtp-Source: ABdhPJygdkAgY3N8t0NU+0sauDZM7x/N0gSU/yl2/13cIDuXW/tuwiEgmyM6DuFGFy7qPECd6urYpQ==
X-Received: by 2002:a17:90b:1bc7:: with SMTP id oa7mr1966283pjb.149.1643093033752;
        Mon, 24 Jan 2022 22:43:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm19017218pfj.115.2022.01.24.22.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 22:43:53 -0800 (PST)
Message-ID: <61ef9c29.1c69fb81.8d7c6.326d@mx.google.com>
Date:   Mon, 24 Jan 2022 22:43:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.225-239-gdd903a45b8a3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 1 regressions (v4.19.225-239-gdd903a45b8a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 1 regressions (v4.19.225-239-gdd90=
3a45b8a3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.225-239-gdd903a45b8a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.225-239-gdd903a45b8a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd903a45b8a360e9f7651605b2f43f91e439c1f2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef662a1335f26dd8abbd40

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-239-gdd903a45b8a3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.225=
-239-gdd903a45b8a3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ef662a1335f26=
dd8abbd46
        new failure (last pass: v4.19.225-239-g087a7512e40c)
        2 lines

    2022-01-25T02:53:17.838032  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-25T02:53:17.847345  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-25T02:53:17.864808  <8>[   21.393310] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
