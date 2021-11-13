Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D244E44F41E
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 17:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhKMQ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 11:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbhKMQ3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 11:29:11 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A51C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 08:26:18 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v19so190167plo.7
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 08:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jE9OCVpq1ayP90nJzeSDZTRZxMMSZce66NXmIzzmf60=;
        b=PfGgN2uOpo6XHnhWLTO8D9S2epJb+gCjwI+TZpG8H+LULTqV2NnOW9yV3PcxjOIo1H
         MFkiuEV21IpqAbrKz/yPSI/Yi93EzCJAnbIL7CnLOYvEajaSUo5QYorD2zCCXnAbC4Wi
         J33GRdCcn/gyu1MKeLYJbV37gfDgHkOrutC3tx9nYUvOO+ythpb2tc21sVPm8DYyZM6C
         7q4jjd/kmy90m1efhtCFOmWlwH6anRrFp69Xb9B8BQtpJ7nOdczI0av0UVhsWmxR8Wpr
         xU/OsJ7bgRKAvVMsaf90vh1nlO6BwnRl6nFGv/u44TJ3qfURxVdBmbYixC04qrTir4Sq
         pF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jE9OCVpq1ayP90nJzeSDZTRZxMMSZce66NXmIzzmf60=;
        b=AXdnrDbX1SNw5d+5XYtx+kTgxO/1DdKw7UhMLr4jEn7lBo1AA0Tm3+L828pGF4llwc
         o9wr9qhZQamVGZSy1XrOOExuLbqH+wN/jZLRCDS+bJO8p1FYpX01r9KgtikgywmLUMn5
         gQrebZSD9XEznXAUxT3ex2J1PSu6oEcA72zLUSQylcDG9XIPLgXc+/TskO3wbOoUxsXB
         qA5Es5LqUGbDM3+WEz5G6XJ+Ka4v/tt9bqLJjh/0kfY2i/5IlGYRD0mBHvjlfPcY8x1o
         DOBYJWSnvI8K2Db4f9zwIzOT7KJoSI+h6C/GpB+BTOEHCzf4Tn7jDzyiw5LppVWPVxag
         9CfQ==
X-Gm-Message-State: AOAM532URvc5PEA/+FXoCcIoLV5zZqayZvGR0J2OMof0X3NIyAAc9fVs
        MF0AUsCmFZjeQdu4pyV54bktnPZqBcdO4F+Y
X-Google-Smtp-Source: ABdhPJzNPpBLoujg3REWxe2Jd7uxRLA+c2dvb16VMR9zUTnivekjONUHu9svcroo7emYzACJsNe7cg==
X-Received: by 2002:a17:902:d50e:b0:142:1b2a:144 with SMTP id b14-20020a170902d50e00b001421b2a0144mr18540042plg.51.1636820777067;
        Sat, 13 Nov 2021 08:26:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 130sm10143084pfu.170.2021.11.13.08.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 08:26:16 -0800 (PST)
Message-ID: <618fe728.1c69fb81.e501d.c54f@mx.google.com>
Date:   Sat, 13 Nov 2021 08:26:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.290
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 130 runs, 1 regressions (v4.9.290)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 130 runs, 1 regressions (v4.9.290)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab95ef83dddbae37b60263e092d08d5cd2b0059e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618faebb1160764876335906

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618faebb1160764=
876335909
        new failure (last pass: v4.9.289-23-g6ecf94b5fd89)
        2 lines

    2021-11-13T12:25:17.154444  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-11-13T12:25:17.163474  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
