Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A84481604
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 19:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhL2SQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 13:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhL2SQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 13:16:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1D0C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 10:16:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so25405318pjo.5
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 10:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2TlYlcohgzp++sSt5aQoFwmyNG1MYVpXJk/n48lfSmE=;
        b=GuOeJbOoT4i6T7vg/QwqBP6jUplgwtIPiG/kjfdgTo5KhBNecpj+vpA1TOLAOBGz8A
         wEtglNzoLrm8DDR4cmaQbxe6NCqM1t6M+v+MI35rurB1Ubf7JldnYgGK0zbNOB8K2cIs
         9378NPxZoa1kgqzqrNuIRYemYbe6eXZ4c3ui1Sr2Ltz8fj7LVwjOSXGdy5ILqcBI3dO0
         iTGLQR8Pb/FKwYJ4APhYFYKWGsVS5xhthJE4PwbUcqypymz3xHtATGQWSplgSJ1+CLGL
         sa+ezULQT0aDyCjn+9I7jBO8qUHo1q4Sj44JZKyDoOxNpRh2gFe7d4sATj/xbdShmMlM
         ealA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2TlYlcohgzp++sSt5aQoFwmyNG1MYVpXJk/n48lfSmE=;
        b=vCbEI8VxJE6TUkWd/mcJlFHVyD5mUkJbvOkXxmk9UumLvbMEyKx766+3iQppyZ0trG
         Lg5jhF4WP2F6bAtbdtII/3xM6I4gr4mSP6fyXHcYqzSNMRELbXXKJc3VlNELQiUXjNgN
         SXftYYo5LkfFkjNUdGyU4Z8POVIxzSiNOns5a5+3RhfuiWJppku/FodI6Kf/XGGRMNHc
         nutFPvY0yy028i4wcjKQZCphQlVkbRgs3KUwhO4SN3Q4UTO6S8TQHWwl58VvwPMVZRRD
         jEOwUCIs5k0V8sCgIBV0soYAVFv/wjpvJKPm6O6PzOv7PVZth6tghpnh/KtkVyIiqbEO
         jZ8g==
X-Gm-Message-State: AOAM532bC7QrOmJNcwltb2lwLf/sW8zPtOSFR9sUVKr0SNJnj/0ptEvZ
        nkejyImrMIzZ/2ICeawfOaheAODlVOGZAtn8
X-Google-Smtp-Source: ABdhPJxaMDCmd/o6SBMb2LJDHYpJnj9fgKES30jYwWn7W3jxdQ3pTIjZEy5C/aWAKC4vuj283ghr1g==
X-Received: by 2002:a17:90b:2381:: with SMTP id mr1mr33952773pjb.12.1640801809938;
        Wed, 29 Dec 2021 10:16:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11sm20621851pgn.26.2021.12.29.10.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 10:16:49 -0800 (PST)
Message-ID: <61cca611.1c69fb81.214ba.a7f6@mx.google.com>
Date:   Wed, 29 Dec 2021 10:16:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.294-20-g049a022cbff0
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 137 runs,
 1 regressions (v4.9.294-20-g049a022cbff0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 137 runs, 1 regressions (v4.9.294-20-g049a022=
cbff0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.294-20-g049a022cbff0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.294-20-g049a022cbff0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      049a022cbff03c828dc15105e2f5945628bc2011 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cc7020cbbd3c3c33ef675b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-2=
0-g049a022cbff0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-2=
0-g049a022cbff0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cc7020cbbd3c3=
c33ef675e
        failing since 1 day (last pass: v4.9.294-8-gdf4b9763cd1e, first fai=
l: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2021-12-29T14:26:20.371502  [   20.375152] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-29T14:26:20.404978  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2021-12-29T14:26:20.414407  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-29T14:26:20.433629  [   20.456115] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
