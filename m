Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C1E2B3A9E
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 00:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgKOXox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 18:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgKOXox (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 18:44:53 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12D7C0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 15:44:51 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y22so7307218plr.6
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 15:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l/Z+h+6T5u1XEeY+UDL68vE3FYcATqr+Ngt2xjuWygY=;
        b=vZR4gAdesQimkcsl+p7zYmx9BynLx8JmRlSExI4WwNwDqOZt0rlf8kh6RxLC4+8IVh
         kP+L8/JhMK4nKf9VLEV8WQ30FIuOOwET0NZQ13HdsmBRaSHiiHU+Mmfp28+CILzA24X6
         O8KLs+83iKMaOK/96YzyAutO0peU42nnz5tb2pimRWYwnB4fF+eW8q1Yu7wTkD8G/QzB
         dFSFtEFszpOKnLxl65kP8eH3aMw2YaLVKSjrXyAb+5TbGteWNlTJjYcF7ZoaXzMauLhz
         IQXbyyI5HA7ag++gRpaXLYMO1ZpL5wp5KiTRE7TTg4kFW89kU7RJynbYZ0Jt271hWU8e
         FGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l/Z+h+6T5u1XEeY+UDL68vE3FYcATqr+Ngt2xjuWygY=;
        b=ny2U52pCqKPHUj++XhvskbxcK4MKjSt4nM4wtkhzK3qHEl3lfrqNFFwigDXWdLdwYE
         bIiR5XFV0pSjFOvXvKgdYrAiLrwcdsAFpyvFmCmTozi2huZoOpsZ2sLdD5MegGK9jvL5
         0EzPyMz1HibOfzy/x60hcbF4o2z3DV5i6f1H2R518fpPyNdQsaiLXgq+nJimdMMNQ/eC
         mMwBZuG4MkAiTHgkpY3NSFoSdBXbrYRX3LS/TsYvyJtZ/Isx2AiPOU0SZYxX07ckborD
         tBmUUjYcHQ+hIROhdqQmpjv0IJSCyZC6UhYUbaqZ65vQBu6fFaaSVCLA3saPMlOrEHX7
         OQKA==
X-Gm-Message-State: AOAM533bQMHEDFSpadruXzJ9thrCYoLsCx0e6+xY1HuIA0mP8fwz3Hkd
        JTzqM2MJsNF1Fscsk9tMAQoOJmoBgYZwKQ==
X-Google-Smtp-Source: ABdhPJxD+g5WYQHOJtaVxtc5HAJwcs/Py0wblW8cK311pQwF37CkbejG7ihdhiHE3bZArl2PFK/9Xg==
X-Received: by 2002:a17:902:d901:b029:d6:9796:514e with SMTP id c1-20020a170902d901b02900d69796514emr10456353plz.84.1605483890856;
        Sun, 15 Nov 2020 15:44:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n18sm15706725pff.129.2020.11.15.15.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 15:44:50 -0800 (PST)
Message-ID: <5fb1bd72.1c69fb81.6be02.316f@mx.google.com>
Date:   Sun, 15 Nov 2020 15:44:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.157-47-g478dfec05dc4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 7 runs,
 1 regressions (v4.19.157-47-g478dfec05dc4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 7 runs, 1 regressions (v4.19.157-47-g478dfec=
05dc4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.157-47-g478dfec05dc4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.157-47-g478dfec05dc4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      478dfec05dc404b4f804aeff40166af01b660b5d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fb17bb54a5e50e65579b897

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-47-g478dfec05dc4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.157=
-47-g478dfec05dc4/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb17bb54a5e50e=
65579b89e
        failing since 1 day (last pass: v4.19.157-26-gd59f3161b3a0, first f=
ail: v4.19.157-27-g5543cc2c41d55)
        2 lines =

 =20
