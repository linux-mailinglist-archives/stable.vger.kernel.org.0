Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5C71FD9AA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 01:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgFQXfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 19:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgFQXfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 19:35:19 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A7DC06174E
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 16:35:19 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id e18so2033612pgn.7
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 16:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HC/z4QR54GrluOp7JWF7E+WqrSgsYR6h2PuClbEVWgM=;
        b=qp1jhKr9vMAcZSwuFjYVvqGw1V0oXvegYQTekoH/hbXhd86UCyEdnoI63Nddn+f2S9
         yqu1mKJG5FsqKBPfCRUy4rny1a70ekYFF50vdLobwoZBk/xUPa4tmtq1cPka1Hjrm4Tb
         2Tuj3ctQSCr991pSwMk/xHlXor/LqLShwMaNKI6B1f6pDfLKSLyRS3hfS5guOtplQclj
         VggxuCnmvEFLxzXRBLTwHKTwUslgKSZaKKjdTshf9D5Ubr+oQrex/K5RLsU91rEBmuL5
         DJW0M7AuxNJ7JdIn1b+XdOZgSqYv7gLd9OI1fcSijgn+KPyhSEdXqLAvWmPFL8NaLZox
         pFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HC/z4QR54GrluOp7JWF7E+WqrSgsYR6h2PuClbEVWgM=;
        b=pyYG5QcdbbGFTtKd6wAVzn6w/7WAhFYnlrvecoVBuFzZaW/ZFCMOemPwqgvzCXfnSy
         I87sn6Ic3jPJLHwcn5ioks//JKgDIlDSq9Qch0FM/Y+VFzG7f438ImURZXLR57N4aa/n
         4W2Rqm8bCDIu70kw4a7//4j8vR8FGGyACpeT5V7LXQh2S/HIl35j49lbDCXRJcU0Hq1H
         ZytxcWE2Hxt0+tUQ4wuBCruQPiC3TIjL0IcSna1p8Bahm3qHR/x0VeV0dx7A8TJng3OW
         CNBwF9IgTPJjMNzVNnNJ3epV4kk4Ezr/TWe/7XlqLun/YbkYYgySVJbRIYqZvJct8R7V
         KTDA==
X-Gm-Message-State: AOAM5322kM4tftR6PAbxPb7smXxJ0MW2XIgtSvhJupRPNF3NhbGbhPPU
        Y9e4+H/U3ENO1bg7BCprrR+RpDlJSk0=
X-Google-Smtp-Source: ABdhPJyDPklrrDqAv83paTn/r5hNfRLKqAcMbbi0zcnLqBrOi+XjfqhMx57PybrfcidAKdKm34E0dQ==
X-Received: by 2002:a62:7712:: with SMTP id s18mr1083911pfc.145.1592436918302;
        Wed, 17 Jun 2020 16:35:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 63sm856074pfd.65.2020.06.17.16.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 16:35:17 -0700 (PDT)
Message-ID: <5eeaa8b5.1c69fb81.e38a4.3d5f@mx.google.com>
Date:   Wed, 17 Jun 2020 16:35:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.47
Subject: stable/linux-5.4.y baseline: 57 runs, 1 regressions (v5.4.47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 57 runs, 1 regressions (v5.4.47)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.47/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fd8cd8ac940c8b45b75474415291a3b941c865ab =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5eea74903bdcfa582597bf09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.47/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.47/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5eea74903bdcfa582597b=
f0a
      new failure (last pass: v5.4.46) =20
