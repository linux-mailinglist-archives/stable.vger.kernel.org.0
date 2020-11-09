Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5716B2AC267
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 18:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgKIReE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 12:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729879AbgKIReE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 12:34:04 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A9AC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 09:34:04 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w6so3300472pfu.1
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 09:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MomoK3UbWLGVH0o3jRK/FJ0dxGxwgTjcaFcKcEax1ZU=;
        b=qTAvriPGYDnyb9yTB1HmGMhqFvnYYBEc7og20mbHyoD3ySVqLrsiYSAW0g3cCk7iUx
         GEivVjUKHnr6ya0NMyu0Nbqgu8ZaGpW+3r8JzF2hP34q4hx2+7ZXED8ubs44DQcSVKeX
         tMkUND4vLhNgnctbxvAX28EUumsihLhPklLftJAwwb2XMsWuqHMxiG1uMI5K6FqmBFbf
         lBAwSj5VKDM3XP24JZXRPV3G0YkrSv9D3rFJJe+CESDwXG5lIRWin6zvdIJNcnLDNXoP
         wQU3AuBYcb8MhyhrBxprvjEC54pf2Mw08969vX+V3QFLBQIcjN/BrdjcgCwJx6vUzeFm
         mrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MomoK3UbWLGVH0o3jRK/FJ0dxGxwgTjcaFcKcEax1ZU=;
        b=Jm+WZCRGE+39ciHBPvazpgBKdj8fkOBb0WIvU0SNGKjqTR3NkHfUEMLbR/e4GByTIl
         seqctxfh4YjpygAsQgwQpORJABC+6q2ycNvx6qmI5d1nzTzZiQweCYPNUYigzNiV1tzn
         u0m8O89NWfD7o0S/J3eTM5FCcUILC/MBVRL8lZYLOCD5N8GO+yWAwk/9NSCffVsvWFTj
         otws7W7fpQwv9mH+OKypfH8KHhgczV9aMpx37rFPC5PYQNU/lGxEIUV7S8OMiEnE6oXP
         S+H95QzE/0wOufBCHlDD0QwKNo3x8ZW+2n5IQ4xwgPPpHZlP+H/j0zXzYRN1OsRJh6ac
         7OFA==
X-Gm-Message-State: AOAM531DRuIoSgSIuivPmWPHVV9VOnKzZ0xrB99rrUs6658b0McVZjnC
        R7Yrcy1VQ1hDbmFuzebaVIzCrCxsbOOGaw==
X-Google-Smtp-Source: ABdhPJx16kME5hawVXHAVN0E28GfJ7X2/e7DZR3NvmRg51xjeA4TzZvb3GibDYed36B1S4bW5feDlA==
X-Received: by 2002:a62:8709:0:b029:18b:23db:7712 with SMTP id i9-20020a6287090000b029018b23db7712mr14666452pfe.66.1604943243474;
        Mon, 09 Nov 2020 09:34:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21sm10684870pgk.52.2020.11.09.09.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 09:34:02 -0800 (PST)
Message-ID: <5fa97d8a.1c69fb81.c2df3.6969@mx.google.com>
Date:   Mon, 09 Nov 2020 09:34:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.204-48-g3793076c5323
Subject: stable-rc/queue/4.14 baseline: 168 runs,
 1 regressions (v4.14.204-48-g3793076c5323)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 168 runs, 1 regressions (v4.14.204-48-g37930=
76c5323)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.204-48-g3793076c5323/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.204-48-g3793076c5323
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3793076c5323cb144fbb4984f9b327113a2a0f22 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa9491b4863c4811cdb8854

  Results:     2 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-48-g3793076c5323/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-48-g3793076c5323/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa9491b4863c48=
11cdb8858
        new failure (last pass: v4.14.204-48-g22f907ea2f6d4)
        2 lines

    2020-11-09 13:50:16.121000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
