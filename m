Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CFE323201
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 21:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhBWUVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 15:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhBWUVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 15:21:07 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97760C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 12:20:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id t9so2586420pjl.5
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 12:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hsg9RPYY0ZCj2mDOz5PPm9v1ZG68IhmKrEGkcOMq21s=;
        b=ZmrG5AxYfEKfPo6sKn5nds9nbBxy1cQ+TbfKEIRK1+lY9wI5W4YLd3p1J4msu8qImm
         vvedti6Ty+aEK7JTxmM0OzAQ9oHqtsZ1L3xDWfhx768f1SFcG6qvvrwcpSYMUmwwgL1S
         5Xdo1yiAU5Y3ih0W+o5KiFHNswQap1zmMSixP2T9ZameSOWDEljpxzg5M9tpEoPlstzf
         lut2LNhlO1zbbYIRIvGiRpFqYCRMZwMeCbWFqdmji0e8ae39N3oSss1/lNAbu2PzKWcV
         mr0sHpAI5fRKz5vjTJ82aVOJ0iWTtPmor7AjdZdpGJxEbG624dY8+zMkOG7aQ8KpYLwM
         yd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hsg9RPYY0ZCj2mDOz5PPm9v1ZG68IhmKrEGkcOMq21s=;
        b=UP5lOiP2nEUeIbIT8dPDH844PAl78jD6jRITGDto+KMjOmNlaU1C5+RaRUnu99Jc4b
         6cuuqzdaui/iKie66QkZj+ToF9Tb/P8W7mStevpMLvWmCe4GRwH0pLOqYam/YE6nS//+
         GYgZyy574gikyikVbWRQr4f6Hm/3yRnr87/wQro17bKQMQl4gkN6eAPdceEQchV+3cYa
         kARHg9/17dfEH3GZ7PxIlhhFzoFJNLI/qyDsLiud5Y6Lakqb8MeSLwb9Q3G8dof/g7iv
         O9YLy3yV+llnrTUTXY58w0RdgVBqnvru+Tm/MZDEbSR3uMzttOqEl9GrmDSmVvPvs6rU
         42qA==
X-Gm-Message-State: AOAM530nSyXqQm0I8SXGt7VPDo6PeR8erhU6qMUdHk3HjG6Lep2vPwI7
        Ln80xeV8XUZSkinD/1/KqG4GvqdDwVxNkg==
X-Google-Smtp-Source: ABdhPJyS2+zeIASrdjZxx/GEmcfhnZLQKcbcbGslvGx5KHJdrCB5caWEzDGMGCH2N4TQhGZo3u/ggw==
X-Received: by 2002:a17:90b:fce:: with SMTP id gd14mr540195pjb.64.1614111626947;
        Tue, 23 Feb 2021 12:20:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm4504085pjq.53.2021.02.23.12.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 12:20:26 -0800 (PST)
Message-ID: <6035638a.1c69fb81.89af.91b7@mx.google.com>
Date:   Tue, 23 Feb 2021 12:20:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-57-g08313506691e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 73 runs,
 1 regressions (v4.14.221-57-g08313506691e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 73 runs, 1 regressions (v4.14.221-57-g083135=
06691e7)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-57-g08313506691e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-57-g08313506691e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08313506691e7c8c2d1c5019618b8b8148d62bde =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60352dae8e5f28c023addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-g08313506691e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-57-g08313506691e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60352dae8e5f28c023add=
cb2
        failing since 77 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
