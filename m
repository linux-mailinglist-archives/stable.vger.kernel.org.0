Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592CF2A9B59
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgKFSAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 13:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgKFSAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 13:00:36 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A55C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 10:00:36 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id w4so1498813pgg.13
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 10:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qZBvbeUAvw3T7dOFfDFhVNa9Hp8qtWMUKx+8VMHfUiY=;
        b=r5MxCI4/CvsSAuGXtlvJqddEp99dwWlcuZKtHDcO9Jg584Hl5z88+EPfEEW+SgpKJK
         69dlh/l9FUC026Sy59mQ1S8Cfk1rYHEuTmxfgNR9cVesIROslbGyUyjHayJlJLAzWfWI
         Rqc8E1Ke+UaBm187H97ojEqh8gHfCTjPmtHDVnyCuSO2K7BvgCUuuXOFFhMTn/yfzb0E
         u7PEbEQwvtXwqhoktnMjp9+9CCDPOKXyOzacqzcbS/dIZ8/Ai8v26/ZyyKhMHPieEJGa
         bGx3c5UBSMZAzbuRHlCatFYBSgkP0Hi9YAKIXI79UJGa55iO617knOKl8cQPNHC1ECgS
         WWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qZBvbeUAvw3T7dOFfDFhVNa9Hp8qtWMUKx+8VMHfUiY=;
        b=sh/5CfPMAzOadvpf2OL9zs1T+MM9v2x5iIeddVDVORszBhVoQ24e+2ZkMb8CP62ite
         8I6brSTRIj6PpXIeP6X/EQrwICgcv4xuyOL8RbTfHi3mHW+GyEpja3EGolUsAf65YoXG
         dDfj+LYea6ARbBOXpgx/qCk91dZxnDdqpT7ouP9CRLbj4WtgoEbWozDKnWoNwM/M6A7p
         sIDabJpwIDFTxogWMZkaRNhJIr+4NwxNHqWtjxmEFMqAltqn+IcTg5fpRMx4yvjrBM3j
         i/5WfKM+VUNvb/jAMmiqk7u3DG+7urw+EXV/Hjsi/o134GFnuX1DD4r+YhmDDy6DLbFv
         k48A==
X-Gm-Message-State: AOAM530wJ8GW5Qh9+49WsOHpHsgvmLfJ2ePMX3yecl11VaO26FytYRbD
        jtGmlo3Rad946JjxlHE9qzzDwEZN61qrRw==
X-Google-Smtp-Source: ABdhPJzWkwnAlVkwXcTudyoKRaXZ2nvsoTmC1nF7dwHWO+/jWe0JFK8pu6e4/RjUxjWWCWR/dv8TEQ==
X-Received: by 2002:a17:90a:7784:: with SMTP id v4mr803697pjk.60.1604685635801;
        Fri, 06 Nov 2020 10:00:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1sm3451244pjq.20.2020.11.06.10.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 10:00:35 -0800 (PST)
Message-ID: <5fa58f43.1c69fb81.d0925.5bdf@mx.google.com>
Date:   Fri, 06 Nov 2020 10:00:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-93-gd72fda650314
Subject: stable-rc/queue/4.9 baseline: 145 runs,
 1 regressions (v4.9.241-93-gd72fda650314)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 145 runs, 1 regressions (v4.9.241-93-gd72fda6=
50314)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-93-gd72fda650314/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-93-gd72fda650314
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d72fda650314bad8a108f72e4e271c56603b7e7a =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
regressions
----------------------+------+--------------+----------+-----------------+-=
-----------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5fa5561f400ccdc2f0db8894

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
3-gd72fda650314/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
3-gd72fda650314/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa5561f400ccdc2f0db8=
895
        failing since 8 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =20
