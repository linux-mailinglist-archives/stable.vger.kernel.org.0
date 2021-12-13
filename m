Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C31472FD0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhLMOxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhLMOxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:53:25 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13BDC061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:53:24 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x131so15100665pfc.12
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qEXotvngrjRV7ht2GIqhe5Tpy7Eaw0cVcn+gYBHfqKg=;
        b=wkYHzfJwqQvHOL1B/0zWWZ39V4ovP2zRjj4nDmrgXwwf4i4LCKITS0Zoxxs3kMV+nn
         Mukuc5w+US2qtg9EWLJe7U3qXI6ILhQ00RyDtAAySOn1yCAECGQAhqRMW8mJFnVI+Fq4
         pnSVTm2YGbkKO7TtOq045/O/S5Aan9ahSw3IA/oPhiF3qS3ypmd9TIGQ1ulzYJ5NgVy1
         rq+NgHp6JOdIRQ7sn8TmHq5mdEC79IyCwsefj/OoRro/qQXYfVxKmTcZPNscZYeVFX6a
         quU4yQg2hbWqBuBF665KePbqGM3Z0aT0H4IKef3aZSvKdcPbFXZSYi5ZDLoHo1soLp9i
         JgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qEXotvngrjRV7ht2GIqhe5Tpy7Eaw0cVcn+gYBHfqKg=;
        b=Mz6yjOEa6aSyhykLT9aJzHg/9fscwq5aSFnwO7rMHFj/RHKGMN/MJ5CPMa4NltHHZ2
         Dl97M+e+6iW2dKKcNt0aVN1r7Ykq2kymK/UE1fiLIVLfBn9ls8AjKgpWu5xkILKYwTlD
         7MgPlMxdLL22iuEAAm27NMaft4brf0yTO3H+xZb4RvstF6RMETn21gpf3gFSdrMDyZ1W
         T4guQeTTBDGcYoCRR5n+sBrfFdtTIMw7r26omVvDltcwnehXM3qUzX9/n5hq/HNLQuIY
         wCEjoBdRlBdAKmwfmzEPreb7VMoeATR9HwN8kzOnS+klZfBkepJYrkMgJXQvLzrBqdb4
         HE7A==
X-Gm-Message-State: AOAM5336CU4tIpkD1/gmUDouYnsiZvA6M97QVMlDNLoCzY326YZGB+5D
        1GVeI0ruT7K/sQo45+nvJgaaXJFZjka2Geoi
X-Google-Smtp-Source: ABdhPJz8eBrV+yhzSpeNBaGMtd/FYjXJzj/kL1YW23qnkewnwxHEg4H2pkIq7biQWQyseoyxFskv4Q==
X-Received: by 2002:a63:d054:: with SMTP id s20mr52063068pgi.565.1639407204121;
        Mon, 13 Dec 2021 06:53:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e35sm10398101pgm.92.2021.12.13.06.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 06:53:23 -0800 (PST)
Message-ID: <61b75e63.1c69fb81.84996.cbc2@mx.google.com>
Date:   Mon, 13 Dec 2021 06:53:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.84-133-gf6a609e247c6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 243 runs,
 1 regressions (v5.10.84-133-gf6a609e247c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 243 runs, 1 regressions (v5.10.84-133-gf6a=
609e247c6)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.84-133-gf6a609e247c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.84-133-gf6a609e247c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6a609e247c6d6f15ec8c4a87c9aef37b7c8e5a5 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b724bfa32c36338539715c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
4-133-gf6a609e247c6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
4-133-gf6a609e247c6/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b724bfa32c363385397=
15d
        new failure (last pass: v5.10.81-154-gc7ee3713feb5) =

 =20
