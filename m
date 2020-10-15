Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80E28ECF4
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 08:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgJOGNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 02:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJOGNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 02:13:24 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E38C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 23:13:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id o3so1217948pgr.11
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 23:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FSx8r5Yn0aHsTIlqeNtZt7OE2QlbWG9h09P7bjUml+4=;
        b=TS5dc/GvRkuaGCxtjRZF9n2h5P9odLU09fSa21Aq413F1ryp7rH9pfUxrnoZ52S4jL
         W8intmzkNf2OY6bmrRJxABq6ClHyRUedyr+Btp8Cea4fDEcWtugIbM/v8YT90iKZcCoc
         WexovjjA6IVfg9wXAF8Q/FcZcg+RS7k4YeFSuHluWeaewHbRkGZHpuQ6MzGXedsMP1l7
         WrH+//oqc14qWfwwCH7ylbzoa38JRCUkGESirrZm1g42bCK0/8UkI/xwotAulUw7YkXB
         LvziN++2T2PFIieabcVl9MkEE8FTpsxydSuiySXtybdRynj0ZKgVvhzw19yA9HxFe87H
         DoEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FSx8r5Yn0aHsTIlqeNtZt7OE2QlbWG9h09P7bjUml+4=;
        b=fp8eXjau/bJtY0MTkHnovkMVtdDptbtXJYd9hjXGnB5MQ000rYVTo3cWFZ6YakQZPs
         8F9EMCZbJE9quVoFhqcnO4zFSTy72X4PSBb06jUOFG19BBmFimc89/gBWVZ3oCQmlFUA
         3UvdycJUZjH32FjU1b6sWc1BHDcA7IhhNe07xOVk0XecYdV/0YJuQ6a8N2BOERbrXgGe
         4CcMNg/M0F5Ef1t3cqio02UbxuRHfe+k/Vi2RUxC/MzkR52LyPMgHlSFW6jZKqvBNt1l
         EEpi+4TzuDXG3NhgT04ZKn9+S6xcdlMn7TchJqtp+k531wXYPQ/CowyrmMdvWnZl4YZR
         IYWQ==
X-Gm-Message-State: AOAM530nLZknyP1MFpuIo46gs7QHuVQj2iyuriRfom7aLa8GeMkra3AV
        +z/BqMim2tD2Q4vpBFW3UifRnJxih0B0hw==
X-Google-Smtp-Source: ABdhPJzf0k5xadvXHxswRJ8bRHnwKbfYsgIHRsk5EMulEu1KSVfR5VkXeqAD22rc4UV2GRd+yIYk0Q==
X-Received: by 2002:a05:6a00:d2:b029:152:5ebd:426 with SMTP id e18-20020a056a0000d2b02901525ebd0426mr2710328pfj.5.1602742402762;
        Wed, 14 Oct 2020 23:13:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm1724425pfa.69.2020.10.14.23.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 23:13:22 -0700 (PDT)
Message-ID: <5f87e882.1c69fb81.b58d9.4521@mx.google.com>
Date:   Wed, 14 Oct 2020 23:13:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.201
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 123 runs, 1 regressions (v4.14.201)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 123 runs, 1 regressions (v4.14.201)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.201/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.201
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a21a9b514b8821af1230fb1a751600d847aeb1a2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f87af079b35244a024ff40f

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.201/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.201/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f87af079b35244=
a024ff416
      new failure (last pass: v4.14.200)
      2 lines  =20
