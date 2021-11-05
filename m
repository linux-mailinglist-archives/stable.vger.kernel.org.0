Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE29445D70
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 02:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhKEBp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 21:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhKEBp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 21:45:27 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3342AC061203
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 18:42:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u17so10104932plg.9
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 18:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cYxVbFXaNDaGnQdrvaSJJU1Sd1S+0Xp1QblAqN4nd2g=;
        b=cTRK+1WD8UF4euQ7TN6DkOEQ3/840qYMZrcAoJSy5HeYhwuqYUYHTVNO6qMaHwKE1c
         D+jYrOrBL+h6kMEyRtFhspBQN50h2iDg89L6PVs4+La+0Qi6PB6m5I8AFX03tyvR2CsE
         OYBkIxl5euX0w6neYHqYzjujyxpVhJnl4Jw3T3Nhtq5uWJQ+rtJ3D1yQSkIYdJ+M7Vsk
         0YQHaFoFo5OdzZtoM0Nqj5r2bLPOI1Xjty3c1C7RICgj9w5P7ubTuKcjszURxdzrw6PV
         GaBCwXo2pd3uzUQ1chHIYvOr/iux1WrkGNWnPXwZE7/Qe/gcTwQT1Udp6vbeXrd7EX7x
         vrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cYxVbFXaNDaGnQdrvaSJJU1Sd1S+0Xp1QblAqN4nd2g=;
        b=NwSUhquuZog/nluMBfn0iw/i462dzc4jX22lmDQBc0HJNZwEzDbxgSiPIsHDqXkSBG
         skU7L39ET0P0wev7G5+ChAiSqpRP5YcZBvOSXy200Re0kXR7xjFI35Z35MTmvE/F3F9c
         hcfYaH40FHpr6z1yTUPJAfMXo/mdiHa6oMR9Ch5N1ATDCdLgY0B/JgEU82cRjoHdQfhO
         C2/xONM2vbJOYBmfcdRwQbHWMEulXk6FcdduJLxA76mMCLex+Lmcno+jZn13vTH396J/
         Y7IKW4nsMGaG9jJ3fCtO1TZzAmhV5aC4y+f87JohLMH4bnZ+qmwiQxAcnvUneuDopYNX
         zdAQ==
X-Gm-Message-State: AOAM531ihht0XWVcSJdDCgD2xd9cxJrOMDixcPV26uY+he0casQft7uz
        89SApg61SCczcTJOjUOtKlb3TeanZVWVjoNe
X-Google-Smtp-Source: ABdhPJy9A3EaauSFMZaUNIqCbQzdAxyLKu6UJVWmoTWuZNEOdJnhFgFaAXaA6894Qg0PdjN83UFJEA==
X-Received: by 2002:a17:90a:598d:: with SMTP id l13mr26569356pji.8.1636076568600;
        Thu, 04 Nov 2021 18:42:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm5843050pfi.122.2021.11.04.18.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:42:48 -0700 (PDT)
Message-ID: <61848c18.1c69fb81.89cf8.4850@mx.google.com>
Date:   Thu, 04 Nov 2021 18:42:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-16-g6cc1c45ae6fd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 152 runs,
 1 regressions (v5.14.16-16-g6cc1c45ae6fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 152 runs, 1 regressions (v5.14.16-16-g6cc1c4=
5ae6fd)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-16-g6cc1c45ae6fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-16-g6cc1c45ae6fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cc1c45ae6fdd6a6b068e47c1549a009bd0f2183 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618456966070ba96fc335906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-g6cc1c45ae6fd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-g6cc1c45ae6fd/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618456966070ba96fc335=
907
        failing since 11 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
