Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12E2486872
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiAFR2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiAFR2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 12:28:20 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBE7C061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 09:28:20 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id x194so3185321pgx.4
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 09:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4GU92gqR5vMfA2sHUJ0dCK1BNDuPY37C/wT3+NOgr9M=;
        b=53o4Kse5M3CK3zxdXYWHn1uNO0lLv/Q+gLti2HIiMll9Yjh05e+38FkErf8leLe1Uy
         4XNq5wC+wJy8DgiapUnxW2n/49Uft2PZXK6uAV11a+3d6voN4RmzIWqf5qky/97vXDDE
         XpmE4wJLQynd4jIniYfcwgIYXBEBA8UDKtMkrEE3nDwY6vi2Mwpx/YEHbeO+Tswo9XHs
         mWlPvkeZIYhlbt6yo7Po6mw+SY+6Pzpq4lQBJwRhJMV2Iq7W6gysxDm60KaxnPFZAGM6
         UoFjMK4K34BbNmEQWu0miJERTS6+QKALww0LNAh7tRBsIAKQjBVClMU3Xt3Ge7KDjpoE
         ykBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4GU92gqR5vMfA2sHUJ0dCK1BNDuPY37C/wT3+NOgr9M=;
        b=aEB3smfIMGhGrINRrsXvw8SJlkwOHr/IMhgpWK3CwWQhWK1Jqql7eKybArs/XmLx7o
         5tFIFLP3LFdsvj3f6Jck5xc1rZtUWh0AV4/Y5k1aQ7rsSdHuv6Mny3daYVdJSnF2GdcA
         MLKZbNMyZ+EIkTetn/V0xDrg6ZZxFarU9zSyOMYutlY6ZlkH7U4QPf0/5CYVw21dV0hr
         nniwGUrWVyrEeDQjfKscb568qOI3b23XHZ0bZ8W2I8y9VNym53e/QPwkVQD/Ud4rHVff
         kC3CEkfg+YOXAq8aOvX++YQQvxoj0lAZ4Msayud4Gf6Xora0YdaxsDLDssxBQK5UoYrD
         MlzA==
X-Gm-Message-State: AOAM531a3VyIP6bUxM+pHLkO94WhrCPN0P3clWmYkCWNY7h0GfPENz4j
        KSt14xMa2x2/B2u3GcIjdJBngWNK/bn90wmy
X-Google-Smtp-Source: ABdhPJyOfoZmzzlb8qZHR3ewA25XSwl2VLT309OBteQaI8JQ63ItV02YSeTZRg3JvU22GVyFNwEBqQ==
X-Received: by 2002:a05:6a00:24cc:b0:4bb:ffe2:17c2 with SMTP id d12-20020a056a0024cc00b004bbffe217c2mr46079516pfv.31.1641490099678;
        Thu, 06 Jan 2022 09:28:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h191sm2591911pge.55.2022.01.06.09.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 09:28:19 -0800 (PST)
Message-ID: <61d726b3.1c69fb81.a4ec8.65e8@mx.google.com>
Date:   Thu, 06 Jan 2022 09:28:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 139 runs, 1 regressions (v4.19.224)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 1 regressions (v4.19.224)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a94dc7407bf3aab53c9fd65d24065a43353a0dbe =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d6f2e593e087511cef6779

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d6f2e593e0875=
11cef677c
        failing since 2 days (last pass: v4.19.223-16-ge86e6ad8a5c1, first =
fail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-06T13:47:04.587464  <8>[   21.077972] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-06T13:47:04.631621  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2022-01-06T13:47:04.641083  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
