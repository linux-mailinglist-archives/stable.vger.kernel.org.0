Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA74461111
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244303AbhK2Jaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 04:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhK2J2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 04:28:52 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F7C061746
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 01:13:23 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so15048876pju.3
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 01:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oblaIl+6e0S8cOJsZV3hUPlmQH9MDbfZlFzRTOrdAPY=;
        b=5aLovDFeZO2xzE4lFoDFaTfBe3Zq+GUgU2yH+R+x0XMhlbSTX52PABQcAAwucbmJNY
         jJ55WoCqwQzdRDCe7AF0/0b7H+dOr9p8GDEGOLMVKaicqfD99F7B5QeqNuhrUxz8ihYd
         zuk7CNW9mNow3R6whifmrr3Nt5Ur1vBQA+EO1RHSfN1F91DpWBAYr7sbrJIb9Uq1gNrQ
         EmX0sJNj8DG2a60kxmYGm7nxeWmAIiEJ+5cW1prhmwJKbk7YVV6AO23EAONROwyJSSRK
         UEFy7UfM05IlrOiWbOuyS98C8lMGs9ZptGS6ZXiPHsXWHeNgRNbzmzwqCkS9kAyUaFVp
         tTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oblaIl+6e0S8cOJsZV3hUPlmQH9MDbfZlFzRTOrdAPY=;
        b=TUSZAuShPuzgFP48453oH+mk9jDHce0/RCBlxJtIyelwrUgt1xqRKokBHFZlvyPNF5
         8n+IoC154jXla8Q03XgynYZzVWkX4zVVwB/Nmd6TX+kNfp3PTqqZsvkufTnCrcwWJfq2
         Dg8iBrYwXoIWhXYMC3c2mQuDUu9XPYJacseKmuYFXaW5jM8etrYIKOANqTNepduOeJhK
         sSIkTTazyn9to+nt/pO+l+ox+fb4rS7jd8r7mDln8T3L5+8IEXm8cLbyjqJ2MtGlTCnI
         xCvOEv11UFW+21Gfx0sMpQgmTt9bPJcP/QUiBQncLI2WB5o5VDl7DZW0iIsuCtvk3xTU
         rvcQ==
X-Gm-Message-State: AOAM531ctv6UwTykSlcDo4oLh8bKt4bDFUchv/VL7IVSmtuv5BH2Nj2p
        kAqrh2CXc/2oCIpCYGOxadJsJisz/SbUqCRj
X-Google-Smtp-Source: ABdhPJxXMJCTeWHSVnkl+Niu8L4mEuxhD0bnycTCHkzN/8NTPqOGzzYsS/l8XNpw6CNbIxFpTtYF/Q==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr37190901pjt.138.1638177203069;
        Mon, 29 Nov 2021 01:13:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm15794132pfl.214.2021.11.29.01.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 01:13:22 -0800 (PST)
Message-ID: <61a499b2.1c69fb81.438c6.afd6@mx.google.com>
Date:   Mon, 29 Nov 2021 01:13:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-28-gb75fc63979563
Subject: stable-rc/queue/4.14 baseline: 128 runs,
 1 regressions (v4.14.256-28-gb75fc63979563)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 128 runs, 1 regressions (v4.14.256-28-gb75fc=
63979563)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-28-gb75fc63979563/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-28-gb75fc63979563
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b75fc639795638a0f4a7c9f48011c6e16a75eba1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a460d50c363a20b718f6e1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-28-gb75fc63979563/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-28-gb75fc63979563/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a460d50c363a2=
0b718f6e7
        new failure (last pass: v4.14.256-28-g54e5647834e42)
        2 lines

    2021-11-29T05:10:21.046144  [   19.912445] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T05:10:21.097608  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-29T05:10:21.105238  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
