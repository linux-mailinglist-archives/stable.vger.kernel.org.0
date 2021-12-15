Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ED2475552
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 10:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbhLOJjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 04:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241235AbhLOJjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 04:39:07 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144C3C06173E
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 01:39:07 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id g18so20208426pfk.5
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 01:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eRAr2IM5FVzkugu59H7/gTWM4xo2FVMW3rmSCTTJJ4Q=;
        b=eT+kQXwmJJPl5RkAOqDmOOxx6rArRIDzTgs4FYdENWDqEyBZWJgNcKJcLvUbwUHXht
         0mF8HqR4hyqgMBFECBXuDTVV5XXgG2PdBEuaTPPr7ruOmpXjs801T2Gd9NghqzIwFE/0
         RCnwqKoVP1thWYtocVvfe5Czyfq4PgSF9hAPvd3rSrExkLrbY4JVdQmu1VtrWkNgtkID
         qebOYyDwNWpGQLJrTNsGWcObljA0bmCizM4p8Cw9ivjNZI+xj/6ybqIkustR50CaZ0eI
         HYxHTD65EfJeUqQjvoeE1C+5e1gNliKZPm9+Vm3EkTC6fYtvMCEL1Ex5RoscGO11OkJ4
         4rnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eRAr2IM5FVzkugu59H7/gTWM4xo2FVMW3rmSCTTJJ4Q=;
        b=NqBmjlU6XCe3RiRnWWb3MRe5SGRvAUwPBzqr2fzTdgnNQgLPR/gxFR0cIiImvX7Tee
         ag4BvJv2x43uw1jdrN0daWb6UrSRRuHbY127dktQ32ME2fZ0JkGtav8/zJZJ1Mi4k78i
         JTWqbeYd1swTW0f4dj8MYki1N1DlNaU+r+KBaLLSm252vgz1e7lzBojZyIfaPD37O0xt
         +CUPrxya78TGy82enivRbNIMZm8+xEl5ScTpwuYDI6oCfign/sYMENOj1owdIAn0Aavn
         G0stbnpDU8mICfljDdcZFOxbNQi1xyAlyi8lbAw5HD+rMdjwt0pmtGDVKTIHdFQL6JYk
         EIeQ==
X-Gm-Message-State: AOAM531qKyzA0EePd+kG/Sj5O23m4eE4nUDAvLsZp5ABN4d1eMc2JPPI
        TxU7KmjwiC0/FTMNGtD+H51+eXVh5wWAPiat
X-Google-Smtp-Source: ABdhPJwc9ur1m+BO2NJ1AwTjpzfxGbFDro9dnVq1/GNuZDyQlXIxhTbmNnuTVow18XhiWXxtNA3Q9A==
X-Received: by 2002:a62:8fcc:0:b0:4a2:5a1f:6752 with SMTP id n195-20020a628fcc000000b004a25a1f6752mr8166150pfd.77.1639561146489;
        Wed, 15 Dec 2021 01:39:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o124sm1840117pfb.177.2021.12.15.01.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:39:06 -0800 (PST)
Message-ID: <61b9b7ba.1c69fb81.8d5a9.503f@mx.google.com>
Date:   Wed, 15 Dec 2021 01:39:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-8-g9f411771d292
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 131 runs,
 1 regressions (v4.19.221-8-g9f411771d292)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 131 runs, 1 regressions (v4.19.221-8-g9f4117=
71d292)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-8-g9f411771d292/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-8-g9f411771d292
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f411771d2924dfabe1071cc23e0d13d69ee8fb3 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b97e0c3ada43462b397144

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-8-g9f411771d292/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-8-g9f411771d292/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b97e0c3ada43462b397=
145
        new failure (last pass: v4.19.220-73-g3a5a4233740e) =

 =20
