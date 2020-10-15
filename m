Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2488128EC55
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 06:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgJOEhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 00:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOEhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 00:37:24 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4BDC061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 21:37:24 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c20so1210898pfr.8
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 21:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XnmFibenzj+6EpP9fkQ4OjZ5F4/DiHTOVS6MbN3+dv4=;
        b=LBDIlStOwMm2k4v5zPffRoYdXHmUzE4M0VT1ojb6mFuWj28whe6BbUvBlAZ3eGUfCU
         oaqyZhP7yHlbQXzftYNUOEzoOOe/oEMTSnV5aVmHcZrWFd83nMstqnyRJdRjKkH5TwFe
         aebgHyXIxnxthYL2JM+l3ClWF4RX9FMJKrB6wU3yXQ8ye9u92ntcDVzdXvWBYT5Eg1Xd
         opx/k+dQCxR0fKNniWcHUvj9WrlJiMUK5/7OrQO4ip4iCgcA0XZHGRFte6ptvbU6hPfZ
         23WFbuwaDI33t5uYHFVtxH0Hn/HIZa0TpMwkyj07afzq7nf28ZhS0HLp/ZCuk3tJGBIs
         dP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XnmFibenzj+6EpP9fkQ4OjZ5F4/DiHTOVS6MbN3+dv4=;
        b=MPT02UMLx5A0iozl3cMMNI3Il+irAl/DcLUqWmBRdalSwnbubsmmv/GheGsJ+znf3d
         PuDqRmKQ4Pi0r1v1CEN2ugair/u5nlaglrC5rMYyOP1ph+NFx1I53YSaKu2NPlF0qM8u
         QOUSYC6XgzYPvknhZ/iaOwJlUONqMJRgx05OZx9ov9ZMYdXKmlGbHDwYrhxyEIujCNPu
         Y3C9b3vBVFQ1qsuFJnwfxp7srkAtg2DErauy9D001dXlxbXY2WZfg0DNvZ73sdyMotXa
         URbsNJYrB8GwLbsOArNDnqPg5XJh1Nwp3GnG2Rz9SJpFkqR0izYECVmynYEt8agaIuNz
         3BWw==
X-Gm-Message-State: AOAM533TT/YbihZWZe3lj40yIgOwHSDRLf9mONPkhxsEISb8zi1TneT5
        WOpYfM9ZWT0LJdwj3pRWMqszms5llGE7fg==
X-Google-Smtp-Source: ABdhPJwhEwiMjUeJE3y/xFtNVYtmEGpAFgcQ/o5EQepeIaapOmvDMi2QA3aOH1R2WYzvuEg3eabFMg==
X-Received: by 2002:a63:4102:: with SMTP id o2mr1897642pga.354.1602736643664;
        Wed, 14 Oct 2020 21:37:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s13sm1301834pgo.56.2020.10.14.21.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:37:23 -0700 (PDT)
Message-ID: <5f87d203.1c69fb81.69e0f.35f6@mx.google.com>
Date:   Wed, 14 Oct 2020 21:37:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.239
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.4.y baseline: 114 runs, 1 regressions (v4.4.239)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 114 runs, 1 regressions (v4.4.239)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.239/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.239
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      08e290674368862e4e5af76418ca5b0db7392030 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f87977cf1de37924f4ff40b

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.239/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.239/ar=
m/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f87977cf1de379=
24f4ff412
      new failure (last pass: v4.4.238)
      2 lines  =20
