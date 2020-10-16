Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7670D290A2B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410982AbgJPRCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 13:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410981AbgJPRCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 13:02:00 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB995C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 10:01:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l18so1821199pgg.0
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 10:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6wMXFMAsIo8lDsx6GQEMderMFti3YEsQn+gRSmMgZAg=;
        b=dg/IDtRE/QQK3b/I9OBeY0MW+di8KKmGn8QXWzFSeWFaXLGl+O+n/0IhvXnbyrITCH
         FJPQOFM3gsVgwAts3QSkayH9/VHKa42U5RtVNjX4epirfwdM46cqjFBZZazEeZioSQqH
         2UOupURZFQMxGZ94kUpfBQi16GKokAN0dr52wRFxXe6Lt6I9YnE8zzgbj8XWhdsfHsDG
         Aoaj5CuE+nxXAYn8Hh8AKzpDqkt/3HVPw5nIPabMXfJMiNUZlxTr7Ly08BKM1zu34UCW
         7vcEdI4J5eZwdxjC3SOE0OPa9Z55utt58oFYP32X32ZfKrl96pKntJdiyjizbkxz5Wk9
         hTkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6wMXFMAsIo8lDsx6GQEMderMFti3YEsQn+gRSmMgZAg=;
        b=hRKUmT5h+sjNcSUWxQIJCQKycnYEPCcRm7vXSACWY71dn8hUU25VuRP/J3Fk/i/i00
         gIuundsryht2hbzgMWZcAzJSUb8gVn8Ga4ToDYBCFXzsfJsrPhYX4pp4wbggzWjhF4/a
         5XYvU4y/azKNdrGMjhVm03WEpzM+yaY/8LiL9K3xyCYTcxsM3f7d2XxPqP+OZXUwwjXn
         Ho1rlNirAULw6u3eTj/L49NIe6IXEAScUDu6stsmjznjqXW33d0MbznhM++4pY6oDhkJ
         ddjt9xiSGyDIgObLt0vck+yp++Yw0k3XthwYzJfuN5D/l6g+ER9bqYZ8n+sb5kSqGkAl
         Ls4A==
X-Gm-Message-State: AOAM531nSLIo5A2yW+r2NEwhKaityG4EP7IVY0v4/J1xH1Rs9EaJ+wyS
        hN+fT5Nx01p90YY3TYOyNrQm90/JtXxvNQ==
X-Google-Smtp-Source: ABdhPJz4835S61YNQQlbJIhsLO14QOW3Gxx9ve4u9KW2JBbPuwZk3CA9Zj/ETiaMuksvAh59snMK8A==
X-Received: by 2002:a63:1d52:: with SMTP id d18mr4008246pgm.450.1602867717846;
        Fri, 16 Oct 2020 10:01:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm3594394pfn.54.2020.10.16.10.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 10:01:56 -0700 (PDT)
Message-ID: <5f89d204.1c69fb81.300fc.7487@mx.google.com>
Date:   Fri, 16 Oct 2020 10:01:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.239-17-geb0fbe0c6b1c
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 144 runs,
 1 regressions (v4.9.239-17-geb0fbe0c6b1c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 144 runs, 1 regressions (v4.9.239-17-geb0fb=
e0c6b1c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.239-17-geb0fbe0c6b1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.239-17-geb0fbe0c6b1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb0fbe0c6b1c2863b26464de441a406275c47b6d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f899b4906d03d8ccc4ff3f4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.239=
-17-geb0fbe0c6b1c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.239=
-17-geb0fbe0c6b1c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f899b4906d03d8=
ccc4ff3fb
      new failure (last pass: v4.9.239)
      2 lines  =20
