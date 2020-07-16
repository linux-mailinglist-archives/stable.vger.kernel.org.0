Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5E222A15
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 19:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgGPRjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 13:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbgGPRjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 13:39:46 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEC5C061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 10:39:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id p3so5205941pgh.3
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 10:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o0E263+4HOoW8Q34n6CVMJeroXRrUTUukO86kHC4hrQ=;
        b=eAvYemFvYAw0uirmZ1rAN0hIN2uaJazCAQCsVLcH+lReTqhYmFs8L7+vz9iw91oKda
         YeuWmuzeMANaspLOXSTEsc282blWQ3/aEHlol2JvZUgFTS6b9aL+c0XE0XLSNycZcJC/
         YRh11mjh9bx+xYka4sPGw/IhcS0TEgm5EyURXw8A+WOTVa6K22gHN7w0YCkFuz0RBoj2
         SEFPS2ZOf2C7QtKtichCiEqi3gipbaGne6MiVrawnK80h9pofONUKw/mMb4lJ5ci/B4n
         qDgX9zCChKJToWDpAnkzWrPcquur8NtNCZL4CzJG1c9l5lkpwY9I6AaFphAiMV15V5cQ
         DsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o0E263+4HOoW8Q34n6CVMJeroXRrUTUukO86kHC4hrQ=;
        b=GcIDWuN2RFPY7iMuoitY+iL1i7ktproH0elDacIoNOoaxxrJOpBJ6sHLk0tGNeIZ16
         O4GuhSGMMI4Yu5gCg6TF/W1NU/BzL6JAPqTAHFlHiyNaFwN1fcpiLwStrU+QBFtbZ1Pg
         286ZxLe3uDPrqs/VGwsBKhHVNTlUKem6z9CIBI9cQ0hw4sJLqajicp9gjhxREyxI4KQs
         YrCLdUpBlQVZSSYmLecIuVNUpxwO5/he2PDbxmEFnPaEZAvcLQxnZLGddwt2ohS51b1Z
         uk8CJ4JRmXZTAxo0Kp8O/+M618waErsuQkhVfpRorrPs09Vk8AzcnRxFOfa7FMntGscO
         0RFA==
X-Gm-Message-State: AOAM531gsR6JQnyUN1+vIv0nDfRB3/tPnmtrIejE5Oh1O+QnhX64fUqG
        4RdJ3ni+Q8nrUoQXBo/AoaOm/nHw8sI=
X-Google-Smtp-Source: ABdhPJxR8rkGhvWrlECQ8jOiyHfay0rF+Ip6+yuBvkvL8XSugdMzS4Ut/ccYjpZ02WaxFGiP/ragcg==
X-Received: by 2002:a62:3744:: with SMTP id e65mr4867829pfa.20.1594921185396;
        Thu, 16 Jul 2020 10:39:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n137sm5463399pfd.194.2020.07.16.10.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 10:39:44 -0700 (PDT)
Message-ID: <5f1090e0.1c69fb81.91a1b.fa98@mx.google.com>
Date:   Thu, 16 Jul 2020 10:39:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.133
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 92 runs, 2 regressions (v4.19.133)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 92 runs, 2 regressions (v4.19.133)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.133/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.133
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17a87580a8856170d59aab302226811a4ae69149 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f10589162cbbed82185bb3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f10589262cbbed82185b=
b40
      failing since 30 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f105b56ad0117b43e85bb1f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
33/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f105b56ad0117b4=
3e85bb22
      new failure (last pass: v4.19.132-59-g4e2a5cde3f03)
      1 lines =20
