Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07424391D4D
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 18:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhEZQwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 12:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbhEZQwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 12:52:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2545C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:50:51 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t11so1150082pjm.0
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AI9qJpX/Aspi1fvijPKNGSfeotzjKEElvW5M/bI2XE0=;
        b=LsF9SLO/UbO7iaCTmN1mDQRSZLQxC4koZF3aHzHiMWYuVdbuA9DnrhiJoPUzzY2RYb
         NFXldB+HGrqnlhP0OuFBe/kcWoqCzd6129GP/oZBpPfwI65UcJXz7/YNTFPodgYIJctF
         SqAv5ZsRvBi/eQuMV1YJK7Rqx7dasTwQs1/zcEPwSFL9YRQV20hnSz3sXhU6qE9pSnkF
         Y6lWyfs+WrDKKg8DDhy+gQBpa5NzQVX6lJ0j8cdzH08fAxs43otnHiSUHNrqiB98eTqK
         oVMzmG0UZLrIQ8sYP+OpBxJYwAWS+n/VYhYUCDsOL3/B5uNZTDu9msV/EA4huXKEc/3N
         tPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AI9qJpX/Aspi1fvijPKNGSfeotzjKEElvW5M/bI2XE0=;
        b=Omtc5uTR1r/ArNUKKo41xUCEV5uy8bUfyZUeHdrD7VAfqpXcZt+BZGDTnAMsLaUyVy
         F/idOfksuVUBgiPCS2jpR0YLxCbRafEV5Z/VV+wvG4NFHxJH036fr6XXj/azcDR7hsji
         UgUUp+RdS+JqchW6EokyHGfgTzMlzezEncCbJSZi29vWQvMMtR+u56J4oUpnP7AetNVl
         NDRr0D/+6F9kS7CuaC3BjqZ+AzHMETHUuPW1MYDC3XqBYKdr5+jx/S7QNQeg74EMsYHe
         ReBUQ4QOxgvUulcFVDKKskp8lyWfJ4CDwak8cv3PKkugDptNzX10np58rhn6a5QXtOdl
         gM6A==
X-Gm-Message-State: AOAM532r3HyI2nBD+t7TDsRXTRltyuakUi81tSe3lAR++Of92WYKzZ5C
        YvtzVZhWo1I/XMjFJ2XRxwwnAUYKxvQbPaRr
X-Google-Smtp-Source: ABdhPJyZFk166r5HdryTUuF6SItJJuKP3qr+TXqK3GCU74aOaEoDGwWANV21ueNs+s0TzIOebpkwdg==
X-Received: by 2002:a17:90a:7896:: with SMTP id x22mr4914478pjk.11.1622047851175;
        Wed, 26 May 2021 09:50:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q24sm17368152pgk.32.2021.05.26.09.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:50:50 -0700 (PDT)
Message-ID: <60ae7c6a.1c69fb81.10778.8eea@mx.google.com>
Date:   Wed, 26 May 2021 09:50:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.40
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 115 runs, 1 regressions (v5.10.40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 115 runs, 1 regressions (v5.10.40)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.40/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4068786a86905a7a358b9fe1327a480f08fb6a40 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae44788d90cdcbf3b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.40/a=
rm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.40/a=
rm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae44788d90cdcbf3b3a=
f9d
        new failure (last pass: v5.10.39) =

 =20
