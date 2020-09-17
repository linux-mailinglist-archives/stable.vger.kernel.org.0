Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30126E0F1
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgIQQlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728577AbgIQQiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 12:38:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DDCC06174A
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 09:37:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k15so1543049pfc.12
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 09:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3daj7onG80HgW16zu6AeFz2Pleyxxeh6+BgeEhbqx4w=;
        b=Sjt38VZgBPPFWrOMKSRdNAdnLdQCQqtHyozrbh93vc/ZJjlog70L8NwOo6p98y0ExW
         Xu9BBnJxDwDoM0ksdNqfGd3FfeDTk93YWycEOx+R6j8JBLeYGPt8oFqvqWHmhb5tIEQ6
         PkBRU7vvfbuSfddzn2WKmMDwzrLtd4BTepr54SIkONFHVryCfEsNYlqMmXR9wbWEwNVH
         avodmfO1mTensZjAeQjuKjwGneDJgTPWWM8EaMNBNkS6l/PTsVIJOlzvBppuq6tX2uHP
         I1Bz2Ij1lPV49ATz9MXo0VwssEzkrA37yaxy95RIT7ixAq4EIQlwljYrqH1UGTn6fuKF
         N3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3daj7onG80HgW16zu6AeFz2Pleyxxeh6+BgeEhbqx4w=;
        b=Srsy9jEMWE2rwR0x4vkZtqyNd7CWzBxi94/Mb0kqSVPFg3FH+BBY1txNPPfP5nTOpO
         SjEEXCS47nRySl0O5jIuMThNSY5ROeIy0cHM2CbOKsZOgK48mSD3RjRK1GnvoDDwOR9e
         AMiAa4WMW9Wlog8Nr7eTnDxmmKKQfRmcRJKjbZBmnBr7An149AyF+m+VJsho+bUqYA52
         0a79Ul6SedpTKHnCJcUAl0l0FUqFtUrbLTRN6ochca68vefgIvkHl7zT1HbpgtK1MOF1
         R88ql330KC4CtqfTk3Zs2iBUYtYLi+d7Qf3QbzUwgbGPXeaeNW6iyHzSs8i5iXKdPHry
         dIGA==
X-Gm-Message-State: AOAM533uVaJ9sI8q8q5mdcgMxWwyQIDz1jMlsiV8uZLRuL5WbVXHH6ZN
        prCFR0YY3fZmzj1trtP8LWOdADNdxG2crQ==
X-Google-Smtp-Source: ABdhPJxQPqOKU3ys/egsRwqpvR1DkrmG186don9UOmH/L5dv4LW6SK5S5v4JoHZzPhhfO3HCw5s27w==
X-Received: by 2002:a63:ec16:: with SMTP id j22mr13378406pgh.208.1600360675008;
        Thu, 17 Sep 2020 09:37:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r144sm140072pfc.63.2020.09.17.09.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 09:37:54 -0700 (PDT)
Message-ID: <5f6390e2.1c69fb81.28861.04d7@mx.google.com>
Date:   Thu, 17 Sep 2020 09:37:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.146
Subject: stable/linux-4.19.y baseline: 163 runs, 1 regressions (v4.19.146)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 163 runs, 1 regressions (v4.19.146)

Regressions Summary
-------------------

platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.146/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.146
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      015e94d0e37b6860e4354ce3cac56bd7c39c8992 =



Test Regressions
---------------- =



platform | arch | lab          | compiler | defconfig      | results
---------+------+--------------+----------+----------------+--------
hsdk     | arc  | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f635ce8afa88a58aebf9dc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.146/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.146/=
arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f635ce8afa88a58aebf9=
dc9
      failing since 63 days (last pass: v4.19.124, first fail: v4.19.133)  =
=20
