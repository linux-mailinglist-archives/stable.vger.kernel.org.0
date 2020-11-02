Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7619A2A2B76
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKBN0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgKBN0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 08:26:41 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21249C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 05:26:41 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 72so4413214pfv.7
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 05:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JhuyAeHV66W343i0xhl6CpTlwC4wUWXdeBWhW+GwgmU=;
        b=t/AboD5N+f0gRo8XrOhat7JMLeGJgD9c2zhKdPeWfXdTI6jDY0oRhCKeZPtR+BD2sG
         Y1Gd20v9lHbv0asw9lsuWuRctq8OaUpGc2P+NgyVC0Spqam5KyPH1w7AJNLfGM5mAw8o
         A1Efy1qmg90ZBWbqlpG+H/wpd5LDu4AOow98eJ4r4QrddH7DBUJXJF/UDxcPqgFL2ya5
         50mFYNFxI8WpPGuPsdPbj0fv6XcoYEZRmInLNlxxtWIiFaLw6RA+RH7oPiCClutZYG3S
         mSBEadgrfSKveedd/4/EeKywJUhE57ng0ZD7xp0pjLrDBu3PR1Wdk6V/P5j4c1T0AqVO
         /p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JhuyAeHV66W343i0xhl6CpTlwC4wUWXdeBWhW+GwgmU=;
        b=rNgtbef6s2LzmL3AhCuKpBxpgoAGlvOTPQYGSOE5PvmNu4EF9DKSOLLVTOA2kK5acm
         q1yTJmSsEQEV6+AktMr676OAmr0tyZ63usEUs1R8wjdBBM+mIidcCHvu6PDdQWn79qt+
         2kwYevJ+0RmVoROi3RzPUYdG2rfPp8XEgcWZ9+zk52c5zk+aKBOy1ljjjLJfvMSpr7ny
         fqDulIDVlpqVvF/ECVp0BdbLgPvjhQi6SzktCZA6RoqR0fNSt+Yq+FZv0LPlnz759SWm
         aOLRgWa/BhCgZZJyJAGgoLnLfgLaloa+urUQiEYcKO6VJbI2vk0MWP8HqC4dJ2EBmu0V
         jYuw==
X-Gm-Message-State: AOAM532WufspoHIwFLqkWwV9Lm1jd5qUNa/R+ADZhVqgd3ETZ0yZMXD0
        5sIiMQiMwKH5EbA1UB8XI6QZv8aR1lwSLA==
X-Google-Smtp-Source: ABdhPJwjyPOXdiVGXrbl6JfsfHySkA+4xVmLo9exHxq3crZWa5MI/1jMWA2Pa3oFXK4unz3OzXIYUQ==
X-Received: by 2002:aa7:8b17:0:b029:15b:c0ba:f2f4 with SMTP id f23-20020aa78b170000b029015bc0baf2f4mr21765215pfd.22.1604323600221;
        Mon, 02 Nov 2020 05:26:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm4448639pfd.49.2020.11.02.05.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 05:26:39 -0800 (PST)
Message-ID: <5fa0090f.1c69fb81.95def.e5fb@mx.google.com>
Date:   Mon, 02 Nov 2020 05:26:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-60-g079291b3e475
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 1 regressions (v4.14.203-60-g079291b3e475)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 1 regressions (v4.14.203-60-g07929=
1b3e475)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-60-g079291b3e475/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-60-g079291b3e475
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      079291b3e4751681435a4289bea6c091e881e95a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5f9fd653f0843bad5c3fe80e

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-60-g079291b3e475/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-60-g079291b3e475/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9fd654f0843ba=
d5c3fe815
        failing since 2 days (last pass: v4.14.203-3-gd24321bfc541, first f=
ail: v4.14.203-3-gad7f808825a3)
        2 lines =

 =20
