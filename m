Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57A297E3E
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 21:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764222AbgJXTuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 15:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764221AbgJXTuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 15:50:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F6EC0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 12:50:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e15so3800292pfh.6
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 12:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CDv1d2PQTy+ri92T/4QNYCuiubygSXFaFO2Nd/eeOnY=;
        b=q1Jzub8HBBlUoVey3fwbSaJtMZMTlm3eaEES623+W3RjTcNh2dJ716ZQtdsC6RZEEV
         aGVXM2vE4zkgq81FYfke8c0qT/agmWNzZBTvZlzIE1dfdsWqjH5NTiAnUfvYAWBwl9W7
         byx4EavhtwDdg3zH3/znzIPrkRuBlI94P7wR9nslrqrob5AgB4pgqDLRQk/DzEGVpQl0
         SlH4E6fdZ/PBZUtJ3g5qusfYgmQ+bHB933QwvrYC4h338c7MxuzT2gHg481JR9e/amZf
         nyXVpkctvESwv1O65Pn4cKj7mR/K5VyMS2YSgcLS+v2sSv5yOMGAjK3Fo7C+Ofnf/MIx
         +IMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CDv1d2PQTy+ri92T/4QNYCuiubygSXFaFO2Nd/eeOnY=;
        b=iSrGgPCsJNUbabuTf3WUEbDdk2gzBClNNiv8r7q0VOw423fkOPPTXhM+1VglTkLV9n
         BaBV/REXsfYn9OuxaQGcvcGoNJfxjNVj45mowEbBDJJFKdCgN6Pbe+gDABX1l7Qvr+67
         906AaFGszzZ8TdXwD6E/FCeFMZgdC0b0Xt4GS0QBuygF+iwipG5n4RkloBWZPG1MfFxn
         Xn+bT9UeZubTsKwxZKxA9qYZXMpBaDEpMXzh4klpAM6pq0rteKpWgbDkJTrB5HaxDBRL
         pkabjFDUV5N6YGNzW+m6SVdUsRl2Ltu44IAn0LE9S+/U5FafGYFJz2ixLOSkCuwQzgbK
         JvRA==
X-Gm-Message-State: AOAM530R0Nh31tLpAFcgcwN6ZC/DkGp0lEvGz+ob/F9NGP3w+eJBBs+D
        Z2UF6W2s2RWEfcM4PxLvc982LtFft0cnNQ==
X-Google-Smtp-Source: ABdhPJz/xiqGME+ziSSYCHODb7JCmHaB9GT/WVcx/YpO3W7CFQsZvBNteuK7jV3lsiBglo3VH1Lb/g==
X-Received: by 2002:a63:8c42:: with SMTP id q2mr8240082pgn.130.1603569004484;
        Sat, 24 Oct 2020 12:50:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm6662045pfl.50.2020.10.24.12.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 12:50:03 -0700 (PDT)
Message-ID: <5f94856b.1c69fb81.fa5d4.c197@mx.google.com>
Date:   Sat, 24 Oct 2020 12:50:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-19-ge3d3be91473e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 109 runs,
 1 regressions (v4.4.240-19-ge3d3be91473e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 109 runs, 1 regressions (v4.4.240-19-ge3d3b=
e91473e)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.240-19-ge3d3be91473e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.240-19-ge3d3be91473e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3d3be91473eabe8fc1043167ea9de76c49fd7f2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f944e257957005a0e38101a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.240=
-19-ge3d3be91473e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.240=
-19-ge3d3be91473e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f944e257957005=
a0e381021
        new failure (last pass: v4.4.240-19-g12e5c7a3b65d)
        2 lines =

 =20
