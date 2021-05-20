Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C554738B762
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 21:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhETTXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbhETTXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 15:23:05 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360BDC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 12:21:44 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s4so8111237plg.12
        for <stable@vger.kernel.org>; Thu, 20 May 2021 12:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KnRMx2lR5NYC3Fixbo8IpzkLOrpalLBooJCOhRPZP38=;
        b=twgWL2rotWPWzu6OVFQb7uGu+nJzJyrKZtJQcrV3sFH/Da+YXH8d6a99eoCM3TkYXi
         S37FEpJ4rYi+TrhmgL0f9c5JT+eKK+nJksXijvv4IwzGHyNc87Qv7I9PRcS9uC5/iVpM
         ZTgfkbzx1c/elYIE2nh96Ce+zqjuRqMyvXL2PIrRfyh73Ovjf0XnFyAVPrGfLUBgX8Sb
         LpQgf67bKc0PBNeEMvFLjwyH0CDfbANSzac61y/l4aqHhtAl8+KFfphF9Tt8Sdi3EAcR
         3MQsiB0X84+z6lJNAxsdIGWrEnggzeoEPJdDB48Tkw6ejbspYzmpYc0IiYzXdOvvlSdx
         hTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KnRMx2lR5NYC3Fixbo8IpzkLOrpalLBooJCOhRPZP38=;
        b=raTWIyDy88nv1dyQNvDXaOPu9jSm3r2YDbhpZMdvgJjQqCLfp3ILnoSFmGoBBEr8k1
         jAPA0UCjmqNeT2nKfnmOVVE+afXjiKBSX6PKjIOGKW7YjQELDz36WaPJdpdclbMU6BkT
         TpoxAyDY5sQGd0DSiw11bK8Pa2GLywhpfFN9W8inFWH7Eiejyw3GEp0h6DwqQGO/Q0wo
         ORnODwgo2kIko/gbgRPJSMTYaaY/DhaHd6MuoFw8g0PDbdq6ySc84COeMwGASdhUDIeJ
         0GjiBRqKIVH5/sBqPViBazL4CExYjFCwXjxa6sMLAk414CsJILwJWBP4CP9nGB3O3M4G
         QzVg==
X-Gm-Message-State: AOAM531CcY8R6ATkiVhhLqKmyHiLpFuSHIyfbKD+ZpgpxxM65w2XJrBX
        TT6pEPdmHOTZT6xEA5oP2JrNn933mLYcTJfU
X-Google-Smtp-Source: ABdhPJzJiRfOVtH3GUmSYiontw+0kxlPap61LgWTaasDZRiBSHzKXiVHnhN80dWDuP1efS0dz3hRhw==
X-Received: by 2002:a17:903:230b:b029:f4:b7cf:44aa with SMTP id d11-20020a170903230bb02900f4b7cf44aamr7651463plh.31.1621538503561;
        Thu, 20 May 2021 12:21:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g13sm2666534pfi.18.2021.05.20.12.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 12:21:43 -0700 (PDT)
Message-ID: <60a6b6c7.1c69fb81.e842b.9543@mx.google.com>
Date:   Thu, 20 May 2021 12:21:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.268-191-g8605df0345a8
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 19 runs,
 1 regressions (v4.4.268-191-g8605df0345a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 19 runs, 1 regressions (v4.4.268-191-g8605d=
f0345a8)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.268-191-g8605df0345a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.268-191-g8605df0345a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8605df0345a8fd9ef9fe1a1d3d765e66e3261561 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/60a634109edbdc5ccdb3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-191-g8605df0345a8/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-do=
ve-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-191-g8605df0345a8/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-do=
ve-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a634109edbdc5ccdb3a=
fc2
        failing since 21 days (last pass: v4.4.267-33-g78d632f91b0e9, first=
 fail: v4.4.268) =

 =20
