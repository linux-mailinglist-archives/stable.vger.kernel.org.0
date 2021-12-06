Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EFA46932D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 11:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhLFKLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 05:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhLFKLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 05:11:40 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6159C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 02:08:11 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z6so6729662plk.6
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 02:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uFUbLX0ITrOISGU+EqsyUl8DsZmc3u13d7rUc/vE7IE=;
        b=YCSc2Q5CtRLS4TLdn/wyu/pLm7aDFTFzRzUzgjMrwjboNpWQDPCy8V3/xVb9IsgYOx
         zugujKWBuoHZ3XvJ0dFk5Vu7aRufz5AVPMHbfl2TqBDFAcs7WnIADpZJRQ/iQ/pIW5lS
         gXWMq22upBgBPkkj9ywjn4BDVCZXhLTxlYrHJZhsENIxd4xxme/MVUD6bcDIXDEwQ5Qv
         FlvbDzkn7Lp5Ua6zdUKxEbHSMw73PdUD88W5BkwR4OGQYOl2phidch/6A5unLHS77CmU
         7shY1YoDfKHF+Br3mETvdTR5c0lTGrg3UaDR0gMHqaGXiS0efrtIrFtFjJBrcRvXn9yC
         vidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uFUbLX0ITrOISGU+EqsyUl8DsZmc3u13d7rUc/vE7IE=;
        b=d9pFS6WDmANJxS14ZQbUqkBpOAeUl2rGmcdsZKLguM+KqJm4TxpaVWMPn7t+EaK+SN
         qK+LgB31SXnDG7jTd6D4GdyX2qtQV0rDqpnMFDQuLZrMvdTmFcUXXEdeXA4U1jIT+CRa
         w+DVD322auz4M2WuKl1UEatoiSyn7vmY8CjQc1/jvwoogPeWXwwc4XhUpKbkw3cq70Bt
         wqgRQcQIfgvMMehiMbbP5amzJoc4Vmd/263CoR4P3xZKnwyrSytv4KzF3Di/CIdnuDOO
         0Yp2Tv73TmaJjk7BoPwZZjeXHwm4JfhNkzfJW1RLFWbjETZJsyCugDv45WJvZI9mTJFX
         7Bfw==
X-Gm-Message-State: AOAM5327uoBoAv2eEJWV/SfPfqBo2paa2pUqR5x5R+8oVGt7Zz5Cvt2O
        PcMw2E+I6WVdmgX+g6WOkmBEfhoxupQzHEon
X-Google-Smtp-Source: ABdhPJxk5JRq8GnGZX3fPpFi+Vma/nq4A+fFEB1XJqlPmcHXplxngguApoaQn8uMaWdjoOZThO4x3A==
X-Received: by 2002:a17:902:e5c9:b0:142:53c4:478d with SMTP id u9-20020a170902e5c900b0014253c4478dmr41578213plf.33.1638785291326;
        Mon, 06 Dec 2021 02:08:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm12760900pfc.51.2021.12.06.02.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 02:08:10 -0800 (PST)
Message-ID: <61ade10a.1c69fb81.abfce.34d5@mx.google.com>
Date:   Mon, 06 Dec 2021 02:08:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-36-g0ade2b16b7cf2
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 2 regressions (v4.19.219-36-g0ade2b16b7cf2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 123 runs, 2 regressions (v4.19.219-36-g0ade2=
b16b7cf2)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-36-g0ade2b16b7cf2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-36-g0ade2b16b7cf2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ade2b16b7cf2a90f8a7120e39f2856bd46d8ff1 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61adacb418af1cbc631a949d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-36-g0ade2b16b7cf2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-36-g0ade2b16b7cf2/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61adacb518af1cbc631a9=
49e
        new failure (last pass: v4.19.219-36-gd334ce8fcda5) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61adace22586f5e9bc1a9483

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-36-g0ade2b16b7cf2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-36-g0ade2b16b7cf2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61adace22586f5e=
9bc1a9486
        failing since 2 days (last pass: v4.19.219-3-g91f80b6b7a49a, first =
fail: v4.19.219-3-g04afdf3600b5e)
        2 lines

    2021-12-06T06:25:11.961817  <6>[   20.971405] [drm] Cannot find any crt=
c or sizes
    2021-12-06T06:25:12.012792  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-12-06T06:25:12.021901  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
