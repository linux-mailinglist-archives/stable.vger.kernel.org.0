Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7059A26B940
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 03:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgIPBOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 21:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIPBOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 21:14:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E826DC06174A
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 18:14:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id kk9so677249pjb.2
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 18:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3U66xLRNytDZMUmlftim0ObH08RH0bQT3OhvecJ2oKA=;
        b=pB0TPkosqdFX65slCF4GUWfJJpIQfO6jXdqEd1gCBE3Jhcr8DDqQJK/W44/qXGg7h6
         TaJ6y/q6GjvGNBVRgiEqk86cvEO+s9QES1wGqlAaM7873YZzC5cjvAfFpwbGB+N6Y2sf
         0Q7RH2yq5AbHGlz+unLjiyatdBzH4j16d69NWJPLGaLU/s/oAYYLnS3/9AM8KQpGR4t/
         1K17A0QnyzsT5UlIsUMA8plF0n+qotQn+gR65CBXTsgfYfpypcjmuGbUU3yHtjMkUrO5
         iEfcSuDfznSfx7VqGmuIdRNpiSNCiYQa7+nVWGQKzKRXSgyzY5CjC1TRu8VnRJ9apsWE
         Mujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3U66xLRNytDZMUmlftim0ObH08RH0bQT3OhvecJ2oKA=;
        b=PNKwCu1qeYDCbUmFigNPBeWT/q3bmvSKHaqX+xUE6Hgp8lz3PGfihza4Tqm7OXeIzS
         JH7/KRzC5G/JPPo81+Fv5VR32EASf2jDyVPYco9LcqusBhzlMqjj2nP9e+7KY9RQJRyL
         CcsfLIQT37JSpaoF3BRq7eLViYnuYtXj2GFuynxRqGfLcb76zPCKbLj7+3vePPuyib3R
         GmEIwksMa7HUdlxgsz+X4J/4vwgO4b/bF4K329ZkLk7wF52dmT8GORSmDv1oWclcDfIG
         BVSRXmzPfkr8QTQ8EsHR5cGsUAwsDlFfzITuN4z1MEyGj3yaDpcu/QCf3K2J0DSILb47
         FZXA==
X-Gm-Message-State: AOAM532/kf1W6TZ54N/ncHCzcKOgeWL2MLGk04uzWm3kJooGs/ROtd59
        UfCf8ro8X8U29JDHBR1JnG2mgzaJ4N34/Q==
X-Google-Smtp-Source: ABdhPJya/pl+bTTH34l1eKdbqPAJlCfmG8OapETO75HgoqDDUwNNyJMUY5UYBdm3Yi1LabSmKc97vg==
X-Received: by 2002:a17:90a:e207:: with SMTP id a7mr1862310pjz.117.1600218840268;
        Tue, 15 Sep 2020 18:14:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l14sm645478pjy.1.2020.09.15.18.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 18:13:59 -0700 (PDT)
Message-ID: <5f6166d7.1c69fb81.50914.233c@mx.google.com>
Date:   Tue, 15 Sep 2020 18:13:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.9-178-g337aafeeb4cd
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 184 runs,
 2 regressions (v5.8.9-178-g337aafeeb4cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 184 runs, 2 regressions (v5.8.9-178-g337aaf=
eeb4cd)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.9-178-g337aafeeb4cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.9-178-g337aafeeb4cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      337aafeeb4cdb1868fff6b6689b715ff376249a2 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
esults
-------------------+------+--------------+----------+-------------------+--=
------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 2=
/4    =


  Details:     https://kernelci.org/test/plan/id/5f61333c3db5b1f87ebed9a0

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.9-1=
78-g337aafeeb4cd/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.9-1=
78-g337aafeeb4cd/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5f61333c3db5b1f=
87ebed9a3
      new failure (last pass: v5.8.9)
      4 lines

    2020-09-15 21:33:36.092000  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 0000000c
    2020-09-15 21:33:36.093000  kern  :alert : pgd =3D ebef074b
    2020-09-15 21:33:36.093000  kern  :alert : [0000000c] *pgd=3D00000000
     * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f61333c3db5=
b1f87ebed9a4
      new failure (last pass: v5.8.9)
      35 lines

    2020-09-15 21:33:36.096000  kern  :emerg : Process vchiq-slot/0 (pid: 1=
02, stack limit =3D 0xbf351219)
    2020-09-15 21:33:36.097000  kern  :emerg : Stack: (0xc43f5e58 to 0xc43f=
6000)
    2020-09-15 21:33:36.134000  kern  :emerg : 5e40:                       =
                                c43f5e74 eb202018
    2020-09-15 21:33:36.135000  kern  :emerg : 5e60: c43f5e84 c43f5e70 c014=
e740 0000002c eb202020 00002001 eb202018 be15c09a
    2020-09-15 21:33:36.136000  kern  :emerg : 5e80: bf077bd0 c4314580 bf0c=
3540 00000000 00000002 eb202018 c43f5ecc c43f5ea8
    2020-09-15 21:33:36.137000  kern  :emerg : 5ea0: bf077648 bf0c354c c414=
b200 00000000 bf07d000 eb202018 00000002 bf0775c8
    2020-09-15 21:33:36.138000  kern  :emerg : 5ec0: c43f5efc c43f5ed0 bf06=
e840 bf0775d4 c414b200 00000001 bf07d354 c414b200
    2020-09-15 21:33:36.177000  kern  :emerg : 5ee0: eb202018 00000000 0000=
0005 00000001 c43f5f7c c43f5f00 bf07227c bf06e7dc
    2020-09-15 21:33:36.179000  kern  :emerg : 5f00: c08743ac c0141780 0000=
0000 00000000 00000000 be15c09a c41afa54 c42692c0
    2020-09-15 21:33:36.180000  kern  :emerg : 5f20: 00000004 be15c09a 0000=
0050 eb200020 eb202000 00000018 eb200194 eb200194
    ... (24 line(s) more)
      =20
