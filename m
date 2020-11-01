Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63AB2A20AF
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 19:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgKASG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 13:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgKASG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 13:06:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E0CC0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 10:06:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k1so2142687pjd.5
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 10:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eB75kUHOraSO/grXIeRidjMptsqvrvShQMd34KjKOGA=;
        b=jPqrbjOEQLIyIfd8PECVC+cX2pIijSwLcKslNj+/SDHgsStB6CE4xCpZBYEiW3bNhu
         GqyVWhLIQ93UFD5OsAfaTjJlXObnE3SfrLrOyxiLivg5f4Yg6qDaT8B7q7Fsl/JVP9WL
         oJRFfIZly/hUBydMt5jTRbGb7jkwVoQtibb+g4LSPLFWFeCipT8Zum6HTz0Tz84hua7j
         AnCjMKO+i0rQMtwgrXi3D+OOunIRKQLmKdmIoIVaUvDxPEf4T45g1GNr5sT7HoYBvc1+
         cMtide3whA4VQUYqfYGzaMzbTk9IvZlDR5TjOfnHzu5KDN3hTKndgd7olEjKdGySDBSb
         9Vdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eB75kUHOraSO/grXIeRidjMptsqvrvShQMd34KjKOGA=;
        b=bIxTy2CRue0vGDqmtC0w4s9d7lIlg+nbouwdur6aR8nTVwaXfmLkbhoj8dWAkOKLUE
         Z/P3tSj6NKnvCjvF+PvEsPVzAvkxI3FEWTTXik0ha4hu2UU99D6J/HjXPDfe4SnV6OoG
         iCSVZeAjZTYAZvytABdM2PgVW3NSN3JYlXZ7uyiDp2tJjbXV8tEUn9BIODlkN4WP+XfS
         WOLbDv/lPyVibQy24kGdOT88+wNrRqe7NZonx8Fx66dg6yoekc48qc0LYHId+trDTghi
         3PJKGDxU7fESs/rtsDnlq1m3p4cuQx1XRFsUfmjQs2PxLAkzZv8bZDDVoFFLyGuhaOXG
         KKGw==
X-Gm-Message-State: AOAM533V8G6EdMueQacjUZtcGp0VNFHsOQBxHe5gejqH6AKvwimF0ChA
        L46OQUKAtXOpuP0gdPnyr2JejRvY5R2YRw==
X-Google-Smtp-Source: ABdhPJytyuq7mj233PiMg3kuhhXX4E4HB5a6TorbjXZBqGyOL2xc7RAyJaM9cGvs/jlOyPvDnhFubA==
X-Received: by 2002:a17:90a:ed97:: with SMTP id k23mr13878563pjy.100.1604253987681;
        Sun, 01 Nov 2020 10:06:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e7sm10758145pgj.19.2020.11.01.10.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 10:06:27 -0800 (PST)
Message-ID: <5f9ef923.1c69fb81.a46b8.b47b@mx.google.com>
Date:   Sun, 01 Nov 2020 10:06:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-35-g23abaeb3f32b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 191 runs,
 1 regressions (v4.19.154-35-g23abaeb3f32b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 191 runs, 1 regressions (v4.19.154-35-g23aba=
eb3f32b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-35-g23abaeb3f32b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-35-g23abaeb3f32b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      23abaeb3f32b65e617d9c992555c18651d2d2e3c =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9ebf050a2e8d994b3fe7e4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-35-g23abaeb3f32b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-35-g23abaeb3f32b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9ebf050a2e8d9=
94b3fe7eb
        failing since 0 day (last pass: v4.19.154-17-g3d66f439c70f, first f=
ail: v4.19.154-35-g047c97e1e99b)
        2 lines =

 =20
