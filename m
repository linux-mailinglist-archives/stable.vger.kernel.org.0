Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641E0453A6F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 20:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbhKPTwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 14:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhKPTwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 14:52:53 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B9EC0613B9
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:49:55 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r5so106920pgi.6
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 11:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1d6/4k5Xcz2WFm9nCRFeDJrzrjmhoF9/g0I0hUKV8pA=;
        b=sTwLG0pWMuBOOVjl+wSvqj3tml5Dl7m3E6DH/8o+1Nwtrvyh9qzmg9a9tv0ZjU5c4Z
         z5GqT9K5+N00bFphQqf4G8myI1O3gUtlzP/49rvG0pS7foXqCgJmgxDGHQRq4EJiKrpx
         +rCBe+mS26F8JGd/f7I08SDbQSEuVZTa/g/eVDQe6gbPiI/VFN4I3j104CteK8RqxzOO
         Hz8+Wy9zypCa2YeC2voYTCAoWOchLHzj2iJJcjBY/OQGQokNKvzB0IIMQNtc/GKDuMZi
         FaihGiRosbHe/uq9KyOq8pDaCGxXsk6gYUMvm0/oCG6AGtqXlHFX2f99xUA0c+krcDNc
         CcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1d6/4k5Xcz2WFm9nCRFeDJrzrjmhoF9/g0I0hUKV8pA=;
        b=pZ2tXMPBLkt+cmgD7Zl7BrhH4eFaPPs0Uy7wIhoYm48XFkX7VQ3Eu/Hi0DbhZFDw9g
         OZ5h/S0KRcuGmtCuapxuKfbpHwFpTSCUwpeXRrJoyxlrWPskbzEBt2j1gY5dFJUGv7jI
         6HGpfnorjinhrXWsv11pJtu/te74fFKCmpaHb95O02/sdxT6aJChkwSQAZ73j8XNw3oG
         r/uI3P4syrBRxhyXX2iNaQFSgSNPrImxGXuFATqGmLTweJCmzOLkgHKkgTgRDAewP0fm
         00AysFVjaYv7QKDkhPXzcKMbwqE5x82mLiSytaDQjTNBRdfFrApjZANevkFa6u8RX1n+
         5pHw==
X-Gm-Message-State: AOAM5301FcdX2qJy3euCEatb/fMqrem3WYp2NL/1siEjhdOIcJNv14GH
        UF5Ipd0FuPQ2sm9ab4xEUkSfRMn5cAn9Ikzb
X-Google-Smtp-Source: ABdhPJz6x+D/nb09U/nIb3XJRfW+2d4kQ57elzFJX8IIZAOO/jIHu8RW3vfIOb4Jb+Tmkg8hX0Y8gA==
X-Received: by 2002:a63:804a:: with SMTP id j71mr1094906pgd.472.1637092194895;
        Tue, 16 Nov 2021 11:49:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm16689269pfk.27.2021.11.16.11.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 11:49:54 -0800 (PST)
Message-ID: <61940b62.1c69fb81.48c9.f00c@mx.google.com>
Date:   Tue, 16 Nov 2021 11:49:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-857-gc5cf53eecb90b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 132 runs,
 1 regressions (v5.14.18-857-gc5cf53eecb90b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 132 runs, 1 regressions (v5.14.18-857-gc5cf5=
3eecb90b)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-857-gc5cf53eecb90b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-857-gc5cf53eecb90b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5cf53eecb90be18439ead17423d407e3eb31bd1 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6193d36a23d4971c833358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
857-gc5cf53eecb90b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
857-gc5cf53eecb90b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193d36a23d4971c83335=
8fe
        failing since 23 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
