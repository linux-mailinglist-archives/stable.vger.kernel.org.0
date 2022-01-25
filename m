Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E292849ABBC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 06:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392338AbiAYFVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 00:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391181AbiAYFDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:03:52 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFAFC0AD19D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:35:56 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id p37so18090949pfh.4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uzuMZkP3ZiSR3DR9GUmanZo50aToF4uBbVwrYzfL5bU=;
        b=YlDor98+G95439owTcU4bhTeMJhx0pyxXV6hNVvqp4fTV6UF5uoEBpB10X0KRx7gsp
         zF9TtJ8nOVpnrCUb7tVgvxojVpXpr+ebyNVAWHjenMI8tMIcRJu85PBIebH6vzr8+JYi
         POKxzST2xQ4Eg8ozs4qSUuIs4nHX7/gJxAr3kaOTr/F48wErOMHMN1oLevwQRxfCRoGR
         XUmWGeNIm0HKefMCbdA+BQzYqUzweEHyZknYu1Q/fFrBRZtUi51oKT4eU4lN322O9ZdO
         T/tFd0Ndnreyz8j9uROmMNlUpPfHhvIyBr0SMGr+s21ntC9QGykO5FP4LM0WZud1hgnl
         1POg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uzuMZkP3ZiSR3DR9GUmanZo50aToF4uBbVwrYzfL5bU=;
        b=39jhAOijO5otEPUV/cdeT5FUc3KEsDMX9C0L191fL/rxI1YLpq3UHBkb1yPQzc0QyO
         Gdx5dAduXEaZ6wxK3ke2zwLlSuY+ztgmBrvu8SrKjMKsPfXxNPbAY/tt9td7O8AF51sf
         SprMfZ2HACRZFMBm3VQsJoCwgmaro7RhlazNR9szG/993Y/NzAQ4xo1LNlCyXbKyj3Oq
         3dvItkCHZ+NMpoWgTnXcOXo9n8OLVu8VxF49ROrB31QoW6rptKAep2ccpoC7u6gtEgqx
         6XnJxYGcMFe4uMIPrz1czRk8SS1woLxhr2ij2naMuNkwRDrHhU4UNQ7yT/ys/PNK4xJV
         tCHw==
X-Gm-Message-State: AOAM531XO8o/TUMJ2TakbPGgI4IoWteOgczgxJKE4P0MaOavIMAsP4zi
        xNbo/a4xn2cMeE17zWp4us97Vf0mTIi2lvHM
X-Google-Smtp-Source: ABdhPJwQUSojC4nGVLZ+BA2vwVfCgzJMH+NaiUPk5jVw532MY54dWGox5YyS82q/U6t9shfuYcEyAA==
X-Received: by 2002:a63:d34b:: with SMTP id u11mr14129410pgi.510.1643081755876;
        Mon, 24 Jan 2022 19:35:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm7966550pgi.8.2022.01.24.19.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 19:35:55 -0800 (PST)
Message-ID: <61ef701b.1c69fb81.c0e7a.6476@mx.google.com>
Date:   Mon, 24 Jan 2022 19:35:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16-847-g86228f6e03f0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 91 runs,
 1 regressions (v5.15.16-847-g86228f6e03f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 91 runs, 1 regressions (v5.15.16-847-g8622=
8f6e03f0)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.16-847-g86228f6e03f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.16-847-g86228f6e03f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86228f6e03f08e9ee58a485c1af92da410e5197d =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ef37a976a821b292abbd3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-847-g86228f6e03f0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6-847-g86228f6e03f0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ef37a976a821b292abb=
d3c
        failing since 4 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first f=
ail: v5.15.16) =

 =20
