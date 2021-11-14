Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600A244FB8C
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 21:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbhKNUXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 15:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbhKNUWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Nov 2021 15:22:48 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB44C061746
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 12:19:53 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so11480937pjc.4
        for <stable@vger.kernel.org>; Sun, 14 Nov 2021 12:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OcKZOI0Dd9WpFQYm4dC10ELAbrl6W0vK51cGVBLBeLE=;
        b=XrVb5dN66gWHG13plGJ0JTZ+2Qn9jFP0Accjicm1xFdby8Yw3CU3I2LsV7Jzrlb+3w
         KeQZMM/XiESEaOtmbqSjKmt0f6ZrQghm7LY4NhTlwHJyXfixunyVFU/lrp7Fb8SkYhHA
         kCPqnUw2s0120pwxUsY/zYwjJe2rn4r59kja3rtV5okFsoIKZHdD7QN6PKXzSu8I2R+u
         XcVXkYZIRJwpKTEpjAKlegIR/iub+XeY+R6ovIF6M+plMkNGEsnpx/94A1UtuXiOssmG
         h6ongAXFjcpjTb70tg/khYNzmAP78WpoXVFVHYXHoMDYmQYskYyDoQVvdhLl7x3aS+k4
         HKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OcKZOI0Dd9WpFQYm4dC10ELAbrl6W0vK51cGVBLBeLE=;
        b=TDR8PdQ3aCogQ6in6VWteHokLTV2fH7eoMO8FmfiMrxmKdwhjzy4+JP1XwREkUAqQg
         wLqCR16/4YoQ42elniCsxzcC4OgMmua1ioGxXuR9zD8f7Ta4Hmd+xISqx/y7lJpYcZqK
         tO/X4vVZ9QM2TPi0kcQagB5/vrMlGty2O+MMX5KuVOajNkKtOqr201yI/+dGklMCZgCc
         ksAZwSe3hL+qpNagXJGncgGIOEavmjZZR2AAJhVU2K9o/PaVd5i1pUPirOuWqniT/Jog
         NEZFfKJDifnUOoey2LiJvIspeAALa4CEo2/e3NgJD7N4tV+IPHPZnsHigfcDb1J3ubbA
         Q/bw==
X-Gm-Message-State: AOAM532ZFEPojv5TyeUUamyeC+sWZ3fucFsfJr8W/aDkaEur0IvJEwYL
        +fc4EcQPICHHnmadghE5L5Z78Netde5/nKZm
X-Google-Smtp-Source: ABdhPJxXASOoAHobASjSDkIBol2LCzuAyM+/Q0+BG4xeeN09JjwGhO2LXvEOm1vXEXbzyYbg5bifuQ==
X-Received: by 2002:a17:902:9005:b0:142:1d6c:797c with SMTP id a5-20020a170902900500b001421d6c797cmr29501080plp.4.1636921192848;
        Sun, 14 Nov 2021 12:19:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm16809959pjm.14.2021.11.14.12.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Nov 2021 12:19:52 -0800 (PST)
Message-ID: <61916f68.1c69fb81.8256e.1308@mx.google.com>
Date:   Sun, 14 Nov 2021 12:19:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-85-g1a2f6a289a70
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 176 runs,
 1 regressions (v4.19.217-85-g1a2f6a289a70)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 176 runs, 1 regressions (v4.19.217-85-g1a2f6=
a289a70)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-85-g1a2f6a289a70/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-85-g1a2f6a289a70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a2f6a289a70a22707673068bfb1f247d3e29d08 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6191351f014da42ea03358ed

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-85-g1a2f6a289a70/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-85-g1a2f6a289a70/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6191351f014da42=
ea03358f0
        new failure (last pass: v4.19.217-72-gf6a03fda7e567)
        2 lines

    2021-11-14T16:10:52.332242  <8>[   21.324462] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-14T16:10:52.375311  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-14T16:10:52.385450  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-14T16:10:52.399364  <8>[   21.393218] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
