Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E245D18A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 01:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243273AbhKYAVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 19:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbhKYAVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 19:21:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475E6C061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:17:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so4189239pjb.4
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IUpByBe73s3jKxnnG7CgNaB2nE30Q6hKdgfGMrnAEbs=;
        b=zvBnHhluDBkYIDPQBRMe+OzpWGSURYmY6t/3Stx2kAW6oPaFhlRcnPtFhkKaJm9WYO
         Ec3Hzra5RYBdGGFTYwrMZ7JLO4we6p8egQ/Z7SwrgS5sBO04JFfV7pCBdGPSQaT0cgLq
         5V9VtJq2i/uWbAFGnGXbWotjTItabZMJkSwiPIY5xooKhbXbGssi1JkK/hwi7q49gfn/
         gtICdKq8kkXRSI4JvZdhAc6FY/QOGXZwWocyEWkMsSvwiup2BPAizWLTtF/5MoT7G4ar
         2e2hJFZr2H4fTG1VHvgxRCFxD96I+++rTw9P+ABr/o2Frs2RqrXPJfRnHNc19XA7u9h9
         yCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IUpByBe73s3jKxnnG7CgNaB2nE30Q6hKdgfGMrnAEbs=;
        b=jCmqwGZoJvMAmVKUk7CotiJnCy48tPzTMD6kopJXlnKx31Lw+FFYcXaPa5e3w3rJ+v
         ZKiVcJxpF6kuvt2L5mXtTEAwawoRTrFHt5zGLUxdbrUw3FgMPw/67mmiQqmvlN603JcM
         knJBytuz5aP1ExlOZgIv8R1v8NtW3q00XEnkpf5OKHbTflD2ywv5+o56Sk+03T8McuRJ
         leu9+zJ7og3TmGO6qpcd5AL3Jv12MZ+RCBQVfqW6ApXeRVEOLSuwhyeGCznhIBH6DBlu
         pUb+T6+DwiEjUWtq1KFU4dvbY1LC5U2ne2hEOZYWOlg8lY8J2f5XJJ+Mle2La5SDdUZK
         SNJg==
X-Gm-Message-State: AOAM531zExonxlbKOgC1ji8A9dKtqoycQl1uwm2bnEuL3w8azMxfwDVP
        yj6U//2D9Hu+QqlLFm9CGLGZdB8XuQo6u8qAdaY=
X-Google-Smtp-Source: ABdhPJwNnibSaPd17vQnWnGWszk63tHUVd62xmG8T54BvxlMphqMdZKuUw9VufnunhTFFmc0k0EtmA==
X-Received: by 2002:a17:90b:3e84:: with SMTP id rj4mr1455568pjb.199.1637799474698;
        Wed, 24 Nov 2021 16:17:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e10sm889700pfv.140.2021.11.24.16.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 16:17:54 -0800 (PST)
Message-ID: <619ed632.1c69fb81.8e908.3be3@mx.google.com>
Date:   Wed, 24 Nov 2021 16:17:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-248-g11189523779ca
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 131 runs,
 2 regressions (v4.14.255-248-g11189523779ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 131 runs, 2 regressions (v4.14.255-248-g1118=
9523779ca)

Regressions Summary
-------------------

platform  | arch  | lab           | compiler | defconfig           | regres=
sions
----------+-------+---------------+----------+---------------------+-------=
-----
hip07-d05 | arm64 | lab-collabora | gcc-10   | defconfig           | 1     =
     =

panda     | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-248-g11189523779ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-248-g11189523779ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11189523779ca3437d8fc8335e933ed526267411 =



Test Regressions
---------------- =



platform  | arch  | lab           | compiler | defconfig           | regres=
sions
----------+-------+---------------+----------+---------------------+-------=
-----
hip07-d05 | arm64 | lab-collabora | gcc-10   | defconfig           | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/619ea01350775939a3f2efc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g11189523779ca/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d05=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g11189523779ca/arm64/defconfig/gcc-10/lab-collabora/baseline-hip07-d05=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619ea01350775939a3f2e=
fc2
        new failure (last pass: v4.14.255-249-gfe623ad09382) =

 =



platform  | arch  | lab           | compiler | defconfig           | regres=
sions
----------+-------+---------------+----------+---------------------+-------=
-----
panda     | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/619e9e2c37bbebc6fff2efba

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g11189523779ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-248-g11189523779ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e9e2c37bbebc=
6fff2efbd
        failing since 5 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-24T20:18:28.781645  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-11-24T20:18:28.790620  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
