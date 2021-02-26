Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3970A32666A
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 18:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBZRoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 12:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBZRoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 12:44:17 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91071C061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 09:43:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d11so5669328plo.8
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 09:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CJXPxJknwWabk3O+i/PIOedlhgUSbEWWoc+zn0TwSY4=;
        b=KqXwh86OyzhyxR+bROReiynSj4leT6k05lrdlbgMFVGw+eELCpIUSKtO7BS15MdAR9
         t5iPwWD2bIMmyArUJO9eMTT7ddTF9qJgJDOB3AlIPuofeUI7w+/PyGB1BL/OtoKNZAM7
         nSAR5tOB9sDXE6n4ZBnjceb2nPgBmIge3E/JVdfbUQPj7OKSVnWXzQ8a9Hs4sGLIloKo
         PLvX/R0cHFCytcpHEsE6k6e3BjG7OJHiPW7UNJ/OaP4aN2wXfjkrZzCMenNIwJ1qe3Y4
         U76FWS6m11YrVCor8iVLYpf5EcE+/5Vt3LdKQvOr6NcoZyyF+zhiFoAKcHdsZBrpQnif
         /dEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CJXPxJknwWabk3O+i/PIOedlhgUSbEWWoc+zn0TwSY4=;
        b=f9Ec09snNAQQ7caArIgFpyoCPUh6RdI4N45qdZeeH68S0qqcyiJwhAMpgr5qEjl4+1
         yzMkUHbpq4SyPAoH158fGTsCofzlxzXVemyf5rPuBaMqvGYD03c2wIfCLaTXcomRwVLZ
         m8UeW1AO8OYH2hlY1sY37OWy3DTW5qUdUXu2vI3oC9u0jIb02bQl8RnGUu98GCeFBsP7
         533kunJw+f6ZUzkmt7+GxcObT/aVfA1H4igeTMPaQHVskTlU0wTwd6oFwXwb4W0OG+zm
         0EzJ4kE3pLeYYCXP4MO8SMOHJpvQK5yWozb9BvAii1aqSSbOOOEy92mJsaIkkZTS23Jr
         8ePA==
X-Gm-Message-State: AOAM530PSKlDfBtfWn9hV3coJUeAhvAuOVqa02yIJAyc2cQDf0Wv+nkG
        Vqhjpu/iUkreDmkXglt9rsgz2b4S6kwYxQ==
X-Google-Smtp-Source: ABdhPJxv0JQ2cJ3/gwHmQZ5HoWcwZ3/YLX0bPjTNYsFz8ZC1lYceluIkl3RO+7mkucpEMFu/cw+GOA==
X-Received: by 2002:a17:902:6ac1:b029:e4:6ec0:92a0 with SMTP id i1-20020a1709026ac1b02900e46ec092a0mr3995184plt.16.1614361417030;
        Fri, 26 Feb 2021 09:43:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm8904519pgb.10.2021.02.26.09.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 09:43:36 -0800 (PST)
Message-ID: <60393348.1c69fb81.79a48.3ef9@mx.google.com>
Date:   Fri, 26 Feb 2021 09:43:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.258-6-ge88d12b1c729
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 35 runs,
 1 regressions (v4.4.258-6-ge88d12b1c729)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 35 runs, 1 regressions (v4.4.258-6-ge88d12b1c=
729)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.258-6-ge88d12b1c729/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.258-6-ge88d12b1c729
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e88d12b1c72992769001d6d9a64afc73ec0169e3 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6038fb5bfd264a84a8addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-6=
-ge88d12b1c729/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-c=
ubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.258-6=
-ge88d12b1c729/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-c=
ubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6038fb5bfd264a84a8add=
cb2
        new failure (last pass: v4.4.258-6-g8319244df84e) =

 =20
