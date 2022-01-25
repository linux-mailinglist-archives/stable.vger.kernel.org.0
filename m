Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35549AF9C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 10:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456714AbiAYJMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 04:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455350AbiAYJE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 04:04:26 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5FEC061361
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 00:48:15 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id 192so15613782pfz.3
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 00:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31zGrxF8jlXSNUyEK0wv79YQxHNEqLs0Po8K/o45nhw=;
        b=6gMFRUo5wQlk4Z3crWcMIlLUUkL3Zg2lHIqbXgD8SDN6nbcr9tFUnDnUDgT4m8sVFu
         WFCzZ4cJhQvOFgm2jxyiD2Bq1j4yzQ9oYCBeTtr3pPcEKjx6OBZcYfBmexmXP1c6MEJ5
         7nX/jwCIURiDtjISHjo7G5DqRyaqg7Z9Q7JEbM0zT2WHrqGoDkx9bVTWS6o9itHOn9oI
         /c5gLSSnDd7LGDenSCxWxE6dnyhnHINFb4h294ybzwIOdqagSg825RohMEAdC8xRKOSk
         /74vXbtqMZJQlXoUh9+k3LDV6O5G9ygLHg1fgPQzLXG31LSJTDpzpzW8av0mHQmKoN/f
         7hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31zGrxF8jlXSNUyEK0wv79YQxHNEqLs0Po8K/o45nhw=;
        b=bHKpGtpgl5qFDoX+1Kxom4EQVT7V/NRwz0z96G2kPwnfwxR8qW3Q0llAG5ZjxlHmL4
         grszQ6GwXZmG54byZGCPGiN4092cZBvW+mErvcVwo5rA5R58vYZRJijM5EV47Goz6k62
         Kwe2xxW3DcFgJMl8Td3Z2WrqMGB5TP4qgPxcM1zaYI2mlJTR4p6IPmpLjJO1GzXWgXd/
         086HNJmWAVJ7etNmPNzZ9CDqo4H48bE14K7nuYMsQNZ3KoE0eM48PiPaCMd/+ZJ90SBo
         fO8kVg6u/2nXS79zUCn32FDkXJJCGA91vDfAGJFTywXu+JBWshDpnTCCWqeCj1OalLxC
         /77w==
X-Gm-Message-State: AOAM532A2ZmLNCZaBJdUYTaisYW54mDNniHfz6pfod4GH5rTStLM5lSw
        ENBnXRWBYb7ZcxdfKLzgiArvFJ+JE6qCD7eQ
X-Google-Smtp-Source: ABdhPJwKACPTC99Rf602XsEW60HfD65pXiAEinJN4wV6Mq7W1tiG6z3TRjisOxWVv6pM+10vKbuQUw==
X-Received: by 2002:a63:8a42:: with SMTP id y63mr14702937pgd.251.1643100494447;
        Tue, 25 Jan 2022 00:48:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 4sm14170368pgq.23.2022.01.25.00.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:48:14 -0800 (PST)
Message-ID: <61efb94e.1c69fb81.23639.747e@mx.google.com>
Date:   Tue, 25 Jan 2022 00:48:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.16.2-900-gce5c422ee966
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
Subject: stable-rc/queue/5.16 baseline: 164 runs,
 1 regressions (v5.16.2-900-gce5c422ee966)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.16 baseline: 164 runs, 1 regressions (v5.16.2-900-gce5c42=
2ee966)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.2-900-gce5c422ee966/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.2-900-gce5c422ee966
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce5c422ee96652f2c6f1005d91a549a0b2cee2f8 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
imx6ul-14x14-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61ef83150ed7e9838fabbd2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-9=
00-gce5c422ee966/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.2-9=
00-gce5c422ee966/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6ul-14x=
14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef83150ed7e9838fabb=
d2e
        failing since 1 day (last pass: v5.16-66-ge6abef275919, first fail:=
 v5.16.2-847-g4e4ea5113e47) =

 =20
