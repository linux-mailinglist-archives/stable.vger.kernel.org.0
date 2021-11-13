Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D55144F5BF
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 00:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhKMXuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 18:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKMXuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 18:50:40 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68C6C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 15:47:47 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y7so11469244plp.0
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 15:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WiBlNQcqta3pDvdgpyXYvjUyPKFYxFXkgaBUWimqmZw=;
        b=GQALKKFpmLS290+oYgnu9Bm4EX3G3bAeyK3Z8AfK/z04KiU+Y8gPgLh7Vj1rrSepZF
         38pzPG5d5DeEBdADgXtdOrfPKLkAqYOCvnmdNt8yLaeXtmEKQYDvPsNuo+SDbL6yVIVN
         nPjtQzQ/ojHf3i891QGAU08QCfM0YWiK+fcsgAD3cRbZ0xxos5PXIiW9jyhNp7jKU/YG
         IZms+yr2dJ4IwJNB9edYcVG3Fs9171gY332vsWp1ZyyT342GnFPbJ1p7dPJRnAB+dEGo
         NZqCWE2sDkOLQPUpxvjhEoxoEP/7UA0NsfmCr3IxuW05Q+JoUo9NevdE9IvkspH5JKCa
         XKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WiBlNQcqta3pDvdgpyXYvjUyPKFYxFXkgaBUWimqmZw=;
        b=m26eRWqJwskeiLWzScwYDbbayNRF8SEZaZ8QXE4eOubjwq7nGvc42YO8h2GYMhmBw1
         7HkbMI4xfznh3TmZpHqZZAbjNwcl2oTYUMecIdwYIw1RYB0jYEHWLgshdHAADVwSbpV0
         LY5bqG1XzzVsnZILNzRHI9q2x4Cvf53DO5paKZNPw1/TqmSNcFS714DOEB3t7QwKW9LX
         9uQlFXxF0U2Yr4lceck3wSkblSsL2mVQRrH0L7Rwyjq3CZ6eKE5IzzoEeL/QGIg2PHRd
         e2SYUoCI98En1h7UPelWUY4jw8OmzkXTMOrSVq/owLUfxn764+wZVugvZIhnneEmFf96
         9kcQ==
X-Gm-Message-State: AOAM531hcwTUHtjSQ25PXhaZ21PvrpZ5oH3xwA7ziL8AOEbMqC9gve+O
        vVhAsg2EdO16jNbrTMgs5Xgm0ogSwQJTxmb8
X-Google-Smtp-Source: ABdhPJygSCU8j7HN379QdbBOq/WavIthLkPLuRgqLw9Fgp43Zz9RmW8pqU/czPjkKmN93vgj2nslCQ==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr34861219pjb.141.1636847267210;
        Sat, 13 Nov 2021 15:47:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm11367446pfu.137.2021.11.13.15.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 15:47:46 -0800 (PST)
Message-ID: <61904ea2.1c69fb81.6c8c6.f521@mx.google.com>
Date:   Sat, 13 Nov 2021 15:47:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-36-g43195d0a7bf0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 120 runs,
 1 regressions (v4.4.292-36-g43195d0a7bf0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 120 runs, 1 regressions (v4.4.292-36-g43195=
d0a7bf0)

Regressions Summary
-------------------

platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-36-g43195d0a7bf0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-36-g43195d0a7bf0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43195d0a7bf01be6e7ccb304f06ab7bf43737f85 =



Test Regressions
---------------- =



platform    | arch   | lab         | compiler | defconfig        | regressi=
ons
------------+--------+-------------+----------+------------------+---------=
---
qemu_x86_64 | x86_64 | lab-broonie | gcc-10   | x86_64_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619013497937abfdcf33596f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-36-g43195d0a7bf0/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-36-g43195d0a7bf0/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619013497937abfdcf335=
970
        new failure (last pass: v4.4.292) =

 =20
