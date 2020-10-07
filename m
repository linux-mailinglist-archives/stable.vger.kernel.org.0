Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB6286792
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgJGSll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 14:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgJGSlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 14:41:39 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89612C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 11:41:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d6so1432656plo.13
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dNkJXrM4P7IG+ISeW2+3A6GoFmUGgSyz00FyM9TZ1ew=;
        b=1QvjOtajUCPoAQrF6o7u7ovXOtrJxMOUxel/A4iiSGq3U6PkQxLngwsvwBVGdf1VBQ
         Ujrz2sja0tJvQef4+rGxoh4eG7ONnIWcQBK7K1IOdrRx6e3A3ms4B3G0v7IBZbbqLyih
         1Bx7ODzZeEUHlLlzQaa3MG4GKRSfzz2QHl4ZsW1y/fwybTU+o2EzPcgK2n//G3kvnZhg
         vbai5rtwltQdnAmBsdGrBUPeE6fw9gc4Th3C4EDU5zGAtagh+apHbbIBmvc4CcZM6cew
         y2KWPgN0wkzVsjLz0MECukwTb2NJLUb+olv10DDf8K8L0nTZtL9nnPsEFQJ0BvToVay4
         aOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dNkJXrM4P7IG+ISeW2+3A6GoFmUGgSyz00FyM9TZ1ew=;
        b=RCOKW+pKkL0AJtqTlUrSz+ts8Tu5OkTgkzm5WOQscGtm0boTJ19jW8z9AZhjo0RznD
         AxuTzWOxAapl1sew9ZM0IQpem1DaPaQgsXtns4e0ZMpGV+VIPR3Z5WaGGrwWkIklUvNZ
         NmvKiW7RrqL3bFyInkTNO8tQdLFB+BINXwrOPSn0TqdQDEyWHYd3cNHeGH5PoZdalvCt
         o7hIioexbHlJvSmD4WD6Y585WzRr1Zx5vrIwIJIRNMC9vtKCtfIWeOlxNSH+i8Ybcc6J
         ccsLRlDE9FxL/jg3+H+MdLsZBu9mSNV5S9c9ADGTTPhNoNdsTnUbWTUj+AJZrjm2J05S
         G6zQ==
X-Gm-Message-State: AOAM531UyYh3ATbvhWw93UoCV7gd0t4WwntlyzeMNHnYhQdJ4ZfVwjOB
        WPwz56G4hD4pG6qE61xE0qGlSQ+/jXrwTA==
X-Google-Smtp-Source: ABdhPJwU0uaqTaNTomL0pNQbsfPlyB13+JnPFv5dSBWek8o/73PsfVFjd5GoYAsw1Yv0YRSvpQikkQ==
X-Received: by 2002:a17:902:a40e:b029:d3:c6fa:2650 with SMTP id p14-20020a170902a40eb02900d3c6fa2650mr4052160plq.29.1602096098710;
        Wed, 07 Oct 2020 11:41:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b185sm4273021pgc.68.2020.10.07.11.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 11:41:37 -0700 (PDT)
Message-ID: <5f7e0be1.1c69fb81.b6495.7701@mx.google.com>
Date:   Wed, 07 Oct 2020 11:41:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.238-26-g1959353b3c5c
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 96 runs,
 1 regressions (v4.9.238-26-g1959353b3c5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 96 runs, 1 regressions (v4.9.238-26-g1959353b=
3c5c)

Regressions Summary
-------------------

platform       | arch | lab           | compiler | defconfig      | results
---------------+------+---------------+----------+----------------+--------
qemu_i386-uefi | i386 | lab-collabora | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.238-26-g1959353b3c5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.238-26-g1959353b3c5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1959353b3c5c434342156f836e0a889c5e22fd39 =



Test Regressions
---------------- =



platform       | arch | lab           | compiler | defconfig      | results
---------------+------+---------------+----------+----------------+--------
qemu_i386-uefi | i386 | lab-collabora | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7dd56b8b761ca0474ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-2=
6-g1959353b3c5c/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.238-2=
6-g1959353b3c5c/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7dd56b8b761ca0474ff=
3e1
      new failure (last pass: v4.9.238-23-g7c3201da309e)  =20
