Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8B429CF4
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 07:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhJLFNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 01:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhJLFNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 01:13:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9815C061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 22:11:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso1000575pjb.4
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 22:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aslTW2ZFgV2KkSK2d7dE9iNlKCeq/WzTPj2gmPBEPgI=;
        b=GpJ/dvnKbatzHDc1lhluE6VuGAO1AxGNeCkyNAiPlCsCAxDqwgPGxuVHl/UR9r9Xnq
         l9++89plXxjeTVlVhWMD+eoIuu5MvXl3Rs0zkcd3RP8BuSICbOt/asodbs5ZVuKwZ60p
         UzsgAOVpbSqPaEAfK5qaa6FeJq4Uv6LdgqjY2KN7UZ7OTGKA6b2ZY9Uik2ztEf9TEQ+A
         PVyFSUz3kRJgwUu0XFXDkWFj0A453lW/0thqzg1jQs2xLW6mmpZia/zGCEVwqxleShDE
         fhLXxMpE76dQB58SE95P70oWqWobT6284m7vISZ/jfKSZ13+lTQ4g/G8ILipXpo9vtiV
         RV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aslTW2ZFgV2KkSK2d7dE9iNlKCeq/WzTPj2gmPBEPgI=;
        b=3O50TJYOLD6KS9MgwOkRTwMAEgSNWCQdxGJv2oJI7fq6SZeiXKQYRCOwO2aVo2Cwop
         rwoGKi00mQYi+wgfevEeNkbfit3byo2Zebj7K5IsDpThsZUjlgCTRKWYCh2Z/ROqC8OK
         5f8Hqrl+D0IabekYRM2N0l1TtxdgAJeqOCpI2vcGZIRa1mnWZhpAuJH3ARKrxw3TrqtH
         MbkIlDqxL1XvAwbeGUPuncAErXYmwjT6EsEmNRe27znmCP4j4KhWlEMHdGbv0KB38XBh
         sikf1DQ5mFPp+16HOu3pxMifKryk6b2DaSt8cfMrjB0a9ymlKT/iWqNHiYXdcOMu7zHw
         a3aA==
X-Gm-Message-State: AOAM530KRgBvZq7l8E+bjctxUYMB/lITdOUT+5jvSbX4hcpzFBFAiD3U
        5D8Ivegz8V0AcBtJwOnEbeAhX/4tbshzBxG9
X-Google-Smtp-Source: ABdhPJwbu5/A06IuCmgA5nEYPrUpsuhWbsbYnAa7napC5/hl6uhgZag2XozhbHLHQXStq3bT18Fu7A==
X-Received: by 2002:a17:90a:ab97:: with SMTP id n23mr2876787pjq.34.1634015490146;
        Mon, 11 Oct 2021 22:11:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d67sm9267204pfd.151.2021.10.11.22.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 22:11:29 -0700 (PDT)
Message-ID: <61651901.1c69fb81.a7493.b650@mx.google.com>
Date:   Mon, 11 Oct 2021 22:11:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.210-29-gdd0ad52a3bb0
Subject: stable-rc/linux-4.19.y baseline: 115 runs,
 1 regressions (v4.19.210-29-gdd0ad52a3bb0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 115 runs, 1 regressions (v4.19.210-29-gdd0=
ad52a3bb0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.210-29-gdd0ad52a3bb0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.210-29-gdd0ad52a3bb0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd0ad52a3bb0042c42f468e946d1cbda6e74dfe2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6164e138a8bb55087508fac1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-29-gdd0ad52a3bb0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
10-29-gdd0ad52a3bb0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164e138a8bb55087508f=
ac2
        failing since 0 day (last pass: v4.19.209-13-g0cf6c1babdb5, first f=
ail: v4.19.210-29-gbf6c58e72541) =

 =20
