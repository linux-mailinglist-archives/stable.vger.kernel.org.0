Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8D626E6E
	for <lists+stable@lfdr.de>; Sun, 13 Nov 2022 09:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiKMIDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Nov 2022 03:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiKMIDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Nov 2022 03:03:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05F313E35
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 00:03:06 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b29so8411864pfp.13
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 00:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K7ryhmFLoB8vHxoTUKTf81tnbyhgjHXEAtxxxVPcCrA=;
        b=pnP+lSGfB6g5UWpZzo7xfGXRaaoNbziC7gVSJgRWXIvQs/ehtzeuQh9CQJB1/zeN0u
         VKYl/KscLOAlrfK2n39ddseu74Dz6xBEnvln+UAf6+vxexSmOED13mkVF/u4xeaU/Aiz
         JbN4xa3Y0CQZnW3mjGqAEQwNg80QynwkutyxWJS2tesOjfbgvMb7g5ZC6/82iiL+1jqB
         rDHurVEuLrCAHJxLutRceIomkx4sDy+buBKktG9E4ICfqNf6kM8KyuFXcMKYjxw+r6VE
         0TLY+yHLnGdEFu7I/FhuYl9g1pDsJDfLMgof+mstytN3vwLmsGpwszTbJ3G7idONyAvZ
         03kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K7ryhmFLoB8vHxoTUKTf81tnbyhgjHXEAtxxxVPcCrA=;
        b=7m3lp8NoLGiDagaG2oTRtqhsipVvuHED7hSEX47+wQVtVV9l95WQAe5Oxo1VFcgfwX
         KQgpnbEytPF+b9G4L7awelF6/JC+f0oi/kdKcE+R5OXXskMizAOg+6fyrI8KRRHYHjFy
         h+L92hwYCcCvUlOcOmEy9vFTIyp4lhnrB13o4TP3BIUVHAjZlWflvtmbyzO6wktOe9Oj
         2CGS1vmz90HCN8oUsDsambBBuXE6UeOmLfjsTRKNXsdjqevg3wUif8gJB7Caz2qn1f7E
         2wvM0CZzYpjcvLLeoN1Nj+cmdMqMt7IP8JtCc7FK2X5Nm3TDO9k+DYqsBEs7EFwOhQgZ
         8Pvg==
X-Gm-Message-State: ANoB5pnUlWtWPahsSBFZtX/8/TAFtndZgZ2KU3XBGtYX6jBJDaW75+u7
        5deq41eX3M4zxaZkWNuWcLubNx3ntBsU3GxXoug=
X-Google-Smtp-Source: AA0mqf5UTqK5KetjSXqWLs2HTmeLOY8RsiXUpbtKQl80wMd5FbWk+FDfgJc646DTIwqvN4lBy7Vdgg==
X-Received: by 2002:a63:f1e:0:b0:470:88:8c18 with SMTP id e30-20020a630f1e000000b0047000888c18mr7815481pgl.23.1668326586166;
        Sun, 13 Nov 2022 00:03:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b00180cf894b67sm4724034plk.130.2022.11.13.00.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 00:03:05 -0800 (PST)
Message-ID: <6370a4b9.170a0220.3777c.6afb@mx.google.com>
Date:   Sun, 13 Nov 2022 00:03:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.78-6-g2127e10a18b1
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 157 runs,
 2 regressions (v5.15.78-6-g2127e10a18b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 157 runs, 2 regressions (v5.15.78-6-g2127e10=
a18b1)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.78-6-g2127e10a18b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.78-6-g2127e10a18b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2127e10a18b1c44f41048bfbce30f351f62b2062 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6370712edae6d036c8e7db58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
6-g2127e10a18b1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
6-g2127e10a18b1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6370712edae6d036c8e7d=
b59
        failing since 48 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/63707426067a9fcda9e7dc95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
6-g2127e10a18b1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.78-=
6-g2127e10a18b1/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63707426067a9fcda9e7d=
c96
        failing since 48 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
