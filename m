Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692184861CC
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 10:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbiAFJEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 04:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiAFJEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 04:04:55 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2124C061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 01:04:54 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id s15so2002519pfk.6
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 01:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3sYPLFtEpc6hcALT2EordpsryNzr2K2mQRpIx7FPvy0=;
        b=OKC0YLIixuG7qXaR4dTQ+VSkQq3ohWXdErlPgfZQRNCIj6HAfHdBAfxWNLPSyQhUJj
         n/dw/UU6sS48nJyYrjkiwhdmGdpsuMl2yTb9F7hN4I7ZbShwU6rj8fwMH5Wt5VD0PQti
         BlAmQZAg/0VBeajIF6/UXxHdXXQz9CPPe349Q+9vJYte835MQA0e0lbrwORwLtD31vdm
         1aMIgunZKvaJChI+Wlfm6jQv+218j+NlBcfBhKgFMxqTcAZ/cJ6HZ2R+vp4rTDbYdSB9
         OVE1hUaK2gBaMa81tA8b0K/SEmqCKvIAi+9t4r2gjCW1SK4q31XuOF5Nu34FEhi7Tw4w
         hQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3sYPLFtEpc6hcALT2EordpsryNzr2K2mQRpIx7FPvy0=;
        b=e1KDydTb3BcbFqp6oudVRmy/wYI6koWUUPEIK/pBJ++I1i7I1e1J1uQEV76ibrX83z
         fReNzRP3+27ZesTyV/frhTsiA5or8laczc7fYbUOFsiBDMyY/lRnIqaAbbb1nQKZHPMz
         ARMtqRPZVV5dalfPUGDpYJRKEsQGFBpFXXxdsJl8rnPXzZKPTU542d83PLfk07tgfZyz
         ZLOJD7mcEVXwVHC4KgQrbUYIMxILFRgPfpFML2BqTPWWkHC3o8KVjXwTHJAqcDgtq2pR
         Xx4iegBGzxbqIgI2MU7eYGxyW81Adw+dtw45LIYUWNQoJDtTw2NbKBbp+U7/oqPSNGzC
         5FeA==
X-Gm-Message-State: AOAM531NmRdnMVS9A4wT9o8aM3Q29u8FneZFPnPyWaPigPP9DbAb/8Ei
        LgBo0yAhqIYEOKh7Ye7j75fVAY6FtiNnWQ//
X-Google-Smtp-Source: ABdhPJwZsk2p9e64ag3Fc0QYJV8ZSH0gtznc5OOvyuDQTypOrdBPhvAoSYuMKewee8ArjyGTRaRSsA==
X-Received: by 2002:aa7:92d1:0:b0:4bb:9d7:6951 with SMTP id k17-20020aa792d1000000b004bb09d76951mr59142319pfa.40.1641459894375;
        Thu, 06 Jan 2022 01:04:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c17sm1784692pfc.163.2022.01.06.01.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 01:04:54 -0800 (PST)
Message-ID: <61d6b0b6.1c69fb81.e136.4a0e@mx.google.com>
Date:   Thu, 06 Jan 2022 01:04:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 124 runs, 1 regressions (v4.14.261)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 124 runs, 1 regressions (v4.14.261)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.261/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.261
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bfdef05c8da46b022172695aa493cff7ac667a4b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d67f66a58c3e6818ef6760

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
61/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
61/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d67f66a58c3e6=
818ef6763
        failing since 14 days (last pass: v4.14.258-46-g5b3e273408e5, first=
 fail: v4.14.259)
        2 lines

    2022-01-06T05:34:12.231614  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2022-01-06T05:34:12.240996  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
