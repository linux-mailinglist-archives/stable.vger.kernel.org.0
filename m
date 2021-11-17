Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29AD454E1F
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 20:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhKQTrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 14:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhKQTrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 14:47:23 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE9BC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 11:44:24 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v23so3166158pjr.5
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 11:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HY2M2hPT1ZoSBBxkdP3j9VHufO1T1TPUJgp137au8as=;
        b=PhfS/N0CgdNRYR3ByfNEOrpRDU8FnfNxaXemtaXvptFI72bOUoYfmAPbG9KXb7SbsT
         Zod/byHVWjTE2tA5OoK2sAGYyY2e+1kOdZDLkWVcMXk2Vcn8rUjWiv3fxhnkJFhleLlD
         oJIxh9dHNYNKQXT6HCGGuhfUIcDELRycY5DzHVWfJu8PpUGCsgtHRYY8/khEPmvhcH/v
         X6pVmB/6CsY33AAUzxlKGKRlZzlVFmw1RjJSrFt8Hc/S8yVKbbHhC4t+sOSfz+9iEVkt
         bheZdyctjVDoRy6RMNEGggFCmxGx7eh6zvrqUbxtyoz9LAkw+RzNGTjZJO4PBeiyhY3t
         iuEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HY2M2hPT1ZoSBBxkdP3j9VHufO1T1TPUJgp137au8as=;
        b=JyFj87afBAdGJ2gg3vq5WW4+BftLIaycSr7nFJO3/3/kHpJWRw8itXEPJ2DXAzxqCz
         0N3n2je6qnpMvA6BYbD/EelgEWd0PpHBnTR+EAh1HIaueIyAcVpudQo22lh0QrLyDl8f
         jhcVJFs5nWh8/j6LFsteGbERrR930AfZbNYSsFGNwPOl2bUrtnU51UFgxE8mkPg57Y0D
         DVrQtYOVSDk9QxuPAtS/2BOlLigICiYBf5B3LNLAk3yz8161XNJTHKMDJtcDm2Mkxf8I
         KKQzSlxQoDZi3mCZF5iF4ZMB4PL5WSsmYpsd6t+qHuw5Ky/ecxyAjiO1OTluX2cGrMOw
         /Peg==
X-Gm-Message-State: AOAM531FbIez3jXjuAaZrKegEBAsGtpFhGwgPN/q8DYMLZb1E6GQTRoW
        zYFWcfGzxOnCx07TWSVJekYPIOcE1UbDBvSQ
X-Google-Smtp-Source: ABdhPJwG6p4lgad7bqeigPUx0Y7m95QBr+4NPVmT+1D4mYYj6Yx7+sJpOP0kZUPFDjIb9wzuuN7FEw==
X-Received: by 2002:a17:902:8544:b0:142:66e7:afbb with SMTP id d4-20020a170902854400b0014266e7afbbmr59378068plo.62.1637178263880;
        Wed, 17 Nov 2021 11:44:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s207sm396043pgs.78.2021.11.17.11.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 11:44:23 -0800 (PST)
Message-ID: <61955b97.1c69fb81.9fa5b.1d1d@mx.google.com>
Date:   Wed, 17 Nov 2021 11:44:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-250-gcb36871725fe
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 137 runs,
 1 regressions (v4.19.217-250-gcb36871725fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 137 runs, 1 regressions (v4.19.217-250-gcb36=
871725fe)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-250-gcb36871725fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-250-gcb36871725fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb36871725feaa959a56052629e1700354b17b93 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6195226125f84ed05a33591b

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-250-gcb36871725fe/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-250-gcb36871725fe/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6195226125f84ed=
05a33591e
        failing since 2 days (last pass: v4.19.217-72-gf6a03fda7e567, first=
 fail: v4.19.217-85-g1a2f6a289a70)
        2 lines

    2021-11-17T15:40:03.925106  <8>[   21.131622] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T15:40:03.973341  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-11-17T15:40:03.982368  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-17T15:40:03.997712  <8>[   21.205902] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
