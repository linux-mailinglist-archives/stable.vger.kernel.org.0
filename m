Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CA3372C92
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 16:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhEDOzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 10:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhEDOzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 10:55:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BF2C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 07:54:40 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i14so7184517pgk.5
        for <stable@vger.kernel.org>; Tue, 04 May 2021 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=59qUJa8AhKU8HGjazRcYXanmPnVS9dJ02nlE9Tc5R3o=;
        b=XxsvIoRHClNWBW9w0W0FdMX7UKNUCs46paV0lqmrt9aVJacum9XVtBDF81vmC9dgoJ
         E6N8aqmVpsXUBzkqfUCBLOpZSwTQiOmNn64LHGE5DiwA9iMJUSat/KCc9wHzyPuhN+vV
         oGrRHBapYAL4H/4jnAgpUuqs/Uv2VXQ9OkQnvme/G9QdRteipTFw+64XinFAEBmle60F
         58OrEQecbF++qOp33FvKEDkNJZnmYHsNwEF9W1Wx6iI7k3S1OXGd4HwfW/YS0qmSYeao
         DYYbcKg3K1jul/H+/+oqJQfH4uafZhTjK3bORoKgsWH/ScRtx+ej9Ba001YYNfzG8htZ
         I/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=59qUJa8AhKU8HGjazRcYXanmPnVS9dJ02nlE9Tc5R3o=;
        b=qGztvr2Vul3MnASkkRZHurF8DoCQ9G59MEHTvovfQ5j75+Jt5sk5T47dAwGCSmk35Q
         FJ4X1+O9PqDW+trustW7uh2E0nwCRr/Pok69b44cNl6UnDxGo9/F83ixskHk9HvE9DUB
         GY7Fkyh+FO8CGlltMo7CUmyPu4QARRh3aVG1vAEe9Q52bEjig6R9Fl47wW7Lyj9Ilzom
         yFNWdCyiJckS7nBN7LnILCQb59EyMleJtjc1GK8pCpLQ333oo9iXpuRPojafzJxUWdXF
         I2kG7eczLWg5maaGhCQKI1lWEQ3BpWdOD8B3tpeLIbbJg0oF7xcIaLLdUim2j6I6nKsN
         oouw==
X-Gm-Message-State: AOAM533raZHPpUgWyaRabfSTikQFxw7nQXkL5XYqVCYGNG0klVqjxvzV
        3BcdrBfvwP5qfJk1M0iXk/YYgdA2jdiMDQHu
X-Google-Smtp-Source: ABdhPJwO31Xbl25VhDPnMRhgeuvujPz2gbhskyE7PYF52kGh0GDyt8CO9TGziPLpSIdYx8eiGw590A==
X-Received: by 2002:a17:90a:5602:: with SMTP id r2mr26715757pjf.60.1620140079679;
        Tue, 04 May 2021 07:54:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z3sm12778722pfn.12.2021.05.04.07.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 07:54:39 -0700 (PDT)
Message-ID: <6091602f.1c69fb81.b1d70.14ae@mx.google.com>
Date:   Tue, 04 May 2021 07:54:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.34-4-g409a7a0c5b5ee
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 124 runs,
 1 regressions (v5.10.34-4-g409a7a0c5b5ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 124 runs, 1 regressions (v5.10.34-4-g409a7a0=
c5b5ee)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.34-4-g409a7a0c5b5ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.34-4-g409a7a0c5b5ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      409a7a0c5b5ee5326b14197a63989d099ff2dbb4 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609129d2b46534d247843f3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
4-g409a7a0c5b5ee/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.34-=
4-g409a7a0c5b5ee/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609129d3b46534d247843=
f3d
        new failure (last pass: v5.10.34-3-g1bc3a983659d7) =

 =20
