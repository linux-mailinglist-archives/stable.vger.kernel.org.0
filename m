Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0D647523
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 18:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiLHRuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 12:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLHRuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 12:50:22 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A8D8B3AE
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 09:50:20 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y4so2235362plb.2
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 09:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8IMuFFio+3hXWiRYVrCsGLP2isTTpP3iBOZ2h3jrkVE=;
        b=ANkgDXyXbvpa0ob8a891DuO/PU7Qdo59bOxOXm6CZp6fP37V+GIlWb8Ath30hjNRt4
         4L3vHt38pWA13gvt+KXRR8a1ph1houUkYUMeq3+02GBcSoWB4RvI83fF25NaeoLh9gz1
         kglZcSkgURnqWB/u7T5SgOIXwHr2mTBeOH3YbIG5nkhdWOqCBpIjRwBwYvgxlaJpYz6I
         Mm67led1/PKHknFmvVST9GM2ZLSHYx8OgzlzYUMUlikSkwbptBq/7W9I4+WRq/PB9x35
         OOidnBwdegT0Xk6xAdlg+F57Trj8HyCqvuT5XT2St9gk2TCka5xuygnj/TjtCkBt7PIc
         EIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8IMuFFio+3hXWiRYVrCsGLP2isTTpP3iBOZ2h3jrkVE=;
        b=gpXH13OTgDvTUkYvPNwHS+xuby3KTs+//Hz6KF7nPTbc1TSxXM1MXfoChztFbQntrL
         q9pfUlXTWJ57ZRI/WT/eV8rk1g9pJHPRGYYJcPDI5MK/ONZwke+pPdUWY96sdPAEIYUt
         +h6N1ADwrvr7+Oq6VusVEEQIhRSt9FRePY+dZQz9wFQoB3Jnrujk7/XOGyhAp0blb9+W
         V9awDptYmwqiKTTG/CJij8nALL1mnvfKngF6Gssa+koUYGizcZWBHUqShJlo2p06f9Jh
         gaJSPj0iU/zRadSy5CRoqjnbadjKGAXpaO5eyPHFRzeLqPKMKbvorR+vFVGW2IH3HJoq
         AFvA==
X-Gm-Message-State: ANoB5pkKFtTNPWZyW0pgOQoheibvMeTV5Wx8TdRLDCDgDHv8Lb00bhJH
        ARnHfkcY2BjtN0hIoTu7RMRXkecFONuawgAnybJ/nA==
X-Google-Smtp-Source: AA0mqf5tbLyfCrxoqZ1Szu0V5D12eAUfATr94J541jfHcTTWkSMbial+tMeSGenMmB9+WiC6Ub491g==
X-Received: by 2002:a17:90a:af8a:b0:20d:bd5f:cec8 with SMTP id w10-20020a17090aaf8a00b0020dbd5fcec8mr2913285pjq.24.1670521819930;
        Thu, 08 Dec 2022 09:50:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv14-20020a17090b1b4e00b00218fba260e2sm3140234pjb.43.2022.12.08.09.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 09:50:19 -0800 (PST)
Message-ID: <639223db.170a0220.66b0e.6760@mx.google.com>
Date:   Thu, 08 Dec 2022 09:50:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.82
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 155 runs, 1 regressions (v5.15.82)
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

stable-rc/linux-5.15.y baseline: 155 runs, 1 regressions (v5.15.82)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9790301361c52921c6e5bdf155fe0d3bf7a207d =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6391edb67a1c134ed82abcfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6391edb67a1c134ed82ab=
cff
        failing since 209 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =20
