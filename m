Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08460407D16
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 13:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhILL5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbhILL5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 07:57:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF25C061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 04:56:01 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f21so1797298plb.4
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 04:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SstAgMxcg5G0P2WIM8C94/Jv0M5Nb1/0MWFj634XIvg=;
        b=Njsq1rMj69GXHkrPgH0W9ebulgz2tDv0aXiK96xkQeendLkOLcRzz9olqpW/dk3HUA
         z6gbXduVzbBCazcXjDWvIVbHiPdKcfmoEbgBqql9jGx+b5h/nw/5AF8sHX0ddjybE0C2
         7KNyR4BNDHCGTlw2pbhumd5xuSSsIDcGKUL2DzWIQqHSleRjJyq0PWE85f6lrYIhCJCt
         D9XyqvHW37lazZauRW7v0+ZlfOoI/K2n68LEYR/QdUgOuoNRa6mdsEFm0qR2xHFtZsWC
         3+llUExCsbudgegmjuNhbfj13IDo67GxxJsTveWCBVvTgInDDy0ZS/FMWF0Ap0JT07Sh
         OCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SstAgMxcg5G0P2WIM8C94/Jv0M5Nb1/0MWFj634XIvg=;
        b=KgS1c1s55ho3fa8ebk4M8lRQJs80DWSOxqn8jsDGg6uFZxDhhR331v7/yl1hQ7sIJr
         1Dzq+lJ+cdZhp7z/jFUYARL8UEG7V3oataA9Z0VEtK/S5bDGbut6mVBzCiYToZkhssCz
         HaM16QE4cqovtS5OsWpPLb5sm9PihBFUWlOlOWEmznzLzJp6PUWsaeO8et5NBtT/iYjS
         NGU3rF/kB8+H3HFA4/vtBt3VmR8FRftIlU66Le/pfTBxPGtcT8QIP/kDlVDdiAUWvCFV
         0ABk31GH4RSVxXm2TYMAacQSyaOWmEKJecBK5xDPsq6m0zOlIaZ8ExNej7+UTKwq6PMv
         mo4g==
X-Gm-Message-State: AOAM530I8R9GDYnqemcRCLb/XyaEl5c3AC3G3RHCup4rMo5i3H+LVOh1
        CAxabmpHn3A/hzlIVE7jQ9O4vayqHAwk0XSv
X-Google-Smtp-Source: ABdhPJyALga7KokkqJmjJv3zS4bEdrL/R4CkX+Lxq6Bh/NAw2wc1bxDvJ4OBd5SS5vTggzmZsTpRCA==
X-Received: by 2002:a17:90b:4f87:: with SMTP id qe7mr7359577pjb.48.1631447760815;
        Sun, 12 Sep 2021 04:56:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n26sm4061512pfq.44.2021.09.12.04.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 04:56:00 -0700 (PDT)
Message-ID: <613dead0.1c69fb81.7770e.a661@mx.google.com>
Date:   Sun, 12 Sep 2021 04:56:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.16
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
Subject: stable/linux-5.13.y baseline: 138 runs, 1 regressions (v5.13.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 138 runs, 1 regressions (v5.13.16)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.16/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a92a476e53c140e715287901aef73df9b5e1570b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/613db6e1c765d95ab9d5966f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.16/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.16/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613db6e1c765d95ab9d59=
670
        failing since 42 days (last pass: v5.13.6, first fail: v5.13.7) =

 =20
