Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8D31EB4A
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 16:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhBRPJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 10:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhBRPCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 10:02:08 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFBFC061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 07:01:24 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t11so1299989pgu.8
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 07:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wygzTSDPq98tSFJI+7F9m9d7QOUzaK4APhEGiCyHXAg=;
        b=kOuk9oGGPqJgfgQYBNfNBqpav9NBVxnwH3rCrylG95Uu5aUEFvrn6QFEvGuMIVapqG
         saC/4tqBxtbuvhXQLzDSaMVgg1LsWGKOZO3hQ1+8KbTfWodvuOPCtIUigyCWxT9o5cAE
         KnkoL54KFwwLnWaiJTDaTvNOGWZhglI9f9OM/cxq/NuLyYxm0ugPW/wI3z1WaT9JeEPS
         xbR4d01DRYa31Cv8HWGxlnbLyX2vPsTzfkiukHcxVcfcTN8ULzS7Esm2iq9BExEoKo8b
         6+nZOYtsvWhV797lLZM/TvfOhCgV7GUQFJAAL8kNARxnmtM8+Mn6KpmRW3e+Jc88Z592
         ydIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wygzTSDPq98tSFJI+7F9m9d7QOUzaK4APhEGiCyHXAg=;
        b=jrT4Hht/2EMTp9lY3ZiVa9OpfNStguT7GLS9fCRpsdnAC6j7xd/pDpE+a8BfCWqc2h
         4hqhk0i30vMOLdPqKhTV6sm+XtKEZOLatyVCa6tmkEgm5gliJRreT5gQz/ujZ2fcX+rP
         Iw/3ohrrb1Ivjm/jUONhNU+ArSufzr91if0Y527KSkNF/OJUZTmze8S/MqUt5t5bAy6g
         GNbASkAjXMu9V0bV51mOeWH1APUvGVzGT5Liaq1Fo9CFLmaPf/B+CApJ7xsJ/uo2tTWH
         27HLg70Gv8EJiDn4JFWEf64TQq2oQsqRMqj/Wj2q3CiFYZurHGZ8WPjhmuGuidpmksfJ
         6Z/w==
X-Gm-Message-State: AOAM530/W8K/bz0G1lpxBOvbL09U1h/J6XthGSG+tuZXg41pYext4hg6
        qPPg8MFQpqh+PEv5gFrBd1+wnl3mhM0axQ==
X-Google-Smtp-Source: ABdhPJwdqhxdP2lKWzTjBDxANAUgfU1weB9lV2UTrGuO02YNrzu4tDgxTa8OIjeI8Njh03FzeB5LRQ==
X-Received: by 2002:a62:4d43:0:b029:1c6:e790:5f8f with SMTP id a64-20020a624d430000b02901c6e7905f8fmr4771709pfb.65.1613660483881;
        Thu, 18 Feb 2021 07:01:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h70sm6272025pfe.70.2021.02.18.07.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 07:01:23 -0800 (PST)
Message-ID: <602e8143.1c69fb81.85d9.dae1@mx.google.com>
Date:   Thu, 18 Feb 2021 07:01:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.221-44-g6cf22cf83373
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 76 runs,
 1 regressions (v4.14.221-44-g6cf22cf83373)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 76 runs, 1 regressions (v4.14.221-44-g6cf22c=
f83373)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-44-g6cf22cf83373/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-44-g6cf22cf83373
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cf22cf83373ed8d456fc3e8d3fdc3a4ccc086b2 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602e61f540a1515683addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g6cf22cf83373/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-44-g6cf22cf83373/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602e61f540a1515683add=
cd9
        failing since 72 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
