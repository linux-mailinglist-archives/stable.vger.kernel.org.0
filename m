Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81B631978F
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 01:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhBLAl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 19:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBLAl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 19:41:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B47C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:41:16 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id u143so4794189pfc.7
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 16:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ml+541OiS40UUZdSyVZnQ1gJGrKCUG+7PKbc0xs9lCc=;
        b=yN9XWJtqVl+AGRfpBDfYOyfD3sZQA7s6SSiyvs+Uv05MiFJm5zg2GfrES7Du3SB5F4
         NPSu1POW34nj8AEqoDkAcUxKsSDF0yLhLqOk1ELB1wspt1cBl4txpTlDkcPUnMlgUUR5
         tuoxRd9ROSvFeaK0nLQNHj+BZVJUXkrfaUY/P406uZBQ9hxztK9s81uExKX/enNfSu5R
         6T7H9nYunDbD9MP95RWypFNHyCqZbLgKY6Avh3iXLeFK6yT65qotrevAjPRaKrpWv5GG
         NDK9Nu6caUYT82Ij6Ch1cx1lik5Iu/xXMJ5Il7EUeACukAXdkrHUPhihw8jwMFDqjR4d
         NBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ml+541OiS40UUZdSyVZnQ1gJGrKCUG+7PKbc0xs9lCc=;
        b=A+WfpVtBamZj+7z7sOWGrU/eCD3DPWANzSQo1HQE3nxggs6JY3eLGRGUCMKJ5zHmhw
         x/pYRQteZAON2D/NVBiKHJMqRHOJNFHRkUUXPOp8zZgx2vK7oAASOW7dk3jyrBBAAXxa
         7PNzADXXnq8sjbBxJLiAYtnoUxiT5muSJ6EXAR74rBfE+R5Ue1uc2hGOJJkwPxMbJunY
         L2cUSQ4+z+E7RHaXPTU8E/d94mwaqX8rfAY3d8GXfYdJjvhFd82WemrEpgxhTGUVPDox
         d/oUTPTg0lr/9izvobGvT8EpDGJufFnIdcbTgzqdlCGokL97Q1TvwcrTIbHsj83XtFfv
         sTOw==
X-Gm-Message-State: AOAM530IamtjCKLDcDcYzRwkP6ohht9FOr4mJDSKhMG5G/CZyozT3bkw
        lxRKySTXtiKhfi6wpuYzvLhIXgGTm64TKQ==
X-Google-Smtp-Source: ABdhPJzjdwBv25OSTqyHIbutOr4NwfN1s7ZrbWVJXTNtiTEe6ZFgHWPQU0ecwBVYnENABomE2Jtsuw==
X-Received: by 2002:a62:4ec4:0:b029:1e0:f67e:b2f2 with SMTP id c187-20020a624ec40000b02901e0f67eb2f2mr522354pfb.81.1613090476046;
        Thu, 11 Feb 2021 16:41:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lf4sm6142477pjb.0.2021.02.11.16.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 16:41:15 -0800 (PST)
Message-ID: <6025ceab.1c69fb81.4fa1c.e8be@mx.google.com>
Date:   Thu, 11 Feb 2021 16:41:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.97-24-g0c5299fc06d2d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 99 runs,
 1 regressions (v5.4.97-24-g0c5299fc06d2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 99 runs, 1 regressions (v5.4.97-24-g0c5299fc0=
6d2d)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.97-24-g0c5299fc06d2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.97-24-g0c5299fc06d2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c5299fc06d2d41bab32fd05968c117d0939c6ee =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602599d189e4eeee623abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.97-24=
-g0c5299fc06d2d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.97-24=
-g0c5299fc06d2d/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602599d189e4eeee623ab=
e78
        failing since 83 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
