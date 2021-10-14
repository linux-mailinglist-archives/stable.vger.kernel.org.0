Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBAA42D821
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 13:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhJNL0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 07:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhJNL0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 07:26:50 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0F4C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 04:24:45 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q12so2311477pgq.11
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 04:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cFNhZZDhpSBt/xwxxP+KVZHrpLhZoH8UI4/S4DECWEA=;
        b=EqicUhkQWF6fKvrtxht0x9k61O4QBIL7egmR++h70pQbK3J6FBX7TGiZ9JvDBRDiRe
         bFoaErasZRclHlvjF0nw0yBziMD8hzGvEMtRbI1WfcGALJ9aRfWn2mcGT58EXPrO3NJE
         /Bptm/3geeYiLjRaVah18TRLsJ8iveHDHZWzq2B/qc7uraaI7tcRJ0lcInCMaB+lXN9h
         0rMdZ6wxIpDm9cfU2+/juQ6bYxEyBZkBsNAj/Y3vMlisHsydGx6k9Yk+A1XusPi25boZ
         LHEuzSRCgWR+NWmNHBRS5bA3jPqXinBl0EQdn5vbDBUrIVIKWnJNRBl5TEPkQfVcSiSs
         Mv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cFNhZZDhpSBt/xwxxP+KVZHrpLhZoH8UI4/S4DECWEA=;
        b=09xpzG37y8DvIlOOB2xY74ol2vOMUJsHhAmjTf0pclSzpII8ykpHY3kf7lvSc+ot3D
         zKIgK3pU2eSVHQviqywPnL7qk9aUT8Tx4Dq62NSu5xfeug27vshsRkyum1C+oyazDJRz
         TvBjLUx8w4H+YT6aRISGiom320W/CcBlbbGYQGvw3ujWbwPfhbXsG4+d4tVS0xylsEI1
         v897R6g0/5T5Atdhb+E4nhKIc9tMeItcMo54XO43qUsLJDk4gdbCAtZJI8xuLAf31NJc
         aFnm/Hvg20t1bhm1iE85LGKK8ybkoAalzbF/B94S9IceY8NN44Gs/m1Bi6n63smpBZch
         1s3w==
X-Gm-Message-State: AOAM531kH5rmLj2flHl6C/Y2EKn9mZsWfpOjz4y88eGjnmgcQOMO9nVo
        hpEJnI8Hq6n5Cfxv3h9zNVubYT96mdPgxSU4PGQ=
X-Google-Smtp-Source: ABdhPJwtNOI2p508kPyXa0MZiYm5NDfJEWy4hX18E9RJenIGraNCbd37w2EvUx4cUMACVkLnN7Hq1Q==
X-Received: by 2002:a62:6543:0:b0:44c:61a0:555a with SMTP id z64-20020a626543000000b0044c61a0555amr4771859pfb.14.1634210685162;
        Thu, 14 Oct 2021 04:24:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm8145438pjk.3.2021.10.14.04.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 04:24:44 -0700 (PDT)
Message-ID: <6168137c.1c69fb81.e5d47.8921@mx.google.com>
Date:   Thu, 14 Oct 2021 04:24:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.12-31-g6aca54ba7654
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.14.y baseline: 89 runs,
 1 regressions (v5.14.12-31-g6aca54ba7654)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.14.y baseline: 89 runs, 1 regressions (v5.14.12-31-g6aca5=
4ba7654)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.14.y/ker=
nel/v5.14.12-31-g6aca54ba7654/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.14.y
  Describe: v5.14.12-31-g6aca54ba7654
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6aca54ba76543f6a5a857e377be9690d22329848 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/6167d56e82bc8382f908faa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
2-31-g6aca54ba7654/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.14.y/v5.14.1=
2-31-g6aca54ba7654/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167d56e82bc8382f908f=
aa7
        failing since 5 days (last pass: v5.14.10, first fail: v5.14.10-49-=
g24e85a19693f) =

 =20
