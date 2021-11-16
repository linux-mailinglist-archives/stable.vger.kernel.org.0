Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF3D452964
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 06:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243998AbhKPFMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 00:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243830AbhKPFL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 00:11:57 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D55C0B1929
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 18:11:15 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id o4so16610413pfp.13
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 18:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=72UVLJ7Ji93+Kp7Yi2UnuoE9YaKQWsfmj3F89YMNbNQ=;
        b=JRBVhCPcGFPWdfld59vS3gPF1X/lQ5PSTvkL4Dew/St0lcf8SWqsIVC8l5gE5fs73/
         2iip1cYCEPuB+HJ+Y3Y1GPb/D8d7Xmjscpk/qFUlx9eiOfrFrlsiXnSd80D0CM15zpAa
         8ilLq2JHA1YGsw4TIpYTmDahhKApfbhztTCz1st/ogL3/SOv25MLq01AKsJMIIthsZK5
         OcmsdYF5YIxTMdXfLbw/mhTM4apRdNjHAfT3AbBvaofNYGbK/qT9ZWz8MTjlT1CBySRN
         5T1XhfmqvDVgJkkEDk1yCW0qeWTGIuGzo7OvmHMV47bPtKgy7RT9OMbZ3rTROk8bMJp8
         zb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=72UVLJ7Ji93+Kp7Yi2UnuoE9YaKQWsfmj3F89YMNbNQ=;
        b=Acm16wxGsh76U0xFPUW1WKhpUrZk/N+pAeLMuVHsy06zR/Kh50H0I65Jnpnh7d4ejr
         RKJ5hNYruZlKKgr/g8fhGygU/lexY/ZtQP0prGNfwonKAcUzX05oiQ1EiC+9Z8ILYmzs
         Tyr4KTwhgyDJg4U/SOYBqC+6z22hT+h+Tg5lihNFeaYGQfFpGZrTYMi4Jd9J5qKF3une
         7gQmp3rwydIEruA50cG7CPLUkVhUqhHaPlRavRyZpidU7YuuoZhjQNmISwO4NC5vkHPb
         AYPoaeEQXgDzfQjy4PPd5WecVQJ73+9jEM1C0gGuaTTEptrLj/+8c9q0R8mFxf5mrSzZ
         bv2g==
X-Gm-Message-State: AOAM532zhN2u7XLKbaGyLHM8v63MmK1AC8Sf0SaKfwDH8fdEntEtJ0nt
        GqelLgDRk4VwrlN/ab4fPxHhZUZs3PiEyJy8
X-Google-Smtp-Source: ABdhPJy3QKihfc67DMDypAHDb6mmRo6zEP7SNLwcuPSU5gHhZF2X5kLH7KhoCvDuwAWZrSOniMLDrA==
X-Received: by 2002:a05:6a00:10c5:b0:49f:de2c:1b23 with SMTP id d5-20020a056a0010c500b0049fde2c1b23mr37084707pfu.41.1637028674350;
        Mon, 15 Nov 2021 18:11:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b28sm12441036pgn.67.2021.11.15.18.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 18:11:14 -0800 (PST)
Message-ID: <61931342.1c69fb81.6d84d.4e7e@mx.google.com>
Date:   Mon, 15 Nov 2021 18:11:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-114-g4dc964d8b18be
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 73 runs,
 1 regressions (v4.4.292-114-g4dc964d8b18be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 73 runs, 1 regressions (v4.4.292-114-g4dc96=
4d8b18be)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-114-g4dc964d8b18be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-114-g4dc964d8b18be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4dc964d8b18bee717a7d924511bd7b9526d3edd6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6192d964881e262eb7335907

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-114-g4dc964d8b18be/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-114-g4dc964d8b18be/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6192d964881e262=
eb733590a
        new failure (last pass: v4.4.292-36-g43195d0a7bf0)
        2 lines

    2021-11-15T22:03:57.408372  [   18.981536] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-15T22:03:57.457538  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-11-15T22:03:57.466409  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
