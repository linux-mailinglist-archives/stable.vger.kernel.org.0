Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B922423C1
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 03:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLBdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 21:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgHLBdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 21:33:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A977FC06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 18:33:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id kr4so326425pjb.2
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 18:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OZsE1sWUoYMWGzMPhiePTP3YwjmZH8UiI+0yejkaD/Y=;
        b=bI00qKV+tmXpb2+CyC23TZAZsH1uAsLbPRAAgaQYPMBrTuAKEfSoR+HWWpLu+TBwAZ
         GGAJ1rsx9NWN5QSRxLGUj0a+1oCZ+HChr5AeMISywIi3qu4BNRwPTDaHdLWpvEsehrS0
         knuL3lGqzPFyA80vQm71SYkR6gAtuo21dzMCcT6XIBIvcF5qTsxg7DrIDzK7GIB6CDsI
         fxTq8wVFsgq7T1OM5GdQFu1qyzEgKAP6ySQGPQ10bSWmSe8sPrPem/2esF/+XePgsnX9
         smztlhMXl4L8yvjj/eImpO0PXImKTUpt+yXuuYF3utWJD6L4Y9W/yrVLk1MAG5Os3lWt
         YnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OZsE1sWUoYMWGzMPhiePTP3YwjmZH8UiI+0yejkaD/Y=;
        b=ULMh4GQHYCmx5sqNsJVS8nbXE4smwq4opWCxF2mHAMaHPfJDmt5bkv29zCmfkdtjmY
         1zR0kDdo/C3DBikJ9TCwdCU5aII29h/isWsB+tZlIanA5L7RcWf7bZh3VIWDGDZoCV/M
         c8di3WFsJN8tyddwHwejtgj8BKxEBMkEy/MjOvnaRzJEjA/DJuzXmzUJQ02bcYiFL+do
         NWoKc+0mufp+xflOIYNHrIBkFGgW5YAeiU4hpsopQmGnb0QhmDiy1fnA+yDS9dluUBxq
         +p0wG2bIw8/ZQkmIovFbQ+zI//sf1GxYRaZLrM6r9UYRDeSWl2DORYTAkvPp0BkryH+5
         wozQ==
X-Gm-Message-State: AOAM533nYZ/NquqxQ0GHRGGOs/+4bk8dpGg4qXQrhggB9YQsLfdRQndp
        VkhMVbdk3JMEaT3Q2QpHQUg9uoaEdQA=
X-Google-Smtp-Source: ABdhPJxWOJeVVk11VkrQQbXLCrPIJbSHon0/MQzeEbGGJ9E47nsmD+gBylMc0EqwvkySG2+6vVjuYQ==
X-Received: by 2002:a17:902:bb82:: with SMTP id m2mr3279155pls.115.1597196023825;
        Tue, 11 Aug 2020 18:33:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm384868pgs.90.2020.08.11.18.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 18:33:43 -0700 (PDT)
Message-ID: <5f3346f7.1c69fb81.37f1b.17f5@mx.google.com>
Date:   Tue, 11 Aug 2020 18:33:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.15
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.7.y baseline: 188 runs, 1 regressions (v5.7.15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 188 runs, 1 regressions (v5.7.15)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e446529d34888ac57fe059ec32e9114a381c800 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f331373a01cd8f3f152c1cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.15/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f331373a01cd8f3f152c=
1cd
      failing since 26 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9) =20
