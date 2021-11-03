Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECC3443AF9
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 02:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhKCB0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 21:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhKCB0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 21:26:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB098C061714
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 18:23:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t21so1397960plr.6
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 18:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i+q5esv10YFUwZF21D0gYbEOZDg5YWwDOLxVB8FdMuM=;
        b=KnImQ3aSohY2/TOyjX0nqwwmBjNbGBUqDOGnVUhcXTwhRuJUUyAFdgY+90TVuPIE2I
         ap4sovvhlVIl+9Wic17IvXsCBqZ38SHb06zBZTgXHNuSFDEAUObiWohsRbS+t1R23+jG
         mqQbznFZDtHK9N8mnBVggdcK/KVyB8uiQTEMO1uoKYk86fSN/xrtgDya0HLTx6M7zNaU
         fv03pz/VzhaIgZkPK+OTU/8ghNe9u6APE0Gr8rARUB0OLpD0Ee+yVc8mtdMVMOhVND/i
         awEYgvelVroNdd0uHSI+YLne0MnB7HF4W9zyNZbWqUhgBY00d6fHMCjMRsxlr7/sDb0U
         O32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i+q5esv10YFUwZF21D0gYbEOZDg5YWwDOLxVB8FdMuM=;
        b=Rve3ttTpNYfAgeYqWBRYN5cKR3OExblo4iJ9VmgwY/8uXAwW+krfkm70VjOdspuOla
         KYPzdEN2c8/8PAjupG/PDMmN7Q1TRCJC7qVYSTu6HO2+HccZIi3LEsLbcNibVyvbNhVH
         S1DGp9T2s4zY/o2JfvYWi4qeCzT/Z0d5n6ctWZ2fUxWS60DJPVrjuzRuiZtNsvfSOqco
         AnpsH0g4ddu+D/geT9bkOjwHoTLcgcpHKuBaqAvskeRl0SbM236y4juH/3TvzPNMom6o
         hi5OX7tg7cDY5MvojDgQ9tiRBlG/6WUT/vlkrXvu/z/9UGgdid3sfGtZe5FCRdkEw+qc
         oqLw==
X-Gm-Message-State: AOAM530oxVRFUGUDFaOb2txPXNaGgA5SjIUBRRFErvsBwJpEmvpKWPyD
        IADKA+v7v1XTUJxXoxE9jYHEdwgI1WoXna0o
X-Google-Smtp-Source: ABdhPJzFtYedriuvSjNQL45KM5ryBqvnpMQ6XP9V+EEFNmhZjja0w+RnO6eZuxHA9OZVOM0BiknV3g==
X-Received: by 2002:a17:90a:bd0f:: with SMTP id y15mr11106501pjr.186.1635902606259;
        Tue, 02 Nov 2021 18:23:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng5sm254864pjb.51.2021.11.02.18.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 18:23:25 -0700 (PDT)
Message-ID: <6181e48d.1c69fb81.f65ab.17d2@mx.google.com>
Date:   Tue, 02 Nov 2021 18:23:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 159 runs, 1 regressions (v5.14.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 159 runs, 1 regressions (v5.14.16)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f63179c1e68ce99d511b683ad05d3829d0e4d9e9 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6181b4ae06a78efbc133591f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6181b4ae06a78efbc1335=
920
        new failure (last pass: v5.14.15-126-gc99063ce032c) =

 =20
