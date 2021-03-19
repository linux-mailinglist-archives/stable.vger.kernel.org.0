Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C059D3427E3
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 22:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCSVcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 17:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCSVcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 17:32:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22B8C06175F
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 14:32:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w11so3541421ply.6
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 14:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EvfxPy9gv9L7H6Z01supia7jwX4ZaL3z/Lh7KAJkA5k=;
        b=Kq7sf3ab/jiCs2OlaKVTRkllptoB7OnKdXy/1TM7yAKXOa9zNPNAUatC/+1JFdHAiz
         VBnCsZnN2Eqpr2wAbnYqN9SNKK/+DCHDL6hrt4E3sNqAcJNghcsKn4EIGrgbzyxtpWjJ
         T2c5DgFUwMXI56ntPwM4kZw5KOgWEv9IwCMKS9snRLXHovSPg7kXjS2JNAYm/UN+axcc
         Mc+S0I9Qw856v9nNK0/Amzab6BgdGiGy9XQK4NLgQSKHRXo3Tsz0lKq5kC26SCjKmlSB
         GyoZwjmxyOz2bI67UoIPZgQ0ZHe58e6mX8eeFH3xmMB+6EMD3LT/1I99N9iGq43zSNcQ
         3LHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EvfxPy9gv9L7H6Z01supia7jwX4ZaL3z/Lh7KAJkA5k=;
        b=STq1229uIQeAKoitMTIH5aaGQjq+e0tPA2YD4LrWz7ZdSTMrhjI9jlAuNqze6Sd40q
         sFOiYqWEf2IE5NK0TmKJATN6tjwgnf88hsEK5r9LZveyVHF+H0pUAwTS+PBxPZHxFF9K
         i0oyqiNu/3eujFqZTrYDesXSnKYEDrWXHZLCvsHKYDFtawpZn9BFbQn8VQeG1ISPaEe3
         /7VHbJT/VTqkVowwg6rd6SXc4zYDCNL1ObLZ4XqCIKJIvBEiOP6Y7S0cZBfbwmEZDpeo
         Db0njUJ036qcUzpIzarfgArJh5jVvxcWtvcp3LZHb51x8IV7VhHniU/g4ZVEwy0RP1yA
         4gYw==
X-Gm-Message-State: AOAM533QoXA17cmKIXqRI45L+hkAlunZwPXD+xXtCtk/a9KLtpT1KSvV
        76VgcJV0Ut0E8PxrLIq8jiw09mTg/CznVQ==
X-Google-Smtp-Source: ABdhPJw1pTArh0V+A+gIGetbqTSRJFlFP+IOSsA3nPoQ+7iT/1gQwjrL/uGt6EoBXmnFt7yMY81+Fw==
X-Received: by 2002:a17:90b:691:: with SMTP id m17mr488018pjz.191.1616189535411;
        Fri, 19 Mar 2021 14:32:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11sm6561399pfm.24.2021.03.19.14.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 14:32:15 -0700 (PDT)
Message-ID: <6055185f.1c69fb81.870ce.05e3@mx.google.com>
Date:   Fri, 19 Mar 2021 14:32:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.106-18-g7dcd48dfe54e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 159 runs,
 1 regressions (v5.4.106-18-g7dcd48dfe54e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 159 runs, 1 regressions (v5.4.106-18-g7dcd48d=
fe54e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.106-18-g7dcd48dfe54e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.106-18-g7dcd48dfe54e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7dcd48dfe54e0b852d06f48bc10e8c44b70f8902 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6054e444330b96d991addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.106-1=
8-g7dcd48dfe54e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.106-1=
8-g7dcd48dfe54e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6054e444330b96d991add=
cbb
        failing since 119 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
