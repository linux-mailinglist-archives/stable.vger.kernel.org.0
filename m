Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7FD3097D9
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 20:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhA3TNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 14:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhA3TNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 14:13:11 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD71C061573
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 11:12:30 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so8791033pfk.1
        for <stable@vger.kernel.org>; Sat, 30 Jan 2021 11:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rol0l5C1xGC7dkt+UQJNh8guQ7lQJJ+MWe7kRltrVXw=;
        b=QvwsCIh0y1MEV/9JtIb/n1W8ysXPtYo/2R+UBc5XV9snupPoKk5MY5sehOm0CaG4EW
         rtMGnhmO6FftjYAte87H+o/FBj6kgoCD5Q3fa/C/Cr90v/9J2v4L6PQRy2+DKKa/J0B1
         aCC4RKVr7l2VJDAdjOg8HSsfM+KSmJwP8Ai3+EX0rHe8Hma/XVgJIeyqBEJDYe6XVPEJ
         Hi/YfSPz6+E+gZtN2zarBjPheFP3X+s7tQlt2eXBVExKn0UfxrO4S77yzwFKV4h/8ThE
         U1KKf3MTTjE4dWPF2AnsSj101eb/72mWg91kkz27FY6CSV0DeVxwvPie3Igr2dYoXR+3
         AlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rol0l5C1xGC7dkt+UQJNh8guQ7lQJJ+MWe7kRltrVXw=;
        b=hh2VHnSVZCI0hnKCAdVnE9GnQqqg+hqGF+0iaJAfMO1cljondg0mJ+tu5GIBaE2fO3
         NdTAWOvtM3ZW5qk6MGQXfjuQHGrhInnlaqM6rwTkmq3Q1B+AcCzfC/A4bSBqkjSd4Pt0
         SKwv+aPbuJZxPWVYfv0ynSC2UiWgL3qQFsIqtXWojWg9XxEyzB6Ar2vNVyQhfvhcv7te
         us4Xgq8Y5pClKHzydONm5Z3latsPeimwtP6pCVC3CPhPCZfDBJaGdocdgEOpghq/6arw
         2xGBToCjmJ1Oz0RdZuOSeBcwpaM7sccbcMngRTQvO0DoMBBdpRjS7Z/4sVAYiN1ZiIMe
         uAHQ==
X-Gm-Message-State: AOAM531JUwOoU8dFtsZKkTK8wjXQ2JeOEXYvgrDElSnrgel7abW3AjCF
        owWJhWFTZ0WLnw/ofVtvK6iK6NuaS4CX3w==
X-Google-Smtp-Source: ABdhPJxRSSzE6JjXdgLrGy8ONiYvSTwMa6TdS+zkLfHk4yh9F/SLSjERTOiATzcHby8ApZWhjuaT2Q==
X-Received: by 2002:a63:3403:: with SMTP id b3mr9981510pga.308.1612033949781;
        Sat, 30 Jan 2021 11:12:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm12821808pfe.177.2021.01.30.11.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 11:12:29 -0800 (PST)
Message-ID: <6015af9d.1c69fb81.bfbaf.f405@mx.google.com>
Date:   Sat, 30 Jan 2021 11:12:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.11-32-g6b6290ce1db5d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 1 regressions (v5.10.11-32-g6b6290ce1db5d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 1 regressions (v5.10.11-32-g6b6290=
ce1db5d)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.11-32-g6b6290ce1db5d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.11-32-g6b6290ce1db5d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b6290ce1db5dfaf68e04f1e861b030253383402 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60157885deab912c6bd3dff0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g6b6290ce1db5d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.11-=
32-g6b6290ce1db5d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60157886deab912c6bd3d=
ff1
        failing since 3 days (last pass: v5.10.10-199-g7697e1eb59f82, first=
 fail: v5.10.10-203-g7b2d1845e2139) =

 =20
