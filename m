Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C287357CC4
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 08:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhDHGvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 02:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHGvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 02:51:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB79C061760
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 23:51:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t22so188135ply.1
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 23:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SpWbKYx1APa5z0dox+PfFSlqqDK2U9RsOhg9cMl8YQE=;
        b=MB9dv3HGyfFwTxlnZL1afr/VAj9W5TOA3aaSkBkOKt8l0Df3aywAHd6VDkGrBi0Ppg
         ELn5ICcYV/VYIZj65kydmXIb97GyA4Uqmxxnqmk25mySex6UESKbqWr7gTH/9JTRXTif
         /sHdtyfSHU1ZJxU6T0v9t/cOcI++dW0ELlyFuELo0jjqU6j5aD06aj6jRVnJDpVtOdLO
         SZwlv0V77ESwDfBa6CwNjq/u2Q4BPtRrHG7qp+plmfuf98Fn9B3aR9Ib5mofZ02ZJAQD
         nqUzKaYPnKd3ZGAyWXg9pZtBjgflDGZauONe4fLqK0dYTltJFHB4aMYueoQm4kZiHr+d
         t8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SpWbKYx1APa5z0dox+PfFSlqqDK2U9RsOhg9cMl8YQE=;
        b=TiHB7nuGogso/JD90F4gXXJjssMvLDlvmEIPgU12vPXRXc3+CM3lA2mDdOLdgMpaMV
         60XUxSwru3gxMcgUjDp/XEQzHzyx6hhJWkBsctu0cpQ3sAwcc3so1gg8rZIRLdzZjfcj
         QsE8RaCMewxLYFkS7dzcUW4dwvmUehh/V+Ayoo6fM9PcrqR5laUXuHV4gVLMZ7QzCmbl
         jLYHIw8iD4d2TNdwJYcCtlwYT7hQHDmNPCvNm6v5WQ6jpuYqTFN85KD30KnbN0QmxsUE
         6c9PRRqESzUJW5eXt2AyYGtvDZY19cLehH/uKjc3BK/KpkJAsRkdpsSFj+jv3kLw52ps
         0vKA==
X-Gm-Message-State: AOAM532koJLmqicliPIzvzCrK2aUPgW+zjQ78qUMUvhau2zaQstp3x8l
        p6DhnmSUmwBqqtNSit5DjXpwzkhGCR6gXlbg
X-Google-Smtp-Source: ABdhPJxxbnV8jEq8+FEzsgQ6DOL8kvxBY6CbL53RKqHDSJQYAT+cpwmCk3CjkTF9jfBYX8KsXqBm5A==
X-Received: by 2002:a17:902:6949:b029:e8:c22d:17ae with SMTP id k9-20020a1709026949b02900e8c22d17aemr6150369plt.57.1617864687220;
        Wed, 07 Apr 2021 23:51:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c129sm24133899pfb.141.2021.04.07.23.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 23:51:26 -0700 (PDT)
Message-ID: <606ea7ee.1c69fb81.335ea.d969@mx.google.com>
Date:   Wed, 07 Apr 2021 23:51:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.185
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 57 runs, 1 regressions (v4.19.185)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 57 runs, 1 regressions (v4.19.185)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.185/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.185
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4454811f122c6a0a330ced6b854e6ef32c37857 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/606e70f14528585d57dac6cc

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
85/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
85/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606e70f14528585=
d57dac6d1
        failing since 2 days (last pass: v4.19.184-40-gea7c9d15cb8d4, first=
 fail: v4.19.184-57-ge80ef2122d5c0)
        2 lines

    2021-04-08 02:56:44.850000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/102
    2021-04-08 02:56:44.859000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-08 02:56:44.875000+00:00  <6>[   22.843841] smsc95xx 3-1.1:1.0 =
eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethern=
et, aa:e6:d6:66:30:0e
    2021-04-08 02:56:44.882000+00:00  <6>[   22.856292] usbcore: registered=
 new interface driver smsc95xx   =

 =20
